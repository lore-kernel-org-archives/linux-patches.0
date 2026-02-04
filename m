Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968D818859B;
	Wed,  4 Feb 2026 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218678; cv=none; b=IjtyqiGLuVyzXskFf5qwFrafXMJ07n8B49IKlYvjYsD9QwIPa4xNshitqWnoQxNKoLAljWLt/yaEmP98lWrjpogqhDxQxtM4shQmQDs7OykPUUou6PFmxkcWxvO2qwqGeR89wFO9o46CSKPYM34nmcAQD5N1hB0HQvqByLKKo84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218678; c=relaxed/simple;
	bh=Kssxkspp02RSOV3ilZ4iJujUUw19lwF4MkBpqK1Ai+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrT1rp5cSWxu2zaBg4vkDZ17pzzBvdx35jQP1c58QQkOxkCBFCmdsRVn7Y0Nz+GFbPfVyYfo67KoByJqhpMybwx6zY2Dp4lfl/UqQJB+nAVpoLeijVxJYY4Wyy6kJafO1HqTCgYGjKERekpPKWMGHQu0RXObSPpCFDnyQ4fmWls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qa4K/obv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qa4K/obv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257A4C4CEF7;
	Wed,  4 Feb 2026 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218678;
	bh=Kssxkspp02RSOV3ilZ4iJujUUw19lwF4MkBpqK1Ai+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qa4K/obvp6ccUijTcDt+/pstqg6oPKroS3iLqvGGlrDA+k/cESPCGy8W8D2y6eutq
	 DGHXOxHH9mkW3+HVJqPp50pnAS/DI2Vc+VNky0BoymXegSraZI0j5H5MlqPsAeqk2u
	 K0Hnj5FX00vyY/PdQzKAMo1+BodjrTsB0cpngNQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Shida Zhang <zhangshida@kylinos.cn>,
	Coly Li <colyli@fnnas.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 29/87] bcache: use bio cloning for detached device requests
Date: Wed,  4 Feb 2026 15:40:27 +0100
Message-ID: <20260204143847.959339388@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Shida Zhang <zhangshida@kylinos.cn>

[ Upstream commit 3ef825dfd4e487d6f92b23ee2df2455814583ef4 ]

Previously, bcache hijacked the bi_end_io and bi_private fields of
the incoming bio when the backing device was in a detached state.
This is fragile and breaks if the bio is needed to be processed by
other layers.

