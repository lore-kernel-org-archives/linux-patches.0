Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDE443901B;
	Tue, 21 Jul 2026 21:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669948; cv=none; b=sVa4eoUBdby5aYD+O0Ek7/RUSxGsfcC65PuqkT9B2P13pzg1/ayAh3xc1aqkE6uGHsz01iJvfEEZW3wfDKAoBE2iybJObFMklUpp90SBKUErZGj4OgLouQrLqAnKl2Ctct7+b0V2HO2fh7sPVWIUmFoEJv4Z2MvtDcrIVAQeoBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669948; c=relaxed/simple;
	bh=sDYXq3+htPyCn0R5yiU9FGKdhSQamlXveJXQCW2WLeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hjo9X6ApvaPhumdXBsv+i+cAbHI7hbYcIPTm/+z/ho1LGU4dXESeVl4Fr/6jnKqPVHADduybooS4UjtMD0zMV5m+04Ygs15fmAkjUt31CscowkCH2G0Boahw8YPYQOnffEBcxWmscXJjuoQlbJlu+tp4cehDi/UxsqWDmPU8Hq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0F7F8sa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0F7F8sa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926C81F000E9;
	Tue, 21 Jul 2026 21:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669947;
	bh=t3lMZfywt9ZjxqASR8EJZYZ8QNu2kNEWzO+KMUObKWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0F7F8sa3BYn8y+JkcGsVj/vDL/NAq2q//GwPw2y163NATPanA2C0ox5wR+ZgGr07N
	 ptTyIpw0vTRkawfOhZVdZXRnYJVxjBdcb++9GFi+2Ok3T13jhlqt4kOjCRk/BYf95+
	 hMQJ79IpZbolh3thfTV/Bw6BYSDfT1pCVDbU1x+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0704/1067] ipvs: pass parsed transport offset to state handlers
Date: Tue, 21 Jul 2026 17:21:45 +0200
Message-ID: <20260721152440.339680752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0b175ecd9562bd..35961160ebdec1 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -455,7 +455,8 @@ struct ip_vs_protocol {
 
 	void (*state_transition)(struct ip_vs_conn *cp, int direction,
 				 const struct sk_buff *skb,
-				 struct ip_vs_proto_data *pd);
+				 struct ip_vs_proto_data *pd,
+				 unsigned int iph_len);
 
 	int (*register_app)(struct netns_ipvs *ipvs, struct ip_vs_app *inc);
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index b5ae419661b804..da39cb7ade4940 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -220,10 +220,10 @@ ip_vs_conn_stats(struct ip_vs_conn *cp, struct ip_vs_service *svc)
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
@@ -625,7 +625,7 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 		ip_vs_in_stats(cp, skb);
 
 		/* set state */
-		ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
+		ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd, iph->len);
 
 		/* transmit the first SYN packet */
 		ret = cp->packet_xmit(skb, cp, pd->pp, iph);
@@ -1308,7 +1308,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 
 after_nat:
 	ip_vs_out_stats(cp, skb);
-	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd);
+	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd, iph->len);
 	skb->ipvs_property = 1;
 	if (!(cp->flags & IP_VS_CONN_F_NFCT))
 		ip_vs_notrack(skb);
@@ -2060,7 +2060,7 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
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
index ede4fa3b63f52d..dc8394383c148e 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -580,7 +580,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 static void
 tcp_state_transition(struct ip_vs_conn *cp, int direction,
 		     const struct sk_buff *skb,
-		     struct ip_vs_proto_data *pd)
+		     struct ip_vs_proto_data *pd,
+		     unsigned int iph_len)
 {
 	struct tcphdr _tcph, *th;
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index ffbebda547fc10..dbd4155bb07526 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -445,7 +445,8 @@ static const char * udp_state_name(int state)
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



