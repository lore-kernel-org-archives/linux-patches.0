Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86057387599;
	Mon, 23 Mar 2026 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277741; cv=none; b=tXMHy2C656tL+BqZITWmpaLq1MiPFJiUjl0rlVRRI6F9sfKUs7rAAOrO/6QsuH0pI8yaHnjrYJcftGdDUU1VuZte0WwQMDMlY3R0/HIYfreTw6ivA7EbzARWdXwOge02FiGeqrdlUDoki9CWinVxE26DvsSiydOwFmQOIHxIDhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277741; c=relaxed/simple;
	bh=ysBbX9tuIe8epelh0a+dgF8Ckk0qB4nAcgLiWbvNoxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ep2W8h7jq/bn0yWR5Zw+vehUdzFnYLKpSdc4TLs8BhsQpRa9dD99hiX3hsX1i/pbIpHsWvMKLGqVKI97tfB/sdovRQ3CT7OVbEOAGt6FTpi4B/1GBY/LCJNmfyrokjDtBZ3RvtqvXB3DNmEpdzRKwHaydPo8mHuYiDlyY8h1tgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0/LXpHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0/LXpHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1297CC4CEF7;
	Mon, 23 Mar 2026 14:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277741;
	bh=ysBbX9tuIe8epelh0a+dgF8Ckk0qB4nAcgLiWbvNoxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0/LXpHvCV4jybhtUIbqdvjFDHWy7aEw7kewWHhMMk0bbjtGmTca/4mDktOPORTMj
	 wtuoFehhN6m1vwU7l4XroKx4EMUjx1XFoqM8STeuxfhzTg8KK1vDD/Ilq+7OUv+kkZ
	 KQsy15/yL4W1Ik5dDaI55YooiVVogjFxxtudLUb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/567] ext4: get rid of ppath in ext4_split_convert_extents()
Date: Mon, 23 Mar 2026 14:39:31 +0100
Message-ID: <20260323134535.073690966@linuxfoundation.org>
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

