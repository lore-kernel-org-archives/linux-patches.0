Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3163A6B92;
	Sat, 17 Oct 2026 16:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254016; cv=none; b=UGFQkBmB1DSmslpQfuY30WMOb40wKo0C3VwY4c50SUl9kzu37qLAsGghzJ1xXiQZJXAqkX/zFbAcGyNtVnBZNScJunKcU+Mkwa84P0HcJGWztHzjxLrMwaGwRhehAfGSGrEsd8PAt/jDMDSKjv1nDiGk/s/AyGXe4uLi44gNnOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254016; c=relaxed/simple;
	bh=BN/h6RwOhIwwVyH00Zc6QmmfOUGEWFqLFGsbdvLSogw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mu+u2CkM46AKsdY/s791ZvjvaUcmv3ilkbrGCMN8ixk7AgDpDA6TclsGuDgniD243P5wAZcvD+Z6226WwUinqBeuAQ83Z+UADZSVUn18KZReVf8yc6aUCeZFzqQRktd5izhkV1fGEJsv5/tyERLGry5VXF5wnEtdlCV0rX7o7ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJaFLED3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJaFLED3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08291F000C4;
	Sat, 17 Oct 2026 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254015;
	bh=9bUxWg21CQjQ9UHKRza/AI4fsWkAF0G7LeTePI7mHBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJaFLED3H3OSHLhQ+5doalxshUOdXE6YYB44zYGCAl9kfBuNDGvVr9E9BwRr0YLpQ
	 PEDSF+98KYn+wkt38a1aj/9jQ2dRxOmbs3s0aUNoIhDQqURzhhkMrNyW3iQ6uhqKmW
	 3LzVpKu4PWv02UeG2Ow5JRgGq3bQyhsCxEqRSfFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/869] net: airoha: fix BQL imbalance in TX path
Date: Sat, 17 Oct 2026 17:52:29 +0200
Message-ID: <20261017160044.972413123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2d9f5a118205da2683ffcec78b9347f1f01a820e ]

Fix a possible BQL imbalance in airoha_dev_xmit(), where inflight
packets are accounted only for the AIROHA_NUM_TX_RING netdev TX
queues. The queue index is computed as:

    qid = skb_get_queue_mapping(skb) % ARRAY_SIZE(qdma->q_tx)
    txq = netdev_get_tx_queue(dev, qid);

However, airoha_qdma_tx_napi_poll() accounts completions across all
netdev TX queues (num_tx_queues), leading to inconsistent BQL
accounting.

Also reset all netdev TX queues in the ndo_stop callback.

Fixes: 1d304174106c ("net: airoha: Implement BQL support")
Fixes: c9f947769b77 ("net: airoha: Reset BQL stopping the netdevice")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260421-airoha-fix-bql-v1-1-f135afe4275b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 9ebc9788ded70..41695f353cdc6 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1777,10 +1777,9 @@ static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 			WRITE_ONCE(desc->msg1, 0);
 
 			if (skb) {
-				u16 queue = skb_get_queue_mapping(skb);
 				struct netdev_queue *txq;
 
-				txq = netdev_get_tx_queue(skb->dev, queue);
+				txq = skb_get_tx_queue(skb->dev, skb);
 				netdev_tx_completed_queue(txq, 1, skb->len);
 				if (netif_tx_queue_stopped(txq) &&
 				    q->ndesc - q->queued >= q->free_thr)
@@ -2559,7 +2558,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 
 	spin_lock_bh(&q->lock);
 
-	txq = netdev_get_tx_queue(dev, qid);
+	txq = skb_get_tx_queue(dev, skb);
 	if (q->queued + nr_frags > q->ndesc) {
 		/* not enough space in the queue */
 		netif_tx_stop_queue(txq);
-- 
2.53.0



