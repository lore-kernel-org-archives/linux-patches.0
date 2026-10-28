Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210438;
	b=YYS99mF1sY9nP6PM5hzCzsECgXlD+IbtMR88CaqHq87hcPJJs43aiSs4rSjJTHAu4ACx
	 tOKKJ36S52Fq5hoUTE5pDBvgDajkn5oCbCFGH+e0rpf50cDlEsYN8NwzewnK75Oo3ZJE3
	 aM+AlPNlDODWS6Y2hUFGI8b2SajjjU7os/1CNSazbpsqiPzLHWmBlr8xXF5wcL9nEgHJj
	 /XLt8JDC5M2cnjypmYi7evLgmtPRShlXOOQH63kX/bTr9OA8ongumQtrNYAdtiq2I4qdn
	 iRSJF+TmeeRHzWlUL0nDPXnA8lFp3EyxXdEzFXsXcWl7OYtwYszH8PDnucjGL4VgdgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7Su02u8XB3PMSbjg/o14FR+ATkMZHEya1Y7S5sA6Tis=;
	b=GkuHRWtmCenS0LLWuj37joUTYVfxGCisVDb79bX/MSE6CdmRo15NPJfQUQ+xa6hwP+nf
	 apPc35hl5+nN71FYsAqCFh8TErt0RAGtmacOo0vROoB8vjATvuQYZWcYpyL2OliAbGfZv
	 Pycj5N6FTBVNTr0tsR2HnHZw/NTK4AHPPd7TtNbDe5GZhVW7nycx+HD5oaQlnHxWKZktq
	 OBQIj+5XIvn1LqbuZJV48PAPoVJ+GPXYXI70f9P2kV6Nyd+WF+K1FtfcTqjZYW7uaoyFS
	 Go/wy0uqtSgncMObRYpEqpg4vMkl3iEDbEeCbpZyGSZP8YidFzpNcIy26EutWQRKUjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HzbQHccX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CE2606A31E;
	Wed, 28 Oct 2026 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HzbQHccX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBDE1F01825;
	Wed, 28 Oct 2026 18:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210437;
	bh=7Su02u8XB3PMSbjg/o14FR+ATkMZHEya1Y7S5sA6Tis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzbQHccXF4aTUVeJv4rgJg2brJRKsU3eFKF2gsLyr58l6aQFPQULrMksnbl7EoHU4
	 ZW5N82dckGsAYwCn+5ta5mwjwXRSaieF8jLu59iNcxnsWT76zJCBLrhr6SpwR3GrzQ
	 veb7C7OHy8lotWtdVVTrnXaDUXronMfz3GAtDaG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/571] f2fs: embed f2fs_gc_kthread in f2fs_sb_info
Date: Wed, 28 Oct 2026 17:52:53 +0100
Message-ID: <20261028170008.643561702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 3d7bca9d583793bb7d0bac0d95a24ddd2e129eed ]

Instead of allocating f2fs_gc_kthread dynamically, embed it in
f2fs_sb_info. This simplifies lifetime management and prepares for
fixing race conditions during teardown.

- __sbi_store			- remount|shutdown
				 - f2fs_stop_gc_thread
 - access sbi->gc_thread
				  - sbi->gc_thread = NULL
 - access sbi->gc_thread->f2fs_gc_task

Fixes: 52190933c37a ("f2fs: sysfs: introduce critical_task_priority")
Fixes: 7950e9ac638e ("f2fs: stop gc/discard thread after fs shutdown")
Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ adapted GC structure access changes to Linux 5.15’s existing fields and APIs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/debug.c   |  4 ----
 fs/f2fs/f2fs.h    | 22 +++++++++++++++++++++-
 fs/f2fs/gc.c      | 33 ++++++++++++---------------------
 fs/f2fs/gc.h      | 20 --------------------
 fs/f2fs/segment.c |  9 ++++-----
 fs/f2fs/super.c   |  4 ++--
 fs/f2fs/sysfs.c   |  8 ++++----
 7 files changed, 43 insertions(+), 57 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index cd21b4edeca1c..9298847d7549f 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -275,10 +275,6 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 get_cache:
 	si->cache_mem = 0;
 
