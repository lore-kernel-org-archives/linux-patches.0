Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BEB183CD4;
	Mon, 12 Aug 2024 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480074; cv=none; b=JxxJAGHsmur/Jvof8rlpbQsWdxB7WoKFbE5cWCINqVZdyv6Rq88pGQjEmDyIqgaY81j8CEjmcFj490Z5ZU32t/PDwEKLyRrRvY8ZSWBk0QdNkHY5rKPe47ZmwWo2NrNRODvnnRD6h3rLZKcFyu/8uMn9xjiHxitvR2wE9GeziKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480074; c=relaxed/simple;
	bh=yr6Vc2Zr272Tf33vQiwOaVIujNN3W/Lm+qJ1z0eT1gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYmV7AsRoe3evCv1o2J2svmLaMHmQSRyqkH1jd8gMUoPs+BVKsX+uafCXWbPe1diTiqIq+fvnsDNHU21j6CiM1fByIzakAUUtbhypy7mCehVWgP4KUpYLqyN8bxXJo2HVBRXamQsYXqQXZJDErO9DqkqtYB35zuAfdmxZVrkbOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJz8JW3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJz8JW3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DF3C32782;
	Mon, 12 Aug 2024 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480074;
	bh=yr6Vc2Zr272Tf33vQiwOaVIujNN3W/Lm+qJ1z0eT1gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJz8JW3tDIoB8bb8w3R+GbAkOzCWGLT6zX0dP1wvJ0uae67tee0P4MxRBU3vlZ0Rf
	 cErchpIUp6TcxQrpa4sAX4iP4OhK126muXZHqbWa6UyLoDeBf5fej7IxhWfFmxRZTR
	 aej8AxjEQ9ZDx5aIRSvb8MUTGeIC5pi1+84Y7NcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 047/263] md: change the return value type of md_write_start to void
Date: Mon, 12 Aug 2024 18:00:48 +0200
Message-ID: <20240812160148.345614106@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 03e792eaf18ec2e93e2c623f9f1a4bdb97fe4126 ]

Commit cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and
md_write_start()") aborted md_write_start() with false when mddev is
suspended, which fixed a deadlock if calling mddev_suspend() with
holding reconfig_mutex(). Since mddev_suspend() now includes
lockdep_assert_not_held(), it no longer holds the reconfig_mutex. This
makes previous abort unnecessary. Now, remove unnecessary abort and
change function return value to void.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240525185257.3896201-2-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c     | 14 ++++----------
 drivers/md/md.h     |  2 +-
 drivers/md/raid1.c  |  3 +--
 drivers/md/raid10.c |  3 +--
 drivers/md/raid5.c  |  3 +--
 5 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 60a5fda7c8aea..a5b5801baa9e8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8638,12 +8638,12 @@ EXPORT_SYMBOL(md_done_sync);
  * A return value of 'false' means that the write wasn't recorded
  * and cannot proceed as the array is being suspend.
  */
-bool md_write_start(struct mddev *mddev, struct bio *bi)
+void md_write_start(struct mddev *mddev, struct bio *bi)
 {
 	int did_change = 0;
 
 	if (bio_data_dir(bi) != WRITE)
-		return true;
+		return;
 
 	BUG_ON(mddev->ro == MD_RDONLY);
 	if (mddev->ro == MD_AUTO_READ) {
@@ -8676,15 +8676,9 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
 	if (did_change)
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 	if (!mddev->has_superblocks)
-		return true;
+		return;
 	wait_event(mddev->sb_wait,
-		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
-		   is_md_suspended(mddev));
-	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
-		percpu_ref_put(&mddev->writes_pending);
-		return false;
-	}
-	return true;
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 }
 EXPORT_SYMBOL(md_write_start);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ca085ecad5044..487582058f741 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -785,7 +785,7 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
 extern void md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
-extern bool md_write_start(struct mddev *mddev, struct bio *bi);
+extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 22bbd06ba6a29..5ea57b6748c53 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1688,8 +1688,7 @@ static bool raid1_make_request(struct mddev *mddev, struct bio *bio)
 	if (bio_data_dir(bio) == READ)
 		raid1_read_request(mddev, bio, sectors, NULL);
 	else {
-		if (!md_write_start(mddev,bio))
-			return false;
+		md_write_start(mddev,bio);
 		raid1_write_request(mddev, bio, sectors);
 	}
 	return true;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a4556d2e46bf9..f8d7c02c6ed56 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1836,8 +1836,7 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 	    && md_flush_request(mddev, bio))
 		return true;
 
-	if (!md_write_start(mddev, bio))
-		return false;
+	md_write_start(mddev, bio);
 
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD))
 		if (!raid10_handle_discard(mddev, bio))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1c6b58adec133..d600030c20f46 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6097,8 +6097,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 		ctx.do_flush = bi->bi_opf & REQ_PREFLUSH;
 	}
 
-	if (!md_write_start(mddev, bi))
-		return false;
+	md_write_start(mddev, bi);
 	/*
 	 * If array is degraded, better not do chunk aligned read because
 	 * later we might have to read it again in order to reconstruct
-- 
2.43.0



