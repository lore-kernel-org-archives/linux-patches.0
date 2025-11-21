Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097A533B6EA;
	Fri, 21 Nov 2025 13:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732970; cv=none; b=N84eL0PDDaXcxlsDJuDZJIWyu/0AIzUM2kk7aZAsI/S9M0VxFe2lU7x+V4yeMmrnUD/zLLM2gyFNzvWHokv4HA/w+D5StKu7A7q6XDM0/bmcxW+8m2lObelKT7FPQ+EFTHLYnTxA0Ogz3X5q9qXzsvI62jdga4yFkO0ZRX7RRq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732970; c=relaxed/simple;
	bh=t9kcRJamV8Dl9jslu7JD9JepDYzJrJxUBC8WnEWqWmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPnbyr368YMQxWqwableI04FTmgKSf4ayZDD9tLdhPY0EUPMxxdxZZs9bAgGLhVVNyhtYt0LK9YXXpzvpZyJLoOf88HO5YzjzuUDqtZSGG42c6R9+BilZhbveeGZRCnlYnVOC9ygZRCndKZlHcYSL/4+H3sB5Pc9h/idgAlT4z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg6z9hTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg6z9hTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E30FC4CEF1;
	Fri, 21 Nov 2025 13:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732969;
	bh=t9kcRJamV8Dl9jslu7JD9JepDYzJrJxUBC8WnEWqWmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg6z9hTS7uPiUI6kZnC+dVSN7TyTCOOpERx2ecONEadcYMD5r9D+FE96qDVglR4PA
	 vTaLPxPl1/LZNGlZwuZuezF9HCExARzkpy/vAPaGUQnpnRJvQosqbqH+DHtHA2oLc2
	 GwTr+m6bks4a/r5qikT5suBkaumNi9CuZIk8qIvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	austinchang <austinchang@synology.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/529] btrfs: mark dirty extent range for out of bound prealloc extents
Date: Fri, 21 Nov 2025 14:10:04 +0100
Message-ID: <20251121130241.875937672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: austinchang <austinchang@synology.com>

[ Upstream commit 3b1a4a59a2086badab391687a6a0b86e03048393 ]

In btrfs_fallocate(), when the allocated range overlaps with a prealloc
extent and the extent starts after i_size, the range doesn't get marked
dirty in file_extent_tree. This results in persisting an incorrect
disk_i_size for the inode when not using the no-holes feature.

This is reproducible since commit 41a2ee75aab0 ("btrfs: introduce
per-inode file extent tree"), then became hidden since commit 3d7db6e8bd22
("btrfs: don't allocate file extent tree for non regular files") and then
visible again after commit 8679d2687c35 ("btrfs: initialize
inode::file_extent_tree after i_mode has been set"), which fixes the
previous commit.

The following reproducer triggers the problem:

$ cat test.sh

MNT=/mnt/test
DEV=/dev/vdb

mkdir -p $MNT

mkfs.btrfs -f -O ^no-holes $DEV
mount $DEV $MNT

touch $MNT/file1
fallocate -n -o 1M -l 2M $MNT/file1

umount $MNT
mount $DEV $MNT

len=$((1 * 1024 * 1024))

fallocate -o 1M -l $len $MNT/file1

du --bytes $MNT/file1

umount $MNT
mount $DEV $MNT

du --bytes $MNT/file1

umount $MNT

Running the reproducer gives the following result:

$ ./test.sh
(...)
2097152 /mnt/test/file1
1048576 /mnt/test/file1

The difference is exactly 1048576 as we assigned.

Fix by adding a call to btrfs_inode_set_file_extent_range() in
btrfs_fallocate_update_isize().

Fixes: 41a2ee75aab0 ("btrfs: introduce per-inode file extent tree")
Signed-off-by: austinchang <austinchang@synology.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e794606e7c780..9ef543db8aab9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2825,12 +2825,22 @@ static int btrfs_fallocate_update_isize(struct inode *inode,
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u64 range_start;
+	u64 range_end;
 	int ret;
 	int ret2;
 
 	if (mode & FALLOC_FL_KEEP_SIZE || end <= i_size_read(inode))
 		return 0;
 
+	range_start = round_down(i_size_read(inode), root->fs_info->sectorsize);
+	range_end = round_up(end, root->fs_info->sectorsize);
+
+	ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode), range_start,
+						range_end - range_start);
+	if (ret)
+		return ret;
+
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-- 
2.51.0



