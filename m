Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6B33FD137;
	Wed, 30 Sep 2026 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796770; cv=none; b=aPufvIp8OwsmqPiaDQfCzWWmE8zAuaSBmLlULfG8C4DVZ68m5p4FlXtQQhYgfO3KTcZlpBp4JLX2vg4S1M27eatR1a/HXsnGTjcovr+a259vyLwVjIxeivzHJnvYrWPc5wSPb21AzTKdU1pk0lZsFSwfweOctE/G7PBu83XSW2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796770; c=relaxed/simple;
	bh=ONyltGCdhHoY85tIhZZo6nlbco1gkdC+v4x9WyapRuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBOBLz5Knk30ChdDmlX3txoim+o/Bns34NR7RlPw16d9CjbCd6wUDVVOza7xXEjoIrzQu/svNv2HVTJVToLbDU/AIpACzU1fVfufpwOZtOlEDRwwSqqZPJt42cSW0uf2Kpa+hE5AcPy0hmOAzT09Kwx8MayHuN5moLUSALtutGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUVl3bmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUVl3bmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C581F000FF;
	Wed, 30 Sep 2026 19:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796769;
	bh=0iMNPe1LMfBVdU0CLRKppSQ41knnp0oXkqkFaC1TWds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SUVl3bmI837FA3BVsfnkXqvvFGrNXt5Fr8TawwrjSfsAWlXCbtMYdW8foaQpBx+Yi
	 zlgW5msdetpSb5cx/Ste/Q0ky0r9adpl+tgIY6nD2ZGx9GrrX8MwOwIrjQ4GJEG1W8
	 90KDrpMoEy86RKMvJ8gNVbYgMaKyZ9E4oWoB6aBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernardo Soares <bsoares.it@gmail.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1029/1193] net/mlx5: Bridge, dont fail switchdev events of sibling eswitch ports
Date: Wed, 30 Sep 2026 17:28:33 +0200
Message-ID: <20260930152457.091830759@linuxfoundation.org>
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

From: Bernardo Soares <bsoares.it@gmail.com>

[ Upstream commit 35e6f970f553954d92ba20afa885139a8e7dd0d7 ]

