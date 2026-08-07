Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD553331A61;
	Fri,  7 Aug 2026 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115356; cv=none; b=FPxL6m1ZTvaUN6ySNtfUjoxF6l+GgZ5iyfiwcLeSofZuAlwFyrC2tUuSEoKneAQ1U0tZBdMIuLYTw4Q6nshxUDyaZrQ5gW7Lt0TFMKSLUdf2Ff/HDez7B3lRAqRA5/u5m4ofWlqvI8Fg5+VRaWbUm6dDbEftUuNqb/IvAvkDrEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115356; c=relaxed/simple;
	bh=LEJv/ZOov8DSfZPRPWHImHqYJakUbJ/7lbFOfyMHAHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+jeQ7byfVD8e9jgu22ygO2Yw7mRjjg6jQNE6MPyRIBLQgzkHmpTScejc4JSw0SS7c/91xCIB2p6qzdtwhXE4sZoQi3T2JeLZ4pQpF1apUEFOMxPJXSTTgw7gDqK/aTIXO0ioTr/91WEfW9Hy6u+JLKSp/AJjAsdZkcvCEWnfPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmbwoKJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmbwoKJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192C91F000E9;
	Fri,  7 Aug 2026 15:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115354;
	bh=iTAympczlzV2qKgNiml6pKhG873nfMrCAugr5/iMe0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmbwoKJlzWAxHc0Sd5ZHveeZwJN+aTnn1ClFAHvt1w4kWnXtEeetJ6QlabDCpueb1
	 Duu7BqQeVpMQDJn8XdpYu6i5vnWMhzdMkW8vdsMEse5gn37SlqWz2ySjlkZ08Vsm+e
	 a6vn4Zj3VzmCZjMvdThrr4y/IOlGTIlMztsHv3x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 248/396] vxlan: use pskb_network_may_pull() for transmit path header pulls
Date: Fri,  7 Aug 2026 16:36:48 +0200
Message-ID: <20260807143429.600491800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit b9553558b48db54ac9273e6b98d7263ef5c1a329 upstream.

In vxlan_xmit(), arp_reduce(), and vxlan_mdb_entry_skb_get(), pskb_may_pull() was
being called to verify the availability of network layer headers (ARP, IPv6/ND,
IP/IPv6 MDB keys).

However, during transmit skb->data points to the MAC header, so skb_network_offset(skb)
is ETH_HLEN (14 bytes). Using pskb_may_pull(skb, len) only checks len bytes from skb->data
rather than skb_network_offset(skb) + len, which can leave part of the network header
in non-linear frags.

Replace these remaining pskb_may_pull() calls with pskb_network_may_pull() to properly
account for the MAC header offset.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Fixes: f564f45c4518 ("vxlan: add ipv6 proxy support")
Fixes: 0f83e69f44bf ("vxlan: Add MDB data path support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260723144249.759100-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 +++---
 drivers/net/vxlan/vxlan_mdb.c  |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1852,7 +1852,7 @@ static int arp_reduce(struct net_device
 	if (dev->flags & IFF_NOARP)
 		goto out;
 
-	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
+	if (!pskb_network_may_pull(skb, arp_hdr_len(dev))) {
 		dev_dstats_tx_dropped(dev);
 		vxlan_vnifilter_count(vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_TX_DROPS, 0);
@@ -2765,8 +2765,8 @@ static netdev_tx_t vxlan_xmit(struct sk_
 			return arp_reduce(dev, skb, vni);
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (ntohs(eth->h_proto) == ETH_P_IPV6 &&
-			 pskb_may_pull(skb, sizeof(struct ipv6hdr) +
-					    sizeof(struct nd_msg)) &&
+			 pskb_network_may_pull(skb, sizeof(struct ipv6hdr) +
+						    sizeof(struct nd_msg)) &&
 			 ipv6_hdr(skb)->nexthdr == IPPROTO_ICMPV6) {
 			struct nd_msg *m = (struct nd_msg *)(ipv6_hdr(skb) + 1);
 
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1631,7 +1631,7 @@ struct vxlan_mdb_entry *vxlan_mdb_entry_
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return NULL;
 		group.dst.sa.sa_family = AF_INET;
 		group.dst.sin.sin_addr.s_addr = ip_hdr(skb)->daddr;
@@ -1640,7 +1640,7 @@ struct vxlan_mdb_entry *vxlan_mdb_entry_
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return NULL;
 		group.dst.sa.sa_family = AF_INET6;
 		group.dst.sin6.sin6_addr = ipv6_hdr(skb)->daddr;


