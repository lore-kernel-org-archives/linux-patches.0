Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA6836EA89;
	Tue, 10 Mar 2026 11:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141203; cv=none; b=j4Be0O13TuPdTmneKkchbdRM7zGZsFlIPJsqK35Q8ciaNqlDftoGOqDg2KbF1avpcDopnpt0ho3C55s4OHhli7vIGWrT/pyvQLl1xvK360GLgkGbdXga0RWWLeV664pm0agWEx5epYKRvAUlcnqsfQaJG6cn+s+0vhQabzDh7ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141203; c=relaxed/simple;
	bh=IiPbt6myBTCrcbxBYqOxZlgTLMyicfj5crT4h8KqJNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6SuLuBd+DuuXS2xihIU3yBqh3h9JEv7A7J8GXsQpyf6nGd3mAnOWolrGrnJqlsQ4g08tlnSPWOPCEOvsRsb6X2ydcfz6HKx6KIGo9IfFTNgxC2roAquleahSxg21GXYiaedTX4dt6BiIzP45hVaozmDV+Ndl0sFflBDxrQwJN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A54kVb6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A54kVb6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4641CC19423;
	Tue, 10 Mar 2026 11:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141203;
	bh=IiPbt6myBTCrcbxBYqOxZlgTLMyicfj5crT4h8KqJNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A54kVb6VvnBtrMLHJ4621Z8r4ODN0SU73A27PhkYugpbYIAYg4be6pj958ep+BI1E
	 kpnv+MECg7QaZIw2hCHqeVSuG5LbLl1fHYhEE2VE4gbn7U3eqCj4Fu32y7PqdSI1XN
	 NQEuZ9Wwl/meUnnajgSMZASFp3He+/x0MA7yAcZF00tUqIir8aXqvMpS19X297NpxE
	 SxeDkxUTKR4PNzKZQ+jioDPPducHrW7bq7SINghKaym41zmAjpKd0zrqyEKRIAMJgs
	 SNlaVtmB6tu/xeecmIYmywkIbnkcTnPMHB1ccDz77NEbA2yOkArYoiU02yhFZC5DCo
	 q1kbUVrRMnrLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 203/311] bridge: Check relevant per-VLAN options in VLAN range grouping
Date: Tue, 10 Mar 2026 07:04:10 -0400
Message-ID: <1d682d0f963928ce778cf7598fc0b58938b3b9b1.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 93c9475c04acad2457a7e7ea4e3ec40a6e6d94a7 ]

The br_vlan_opts_eq_range() function determines if consecutive VLANs can
be grouped together in a range for compact netlink notifications. It
currently checks state, tunnel info, and multicast router configuration,
but misses two categories of per-VLAN options that affect the output:
1. User-visible priv_flags (neigh_suppress, mcast_enabled)
2. Port multicast context (mcast_max_groups, mcast_n_groups)

When VLANs have different settings for these options, they are incorrectly
grouped into ranges, causing netlink notifications to report only one
VLAN's settings for the entire range.

Fix by checking priv_flags equality, but only for flags that affect netlink
output (BR_VLFLAG_NEIGH_SUPPRESS_ENABLED and BR_VLFLAG_MCAST_ENABLED),
and comparing multicast context (mcast_max_groups and mcast_n_groups).

Example showing the bugs before the fix:

$ bridge vlan set vid 10 dev dummy1 neigh_suppress on
$ bridge vlan set vid 11 dev dummy1 neigh_suppress off
$ bridge -d vlan show dev dummy1
  port             vlan-id
  dummy1           10-11
                      ... neigh_suppress on

$ bridge vlan set vid 10 dev dummy1 mcast_max_groups 100
$ bridge vlan set vid 11 dev dummy1 mcast_max_groups 200
$ bridge -d vlan show dev dummy1
  port             vlan-id
  dummy1           10-11
                      ... mcast_max_groups 100

After the fix, VLANs 10 and 11 are shown as separate entries with their
correct individual settings.

Fixes: a1aee20d5db2 ("net: bridge: Add netlink knobs for number / maximum MDB entries")
Fixes: 83f6d600796c ("bridge: vlan: Allow setting VLAN neighbor suppression state")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260225143956.3995415-2-danieller@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_private.h      | 10 ++++++++++
 net/bridge/br_vlan_options.c | 26 +++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b9b2981c48414..9b55d38ea9edb 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1344,6 +1344,16 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       true;
 }
 
+static inline bool
+br_multicast_port_ctx_options_equal(const struct net_bridge_mcast_port *pmctx1,
+				    const struct net_bridge_mcast_port *pmctx2)
+{
+	return br_multicast_ngroups_get(pmctx1) ==
+	       br_multicast_ngroups_get(pmctx2) &&
+	       br_multicast_ngroups_get_max(pmctx1) ==
+	       br_multicast_ngroups_get_max(pmctx2);
+}
+
 static inline bool
 br_multicast_ctx_matches_vlan_snooping(const struct net_bridge_mcast *brmctx)
 {
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 8fa89b04ee942..5514e1fc8d1fa 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -43,9 +43,29 @@ bool br_vlan_opts_eq_range(const struct net_bridge_vlan *v_curr,
 	u8 range_mc_rtr = br_vlan_multicast_router(range_end);
 	u8 curr_mc_rtr = br_vlan_multicast_router(v_curr);
 
-	return v_curr->state == range_end->state &&
-	       __vlan_tun_can_enter_range(v_curr, range_end) &&
-	       curr_mc_rtr == range_mc_rtr;
+	if (v_curr->state != range_end->state)
+		return false;
+
+	if (!__vlan_tun_can_enter_range(v_curr, range_end))
+		return false;
+
+	if (curr_mc_rtr != range_mc_rtr)
+		return false;
+
+	/* Check user-visible priv_flags that affect output */
+	if ((v_curr->priv_flags ^ range_end->priv_flags) &
+	    (BR_VLFLAG_NEIGH_SUPPRESS_ENABLED | BR_VLFLAG_MCAST_ENABLED))
+		return false;
+
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	if (!br_vlan_is_master(v_curr) &&
+	    !br_multicast_port_ctx_vlan_disabled(&v_curr->port_mcast_ctx) &&
+	    !br_multicast_port_ctx_options_equal(&v_curr->port_mcast_ctx,
+						 &range_end->port_mcast_ctx))
+		return false;
+#endif
+
+	return true;
 }
 
 bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
-- 
2.51.0

