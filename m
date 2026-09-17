Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B674848BF;
	Thu, 17 Sep 2026 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670864; cv=none; b=EH222Hm0M9OkSIg4pHjez6g2evqvHpIKuaU3Gq1k006eFmPnIvu9280KJJEpvxpqHeNJqT5pnRU1jmppiuyVtNB+84QWgEgNgc8V/fx9JMUBZplH/RDohl3iRWMWPW7LmGUWApT7T4yuUtXB+OZT5VNywiTLq13xgIkuPrMmVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670864; c=relaxed/simple;
	bh=3LNM2kA+BpmVWITw/Au4VbN1BT0jLBoa8idCxui3dmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQI+6NLBmcY1yUFizNydKNdcXmX95/3XqTcqSu+blz0wziqYXI3I3Z0TQ8HoZYdqo3KS0EDdmDHXf1ge0it/gfLPctsjpteamBy6hHbWy6AY27AtbksERb/4wL73GTtksRQ+lhpN/b8jgCO9fJ6wu8DCO+zKOzY4GvnHd3VViUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH3EM1/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH3EM1/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FAD1F00898;
	Thu, 17 Sep 2026 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670863;
	bh=1zBRq7KcYlE4YY9xyTYvgHKk9WRyjUYdHlU7dTPmLRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vH3EM1/RNQgMlASJGsUL/jkLWUKfJizIWPv1eLzjwQEOMNTwNbG4j/Ofe4+9Tb0Ju
	 Up7U9aehISuTzFhxgQrRVktxLILQAq/NruCgI80fQEFOG0PvRp+aWxcK+p1NW5MrRm
	 iDRu4qXKNVK1J5RCelcsJuF5bn/kTlpxDViJniFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0793/1102] net: stmmac: add stmmac_tso_header_size()
Date: Thu, 17 Sep 2026 16:12:16 +0100
Message-ID: <20260917151600.379961937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit f799b5dab9c98a4b52a93d1c357916e0f0b7e663 ]

We will need to compute the size of the protocol headers in two places,
so move this into a separate function.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1w7ptJ-0000000Eat5-2ZlA@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5e38d732ec67 ("net: stmmac: fix TX descriptor availability check for TSO traffic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 ++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 548e2be390d23..409d36c1960c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4151,6 +4151,18 @@ static void stmmac_flush_tx_descriptors(struct stmmac_priv *priv, int queue)
 	stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr, queue);
 }
 
+static size_t stmmac_tso_header_size(struct sk_buff *skb)
+{
+	size_t size;
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		size = skb_transport_offset(skb) + sizeof(struct udphdr);
+	else
+		size = skb_tcp_all_headers(skb);
+
+	return size;
+}
+
 /**
  *  stmmac_tso_xmit - Tx entry point of the driver for oversized frames (TSO)
  *  @skb : the socket buffer
@@ -4222,13 +4234,11 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	first_tx = tx_q->cur_tx;
 
 	/* Compute header lengths */
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
-		proto_hdr_len = skb_transport_offset(skb) + sizeof(struct udphdr);
+	proto_hdr_len = stmmac_tso_header_size(skb);
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 		hdr = sizeof(struct udphdr);
-	} else {
-		proto_hdr_len = skb_tcp_all_headers(skb);
+	else
 		hdr = tcp_hdrlen(skb);
-	}
 
 	/* Desc availability based on threshold should be enough safe */
 	if (unlikely(stmmac_tx_avail(priv, queue) <
-- 
2.53.0



