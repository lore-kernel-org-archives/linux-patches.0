Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208175;
	b=Hp8iFY3AUZCkbZ8UlmcQadDXEzkgUrxRZw3NU1Pj2dhibyZLt+IUVOZLHmeihEZVY68/
	 vcf47jEUB2h55DAKxQKI5g+lmP1+aJrn4T8+SylU71bqMbJgms6ffBEYwSW255VMNVYYs
	 gDh6bUEDv6GqV5hxNgloRW3wJcdltDfYNVcdkKrRXDIXIjuHuK0Kohtl/uKVlWR8vGsS+
	 sEmh4bN/HAKEnUSaEqNnezoCI4oS06HpM0VGONeJEyL1TWULzrr/MPu7Fl//Y/zA3HnLj
	 kboQPqPUmFsG54y/gisCazAYiQeMMmtaBZBayNsUDLrwf0JKu/dl+UKupnpOO18owLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1thoqaDWiTRKC/JDp5xQPTQ9TF2CUHr+51i6P03GQA=;
	b=en/kgwSa8afHFmnmPexu6RCbmC63RBok6XDnwhK0+n39ZX4TxUcecf+7oR7b6/G+WS9K
	 LFOPz04xowiSTu2mol0/W6eugJbbgtcVCwo/6HLXq20iLdSSDAXsh3mc01F7HKoAhKUWK
	 ifufo7DeDbzZrgezsVwBr3eBi61wSrbjIGzyRYUoBCR6Z9S2GavqqjufvKAxRcPjHHvFs
	 ozC6Snbt0v+3H2aDy/TB0OYKej0dGX/+LT/JJODsqlJZTuN9IxOTpnAN++OhSBWC3+Q18
	 zJNIh2bmRH/alPEYyepnwWvEdH7PR5T5uwNIikeczxJ/N+lMulKYwUUeGmYm5NpQm2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDDDQpmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BCF606A31C;
	Wed, 28 Oct 2026 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QDDDQpmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517AF1F01828;
	Wed, 28 Oct 2026 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208174;
	bh=N1thoqaDWiTRKC/JDp5xQPTQ9TF2CUHr+51i6P03GQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDDDQpmiizZoAEZPf9QLA9IHwCJuF2pBqnnq8YvhcQzqTRCWkl+/kP8IesqoOcMSZ
	 eyo0eWXhpZnnrxKcgA4EKkz88cDjZWQ2DFsEh8U0JqclQI63LREvU7fHiN90jCc4gE
	 D0XV77Do9XZx5JFo88FWs0badq2xN7qGqtDIUdDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/516] f2fs: embed f2fs_gc_kthread in f2fs_sb_info
Date: Wed, 28 Oct 2026 17:52:59 +0100
Message-ID: <20261028170004.171600545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Omitted hunks for upstream GC features absent from Linux 5.10. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/debug.c |  4 ----
 fs/f2fs/f2fs.h  | 16 +++++++++++++++-
 fs/f2fs/gc.c    | 30 +++++++++++-------------------
 fs/f2fs/gc.h    | 14 --------------
 fs/f2fs/super.c |  4 ++--
 fs/f2fs/sysfs.c |  8 ++++----
 6 files changed, 32 insertions(+), 44 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 5f52d004105ae..4e2a350ca8457 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -261,10 +261,6 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
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
index 948e3512f60ff..cead30cab94bc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1373,6 +1373,20 @@ struct decompress_io_ctx {
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
+};
+
 struct f2fs_sb_info {
 	struct super_block *sb;			/* pointer to VFS super block */
 	struct proc_dir_entry *s_proc;		/* proc entry */
@@ -1488,7 +1502,7 @@ struct f2fs_sb_info {
 						 * semaphore for GC, avoid
 						 * race between GC and GC or CP
 						 */
-	struct f2fs_gc_kthread	*gc_thread;	/* GC thread */
+	struct f2fs_gc_kthread gc_thread;	/* GC thread */
 	struct atgc_management am;		/* atgc management */
 	unsigned int cur_victim_sec;		/* current victim section num */
 	unsigned int gc_mode;			/* current GC state */
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 379839f5b4b74..651dd392b5b93 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -30,8 +30,8 @@ static unsigned int count_bits(const unsigned long *addr,
 static int gc_thread_func(void *data)
 {
 	struct f2fs_sb_info *sbi = data;
-	struct f2fs_gc_kthread *gc_th = sbi->gc_thread;
-	wait_queue_head_t *wq = &sbi->gc_thread->gc_wait_queue_head;
+	struct f2fs_gc_kthread *gc_th = &sbi->gc_thread;
+	wait_queue_head_t *wq = &sbi->gc_thread.gc_wait_queue_head;
 	unsigned int wait_ms;
 
 	wait_ms = gc_th->min_sleep_time;
@@ -130,16 +130,10 @@ static int gc_thread_func(void *data)
 
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
@@ -147,27 +141,25 @@ int f2fs_start_gc_thread(struct f2fs_sb_info *sbi)
 
 	gc_th->gc_wake= 0;
 
-	sbi->gc_thread = gc_th;
-	init_waitqueue_head(&sbi->gc_thread->gc_wait_queue_head);
-	sbi->gc_thread->f2fs_gc_task = kthread_run(gc_thread_func, sbi,
+	init_waitqueue_head(&gc_th->gc_wait_queue_head);
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
-	if (!gc_th)
+	struct f2fs_gc_kthread *gc_th = &sbi->gc_thread;
+
+	if (!gc_th->f2fs_gc_task)
 		return;
+
 	kthread_stop(gc_th->f2fs_gc_task);
-	kfree(gc_th);
-	sbi->gc_thread = NULL;
+	gc_th->f2fs_gc_task = NULL;
 }
 
 static int select_gc_type(struct f2fs_sb_info *sbi, int gc_type)
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 0c8dae12dc512..f29c3ca07d70c 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -30,20 +30,6 @@
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
-};
-
 struct gc_inode_list {
 	struct list_head ilist;
 	struct radix_tree_root iroot;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8ab7d3f9a764b..ad0f29f579463 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1982,11 +1982,11 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	 */
 	if ((*flags & SB_RDONLY) ||
 			F2FS_OPTION(sbi).bggc_mode == BGGC_MODE_OFF) {
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
index f57df76ee71cc..f777c3285fa14 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -53,7 +53,7 @@ static ssize_t f2fs_sbi_show(struct f2fs_attr *a,
 static unsigned char *__struct_ptr(struct f2fs_sb_info *sbi, int struct_type)
 {
 	if (struct_type == GC_THREAD)
-		return (unsigned char *)sbi->gc_thread;
+		return (unsigned char *)&sbi->gc_thread;
 	else if (struct_type == SM_INFO)
 		return (unsigned char *)SM_I(sbi);
 	else if (struct_type == DCC_INFO)
@@ -406,10 +406,10 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
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



