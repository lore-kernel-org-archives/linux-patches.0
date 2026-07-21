Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528DC3E49EF;
	Tue, 21 Jul 2026 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655075; cv=none; b=e0Z0OL7b99Fqh4UxZwncANbndUChihTvOcsCSAdWzawV0fhNsVT0O48c0D1XcNcPdyNyQVgKXWee3UikC3Oh7YpaCPn3YgLDPPjxrxSHL02/GRHLzQBKQMRIfvYceR28cuymEa4GQLIJG8WfErW7/zZs28d7cxwaQBJT5W/b5N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655075; c=relaxed/simple;
	bh=YmO437KDBaMN+fMFiEtaP96AXHkNTSJdIYGZ/KuajTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ls93ZfmxOpmWdCe+8qOrfBKEPE9uF0dQlcI+BK39XJDd9gmUx+rG74FLURwHjj2ZFWSMvZcYBuaWiMsKy1O0cCh3ZklpQsoLqjC2bOu+2XQE6bX4T9J8EQtLhij0bI+Q/4PVeOGPpFZDMhe2O70wH1zqEv6jh4qfiYn5Qwodb/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ljFrgZiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljFrgZiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4041F000E9;
	Tue, 21 Jul 2026 17:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655074;
	bh=wTczjhaCfvbHuUFAmJKifRFgMokLDhZI12og3aea+z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ljFrgZiWkyeSdGl+KqQGA7ip+YEXvwJgJyj76pD5caqytSmw+Zo2aJW7oR6eEbymT
	 Oz2rtTKhbkSN5cDbZZviiUwmCGdjsdUowKu4c+k1vNrlCCk0nA6X/TNCe4cREKFHOg
	 HPaKTvGqfV8Y8O8FYgzhvUAB8RvezT/Xv3WTFbG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 1947/2077] hwmon: (w83627hf) remove VID sysfs files on error and remove
Date: Tue, 21 Jul 2026 17:27:00 +0200
Message-ID: <20260721152638.633458290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


