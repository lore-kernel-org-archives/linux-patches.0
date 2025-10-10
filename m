Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE1C2F6196;
	Fri, 10 Oct 2025 13:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102270; cv=none; b=Wc6CJnfD9wbxI9ssZExQ257N4rlhoCNoKuG2PRre3jB9RYimLlph4v8HmFZ2Z8phalOJYR/fxIlcWKcV3pUc3efvHHS8XLYIyoQv5xAFJ91GG1NPnuM+i088+Fyw40UfCPC1O1kFU3cBEOZTLlv+ZnS9ujhICNlvfpF7lG4BryE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102270; c=relaxed/simple;
	bh=pgFIc4rJ0Tc/jPNtIj3DCXWzWlmZUpc8ipWOj3j4V5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhHVzcWW+bMu7AjIpr0p61PEsdJlr6CBC1RpE12tNvvQ5BrDDk8nqBATofP9VgJBTk6yUVSAflDGlIpZIreSbympq/BO1L28/PnnIgRlslMtArl4RNSj4D46hgiz18G4xis9xci8SAMP1bli5o3gq5uDINpZoImpCq2Yy6LFbwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYc9dx2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYc9dx2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40EBAC4CEF9;
	Fri, 10 Oct 2025 13:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102270;
	bh=pgFIc4rJ0Tc/jPNtIj3DCXWzWlmZUpc8ipWOj3j4V5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYc9dx2t3QZYiUE3tSRiWxgPIz+iYLSv8ZlA5AYb/EE8jRr4wUjdH27nh1G38eubl
	 yyaHQo7DKcu4GKk9nCBKx8Ynn0VAu3/EKcUvZ08jJONRRRgRgWXiezhhjt4HK1zcsd
	 blkwdsket7LbAiMS2u4j8t+54iYEeRQLLuqeuVcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+b9c7ffd609c3f09416ab@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.17 25/26] f2fs: fix to do sanity check on node footer for non inode dnode
Date: Fri, 10 Oct 2025 15:16:20 +0200
Message-ID: <20251010131332.120480940@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit c18ecd99e0c707ef8f83cace861cbc3162f4fdf1 upstream.

As syzbot reported below:

------------[ cut here ]------------
kernel BUG at fs/f2fs/file.c:1243!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5354 Comm: syz.0.0 Not tainted 6.17.0-rc1-syzkaller-00211-g90d970cade8e #0 PREEMPT(full)
RIP: 0010:f2fs_truncate_hole+0x69e/0x6c0 fs/f2fs/file.c:1243
Call Trace:
 <TASK>
 f2fs_punch_hole+0x2db/0x330 fs/f2fs/file.c:1306
 f2fs_fallocate+0x546/0x990 fs/f2fs/file.c:2018
 vfs_fallocate+0x666/0x7e0 fs/open.c:342
 ksys_fallocate fs/open.c:366 [inline]
 __do_sys_fallocate fs/open.c:371 [inline]
 __se_sys_fallocate fs/open.c:369 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:369
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1e65f8ebe9

w/ a fuzzed image, f2fs may encounter panic due to it detects inconsistent
truncation range in direct node in f2fs_truncate_hole().

The root cause is: a non-inode dnode may has the same footer.ino and
footer.nid, so the dnode will be parsed as an inode, then ADDRS_PER_PAGE()
may return wrong blkaddr count which may be 923 typically, by chance,
dn.ofs_in_node is equal to 923, then count can be calculated to 0 in below
statement, later it will trigger panic w/ f2fs_bug_on(, count == 0 || ...).

	count = min(end_offset - dn.ofs_in_node, pg_end - pg_start);

This patch introduces a new node_type NODE_TYPE_NON_INODE, then allowing
passing the new_type to sanity_check_node_footer in f2fs_get_node_folio()
to detect corruption that a non-inode dnode has the same footer.ino and
footer.nid.

Scripts to reproduce:
mkfs.f2fs -f /dev/vdb
mount /dev/vdb /mnt/f2fs
touch /mnt/f2fs/foo
touch /mnt/f2fs/bar
dd if=/dev/zero of=/mnt/f2fs/foo bs=1M count=8
umount /mnt/f2fs
inject.f2fs --node --mb i_nid --nid 4 --idx 0 --val 5 /dev/vdb
mount /dev/vdb /mnt/f2fs
xfs_io /mnt/f2fs/foo -c "fpunch 6984k 4k"