mlx5 registers the bridge offload switchdev notifiers once per eswitch
instance, but the notifier chains are global, so every instance sees
every event and must filter out the ones that aren't its own. The
existing filter, mlx5_esw_bridge_dev_same_hw(), only checks that the
event netdevice sits on the same HCA - intentional for merged eswitch,
where one bridge can span representors of several eswitches on one
HCA - but same-HCA doesn't mean the instance actually has that port:
peer ports are only created reactively from NETDEV_CHANGEUPPER, so an
instance brought up after a sibling PF's port was already enslaved has
none. The port object and attribute handlers claim the event anyway
once same-HW passes, then fail the port lookup and return -EINVAL,
which gets reported to user space even though the owning instance
already handled it (e.g. "bridge vlan add ... RTNETLINK answers:
Invalid argument"). Fix by filtering on the tracked port instead.

The same gap exists in the generic recursive lower-device walk used by
attribute changes on a bridge with more than one representor enslaved
directly: mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get() is entered
with the bridge master netdevice, falls through to its generic
netdev_for_each_lower_dev() loop, and returns as soon as the recursion
into any one lower device yields a non-NULL rep - the underlying base
case, mlx5_esw_bridge_rep_vport_num_vhca_id_get(), only checks
mlx5_esw_bridge_dev_same_hw(), not ownership by the calling instance's
br_offloads. mlx5_esw_bridge_lag_rep_get(), used for the LAG-master
case, already filters on mlx5_esw_bridge_dev_same_esw() per candidate
and so cannot select a sibling's rep; it is not the source of this bug.
On a merged-eswitch HCA with a bridge spanning representors of more
than one eswitch instance directly, the walk can return a sibling's rep
instead of continuing to the one the calling instance actually owns, so
the attribute change fails the same way as above. Fix by checking
mlx5_esw_bridge_port_exists() at the point each rep is picked, same as
the previous fix did for the notifier filter.

Fixes: c358ea1741bc ("net/mlx5: Bridge, allow merged eswitch connectivity")
Signed-off-by: Bernardo Soares <bsoares.it@gmail.com>
Cc: Vlad Buslov <vladbu@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20260918095931.29792-2-bsoares.it@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        | 45 +++++++++++++++----
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  6 +++
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |  2 +
 3 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 0f5d7ea8956f7..d8658fa517e70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -89,9 +89,16 @@ mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(struct net_device *dev, struct m
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	if (netif_is_lag_master(dev) || mlx5e_eswitch_rep(dev))
-		return mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw, vport_num,
-								 esw_owner_vhca_id);
+	if (netif_is_lag_master(dev) || mlx5e_eswitch_rep(dev)) {
+		struct net_device *rep;
+
+		rep = mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, esw, vport_num,
+								esw_owner_vhca_id);
+		if (rep && !mlx5_esw_bridge_port_exists(*vport_num, *esw_owner_vhca_id,
+							esw->br_offloads))
+			return NULL;
+		return rep;
+	}
 
 	netdev_for_each_lower_dev(dev, lower_dev, iter) {
 		struct net_device *rep;
@@ -108,6 +115,28 @@ mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(struct net_device *dev, struct m
 	return NULL;
 }
 
+static bool mlx5_esw_bridge_rep_port_lookup(struct net_device *dev,
+					    struct mlx5_esw_bridge_offloads *br_offloads,
+					    u16 *vport_num, u16 *esw_owner_vhca_id)
+{
+	if (!mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, br_offloads->esw, vport_num,
+						       esw_owner_vhca_id))
+		return false;
+
+	return mlx5_esw_bridge_port_exists(*vport_num, *esw_owner_vhca_id, br_offloads);
+}
+
+static bool mlx5_esw_bridge_lower_rep_port_lookup(struct net_device *dev,
+						  struct mlx5_esw_bridge_offloads *br_offloads,
+						  u16 *vport_num, u16 *esw_owner_vhca_id)
+{
+	if (!mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, vport_num,
+							     esw_owner_vhca_id))
+		return false;
+
+	return mlx5_esw_bridge_port_exists(*vport_num, *esw_owner_vhca_id, br_offloads);
+}
+
 static bool mlx5_esw_bridge_is_local(struct net_device *dev, struct net_device *rep,
 				     struct mlx5_eswitch *esw)
 {
@@ -222,8 +251,7 @@ mlx5_esw_bridge_port_obj_add(struct net_device *dev,
 	u16 vport_num, esw_owner_vhca_id;
 	int err;
 
-	if (!mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-						       &esw_owner_vhca_id))
+	if (!mlx5_esw_bridge_rep_port_lookup(dev, br_offloads, &vport_num, &esw_owner_vhca_id))
 		return 0;
 
 	port_obj_info->handled = true;
@@ -255,8 +283,7 @@ mlx5_esw_bridge_port_obj_del(struct net_device *dev,
 	const struct switchdev_obj_port_mdb *mdb;
 	u16 vport_num, esw_owner_vhca_id;
 
-	if (!mlx5_esw_bridge_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-						       &esw_owner_vhca_id))
+	if (!mlx5_esw_bridge_rep_port_lookup(dev, br_offloads, &vport_num, &esw_owner_vhca_id))
 		return 0;
 
 	port_obj_info->handled = true;
@@ -287,8 +314,8 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	u16 vport_num, esw_owner_vhca_id;
 	int err = 0;
 
-	if (!mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
-							     &esw_owner_vhca_id))
+	if (!mlx5_esw_bridge_lower_rep_port_lookup(dev, br_offloads, &vport_num,
+						   &esw_owner_vhca_id))
 		return 0;
 
 	port_attr_info->handled = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index c5ea1d1d2b035..a3d875fbcc19e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -1683,6 +1683,12 @@ int mlx5_esw_bridge_vport_peer_unlink(struct net_device *br_netdev, u16 vport_nu
 					    extack);
 }
 
+bool mlx5_esw_bridge_port_exists(u16 vport_num, u16 esw_owner_vhca_id,
+				 struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	return mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+}
+
 int mlx5_esw_bridge_port_vlan_add(u16 vport_num, u16 esw_owner_vhca_id, u16 vid, u16 flags,
 				  struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index d6f5391619930..a4e59cc210894 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -80,6 +80,8 @@ int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 pro
 				   struct mlx5_esw_bridge_offloads *br_offloads);
 int mlx5_esw_bridge_mcast_set(u16 vport_num, u16 esw_owner_vhca_id, bool enable,
 			      struct mlx5_esw_bridge_offloads *br_offloads);
+bool mlx5_esw_bridge_port_exists(u16 vport_num, u16 esw_owner_vhca_id,
+				 struct mlx5_esw_bridge_offloads *br_offloads);
 int mlx5_esw_bridge_port_vlan_add(u16 vport_num, u16 esw_owner_vhca_id, u16 vid, u16 flags,
 				  struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct netlink_ext_ack *extack);
-- 
2.53.0



