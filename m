Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B2C6EB56;
	Thu, 13 Jun 2024 12:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281045; cv=none; b=SvYZlZ7SCWe+WM+LcJCOKeMqJvpCVhSM4+QouolHFsqGRt4oARD3SNS5+IQy3j6eixXlsH5TII79PLQRiDFxLszZp17NidvgG1QCBtg3I4pAgOVY3OF81J5MrNe10yCuWZPRq7/6cuzedLIA1/Hb7vo6rOIJL7coIM04loXMB2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281045; c=relaxed/simple;
	bh=WzXWnC+Gh5ulhcD0BAxF4UVAEYVMRiT1lpY6cWA5NNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiLLZMVxm4APaFg3zh/ZWaRDI7VrP2gs30krC9cq+Trwri1GKnPXFAi1jI84uHiWZZQM2HjiuoMRj19KNxU0lqfX4GJzspcMQGgOp7stSJPDnFTwg0RFR/tErWT6j74U1Y4OOtI7UwmJm8aQSdg7QBIcUz/JoNbzyXOsr5ZWlVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAlbpGQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAlbpGQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D514BC2BBFC;
	Thu, 13 Jun 2024 12:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281045;
	bh=WzXWnC+Gh5ulhcD0BAxF4UVAEYVMRiT1lpY6cWA5NNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAlbpGQbD+mYyUWtXT1CbXUbZ4od3dk0Bkf8K7BJMEsjhsCPthYk0hUT5pvVWxWIL
	 E0oDV6WXxcdXMIUuDT4dLHDZYq69w22r6esDh4M1YFGf3rs/7x84ko69Od/+cqE2i2
	 9GMvy2iTQrIc7d9rVPe/38TTUY3PKEdOujld3mcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/317] ext4: simplify calculation of blkoff in ext4_mb_new_blocks_simple
Date: Thu, 13 Jun 2024 13:32:19 +0200
Message-ID: <20240613113252.232200718@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 253cacb0de89235673ad5889d61f275a73dbee79 ]

We try to allocate a block from goal in ext4_mb_new_blocks_simple. We
only need get blkoff in first group with goal and set blkoff to 0 for
the rest groups.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://lore.kernel.org/r/20230303172120.3800725-21-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 3f4830abd236 ("ext4: fix potential unnitialized variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1d632725c2c0..26beaf102ce36 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5371,9 +5371,6 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 			return 0;
 		}
 
-		ext4_get_group_no_and_offset(sb,
-			max(ext4_group_first_block_no(sb, group), goal),
-			NULL, &blkoff);
 		while (1) {
 			i = mb_find_next_zero_bit(bitmap_bh->b_data, max,
 						blkoff);
@@ -5388,6 +5385,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		brelse(bitmap_bh);
 		if (i < max)
 			break;
+
+		blkoff = 0;
 	}
 
 	if (group >= ext4_get_groups_count(sb) || i >= max) {
-- 
2.43.0



