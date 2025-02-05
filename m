Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BE3158536;
	Wed,  5 Feb 2025 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768511; cv=none; b=IZUrOlhtMwK1MVn522JXL08bYRDmk+3NfmzZ6eDGxEaf2eZuBIC69/GgW7nPqCtZLWKKiAYs9XrDCixtzoTLqjxaw+Sm6PtYAW4da2vtZFYVsZ6ojmbjrbhQANIkLagOuQBk4QMze/DtYptEVaWnB1UNa+57dpe2GvxMHGTVJyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768511; c=relaxed/simple;
	bh=09SjyKC2H13P8WLxGX3CIGsZZkjitZE4mk9pXp+2UBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HnxXmf71PEvO1jzN6es3X3aqJBDJy6hgfQ4Mu2/VGAoNOD6r+VHAR0RwaNxdasjPw9UTeUTouMW0iaKz86/fX6bhuEBgYqzU4N6F8HhRRWoxZ/AL+ZafxeT7ACuv16bhKj2yqjkTHhLjEEq/wurRzY7L93vbF+nxGBs003UxM/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffLh6TCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffLh6TCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9772DC4CED1;
	Wed,  5 Feb 2025 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768511;
	bh=09SjyKC2H13P8WLxGX3CIGsZZkjitZE4mk9pXp+2UBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffLh6TCKzQB9j6tqBr9rz2g1ab5jWUvPWV1gc/Ums+xD9ARlpZEV8C+FN/5Z707g7
	 5CbgovCwnhfotdCBy8USibN3JobcC6+dopEZmVlGjSAq7tXXy8I8ZFZGCvmIeUge6f
	 XPtFjf1pDY9YyH6A3dpdZ2FeDU4y5xckzIyHS1Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH 6.13 577/623] md/md-bitmap: move bitmap_{start, end}write to md upper layer
Date: Wed,  5 Feb 2025 14:45:19 +0100
Message-ID: <20250205134518.296365050@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit cd5fc653381811f1e0ba65f5d169918cab61476f upstream.

There are two BUG reports that raid5 will hang at
bitmap_startwrite([1],[2]), root cause is that bitmap start write and end
write is unbalanced, it's not quite clear where, and while reviewing raid5
code, it's found that bitmap operations can be optimized. For example,
for a 4 disks raid5, with chunksize=8k, if user issue a IO (0 + 48k) to
the array:

┌────────────────────────────────────────────────────────────┐
│chunk 0                                                     │
│      ┌────────────┬─────────────┬─────────────┬────────────┼
│  sh0 │A0: 0 + 4k  │A1: 8k + 4k  │A2: 16k + 4k │A3: P       │
│      ┼────────────┼─────────────┼─────────────┼────────────┼
│  sh1 │B0: 4k + 4k │B1: 12k + 4k │B2: 20k + 4k │B3: P       │
┼──────┴────────────┴─────────────┴─────────────┴────────────┼
│chunk 1                                                     │
│      ┌────────────┬─────────────┬─────────────┬────────────┤
│  sh2 │C0: 24k + 4k│C1: 32k + 4k │C2: P        │C3: 40k + 4k│
│      ┼────────────┼─────────────┼─────────────┼────────────┼
│  sh3 │D0: 28k + 4k│D1: 36k + 4k │D2: P        │D3: 44k + 4k│
└──────┴────────────┴─────────────┴─────────────┴────────────┘

Before this patch, 4 stripe head will be used, and each sh will attach
bio for 3 disks, and each attached bio will trigger
bitmap_startwrite() once, which means total 12 times.
 - 3 times (0 + 4k), for (A0, A1 and A2)
 - 3 times (4 + 4k), for (B0, B1 and B2)
 - 3 times (8 + 4k), for (C0, C1 and C3)
 - 3 times (12 + 4k), for (D0, D1 and D3)

After this patch, md upper layer will calculate that IO range (0 + 48k)
is corresponding to the bitmap (0 + 16k), and call bitmap_startwrite()
just once.

Noted that this patch will align bitmap ranges to the chunks, for example,
if user issue a IO (0 + 4k) to array:

- Before this patch, 1 time (0 + 4k), for A0;
- After this patch, 1 time (0 + 8k) for chunk 0;

Usually, one bitmap bit will represent more than one disk chunk, and this
doesn't have any difference. And even if user really created a array
that one chunk contain multiple bits, the overhead is that more data
will be recovered after power failure.

Also remove STRIPE_BITMAP_PENDING since it's not used anymore.

