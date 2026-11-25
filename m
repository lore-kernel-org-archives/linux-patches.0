Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624169;
	b=P2sJnS3WZxg8m+Y2ilLZlIpcDJo9EMC+ESP/71HXoRS4IlnrVU+g+mDs1I31Wgvbdj50
	 AASagQg17r6nS+8dvulTxy4cXuZJJCP2GRVEIDY44tBRZv3nxHL29fy9LPeRC5Ncsn22v
	 dgOmTWFRbpM+3Fxh0iSoWOLaaG6H40wVoSQrGLN6xcQTn0a4ix+AwIlpNGpUHzEGYGjGZ
	 lUjxQVNNavXz3rh3SZiRRhTulmBFrNuv43fYGWCcamkxBGVy++ZUEe9U4QFt1PHp6BI2N
	 0vSljyduFSa/BDsKhDobvw3xbBE9VunhCrdFWtiznNFOx26mjrBjlORzERJyypvXRBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cdfox5Zn2257OInTQZZjuo3wH/Ziv8hJSy+5fc+OsdI=;
	b=J7eznJRk3Sxj2Oozaft5q0DOdiUT+LCpnOBRHW6DKn5erdOshjP/Az+0C7JhfPqxtpN6
	 4rxq3H3jxkZmF2CUAvZa915QbV/WE+nuLsMNZUFxgz44bsl722waLdB9prcHeFezkdyR4
	 f0BGtbYD4ZMD15yon5xvu8Sfy4jWYYWLwX4OomD0z3YmGQQwbQLWH/oVA8Fxqb0On0uIs
	 OsWEs/8S1zRy63zGiF52OWMHjGGFH/uchHBM5VK4zytpsakSm+pD+6gOF5jxnBL8ElNMX
	 8zHkdducRCyL2CFGSVGF3JKgHxGdPx6VgSW0X54KqzE7tRKo2ru30s47Roy/wDANODA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoNZOof6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A1B606A326;
	Wed, 25 Nov 2026 16:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LoNZOof6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A8C1F00A3E;
	Wed, 25 Nov 2026 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624169;
	bh=cdfox5Zn2257OInTQZZjuo3wH/Ziv8hJSy+5fc+OsdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoNZOof61L44c+p6X8XC4bkw12yS3mjyWUA2S0BHK7ZK3MBbIPXzLTh+AYxdM2GDJ
	 xAwFU7PIMTc50UWkENfqPUvZ1ZkJJdf2eeNINvDyLuhfeuA47fh/EVBOP0X5Ar4/tV
	 gyGMETQ+Pms/WEkXW9TdFbhp2V43gGYnKy6SAuus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/816] ipv4: Convert ip_route_input_noref() to dscp_t.
Date: Wed, 25 Nov 2026 15:27:35 +0100
Message-ID: <20261125143851.690582636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 66fb6386d358a04edd5c640e38b4a02b323b89d8 ]

Pass a dscp_t variable to ip_route_input_noref(), instead of a plain
u8, to prevent accidental setting of ECN bits in ->flowi4_tos.

Callers of ip_route_input_noref() to consider are:

  * arp_process() in net/ipv4/arp.c. This function sets the tos
    parameter to 0, which is already a valid dscp_t value, so it
    doesn't need to be adjusted for the new prototype.

  * ip_route_input(), which already has a dscp_t variable to pass as
    parameter. We just need to remove the inet_dscp_to_dsfield()
    conversion.

  * ipvlan_l3_rcv(), bpf_lwt_input_reroute(), ip_expire(),
    ip_rcv_finish_core(), xfrm4_rcv_encap_finish() and
    xfrm4_rcv_encap(), which get the DSCP directly from IPv4 headers
    and can simply use the ip4h_dscp() helper.

