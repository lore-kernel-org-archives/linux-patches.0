Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9D3298C08;
	Mon, 12 May 2025 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073063; cv=none; b=NSljKY8puRCiaNav2ZTknk6quxRrCZM6cJ/KhfgTXsuXiZZPR0ud/Cl9KpmZrgz6ZM89/HTgsq22bx3hMYFTIS1TMXYJvFo5oFUGKNGaA1ayaOcmF5z0w798ypy2KpFsfD5nHE0rtXbL3ZtRd7aHwWg+aFkENXa9P15NhYVox6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073063; c=relaxed/simple;
	bh=6a03zXtMy4boFhfqEdcRZG6oi7lKxCf+Yj8MfuGWzP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhRSoueONaNsNmyqeRDarjrO4yMQfXnWrs0VML1mDXierykM/PlEIFwjUva+/B1Hmbp91+9eom1uAW5NPcZ+hGQ61Ta5Wp8aY7VEHh3in2V6iakEr/iQcWvYryx3pZHejD/izxecWmiegmljS4EqirYg8qe8msazszVgM8G3OQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=galSuCJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="galSuCJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD1CC4CEE9;
	Mon, 12 May 2025 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073063;
	bh=6a03zXtMy4boFhfqEdcRZG6oi7lKxCf+Yj8MfuGWzP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=galSuCJ8D16eBEp5ZAuBfwJ3Oanjk2sf6wfMWm/jsP9l4XEAc6PW+kNrCyZyrwpFW
	 T0C0XfRWLlaYgEr4Pg2YjKRcZzIfUW0IdLpSK+1Wp1fiYXpnxyVTt/UUaJNr9dwZRd
	 kytE+xIIeJ5OcDFC4xaTiBLMmyEAjbGCENHyOneg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/184] loop: factor out a loop_assign_backing_file helper
Date: Mon, 12 May 2025 19:45:44 +0200
Message-ID: <20250512172047.629348393@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d278164832618bf2775c6a89e6434e2633de1eed ]

Split the code for setting up a backing file into a helper in preparation
of adding more code to this path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250131120120.1315125-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 81995ebefc962..e083099a01e29 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -493,6 +493,14 @@ static int loop_validate_file(struct file *file, struct block_device *bdev)
 	return 0;
 }
 
+static void loop_assign_backing_file(struct loop_device *lo, struct file *file)
+{
+	lo->lo_backing_file = file;
+	lo->old_gfp_mask = mapping_gfp_mask(file->f_mapping);
+	mapping_set_gfp_mask(file->f_mapping,
+			lo->old_gfp_mask & ~(__GFP_IO | __GFP_FS));
+}
+
 /*
  * loop_change_fd switched the backing store of a loopback device to
  * a new file. This is useful for operating system installers to free up
@@ -545,10 +553,7 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	disk_force_media_change(lo->lo_disk);
 	blk_mq_freeze_queue(lo->lo_queue);
 	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
-	lo->lo_backing_file = file;
-	lo->old_gfp_mask = mapping_gfp_mask(file->f_mapping);
-	mapping_set_gfp_mask(file->f_mapping,
-			     lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+	loop_assign_backing_file(lo, file);
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
@@ -940,7 +945,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 			  const struct loop_config *config)
 {
 	struct file *file = fget(config->fd);
-	struct address_space *mapping;
 	struct queue_limits lim;
 	int error;
 	loff_t size;
@@ -976,8 +980,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	if (error)
 		goto out_unlock;
 
-	mapping = file->f_mapping;
-
 	if ((config->info.lo_flags & ~LOOP_CONFIGURE_SETTABLE_FLAGS) != 0) {
 		error = -EINVAL;
 		goto out_unlock;
@@ -1009,9 +1011,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 
 	lo->use_dio = lo->lo_flags & LO_FLAGS_DIRECT_IO;
 	lo->lo_device = bdev;
-	lo->lo_backing_file = file;
-	lo->old_gfp_mask = mapping_gfp_mask(mapping);
-	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+	loop_assign_backing_file(lo, file);
 
 	lim = queue_limits_start_update(lo->lo_queue);
 	loop_update_limits(lo, &lim, config->block_size);
-- 
2.39.5