Cc: stable@kernel.org
Reported-by: syzbot+b9c7ffd609c3f09416ab@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-f2fs-devel/68a68e27.050a0220.1a3988.0002.GAE@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h     |    4 ++-
 fs/f2fs/gc.c       |    4 +--
 fs/f2fs/node.c     |   58 +++++++++++++++++++++++++++++++++++------------------
 fs/f2fs/node.h     |    1 
 fs/f2fs/recovery.c |    2 -
 5 files changed, 46 insertions(+), 23 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3764,6 +3764,7 @@ void f2fs_hash_filename(const struct ino
  * node.c
  */
 struct node_info;
+enum node_type;
 
 int f2fs_check_nid_range(struct f2fs_sb_info *sbi, nid_t nid);
 bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type);
@@ -3786,7 +3787,8 @@ int f2fs_remove_inode_page(struct inode
 struct folio *f2fs_new_inode_folio(struct inode *inode);
 struct folio *f2fs_new_node_folio(struct dnode_of_data *dn, unsigned int ofs);
 void f2fs_ra_node_page(struct f2fs_sb_info *sbi, nid_t nid);
-struct folio *f2fs_get_node_folio(struct f2fs_sb_info *sbi, pgoff_t nid);
+struct folio *f2fs_get_node_folio(struct f2fs_sb_info *sbi, pgoff_t nid,
+						enum node_type node_type);
 struct folio *f2fs_get_inode_folio(struct f2fs_sb_info *sbi, pgoff_t ino);
 struct folio *f2fs_get_xnode_folio(struct f2fs_sb_info *sbi, pgoff_t xnid);
 int f2fs_move_node_folio(struct folio *node_folio, int gc_type);
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1071,7 +1071,7 @@ next_step:
 		}
 
 		/* phase == 2 */
-		node_folio = f2fs_get_node_folio(sbi, nid);
+		node_folio = f2fs_get_node_folio(sbi, nid, NODE_TYPE_REGULAR);
 		if (IS_ERR(node_folio))
 			continue;
 
