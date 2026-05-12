Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB8836D510;
	Tue, 12 May 2026 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609651; cv=none; b=O5aFUOkUQrXl0bRzUb+vSmElwnzjZ7yMby47naIr0J6XPibjULVVWLGQ3AKKRqUlzfj7qkvoF6sHw5kA6wBxNS1lEsfCl2XC0kMEeuAS5FiGhJLbBx4+mp7df3cvU9aMcqcYn0yRapM26iFHeqN7v1NO0fkPJvtslVhGLXrKXMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609651; c=relaxed/simple;
	bh=q1bgrQC6GZUlH/71dApTdG6SORgleNquYjpMuqChYdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peT2+n24F+a7HeyaAawbRzkmKt3sdt4KeYkCim/LdFqoe8QKNEgyI7m7dAegzgEyNulmwn5w8wJLI2PHl7AhQ7QLjr8nNBT5euT4OiBELztdxx/sZIniTpqoyrP671sZSeSNIc2H8sGH5zbNKaJ1ZoOZJgy9moIFoyY3esUAeBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8ZTzfCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8ZTzfCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80B6C4AF0B;
	Tue, 12 May 2026 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609651;
	bh=q1bgrQC6GZUlH/71dApTdG6SORgleNquYjpMuqChYdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8ZTzfCnIq5EAcQOe78aHC06bxd2tBRNzqxzId2LeUH88ZYqNIFhARUNxZZAG0tXL
	 ynN5jgjw1QVbSXCs5g+D+Y70+gWzoSt29MaErdCoWzJqud+lLYIuiZQ4+LjzxqWUTP
	 ORZYZvwH5+H9jd7UPCBpzQhUMisNPokULpZdRoIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.0 277/307] f2fs: fix fsck inconsistency caused by FGGC of node block
Date: Tue, 12 May 2026 19:41:12 +0200
Message-ID: <20260512173945.972416642@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit c3e238bd1f56993f205ef83889d406dfeaf717a8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1729,9 +1729,10 @@ continue_unlock:
 	return last_folio;
 }
 
-static bool __write_node_folio(struct folio *folio, bool atomic, bool *submitted,
-				struct writeback_control *wbc, bool do_balance,
-				enum iostat_type io_type, unsigned int *seq_id)
+static bool __write_node_folio(struct folio *folio, bool atomic, bool do_fsync,
+				bool *submitted, struct writeback_control *wbc,
+				bool do_balance, enum iostat_type io_type,
+				unsigned int *seq_id)
 {
 	struct f2fs_sb_info *sbi = F2FS_F_SB(folio);
 	nid_t nid;
@@ -1804,6 +1805,8 @@ static bool __write_node_folio(struct fo
 	if (atomic && !test_opt(sbi, NOBARRIER))
 		fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
 
+	set_dentry_mark(folio, false);
+	set_fsync_mark(folio, do_fsync);
 	if (IS_INODE(folio) && (atomic || is_fsync_dnode(folio)))
 		set_dentry_mark(folio,
 				f2fs_need_dentry_mark(sbi, ino_of_node(folio)));
@@ -1870,7 +1873,7 @@ int f2fs_write_single_node_folio(struct
 		goto out_folio;
 	}
 
-	if (!__write_node_folio(node_folio, false, NULL,
+	if (!__write_node_folio(node_folio, false, false, NULL,
 				&wbc, false, FS_GC_NODE_IO, NULL))
 		err = -EAGAIN;
 	goto release_folio;
@@ -1917,6 +1920,7 @@ retry:
 		for (i = 0; i < nr_folios; i++) {
 			struct folio *folio = fbatch.folios[i];
 			bool submitted = false;
+			bool do_fsync = false;
 
 			if (unlikely(f2fs_cp_error(sbi))) {
 				f2fs_folio_put(last_folio, false);
@@ -1947,11 +1951,8 @@ continue_unlock:
 
 			f2fs_folio_wait_writeback(folio, NODE, true, true);
 
-			set_fsync_mark(folio, 0);
-			set_dentry_mark(folio, 0);
-
 			if (!atomic || folio == last_folio) {
-				set_fsync_mark(folio, 1);
+				do_fsync = true;
 				percpu_counter_inc(&sbi->rf_node_block_count);
 				if (IS_INODE(folio)) {
 					if (is_inode_flag_set(inode,
@@ -1968,8 +1969,9 @@ continue_unlock:
 
 			if (!__write_node_folio(folio, atomic &&
 						folio == last_folio,
-						&submitted, wbc, true,
-						FS_NODE_IO, seq_id)) {
+						do_fsync, &submitted,
+						wbc, true, FS_NODE_IO,
+						seq_id)) {
 				f2fs_folio_put(last_folio, false);
 				folio_batch_release(&fbatch);
 				ret = -EIO;
@@ -2169,10 +2171,7 @@ write_node:
 			if (!folio_clear_dirty_for_io(folio))
 				goto continue_unlock;
 
-			set_fsync_mark(folio, 0);
-			set_dentry_mark(folio, 0);
-
-			if (!__write_node_folio(folio, false, &submitted,
+			if (!__write_node_folio(folio, false, false, &submitted,
 					wbc, do_balance, io_type, NULL)) {
 				folio_batch_release(&fbatch);
 				ret = -EIO;


