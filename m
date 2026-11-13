Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591247;
	b=hf4vhpIIl09NcB9eEJy1v/8JYaST1WiEbMLvwRgpn0jobKXUNXW/P+TbXs3Y7zlmiPdS
	 23REJuwe0n5UIX3S1gWH9vQvQKYXWLgG0uvH7CtdsdaugeQiKQb9uFTQp6aF0F9yOOcG5
	 HhnZqpGlHMzNdHZnPwkRLiC9Fg8bXXZ9294vtj7CbsPaBDN9Gm2V0P2WF6Du6ORbnH5b1
	 7jhj4u5xr7TSnCVEDhHrsG58dchQoFpmJLQBJN4Iqhwsfn4/48LzoUGugFjqA6j3KLfrt
	 lPXyKCbHtx9VTln8PD5/u+VtMmOnJsVRP05aPNBMuSXa59yOuZI0kionwaDwyBWPQHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rra540axxRn3ZgBdL2pC8Uo3eApFTPYRaxLrxPpXip4=;
	b=EdQtFIeyXc3AtGXfbKEgyuCW7Gwjx3OHF2FAkbxNV0hC5U8oqAPShXe73eu1lHFa8kk5
	 hG4QbUD1ldR65QaRSS1BLEBh8ap2Op8KUamV9aqTu81dWov5Ab8DFXWvaqf5IuCz2c6kv
	 6tzJrvVOHNbxwryOnBInOqoiV0eT3Q1rMeWrbO1QQfzXpYCKEwmuJIv/SU8Shi4iUIYwf
	 0RrlMSdGkf5EMiGeKBXG00gohO3b1CtPaovtwOTOvPnGIbeNmgAgbYdy4JcavSfF72AFt
	 jPrQysCAw6stgHPP4WLxmH6ibjxBX4rZ49tz7r5viTTn6vXiepu03U/e4sJR9XpIz+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUw6ujCf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055ED60A2631;
	Fri, 13 Nov 2026 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rUw6ujCf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50961F000C4;
	Fri, 13 Nov 2026 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591246;
	bh=rra540axxRn3ZgBdL2pC8Uo3eApFTPYRaxLrxPpXip4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUw6ujCfz1RB9C4uav4SB0IssnuUxazPNa+GJxvXTi7mtIf5Zvs8u8pR8ALhPGECC
	 aF3QZg9kLwX4WlX1z8nObi6Qb0ozKXpBbm8oUkKsyl3n9+gKokwx/po8HvHVquwIiI
	 BER4R0EFyr6q0l/VKCrboO3JOoabUo3jPsEEZz9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/670] ext2: preserve IOMAP_F_DIRTY for extending direct writes
Date: Fri, 13 Nov 2026 10:48:56 -0500
Message-ID: <20261113153824.404163180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 4f91b042af212ca0b610e43f9a975ddc7f0d0923 ]

ext2_iomap_begin() sets IOMAP_F_DIRTY for writes that may extend i_size,
but clears the flag after ext2_get_blocks(). When the write uses an
existing mapped block, iomap can then use FUA and skip
generic_write_sync(), even though ext2_dio_write_end_io() updates the
inode size. An O_DSYNC write can therefore return without persisting
the new size.

For example, on a FUA-capable device, a 512-byte O_DIRECT|O_DSYNC write
at offset 512 into a fsynced one-byte file returns successfully and
extends the in-memory size to 1024, while an immediate read of the
on-disk inode still shows size 1. An explicit fsync persists the new
size.

Move setting of IOMAP_F_DIRTY after the initialization.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261029013616.97194-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/inode.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index f3149022257a4..e8a7b21eedb52 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -824,6 +824,12 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	    (first_block << blkbits) < i_size_read(inode))
 		create = 0;
 
+	ret = ext2_get_blocks(inode, first_block, max_blocks,
+			&bno, &new, &boundary, create);
+	if (ret < 0)
+		return ret;
+
+	iomap->flags = 0;
 	/*
 	 * Writes that span EOF might trigger an IO size update on completion,
 	 * so consider them to be dirty for the purposes of O_DSYNC even if
@@ -831,13 +837,6 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 */
 	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
 		iomap->flags |= IOMAP_F_DIRTY;
-
-	ret = ext2_get_blocks(inode, first_block, max_blocks,
-			&bno, &new, &boundary, create);
-	if (ret < 0)
-		return ret;
-
-	iomap->flags = 0;
 	iomap->offset = (u64)first_block << blkbits;
 	if (flags & IOMAP_DAX)
 		iomap->dax_dev = sbi->s_daxdev;
-- 
2.53.0



