Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83BC254879;
	Mon, 12 May 2025 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072244; cv=none; b=tFvsefduISGr5bPSgXHoy+xp1/7fYm9cldx1X6WeNx/l+9HtTOhoSDIREl3dw2jYtirdtTkgF5sT6emrT0/lwVRfShHZLODV43Ccgef7gJhib8uMXytVDob06l3byYjiNEDcTD9bBmpB3ymJ1c9K9NN3AU4C7+VOw1rgA3FL8GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072244; c=relaxed/simple;
	bh=MavcPj2VPmijY3s5izDKQ/295stt8XH4WZpPhq0/Lpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYw9YpDgBNmJX9f+n/93uROxZUhsEKAtWf+w3gzs0vEes01Kf0WPiQLn6Fx28HU7fvtZhIohSVPZhUEYf4Cic/MLOGCMooia3/W4eHsA1kZ9JGe4mEUnmnUanZoFrkku953/x+eiekC3VRINozLcLgzsV8nfrX37h5njZLpgyAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmkAS+Ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmkAS+Ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485B1C4CEEF;
	Mon, 12 May 2025 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072244;
	bh=MavcPj2VPmijY3s5izDKQ/295stt8XH4WZpPhq0/Lpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmkAS+Ur32KnvonYIF9mDohkoZmw2Osle6rdPLzErfQtC4QU+PiXMYPQwsyDBJscL
	 MOiZRQhmNwxK5tlJYQY2f0uH5XEix2xx5HohnEChMYj9MtCwAaVjbpnEJ8ryXXUnPH
	 9kna5rG2ZL9vuLGKE61Iy7cGwez79DzYLxLNSUD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 161/197] loop: factor out a loop_assign_backing_file helper
Date: Mon, 12 May 2025 19:40:11 +0200
Message-ID: <20250512172050.939087333@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 7668b79d8b0a9..61ce7ccde3445 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -496,6 +496,14 @@ static int loop_validate_file(struct file *file, struct block_device *bdev)
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
@@ -549,10 +557,7 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 	disk_force_media_change(lo->lo_disk);
 	memflags = blk_mq_freeze_queue(lo->lo_queue);
 	mapping_set_gfp_mask(old_file->f_mapping, lo->old_gfp_mask);
-	lo->lo_backing_file = file;
-	lo->old_gfp_mask = mapping_gfp_mask(file->f_mapping);
-	mapping_set_gfp_mask(file->f_mapping,
-			     lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+	loop_assign_backing_file(lo, file);
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue, memflags);
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
@@ -943,7 +948,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 			  const struct loop_config *config)
 {
 	struct file *file = fget(config->fd);
-	struct address_space *mapping;
 	struct queue_limits lim;
 	int error;
 	loff_t size;
@@ -979,8 +983,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	if (error)
 		goto out_unlock;
 
-	mapping = file->f_mapping;
-
 	if ((config->info.lo_flags & ~LOOP_CONFIGURE_SETTABLE_FLAGS) != 0) {
 		error = -EINVAL;
 		goto out_unlock;
@@ -1012,9 +1014,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	set_disk_ro(lo->lo_disk, (lo->lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
 	lo->lo_device = bdev;
-	lo->lo_backing_file = file;
-	lo->old_gfp_mask = mapping_gfp_mask(mapping);
-	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
+	loop_assign_backing_file(lo, file);
 
 	lim = queue_limits_start_update(lo->lo_queue);
 	loop_update_limits(lo, &lim, config->block_size);
-- 
2.39.5