[1] https://lore.kernel.org/all/CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com/
[2] https://lore.kernel.org/all/ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io/

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250109015145.158868-6-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c          |   29 +++++++++++++++++++++++++++
 drivers/md/md.h          |    2 +
 drivers/md/raid1.c       |    4 ---
 drivers/md/raid10.c      |    3 --
 drivers/md/raid5-cache.c |    2 -
 drivers/md/raid5.c       |   50 +++++------------------------------------------
 drivers/md/raid5.h       |    3 --
 7 files changed, 37 insertions(+), 56 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8745,12 +8745,32 @@ void md_submit_discard_bio(struct mddev
 }
 EXPORT_SYMBOL_GPL(md_submit_discard_bio);
 
+static void md_bitmap_start(struct mddev *mddev,
+			    struct md_io_clone *md_io_clone)
+{
+	if (mddev->pers->bitmap_sector)
+		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
+					   &md_io_clone->sectors);
+
+	mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
+				      md_io_clone->sectors);
+}
+
+static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io_clone)
+{
+	mddev->bitmap_ops->endwrite(mddev, md_io_clone->offset,
+				    md_io_clone->sectors);
+}
+
 static void md_end_clone_io(struct bio *bio)
 {
 	struct md_io_clone *md_io_clone = bio->bi_private;
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
+	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
+		md_bitmap_end(mddev, md_io_clone);
+
 	if (bio->bi_status && !orig_bio->bi_status)
 		orig_bio->bi_status = bio->bi_status;
 
@@ -8775,6 +8795,12 @@ static void md_clone_bio(struct mddev *m
 	if (blk_queue_io_stat(bdev->bd_disk->queue))
 		md_io_clone->start_time = bio_start_io_acct(*bio);
 
+	if (bio_data_dir(*bio) == WRITE && mddev->bitmap) {
+		md_io_clone->offset = (*bio)->bi_iter.bi_sector;
+		md_io_clone->sectors = bio_sectors(*bio);
+		md_bitmap_start(mddev, md_io_clone);
+	}
+
 	clone->bi_end_io = md_end_clone_io;
 	clone->bi_private = md_io_clone;
 	*bio = clone;
@@ -8793,6 +8819,9 @@ void md_free_cloned_bio(struct bio *bio)
 	struct bio *orig_bio = md_io_clone->orig_bio;
 	struct mddev *mddev = md_io_clone->mddev;
 
+	if (bio_data_dir(orig_bio) == WRITE && mddev->bitmap)
+		md_bitmap_end(mddev, md_io_clone);
+
 	if (bio->bi_status && !orig_bio->bi_status)
 		orig_bio->bi_status = bio->bi_status;
 
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -831,6 +831,8 @@ struct md_io_clone {
 	struct mddev	*mddev;
 	struct bio	*orig_bio;
 	unsigned long	start_time;
+	sector_t	offset;
+	unsigned long	sectors;
 	struct bio	bio_clone;
 };
 
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -422,8 +422,6 @@ static void close_write(struct r1bio *r1
 
 	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
 		mddev->bitmap_ops->end_behind_write(mddev);
-	/* clear the bitmap if all writes complete successfully */
-	mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors);
 	md_write_end(mddev);
 }
 
@@ -1632,8 +1630,6 @@ static void raid1_write_request(struct m
 
 			if (test_bit(R1BIO_BehindIO, &r1_bio->state))
 				mddev->bitmap_ops->start_behind_write(mddev);
-			mddev->bitmap_ops->startwrite(mddev, r1_bio->sector,
-						      r1_bio->sectors);
 			first_clone = 0;
 		}
 
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -428,8 +428,6 @@ static void close_write(struct r10bio *r
 {
 	struct mddev *mddev = r10_bio->mddev;
 
-	/* clear the bitmap if all writes complete successfully */
-	mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors);
 	md_write_end(mddev);
 }
 
@@ -1506,7 +1504,6 @@ static void raid10_write_request(struct
 	md_account_bio(mddev, &bio);
 	r10_bio->master_bio = bio;
 	atomic_set(&r10_bio->remaining, 1);
-	mddev->bitmap_ops->startwrite(mddev, r10_bio->sector, r10_bio->sectors);
 
 	for (i = 0; i < conf->copies; i++) {
 		if (r10_bio->devs[i].bio)
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -313,8 +313,6 @@ void r5c_handle_cached_data_endio(struct
 		if (sh->dev[i].written) {
 			set_bit(R5_UPTODATE, &sh->dev[i].flags);
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
-			conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf));
 		}
 	}
 }
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -906,8 +906,7 @@ static bool stripe_can_batch(struct stri
 	if (raid5_has_log(conf) || raid5_has_ppl(conf))
 		return false;
 	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
-		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
-		is_full_stripe_write(sh);
+	       is_full_stripe_write(sh);
 }
 
 /* we only do back search */
@@ -3545,29 +3544,9 @@ static void __add_stripe_bio(struct stri
 		 (*bip)->bi_iter.bi_sector, sh->sector, dd_idx,
 		 sh->dev[dd_idx].sector);
 
