Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D71B3375DC;
	Tue, 26 Aug 2025 11:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207918; cv=none; b=hZS0vHUVCjabFRBiGE+xHXpMTEZnYal0wvZOmq6b9C7toDWVbEw3jcytCqMqWCmoSd5AOrj+8e48qu9BUUkJezn7XMJXypn/MK/Klk+jBF7ofm7W09hRA+PzpLZ2sGpartlbH0fsK3of4bS7KBSXhUHCXbyfPAVGo5idbGQBSMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207918; c=relaxed/simple;
	bh=XWVhs+WtVy7y4FnBPcHUkipLSS/Ne/UVL9ysUAaCxcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBV4gwGZdpXjqsH/ThHX9MWFlF1uZ7ChD7+TqvgcU0fy9PEOyJN7AJPTsreaHUeRFKSi1xAQkDY6cE0qqsQ/Jwm5YkwHFsaFPHDK4A08ptGePJLrfXMATkEg3TMBcC3RfO+sMlJpuHS5rZL72+LE0CbAa1NlMar/h7faCWez5Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7vV6sdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7vV6sdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF289C4CEF1;
	Tue, 26 Aug 2025 11:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207918;
	bh=XWVhs+WtVy7y4FnBPcHUkipLSS/Ne/UVL9ysUAaCxcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7vV6sdEaZ/SgoVRw36YKdmZXqE9osTqrd7KFvnhFOtxz9m8kGFWDtzMWSNzkEHq5
	 PzfOlTjnftinYvHmu73HktJBksA/1mftJlebBAyRfMptsx0QrWug/GRysYZO0hYKVv
	 WzlNjg++KiZd+PiXJeJ6Nrm3/7YvEvEWFFor209s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 367/457] net: xilinx: axienet: Fix RX skb ring management in DMAengine mode
Date: Tue, 26 Aug 2025 13:10:51 +0200
Message-ID: <20250826110946.375790600@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit fd980bf6e9cdae885105685259421164f843ca55 ]

Submit multiple descriptors in axienet_rx_cb() to fill Rx skb ring. This
ensures the ring "catches up" on previously missed allocations.

Increment Rx skb ring head pointer after BD is successfully allocated.
Previously, head pointer was incremented before verifying if descriptor is
successfully allocated and has valid entries, which could lead to ring
state inconsistency if descriptor setup failed.

These changes improve reliability by maintaining adequate descriptor
availability and ensuring proper ring buffer state management.

Fixes: 6a91b846af85 ("net: axienet: Introduce dmaengine support")
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Link: https://patch.msgid.link/20250813135559.1555652-1-suraj.gupta2@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6011d7eae0c7..0d8a05fe541a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1160,6 +1160,7 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 	struct axienet_local *lp = data;
 	struct sk_buff *skb;
 	u32 *app_metadata;
+	int i;
 
 	skbuf_dma = axienet_get_rx_desc(lp, lp->rx_ring_tail++);
 	skb = skbuf_dma->skb;
@@ -1178,7 +1179,10 @@ static void axienet_dma_rx_cb(void *data, const struct dmaengine_result *result)
 	u64_stats_add(&lp->rx_packets, 1);
 	u64_stats_add(&lp->rx_bytes, rx_len);
 	u64_stats_update_end(&lp->rx_stat_sync);
-	axienet_rx_submit_desc(lp->ndev);
+
+	for (i = 0; i < CIRC_SPACE(lp->rx_ring_head, lp->rx_ring_tail,
+				   RX_BUF_NUM_DEFAULT); i++)
+		axienet_rx_submit_desc(lp->ndev);
 	dma_async_issue_pending(lp->rx_chan);
 }
 
@@ -1457,7 +1461,6 @@ static void axienet_rx_submit_desc(struct net_device *ndev)
 	if (!skbuf_dma)
 		return;
 
-	lp->rx_ring_head++;
 	skb = netdev_alloc_skb(ndev, lp->max_frm_size);
 	if (!skb)
 		return;
@@ -1482,6 +1485,7 @@ static void axienet_rx_submit_desc(struct net_device *ndev)
 	skbuf_dma->desc = dma_rx_desc;
 	dma_rx_desc->callback_param = lp;
 	dma_rx_desc->callback_result = axienet_dma_rx_cb;
+	lp->rx_ring_head++;
 	dmaengine_submit(dma_rx_desc);
 
 	return;
-- 
2.50.1



