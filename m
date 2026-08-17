Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35B8424D74;
	Mon, 17 Aug 2026 14:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976821; cv=none; b=miwAz7Ln0Ty/lpy8lXB+gMAtoO/zY43EblOWtt7Abt8nK+0UCYV0mEGVcoBMDOWQ1Oq8jRY0bH+cduJO7WAVE6m5tZK/ysN/e216wcVZCk9g4y2FGQB9mQ3Wljn8gsNCOKshWxjUY6CdkKkfA+D1GTeClLIRHSk1Y5UtpquySMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976821; c=relaxed/simple;
	bh=9AdZAH0ewwUKo4We/S94tBGh5jhfJP+SS2xMdaft4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT4M8OXpOOXOt6agM9B1PN1OvSFSsDFoYO4RSU/Y/nnqNuUI26ddiOYgAInvCxRmzFn2ILn9q4Xtyaec1FhOC5tv+TaMhvDD3uaNGmWjm3Koyo1D0zfTjhu8Wf4vZuWRrfKq8lZq5gPzVdPM5k+tWZZq9m1AcWjZDUZwlOhrkP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bji6PQez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bji6PQez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189661F000E9;
	Mon, 17 Aug 2026 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976819;
	bh=wQC+OqKVqi+eKFja+5zkZ0m1U1VzxGcvv8wxU5uSfEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bji6PQezczinKKo0kvRS3/UBmAMz1vp7SqybBArMK+11rkZ761u8yUgVbl7qrUA7D
	 xB0+pLFsVxcg5UWpswet88IBnSeAL1oX5G6WeVA9LhTjWn0/Vr1+sIRzgNaHD5uTjB
	 hQhd/6w3L/ihAyToAyvLJjTP2YQsP9XUUkNxg/Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/456] net: bridge: vlan: fix vlan range dumps starting with pvid
Date: Mon, 17 Aug 2026 15:28:26 +0200
Message-ID: <20260817132544.623244402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8914290c75d480..e4aab077527011 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -268,7 +268,8 @@ static void __vlan_tunnel_handle_range(const struct net_bridge_port *p,
 	if (!*v_start)
 		goto out_init;
 
-	if (v && curr_change && br_vlan_can_enter_range(v, *v_end)) {
+	if (v && curr_change &&
+	    br_vlan_can_enter_range(v, *v_end, br_get_pvid(vg))) {
 		*v_end = v;
 		return;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9a5479868489e9..62fdafbcc7e720 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1475,7 +1475,8 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 		   const void *ctx, bool adding, struct notifier_block *nb,
 		   struct netlink_ext_ack *extack);
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-			     const struct net_bridge_vlan *range_end);
+			     const struct net_bridge_vlan *range_end,
+			     u16 pvid);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 				    struct net_device_path_ctx *ctx,
@@ -1715,7 +1716,8 @@ static inline void br_vlan_notify(const struct net_bridge *br,
 }
 
 static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-					   const struct net_bridge_vlan *range_end)
+					   const struct net_bridge_vlan *range_end,
+					   u16 pvid)
 {
 	return true;
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 055d988d280cd6..5c41c6d00942d4 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1958,9 +1958,11 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 
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
@@ -2042,8 +2044,8 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			idx += range_end->vid - range_start->vid + 1;
 
 			range_start = v;
-		} else if (dump_stats || v->vid == pvid ||
-			   !br_vlan_can_enter_range(v, range_end)) {
+		} else if (dump_stats ||
+			   !br_vlan_can_enter_range(v, range_end, pvid)) {
 			u16 vlan_flags = br_vlan_flags(range_start, pvid);
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a6382973b3e701..87fe159efcf76e 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -262,8 +262,7 @@ int br_vlan_process_options(const struct net_bridge *br,
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



