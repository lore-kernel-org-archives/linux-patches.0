Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE253274B53;
	Fri,  7 Aug 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113836; cv=none; b=BbHY+tu5IOKslrfzUXACEmOnktZ/LwDyyXipkpXdBh3Ra/d2AksB8E7i5rgtGTZUVwDm3ohptdbTc6UnY4Go/mF+M2vK9/mwfwqaKxAQ39UwURAD2qytVE4qcmn1/VN3E6ps1RAveUf/K862bNQUnK1LJnXlx4VXt6lm+rsdd6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113836; c=relaxed/simple;
	bh=ntlnBg7/1qzggjS0OocHu5mYVzadk021Mb+HyFlGJXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHTOuK+wzMFJHNpNV87+IgyJh1JfdkeYGsGrjVwvVxsopDVGhtmNtqmHDOOfu3YMosxbdllwBd+el+gI4yJ3XGavPO4raSL4SROXfpsiIq9I3UDOsgQulV6Obd5LFrARS9A0ytjoxhfLG+KyC0n1dZshvGXGp9McmBIDxqW60j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7noe6P8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7noe6P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250C71F00A3D;
	Fri,  7 Aug 2026 14:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113822;
	bh=kEdvg+doy9AREvYA5iuyP/t5z7CPIYjvqmC4bBz16lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7noe6P8dIE1VpcQ3n6bzbztByKPPQukVhlUvgdx4zfcpwoVCsdiTfh5ahEnWUJEv
	 j+THmYKGCHNozx1a303qcpVzbQYPaRa8jJ4YBfA1ACUa+GCJMGAF/5X9LXTrwh3plN
	 vaKALEBzO/+4uz1DBHIjCNqDX2+pS5M9c5zu2Udo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/337] ipvs: fix the checksum validations
Date: Fri,  7 Aug 2026 16:34:10 +0200
Message-ID: <20260807143419.535501641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit e876b75b9020a97bbdc79721e7fc749024891c65 ]

ip_vs_in_icmp_v6() is missing checksum validation for ICMPv6
packets from clients. In fact, as for TCP/UDP we should
validate the checksum for ICMP packets only when we
mangle the packets on MASQ or on reply for tunnel.

Also, Sashiko points out that handle_response_icmp() being
common for IPv4 and IPv6 is missing the pseudo-header
calculation while validating ICMPv6 messages from real
servers which is a problem if checksum is not validated
by the hardware.

Fix the problems by creating ip_vs_checksum_common_check()
helper and use it for TCP/UDP/ICMP both for IPv4 and IPv6.
Rely on the nf_checksum() for validating the ICMP messages
but use it also for TCP and UDP.

Use correct IP offset for IP_VS_DBG_RL_PKT for TCP/UDP/SCTP.

IPVS packets (TCP/UDP/SCTP/ICMP) do not need checksum
validation on LOCAL_OUT (local clients or local real
servers) and on FORWARD (traffic from servers on LAN).
Do it only on LOCAL_IN, in case nf_checksum() is not
called on PRE_ROUTING.

Also, ip_vs_checksum_complete() can be marked static.

Fixes: 2a3b791e6e11 ("IPVS: Add/adjust Netfilter hook functions and helpers for v6")
Link: https://sashiko.dev/#/patchset/20260708180315.77413-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h                   | 31 +++++++++++++++--
 net/netfilter/ipvs/ip_vs_core.c       | 20 +++++++++--
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 15 ++++----
 net/netfilter/ipvs/ip_vs_proto_tcp.c  | 44 +++++------------------
 net/netfilter/ipvs/ip_vs_proto_udp.c  | 50 ++++++---------------------
 5 files changed, 74 insertions(+), 86 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 08b90d33acdc6..aef042039cb00 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -24,7 +24,9 @@
 #include <linux/netfilter.h>		/* for union nf_inet_addr */
 #include <linux/ip.h>
 #include <linux/ipv6.h>			/* for struct ipv6hdr */
+#include <net/route.h>
 #include <net/ipv6.h>
+#include <net/ip6_fib.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
 #endif
@@ -1711,8 +1713,6 @@ void ip_vs_nat_icmp_v6(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		       struct ip_vs_conn *cp, int dir);
 #endif
 
-__sum16 ip_vs_checksum_complete(struct sk_buff *skb, int offset);
-
 static inline __wsum ip_vs_check_diff4(__be32 old, __be32 new, __wsum oldsum)
 {
 	__be32 diff[2] = { ~old, new };
@@ -1738,6 +1738,33 @@ static inline __wsum ip_vs_check_diff2(__be16 old, __be16 new, __wsum oldsum)
 	return csum_partial(diff, sizeof(diff), oldsum);
 }
 
