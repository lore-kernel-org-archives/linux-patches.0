Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1259E43D503;
	Tue, 21 Jul 2026 22:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674489; cv=none; b=PVYIYvyzuWaAOBizVbZYunY8DZ5iEzJrgLk/ROCx4oPqcmVWnsYMQN0NIjqCN8k2TwrWqG4JsCvpoZgI6nATuuIFnYdKJAJd2dHFtRYT0xsO/IGNqiIQoYoSXJG/p7ChLZHre508RdHqiPuilKcCyUXqop6r2VlGF0k16I/zel0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674489; c=relaxed/simple;
	bh=w0QlzIe0nBB5VBzg3V4fLCROsreXxh8XJOh4iYY+L6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjJrJh0OwFNu6nuL+3mL3YBmhR228p73X4bAJC/IVF95JQN2zCN6bfOsDJg6Ah4DGHcX573KuVJs27gBLWENpYUnQr1n/OR+Y0i0kDFuoSk0R7D4sdQOHT+zxbsMnqpsRxpWCmF/wLtjQHADpWrx+Qll+6AfEFa0P0Kp+eH8ucI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVJ+JHko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVJ+JHko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC4E1F000E9;
	Tue, 21 Jul 2026 22:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674487;
	bh=WCWtTUvdnbgBorrO7Y6UIJlocGgUadmKigNvMPYtSnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVJ+JHkomUdA0LtxJwa8F+KElu46MfeqRfw3acgZwd2LofFKYAEv6cwhgvGsJ8c1J
	 wTcy5w5lOAhONbrZOT69wq9xSB82pbDsI3KNEf6noE/a4LBjhUS5XtBm/aS05XuKzl
	 xuMcOC3lR6ya3PqOxSZjmlY/kXDZE7+XXGmWivGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 543/699] hwmon: (w83627hf) remove VID sysfs files on error and remove
Date: Tue, 21 Jul 2026 17:25:02 +0200
Message-ID: <20260721152407.952996332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 5264b389c4e02dec214a46c400eb3ab867a7749a upstream.

w83627hf_probe() creates cpu0_vid and vrm with device_create_file() when
VID information is available.

The error path and remove callback only remove the common and optional
attribute groups.  Those groups do not contain cpu0_vid or vrm, so the
files can remain after a later probe failure or after device removal
while their callbacks still expect live driver data.

Remove the standalone VID sysfs files from both the probe error path and
the remove callback.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20260615064732.48113-1-pengpeng@iscas.ac.cn
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83627hf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -1551,6 +1551,8 @@ static int w83627hf_probe(struct platfor
 	return 0;
 
  error:
+	device_remove_file(dev, &dev_attr_vrm);
+	device_remove_file(dev, &dev_attr_cpu0_vid);
 	sysfs_remove_group(&dev->kobj, &w83627hf_group);
 	sysfs_remove_group(&dev->kobj, &w83627hf_group_opt);
 	return err;
@@ -1562,6 +1564,8 @@ static int w83627hf_remove(struct platfo
 
 	hwmon_device_unregister(data->hwmon_dev);
 
+	device_remove_file(&pdev->dev, &dev_attr_vrm);
+	device_remove_file(&pdev->dev, &dev_attr_cpu0_vid);
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group);
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group_opt);
 


