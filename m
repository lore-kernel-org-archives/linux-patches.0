Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9E42F2909;
	Mon, 22 Sep 2025 19:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570224; cv=none; b=lRzwqfko8BEOW9H562IjLbBXapezPC8j1hac/4la+k0/2a3W2ZKNoBi5AdKoq+LxMIgmVVa38PyyLGHG5wIXm0cQc5I10eXKgIm3FIIrjQEivZVokR2aVgBczzY6XJFXpd9MMJY/oG3OA21X6liIHRPVPA7Oh4VOS598kODTV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570224; c=relaxed/simple;
	bh=bRV92q0l9t5k6J/kRI0NcfBqDTIi05EdafOIaTY8Rqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbrwZaeqqVR/wiDAoJyQm0vJCUoVVMMgMQLXbcWb+0js02aLWQKjw7dVc3MalE7TYi1tZqd7G+SDfDsaVlSmEAG1A/OU+TXFOzoIwLvWR6s9PtZl0XSAdMZo8NSru8FN+YB8kF1nyKRQRHykanVPfUkJJcp13rNq4Xyj5cXRjw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNvVshHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNvVshHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252CFC4CEF0;
	Mon, 22 Sep 2025 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570224;
	bh=bRV92q0l9t5k6J/kRI0NcfBqDTIi05EdafOIaTY8Rqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNvVshHnj+CEgeLT/AYrzeBu2xKkpH2vKQbZR2yHYotXQgMTY87PDxmhiOUG3+osJ
	 30yAzQ9Ur2aisau3/Gzkw5bn/OiGWVNRGtHhdxxjw4GyM8VAqyleyZMRCVIAjfv9kQ
	 xvQPeJlfGZbhsh+f0h//dHnZZgJYoY1OhhO2hozs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	austinchang <austinchang@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 055/149] btrfs: initialize inode::file_extent_tree after i_mode has been set
Date: Mon, 22 Sep 2025 21:29:15 +0200
Message-ID: <20250922192414.249015858@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: austinchang <austinchang@synology.com>

commit 8679d2687c351824d08cf1f0e86f3b65f22a00fe upstream.

btrfs_init_file_extent_tree() uses S_ISREG() to determine if the file is
a regular file. In the beginning of btrfs_read_locked_inode(), the i_mode
hasn't been read from inode item, then file_extent_tree won't be used at
all in volumes without NO_HOLES.

Fix this by calling btrfs_init_file_extent_tree() after i_mode is
initialized in btrfs_read_locked_inode().

Fixes: 3d7db6e8bd22e6 ("btrfs: don't allocate file extent tree for non regular files")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: austinchang <austinchang@synology.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-inode.c |    3 ---
 fs/btrfs/inode.c         |   11 +++++------
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1843,7 +1843,6 @@ static void fill_stack_inode_item(struct
 
 int btrfs_fill_inode(struct btrfs_inode *inode, u32 *rdev)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_delayed_node *delayed_node;
 	struct btrfs_inode_item *inode_item;
 	struct inode *vfs_inode = &inode->vfs_inode;
@@ -1864,8 +1863,6 @@ int btrfs_fill_inode(struct btrfs_inode
 	i_uid_write(vfs_inode, btrfs_stack_inode_uid(inode_item));
 	i_gid_write(vfs_inode, btrfs_stack_inode_gid(inode_item));
 	btrfs_i_size_write(inode, btrfs_stack_inode_size(inode_item));
-	btrfs_inode_set_file_extent_range(inode, 0,
-			round_up(i_size_read(vfs_inode), fs_info->sectorsize));
 	vfs_inode->i_mode = btrfs_stack_inode_mode(inode_item);
 	set_nlink(vfs_inode, btrfs_stack_inode_nlink(inode_item));
 	inode_set_bytes(vfs_inode, btrfs_stack_inode_nbytes(inode_item));
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3881,10 +3881,6 @@ static int btrfs_read_locked_inode(struc
 	bool filled = false;
 	int first_xattr_slot;
 
-	ret = btrfs_init_file_extent_tree(inode);
-	if (ret)
-		goto out;
-
 	ret = btrfs_fill_inode(inode, &rdev);
 	if (!ret)
 		filled = true;
@@ -3916,8 +3912,6 @@ static int btrfs_read_locked_inode(struc
 	i_uid_write(vfs_inode, btrfs_inode_uid(leaf, inode_item));
 	i_gid_write(vfs_inode, btrfs_inode_gid(leaf, inode_item));
 	btrfs_i_size_write(inode, btrfs_inode_size(leaf, inode_item));
-	btrfs_inode_set_file_extent_range(inode, 0,
-			round_up(i_size_read(vfs_inode), fs_info->sectorsize));
 
 	inode_set_atime(vfs_inode, btrfs_timespec_sec(leaf, &inode_item->atime),
 			btrfs_timespec_nsec(leaf, &inode_item->atime));
@@ -3948,6 +3942,11 @@ static int btrfs_read_locked_inode(struc
 	btrfs_update_inode_mapping_flags(inode);
 
 cache_index:
+	ret = btrfs_init_file_extent_tree(inode);
+	if (ret)
+		goto out;
+	btrfs_inode_set_file_extent_range(inode, 0,
+			round_up(i_size_read(vfs_inode), fs_info->sectorsize));
 	/*
 	 * If we were modified in the current generation and evicted from memory
 	 * and then re-read we need to do a full sync since we don't have any


