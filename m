Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C962C3D7D9D;
	Tue, 16 Jun 2026 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636458; cv=none; b=ph4kf9SU0xRn4ImFgzn26kPamP+l2C0LyhYt+3LreQJiaA7EDwEv6oMFk7vpjQWX828TZqgxZYuFdDq8KiLbvUi9SdUe3MaiOSUqj0yvZIx4AqhS+8BRzdbphgAnBxlHvyU6v5hqYwP983sXg4a77cRmWKL2LGccB9G6cfMJfkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636458; c=relaxed/simple;
	bh=cusyxUnnfP1VwGaXgOL3xtDts3rCwToNqsQgQK8DE6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twRj4rWQxXMtu/S6PBBLL5D3V80szm0FD4/OR+Bme91IJhvYzJna9AqPxyTUtucH4E0ormA4X2LDpSpwMXB3YdBy8BggxWg5D6Xn9KwSmaLiFqDQhsu7qPIFJK6dH7wKzOoXL0OcbDH+qEwZRUR+CSoDpiS6Zp74j/KT3T1cA3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uahVYI/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uahVYI/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A89D1F000E9;
	Tue, 16 Jun 2026 19:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636456;
	bh=So9XFKQAatxNd3AC1cI6U3QvApNi0O1kSK+DFcdQ0kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uahVYI/E9A6B+MOuSgezIV0MRWiKFfqCioGPyMEM1JhvAlj4P34yTUiAcUCvZDEU2
	 6rbKCTKtdGt5LfwXdyNjMmj57ARUn7NWPWujlIo+xB4RWz+Ne26Wt8Qmyj9E9CX4io
	 xLtZpPz/oFaHV1H6ymBmfeIuFJhJLZRIqVvF65cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Subject: [PATCH 5.10 215/342] ipvs: skip ipv6 extension headers for csum checks
Date: Tue, 16 Jun 2026 20:28:31 +0530
Message-ID: <20260616145058.199021441@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

commit 05cfe9863ef049d98141dc2969eefde72fb07625 upstream.

Protocol checksum validation fails for IPv6 if there are extension
headers before the protocol header. iph->len already contains its
offset, so use it to fix the problem.

Fixes: 2906f66a5682 ("ipvs: SCTP Trasport Loadbalancing Support")
Fixes: 0bbdd42b7efa ("IPVS: Extend protocol DNAT/SNAT and state handlers")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Nazar Kalashnikov <nazarkalashnikov0@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c |   18 ++++++------------
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |   21 +++++++--------------
 net/netfilter/ipvs/ip_vs_proto_udp.c  |   20 +++++++-------------
 3 files changed, 20 insertions(+), 39 deletions(-)

--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -10,7 +10,8 @@
 #include <net/ip_vs.h>
 
 static int
-sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp);
+sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
+		unsigned int sctphoff);
 
 static int
 sctp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
@@ -108,7 +109,7 @@ sctp_snat_handler(struct sk_buff *skb, s
 		int ret;
 
 		/* Some checks before mangling */
-		if (!sctp_csum_check(cp->af, skb, pp))
+		if (!sctp_csum_check(cp->af, skb, pp, sctphoff))
 			return 0;
 
 		/* Call application helper if needed */
@@ -156,7 +157,7 @@ sctp_dnat_handler(struct sk_buff *skb, s
 		int ret;
 
 		/* Some checks before mangling */
-		if (!sctp_csum_check(cp->af, skb, pp))
+		if (!sctp_csum_check(cp->af, skb, pp, sctphoff))
 			return 0;
 
 		/* Call application helper if needed */
@@ -185,19 +186,12 @@ sctp_dnat_handler(struct sk_buff *skb, s
 }
 
 static int
-sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
+sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
+		unsigned int sctphoff)
 {
-	unsigned int sctphoff;
 	struct sctphdr *sh;
 	__le32 cmp, val;
 
-#ifdef CONFIG_IP_VS_IPV6
-	if (af == AF_INET6)
-		sctphoff = sizeof(struct ipv6hdr);
-	else
-#endif
-		sctphoff = ip_hdrlen(skb);
-
 	sh = (struct sctphdr *)(skb->data + sctphoff);
 	cmp = sh->checksum;
 	val = sctp_compute_cksum(skb, sctphoff);
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -29,7 +29,8 @@
 #include <net/ip_vs.h>
 
 static int
-tcp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp);
+tcp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
+	       unsigned int tcphoff);
 
 static int
 tcp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
