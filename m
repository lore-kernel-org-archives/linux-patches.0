Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E5E358D27;
	Thu, 17 Sep 2026 15:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659977; cv=none; b=ofeq+JtuxvVu/3eIs9Ai5qHv+5POooRnGEubqPX+VZQeYqu+rpBqXCk3pJsKA9jInk8MejD2LjcUuxxH0yJP0ANBgLKkY+GBs2e7iPYDp8ivVSqOH2JPAuGUiRcYZGarbMB/JDE3BsvwiPE37NsIuYCDNnEGbq3L+QTfDTHkFbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659977; c=relaxed/simple;
	bh=HhKDSDN1hciGQulWiDED/J/Ez5ke7vnu85dw61RgKGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5M7Fb3ficXwWETl0fqDXJ2ZXIFEk9w7wh4f15sZney2aoQWfm4JIWUWMXbjcwG8SHnUAb8fbnjxJ5HPeZ5RiQV//CFZE9YUzx5peB1Cfrb9VdLe1NHUyjevD1D/KuPRPqENZ+GYvgdfPNqU+/Y9fP6Oy4mq+qiqAOPkhG5bhls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN+cF0lq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN+cF0lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD351F00898;
	Thu, 17 Sep 2026 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659970;
	bh=FEDUqaHh+TqeLSfH7tciKxdc7SVxygbgyRbhgXf5Xag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FN+cF0lqZn0by8r224x7aXwOSaZWxH+8ft+Dkd+QMWdz7D5540o2CSxGKL6tZ2A+4
	 oKEYGZQsdwKCMy4u/nfdKxrKBZasmFVyxrTe/oH/xO2TjvRm+mfyXZQHSl/DnuBll/
	 Bd7zf9me0i+cUMpMG3zIEGL8qtIRp0twD0mEwLcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 435/733] net: stmmac: fix TX descriptor availability check for TSO traffic
Date: Thu, 17 Sep 2026 16:12:23 +0100
Message-ID: <20260917151402.688698640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index aa05160c22e35..f801caf65fff1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4454,6 +4454,26 @@ static bool stmmac_tso_valid_packet(struct sk_buff *skb)
 	       header_len + gso_size < 16383;
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
@@ -4497,10 +4517,10 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	unsigned int first_entry, entry, tx_packets;
 	struct stmmac_txq_stats *txq_stats;
+	int i, first_tx, nfrags, ndesc;
 	struct stmmac_tx_queue *tx_q;
 	bool set_ic, is_last_segment;
 	u32 pay_len, mss, queue;
-	int i, first_tx, nfrags;
 	u8 proto_hdr_len, hdr;
 	dma_addr_t des;
 
@@ -4513,14 +4533,15 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* Compute header lengths */
 	proto_hdr_len = stmmac_tso_header_size(skb);
+	pay_len = skb_headlen(skb) - proto_hdr_len; /* no frags */
+
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 		hdr = sizeof(struct udphdr);
 	else
 		hdr = tcp_hdrlen(skb);
 
-	/* Desc availability based on threshold should be enough safe */
-	if (unlikely(stmmac_tx_avail(priv, queue) <
-		(((skb->len - proto_hdr_len) / TSO_MAX_BUFF_SIZE + 1)))) {
+	ndesc = stmmac_tso_get_num_desc(tx_q, skb, pay_len);
+	if (unlikely(stmmac_tx_avail(priv, queue) < ndesc)) {
 		if (!netif_tx_queue_stopped(netdev_get_tx_queue(dev, queue))) {
 			netif_tx_stop_queue(netdev_get_tx_queue(priv->dev,
 								queue));
@@ -4532,8 +4553,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
-	pay_len = skb_headlen(skb) - proto_hdr_len; /* no frags */
-
 	mss = skb_shinfo(skb)->gso_size;
 
 	/* set new MSS value if needed */
-- 
2.53.0



