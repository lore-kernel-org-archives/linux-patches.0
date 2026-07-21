Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A41635C697;
	Tue, 21 Jul 2026 21:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668408; cv=none; b=E2+MCznRLVKr3GwNyiaY/tE4sLsIa4Jla57q3FW9byMabRIwWcunlR9BQu3bEcZSPm9XK12F1xe4hi6ERa+ASvEwvZ9zNnvL8RupQZVRw19Q672v6MFQUG0ZrosFv+lKyrpppZK73eWlAHdl9a+4tONT2inVCGIHCZF6/f8i5F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668408; c=relaxed/simple;
	bh=NX1XTASJ+/EQmvZB/PFyUZ78+mpN6J1MsLEH9G7//Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/ipuJj3JwQMze22ZKswT6JDt2GEePoFMU+ovHLdkeHbAHgN8nM8iNxaOL2xksXhzPwKnZkYzpbTmgzQITb4kaaJtbrUsT41IRx8YRWC/hAcBnv2r7+Zxrp7dTp607qffVdAR1dAJr7dufWjszonAgs4vT9d5LlgUlvTE0eHNTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYMRCC3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYMRCC3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A044D1F00A3A;
	Tue, 21 Jul 2026 21:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668407;
	bh=NPyEcmJS/vsFG8N25YeW91Eu9+XPOz52jaQHiahVH0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYMRCC3WvAJO3UgMl1KZuywqC2QMS6KQ0VN1gNIr9BDqjmIDdW2o/lCLR2YIk3S+S
	 s2M54WmB+6YEvGzZ5pHxTlOt56ZzKKJuNk21Z8lcIx6Me1CL5dBY5gtsaKQurXKyK/
	 ey5ZsP3S5HPQGqcCFJcO6pm0Ro7dqqP+IbmDOj14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 0147/1067] firmware_loader: fix device reference leak in firmware_upload_register()
Date: Tue, 21 Jul 2026 17:12:28 +0200
Message-ID: <20260721152427.884125888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 896df22ee57648b0c505bd76ddbc6b2341834696 upstream.

firmware_upload_register()
  -> fw_create_instance()
     -> device_initialize()

After fw_create_instance() succeeds, the lifetime of the embedded struct
device is expected to be managed through the device core reference
counting, since fw_create_instance() has already called
device_initialize().

In firmware_upload_register(), if alloc_lookup_fw_priv() fails after
fw_create_instance() succeeds, the code reaches free_fw_sysfs and frees
fw_sysfs directly instead of releasing the device reference with
put_device(). This may leave the reference count of the embedded struct
device unbalanced, resulting in a refcount leak.

The issue was identified by a static analysis tool I developed and
confirmed by manual review. Fix this by using put_device(fw_dev) in the
failure path and letting fw_dev_release() handle the final cleanup,
instead of freeing the instance directly from the error path.

Fixes: 97730bbb242c ("firmware_loader: Add firmware-upload support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260505091231.607089-1-lgs201920130244@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/sysfs_upload.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -340,7 +340,6 @@ firmware_upload_register(struct module *
 		goto free_fw_upload_priv;
 	}
 	fw_upload->priv = fw_sysfs;
-	fw_sysfs->fw_upload_priv = fw_upload_priv;
 	fw_dev = &fw_sysfs->dev;
 
 	ret = alloc_lookup_fw_priv(name, &fw_cache, &fw_priv,  NULL, 0, 0,
@@ -348,10 +347,12 @@ firmware_upload_register(struct module *
 	if (ret != 0) {
 		if (ret > 0)
 			ret = -EINVAL;
-		goto free_fw_sysfs;
+		put_device(fw_dev);
+		goto free_fw_upload_priv;
 	}
 	fw_priv->is_paged_buf = true;
 	fw_sysfs->fw_priv = fw_priv;
+	fw_sysfs->fw_upload_priv = fw_upload_priv;
 
 	ret = device_add(fw_dev);
 	if (ret) {
@@ -362,9 +363,6 @@ firmware_upload_register(struct module *
 
 	return fw_upload;
 
-free_fw_sysfs:
-	kfree(fw_sysfs);
-
 free_fw_upload_priv:
 	kfree(fw_upload_priv);
 


