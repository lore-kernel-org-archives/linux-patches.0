Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A732989B2;
	Mon, 12 May 2025 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073061; cv=none; b=Jw3s48lYBbpk8XTf36K8G7JE461rVwohbz7lqdLhfbLLJWzbaTYQ1GNVWMp4MTQpSju57r9XjEeVV7M8+BMrROzvsBClx98N3ls9p6bFoKv6oDQS3RuJTPTYjnkQGoviKMbyUMW+ZoLLS48lhufLLTb/jHALdzFK/41KZGFmjW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073061; c=relaxed/simple;
	bh=yq93t+wQDRhOU6ht+Z5zQ1AWcbo7fRi1um1/XTqQrNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCftYrHgFrTAqNYWfOF6iDabSiFYVUSRVSMDu18wH9e3YtMGkNFVkvfXdgmQgb61qha3KYj92doMV4XV4a8f1uhZcwwrTExNYbWMMajFasi1nhlTgD2KGmdiL05PDWtWYhzKvixw28KXqiXbU/0+Qj4kTGlyRw6cvLWSRJnM7SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfWxfaZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfWxfaZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F9BC4CEE7;
	Mon, 12 May 2025 18:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073059;
	bh=yq93t+wQDRhOU6ht+Z5zQ1AWcbo7fRi1um1/XTqQrNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfWxfaZWVQUPkqia9xMjNsrUcL/rCMBzuKvsI2t42ElqcIBJOTCefuqAG8YrF+ggx
	 5kqX7GeNHMZARXuS5uLViWT60QKx7nmxVpokNi8WYP5bSjo0+qbclFssAUTnSE2dM4
	 Gp/ZT0/5vxmVY6AM7qLtS1Y4Mq0+RytXsftdmHQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/184] loop: refactor queue limits updates
Date: Mon, 12 May 2025 19:45:43 +0200
Message-ID: <20250512172047.589871280@linuxfoundation.org>
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

[ Upstream commit b38c8be255e89ffcdeb817407222d2de0b573a41 ]

Replace loop_reconfigure_limits with a slightly less encompassing
loop_update_limits that expects the caller to acquire and commit the
queue limits to prepare for sorting out the freeze vs limits lock
ordering.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://lore.kernel.org/r/20250110054726.1499538-11-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 27e4bd8ee9dc9..81995ebefc962 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -901,12 +901,12 @@ static unsigned int loop_default_blocksize(struct loop_device *lo,
 	return SECTOR_SIZE;
 }
 
-static int loop_reconfigure_limits(struct loop_device *lo, unsigned int bsize)
+static void loop_update_limits(struct loop_device *lo, struct queue_limits *lim,
+		unsigned int bsize)
 {
 	struct file *file = lo->lo_backing_file;
 	struct inode *inode = file->f_mapping->host;
 	struct block_device *backing_bdev = NULL;
-	struct queue_limits lim;
 	u32 granularity = 0, max_discard_sectors = 0;
 
 	if (S_ISBLK(inode->i_mode))
@@ -919,22 +919,20 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned int bsize)
 
 	loop_get_discard_config(lo, &granularity, &max_discard_sectors);
 
-	lim = queue_limits_start_update(lo->lo_queue);
-	lim.logical_block_size = bsize;
-	lim.physical_block_size = bsize;
-	lim.io_min = bsize;
-	lim.features &= ~(BLK_FEAT_WRITE_CACHE | BLK_FEAT_ROTATIONAL);
+	lim->logical_block_size = bsize;
+	lim->physical_block_size = bsize;
+	lim->io_min = bsize;
+	lim->features &= ~(BLK_FEAT_WRITE_CACHE | BLK_FEAT_ROTATIONAL);
 	if (file->f_op->fsync && !(lo->lo_flags & LO_FLAGS_READ_ONLY))
-		lim.features |= BLK_FEAT_WRITE_CACHE;
+		lim->features |= BLK_FEAT_WRITE_CACHE;
 	if (backing_bdev && !bdev_nonrot(backing_bdev))
-		lim.features |= BLK_FEAT_ROTATIONAL;
-	lim.max_hw_discard_sectors = max_discard_sectors;
-	lim.max_write_zeroes_sectors = max_discard_sectors;
+		lim->features |= BLK_FEAT_ROTATIONAL;
+	lim->max_hw_discard_sectors = max_discard_sectors;
+	lim->max_write_zeroes_sectors = max_discard_sectors;
 	if (max_discard_sectors)
-		lim.discard_granularity = granularity;
+		lim->discard_granularity = granularity;
 	else
-		lim.discard_granularity = 0;
-	return queue_limits_commit_update(lo->lo_queue, &lim);
+		lim->discard_granularity = 0;
 }
 
 static int loop_configure(struct loop_device *lo, blk_mode_t mode,
@@ -943,6 +941,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 {
 	struct file *file = fget(config->fd);
 	struct address_space *mapping;
+	struct queue_limits lim;
 	int error;
 	loff_t size;
 	bool partscan;
@@ -1014,7 +1013,9 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	lo->old_gfp_mask = mapping_gfp_mask(mapping);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask & ~(__GFP_IO|__GFP_FS));
 
-	error = loop_reconfigure_limits(lo, config->block_size);
+	lim = queue_limits_start_update(lo->lo_queue);
+	loop_update_limits(lo, &lim, config->block_size);
+	error = queue_limits_commit_update(lo->lo_queue, &lim);
 	if (error)
 		goto out_unlock;
 
@@ -1382,6 +1383,7 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)
 
 static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 {
+	struct queue_limits lim;
 	int err = 0;
 
 	if (lo->lo_state != Lo_bound)
@@ -1394,7 +1396,9 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	invalidate_bdev(lo->lo_device);
 
 	blk_mq_freeze_queue(lo->lo_queue);
-	err = loop_reconfigure_limits(lo, arg);
+	lim = queue_limits_start_update(lo->lo_queue);
+	loop_update_limits(lo, &lim, arg);
+	err = queue_limits_commit_update(lo->lo_queue, &lim);
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
-- 
2.39.5



