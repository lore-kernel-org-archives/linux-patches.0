Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDBC1F16B;
	Sat, 17 Oct 2026 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258686; cv=none; b=oTR1en2nR2Iph5G3ZEw3wBY7b84qSryTcxmoI9NJAOqe6HfpRwMC9rufjjFER/v690kzDuirpnxfspNFkhtwfpAebxjhry3CbiV1+o4huwIVVBsleimDSKVsG97Wb/F+VOmOkVgkk49RRf7kukIHAV0Nr7nVB31n55w3ytz7sn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258686; c=relaxed/simple;
	bh=XpWqIGIAFwxEx+Hi70d7rHkrumZ56lug5irsJFV4CLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VN17pIJ9Mf6Ctv0PeM2LxF6FwU3uXB3VRXGShOqf5r0BWXfIq4AeEwmGspDoydM+4sPx7mCrGtJdWFj7izUtCyMqckhkz7dN9m9gdzDh7SBMrh90bvy5uds1JDEQFA6b4QuugD8fCbhJHX4bM3XmzgPJG4Tauf0YlAtEDQsSPZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGk5oouQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGk5oouQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61481F000C4;
	Sat, 17 Oct 2026 17:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258685;
	bh=y9Z9hc+7QhYFyDck1AvW0GY/2u4N5d2BPuYwEoog1Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pGk5oouQAXAFzWIS687hsrFjgDzP/Aq7qAFAnwfqBAB1BbKkPP3KCm/IuNcYY3PmQ
	 JN0UYx39YdBNAXcld7HzqWqU2ti2lX7pobEkOZqe5EE4PiREt2ecaXwNYhWSYXE+ze
	 pAbKWO6Rr/7sNmqBXFfaauapw+ptF50QAy23mdGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0965/1674] f2fs: fix fsck inconsistency caused by FGGC of node block
Date: Sat, 17 Oct 2026 17:53:57 +0200
Message-ID: <20261017160455.895209325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit c3e238bd1f56993f205ef83889d406dfeaf717a8 ]

During FGGC node block migration, fsck may incorrectly treat the
migrated node block as fsync-written data.

The reproduction scenario:
root@vm:/mnt/f2fs# seq 1 2048 | xargs -n 1 ./test_sync // write inline inode and sync
root@vm:/mnt/f2fs# rm -f 1
root@vm:/mnt/f2fs# sync
root@vm:/mnt/f2fs# f2fs_io gc_range // move data block in sync mode and not write CP
  SPO, "fsck --dry-run" find inode has already checkpointed but still
  with DENT_BIT_SHIFT set

The root cause is that GC does not clear the dentry mark and fsync mark
during node block migration, leading fsck to misinterpret them as
user-issued fsync writes.

In BGGC mode, node block migration is handled by f2fs_sync_node_pages(),
which guarantees the dentry and fsync marks are cleared before writing.

This patch move the set/clear of the fsync|dentry marks into
__write_node_folio to make the logic clearer, and ensures the
fsync|dentry mark is cleared in FGGC.

Cc: stable@kernel.org
Fixes: da011cc0da8c ("f2fs: move node pages only in victim section during GC")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e7a0a841bd689..d9021bfee5cf0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1630,9 +1630,10 @@ static struct page *last_fsync_dnode(struct f2fs_sb_info *sbi, nid_t ino)
 	return last_page;
 }
 
-static int __write_node_page(struct page *page, bool atomic, bool *submitted,
-				struct writeback_control *wbc, bool do_balance,
-				enum iostat_type io_type, unsigned int *seq_id)
+static int __write_node_page(struct page *page, bool atomic, bool do_fsync,
+				bool *submitted, struct writeback_control *wbc,
+				bool do_balance, enum iostat_type io_type,
+				unsigned int *seq_id)
 {
 	struct f2fs_sb_info *sbi = F2FS_P_SB(page);
 	nid_t nid;
@@ -1704,11 +1705,14 @@ static int __write_node_page(struct page *page, bool atomic, bool *submitted,
 	if (atomic) {
 		if (!test_opt(sbi, NOBARRIER) && !f2fs_sb_has_blkzoned(sbi))
 			fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
-		if (IS_INODE(page))
-			set_dentry_mark(page,
-				f2fs_need_dentry_mark(sbi, ino_of_node(page)));
 	}
 
+	set_dentry_mark(page, false);
+	set_fsync_mark(page, do_fsync);
+	if (IS_INODE(page) && (atomic || is_fsync_dnode(page)))
+		set_dentry_mark(page,
+				f2fs_need_dentry_mark(sbi, ino_of_node(page)));
+
 	/* should add to global list before clearing PAGECACHE status */
 	if (f2fs_in_warm_node_list(sbi, page)) {
 		seq = f2fs_add_fsync_node_entry(sbi, page);
@@ -1767,7 +1771,7 @@ int f2fs_move_node_page(struct page *node_page, int gc_type)
 			goto out_page;
 		}
 
-		if (__write_node_page(node_page, false, NULL,
+		if (__write_node_page(node_page, false, false, NULL,
 					&wbc, false, FS_GC_NODE_IO, NULL)) {
 			err = -EAGAIN;
 			unlock_page(node_page);
@@ -1788,7 +1792,7 @@ int f2fs_move_node_page(struct page *node_page, int gc_type)
 static int f2fs_write_node_page(struct page *page,
 				struct writeback_control *wbc)
 {
-	return __write_node_page(page, false, NULL, wbc, false,
+	return __write_node_page(page, false, false, NULL, wbc, false,
 						FS_NODE_IO, NULL);
 }
 
@@ -1822,6 +1826,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 		for (i = 0; i < nr_folios; i++) {
 			struct page *page = &fbatch.folios[i]->page;
 			bool submitted = false;
+			bool do_fsync = false;
 
 			if (unlikely(f2fs_cp_error(sbi))) {
 				f2fs_put_page(last_page, 0);
@@ -1852,19 +1857,13 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 
 			f2fs_wait_on_page_writeback(page, NODE, true, true);
 
-			set_fsync_mark(page, 0);
-			set_dentry_mark(page, 0);
-
 			if (!atomic || page == last_page) {
-				set_fsync_mark(page, 1);
+				do_fsync = true;
 				percpu_counter_inc(&sbi->rf_node_block_count);
 				if (IS_INODE(page)) {
 					if (is_inode_flag_set(inode,
 								FI_DIRTY_INODE))
 						f2fs_update_inode(inode, page);
-					if (!atomic)
-						set_dentry_mark(page,
-							f2fs_need_dentry_mark(sbi, ino));
 				}
 				/* may be written by other thread */
 				if (!PageDirty(page))
@@ -1876,8 +1875,9 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 
 			ret = __write_node_page(page, atomic &&
 						page == last_page,
-						&submitted, wbc, true,
-						FS_NODE_IO, seq_id);
+						do_fsync, &submitted,
+						wbc, true, FS_NODE_IO,
+						seq_id);
 			if (ret) {
 				unlock_page(page);
 				f2fs_put_page(last_page, 0);
@@ -2084,10 +2084,7 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
-			set_fsync_mark(page, 0);
-			set_dentry_mark(page, 0);
-
-			ret = __write_node_page(page, false, &submitted,
+			ret = __write_node_page(page, false, false, &submitted,
 						wbc, do_balance, io_type, NULL);
 			if (ret)
 				unlock_page(page);
-- 
2.53.0



