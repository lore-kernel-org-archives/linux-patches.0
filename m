Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78D943B6D1;
	Thu, 30 Jul 2026 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422054; cv=none; b=evOpF/MilI5GGo4kcB7axNzhmSQ0j7KD0AmXRMkDfza7AU5ZX3X+6c/CDeer+sfa6X/8jtej9uKu310ffj9WsXMeIWNoM+wd+VrEHmooms3lstGLl4hct+lKutmxrJAZeRr9S11qJ7Ag9aJYNCGB8CxkPeeAX6jp58GzSCcakCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422054; c=relaxed/simple;
	bh=NVszQRwLakrPe8jJwXzWHGSTR5N3ok9PnR0AjUMTJ7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVkFezaC0r8QJ2hObrdumePc3Dyo9pP+hYWcgDld/K2MjDZZITMt1oGtsyt1QktgPlC2QgN8ackZrC1M0kz2/CsXcL6m9Jw0vCpXFUFlHn3a3TnQcBD9QzSG/K+nfaJbph0ko2OFJ+LwZLBevryJ0ZbJu4LMyzSR/Zc52hckDoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7QTpOmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7QTpOmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009401F000E9;
	Thu, 30 Jul 2026 14:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422053;
	bh=JyFVCANMKJZwYk1a1THbrixDaHXdlIkCfNmw6X+Q7a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7QTpOmvwJlZXXPg9DqBIR+wfc39+5Ag+l/CxNXIvEq2lmfqCNVqLyyG3H57PKHJE
	 w0wlS6Uf4FdFV50e5KbSzQqBFfm0l3OkN8Y6iqa1IMzRue6fd6ylExv+rtKa+KOF7t
	 aYiQ8TP0AAe7cI9vk3Fot5B+qtgaBOQzwzz3Kcdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 307/744] net: bridge: vlan: fix vlan range dumps starting with pvid
Date: Thu, 30 Jul 2026 16:09:40 +0200
Message-ID: <20260730141450.816097378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 43171c97e4714bf601b468401b37732244639c21 ]

There is a bug in all range dumps that rely on br_vlan_can_enter_range()
when the PVID is a range starting VLAN, all following VLANs that match
its flags can enter the range, but when the range is filled in only the
PVID VLAN is dumped and the rest of the range is discarded because
br_vlan_fill_vids() checks for the PVID flag. Since the PVID VLAN can
be only one, we need to break ranges around it, the best way to do that
consistently for all is to alter br_vlan_can_enter_range() to take into
account the PVID and return false to break the range when it's matched.

Before the fix:
$ ip l add br0 type bridge vlan_filtering 1
$ ip l add dumdum type dummy
$ ip l set dumdum master br0
$ ip l set br0 up
$ ip l set dumdum up
$ bridge vlan add dev dumdum vid 1 pvid untagged master
$ bridge vlan add dev dumdum vid 2 untagged master
$ bridge vlan show dev dumdum # use legacy dump to show all vlans
port              vlan-id
dumdum            1 PVID Egress Untagged
                  2 Egress Untagged

$ bridge -d vlan show dev dumdum # use the new dump (RTM_GETVLAN)
port              vlan-id
dumdum            1 PVID Egress Untagged
                    state forwarding mcast_router 1

VLAN 2 is missing, and if there are more matching VLANs afterwards
they'd be missing too.

After the fix:
[ same setup steps ]
$ bridge vlan show dev dumdum
port              vlan-id
dumdum            1 PVID Egress Untagged
                  2 Egress Untagged
$ bridge -d vlan show dev dumdum # use the new dump (RTM_GETVLAN)
port              vlan-id
dumdum            1 PVID Egress Untagged
                    state forwarding mcast_router 1
                  2 Egress Untagged
                    state forwarding mcast_router 1

Fixes: 0ab558795184 ("net: bridge: vlan: add rtm range support")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260721140922.682265-2-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink_tunnel.c |  3 ++-
 net/bridge/br_private.h        |  6 ++++--
 net/bridge/br_vlan.c           | 10 ++++++----
 net/bridge/br_vlan_options.c   |  3 +--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index 71a12da30004c7..a713668ea34f0e 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -271,7 +271,8 @@ static void __vlan_tunnel_handle_range(const struct net_bridge_port *p,
 	if (!*v_start)
 		goto out_init;
 
-	if (v && curr_change && br_vlan_can_enter_range(v, *v_end)) {
+	if (v && curr_change &&
+	    br_vlan_can_enter_range(v, *v_end, br_get_pvid(vg))) {
 		*v_end = v;
 		return;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bed1b1d9b28234..6b979a5cc424c8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1625,7 +1625,8 @@ void br_vlan_notify(const struct net_bridge *br,
 		    u16 vid, u16 vid_range,
 		    int cmd);
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-			     const struct net_bridge_vlan *range_end);
+			     const struct net_bridge_vlan *range_end,
+			     u16 pvid);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 				    struct net_device_path_ctx *ctx,
@@ -1872,7 +1873,8 @@ static inline void br_vlan_notify(const struct net_bridge *br,
 }
 
 static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-					   const struct net_bridge_vlan *range_end)
+					   const struct net_bridge_vlan *range_end,
+					   u16 pvid)
 {
 	return true;
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 84a180927eb73b..64a4151761d479 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1982,9 +1982,11 @@ void br_vlan_notify(const struct net_bridge *br,
 
 /* check if v_curr can enter a range ending in range_end */
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-			     const struct net_bridge_vlan *range_end)
+			     const struct net_bridge_vlan *range_end,
+			     u16 pvid)
 {
-	return v_curr->vid - range_end->vid == 1 &&
+	return v_curr->vid != pvid && range_end->vid != pvid &&
+	       v_curr->vid - range_end->vid == 1 &&
 	       range_end->flags == v_curr->flags &&
 	       br_vlan_opts_eq_range(v_curr, range_end);
 }
@@ -2066,8 +2068,8 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			idx += range_end->vid - range_start->vid + 1;
 
 			range_start = v;
-		} else if (dump_stats || v->vid == pvid ||
-			   !br_vlan_can_enter_range(v, range_end)) {
+		} else if (dump_stats ||
+			   !br_vlan_can_enter_range(v, range_end, pvid)) {
 			u16 vlan_flags = br_vlan_flags(range_start, pvid);
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 5514e1fc8d1faf..831e6d3a9c3bd7 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -330,8 +330,7 @@ int br_vlan_process_options(const struct net_bridge *br,
 				continue;
 			}
 
-			if (v->vid == pvid ||
-			    !br_vlan_can_enter_range(v, curr_end)) {
+			if (!br_vlan_can_enter_range(v, curr_end, pvid)) {
 				br_vlan_notify(br, p, curr_start->vid,
 					       curr_end->vid, RTM_NEWVLAN);
 				curr_start = v;
-- 
2.53.0



