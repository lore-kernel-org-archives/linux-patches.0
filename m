Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004C21494D9;
	Fri,  6 Dec 2024 14:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496105; cv=none; b=H8DuNZwAPhN25OvhLbk1rYUtzrs/8QJsomeBoyNGAnOphBvWaULRtTk/zRtukV+yepQu9kk+M9VuiHHLGvDoHleQl0HvQR1G+qsaZ7Wg6qBBi74h0nA/cIRE7enXb7sBQsSv4WJThtAJ6fjU3sG98MtHHTiKFtCMVG8nCVVR68Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496105; c=relaxed/simple;
	bh=+UKWHvs1SHLmeptsjVj6287wsHzuoYgka/hT7immDqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f57Z3KjLOtGh9n+FFPmrRt0C88RfdX2cqk6QWUPYiS9LcXGIfSPfUIdXtaEfGqfU6LApYKM+Zh78h7NBGVTBkAo6rGLJ28FD4g3pJjz9YEItbyywV6ayi/HqY86Pq+SkQeHX8vbaK4dIp8EhDnzwQUfgVK/NC7+qudqXaKSUfNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlF0hQuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlF0hQuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EA6C4CEE0;
	Fri,  6 Dec 2024 14:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496104;
	bh=+UKWHvs1SHLmeptsjVj6287wsHzuoYgka/hT7immDqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlF0hQuBahYjmJ8eVtGxoSkz9uDCfmd894iP21k20J+Z1VnRHRQh1WBagsivzLTRq
	 y618Hses8+QfBIv3HurkS0DgXd5mB5OjSjN/gmUWZuINJ7DP09G+80conM6UNbF4rI
	 u2iBX8pe6N0vDWEOaXeMPhXKga43xet16F5VcShI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jrife@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.12 011/146] netkit: Add option for scrubbing skb meta data
Date: Fri,  6 Dec 2024 15:35:42 +0100
Message-ID: <20241206143528.104033290@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit 83134ef4609388f6b9ca31a384f531155196c2a7 upstream.

Jordan reported that when running Cilium with netkit in per-endpoint-routes
mode, network policy misclassifies traffic. In this direct routing mode
of Cilium which is used in case of GKE/EKS/AKS, the Pod's BPF program to
enforce policy sits on the netkit primary device's egress side.

The issue here is that in case of netkit's netkit_prep_forward(), it will
clear meta data such as skb->mark and skb->priority before executing the
BPF program. Thus, identity data stored in there from earlier BPF programs
(e.g. from tcx ingress on the physical device) gets cleared instead of
being made available for the primary's program to process. While for traffic
egressing the Pod via the peer device this might be desired, this is
different for the primary one where compared to tcx egress on the host
veth this information would be available.

To address this, add a new parameter for the device orchestration to
allow control of skb->mark and skb->priority scrubbing, to make the two
accessible from BPF (and eventually leave it up to the program to scrub).
By default, the current behavior is retained. For netkit peer this also
enables the use case where applications could cooperate/signal intent to
the BPF program.

Note that struct netkit has a 4 byte hole between policy and bundle which
is used here, in other words, struct netkit's first cacheline content used
in fast-path does not get moved around.

Fixes: 35dfaad7188c ("netkit, bpf: Add bpf programmable net device")
Reported-by: Jordan Rife <jrife@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://github.com/cilium/cilium/issues/34042
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20241004101335.117711-1-daniel@iogearbox.net
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netkit.c         |   68 ++++++++++++++++++++++++++++++++++---------
 include/uapi/linux/if_link.h |   15 +++++++++
 2 files changed, 70 insertions(+), 13 deletions(-)

