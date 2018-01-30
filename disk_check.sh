#!/bin/bash
partition_list=(`df -h | awk 'NF>3&&NR>1{sub(/%/,"",$(NF-1));print $NF,$(NF-1)}'`)
critical=90
notification_email()
{
    emailuser='zhakuo@126.com'
    emailpasswd='zhakuo126com'
    emailsmtp='smtp.126.com'
    sendto='tudor@viistep.com'
    title='Disk Space Alarm'
    /opt/sendEmail-v1.56/sendEmail -f $emailuser -t $sendto -s $emailsmtp -u $title -xu $emailuser -xp $emailpasswd
}
crit_info=""
for (( i=0;i<${#partition_list[@]};i+=2 ))
do
    if [ "${partition_list[((i+1))]}" -lt "$critical" ];then
        echo "OK! ${partition_list[i]} used ${partition_list[((i+1))]}%"
    else
            if [ "${partition_list[((i+1))]}" -gt "$critical" ];then
                crit_info=$crit_info"138.68.16.158\n Warning!!!\n  ${partition_list[i]} used ${partition_list[((i+1))]}%\n"
            fi
    fi
done
if [ "$crit_info" != "" ];then
    echo -e $crit_info | notification_email
fi
