Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615CA3ED5C8;
	Wed, 20 May 2026 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299097; cv=none; b=EiuHKmKa2ZGNG3QcD7Pk//0jcuzNW8wlON7yeTEWCSp5GG+kfWzzXwB4Qi3dWSdiys6ErvH0CP1uspE1UazKGWfX+1LDbOD6BpBFLq7We2Pi8R/TRhKLLm8Kq/M+EC2ruRPlClrwxOlhO+G6KzhaVyUCu9XG2YO5QP9A1JYtg5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299097; c=relaxed/simple;
	bh=9h56ctgyCZZ2ysOMIwn5lGxwiqcYYS5bVLROHlKcolg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iALOyybzyLkkDMxZzAYwdDMz8kWBi2QL7dkMD9cXmHYGlGgg7UTrmI1eCXngEXPviqZkWOUKun+9CKBLUKDvJQyXtXtHwSPM0Qp1aSmcd4goYL5COJLJKXD/13tmyv9ANjtbxUqHlY+QMgyY+oLOYMGeivEjPF9zkjyyU5QWPj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDoZKPtN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDoZKPtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847701F000E9;
	Wed, 20 May 2026 17:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299096;
	bh=rQQmIjfJudAa6M4OOO5bkghFS+bD5IWx/u12RBeC6og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDoZKPtNC96YQOz0bxD3bv6KXdNtQUFqsXL+EMEiQ7Ocl845H3laRegl0cxl54Xu7
	 w0Ay7TvhSez1+ps/144w0jowOkUnNWeT+yhr2pcsQXyzQhEdi2a3WDAyX4qwBlNLUq
	 zCL4ldIv78qkKqmYKeWEixEuP+u3/FN7oevCPFYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 659/957] net: airoha: Fix possible TX queue stall in airoha_qdma_tx_napi_poll()
Date: Wed, 20 May 2026 18:19:02 +0200
Message-ID: <20260520162148.823506204@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cbf21e15df6dd..f8db324b141fe 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -874,6 +874,21 @@ static int airoha_qdma_init_rx(struct airoha_qdma *qdma)
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
@@ -956,12 +971,21 @@ static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 
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
@@ -1978,6 +2002,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	if (airoha_dev_tx_queue_busy(q, nr_frags)) {
 		/* not enough space in the queue */
 		netif_tx_stop_queue(txq);
+		q->txq_stopped = true;
 		spin_unlock_bh(&q->lock);
 		return NETDEV_TX_BUSY;
 	}
@@ -2030,8 +2055,10 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 				TX_RING_CPU_IDX_MASK,
 				FIELD_PREP(TX_RING_CPU_IDX_MASK, q->head));
 
-	if (q->ndesc - q->queued < q->free_thr)
+	if (q->ndesc - q->queued < q->free_thr) {
 		netif_tx_stop_queue(txq);
+		q->txq_stopped = true;
+	}
 
 	spin_unlock_bh(&q->lock);
 
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index d76f71558f8c2..054fe86d67bd1 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -181,6 +181,7 @@ struct airoha_queue {
 	int ndesc;
 	int free_thr;
 	int buf_size;
+	bool txq_stopped;
 
 	struct napi_struct napi;
 	struct page_pool *page_pool;
-- 
2.53.0