--- a/drivers/net/netkit.c
+++ b/drivers/net/netkit.c
@@ -20,6 +20,7 @@ struct netkit {
 	struct net_device __rcu *peer;
 	struct bpf_mprog_entry __rcu *active;
 	enum netkit_action policy;
+	enum netkit_scrub scrub;
 	struct bpf_mprog_bundle	bundle;
 
 	/* Needed in slow-path */
@@ -50,12 +51,24 @@ netkit_run(const struct bpf_mprog_entry
 	return ret;
 }
 
-static void netkit_prep_forward(struct sk_buff *skb, bool xnet)
+static void netkit_xnet(struct sk_buff *skb)
 {
-	skb_scrub_packet(skb, xnet);
 	skb->priority = 0;
+	skb->mark = 0;
+}
+
+static void netkit_prep_forward(struct sk_buff *skb,
+				bool xnet, bool xnet_scrub)
+{
+	skb_scrub_packet(skb, false);
 	nf_skip_egress(skb, true);
 	skb_reset_mac_header(skb);
+	if (!xnet)
+		return;
+	ipvs_reset(skb);
+	skb_clear_tstamp(skb);
+	if (xnet_scrub)
+		netkit_xnet(skb);
 }
 
 static struct netkit *netkit_priv(const struct net_device *dev)
@@ -80,7 +93,8 @@ static netdev_tx_t netkit_xmit(struct sk
 		     !pskb_may_pull(skb, ETH_HLEN) ||
 		     skb_orphan_frags(skb, GFP_ATOMIC)))
 		goto drop;
-	netkit_prep_forward(skb, !net_eq(dev_net(dev), dev_net(peer)));
+	netkit_prep_forward(skb, !net_eq(dev_net(dev), dev_net(peer)),
+			    nk->scrub);
 	eth_skb_pkt_type(skb, peer);
 	skb->dev = peer;
 	entry = rcu_dereference(nk->active);
