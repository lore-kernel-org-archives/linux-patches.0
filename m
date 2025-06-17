Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B361F2ED844;
	Tue, 17 Jun 2025 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177539; cv=none; b=oxIFGZjEoxh9OZ3jzUQzYz/GR6iLZgyAfmyJTIrnHWR7fi/gSUWe8AY0INO737zJ/agcpVvWJEnneP0PqILG8tc/BZtm8AkALJ0/8YapamrdbaEXjhPrCMa81bhJWpUWrPnY1I7weSaMEj0rforj08Wc0Wg7xdmtw6JqHRPQhIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177539; c=relaxed/simple;
	bh=jEhiZIbG5iC/n09BcwoabuJ5BQZOVqOmNRn+P6uCIak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd1pO/TV+2c0z6TGaIQIWZxMYr1w2YyQFNMpKgHRJLQZ3uZTG9UMd9pO8DUQTkBq8UR+Xgr3+r9DcWmtCHXBau6DnKMJx34WR3plXj1MnaojmH7o5mrBalNYgDCdbgsWWxw4+i/KtUTAGGyIxmCIwS4mUdXgjhT4cj/I8jlkMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+1HGMAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+1HGMAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A2CC4CEE3;
	Tue, 17 Jun 2025 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177539;
	bh=jEhiZIbG5iC/n09BcwoabuJ5BQZOVqOmNRn+P6uCIak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+1HGMAwusHNi2kF+q5q0vCeCKzWxq2hf/0e9k6jQHxZcl3gWd5Cw3Q4Ss4neBAF8
	 ElwBRdAT+ets2CHjD3cXh1KTu3JjYzoPA+xu5rS8cSXWpxK6n6UITYJabnwMtdP1Q5
	 VmTM84nrEelSmAoqbalRQJSc9XNob+nRoZ+qs7LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 321/780] net: xilinx: axienet: Fix Tx skb circular buffer occupancy check in dmaengine xmit
Date: Tue, 17 Jun 2025 17:20:29 +0200
Message-ID: <20250617152504.523237951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit 32374234ab0101881e7d0c6a8ef7ebce566c46c9 ]

In Dmaengine flow, driver maintains struct skbuf_dma_descriptor rings each
element of which corresponds to a skb. In Tx datapath, compare available
space in skb ring with number of skbs instead of skb fragments.
Replace x * (MAX_SKB_FRAGS) in netif_txq_completed_wake() and
netif_txq_maybe_stop() with x * (1 skb) to fix the comparison.

Fixes: 6a91b846af85 ("net: axienet: Introduce dmaengine support")
Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20250521181608.669554-1-suraj.gupta2@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 054abf283ab33..5f912b27bfd7f 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -880,7 +880,7 @@ static void axienet_dma_tx_cb(void *data, const struct dmaengine_result *result)
 	dev_consume_skb_any(skbuf_dma->skb);
 	netif_txq_completed_wake(txq, 1, len,
 				 CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX),
-				 2 * MAX_SKB_FRAGS);
+				 2);
 }
 
 /**
@@ -914,7 +914,7 @@ axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device *ndev)
 
 	dma_dev = lp->tx_chan->device;
 	sg_len = skb_shinfo(skb)->nr_frags + 1;
-	if (CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX) <= sg_len) {
+	if (CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX) <= 1) {
 		netif_stop_queue(ndev);
 		if (net_ratelimit())
 			netdev_warn(ndev, "TX ring unexpectedly full\n");
@@ -964,7 +964,7 @@ axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device *ndev)
 	txq = skb_get_tx_queue(lp->ndev, skb);
 	netdev_tx_sent_queue(txq, skb->len);
 	netif_txq_maybe_stop(txq, CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX),
-			     MAX_SKB_FRAGS + 1, 2 * MAX_SKB_FRAGS);
+			     1, 2);
 
 	dmaengine_submit(dma_tx_desc);
 	dma_async_issue_pending(lp->tx_chan);
-- 
2.39.5



