Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00D4207F;
	Wed,  6 Nov 2024 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896247; cv=none; b=JxxcnqW5XHytU6GXZycZOnGpcbSC/fbkzMb4MbVlGkfzndoJ4Vx3zBW/LQETElTLXacs0HrGzVt/4aqpeVWN8huan2cowMrpzt44Yppp6CKra3YFLpL+QGwXi6uRgNSwIIgNW7EAEJxp16at68pfFfRHK2z6wy+AOZQNyQZPA1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896247; c=relaxed/simple;
	bh=gTCireRxPQphKzdKqHf1iPFJJ8j9OpnxsfTbnofzX6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYvu0WTqmm78+EK/PH8G/BccSrlXNpiWo9VMc3vNKIT8/WxxCFQiH1ss21nW0v7EYy0n6MBaqtyBXOJp1lefIHMdcTKk3F4G19+lvUyoe+2X+3j3f1mihxuI5cdiZuERLI9DKVMEkyNx/Tnr1AqkaXC/1KbRIgFWlbi5vl1OA+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbhmFI23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbhmFI23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AE4C4CECD;
	Wed,  6 Nov 2024 12:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896247;
	bh=gTCireRxPQphKzdKqHf1iPFJJ8j9OpnxsfTbnofzX6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbhmFI23LB/HfNEE9nY9/wuAj4c9aMS5sdV3AEC9GyLczfGVsCT40cSmwbJnxX62W
	 EVlnI1PDOVKMHGlrwQ1O5JGJyp9mKGmDuPUkfTa23kthjD1oQKxTRCpnSfd8AdaZi4
	 dQZZ/boBE3Y9FKfgMjK8g2flSO8CyeRUcYM/66pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Gibbons <jamie.gibbons@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.11 139/245] firmware: microchip: auto-update: fix poll_complete() to not report spurious timeout errors
Date: Wed,  6 Nov 2024 13:03:12 +0100
Message-ID: <20241106120322.652137414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 83beece5aff75879bdfc6df8ba84ea88fd93050e upstream.

fw_upload's poll_complete() is really intended for use with
asynchronous write() implementations - or at least those where the
write() loop may terminate without the kernel yet being aware of whether
or not the firmware upload has succeeded. For auto-update, write() is
only ever called once and will only return when uploading has completed,
be that by passing or failing. The core fw_upload code only calls
poll_complete() after the final call to write() has returned.

However, the poll_complete() implementation in the auto-update driver
was written to expect poll_complete() to be called from another context,
and it waits for a completion signalled from write(). Since
poll_complete() is actually called from the same context, after the
write() loop has terminated, wait_for_completion() never sees the
completion get signalled and always times out, causing programming to
always report a failing.

Since write() is full synchronous, and its return value will indicate
whether or not programming passed or failed, poll_complete() serves no
purpose and can be cut down to simply return FW_UPLOAD_ERR_NONE.

Cc: stable@vger.kernel.org
Fixes: ec5b0f1193ad4 ("firmware: microchip: add PolarFire SoC Auto Update support")
Reported-by: Jamie Gibbons <jamie.gibbons@microchip.com>
Tested-by: Jamie Gibbons <jamie.gibbons@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/microchip/mpfs-auto-update.c |   42 ++++----------------------
 1 file changed, 7 insertions(+), 35 deletions(-)

--- a/drivers/firmware/microchip/mpfs-auto-update.c
+++ b/drivers/firmware/microchip/mpfs-auto-update.c
@@ -76,14 +76,11 @@
 #define AUTO_UPDATE_INFO_SIZE		SZ_1M
 #define AUTO_UPDATE_BITSTREAM_BASE	(AUTO_UPDATE_DIRECTORY_SIZE + AUTO_UPDATE_INFO_SIZE)
 
-#define AUTO_UPDATE_TIMEOUT_MS		60000
-
 struct mpfs_auto_update_priv {
 	struct mpfs_sys_controller *sys_controller;
 	struct device *dev;
 	struct mtd_info *flash;
 	struct fw_upload *fw_uploader;
-	struct completion programming_complete;
 	size_t size_per_bitstream;
 	bool cancel_request;
 };
@@ -156,19 +153,6 @@ static void mpfs_auto_update_cancel(stru
 
 static enum fw_upload_err mpfs_auto_update_poll_complete(struct fw_upload *fw_uploader)
 {
-	struct mpfs_auto_update_priv *priv = fw_uploader->dd_handle;
-	int ret;
-
-	/*
-	 * There is no meaningful way to get the status of the programming while
-	 * it is in progress, so attempting anything other than waiting for it
-	 * to complete would be misplaced.
-	 */
-	ret = wait_for_completion_timeout(&priv->programming_complete,
-					  msecs_to_jiffies(AUTO_UPDATE_TIMEOUT_MS));
-	if (!ret)
-		return FW_UPLOAD_ERR_TIMEOUT;
-
 	return FW_UPLOAD_ERR_NONE;
 }
 
@@ -349,33 +333,23 @@ static enum fw_upload_err mpfs_auto_upda
 						 u32 offset, u32 size, u32 *written)
 {
 	struct mpfs_auto_update_priv *priv = fw_uploader->dd_handle;
-	enum fw_upload_err err = FW_UPLOAD_ERR_NONE;
 	int ret;
 
-	reinit_completion(&priv->programming_complete);
-
 	ret = mpfs_auto_update_write_bitstream(fw_uploader, data, offset, size, written);
-	if (ret) {
-		err = FW_UPLOAD_ERR_RW_ERROR;
-		goto out;
-	}
+	if (ret)
+		return FW_UPLOAD_ERR_RW_ERROR;
 
-	if (priv->cancel_request) {
-		err = FW_UPLOAD_ERR_CANCELED;
-		goto out;
-	}
+	if (priv->cancel_request)
+		return FW_UPLOAD_ERR_CANCELED;
 
 	if (mpfs_auto_update_is_bitstream_info(data, size))
-		goto out;
+		return FW_UPLOAD_ERR_NONE;
 
 	ret = mpfs_auto_update_verify_image(fw_uploader);
 	if (ret)
-		err = FW_UPLOAD_ERR_FW_INVALID;
+		return FW_UPLOAD_ERR_FW_INVALID;
 
-out:
-	complete(&priv->programming_complete);
-
-	return err;
+	return FW_UPLOAD_ERR_NONE;
 }
 
 static const struct fw_upload_ops mpfs_auto_update_ops = {
@@ -461,8 +435,6 @@ static int mpfs_auto_update_probe(struct
 		return dev_err_probe(dev, ret,
 				     "The current bitstream does not support auto-update\n");
 
-	init_completion(&priv->programming_complete);
-
 	fw_uploader = firmware_upload_register(THIS_MODULE, dev, "mpfs-auto-update",
 					       &mpfs_auto_update_ops, priv);
 	if (IS_ERR(fw_uploader))