-	if (conf->mddev->bitmap && firstwrite) {
-		/* Cannot hold spinlock over bitmap_startwrite,
-		 * but must ensure this isn't added to a batch until
-		 * we have added to the bitmap and set bm_seq.
-		 * So set STRIPE_BITMAP_PENDING to prevent
-		 * batching.
-		 * If multiple __add_stripe_bio() calls race here they
-		 * much all set STRIPE_BITMAP_PENDING.  So only the first one
-		 * to complete "bitmap_startwrite" gets to set
-		 * STRIPE_BIT_DELAY.  This is important as once a stripe
-		 * is added to a batch, STRIPE_BIT_DELAY cannot be changed
-		 * any more.
-		 */
-		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
-		spin_unlock_irq(&sh->stripe_lock);
-		conf->mddev->bitmap_ops->startwrite(conf->mddev, sh->sector,
-					RAID5_STRIPE_SECTORS(conf));
-		spin_lock_irq(&sh->stripe_lock);
-		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
-		if (!sh->batch_head) {
-			sh->bm_seq = conf->seq_flush+1;
-			set_bit(STRIPE_BIT_DELAY, &sh->state);
-		}
+	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
+		sh->bm_seq = conf->seq_flush+1;
+		set_bit(STRIPE_BIT_DELAY, &sh->state);
 	}
 }
 
@@ -3618,7 +3597,6 @@ handle_failed_stripe(struct r5conf *conf
 	BUG_ON(sh->batch_head);
 	for (i = disks; i--; ) {
 		struct bio *bi;
-		int bitmap_end = 0;
 
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			struct md_rdev *rdev = conf->disks[i].rdev;
@@ -3643,8 +3621,6 @@ handle_failed_stripe(struct r5conf *conf
 		sh->dev[i].towrite = NULL;
 		sh->overwrite_disks = 0;
 		spin_unlock_irq(&sh->stripe_lock);
-		if (bi)
-			bitmap_end = 1;
 
 		log_stripe_write_finished(sh);
 
@@ -3659,10 +3635,6 @@ handle_failed_stripe(struct r5conf *conf
 			bio_io_error(bi);
 			bi = nextbi;
 		}
-		if (bitmap_end)
-			conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf));
-		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
@@ -3671,7 +3643,6 @@ handle_failed_stripe(struct r5conf *conf
 			sh->dev[i].page = sh->dev[i].orig_page;
 		}
 
-		if (bi) bitmap_end = 1;
 		while (bi && bi->bi_iter.bi_sector <
 		       sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
 			struct bio *bi2 = r5_next_bio(conf, bi, sh->dev[i].sector);
@@ -3705,9 +3676,6 @@ handle_failed_stripe(struct r5conf *conf
 				bi = nextbi;
 			}
 		}
-		if (bitmap_end)
-			conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf));
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -4056,8 +4024,7 @@ returnbi:
 					bio_endio(wbi);
 					wbi = wbi2;
 				}
-				conf->mddev->bitmap_ops->endwrite(conf->mddev,
-					sh->sector, RAID5_STRIPE_SECTORS(conf));
+
 				if (head_sh->batch_head) {
 					sh = list_first_entry(&sh->batch_list,
 							      struct stripe_head,
@@ -4882,8 +4849,7 @@ static void break_stripe_batch_list(stru
 					  (1 << STRIPE_COMPUTE_RUN)  |
 					  (1 << STRIPE_DISCARD) |
 					  (1 << STRIPE_BATCH_READY) |
-					  (1 << STRIPE_BATCH_ERR) |
-					  (1 << STRIPE_BITMAP_PENDING)),
+					  (1 << STRIPE_BATCH_ERR)),
 			"stripe state: %lx\n", sh->state);
 		WARN_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
 					      (1 << STRIPE_REPLACED)),
@@ -5774,10 +5740,6 @@ static void make_discard_request(struct
 		}
 		spin_unlock_irq(&sh->stripe_lock);
 		if (conf->mddev->bitmap) {
-			for (d = 0; d < conf->raid_disks - conf->max_degraded;
-			     d++)
-				mddev->bitmap_ops->startwrite(mddev, sh->sector,
-					RAID5_STRIPE_SECTORS(conf));
 			sh->bm_seq = conf->seq_flush + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -371,9 +371,6 @@ enum {
 	STRIPE_ON_RELEASE_LIST,
 	STRIPE_BATCH_READY,
 	STRIPE_BATCH_ERR,
-	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
-				 * to batch yet.
-				 */
 	STRIPE_LOG_TRAPPED,	/* trapped into log (see raid5-cache.c)
 				 * this bit is used in two scenarios:
 				 *


