Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8682B67E;
	Wed,  8 Apr 2026 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672229; cv=none; b=dB6KalXUw2x246FMTEm16JS8McAuQyeQ+9P+o6TU2bouPj1n07X6DArTE1SbIE47GoMeXw/usW18rSqYLOCYMdX7rNIrVTHGELsxw+7JyhClNmRL1lB0NbKKJlyY5D8kHdCvpsw9Fe4vFm4ADqdeXNPLZ033L3OBFhuElwMFluM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672229; c=relaxed/simple;
	bh=Wgt1N3oLAnlHwnUyFpaasosQB5YDN8puqaoFiYbjQus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ekgWM6nIKmADzjShX36RAfeSzkygi0bJuRsNgNWIm5x0qLoWioNoHirxeyqjtuA49jH5DoL+/mlgnlpINie4Y6MhvQmkxXtPNSTVWJWDqq6l96fqCIbQSvkhbHLHivTpNzj5LiKVe/kPUO6Xdi9j+D/++T+VdDv+x3IMQZUHefc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGhUGHGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGhUGHGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EBBC19425;
	Wed,  8 Apr 2026 18:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672229;
	bh=Wgt1N3oLAnlHwnUyFpaasosQB5YDN8puqaoFiYbjQus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGhUGHGOmydHUhyu1IIOYd0qGZJjlxWxTc2hiJyrexSMoKvD2wOYQg7tHOT4xuI6I
	 7YUSzA9+rPz/HdXzdIVDqtF/8L8KoGBw8abzk4aeMX700d4H5iT0wFrHHmZZfD8Jgv
	 1HSnqA7hTucRurPJkG2VuNNtkspqqz31dFVUEiB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 240/312] Revert "ext4: get rid of ppath in ext4_ext_insert_extent()"
Date: Wed,  8 Apr 2026 20:02:37 +0200
Message-ID: <20260408175942.714589349@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit b6a01b66cdaa2da526b512fc0f9938ea5d6c7a1c.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h        |  7 ++--
 fs/ext4/extents.c     | 88 +++++++++++++++++++------------------------
 fs/ext4/fast_commit.c |  8 ++--
 fs/ext4/migrate.c     |  5 +--
 4 files changed, 47 insertions(+), 61 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7449777fabc36..490496adf17cc 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3719,10 +3719,9 @@ extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						   int num,
 						   struct ext4_ext_path *path);
-extern struct ext4_ext_path *ext4_ext_insert_extent(
-				handle_t *handle, struct inode *inode,
-				struct ext4_ext_path *path,
-				struct ext4_extent *newext, int gb_flags);
+extern int ext4_ext_insert_extent(handle_t *, struct inode *,
+				  struct ext4_ext_path **,
+				  struct ext4_extent *, int);
 extern struct ext4_ext_path *ext4_find_extent(struct inode *, ext4_lblk_t,
 					      struct ext4_ext_path *,
 					      int flags);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 59c0bffc691d1..eda6f92a42330 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1960,15 +1960,16 @@ static unsigned int ext4_ext_check_overlap(struct ext4_sb_info *sbi,
  * inserts requested extent as new one into the tree,
  * creating new leaf in the no-space case.
  */
-struct ext4_ext_path *
-ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
-		       struct ext4_ext_path *path,
-		       struct ext4_extent *newext, int gb_flags)
+int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
+				struct ext4_ext_path **ppath,
+				struct ext4_extent *newext, int gb_flags)
 {
+	struct ext4_ext_path *path = *ppath;
 	struct ext4_extent_header *eh;
 	struct ext4_extent *ex, *fex;
 	struct ext4_extent *nearex; /* nearest extent */
-	int depth, len, err = 0;
+	struct ext4_ext_path *npath = NULL;
+	int depth, len, err;
 	ext4_lblk_t next;
 	int mb_flags = 0, unwritten;
 
@@ -1976,16 +1977,14 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		mb_flags |= EXT4_MB_DELALLOC_RESERVED;
 	if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
 		EXT4_ERROR_INODE(inode, "ext4_ext_get_actual_len(newext) == 0");
-		err = -EFSCORRUPTED;
-		goto errout;
+		return -EFSCORRUPTED;
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
 	eh = path[depth].p_hdr;
 	if (unlikely(path[depth].p_hdr == NULL)) {
 		EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
-		err = -EFSCORRUPTED;
-		goto errout;
+		return -EFSCORRUPTED;
 	}
 
 	/* try to insert block into found extent and return */
@@ -2023,7 +2022,7 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 			err = ext4_ext_get_access(handle, inode,
 						  path + depth);
 			if (err)
-				goto errout;
+				return err;
 			unwritten = ext4_ext_is_unwritten(ex);
 			ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
 					+ ext4_ext_get_actual_len(newext));
