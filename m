Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FE7212FB9;
	Mon, 29 Dec 2025 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025811; cv=none; b=kT9yeitXdzhUisyVkO9Maxf2LOS4Ve9ycy2oQ6EYAeWHBiT1C3Ib4xx4c78e9RkkCtx31Cu9N0Rpjev6vLx8eweGHK5LZ314ub52X1I09vyhCAuSy7oWdzTWwQDc5tuAEx7wXHxeUc8UtIsecorTUR8Nh2Vj1hknNSTHudE1PeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025811; c=relaxed/simple;
	bh=CuVhanL/zSOFbAXVWydEgJfgN+CtK9XlwkS/e6HugFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtTCTGQpzr261U9ZDMGBAN2Em243xYWoHP1zKxdK8IoZz6TUgukcd8VEWJlQX37UDUqUrjhc50yfEkjhVagSUX74kmhk4Z9gf2zKMJfLP+3jG7fKSl/cNp3vXeenLBhc2scqzsN9Ph/drHXrk0z4ooXjf86+7Syo/cC7MiOT0W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aX+uABoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aX+uABoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3310BC4CEF7;
	Mon, 29 Dec 2025 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025811;
	bh=CuVhanL/zSOFbAXVWydEgJfgN+CtK9XlwkS/e6HugFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aX+uABoETBc3iK5UAN6UvGufkbJa6fycWdNXcGXLKR2nS67zkmwwvuWYYwA+yUAUi
	 b6dNqEtCHAWmk/p3bMAIRNdNdAsQZEzQNpeHO/dSTpIqlvo/J7h3vmvRVF2odhuY8i
	 pl/qFPC2lBDStyVZZre7Lo04AUp4duMyXzD5VmiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	"Bai, Shuangpeng" <sjb7183@psu.edu>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 313/430] f2fs: fix to avoid updating compression context during writeback
Date: Mon, 29 Dec 2025 17:11:55 +0100
Message-ID: <20251229160735.848738303@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 10b591e7fb7cdc8c1e53e9c000dc0ef7069aaa76 upstream.

Bai, Shuangpeng <sjb7183@psu.edu> reported a bug as below:

Oops: divide error: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 11441 Comm: syz.0.46 Not tainted 6.17.0 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:f2fs_all_cluster_page_ready+0x106/0x550 fs/f2fs/compress.c:857
Call Trace:
 <TASK>
 f2fs_write_cache_pages fs/f2fs/data.c:3078 [inline]
 __f2fs_write_data_pages fs/f2fs/data.c:3290 [inline]
 f2fs_write_data_pages+0x1c19/0x3600 fs/f2fs/data.c:3317
 do_writepages+0x38e/0x640 mm/page-writeback.c:2634
 filemap_fdatawrite_wbc mm/filemap.c:386 [inline]
 __filemap_fdatawrite_range mm/filemap.c:419 [inline]
 file_write_and_wait_range+0x2ba/0x3e0 mm/filemap.c:794
 f2fs_do_sync_file+0x6e6/0x1b00 fs/f2fs/file.c:294
 generic_write_sync include/linux/fs.h:3043 [inline]
 f2fs_file_write_iter+0x76e/0x2700 fs/f2fs/file.c:5259
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x7e9/0xe00 fs/read_write.c:686
 ksys_write+0x19d/0x2d0 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf7/0x470 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The bug was triggered w/ below race condition:

fsync				setattr			ioctl
- f2fs_do_sync_file
 - file_write_and_wait_range
  - f2fs_write_cache_pages
  : inode is non-compressed
  : cc.cluster_size =
    F2FS_I(inode)->i_cluster_size = 0
   - tag_pages_for_writeback
				- f2fs_setattr
				 - truncate_setsize
				 - f2fs_truncate
							- f2fs_fileattr_set
							 - f2fs_setflags_common
							  - set_compress_context
							  : F2FS_I(inode)->i_cluster_size = 4
							  : set_inode_flag(inode, FI_COMPRESSED_FILE)
   - f2fs_compressed_file
   : return true
   - f2fs_all_cluster_page_ready
   : "pgidx % cc->cluster_size" trigger dividing 0 issue