@@ -1145,7 +1145,7 @@ static bool is_alive(struct f2fs_sb_info
 	nid = le32_to_cpu(sum->nid);
 	ofs_in_node = le16_to_cpu(sum->ofs_in_node);
 
-	node_folio = f2fs_get_node_folio(sbi, nid);
+	node_folio = f2fs_get_node_folio(sbi, nid, NODE_TYPE_REGULAR);
 	if (IS_ERR(node_folio))
 		return false;
 
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -871,7 +871,8 @@ int f2fs_get_dnode_of_data(struct dnode_
 		}
 
 		if (!done) {
-			nfolio[i] = f2fs_get_node_folio(sbi, nids[i]);
+			nfolio[i] = f2fs_get_node_folio(sbi, nids[i],
+						NODE_TYPE_NON_INODE);
 			if (IS_ERR(nfolio[i])) {
 				err = PTR_ERR(nfolio[i]);
 				f2fs_folio_put(nfolio[0], false);
@@ -989,7 +990,7 @@ static int truncate_dnode(struct dnode_o
 		return 1;
 
 	/* get direct node */
-	folio = f2fs_get_node_folio(sbi, dn->nid);
+	folio = f2fs_get_node_folio(sbi, dn->nid, NODE_TYPE_NON_INODE);
 	if (PTR_ERR(folio) == -ENOENT)
 		return 1;
 	else if (IS_ERR(folio))
@@ -1033,7 +1034,8 @@ static int truncate_nodes(struct dnode_o
 
 	trace_f2fs_truncate_nodes_enter(dn->inode, dn->nid, dn->data_blkaddr);
 
-	folio = f2fs_get_node_folio(F2FS_I_SB(dn->inode), dn->nid);
+	folio = f2fs_get_node_folio(F2FS_I_SB(dn->inode), dn->nid,
+						NODE_TYPE_NON_INODE);
 	if (IS_ERR(folio)) {
 		trace_f2fs_truncate_nodes_exit(dn->inode, PTR_ERR(folio));
 		return PTR_ERR(folio);
@@ -1111,7 +1113,8 @@ static int truncate_partial_nodes(struct
 	/* get indirect nodes in the path */
 	for (i = 0; i < idx + 1; i++) {
 		/* reference count'll be increased */
-		folios[i] = f2fs_get_node_folio(F2FS_I_SB(dn->inode), nid[i]);
+		folios[i] = f2fs_get_node_folio(F2FS_I_SB(dn->inode), nid[i],
+							NODE_TYPE_NON_INODE);
 		if (IS_ERR(folios[i])) {
 			err = PTR_ERR(folios[i]);
 			idx = i - 1;
@@ -1496,21 +1499,37 @@ static int sanity_check_node_footer(stru
 					struct folio *folio, pgoff_t nid,
 					enum node_type ntype)
 {
-	if (unlikely(nid != nid_of_node(folio) ||
-		(ntype == NODE_TYPE_INODE && !IS_INODE(folio)) ||
-		(ntype == NODE_TYPE_XATTR &&
-		!f2fs_has_xattr_block(ofs_of_node(folio))) ||
-		time_to_inject(sbi, FAULT_INCONSISTENT_FOOTER))) {
-		f2fs_warn(sbi, "inconsistent node block, node_type:%d, nid:%lu, "
-			  "node_footer[nid:%u,ino:%u,ofs:%u,cpver:%llu,blkaddr:%u]",
-			  ntype, nid, nid_of_node(folio), ino_of_node(folio),
-			  ofs_of_node(folio), cpver_of_node(folio),
-			  next_blkaddr_of_node(folio));
-		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		f2fs_handle_error(sbi, ERROR_INCONSISTENT_FOOTER);
-		return -EFSCORRUPTED;
+	if (unlikely(nid != nid_of_node(folio)))
+		goto out_err;
+
+	switch (ntype) {
+	case NODE_TYPE_INODE:
+		if (!IS_INODE(folio))
+			goto out_err;
+		break;
+	case NODE_TYPE_XATTR:
+		if (!f2fs_has_xattr_block(ofs_of_node(folio)))
+			goto out_err;
+		break;
+	case NODE_TYPE_NON_INODE:
+		if (IS_INODE(folio))
+			goto out_err;
+		break;
+	default:
+		break;
 	}
+	if (time_to_inject(sbi, FAULT_INCONSISTENT_FOOTER))
+		goto out_err;
 	return 0;
+out_err:
+	f2fs_warn(sbi, "inconsistent node block, node_type:%d, nid:%lu, "
+		  "node_footer[nid:%u,ino:%u,ofs:%u,cpver:%llu,blkaddr:%u]",
+		  ntype, nid, nid_of_node(folio), ino_of_node(folio),
+		  ofs_of_node(folio), cpver_of_node(folio),
+		  next_blkaddr_of_node(folio));
+	set_sbi_flag(sbi, SBI_NEED_FSCK);
+	f2fs_handle_error(sbi, ERROR_INCONSISTENT_FOOTER);
+	return -EFSCORRUPTED;
 }
 
 static struct folio *__get_node_folio(struct f2fs_sb_info *sbi, pgoff_t nid,
@@ -1567,9 +1586,10 @@ out_put_err:
 	return ERR_PTR(err);
 }
 
-struct folio *f2fs_get_node_folio(struct f2fs_sb_info *sbi, pgoff_t nid)
+struct folio *f2fs_get_node_folio(struct f2fs_sb_info *sbi, pgoff_t nid,
+						enum node_type node_type)
 {
-	return __get_node_folio(sbi, nid, NULL, 0, NODE_TYPE_REGULAR);
+	return __get_node_folio(sbi, nid, NULL, 0, node_type);
 }
 
 struct folio *f2fs_get_inode_folio(struct f2fs_sb_info *sbi, pgoff_t ino)
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -57,6 +57,7 @@ enum node_type {
 	NODE_TYPE_REGULAR,
 	NODE_TYPE_INODE,
 	NODE_TYPE_XATTR,
+	NODE_TYPE_NON_INODE,
 };
 
 /*
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -548,7 +548,7 @@ got_it:
 	}
 
 	/* Get the node page */
-	node_folio = f2fs_get_node_folio(sbi, nid);
+	node_folio = f2fs_get_node_folio(sbi, nid, NODE_TYPE_REGULAR);
 	if (IS_ERR(node_folio))
 		return PTR_ERR(node_folio);
 


