Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302C02B9B7;
	Tue, 23 Jan 2024 01:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974116; cv=none; b=bvPJUmUYbRpeNBticqmNuoxXP9iD0N8O/mxXUDuzk7yb/YS4vco4G2l31VOGESE4LIEWFyJGVdgBWuRN+Hhf2hMVBf23h+cDXp6fB2gctHhaPFVY+14p2ECYrLxMP0IvnoTjHSCMZ7M42IaThe7MjMksjjvnN/2lINJpPbFXdbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974116; c=relaxed/simple;
	bh=yE87BagCmzeNk7EFF94eBs1/2h2Ir3iYmREoFr9CtbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhcSrcOmzUfe90QgoSwFKho0m7GO0qwpd+X9MDv75txcCJIP3ABEoGdQAeQsF3ddNYQSf0L84CJNtDYf+f+OYEpqti6dqS6a35B692dVvykCQsqt+XH4YGDFcrbk8jrBH9BxMKqDsX6UVLCnrW0yK6GMg/cEw3ZXYXc+UkIIJA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekGWhSBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekGWhSBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C3AC433C7;
	Tue, 23 Jan 2024 01:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974115;
	bh=yE87BagCmzeNk7EFF94eBs1/2h2Ir3iYmREoFr9CtbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekGWhSBCG+XIsXZ/TvQgvNPfaZRvsPbV2Q0V3fAShwrwQAuy0YSWoxeaOEag0cfJl
	 YCCusnYco39vPZW/3ZavuWnPbda8/R5SXVUEECVbfma3C0ZFMnU3NPM05UGzBt/tjh
	 LjHBTIq6GmB2dSochVZ0OmPH4Dqh/h0yhaJNg608=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/374] null_blk: dont cap max_hw_sectors to BLK_DEF_MAX_SECTORS
Date: Mon, 22 Jan 2024 15:57:05 -0800
Message-ID: <20240122235750.514244465@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9a9525de865410047fa962867b4fcd33943b206f ]

null_blk has some rather odd capping of the max_hw_sectors value to
BLK_DEF_MAX_SECTORS, which doesn't make sense - max_hw_sector is the
hardware limit, and BLK_DEF_MAX_SECTORS despite the confusing name is the
default cap for the max_sectors field used for normal file system I/O.

Remove all the capping, and simply leave it to the block layer or
user to take up or not all of that for file system I/O.

Fixes: ea17fd354ca8 ("null_blk: Allow controlling max_hw_sectors limit")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231227092305.279567-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 4a867233b14a..87791265e09b 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1900,10 +1900,8 @@ static int null_add_dev(struct nullb_device *dev)
 
 	blk_queue_logical_block_size(nullb->q, dev->blocksize);
 	blk_queue_physical_block_size(nullb->q, dev->blocksize);
-	if (!dev->max_sectors)
-		dev->max_sectors = queue_max_hw_sectors(nullb->q);
-	dev->max_sectors = min(dev->max_sectors, BLK_DEF_MAX_SECTORS);
-	blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
+	if (dev->max_sectors)
+		blk_queue_max_hw_sectors(nullb->q, dev->max_sectors);
 
 	if (dev->virt_boundary)
 		blk_queue_virt_boundary(nullb->q, PAGE_SIZE - 1);
@@ -1953,12 +1951,6 @@ static int __init null_init(void)
 		g_bs = PAGE_SIZE;
 	}
 
-	if (g_max_sectors > BLK_DEF_MAX_SECTORS) {
-		pr_warn("invalid max sectors\n");
-		pr_warn("defaults max sectors to %u\n", BLK_DEF_MAX_SECTORS);
-		g_max_sectors = BLK_DEF_MAX_SECTORS;
-	}
-
 	if (g_home_node != NUMA_NO_NODE && g_home_node >= nr_online_nodes) {
 		pr_err("invalid home_node value\n");
 		g_home_node = NUMA_NO_NODE;
-- 
2.43.0



