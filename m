Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9323E1D9341;
	Tue,  3 Dec 2024 14:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237839; cv=none; b=tsxTgBSP4sUrWwN/sGE4hchCVwCdwDGRQ/Iz2B3ElYS1u0a1E6WaCD1ewt+tvPP8UrK8clBDG1K5Tlw0aEc/Z0PG4XaT+UYPvoFLav4a0l3PaxP2mYdydGZNqc1JXJxLt88XxiYjkStJ8DSEwGGlgMM1l9BIYaANiX/IKpsvvu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237839; c=relaxed/simple;
	bh=wDdjKVwOSZ/2f73YHz0e7pwjlRFaNoblvUG0Jl+6ZR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDheJH5a6M1+37Fp3lQaMHfGp2kgZVdfaeO/DKTsLDwMAQNsg64UnDBQuabY49aucMTYhzxSrkVXb6xhh8N270YFNTWAJUv7m+MkBdH+2/zL0EAOxN5tmgg6lqJ948ekoaMgXfv8oCm6PirUJ6DAh3OFxtQ9lAqM7CqGH2WbILQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4f97xWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4f97xWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72278C4CECF;
	Tue,  3 Dec 2024 14:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237839;
	bh=wDdjKVwOSZ/2f73YHz0e7pwjlRFaNoblvUG0Jl+6ZR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4f97xWn3g1fCB72Gu7oCEerUVBit3jX1WsGhMvlpEJp9tUoB38be5sHXSTw5eoW+
	 h88hnCcI6cxg6+oFpFk6lHlgcZOiUtyP/0XSTyuRCeRKEygU9+8KZjs3XhJaQA/dzW
	 Lbp+rI3HKLBqfXwvgtV125TbJm3dqqv/wmhD9HSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 085/817] ext4: fix race in buffer_head read fault injection
Date: Tue,  3 Dec 2024 15:34:17 +0100
Message-ID: <20241203143959.017207225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 2f3d93e210b9c2866c8b3662adae427d5bf511ec ]

When I enabled ext4 debug for fault injection testing, I encountered the
following warning:

  EXT4-fs error (device sda): ext4_read_inode_bitmap:201: comm fsstress:
         Cannot read inode bitmap - block_group = 8, inode_bitmap = 1051
  WARNING: CPU: 0 PID: 511 at fs/buffer.c:1181 mark_buffer_dirty+0x1b3/0x1d0

The root cause of the issue lies in the improper implementation of ext4's
buffer_head read fault injection. The actual completion of buffer_head
read and the buffer_head fault injection are not atomic, which can lead
to the uptodate flag being cleared on normally used buffer_heads in race
conditions.

[CPU0]           [CPU1]         [CPU2]
ext4_read_inode_bitmap
  ext4_read_bh()
  <bh read complete>
                 ext4_read_inode_bitmap
                   if (buffer_uptodate(bh))
                     return bh
                               jbd2_journal_commit_transaction
                                 __jbd2_journal_refile_buffer
                                   __jbd2_journal_unfile_buffer
                                     __jbd2_journal_temp_unlink_buffer
  ext4_simulate_fail_bh()
    clear_buffer_uptodate
                                      mark_buffer_dirty
                                        <report warning>
                                        WARN_ON_ONCE(!buffer_uptodate(bh))

The best approach would be to perform fault injection in the IO completion
callback function, rather than after IO completion. However, the IO
completion callback function cannot get the fault injection code in sb.

Fix it by passing the result of fault injection into the bh read function,
we simulate faults within the bh read function itself. This requires adding
an extra parameter to the bh read functions that need fault injection.

