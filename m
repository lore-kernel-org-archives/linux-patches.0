Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216139;
	b=DCitEX1lB1L9dCEbebKtsUOZesHNgmmSxQTPwhDTigORiGTqZA01TH/wh7c1QkFuE+vJ
	 31ZasYsUh+jakjXYla5ueluIht9Mj2ZkPqq+8KJUpx3S8lXSxgAZAOqTYOkYthzIfX1x3
	 q6Jh5ZN7jfshAYfn6U9pI0u19H1ZbNatYsAtgc8hiT3m4G0EC6rW6ub20DyAi0WwyoSec
	 qL5N9XEoCXdSk7ScOP63PVszLZwcrWUH6SOx7JQ+eKnCuT1KxGs+REYlnJRfB1ZTLxx06
	 7mtO7fh+ZyUK3n+AjHIZ3Vxv7c3IUmDtHMvMTbr/kFJhDuIZtyvsJb5B6dQgNt1o2aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ts2/8C4lrv17ivReiiex+DW94R6j4eivTVGDIIhC05g=;
	b=R7xg0WauP2OKMyNHFoJ1rU/iqvOmSxylCJN6Q3GNjUG4Regi6IJajawmdbj/u6rlJa00
	 J0pkbELdmSLOl9CTqDTXzIBr7LwTlUFIecx5J7SOl6UQNr6rNSST+R6xpfKyiSHwpQNwZ
	 omQ1DfYGU2yK9iijL7iPBoYHloRAMHB5PaIBAO+EkbjO/BzfTToXbylvaeUi1kCsmXsAm
	 uDDqMvd3MCGOcErS2B+8UY6Qw4SC9g2NDwbm399gi9T+uBtzJA4Ntq3aQVli8ivkvecQr
	 fBQcQHpDx6RM9VdWhns33H+KpYTQFo4eWUhbyS4mvlTAzS7eFXEFPucoxdnDHCh/lvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXWGBrfL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58847606A31C;
	Wed, 28 Oct 2026 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXWGBrfL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84681F01825;
	Wed, 28 Oct 2026 19:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216139;
	bh=Ts2/8C4lrv17ivReiiex+DW94R6j4eivTVGDIIhC05g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXWGBrfLBoIH/m94DE6mUZdjd67b+eDfp0jfle9l6vmwVa0hiDaRspLGqC636tesZ
	 TJkjfComlbmFpBcV4Hrvhz5NWoLjTg0UxQoNFPUE6lmp3Hn2r/psR2n1wjUyVeVRGx
	 an4USYMxaXG2L/n6i7Fl/Z9apLXDOhkrkWil7Lbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1452/1887] f2fs: fix fsck inconsistency caused by FGGC of node block
Date: Wed, 28 Oct 2026 17:59:08 +0100
Message-ID: <20261028170532.501755506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/f2fs/node.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 2cfe99772b3fa..8df943d6ee626 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1624,9 +1624,10 @@ static struct page *last_fsync_dnode(struct f2fs_sb_info *sbi, nid_t ino)
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
@@ -1695,6 +1696,8 @@ static int __write_node_page(struct page *page, bool atomic, bool *submitted,
 	if (atomic && !test_opt(sbi, NOBARRIER) && !f2fs_sb_has_blkzoned(sbi))
 		fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
 
+	set_dentry_mark(page, false);
+	set_fsync_mark(page, do_fsync);
 	if (IS_INODE(page) && (atomic || is_fsync_dnode(page)))
 		set_dentry_mark(page,
 				f2fs_need_dentry_mark(sbi, ino_of_node(page)));
@@ -1758,7 +1761,7 @@ int f2fs_move_node_page(struct page *node_page, int gc_type)
 			goto out_page;
 		}
 
-		if (__write_node_page(node_page, false, NULL,
+		if (__write_node_page(node_page, false, false, NULL,
 					&wbc, false, FS_GC_NODE_IO, NULL)) {
 			err = -EAGAIN;
 			unlock_page(node_page);
@@ -1779,7 +1782,7 @@ int f2fs_move_node_page(struct page *node_page, int gc_type)
 static int f2fs_write_node_page(struct page *page,
 				struct writeback_control *wbc)
 {
-	return __write_node_page(page, false, NULL, wbc, false,
+	return __write_node_page(page, false, false, NULL, wbc, false,
 						FS_NODE_IO, NULL);
 }
 
@@ -1812,6 +1815,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 			bool submitted = false;
+			bool do_fsync = false;
 
 			if (unlikely(f2fs_cp_error(sbi))) {
 				f2fs_put_page(last_page, 0);
@@ -1842,11 +1846,8 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 
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
@@ -1863,8 +1864,9 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 
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
@@ -2069,10 +2071,7 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
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



