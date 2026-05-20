Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5923E95A4;
	Wed, 20 May 2026 18:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300217; cv=none; b=Xr9zGP7KAEgzWPNDtQnyhlyCMz+nDTrhIe2WNA1GnwplAhWPGRngDeT9QbtYVx3pTYPrcspwtmOn/+QadFvhvtjyE6TPabCajOnC4P7BYNRI6cyW3fTIat+AtnZgAw/4hcOThEWb9PKBdzszuLKpoYveibVApCdk0eMK7ukMVcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300217; c=relaxed/simple;
	bh=i6cbsgP9ED9xxD+HrfMXY+A3gQOenJk7fmIgoLuT9DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O63JyPk/i+L/q/yFTzjpqC7H0/MOYnQJ1e+oELLsYqcOXwxIE72pOUgFFQqD/bBv6If1N68ILIIZly1ESY76cFAlbLrCiIO23qfIpGkfPZpRr4z3IWU06eVuJFyQPfs/bu/+PD0BoOILKEN9+g4vyQCHALz9kRf+yUBdJLYDZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpy9vvAF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpy9vvAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249BB1F000E9;
	Wed, 20 May 2026 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300216;
	bh=msYA/8Y6P40jvZ3+BUXjGFvu1C/YBuIndcGc3o38pgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpy9vvAF/RoFSZXyDAW8seDSC3YEcwvFP6ty6cqws5WNZzDu/miYZwfOSL0RxqG6t
	 ltWsxB0q60CWxlsbrPYu2BTH7sf66wPB8C8ymJj1JZMOsDjHtZQFyoLD5IUinPk75U
	 sYKo4iQa+iCmq5mg3qeDFuLVHQCviwmnxW9cixh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/666] net: airoha: Implement BQL support
Date: Wed, 20 May 2026 18:15:03 +0200
Message-ID: <20260520162113.219625243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

[ Upstream commit 1d304174106c93ce05f6088813ad7203b3eb381a ]

Introduce BQL support in the airoha_eth driver reporting to the kernel
info about tx hw DMA queues in order to avoid bufferbloat and keep the
latency small.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20241012-en7581-bql-v2-1-4deb4efdb60b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 656121b15503 ("net: airoha: Add missing RX_CPU_IDX() configuration in airoha_qdma_cleanup_rx_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 7a85550e5ecb3..268d3050c0178 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -1729,9 +1729,11 @@ static int airoha_qdma_tx_napi_poll(struct napi_struct *napi, int budget)
 			WRITE_ONCE(desc->msg1, 0);
 
 			if (skb) {
+				u16 queue = skb_get_queue_mapping(skb);
 				struct netdev_queue *txq;
 
-				txq = netdev_get_tx_queue(skb->dev, qid);
+				txq = netdev_get_tx_queue(skb->dev, queue);
+				netdev_tx_completed_queue(txq, 1, skb->len);
 				if (netif_tx_queue_stopped(txq) &&
 				    q->ndesc - q->queued >= q->free_thr)
 					netif_tx_wake_queue(txq);
@@ -2510,7 +2512,9 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	q->queued += i;
 
 	skb_tx_timestamp(skb);
-	if (!netdev_xmit_more())
+	netdev_tx_sent_queue(txq, skb->len);
+
+	if (netif_xmit_stopped(txq) || !netdev_xmit_more())
 		airoha_qdma_rmw(qdma, REG_TX_CPU_IDX(qid),
 				TX_RING_CPU_IDX_MASK,
 				FIELD_PREP(TX_RING_CPU_IDX_MASK, q->head));
-- 
2.53.0



