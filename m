Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C844CDDE1;
	Thu, 17 Sep 2026 16:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660981; cv=none; b=tNHgX6Pjqio5AraEnnR+rSJCU8nNVl7Z8dP0QsCpsRWMDZiSLaCp1PuNCONy/ITkNPXZdxnkn20LFgJeWl6k5J0d6ByK/vTttbUbllhd6qHzab25fOgEGsCId+sh9Cm0U1NBeFcN1wN2LgiTQ9QmGtEIdzUMHMRTkcak/gNGaOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660981; c=relaxed/simple;
	bh=/c+k7lmCjzOKFb8V/vTNoADN6+JfpEMZxM1+CG5kk6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snJGQYd+cNsIE14CWON4qWhU8Gtx6r/5y2eFpxV04D4ibl+xwwo3A//FlSb+QBHvbcRcDZPMwI4CGVOf3lWYQxSiMGt047vkDfS8Tz7ggOZvGJ6JOFDnTTHXquLnY/+le/+QtScPFenhgkQoj5jOaQc093WF5N9qb0Dckrdvu9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxxRplqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxxRplqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EA81F000FF;
	Thu, 17 Sep 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660980;
	bh=0fLM2nk8+M/ekIh2Z+ynEQTpACYaFi6A/ZVIoTbNPf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxxRplquj+gD+J3cVYYGkai9BCx7X1UKvWm6UYj82Cf/lCe/6Flwxg9DuI2FfCfJ/
	 BF3Q+HJWT2KhTFe5Mk/RvmS9gURw11WTWlAnwyVurWw6mGor2+o8kPqcAfFOMMN8PO
	 r68w6IqG3HLtpNHMWxd1HShfybfvCEmnFHxO4l5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0043/1250] bridge: Do not suppress ARP probes and DAD NS unconditionally
Date: Thu, 17 Sep 2026 15:57:18 +0100
Message-ID: <20260917151553.103669182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 7ace0f4941bb6..4cd3470e5f56c 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -165,7 +165,7 @@ void br_do_proxy_suppress_arp(struct sk_buff *skb, struct net_bridge *br,
 			return;
 		if (parp->ar_op != htons(ARPOP_RREQUEST) &&
 		    parp->ar_op != htons(ARPOP_RREPLY) &&
-		    (ipv4_is_zeronet(sip) || sip == tip)) {
+		    sip == tip) {
 			/* prevent flooding to neigh suppress ports */
 			BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 			return;
@@ -263,6 +263,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	int ns_olen;
 	int i, len;
 	u8 *daddr;
+	bool dad;
 	u16 pvid;
 
 	if (!dev || skb_linearize(request))
@@ -301,8 +302,13 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
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
@@ -318,7 +324,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	pip6->priority = ipv6_hdr(request)->priority;
 	pip6->nexthdr = IPPROTO_ICMPV6;
 	pip6->hop_limit = 255;
-	pip6->daddr = ipv6_hdr(request)->saddr;
+	pip6->daddr = dad ? in6addr_linklocal_allnodes : ipv6_hdr(request)->saddr;
 	pip6->saddr = *(struct in6_addr *)n->primary_key;
 
 	skb_pull(reply, sizeof(struct ipv6hdr));
@@ -331,7 +337,7 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	na->icmph.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT;
 	na->icmph.icmp6_router = (n->flags & NTF_ROUTER) ? 1 : 0;
 	na->icmph.icmp6_override = 1;
-	na->icmph.icmp6_solicited = 1;
+	na->icmph.icmp6_solicited = dad ? 0 : 1;
 	na->target = ns->target;
 	ether_addr_copy(&na->opt[2], n->ha);
 	na->opt[0] = ND_OPT_TARGET_LL_ADDR;
@@ -436,7 +442,7 @@ void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
 	saddr = &iphdr->saddr;
 	daddr = &iphdr->daddr;
 
-	if (ipv6_addr_any(saddr) || !ipv6_addr_cmp(saddr, daddr)) {
+	if (!ipv6_addr_cmp(saddr, daddr)) {
 		/* prevent flooding to neigh suppress ports */
 		BR_INPUT_SKB_CB(skb)->proxyarp_replied = 1;
 		return;
-- 
2.53.0