@@ -166,7 +167,7 @@ tcp_snat_handler(struct sk_buff *skb, st
 		int ret;
 
 		/* Some checks before mangling */
-		if (!tcp_csum_check(cp->af, skb, pp))
+		if (!tcp_csum_check(cp->af, skb, pp, tcphoff))
 			return 0;
 
 		/* Call application helper if needed */
@@ -244,7 +245,7 @@ tcp_dnat_handler(struct sk_buff *skb, st
 		int ret;
 
 		/* Some checks before mangling */
-		if (!tcp_csum_check(cp->af, skb, pp))
+		if (!tcp_csum_check(cp->af, skb, pp, tcphoff))
 			return 0;
 
 		/*
@@ -301,17 +302,9 @@ tcp_dnat_handler(struct sk_buff *skb, st
 
 
 static int
-tcp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
+tcp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
+	       unsigned int tcphoff)
 {
-	unsigned int tcphoff;
-
-#ifdef CONFIG_IP_VS_IPV6
-	if (af == AF_INET6)
-		tcphoff = sizeof(struct ipv6hdr);
-	else
-#endif
-		tcphoff = ip_hdrlen(skb);
-
 	switch (skb->ip_summed) {
 	case CHECKSUM_NONE:
 		skb->csum = skb_checksum(skb, tcphoff, skb->len - tcphoff, 0);
@@ -322,7 +315,7 @@ tcp_csum_check(int af, struct sk_buff *s
 			if (csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
 					    &ipv6_hdr(skb)->daddr,
 					    skb->len - tcphoff,
-					    ipv6_hdr(skb)->nexthdr,
+					    IPPROTO_TCP,
 					    skb->csum)) {
 				IP_VS_DBG_RL_PKT(0, af, pp, skb, 0,
 						 "Failed checksum for");
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -25,7 +25,8 @@
 #include <net/ip6_checksum.h>
 
 static int
-udp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp);
+udp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
+	       unsigned int udphoff);
 
 static int
 udp_conn_schedule(struct netns_ipvs *ipvs, int af, struct sk_buff *skb,
@@ -155,7 +156,7 @@ udp_snat_handler(struct sk_buff *skb, st
 		int ret;
 
 		/* Some checks before mangling */
-		if (!udp_csum_check(cp->af, skb, pp))
+		if (!udp_csum_check(cp->af, skb, pp, udphoff))
 			return 0;
 
 		/*
@@ -238,7 +239,7 @@ udp_dnat_handler(struct sk_buff *skb, st
 		int ret;
 
 		/* Some checks before mangling */
-		if (!udp_csum_check(cp->af, skb, pp))
+		if (!udp_csum_check(cp->af, skb, pp, udphoff))
 			return 0;
 
 		/*
@@ -297,17 +298,10 @@ udp_dnat_handler(struct sk_buff *skb, st
 
 
 static int
-udp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
+udp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
+	       unsigned int udphoff)
 {
 	struct udphdr _udph, *uh;
-	unsigned int udphoff;
-
-#ifdef CONFIG_IP_VS_IPV6
-	if (af == AF_INET6)
-		udphoff = sizeof(struct ipv6hdr);
-	else
-#endif
-		udphoff = ip_hdrlen(skb);
 
 	uh = skb_header_pointer(skb, udphoff, sizeof(_udph), &_udph);
 	if (uh == NULL)
@@ -325,7 +319,7 @@ udp_csum_check(int af, struct sk_buff *s
 				if (csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
 						    &ipv6_hdr(skb)->daddr,
 						    skb->len - udphoff,
-						    ipv6_hdr(skb)->nexthdr,
+						    IPPROTO_UDP,
 						    skb->csum)) {
 					IP_VS_DBG_RL_PKT(0, af, pp, skb, 0,
 							 "Failed checksum for");


