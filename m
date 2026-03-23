Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4092F3AA1BB;
	Mon, 23 Mar 2026 14:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277769; cv=none; b=dr8gC+lRCPj0mb3YsEYX0EOQ1GWSH8pddA3thh0MDJ79Sh8xgs90ccEdaR7vTWe1V8S2QXTI69xEAb8K7ABNFiIukVxbETHUYRk4fO3gMNFFLCnbJCkE1U2+jMAdm1k7jKgtM4aJ0l4QGsV88WSKxK6gbILuSn8vt2d0gwJrmdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277769; c=relaxed/simple;
	bh=suldFhZgWhF+ot4Wmo8b1JjFriU9avbO1KMcEmPCD/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUxT9qqn/JJEv/bwnSKNpGc847+AELM06B6bTwagOiD3ESAPog/j9JRG1aqZlxb9cSNn7gIRuucXL7fP5PYDjczZFfwMq/l8PUsmO4Qgdh6kFaQ/DGbb+IOAiMfuTBST6MWN4nvFqsi/8H9i+/tSkLzAygNUpUYfJem9tNd6kU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBDNauuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBDNauuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45A3C2BCB8;
	Mon, 23 Mar 2026 14:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277769;
	bh=suldFhZgWhF+ot4Wmo8b1JjFriU9avbO1KMcEmPCD/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBDNauuzgMKo6Myl4A78+ZziV8iNAQePsgfy6VWJLrZ5gfWw7fh+qji0HO6DOdi1G
	 SPnFdFH4bwaENK0pLjc4U8JyFVWZRVFTGjm/r7Jrx2Y8toMTSZnoVQHfzLK5dPY830
	 7jvkmiv4nNWB8xLHvKgRlw7nbukVasIvU6dDnO7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/567] ext4: get rid of ppath in ext4_ext_handle_unwritten_extents()
Date: Mon, 23 Mar 2026 14:39:34 +0100
Message-ID: <20260323134535.148733193@linuxfoundation.org>
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