Let's change as below to fix this issue:
- introduce a new atomic type variable .writeback in structure f2fs_inode_info
to track the number of threads which calling f2fs_write_cache_pages().
- use .i_sem lock to protect .writeback update.
- check .writeback before update compression context in f2fs_setflags_common()
to avoid race w/ ->writepages.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Cc: stable@kernel.org
Reported-by: Bai, Shuangpeng <sjb7183@psu.edu>
Tested-by: Bai, Shuangpeng <sjb7183@psu.edu>
Closes: https://lore.kernel.org/lkml/44D8F7B3-68AD-425F-9915-65D27591F93F@psu.edu
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c  |   17 +++++++++++++++++
 fs/f2fs/f2fs.h  |    3 ++-
 fs/f2fs/file.c  |    5 +++--
 fs/f2fs/super.c |    1 +
 4 files changed, 23 insertions(+), 3 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3224,6 +3224,19 @@ static inline bool __should_serialize_io
 	return false;
 }
 
+static inline void account_writeback(struct inode *inode, bool inc)
+{
+	if (!f2fs_sb_has_compression(F2FS_I_SB(inode)))
+		return;
+
+	f2fs_down_read(&F2FS_I(inode)->i_sem);
+	if (inc)
+		atomic_inc(&F2FS_I(inode)->writeback);
+	else
+		atomic_dec(&F2FS_I(inode)->writeback);
+	f2fs_up_read(&F2FS_I(inode)->i_sem);
+}
+
 static int __f2fs_write_data_pages(struct address_space *mapping,
 						struct writeback_control *wbc,
 						enum iostat_type io_type)
@@ -3269,10 +3282,14 @@ static int __f2fs_write_data_pages(struc
 		locked = true;
 	}
 
+	account_writeback(inode, true);
+
 	blk_start_plug(&plug);
 	ret = f2fs_write_cache_pages(mapping, wbc, io_type);
 	blk_finish_plug(&plug);
 
+	account_writeback(inode, false);
+
 	if (locked)
 		mutex_unlock(&sbi->writepages);
 
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -948,6 +948,7 @@ struct f2fs_inode_info {
 	unsigned char i_compress_level;		/* compress level (lz4hc,zstd) */
 	unsigned char i_compress_flag;		/* compress flag */
 	unsigned int i_cluster_size;		/* cluster size */
+	atomic_t writeback;			/* count # of writeback thread */
 
 	unsigned int atomic_write_cnt;
 	loff_t original_i_size;		/* original i_size before atomic write */
@@ -4675,7 +4676,7 @@ static inline bool f2fs_disable_compress
 		f2fs_up_write(&fi->i_sem);
 		return true;
 	}
-	if (f2fs_is_mmap_file(inode) ||
+	if (f2fs_is_mmap_file(inode) || atomic_read(&fi->writeback) ||
 		(S_ISREG(inode->i_mode) && F2FS_HAS_BLOCKS(inode))) {
 		f2fs_up_write(&fi->i_sem);
 		return false;
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2125,8 +2125,9 @@ static int f2fs_setflags_common(struct i
 
 			f2fs_down_write(&fi->i_sem);
 			if (!f2fs_may_compress(inode) ||
-					(S_ISREG(inode->i_mode) &&
-					F2FS_HAS_BLOCKS(inode))) {
+				atomic_read(&fi->writeback) ||
+				(S_ISREG(inode->i_mode) &&
+				F2FS_HAS_BLOCKS(inode))) {
 				f2fs_up_write(&fi->i_sem);
 				return -EINVAL;
 			}
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1759,6 +1759,7 @@ static struct inode *f2fs_alloc_inode(st
 	atomic_set(&fi->dirty_pages, 0);
 	atomic_set(&fi->i_compr_blocks, 0);
 	atomic_set(&fi->open_count, 0);
+	atomic_set(&fi->writeback, 0);
 	init_f2fs_rwsem(&fi->i_sem);
 	spin_lock_init(&fi->i_size_lock);
 	INIT_LIST_HEAD(&fi->dirty_list);


