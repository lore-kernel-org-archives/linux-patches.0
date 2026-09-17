Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E624FB9C3;
	Thu, 17 Sep 2026 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667475; cv=none; b=Cxs2MX1DIC7VNF9kNOizJzNGn8ubGpELyw+1GcjliGrbyCakTvtn9lwdrIAVpd9Q0u7czluE1Ud/BLUzdv0WA7xNdZOHMaaGwhUYDhFwZjMaa7bzwcKRW8pWWjXG7TVrv/cwPexKNzfPsf7F0iWAHQHxbru4eIw0iWZKHmjn1EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667475; c=relaxed/simple;
	bh=6Nbzwio/LWA4AyLdTpZmXl5eIR37zKyW5SLiIffxZYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc0QIblW/fitteHqazxlYQUJcVgJzZMRhGYHBzINaV7Drq9hR2hmPEo6R2kLFsZ0CMuSisu4EVK4egIW5GkE+Z3684h3MOfRy989eCktkylwC2kfGLIRtFQZtU8ILFS1WsN7Vht3g4Q92TMPUE71Wt+TWrAhg6UgmXlu32mKrl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXhrhViO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXhrhViO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C5D1F000FF;
	Thu, 17 Sep 2026 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667473;
	bh=A4WBMXWqHIdvf3bkPu4BWifKpZLRtuXAG6qqoyzUvj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXhrhViO9qjtRmda5IgQSkg5RCwC1nDwL8UTmNBBru9HpyqxLeenBh4yz0lXz9v+z
	 9P/qY67qeKtrctNnq7004CXbVDIfAYfZCGhYgRmR7THhc/NWgw1mfRgnVsY5JKEynX
	 cGsu+MuoMkgotYPjpv8QcKcUR/FPJ9G4P6YoYUVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0105/1102] bridge: Add missing READ_ONCE() annotations around FDB destination port
Date: Thu, 17 Sep 2026 16:00:48 +0100
Message-ID: <20260917151542.134810661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit bcdfd9fb109e0c9d76c345b2346b6b75ed1f476d ]

When roaming, the FDB destination port can change without holding the
bridge's hash lock. Therefore, add missing READ_ONCE() annotations in
both RCU readers and readers that hold the lock. In the latter case, the
annotation is not needed in places where the FDB entry was already
validated to be a local entry since such entries cannot roam.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260517115009.175163-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_device.c | 2 +-
 net/bridge/br_fdb.c    | 7 ++++---
 net/bridge/br_input.c  | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 3768cc9c8ecb3..6b7021cebb529 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -105,7 +105,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true, vid);
 	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
-		br_forward(dst->dst, skb, false, true);
+		br_forward(READ_ONCE(dst->dst), skb, false, true);
 	} else {
 		br_flood(br, skb, BR_PKT_UNICAST, false, true, vid);
 	}
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 39cc761012d48..ab00b1e55eae4 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -474,7 +474,8 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	spin_lock_bh(&br->hash_lock);
 	vg = nbp_vlan_group(p);
 	hlist_for_each_entry(f, &br->fdb_list, fdb_node) {
-		if (f->dst == p && test_bit(BR_FDB_LOCAL, &f->flags) &&
+		if (READ_ONCE(f->dst) == p &&
+		    test_bit(BR_FDB_LOCAL, &f->flags) &&
 		    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags)) {
 			/* delete old one */
 			fdb_delete_local(br, p, f);
@@ -777,7 +778,7 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 
 	spin_lock_bh(&br->hash_lock);
 	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
-		if (f->dst != p)
+		if (READ_ONCE(f->dst) != p)
 			continue;
 
 		if (!do_all)
@@ -1560,7 +1561,7 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 
 	spin_lock_bh(&p->br->hash_lock);
 	hlist_for_each_entry(f, &p->br->fdb_list, fdb_node) {
-		if (f->dst == p && f->key.vlan_id == vid)
+		if (READ_ONCE(f->dst) == p && f->key.vlan_id == vid)
 			clear_bit(BR_FDB_OFFLOADED, &f->flags);
 	}
 	spin_unlock_bh(&p->br->hash_lock);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index e22088b07e70b..ab4758ec3e54c 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -209,7 +209,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 
 		if (now != READ_ONCE(dst->used))
 			WRITE_ONCE(dst->used, now);
-		br_forward(dst->dst, skb, local_rcv, false);
+		br_forward(READ_ONCE(dst->dst), skb, local_rcv, false);
 	} else {
 		if (!mcast_hit)
 			br_flood(br, skb, pkt_type, local_rcv, false, vid);
-- 
2.53.0



