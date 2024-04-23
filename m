Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B570320B3E;
	Tue, 23 Apr 2024 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908460; cv=none; b=nw+tRZ9nK+DFJashSUevxskgRt5ORwZsBd2Yp30qmYezUiJ/HwKhp7FK4TxpvZX7Y7ElLP66DP4mTU5yehSIm8kDpsyBzL64yMHpqmrehVdR2Oml6RItndG6LFVAaLWW24Vx3vqxIn5/Lfe5ybz38tJZEC6UGa5DyMFFkYb3Qdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908460; c=relaxed/simple;
	bh=AruY2WZSZrJdKY3QQphuoK2wRPEtzwuVH7h/XN0yvfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkyJkj+SGiwhAckqr351bLaUs5jt7TxXWp/dbO0ZBTCkEwtRXXdXJngcQYGLgEkJlEyG10X4tjA2gFvH5QmkBtxoDG9UW63GoBs4bxbTqr2pevad/AIaNf09L4BSixtjpVy/B4THVzsRHIqzU6uGA54cnwoaIzJy3JRTvSUgDek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/SeQdXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/SeQdXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348DFC3277B;
	Tue, 23 Apr 2024 21:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908460;
	bh=AruY2WZSZrJdKY3QQphuoK2wRPEtzwuVH7h/XN0yvfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/SeQdXPYZCaFikJBCBX449CKx3sDPW3QhyXYXToobhTPRaqr8JwV3zAwOS0DBggo
	 p8x0BPWgQlSSKmcN9KwwqySSq53rFX6rMoUqIE0aozhqRPavMvBrQuavbEOsmZrzox
	 ckIHEVORNjC+1LxCMyyxBE1lyaHT+XuCTlAARpMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b6f07e1c07ef40199081@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 020/158] netfilter: flowtable: validate pppoe header
Date: Tue, 23 Apr 2024 14:37:22 -0700
Message-ID: <20240423213856.519679240@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 87b3593bed1868b2d9fe096c01bcdf0ea86cbebf ]

Ensure there is sufficient room to access the protocol field of the
PPPoe header. Validate it once before the flowtable lookup, then use a
helper function to access protocol field.

Reported-by: syzbot+b6f07e1c07ef40199081@syzkaller.appspotmail.com
Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h | 12 +++++++++++-
 net/netfilter/nf_flow_table_inet.c    |  3 ++-
 net/netfilter/nf_flow_table_ip.c      |  8 +++++---
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a763dd327c6ea..9abb7ee40d72f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -336,7 +336,7 @@ int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
 
-static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
+static inline __be16 __nf_flow_pppoe_proto(const struct sk_buff *skb)
 {
 	__be16 proto;
 
@@ -352,6 +352,16 @@ static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
 	return 0;
 }
 
+static inline bool nf_flow_pppoe_proto(struct sk_buff *skb, __be16 *inner_proto)
+{
+	if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+		return false;
+
+	*inner_proto = __nf_flow_pppoe_proto(skb);
+
+	return true;
+}
+
 #define NF_FLOW_TABLE_STAT_INC(net, count) __this_cpu_inc((net)->ft.stat->count)
 #define NF_FLOW_TABLE_STAT_DEC(net, count) __this_cpu_dec((net)->ft.stat->count)
 #define NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count)	\
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 9505f9d188ff2..6eef15648b7b0 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -21,7 +21,8 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 		proto = veth->h_vlan_encapsulated_proto;
 		break;
 	case htons(ETH_P_PPP_SES):
-		proto = nf_flow_pppoe_proto(skb);
+		if (!nf_flow_pppoe_proto(skb, &proto))
+			return NF_ACCEPT;
 		break;
 	default:
 		proto = skb->protocol;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e45fade764096..9e9e105052dae 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -273,10 +273,11 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
+static bool nf_flow_skb_encap_protocol(struct sk_buff *skb, __be16 proto,
 				       u32 *offset)
 {
 	struct vlan_ethhdr *veth;
+	__be16 inner_proto;
 
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
@@ -287,7 +288,8 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 		}
 		break;
 	case htons(ETH_P_PPP_SES):
-		if (nf_flow_pppoe_proto(skb) == proto) {
+		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
+		    inner_proto == proto) {
 			*offset += PPPOE_SES_HLEN;
 			return true;
 		}
@@ -316,7 +318,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
 			skb_reset_network_header(skb);
 			break;
 		case htons(ETH_P_PPP_SES):
-			skb->protocol = nf_flow_pppoe_proto(skb);
+			skb->protocol = __nf_flow_pppoe_proto(skb);
 			skb_pull(skb, PPPOE_SES_HLEN);
 			skb_reset_network_header(skb);
 			break;
-- 
2.43.0



