Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641B231853;
	Thu,  3 Jul 2025 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554242; cv=none; b=mBgQIYZNibQvVRzYYAmvmmBGGXfCFPWmYfa6BVHAizAWbNrLR/ujAcRhXQK7C0WUeZc/jPKX1QkWwR3ZoWRGRwNtls5swKIQKsGW855w+LEqko6xJp8JSQ65fYhvEBsayM+sZ7ug+sGlotMEMJgCHYc4wOdekiBqIr9HnW4l21w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554242; c=relaxed/simple;
	bh=bl3mVllg0152T3SiKFvSgnT20KHEaMbtT3WAD3YPpAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiELflEMSRLGBi9tOIV32LIAh0rdP6BeOHLLGqdYfTTLNpiaDYGFujQ/GZfb0OmOZRevPdgnATZCflA3SsofHCZq5q8H2zA28eayrHcFAR8QndTJAZ/uQ2wd5RpgoJ7ck4TNviG4ZeXlGNHSXQ90nUM5tZgrIU6MXHe9WKHEUDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgPodupH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgPodupH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E658FC4CEF3;
	Thu,  3 Jul 2025 14:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554242;
	bh=bl3mVllg0152T3SiKFvSgnT20KHEaMbtT3WAD3YPpAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgPodupHCjShNE9N9FAWsuj35py1I4HnhKEZtUEdbHuX2aVCmLxGsWeSbr7QLldd9
	 3pdgrT4JgwKqRqR8hrWNGAukhnFbZ7uD2EuJ6Z5XqruNCIhDVST1zjDq95qxPpRPk2
	 O3hDf/zASKxHsyNWoPMwC0iGD/xhnEuzimgNNM4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/218] ethernet: ionic: Fix DMA mapping tests
Date: Thu,  3 Jul 2025 16:40:44 +0200
Message-ID: <20250703143959.774604679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit d5e3241c5a386a2425823c8c7afb77a465bd040f ]

Change error values of `ionic_tx_map_single()` and `ionic_tx_map_frag()`
from 0 to `DMA_MAPPING_ERROR` to prevent collision with 0 as a valid
address.

This also fixes the use of `dma_mapping_error()` to test against 0 in
`ionic_xdp_post_frame()`

Fixes: 0f3154e6bcb3 ("ionic: Add Tx and Rx handling")
Fixes: 56e41ee12d2d ("ionic: better dma-map error handling")
Fixes: ac8813c0ab7d ("ionic: convert Rx queue buffers to use page_pool")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://patch.msgid.link/20250619094538.283723-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 0eeda7e502db2..0f5758c273c22 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -321,7 +321,7 @@ static int ionic_xdp_post_frame(struct ionic_queue *q, struct xdp_frame *frame,
 					   len, DMA_TO_DEVICE);
 	} else /* XDP_REDIRECT */ {
 		dma_addr = ionic_tx_map_single(q, frame->data, len);
-		if (!dma_addr)
+		if (dma_addr == DMA_MAPPING_ERROR)
 			return -EIO;
 	}
 
@@ -357,7 +357,7 @@ static int ionic_xdp_post_frame(struct ionic_queue *q, struct xdp_frame *frame,
 			} else {
 				dma_addr = ionic_tx_map_frag(q, frag, 0,
 							     skb_frag_size(frag));
-				if (dma_mapping_error(q->dev, dma_addr)) {
+				if (dma_addr == DMA_MAPPING_ERROR) {
 					ionic_tx_desc_unmap_bufs(q, desc_info);
 					return -EIO;
 				}
@@ -1083,7 +1083,7 @@ static dma_addr_t ionic_tx_map_single(struct ionic_queue *q,
 		net_warn_ratelimited("%s: DMA single map failed on %s!\n",
 				     dev_name(dev), q->name);
 		q_to_tx_stats(q)->dma_map_err++;
-		return 0;
+		return DMA_MAPPING_ERROR;
 	}
 	return dma_addr;
 }
@@ -1100,7 +1100,7 @@ static dma_addr_t ionic_tx_map_frag(struct ionic_queue *q,
 		net_warn_ratelimited("%s: DMA frag map failed on %s!\n",
 				     dev_name(dev), q->name);
 		q_to_tx_stats(q)->dma_map_err++;
-		return 0;
+		return DMA_MAPPING_ERROR;
 	}
 	return dma_addr;
 }
@@ -1116,7 +1116,7 @@ static int ionic_tx_map_skb(struct ionic_queue *q, struct sk_buff *skb,
 	int frag_idx;
 
 	dma_addr = ionic_tx_map_single(q, skb->data, skb_headlen(skb));
-	if (!dma_addr)
+	if (dma_addr == DMA_MAPPING_ERROR)
 		return -EIO;
 	buf_info->dma_addr = dma_addr;
 	buf_info->len = skb_headlen(skb);
@@ -1126,7 +1126,7 @@ static int ionic_tx_map_skb(struct ionic_queue *q, struct sk_buff *skb,
 	nfrags = skb_shinfo(skb)->nr_frags;
 	for (frag_idx = 0; frag_idx < nfrags; frag_idx++, frag++) {
 		dma_addr = ionic_tx_map_frag(q, frag, 0, skb_frag_size(frag));
-		if (!dma_addr)
+		if (dma_addr == DMA_MAPPING_ERROR)
 			goto dma_fail;
 		buf_info->dma_addr = dma_addr;
 		buf_info->len = skb_frag_size(frag);
-- 
2.39.5