@@ -332,8 +346,10 @@ static int netkit_new_link(struct net *s
 			   struct netlink_ext_ack *extack)
 {
 	struct nlattr *peer_tb[IFLA_MAX + 1], **tbp = tb, *attr;
-	enum netkit_action default_prim = NETKIT_PASS;
-	enum netkit_action default_peer = NETKIT_PASS;
+	enum netkit_action policy_prim = NETKIT_PASS;
+	enum netkit_action policy_peer = NETKIT_PASS;
+	enum netkit_scrub scrub_prim = NETKIT_SCRUB_DEFAULT;
+	enum netkit_scrub scrub_peer = NETKIT_SCRUB_DEFAULT;
 	enum netkit_mode mode = NETKIT_L3;
 	unsigned char ifname_assign_type;
 	struct ifinfomsg *ifmp = NULL;
@@ -362,17 +378,21 @@ static int netkit_new_link(struct net *s
 				return err;
 			tbp = peer_tb;
 		}
+		if (data[IFLA_NETKIT_SCRUB])
+			scrub_prim = nla_get_u32(data[IFLA_NETKIT_SCRUB]);
+		if (data[IFLA_NETKIT_PEER_SCRUB])
+			scrub_peer = nla_get_u32(data[IFLA_NETKIT_PEER_SCRUB]);
 		if (data[IFLA_NETKIT_POLICY]) {
 			attr = data[IFLA_NETKIT_POLICY];
-			default_prim = nla_get_u32(attr);
-			err = netkit_check_policy(default_prim, attr, extack);
+			policy_prim = nla_get_u32(attr);
+			err = netkit_check_policy(policy_prim, attr, extack);
 			if (err < 0)
 				return err;
 		}
 		if (data[IFLA_NETKIT_PEER_POLICY]) {
 			attr = data[IFLA_NETKIT_PEER_POLICY];
-			default_peer = nla_get_u32(attr);
-			err = netkit_check_policy(default_peer, attr, extack);
+			policy_peer = nla_get_u32(attr);
+			err = netkit_check_policy(policy_peer, attr, extack);
 			if (err < 0)
 				return err;
 		}
@@ -409,7 +429,8 @@ static int netkit_new_link(struct net *s
 
 	nk = netkit_priv(peer);
 	nk->primary = false;
-	nk->policy = default_peer;
+	nk->policy = policy_peer;
+	nk->scrub = scrub_peer;
 	nk->mode = mode;
 	bpf_mprog_bundle_init(&nk->bundle);
 
@@ -434,7 +455,8 @@ static int netkit_new_link(struct net *s
 
 	nk = netkit_priv(dev);
 	nk->primary = true;
-	nk->policy = default_prim;
+	nk->policy = policy_prim;
+	nk->scrub = scrub_prim;
 	nk->mode = mode;
 	bpf_mprog_bundle_init(&nk->bundle);
 
@@ -874,6 +896,18 @@ static int netkit_change_link(struct net
 		return -EACCES;
 	}
 
+	if (data[IFLA_NETKIT_SCRUB]) {
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_NETKIT_SCRUB],
+				    "netkit scrubbing cannot be changed after device creation");
+		return -EACCES;
+	}
+
+	if (data[IFLA_NETKIT_PEER_SCRUB]) {
+		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_NETKIT_PEER_SCRUB],
+				    "netkit scrubbing cannot be changed after device creation");
+		return -EACCES;
+	}
+
 	if (data[IFLA_NETKIT_PEER_INFO]) {
 		NL_SET_ERR_MSG_ATTR(extack, data[IFLA_NETKIT_PEER_INFO],
 				    "netkit peer info cannot be changed after device creation");
@@ -908,8 +942,10 @@ static size_t netkit_get_size(const stru
 {
 	return nla_total_size(sizeof(u32)) + /* IFLA_NETKIT_POLICY */
 	       nla_total_size(sizeof(u32)) + /* IFLA_NETKIT_PEER_POLICY */
-	       nla_total_size(sizeof(u8))  + /* IFLA_NETKIT_PRIMARY */
+	       nla_total_size(sizeof(u32)) + /* IFLA_NETKIT_SCRUB */
+	       nla_total_size(sizeof(u32)) + /* IFLA_NETKIT_PEER_SCRUB */
 	       nla_total_size(sizeof(u32)) + /* IFLA_NETKIT_MODE */
+	       nla_total_size(sizeof(u8))  + /* IFLA_NETKIT_PRIMARY */
 	       0;
 }
 
@@ -924,11 +960,15 @@ static int netkit_fill_info(struct sk_bu
 		return -EMSGSIZE;
 	if (nla_put_u32(skb, IFLA_NETKIT_MODE, nk->mode))
 		return -EMSGSIZE;
+	if (nla_put_u32(skb, IFLA_NETKIT_SCRUB, nk->scrub))
+		return -EMSGSIZE;
 
 	if (peer) {
 		nk = netkit_priv(peer);
 		if (nla_put_u32(skb, IFLA_NETKIT_PEER_POLICY, nk->policy))
 			return -EMSGSIZE;
+		if (nla_put_u32(skb, IFLA_NETKIT_PEER_SCRUB, nk->scrub))
+			return -EMSGSIZE;
 	}
 
 	return 0;
@@ -936,9 +976,11 @@ static int netkit_fill_info(struct sk_bu
 
 static const struct nla_policy netkit_policy[IFLA_NETKIT_MAX + 1] = {
 	[IFLA_NETKIT_PEER_INFO]		= { .len = sizeof(struct ifinfomsg) },
-	[IFLA_NETKIT_POLICY]		= { .type = NLA_U32 },
 	[IFLA_NETKIT_MODE]		= { .type = NLA_U32 },
+	[IFLA_NETKIT_POLICY]		= { .type = NLA_U32 },
 	[IFLA_NETKIT_PEER_POLICY]	= { .type = NLA_U32 },
+	[IFLA_NETKIT_SCRUB]		= NLA_POLICY_MAX(NLA_U32, NETKIT_SCRUB_DEFAULT),
+	[IFLA_NETKIT_PEER_SCRUB]	= NLA_POLICY_MAX(NLA_U32, NETKIT_SCRUB_DEFAULT),
 	[IFLA_NETKIT_PRIMARY]		= { .type = NLA_REJECT,
 					    .reject_message = "Primary attribute is read-only" },
 };
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1292,6 +1292,19 @@ enum netkit_mode {
 	NETKIT_L3,
 };
 
+/* NETKIT_SCRUB_NONE leaves clearing skb->{mark,priority} up to
+ * the BPF program if attached. This also means the latter can
+ * consume the two fields if they were populated earlier.
+ *
+ * NETKIT_SCRUB_DEFAULT zeroes skb->{mark,priority} fields before
+ * invoking the attached BPF program when the peer device resides
+ * in a different network namespace. This is the default behavior.
+ */
+enum netkit_scrub {
+	NETKIT_SCRUB_NONE,
+	NETKIT_SCRUB_DEFAULT,
+};
+
 enum {
 	IFLA_NETKIT_UNSPEC,
 	IFLA_NETKIT_PEER_INFO,
@@ -1299,6 +1312,8 @@ enum {
 	IFLA_NETKIT_POLICY,
 	IFLA_NETKIT_PEER_POLICY,
 	IFLA_NETKIT_MODE,
+	IFLA_NETKIT_SCRUB,
+	IFLA_NETKIT_PEER_SCRUB,
 	__IFLA_NETKIT_MAX,
 };
 #define IFLA_NETKIT_MAX	(__IFLA_NETKIT_MAX - 1)