-	/* build gc */
-	if (sbi->gc_thread)
-		si->cache_mem += sizeof(struct f2fs_gc_kthread);
-
 	/* build merge flush thread */
 	if (SM_I(sbi)->fcc_info)
 		si->cache_mem += sizeof(struct flush_cmd_control);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index fe17f10257371..bd13a38ab57fe 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1561,6 +1561,26 @@ struct decompress_io_ctx {
 #define MAX_COMPRESS_LOG_SIZE		8
 #define MAX_COMPRESS_WINDOW_SIZE(log_size)	((PAGE_SIZE) << (log_size))
 
+struct f2fs_gc_kthread {
+	struct task_struct *f2fs_gc_task;
+	wait_queue_head_t gc_wait_queue_head;
+
+	/* for gc sleep time */
+	unsigned int urgent_sleep_time;
+	unsigned int min_sleep_time;
+	unsigned int max_sleep_time;
+	unsigned int no_gc_sleep_time;
+
+	/* for changing gc mode */
+	unsigned int gc_wake;
+
+	/* for GC_MERGE mount option */
+	wait_queue_head_t fggc_wq;		/*
+						 * caller of f2fs_balance_fs()
+						 * will wait on this wait queue.
+						 */
+};
+
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
 	struct proc_dir_entry *s_proc;		/* proc entry */
@@ -1677,7 +1697,7 @@ struct f2fs_sb_info {
 						 * semaphore for GC, avoid
 						 * race between GC and GC or CP
 						 */
-	struct f2fs_gc_kthread	*gc_thread;	/* GC thread */
+	struct f2fs_gc_kthread gc_thread;	/* GC thread */
 	struct atgc_management am;		/* atgc management */
 	unsigned int cur_victim_sec;		/* current victim section num */
 	unsigned int gc_mode;			/* current GC state */
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 69a51fcfbead4..663835527298f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -30,9 +30,9 @@ static unsigned int count_bits(const unsigned long *addr,
 static int gc_thread_func(void *data)
 {
 	struct f2fs_sb_info *sbi = data;
-	struct f2fs_gc_kthread *gc_th = sbi->gc_thread;
-	wait_queue_head_t *wq = &sbi->gc_thread->gc_wait_queue_head;
-	wait_queue_head_t *fggc_wq = &sbi->gc_thread->fggc_wq;
+	struct f2fs_gc_kthread *gc_th = &sbi->gc_thread;
+	wait_queue_head_t *wq = &sbi->gc_thread.gc_wait_queue_head;
+	wait_queue_head_t *fggc_wq = &sbi->gc_thread.fggc_wq;
 	unsigned int wait_ms;
 
 	wait_ms = gc_th->min_sleep_time;
@@ -146,16 +146,10 @@ static int gc_thread_func(void *data)
 
 int f2fs_start_gc_thread(struct f2fs_sb_info *sbi)
 {
-	struct f2fs_gc_kthread *gc_th;
+	struct f2fs_gc_kthread *gc_th = &sbi->gc_thread;
 	dev_t dev = sbi->sb->s_bdev->bd_dev;
 	int err = 0;
 
-	gc_th = f2fs_kmalloc(sbi, sizeof(struct f2fs_gc_kthread), GFP_KERNEL);
-	if (!gc_th) {
-		err = -ENOMEM;
-		goto out;
-	}
-
 	gc_th->urgent_sleep_time = DEF_GC_THREAD_URGENT_SLEEP_TIME;
 	gc_th->min_sleep_time = DEF_GC_THREAD_MIN_SLEEP_TIME;
 	gc_th->max_sleep_time = DEF_GC_THREAD_MAX_SLEEP_TIME;
@@ -163,30 +157,27 @@ int f2fs_start_gc_thread(struct f2fs_sb_info *sbi)
 
 	gc_th->gc_wake = 0;
 
-	sbi->gc_thread = gc_th;
-	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
-	init_waitqueue_head(&sbi->gc_thread->fggc_wq);
-	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
+	init_waitqueue_head(&gc_th->gc_wait_queue_head);
+	init_waitqueue_head(&gc_th->fggc_wq);
+	gc_th->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
 			"f2fs_gc-%u:%u", MAJOR(dev), MINOR(dev));
 	if (IS_ERR(gc_th->f2fs_gc_task)) {
 		err = PTR_ERR(gc_th->f2fs_gc_task);
-		kfree(gc_th);
-		sbi->gc_thread = NULL;
+		gc_th->f2fs_gc_task = NULL;
 	}
-out:
 	return err;
 }
 
 void f2fs_stop_gc_thread(struct f2fs_sb_info *sbi)
 {
-	struct f2fs_gc_kthread *gc_th = sbi->gc_thread;
+	struct f2fs_gc_kthread *gc_th = &sbi->gc_thread;
 
-	if (!gc_th)
+	if (!gc_th->f2fs_gc_task)
 		return;
+
 	kthread_stop(gc_th->f2fs_gc_task);
+	gc_th->f2fs_gc_task = NULL;
 	wake_up_all(&gc_th->fggc_wq);
-	kfree(gc_th);
-	sbi->gc_thread = NULL;
 }
 
 static int select_gc_type(struct f2fs_sb_info *sbi, int gc_type)
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 3fe145e8e594f..f29c3ca07d70c 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -30,26 +30,6 @@
 /* Search max. number of dirty segments to select a victim segment */
 #define DEF_MAX_VICTIM_SEARCH 4096 /* covers 8GB */
 
-struct f2fs_gc_kthread {
-	struct task_struct *f2fs_gc_task;
-	wait_queue_head_t gc_wait_queue_head;
-
-	/* for gc sleep time */
-	unsigned int urgent_sleep_time;
-	unsigned int min_sleep_time;
-	unsigned int max_sleep_time;
-	unsigned int no_gc_sleep_time;
-
-	/* for changing gc mode */
-	unsigned int gc_wake;
-
-	/* for GC_MERGE mount option */
-	wait_queue_head_t fggc_wq;		/*
-						 * caller of f2fs_balance_fs()
-						 * will wait on this wait queue.
-						 */
-};
-
 struct gc_inode_list {
 	struct list_head ilist;
 	struct radix_tree_root iroot;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 6c47cebbd0f11..0d10bea639372 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -522,15 +522,14 @@ void f2fs_balance_fs(struct f2fs_sb_info *sbi, bool need)
 		f2fs_submit_merged_write(sbi, DATA);
 		f2fs_submit_all_merged_ipu_writes(sbi);
 
-		if (test_opt(sbi, GC_MERGE) && sbi->gc_thread &&
-					sbi->gc_thread->f2fs_gc_task) {
+		if (test_opt(sbi, GC_MERGE) && sbi->gc_thread.f2fs_gc_task) {
 			DEFINE_WAIT(wait);
 
-			prepare_to_wait(&sbi->gc_thread->fggc_wq, &wait,
+			prepare_to_wait(&sbi->gc_thread.fggc_wq, &wait,
 						TASK_UNINTERRUPTIBLE);
-			wake_up(&sbi->gc_thread->gc_wait_queue_head);
+			wake_up(&sbi->gc_thread.gc_wait_queue_head);
 			io_schedule();
-			finish_wait(&sbi->gc_thread->fggc_wq, &wait);
+			finish_wait(&sbi->gc_thread.fggc_wq, &wait);
 		} else {
 			down_write(&sbi->gc_lock);
 			f2fs_gc(sbi, false, false, false, NULL_SEGNO);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 757f0bd843dde..a40dc08b3a1e8 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2349,11 +2349,11 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	if ((*flags & SB_RDONLY) ||
 			(F2FS_OPTION(sbi).bggc_mode == BGGC_MODE_OFF &&
 			!test_opt(sbi, GC_MERGE))) {
-		if (sbi->gc_thread) {
+		if (sbi->gc_thread.f2fs_gc_task) {
 			f2fs_stop_gc_thread(sbi);
 			need_restart_gc = true;
 		}
-	} else if (!sbi->gc_thread) {
+	} else if (!sbi->gc_thread.f2fs_gc_task) {
 		err = f2fs_start_gc_thread(sbi);
 		if (err)
 			goto restore_opts;
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index cb13d47725432..70bdc2a6a5a24 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -58,7 +58,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 static unsigned char *__struct_ptr(struct f2fs_sb_info *sbi, int struct_type)
 {
 	if (struct_type == GC_THREAD)
-		return (unsigned char *)sbi->gc_thread;
+		return (unsigned char *)&sbi->gc_thread;
 	else if (struct_type == SM_INFO)
 		return (unsigned char *)SM_I(sbi);
 	else if (struct_type == DCC_INFO)
@@ -499,10 +499,10 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 			sbi->gc_mode = GC_NORMAL;
 		} else if (t == 1) {
 			sbi->gc_mode = GC_URGENT_HIGH;
-			if (sbi->gc_thread) {
-				sbi->gc_thread->gc_wake = 1;
+			if (sbi->gc_thread.f2fs_gc_task) {
+				sbi->gc_thread.gc_wake = 1;
 				wake_up_interruptible_all(
-					&sbi->gc_thread->gc_wait_queue_head);
+					&sbi->gc_thread.gc_wait_queue_head);
 				wake_up_discard_thread(sbi, true);
 			}
 		} else if (t == 2) {
-- 
2.53.0



