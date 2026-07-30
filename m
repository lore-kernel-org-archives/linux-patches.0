Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D08392C2C;
	Thu, 30 Jul 2026 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427546; cv=none; b=T3PeeahzaesYB1GxRzBzGpxUnr/dWIspmBe2Sa4MMumZ2c/2o0I73HiMyH3EORflmOkpT8ZvYRKio6RFRLF28SYt0AsWhLHEqv+Xl/DfqbOjt2BwUJ/IY30Je//rQMA10IPrNJy5pf7iLkyKz54tWFAjSSfCnjeOGajwq5tFaus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427546; c=relaxed/simple;
	bh=aj4yK0Bdeh8Cmfet/sEkZoIaqTs0MqI8m8zKxbcP++M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBzgsS9pCnUiqdp0ifl4sKLmPy5tgEOzG4YqI50gHatmVyD7PyyZHtQeB+IS1rgkL9fwomPchxPjW7S0IEfD8q0lG9lAlcV3QGLFqggwusYIGUUAhiwcHEmU+jsoOAY/kLiF//+KJ966WMVsfv77a3U5DULA0m+WWPOUVE6+Z6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHMSGnbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHMSGnbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F60E1F000E9;
	Thu, 30 Jul 2026 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427545;
	bh=QKRcIpGmmYqbyZ+ypyIII3jgrdfMnT8+YqNxcTzj61Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHMSGnbxtIHjs1cDUAiX+EaKL1RxhpzEYrt2ELCndJuL9zFjOhuOXTvUhP5HOBvjq
	 EvM/lKt8yLM29BnCP83j3IuDhgrADBIrnSxP/Cr2OZ8H6PftNVIZPNbdT+W8K26Zgt
	 BfSfyn/Cfy2KtS80kTqE2MzyyDpHokLEaWGrbUlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/484] net: bridge: vlan: fix vlan range dumps starting with pvid
Date: Thu, 30 Jul 2026 16:11:18 +0200
Message-ID: <20260730141427.400336504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 17abf092f7cac1..b006d1127c5495 100644
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
index f0d8edc378a0eb..4867464bde32b6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1563,7 +1563,8 @@ void br_vlan_notify(const struct net_bridge *br,
 		    u16 vid, u16 vid_range,
 		    int cmd);
 bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-			     const struct net_bridge_vlan *range_end);
+			     const struct net_bridge_vlan *range_end,
+			     u16 pvid);
 
 void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 				    struct net_device_path_ctx *ctx,
@@ -1804,7 +1805,8 @@ static inline void br_vlan_notify(const struct net_bridge *br,
 }
 
 static inline bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
-					   const struct net_bridge_vlan *range_end)
+					   const struct net_bridge_vlan *range_end,
+					   u16 pvid)
 {
 	return true;
 }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index cc54b8267bcc7b..171d1dddb26a81 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1943,9 +1943,11 @@ void br_vlan_notify(const struct net_bridge *br,
 
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
@@ -2027,8 +2029,8 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			idx += range_end->vid - range_start->vid + 1;
 
 			range_start = v;
-		} else if (dump_stats || v->vid == pvid ||
-			   !br_vlan_can_enter_range(v, range_end)) {
+		} else if (dump_stats ||
+			   !br_vlan_can_enter_range(v, range_end, pvid)) {
 			u16 vlan_flags = br_vlan_flags(range_start, pvid);
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 8fa89b04ee942d..4a736e005bad7e 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -310,8 +310,7 @@ int br_vlan_process_options(const struct net_bridge *br,
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



