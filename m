Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26750322531;
	Mon, 18 Aug 2025 14:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526029; cv=none; b=QKR+9ZQcyrcyDxMswf4RmY/9P/Z9fgATLWK9ISubk9uTlPsnuzd/MMZ+jNi34iJjSmJGQKFMgoo40d831HsN8+7yz/RwOdHZ0wTWtKBbOM5O7nxehSddX86wlAewSliRhcrsaMV3gWeIII/7QcMgHTFp/8fkKGaeF9FprAB+a6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526029; c=relaxed/simple;
	bh=NNYe8IUr8NVxVJsu+LCyDU1yRbxYb7ASqS+fSi7Zia4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cN9a7WQXB3u7ADEiT9n1SSLOR8eYMeKdEdgEXS5w8Pu+VPGuOIZrZ775lib8jwYQtP15PMKF6cah7RaITeDqWK+gpYUEJRV8C4o8sqvRSftx/bRm2cmjksmSsD1GD9nVVVMuOYmKx5CEk0SMuP4AqKoyN3foBc/0B/W+LzE+82c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHTty9Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHTty9Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7BDC16AAE;
	Mon, 18 Aug 2025 14:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526028;
	bh=NNYe8IUr8NVxVJsu+LCyDU1yRbxYb7ASqS+fSi7Zia4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHTty9MdOauUT61RvsfqZAo+wtHWUlDzmRNUruS6MVtlY7iplNPkEnhQCD8f8bFsc
	 Ofcjgwq5VYEG41xLfuWIX5wowcSLQ6sJD5iXLWs2UfRcEr++nJDI+jHPTPMuorxadh
	 XozEp4tnV8LC5dyi6mfhxgtGGUVQW5VXOq8JXmPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 437/570] f2fs: handle nat.blkaddr corruption in f2fs_get_node_info()
Date: Mon, 18 Aug 2025 14:47:04 +0200
Message-ID: <20250818124522.658348260@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1773f63d108b1b9b9d053d8c95f8300c556f93b8 ]

F2FS-fs (dm-55): access invalid blkaddr:972878540
Call trace:
 dump_backtrace+0xec/0x128
 show_stack+0x18/0x28
 dump_stack_lvl+0x40/0x88
 dump_stack+0x18/0x24
 __f2fs_is_valid_blkaddr+0x360/0x3b4
 f2fs_is_valid_blkaddr+0x10/0x20
 f2fs_get_node_info+0x21c/0x60c
 __write_node_page+0x15c/0x734
 f2fs_sync_node_pages+0x4f8/0x700
 f2fs_write_checkpoint+0x4a8/0x99c
 __checkpoint_and_complete_reqs+0x7c/0x20c
 issue_checkpoint_thread+0x4c/0xd8
 kthread+0x11c/0x1b0
 ret_from_fork+0x10/0x20

If nat.blkaddr is corrupted, during checkpoint, f2fs_sync_node_pages()
will loop to flush node page w/ corrupted nat.blkaddr.

Although, it tags SBI_NEED_FSCK, checkpoint can not persist it due
to deadloop.

Let's call f2fs_handle_error(, ERROR_INCONSISTENT_NAT) to record such
error into superblock, it expects fsck can detect the error and repair
inconsistent nat.blkaddr after device reboot.

Note that, let's add sanity check in f2fs_get_node_info() to detect
in-memory nat.blkaddr inconsistency, but only if CONFIG_F2FS_CHECK_FS
is enabled.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index bfe104db284e..2fd287f2bca4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -555,8 +555,8 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 	struct f2fs_nat_entry ne;
 	struct nat_entry *e;
 	pgoff_t index;
-	block_t blkaddr;
 	int i;
+	bool need_cache = true;
 
 	ni->flag = 0;
 	ni->nid = nid;
@@ -569,6 +569,10 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 		ni->blk_addr = nat_get_blkaddr(e);
 		ni->version = nat_get_version(e);
 		f2fs_up_read(&nm_i->nat_tree_lock);
+		if (IS_ENABLED(CONFIG_F2FS_CHECK_FS)) {
+			need_cache = false;
+			goto sanity_check;
+		}
 		return 0;
 	}
 
@@ -594,7 +598,7 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 	up_read(&curseg->journal_rwsem);
 	if (i >= 0) {
 		f2fs_up_read(&nm_i->nat_tree_lock);
-		goto cache;
+		goto sanity_check;
 	}
 
 	/* Fill node_info from nat page */
@@ -609,14 +613,23 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 	ne = nat_blk->entries[nid - start_nid];
 	node_info_from_raw_nat(ni, &ne);
 	f2fs_folio_put(folio, true);
-cache:
-	blkaddr = le32_to_cpu(ne.block_addr);
-	if (__is_valid_data_blkaddr(blkaddr) &&
-		!f2fs_is_valid_blkaddr(sbi, blkaddr, DATA_GENERIC_ENHANCE))
-		return -EFAULT;
+sanity_check:
+	if (__is_valid_data_blkaddr(ni->blk_addr) &&
+		!f2fs_is_valid_blkaddr(sbi, ni->blk_addr,
+					DATA_GENERIC_ENHANCE)) {
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		f2fs_err_ratelimited(sbi,
+			"f2fs_get_node_info of %pS: inconsistent nat entry, "
+			"ino:%u, nid:%u, blkaddr:%u, ver:%u, flag:%u",
+			__builtin_return_address(0),
+			ni->ino, ni->nid, ni->blk_addr, ni->version, ni->flag);
+		f2fs_handle_error(sbi, ERROR_INCONSISTENT_NAT);
+		return -EFSCORRUPTED;
+	}
 
 	/* cache nat entry */
-	cache_nat_entry(sbi, nid, &ne);
+	if (need_cache)
+		cache_nat_entry(sbi, nid, &ne);
 	return 0;
 }
 
-- 
2.39.5



