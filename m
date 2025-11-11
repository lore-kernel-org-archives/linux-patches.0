Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B1033FE22;
	Tue, 11 Nov 2025 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825431; cv=none; b=Ay+meFmiGfV6tVtdphHQutiKlVu6/9/O5ZuHZi4pREz8dyOD6/kIp5VdI21C/c0FFioNC8M+V0EJOw5dCSQ2OFiK8zDu64GJqb2y7klh1fwX52FzjSY+pqBjen64l/TzWx+WDy669Y0xeqbOp1AzUazk7CN+RBMbvjO3ue/PWLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825431; c=relaxed/simple;
	bh=pDzhzv2uDXmVghxw7VbDOEnd0yPaQ9R3kRz1ughru/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCcmyAvasTlQ+GEhnn0hqQgigBshVJsupoaZ+Ni/1SauJDett4yRuGQpUcJ7/Wo+dzyauYVp8PLmAqBNtbT7zrmKmXzQuKmvqgaH46JTZDjhyxIpsHq/gHm6YYbL75dDj9pLJ9lB9FH+RIkrQPxdV2+IFsmUuQ6epS+iGWzPLRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rowUU1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rowUU1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5C3C116B1;
	Tue, 11 Nov 2025 01:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825431;
	bh=pDzhzv2uDXmVghxw7VbDOEnd0yPaQ9R3kRz1ughru/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rowUU1d++QRU7VrOfeOp0Kzdfu0BrWH5lgSj05TACz9DGq4Pzey8ggtdXCdWClL/
	 4569rEf26HQwyaeDUJ9VU/ZHyzlnlGoumcfHh/cgrHKuuNjAf46Hj5qOplGwgx+USE
	 vXDwIYLGeGn8kT31EhrBqji/kMdvyNiQUZk/b6Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dd280197f0f7ab3917be@syzkaller.appspotmail.com,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 797/849] net: bridge: fix use-after-free due to MST port state bypass
Date: Tue, 11 Nov 2025 09:46:07 +0900
Message-ID: <20251111004555.701741588@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 870bdf2e082c4..dea09096ad0fb 100644
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
index 5f6ac9bf15275..c07265b365b10 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -94,7 +94,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 
 	br = p->br;
 
-	if (br_mst_is_enabled(br)) {
+	if (br_mst_is_enabled(p)) {
 		state = BR_STATE_FORWARDING;
 	} else {
 		if (p->state == BR_STATE_DISABLED) {
@@ -421,7 +421,7 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		return RX_HANDLER_PASS;
 
 forward:
-	if (br_mst_is_enabled(p->br))
+	if (br_mst_is_enabled(p))
 		goto defer_stp_filtering;
 
 	switch (p->state) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 8de0904b9627f..fdaf7d8374639 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1932,10 +1932,12 @@ static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
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
@@ -1950,7 +1952,7 @@ int br_mst_fill_info(struct sk_buff *skb,
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



