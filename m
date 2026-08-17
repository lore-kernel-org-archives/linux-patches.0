Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECAB43E085;
	Mon, 17 Aug 2026 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974749; cv=none; b=jnY91ugMBVuQLv2Eg6PXCy2UnCB9x6blecEG/6dbpqzHg/p2M/TqwY76iXQUPRCWmGxu2bZpyDoVjzNd4IefLYHW6Ui8V1GWBqRr3F9Nqq8hm1vwUrEF5S2Q4SGcX7rkeTIN4FQUAXm7sks16FOplF8ffZVRx2GEpTg8mPSZN2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974749; c=relaxed/simple;
	bh=F7rirEv1Sl8VEj1tTq6LCGFHorjq/wCUGOqGTqleS+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPbU5bJ6tbr6d/85BQQzkOHSkgd56i+hnRFbBalvFwEqorI0s2s88pcFn/HW14jezMef5SOF7FmketPCHtBGIS0e0KTaymDZ3gSIfZLUq9nxRg75Rhg21rIiw+za4TKAkkYX8YJsxS3r5IgKklkGf4ZXmA7ngOGCt3jC6zE/QRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHwOpw3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHwOpw3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3FA1F000E9;
	Mon, 17 Aug 2026 13:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974741;
	bh=atX87GwpGXc+VTqnaJqCjM+g8qRELjDWXZOCgxt7WPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHwOpw3SZnRSI9X0hY47eIICX0B8lmEmp7yikFAUnOmJTEMgZepFRhzH2yqw+yyIb
	 buKC2GiNs1TcPadLV1gLUIFrNMvZbkTg7tX/NoRmS7C8bOJY0H0nSlb537XJ+v3kly
	 6K4DPlhHSi1fsusUcei/Blghl8UPEHl7ic9FeWm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/250] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp
Date: Mon, 17 Aug 2026 15:30:00 +0200
Message-ID: <20260817132538.053344886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 646922a0379496154e8c8faca4f8e2fd9100cacc ]

Sashiko warns that local attacker can modify the packet
while it is processed by IPVS. Some places read the
IP ihl field multiple times which can cause out-of-bounds
access. One such place is ip_vs_nat_icmp where we
can write after the validated area.

Fix it by providing ciph argument just like it is done for
IPv6 and use ciph->len as offset to the embedded transport
header.

Modify some IPv4 header checks by reading the ihl field
only once.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20260722101517.36313-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 67 +++++++++++++++++----------------
 net/netfilter/ipvs/ip_vs_xmit.c |  2 +-
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 17a97086b294f..cbad9c74a8868 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1720,7 +1720,7 @@ static inline char ip_vs_fwd_tag(struct ip_vs_conn *cp)
 
 void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int dir, unsigned int toff,
