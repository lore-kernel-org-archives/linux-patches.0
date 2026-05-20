Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C61D28DC4;
	Wed, 20 May 2026 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296794; cv=none; b=LSF7mLrW1XAhk5IpcXOYqT2kJdU6ttpk9srW8/bcNYQTCIqPvchWwtU+cwoTpCFrjY/aBKO8eRO4EYtPMkcXgb/W4OSx0uN4tyBFWTJdcUIrGXgFG09wQkGSvJvrmt0ItC3E4qfRRA0n/BfAm0cskNCVZf+pZzZF5//lri3MXFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296794; c=relaxed/simple;
	bh=y20OK16J2SIOBUue0Jd3DncTICFE3aU+imEX2RImsbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUG3jOTscXpLIRbpSl8lHEuidy41mf9UFLiz4zTZHw1EG9ARRgtec7SH7yrtopY2MvFj8sChyhV4BNS6PMOEt+J5Hgf5NFJdTIht4AYT5i9hANIs0K1QtcIMJaqanPlur2eZE/wKBI7fl6OnTRC8zrYBUdzLEcUM4KV7Ot+8/B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgO2LYgi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgO2LYgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C6B1F000E9;
	Wed, 20 May 2026 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296793;
	bh=L8EvwecYNzHovF4tkl2MA4E0kJ0b66ebMiASLpRqrdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgO2LYgiTVOXqkig6wgOfsnOmkY3IYi6PVLWBrJbxLki9XNot4rL8UhVlTQMdNDjl
	 0AfjzAkhgA61SxB7FN55WLIuFNe+iIgq5cfgzKj0/cf1w1iaxW8kjPuXnEzYkNoiLa
	 5XPZuildR4BzC871tM0ks3kdoc3A63gcEx2yffhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0934/1146] net: airoha: fix BQL imbalance in TX path
Date: Wed, 20 May 2026 18:19:44 +0200
Message-ID: <20260520162209.372261798@linuxfoundation.org>
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
 drivers/net/ethernet/airoha/airoha_eth.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 1bdf90b311060..a73c224d65755 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -929,10 +929,9 @@ static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 		q->queued--;
 
 		if (skb) {
-			u16 queue = skb_get_queue_mapping(skb);
 			struct netdev_queue *txq;
 
-			txq = netdev_get_tx_queue(skb->dev, queue);
+			txq = skb_get_tx_queue(skb->dev, skb);
 			netdev_tx_completed_queue(txq, 1, skb->len);
 			dev_kfree_skb_any(skb);
 		}
@@ -1735,7 +1734,7 @@ static int airoha_dev_stop(struct net_device *dev)
 	if (err)
 		return err;
 
-	for (i = 0; i < ARRAY_SIZE(qdma->q_tx); i++)
+	for (i = 0; i < dev->num_tx_queues; i++)
 		netdev_tx_reset_subqueue(dev, i);
 
 	if (atomic_dec_and_test(&qdma->users)) {
@@ -2037,7 +2036,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 
 	spin_lock_bh(&q->lock);
 
-	txq = netdev_get_tx_queue(dev, qid);
+	txq = skb_get_tx_queue(dev, skb);
 	nr_frags = 1 + skb_shinfo(skb)->nr_frags;
 
 	if (q->queued + nr_frags >= q->ndesc) {
-- 
2.53.0



