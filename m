Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5A72E649
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3C5QahX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82440C433C8;
	Mon,  9 Oct 2023 13:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858712;
	bh=pJGpqQ/VJkguZPoj3pNYLHAd35OTS99ZxLK3cLP1Brg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3C5QahXXOnwLtrFeGJqnqbQ9cQgXLWrB4u+KIFA6p4y3NnC3WTIHB865dbqa8Bgk
	 5BqDc5GEyILfcTLwws5veLwHo9+OW+VAXWGCTScaMPbMJJUqefjg1SbjvSx1KQ3amz
	 5tcJ1ku8smwLT8/Dbvvc73PxuaIRnYvLPxqQEqn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minqiang Chen <ptpt52@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jan Engelhardt <jengelh@inai.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/226] netfilter: use actual socket sk for REJECT action
Date: Mon,  9 Oct 2023 15:00:37 +0200
Message-ID: <20231009130128.773063301@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jan Engelhardt <jengelh@inai.de>

[ Upstream commit 04295878beac396dae47ba93141cae0d9386e7ef ]

True to the message of commit v5.10-rc1-105-g46d6c5ae953c, _do_
actually make use of state->sk when possible, such as in the REJECT
modules.

Reported-by: Minqiang Chen <ptpt52@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 28427f368f0e ("netfilter: nft_exthdr: Fix non-linear header modification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/ipv4/nf_reject.h | 4 ++--
 include/net/netfilter/ipv6/nf_reject.h | 5 ++---
 net/ipv4/netfilter/ipt_REJECT.c        | 3 ++-
 net/ipv4/netfilter/nf_reject_ipv4.c    | 6 +++---
 net/ipv4/netfilter/nft_reject_ipv4.c   | 3 ++-
 net/ipv6/netfilter/ip6t_REJECT.c       | 2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c    | 5 +++--
 net/ipv6/netfilter/nft_reject_ipv6.c   | 3 ++-
 net/netfilter/nft_reject_inet.c        | 6 ++++--
 9 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_reject.h b/include/net/netfilter/ipv4/nf_reject.h
index 40e0e0623f461..d8207a82d761a 100644
--- a/include/net/netfilter/ipv4/nf_reject.h
+++ b/include/net/netfilter/ipv4/nf_reject.h
@@ -8,8 +8,8 @@
 #include <net/netfilter/nf_reject.h>
 
 void nf_send_unreach(struct sk_buff *skb_in, int code, int hook);
-void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook);
-
+void nf_send_reset(struct net *net, struct sock *, struct sk_buff *oldskb,
+		   int hook);
 const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 					     struct tcphdr *_oth, int hook);
 struct iphdr *nf_reject_iphdr_put(struct sk_buff *nskb,
diff --git a/include/net/netfilter/ipv6/nf_reject.h b/include/net/netfilter/ipv6/nf_reject.h
index 4a3ef9ebdf6f6..86e87bc2c5167 100644
--- a/include/net/netfilter/ipv6/nf_reject.h
+++ b/include/net/netfilter/ipv6/nf_reject.h
@@ -7,9 +7,8 @@
 
 void nf_send_unreach6(struct net *net, struct sk_buff *skb_in, unsigned char code,
 		      unsigned int hooknum);
-
-void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook);
-
+void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		    int hook);
 const struct tcphdr *nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 					      struct tcphdr *otcph,
 					      unsigned int *otcplen, int hook);
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index e16b98ee6266e..4b88407347629 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -56,7 +56,8 @@ reject_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		nf_send_unreach(skb, ICMP_PKT_FILTERED, hook);
 		break;
 	case IPT_TCP_RESET:
-		nf_send_reset(xt_net(par), skb, hook);
+		nf_send_reset(xt_net(par), par->state->sk, skb, hook);
+		break;
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 93b07739807b2..efe14a6a5d9b8 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -112,7 +112,8 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 }
 
 /* Send RST reply */
-void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
+void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		   int hook)
 {
 	struct net_device *br_indev __maybe_unused;
 	struct sk_buff *nskb;
@@ -144,8 +145,7 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
 				   ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
-
-	if (ip_route_me_harder(net, nskb->sk, nskb, RTN_UNSPEC))
+	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
 	niph = ip_hdr(nskb);
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index e408f813f5d80..ff437e4ed6db0 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -27,7 +27,8 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 		nf_send_unreach(pkt->skb, priv->icmp_code, nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
+		nf_send_reset(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+			      nft_hook(pkt));
 		break;
 	default:
 		break;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 3ac5485049f09..a35019d2e480c 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -61,7 +61,7 @@ reject_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		/* Do nothing */
 		break;
 	case IP6T_TCP_RESET:
-		nf_send_reset6(net, skb, xt_hooknum(par));
+		nf_send_reset6(net, par->state->sk, skb, xt_hooknum(par));
 		break;
 	case IP6T_ICMP6_POLICY_FAIL:
 		nf_send_unreach6(net, skb, ICMPV6_POLICY_FAIL, xt_hooknum(par));
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index bf95513736c92..832d9f9cd10ad 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -141,7 +141,8 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 	return 0;
 }
 
-void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
+void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		    int hook)
 {
 	struct net_device *br_indev __maybe_unused;
 	struct sk_buff *nskb;
@@ -233,7 +234,7 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 		dev_queue_xmit(nskb);
 	} else
 #endif
-		ip6_local_out(net, nskb->sk, nskb);
+		ip6_local_out(net, sk, nskb);
 }
 EXPORT_SYMBOL_GPL(nf_send_reset6);
 
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index c1098a1968e1e..7969d1f3018dc 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -28,7 +28,8 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 				 nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
+		nf_send_reset6(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+			       nft_hook(pkt));
 		break;
 	default:
 		break;
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index cf8f2646e93c6..36b219e2e896c 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -28,7 +28,8 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
+			nf_send_reset(nft_net(pkt), pkt->xt.state->sk,
+				      pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
 			nf_send_unreach(pkt->skb,
@@ -44,7 +45,8 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					 priv->icmp_code, nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
+			nf_send_reset6(nft_net(pkt), pkt->xt.state->sk,
+				       pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
 			nf_send_unreach6(nft_net(pkt), pkt->skb,
-- 
2.40.1