@@ -2048,7 +2047,7 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 			err = ext4_ext_get_access(handle, inode,
 						  path + depth);
 			if (err)
-				goto errout;
+				return err;
 
 			unwritten = ext4_ext_is_unwritten(ex);
 			ex->ee_block = newext->ee_block;
@@ -2073,26 +2072,21 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	if (le32_to_cpu(newext->ee_block) > le32_to_cpu(fex->ee_block))
 		next = ext4_ext_next_leaf_block(path);
 	if (next != EXT_MAX_BLOCKS) {
-		struct ext4_ext_path *npath;
-
 		ext_debug(inode, "next leaf block - %u\n", next);
+		BUG_ON(npath != NULL);
 		npath = ext4_find_extent(inode, next, NULL, gb_flags);
-		if (IS_ERR(npath)) {
-			err = PTR_ERR(npath);
-			goto errout;
-		}
+		if (IS_ERR(npath))
+			return PTR_ERR(npath);
 		BUG_ON(npath->p_depth != path->p_depth);
 		eh = npath[depth].p_hdr;
 		if (le16_to_cpu(eh->eh_entries) < le16_to_cpu(eh->eh_max)) {
 			ext_debug(inode, "next leaf isn't full(%d)\n",
 				  le16_to_cpu(eh->eh_entries));
-			ext4_free_ext_path(path);
 			path = npath;
 			goto has_space;
 		}
 		ext_debug(inode, "next leaf has no free space(%d,%d)\n",
 			  le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
-		ext4_free_ext_path(npath);
 	}
 
 	/*
@@ -2103,8 +2097,12 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		mb_flags |= EXT4_MB_USE_RESERVED;
 	path = ext4_ext_create_new_leaf(handle, inode, mb_flags, gb_flags,
 					path, newext);
-	if (IS_ERR(path))
-		return path;
+	if (IS_ERR(path)) {
+		*ppath = NULL;
+		err = PTR_ERR(path);
+		goto cleanup;
+	}
+	*ppath = path;
 	depth = ext_depth(inode);
 	eh = path[depth].p_hdr;
 
@@ -2113,7 +2111,7 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
-		goto errout;
+		goto cleanup;
 
 	if (!nearex) {
 		/* there is no extent in this leaf, create first one */
@@ -2171,20 +2169,17 @@ ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	if (!(gb_flags & EXT4_GET_BLOCKS_PRE_IO))
 		ext4_ext_try_to_merge(handle, inode, path, nearex);
 
+
 	/* time to correct all indexes above */
 	err = ext4_ext_correct_indexes(handle, inode, path);
 	if (err)
-		goto errout;
+		goto cleanup;
 
 	err = ext4_ext_dirty(handle, inode, path + path->p_depth);
-	if (err)
-		goto errout;
-
-	return path;
 
-errout:
-	ext4_free_ext_path(path);
-	return ERR_PTR(err);
+cleanup:
+	ext4_free_ext_path(npath);
+	return err;
 }
 
 static int ext4_fill_es_cache_info(struct inode *inode,
@@ -3237,29 +3232,24 @@ static int ext4_split_extent_at(handle_t *handle,
 	if (split_flag & EXT4_EXT_MARK_UNWRIT2)
 		ext4_ext_mark_unwritten(ex2);
 
-	path = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
-	if (!IS_ERR(path)) {
-		*ppath = path;
-		goto out;
-	}
-	*ppath = NULL;
-	err = PTR_ERR(path);
+	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
 	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
-		return err;
+		goto out;
 
 	/*
-	 * Get a new path to try to zeroout or fix the extent length.
-	 * Using EXT4_EX_NOFAIL guarantees that ext4_find_extent()
-	 * will not return -ENOMEM, otherwise -ENOMEM will cause a
-	 * retry in do_writepages(), and a WARN_ON may be triggered
-	 * in ext4_da_update_reserve_space() due to an incorrect
-	 * ee_len causing the i_reserved_data_blocks exception.
+	 * Update path is required because previous ext4_ext_insert_extent()
+	 * may have freed or reallocated the path. Using EXT4_EX_NOFAIL
+	 * guarantees that ext4_find_extent() will not return -ENOMEM,
+	 * otherwise -ENOMEM will cause a retry in do_writepages(), and a
+	 * WARN_ON may be triggered in ext4_da_update_reserve_space() due to
+	 * an incorrect ee_len causing the i_reserved_data_blocks exception.
 	 */
-	path = ext4_find_extent(inode, ee_block, NULL,
+	path = ext4_find_extent(inode, ee_block, *ppath,
 				flags | EXT4_EX_NOFAIL);
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
+		*ppath = NULL;
 		return PTR_ERR(path);
 	}
 	depth = ext_depth(inode);
@@ -3318,7 +3308,7 @@ static int ext4_split_extent_at(handle_t *handle,
 	ext4_ext_dirty(handle, inode, path + path->p_depth);
 	return err;
 out:
-	ext4_ext_show_leaf(inode, path);
+	ext4_ext_show_leaf(inode, *ppath);
 	return err;
 }
 
@@ -4309,7 +4299,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	    get_implied_cluster_alloc(inode->i_sb, map, &ex2, path)) {
 		ar.len = allocated = map->m_len;
 		newblock = map->m_pblk;
-		err = 0;
 		goto got_allocated_blocks;
 	}
 
@@ -4382,9 +4371,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		map->m_flags |= EXT4_MAP_UNWRITTEN;
 	}
 
