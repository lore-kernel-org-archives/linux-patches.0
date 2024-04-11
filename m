Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124631422C4;
	Thu, 11 Apr 2024 10:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829750; cv=none; b=P6gt24R+dQcVgz++LcyVPqIS+zZULUYWxTk40t+VIvBfSemtKfM7BHJ8WCiejMK0TZEIMWTYR1mwVgOpKjed3lF/96wHjLKRP9OeKLRZf16tAw578Q3iEOEmLMHpJBEQz4OUR5FsLts9og3L3wYugZpYUNk44AcLYAAsWDBC/50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829750; c=relaxed/simple;
	bh=+oeTTC3ALWwMkt2MKi9kwo2aMtZxtlLh59KrYjM7l/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYk180LkzMzm1ZivOJB3sIbs/LhZ4oJ+VMd8eCzt1MMggqEfQ6FQbmmjs83QHAueJJytV1stwmcW5I3500Z6iBeF9P/se/IE//Al6QtLSlXIGcRZ1q8JG1INkrusKElqVtOevfL8KTa+0RBLgbgcolu8gmOfR1I2JbfQOwOxaZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LceuyRTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LceuyRTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C00C433C7;
	Thu, 11 Apr 2024 10:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829749;
	bh=+oeTTC3ALWwMkt2MKi9kwo2aMtZxtlLh59KrYjM7l/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LceuyRToM23y0KWPiX2zO/cXoYY9v7Z53uc8HOpx9dWH+mZ14o5gyWx7nVqz+p3LA
	 5BFTxc+GPfyNyY244cTqnA8zm0lu492Mwc/4XLi2iVlPL4GC+RMKwJ3DlhrP48Ih50
	 BlHTvWVb5XRknkA8mWFiT1iQgN1Xj6fAJaNMBFps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 4.19 093/175] loop: Refactor loop_set_status() size calculation
Date: Thu, 11 Apr 2024 11:55:16 +0200
Message-ID: <20240411095422.366009816@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martijn Coenen <maco@android.com>

[ Upstream commit b0bd158dd630bd47640e0e418c062cda1e0da5ad ]

figure_loop_size() calculates the loop size based on the passed in
parameters, but at the same time it updates the offset and sizelimit
parameters in the loop device configuration. That is a somewhat
unexpected side effect of a function with this name, and it is only only
needed by one of the two callers of this function - loop_set_status().

Move the lo_offset and lo_sizelimit assignment back into loop_set_status(),
and use the newly factored out functions to validate and apply the newly
calculated size. This allows us to get rid of figure_loop_size() in a
follow-up commit.

Signed-off-by: Martijn Coenen <maco@android.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -248,11 +248,6 @@ figure_loop_size(struct loop_device *lo,
 {
 	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
 
-	if (lo->lo_offset != offset)
-		lo->lo_offset = offset;
-	if (lo->lo_sizelimit != sizelimit)
-		lo->lo_sizelimit = sizelimit;
-
 	loop_set_size(lo, size);
 }
 
@@ -1225,6 +1220,7 @@ loop_set_status(struct loop_device *lo,
 	kuid_t uid = current_uid();
 	struct block_device *bdev;
 	bool partscan = false;
+	bool size_changed = false;
 
 	err = mutex_lock_killable(&loop_ctl_mutex);
 	if (err)
@@ -1246,6 +1242,7 @@ loop_set_status(struct loop_device *lo,
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
+		size_changed = true;
 		sync_blockdev(lo->lo_device);
 		invalidate_bdev(lo->lo_device);
 	}
@@ -1253,6 +1250,15 @@ loop_set_status(struct loop_device *lo,
 	/* I/O need to be drained during transfer transition */
 	blk_mq_freeze_queue(lo->lo_queue);
 
+	if (size_changed && lo->lo_device->bd_inode->i_mapping->nrpages) {
+		/* If any pages were dirtied after invalidate_bdev(), try again */
+		err = -EAGAIN;
+		pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
+			__func__, lo->lo_number, lo->lo_file_name,
+			lo->lo_device->bd_inode->i_mapping->nrpages);
+		goto out_unfreeze;
+	}
+
 	err = loop_release_xfer(lo);
 	if (err)
 		goto out_unfreeze;
@@ -1276,19 +1282,8 @@ loop_set_status(struct loop_device *lo,
 	if (err)
 		goto out_unfreeze;
 
-	if (lo->lo_offset != info->lo_offset ||
-	    lo->lo_sizelimit != info->lo_sizelimit) {
-		/* kill_bdev should have truncated all the pages */
-		if (lo->lo_device->bd_inode->i_mapping->nrpages) {
-			err = -EAGAIN;
-			pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
-				__func__, lo->lo_number, lo->lo_file_name,
-				lo->lo_device->bd_inode->i_mapping->nrpages);
-			goto out_unfreeze;
-		}
-		figure_loop_size(lo, info->lo_offset, info->lo_sizelimit);
-	}
-
+	lo->lo_offset = info->lo_offset;
+	lo->lo_sizelimit = info->lo_sizelimit;
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
@@ -1312,6 +1307,12 @@ loop_set_status(struct loop_device *lo,
 		lo->lo_key_owner = uid;
 	}
 
+	if (size_changed) {
+		loff_t new_size = get_size(lo->lo_offset, lo->lo_sizelimit,
+					   lo->lo_backing_file);
+		loop_set_size(lo, new_size);
+	}
+
 	loop_config_discard(lo);
 
 	/* update dio if lo_offset or transfer is changed */