Fixes: 46f870d690fe ("ext4: simulate various I/O and checksum errors when reading metadata")
Signed-off-by: Long Li <leo.lilong@huawei.com>
Link: https://patch.msgid.link/20240906091746.510163-1-leo.lilong@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/balloc.c      |  4 ++--
 fs/ext4/ext4.h        | 12 ++----------
 fs/ext4/extents.c     |  2 +-
 fs/ext4/ialloc.c      |  5 +++--
 fs/ext4/indirect.c    |  2 +-
 fs/ext4/inode.c       |  4 ++--
 fs/ext4/mmp.c         |  2 +-
 fs/ext4/move_extent.c |  2 +-
 fs/ext4/resize.c      |  2 +-
 fs/ext4/super.c       | 23 +++++++++++++++--------
 10 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 591fb3f710be7..8042ad8738089 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -550,7 +550,8 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group,
 	trace_ext4_read_block_bitmap_load(sb, block_group, ignore_locked);
 	ext4_read_bh_nowait(bh, REQ_META | REQ_PRIO |
 			    (ignore_locked ? REQ_RAHEAD : 0),
-			    ext4_end_bitmap_read);
+			    ext4_end_bitmap_read,
+			    ext4_simulate_fail(sb, EXT4_SIM_BBITMAP_EIO));
 	return bh;
 verify:
 	err = ext4_validate_block_bitmap(sb, desc, block_group, bh);
