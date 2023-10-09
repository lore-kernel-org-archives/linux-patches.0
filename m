Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F48C28DD9
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSu/X8jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE540C433C7;
	Mon,  9 Oct 2023 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858719;
	bh=ZTS7FeudJkuUbsKRCtLDEyM7tyyoNpPpnvu9xmR9CiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSu/X8jmJc/3POVs1V7nWaSicsuRZBKk4WKHBHxTn5BYLxZGdd80dLJfNP58PapMl
	 p0b79qKwkknZHG0ExiwoEz1t2rGpx9uAfkdEM3sWtXlx17lwWL8ETW8lyYgfgTbEQH
	 zPNaCP19KRyMUFFIwlg7guIeGq5qD6Jp1XSPhduo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/226] netfilter: nf_tables: add and use nft_sk helper
Date: Mon,  9 Oct 2023 15:00:39 +0200
Message-ID: <20231009130128.827076229@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 85554eb981e5a8b0b8947611193aef1737081ef2 ]

This allows to change storage placement later on without changing readers.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 28427f368f0e ("netfilter: nft_exthdr: Fix non-linear header modification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h    | 5 +++++
 net/ipv4/netfilter/nft_reject_ipv4.c | 2 +-
 net/ipv6/netfilter/nft_reject_ipv6.c | 2 +-
 net/netfilter/nft_reject_inet.c      | 4 ++--
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5619642b9ad47..013f11c9de85a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -28,6 +28,11 @@ struct nft_pktinfo {
 	struct xt_action_param		xt;
 };
 
+static inline struct sock *nft_sk(const struct nft_pktinfo *pkt)
+{
+	return pkt->xt.state->sk;
+}
+
 static inline struct net *nft_net(const struct nft_pktinfo *pkt)
 {
 	return pkt->xt.state->net;
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index ff437e4ed6db0..55fc23a8f7a70 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -27,7 +27,7 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 		nf_send_unreach(pkt->skb, priv->icmp_code, nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+		nf_send_reset(nft_net(pkt), nft_sk(pkt), pkt->skb,
 			      nft_hook(pkt));
 		break;
 	default:
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index 7969d1f3018dc..ed69c768797ec 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -28,7 +28,7 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 				 nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset6(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+		nf_send_reset6(nft_net(pkt), nft_sk(pkt), pkt->skb,
 			       nft_hook(pkt));
 		break;
 	default:
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 36b219e2e896c..c00b94a166824 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -28,7 +28,7 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset(nft_net(pkt), pkt->xt.state->sk,
+			nf_send_reset(nft_net(pkt), nft_sk(pkt),
 				      pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
@@ -45,7 +45,7 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					 priv->icmp_code, nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset6(nft_net(pkt), pkt->xt.state->sk,
+			nf_send_reset6(nft_net(pkt), nft_sk(pkt),
 				       pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-- 
2.40.1



