Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE7833AD88;
	Sat, 12 Sep 2026 09:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204877; cv=none; b=r6xGlKXsNVwOHR2y2Rtnk/yyapjGZXwoPkHB2+eC+LE7uucx/2ZIH3s7YlTm71OUZ50/yLQzWmZlvSTQt8WqQgQ00zzH7/T0+anQJcgpS4vxhCXT3aCDA/U7G3k6cMBNM5T9lEcw9f0FXgfYyeb8mluUiC0UJnRuqWCEexGCZ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204877; c=relaxed/simple;
	bh=PbT2N1u5mmE0+vLzdFdAsZgbVlwb5xAlFJoCy8W1FFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHJnerKD51TqPB4TOXX7Ba+Jw2UVqWO2rgHMstS2GzoknDDgMrBNLKVzyUWLIV+zmuadlukaTWedhTCiCNlt2DxibToDafYJKHIPBT6ax+s2/vwVdVAfFsZHB7BX+0MKmgsjSogbswgRI+Ksxxrsg60YVN2FX5SZoz8RGkkDzCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZ/k93hq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZ/k93hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30C01F000FF;
	Sat, 12 Sep 2026 09:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204875;
	bh=oDSB5q13QHmejUDePZ4Pps23ANNYjPJHdvDsV0iRkX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZ/k93hqaGAWXX0qDMgnPo5LJ7b9mDoDt6Udygf1Ws6JYy9J2TBbOhio0+TLoeOil
	 yVArCszmMXuuULhInZCsOFO3vf3QaXma5PLv17Ie1zQvZVLI2vsLOiascDeU0WKcHN
	 Z+UB7WQg3psHN5G8jrboqC1iPxjWvfnqbiQJFJTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1704/1815] net: hibmcge: fix page_pool DMA direction mismatch
Date: Sat, 12 Sep 2026 08:57:34 +0200
Message-ID: <20260912065728.981774081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 11efd7963dac9b036a7c9a435ab0e621188910e8 ]

The driver memsets the RX buffer page head to zero before
submitting it to hardware, then calls dma_sync_single_for_device()
with DMA_TO_DEVICE.  This sync direction does not match the pool
dma_dir which is DMA_FROM_DEVICE, violating the DMA API contract
that the sync direction must match the mapping direction.

On swiotlb platforms the mismatch can cause incorrect bounce-buffer
behaviour, and CONFIG_DMA_API_DEBUG emits a warning.

Switch the page_pool dma_dir to DMA_BIDIRECTIONAL so that the
CPU-to-device memset sync becomes legal.

Fixes: c30595917585 ("net: hibmcge: add support for pagepool on rx")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260820124346.4097115-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
index 0ae3149946769..3e6ae2aa0d4b4 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.c
@@ -553,7 +553,7 @@ static int hbg_ring_page_pool_init(struct hbg_priv *priv, struct hbg_ring *ring)
 		.nid = dev_to_node(&priv->pdev->dev),
 		.dev = &priv->pdev->dev,
 		.napi = &ring->napi,
-		.dma_dir = DMA_FROM_DEVICE,
+		.dma_dir = DMA_BIDIRECTIONAL,
 		.offset = 0,
 		.max_len = hbg_get_page_size(ring),
 	};
-- 
2.53.0



