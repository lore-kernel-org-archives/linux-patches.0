Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9A33DC857;
	Mon, 17 Aug 2026 14:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975612; cv=none; b=IlY6sXv/EiOIPPXmG5P6u+sEYWhAsAKkTsEXafR8+RLz2sH5ZNujNF5JtY8rr1rKOeBubsnYzYwW2ma5oL7IAjJ9zqCKMILYuMnaSxnbuFRB+tQFDmKw+1t9jPa8aqbnfHQ6vy3+EXT48axDwxTdVtASQ42bWTFSfO258Ykm4WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975612; c=relaxed/simple;
	bh=GIBVUF2JEt2FyS9cXEv2doLJUEjdoALPMLpp5AxWqQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVJ7vHwGvEozQBYBnuNsMybBY32Ti+yBk5/DLM70Pqb3zWP++sH8bzWsHsL+Zl6rYaMWUA6NmzbfulW5RgpsjjMlC8ei3+D/JLy9xAz7oI4iMVbxInOCRaQlLxWyf5mjFzQ1QqgD4oERPu2mqBFCxKMDZSFdByNR/PN1IU2UYGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCjKX07v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCjKX07v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DE51F000E9;
	Mon, 17 Aug 2026 14:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975610;
	bh=t+kFgDAbtLwWvJQR7o07kSLTQ8EZTuoFX/8t6//G0k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCjKX07vxCYuXvAX/8NO9GV4g0eAoeTqaMkLJO4QuUMFTLsqEP7bttD8xJCdDeBnh
	 Oegcv2dtLiDJjmUPcFGe8FJNhZG4HgjjKhCwCbZPcj2/8AEm7gqTqApPKYHW9TvDH7
	 1iVLiwlvC5Kogm+iY9R2PGNFP/VVRRPVkqeReQW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/389] net: bridge: vlan: add support for dumping global vlan options
Date: Mon, 17 Aug 2026 15:28:46 +0200
Message-ID: <20260817132542.501198791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <nikolay@nvidia.com>

[ Upstream commit 743a53d9636aad83da63a8638e8365e817ef6365 ]

Add a new vlan options dump flag which causes only global vlan options
to be dumped. The dumps are done only with bridge devices, ports are
ignored. They support vlan compression if the options in sequential
vlans are equal (currently always true).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 43171c97e471 ("net: bridge: vlan: fix vlan range dumps starting with pvid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  4 ++++
 net/bridge/br_vlan.c           | 41 +++++++++++++++++++++++++++-------
 net/bridge/br_vlan_options.c   | 31 +++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index f56e9114558299..e4a94f5c3a147f 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -354,6 +354,7 @@ enum {
 
 /* flags used in BRIDGE_VLANDB_DUMP_FLAGS attribute to affect dumps */
 #define BRIDGE_VLANDB_DUMPF_STATS	(1 << 0) /* Include stats in the dump */
+#define BRIDGE_VLANDB_DUMPF_GLOBAL	(1 << 1) /* Dump global vlan options only */
 
 /* Bridge vlan RTM attributes
  * [BRIDGE_VLANDB_ENTRY] = {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bd68d049c5fd93..b3a98ae8fbd619 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1331,6 +1331,10 @@ int br_vlan_rtm_process_global_options(struct net_device *dev,
 				       const struct nlattr *attr,
 				       int cmd,
 				       struct netlink_ext_ack *extack);
+bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
+					 const struct net_bridge_vlan *r_end);
+bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
+			      const struct net_bridge_vlan *v_opts);
 
 /* vlan state manipulation helpers using *_ONCE to annotate lock-free access */
 static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 0bd5a168943fd1..258702134d9bfc 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1777,6 +1777,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			    u32 dump_flags)
 {
 	struct net_bridge_vlan *v, *range_start = NULL, *range_end = NULL;
+	bool dump_global = !!(dump_flags & BRIDGE_VLANDB_DUMPF_GLOBAL);
 	bool dump_stats = !!(dump_flags & BRIDGE_VLANDB_DUMPF_STATS);
 	struct net_bridge_vlan_group *vg;
 	int idx = 0, s_idx = cb->args[1];
@@ -1795,6 +1796,10 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 		vg = br_vlan_group_rcu(br);
 		p = NULL;
 	} else {
+		/* global options are dumped only for bridge devices */
+		if (dump_global)
+			return 0;
+
 		p = br_port_get_rcu(dev);
 		if (WARN_ON(!p))
 			return -EINVAL;
@@ -1817,7 +1822,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 
 	/* idx must stay at range's beginning until it is filled in */
 	list_for_each_entry_rcu(v, &vg->vlan_list, vlist) {
-		if (!br_vlan_should_use(v))
+		if (!dump_global && !br_vlan_should_use(v))
 			continue;
 		if (idx < s_idx) {
 			idx++;
@@ -1830,8 +1835,21 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			continue;
 		}
 
-		if (dump_stats || v->vid == pvid ||
-		    !br_vlan_can_enter_range(v, range_end)) {
+		if (dump_global) {
+			if (br_vlan_global_opts_can_enter_range(v, range_end))
+				continue;
+			if (!br_vlan_global_opts_fill(skb, range_start->vid,
+						      range_end->vid,
+						      range_start)) {
+				err = -EMSGSIZE;
+				break;
+			}
+			/* advance number of filled vlans */
+			idx += range_end->vid - range_start->vid + 1;
+
+			range_start = v;
+		} else if (dump_stats || v->vid == pvid ||
+			   !br_vlan_can_enter_range(v, range_end)) {
 			u16 vlan_flags = br_vlan_flags(range_start, pvid);
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
@@ -1853,11 +1871,18 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 	 * - last vlan (range_start == range_end, not in range)
 	 * - last vlan range (range_start != range_end, in range)
 	 */
-	if (!err && range_start &&
-	    !br_vlan_fill_vids(skb, range_start->vid, range_end->vid,
-			       range_start, br_vlan_flags(range_start, pvid),
-			       dump_stats))
-		err = -EMSGSIZE;
+	if (!err && range_start) {
+		if (dump_global &&
+		    !br_vlan_global_opts_fill(skb, range_start->vid,
+					      range_end->vid, range_start))
+			err = -EMSGSIZE;
+		else if (!dump_global &&
+			 !br_vlan_fill_vids(skb, range_start->vid,
+					    range_end->vid, range_start,
+					    br_vlan_flags(range_start, pvid),
+					    dump_stats))
+			err = -EMSGSIZE;
+	}
 
 	cb->args[1] = err ? idx : 0;
 
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a7d5a233420732..f290f514054714 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -259,6 +259,37 @@ int br_vlan_process_options(const struct net_bridge *br,
 	return err;
 }
 
+bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
+					 const struct net_bridge_vlan *r_end)
+{
+	return v_curr->vid - r_end->vid == 1;
+}
+
+bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
+			      const struct net_bridge_vlan *v_opts)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, BRIDGE_VLANDB_GLOBAL_OPTIONS);
+	if (!nest)
+		return false;
+
+	if (nla_put_u16(skb, BRIDGE_VLANDB_GOPTS_ID, vid))
+		goto out_err;
+
+	if (vid_range && vid < vid_range &&
+	    nla_put_u16(skb, BRIDGE_VLANDB_GOPTS_RANGE, vid_range))
+		goto out_err;
+
+	nla_nest_end(skb, nest);
+
+	return true;
+
+out_err:
+	nla_nest_cancel(skb, nest);
+	return false;
+}
+
 static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 					   struct net_bridge_vlan_group *vg,
 					   struct net_bridge_vlan *v,
-- 
2.53.0



