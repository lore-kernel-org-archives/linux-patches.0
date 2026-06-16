Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACA1257827;
	Tue, 16 Jun 2026 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632525; cv=none; b=R1XWz/lpq2PtOwy6gFv3IYxBbC+9q920h0t9ztC9gBc+b1eqUPE1/jiea4ksgUY+9X7awpMrAqAeN6JzccwDOFYbBX1ZzrP1aAgVJOptg8dKkDNtsRHVbOpvqCJMBifb2x1UDj8eYnrUj4UxrZGp6bE9++ENUwCwF2zcjfq+TDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632525; c=relaxed/simple;
	bh=zphiyY3nkib69TGv9Q0bTIA/Lf/1lvTqOJvp3/VgPhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWStETucwwwbucUTbLkeIvBYhoFSLJaQkV9UtAij5RCZt4BPFVJLfOQjcj42o4yyG7oyvEEJU+bBAi4tzI2BPYHzz8tHgYvo+blQI10DtmbYfg+5fPW8LM7EgftdkcBsVHvV5lRgkA9xq1aOto5Q+9Wm6rl1e2ytOPuDBcWjjz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7Y9hvTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7Y9hvTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1B91F000E9;
	Tue, 16 Jun 2026 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632524;
	bh=KeuQsRp4+Olz9J+8ihk++1CiLwCtcWf0nra41ufI2Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7Y9hvTnp5VnnNg0CIoCFgwjZLwRKaPHG858XlC7MpLInocAAMueBCdCMz9fNa0yT
	 wghWhNikF0Mya+1nGycainngbRecKRxqMTXaf9MpcuPHymvEphTxJsUq3EV6xESyz7
	 KOhd9oBnTaqR0L0RivgVEQeSQ54Pd/ghrdhCi/aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 427/522] f2fs: fix false alarm of lockdep on cp_global_sem lock
Date: Tue, 16 Jun 2026 20:29:34 +0530
Message-ID: <20260616145145.957037049@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 6a5e3de9c2bb0b691d16789a5d19e9276a09b308 ]

lockdep reported a potential deadlock:

a) TCMU device removal context:
 - call del_gendisk() to get q->q_usage_counter
 - call start_flush_work() to get work_completion of wb->dwork
b) f2fs writeback context:
 - in wb_workfn(), which holds work_completion of wb->dwork
 - call f2fs_balance_fs() to get sbi->gc_lock
c) f2fs vfs_write context:
 - call f2fs_gc() to get sbi->gc_lock
 - call f2fs_write_checkpoint() to get sbi->cp_global_sem
d) f2fs mount context:
 - call recover_fsync_data() to get sbi->cp_global_sem
 - call f2fs_check_and_fix_write_pointer() to call blkdev_report_zones()
   that goes down to blk_mq_alloc_request and get q->q_usage_counter

Original callstack is in Closes tag.

However, I think this is a false alarm due to before mount returns
successfully (context d), we can not access file therein via vfs_write
(context c).

Let's introduce per-sb cp_global_sem_key, and assign the key for
cp_global_sem, so that lockdep can recognize cp_global_sem from
different super block correctly.

A lot of work are done by Shin'ichiro Kawasaki, thanks a lot for
the work.

Fixes: c426d99127b1 ("f2fs: Check write pointer consistency of open zones")
Cc: stable@kernel.org
Reported-and-tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/20260218125237.3340441-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ re-anchored lockdep_register_key after init_f2fs_rwsem and placed lockdep_unregister_key before kfree(sbi) in f2fs_put_super instead of kill_f2fs_super ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |    3 +++
 fs/f2fs/super.c |   11 +++++++++++
 2 files changed, 14 insertions(+)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1853,6 +1853,9 @@ struct f2fs_sb_info {
 	spinlock_t iostat_lat_lock;
 	struct iostat_lat_info *iostat_io_lat;
 #endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key cp_global_sem_key;
+#endif
 };
 
 #ifdef CONFIG_F2FS_FAULT_INJECTION
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1687,6 +1687,9 @@ static void f2fs_put_super(struct super_
 #if IS_ENABLED(CONFIG_UNICODE)
 	utf8_unload(sb->s_encoding);
 #endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 	kfree(sbi);
 }
 
@@ -4188,6 +4191,11 @@ try_onemore:
 	init_f2fs_rwsem(&sbi->gc_lock);
 	mutex_init(&sbi->writepages);
 	init_f2fs_rwsem(&sbi->cp_global_sem);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_register_key(&sbi->cp_global_sem_key);
+	lockdep_set_class(&sbi->cp_global_sem.internal_rwsem,
+					&sbi->cp_global_sem_key);
+#endif
 	init_f2fs_rwsem(&sbi->node_write);
 	init_f2fs_rwsem(&sbi->node_change);
 	spin_lock_init(&sbi->stat_lock);
@@ -4651,6 +4659,9 @@ free_sb_buf:
 free_sbi:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 	kfree(sbi);
 
 	/* give only one another chance */


