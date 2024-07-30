Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AB21A76A1;
	Tue, 30 Jul 2024 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360298; cv=none; b=Fb9cmXZUqG2LMDYHThFDP41ab0zbsTybTBy8AttumH7uRUJcqgJgCxvK4aItNGeb5WtAAaGF7SIoWo2VEv8CXPzTkd5C4Kg0DlaQ75sHrueyvknT6wtuB9OqdMvpn7RKh/tm7f9TEaWDWqvspxvBcWesvKKpf5E4pgmHXJ+cqVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360298; c=relaxed/simple;
	bh=NHEzMdUXKqCFo3VKgZ2ivM244ggHxu9BZqp+xG3L3Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIY935854uBze9IEh4fkWwSx5lo7Rx0dMTO08MVDSNMi/KL2x/oXhX9Dvk0zP8Iq9m+TVUM1GvB/ech1A7mvqHkGleuYDtoLKdZAAMlsrIpoD35CpR9k2Lw0FJA+iotqnZENClZEcFh09AU5q0pyGp3PAN1ro/auoJGwoZ8Ad7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsSBKG3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsSBKG3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F3AC32782;
	Tue, 30 Jul 2024 17:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360297;
	bh=NHEzMdUXKqCFo3VKgZ2ivM244ggHxu9BZqp+xG3L3Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsSBKG3EMrHb+Y+Z64x+XHOCbcFV2t5n04ZIF8UNI7KU6JcYLkhxplDmtQYgiixMD
	 ogKOY31aSYmD1VeGBgU2HWRj868xgcBvQo0GCqhfUixkiPGeFieKOJciRg32ZmemFK
	 S5gPVnNZLZTboO423Vwe8zWWBrcp2M9r6scIb7OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.10 655/809] f2fs: use meta inode for GC of atomic file
Date: Tue, 30 Jul 2024 17:48:51 +0200
Message-ID: <20240730151750.751152280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Sunmin Jeong <s_min.jeong@samsung.com>

commit b40a2b00370931b0c50148681dd7364573e52e6b upstream.

The page cache of the atomic file keeps new data pages which will be
stored in the COW file. It can also keep old data pages when GCing the
atomic file. In this case, new data can be overwritten by old data if a
GC thread sets the old data page as dirty after new data page was
evicted.

Also, since all writes to the atomic file are redirected to COW inodes,
GC for the atomic file is not working well as below.

f2fs_gc(gc_type=FG_GC)
  - select A as a victim segment
  do_garbage_collect
    - iget atomic file's inode for block B
    move_data_page
      f2fs_do_write_data_page
        - use dn of cow inode
        - set fio->old_blkaddr from cow inode
    - seg_freed is 0 since block B is still valid
  - goto gc_more and A is selected as victim again

To solve the problem, let's separate GC writes and updates in the atomic
file by using the meta inode for GC writes.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Cc: stable@vger.kernel.org #v5.19+
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yeongjin Gil <youngjin.gil@samsung.com>
Signed-off-by: Sunmin Jeong <s_min.jeong@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c    |    4 ++--
 fs/f2fs/f2fs.h    |    7 ++++++-
 fs/f2fs/gc.c      |    6 +++---
 fs/f2fs/segment.c |    6 +++---
 4 files changed, 14 insertions(+), 9 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2688,7 +2688,7 @@ got_it:
 	}
 
 	/* wait for GCed page writeback via META_MAPPING */
-	if (fio->post_read)
+	if (fio->meta_gc)
 		f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
 
 	/*
@@ -2783,7 +2783,7 @@ int f2fs_write_single_data_page(struct p
 		.submitted = 0,
 		.compr_blocks = compr_blocks,
 		.need_lock = compr_blocks ? LOCK_DONE : LOCK_RETRY,
-		.post_read = f2fs_post_read_required(inode) ? 1 : 0,
+		.meta_gc = f2fs_meta_inode_gc_required(inode) ? 1 : 0,
 		.io_type = io_type,
 		.io_wbc = wbc,
 		.bio = bio,
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1210,7 +1210,7 @@ struct f2fs_io_info {
 	unsigned int in_list:1;		/* indicate fio is in io_list */
 	unsigned int is_por:1;		/* indicate IO is from recovery or not */
 	unsigned int encrypted:1;	/* indicate file is encrypted */
-	unsigned int post_read:1;	/* require post read */
+	unsigned int meta_gc:1;		/* require meta inode GC */
 	enum iostat_type io_type;	/* io type */
 	struct writeback_control *io_wbc; /* writeback control */
 	struct bio **bio;		/* bio for ipu */
@@ -4261,6 +4261,11 @@ static inline bool f2fs_post_read_requir
 		f2fs_compressed_file(inode);
 }
 
+static inline bool f2fs_meta_inode_gc_required(struct inode *inode)
+{
+	return f2fs_post_read_required(inode) || f2fs_is_atomic_file(inode);
+}
+
 /*
  * compress.c
  */
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1579,7 +1579,7 @@ next_step:
 			start_bidx = f2fs_start_bidx_of_node(nofs, inode) +
 								ofs_in_node;
 
-			if (f2fs_post_read_required(inode)) {
+			if (f2fs_meta_inode_gc_required(inode)) {
 				int err = ra_data_block(inode, start_bidx);
 
 				f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
@@ -1630,7 +1630,7 @@ next_step:
 
 			start_bidx = f2fs_start_bidx_of_node(nofs, inode)
 								+ ofs_in_node;
-			if (f2fs_post_read_required(inode))
+			if (f2fs_meta_inode_gc_required(inode))
 				err = move_data_block(inode, start_bidx,
 							gc_type, segno, off);
 			else
@@ -1638,7 +1638,7 @@ next_step:
 								segno, off);
 
 			if (!err && (gc_type == FG_GC ||
-					f2fs_post_read_required(inode)))
+					f2fs_meta_inode_gc_required(inode)))
 				submitted++;
 
 			if (locked) {
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3828,7 +3828,7 @@ int f2fs_inplace_write_data(struct f2fs_
 		goto drop_bio;
 	}
 
-	if (fio->post_read)
+	if (fio->meta_gc)
 		f2fs_truncate_meta_inode_pages(sbi, fio->new_blkaddr, 1);
 
 	stat_inc_inplace_blocks(fio->sbi);
@@ -3998,7 +3998,7 @@ void f2fs_wait_on_block_writeback(struct
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *cpage;
 
-	if (!f2fs_post_read_required(inode))
+	if (!f2fs_meta_inode_gc_required(inode))
 		return;
 
 	if (!__is_valid_data_blkaddr(blkaddr))
@@ -4017,7 +4017,7 @@ void f2fs_wait_on_block_writeback_range(
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	block_t i;
 
-	if (!f2fs_post_read_required(inode))
+	if (!f2fs_meta_inode_gc_required(inode))
 		return;
 
 	for (i = 0; i < len; i++)


