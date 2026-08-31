Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D8247A0B4;
	Mon, 31 Aug 2026 13:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184519; cv=none; b=cc2lP+HReCsijHx8Skg4N7uT34eefpMIVuaPViagrcgjlBJDN3beLBrJTl/XR2J2XuzG4oQmH/UqPc1Y1GDJyDXFbqH2ReZVl2F+Y6PP+FiNXchxSdoOR+kwDsVF+QuRbrrqonXR6hnn6T+XfLXVOiD6ykZRDhsleaO+cUhwSeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184519; c=relaxed/simple;
	bh=zVlBS/PSe7zZVPCsnR7hG1KW4G5w8Tn/xWSz2yuwPos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ax6/nat7KETH0Yzis1F6T5KtBUHovQ8z+sV2JWzv3J2aAf6Qhx/nsRqOTVWRPcBRPL0ew3hCEso1RR4xZ5p/uYH8eas0lr91eLyIe+MRSSAFnjWiDC1mOCdm0XyjEUQMY5yJMJ5CzPemEdrBHFr2OrkdA4Ys5wUfXEOeBVSl100=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kdm0HrXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kdm0HrXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283111F000E9;
	Mon, 31 Aug 2026 13:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184516;
	bh=iEqgLgO+0iaSluT+I7kP5+fWMJb1Jdc3oWsbphi4mRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kdm0HrXeooe9zRH6rZeihdSB2yqe5mI9046EQCbUhk3gKkkUsXpDhV4o+MQV3wjae
	 ro8H8Pwk1C6Kag49/bYCu3pmdDHmiwEqmwBnY6XmB3VUCzI8QwEXCx/hiMul5smqle
	 VGiAQ+aVvfIxo5xvjuTZvyHAymm8a9Jo5n2SeJ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/91] ext4: make some fast commit functions reuse extents path
Date: Mon, 31 Aug 2026 15:34:24 +0200
Message-ID: <20260831133401.608410785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

[ Upstream commit 2352e3e461926b59f01c1e39fbb0494891cff997 ]

The ext4_find_extent() can update the extent path so that it does not have
to allocate and free the path repeatedly, thus reducing the consumption of
memory allocation and freeing in the following functions:

    ext4_ext_clear_bb
    ext4_ext_replay_set_iblocks
    ext4_fc_replay_add_range
    ext4_fc_set_bitmaps_and_counters

