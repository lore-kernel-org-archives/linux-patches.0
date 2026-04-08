Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C028EB67E;
	Wed,  8 Apr 2026 18:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672226; cv=none; b=UckbO/6JSyvaF/8XerKv8I5JTvjRxSV+BggXB5Gxv6I3ToqoU5xMIQjSzlZf+E+xqv5j+D2E5++iSmZ/txxRUmmFPAJ3Xv6I4zKpvCKB43k/nSm/Od/120FKOklk9mk6JAsRPOJOKDpLxUomE+nw7vZtdY+NxZCbQqPADN7ASxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672226; c=relaxed/simple;
	bh=xjrHZvI4oO/Ex0zDuoALgO0TxrWFEVfDiraCKn7o244=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orzFxR5gTZA96F4Dv/5Q0nR1kRljoEeDNH1WXVrvVHTa0m8qc5dhbd6hE21bH9mHnFGD7EcqjxdNbKeW8iiFigQekW4Qg56tOGJWwkR4WkMH15Ysd4NoXUzgq7xEFt5CGF7oUHCwPq9qvbP8d50tUHoUZmxc4pCT6qOMdbG/HTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYZ8ZjJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYZ8ZjJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5E6C19421;
	Wed,  8 Apr 2026 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672226;
	bh=xjrHZvI4oO/Ex0zDuoALgO0TxrWFEVfDiraCKn7o244=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYZ8ZjJz1aak2vAN8BZkMiB+PTUbPgdEN3biHB6HwxzKDGJohv2CntxSjddJUGIpt
	 +flv8u9PqwFj1Lo3usIChokZ5FIvwsuOzy5jOvaNbLiWKkjlptl1QGYbQLbe3vgUlW
	 iWJ+UOl3PVuvngG4KqfGUVV8gnDgOgpKyRxQJ9a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/312] Revert "ext4: get rid of ppath in ext4_split_extent_at()"
Date: Wed,  8 Apr 2026 20:02:36 +0200
Message-ID: <20260408175942.677671756@linuxfoundation.org>
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

This reverts commit 4d03e2046f73158feb886a45d5682c3b79066872.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 85 +++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6da0bf3cf406d..59c0bffc691d1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -84,11 +84,12 @@ static void ext4_extent_block_csum_set(struct inode *inode,
 	et->et_checksum = ext4_extent_block_csum(inode, eh);
 }
 
