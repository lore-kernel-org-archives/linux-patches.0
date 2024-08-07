Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E2C374CC;
	Wed,  7 Aug 2024 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043593; cv=none; b=XLMGJp8MZZJUI1wO8gsfubG06YBXVfLXk6LPf2CTItjAl0pqKCEukpAbUzQ5/JhS+xGxI19qlqPCaRiUJQLuhyxVAaZr5vTZB1yRE4AzDI6jgL3318CeeZ9047Yy0TIGtWrRvL/5/JF3v7FyklSjiyvXUyp7dG3dzPUOHQP8508=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043593; c=relaxed/simple;
	bh=Q8Svk2/5U4dbbggSrezZjiNEGxAXLMsYggAObh3dvY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBjuL/455qQFgoncy9knMLLQUPnxRf4aIu+WEhXVnWPH1FuE3zlLM1wBe665PWTCzclXo7+R2RaGm6TQrhGfwHFxjxGwGq4tJ4kB0Hyve1uiIImsnhNk3K62bzl1EevuwYUnVz5QfLzv+FVDnUiQJwteAIkE1JcO1U32j+ERa4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVlm4Fg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVlm4Fg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D4DC32781;
	Wed,  7 Aug 2024 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043593;
	bh=Q8Svk2/5U4dbbggSrezZjiNEGxAXLMsYggAObh3dvY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVlm4Fg0taMePwp3J7Ml2lPql+UbrQY1Jxc98YsaGa86MK2q9b4tTWNERPAaoN5kA
	 yJIWleM4MOv1JRSZHU1N5AOCvnVKDUCJ6oZIrDLDgnPtF5ohlmXOxRmpJT/Z0awPHO
	 ymCno90bz7bXwpLceqWjWxdzC4O4+te8R/7Ldm3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/86] ext4: make ext4_es_insert_extent() return void
Date: Wed,  7 Aug 2024 16:59:47 +0200
Message-ID: <20240807150039.523957970@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 6c120399cde6b1b5cf65ce403765c579fb3d3e50 ]

Now ext4_es_insert_extent() never return error, so make it return void.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-12-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 0ea6560abb3b ("ext4: check the extent status again before inserting delalloc block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c        |  5 +++--
 fs/ext4/extents_status.c | 14 ++++++--------
 fs/ext4/extents_status.h |  6 +++---
 fs/ext4/inode.c          | 21 ++++++---------------
 4 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 67af684e44e6e..5cbe5ae5ad4a2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3113,8 +3113,9 @@ static int ext4_zeroout_es(struct inode *inode, struct ext4_extent *ex)
 	if (ee_len == 0)
 		return 0;
 
-	return ext4_es_insert_extent(inode, ee_block, ee_len, ee_pblock,
-				     EXTENT_STATUS_WRITTEN);
+	ext4_es_insert_extent(inode, ee_block, ee_len, ee_pblock,
+			      EXTENT_STATUS_WRITTEN);
+	return 0;
 }
 
 /* FIXME!! we need to try to merge to left or right after zero-out  */
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 9766d3b21ca2e..592229027af72 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -847,12 +847,10 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
 /*
  * ext4_es_insert_extent() adds information to an inode's extent
  * status tree.
- *
- * Return 0 on success, error code on failure.
  */
-int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
-			  ext4_lblk_t len, ext4_fsblk_t pblk,
-			  unsigned int status)
+void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
+			   ext4_lblk_t len, ext4_fsblk_t pblk,
+			   unsigned int status)
 {
 	struct extent_status newes;
 	ext4_lblk_t end = lblk + len - 1;
@@ -864,13 +862,13 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	bool revise_pending = false;
 
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
-		return 0;
+		return;
 
 	es_debug("add [%u/%u) %llu %x to extent status tree of inode %lu\n",
 		 lblk, len, pblk, status, inode->i_ino);
 
 	if (!len)
-		return 0;
+		return;
 
 	BUG_ON(end < lblk);
 
@@ -939,7 +937,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 		goto retry;
 
 	ext4_es_print_tree(inode);
-	return 0;
+	return;
 }
 
 /*
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 4ec30a7982605..481ec4381bee6 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -127,9 +127,9 @@ extern int __init ext4_init_es(void);
 extern void ext4_exit_es(void);
 extern void ext4_es_init_tree(struct ext4_es_tree *tree);
 
-extern int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
-				 ext4_lblk_t len, ext4_fsblk_t pblk,
-				 unsigned int status);
+extern void ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
+				  ext4_lblk_t len, ext4_fsblk_t pblk,
+				  unsigned int status);
 extern void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len, ext4_fsblk_t pblk,
 				 unsigned int status);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2479508deab3b..6dc15ad45ac95 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -595,10 +595,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
 				       map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
-		ret = ext4_es_insert_extent(inode, map->m_lblk,
-					    map->m_len, map->m_pblk, status);
-		if (ret < 0)
-			retval = ret;
+		ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
+				      map->m_pblk, status);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
@@ -707,12 +705,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
 				       map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
-		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
-					    map->m_pblk, status);
-		if (ret < 0) {
-			retval = ret;
-			goto out_sem;
-		}
+		ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
+				      map->m_pblk, status);
 	}
 
 out_sem:
@@ -1812,7 +1806,6 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		set_buffer_new(bh);
 		set_buffer_delay(bh);
 	} else if (retval > 0) {
-		int ret;
 		unsigned int status;
 
 		if (unlikely(retval != map->m_len)) {
@@ -1825,10 +1818,8 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 
 		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
-		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
-					    map->m_pblk, status);
-		if (ret != 0)
-			retval = ret;
+		ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
+				      map->m_pblk, status);
 	}
 
 out_unlock:
-- 
2.43.0



