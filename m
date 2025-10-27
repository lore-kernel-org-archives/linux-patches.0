Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA033164A8;
	Mon, 27 Oct 2025 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592486; cv=none; b=jZgFiz2e5tZUZdX/Z1kWDNJWJbHZmrw9d5KDtxWysXQBngnzLLKXQjsW93VJUWsCcNsBOYEWJy2P2Ai39pp4VIOznx0tAKJPcXBVVnbygv83RN6DZ2Egmyf1po8tTKQOOew+8lQfL+Rm2J/4A+UQMJO2TpkKtGY38SE0R0w22G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592486; c=relaxed/simple;
	bh=sBpB+aqHvqY5EDPYMi9PTahWlPZuQPoMWyeUBLxj/hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5j5txooA1AG6m+7KBl8SvWxtJGXmQ1mTw/rWYXgSkPSSNC9jQF1ttaWv/tGP3eL5AFDmd8XbTHCGGnKi0o1CHCCZHOHMkrg5aLyaPOTFs9rqcrbLvMPAqJeyAZHgRPDwdszjDLq2BR2xyDrXvgaj66gGiBHcIOeZywxLIN0Isk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XK/vYsE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XK/vYsE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27480C113D0;
	Mon, 27 Oct 2025 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592486;
	bh=sBpB+aqHvqY5EDPYMi9PTahWlPZuQPoMWyeUBLxj/hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XK/vYsE9laYjqhKE+APpy+nJth7EnOCY/bTarsUCtjIhCAbymrwqRGxWutwn8YyRg
	 I81L3I8nxqHkkpHl0+0SHbD6rMZA4TuteRku5pOFvj+o58cchNjH3VecYEPcyugOjh
	 n4ZHL4TqL49jg4NCNrw9LkFA5DxoWwJUl/UpLa0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/157] f2fs: add a f2fs_get_block_locked helper
Date: Mon, 27 Oct 2025 19:36:40 +0100
Message-ID: <20251027183504.998990862@linuxfoundation.org>
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

[ Upstream commit cf342d3beda000b4c60990755ca7800de5038785 ]

This allows to keep the f2fs_do_map_lock based locking scheme
private to data.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 9d5c4f5c7a2c ("f2fs: fix wrong block mapping for multi-devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   16 ++++++++++++++--
 fs/f2fs/f2fs.h |    3 +--
 fs/f2fs/file.c |    4 +---
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1192,7 +1192,7 @@ int f2fs_reserve_block(struct dnode_of_d
 	return err;
 }
 
-int f2fs_get_block(struct dnode_of_data *dn, pgoff_t index)
+static int f2fs_get_block(struct dnode_of_data *dn, pgoff_t index)
 {
 	struct extent_info ei = {0, };
 	struct inode *inode = dn->inode;
@@ -1432,7 +1432,7 @@ static int __allocate_data_block(struct
 	return 0;
 }
 
-void f2fs_do_map_lock(struct f2fs_sb_info *sbi, int flag, bool lock)
+static void f2fs_do_map_lock(struct f2fs_sb_info *sbi, int flag, bool lock)
 {
 	if (flag == F2FS_GET_BLOCK_PRE_AIO) {
 		if (lock)
@@ -1447,6 +1447,18 @@ void f2fs_do_map_lock(struct f2fs_sb_inf
 	}
 }
 
+int f2fs_get_block_locked(struct dnode_of_data *dn, pgoff_t index)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
+	int err;
+
+	f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, true);
+	err = f2fs_get_block(dn, index);
+	f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, false);
+
+	return err;
+}
+
 /*
  * f2fs_map_blocks() tries to find or build mapping relationship which
  * maps continuous logical blocks to physical blocks, and return such
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3783,7 +3783,7 @@ void f2fs_set_data_blkaddr(struct dnode_
 void f2fs_update_data_blkaddr(struct dnode_of_data *dn, block_t blkaddr);
 int f2fs_reserve_new_blocks(struct dnode_of_data *dn, blkcnt_t count);
 int f2fs_reserve_new_block(struct dnode_of_data *dn);
-int f2fs_get_block(struct dnode_of_data *dn, pgoff_t index);
+int f2fs_get_block_locked(struct dnode_of_data *dn, pgoff_t index);
 int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index);
 struct page *f2fs_get_read_data_page(struct inode *inode, pgoff_t index,
 			blk_opf_t op_flags, bool for_write, pgoff_t *next_pgofs);
@@ -3794,7 +3794,6 @@ struct page *f2fs_get_lock_data_page(str
 struct page *f2fs_get_new_data_page(struct inode *inode,
 			struct page *ipage, pgoff_t index, bool new_i_size);
 int f2fs_do_write_data_page(struct f2fs_io_info *fio);
-void f2fs_do_map_lock(struct f2fs_sb_info *sbi, int flag, bool lock);
 int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map,
 			int create, int flag);
 int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -113,10 +113,8 @@ static vm_fault_t f2fs_vm_page_mkwrite(s
 
 	if (need_alloc) {
 		/* block allocation */
-		f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, true);
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
-		err = f2fs_get_block(&dn, page->index);
-		f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, false);
+		err = f2fs_get_block_locked(&dn, page->index);
 	}
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION


