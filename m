Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410423F23C5;
	Wed, 20 May 2026 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299612; cv=none; b=ODF/zBOdYsJxIfYRLTej1S8KCa14u95BGstdrRC2aax00R/+xbHuOq4y8LHhCmkMDSf8V6nMw0SA4iU9oF22waW4M7p2ni8nycJKUunUACUNo+k8ydpmkP4x+eDbYHG3zGNOixWbq3tdPf/f4ZtEGugk8MnQXAaM6FaRxM1wsE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299612; c=relaxed/simple;
	bh=fwOwH2urZ0ThzA2oA8YdF117Yr7bH2vAAobv2j7nq94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDmKAsBrmb8SFWn8HXQSq6unTjdWHPmPBTxCWQJTGIPwV7kelfs+jWDz1b4Ll+CWnBMHQ+kNIYeO3en0ywxw+R6f8AHyBJGd17pzlA9R60acUBznTSZWrjg/8Lc0y8BbGNgHf24Y8X5GumkyAksFVbOZKXkuLwJ4pz3FUenvFOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmswOhAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmswOhAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36F91F000E9;
	Wed, 20 May 2026 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299611;
	bh=6lfbn2cySl0zjZHGFQTFloBXldOiHlCG0y1Xa5x1GzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmswOhAqCgrOA4iwmgaAT+NXN8LqT4AXt23duVn/SheZynyGyP4J2zkuSiZdiBvMY
	 Wd/xf6Yz2M9Yd9Hu7fCVKpW9jfqm8fz9YqEXEOE9jFOa9yXWHRcNfWT5pXeQO1Qt0q
	 hi8SJoqYnEQYhreinw2RFxvdAJxQOgAWx63H82PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 836/957] net: airoha: fix BQL imbalance in TX path
Date: Wed, 20 May 2026 18:21:59 +0200
Message-ID: <20260520162152.693483049@linuxfoundation.org>
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
Stable-dep-of: 4ca01292ea2f ("net: airoha: Do not return err in ndo_stop() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index a69544e785a2a..6742d0d9068df 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -971,10 +971,9 @@ static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 		q->queued--;
 
 		if (skb) {
-			u16 queue = skb_get_queue_mapping(skb);
 			struct netdev_queue *txq;
 
-			txq = netdev_get_tx_queue(skb->dev, queue);
+			txq = skb_get_tx_queue(skb->dev, skb);
 			netdev_tx_completed_queue(txq, 1, skb->len);
 			dev_kfree_skb_any(skb);
 		}
@@ -1777,7 +1776,7 @@ static int airoha_dev_stop(struct net_device *dev)
 	if (err)
 		return err;
 
-	for (i = 0; i < ARRAY_SIZE(qdma->q_tx); i++)
+	for (i = 0; i < dev->num_tx_queues; i++)
 		netdev_tx_reset_subqueue(dev, i);
 
 	if (atomic_dec_and_test(&qdma->users)) {
@@ -2066,7 +2065,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 
 	spin_lock_bh(&q->lock);
 
-	txq = netdev_get_tx_queue(dev, qid);
+	txq = skb_get_tx_queue(dev, skb);
 	nr_frags = 1 + skb_shinfo(skb)->nr_frags;
 
 	if (q->queued + nr_frags >= q->ndesc) {
-- 
2.53.0



