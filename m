Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD51733F38B;
	Fri, 21 Nov 2025 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733120; cv=none; b=ddquZu2WOI5wwU9k7YYDP8LT6xyCYt7WV4azEpuZq9ISMgsto3y5Ch+sRl84DDNNck00r/jIjvoBRJlrCnea4lZ83Qbr6jIugKqP7n9TOfqI2dQbeTcQA2EKZilDbDOM8Co+7FZ1gVAf62KZ3WKnekTQix4T1zpeCBwsjWp3pfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733120; c=relaxed/simple;
	bh=d0jp65xFVoSP+yB/98YMHzDdpXWymVvfMnEM3pSUuTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzZxpJx1OFdhNYkjs3/jBnEfzuuTjiVQdCwPON9sD8HwzdrYPsgr8XdmtzghTuQfjWUi+CfRXTCALK2xD/5127Fg+qglXaskJI5PNDvTfY/SG99/el5q8R2WuzleQ4FvwlFXnQFe8bJ8tEXB7GOcpAhxJF/Q1Tn9XL7vcLDol10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q416pXpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q416pXpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4607AC4CEF1;
	Fri, 21 Nov 2025 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733120;
	bh=d0jp65xFVoSP+yB/98YMHzDdpXWymVvfMnEM3pSUuTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q416pXpthQ9oi1QBAROUU8A6laTcIn5mp57q5cJcF5Xka3TacWLBFC+hfOg18dz65
	 hPOu0D4PGlOLvqJGKxCIZuhKZZg0af2zs/2gN65zZJnMAMTXG2/PfRdN50A6IeiiYj
	 Vsd7AV9Ifw0D7/iOHEABk2m3DPg9y1ESIPh7RGRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dd280197f0f7ab3917be@syzkaller.appspotmail.com,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 359/529] net: bridge: fix use-after-free due to MST port state bypass
Date: Fri, 21 Nov 2025 14:10:58 +0100
Message-ID: <20251121130243.801600669@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 8dca36978aa80bab9d4da130c211db75c9e00048 ]

syzbot reported[1] a use-after-free when deleting an expired fdb. It is
due to a race condition between learning still happening and a port being
deleted, after all its fdbs have been flushed. The port's state has been
toggled to disabled so no learning should happen at that time, but if we
have MST enabled, it will bypass the port's state, that together with VLAN
filtering disabled can lead to fdb learning at a time when it shouldn't
happen while the port is being deleted. VLAN filtering must be disabled
because we flush the port VLANs when it's being deleted which will stop
learning. This fix adds a check for the port's vlan group which is
initialized to NULL when the port is getting deleted, that avoids the port
state bypass. When MST is enabled there would be a minimal new overhead
in the fast-path because the port's vlan group pointer is cache-hot.

[1] https://syzkaller.appspot.com/bug?extid=dd280197f0f7ab3917be

Fixes: ec7328b59176 ("net: bridge: mst: Multiple Spanning Tree (MST) mode")
Reported-by: syzbot+dd280197f0f7ab3917be@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/69088ffa.050a0220.29fc44.003d.GAE@google.com/
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251105111919.1499702-2-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_forward.c | 2 +-
 net/bridge/br_input.c   | 4 ++--
 net/bridge/br_private.h | 8 +++++---
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 49dd8cd526f46..e9f09cdb9848e 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -25,7 +25,7 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 	vg = nbp_vlan_group_rcu(p);
 	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
-		(br_mst_is_enabled(p->br) || p->state == BR_STATE_FORWARDING) &&
+		(br_mst_is_enabled(p) || p->state == BR_STATE_FORWARDING) &&
 		br_allowed_egress(vg, skb) && nbp_switchdev_allowed_egress(p, skb) &&
 		!br_skb_isolated(p, skb);
 }
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e09000e38d071..951330c1a813b 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -93,7 +93,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 
 	br = p->br;
 
-	if (br_mst_is_enabled(br)) {
+	if (br_mst_is_enabled(p)) {
 		state = BR_STATE_FORWARDING;
 	} else {
 		if (p->state == BR_STATE_DISABLED)
@@ -411,7 +411,7 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 
 forward:
-	if (br_mst_is_enabled(p->br))
+	if (br_mst_is_enabled(p))
 		goto defer_stp_filtering;
 
 	switch (p->state) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ef98ec4c3f51d..798960ef2dcd0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1880,10 +1880,12 @@ static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
 /* br_mst.c */
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 DECLARE_STATIC_KEY_FALSE(br_mst_used);
-static inline bool br_mst_is_enabled(struct net_bridge *br)
+static inline bool br_mst_is_enabled(const struct net_bridge_port *p)
 {
+	/* check the port's vlan group to avoid racing with port deletion */
 	return static_branch_unlikely(&br_mst_used) &&
-		br_opt_get(br, BROPT_MST_ENABLED);
+	       br_opt_get(p->br, BROPT_MST_ENABLED) &&
+	       rcu_access_pointer(p->vlgrp);
 }
 
 int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
@@ -1898,7 +1900,7 @@ int br_mst_fill_info(struct sk_buff *skb,
 int br_mst_process(struct net_bridge_port *p, const struct nlattr *mst_attr,
 		   struct netlink_ext_ack *extack);
 #else
-static inline bool br_mst_is_enabled(struct net_bridge *br)
+static inline bool br_mst_is_enabled(const struct net_bridge_port *p)
 {
 	return false;
 }
-- 
2.51.0



