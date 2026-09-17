Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8CC4FD265;
	Thu, 17 Sep 2026 17:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667243; cv=none; b=SHdsRJkVyBzVQteozJIRz9SwYe2BxQXEdyBIVT2kIVNLj7jH/jsYRlYqps9dO0HDL9DyKFkpxo78DE1SyPt4eYcREwaIuBqxeh2J3Gq+pT2lPglaOI871gIeKfJRWWlJw7BuNpd31VLHlC0aJBNiOxVb6GdqjaVOsCPrwn0yir4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667243; c=relaxed/simple;
	bh=ngFbR6iOwSapSneTH4M0phcxDP+nhLZ0NIRnGPxClpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cP7vaNJ+zTh06SOvlaDPxyQd1wnG1yuIabXeYRzOtO5ffAvjlg66o6Ms6OT8ZmtM1Pbp3Kd7Y1bCxNUdAUqA2HZ7/Q4pD8lPOzuW0tp0PpKjVo7NwqYURoNtsx3JGbwWVOJmMb1aQFv+6HVOPpJTAFlsn6UJVbT4PsDOwkqu768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7kqImw3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7kqImw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44631F000FF;
	Thu, 17 Sep 2026 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667241;
	bh=pQXdN6azuLdZQ8iCuOJid4kOHH3CmSaQ9g+cyaswsUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7kqImw3MI1iR8thMQbUMIxr9hEymWY6m1G/yeBcfytLA/CrwGT+he9cXH5i9L7vO
	 5pyf/ptOrTlkHtIbXCvylT6pX7oaAZvMw5JnMiN3plXZEzRONGVRp0Cuu4bcFeYwv0
	 sEiovdsliXbTEL8ZAUtABi8xJI37otoX9QDjFjyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0027/1102] bridge: Do not suppress ARP probes and DAD NS unconditionally
Date: Thu, 17 Sep 2026 15:59:30 +0100
Message-ID: <20260917151540.117861448@linuxfoundation.org>
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

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit fee1fc1d5a5475f5516d406a03e443348cd0f06c ]

When neighbor suppression is enabled on a VXLAN port, the bridge is
expected to reply to ARP/NS messages on behalf of remote hosts when both
FDB and neighbor entries exist. This allows the bridge to suppress
flooding of these messages to the VXLAN overlay.

According to RFC 9161 ("Operational Aspects of Proxy ARP/ND in Ethernet
Virtual Private Networks"):
"A PE SHOULD reply to broadcast/multicast address resolution messages,
i.e., ARP Requests, ARP probes, NS messages, as well as DAD NS messages.
An ARP probe is an ARP Request constructed with an all-zero sender IP
address that may be used by hosts for IPv4 Address Conflict Detection as
specified in [RFC5227]".

However, the current implementation unconditionally suppresses ARP probes
and DAD Neighbor Solicitations, which breaks Duplicate Address Detection
(DAD) over EVPN.

For DAD to work correctly over the VXLAN fabric:
- When the bridge does not know the answer:
  flood the probe/DAD packet to allow remote VTEPs to respond.
- When the bridge knows the answer:
  reply to indicate the address is in use.

Fix by adjusting the early suppression checks to exclude ARP probes and
DAD NS from unconditional suppression.

When replying to a DAD NS, br_nd_send() is adjusted to set the NA
destination to the all-nodes multicast address (ff02::1) and clear the
Solicited flag, in accordance with RFC 4861 section 7.2.4.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260429062405.1386417-2-danieller@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_arp_nd_proxy.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index 985aaf7ff1564..f2d6643d2c0a1 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -162,7 +162,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 			return;
 		if (parp->ar_op != htons(ARPOP_RREQUEST) &&
 		    parp->ar_op != htons(ARPOP_RREPLY) &&
-		    (ipv4_is_zeronet(sip) || sip == tip)) {
+		    sip == tip) {
 			/* prevent flooding to neigh suppress ports */
 			BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 			return;
@@ -260,6 +260,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	int ns_olen;
 	int i, len;
 	u8 *daddr;
+	bool dad;
 	u16 pvid;
 
 	if (!dev || skb_linearize(request))
@@ -298,8 +299,13 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 		}
 	}
 
+	dad = ipv6_addr_any(&ipv6_hdr(request)->saddr);
+
 	/* Ethernet header */
-	ether_addr_copy(eth_hdr(reply)->h_dest, daddr);
+	if (dad)
+		ipv6_eth_mc_map(&in6addr_linklocal_allnodes, eth_hdr(reply)->h_dest);
+	else
+		ether_addr_copy(eth_hdr(reply)->h_dest, daddr);
 	ether_addr_copy(eth_hdr(reply)->h_source, n->ha);
 	eth_hdr(reply)->h_proto = htons(ETH_P_IPV6);
 	reply->protocol = htons(ETH_P_IPV6);
@@ -315,7 +321,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	pip6->priority = ipv6_hdr(request)->priority;
 	pip6->nexthdr = IPPROTO_ICMPV6;
 	pip6->hop_limit = 255;
-	pip6->daddr = ipv6_hdr(request)->saddr;
+	pip6->daddr = dad ? in6addr_linklocal_allnodes : ipv6_hdr(request)->saddr;
 	pip6->saddr = *(struct in6_addr *)n->primary_key;
 
 	skb_pull(reply, sizeof(struct ipv6hdr));
@@ -328,7 +334,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	na->icmph.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT;
 	na->icmph.icmp6_router = (n->flags & NTF_ROUTER) ? 1 : 0;
 	na->icmph.icmp6_override = 1;
-	na->icmph.icmp6_solicited = 1;
+	na->icmph.icmp6_solicited = dad ? 0 : 1;
 	na->target = ns->target;
 	ether_addr_copy(&na->opt[2], n->ha);
 	na->opt[0] = ND_OPT_TARGET_LL_ADDR;
@@ -429,7 +435,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 	saddr = &iphdr->saddr;
 	daddr = &iphdr->daddr;
 
-	if (ipv6_addr_any(saddr) || !ipv6_addr_cmp(saddr, daddr)) {
+	if (!ipv6_addr_cmp(saddr, daddr)) {
 		/* prevent flooding to neigh suppress ports */
 		BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		return;
-- 
2.53.0



