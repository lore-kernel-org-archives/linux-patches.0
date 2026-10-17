Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF6A3A1E92;
	Sat, 17 Oct 2026 16:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254109; cv=none; b=JpYDMiaKyDc1FLIfUIdXAKovDmHZuqYP7S1GsqyhYcBwR95KBAkt5CBUDSBR83X0Rvthm8PoW/a3sRkJoe4+4W4KxdJx3usVlTmzncXEAT5mVdtcU0zdtHggcO9XdRjxUKL5cshNcoc8eZ4lVjgdnd3DtOd/zjxqSA+SAP3/Jto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254109; c=relaxed/simple;
	bh=LQrIqZySwalX7DnQIsXXHzutO5D4V5iUOwsKHZwRL6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUDmiyyWVzvd8D5rdaZBTsdJ8J/Qa0icTI09Wnk++FNaUAjZoWt5V9wPRffGEra7vj4SuMrtQLf0NfzXVSmRjOrpRTRV5UKT6e1bvw4hZV6MqaHTWwcWUDYYjL0VBzke9IoThWG2adPe3RycAZ3zhuUUpFu/T3p4j5y69TmZhw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li+eJlWC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li+eJlWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8893A1F000C4;
	Sat, 17 Oct 2026 16:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254107;
	bh=yDyGjWY8giKkxOQ7fxV0LDRoQBtLXlNG3sY9heGJRCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li+eJlWCsU8k9/3tbSkvqFKHMOeHvjrKs8CafWg2iCeuFqC0My74UsIGWqUpB1HcX
	 ncw5lt6zsV9xWJm01hN3qF+D70RMJhpVCVTtyg7vYCIgwiVJGWXj9fgpN+f+xDjCIJ
	 wbdifAwmzStlHlqTpNU6JrHkrO+vc35PVZHyw55Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/869] f2fs: fix fsck inconsistency caused by FGGC of node block
Date: Sat, 17 Oct 2026 17:52:14 +0200
Message-ID: <20261017160044.583949236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 fs/f2fs/node.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 0898ce801f281..9709a212e6a03 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1643,9 +1643,10 @@ static struct page *last_fsync_dnode(struct f2fs_sb_info *sbi, nid_t ino)
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
 	struct folio *folio = page_folio(page);
@@ -1715,13 +1716,14 @@ static int __write_node_page(struct page *page, bool atomic, bool *submitted,
 		goto redirty_out;
 	}
 
-	if (atomic) {
-		if (!test_opt(sbi, NOBARRIER))
-			fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
-		if (IS_INODE(page))
-			set_dentry_mark(page,
+	if (atomic && !test_opt(sbi, NOBARRIER))
+		fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
+
+	set_dentry_mark(page, false);
+	set_fsync_mark(page, do_fsync);
+	if (IS_INODE(page) && (atomic || is_fsync_dnode(page)))
+		set_dentry_mark(page,
 				f2fs_need_dentry_mark(sbi, ino_of_node(page)));
-	}
 
 	/* should add to global list before clearing PAGECACHE status */
 	if (f2fs_in_warm_node_list(sbi, page)) {
@@ -1781,7 +1783,7 @@ int f2fs_move_node_page(struct page *node_page, int gc_type)
 			goto out_page;
 		}
 
-		if (__write_node_page(node_page, false, NULL,
+		if (__write_node_page(node_page, false, false, NULL,
 					&wbc, false, FS_GC_NODE_IO, NULL)) {
 			err = -EAGAIN;
 			unlock_page(node_page);
@@ -1802,7 +1804,7 @@ int f2fs_move_node_page(struct page *node_page, int gc_type)
 static int f2fs_write_node_page(struct page *page,
 				struct writeback_control *wbc)
 {
-	return __write_node_page(page, false, NULL, wbc, false,
+	return __write_node_page(page, false, false, NULL, wbc, false,
 						FS_NODE_IO, NULL);
 }
 
@@ -1836,6 +1838,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 		for (i = 0; i < nr_folios; i++) {
 			struct page *page = &fbatch.folios[i]->page;
 			bool submitted = false;
+			bool do_fsync = false;
 
 			if (unlikely(f2fs_cp_error(sbi))) {
 				f2fs_put_page(last_page, 0);
@@ -1866,11 +1869,8 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 
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
@@ -1890,8 +1890,9 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 
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
@@ -2098,10 +2099,7 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
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



