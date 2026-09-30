Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8284A1A683D;
	Wed, 30 Sep 2026 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794033; cv=none; b=FxWvrJ47gSv64RiSGgMrMazNN8TpuxDi5Q+jqaSNdIrFC5dsP9VjcCDq3F7dUaGxWT914/gxTUdK3kliVup4RLE32MdfXNIwRlQl6dRxwuv+nZJwI9G0hV3To/PJa9xJWjBpC9j76vwXe8hU2SpSDaRytCBXgk3VLg1eVWqFRcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794033; c=relaxed/simple;
	bh=APvTZQjOyGpEhvvKVWuNzMwvTuv8xuLxDSdS+ds+A3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DD8fKbVLttxo/TRMXU6unCxfoLK7y7ywLclyEumMAPJ8DXhJTjFxRcrIf4nqxhPyiEIjJc+5xUv7HNVRTb3lJXDE6icPukGJXeCAhpcEb3bleHlhxo7FHWIT/IEU8Vc8evmCEp70CrYtk6wjntMbNr7oBj/3agevjjRZo7cr9A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHNRmWZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHNRmWZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EBB1F00898;
	Wed, 30 Sep 2026 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794032;
	bh=Zu1Qh53/J+kydm5h+Wveg6tfY309jKaj/TKdy1pO5nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHNRmWZtOsvZyUIkFw44Ucs37Ldm034s1szr7XLsvQuzPWY+VgEbJmEJKy1uS5I77
	 iZVjL81nhciHxYbNqUaVv/MdybQ+vF0NxvjB4vrPJOSSs9mXz25u+vVSflLF9ldKCH
	 r9M968v2ZRykT6hV1uk7qpPKr78SZ4f3hhP/WyT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0069/1193] bridge: Add missing READ_ONCE() annotations around FDB destination port
Date: Wed, 30 Sep 2026 17:12:33 +0200
Message-ID: <20260930152435.801210997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 4af3e4c67038d..a4f6e56ef8729 100644
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
index 0a51f648c57ec..87816c1a0e060 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -456,7 +456,8 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	spin_lock_bh(&br->hash_lock);
 	vg = nbp_vlan_group(p);
 	hlist_for_each_entry(f, &br->fdb_list, fdb_node) {
-		if (f->dst == p && test_bit(BR_FDB_LOCAL, &f->flags) &&
+		if (READ_ONCE(f->dst) == p &&
+		    test_bit(BR_FDB_LOCAL, &f->flags) &&
 		    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags)) {
 			/* delete old one */
 			fdb_delete_local(br, p, f);
@@ -740,7 +741,7 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 
 	spin_lock_bh(&br->hash_lock);
 	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
-		if (f->dst != p)
+		if (READ_ONCE(f->dst) != p)
 			continue;
 
 		if (!do_all)
@@ -1513,7 +1514,7 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 
 	spin_lock_bh(&p->br->hash_lock);
 	hlist_for_each_entry(f, &p->br->fdb_list, fdb_node) {
-		if (f->dst == p && f->key.vlan_id == vid)
+		if (READ_ONCE(f->dst) == p && f->key.vlan_id == vid)
 			clear_bit(BR_FDB_OFFLOADED, &f->flags);
 	}
 	spin_unlock_bh(&p->br->hash_lock);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 46d2b20afd5ff..7f9bb05048d95 100644
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



