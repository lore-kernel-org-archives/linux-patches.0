Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D076C274FD0;
	Mon, 27 Oct 2025 19:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592491; cv=none; b=c0Kc7oYn2WThYQrkfeodCqP0gnNwxP0t4P2hsOP7sEo7oDegpeNfZ9yPUY9Ek3/RhuHzmfvwRB7n+7tcjbEMRkDL6w0GJmLYL+uL58ZPnwV8V9pQkX1e6Qn0DWMGRXA+Xc9QpE3DHQwTeRedMptSgr+HNZIR7zkl5qan/8bVCT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592491; c=relaxed/simple;
	bh=hnD/cqLZkd6XmCW+1NP60zU2Gu5ZbRfqdY7tQurTzf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3tCgQimUuuHJ6X7fb8dsMCAAG5z9R5mbLMfV+ybx2zzWA9XktHsre7aCd4WiulzL1M6MYlGmnlUkODBUuOS1nkEo1PgM0p9IAcenYzns6eus+z1bMnJ4RX5b8My/RJb2VLWeBCZ9QWhe8zZk8D37rEg1PrXu2MDocrVCr6e4wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ho3guD1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ho3guD1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6306EC4CEFD;
	Mon, 27 Oct 2025 19:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592491;
	bh=hnD/cqLZkd6XmCW+1NP60zU2Gu5ZbRfqdY7tQurTzf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ho3guD1OlBsX2VZRPKz8bk1QKN2cD4tTH/WQNAmmykdwCcXfub7Q+jl/S3hmiX9uv
	 K+5nXmnEoxg8Z7Z6QiUmUZEkSuh5WWX74A2MAPDnZZjEm1TAdvdxoKz9kL6uXcVcfJ
	 Sp7G1I8l8x0uUPW9PYury6nQQWn7VltIMII6qJ2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/157] f2fs: factor a f2fs_map_blocks_cached helper
Date: Mon, 27 Oct 2025 19:36:42 +0100
Message-ID: <20251027183505.059456833@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0094e98bd1477a6b7d97c25b47b19a7317c35279 ]

Add a helper to deal with everything needed to return a f2fs_map_blocks
structure based on a lookup in the extent cache.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 9d5c4f5c7a2c ("f2fs: fix wrong block mapping for multi-devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   65 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1459,6 +1459,41 @@ int f2fs_get_block_locked(struct dnode_o
 	return err;
 }
 
+static bool f2fs_map_blocks_cached(struct inode *inode,
+		struct f2fs_map_blocks *map, int flag)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	unsigned int maxblocks = map->m_len;
+	pgoff_t pgoff = (pgoff_t)map->m_lblk;
+	struct extent_info ei = {};
+
+	if (!f2fs_lookup_read_extent_cache(inode, pgoff, &ei))
+		return false;
+
+	map->m_pblk = ei.blk + pgoff - ei.fofs;
+	map->m_len = min((pgoff_t)maxblocks, ei.fofs + ei.len - pgoff);
+	map->m_flags = F2FS_MAP_MAPPED;
+	if (map->m_next_extent)
+		*map->m_next_extent = pgoff + map->m_len;
+
+	/* for hardware encryption, but to avoid potential issue in future */
+	if (flag == F2FS_GET_BLOCK_DIO)
+		f2fs_wait_on_block_writeback_range(inode,
+					map->m_pblk, map->m_len);
+
+	if (f2fs_allow_multi_device_dio(sbi, flag)) {
+		int bidx = f2fs_target_device_index(sbi, map->m_pblk);
+		struct f2fs_dev_info *dev = &sbi->devs[bidx];
+
+		map->m_bdev = dev->bdev;
+		map->m_pblk -= dev->start_blk;
+		map->m_len = min(map->m_len, dev->end_blk + 1 - map->m_pblk);
+	} else {
+		map->m_bdev = inode->i_sb->s_bdev;
+	}
+	return true;
+}
+
 /*
  * f2fs_map_blocks() tries to find or build mapping relationship which
  * maps continuous logical blocks to physical blocks, and return such
@@ -1474,7 +1509,6 @@ int f2fs_map_blocks(struct inode *inode,
 	int err = 0, ofs = 1;
 	unsigned int ofs_in_node, last_ofs_in_node;
 	blkcnt_t prealloc;
-	struct extent_info ei = {0, };
 	block_t blkaddr;
 	unsigned int start_pgofs;
 	int bidx = 0;
@@ -1482,6 +1516,9 @@ int f2fs_map_blocks(struct inode *inode,
 	if (!maxblocks)
 		return 0;
 
+	if (!map->m_may_create && f2fs_map_blocks_cached(inode, map, flag))
+		goto out;
+
 	map->m_bdev = inode->i_sb->s_bdev;
 	map->m_multidev_dio =
 		f2fs_allow_multi_device_dio(F2FS_I_SB(inode), flag);
@@ -1493,32 +1530,6 @@ int f2fs_map_blocks(struct inode *inode,
 	pgofs =	(pgoff_t)map->m_lblk;
 	end = pgofs + maxblocks;
 
-	if (map->m_may_create ||
-	    !f2fs_lookup_read_extent_cache(inode, pgofs, &ei))
-		goto next_dnode;
-
-	/* Found the map in read extent cache */
-	map->m_pblk = ei.blk + pgofs - ei.fofs;
-	map->m_len = min((pgoff_t)maxblocks, ei.fofs + ei.len - pgofs);
-	map->m_flags = F2FS_MAP_MAPPED;
-	if (map->m_next_extent)
-		*map->m_next_extent = pgofs + map->m_len;
-
-	/* for hardware encryption, but to avoid potential issue in future */
-	if (flag == F2FS_GET_BLOCK_DIO)
-		f2fs_wait_on_block_writeback_range(inode,
-						map->m_pblk, map->m_len);
-
-	if (map->m_multidev_dio) {
-		bidx = f2fs_target_device_index(sbi, map->m_pblk);
-
-		map->m_bdev = FDEV(bidx).bdev;
-		map->m_pblk -= FDEV(bidx).start_blk;
-		map->m_len = min(map->m_len,
-				FDEV(bidx).end_blk + 1 - map->m_pblk);
-	}
-	goto out;
-
 next_dnode:
 	if (map->m_may_create)
 		f2fs_do_map_lock(sbi, flag, true);