-		    bool has_ports);
+		    bool has_ports, struct ip_vs_iphdr *ciph);
 
 #ifdef CONFIG_IP_VS_IPV6
 void ip_vs_nat_icmp_v6(struct sk_buff *skb, struct ip_vs_protocol *pp,
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 6207a91e93f3b..586346110cd89 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -747,28 +747,27 @@ static int ip_vs_route_me_harder(struct netns_ipvs *ipvs, int af,
  */
 void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		    struct ip_vs_conn *cp, int inout, unsigned int toff,
-		    bool has_ports)
+		    bool has_ports, struct ip_vs_iphdr *ciph)
 {
 	struct iphdr *iph	 = ip_hdr(skb);
 	struct icmphdr *icmph	 = (struct icmphdr *)(skb->data + toff);
-	struct iphdr *ciph	 = (struct iphdr *)(icmph + 1);
-	unsigned int coff __maybe_unused = toff + sizeof(struct icmphdr);
+	struct iphdr *cih	 = (struct iphdr *)(icmph + 1);
 
 	if (inout) {
 		iph->saddr = cp->vaddr.ip;
 		ip_send_check(iph);
-		ciph->daddr = cp->vaddr.ip;
-		ip_send_check(ciph);
+		cih->daddr = cp->vaddr.ip;
+		ip_send_check(cih);
 	} else {
 		iph->daddr = cp->daddr.ip;
 		ip_send_check(iph);
-		ciph->saddr = cp->daddr.ip;
-		ip_send_check(ciph);
+		cih->saddr = cp->daddr.ip;
+		ip_send_check(cih);
 	}
 
 	/* the TCP/UDP/SCTP port */
 	if (has_ports) {
-		__be16 *ports = (void *)ciph + ciph->ihl*4;
+		__be16 *ports = (void *)(skb->data + ciph->len);
 
 		if (inout)
 			ports[1] = cp->vport;
@@ -782,10 +781,10 @@ void ip_vs_nat_icmp(struct sk_buff *skb, struct ip_vs_protocol *pp,
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	if (inout)
-		IP_VS_DBG_PKT(11, AF_INET, pp, skb, coff,
+		IP_VS_DBG_PKT(11, AF_INET, pp, skb, ciph->off,
 			      "Forwarding altered outgoing ICMP");
 	else
-		IP_VS_DBG_PKT(11, AF_INET, pp, skb, coff,
+		IP_VS_DBG_PKT(11, AF_INET, pp, skb, ciph->off,
 			      "Forwarding altered incoming ICMP");
 }
 
@@ -878,7 +877,7 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 		ip_vs_nat_icmp_v6(skb, pp, cp, 1, toff, has_ports, ciph);
 	else
 #endif
-		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports);
+		ip_vs_nat_icmp(skb, pp, cp, 1, toff, has_ports, ciph);
 
 	if (ip_vs_route_me_harder(cp->ipvs, af, skb, hooknum))
 		goto out;
@@ -914,7 +913,7 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	struct ip_vs_iphdr ciph;
 	struct ip_vs_conn *cp;
 	struct ip_vs_protocol *pp;
-	unsigned int offset, ihl;
+	unsigned int offset;
 	union nf_inet_addr snet;
 
 	*related = 1;
@@ -927,7 +926,6 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 			return NF_ACCEPT;
 	}
 
-	ihl = ipvsh->len;
 	offset = ipvsh->len;
 	ic = skb_header_pointer(skb, offset, sizeof(_icmph), &_icmph);
 	if (ic == NULL)
@@ -953,11 +951,15 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 
 	/* Now find the contained IP header */
 	offset += sizeof(_icmph);
+	if (!ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, true, &ciph))
+		return NF_ACCEPT; /* The packet looks wrong, ignore */
+
 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-	if (!(cih && cih->version == 4 && cih->ihl >= 5))
+	if (!(cih && cih->version == 4 &&
+	      ciph.len - ciph.off >= sizeof(struct iphdr)))
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
 
-	pp = ip_vs_proto_get(cih->protocol);
+	pp = ip_vs_proto_get(ciph.protocol);
 	if (!pp)
 		return NF_ACCEPT;
 
@@ -968,8 +970,6 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	IP_VS_DBG_PKT(11, AF_INET, pp, skb, offset,
 		      "Checking outgoing ICMP for");
 
-	ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, true, &ciph);
-
 	/* The embedded headers contain source and dest in reverse order */
 	cp = INDIRECT_CALL_1(pp->conn_out_get, ip_vs_conn_out_get_proto,
 			     ipvs, AF_INET, skb, &ciph);
@@ -977,8 +977,8 @@ static int ip_vs_out_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		return NF_ACCEPT;
 
 	snet.ip = ipvsh->saddr.ip;
-	return handle_response_icmp(AF_INET, skb, &snet, cp, pp, &ciph, ihl,
-				    hooknum);
+	return handle_response_icmp(AF_INET, skb, &snet, cp, pp, &ciph,
+				    ipvsh->len, hooknum);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -1625,10 +1625,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	/* Now find the contained IP header */
 	offset += sizeof(_icmph);
 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-	if (!(cih && cih->version == 4 && cih->ihl >= 5))
