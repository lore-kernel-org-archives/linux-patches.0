Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D263AEF58;
	Mon, 23 Mar 2026 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277706; cv=none; b=WjiX38Q/aHZetuoRi5GLhIz0/NLkNNQQy7pwQBaqdpE97qfq+D3itv9p8+RlhVw6PniMLp6JXIK7BBZuThNzFNhhCzCXtH/1wQ6f4OYRuiktgK0tPaPuOm9/2irPQXYGevhPXELnASrHkcIoL12VWP12yAyE9pI7LVWZFiFLZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277706; c=relaxed/simple;
	bh=N1J2EJuaBSHspS5RAs/Ncgpr56WddLJlBkZ+JkFhL7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drBY4orOMHSPJ/dZJGnuPG3ngM6Yq8AW35PLnTdi+SL8ad54PPRpjUbGMiE1u+fchGj2R9cfKPYoEvzRwCYNPt7heMcHBg8hDWyQ4o3RTTzuybHmGz3iVSUqnO4YgqXximCuE59s6E+TbiUb4JxTDlV7t2d03Pf8iiw+0toChMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qevRxHxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qevRxHxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466E5C4CEF7;
	Mon, 23 Mar 2026 14:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277706;
	bh=N1J2EJuaBSHspS5RAs/Ncgpr56WddLJlBkZ+JkFhL7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qevRxHxcr06q9Rx9I22lNO4HHa956xAwRJOMSAHcnI0AIFfGLEMJ2nTxOSiYwUnLQ
	 QaNoai/RFqCj1Vnuq4XvPRkor6x+Bp6LFjDgsYBczsh6UAJom5ce0kcwjbDKfxuewC
	 Ou4mzRR9urfLVaFvR7gXnYhu2miqWGcfNjJ7y5m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/567] ext4: get rid of ppath in ext4_split_extent()
Date: Mon, 23 Mar 2026 14:39:30 +0100
Message-ID: <20260323134535.045753753@linuxfoundation.org>
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

[ Upstream commit f74cde045617cc275c848c9692feac249ff7a3e7 ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

To get rid of the ppath in ext4_split_extent(), the following is done here:

 * The 'allocated' is changed from passing a value to passing an address.
 * Its caller needs to update ppath if it uses ppath.

No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-18-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: feaf2a80e78f ("ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 97 ++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index fd9517dbf633e..89d3baac7a79c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3348,21 +3348,18 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
  *   c> Splits in three extents: Somone is splitting in middle of the extent
  *
  */
-static int ext4_split_extent(handle_t *handle,
-			      struct inode *inode,
-			      struct ext4_ext_path **ppath,
-			      struct ext4_map_blocks *map,
-			      int split_flag,
-			      int flags)
+static struct ext4_ext_path *ext4_split_extent(handle_t *handle,
+					       struct inode *inode,
+					       struct ext4_ext_path *path,
+					       struct ext4_map_blocks *map,
+					       int split_flag, int flags,
+					       unsigned int *allocated)
 {
-	struct ext4_ext_path *path = *ppath;
 	ext4_lblk_t ee_block;
 	struct ext4_extent *ex;
 	unsigned int ee_len, depth;
-	int err = 0;
 	int unwritten;
 	int split_flag1, flags1;
-	int allocated = map->m_len;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3385,33 +3382,25 @@ static int ext4_split_extent(handle_t *handle,
 				       EXT4_EXT_DATA_ENTIRE_VALID1;
 		path = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk + map->m_len, split_flag1, flags1);
-		if (IS_ERR(path)) {
-			err = PTR_ERR(path);
-			*ppath = NULL;
-			goto out;
+		if (IS_ERR(path))
+			return path;
+		/*
+		 * Update path is required because previous ext4_split_extent_at
+		 * may result in split of original leaf or extent zeroout.
+		 */
+		path = ext4_find_extent(inode, map->m_lblk, path, flags);
+		if (IS_ERR(path))
+			return path;
+		depth = ext_depth(inode);
+		ex = path[depth].p_ext;
+		if (!ex) {
+			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
+					(unsigned long) map->m_lblk);
+			ext4_free_ext_path(path);
+			return ERR_PTR(-EFSCORRUPTED);
 		}
-		*ppath = path;
-	} else {
-		allocated = ee_len - (map->m_lblk - ee_block);
-	}
-	/*
-	 * Update path is required because previous ext4_split_extent_at() may
-	 * result in split of original leaf or extent zeroout.
-	 */
-	path = ext4_find_extent(inode, map->m_lblk, path, flags);
-	if (IS_ERR(path)) {
-		*ppath = NULL;
-		return PTR_ERR(path);
-	}
-	*ppath = path;
-	depth = ext_depth(inode);
-	ex = path[depth].p_ext;
-	if (!ex) {
-		EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
-				 (unsigned long) map->m_lblk);
-		return -EFSCORRUPTED;
+		unwritten = ext4_ext_is_unwritten(ex);
 	}
-	unwritten = ext4_ext_is_unwritten(ex);
 
 	if (map->m_lblk >= ee_block) {
 		split_flag1 = split_flag & EXT4_EXT_DATA_VALID2;
@@ -3422,17 +3411,18 @@ static int ext4_split_extent(handle_t *handle,
 		}
 		path = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk, split_flag1, flags);
-		if (IS_ERR(path)) {
-			err = PTR_ERR(path);
-			*ppath = NULL;
-			goto out;
-		}
-		*ppath = path;
+		if (IS_ERR(path))
+			return path;
 	}
 
+	if (allocated) {
+		if (map->m_lblk + map->m_len > ee_block + ee_len)
+			*allocated = ee_len - (map->m_lblk - ee_block);
+		else
+			*allocated = map->m_len;
+	}
 	ext4_ext_show_leaf(inode, path);
-out:
-	return err ? err : allocated;
+	return path;
 }
 
 /*
@@ -3677,10 +3667,15 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	}
 
 fallback:
-	err = ext4_split_extent(handle, inode, ppath, &split_map, split_flag,
-				flags);
-	if (err > 0)
-		err = 0;
+	path = ext4_split_extent(handle, inode, path, &split_map, split_flag,
+				 flags, NULL);
+	if (IS_ERR(path)) {
+		err = PTR_ERR(path);
+		*ppath = NULL;
+		goto out;
+	}
+	err = 0;
+	*ppath = path;
 out:
 	/* If we have gotten a failure, don't zero out status tree */
 	if (!err) {
@@ -3726,6 +3721,7 @@ static int ext4_split_convert_extents(handle_t *handle,
 	struct ext4_extent *ex;
 	unsigned int ee_len;
 	int split_flag = 0, depth;
+	unsigned int allocated = 0;
 
 	ext_debug(inode, "logical block %llu, max_blocks %u\n",
 		  (unsigned long long)map->m_lblk, map->m_len);
@@ -3753,7 +3749,14 @@ static int ext4_split_convert_extents(handle_t *handle,
 		split_flag |= (EXT4_EXT_MARK_UNWRIT2 | EXT4_EXT_DATA_VALID2);
 	}
 	flags |= EXT4_GET_BLOCKS_PRE_IO;
-	return ext4_split_extent(handle, inode, ppath, map, split_flag, flags);
+	path = ext4_split_extent(handle, inode, path, map, split_flag, flags,
+				 &allocated);
+	if (IS_ERR(path)) {
+		*ppath = NULL;
+		return PTR_ERR(path);
+	}
+	*ppath = path;
+	return allocated;
 }
 
 static int ext4_convert_unwritten_extents_endio(handle_t *handle,
-- 
2.51.0



