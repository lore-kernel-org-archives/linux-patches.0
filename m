Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5608646E017;
	Tue, 21 Jul 2026 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658277; cv=none; b=kfQrrlacf3OtMDbj2H82FyaPXvrO+H+ObPk5LTjNxibOADusVYNNTusX1nRAuJ1A0uL5dSQfovLGoRp2njxxrF3rR9ksVRqmgsSPmB4C18RrjQoRG1VkTquR88y+RvaGbJ0mF/jtEpiivd6yUpEGLiuY/zJ0rEzViZrmRGOyP/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658277; c=relaxed/simple;
	bh=AnICE+6i47eq5ubLoR4QHL+wIXty6LWgWHsh54mKZQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lewNoTY7L/yWMT+kjfxuNPWMH+eaWEuHHTN5M6T+y+BpmCdX+BSmhYT2not6+5K/90TCoTDtUdTu1/r9SX3V9L9x6CX4z4a1smwFdbxzjI+KWlPspn1uaT1zovkbRtamRuy2I6OCfA3kKcKaiPBoElKDOwNMJZb93cujmSYrDxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F71kQnom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F71kQnom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6011F00A3D;
	Tue, 21 Jul 2026 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658274;
	bh=kQv6V71cUK7FvtVgyVg9JQQcqgcjgGEJXu5I2+YAoDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F71kQnom3E6YnfxZQiEQCF2Zz70N1W88ze1aaRg3FYEK+Yp51JyI2NXSK0JY9TzV3
	 q1SkN3CRu5EaUsdIpxoQnCUr9rHzSdg823wPz/A8tEaEuIEuXvgGyTwtoDtMSTSQtV
	 XMa+3X4nRXHiZ6KGkg5L/c5MOmspuZe7wDlQ2P4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1083/1611] ipvs: ensure inner headers in ICMP errors are in headroom
Date: Tue, 21 Jul 2026 17:19:59 +0200
Message-ID: <20260721152539.770427676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index a7dc5014e0fe72..594c7b24007d61 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1589,6 +1589,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	bool tunnel, new_cp = false;
 	union nf_inet_addr *raddr;
 	char *outer_proto = "IPIP";
+	unsigned int hlen_ipip;
 	int ulen = 0;
 
 	*related = 1;
@@ -1626,9 +1627,10 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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
@@ -1644,9 +1646,9 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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
@@ -1658,7 +1660,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 		/* Non-first fragment has no UDP/GRE header */
 		if (unlikely(cih->frag_off & htons(IP_OFFSET)))
 			return NF_ACCEPT;
-		offset2 = offset + cih->ihl * 4;
+		offset2 = offset + hlen_ipip;
 		if (cih->protocol == IPPROTO_UDP) {
 			ulen = ipvs_udp_decap(ipvs, skb, offset2, AF_INET,
 					      raddr, &iproto);
@@ -1727,6 +1729,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	}
 
 	if (tunnel) {
+		unsigned int hlen_orig = cih->ihl * 4;
 		__be32 info = ic->un.gateway;
 		__u8 type = ic->type;
 		__u8 code = ic->code;
@@ -1743,6 +1746,9 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 				goto ignore_tunnel;
 			offset2 -= ihl + sizeof(_icmph);
 			skb_reset_network_header(skb);
+			/* Ensure the IP header is present in headroom */
+			if (!pskb_may_pull(skb, hlen_ipip))
+				goto ignore_tunnel;
 			IP_VS_DBG(12, "ICMP for %s %pI4->%pI4: mtu=%u\n",
 				  outer_proto, &ip_hdr(skb)->saddr,
 				  &ip_hdr(skb)->daddr, mtu);
@@ -1758,8 +1764,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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
@@ -1768,6 +1774,9 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
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



