Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA221C6AB;
	Mon,  4 Mar 2024 21:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589280; cv=none; b=SUxDTnyfjz8JGCSlSaBby5wuaBmtowYj/cPQ0lWGdyAq2hE/4kC4PNYM7RhDXvYHDXhZZ1xWZva7fM8fyMPjTG28vMgmTUSZJtFnWI1PARJ7CHT0l7eETeRjOsWjRgTEsYYIoSkRn4ak5lLnVyGLscf3G/1B6TMiH2YVJHAG6SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589280; c=relaxed/simple;
	bh=cO0/AbXNkljJN/DTTx3JdJ+roGkluPjdWllU40e5TNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bs7hHa8G3MK7j+i0+IzBkPMK4osRsCZvKHY7aIfbZyAyhXKf9VhHgjel0OMoTHzA1R2aS8h30AxupTIX2ettSPckVU6DvmnqF3U5I+qZ1CDzm833XStVx/0TLM4uRcUGd6QAWzBEwypMASTNwZW5ZTqS4pynIY6sVQ7emRxwfQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgN1WWFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgN1WWFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5859C433F1;
	Mon,  4 Mar 2024 21:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589280;
	bh=cO0/AbXNkljJN/DTTx3JdJ+roGkluPjdWllU40e5TNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgN1WWFEDxOgPktbTf48GfQgnLaEL+ud8ygT+9qWKMOG7CE8SHtoFeB7BLPQx/U9j
	 Ek8ILekwmxB3JAho+4Bemrb+0jSsXeUqdMzksQ6rzF8dsG9273GDfsP0tBC1+y9jC+
	 j4Exks1MuXqC4GGh05husecF/drCS/Ns6wEow0Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/84] netfilter: bridge: confirm multicast packets before passing them up the stack
Date: Mon,  4 Mar 2024 21:23:57 +0000
Message-ID: <20240304211543.131336821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 62e7151ae3eb465e0ab52a20c941ff33bb6332e9 ]

conntrack nf_confirm logic cannot handle cloned skbs referencing
the same nf_conn entry, which will happen for multicast (broadcast)
frames on bridges.

 Example:
    macvlan0
       |
      br0
     /  \
  ethX    ethY

 ethX (or Y) receives a L2 multicast or broadcast packet containing
 an IP packet, flow is not yet in conntrack table.

 1. skb passes through bridge and fake-ip (br_netfilter)Prerouting.
    -> skb->_nfct now references a unconfirmed entry
 2. skb is broad/mcast packet. bridge now passes clones out on each bridge
    interface.
 3. skb gets passed up the stack.
 4. In macvlan case, macvlan driver retains clone(s) of the mcast skb
    and schedules a work queue to send them out on the lower devices.

    The clone skb->_nfct is not a copy, it is the same entry as the
    original skb.  The macvlan rx handler then returns RX_HANDLER_PASS.
 5. Normal conntrack hooks (in NF_INET_LOCAL_IN) confirm the orig skb.

The Macvlan broadcast worker and normal confirm path will race.

This race will not happen if step 2 already confirmed a clone. In that
case later steps perform skb_clone() with skb->_nfct already confirmed (in
hash table).  This works fine.

But such confirmation won't happen when eb/ip/nftables rules dropped the
packets before they reached the nf_confirm step in postrouting.

Pablo points out that nf_conntrack_bridge doesn't allow use of stateful
nat, so we can safely discard the nf_conn entry and let inet call
conntrack again.

This doesn't work for bridge netfilter: skb could have a nat
transformation. Also bridge nf prevents re-invocation of inet prerouting
via 'sabotage_in' hook.

Work around this problem by explicit confirmation of the entry at LOCAL_IN
time, before upper layer has a chance to clone the unconfirmed entry.

The downside is that this disables NAT and conntrack helpers.

Alternative fix would be to add locking to all code parts that deal with
unconfirmed packets, but even if that could be done in a sane way this
opens up other problems, for example:

-m physdev --physdev-out eth0 -j SNAT --snat-to 1.2.3.4
-m physdev --physdev-out eth1 -j SNAT --snat-to 1.2.3.5

For multicast case, only one of such conflicting mappings will be
created, conntrack only handles 1:1 NAT mappings.

Users should set create a setup that explicitly marks such traffic
NOTRACK (conntrack bypass) to avoid this, but we cannot auto-bypass
them, ruleset might have accept rules for untracked traffic already,
so user-visible behaviour would change.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217777
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter.h                  |  1 +
 net/bridge/br_netfilter_hooks.c            | 96 ++++++++++++++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c | 30 +++++++
 net/netfilter/nf_conntrack_core.c          |  1 +
 4 files changed, 128 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index c92bb1580f419..c69cbd64b5b46 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -461,6 +461,7 @@ struct nf_ct_hook {
 			      const struct sk_buff *);
 	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 	void (*set_closing)(struct nf_conntrack *nfct);
