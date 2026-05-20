Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397151E633C;
	Wed, 20 May 2026 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296470; cv=none; b=Jo9FMr8+9nLziFbV5CeoJcjSXPUK6t7hLP9RNG6PJDEFk7X7mjWho9nZtiNnDftydkxHRmbGObb4nEfaBmp9hLrod9Z3jVHw9riRkEvc2rJCsOHxWxrDVJ7UgVu1PJR7ONQYXDNDL3yxo5dij+BIgAiOrHHhm3oDI+BXgFh7Tj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296470; c=relaxed/simple;
	bh=WMHnUGR75eQ5KGZu006h0xpQ+uXjvnqHpXauGvuBt3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmQ1ZSyKzIJe0KV99DFdDoKIEg7hsYx0EVxSD/4GJJVcNm8xClkzKsrCaYdKkR609Y8CVU+fLOJa0cZzWhm3nvsnwKJO6bATcMBv7LsUiBauxBU0ci/uKQGVkfopjowPsfnSvzqjrPEoM+e9WN8PQivDHb89FZu3yVSTCA+LMLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhHk0B9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhHk0B9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0B91F000E9;
	Wed, 20 May 2026 17:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296469;
	bh=UCq5BAi0EtWJMSabD87IGnxg+JJ/4Yde4OaYMi/bIHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhHk0B9FCoeJFCTtizHdco2f8/lRuWAj+ZokdFiDWhVHYa8Uu2wsmojWkI0MkKYKy
	 u5qyK87QQawCP//Hh4f8mDKKSG42/S43iFFIqz9ZhF/B2qXCLIF8FvibFYZVDFQYEi
	 OtrTi9tUnhIR7xxUj5lxfQ/WmFi9P8yZ3BdNYOEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0810/1146] net: airoha: Fix possible TX queue stall in airoha_qdma_tx_napi_poll()
Date: Wed, 20 May 2026 18:17:40 +0200
Message-ID: <20260520162206.558043986@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b94769eb2f30e61e86cd8551c084c34134290d89 ]

Since multiple net_device TX queues can share the same hw QDMA TX queue,
there is no guarantee we have inflight packets queued in hw belonging to a
net_device TX queue stopped in the xmit path because hw QDMA TX queue
can be full. In this corner case the net_device TX queue will never be
re-activated. In order to avoid any potential net_device TX queue stall,
we need to wake all the net_device TX queues feeding the same hw QDMA TX
queue in airoha_qdma_tx_napi_poll routine.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260416-airoha-txq-potential-stall-v2-1-42c732074540@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 37 ++++++++++++++++++++----
 drivers/net/ethernet/airoha/airoha_eth.h |  1 +
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index f484835af703c..3deffc499bcb4 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -843,6 +843,21 @@ static int airoha_qdma_init_rx(struct airoha_qdma *qdma)
 	return 0;
 }
 
+static void airoha_qdma_wake_netdev_txqs(struct airoha_queue *q)
+{
+	struct airoha_qdma *qdma = q->qdma;
+	struct airoha_eth *eth = qdma->eth;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(eth->ports); i++) {
+		struct airoha_gdm_port *port = eth->ports[i];
+
+		if (port && port->qdma == qdma)
+			netif_tx_wake_all_queues(port->dev);
+	}
+	q->txq_stopped = false;
+}
+
 static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 {
 	struct airoha_tx_irq_queue *irq_q;
@@ -919,12 +934,21 @@ static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 
 			txq = netdev_get_tx_queue(skb->dev, queue);
 			netdev_tx_completed_queue(txq, 1, skb->len);
-			if (netif_tx_queue_stopped(txq) &&
-			    q->ndesc - q->queued >= q->free_thr)
-				netif_tx_wake_queue(txq);
-
 			dev_kfree_skb_any(skb);
 		}
+
+		if (q->txq_stopped && q->ndesc - q->queued >= q->free_thr) {
+			/* Since multiple net_device TX queues can share the
+			 * same hw QDMA TX queue, there is no guarantee we have
+			 * inflight packets queued in hw belonging to a
+			 * net_device TX queue stopped in the xmit path.
+			 * In order to avoid any potential net_device TX queue
+			 * stall, we need to wake all the net_device TX queues
+			 * feeding the same hw QDMA TX queue.
+			 */
+			airoha_qdma_wake_netdev_txqs(q);
+		}
+
 unlock:
 		spin_unlock_bh(&q->lock);
 	}
@@ -1970,6 +1994,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	if (q->queued + nr_frags >= q->ndesc) {
 		/* not enough space in the queue */
 		netif_tx_stop_queue(txq);
+		q->txq_stopped = true;
 		spin_unlock_bh(&q->lock);
 		return NETDEV_TX_BUSY;
 	}
@@ -2025,8 +2050,10 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 				TX_RING_CPU_IDX_MASK,
 				FIELD_PREP(TX_RING_CPU_IDX_MASK, index));
 
-	if (q->ndesc - q->queued < q->free_thr)
+	if (q->ndesc - q->queued < q->free_thr) {
 		netif_tx_stop_queue(txq);
+		q->txq_stopped = true;
+	}
 
 	spin_unlock_bh(&q->lock);
 
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 8bcd809e6f53e..c9d1abda47768 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -193,6 +193,7 @@ struct airoha_queue {
 	int ndesc;
 	int free_thr;
 	int buf_size;
+	bool txq_stopped;
 
 	struct napi_struct napi;
 	struct page_pool *page_pool;
-- 
2.53.0



