Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445FF79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA2FC433D6;
	Wed, 30 Nov 2022 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834118;
	bh=xL0QLBhARx3V2fKRqnoxqZLf5A3hP+k6oYzYu2F/iYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POiN/2z6gVXl9E5I9FJbYFU9zAzXZ7gz5Rw7T8zSBP40fcJ1bvg/wgCCMvXvI6ZVg
	 wYOVBY5C2Bj+CXyNK433CrG6yO9EWDpHM4fJBLxHZ8HLLZFckBPsVarS5evNB2Gn+a
	 3jhBUpT4SN9cKVQL2jP/dxfcrwXM/6DcrrTHjczQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 135/289] net: ethernet: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()
Date: Wed, 30 Nov 2022 19:22:00 +0100
Message-Id: <20221130180547.198925844@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 3213f808ae21be3891885de2f3a775afafcda987 ]

When fail to dma_map_single() in mtk_rx_alloc(), it returns directly.
But the memory allocated for local variable data is not freed, and
local variabel data has not been attached to ring->data[i] yet, so the
memory allocated for local variable data will not be freed outside
mtk_rx_alloc() too. Thus memory leak would occur in this scenario.

Add skb_free_frag(data) when dma_map_single() failed.

Fixes: 23233e577ef9 ("net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Link: https://lore.kernel.org/r/20221120035405.1464341-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a75f5931f746..916b570bdbf4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2363,8 +2363,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 				data + NET_SKB_PAD + eth->ip_align,
 				ring->buf_size, DMA_FROM_DEVICE);
 			if (unlikely(dma_mapping_error(eth->dma_dev,
-						       dma_addr)))
+						       dma_addr))) {
+				skb_free_frag(data);
 				return -ENOMEM;
+			}
 		}
 		rxd->rxd1 = (unsigned int)dma_addr;
 		ring->data[i] = data;
-- 
2.35.1



