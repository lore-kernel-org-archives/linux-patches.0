Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439E824EF8C;
	Mon, 29 Dec 2025 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025676; cv=none; b=jLdAgCMHvE4IdEsuMfm2DbLKVKoP1Yrw4YHKL2ENuBt9caHxslPhKZIILVf5jLJJrtMboePREa2holKm6S2sFiw+d7IJJlIj8PHlIniJG9IQLAbWfkWEh0ig67dSPRbv39xEnG+mLaVCxl8mR3uMcqh9wr3RBr6jCdmfNAPf0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025676; c=relaxed/simple;
	bh=JksyVe/Lp9Rgm6TY0E16sOsx1BAyin/Dcjwhp/Q8RNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7esCcR9WPCqOtK+bwnz95MNPh0XtGJI3NrTH2d9Jqd/FePtmcX0MqPSjEap56cjqboiX5FqJzUB4mJkUYXS5mHOdBegy5A4FUid8KUyZYbEtLca51YpWG50Y6lGVQIUsDVL0ht/C4EYLKOmFoDtcyiOo7WLvV6UWg7lcvOG0Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWPOUnPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWPOUnPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85261C4CEF7;
	Mon, 29 Dec 2025 16:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025675;
	bh=JksyVe/Lp9Rgm6TY0E16sOsx1BAyin/Dcjwhp/Q8RNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWPOUnPkLnsRc3fnF8j2kMp2Zfo5uclM51CKxmPSSPZm21mkZdw3trmNCrEzjFmcx
	 D11iLRALcM2eQJHxmmT2+sdvGkGlEF9cLa9IKyAZXvkrD4iHX6ZG6WQqZMBOZkQjWd
	 2yIQGHvWUNJMcMXEgkjgnYjVvjeBcLy9m7RzhAfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>
Subject: [PATCH 6.18 297/430] intel_th: Fix error handling in intel_th_output_open
Date: Mon, 29 Dec 2025 17:11:39 +0100
Message-ID: <20251229160735.268505900@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit 6d5925b667e4ed9e77c8278cc215191d29454a3f upstream.

intel_th_output_open() calls bus_find_device_by_devt() which
internally increments the device reference count via get_device(), but
this reference is not properly released in several error paths. When
device driver is unavailable, file operations cannot be obtained, or
the driver's open method fails, the function returns without calling
put_device(), leading to a permanent device reference count leak. This
prevents the device from being properly released and could cause
resource exhaustion over time.

Found by code review.

Cc: stable <stable@kernel.org>
Fixes: 39f4034693b7 ("intel_th: Add driver infrastructure for Intel(R) Trace Hub devices")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20251112091723.35963-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/core.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -810,13 +810,17 @@ static int intel_th_output_open(struct i
 	int err;
 
 	dev = bus_find_device_by_devt(&intel_th_bus, inode->i_rdev);
-	if (!dev || !dev->driver)
-		return -ENODEV;
+	if (!dev || !dev->driver) {
+		err = -ENODEV;
+		goto out_no_device;
+	}
 
 	thdrv = to_intel_th_driver(dev->driver);
 	fops = fops_get(thdrv->fops);
-	if (!fops)
-		return -ENODEV;
+	if (!fops) {
+		err = -ENODEV;
+		goto out_put_device;
+	}
 
 	replace_fops(file, fops);
 
@@ -824,10 +828,16 @@ static int intel_th_output_open(struct i
 
 	if (file->f_op->open) {
 		err = file->f_op->open(inode, file);
-		return err;
+		if (err)
+			goto out_put_device;
 	}
 
 	return 0;
+
+out_put_device:
+	put_device(dev);
+out_no_device:
+	return err;
 }
 
 static const struct file_operations intel_th_output_fops = {


