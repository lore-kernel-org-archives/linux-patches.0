Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F23E183CB0;
	Tue, 10 Sep 2024 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963180; cv=none; b=qoiEq2p6HiP5lwNX6NL39r+RF4MGA7nKeVQNDSWE09E9w+RvUF1FxWnDQ0zMxOAqiMRzaaPgO+53aWoV6zxkWtnLQ6q2f1DzCQUDYUV4THbfuD6kHKDLRSoi0X/0IUVrphqUxB5VlrD8Cp6GpOoBHhw9HG0b8pYo+Lr7Z9h8g3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963180; c=relaxed/simple;
	bh=WRGY/d7BMN1lw8tHU3KRSbEV5nREuEpinvTjoshGAoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fklgEhc/MsmU8NwP8bF7wCNT3tNC7Xy7CrCQFeywaeKh0NmrzDOMZ9SPuR97GB5fXEzzRDL9ww/J2blj3PrQO+5/GPyBwTxFQAulLlDlXhxOeGLN1Sq/uN7ipEuLmebKyWwvxHYpyr4oW/izzP1WnfSMmYJcO+fsE+7YN3w2i1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9fzZWK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9fzZWK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10ED3C4CEC3;
	Tue, 10 Sep 2024 10:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963180;
	bh=WRGY/d7BMN1lw8tHU3KRSbEV5nREuEpinvTjoshGAoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9fzZWK4N2DabdMl7l8XbTQY2cvZWfUG5GsQNehMsEC5qEiUgnf7VH0AA6qXwV0al
	 4LgGMfjj+wY1IfOq+NMOdKooJ5HqllEviFP5ynadPOPzf2wlhIEhvNzT5QzUyS9Yeh
	 G2redSU7KQXwMX/BzLO5QEtYIKvxQVUmCe4xE9eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/192] net: mana: Fix error handling in mana_create_txq/rxqs NAPI cleanup
Date: Tue, 10 Sep 2024 11:33:06 +0200
Message-ID: <20240910092604.606682526@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>

[ Upstream commit b6ecc662037694488bfff7c9fd21c405df8411f2 ]

Currently napi_disable() gets called during rxq and txq cleanup,
even before napi is enabled and hrtimer is initialized. It causes
kernel panic.

? page_fault_oops+0x136/0x2b0
  ? page_counter_cancel+0x2e/0x80
  ? do_user_addr_fault+0x2f2/0x640
  ? refill_obj_stock+0xc4/0x110
  ? exc_page_fault+0x71/0x160
  ? asm_exc_page_fault+0x27/0x30
  ? __mmdrop+0x10/0x180
  ? __mmdrop+0xec/0x180
  ? hrtimer_active+0xd/0x50
  hrtimer_try_to_cancel+0x2c/0xf0
  hrtimer_cancel+0x15/0x30
  napi_disable+0x65/0x90
  mana_destroy_rxq+0x4c/0x2f0
  mana_create_rxq.isra.0+0x56c/0x6d0
  ? mana_uncfg_vport+0x50/0x50
  mana_alloc_queues+0x21b/0x320
  ? skb_dequeue+0x5f/0x80

Cc: stable@vger.kernel.org
Fixes: e1b5683ff62e ("net: mana: Move NAPI from EQ to CQ")
Signed-off-by: Souradeep Chakrabarti <schakrabarti@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana.h    |  2 ++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 22 +++++++++++--------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 41c99eabf40a..2b00d6a29117 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -86,6 +86,8 @@ struct mana_txq {
 
 	atomic_t pending_sends;
 
+	bool napi_initialized;
+
 	struct mana_stats_tx stats;
 };
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index e7d1ce68f05e..b52612eef0a6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1391,10 +1391,12 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 
 	for (i = 0; i < apc->num_queues; i++) {
 		napi = &apc->tx_qp[i].tx_cq.napi;
-		napi_synchronize(napi);
-		napi_disable(napi);
-		netif_napi_del(napi);
-
+		if (apc->tx_qp[i].txq.napi_initialized) {
+			napi_synchronize(napi);
+			napi_disable(napi);
+			netif_napi_del(napi);
+			apc->tx_qp[i].txq.napi_initialized = false;
+		}
 		mana_destroy_wq_obj(apc, GDMA_SQ, apc->tx_qp[i].tx_object);
 
 		mana_deinit_cq(apc, &apc->tx_qp[i].tx_cq);
@@ -1450,6 +1452,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		txq->ndev = net;
 		txq->net_txq = netdev_get_tx_queue(net, i);
 		txq->vp_offset = apc->tx_vp_offset;
+		txq->napi_initialized = false;
 		skb_queue_head_init(&txq->pending_skbs);
 
 		memset(&spec, 0, sizeof(spec));
@@ -1514,6 +1517,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		netif_napi_add_tx(net, &cq->napi, mana_poll);
 		napi_enable(&cq->napi);
+		txq->napi_initialized = true;
 
 		mana_gd_ring_cq(cq->gdma_cq, SET_ARM_BIT);
 	}
@@ -1525,7 +1529,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 }
 
 static void mana_destroy_rxq(struct mana_port_context *apc,
-			     struct mana_rxq *rxq, bool validate_state)
+			     struct mana_rxq *rxq, bool napi_initialized)
 
 {
 	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
@@ -1539,15 +1543,15 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 
 	napi = &rxq->rx_cq.napi;
 
-	if (validate_state)
+	if (napi_initialized) {
 		napi_synchronize(napi);
 
-	napi_disable(napi);
+		napi_disable(napi);
 
+		netif_napi_del(napi);
+	}
 	xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
-	netif_napi_del(napi);
-
 	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
-- 
2.43.0



