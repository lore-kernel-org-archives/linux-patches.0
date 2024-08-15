Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662071714A1;
	Thu, 15 Aug 2024 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730209; cv=none; b=E2HRVF/dNV1KZkgN6ReVFPNQWvj3D98kPJ7wJkPjgzcj3r1j7gWivrX3ciAR0WWTRj8txE2qVu2OYQAbbdpN+P3IJKZaMTmRQw40a+Z8x/1z4so8nTiMvQgpGThgkn1ycwpp8iIusK+xl7B7WpMLOJJ2/4gm9GXbs8h0Y74CEuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730209; c=relaxed/simple;
	bh=Le2aKQOUJjg/bGYaGjCPjlwX269EonZG0IEL7K9H9NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMJ2zEjHxCtSRE+Tu/nQiHPuw7O7jnXWWOUvV3O5J9AFiSXkbeHPtsreKFp5M7dXE83bS4q0rx7381l3e4XQ5WF/5zf6lEQjH9qhCMz8rrkWu9Ln2bFJwpx+mfciWz1uoYH97g32O3e7HKN6N85TGPnRZssP1QWqzDvoLgvu/QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ghb/DYfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ghb/DYfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13C7C32786;
	Thu, 15 Aug 2024 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730209;
	bh=Le2aKQOUJjg/bGYaGjCPjlwX269EonZG0IEL7K9H9NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ghb/DYfhgnoHW7CR8GXMA52879/Fjms7pdS/qKy0Hvb7cq+lks39Bg5irjhQuluoq
	 Ic/CCudQJjUWJOJ3iApl2KEi4Izvc5e7umhgxSbp02rsI+PCDPIvxESYMEG3iAJAXC
	 DTXsCFtRvLso8K9r9H5q8ZZcIRZN6CrUS1TV+HPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/484] ext4: make ext4_es_insert_extent() return void
Date: Thu, 15 Aug 2024 15:22:43 +0200
Message-ID: <20240815131953.187220578@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cece004b32d5c..6c41bf322315c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3112,8 +3112,9 @@ static int ext4_zeroout_es(struct inode *inode, struct ext4_extent *ex)
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
index ee52dd6afe543..be3b3ccbf70b6 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -848,12 +848,10 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
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
@@ -865,13 +863,13 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
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
 
@@ -940,7 +938,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
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
index 64a783f221052..7ad37c807147b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -589,10 +589,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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
 
@@ -701,12 +699,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
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
@@ -1784,7 +1778,6 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		set_buffer_new(bh);
 		set_buffer_delay(bh);
 	} else if (retval > 0) {
-		int ret;
 		unsigned int status;
 
 		if (unlikely(retval != map->m_len)) {
@@ -1797,10 +1790,8 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 
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



