Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F216914389D;
	Tue, 23 Apr 2024 21:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908776; cv=none; b=NOV+1+IB+x5NUzsp9xAz8Gi8JRqcbti4uBTdL0LKmG3/cEHrDi8Aeb/2ZX/kqiqHYV97R48p3q181Ed/Wbw5NT44ne6eWmFRiH4m0WE0jhl7yUpkX2KCtjtzknmczyeZGOIVrk7c2LZ6F7TQqRtCvTJVH9/f5Ga9jFmrFopTbc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908776; c=relaxed/simple;
	bh=6gxcLYmE1kw3YFkNiR/95xQw9Wdo4Vr4oJ04jq8ToaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQd+k3mNwUWHfu+NS3NiFUrBbiPY3Nrg1QCYaQZh04afnFUv3l7rN+o0CmeQ1oCf5bHUz1Aix6mmJp6nvNGiL8pce6N8Zr63dOhBEoEdCYWjTnLaVDdE6Nvt6XDTlYk6XwAUWUEeEIzc3LBi1piMKaRX1FjV9AkudRbmkZcuDEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7rEEkTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7rEEkTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C437AC116B1;
	Tue, 23 Apr 2024 21:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908775;
	bh=6gxcLYmE1kw3YFkNiR/95xQw9Wdo4Vr4oJ04jq8ToaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7rEEkTffU36iLv68On+H7v30HwXMKuNWTW54Iw7vEzhToNKRaLWZyV0ZQZ0UAFq6
	 9mUcKYfiVC8Vi/9I9roK67hEYib5r0KMfnfp2B2pc/kBeDc6Xb5dqh2znrzF8uSTYQ
	 5o9LEiEHgiSoBuPop7CkSFlAtzmIaJFx3isZgAkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b6f07e1c07ef40199081@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/71] netfilter: flowtable: validate pppoe header
Date: Tue, 23 Apr 2024 14:39:33 -0700
Message-ID: <20240423213844.822388120@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6cc0cfbf69b86..8e98fb8edff8d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -318,7 +318,7 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 int nf_flow_table_offload_init(void);
 void nf_flow_table_offload_exit(void);
 
-static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
+static inline __be16 __nf_flow_pppoe_proto(const struct sk_buff *skb)
 {
 	__be16 proto;
 
@@ -334,6 +334,16 @@ static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
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
index 280fdd32965f6..6783ea220f8fe 100644
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
index 28026467b54cd..448956fb52f69 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -246,10 +246,11 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
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
@@ -260,7 +261,8 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
 		}
 		break;
 	case htons(ETH_P_PPP_SES):
-		if (nf_flow_pppoe_proto(skb) == proto) {
+		if (nf_flow_pppoe_proto(skb, &inner_proto) &&
+		    inner_proto == proto) {
 			*offset += PPPOE_SES_HLEN;
 			return true;
 		}
@@ -289,7 +291,7 @@ static void nf_flow_encap_pop(struct sk_buff *skb,
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



