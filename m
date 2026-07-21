Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4799A3C10AB;
	Tue, 21 Jul 2026 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674127; cv=none; b=gUv6V0BfItojYcQ/9UYlXVJfh0bXrqc72zC60AJPitQR05dAtKgVcSxUlExnfB4mAbxstVFQ+ERakZ1j6Z/tP8UesithwRxoi0Q0RebTDAeTfk1u/WaSSsFC0FfDlQUxKwxbwfd3fWXfkcmVIvj3elmx1UOx2ZTldEFmRUvkOE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674127; c=relaxed/simple;
	bh=7TK37+u3hQSw3jyZDhnzQTAszzPgPQMlTamutjyHrEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYe5R+RZpiVdcwbRDBCdZuCJcC1IEnMyzn6lMYJHtwXXigc5AEjBm6JPKMRktEbQ1Bnr2AB4LlVO+9ZTEj/Eg/NOounRDjimWZLiux5S4XDbSvRV8tAmrYeRgda7LEBCyvMCEkSOO++NT74b8TAJ36uGsTQ4r8b05S63Dorpf78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNL0khre; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNL0khre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A011F000E9;
	Tue, 21 Jul 2026 22:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674125;
	bh=2l9tZNVlQ+5CISuJJEB8JH4lGkp1IQgtCzXwswo3OkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNL0khreDip9ACCbZ5VPckewBtqrWEMnqOo706AvvrNPfPZJaOCoHZL0Y/L3RFOeO
	 B1eAnreVJuJp5NCQqKdYbu3oJ/h9QiQxke2Rni4bGXE24fCVSXOwg3Lqewz8icffuE
	 Kjzm2VqlP/5n9uLwpTtAh2zXsQpL6iz8P6hFvC2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/699] ipvs: ensure inner headers in ICMP errors are in headroom
Date: Tue, 21 Jul 2026 17:23:02 +0200
Message-ID: <20260721152405.234543062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 3f7a535ff0fa627a0132803e4c2f903ceffcbc1c ]

Sashiko points out that after stripping the outer headers
with pskb_pull() we should ensure the inner IP headers
in ICMP errors from tunnels are present in the skb headroom
for functions like ipv4_update_pmtu(), icmp_send() and
IP_VS_DBG().

Also, add more checks for the length of the inner headers.

Fixes: f2edb9f7706d ("ipvs: implement passive PMTUD for IPIP packets")
Link: https://sashiko.dev/#/patchset/20260702073430.67680-1-zhaoyz24%40mails.tsinghua.edu.cn
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 3a338f20fb6c07..4ce5aa8be321e5 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1653,6 +1653,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	bool tunnel, new_cp = false;
 	union nf_inet_addr *raddr;
 	char *outer_proto = "IPIP";
+	unsigned int hlen_ipip;
 	int ulen = 0;
 
 	*related = 1;
@@ -1690,9 +1691,10 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	/* Now find the contained IP header */
 	offset += sizeof(_icmph);
 	cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-	if (cih == NULL)
+	if (!(cih && cih->version == 4 && cih->ihl >= 5))
 		return NF_ACCEPT; /* The packet looks wrong, ignore */
 	raddr = (union nf_inet_addr *)&cih->daddr;
+	hlen_ipip = cih->ihl * 4;
 
 	/* Special case for errors for IPIP/UDP/GRE tunnel packets */
 	tunnel = false;
@@ -1708,9 +1710,9 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		/* Only for known tunnel */
 		if (!dest || dest->tun_type != IP_VS_CONN_F_TUNNEL_TYPE_IPIP)
 			return NF_ACCEPT;
-		offset += cih->ihl * 4;
+		offset += hlen_ipip;
 		cih = skb_header_pointer(skb, offset, sizeof(_ciph), &_ciph);
-		if (cih == NULL)
+		if (!(cih && cih->version == 4 && cih->ihl >= 5))
 			return NF_ACCEPT; /* The packet looks wrong, ignore */
 		tunnel = true;
 	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
@@ -1722,7 +1724,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		/* Non-first fragment has no UDP/GRE header */
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
 			return NF_ACCEPT;
-		offset2 = offset + cih->ihl * 4;
+		offset2 = offset + hlen_ipip;
 		if (cih->protocol == IPPROTO_UDP) {
 			ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET,
 					      raddr, &iproto);
@@ -1791,6 +1793,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	}
 
 	if (tunnel) {
+		unsigned int hlen_orig = cih->ihl * 4;
 		__be32 info = ic->un.gateway;
 		__u8 type = ic->type;
 		__u8 code = ic->code;
@@ -1807,6 +1810,9 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 				goto ignore_tunnel;
 			offset2 -= ihl + sizeof(_icmph);
 			skb_reset_network_header(skb);
+			/* Ensure the IP header is present in headroom */
+			if (!pskb_may_pull(skb, hlen_ipip))
+				goto ignore_tunnel;
 			IP_VS_DBG(12, "ICMP for %s %pI4->%pI4: mtu=%u\n",
 				  outer_proto, &ip_hdr(skb)->saddr,
 				  &ip_hdr(skb)->daddr, mtu);
@@ -1822,8 +1828,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 				if (dest_dst)
 					mtu = dst_mtu(dest_dst->dst_cache);
 			}
-			if (mtu > 68 + sizeof(struct iphdr) + ulen)
-				mtu -= sizeof(struct iphdr) + ulen;
+			if (mtu > 68 + hlen_ipip + ulen)
+				mtu -= hlen_ipip + ulen;
 			info = htonl(mtu);
 		}
 		/* Strip outer IP, ICMP and IPIP/UDP/GRE, go to IP header of
@@ -1832,6 +1838,9 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		if (pskb_pull(skb, offset2) == NULL)
 			goto ignore_tunnel;
 		skb_reset_network_header(skb);
+		/* Ensure the IP header is present in headroom */
+		if (!pskb_may_pull(skb, hlen_orig))
+			goto ignore_tunnel;
 		IP_VS_DBG(12, "Sending ICMP for %pI4->%pI4: t=%u, c=%u, i=%u\n",
 			&ip_hdr(skb)->saddr, &ip_hdr(skb)->daddr,
 			type, code, ntohl(info));
-- 
2.53.0



