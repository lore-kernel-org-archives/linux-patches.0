Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6615169AD2;
	Tue, 16 Jun 2026 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634978; cv=none; b=tcr0lo3RhEZzjQpSbHLHO+rY0ar6UB464YKjaD/6jHu17wdInxs+i1SpFORjcnd6/EDXBk5b1WxGSh/5U/zkxHWPhkC97Ek2gum1A+BM7+AptkmuKm52An0CHk5hcMOlZPA3VEScNZkScxXfBuzxkZr1RVnb3efkCeSqbSyCay8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634978; c=relaxed/simple;
	bh=Cob6JLo9Wy97eZ1bPdpE79srGsCdMbFs0A02Kktbq0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEEKWNqQGqzrUBoFN48Y13xGZ+TFhd8Oe1zWVWFt3TWkTaLZU5+Bl73TmeoRTN3lPDOOJQcvPqD7mcI/JFxd++etJvZnE9H2/0U97Bg3C30xUaC2x7qxhXDyuin8Ng4ft3mdlxypLm1uRV6b8hRqtE+198THP/fHIzPv92yuI9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydMJAPK+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydMJAPK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5453B1F000E9;
	Tue, 16 Jun 2026 18:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634977;
	bh=zsQY21QLSUrDNwgG9IHWwBgFJxscvA70qKbgFR4Nmic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydMJAPK+y+Rpep2/kgHqz0M6fTIVZW94eK3UUkzQo7eoGi2bXjtuE6EP3UIwQ6Wgn
	 656KpucGBrQ70W6Ix4ITsnibefkFhD1NIFRJ9tUR5qyZcBpGx6rZNdIFJEBfuqdqNd
	 evsWXQIyZFKycHfx+zG5aE91cbRmQx+JWr/w2xlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 334/411] f2fs: fix false alarm of lockdep on cp_global_sem lock
Date: Tue, 16 Jun 2026 20:29:32 +0530
Message-ID: <20260616145118.916496425@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted to plain `struct rw_semaphore` (no `f2fs_rwsem` wrapper) and moved success-path `lockdep_unregister_key` from `kill_f2fs_super` to `f2fs_put_super` where sbi is actually freed ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |    3 +++
 fs/f2fs/super.c |   11 +++++++++++
 2 files changed, 14 insertions(+)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1798,6 +1798,9 @@ struct f2fs_sb_info {
 	spinlock_t iostat_lat_lock;
 	struct iostat_lat_info *iostat_io_lat;
 #endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key cp_global_sem_key;
+#endif
 };
 
 struct f2fs_private_dio {
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1668,6 +1668,9 @@ static void f2fs_put_super(struct super_
 #ifdef CONFIG_UNICODE
 	utf8_unload(sb->s_encoding);
 #endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 	kfree(sbi);
 }
 
@@ -4123,6 +4126,11 @@ try_onemore:
 	init_rwsem(&sbi->gc_lock);
 	mutex_init(&sbi->writepages);
 	init_rwsem(&sbi->cp_global_sem);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_register_key(&sbi->cp_global_sem_key);
+	lockdep_set_class(&sbi->cp_global_sem,
+					&sbi->cp_global_sem_key);
+#endif
 	init_rwsem(&sbi->node_write);
 	init_rwsem(&sbi->node_change);
 
@@ -4524,6 +4532,9 @@ free_sb_buf:
 free_sbi:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	lockdep_unregister_key(&sbi->cp_global_sem_key);
+#endif
 	kfree(sbi);
 
 	/* give only one another chance */


