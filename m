Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D101638D;
	Thu,  6 Jun 2024 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683456; cv=none; b=N9byYgNlU7YIPHJA3hvptWD9pS3Z9yhe1s6E8Zel3klmofWQ7powbgwcF0ULFAi9P5H+o2vrKk3geIhgXW4uJe/3modYnVEQN4ZRoxOkfvwvjDPXyC31fKR166UEldLP35D2IfFtujpx/tKN0Uvw84pg6WeZqKaa7t6HYQyAg2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683456; c=relaxed/simple;
	bh=6fqzCGj/PDlxeriE+y/lMWiM50p6I07WRk9srq1bNZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuueIgqYQyabGfMrgxylCJs5e382yx+8uQ1O+b/2GrZoevePIMPESqHKPknW8hGi4o/PNzRLXGnq/yhhYn9DzhTX/wS8anwSXwnMEfjQKgnwG/8fou9iIYBbYb7/47/izJ4xtKDR8z9stLWASuoHCjct5/fM0ZZyAePZDK5Du9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkoVoIxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkoVoIxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC160C2BD10;
	Thu,  6 Jun 2024 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683456;
	bh=6fqzCGj/PDlxeriE+y/lMWiM50p6I07WRk9srq1bNZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkoVoIxxsa/Q3Tr8CEsI519nIOQaC4db843A/93h7unhXfRjtF+zS/WipRELy4ljl
	 dfyIUDsOE050VGsQX6cZhxYTcaF6pRjYz4oqW/a+cmT92pitqlktYNT8JYCyRH2oAJ
	 p1rc2nYT6ZH6hBu+pS5lUXxUrxat1st7oWqMEHF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 344/473] f2fs: compress: dont allow unaligned truncation on released compress inode
Date: Thu,  6 Jun 2024 16:04:33 +0200
Message-ID: <20240606131711.278882389@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 29ed2b5dd521ce7c5d8466cd70bf0cc9d07afeee ]

f2fs image may be corrupted after below testcase:
- mkfs.f2fs -O extra_attr,compression -f /dev/vdb
- mount /dev/vdb /mnt/f2fs
- touch /mnt/f2fs/file
- f2fs_io setflags compression /mnt/f2fs/file
- dd if=/dev/zero of=/mnt/f2fs/file bs=4k count=4
- f2fs_io release_cblocks /mnt/f2fs/file
- truncate -s 8192 /mnt/f2fs/file
- umount /mnt/f2fs
- fsck.f2fs /dev/vdb

[ASSERT] (fsck_chk_inode_blk:1256)  --> ino: 0x5 has i_blocks: 0x00000002, but has 0x3 blocks
[FSCK] valid_block_count matching with CP             [Fail] [0x4, 0x5]
[FSCK] other corrupted bugs                           [Fail]

The reason is: partial truncation assume compressed inode has reserved
blocks, after partial truncation, valid block count may change w/o
.i_blocks and .total_valid_block_count update, result in corruption.

This patch only allow cluster size aligned truncation on released
compress inode for fixing.

Fixes: c61404153eb6 ("f2fs: introduce FI_COMPRESS_RELEASED instead of using IMMUTABLE bit")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2b0f8408917bb..1d73582d1f63d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -940,9 +940,14 @@ int f2fs_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 				  ATTR_GID | ATTR_TIMES_SET))))
 		return -EPERM;
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-		!f2fs_is_compress_backend_ready(inode))
-		return -EOPNOTSUPP;
+	if ((attr->ia_valid & ATTR_SIZE)) {
+		if (!f2fs_is_compress_backend_ready(inode))
+			return -EOPNOTSUPP;
+		if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED) &&
+			!IS_ALIGNED(attr->ia_size,
+			F2FS_BLK_TO_BYTES(F2FS_I(inode)->i_cluster_size)))
+			return -EINVAL;
+	}
 
 	err = setattr_prepare(mnt_userns, dentry, attr);
 	if (err)
-- 
2.43.0



