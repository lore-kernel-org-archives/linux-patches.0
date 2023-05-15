Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58613FBFE
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B0CC433EF;
	Mon, 15 May 2023 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170765;
	bh=mTLgljBowj+HIHE/XYun5mcSDoGFs6yopZF9PDKvqyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpT1yYpam9RHYEd/1bDSUCsIO94WNZkvdhSGypcY/W5W9wtrkJTA4/wdepeRpk92V
	 DMZQSN0b+D+rEo2ZzuryyE2Nfj9qdNKVeq/Tn1+y2lxMz6g3N1mmmiTZECXvK6kE2D
	 BKVbXSAaVBJDpeUh4YT6mPlbN0OatfZSYGQgzUBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 234/239] f2fs: inode: fix to do sanity check on extent cache correctly
Date: Mon, 15 May 2023 18:28:17 +0200
Message-Id: <20230515161728.729322973@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

commit 269d119481008cd725ce32553332593c0ecfc91c upstream.

In do_read_inode(), sanity check for extent cache should be called after
f2fs_init_read_extent_tree(), fix it.

Fixes: 72840cccc0a1 ("f2fs: allocate the extent_cache by default")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |   25 +++++++++++++++++++++++++
 fs/f2fs/f2fs.h         |    1 +
 fs/f2fs/inode.c        |   22 ++++++----------------
 3 files changed, 32 insertions(+), 16 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -15,6 +15,31 @@
 #include "node.h"
 #include <trace/events/f2fs.h>
 
+bool sanity_check_extent_cache(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	struct extent_info *ei;
+
+	if (!fi->extent_tree[EX_READ])
+		return true;
+
+	ei = &fi->extent_tree[EX_READ]->largest;
+
+	if (ei->len &&
+		(!f2fs_is_valid_blkaddr(sbi, ei->blk,
+					DATA_GENERIC_ENHANCE) ||
+		!f2fs_is_valid_blkaddr(sbi, ei->blk + ei->len - 1,
+					DATA_GENERIC_ENHANCE))) {
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
+		f2fs_warn(sbi, "%s: inode (ino=%lx) extent info [%u, %u, %u] is incorrect, run fsck to fix",
+			  __func__, inode->i_ino,
+			  ei->blk, ei->fofs, ei->len);
+		return false;
+	}
+	return true;
+}
+
 static void __set_extent_info(struct extent_info *ei,
 				unsigned int fofs, unsigned int len,
 				block_t blk, bool keep_clen,
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4125,6 +4125,7 @@ void f2fs_leave_shrinker(struct f2fs_sb_
 /*
  * extent_cache.c
  */
+bool sanity_check_extent_cache(struct inode *inode);
 struct rb_entry *f2fs_lookup_rb_tree(struct rb_root_cached *root,
 				struct rb_entry *cached_re, unsigned int ofs);
 struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -262,22 +262,6 @@ static bool sanity_check_inode(struct in
 		return false;
 	}
 
-	if (fi->extent_tree[EX_READ]) {
-		struct extent_info *ei = &fi->extent_tree[EX_READ]->largest;
-
-		if (ei->len &&
-			(!f2fs_is_valid_blkaddr(sbi, ei->blk,
-						DATA_GENERIC_ENHANCE) ||
-			!f2fs_is_valid_blkaddr(sbi, ei->blk + ei->len - 1,
-						DATA_GENERIC_ENHANCE))) {
-			set_sbi_flag(sbi, SBI_NEED_FSCK);
-			f2fs_warn(sbi, "%s: inode (ino=%lx) extent info [%u, %u, %u] is incorrect, run fsck to fix",
-				  __func__, inode->i_ino,
-				  ei->blk, ei->fofs, ei->len);
-			return false;
-		}
-	}
-
 	if (f2fs_sanity_check_inline_data(inode)) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_warn(sbi, "%s: inode (ino=%lx, mode=%u) should not have inline_data, run fsck to fix",
@@ -479,6 +463,12 @@ static int do_read_inode(struct inode *i
 		f2fs_put_page(node_page, 1);
 		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
 		return -EFSCORRUPTED;
+	}
+
+	if (!sanity_check_extent_cache(inode)) {
+		f2fs_put_page(node_page, 1);
+		f2fs_handle_error(sbi, ERROR_CORRUPTED_INODE);
+		return -EFSCORRUPTED;
 	}
 
 	f2fs_put_page(node_page, 1);


