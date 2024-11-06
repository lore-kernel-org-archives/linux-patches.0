Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CADA1DED49;
	Wed,  6 Nov 2024 12:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895535; cv=none; b=CNO9oPsdYbLFg3+7dXcTjFKfuZ9ejBhmzW0hE6BWTl8dCtV/inFO9tB2KxZFZ/xDrVpPaKtTjRkTjNwNw1RVJ++dl6/6TBrcSgNis0/6Esqk/zXUzYixzZlyHTQgCJwBquJuXbRr6BmvLLbuMBjjPbVENIDipzJDuEhJadtdd/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895535; c=relaxed/simple;
	bh=XJeb3K9aUpSYPqvgWrt6mlwnZb0JZbahgR01EcETt3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UVcwTn5D0j/H9Qv4xcDIO9wDsdWISJ0g+cwLtih8mByWzisNae1i43T7lcnxcfAtuVnjARNU0CV/BvL5qzMpUWfXtgNr6JCRlcHAb7S5S67/vkVZoIJeYqEmFAisKADevddOVHBR+4+cN+U4NF2LXvcu5EkWKbgF1O7cAvaw8v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3A80jnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3A80jnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87922C4CECD;
	Wed,  6 Nov 2024 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895534;
	bh=XJeb3K9aUpSYPqvgWrt6mlwnZb0JZbahgR01EcETt3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3A80jnbM652rhD0U+x1/B2p47f/5D1H9zO9TKobsqkk6a9Hmz8CcalPTlPXlE8oM
	 wymuWBetjg9UWMmhFbLJbjapt/plnUUTcw3J3lODiMZQYSeflpkQujRqSqsBkThEkD
	 dFjRSqCnkWj9MJDBfJAjiaKzweQB1yAo3T7ITlGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Anna Pendleton <pendleton@google.com>,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 214/350] ext4: avoid ext4_error()s caused by ENOMEM in the truncate path
Date: Wed,  6 Nov 2024 13:02:22 +0100
Message-ID: <20241106120326.283576130@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 73c384c0cdaa8ea9ca9ef2d0cff6a25930f1648e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h    |  1 +
 fs/ext4/extents.c | 43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fa2579abea7df..3871df6b67322 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -629,6 +629,7 @@ enum {
  */
 #define EXT4_EX_NOCACHE				0x40000000
 #define EXT4_EX_FORCE_CACHE			0x20000000
+#define EXT4_EX_NOFAIL				0x10000000
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1762a6330a53c..080a7a401a4e1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -290,11 +290,14 @@ ext4_force_split_extent_at(handle_t *handle, struct inode *inode,
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
@@ -536,8 +539,12 @@ __read_extent_tree_block(const char *function, unsigned int line,
 {
 	struct buffer_head		*bh;
 	int				err;
+	gfp_t				gfp_flags = __GFP_MOVABLE | GFP_NOFS;
+
+	if (flags & EXT4_EX_NOFAIL)
+		gfp_flags |= __GFP_NOFAIL;
 
-	bh = sb_getblk_gfp(inode->i_sb, pblk, __GFP_MOVABLE | GFP_NOFS);
+	bh = sb_getblk_gfp(inode->i_sb, pblk, gfp_flags);
 	if (unlikely(!bh))
 		return ERR_PTR(-ENOMEM);
 
@@ -879,6 +886,10 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 	struct ext4_ext_path *path = orig_path ? *orig_path : NULL;
 	short int depth, i, ppos = 0;
 	int ret;
+	gfp_t gfp_flags = GFP_NOFS;
+
+	if (flags & EXT4_EX_NOFAIL)
+		gfp_flags |= __GFP_NOFAIL;
 
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
@@ -899,7 +910,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 	if (!path) {
 		/* account possible depth increase */
 		path = kcalloc(depth + 2, sizeof(struct ext4_ext_path),
-				GFP_NOFS);
+				gfp_flags);
 		if (unlikely(!path))
 			return ERR_PTR(-ENOMEM);
 		path[0].p_maxdepth = depth + 1;
@@ -1049,9 +1060,13 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
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
 
@@ -1085,7 +1100,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	 * We need this to handle errors and free blocks
 	 * upon them.
 	 */
-	ablocks = kcalloc(depth, sizeof(ext4_fsblk_t), GFP_NOFS);
+	ablocks = kcalloc(depth, sizeof(ext4_fsblk_t), gfp_flags);
 	if (!ablocks)
 		return -ENOMEM;
 
@@ -2075,7 +2090,7 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	if (next != EXT_MAX_BLOCKS) {
 		ext_debug("next leaf block - %u\n", next);
 		BUG_ON(npath != NULL);
-		npath = ext4_find_extent(inode, next, NULL, 0);
+		npath = ext4_find_extent(inode, next, NULL, gb_flags);
 		if (IS_ERR(npath))
 			return PTR_ERR(npath);
 		BUG_ON(npath->p_depth != path->p_depth);
@@ -2878,7 +2893,8 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 		ext4_fsblk_t pblk;
 
 		/* find extent for or closest extent to this block */
-		path = ext4_find_extent(inode, end, NULL, EXT4_EX_NOCACHE);
+		path = ext4_find_extent(inode, end, NULL,
+					EXT4_EX_NOCACHE | EXT4_EX_NOFAIL);
 		if (IS_ERR(path)) {
 			ext4_journal_stop(handle);
 			return PTR_ERR(path);
@@ -2960,7 +2976,7 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 				le16_to_cpu(path[k].p_hdr->eh_entries)+1;
 	} else {
 		path = kcalloc(depth + 1, sizeof(struct ext4_ext_path),
-			       GFP_NOFS);
+			       GFP_NOFS | __GFP_NOFAIL);
 		if (path == NULL) {
 			ext4_journal_stop(handle);
 			return -ENOMEM;
@@ -3382,7 +3398,7 @@ static int ext4_split_extent(handle_t *handle,
 	 * Update path is required because previous ext4_split_extent_at() may
 	 * result in split of original leaf or extent zeroout.
 	 */
-	path = ext4_find_extent(inode, map->m_lblk, ppath, 0);
+	path = ext4_find_extent(inode, map->m_lblk, ppath, flags);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	depth = ext_depth(inode);
@@ -4677,7 +4693,14 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
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
-- 
2.43.0