No functional changes. Note that ext4_find_extent() does not support error
pointers, so in this case set path to NULL first.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-25-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d8b8dd3530bf ("ext4: propagate errors from fast commit range replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c     |   51 +++++++++++++++++++++-----------------------------
 fs/ext4/fast_commit.c |   11 ++++++----
 2 files changed, 29 insertions(+), 33 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -6092,12 +6092,9 @@ int ext4_ext_replay_set_iblocks(struct i
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	ex = path[path->p_depth].p_ext;
-	if (!ex) {
-		ext4_free_ext_path(path);
+	if (!ex)
 		goto out;
-	}
 	end = le32_to_cpu(ex->ee_block) + ext4_ext_get_actual_len(ex);
-	ext4_free_ext_path(path);
 
 	/* Count the number of data blocks */
 	cur = 0;
@@ -6123,32 +6120,28 @@ int ext4_ext_replay_set_iblocks(struct i
 	ret = skip_hole(inode, &cur);
 	if (ret < 0)
 		goto out;
-	path = ext4_find_extent(inode, cur, NULL, 0);
+	path = ext4_find_extent(inode, cur, path, 0);
 	if (IS_ERR(path))
 		goto out;
 	numblks += path->p_depth;
-	ext4_free_ext_path(path);
 	while (cur < end) {
-		path = ext4_find_extent(inode, cur, NULL, 0);
+		path = ext4_find_extent(inode, cur, path, 0);
 		if (IS_ERR(path))
 			break;
 		ex = path[path->p_depth].p_ext;
-		if (!ex) {
-			ext4_free_ext_path(path);
-			return 0;
-		}
+		if (!ex)
+			goto cleanup;
+
 		cur = max(cur + 1, le32_to_cpu(ex->ee_block) +
 					ext4_ext_get_actual_len(ex));
 		ret = skip_hole(inode, &cur);
-		if (ret < 0) {
-			ext4_free_ext_path(path);
+		if (ret < 0)
 			break;
-		}
-		path2 = ext4_find_extent(inode, cur, NULL, 0);
-		if (IS_ERR(path2)) {
-			ext4_free_ext_path(path);
+
+		path2 = ext4_find_extent(inode, cur, path2, 0);
+		if (IS_ERR(path2))
 			break;
-		}
+
 		for (i = 0; i <= max(path->p_depth, path2->p_depth); i++) {
 			cmp1 = cmp2 = 0;
 			if (i <= path->p_depth)
@@ -6160,13 +6153,14 @@ int ext4_ext_replay_set_iblocks(struct i
 			if (cmp1 != cmp2 && cmp2 != 0)
 				numblks++;
 		}
-		ext4_free_ext_path(path);
-		ext4_free_ext_path(path2);
 	}
 
 out:
 	inode->i_blocks = numblks << (inode->i_sb->s_blocksize_bits - 9);
 	ext4_mark_inode_dirty(NULL, inode);
+cleanup:
+	ext4_free_ext_path(path);
+	ext4_free_ext_path(path2);
 	return 0;
 }
 
@@ -6187,12 +6181,9 @@ int ext4_ext_clear_bb(struct inode *inod
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	ex = path[path->p_depth].p_ext;
-	if (!ex) {
-		ext4_free_ext_path(path);
-		return 0;
-	}
+	if (!ex)
+		goto out;
 	end = le32_to_cpu(ex->ee_block) + ext4_ext_get_actual_len(ex);
-	ext4_free_ext_path(path);
 
 	cur = 0;
 	while (cur < end) {
@@ -6202,16 +6193,16 @@ int ext4_ext_clear_bb(struct inode *inod
 		if (ret < 0)
 			break;
 		if (ret > 0) {
-			path = ext4_find_extent(inode, map.m_lblk, NULL, 0);
-			if (!IS_ERR_OR_NULL(path)) {
+			path = ext4_find_extent(inode, map.m_lblk, path, 0);
+			if (!IS_ERR(path)) {
 				for (j = 0; j < path->p_depth; j++) {
-
 					ext4_mb_mark_bb(inode->i_sb,
 							path[j].p_block, 1, false);
 					ext4_fc_record_regions(inode->i_sb, inode->i_ino,
 							0, path[j].p_block, 1, 1);
 				}
-				ext4_free_ext_path(path);
+			} else {
+				path = NULL;
 			}
 			ext4_mb_mark_bb(inode->i_sb, map.m_pblk, map.m_len, false);
 			ext4_fc_record_regions(inode->i_sb, inode->i_ino,
@@ -6220,5 +6211,7 @@ int ext4_ext_clear_bb(struct inode *inod
 		cur = cur + map.m_len;
 	}
 
+out:
+	ext4_free_ext_path(path);
 	return 0;
 }
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1798,7 +1798,7 @@ static int ext4_fc_replay_add_range(stru
 
 		if (ret == 0) {
 			/* Range is not mapped */
-			path = ext4_find_extent(inode, cur, NULL, 0);
+			path = ext4_find_extent(inode, cur, path, 0);
 			if (IS_ERR(path))
 				goto out;
 			memset(&newex, 0, sizeof(newex));
@@ -1814,7 +1814,6 @@ static int ext4_fc_replay_add_range(stru
 			up_write((&EXT4_I(inode)->i_data_sem));
 			if (IS_ERR(path))
 				goto out;
-			ext4_free_ext_path(path);
 			goto next;
 		}
 
@@ -1862,6 +1861,7 @@ next:
 	ext4_ext_replay_shrink_inode(inode, i_size_read(inode) >>
 					sb->s_blocksize_bits);
 out:
+	ext4_free_ext_path(path);
 	iput(inode);
 	return 0;
 }
@@ -1962,12 +1962,13 @@ static void ext4_fc_set_bitmaps_and_coun
 				break;
 
 			if (ret > 0) {
-				path = ext4_find_extent(inode, map.m_lblk, NULL, 0);
+				path = ext4_find_extent(inode, map.m_lblk, path, 0);
 				if (!IS_ERR(path)) {
 					for (j = 0; j < path->p_depth; j++)
 						ext4_mb_mark_bb(inode->i_sb,
 							path[j].p_block, 1, true);
-					ext4_free_ext_path(path);
+				} else {
+					path = NULL;
 				}
 				cur += ret;
 				ext4_mb_mark_bb(inode->i_sb, map.m_pblk,
@@ -1978,6 +1979,8 @@ static void ext4_fc_set_bitmaps_and_coun
 		}
 		iput(inode);
 	}
+
+	ext4_free_ext_path(path);
 }
 
 /*