While there, declare the IPv4 header pointers as const in
ipvlan_l3_rcv() and bpf_lwt_input_reroute().
Also, modify the declaration of ip_route_input_noref() in
include/net/route.h so that it matches the prototype of its
implementation in net/ipv4/route.c.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/a8a747bed452519c4d0cc06af32c7e7795d7b627.1727807926.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b3ad42f61832 ("bpf: Reset skb->cb after an lwt prog pushes an IP header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_l3s.c | 6 ++++--
 include/net/route.h             | 7 +++----
 net/core/lwt_bpf.c              | 5 +++--
 net/ipv4/ip_fragment.c          | 4 ++--
 net/ipv4/ip_input.c             | 2 +-
 net/ipv4/route.c                | 6 +++---
 net/ipv4/xfrm4_input.c          | 2 +-
 net/ipv4/xfrm4_protocol.c       | 2 +-
 8 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index ca35a50bb6405..7c017fe35522a 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2014 Mahesh Bandewar <maheshb@google.com>
  */
 
+#include <net/ip.h>
+
 #include "ipvlan.h"
 
 static unsigned int ipvlan_netid __read_mostly;
@@ -48,11 +50,11 @@ static struct sk_buff *ipvlan_l3_rcv(struct net_device *dev,
 	switch (proto) {
 	case AF_INET:
 	{
-		struct iphdr *ip4h = ip_hdr(skb);
+		const struct iphdr *ip4h = ip_hdr(skb);
 		int err;
 
 		err = ip_route_input_noref(skb, ip4h->daddr, ip4h->saddr,
-					   ip4h->tos, sdev);
+					   ip4h_dscp(ip4h), sdev);
 		if (unlikely(err))
 			goto out;
 		break;
diff --git a/include/net/route.h b/include/net/route.h
index 76f526e051aa3..5df58eb5ecb10 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -201,8 +201,8 @@ static inline struct rtable *ip_route_output_gre(struct net *net, struct flowi4
 int ip_mc_validate_source(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 			  u8 tos, struct net_device *dev,
 			  struct in_device *in_dev, u32 *itag);
-int ip_route_input_noref(struct sk_buff *skb, __be32 dst, __be32 src,
-			 u8 tos, struct net_device *devin);
+int ip_route_input_noref(struct sk_buff *skb, __be32 daddr, __be32 saddr,
+			 dscp_t dscp, struct net_device *dev);
 int ip_route_use_hint(struct sk_buff *skb, __be32 dst, __be32 src,
 		      u8 tos, struct net_device *devin,
 		      const struct sk_buff *hint);
@@ -213,8 +213,7 @@ static inline int ip_route_input(struct sk_buff *skb, __be32 dst, __be32 src,
 	int err;
 
 	rcu_read_lock();
-	err = ip_route_input_noref(skb, dst, src, inet_dscp_to_dsfield(dscp),
-				   devin);
+	err = ip_route_input_noref(skb, dst, src, dscp, devin);
 	if (!err) {
 		skb_dst_force(skb);
 		if (!skb_dst(skb))
diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index 4978dcf6ffc1d..58bf664d99ebd 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -10,6 +10,7 @@
 #include <linux/bpf.h>
 #include <net/lwtunnel.h>
 #include <net/gre.h>
+#include <net/ip.h>
 #include <net/ip6_route.h>
 #include <net/ipv6_stubs.h>
 #include <net/inet_dscp.h>
@@ -91,12 +92,12 @@ static int bpf_lwt_input_reroute(struct sk_buff *skb)
 
 	if (skb->protocol == htons(ETH_P_IP)) {
 		struct net_device *dev = skb_dst(skb)->dev;
-		struct iphdr *iph = ip_hdr(skb);
+		const struct iphdr *iph = ip_hdr(skb);
 
 		dev_hold(dev);
 		skb_dst_drop(skb);
 		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
-					   iph->tos, dev);
+					   ip4h_dscp(iph), dev);
 		dev_put(dev);
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
 		skb_dst_drop(skb);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 1fd7017300b3b..648e80c1f8df3 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -168,8 +168,8 @@ static void ip_expire(struct timer_list *t)
 
 	/* skb has no dst, perform route lookup again */
 	iph = ip_hdr(head);
-	err = ip_route_input_noref(head, iph->daddr, iph->saddr,
-					   iph->tos, head->dev);
+	err = ip_route_input_noref(head, iph->daddr, iph->saddr, ip4h_dscp(iph),
+				   head->dev);
 	if (err)
 		goto out;
 
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 7b092ba6f5779..9db51472c1e0f 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -363,7 +363,7 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 	 */
 	if (!skb_valid_dst(skb)) {
 		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
-					   iph->tos, dev);
+					   ip4h_dscp(iph), dev);
 		if (unlikely(err))
 			goto drop_error;
 	} else {
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f1b0ab77b443b..64fe59730ed8b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2529,14 +2529,14 @@ static int ip_route_input_rcu(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 }
 
 int ip_route_input_noref(struct sk_buff *skb, __be32 daddr, __be32 saddr,
-			 u8 tos, struct net_device *dev)
+			 dscp_t dscp, struct net_device *dev)
 {
 	struct fib_result res;
 	int err;
 
-	tos &= INET_DSCP_MASK;
 	rcu_read_lock();
-	err = ip_route_input_rcu(skb, daddr, saddr, tos, dev, &res);
+	err = ip_route_input_rcu(skb, daddr, saddr, inet_dscp_to_dsfield(dscp),
+				 dev, &res);
 	rcu_read_unlock();
 
 	return err;
diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index 9deee1558e3d6..f6f2a8ef3f884 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -33,7 +33,7 @@ static inline int xfrm4_rcv_encap_finish(struct net *net, struct sock *sk,
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (ip_route_input_noref(skb, iph->daddr, iph->saddr,
-					 iph->tos, skb->dev))
+					 ip4h_dscp(iph), skb->dev))
 			goto drop;
 	}
 
diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index b146ce88c5d0c..4ee624d8e66fc 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -76,7 +76,7 @@ int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (ip_route_input_noref(skb, iph->daddr, iph->saddr,
-					 iph->tos, skb->dev))
+					 ip4h_dscp(iph), skb->dev))
 			goto drop;
 	}
 
-- 
2.53.0



