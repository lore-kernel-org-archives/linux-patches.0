Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B2424D75;
	Thu, 16 Jul 2026 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212100; cv=none; b=jrkb277v5/sbJRbSCPuNlMOVoZbFuht0TLPDTqqU3mPtWqn+YpAV4QrkhLg9ZyAo8Jus3EwEWbgZGwZTcKvBpRqIr3KzjPeKVcrnIZY3aD0Y3Jm0/qbfa5lgvHgDaOqZnVBIVMf+3T3fp3rJfUzNixzFAMGv7mnyrMFEk2rwqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212100; c=relaxed/simple;
	bh=3BTpaSILyIfUYiMFPzcn0oFRQV/idQnKiREY1T9anIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ha2H52QWj742UJf9dHCT32x52MrSwdVsGWpCf9+dvdpIlK0LBvQWpROE7U1JrM1KpCSjykjZQtJXUzToHOSeQ6qlI3Ki/RICXGPokdzJj7e6+Lq3SaZGlOnpHDJ1WZ2DHGYfXy7S1ZJS+/HASi4P1KfVWom5HBOS0UKZ3EVcGoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgWv6a9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgWv6a9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAAE1F00A3A;
	Thu, 16 Jul 2026 14:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212091;
	bh=NpXe5BA5UjFCi2etONYXkOWGyrNIfpolFX/D+M4hRFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgWv6a9plo5Y0GfmMV7Xx4wKj+VLsmjSrl/qAR/s/7u4l3PUANQwPfB0ys8eqIaVl
	 9yj/kItr2h+xfjEBl7dU/HSL14st4GLZWARAila46q38KC/wm32c14/s4aAjSwN5Y0
	 jMHi2lkkcSUDiqdQMVHX4XASFY5pWDwriOyQEyow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 189/349] firmware_loader: fix device reference leak in firmware_upload_register()
Date: Thu, 16 Jul 2026 15:32:03 +0200
Message-ID: <20260716133037.607524994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -341,7 +341,6 @@ firmware_upload_register(struct module *
 		goto free_fw_upload_priv;
 	}
 	fw_upload->priv = fw_sysfs;
-	fw_sysfs->fw_upload_priv = fw_upload_priv;
 	fw_dev = &fw_sysfs->dev;
 
 	ret = alloc_lookup_fw_priv(name, &fw_cache, &fw_priv,  NULL, 0, 0,
@@ -349,10 +348,12 @@ firmware_upload_register(struct module *
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
@@ -363,9 +364,6 @@ firmware_upload_register(struct module *
 
 	return fw_upload;
 
-free_fw_sysfs:
-	kfree(fw_sysfs);
-
 free_fw_upload_priv:
 	kfree(fw_upload_priv);
 