[ Upstream commit 2ec2e1043473b3d4a3afbe6ad7c5a5b7a6fdf480 ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

To get rid of the ppath in ext4_ext_handle_unwritten_extents(), the
following is done here:

 * Free the extents path when an error is encountered.
 * The 'allocated' is changed from passing a value to passing an address.

No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-22-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: feaf2a80e78f ("ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 82 +++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 45 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index fe39d86d3a7e6..86c814bede1c5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3895,18 +3895,18 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
-static int
+static struct ext4_ext_path *
 ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 			struct ext4_map_blocks *map,
-			struct ext4_ext_path **ppath, int flags,
-			unsigned int allocated, ext4_fsblk_t newblock)
+			struct ext4_ext_path *path, int flags,
+			unsigned int *allocated, ext4_fsblk_t newblock)
 {
 	int err = 0;
 
 	ext_debug(inode, "logical block %llu, max_blocks %u, flags 0x%x, allocated %u\n",
 		  (unsigned long long)map->m_lblk, map->m_len, flags,
-		  allocated);
-	ext4_ext_show_leaf(inode, *ppath);
+		  *allocated);
+	ext4_ext_show_leaf(inode, path);
 
 	/*
 	 * When writing into unwritten space, we should not fail to
@@ -3915,40 +3915,34 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	flags |= EXT4_GET_BLOCKS_METADATA_NOFAIL;
 
 	trace_ext4_ext_handle_unwritten_extents(inode, map, flags,
-						    allocated, newblock);
+						*allocated, newblock);
 
 	/* get_block() before submitting IO, split the extent */
 	if (flags & EXT4_GET_BLOCKS_PRE_IO) {
-		*ppath = ext4_split_convert_extents(handle, inode, map, *ppath,
-				flags | EXT4_GET_BLOCKS_CONVERT, &allocated);
-		if (IS_ERR(*ppath)) {
-			err = PTR_ERR(*ppath);
-			*ppath = NULL;
-			goto out2;
-		}
+		path = ext4_split_convert_extents(handle, inode, map, path,
+				flags | EXT4_GET_BLOCKS_CONVERT, allocated);
+		if (IS_ERR(path))
+			return path;
 		/*
 		 * shouldn't get a 0 allocated when splitting an extent unless
 		 * m_len is 0 (bug) or extent has been corrupted
 		 */
-		if (unlikely(allocated == 0)) {
+		if (unlikely(*allocated == 0)) {
 			EXT4_ERROR_INODE(inode,
 					 "unexpected allocated == 0, m_len = %u",
 					 map->m_len);
 			err = -EFSCORRUPTED;
-			goto out2;
+			goto errout;
 		}
 		map->m_flags |= EXT4_MAP_UNWRITTEN;
 		goto out;
 	}
 	/* IO end_io complete, convert the filled extent to written */
 	if (flags & EXT4_GET_BLOCKS_CONVERT) {
-		*ppath = ext4_convert_unwritten_extents_endio(handle, inode,
-							      map, *ppath);
-		if (IS_ERR(*ppath)) {
-			err = PTR_ERR(*ppath);
-			*ppath = NULL;
-			goto out2;
-		}
+		path = ext4_convert_unwritten_extents_endio(handle, inode,
+							    map, path);
+		if (IS_ERR(path))
+			return path;
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 		goto map_out;
 	}
@@ -3980,23 +3974,20 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	 * For buffered writes, at writepage time, etc.  Convert a
 	 * discovered unwritten extent to written.
 	 */
-	*ppath = ext4_ext_convert_to_initialized(handle, inode, map, *ppath,
-						 flags, &allocated);
-	if (IS_ERR(*ppath)) {
-		err = PTR_ERR(*ppath);
-		*ppath = NULL;
-		goto out2;
-	}
+	path = ext4_ext_convert_to_initialized(handle, inode, map, path,
+					       flags, allocated);
+	if (IS_ERR(path))
+		return path;
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 	/*
 	 * shouldn't get a 0 allocated when converting an unwritten extent
 	 * unless m_len is 0 (bug) or extent has been corrupted
 	 */
-	if (unlikely(allocated == 0)) {
+	if (unlikely(*allocated == 0)) {
 		EXT4_ERROR_INODE(inode, "unexpected allocated == 0, m_len = %u",
 				 map->m_len);
 		err = -EFSCORRUPTED;
-		goto out2;
+		goto errout;
 	}
 
 out:
@@ -4005,12 +3996,15 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 	map->m_flags |= EXT4_MAP_MAPPED;
 out1:
 	map->m_pblk = newblock;
-	if (allocated > map->m_len)
-		allocated = map->m_len;
-	map->m_len = allocated;
-	ext4_ext_show_leaf(inode, *ppath);
-out2:
-	return err ? err : allocated;
+	if (*allocated > map->m_len)
+		*allocated = map->m_len;
+	map->m_len = *allocated;
+	ext4_ext_show_leaf(inode, path);
+	return path;
+
+errout:
+	ext4_free_ext_path(path);
+	return ERR_PTR(err);
 }
 
 /*
@@ -4204,7 +4198,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent newex, *ex, ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0, pblk;
-	int err = 0, depth, ret;
+	int err = 0, depth;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0;
 	struct ext4_allocation_request ar;
@@ -4279,13 +4273,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 				goto out;
 			}
 
-			ret = ext4_ext_handle_unwritten_extents(
-				handle, inode, map, &path, flags,
-				allocated, newblock);
-			if (ret < 0)
-				err = ret;
-			else
-				allocated = ret;
+			path = ext4_ext_handle_unwritten_extents(
+				handle, inode, map, path, flags,
+				&allocated, newblock);
+			if (IS_ERR(path))
+				err = PTR_ERR(path);
 			goto out;
 		}
 	}
-- 
2.51.0



