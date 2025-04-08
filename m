Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FBA374C4;
	Tue,  8 Apr 2025 11:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110836; cv=none; b=DURuccWt2mF2bg6FvxvoyQvL69N0rSSbCyD9HF5Ga/HhwveGovhNjSOR8107AKi+3SazaL5MfQin3Y+A25Hyruc+3MLyTod/4D0xv/E6nZ+9hp6YJpamemayi9M6dbde5+NF3mILeI0Ax+QTHPmYCGGSJ2/HGCaKO6w9lXhTwhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110836; c=relaxed/simple;
	bh=YMfQ+A/QNSEvuLhq05/aIvmJgHhfwG/Q27bMj7zhVBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAUgJVw3nIdKYExplucV8uHOXYZTUJh8XE30nZ4QGGg/bnJiOHO6KZgJCP2UOGteIL0o/4H3IHrQw3qC4/eDVms7ZmnK83lEyWUo5EgipHJctNC3Gqj2y1CtZ9QTKu1o85Ep4R/8OKutiz2ya5S7R58dRlUumLEo9o4Eby7a89M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWpHvaB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWpHvaB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D2EC4CEE5;
	Tue,  8 Apr 2025 11:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110836;
	bh=YMfQ+A/QNSEvuLhq05/aIvmJgHhfwG/Q27bMj7zhVBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWpHvaB+1PzHFH0+f9ImyQ7pWb2eKp/LVFyO+QMHZjeNd/DkCxOhaO9GCaZp7JBCU
	 IpluUu5npRX/ZcoNqmt3//YBFOkpBwmI0Q/zYS0On3BQhkL1Rgj4vy43pJd9Ui/YlS
	 9NGPraVgnWxPCv0SxKZ10cie5EaTlYKlENi1j7GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b6b347b7a4ea1b2e29b6@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 173/731] f2fs: fix to avoid accessing uninitialized curseg
Date: Tue,  8 Apr 2025 12:41:10 +0200
Message-ID: <20250408104918.299796238@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 986c50f6bca109c6cf362b4e2babcb85aba958f6 ]

syzbot reports a f2fs bug as below:

F2FS-fs (loop3): Stopped filesystem due to reason: 7
kworker/u8:7: attempt to access beyond end of device
BUG: unable to handle page fault for address: ffffed1604ea3dfa
RIP: 0010:get_ckpt_valid_blocks fs/f2fs/segment.h:361 [inline]
RIP: 0010:has_curseg_enough_space fs/f2fs/segment.h:570 [inline]
RIP: 0010:__get_secs_required fs/f2fs/segment.h:620 [inline]
RIP: 0010:has_not_enough_free_secs fs/f2fs/segment.h:633 [inline]
RIP: 0010:has_enough_free_secs+0x575/0x1660 fs/f2fs/segment.h:649
 <TASK>
 f2fs_is_checkpoint_ready fs/f2fs/segment.h:671 [inline]
 f2fs_write_inode+0x425/0x540 fs/f2fs/inode.c:791
 write_inode fs/fs-writeback.c:1525 [inline]
 __writeback_single_inode+0x708/0x10d0 fs/fs-writeback.c:1745
 writeback_sb_inodes+0x820/0x1360 fs/fs-writeback.c:1976
 wb_writeback+0x413/0xb80 fs/fs-writeback.c:2156
 wb_do_writeback fs/fs-writeback.c:2303 [inline]
 wb_workfn+0x410/0x1080 fs/fs-writeback.c:2343
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Commit 8b10d3653735 ("f2fs: introduce FAULT_NO_SEGMENT") allows to trigger
no free segment fault in allocator, then it will update curseg->segno to
NULL_SEGNO, though, CP_ERROR_FLAG has been set, f2fs_write_inode() missed
to check the flag, and access invalid curseg->segno directly in below call
path, then resulting in panic:

- f2fs_write_inode
 - f2fs_is_checkpoint_ready
  - has_enough_free_secs
   - has_not_enough_free_secs
    - __get_secs_required
     - has_curseg_enough_space
      - get_ckpt_valid_blocks
      : access invalid curseg->segno

To avoid this issue, let's:
- check CP_ERROR_FLAG flag in prior to f2fs_is_checkpoint_ready() in
f2fs_write_inode().
- in has_curseg_enough_space(), save curseg->segno into a temp variable,
and verify its validation before use.

Fixes: 8b10d3653735 ("f2fs: introduce FAULT_NO_SEGMENT")
Reported-by: syzbot+b6b347b7a4ea1b2e29b6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67973c2b.050a0220.11b1bb.0089.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/inode.c   | 7 +++++++
 fs/f2fs/segment.h | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 3dd25f64d6f1e..cd17d6f4c291f 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -789,6 +789,13 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		!is_inode_flag_set(inode, FI_DIRTY_INODE))
 		return 0;
 
+	/*
+	 * no need to update inode page, ultimately f2fs_evict_inode() will
+	 * clear dirty status of inode.
+	 */
+	if (f2fs_cp_error(sbi))
+		return -EIO;
+
 	if (!f2fs_is_checkpoint_ready(sbi)) {
 		f2fs_mark_inode_dirty_sync(inode, true);
 		return -ENOSPC;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 943be4f1d6d2d..0465dc00b349d 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -559,13 +559,16 @@ static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi,
 			unsigned int node_blocks, unsigned int data_blocks,
 			unsigned int dent_blocks)
 {
-
 	unsigned int segno, left_blocks, blocks;
 	int i;
 
 	/* check current data/node sections in the worst case. */
 	for (i = CURSEG_HOT_DATA; i < NR_PERSISTENT_LOG; i++) {
 		segno = CURSEG_I(sbi, i)->segno;
+
+		if (unlikely(segno == NULL_SEGNO))
+			return false;
+
 		left_blocks = CAP_BLKS_PER_SEC(sbi) -
 				get_ckpt_valid_blocks(sbi, segno, true);
 
@@ -576,6 +579,10 @@ static inline bool has_curseg_enough_space(struct f2fs_sb_info *sbi,
 
 	/* check current data section for dentry blocks. */
 	segno = CURSEG_I(sbi, CURSEG_HOT_DATA)->segno;
+
+	if (unlikely(segno == NULL_SEGNO))
+		return false;
+
 	left_blocks = CAP_BLKS_PER_SEC(sbi) -
 			get_ckpt_valid_blocks(sbi, segno, true);
 	if (dent_blocks > left_blocks)
-- 
2.39.5



