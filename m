Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F301C7019;
	Wed, 19 Feb 2025 09:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955929; cv=none; b=ap6bx8Ht/tu5WPM6YUGzmdG3Y+coNSHnkmuIW6i5Wm2KDCag1j4waIbEOkVsn9Xav9WyUBj3mOTox7nXYhPZb4whhZJObGWCNICTI9OIwrtCNDN70eLoLkdpixk6QZcKwaru8LBVvGWea+YBhWrYFDoC4YsjjoXHTI3CDzhuEiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955929; c=relaxed/simple;
	bh=Sl6LYX3H5MwAXf8P6cipcHlV3EhsfkG2IiUNGix9ZXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrEI66qGJlcoP/ZhFVIa7LARosrxEDextxIsKPr7TdS0iODLhuOHiy+krfsUdbqfxSJefd4ld5i/oSbLITXzR418nburkXwc3lE7QsYB7LWkul8rC/1sfDF2VAqdDqQbggCNeEk67c7qmwdkuevgsvHjQs7almBj81Ry7msMPs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v45k2W3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v45k2W3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B2EC4CED1;
	Wed, 19 Feb 2025 09:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955928;
	bh=Sl6LYX3H5MwAXf8P6cipcHlV3EhsfkG2IiUNGix9ZXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v45k2W3qXJBjKX3a2bv4mizsQ6+f69uvbwmqwz42MHo/zhhmrmw7QcGC38H5LGpgI
	 A+76CbiR6HI/AEpgI3LGppz0mMLyOKuzemSfOk9KIZgj+DNkXmz7/LvZCM3qgD1aTj
	 5Lkmx4AHKpZKQOlOLbfXzeTC/UNvini9FItN76+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 139/152] md/md-bitmap: factor behind write counters out from bitmap_{start/end}write()
Date: Wed, 19 Feb 2025 09:29:12 +0100
Message-ID: <20250219082555.544106459@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 08c50142a128dcb2d7060aa3b4c5db8837f7a46a upstream.

behind_write is only used in raid1, prepare to refactor
bitmap_{start/end}write(), there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/r/20250109015145.158868-2-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
[There is no bitmap_operations, resolve conflicts by exporting new api
md_bitmap_{start,end}_behind_write]
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c   |   60 +++++++++++++++++++++++++++++------------------
 drivers/md/md-bitmap.h   |    6 +++-
 drivers/md/raid1.c       |   11 +++++---
 drivers/md/raid10.c      |    5 +--
 drivers/md/raid5-cache.c |    4 +--
 drivers/md/raid5.c       |   13 ++++------
 6 files changed, 59 insertions(+), 40 deletions(-)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1465,22 +1465,12 @@ __acquires(bitmap->lock)
 			&(bitmap->bp[page].map[pageoff]);
 }
 
-int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
+int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
+			 unsigned long sectors)
 {
 	if (!bitmap)
 		return 0;
 
-	if (behind) {
-		int bw;
-		atomic_inc(&bitmap->behind_writes);
-		bw = atomic_read(&bitmap->behind_writes);
-		if (bw > bitmap->behind_writes_used)
-			bitmap->behind_writes_used = bw;
-
-		pr_debug("inc write-behind count %d/%lu\n",
-			 bw, bitmap->mddev->bitmap_info.max_write_behind);
-	}
-
 	while (sectors) {
 		sector_t blocks;
 		bitmap_counter_t *bmc;
@@ -1527,20 +1517,13 @@ int md_bitmap_startwrite(struct bitmap *
 	}
 	return 0;
 }
-EXPORT_SYMBOL(md_bitmap_startwrite);
+EXPORT_SYMBOL_GPL(md_bitmap_startwrite);
 
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind)
+			unsigned long sectors, int success)
 {
 	if (!bitmap)
 		return;
-	if (behind) {
-		if (atomic_dec_and_test(&bitmap->behind_writes))
-			wake_up(&bitmap->behind_wait);
-		pr_debug("dec write-behind count %d/%lu\n",
-			 atomic_read(&bitmap->behind_writes),
-			 bitmap->mddev->bitmap_info.max_write_behind);
-	}
 
 	while (sectors) {
 		sector_t blocks;
@@ -1580,7 +1563,7 @@ void md_bitmap_endwrite(struct bitmap *b
 			sectors = 0;
 	}
 }
-EXPORT_SYMBOL(md_bitmap_endwrite);
+EXPORT_SYMBOL_GPL(md_bitmap_endwrite);
 
 static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks,
 			       int degraded)
@@ -1842,6 +1825,39 @@ void md_bitmap_free(struct bitmap *bitma
 }
 EXPORT_SYMBOL(md_bitmap_free);
 
