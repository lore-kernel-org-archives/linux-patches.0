Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1708226ED46;
	Mon, 23 Mar 2026 14:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277602; cv=none; b=ZLwoyYbM+E4Vf+r+Y3NaRpnGmU2fR2+8a0er7Dyih+M4jAO7DiRtGU9Vq7RSEBDsspYmYfvieRtbSRw8IGNXTfKZFrZUk28jbT4/0hn//RuDNCGI1DyEJrSTfkDDsI+SzLgEkIiuM5SyY8bby93f5PFfE2BottVpRu259TSaEEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277602; c=relaxed/simple;
	bh=BKX6+setLmcTIk7qtkWCizBdVOw5E3eMA+rjT7LjmnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HejNreEUptzpXm678h/zsSTmSNPc9cHPS5vLXTffmz38vDS6uAetW2P9JEiyA4lGKtxSOio8K7IPLtif2ZJPFnjEyDsl+1V3JIwvao0EJLYtI6kvfO41NrnwXDhxGQBLxbKh6xjq05jLGqtPVlQE4Gbo8xLo3m9c8WPtPBqcyaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsDx3eg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsDx3eg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E44C4CEF7;
	Mon, 23 Mar 2026 14:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277601;
	bh=BKX6+setLmcTIk7qtkWCizBdVOw5E3eMA+rjT7LjmnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsDx3eg2lUWHnFV20GwVN7Smpe4eM7wgqB4j7cwIUtPQfMlezFP8hnQzoZr/1HP0w
	 yCoqNVnHRQ1V3QWm6V2AkgSIdOX92YyEVIDqCigQ87C/dcaPJDV4EK6w7kkAMPRtVV
	 oUGuILW0O7Cx8uctCtFaVr8HyjUwkX69pvDkaIUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/567] ext4: get rid of ppath in ext4_find_extent()
Date: Mon, 23 Mar 2026 14:39:24 +0100
Message-ID: <20260323134534.889199693@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 0be4c0c2f17bd10ae16c852f02d51a6a7b318aca ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

Getting rid of ppath in ext4_find_extent() requires its caller to update
ppath. These ppaths will also be dropped later. No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-12-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 22784ca541c0 ("ext4: subdivide EXT4_EXT_DATA_VALID1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h        |  2 +-
 fs/ext4/extents.c     | 55 +++++++++++++++++++++++--------------------
 fs/ext4/move_extent.c |  7 +++---
 3 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 85ba12a48f26a..dd0317d66c1db 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3712,7 +3712,7 @@ extern int ext4_ext_insert_extent(handle_t *, struct inode *,
 				  struct ext4_ext_path **,
 				  struct ext4_extent *, int);
 extern struct ext4_ext_path *ext4_find_extent(struct inode *, ext4_lblk_t,
-					      struct ext4_ext_path **,
+					      struct ext4_ext_path *,
 					      int flags);
 extern void ext4_free_ext_path(struct ext4_ext_path *);
 extern int ext4_ext_check_inode(struct inode *inode);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8d9cd6574d326..cd5f679648cea 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -881,11 +881,10 @@ void ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 
 struct ext4_ext_path *
 ext4_find_extent(struct inode *inode, ext4_lblk_t block,
-		 struct ext4_ext_path **orig_path, int flags)
+		 struct ext4_ext_path *path, int flags)
 {
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
-	struct ext4_ext_path *path = orig_path ? *orig_path : NULL;
 	short int depth, i, ppos = 0;
 	int ret;
 	gfp_t gfp_flags = GFP_NOFS;
@@ -906,7 +905,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		ext4_ext_drop_refs(path);
 		if (depth > path[0].p_maxdepth) {
 			kfree(path);
-			*orig_path = path = NULL;
+			path = NULL;
 		}
 	}
 	if (!path) {
@@ -957,14 +956,10 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 
 	ext4_ext_show_path(inode, path);
 
-	if (orig_path)
-		*orig_path = path;
 	return path;
 
 err:
 	ext4_free_ext_path(path);
-	if (orig_path)
-		*orig_path = NULL;
 	return ERR_PTR(ret);
 }
 
@@ -1429,7 +1424,7 @@ static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 		/* refill path */
 		path = ext4_find_extent(inode,
 				    (ext4_lblk_t)le32_to_cpu(newext->ee_block),
-				    ppath, gb_flags);
+				    path, gb_flags);
 		if (IS_ERR(path))
 			err = PTR_ERR(path);
 	} else {
@@ -1441,7 +1436,7 @@ static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 		/* refill path */
 		path = ext4_find_extent(inode,
 				   (ext4_lblk_t)le32_to_cpu(newext->ee_block),
-				    ppath, gb_flags);
+				    path, gb_flags);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
 			goto out;
@@ -1457,8 +1452,8 @@ static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 			goto repeat;
 		}
 	}
-
 out:
+	*ppath = IS_ERR(path) ? NULL : path;
 	return err;
 }
 
