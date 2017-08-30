#!/bin/bash


# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script!"
    exit 1
fi

hosts_file='/etc/hosts'
local_end='###local_end###'
tmp_file='/tmp/tmp_hosts'
echo "Start execute"

if [ -f "$tmp_file" ]; then
	rm -rf $tmp_file
fi
line=`sed -n "/^${local_end}$/=" ${hosts_file}`
if [ ! $line ]; then
	echo "not found '${local_end}'"
	exit 1
fi
sed -n "1,${line}p" $hosts_file > $tmp_file
echo "\n" >> $tmp_file
curl https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts 2>/dev/null >> $tmp_file
cat $tmp_file > $hosts_file
rm -rf $tmp_file
echo "End execute"