This patch transitions to using a cloned bio embedded within a private
structure. This ensures the original bio's metadata remains untouched.

Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
Co-developed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Acked-by: Coly Li <colyli@fnnas.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 4da7c5c3ec34 ("bcache: fix I/O accounting leak in detached_dev_do_request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/bcache.h  |  9 +++++
 drivers/md/bcache/request.c | 79 ++++++++++++++++---------------------
 drivers/md/bcache/super.c   | 12 +++++-
 3 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d33e40d26ea5..cca5756030d71 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -273,6 +273,8 @@ struct bcache_device {
 
 	struct bio_set		bio_split;
 
+	struct bio_set		bio_detached;
+
 	unsigned int		data_csum:1;
 
 	int (*cache_miss)(struct btree *b, struct search *s,
@@ -755,6 +757,13 @@ struct bbio {
 	struct bio		bio;
 };
 
+struct detached_dev_io_private {
+	struct bcache_device	*d;
+	unsigned long		start_time;
+	struct bio		*orig_bio;
+	struct bio              bio;
+};
+
 #define BTREE_PRIO		USHRT_MAX
 #define INITIAL_PRIO		32768U
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7aa..a02aecac05cdf 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1077,68 +1077,58 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
 
-struct detached_dev_io_private {
-	struct bcache_device	*d;
-	unsigned long		start_time;
-	bio_end_io_t		*bi_end_io;
-	void			*bi_private;
-	struct block_device	*orig_bdev;
-};
-
 static void detached_dev_end_io(struct bio *bio)
 {
-	struct detached_dev_io_private *ddip;
-
-	ddip = bio->bi_private;
-	bio->bi_end_io = ddip->bi_end_io;
-	bio->bi_private = ddip->bi_private;
+	struct detached_dev_io_private *ddip =
+		container_of(bio, struct detached_dev_io_private, bio);
+	struct bio *orig_bio = ddip->orig_bio;
 
 	/* Count on the bcache device */
-	bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
+	bio_end_io_acct(orig_bio, ddip->start_time);
 
 	if (bio->bi_status) {
-		struct cached_dev *dc = container_of(ddip->d,
-						     struct cached_dev, disk);
+		struct cached_dev *dc = bio->bi_private;
+
 		/* should count I/O error for backing device here */
 		bch_count_backing_io_errors(dc, bio);
+		orig_bio->bi_status = bio->bi_status;
 	}
 
-	kfree(ddip);
-	bio_endio(bio);
+	bio_put(bio);
+	bio_endio(orig_bio);
 }
 
-static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
-		struct block_device *orig_bdev, unsigned long start_time)
+static void detached_dev_do_request(struct bcache_device *d,
+		struct bio *orig_bio, unsigned long start_time)
 {
 	struct detached_dev_io_private *ddip;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	struct bio *clone_bio;
 
-	/*
-	 * no need to call closure_get(&dc->disk.cl),
-	 * because upper layer had already opened bcache device,
-	 * which would call closure_get(&dc->disk.cl)
-	 */
-	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
-	if (!ddip) {
-		bio->bi_status = BLK_STS_RESOURCE;
-		bio_endio(bio);
+	if (bio_op(orig_bio) == REQ_OP_DISCARD &&
+	    !bdev_max_discard_sectors(dc->bdev)) {
+		bio_endio(orig_bio);
 		return;
 	}
 
-	ddip->d = d;
+	clone_bio = bio_alloc_clone(dc->bdev, orig_bio, GFP_NOIO,
+				    &d->bio_detached);
+	if (!clone_bio) {
+		orig_bio->bi_status = BLK_STS_RESOURCE;
+		bio_endio(orig_bio);
+		return;
+	}
+
+	ddip = container_of(clone_bio, struct detached_dev_io_private, bio);
 	/* Count on the bcache device */
-	ddip->orig_bdev = orig_bdev;
+	ddip->d = d;
 	ddip->start_time = start_time;
-	ddip->bi_end_io = bio->bi_end_io;
-	ddip->bi_private = bio->bi_private;
-	bio->bi_end_io = detached_dev_end_io;
-	bio->bi_private = ddip;
-
-	if ((bio_op(bio) == REQ_OP_DISCARD) &&
-	    !bdev_max_discard_sectors(dc->bdev))
-		detached_dev_end_io(bio);
-	else
-		submit_bio_noacct(bio);
+	ddip->orig_bio = orig_bio;
+
+	clone_bio->bi_end_io = detached_dev_end_io;
+	clone_bio->bi_private = dc;
+
+	submit_bio_noacct(clone_bio);
 }
 
 static void quit_max_writeback_rate(struct cache_set *c,
@@ -1214,10 +1204,10 @@ void cached_dev_submit_bio(struct bio *bio)
 
 	start_time = bio_start_io_acct(bio);
 
-	bio_set_dev(bio, dc->bdev);
 	bio->bi_iter.bi_sector += dc->sb.data_offset;
 
 	if (cached_dev_get(dc)) {
+		bio_set_dev(bio, dc->bdev);
 		s = search_alloc(bio, d, orig_bdev, start_time);
 		trace_bcache_request_start(s->d, bio);
 
@@ -1237,9 +1227,10 @@ void cached_dev_submit_bio(struct bio *bio)
 			else
 				cached_dev_read(dc, s);
 		}
-	} else
+	} else {
 		/* I/O request sent to backing device */
-		detached_dev_do_request(d, bio, orig_bdev, start_time);
+		detached_dev_do_request(d, bio, start_time);
+	}
 }
 
 static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1084b3f0dfe71..017a1ef42f1b0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -887,6 +887,7 @@ static void bcache_device_free(struct bcache_device *d)
 	}
 
 	bioset_exit(&d->bio_split);
+	bioset_exit(&d->bio_detached);
 	kvfree(d->full_dirty_stripes);
 	kvfree(d->stripe_sectors_dirty);
 
@@ -949,6 +950,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
 		goto out_ida_remove;
 
+	if (bioset_init(&d->bio_detached, 4,
+			offsetof(struct detached_dev_io_private, bio),
+			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
+		goto out_bioset_split_exit;
+
 	if (lim.logical_block_size > PAGE_SIZE && cached_bdev) {
 		/*
 		 * This should only happen with BCACHE_SB_VERSION_BDEV.
@@ -964,7 +970,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 
 	d->disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(d->disk))
-		goto out_bioset_exit;
+		goto out_bioset_detach_exit;
 
 	set_capacity(d->disk, sectors);
 	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -976,7 +982,9 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	d->disk->private_data	= d;
 	return 0;
 
-out_bioset_exit:
+out_bioset_detach_exit:
+	bioset_exit(&d->bio_detached);
+out_bioset_split_exit:
 	bioset_exit(&d->bio_split);
 out_ida_remove:
 	ida_free(&bcache_device_idx, idx);
-- 
2.51.0



