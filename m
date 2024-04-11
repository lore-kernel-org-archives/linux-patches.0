Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6314714B067;
	Thu, 11 Apr 2024 10:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831630; cv=none; b=XpQiJJFcveyh/Baef5RYQKOOr/jEI2Bi3Uukrg9jTAjnpMj8466CP8FG0SxxxUCoePTCoycNiKUffO7W63/i4y7u54fbYJOZc4vCyHXBLEQKHGZdvXoFWjgnwCXzMX5Y/kwY7FOzi98hvNOM4U3Lx8hnwWu0U/4lVFO9zBIj5bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831630; c=relaxed/simple;
	bh=GaM9d2PsOp1TGq17jKKjF7/GDADFJFZXIEDioSSTmxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMksWBLVQUBYCODs/T46OYBscGKm5gA2vFuX87vOHg/VxU/nJGSFdiiA7GnXWmzh5IORVfS5ttGs0z5ycZN/tc29lopqCh1mDcULsV9hRRh4ml7JpM0+3t+1hwEkXOCktUIQvAtJ4j5tqx2fkE9VUzCCPlcJx09x48tiBlC5wIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4Ch1Vsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4Ch1Vsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDDBC43394;
	Thu, 11 Apr 2024 10:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831630;
	bh=GaM9d2PsOp1TGq17jKKjF7/GDADFJFZXIEDioSSTmxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4Ch1VskP/HngI3kqVfabuq2kpD9EtDo1jW0rql8pATdnEzuQNjDpBX/T8yRXz15p
	 2OWh8nYjpjbi6Nu/dHUoKY2ZLbsP2SPMYPtxhHT9QJa/D66mZ41t4mHf2WMVZ4GYk9
	 ARKzDwI/sY6Pz0HrIkLoqSEo4fTkJQYwr6nAvr6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Srivathsa Dara <srivathsa.d.dara@oracle.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/294] ext4: fix corruption during on-line resize
Date: Thu, 11 Apr 2024 11:53:57 +0200
Message-ID: <20240411095437.919980358@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Heyne <mheyne@amazon.de>

[ Upstream commit a6b3bfe176e8a5b05ec4447404e412c2a3fc92cc ]

We observed a corruption during on-line resize of a file system that is
larger than 16 TiB with 4k block size. With having more then 2^32 blocks
resize_inode is turned off by default by mke2fs. The issue can be
reproduced on a smaller file system for convenience by explicitly
turning off resize_inode. An on-line resize across an 8 GiB boundary (the
size of a meta block group in this setup) then leads to a corruption:

  dev=/dev/<some_dev> # should be >= 16 GiB
  mkdir -p /corruption
  /sbin/mke2fs -t ext4 -b 4096 -O ^resize_inode $dev $((2 * 2**21 - 2**15))
  mount -t ext4 $dev /corruption

  dd if=/dev/zero bs=4096 of=/corruption/test count=$((2*2**21 - 4*2**15))
  sha1sum /corruption/test
  # 79d2658b39dcfd77274e435b0934028adafaab11  /corruption/test

  /sbin/resize2fs $dev $((2*2**21))
  # drop page cache to force reload the block from disk
  echo 1 > /proc/sys/vm/drop_caches

  sha1sum /corruption/test
  # 3c2abc63cbf1a94c9e6977e0fbd72cd832c4d5c3  /corruption/test

2^21 = 2^15*2^6 equals 8 GiB whereof 2^15 is the number of blocks per
block group and 2^6 are the number of block groups that make a meta
block group.

The last checksum might be different depending on how the file is laid
out across the physical blocks. The actual corruption occurs at physical
block 63*2^15 = 2064384 which would be the location of the backup of the
meta block group's block descriptor. During the on-line resize the file
system will be converted to meta_bg starting at s_first_meta_bg which is
2 in the example - meaning all block groups after 16 GiB. However, in
ext4_flex_group_add we might add block groups that are not part of the
first meta block group yet. In the reproducer we achieved this by
substracting the size of a whole block group from the point where the
meta block group would start. This must be considered when updating the
backup block group descriptors to follow the non-meta_bg layout. The fix
is to add a test whether the group to add is already part of the meta
block group or not.

Fixes: 01f795f9e0d67 ("ext4: add online resizing support for meta_bg and 64-bit file systems")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Tested-by: Srivathsa Dara <srivathsa.d.dara@oracle.com>
Reviewed-by: Srivathsa Dara <srivathsa.d.dara@oracle.com>
Link: https://lore.kernel.org/r/20240215155009.94493-1-mheyne@amazon.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/resize.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 06e0eaf2ea4e1..5d45ec29e61a6 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1545,7 +1545,8 @@ static int ext4_flex_group_add(struct super_block *sb,
 		int gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
 		int gdb_num_end = ((group + flex_gd->count - 1) /
 				   EXT4_DESC_PER_BLOCK(sb));
-		int meta_bg = ext4_has_feature_meta_bg(sb);
+		int meta_bg = ext4_has_feature_meta_bg(sb) &&
+			      gdb_num >= le32_to_cpu(es->s_first_meta_bg);
 		sector_t padding_blocks = meta_bg ? 0 : sbi->s_sbh->b_blocknr -
 					 ext4_group_first_block_no(sb, 0);
 		sector_t old_gdb = 0;
-- 
2.43.0



