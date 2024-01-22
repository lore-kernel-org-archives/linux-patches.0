Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59DC3FFE;
	Tue, 23 Jan 2024 00:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970949; cv=none; b=Qaj81ngHY8G3xwrflLTEVVcSrKQnTYegd7efGcHWIta1Nuk1PY3i8gm187MOu1BN893JikU7rvAGJ52i4godD846cyKf8lQBClQKTJ8SlsEtZOfajS2hoKUPc2j11fNjDL0noc9AQ+jzEn8ah+0UGWuwD5SDBTkvt5MeiPvvW/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970949; c=relaxed/simple;
	bh=I46OSm5RdYSZwdkRvwvwDQPHu7CTB/mTlXRxHmEgNls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+sMXkHFPrYlnp9vTUQg5+V/Jd5L3R7/8eg4y1EG0a7AzxAq6ru5nxZDMFQqbFOrPhtXdKKVoBJlhx7yxlFlx38+lPCYYVmjYJ59yShSq/h391yRq4Lu0cp8etr/JJPSf6x1hHTo4qZeNVMc6iTndu0Y72WzS4iFVd9wlkGjN7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJjpuKiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJjpuKiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D11C43390;
	Tue, 23 Jan 2024 00:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970948;
	bh=I46OSm5RdYSZwdkRvwvwDQPHu7CTB/mTlXRxHmEgNls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJjpuKiu/uuXXSNewJrYm9Oh3xuGnKiRWHDIzQDcyzZCFTjBHsrB6BTkXoLFH9xtJ
	 YeYiMfN3T3/lCYbpCzdGmyiLTuel7xNG0rUJRzQtLsOif8zU5sEFhJ/g/oi2Ppqz16
	 bm8Uvwv4GoY+FM6ODPW93Qh7b1rxF4YrsVgOPB9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/417] null_blk: dont cap max_hw_sectors to BLK_DEF_MAX_SECTORS
Date: Mon, 22 Jan 2024 15:55:15 -0800
Message-ID: <20240122235756.918714721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index d921653b096b..959952e8ede3 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2114,10 +2114,8 @@ static int null_add_dev(struct nullb_device *dev)
 
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
@@ -2217,12 +2215,6 @@ static int __init null_init(void)
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



