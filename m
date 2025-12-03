Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D906D303A3D;
	Wed,  3 Dec 2025 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776313; cv=none; b=nzPDt5oVxu6VSGcl72wz0rDQ+HfXvTPetSJ72UhPQa9L6BK/WXOI+DuCEydSVcXRr3A8OtsQKXhMXKkziu/UrnMjONyu20tp+kbnc+gzXXxFYXJTSTfgR1VzvLZtj1uUIKBV+bCiAbbhkk5JZ04X5tUG2/jvqG5t5eQTBibaBZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776313; c=relaxed/simple;
	bh=2ubJzb9iMfUUONfnPqWGz4Pg+nxDlSNcoar1JzGCdUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0jnhPD8rQQWOMgLuNWAA5bLnzrQEn9REk/SQb5yU5Bps95Hw0/pTYLxpIGVVt93IQq60XBI9PhZclVUE/P/76tB76mc929uumouaLD3FT7WrVlYox4OGQjYWT7xUlfkhKKs9fywMp9k6UaobN63xGbfgJPMOl7OqaBe/z/NCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BizK3KhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BizK3KhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47373C4CEF5;
	Wed,  3 Dec 2025 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776313;
	bh=2ubJzb9iMfUUONfnPqWGz4Pg+nxDlSNcoar1JzGCdUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BizK3KhKX24PUZSnsMlu+mld4C0BcGQYl0GsNuk1LxCx1eBH6OjCMtJl6e+m+bLve
	 TyjPvn70vXl356EMtQ9hXTlmUoRfEVIS5cWlWHvggm3JbLYhi6tT5Mr6JDyRplgqKL
	 odvkuloW7xl28x1FtJ0ON6yFRgAqqhjjTDjmkRKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	austinchang <austinchang@synology.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/300] btrfs: mark dirty extent range for out of bound prealloc extents
Date: Wed,  3 Dec 2025 16:25:50 +0100
Message-ID: <20251203152406.026996360@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 53a3c32a0f8ce..38a293a9d0644 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3049,12 +3049,22 @@ static int btrfs_fallocate_update_isize(struct inode *inode,
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



