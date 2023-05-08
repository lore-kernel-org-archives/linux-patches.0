Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DCE171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7DEC433EF;
	Mon,  8 May 2023 11:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545938;
	bh=4V3xFZdIbV55er1cVBwZyz8UejTa6vkB3WWcebhvAjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4Lbx2M6LmxGC7yGg7XQfi9Bw72IkZArluF1nL6Ath6Tg9uP/o2ZUlBKFPxRmtJyb
	 yU92Ci6B3FdMfOHrgRD+HiILS7ep3Q/Gkfi6lK2HLNa01bUd+CoKpWYYBNHaxMAwYG
	 ELZ/nSZUJ8YfahU8i4MtMiiOtezYbbWk8WPQSj70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Vishal Verma <vverma@digitalocean.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 204/371] md: raid10 add nowait support
Date: Mon,  8 May 2023 11:46:45 +0200
Message-Id: <20230508094820.188185905@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vishal Verma <vverma@digitalocean.com>

[ Upstream commit c9aa889b035fca4598ae985a0f0c76ebbb547ad2 ]

This adds nowait support to the RAID10 driver. Very similar to
raid1 driver changes. It makes RAID10 driver return with EAGAIN
for situations where it could wait for eg:

  - Waiting for the barrier,
  - Reshape operation,
  - Discard operation.

wait_barrier() and regular_request_wait() fn are modified to return bool
to support error for wait barriers. They returns true in case of wait
or if wait is not required and returns false if wait was required
but not performed to support nowait.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Vishal Verma <vverma@digitalocean.com>
Signed-off-by: Song Liu <song@kernel.org>
Stable-dep-of: 72c215ed8731 ("md/raid10: fix task hung in raid10d")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 100 +++++++++++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 69708b455295b..287bebde2e546 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -952,8 +952,10 @@ static void lower_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void wait_barrier(struct r10conf *conf)
+static bool wait_barrier(struct r10conf *conf, bool nowait)
 {
+	bool ret = true;
+
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		struct bio_list *bio_list = current->bio_list;
@@ -967,27 +969,35 @@ static void wait_barrier(struct r10conf *conf)
 		 * that queue to get the nr_pending
 		 * count down.
 		 */
-		raid10_log(conf->mddev, "wait barrier");
-		wait_event_lock_irq(conf->wait_barrier,
-				    !conf->barrier ||
-				    (atomic_read(&conf->nr_pending) &&
-				     bio_list &&
-				     (!bio_list_empty(&bio_list[0]) ||
-				      !bio_list_empty(&bio_list[1]))) ||
-				     /* move on if recovery thread is
-				      * blocked by us
-				      */
-				     (conf->mddev->thread->tsk == current &&
-				      test_bit(MD_RECOVERY_RUNNING,
-					       &conf->mddev->recovery) &&
-				      conf->nr_queued > 0),
-				    conf->resync_lock);
+		/* Return false when nowait flag is set */
+		if (nowait) {
+			ret = false;
+		} else {
+			raid10_log(conf->mddev, "wait barrier");
+			wait_event_lock_irq(conf->wait_barrier,
+					    !conf->barrier ||
+					    (atomic_read(&conf->nr_pending) &&
+					     bio_list &&
+					     (!bio_list_empty(&bio_list[0]) ||
+					      !bio_list_empty(&bio_list[1]))) ||
+					     /* move on if recovery thread is
+					      * blocked by us
+					      */
+					     (conf->mddev->thread->tsk == current &&
+					      test_bit(MD_RECOVERY_RUNNING,
+						       &conf->mddev->recovery) &&
+					      conf->nr_queued > 0),
+					    conf->resync_lock);
+		}
 		conf->nr_waiting--;
 		if (!conf->nr_waiting)
 			wake_up(&conf->wait_barrier);
 	}
-	atomic_inc(&conf->nr_pending);
+	/* Only increment nr_pending when we wait */
+	if (ret)
+		atomic_inc(&conf->nr_pending);
 	spin_unlock_irq(&conf->resync_lock);
+	return ret;
 }
 
 static void allow_barrier(struct r10conf *conf)
