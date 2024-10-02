Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EDC1D095C;
	Wed,  2 Oct 2024 14:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878030; cv=none; b=Tt18zJbQihnACT2PadCgVIZ8mAymVQgT1mr+bw6WNeDH2z+q6GNvQ+TSvXTBIWjK9bhqhDVe10UOvi1WHUkCESZu52UryE0OB3qNqNlfM+MfPEIASZx76h1crKbNwyTDECLinJL8LXxvMqNca9NXqxMx+G2ROgmXzkzzUOYL8k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878030; c=relaxed/simple;
	bh=QopW/Krj0HQQw+GAn4fV1GBe7Q4ZyNOALLANXEL0dOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1XLA4ALhx0g5l/Jdh4kNbps45/tHyC0u1xiTLpO/4NSrGh6UlA1SHNlcWiMppwRC/jHpOYCmlloX1o1Rrf8VLvZR1iB5SYUdPV8TrABcT1CjK5PV8TE9AZP0uzrR+Ktcnrp37EszPnuTJh7gpH24U1iQCme164UKwRgJ4Go1HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3I2oiVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3I2oiVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E81C4CEC5;
	Wed,  2 Oct 2024 14:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878030;
	bh=QopW/Krj0HQQw+GAn4fV1GBe7Q4ZyNOALLANXEL0dOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3I2oiVKjKg0fxuJ8yZXyM2N0FFHPfTYGdrbf65X2wZXbD3rQYFWQdRDqs3BbRE54
	 QB06XN9WhOOOex3JYcLqC/G0E3f/6+iebswa8C08tT9EU/FuVGtkTCxkFPariqLCSK
	 Y+2/0xXuNq3/Z/C4z6xJIHm/GLVGHJ2utFOQbKns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 278/634] ext4: avoid potential buffer_head leak in __ext4_new_inode()
Date: Wed,  2 Oct 2024 14:56:18 +0200
Message-ID: <20241002125822.075091323@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 227d31b9214d1b9513383cf6c7180628d4b3b61f ]

If a group is marked EXT4_GROUP_INFO_IBITMAP_CORRUPT after it's inode
bitmap buffer_head was successfully verified, then __ext4_new_inode()
will get a valid inode_bitmap_bh of a corrupted group from
ext4_read_inode_bitmap() in which case inode_bitmap_bh misses a release.
Hnadle "IS_ERR(inode_bitmap_bh)" and group corruption separately like
how ext4_free_inode() does to avoid buffer_head leak.

Fixes: 9008a58e5dce ("ext4: make the bitmap read routines return real error codes")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://patch.msgid.link/20240820132234.2759926-3-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index bf14450da35f4..de04f4400d926 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1054,12 +1054,13 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		brelse(inode_bitmap_bh);
 		inode_bitmap_bh = ext4_read_inode_bitmap(sb, group);
 		/* Skip groups with suspicious inode tables */
-		if (((!(sbi->s_mount_state & EXT4_FC_REPLAY))
-		     && EXT4_MB_GRP_IBITMAP_CORRUPT(grp)) ||
-		    IS_ERR(inode_bitmap_bh)) {
+		if (IS_ERR(inode_bitmap_bh)) {
 			inode_bitmap_bh = NULL;
 			goto next_group;
 		}
+		if (!(sbi->s_mount_state & EXT4_FC_REPLAY) &&
+		    EXT4_MB_GRP_IBITMAP_CORRUPT(grp))
+			goto next_group;
 
 repeat_in_this_group:
 		ret2 = find_inode_bit(sb, group, inode_bitmap_bh, &ino);
-- 
2.43.0



