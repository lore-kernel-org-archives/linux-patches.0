Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BC846D2B9;
	Tue, 21 Jul 2026 18:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658268; cv=none; b=i0isdTj6BPXr4Edj0j81hRoOTuPmRBErYA0lTa8RUyCZRljdMrX1EsXN6q+/QyJpGuFQ0WtQIz/7gDLdE614hjycmrrA+iEw7qj61kDW9mG9YGb73JyIiqvbFHI2LOC2N67sOJJ0IMvv4Y7hZw9y36ZK80vaR6MNT4en/L33QJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658268; c=relaxed/simple;
	bh=4PlnibktsL8vw3Ecwsm2O0B5ZVX8c45aKd5M1ZO7kls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Ap3t5TUxROCDlg4QWIXuU4n/ZWU/29Q19ZiGWftr6bhHOxrsXvO9YyBDjGz2qtPBrIUxqxWMQrZAnAwHLAy93MH95i20f7eTBe2C4xtdznrvA7FJvQ0tOUK5XvcP6nPkYLVLdPbCMRYVh7E4j6Ab3pYlGJQhAEv9OtyHDqg2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZ1EZvdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZ1EZvdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0581F00A3A;
	Tue, 21 Jul 2026 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658266;
	bh=hGhnSd5Wwd3KTKh6f2DUJKqF8mTrdXomhZHCkZb6E6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZ1EZvdUceKf+vc4h0IOon+ccuGawXzFtQj3Uf4JrZWNoszifHbk8xqQnMCt0QD8E
	 jbdhGqaB5Ox9N8Fn6qLVthaJJ0FMVL8X9t7OR9CJi8GN7ROXcs6W1yK1xiCwuyIW8P
	 /osNuhdJxwP+7IWPLs/7AQqxAlsqtl8o/ynHLm5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1080/1611] ipvs: pass parsed transport offset to state handlers
Date: Tue, 21 Jul 2026 17:19:56 +0200
Message-ID: <20260721152539.703109170@linuxfoundation.org>
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
index 2163f32ef6abc1..2be04ca409d1fa 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -516,7 +516,8 @@ struct ip_vs_protocol {
 
 	void (*state_transition)(struct ip_vs_conn *cp, int direction,
 				 const struct sk_buff *skb,
-				 struct ip_vs_proto_data *pd);
+				 struct ip_vs_proto_data *pd,
+				 unsigned int iph_len);
 
 	int (*register_app)(struct netns_ipvs *ipvs, struct ip_vs_app *inc);
 
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 5ea7ab8bf4dcc2..32e7230952102a 100644
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
@@ -1306,7 +1306,7 @@ handle_response(int af, struct sk_buff *skb, struct ip_vs_proto_data *pd,
 
 after_nat:
 	ip_vs_out_stats(cp, skb);
-	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd);
+	ip_vs_set_state(cp, IP_VS_DIR_OUTPUT, skb, pd, iph->len);
 	skb->ipvs_property = 1;
 	if (!(cp->flags & IP_VS_CONN_F_NFCT))
 		ip_vs_notrack(skb);
@@ -2055,7 +2055,7 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
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



