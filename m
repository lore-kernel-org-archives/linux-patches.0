Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D54D1C68BE;
	Tue, 27 Aug 2024 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772301; cv=none; b=EkYETFjIFgf+S6Pkyng+WnNcuLlWnSZXoNBAu8cLff+5MIUNDZfvqFS80zjCv7xMDlPCCgK/2pGDOJLwsh+xtZohB+7Nxa4u0OC8wf7FJqSYwxtW8Ik8X9kcQKG1VftrBTXvPs3reJ920eN/csx0faCQjP9TsnGV0pxq9X3Pccc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772301; c=relaxed/simple;
	bh=kEBE5B24GjHpQrRaPn5HoluqGWIKJSh0Xl8IRPEN5mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftq0u8/pbQ2x4u36yZ1y/y4yyUz/SywaVrW3U+GOOXZ1mdfH+OaLYT1NVQQfYSoiGM7bCaxbxzz/zeExENFlMTOoDbGiOzWOp+MW37ruaotKqbD+F+zhGTTWTaPjdBBGYs/C9Z5R31EY3pwwLtCDYvlESGrOr4MUdwygYpFpAN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17W1w380; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17W1w380"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F689C61071;
	Tue, 27 Aug 2024 15:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772301;
	bh=kEBE5B24GjHpQrRaPn5HoluqGWIKJSh0Xl8IRPEN5mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17W1w380C/JiRj0nMSskdLLxIdBC9+iY7WHo816RpJshGRfOWApGksgDazCD5I9pL
	 O6VzHCXckQ4MeHevfWBxkm29wff3D5gi3mdAEDJa4BtDbJ0xTI4ydzk50Vv+8i54O2
	 GdfxiuAb8Zb+z6pyCO9WJiAFfzaYyzC2vvbFV7Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/321] md/raid5-cache: use READ_ONCE/WRITE_ONCE for conf->log
Date: Tue, 27 Aug 2024 16:37:20 +0200
Message-ID: <20240827143843.268804303@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 06a4d0d8c642b5ea654e832b74dca12965356da0 ]