-	path = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
-	if (IS_ERR(path)) {
-		err = PTR_ERR(path);
+	err = ext4_ext_insert_extent(handle, inode, &path, &newex, flags);
+	if (err) {
 		if (allocated_clusters) {
 			int fb_flags = 0;
 
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index a6fa8013c02f5..eee771bef0272 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1831,12 +1831,12 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 			if (ext4_ext_is_unwritten(ex))
 				ext4_ext_mark_unwritten(&newex);
 			down_write(&EXT4_I(inode)->i_data_sem);
-			path = ext4_ext_insert_extent(NULL, inode,
-						      path, &newex, 0);
+			ret = ext4_ext_insert_extent(
+				NULL, inode, &path, &newex, 0);
 			up_write((&EXT4_I(inode)->i_data_sem));
-			if (IS_ERR(path))
-				goto out;
 			ext4_free_ext_path(path);
+			if (ret)
+				goto out;
 			goto next;
 		}
 
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 7a0e429507cf3..0be0467ae6dd2 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -37,6 +37,7 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	path = ext4_find_extent(inode, lb->first_block, NULL, 0);
 	if (IS_ERR(path)) {
 		retval = PTR_ERR(path);
+		path = NULL;
 		goto err_out;
 	}
 
@@ -52,9 +53,7 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	retval = ext4_datasem_ensure_credits(handle, inode, needed, needed, 0);
 	if (retval < 0)
 		goto err_out;
-	path = ext4_ext_insert_extent(handle, inode, path, &newext, 0);
-	if (IS_ERR(path))
-		retval = PTR_ERR(path);
+	retval = ext4_ext_insert_extent(handle, inode, &path, &newext, 0);
 err_out:
 	up_write((&EXT4_I(inode)->i_data_sem));
 	ext4_free_ext_path(path);
-- 
2.53.0



