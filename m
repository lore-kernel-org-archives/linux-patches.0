Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C428927CCF0;
	Tue, 27 May 2025 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365984; cv=none; b=HBsmYS67XwTDlimHR6rUDi589sv9wIHmOatV5SW3r1VU3QQhhirIAmtGDmuPHlv08KbUSItUidE8UD0EqrXFDrcD3irTlMuMei8E2kyxQ4H0nsUU1tAi3H889qRAHlB04mFnSvLLBoVLy/fwWlYLSQTkgBfIKAuZq+Fap63SSFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365984; c=relaxed/simple;
	bh=+qzUdh+tTgGBgqV7u81Qcp3BUm1RQa8niVM6qaI98z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOZ2NV7zl2mippJ+g9ez2e7uMVa1KVg6TEm3lcRQmdcx+KDIPbf7+pRY3XKgEpQ7qnIqFirBFTD2HlDEdO4Lf59mxjd0kh4N8kgVymmD46rTpXzpvsoudX5HyuFzBUcYMo9Veg7eyxsIW0i9r4YG357nq9MhtUWbdR9G7n2TFEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpb5bP+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpb5bP+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA54C4CEE9;
	Tue, 27 May 2025 17:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365984;
	bh=+qzUdh+tTgGBgqV7u81Qcp3BUm1RQa8niVM6qaI98z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpb5bP+7B47sSCoIcmbY4CYBo/m0AKwubvqgD+ZiopiADPIiLvVVSdriGrEGLqtxW
	 /ToLZLx9mLKs+k2xsoBLeTDXvmPQdN8rnZTbkghc71Znm7gJKR5/zpZpoB30Xle4NE
	 buAlZJq/ihsICopB2GfP0165z0DWRTKN1GEg3ZSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 554/626] bridge: netfilter: Fix forwarding of fragmented packets
Date: Tue, 27 May 2025 18:27:27 +0200
Message-ID: <20250527162507.480852614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 91b6dbced0ef1d680afdd69b14fc83d50ebafaf3 ]

When netfilter defrag hooks are loaded (due to the presence of conntrack
rules, for example), fragmented packets entering the bridge will be
defragged by the bridge's pre-routing hook (br_nf_pre_routing() ->
ipv4_conntrack_defrag()).

Later on, in the bridge's post-routing hook, the defragged packet will
be fragmented again. If the size of the largest fragment is larger than
what the kernel has determined as the destination MTU (using
ip_skb_dst_mtu()), the defragged packet will be dropped.

Before commit ac6627a28dbf ("net: ipv4: Consolidate ipv4_mtu and
ip_dst_mtu_maybe_forward"), ip_skb_dst_mtu() would return dst_mtu() as
the destination MTU. Assuming the dst entry attached to the packet is
the bridge's fake rtable one, this would simply be the bridge's MTU (see
fake_mtu()).

However, after above mentioned commit, ip_skb_dst_mtu() ends up
returning the route's MTU stored in the dst entry's metrics. Ideally, in
case the dst entry is the bridge's fake rtable one, this should be the
bridge's MTU as the bridge takes care of updating this metric when its
MTU changes (see br_change_mtu()).

Unfortunately, the last operation is a no-op given the metrics attached
to the fake rtable entry are marked as read-only. Therefore,
ip_skb_dst_mtu() ends up returning 1500 (the initial MTU value) and
defragged packets are dropped during fragmentation when dealing with
large fragments and high MTU (e.g., 9k).

Fix by moving the fake rtable entry's metrics to be per-bridge (in a
similar fashion to the fake rtable entry itself) and marking them as
writable, thereby allowing MTU changes to be reflected.

Fixes: 62fa8a846d7d ("net: Implement read-only protection and COW'ing of metrics.")
Fixes: 33eb9873a283 ("bridge: initialize fake_rtable metrics")
Reported-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Closes: https://lore.kernel.org/netdev/PH0PR10MB4504888284FF4CBA648197D0ACB82@PH0PR10MB4504.namprd10.prod.outlook.com/
Tested-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250515084848.727706-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_nf_core.c | 7 ++-----
 net/bridge/br_private.h | 1 +
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_nf_core.c b/net/bridge/br_nf_core.c
index 98aea5485aaef..a8c67035e23c0 100644
--- a/net/bridge/br_nf_core.c
+++ b/net/bridge/br_nf_core.c
@@ -65,17 +65,14 @@ static struct dst_ops fake_dst_ops = {
  * ipt_REJECT needs it.  Future netfilter modules might
  * require us to fill additional fields.
  */
-static const u32 br_dst_default_metrics[RTAX_MAX] = {
-	[RTAX_MTU - 1] = 1500,
-};
-
 void br_netfilter_rtable_init(struct net_bridge *br)
 {
 	struct rtable *rt = &br->fake_rtable;
 
 	rcuref_init(&rt->dst.__rcuref, 1);
 	rt->dst.dev = br->dev;
-	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
+	dst_init_metrics(&rt->dst, br->metrics, false);
+	dst_metric_set(&rt->dst, RTAX_MTU, br->dev->mtu);
 	rt->dst.flags	= DST_NOXFRM | DST_FAKE_RTABLE;
 	rt->dst.ops = &fake_dst_ops;
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 041f6e571a209..df502cc1191c3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -505,6 +505,7 @@ struct net_bridge {
 		struct rtable		fake_rtable;
 		struct rt6_info		fake_rt6_info;
 	};
+	u32				metrics[RTAX_MAX];
 #endif
 	u16				group_fwd_mask;
 	u16				group_fwd_mask_required;
-- 
2.39.5