[ Upstream commit 225057b1af381567ffa4eb813f4a28a5c38a25cf ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

To get rid of the ppath in ext4_split_convert_extents(), the following is
done here:

 * Its caller needs to update ppath if it uses ppath.

No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-19-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: feaf2a80e78f ("ext4: don't set EXT4_GET_BLOCKS_CONVERT when splitting before submitting I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 65 ++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 89d3baac7a79c..27bacfa7d492c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3707,21 +3707,21 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
  * being filled will be convert to initialized by the end_io callback function
  * via ext4_convert_unwritten_extents().
  *
- * Returns the size of unwritten extent to be written on success.
+ * The size of unwritten extent to be written is passed to the caller via the
+ * allocated pointer. Return an extent path pointer on success, or an error
+ * pointer on failure.
  */
-static int ext4_split_convert_extents(handle_t *handle,
+static struct ext4_ext_path *ext4_split_convert_extents(handle_t *handle,
 					struct inode *inode,
 					struct ext4_map_blocks *map,
-					struct ext4_ext_path **ppath,
-					int flags)
+					struct ext4_ext_path *path,
+					int flags, unsigned int *allocated)
 {
-	struct ext4_ext_path *path = *ppath;
 	ext4_lblk_t eof_block;
 	ext4_lblk_t ee_block;
 	struct ext4_extent *ex;
 	unsigned int ee_len;
 	int split_flag = 0, depth;
-	unsigned int allocated = 0;
 
 	ext_debug(inode, "logical block %llu, max_blocks %u\n",
 		  (unsigned long long)map->m_lblk, map->m_len);
@@ -3749,14 +3749,8 @@ static int ext4_split_convert_extents(handle_t *handle,
 		split_flag |= (EXT4_EXT_MARK_UNWRIT2 | EXT4_EXT_DATA_VALID2);
 	}
 	flags |= EXT4_GET_BLOCKS_PRE_IO;
-	path = ext4_split_extent(handle, inode, path, map, split_flag, flags,
-				 &allocated);
-	if (IS_ERR(path)) {
-		*ppath = NULL;
-		return PTR_ERR(path);
-	}
-	*ppath = path;
-	return allocated;
+	return ext4_split_extent(handle, inode, path, map, split_flag, flags,
+				 allocated);
 }
 
 static int ext4_convert_unwritten_extents_endio(handle_t *handle,
@@ -3792,11 +3786,14 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 			     inode->i_ino, (unsigned long long)ee_block, ee_len,
 			     (unsigned long long)map->m_lblk, map->m_len);
 #endif
-		err = ext4_split_convert_extents(handle, inode, map, ppath,
-						 EXT4_GET_BLOCKS_CONVERT);
-		if (err < 0)
-			return err;
-		path = ext4_find_extent(inode, map->m_lblk, *ppath, 0);
+		path = ext4_split_convert_extents(handle, inode, map, path,
+						EXT4_GET_BLOCKS_CONVERT, NULL);
+		if (IS_ERR(path)) {
+			*ppath = NULL;
+			return PTR_ERR(path);
+		}
+
+		path = ext4_find_extent(inode, map->m_lblk, path, 0);
 		if (IS_ERR(path)) {
 			*ppath = NULL;
 			return PTR_ERR(path);
@@ -3853,11 +3850,14 @@ convert_initialized_extent(handle_t *handle, struct inode *inode,
 		  (unsigned long long)ee_block, ee_len);
 
 	if (ee_block != map->m_lblk || ee_len > map->m_len) {
-		err = ext4_split_convert_extents(handle, inode, map, ppath,
-				EXT4_GET_BLOCKS_CONVERT_UNWRITTEN);
-		if (err < 0)
-			return err;
-		path = ext4_find_extent(inode, map->m_lblk, *ppath, 0);
+		path = ext4_split_convert_extents(handle, inode, map, path,
+				EXT4_GET_BLOCKS_CONVERT_UNWRITTEN, NULL);
+		if (IS_ERR(path)) {
+			*ppath = NULL;
+			return PTR_ERR(path);
+		}
+
+		path = ext4_find_extent(inode, map->m_lblk, path, 0);
 		if (IS_ERR(path)) {
 			*ppath = NULL;
 			return PTR_ERR(path);
@@ -3923,19 +3923,20 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 
 	/* get_block() before submitting IO, split the extent */
 	if (flags & EXT4_GET_BLOCKS_PRE_IO) {
-		ret = ext4_split_convert_extents(handle, inode, map, ppath,
-					 flags | EXT4_GET_BLOCKS_CONVERT);
-		if (ret < 0) {
-			err = ret;
+		*ppath = ext4_split_convert_extents(handle, inode, map, *ppath,
+				flags | EXT4_GET_BLOCKS_CONVERT, &allocated);
+		if (IS_ERR(*ppath)) {
+			err = PTR_ERR(*ppath);
+			*ppath = NULL;
 			goto out2;
 		}
 		/*
-		 * shouldn't get a 0 return when splitting an extent unless
+		 * shouldn't get a 0 allocated when splitting an extent unless
 		 * m_len is 0 (bug) or extent has been corrupted
 		 */
-		if (unlikely(ret == 0)) {
+		if (unlikely(allocated == 0)) {
 			EXT4_ERROR_INODE(inode,
-					 "unexpected ret == 0, m_len = %u",
+					 "unexpected allocated == 0, m_len = %u",
 					 map->m_len);
 			err = -EFSCORRUPTED;
 			goto out2;
@@ -3996,9 +3997,9 @@ ext4_ext_handle_unwritten_extents(handle_t *handle, struct inode *inode,
 		err = -EFSCORRUPTED;
 		goto out2;
 	}
+	allocated = ret;
 
 out:
-	allocated = ret;
 	map->m_flags |= EXT4_MAP_NEW;
 map_out:
 	map->m_flags |= EXT4_MAP_MAPPED;
-- 
2.51.0



