Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C6143F4CE;
	Tue, 21 Jul 2026 20:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667550; cv=none; b=TYLbzyREfbVeEg2wHPyEELJfFWyITJ6sUbpJ76kemEpsE+OGxM8WUZrb0JIXSkoSIHYcbSD5wPu+XsRnRaq5HSvy7rrQEIZtg/a5OI/l6X6OIXwmNxt43ncV0C4GAGKP4UCMAjwlpUW49usXalkJatA5B98F9ShMGYQtdKvVVhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667550; c=relaxed/simple;
	bh=sONuebx8tfWFs3RMgQjZyLpu+Wbd3e40FAX4cdaXrns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr77mHUzSA7l4ZuUJsA1PLSY87Uazjj7zgUZdrh4vScXMHtCJH2EaE2TeWzksMyNaCDHjzb8UBqH23s/E5GMRFhaiHLq2AAnw3JoycgOJ2WRZMcXaB13PBwiE5oT8U2+dYRcsa+vwzljHly+EGnYKfFx+4hPxZjQuq08Uo5HqsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b93TNEwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b93TNEwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424D91F00A3D;
	Tue, 21 Jul 2026 20:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667548;
	bh=2pdfxwR54iF+ARZK+JF9AjVLA8BHskxaupJRsu0kTCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b93TNEwk13Pfnzk17skNw2BV1RYeLZhYXR8YVJvZl+UxzcCsMOfa5nDoLBOrCntdi
	 Tee/TyjlVCyQEFFh3sdMwqrQHLw1jnReGw/y5hIuPoHsoJnfXltqCNsTybWftQAh9g
	 5IaPWF+tEsERzduMWdMBEQ3o9GKOg7rUJqB/u36Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 1101/1266] hwmon: (w83627hf) remove VID sysfs files on error and remove
Date: Tue, 21 Jul 2026 17:25:38 +0200
Message-ID: <20260721152506.439494667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1834,6 +1836,8 @@ static int w83627hf_remove(struct platfo
 
 	hwmon_device_unregister(data->hwmon_dev);
 
+	device_remove_file(&pdev->dev, &dev_attr_vrm);
+	device_remove_file(&pdev->dev, &dev_attr_cpu0_vid);
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group);
 	sysfs_remove_group(&pdev->dev.kobj, &w83627hf_group_opt);
 


