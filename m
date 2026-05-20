Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE1E40C5A3;
	Wed, 20 May 2026 18:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303051; cv=none; b=UO/dOc6TuL+wLzqME0t0plGbp0BVkq6LzZrTD0+giQfts8V836rQJu86KJ1zZjcpnk+AxAwYMN+4+zRJ30NH54PkmMw8iLVMRo7Io4zZ7YcCBZ+Clj7cNrBknGV/HIDNQfnBr1D7KFbo0Cf8/MLVEXvsuoD7st0skoIDsKXyk+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303051; c=relaxed/simple;
	bh=2F3FO3DwYa5I86U1S5bxcfDJHAdd11qltWNoG/rJok4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CP4Fo2g00z1VbWOvy8kdf1mGkPWY50raAKMbVNRyWdywZk8ypkT6ITC9/TvxdQ9GEU4iuStrYt4eV5cLaH12OPzyk18oYukZQW7YSlQIqPs2Y9I0nmcbRYOLTrZGAlwfluI0AmqaosRyyLxPvYAfnVcE3fxcg3VOEAE14HlxQrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJ/Cwnhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJ/Cwnhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CDD1F00893;
	Wed, 20 May 2026 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303048;
	bh=zqtXR3UHNDini7MJoDup2XdIA5RGTv8nfX+FuDWOsDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJ/CwnhxWHIWu8CxuqGpMjI5QbhvYlJ+fSqdkIZ1gM7WZ0m6t0kbn2DCe0BQJooPj
	 cFthylRFH4gBsJkBMWayn3u4wPSpXcvjyIWHd7RiRgNuF8xcttwo0VrHLFN4eKCFfy
	 NkySrkLy6h96dwh0H6hj2rJWE5bZkEdVEB8rmx0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 499/508] f2fs: fix false alarm of lockdep on cp_global_sem lock
Date: Wed, 20 May 2026 18:25:22 +0200
Message-ID: <20260520162109.412331040@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1824,6 +1824,9 @@ struct f2fs_sb_info {
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
@@ -1695,6 +1695,9 @@ static void f2fs_put_super(struct super_
 #if IS_ENABLED(CONFIG_UNICODE)
 	utf8_unload(sb->s_encoding);
 #endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 	kfree(sbi);
 }
 
@@ -4380,6 +4383,11 @@ try_onemore:
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
@@ -4838,6 +4846,9 @@ free_sb_buf:
 free_sbi:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 	kfree(sbi);
 
 	/* give only one another chance */