'conf->log' is set with 'reconfig_mutex' grabbed, however, readers are
not procted, hence protect it with READ_ONCE/WRITE_ONCE to prevent
reading abnormal values.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231010151958.145896-3-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5-cache.c | 47 +++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index eb66d0bfe39d2..4b9585875a669 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -327,8 +327,9 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
 void r5c_check_stripe_cache_usage(struct r5conf *conf)
 {
 	int total_cached;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
-	if (!r5c_is_writeback(conf->log))
+	if (!r5c_is_writeback(log))
 		return;
 
 	total_cached = atomic_read(&conf->r5c_cached_partial_stripes) +
@@ -344,7 +345,7 @@ void r5c_check_stripe_cache_usage(struct r5conf *conf)
 	 */
 	if (total_cached > conf->min_nr_stripes * 1 / 2 ||
 	    atomic_read(&conf->empty_inactive_list_nr) > 0)
-		r5l_wake_reclaim(conf->log, 0);
+		r5l_wake_reclaim(log, 0);
 }
 
 /*
@@ -353,7 +354,9 @@ void r5c_check_stripe_cache_usage(struct r5conf *conf)
  */
 void r5c_check_cached_full_stripe(struct r5conf *conf)
 {
-	if (!r5c_is_writeback(conf->log))
+	struct r5l_log *log = READ_ONCE(conf->log);
+
+	if (!r5c_is_writeback(log))
 		return;
 
 	/*
@@ -363,7 +366,7 @@ void r5c_check_cached_full_stripe(struct r5conf *conf)
 	if (atomic_read(&conf->r5c_cached_full_stripes) >=
 	    min(R5C_FULL_STRIPE_FLUSH_BATCH(conf),
 		conf->chunk_sectors >> RAID5_STRIPE_SHIFT(conf)))
-		r5l_wake_reclaim(conf->log, 0);
+		r5l_wake_reclaim(log, 0);
 }
 
 /*
@@ -396,7 +399,7 @@ void r5c_check_cached_full_stripe(struct r5conf *conf)
  */
 static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	if (!r5c_is_writeback(log))
 		return 0;
@@ -449,7 +452,7 @@ static inline void r5c_update_log_state(struct r5l_log *log)
 void r5c_make_stripe_write_out(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	BUG_ON(!r5c_is_writeback(log));
 
@@ -491,7 +494,7 @@ static void r5c_handle_parity_cached(struct stripe_head *sh)
  */
 static void r5c_finish_cache_stripe(struct stripe_head *sh)
 {
-	struct r5l_log *log = sh->raid_conf->log;
+	struct r5l_log *log = READ_ONCE(sh->raid_conf->log);
 
 	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH) {
 		BUG_ON(test_bit(STRIPE_R5C_CACHING, &sh->state));
@@ -692,7 +695,7 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 
 	/* wait superblock change before suspend */
 	wait_event(mddev->sb_wait,
-		   conf->log == NULL ||
+		   !READ_ONCE(conf->log) ||
 		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
 		    (locked = mddev_trylock(mddev))));
 	if (locked) {
@@ -1151,7 +1154,7 @@ static void r5l_run_no_space_stripes(struct r5l_log *log)
 static sector_t r5c_calculate_new_cp(struct r5conf *conf)
 {
 	struct stripe_head *sh;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	sector_t new_cp;
 	unsigned long flags;
 
@@ -1159,12 +1162,12 @@ static sector_t r5c_calculate_new_cp(struct r5conf *conf)
 		return log->next_checkpoint;
 
 	spin_lock_irqsave(&log->stripe_in_journal_lock, flags);
-	if (list_empty(&conf->log->stripe_in_journal_list)) {
+	if (list_empty(&log->stripe_in_journal_list)) {
 		/* all stripes flushed */
 		spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
 		return log->next_checkpoint;
 	}
-	sh = list_first_entry(&conf->log->stripe_in_journal_list,
+	sh = list_first_entry(&log->stripe_in_journal_list,
 			      struct stripe_head, r5c);
 	new_cp = sh->log_start;
 	spin_unlock_irqrestore(&log->stripe_in_journal_lock, flags);
@@ -1399,7 +1402,7 @@ void r5c_flush_cache(struct r5conf *conf, int num)
 	struct stripe_head *sh, *next;
 
 	lockdep_assert_held(&conf->device_lock);
-	if (!conf->log)
+	if (!READ_ONCE(conf->log))
 		return;
 
 	count = 0;
@@ -1420,7 +1423,7 @@ void r5c_flush_cache(struct r5conf *conf, int num)
 
 static void r5c_do_reclaim(struct r5conf *conf)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	struct stripe_head *sh;
 	int count = 0;
 	unsigned long flags;
@@ -1549,7 +1552,7 @@ static void r5l_reclaim_thread(struct md_thread *thread)
 {
 	struct mddev *mddev = thread->mddev;
 	struct r5conf *conf = mddev->private;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	if (!log)
 		return;
@@ -1589,7 +1592,7 @@ void r5l_quiesce(struct r5l_log *log, int quiesce)
 
 bool r5l_log_disk_error(struct r5conf *conf)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	/* don't allow write if journal disk is missing */
 	if (!log)
@@ -2633,7 +2636,7 @@ int r5c_try_caching_write(struct r5conf *conf,
 			  struct stripe_head_state *s,
 			  int disks)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	int i;
 	struct r5dev *dev;
 	int to_cache = 0;
@@ -2800,7 +2803,7 @@ void r5c_finish_stripe_write_out(struct r5conf *conf,
 				 struct stripe_head *sh,
 				 struct stripe_head_state *s)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	int i;
 	int do_wakeup = 0;
 	sector_t tree_index;
@@ -2939,7 +2942,7 @@ int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)
 /* check whether this big stripe is in write back cache. */
 bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
 {
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 	sector_t tree_index;
 	void *slot;
 
@@ -3047,14 +3050,14 @@ int r5l_start(struct r5l_log *log)
 void r5c_update_on_rdev_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct r5conf *conf = mddev->private;
-	struct r5l_log *log = conf->log;
+	struct r5l_log *log = READ_ONCE(conf->log);
 
 	if (!log)
 		return;
 
 	if ((raid5_calc_degraded(conf) > 0 ||
 	     test_bit(Journal, &rdev->flags)) &&
-	    conf->log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_BACK)
+	    log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_BACK)
 		schedule_work(&log->disable_writeback_work);
 }
 
@@ -3143,7 +3146,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	spin_lock_init(&log->stripe_in_journal_lock);
 	atomic_set(&log->stripe_in_journal_count, 0);
 
-	conf->log = log;
+	WRITE_ONCE(conf->log, log);
 
 	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	return 0;
@@ -3171,7 +3174,7 @@ void r5l_exit_log(struct r5conf *conf)
 	 * 'reconfig_mutex' is held by caller, set 'confg->log' to NULL to
 	 * ensure disable_writeback_work wakes up and exits.
 	 */
-	conf->log = NULL;
+	WRITE_ONCE(conf->log, NULL);
 	wake_up(&conf->mddev->sb_wait);
 	flush_work(&log->disable_writeback_work);
 
-- 
2.43.0