@@ -3246,15 +3241,17 @@ static int ext4_split_extent_at(handle_t *handle,
 	 * WARN_ON may be triggered in ext4_da_update_reserve_space() due to
 	 * an incorrect ee_len causing the i_reserved_data_blocks exception.
 	 */
-	path = ext4_find_extent(inode, ee_block, ppath,
+	path = ext4_find_extent(inode, ee_block, *ppath,
 				flags | EXT4_EX_NOFAIL);
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
+		*ppath = NULL;
 		return PTR_ERR(path);
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
+	*ppath = path;
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {
 		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
@@ -3367,9 +3364,12 @@ static int ext4_split_extent(handle_t *handle,
 	 * Update path is required because previous ext4_split_extent_at() may
 	 * result in split of original leaf or extent zeroout.
 	 */
-	path = ext4_find_extent(inode, map->m_lblk, ppath, flags);
-	if (IS_ERR(path))
+	path = ext4_find_extent(inode, map->m_lblk, *ppath, flags);
+	if (IS_ERR(path)) {
+		*ppath = NULL;
 		return PTR_ERR(path);
+	}
+	*ppath = path;
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	if (!ex) {
@@ -3755,9 +3755,12 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 						 EXT4_GET_BLOCKS_CONVERT);
 		if (err < 0)
 			return err;
-		path = ext4_find_extent(inode, map->m_lblk, ppath, 0);
-		if (IS_ERR(path))
+		path = ext4_find_extent(inode, map->m_lblk, *ppath, 0);
+		if (IS_ERR(path)) {
+			*ppath = NULL;
 			return PTR_ERR(path);
+		}
+		*ppath = path;
 		depth = ext_depth(inode);
 		ex = path[depth].p_ext;
 	}
@@ -3813,9 +3816,12 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 				EXT4_GET_BLOCKS_CONVERT_UNWRITTEN);
 		if (err < 0)
 			return err;
-		path = ext4_find_extent(inode, map->m_lblk, ppath, 0);
-		if (IS_ERR(path))
+		path = ext4_find_extent(inode, map->m_lblk, *ppath, 0);
+		if (IS_ERR(path)) {
+			*ppath = NULL;
 			return PTR_ERR(path);
+		}
+		*ppath = path;
 		depth = ext_depth(inode);
 		ex = path[depth].p_ext;
 		if (!ex) {
@@ -5200,7 +5206,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	* won't be shifted beyond EXT_MAX_BLOCKS.
 	*/
 	if (SHIFT == SHIFT_LEFT) {
-		path = ext4_find_extent(inode, start - 1, &path,
+		path = ext4_find_extent(inode, start - 1, path,
 					EXT4_EX_NOCACHE);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
@@ -5249,7 +5255,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * becomes NULL to indicate the end of the loop.
 	 */
 	while (iterator && start <= stop) {
-		path = ext4_find_extent(inode, *iterator, &path,
+		path = ext4_find_extent(inode, *iterator, path,
 					EXT4_EX_NOCACHE);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
@@ -5832,11 +5838,8 @@ int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu)
 
 	/* search for the extent closest to the first block in the cluster */
 	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
-	if (IS_ERR(path)) {
-		err = PTR_ERR(path);
-		path = NULL;
-		goto out;
-	}
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	depth = ext_depth(inode);
 
@@ -5920,7 +5923,7 @@ int ext4_ext_replay_update_ex(struct inode *inode, ext4_lblk_t start,
 		if (ret)
 			goto out;
 
-		path = ext4_find_extent(inode, start, &path, 0);
+		path = ext4_find_extent(inode, start, path, 0);
 		if (IS_ERR(path))
 			return PTR_ERR(path);
 		ex = path[path->p_depth].p_ext;
@@ -5934,7 +5937,7 @@ int ext4_ext_replay_update_ex(struct inode *inode, ext4_lblk_t start,
 			if (ret)
 				goto out;
 
-			path = ext4_find_extent(inode, start, &path, 0);
+			path = ext4_find_extent(inode, start, path, 0);
 			if (IS_ERR(path))
 				return PTR_ERR(path);
 			ex = path[path->p_depth].p_ext;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a3b0acca02ca5..d5636a2a718a8 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -26,16 +26,17 @@ static inline int
 get_ext_path(struct inode *inode, ext4_lblk_t lblock,
 		struct ext4_ext_path **ppath)
 {
-	struct ext4_ext_path *path;
+	struct ext4_ext_path *path = *ppath;
 
-	path = ext4_find_extent(inode, lblock, ppath, EXT4_EX_NOCACHE);
+	*ppath = NULL;
+	path = ext4_find_extent(inode, lblock, path, EXT4_EX_NOCACHE);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	if (path[ext_depth(inode)].p_ext == NULL) {
 		ext4_free_ext_path(path);
-		*ppath = NULL;
 		return -ENODATA;
 	}
+	*ppath = path;
 	return 0;
 }
 
-- 
2.51.0