+	int (*confirm)(struct sk_buff *skb);
 };
 extern const struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index f14beb9a62edb..8a114a5000466 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -43,6 +43,10 @@
 #include <linux/sysctl.h>
 #endif
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack_core.h>
+#endif
+
 static unsigned int brnf_net_id __read_mostly;
 
 struct brnf_net {
@@ -537,6 +541,90 @@ static unsigned int br_nf_pre_routing(void *priv,
 	return NF_STOLEN;
 }
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+/* conntracks' nf_confirm logic cannot handle cloned skbs referencing
+ * the same nf_conn entry, which will happen for multicast (broadcast)
+ * Frames on bridges.
+ *
+ * Example:
+ *      macvlan0
+ *      br0
+ *  ethX  ethY
+ *
+ * ethX (or Y) receives multicast or broadcast packet containing
+ * an IP packet, not yet in conntrack table.
+ *
+ * 1. skb passes through bridge and fake-ip (br_netfilter)Prerouting.
+ *    -> skb->_nfct now references a unconfirmed entry
+ * 2. skb is broad/mcast packet. bridge now passes clones out on each bridge
+ *    interface.
+ * 3. skb gets passed up the stack.
+ * 4. In macvlan case, macvlan driver retains clone(s) of the mcast skb
+ *    and schedules a work queue to send them out on the lower devices.
+ *
+ *    The clone skb->_nfct is not a copy, it is the same entry as the
+ *    original skb.  The macvlan rx handler then returns RX_HANDLER_PASS.
+ * 5. Normal conntrack hooks (in NF_INET_LOCAL_IN) confirm the orig skb.
+ *
+ * The Macvlan broadcast worker and normal confirm path will race.
+ *
+ * This race will not happen if step 2 already confirmed a clone. In that
+ * case later steps perform skb_clone() with skb->_nfct already confirmed (in
+ * hash table).  This works fine.
+ *
+ * But such confirmation won't happen when eb/ip/nftables rules dropped the
+ * packets before they reached the nf_confirm step in postrouting.
+ *
+ * Work around this problem by explicit confirmation of the entry at
+ * LOCAL_IN time, before upper layer has a chance to clone the unconfirmed
+ * entry.
+ *
+ */
+static unsigned int br_nf_local_in(void *priv,
+				   struct sk_buff *skb,
+				   const struct nf_hook_state *state)
+{
+	struct nf_conntrack *nfct = skb_nfct(skb);
+	const struct nf_ct_hook *ct_hook;
+	struct nf_conn *ct;
+	int ret;
+
+	if (!nfct || skb->pkt_type == PACKET_HOST)
+		return NF_ACCEPT;
+
+	ct = container_of(nfct, struct nf_conn, ct_general);
+	if (likely(nf_ct_is_confirmed(ct)))
+		return NF_ACCEPT;
+
+	WARN_ON_ONCE(skb_shared(skb));
+	WARN_ON_ONCE(refcount_read(&nfct->use) != 1);
+
+	/* We can't call nf_confirm here, it would create a dependency
+	 * on nf_conntrack module.
+	 */
+	ct_hook = rcu_dereference(nf_ct_hook);
+	if (!ct_hook) {
+		skb->_nfct = 0ul;
+		nf_conntrack_put(nfct);
+		return NF_ACCEPT;
+	}
+
+	nf_bridge_pull_encap_header(skb);
+	ret = ct_hook->confirm(skb);
+	switch (ret & NF_VERDICT_MASK) {
+	case NF_STOLEN:
+		return NF_STOLEN;
+	default:
+		nf_bridge_push_encap_header(skb);
+		break;
+	}
+
+	ct = container_of(nfct, struct nf_conn, ct_general);
+	WARN_ON_ONCE(!nf_ct_is_confirmed(ct));
+
+	return ret;
+}
+#endif
 
 /* PF_BRIDGE/FORWARD *************************************************/
 static int br_nf_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
@@ -935,6 +1023,14 @@ static const struct nf_hook_ops br_nf_ops[] = {
 		.hooknum = NF_BR_PRE_ROUTING,
 		.priority = NF_BR_PRI_BRNF,
 	},
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	{
+		.hook = br_nf_local_in,
+		.pf = NFPROTO_BRIDGE,
+		.hooknum = NF_BR_LOCAL_IN,
+		.priority = NF_BR_PRI_LAST,
+	},
+#endif
 	{
 		.hook = br_nf_forward_ip,
 		.pf = NFPROTO_BRIDGE,
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index d14b2dbbd1dfb..83743e95939b1 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -290,6 +290,30 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 	return nf_conntrack_in(skb, &bridge_state);
 }
 
+static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
+				    const struct nf_hook_state *state)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	if (skb->pkt_type == PACKET_HOST)
+		return NF_ACCEPT;
+
+	/* nf_conntrack_confirm() cannot handle concurrent clones,
+	 * this happens for broad/multicast frames with e.g. macvlan on top
+	 * of the bridge device.
+	 */
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct))
+		return NF_ACCEPT;
+
+	/* let inet prerouting call conntrack again */
+	skb->_nfct = 0;
+	nf_ct_put(ct);
+
+	return NF_ACCEPT;
+}
+
 static void nf_ct_bridge_frag_save(struct sk_buff *skb,
 				   struct nf_bridge_frag_data *data)
 {
@@ -414,6 +438,12 @@ static struct nf_hook_ops nf_ct_bridge_hook_ops[] __read_mostly = {
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
+	{
+		.hook		= nf_ct_bridge_in,
+		.pf		= NFPROTO_BRIDGE,
+		.hooknum	= NF_BR_LOCAL_IN,
+		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
+	},
 	{
 		.hook		= nf_ct_bridge_post,
 		.pf		= NFPROTO_BRIDGE,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e0f4f76439d3d..be6031886f942 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2850,6 +2850,7 @@ static const struct nf_ct_hook nf_conntrack_hook = {
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
 	.attach		= nf_conntrack_attach,
 	.set_closing	= nf_conntrack_set_closing,
+	.confirm	= __nf_conntrack_confirm,
 };
 
 void nf_conntrack_init_end(void)
-- 
2.43.0