+static inline bool ip_vs_checksum_needed(struct sk_buff *skb, int af)
+{
+	/* Checksum unnecessary or already validated? */
+	if (skb_csum_unnecessary(skb))
+		return false;
+	/* LOCAL_OUT ? */
+	if (!skb->dev || skb->dev->flags & IFF_LOOPBACK)
+		return false;
+	/* !LOCAL_IN (FORWARD) ? */
+	if (af == AF_INET6) {
+		if (!(dst_rt6_info(skb_dst(skb))->rt6i_flags & RTF_LOCAL))
+			return false;
+	} else {
+		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
+			return false;
+	}
+	return true;
+}
+
+static inline bool ip_vs_checksum_common_check(struct sk_buff *skb,
+					       int offset, int proto, int af)
+{
+	if (!ip_vs_checksum_needed(skb, af))
+		return true;
+	return !nf_checksum(skb, NF_INET_LOCAL_IN, offset, proto, af);
+}
+
 /* Forget current conntrack (unconfirmed) and attach notrack entry */
 static inline void ip_vs_notrack(struct sk_buff *skb)
 {
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 90619453cb6f0..306a8227d300e 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -689,7 +689,7 @@ static int sysctl_nat_icmp_send(struct netns_ipvs *ipvs) { return 0; }
 
 #endif
 
-__sum16 ip_vs_checksum_complete(struct sk_buff *skb, int offset)
+static __sum16 ip_vs_checksum_complete(struct sk_buff *skb, int offset)
 {
 	return csum_fold(skb_checksum(skb, offset, skb->len - offset, 0));
 }
@@ -860,13 +860,14 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
 				unsigned int offset, unsigned int ihl,
 				unsigned int hooknum)
 {
+	int iproto = af == AF_INET6 ? IPPROTO_ICMPV6 : IPPROTO_ICMP;
 	unsigned int verdict = NF_DROP;
 
 	if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
 		goto after_nat;
 
 	/* Ensure the checksum is correct */
-	if (!skb_csum_unnecessary(skb) && ip_vs_checksum_complete(skb, ihl)) {
+	if (!ip_vs_checksum_common_check(skb, ihl, iproto, af)) {
 		/* Failed checksum! */
 		IP_VS_DBG_BUF(1, "Forward ICMP: failed checksum from %s!\n",
 			      IP_VS_DBG_ADDR(af, snet));
@@ -1720,7 +1721,8 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
 	verdict = NF_DROP;
 
 	/* Ensure the checksum is correct */
-	if (!skb_csum_unnecessary(skb) && ip_vs_checksum_complete(skb, ihl)) {
+	if ((IP_VS_FWD_METHOD(cp) == IP_VS_CONN_F_MASQ || tunnel) &&
+	    !ip_vs_checksum_common_check(skb, ihl, IPPROTO_ICMP, AF_INET)) {
 		/* Failed checksum! */
 		IP_VS_DBG(1, "Incoming ICMP: failed checksum from %pI4!\n",
 			  &iph->saddr);
@@ -1886,6 +1888,18 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		goto out;
 	}
 
+	verdict = NF_DROP;
+
+	/* Ensure the checksum is correct */
+	if (IP_VS_FWD_METHOD(cp) == IP_VS_CONN_F_MASQ &&
+	    !ip_vs_checksum_common_check(skb, iph->len, IPPROTO_ICMPV6,
+					 AF_INET6)) {
+		/* Failed checksum! */
+		IP_VS_DBG(1, "Incoming ICMPv6: failed checksum from %pI6c!\n",
+			  &iph->saddr);
+		goto out;
+	}
+
 	/* do the statistics and put it back */
 	ip_vs_in_stats(cp, skb);
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index c67317be17dfa..f6f732b7dfa86 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -11,7 +11,7 @@
 
 static int
 sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
-		unsigned int sctphoff);
+		struct ip_vs_iphdr *iph);
 
 static int
 sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
@@ -109,7 +109,7 @@ sctp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		int ret;
 
 		/* Some checks before mangling */
-		if (!sctp_csum_check(cp->af, skb, pp, sctphoff))
+		if (!sctp_csum_check(cp->af, skb, pp, iph))
 			return 0;
 
 		/* Call application helper if needed */
@@ -157,7 +157,7 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		int ret;
 
 		/* Some checks before mangling */
-		if (!sctp_csum_check(cp->af, skb, pp, sctphoff))
+		if (!sctp_csum_check(cp->af, skb, pp, iph))
 			return 0;
 
 		/* Call application helper if needed */
@@ -187,19 +187,22 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 
 static int
 sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
-		unsigned int sctphoff)
+		struct ip_vs_iphdr *iph)
 {
+	unsigned int sctphoff = iph->len;
 	struct sctphdr *sh;
 	__le32 cmp, val;
 
+	if (!ip_vs_checksum_needed(skb, af))
+		return 1;
 	sh = (struct sctphdr *)(skb->data + sctphoff);
 	cmp = sh->checksum;
 	val = sctp_compute_cksum(skb, sctphoff);
 
 	if (val != cmp) {
 		/* CRC failure, dump it. */
-		IP_VS_DBG_RL_PKT(0, af, pp, skb, 0,
-				"Failed checksum for");
+		IP_VS_DBG_RL_PKT(0, af, pp, skb, iph->off,
+				 "Failed checksum for");
 		return 0;
 	}
 	return 1;
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index b382810156b2c..bf31127338aa0 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -30,7 +30,7 @@
 
 static int
 tcp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
-	       unsigned int tcphoff);
+	       struct ip_vs_iphdr *iph);
 
 static int
 tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
