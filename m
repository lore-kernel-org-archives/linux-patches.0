Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147024778C;
	Mon,  1 Apr 2024 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988227; cv=none; b=RLmIAvuPKI7NApeI8QXc/bIapp+rhQ/Q9GWu6enAk0qm5osps89e8DBvux/fTER16pQGhFrNzTf5nAcAzKW9uEpnvk+zOj11pbfxth6in43m9aOnMuW3ZsRKJGjQ2A4woDmwsmSvqas7xPESf73hL3W4UN9d/PcSlm90KztPj6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988227; c=relaxed/simple;
	bh=R95RaNIk/nee8tsGAu99nYEZ1FORbFJlrFa4lISYUug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im03GMDPyoEo/bZ4Q4T9cCqfyomVXnvn2doeYRhI067AeA442ytc+Dwdn4vdD1EuATXhn7sKy6QN73p9j8IsoGwLdV3OM6jVyEUkAM+xGHCX5C6Jp/z2eOfVGWdeR7h/F3wpnUB2MtVUT34loszUnlJnLbkngNnIJuCIeAqgRSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LssEPClF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LssEPClF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8DCC433F1;
	Mon,  1 Apr 2024 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988227;
	bh=R95RaNIk/nee8tsGAu99nYEZ1FORbFJlrFa4lISYUug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LssEPClFnh9kTFCruZRNB+AtP7QbbQfsJvCSSmF6aqWevszP/w+nZcK1sHujaaj4l
	 MnUDZg5t5VJ05jsGZ0V4YTX3/z7ECW8d6SPzDmhQtn+pCFNrmxLLN2zVvMb06KSVSu
	 f+WFkql7BFFNgcQFa32awMYuXxoCmINw7SgQ3jVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Srivathsa Dara <srivathsa.d.dara@oracle.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 121/432] ext4: fix corruption during on-line resize
Date: Mon,  1 Apr 2024 17:41:48 +0200
Message-ID: <20240401152556.731814530@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index e168a9f596001..9a39596d2ac4d 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1592,7 +1592,8 @@ static int ext4_flex_group_add(struct super_block *sb,
 		int gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
 		int gdb_num_end = ((group + flex_gd->count - 1) /
 				   EXT4_DESC_PER_BLOCK(sb));
-		int meta_bg = ext4_has_feature_meta_bg(sb);
+		int meta_bg = ext4_has_feature_meta_bg(sb) &&
+			      gdb_num >= le32_to_cpu(es->s_first_meta_bg);
 		sector_t padding_blocks = meta_bg ? 0 : sbi->s_sbh->b_blocknr -
 					 ext4_group_first_block_no(sb, 0);
 
-- 
2.43.0



