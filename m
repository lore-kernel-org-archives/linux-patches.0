Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD48E1BDA95;
	Thu, 30 Jan 2025 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246838; cv=none; b=VRfTnVZ/VVmHCrrrGruBx8yZO1WH3YJkkLJavFVyzf68yOuOlKS1cwgOBF/GabZ27PbNDYPkEuCsKLFfSpyK09VJQw3Og6+/Afg8VbHsYwmoHsc2G8+9kJUCeBrlWrVCKYlmhE5Ii1pNAUIsdZk2YgsP4RG0NGK64apsECzYNrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246838; c=relaxed/simple;
	bh=BtzLZak/dX3BY7kuoGSaQdaywOZ2bnnhl96MPotD38Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RY4OZlz1LMtmRolrZeiZs6DWnHA03vDMNDyh5FaKAl1X+Bk3wgUw2CPlvQhx5npnv6DqRSwpmuh9/KFajHV9JN1vcblvl0bu5/39BQhMmNKcMAmZrbpjy0FEAmKNWFy+goK7wCuk/m9/6i0aU2hHZ8u7HAanUE2Mh3YfoO6K3Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVm1CQq9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVm1CQq9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37785C4CED2;
	Thu, 30 Jan 2025 14:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246838;
	bh=BtzLZak/dX3BY7kuoGSaQdaywOZ2bnnhl96MPotD38Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVm1CQq92qCGZ5my6eyK2R6YXBaYV92fy39245o6cxHDBYKGtfABjl6UdnwlmYy1f
	 G4H/bszbYRjgDT5IjTGw71P5g36l/099Wm3nj1fH5GTmtZ5sbJjyxdS5GFh1bUW3m0
	 2jqeez23lT6gioJJvj8yl8bAUEvUD4MSaK5Chx9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Anna Pendleton <pendleton@google.com>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Shaoying Xu <shaoyi@amazon.com>
Subject: [PATCH 5.4 85/91] ext4: avoid ext4_error()s caused by ENOMEM in the truncate path
Date: Thu, 30 Jan 2025 15:01:44 +0100
Message-ID: <20250130140137.104091886@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 73c384c0cdaa8ea9ca9ef2d0cff6a25930f1648e upstream.

We can't fail in the truncate path without requiring an fsck.
Add work around for this by using a combination of retry loops
and the __GFP_NOFAIL flag.

From: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Anna Pendleton <pendleton@google.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20200507175028.15061-1-pendleton@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: c26ab35702f8 ("ext4: fix slab-use-after-free in ext4_split_extent_at()")
[v5.4: resolved contextual conflict in __read_extent_tree_block]
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 10 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -628,6 +628,7 @@ enum {
  */
 #define EXT4_EX_NOCACHE				0x40000000
 #define EXT4_EX_FORCE_CACHE			0x20000000
+#define EXT4_EX_NOFAIL				0x10000000
 
 /*
  * Flags used by ext4_free_blocks
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -304,11 +304,14 @@ ext4_force_split_extent_at(handle_t *han
 {
 	struct ext4_ext_path *path = *ppath;
 	int unwritten = ext4_ext_is_unwritten(path[path->p_depth].p_ext);
+	int flags = EXT4_EX_NOCACHE | EXT4_GET_BLOCKS_PRE_IO;
+
+	if (nofail)
+		flags |= EXT4_GET_BLOCKS_METADATA_NOFAIL | EXT4_EX_NOFAIL;
 
 	return ext4_split_extent_at(handle, inode, ppath, lblk, unwritten ?
 			EXT4_EXT_MARK_UNWRIT1|EXT4_EXT_MARK_UNWRIT2 : 0,
-			EXT4_EX_NOCACHE | EXT4_GET_BLOCKS_PRE_IO |
-			(nofail ? EXT4_GET_BLOCKS_METADATA_NOFAIL:0));
+			flags);
 }
 
 /*
@@ -572,9 +575,13 @@ __read_extent_tree_block(const char *fun
 	struct buffer_head		*bh;
 	int				err;
 	ext4_fsblk_t			pblk;
+	gfp_t                           gfp_flags = __GFP_MOVABLE | GFP_NOFS;
+
+	if (flags & EXT4_EX_NOFAIL)
+		 gfp_flags |= __GFP_NOFAIL;
 
 	pblk = ext4_idx_pblock(idx);
-	bh = sb_getblk_gfp(inode->i_sb, pblk, __GFP_MOVABLE | GFP_NOFS);
+	bh = sb_getblk_gfp(inode->i_sb, pblk, gfp_flags);
 	if (unlikely(!bh))
 		return ERR_PTR(-ENOMEM);
 
@@ -919,6 +926,10 @@ ext4_find_extent(struct inode *inode, ex
 	struct ext4_ext_path *path = orig_path ? *orig_path : NULL;
 	short int depth, i, ppos = 0;
 	int ret;
+	gfp_t gfp_flags = GFP_NOFS;
+
+	if (flags & EXT4_EX_NOFAIL)
+		gfp_flags |= __GFP_NOFAIL;
 
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
@@ -939,7 +950,7 @@ ext4_find_extent(struct inode *inode, ex
 	if (!path) {
 		/* account possible depth increase */
 		path = kcalloc(depth + 2, sizeof(struct ext4_ext_path),
-				GFP_NOFS);
+				gfp_flags);
 		if (unlikely(!path))
 			return ERR_PTR(-ENOMEM);
 		path[0].p_maxdepth = depth + 1;
