Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCD63909BC;
	Sat, 17 Oct 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260636; cv=none; b=R0n0e4tCmEvx9lb8eRvLjlHfZmTwqkFB174U2MjjEU3AxS8h4bwt8Wb6paS9OLphPTnFRudfiEF1hvxgzZ38hqmOUG3y8L7DRbzF2k3U2aNLCjv0Ko3O+nUfGHLh//0isITp3HCaVfl4sqCr6KID+I/OxXHj5qid1hZojPeCYeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260636; c=relaxed/simple;
	bh=ORayCIrbUpaz3ii28t+a30QacfPC4Ak7CoWrv6o9k0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWSlAJtpca9dlSyTYf6wjmVNvETH4CQK16vg/nR3cOEcGjAKchx5OEVLk1paIjoT6HE0Uc0evKY/B8HIxQEJy2PG3o7/I4d+0ih6/ISN5wLaU7l5acYDJCtKwtB8oGIoB+nygqrju0PEi2D7BD102r/O1Ky+2aC+Ms8cpjOS/dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUGZIXqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUGZIXqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7BE1F000C4;
	Sat, 17 Oct 2026 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260635;
	bh=eD4UcxaLJbFwNa37mSCLpQ2KWf41p7syTZc1wDKG8XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUGZIXqc3IsBdvSweHy6HqYdgZALMYc+EzXZ3V63abdnsqqrp9rsY7ZgSIU7WBKwf
	 E96C8SRMsR8qNqwS0utF/snC7x9fUMudMMQM1UqUQuM28O/hTwH9kOHIWe/LkEENO4
	 ZpR64/yhG2ZT7ByQTDjQhHZ54boEeP7KRPn8Iwfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1610/1674] net: stmmac: fix TX descriptor availability check for TSO traffic
Date: Sat, 17 Oct 2026 18:04:42 +0200
Message-ID: <20261017160512.411752388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 5e38d732ec67a5b1f9a56e6c73add480c4b6030a ]

stmmac_tso_xmit() estimates the number of free TX descriptors required by
a TSO skb as:

	(skb->len - proto_hdr_len) / TSO_MAX_BUFF_SIZE + 1

which assumes the payload is split into TSO_MAX_BUFF_SIZE chunks. This
underestimates the descriptors actually consumed by stmmac_tso_allocator(),
since each fragment is mapped individually and so it needs at least one
descriptor regardless of its size. Moreover, one descriptor is used for
the L2/L3/L4 headers and, when the MSS changes, one more is consumed for
the MSS context descriptor.
For a highly fragmented TSO skb the check can therefore pass even when the
ring has too few free slots. stmmac_tso_allocator() then writes past the
available descriptors, overwriting descriptors still owned by the DMA
engine, corrupting the TX ring.
Add stmmac_tso_get_num_desc() to compute the exact number of descriptors
needed for the header, the linear payload and each fragment, plus the MSS
context descriptor when required, and use it in the availability check.

Fixes: f748be531d70 ("stmmac: support new GMAC4")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260907-stmmac-fix-tso-nfrags-check-v1-1-328459906cdb@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 31 +++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 96d97b209af9c..6f7a2fec7f133 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4040,6 +4040,26 @@ static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue)
 	stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr, queue);
 }
 
+static int stmmac_tso_get_num_desc(struct stmmac_tx_queue *tx_q,
+				   struct sk_buff *skb, u32 pay_len)
+{
+	int i, ndesc = 1;
+
+	/* head payload */
+	ndesc += DIV_ROUND_UP(pay_len, TSO_MAX_BUFF_SIZE);
+	/* frag payload */
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+
+		ndesc += DIV_ROUND_UP(skb_frag_size(frag),
+				      TSO_MAX_BUFF_SIZE);
+	}
+	/* MSS update requires a new descriptor */
+	ndesc += !!(skb_shinfo(skb)->gso_size != tx_q->mss);
+
+	return ndesc;
+}
+
 /**
  *  stmmac_tso_xmit - Tx entry point of the driver for oversized frames (TSO)
  *  @skb : the socket buffer
@@ -4075,7 +4095,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	u32 queue = skb_get_queue_mapping(skb);
 	unsigned int first_entry, tx_packets;
 	struct stmmac_txq_stats *txq_stats;
-	int tmp_pay_len = 0, first_tx;
+	int tmp_pay_len = 0, first_tx, ndesc;
 	struct stmmac_tx_queue *tx_q;
 	bool has_vlan, set_ic;
 	dma_addr_t tso_des, des;
@@ -4096,9 +4116,10 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		hdr = tcp_hdrlen(skb);
 	}
 
-	/* Desc availability based on threshold should be enough safe */
-	if (unlikely(stmmac_tx_avail(priv, queue) <
-		(((skb->len - proto_hdr_len) / TSO_MAX_BUFF_SIZE + 1)))) {
+	pay_len = skb_headlen(skb) - proto_hdr_len; /* no frags */
+
+	ndesc = stmmac_tso_get_num_desc(tx_q, skb, pay_len);
+	if (unlikely(stmmac_tx_avail(priv, queue) < ndesc)) {
 		if (!netif_tx_queue_stopped(netdev_get_tx_queue(dev, queue))) {
 			netif_tx_stop_queue(netdev_get_tx_queue(priv->dev,
 								queue));
@@ -4110,8 +4131,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
-	pay_len = skb_headlen(skb) - proto_hdr_len; /* no frags */
-
 	mss = skb_shinfo(skb)->gso_size;
 
 	/* set new MSS value if needed */
-- 
2.53.0



