Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA7711710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7448C433C9;
	Mon, 11 Sep 2023 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445238;
	bh=zq5UzGm1X5lbfhr5dtx0FBvlih1UpFEaamieQvrYkpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXPVwZhnEjoJphVazlQmS0t+RSN29H42Q+uX6p3W7lIQl0KY51r5BtU0ywzlWlMII
	 b2gL8d0j4+lYWbZh6RLIbZQ8XEryOZ8/b7bs/uHe7iQqMZA8dBpsznMFi0MQEybgt2
	 y5gQcQTVX8tmTw982RD4bZ3PgL4L+wg4ELKGzN2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/600] md: Change active_io to percpu
Date: Mon, 11 Sep 2023 15:45:09 +0200
Message-ID: <20230911134641.753916703@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 72adae23a72cb12e2ef0dcd7c0aa042867f27998 ]

Now the type of active_io is atomic. It's used to count how many ios are
in the submitting process and it's added and decreased very time. But it
only needs to check if it's zero when suspending the raid. So we can
switch atomic to percpu to improve the performance.

After switching active_io to percpu type, we use the state of active_io
to judge if the raid device is suspended. And we don't need to wake up
->sb_wait in md_handle_request anymore. It's done in the callback function
which is registered when initing active_io. The argument mddev->suspended
is only used to count how many users are trying to set raid to suspend
state.

Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Stable-dep-of: e24ed04389f9 ("md: restore 'noio_flag' for the last mddev_resume()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 43 ++++++++++++++++++++++++-------------------
 drivers/md/md.h |  2 +-
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index abb6c03c85b29..1c44294c625a4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -370,10 +370,7 @@ static DEFINE_SPINLOCK(all_mddevs_lock);
 
 static bool is_md_suspended(struct mddev *mddev)
 {
-	if (mddev->suspended)
-		return true;
-	else
-		return false;
+	return percpu_ref_is_dying(&mddev->active_io);
 }
 /* Rather than calling directly into the personality make_request function,
  * IO requests come here first so that we can check if the device is
@@ -400,12 +397,10 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
 void md_handle_request(struct mddev *mddev, struct bio *bio)
 {
 check_suspended:
-	rcu_read_lock();
 	if (is_suspended(mddev, bio)) {
 		DEFINE_WAIT(__wait);
 		/* Bail out if REQ_NOWAIT is set for the bio */
 		if (bio->bi_opf & REQ_NOWAIT) {
-			rcu_read_unlock();
 			bio_wouldblock_error(bio);
 			return;
 		}
@@ -414,23 +409,19 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
 					TASK_UNINTERRUPTIBLE);
 			if (!is_suspended(mddev, bio))
 				break;
-			rcu_read_unlock();
 			schedule();
-			rcu_read_lock();
 		}
 		finish_wait(&mddev->sb_wait, &__wait);
 	}
-	atomic_inc(&mddev->active_io);
-	rcu_read_unlock();
+	if (!percpu_ref_tryget_live(&mddev->active_io))
+		goto check_suspended;
 
 	if (!mddev->pers->make_request(mddev, bio)) {
-		atomic_dec(&mddev->active_io);
-		wake_up(&mddev->sb_wait);
+		percpu_ref_put(&mddev->active_io);
 		goto check_suspended;
 	}
 
-	if (atomic_dec_and_test(&mddev->active_io) && is_md_suspended(mddev))
-		wake_up(&mddev->sb_wait);
+	percpu_ref_put(&mddev->active_io);
 }
 EXPORT_SYMBOL(md_handle_request);
 
@@ -478,11 +469,10 @@ void mddev_suspend(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (mddev->suspended++)
 		return;
-	synchronize_rcu();
 	wake_up(&mddev->sb_wait);
 	set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
-	smp_mb__after_atomic();
-	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
+	percpu_ref_kill(&mddev->active_io);
+	wait_event(mddev->sb_wait, percpu_ref_is_zero(&mddev->active_io));
 	mddev->pers->quiesce(mddev, 1);
 	clear_bit_unlock(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	wait_event(mddev->sb_wait, !test_bit(MD_UPDATING_SB, &mddev->flags));
@@ -500,6 +490,7 @@ void mddev_resume(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 	if (--mddev->suspended)
 		return;
+	percpu_ref_resurrect(&mddev->active_io);
 	wake_up(&mddev->sb_wait);
 	mddev->pers->quiesce(mddev, 0);
 
@@ -678,7 +669,6 @@ void mddev_init(struct mddev *mddev)
 	timer_setup(&mddev->safemode_timer, md_safemode_timeout, 0);
 	atomic_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
-	atomic_set(&mddev->active_io, 0);
 	spin_lock_init(&mddev->lock);
 	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
@@ -5786,6 +5776,12 @@ static void md_safemode_timeout(struct timer_list *t)
 }
 
 static int start_dirty_degraded;
+static void active_io_release(struct percpu_ref *ref)
+{
+	struct mddev *mddev = container_of(ref, struct mddev, active_io);
+
+	wake_up(&mddev->sb_wait);
+}
 
 int md_run(struct mddev *mddev)
 {
@@ -5866,10 +5862,15 @@ int md_run(struct mddev *mddev)
 		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
 
+	err = percpu_ref_init(&mddev->active_io, active_io_release,
+				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
+	if (err)
+		return err;
+
 	if (!bioset_initialized(&mddev->bio_set)) {
 		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 		if (err)
-			return err;
+			goto exit_active_io;
 	}
 	if (!bioset_initialized(&mddev->sync_set)) {
 		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
@@ -6057,6 +6058,8 @@ int md_run(struct mddev *mddev)
 	bioset_exit(&mddev->sync_set);
 exit_bio_set:
 	bioset_exit(&mddev->bio_set);
+exit_active_io:
+	percpu_ref_exit(&mddev->active_io);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6283,6 +6286,7 @@ void md_stop(struct mddev *mddev)
 	 */
 	__md_stop_writes(mddev);
 	__md_stop(mddev);
+	percpu_ref_exit(&mddev->active_io);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
 }
@@ -7852,6 +7856,7 @@ static void md_free_disk(struct gendisk *disk)
 	struct mddev *mddev = disk->private_data;
 
 	percpu_ref_exit(&mddev->writes_pending);
+	percpu_ref_exit(&mddev->active_io);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b4e2d8b87b611..64f8182a3dfc6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -315,7 +315,7 @@ struct mddev {
 	unsigned long			sb_flags;
 
 	int				suspended;
-	atomic_t			active_io;
+	struct percpu_ref		active_io;
 	int				ro;
 	int				sysfs_active; /* set when sysfs deletes
 						       * are happening, so run/
-- 
2.40.1



