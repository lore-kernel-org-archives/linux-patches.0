Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2BB371048;
	Wed, 20 May 2026 18:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301748; cv=none; b=Gaz6lObGoTASIkZqFo1BlWil7LKl9rM+yXvGyLUxef5zNBVRikxjKtH7XS228KSpJqOF7uK1tm9HlV2qMPDhAJEgMcyBNP/2QOQTQZg7b/o3EG5sUNgVNm7Aprf96hpC/83ONWflqMedto/N179U9cBHQJamOftwgZ4mfz04hmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301748; c=relaxed/simple;
	bh=MZAcWi0r7+kKpnAA7r7nbdivguIBnIJ8WhBxaRTiZPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Snvk7UECZ2BcmzAkXeXjhtSyLSSWPKQIZ82CL4q2rJWTmwwsGtuRcJFfnOrrjNzq9UaJ820lT+cFBC5Zh4INMiTD/HCd6Y7QjPyZQ6E/hxPjTRCnvXRK9onFTVJy4/iqn6GWAhDwF7TtadtazooBySbCK3uAbrw/BXzbMmdcEQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApujYdBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApujYdBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B871F00893;
	Wed, 20 May 2026 18:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301747;
	bh=sS9FdlKYetLsnAltaek6nUAzqHxLhLiZXrN94Jz+KPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApujYdBCLcreGrHF8kHr4QUM8X/dyhoLgCMfn6cxxkEvU0lqeRmD/MLLAVfXKp8xv
	 UHcp47DNGlo0mrVFZBeV6blpUkidMMmcHdN7ay3GAD7znBtwmsRg2dMPt5rj3ha+GD
	 +CxhgSfoMVCHj/+R54qVaVN0rqnL6mrDfuqEQ3BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 661/666] f2fs: fix false alarm of lockdep on cp_global_sem lock
Date: Wed, 20 May 2026 18:24:32 +0200
Message-ID: <20260520162125.616553719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted context to use `init_f2fs_rwsem()` instead of the not-yet-backported `init_f2fs_rwsem_trace()` macro ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |    3 +++
 fs/f2fs/super.c |   11 +++++++++++
 2 files changed, 14 insertions(+)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1858,6 +1858,9 @@ struct f2fs_sb_info {
 	spinlock_t iostat_lat_lock;
 	struct iostat_lat_info *iostat_io_lat;
 #endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key cp_global_sem_key;
+#endif
 };
 
 /* Definitions to access f2fs_sb_info */
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4490,6 +4490,11 @@ try_onemore:
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
@@ -4963,6 +4968,9 @@ free_sb_buf:
 free_sbi:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 
@@ -5015,6 +5023,9 @@ static void kill_f2fs_super(struct super
 	/* Release block devices last, after fscrypt_destroy_keyring(). */
 	if (sbi) {
 		destroy_device_list(sbi);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+		lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 		kfree(sbi);
 		sb->s_fs_info = NULL;
 	}


