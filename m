Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A712B196C8D;
	Thu,  6 Jun 2024 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682948; cv=none; b=RSx0eNnABO2xiy1wxKsF/EGtTygWvyvVyOSsTwOeHsZXP5fFvBLQO5eQ9KdaA+tuh6tcsA3lWzCdE3h/NLW+zmfD2f75lEbucWIocPx6UXzvGZ8h49LhloVMxLw9T56LCHFQBSSfnRKPHQ46oYkh3sh9Viybhu/t5RoDVmZLnWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682948; c=relaxed/simple;
	bh=lYtExvF3zIG9F8kK9YPLmRDeT1FtkKORufkahtk5r7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cD2CRFt1rUv3H6eaGNXUuIZDydkFdaL4XkozXDAAxbtsYU32dTNNAMa25VAaQN+3TtExn872U81XPhVq/P8zgjZ36s5V1lKObWxWbqMG88g5pVTLRyL4nbucSZuEiqQTE+khoSpdulyc5tkjCOocA9zWDx4mcDEtVmlptH6YkwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqKNcKoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqKNcKoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DDBC32781;
	Thu,  6 Jun 2024 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682948;
	bh=lYtExvF3zIG9F8kK9YPLmRDeT1FtkKORufkahtk5r7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqKNcKojtYRFXTKbQ+RMcgjaq824iYg+4RfU/qRuHdRraAKi1F6qKN+WRk6ryIcq3
	 8S0vaqPzQIMLcl2ho1iJu32S6KFBwPwyKXCNPV8qqWASjpKXfPMbVddGPjCfjQERJp
	 MY0ZKKGnWODTb/m8a+1a1NMoneE8nOFuCJpCB+ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 111/374] f2fs: compress: dont allow unaligned truncation on released compress inode
Date: Thu,  6 Jun 2024 16:01:30 +0200
Message-ID: <20240606131655.642218490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 30d438bd30ab4..208dedc161d53 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -952,9 +952,14 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
 
 	err = setattr_prepare(idmap, dentry, attr);
 	if (err)
-- 
2.43.0