+void md_bitmap_start_behind_write(struct mddev *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+	int bw;
+
+	if (!bitmap)
+		return;
+
+	atomic_inc(&bitmap->behind_writes);
+	bw = atomic_read(&bitmap->behind_writes);
+	if (bw > bitmap->behind_writes_used)
+		bitmap->behind_writes_used = bw;
+
+	pr_debug("inc write-behind count %d/%lu\n",
+		 bw, bitmap->mddev->bitmap_info.max_write_behind);
+}
+EXPORT_SYMBOL_GPL(md_bitmap_start_behind_write);
+
+void md_bitmap_end_behind_write(struct mddev *mddev)
+{
+	struct bitmap *bitmap = mddev->bitmap;
+
+	if (!bitmap)
+		return;
+
+	if (atomic_dec_and_test(&bitmap->behind_writes))
+		wake_up(&bitmap->behind_wait);
+	pr_debug("dec write-behind count %d/%lu\n",
+		 atomic_read(&bitmap->behind_writes),
+		 bitmap->mddev->bitmap_info.max_write_behind);
+}
+EXPORT_SYMBOL_GPL(md_bitmap_end_behind_write);
+
 void md_bitmap_wait_behind_writes(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -253,9 +253,11 @@ void md_bitmap_dirty_bits(struct bitmap
 
 /* these are exported */
 int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,
-			 unsigned long sectors, int behind);
+			 unsigned long sectors);
 void md_bitmap_endwrite(struct bitmap *bitmap, sector_t offset,
-			unsigned long sectors, int success, int behind);
+			unsigned long sectors, int success);
+void md_bitmap_start_behind_write(struct mddev *mddev);
+void md_bitmap_end_behind_write(struct mddev *mddev);
 int md_bitmap_start_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int degraded);
 void md_bitmap_end_sync(struct bitmap *bitmap, sector_t offset, sector_t *blocks, int aborted);
 void md_bitmap_close_sync(struct bitmap *bitmap);
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -419,11 +419,12 @@ static void close_write(struct r1bio *r1
 		bio_put(r1_bio->behind_master_bio);
 		r1_bio->behind_master_bio = NULL;
 	}
+	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
+		md_bitmap_end_behind_write(r1_bio->mddev);
 	/* clear the bitmap if all writes complete successfully */
 	md_bitmap_endwrite(r1_bio->mddev->bitmap, r1_bio->sector,
 			   r1_bio->sectors,
-			   !test_bit(R1BIO_Degraded, &r1_bio->state),
-			   test_bit(R1BIO_BehindIO, &r1_bio->state));
+			   !test_bit(R1BIO_Degraded, &r1_bio->state));
 	md_write_end(r1_bio->mddev);
 }
 
@@ -1530,8 +1531,10 @@ static void raid1_write_request(struct m
 				alloc_behind_master_bio(r1_bio, bio);
 			}
 
-			md_bitmap_startwrite(bitmap, r1_bio->sector, r1_bio->sectors,
-					     test_bit(R1BIO_BehindIO, &r1_bio->state));
+			if (test_bit(R1BIO_BehindIO, &r1_bio->state))
+				md_bitmap_start_behind_write(mddev);
+			md_bitmap_startwrite(bitmap, r1_bio->sector,
+					     r1_bio->sectors);
 			first_clone = 0;
 		}
 
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -430,8 +430,7 @@ static void close_write(struct r10bio *r
 	/* clear the bitmap if all writes complete successfully */
 	md_bitmap_endwrite(r10_bio->mddev->bitmap, r10_bio->sector,
 			   r10_bio->sectors,
-			   !test_bit(R10BIO_Degraded, &r10_bio->state),
-			   0);
+			   !test_bit(R10BIO_Degraded, &r10_bio->state));
 	md_write_end(r10_bio->mddev);
 }
 
@@ -1554,7 +1553,7 @@ static void raid10_write_request(struct
 	md_account_bio(mddev, &bio);
 	r10_bio->master_bio = bio;
 	atomic_set(&r10_bio->remaining, 1);
-	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors, 0);
+	md_bitmap_startwrite(mddev->bitmap, r10_bio->sector, r10_bio->sectors);
 
 	for (i = 0; i < conf->copies; i++) {
 		if (r10_bio->devs[i].bio)
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -315,8 +315,8 @@ void r5c_handle_cached_data_endio(struct
 			r5c_return_dev_pending_writes(conf, &sh->dev[i]);
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 					   RAID5_STRIPE_SECTORS(conf),
-					   !test_bit(STRIPE_DEGRADED, &sh->state),
-					   0);
+					   !test_bit(STRIPE_DEGRADED,
+						     &sh->state));
 		}
 	}
 }
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3606,7 +3606,7 @@ static void __add_stripe_bio(struct stri
 		set_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		spin_unlock_irq(&sh->stripe_lock);
 		md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-				     RAID5_STRIPE_SECTORS(conf), 0);
+				     RAID5_STRIPE_SECTORS(conf));
 		spin_lock_irq(&sh->stripe_lock);
 		clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
 		if (!sh->batch_head) {
@@ -3708,7 +3708,7 @@ handle_failed_stripe(struct r5conf *conf
 		}
 		if (bitmap_end)
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0, 0);
+					   RAID5_STRIPE_SECTORS(conf), 0);
 		bitmap_end = 0;
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
@@ -3754,7 +3754,7 @@ handle_failed_stripe(struct r5conf *conf
 		}
 		if (bitmap_end)
 			md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-					   RAID5_STRIPE_SECTORS(conf), 0, 0);
+					   RAID5_STRIPE_SECTORS(conf), 0);
 		/* If we were in the middle of a write the parity block might
 		 * still be locked - so just clear all R5_LOCKED flags
 		 */
@@ -4107,8 +4107,8 @@ returnbi:
 				}
 				md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
 						   RAID5_STRIPE_SECTORS(conf),
-						   !test_bit(STRIPE_DEGRADED, &sh->state),
-						   0);
+						   !test_bit(STRIPE_DEGRADED,
+							     &sh->state));
 				if (head_sh->batch_head) {
 					sh = list_first_entry(&sh->batch_list,
 							      struct stripe_head,
@@ -5853,8 +5853,7 @@ static void make_discard_request(struct
 			     d++)
 				md_bitmap_startwrite(mddev->bitmap,
 						     sh->sector,
-						     RAID5_STRIPE_SECTORS(conf),
-						     0);
+						     RAID5_STRIPE_SECTORS(conf));
 			sh->bm_seq = conf->seq_flush + 1;
 			set_bit(STRIPE_BIT_DELAY, &sh->state);
 		}


