Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A8C47125D;
	Tue, 21 Jul 2026 18:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659206; cv=none; b=OoFSVE5YBoaY6IdTvr6qsvh7JRUedgCBdaLAwugmOrtP6d0EFE2FOAjOkx1Odsjx37s1UpS04pru0RnpOjIJuAdQ215aJYWZ8jUBApxBwGCcXokj8MRoqJjsNysw9VwiinFXFzlQyhiuwVX2R0lNvkm6TX1e174wSFnyAb6lYsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659206; c=relaxed/simple;
	bh=OGQYgHFvF+hYI3oPeBcwXJjQvUX7fXH77C6Xzm1uZ98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLa7uWlq9AHZt7xk9nz9MXlOXVrQPwZMQvN/XSInPylyZWjzcdCZINLc3g9iIWAyZvPUiy4RmgjvPqfh1xOQKUqwRUA/kmIvaHCVaJ3UvKUERib2nEexsuZTVyZcP9UNga6OosawtHKKJ3oTTITEV20f9yDgZlGi8kZblWaEH68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmUqgMMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmUqgMMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93541F000E9;
	Tue, 21 Jul 2026 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659205;
	bh=dr9JjCLg+591fdOTQj+7nt8kRgnDTqG+VPSCP8OASf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmUqgMMheDq8DsO7G9OLCOCRs0AnLxJYy/W0+pOWBi5m3n7bx/RfmtukcPc+Qp5wT
	 txlDs7uwFxIqIWhzvWDrShfla7K7mueCVb7bEYqqP9qEl72Uow8jy9VxBlNsKu9VIA
	 yhFDWaSUvpG5yR7DAbaM0BKpgBJ5fZcRJg5Rwye8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 1431/1611] hwmon: (w83627hf) remove VID sysfs files on error and remove
Date: Tue, 21 Jul 2026 17:25:47 +0200
Message-ID: <20260721152547.628552933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1823,6 +1823,8 @@ static int w83627hf_probe(struct platfor
 	return 0;
 
  error:
+	device_remove_file(dev, &dev_attr_vrm);
+	device_remove_file(dev, &dev_attr_cpu0_vid);
 	sysfs_remove_group(&dev->kobj, &w83627hf_group);
 	sysfs_remove_group(&dev->kobj, &w83627hf_group_opt);
 	return err;
@@ -1834,6 +1836,8 @@ static void w83627hf_remove(struct platf
 
 	hwmon_device_unregister(data->hwmon_dev);
 
+	device_remove_file(&pdev->dev, &dev_attr_vrm);
+	device_remove_file(&pdev->dev, &dev_attr_cpu0_vid);
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group);
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group_opt);
 }


