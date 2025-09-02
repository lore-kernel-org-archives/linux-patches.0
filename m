Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5DA30C35F;
	Tue,  2 Sep 2025 13:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819986; cv=none; b=boEiZlNSyF4npCAws0YPzmGSzJhvQ8g+KtrxO120w/eb2rPirozt656jpZtXO2igjSr6LnWmiY5slQb7B0Vn7/Y/zJ0yDWvQ2HSBMKQ2DFURrnWezX6tQPfj3GsrOPRWO3NboQQZemS6NIZVr6sq1bKA6B3K5ieAaklnTdCaZlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819986; c=relaxed/simple;
	bh=H+AcWaqyfCZ5GmK0CnH7LOOmIf0KwL9sNiVgFGrTe5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEtPCw2AL3RauJBmg5uGlWxYrBmdCc6zbiUbREmg4tXfEg+caYM7l5U7JBYBG6B5ATDEaS2zOs/+eB2Pdg0PsdD4D7oby7W9m2HKif51PLLiAGZnRBgS499/8fRBeJmBzzDHv1Kf2O9bDQNF4LqXhmIqUAO56t52zT5EflvR/Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPjgtmnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPjgtmnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679E6C4CEED;
	Tue,  2 Sep 2025 13:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819986;
	bh=H+AcWaqyfCZ5GmK0CnH7LOOmIf0KwL9sNiVgFGrTe5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPjgtmnmrVi++tnfQFWURLNPcIjNt5KcP+fKRWZABiTVRqIgK3hfAaHjvzpCE8hmi
	 xizhuyUAioD2fUGh8CdliuxcpGRIvpov8Rxssmpe5QlmiYRzBXhLwwbCXa4qHeBvVe
	 qeDmAtCX2bu73bMgrilZIIf7Cqzrr+i2cLkfyvSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 56/95] net: stmmac: Set CIC bit only for TX queues with COE
Date: Tue,  2 Sep 2025 15:20:32 +0200
Message-ID: <20250902131941.755044860@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Rohan G Thomas <rohan.g.thomas@altera.com>

[ Upstream commit b1eded580ab28119de0b0f21efe37ee2b4419144 ]

Currently, in the AF_XDP transmit paths, the CIC bit of
TX Desc3 is set for all packets. Setting this bit for
packets transmitting through queues that don't support
checksum offloading causes the TX DMA to get stuck after
transmitting some packets. This patch ensures the CIC bit
of TX Desc3 is set only if the TX queue supports checksum
offloading.

Fixes: 132c32ee5bc0 ("net: stmmac: Add TX via XDP zero-copy socket")
Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Link: https://patch.msgid.link/20250825-xgmac-minor-fixes-v3-3-c225fe4444c0@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 058cd9e9fd71d..40d56ff66b6a8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2488,6 +2488,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 	struct netdev_queue *nq = netdev_get_tx_queue(priv->dev, queue);
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
 	struct stmmac_txq_stats *txq_stats = &priv->xstats.txq_stats[queue];
+	bool csum = !priv->plat->tx_queues_cfg[queue].coe_unsupported;
 	struct xsk_buff_pool *pool = tx_q->xsk_pool;
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc = NULL;
@@ -2573,7 +2574,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 		}
 
 		stmmac_prepare_tx_desc(priv, tx_desc, 1, xdp_desc.len,
-				       true, priv->mode, true, true,
+				       csum, priv->mode, true, true,
 				       xdp_desc.len);
 
 		stmmac_enable_dma_transmission(priv, priv->ioaddr, queue);
@@ -4902,6 +4903,7 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 {
 	struct stmmac_txq_stats *txq_stats = &priv->xstats.txq_stats[queue];
 	struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[queue];
+	bool csum = !priv->plat->tx_queues_cfg[queue].coe_unsupported;
 	unsigned int entry = tx_q->cur_tx;
 	struct dma_desc *tx_desc;
 	dma_addr_t dma_addr;
@@ -4953,7 +4955,7 @@ static int stmmac_xdp_xmit_xdpf(struct stmmac_priv *priv, int queue,
 	stmmac_set_desc_addr(priv, tx_desc, dma_addr);
 
 	stmmac_prepare_tx_desc(priv, tx_desc, 1, xdpf->len,
-			       true, priv->mode, true, true,
+			       csum, priv->mode, true, true,
 			       xdpf->len);
 
 	tx_q->tx_count_frames++;
-- 
2.50.1



