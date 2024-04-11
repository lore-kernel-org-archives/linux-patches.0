Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AE4140E3D;
	Thu, 11 Apr 2024 10:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830748; cv=none; b=HwdlYLiAciY1abCWwQTsUw9InreQJ2PgfSMfKA4w3/bKBnlXAD08mdjyKEIq+1v0xrbHyZ1XXsTsAVw0ELLMOEqKV5h6UhZpYbZfnXTltc0FoBvx4QX9VNEfi1nfxI2vpX5JPI2spJPRTvjXYLk5xEBZVALqKhx/aeO4Of9TMvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830748; c=relaxed/simple;
	bh=aCm8vlfm8Q4BfvMgszpYtKzYPeZof52XI8PMueq0wb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLvzF6Dku0DWo6S8ahMsideFSCJBpSE805bRap9Gj1TPfmsSsiz8nZJijCvAOrbwKInX4SMKqC8TrsGLfS0jqLAgtZ+iUUjBdrPgeXprxWGmTnnWaVTo4MGmU0DoNIOmyqYHgH+RPc+3pWtYnppLF7D24Xb1GuBFuthKASknQow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqBW1V/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqBW1V/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68419C433C7;
	Thu, 11 Apr 2024 10:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830747;
	bh=aCm8vlfm8Q4BfvMgszpYtKzYPeZof52XI8PMueq0wb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqBW1V/xH/lCGoNbSYz0NcqYhrs3NfYg8yjPvopot03WJnOsYxrzYEzTK5p07ajXe
	 8BZflj0EzZgPz7heAprY13y5hTo72LxW/G6s7KRpsuWeDaZErHMUfT6OwLLC7i7RXm
	 meCftIYzxjMe0Nl/IqsKmXG5oE6dyk40RyGqJKyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 5.4 103/215] loop: Factor out configuring loop from status
Date: Thu, 11 Apr 2024 11:55:12 +0200
Message-ID: <20240411095428.007599584@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martijn Coenen <maco@android.com>

[ Upstream commit 0c3796c244598122a5d59d56f30d19390096817f ]

Factor out this code into a separate function, so it can be reused by
other code more easily.

Signed-off-by: Martijn Coenen <maco@android.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |  117 +++++++++++++++++++++++++++++----------------------
 1 file changed, 67 insertions(+), 50 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1258,75 +1258,43 @@ static int loop_clr_fd(struct loop_devic
 	return __loop_clr_fd(lo, false);
 }
 
+/**
+ * loop_set_status_from_info - configure device from loop_info
+ * @lo: struct loop_device to configure
+ * @info: struct loop_info64 to configure the device with
+ *
+ * Configures the loop device parameters according to the passed
+ * in loop_info64 configuration.
+ */
 static int
-loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
+loop_set_status_from_info(struct loop_device *lo,
+			  const struct loop_info64 *info)
 {
 	int err;
 	struct loop_func_table *xfer;
 	kuid_t uid = current_uid();
-	struct block_device *bdev;
-	bool partscan = false;
-	bool size_changed = false;
 
-	err = mutex_lock_killable(&loop_ctl_mutex);
-	if (err)
-		return err;
-	if (lo->lo_encrypt_key_size &&
-	    !uid_eq(lo->lo_key_owner, uid) &&
-	    !capable(CAP_SYS_ADMIN)) {
-		err = -EPERM;
-		goto out_unlock;
-	}
-	if (lo->lo_state != Lo_bound) {
-		err = -ENXIO;
-		goto out_unlock;
-	}
-	if ((unsigned int) info->lo_encrypt_key_size > LO_KEY_SIZE) {
-		err = -EINVAL;
-		goto out_unlock;
-	}
-
-	if (lo->lo_offset != info->lo_offset ||
-	    lo->lo_sizelimit != info->lo_sizelimit) {
-		size_changed = true;
-		sync_blockdev(lo->lo_device);
-		invalidate_bdev(lo->lo_device);
-	}
-
-	/* I/O need to be drained during transfer transition */
-	blk_mq_freeze_queue(lo->lo_queue);
-
-	if (size_changed && lo->lo_device->bd_inode->i_mapping->nrpages) {
-		/* If any pages were dirtied after invalidate_bdev(), try again */
-		err = -EAGAIN;
-		pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
-			__func__, lo->lo_number, lo->lo_file_name,
-			lo->lo_device->bd_inode->i_mapping->nrpages);
-		goto out_unfreeze;
-	}
+	if ((unsigned int) info->lo_encrypt_key_size > LO_KEY_SIZE)
+		return -EINVAL;
 
 	err = loop_release_xfer(lo);
 	if (err)
-		goto out_unfreeze;
+		return err;
 
 	if (info->lo_encrypt_type) {
 		unsigned int type = info->lo_encrypt_type;
 
-		if (type >= MAX_LO_CRYPT) {
-			err = -EINVAL;
-			goto out_unfreeze;
-		}
+		if (type >= MAX_LO_CRYPT)
+			return -EINVAL;
 		xfer = xfer_funcs[type];
-		if (xfer == NULL) {
-			err = -EINVAL;
-			goto out_unfreeze;
-		}
+		if (xfer == NULL)
+			return -EINVAL;
 	} else
 		xfer = NULL;
 
 	err = loop_init_xfer(lo, xfer, info);
 	if (err)
-		goto out_unfreeze;
+		return err;
 
 	lo->lo_offset = info->lo_offset;
 	lo->lo_sizelimit = info->lo_sizelimit;
@@ -1353,6 +1321,55 @@ loop_set_status(struct loop_device *lo,
 		lo->lo_key_owner = uid;
 	}
 
+	return 0;
+}
+
+static int
+loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
+{
+	int err;
+	struct block_device *bdev;
+	kuid_t uid = current_uid();
+	bool partscan = false;
+	bool size_changed = false;
+
+	err = mutex_lock_killable(&loop_ctl_mutex);
+	if (err)
+		return err;
+	if (lo->lo_encrypt_key_size &&
+	    !uid_eq(lo->lo_key_owner, uid) &&
+	    !capable(CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out_unlock;
+	}
+	if (lo->lo_state != Lo_bound) {
+		err = -ENXIO;
+		goto out_unlock;
+	}
+
+	if (lo->lo_offset != info->lo_offset ||
+	    lo->lo_sizelimit != info->lo_sizelimit) {
+		size_changed = true;
+		sync_blockdev(lo->lo_device);
+		invalidate_bdev(lo->lo_device);
+	}
+
+	/* I/O need to be drained during transfer transition */
+	blk_mq_freeze_queue(lo->lo_queue);
+
+	if (size_changed && lo->lo_device->bd_inode->i_mapping->nrpages) {
+		/* If any pages were dirtied after invalidate_bdev(), try again */
+		err = -EAGAIN;
+		pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
+			__func__, lo->lo_number, lo->lo_file_name,
+			lo->lo_device->bd_inode->i_mapping->nrpages);
+		goto out_unfreeze;
+	}
+
+	err = loop_set_status_from_info(lo, info);
+	if (err)
+		goto out_unfreeze;
+
 	if (size_changed) {
 		loff_t new_size = get_size(lo->lo_offset, lo->lo_sizelimit,
 					   lo->lo_backing_file);