@@ -167,7 +167,7 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		int ret;
 
 		/* Some checks before mangling */
-		if (!tcp_csum_check(cp->af, skb, pp, tcphoff))
+		if (!tcp_csum_check(cp->af, skb, pp, iph))
 			return 0;
 
 		/* Call application helper if needed */
@@ -245,7 +245,7 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		int ret;
 
 		/* Some checks before mangling */
-		if (!tcp_csum_check(cp->af, skb, pp, tcphoff))
+		if (!tcp_csum_check(cp->af, skb, pp, iph))
 			return 0;
 
 		/*
@@ -303,41 +303,13 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 
 static int
 tcp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
-	       unsigned int tcphoff)
+	       struct ip_vs_iphdr *iph)
 {
-	switch (skb->ip_summed) {
-	case CHECKSUM_NONE:
-		skb->csum = skb_checksum(skb, tcphoff, skb->len - tcphoff, 0);
-		fallthrough;
-	case CHECKSUM_COMPLETE:
-#ifdef CONFIG_IP_VS_IPV6
-		if (af == AF_INET6) {
-			if (csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-					    &ipv6_hdr(skb)->daddr,
-					    skb->len - tcphoff,
-					    IPPROTO_TCP,
-					    skb->csum)) {
-				IP_VS_DBG_RL_PKT(0, af, pp, skb, 0,
-						 "Failed checksum for");
-				return 0;
-			}
-		} else
-#endif
-			if (csum_tcpudp_magic(ip_hdr(skb)->saddr,
-					      ip_hdr(skb)->daddr,
-					      skb->len - tcphoff,
-					      ip_hdr(skb)->protocol,
-					      skb->csum)) {
-				IP_VS_DBG_RL_PKT(0, af, pp, skb, 0,
-						 "Failed checksum for");
-				return 0;
-			}
-		break;
-	default:
-		/* No need to checksum. */
-		break;
+	if (!ip_vs_checksum_common_check(skb, iph->len, IPPROTO_TCP, af)) {
+		IP_VS_DBG_RL_PKT(0, af, pp, skb, iph->off,
+				 "Failed checksum for");
+		return 0;
 	}
-
 	return 1;
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index dbd4155bb0752..40d30649b3048 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -26,7 +26,7 @@
 
 static int
 udp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
-	       unsigned int udphoff);
+	       struct ip_vs_iphdr *iph);
 
 static int
 udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
@@ -156,7 +156,7 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		int ret;
 
 		/* Some checks before mangling */
-		if (!udp_csum_check(cp->af, skb, pp, udphoff))
+		if (!udp_csum_check(cp->af, skb, pp, iph))
 			return 0;
 
 		/*
@@ -239,7 +239,7 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		int ret;
 
 		/* Some checks before mangling */
-		if (!udp_csum_check(cp->af, skb, pp, udphoff))
+		if (!udp_csum_check(cp->af, skb, pp, iph))
 			return 0;
 
 		/*
@@ -299,48 +299,20 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 
 static int
 udp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
-	       unsigned int udphoff)
+	       struct ip_vs_iphdr *iph)
 {
 	struct udphdr _udph, *uh;
 
-	uh = skb_header_pointer(skb, udphoff, sizeof(_udph), &_udph);
+	uh = skb_header_pointer(skb, iph->len, sizeof(_udph), &_udph);
 	if (uh == NULL)
 		return 0;
 
-	if (uh->check != 0) {
-		switch (skb->ip_summed) {
-		case CHECKSUM_NONE:
-			skb->csum = skb_checksum(skb, udphoff,
-						 skb->len - udphoff, 0);
-			fallthrough;
-		case CHECKSUM_COMPLETE:
-#ifdef CONFIG_IP_VS_IPV6
-			if (af == AF_INET6) {
-				if (csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						    &ipv6_hdr(skb)->daddr,
-						    skb->len - udphoff,
-						    IPPROTO_UDP,
-						    skb->csum)) {
-					IP_VS_DBG_RL_PKT(0, af, pp, skb, 0,
-							 "Failed checksum for");
-					return 0;
-				}
-			} else
-#endif
-				if (csum_tcpudp_magic(ip_hdr(skb)->saddr,
-						      ip_hdr(skb)->daddr,
-						      skb->len - udphoff,
-						      ip_hdr(skb)->protocol,
-						      skb->csum)) {
-					IP_VS_DBG_RL_PKT(0, af, pp, skb, 0,
-							 "Failed checksum for");
-					return 0;
-				}
-			break;
-		default:
-			/* No need to checksum. */
-			break;
-		}
+	if (!uh->check)
+		return 1;
+	if (!ip_vs_checksum_common_check(skb, iph->len, IPPROTO_UDP, af)) {
+		IP_VS_DBG_RL_PKT(0, af, pp, skb, iph->off,
+				 "Failed checksum for");
+		return 0;
 	}
 	return 1;
 }
-- 
2.53.0



