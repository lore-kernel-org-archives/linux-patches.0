Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2EF8801;
	Tue, 30 Apr 2024 11:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475610; cv=none; b=BUlS5sI1vw360iGu4g7P0yThOkRb8Ijpp1wsT+peOWyTforOVJNzw8lmJsXJBFri04/8/ng4bGDjnOg9Qd/8dShRJy41U6/DQTYkOTcmQBujrLS3rdqR/HhOWRU9bdZ9xkwBheZ4bAMho3GNX5KKnkDdLcZvIdcM6A5pp/iuXVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475610; c=relaxed/simple;
	bh=+cGhsZNLBaGvAYeTP7Ou1qNpOdyLBjh12Z4lZzq9YUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUYFUq0gemiVFkP/MtW5RNWXQGNSwdVYVj7IRiaa0//TA1rPel7Bsv65PAhMOCkYLKzAzPUKOGQiZnyQxr+RZsO4KdyfydCPCSOT4oPY4OANZYZ/Nyjmc1WuGa7mtEyDNDdx5bisU4WNb52wFWOIrctaZbmr621lV78/4iawtao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VD6OvBKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VD6OvBKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF4CC2BBFC;
	Tue, 30 Apr 2024 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475610;
	bh=+cGhsZNLBaGvAYeTP7Ou1qNpOdyLBjh12Z4lZzq9YUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VD6OvBKvPoNM0Ux3COHhet7DHdAR9ezP71FI8PfZ54A9NErk1Gxq5ZD1HCs/G4P/H
	 hPsPqS9ZGiUdwsztV5RoBctgAHRixuUUgpVUb/DitL7l1uB6LeMs2uqbLPUeAbWOY1
	 F1FWWCmm9QcL03E2rwZZHekXUa9iDr8IkeFd9hRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 148/186] ethernet: Add helper for assigning packet type when dest address does not match device address
Date: Tue, 30 Apr 2024 12:40:00 +0200
Message-ID: <20240430103102.330279041@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -608,6 +608,31 @@ static inline void eth_hw_addr_gen(struc
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


