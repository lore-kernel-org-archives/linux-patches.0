Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F9B33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4764DC433EF;
	Mon, 16 Jan 2023 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884895;
	bh=KE3i+TAf3Z6Tj98mEE63u8rEH1YJprY5ygNDnEyaZkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zwilz8ToZV35T/zGNztqCXFni3YmDh4F/tiUPKdDlWQcGw8VVRHydtTEGWaeWqMD1
	 E3DRvlZR6m2kUrYZtZS6EzWwG9JMJzv4IQVsHP6++LNnygB4nvoZnJSgAj1JZgt/FU
	 BVa5ljz7u70dJG6DW/aOZ49Nvwgvm4fZyEv4yX8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 181/183] block: handle bio_split_to_limits() NULL return
Date: Mon, 16 Jan 2023 16:51:44 +0100
Message-Id: <20230116154810.941489012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit 613b14884b8595e20b9fac4126bf627313827fbe upstream.

This can't happen right now, but in preparation for allowing
bio_split_to_limits() returning NULL if it ended the bio, check for it
in all the callers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-merge.c             |    4 +++-
 block/blk-mq.c                |    5 ++++-
 drivers/block/drbd/drbd_req.c |    2 ++
 drivers/block/ps3vram.c       |    2 ++
 drivers/md/dm.c               |    2 ++
 drivers/md/md.c               |    2 ++
 drivers/nvme/host/multipath.c |    2 ++
 drivers/s390/block/dcssblk.c  |    2 ++
 8 files changed, 19 insertions(+), 2 deletions(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -358,11 +358,13 @@ struct bio *__bio_split_to_limits(struct
 	default:
 		split = bio_split_rw(bio, lim, nr_segs, bs,
 				get_max_io_size(bio, lim) << SECTOR_SHIFT);
+		if (IS_ERR(split))
+			return NULL;
 		break;
 	}
 
 	if (split) {
-		/* there isn't chance to merge the splitted bio */
+		/* there isn't chance to merge the split bio */
 		split->bi_opf |= REQ_NOMERGE;
 
 		blkcg_bio_issue_init(split);
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2919,8 +2919,11 @@ void blk_mq_submit_bio(struct bio *bio)
 	blk_status_t ret;
 
 	bio = blk_queue_bounce(bio, q);
-	if (bio_may_exceed_limits(bio, &q->limits))
+	if (bio_may_exceed_limits(bio, &q->limits)) {
 		bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
+		if (!bio)
+			return;
+	}
 
 	if (!bio_integrity_prep(bio))
 		return;
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1607,6 +1607,8 @@ void drbd_submit_bio(struct bio *bio)
 	struct drbd_device *device = bio->bi_bdev->bd_disk->private_data;
 
 	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
 
 	/*
 	 * what we "blindly" assume:
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -587,6 +587,8 @@ static void ps3vram_submit_bio(struct bi
 	dev_dbg(&dev->core, "%s\n", __func__);
 
 	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
 
 	spin_lock_irq(&priv->lock);
 	busy = !bio_list_empty(&priv->list);
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1755,6 +1755,8 @@ static void dm_split_and_process_bio(str
 		 * otherwise associated queue_limits won't be imposed.
 		 */
 		bio = bio_split_to_limits(bio);
+		if (!bio)
+			return;
 	}
 
 	init_clone_info(&ci, md, map, bio, is_abnormal);
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -443,6 +443,8 @@ static void md_submit_bio(struct bio *bi
 	}
 
 	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
 
 	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
 		if (bio_sectors(bio) != 0)
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -351,6 +351,8 @@ static void nvme_ns_head_submit_bio(stru
 	 * pool from the original queue to allocate the bvecs from.
 	 */
 	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
 
 	srcu_idx = srcu_read_lock(&head->srcu);
 	ns = nvme_find_path(head);
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -865,6 +865,8 @@ dcssblk_submit_bio(struct bio *bio)
 	unsigned long bytes_done;
 
 	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
 
 	bytes_done = 0;
 	dev_info = bio->bi_bdev->bd_disk->private_data;


