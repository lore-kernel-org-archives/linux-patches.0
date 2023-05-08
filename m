Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABFA168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5739C433D2;
	Mon,  8 May 2023 10:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540243;
	bh=f+TNB1z6Z71G2y4UxNzTNiKWRkEO+JoaDGqMXlsfExY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kp++5F/Oh0WhcB6oWjmnUdbGoFbpQ3EXzQ8LH+G2aDHfxLSaU0OrX9/cps2OUISLh
	 UXAy6f18q4dX5Fixo1ooB9Ag7irc4jBiFEmO1cMefmzbp4MXAxHjzbxvD+/6Se/YNa
	 eFNTiN0vZS0aDpHt5XW2rysqcAbUEjORFojaFnIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhu Koriginja <madhu.koriginja@nxp.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 291/611] netfilter: keep conntrack reference until IPsecv6 policy checks are done
Date: Mon,  8 May 2023 11:42:13 +0200
Message-Id: <20230508094431.863511800@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Madhu Koriginja <madhu.koriginja@nxp.com>

[ Upstream commit b0e214d212030fe497d4d150bb3474e50ad5d093 ]

Keep the conntrack reference until policy checks have been performed for
IPsec V6 NAT support, just like ipv4.

The reference needs to be dropped before a packet is
queued to avoid having the conntrack module unloadable.

Fixes: 58a317f1061c ("netfilter: ipv6: add IPv6 NAT support")
Signed-off-by: Madhu Koriginja <madhu.koriginja@nxp.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/ipv6.c      |  1 +
 net/ipv6/ip6_input.c | 14 ++++++--------
 net/ipv6/raw.c       |  5 ++---
 net/ipv6/tcp_ipv6.c  |  2 ++
 net/ipv6/udp.c       |  2 ++
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index b9d7c3dd1cb39..c0fd8f5f3b94e 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -783,6 +783,7 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset_ct(skb);
 
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4,
 				refcounted) ? -1 : 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e1ebf5e42ebe9..d94041bb42872 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -404,10 +404,6 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			/* Only do this once for first final protocol */
 			have_final = true;
 
-			/* Free reference early: we don't need it any more,
-			   and it may hold ip_conntrack module loaded
-			   indefinitely. */
-			nf_reset_ct(skb);
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
@@ -430,10 +426,12 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 				goto discard;
 			}
 		}
-		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
-		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
-			SKB_DR_SET(reason, XFRM_POLICY);
-			goto discard;
+		if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) {
+			if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+				SKB_DR_SET(reason, XFRM_POLICY);
+				goto discard;
+			}
+			nf_reset_ct(skb);
 		}
 
 		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v6_rcv, udpv6_rcv,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 4fc511bdf176c..f44b99f7ecdcc 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -193,10 +193,8 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 			struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
 
 			/* Not releasing hash table! */
-			if (clone) {
-				nf_reset_ct(clone);
+			if (clone)
 				rawv6_rcv(sk, clone);
-			}
 		}
 	}
 	rcu_read_unlock();
@@ -387,6 +385,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
+	nf_reset_ct(skb);
 
 	if (!rp->checksum)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 81afb40bfc0bb..c563a84d67b46 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1722,6 +1722,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (drop_reason)
 		goto discard_and_relse;
 
+	nf_reset_ct(skb);
+
 	if (tcp_filter(sk, skb)) {
 		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 0b8127988adb7..c029222ce46b0 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -701,6 +701,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto drop;
 	}
+	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -1024,6 +1025,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard;
+	nf_reset_ct(skb);
 
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
-- 
2.39.2