@@ -577,7 +578,6 @@ int ext4_wait_block_bitmap(struct super_block *sb, ext4_group_t block_group,
 	if (!desc)
 		return -EFSCORRUPTED;
 	wait_on_buffer(bh);
-	ext4_simulate_fail_bh(sb, bh, EXT4_SIM_BBITMAP_EIO);
 	if (!buffer_uptodate(bh)) {
 		ext4_error_err(sb, EIO, "Cannot read block bitmap - "
 			       "block_group = %u, block_bitmap = %llu",
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8bd302392d759..b02d6e444cfb6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1865,14 +1865,6 @@ static inline bool ext4_simulate_fail(struct super_block *sb,
 	return false;
 }
 
-static inline void ext4_simulate_fail_bh(struct super_block *sb,
-					 struct buffer_head *bh,
-					 unsigned long code)
-{
-	if (!IS_ERR(bh) && ext4_simulate_fail(sb, code))
-		clear_buffer_uptodate(bh);
-}
-
 /*
  * Error number codes for s_{first,last}_error_errno
  *
@@ -3098,9 +3090,9 @@ extern struct buffer_head *ext4_sb_bread(struct super_block *sb,
 extern struct buffer_head *ext4_sb_bread_unmovable(struct super_block *sb,
 						   sector_t block);
 extern void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
-				bh_end_io_t *end_io);
+				bh_end_io_t *end_io, bool simu_fail);
 extern int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-			bh_end_io_t *end_io);
+			bh_end_io_t *end_io, bool simu_fail);
 extern int ext4_read_bh_lock(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
 extern void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block);
 extern int ext4_seq_options_show(struct seq_file *seq, void *offset);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c64f7c1b1d908..123a69e62e59b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -564,7 +564,7 @@ __read_extent_tree_block(const char *function, unsigned int line,
 
 	if (!bh_uptodate_or_lock(bh)) {
 		trace_ext4_ext_load_extent(inode, pblk, _RET_IP_);
-		err = ext4_read_bh(bh, 0, NULL);
+		err = ext4_read_bh(bh, 0, NULL, false);
 		if (err < 0)
 			goto errout;
 	}
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 81641be38c0e8..072084da50d33 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -194,8 +194,9 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	 * submit the buffer_head for reading
 	 */
 	trace_ext4_load_inode_bitmap(sb, block_group);
-	ext4_read_bh(bh, REQ_META | REQ_PRIO, ext4_end_bitmap_read);
-	ext4_simulate_fail_bh(sb, bh, EXT4_SIM_IBITMAP_EIO);
+	ext4_read_bh(bh, REQ_META | REQ_PRIO,
+		     ext4_end_bitmap_read,
+		     ext4_simulate_fail(sb, EXT4_SIM_IBITMAP_EIO));
 	if (!buffer_uptodate(bh)) {
 		put_bh(bh);
 		ext4_error_err(sb, EIO, "Cannot read inode bitmap - "
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index d8ca7f64f9523..8480bddde789b 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -170,7 +170,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 		}
 
 		if (!bh_uptodate_or_lock(bh)) {
-			if (ext4_read_bh(bh, 0, NULL) < 0) {
+			if (ext4_read_bh(bh, 0, NULL, false) < 0) {
 				put_bh(bh);
 				goto failure;
 			}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a0fa5192db8ed..235e22790ec62 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4530,10 +4530,10 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 	 * Read the block from disk.
 	 */
 	trace_ext4_load_inode(sb, ino);
-	ext4_read_bh_nowait(bh, REQ_META | REQ_PRIO, NULL);
+	ext4_read_bh_nowait(bh, REQ_META | REQ_PRIO, NULL,
+			    ext4_simulate_fail(sb, EXT4_SIM_INODE_EIO));
 	blk_finish_plug(&plug);
 	wait_on_buffer(bh);
-	ext4_simulate_fail_bh(sb, bh, EXT4_SIM_INODE_EIO);
 	if (!buffer_uptodate(bh)) {
 		if (ret_block)
 			*ret_block = block;
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index bd946d0c71b70..d64c04ed061ae 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -94,7 +94,7 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	}
 
 	lock_buffer(*bh);
-	ret = ext4_read_bh(*bh, REQ_META | REQ_PRIO, NULL);
+	ret = ext4_read_bh(*bh, REQ_META | REQ_PRIO, NULL, false);
 	if (ret)
 		goto warn_exit;
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 42b52b6491a03..fd3487df360a5 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -212,7 +212,7 @@ static int mext_page_mkuptodate(struct folio *folio, size_t from, size_t to)
 			unlock_buffer(bh);
 			continue;
 		}
-		ext4_read_bh_nowait(bh, 0, NULL);
+		ext4_read_bh_nowait(bh, 0, NULL, false);
 		nr++;
 	}
 	/* No io required */
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f12ccaabf13d8..e9da8bba0f9d7 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1300,7 +1300,7 @@ static struct buffer_head *ext4_get_bitmap(struct super_block *sb, __u64 block)
 	if (unlikely(!bh))
 		return NULL;
 	if (!bh_uptodate_or_lock(bh)) {
-		if (ext4_read_bh(bh, 0, NULL) < 0) {
+		if (ext4_read_bh(bh, 0, NULL, false) < 0) {
 			brelse(bh);
 			return NULL;
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 42b1acac88e78..350b083012851 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -161,8 +161,14 @@ MODULE_ALIAS("ext3");
 
 
 static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
-				  bh_end_io_t *end_io)
+				  bh_end_io_t *end_io, bool simu_fail)
 {
+	if (simu_fail) {
+		clear_buffer_uptodate(bh);
+		unlock_buffer(bh);
+		return;
+	}
+
 	/*
 	 * buffer's verified bit is no longer valid after reading from
 	 * disk again due to write out error, clear it to make sure we
@@ -176,7 +182,7 @@ static inline void __ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
 }
 
 void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
-			 bh_end_io_t *end_io)
+			 bh_end_io_t *end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
@@ -184,10 +190,11 @@ void ext4_read_bh_nowait(struct buffer_head *bh, blk_opf_t op_flags,
 		unlock_buffer(bh);
 		return;
 	}
-	__ext4_read_bh(bh, op_flags, end_io);
+	__ext4_read_bh(bh, op_flags, end_io, simu_fail);
 }
 
-int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags, bh_end_io_t *end_io)
+int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags,
+		 bh_end_io_t *end_io, bool simu_fail)
 {
 	BUG_ON(!buffer_locked(bh));
 
@@ -196,7 +203,7 @@ int ext4_read_bh(struct buffer_head *bh, blk_opf_t op_flags, bh_end_io_t *end_io
 		return 0;
 	}
 
-	__ext4_read_bh(bh, op_flags, end_io);
+	__ext4_read_bh(bh, op_flags, end_io, simu_fail);
 
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
@@ -208,10 +215,10 @@ int ext4_read_bh_lock(struct buffer_head *bh, blk_opf_t op_flags, bool wait)
 {
 	lock_buffer(bh);
 	if (!wait) {
-		ext4_read_bh_nowait(bh, op_flags, NULL);
+		ext4_read_bh_nowait(bh, op_flags, NULL, false);
 		return 0;
 	}
-	return ext4_read_bh(bh, op_flags, NULL);
+	return ext4_read_bh(bh, op_flags, NULL, false);
 }
 
 /*
@@ -266,7 +273,7 @@ void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block)
 
 	if (likely(bh)) {
 		if (trylock_buffer(bh))
-			ext4_read_bh_nowait(bh, REQ_RAHEAD, NULL);
+			ext4_read_bh_nowait(bh, REQ_RAHEAD, NULL, false);
 		brelse(bh);
 	}
 }
-- 
2.43.0



