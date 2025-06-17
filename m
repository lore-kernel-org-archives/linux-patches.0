Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EFB2DFF06;
	Tue, 17 Jun 2025 16:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176183; cv=none; b=DUI3PL4e4xvcS30A5Dn8hv/0nk9Y05SKTDe0ZMR7fk+YO4xZGGg69xmszZwUh/Lv5ecWEnONskj54+hYoRWtRqlWYnwKN7U5szb7iCwwl3NsxW7zq6myhIDkXeMawWW22HG0HRbmNBVJ/8xo+aEeRhqAKKlm6pigd7KJdM2MbLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176183; c=relaxed/simple;
	bh=niC42KWOkPP+D+P8Bt7N6mljhyZ1CcBNHnu6fodmjdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk36Zy+bfJhZ9kKbyinCzwzZ/A/CsPPayKsZylHqu0H2bJ0L2PZjUSl3nseN+TW4qs/C3Z7OXQ05yaGP+WYFhdqu/6L1lJ0d3qV+QES+UwU8+RgTSIyqMjj6VPFbci7dt42lWbYcRYtbIWX/2xS+hntFDYyPBy2PPnQfNYkJodg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuPvGg/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuPvGg/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC94BC4CEE3;
	Tue, 17 Jun 2025 16:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176183;
	bh=niC42KWOkPP+D+P8Bt7N6mljhyZ1CcBNHnu6fodmjdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuPvGg/oKwvJ81vRlte9jQTFZGxUlc7oK568gCllyZEKJIv4uCp0nPCq2GL12xwrg
	 ciChT78gOBY5nNupzLIrvkXYKTttZciRqU0Kqxu8BwQ3dGSIx5ThzskwOwpwXDguNE
	 aKxEA6h/SkDrSzKv178HqUFx5mkTOsF7Iz5bFjxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/512] net: xilinx: axienet: Fix Tx skb circular buffer occupancy check in dmaengine xmit
Date: Tue, 17 Jun 2025 17:22:50 +0200
Message-ID: <20250617152427.903882535@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index fe3438abcd253..2d47b35443af0 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -843,7 +843,7 @@ static void axienet_dma_tx_cb(void *data, const struct dmaengine_result *result)
 	dev_consume_skb_any(skbuf_dma->skb);
 	netif_txq_completed_wake(txq, 1, len,
 				 CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX),
-				 2 * MAX_SKB_FRAGS);
+				 2);
 }
 
 /**
@@ -877,7 +877,7 @@ axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device *ndev)
 
 	dma_dev = lp->tx_chan->device;
 	sg_len = skb_shinfo(skb)->nr_frags + 1;
-	if (CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX) <= sg_len) {
+	if (CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX) <= 1) {
 		netif_stop_queue(ndev);
 		if (net_ratelimit())
 			netdev_warn(ndev, "TX ring unexpectedly full\n");
@@ -927,7 +927,7 @@ axienet_start_xmit_dmaengine(struct sk_buff *skb, struct net_device *ndev)
 	txq = skb_get_tx_queue(lp->ndev, skb);
 	netdev_tx_sent_queue(txq, skb->len);
 	netif_txq_maybe_stop(txq, CIRC_SPACE(lp->tx_ring_head, lp->tx_ring_tail, TX_BD_NUM_MAX),
-			     MAX_SKB_FRAGS + 1, 2 * MAX_SKB_FRAGS);
+			     1, 2);
 
 	dmaengine_submit(dma_tx_desc);
 	dma_async_issue_pending(lp->tx_chan);
-- 
2.39.5



