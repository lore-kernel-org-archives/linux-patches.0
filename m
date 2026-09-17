Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1894DDB2F;
	Thu, 17 Sep 2026 16:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661322; cv=none; b=NKKxSmtRB4rYgSc+4Lmh+jX24I8lNYxbeTXu+0xS5EAftA2A/fj4ojW3Nzr0eG3EbiDEq7I7dyFcg5vzcj6LewGzyVTc3EzWreDbtNehCvR4jI93V1RMePWfscmeamaU9cz8ktptU9dz1rDjHjUW7LYMtNy/qqITecNrzzBSx64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661322; c=relaxed/simple;
	bh=I1NDC1vxEpkSAz6IQGYMMLZOCk+HVta3d8XgzvAcg94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qaa5VtRoaWByAgu4bsrr1WSg1kIk3yA/JT6zXJxEjY+nLnwR+EJjOtiPcltI3qxQTRdogcHivclPIG1SsaAjbcJ/yjdk5Z854PSd2asu1UABMQzSrRE49wGeBqvqdHOmG0nB4WdDEgoIdGBnU+phHHuex/2Td5a/NvHz2qpwQD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScxSLGNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScxSLGNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316431F000FF;
	Thu, 17 Sep 2026 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661320;
	bh=5vlmL95g/Cg2+PaQem5ghk75pGGvuc8qNqfMY3+uRK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ScxSLGNXMFpzaMlbI7cAt6LR76EO2fHY/oSGoqON0s/VDH8EHcVN4Ko2BOlNr3N10
	 mLdNn3+pXhFPoAf673hYzOO8TeX9Ya1kKM3j/B2ppRM/PEDs2DNSbKlKF+0z01bchy
	 vIKReJbqlBUJvVYklDrHAkppHgfRjnQxkS5htiFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <nikolay@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0156/1250] bridge: Add missing READ_ONCE() annotations around FDB destination port
Date: Thu, 17 Sep 2026 15:59:11 +0100
Message-ID: <20260917151556.306899172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 525d4eccd194a..966fac7017225 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -107,7 +107,7 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		else
 			br_flood(br, skb, BR_PKT_MULTICAST, false, true, vid);
 	} else if ((dst = br_fdb_find_rcu(br, dest, vid)) != NULL) {
-		br_forward(dst->dst, skb, false, true);
+		br_forward(READ_ONCE(dst->dst), skb, false, true);
 	} else {
 		br_flood(br, skb, BR_PKT_UNICAST, false, true, vid);
 	}
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 6eb3ab69a5140..fe85c8f197e67 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -470,7 +470,8 @@ void br_fdb_changeaddr(struct net_bridge_port *p, const unsigned char *newaddr)
 	spin_lock_bh(&br->hash_lock);
 	vg = nbp_vlan_group(p);
 	hlist_for_each_entry(f, &br->fdb_list, fdb_node) {
-		if (f->dst == p && test_bit(BR_FDB_LOCAL, &f->flags) &&
+		if (READ_ONCE(f->dst) == p &&
+		    test_bit(BR_FDB_LOCAL, &f->flags) &&
 		    !test_bit(BR_FDB_ADDED_BY_USER, &f->flags)) {
 			/* delete old one */
 			fdb_delete_local(br, p, f);
@@ -878,7 +879,7 @@ void br_fdb_delete_by_port(struct net_bridge *br,
 
 	spin_lock_bh(&br->hash_lock);
 	hlist_for_each_entry_safe(f, tmp, &br->fdb_list, fdb_node) {
-		if (f->dst != p)
+		if (READ_ONCE(f->dst) != p)
 			continue;
 
 		if (!do_all)
@@ -1660,7 +1661,7 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
 
 	spin_lock_bh(&p->br->hash_lock);
 	hlist_for_each_entry(f, &p->br->fdb_list, fdb_node) {
-		if (f->dst == p && f->key.vlan_id == vid)
+		if (READ_ONCE(f->dst) == p && f->key.vlan_id == vid)
 			clear_bit(BR_FDB_OFFLOADED, &f->flags);
 	}
 	spin_unlock_bh(&p->br->hash_lock);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 2cbae0f9ae1f0..470615675bdc0 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -223,7 +223,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 
 		if (now != READ_ONCE(dst->used))
 			WRITE_ONCE(dst->used, now);
-		br_forward(dst->dst, skb, local_rcv, false);
+		br_forward(READ_ONCE(dst->dst), skb, local_rcv, false);
 	} else {
 		if (!mcast_hit)
 			br_flood(br, skb, pkt_type, local_rcv, false, vid);
-- 
2.53.0