-static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
-						  struct inode *inode,
-						  struct ext4_ext_path *path,
-						  ext4_lblk_t split,
-						  int split_flag, int flags);
+static int ext4_split_extent_at(handle_t *handle,
+			     struct inode *inode,
+			     struct ext4_ext_path **ppath,
+			     ext4_lblk_t split,
+			     int split_flag,
+			     int flags);
 
 static int ext4_ext_trunc_restart_fn(struct inode *inode, int *dropped)
 {
@@ -334,15 +335,9 @@ ext4_force_split_extent_at(handle_t *handle, struct inode *inode,
 	if (nofail)
 		flags |= EXT4_GET_BLOCKS_METADATA_NOFAIL | EXT4_EX_NOFAIL;
 
-	path = ext4_split_extent_at(handle, inode, path, lblk, unwritten ?
+	return ext4_split_extent_at(handle, inode, ppath, lblk, unwritten ?
 			EXT4_EXT_MARK_UNWRIT1|EXT4_EXT_MARK_UNWRIT2 : 0,
 			flags);
-	if (IS_ERR(path)) {
-		*ppath = NULL;
-		return PTR_ERR(path);
-	}
-	*ppath = path;
-	return 0;
 }
 
 static int
@@ -694,7 +689,7 @@ static void ext4_ext_show_leaf(struct inode *inode, struct ext4_ext_path *path)
 	struct ext4_extent *ex;
 	int i;
 
-	if (IS_ERR_OR_NULL(path))
+	if (!path)
 		return;
 
 	eh = path[depth].p_hdr;
@@ -3160,14 +3155,16 @@ static int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
  *  a> the extent are splitted into two extent.
  *  b> split is not needed, and just mark the extent.
  *
- * Return an extent path pointer on success, or an error pointer on failure.
+ * return 0 on success.
  */
-static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
-						  struct inode *inode,
-						  struct ext4_ext_path *path,
-						  ext4_lblk_t split,
-						  int split_flag, int flags)
+static int ext4_split_extent_at(handle_t *handle,
+			     struct inode *inode,
+			     struct ext4_ext_path **ppath,
+			     ext4_lblk_t split,
+			     int split_flag,
+			     int flags)
 {
+	struct ext4_ext_path *path = *ppath;
 	ext4_fsblk_t newblock;
 	ext4_lblk_t ee_block;
 	struct ext4_extent *ex, newex, orig_ex, zero_ex;
@@ -3241,12 +3238,14 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 		ext4_ext_mark_unwritten(ex2);
 
 	path = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
-	if (!IS_ERR(path))
+	if (!IS_ERR(path)) {
+		*ppath = path;
 		goto out;
-
+	}
+	*ppath = NULL;
 	err = PTR_ERR(path);
 	if (err != -ENOSPC && err != -EDQUOT && err != -ENOMEM)
-		return path;
+		return err;
 
 	/*
 	 * Get a new path to try to zeroout or fix the extent length.
@@ -3256,14 +3255,16 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	 * in ext4_da_update_reserve_space() due to an incorrect
 	 * ee_len causing the i_reserved_data_blocks exception.
 	 */
-	path = ext4_find_extent(inode, ee_block, NULL, flags | EXT4_EX_NOFAIL);
+	path = ext4_find_extent(inode, ee_block, NULL,
+				flags | EXT4_EX_NOFAIL);
 	if (IS_ERR(path)) {
 		EXT4_ERROR_INODE(inode, "Failed split extent on %u, err %ld",
 				 split, PTR_ERR(path));
-		return path;
+		return PTR_ERR(path);
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
+	*ppath = path;
 
 	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {
 		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
@@ -3315,13 +3316,10 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
 	 * and err is a non-zero error code.
 	 */
 	ext4_ext_dirty(handle, inode, path + path->p_depth);
+	return err;
 out:
-	if (err) {
-		ext4_free_ext_path(path);
-		path = ERR_PTR(err);
-	}
 	ext4_ext_show_leaf(inode, path);
-	return path;
+	return err;
 }
 
 /*
@@ -3368,14 +3366,10 @@ static int ext4_split_extent(handle_t *handle,
 				       EXT4_EXT_MARK_UNWRIT2;
 		if (split_flag & EXT4_EXT_DATA_VALID2)
 			split_flag1 |= EXT4_EXT_DATA_VALID1;
-		path = ext4_split_extent_at(handle, inode, path,
+		err = ext4_split_extent_at(handle, inode, ppath,
 				map->m_lblk + map->m_len, split_flag1, flags1);
-		if (IS_ERR(path)) {
-			err = PTR_ERR(path);
-			*ppath = NULL;
+		if (err)
 			goto out;
-		}
-		*ppath = path;
 	} else {
 		allocated = ee_len - (map->m_lblk - ee_block);
 	}
@@ -3383,7 +3377,7 @@ static int ext4_split_extent(handle_t *handle,
 	 * Update path is required because previous ext4_split_extent_at() may
 	 * result in split of original leaf or extent zeroout.
 	 */
-	path = ext4_find_extent(inode, map->m_lblk, path, flags);
+	path = ext4_find_extent(inode, map->m_lblk, *ppath, flags);
 	if (IS_ERR(path)) {
 		*ppath = NULL;
 		return PTR_ERR(path);
@@ -3405,17 +3399,13 @@ static int ext4_split_extent(handle_t *handle,
 			split_flag1 |= split_flag & (EXT4_EXT_MAY_ZEROOUT |
 						     EXT4_EXT_MARK_UNWRIT2);
 		}
-		path = ext4_split_extent_at(handle, inode, path,
+		err = ext4_split_extent_at(handle, inode, ppath,
 				map->m_lblk, split_flag1, flags);
-		if (IS_ERR(path)) {
-			err = PTR_ERR(path);
-			*ppath = NULL;
+		if (err)
 			goto out;
-		}
-		*ppath = path;
 	}
 
-	ext4_ext_show_leaf(inode, path);
+	ext4_ext_show_leaf(inode, *ppath);
 out:
 	return err ? err : allocated;
 }
@@ -5611,21 +5601,22 @@ static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 			if (ext4_ext_is_unwritten(extent))
 				split_flag = EXT4_EXT_MARK_UNWRIT1 |
 					EXT4_EXT_MARK_UNWRIT2;
-			path = ext4_split_extent_at(handle, inode, path,
+			ret = ext4_split_extent_at(handle, inode, &path,
 					offset_lblk, split_flag,
 					EXT4_EX_NOCACHE |
 					EXT4_GET_BLOCKS_PRE_IO |
 					EXT4_GET_BLOCKS_METADATA_NOFAIL);
 		}
 
-		if (IS_ERR(path)) {
+		ext4_free_ext_path(path);
+		if (ret < 0) {
 			up_write(&EXT4_I(inode)->i_data_sem);
-			ret = PTR_ERR(path);
 			goto out_stop;
 		}
+	} else {
+		ext4_free_ext_path(path);
 	}
 
-	ext4_free_ext_path(path);
 	ext4_es_remove_extent(inode, offset_lblk, EXT_MAX_BLOCKS - offset_lblk);
 
 	/*
-- 
2.53.0



