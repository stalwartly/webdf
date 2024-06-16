#!/bin/bash

hostname=$(hostname)

# Start of the HTML file
echo "<html>
<head>
<title>Disk Usage on $(hostname)</title>
<style>
.progress-bar {
    width: 100%;
    background-color: #f3f3f3;
}
.progress-bar-fill {
    height: 20px;
    background-color: #007bff;
}
tr td:last-child {
    min-width: 75px;
}
</style>
</head>
<body>
<h1>Disk Usage on $(hostname)</h1>
<table border='1'>
<tr>
<th>Filesystem</th>
<th>Size</th>
<th>Used</th>
<th>Available</th>
<th>Use%</th>
<th>Mounted on</th>
<th>Usage</th>
</tr>" > disk_usage.html

# Run df, parse the output and add it to the HTML file
df -h | tail -n +2 | while read line; do
    filesystem=$(echo $line | awk '{print $1}')
    size=$(echo $line | awk '{print $2}')
    used=$(echo $line | awk '{print $3}')
    available=$(echo $line | awk '{print $4}')
    use_percent=$(echo $line | awk '{print $5}' | sed 's/%//')
    mounted_on=$(echo $line | awk '{print $6}')

    echo "<tr>
    <td>$filesystem</td>
    <td>$size</td>
    <td>$used</td>
    <td>$available</td>
    <td>$use_percent%</td>
    <td>$mounted_on</td>
    <td colspan='2'>
        <div class='progress-bar'>
            <div class='progress-bar-fill' style='width: $use_percent%;'></div>
        </div>
    </td>
    </tr>" >> disk_usage.html
done

# End of the HTML file
echo "</table>
</body>
<p>As at $(date)</p>
</html>" >> disk_usage.html