@@ -1088,9 +1099,13 @@ static int ext4_ext_split(handle_t *hand
 	ext4_fsblk_t newblock, oldblock;
 	__le32 border;
 	ext4_fsblk_t *ablocks = NULL; /* array of allocated blocks */
+	gfp_t gfp_flags = GFP_NOFS;
 	int err = 0;
 	size_t ext_size = 0;
 
+	if (flags & EXT4_EX_NOFAIL)
+		gfp_flags |= __GFP_NOFAIL;
+
 	/* make decision: where to split? */
 	/* FIXME: now decision is simplest: at current extent */
 
@@ -1124,7 +1139,7 @@ static int ext4_ext_split(handle_t *hand
 	 * We need this to handle errors and free blocks
 	 * upon them.
 	 */
-	ablocks = kcalloc(depth, sizeof(ext4_fsblk_t), GFP_NOFS);
+	ablocks = kcalloc(depth, sizeof(ext4_fsblk_t), gfp_flags);
 	if (!ablocks)
 		return -ENOMEM;
 
@@ -2110,7 +2125,7 @@ prepend:
 	if (next != EXT_MAX_BLOCKS) {
 		ext_debug("next leaf block - %u\n", next);
 		BUG_ON(npath != NULL);
-		npath = ext4_find_extent(inode, next, NULL, 0);
+		npath = ext4_find_extent(inode, next, NULL, gb_flags);
 		if (IS_ERR(npath))
 			return PTR_ERR(npath);
 		BUG_ON(npath->p_depth != path->p_depth);
@@ -3018,7 +3033,8 @@ again:
 		ext4_fsblk_t pblk;
 
 		/* find extent for or closest extent to this block */
-		path = ext4_find_extent(inode, end, NULL, EXT4_EX_NOCACHE);
+		path = ext4_find_extent(inode, end, NULL,
+					EXT4_EX_NOCACHE | EXT4_EX_NOFAIL);
 		if (IS_ERR(path)) {
 			ext4_journal_stop(handle);
 			return PTR_ERR(path);
@@ -3104,7 +3120,7 @@ again:
 				le16_to_cpu(path[k].p_hdr->eh_entries)+1;
 	} else {
 		path = kcalloc(depth + 1, sizeof(struct ext4_ext_path),
-			       GFP_NOFS);
+			       GFP_NOFS | __GFP_NOFAIL);
 		if (path == NULL) {
 			ext4_journal_stop(handle);
 			return -ENOMEM;
@@ -3528,7 +3544,7 @@ static int ext4_split_extent(handle_t *h
 	 * Update path is required because previous ext4_split_extent_at() may
 	 * result in split of original leaf or extent zeroout.
 	 */
-	path = ext4_find_extent(inode, map->m_lblk, ppath, 0);
+	path = ext4_find_extent(inode, map->m_lblk, ppath, flags);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	depth = ext_depth(inode);
@@ -4650,7 +4666,14 @@ retry:
 	}
 	if (err)
 		return err;
-	return ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
+retry_remove_space:
+	err = ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
+	if (err == -ENOMEM) {
+		cond_resched();
+		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		goto retry_remove_space;
+	}
+	return err;
 }
 
 static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,