+	if (!cih)
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
-	raddr = (union nf_inet_addr *)&cih->daddr;
 	hlen_ipip = cih->ihl * 4;
+	if (!(cih->version == 4 && hlen_ipip >= sizeof(struct iphdr)))
+		return NF_ACCEPT; /* The packet looks wrong, ignore */
+	raddr = (union nf_inet_addr *)&cih->daddr;
 
 	/* Special case for errors for IPIP/UDP/GRE tunnel packets */
 	tunnel = false;
@@ -1645,9 +1647,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (!dest || dest->tun_type != IP_VS_CONN_F_TUNNEL_TYPE_IPIP)
 			return NF_ACCEPT;
 		offset += hlen_ipip;
-		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-		if (!(cih && cih->version == 4 && cih->ihl >= 5))
-			return NF_ACCEPT; /* The packet looks wrong, ignore */
 		tunnel = true;
 	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
 		    cih->protocol == IPPROTO_GRE) &&	/* Can be GRE encap */
@@ -1672,21 +1671,25 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 			/* Skip IP and UDP/GRE tunnel headers */
 			offset = offset2 + ulen;
 			/* Now we should be at the original IP header */
-			cih = skb_header_pointer(skb, offset, sizeof(_ciph),
-						 &_ciph);
-			if (cih && cih->version == 4 && cih->ihl >= 5 &&
-			    iproto == IPPROTO_IPIP)
+			if (iproto == IPPROTO_IPIP)
 				tunnel = true;
 			else
 				return NF_ACCEPT;
 		}
 	}
 
-	pd = ip_vs_proto_data_get(ipvs, cih->protocol);
+	if (!ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, !tunnel, &ciph))
+		return NF_ACCEPT;
+	pd = ip_vs_proto_data_get(ipvs, ciph.protocol);
 	if (!pd)
 		return NF_ACCEPT;
 	pp = pd->pp;
 
+	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
+	if (!(cih && cih->version == 4 &&
+	      ciph.len - ciph.off >= sizeof(struct iphdr)))
+		return NF_ACCEPT; /* The packet looks wrong, ignore */
+
 	/* Is the embedded protocol header present? */
 	if (unlikely(cih->frag_off & htons(IP_OFFSET) && !pp->dont_defrag))
 		return NF_ACCEPT;
@@ -1694,9 +1697,6 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	IP_VS_DBG_PKT(11, AF_INET, pp, skb, offset,
 		      "Checking incoming ICMP for");
 
-	offset2 = offset;
-	ip_vs_fill_iph_skb_icmp(AF_INET, skb, offset, !tunnel, &ciph);
-
 	/* The embedded headers contain source and dest in reverse order.
 	 * For IPIP/UDP/GRE tunnel this is error for request, not for reply.
 	 */
@@ -1726,11 +1726,12 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	}
 
 	if (tunnel) {
-		unsigned int hlen_orig = cih->ihl * 4;
+		unsigned int hlen_orig = ciph.len - ciph.off;
 		__be32 info = ic->un.gateway;
 		__u8 type = ic->type;
 		__u8 code = ic->code;
 
+		offset2 = offset;
 		/* Update the MTU */
 		if (ic->type == ICMP_DEST_UNREACH &&
 		    ic->code == ICMP_FRAG_NEEDED) {
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index ac1827ef78949..7db74b2ea358c 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1577,7 +1577,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	if (skb_cow(skb, rt->dst.dev->hard_header_len))
 		goto tx_error;
 
-	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports);
+	ip_vs_nat_icmp(skb, pp, cp, 0, toff, has_ports, ciph);
 
 	/* Another hack: avoid icmp_send in ip_fragment */
 	skb->ignore_df = 1;
-- 
2.53.0