@@ -1098,21 +1108,30 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
  * currently.
  * 2. If IO spans the reshape position.  Need to wait for reshape to pass.
  */
-static void regular_request_wait(struct mddev *mddev, struct r10conf *conf,
+static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 				 struct bio *bio, sector_t sectors)
 {
-	wait_barrier(conf);
+	/* Bail out if REQ_NOWAIT is set for the bio */
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return false;
+	}
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_iter.bi_sector < conf->reshape_progress &&
 	    bio->bi_iter.bi_sector + sectors > conf->reshape_progress) {
-		raid10_log(conf->mddev, "wait reshape");
 		allow_barrier(conf);
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return false;
+		}
+		raid10_log(conf->mddev, "wait reshape");
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
 			   sectors);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
+	return true;
 }
 
 static void raid10_read_request(struct mddev *mddev, struct bio *bio,
@@ -1157,7 +1176,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		rcu_read_unlock();
 	}
 
-	regular_request_wait(mddev, conf, bio, r10_bio->sectors);
+	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors))
+		return;
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (!rdev) {
 		if (err_rdev) {
@@ -1179,7 +1199,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
 		r10_bio->sectors = max_sectors;
@@ -1338,7 +1358,7 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 		raid10_log(conf->mddev, "%s wait rdev %d blocked",
 				__func__, blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		goto retry_wait;
 	}
 }
@@ -1356,6 +1376,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 					    bio->bi_iter.bi_sector,
 					    bio_end_sector(bio)))) {
 		DEFINE_WAIT(w);
+		/* Bail out if REQ_NOWAIT is set for the bio */
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		for (;;) {
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_IDLE);
@@ -1368,7 +1393,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	}
 
 	sectors = r10_bio->sectors;
-	regular_request_wait(mddev, conf, bio, sectors);
+	if (!regular_request_wait(mddev, conf, bio, sectors))
+		return;
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    (mddev->reshape_backwards
 	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
@@ -1380,6 +1406,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		set_mask_bits(&mddev->sb_flags, 0,
 			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
+		if (bio->bi_opf & REQ_NOWAIT) {
+			allow_barrier(conf);
+			bio_wouldblock_error(bio);
+			return;
+		}
 		raid10_log(conf->mddev, "wait reshape metadata");
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
@@ -1476,7 +1507,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		bio_chain(split, bio);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		bio = split;
 		r10_bio->master_bio = bio;
 	}
@@ -1601,7 +1632,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	wait_barrier(conf);
+	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return 0;
+	}
+	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
@@ -1643,7 +1678,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		allow_barrier(conf);
 		/* Resend the fist split part */
 		submit_bio_noacct(split);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 	div_u64_rem(bio_end, stripe_size, &remainder);
 	if (remainder) {
@@ -1654,7 +1689,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		/* Resend the second split part */
 		submit_bio_noacct(bio);
 		bio = split;
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 
 	bio_start = bio->bi_iter.bi_sector;
@@ -1810,7 +1845,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 		end_disk_offset += geo->stride;
 		atomic_inc(&first_r10bio->remaining);
 		raid_end_discard_bio(r10_bio);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		goto retry_discard;
 	}
 
@@ -2005,7 +2040,7 @@ static void print_conf(struct r10conf *conf)
 
 static void close_sync(struct r10conf *conf)
 {
-	wait_barrier(conf);
+	wait_barrier(conf, false);
 	allow_barrier(conf);
 
 	mempool_exit(&conf->r10buf_pool);
@@ -4816,7 +4851,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	if (need_flush ||
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Need to update reshape_position in metadata */
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		mddev->reshape_position = conf->reshape_progress;
 		if (mddev->reshape_backwards)
 			mddev->curr_resync_completed = raid10_size(mddev, 0, 0)
@@ -5239,4 +5274,3 @@ MODULE_DESCRIPTION("RAID10 (striped mirror) personality for MD");
 MODULE_ALIAS("md-personality-9"); /* RAID10 */
 MODULE_ALIAS("md-raid10");
 MODULE_ALIAS("md-level-10");
-
-- 
2.39.2



