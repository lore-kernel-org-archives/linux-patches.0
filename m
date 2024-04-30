Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB7E12C47A;
	Tue, 30 Apr 2024 11:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476289; cv=none; b=QbHDAMuBlD8SdxtlrJyFvTT1Tg7IGP0i1d4DXi7ydPCIun7H3TD4JUuv55D8TjXgk1WDjSw/VU4EVXsJzOSAupgF/4u6ZrXwc29Ze6bsPx0KfxJxWMsprUNkcVsEzhH9Nf4Bz+XcQWhfLTo9jWt6aAVaKZEOcCGzO7jTU6Cd7tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476289; c=relaxed/simple;
	bh=5u5amtbsZmtUSotF/5X8qlmYceNx23czu+Wlvf86g/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwC0Oojisv4YBwjBEK9bVNX01is35GCyfb0ADAaL+rn886ISSqtQdbifmBBOjehdCMdXQ10QuiGMJRuc/SBY7PHrKfIc15vG9967sMHiekau+darlEUwd3XtlqTg3a91MmcyWrNiVUWccRM2qLo/9MEtXdfKxxNieyt/PwjvMuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Py6zVVzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Py6zVVzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFF4C2BBFC;
	Tue, 30 Apr 2024 11:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476288;
	bh=5u5amtbsZmtUSotF/5X8qlmYceNx23czu+Wlvf86g/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Py6zVVzXphTZuCoH6AWKvR6kCDVnBTsQ1LRZw5bKdILcVJrR8W+rySI6wSz9WN+Og
	 XYdEKJKf0RFhC6RHXhduVWJ86hFBM4mxd3BXI1lDlywcfulgm60H2/mkE5fUI6c+Cu
	 hTYbFhbPnaV2cfs/heIYa8OxSwBXy3gEO+8ofgCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 094/107] ethernet: Add helper for assigning packet type when dest address does not match device address
Date: Tue, 30 Apr 2024 12:40:54 +0200
Message-ID: <20240430103047.432051153@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

commit 6e159fd653d7ebf6290358e0330a0cb8a75cf73b upstream.

Enable reuse of logic in eth_type_trans for determining packet type.

Suggested-by: Sabrina Dubroca <sd@queasysnail.net>
Cc: stable@vger.kernel.org
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20240423181319.115860-3-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/etherdevice.h |   25 +++++++++++++++++++++++++
 net/ethernet/eth.c          |   12 +-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -532,6 +532,31 @@ static inline unsigned long compare_ethe
 }
 
 /**
+ * eth_skb_pkt_type - Assign packet type if destination address does not match
+ * @skb: Assigned a packet type if address does not match @dev address
+ * @dev: Network device used to compare packet address against
+ *
+ * If the destination MAC address of the packet does not match the network
+ * device address, assign an appropriate packet type.
+ */
+static inline void eth_skb_pkt_type(struct sk_buff *skb,
+				    const struct net_device *dev)
+{
+	const struct ethhdr *eth = eth_hdr(skb);
+
+	if (unlikely(!ether_addr_equal_64bits(eth->h_dest, dev->dev_addr))) {
+		if (unlikely(is_multicast_ether_addr_64bits(eth->h_dest))) {
+			if (ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
+				skb->pkt_type = PACKET_BROADCAST;
+			else
+				skb->pkt_type = PACKET_MULTICAST;
+		} else {
+			skb->pkt_type = PACKET_OTHERHOST;
+		}
+	}
+}
+
+/**
  * eth_skb_pad - Pad buffer to mininum number of octets for Ethernet frame
  * @skb: Buffer to pad
  *
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -164,17 +164,7 @@ __be16 eth_type_trans(struct sk_buff *sk
 	eth = (struct ethhdr *)skb->data;
 	skb_pull_inline(skb, ETH_HLEN);
 
-	if (unlikely(!ether_addr_equal_64bits(eth->h_dest,
-					      dev->dev_addr))) {
-		if (unlikely(is_multicast_ether_addr_64bits(eth->h_dest))) {
-			if (ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
-				skb->pkt_type = PACKET_BROADCAST;
-			else
-				skb->pkt_type = PACKET_MULTICAST;
-		} else {
-			skb->pkt_type = PACKET_OTHERHOST;
-		}
-	}
+	eth_skb_pkt_type(skb, dev);
 
 	/*
 	 * Some variants of DSA tagging don't have an ethertype field


