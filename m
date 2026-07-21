Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F7638399A;
	Tue, 21 Jul 2026 17:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653874; cv=none; b=hApnXwaEnPQazWRTr7pRZnlMAHdJSw4tMj4LWyydi5W4LmFBGD7RbziEL8ukhUgnDC+jwU8yBNWw/XAvAKhj0wxqkWg3bjFtoCm79dweFi78RVdzawn1qZl6eG3e5P7+iFbnXCYcktBG+KuIzgo3LHIoeJaMEkyA0PW4gfLtnto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653874; c=relaxed/simple;
	bh=qJPBWuIUh9Yg9kiB1eNFVfycbHop1A0YHtErwi2yY0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuGOSWLHAD9DvoG7xXN2+FxIAhUie+7tniBlHcNLYpnctxIt8HfCq5RpvzxRXlGCxSW+AUhbJRM20QnroW+/ui35j4vC+ZwhilV41i525fQtkaw4KlVw7POJ2xLrrOJ9M7EmD+Q+HzS+U/5mePopCXWafgTa03pU/FdFeZsYsho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbqhOQbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbqhOQbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74011F000E9;
	Tue, 21 Jul 2026 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653872;
	bh=Om69oyHQi2UspRmPpRNCRNsOyTko4AXKIbV4Sj2JzhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbqhOQbsqA6EuUe2KUKBdbcxtQCli7nXrZWtotxm8lJ2eetoHfWdh1zSPTBXD4Xon
	 GZXU0AHg0taDbZxJj0Qd57grymFtfiwPTne1LtY6Zu6LLvBbGGy4kYwY99WsE113j5
	 q+gOkGZEj569ksIUIfIhA1jIdTphpK+/LLGHQhyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1492/2077] ipvs: pass parsed transport offset to state handlers
Date: Tue, 21 Jul 2026 17:19:25 +0200
Message-ID: <20260721152627.984658782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit bae7ce7bafb59e42dc0e0e2999fdd9d1cffe3866 ]

IPVS callers already parse the packet into struct ip_vs_iphdr before
updating connection state. For IPv6 this records the real
transport-header offset after extension headers in iph.len.

Pass this parsed transport offset through ip_vs_set_state() and the
protocol state_transition() callback so protocol handlers can use the
same packet context as scheduling and NAT handling. This patch only
changes the common callback plumbing and adapts the protocol callback
signatures; TCP and SCTP start using the value in follow-up patches.

Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 2500fa3958b1 ("ipvs: use parsed transport offset in TCP state lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h                   |  3 ++-
 net/netfilter/ipvs/ip_vs_core.c       | 10 +++++-----
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  3 ++-
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |  3 ++-
 net/netfilter/ipvs/ip_vs_proto_udp.c  |  3 ++-
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index e517eaaa177b02..62433e48b1f9a7 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -744,7 +744,8 @@ struct ip_vs_protocol {
 
 	void (*state_transition)(struct ip_vs_conn *cp, int direction,
 				 const struct sk_buff *skb,
-				 struct ip_vs_proto_data *pd);
+				 struct ip_vs_proto_data *pd,
+				 unsigned int iph_len);
 
 	int (*register_app)(struct netns_ipvs *ipvs, struct ip_vs_app *inc);
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d40b404c1bf646..bd90f03fe3a4a1 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -398,10 +398,10 @@ ip_vs_conn_stats(struct ip_vs_conn *cp, struct ip_vs_service *svc)
 static inline void
 ip_vs_set_state(struct ip_vs_conn *cp, int direction,
 		const struct sk_buff *skb,
-		struct ip_vs_proto_data *pd)
+		struct ip_vs_proto_data *pd, unsigned int iph_len)
 {
 	if (likely(pd->pp->state_transition))
-		pd->pp->state_transition(cp, direction, skb, pd);
+		pd->pp->state_transition(cp, direction, skb, pd, iph_len);
 }
 
 static inline int
@@ -803,7 +803,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 		ip_vs_in_stats(cp, skb);
 
 		/* set state */
-		ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
+		ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd, iph->len);
 
 		/* transmit the first SYN packet */
 		ret = cp->packet_xmit(skb, cp, pd->pp, iph);
@@ -1484,7 +1484,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 
 after_nat:
 	ip_vs_out_stats(cp, skb);
-	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd);
+	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd, iph->len);
 	skb->ipvs_property = 1;
 	if (!(cp->flags & IP_VS_CONN_F_NFCT))
 		ip_vs_notrack(skb);
@@ -2233,7 +2233,7 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 	IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
 
 	ip_vs_in_stats(cp, skb);
-	ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
+	ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd, iph.len);
 	if (cp->packet_xmit)
 		ret = cp->packet_xmit(skb, cp, pp, &iph);
 		/* do not touch skb anymore */
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 63c78a1f3918a7..394367b7b38879 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -468,7 +468,8 @@ set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 
 static void
 sctp_state_transition(struct ip_vs_conn *cp, int direction,
-		const struct sk_buff *skb, struct ip_vs_proto_data *pd)
+		const struct sk_buff *skb, struct ip_vs_proto_data *pd,
+		unsigned int iph_len)
 {
 	spin_lock_bh(&cp->lock);
 	set_sctp_state(pd, cp, direction, skb);
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 8cc0a8ce624112..2d3f6aeafe522d 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -579,7 +579,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 static void
 tcp_state_transition(struct ip_vs_conn *cp, int direction,
 		     const struct sk_buff *skb,
-		     struct ip_vs_proto_data *pd)
+		     struct ip_vs_proto_data *pd,
+		     unsigned int iph_len)
 {
 	struct tcphdr _tcph, *th;
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index f9de632e38cdd6..58f9e255927e2e 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -444,7 +444,8 @@ static const char * udp_state_name(int state)
 static void
 udp_state_transition(struct ip_vs_conn *cp, int direction,
 		     const struct sk_buff *skb,
-		     struct ip_vs_proto_data *pd)
+		     struct ip_vs_proto_data *pd,
+		     unsigned int iph_len)
 {
 	if (unlikely(!pd)) {
 		pr_err("UDP no ns data\n");
-- 
2.53.0



