Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180B81FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E97C433C7;
	Tue,  1 Aug 2023 09:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883087;
	bh=ZAQJNBRmR9hUfwPoOvGTWhSg3c6HH8N+XCyaDxhkRjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcNgLAdij1tuHO0Bhkdx4Be44bLB0kx7qbiAIKhhaH0ERpKSTWfLte9ecn2vRB5O1
	 9yH9RSamFOQABIlyAvg7unU3M0b7ceDkty61x12y8HmP8dPJ55VBJ0POMkfVRGrsbb
	 pa6vIPSBvC+vGGOhUEJIS5LlMWWwugMCmC/NkOVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 093/239] net: fec: tx processing does not call XDP APIs if budget is 0
Date: Tue,  1 Aug 2023 11:19:17 +0200
Message-ID: <20230801091929.094603277@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 15cec633fc7bfe4cd69aa012c3b35b31acfc86f2 ]

According to the clarification [1] in the latest napi.rst, the tx
processing cannot call any XDP (or page pool) APIs if the "budget"
is 0. Because NAPI is called with the budget of 0 (such as netpoll)
indicates we may be in an IRQ context, however, we cannot use the
page pool from IRQ context.

[1] https://lore.kernel.org/all/20230720161323.2025379-1-kuba@kernel.org/

Fixes: 20f797399035 ("net: fec: recycle pages for transmitted XDP frames")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230725074148.2936402-1-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a1b0abe54a0e5..92410f30ad241 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1372,7 +1372,7 @@ fec_enet_hwtstamp(struct fec_enet_private *fep, unsigned ts,
 }
 
 static void
-fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
+fec_enet_tx_queue(struct net_device *ndev, u16 queue_id, int budget)
 {
 	struct	fec_enet_private *fep;
 	struct xdp_frame *xdpf;
@@ -1416,6 +1416,14 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 			if (!skb)
 				goto tx_buf_done;
 		} else {
+			/* Tx processing cannot call any XDP (or page pool) APIs if
+			 * the "budget" is 0. Because NAPI is called with budget of
+			 * 0 (such as netpoll) indicates we may be in an IRQ context,
+			 * however, we can't use the page pool from IRQ context.
+			 */
+			if (unlikely(!budget))
+				break;
+
 			xdpf = txq->tx_buf[index].xdp;
 			if (bdp->cbd_bufaddr)
 				dma_unmap_single(&fep->pdev->dev,
@@ -1508,14 +1516,14 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
 		writel(0, txq->bd.reg_desc_active);
 }
 
-static void fec_enet_tx(struct net_device *ndev)
+static void fec_enet_tx(struct net_device *ndev, int budget)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	int i;
 
 	/* Make sure that AVB queues are processed first. */
 	for (i = fep->num_tx_queues - 1; i >= 0; i--)
-		fec_enet_tx_queue(ndev, i);
+		fec_enet_tx_queue(ndev, i, budget);
 }
 
 static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
@@ -1858,7 +1866,7 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 
 	do {
 		done += fec_enet_rx(ndev, budget - done);
-		fec_enet_tx(ndev);
+		fec_enet_tx(ndev, budget);
 	} while ((done < budget) && fec_enet_collect_events(fep));
 
 	if (done < budget) {
-- 
2.39.2



