Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E610154C1B;
	Tue, 23 Jan 2024 00:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969406; cv=none; b=W3TkgEss8fJIHMj6d9+8ofyDtX388PgFcOknzChDwpUedG/Az739F/A3McvGBJcAVtYJ1XGXNkhd10DtitxEELm6O34aXjFJ8NfTFOmcATLaMUN3crGIvzqa3QSZN0D+lxec9vbVuCAib0Ku7rJ51Hwwp0tgRBhyZNwUPQh5A2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969406; c=relaxed/simple;
	bh=ooRJNfvFtFWfYmAD5FiKrogOKLd3CMOKTEFhBbaObxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bl4CVnssldaVFLgawOz84KqcR+I+nHdHtA75mNIgTTIlyJNv/v3Mx/cW6u3jy6jqd9edViuTF8N0JYAQmn24o0Xb7QGnqY47+mKGBuBtnC4PA7jsMZmLv+R1uwy9hO1jwMEGyHX0X3ZamDT9IK9ajLzUVkZSTDtIEwWOVeX4AGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWvs/0K4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWvs/0K4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D08C43390;
	Tue, 23 Jan 2024 00:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969406;
	bh=ooRJNfvFtFWfYmAD5FiKrogOKLd3CMOKTEFhBbaObxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWvs/0K4M0XHXZnRw5BMF7q7emfRq7jo7td0RPBjxj+9XxaQaoilrOaF46d6BVS31
	 NtNtMRXUsyMq+7SKIm8KGZ/uMRVAasmCvs4zXf0PwLTOfqzvbnMdIpDzjYEWIBJzmP
	 Fd9EsI2+Bo/SpndMb6ONS0xfbJGiugGLwALqkuFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 226/641] null_blk: dont cap max_hw_sectors to BLK_DEF_MAX_SECTORS
Date: Mon, 22 Jan 2024 15:52:10 -0800
Message-ID: <20240122235825.012602064@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index 3021d58ca51c..13ed446b5e19 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2186,10 +2186,8 @@ static int null_add_dev(struct nullb_device *dev)
 
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
@@ -2289,12 +2287,6 @@ static int __init null_init(void)
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



