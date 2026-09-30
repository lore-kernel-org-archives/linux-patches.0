Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A087950254F;
	Wed, 30 Sep 2026 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786458; cv=none; b=CWdP5q4e0S1WZbMDFf4WFYQ+vKui4hi5Xcj64AL1e2UAxSQUxQ9mpIJ1ADakUzZsxj4kZG6vuW9p/jpNa5h6QqQcFKWFBdr5AERwhdIPEeVVSx1o3NtBCFlVF5HAss0NQAcRJuEypuuP5+c2ASLaKCXShNE1x7O5pmzOSEYfTRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786458; c=relaxed/simple;
	bh=0rWcpkJS2dSUkyna9k1gFiwggDGrkkyXxT/UQwLXopc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbUSVmQqpuuGX/DiZMZO53tYjqTa6AfFIhBFI5db7CsCmmXU1aazvPrXnEnydTPop3fGd9A5JITUe1kxGJk1kjmoUKzjRGhQfEICrjPsQlB8yga8IOmPNQEPy7tFFjLk4JwYKORdSfVj/NIlr45wELyKXk/a/9DxT2TZCg4I4V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHFGJg+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHFGJg+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21FB1F000FF;
	Wed, 30 Sep 2026 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786455;
	bh=20BiRe5Tcs+fPONej8K0pB7UULfSctABqiNBs/IlWHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHFGJg+u/l1lzmooDqy2h67F0BfeUHRemkztvZZDU/wO0by1noupcv6uYtGdYWxwZ
	 hgiu30us1xaUhXLLHshHz0iHUfX25NXqxTeI+WSU/vVUOq93KLSsj1zaQ/dABw1Y0b
	 1DfIaYYZTdAMXExn02+0ozBVbyOMsXlXp+mb0xiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 867/982] net/mlx5: Bridge, pass net device when linking vport to bridge
Date: Wed, 30 Sep 2026 17:26:43 +0200
Message-ID: <20260930152435.372797774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit ade19f0d6a3a395e7936227811acbf897ee186fc ]

Following patch requires access to additional data in bridge net_device.
Pass the whole structure down the stack instead of adding necessary fields
as function arguments one-by-one.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 2e51097c982b ("net/mlx5: Bridge, don't fail unlink of untracked/unsupported peer ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en/rep/bridge.c        |  9 +++--
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 35 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  | 10 +++---
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index ea7c5e907266e..effb0706a71ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -160,7 +160,6 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 	struct mlx5_eswitch *esw = br_offloads->esw;
 	u16 vport_num, esw_owner_vhca_id;
 	struct netlink_ext_ack *extack;
-	int ifindex = upper->ifindex;
 	int err = 0;
 
 	if (!netif_is_bridge_master(upper))
@@ -174,15 +173,15 @@ static int mlx5_esw_bridge_port_changeupper(struct notifier_block *nb, void *ptr
 
 	if (mlx5_esw_bridge_is_local(dev, rep, esw))
 		err = info->linking ?
-			mlx5_esw_bridge_vport_link(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_link(upper, vport_num, esw_owner_vhca_id,
 						   br_offloads, extack) :
-			mlx5_esw_bridge_vport_unlink(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_unlink(upper, vport_num, esw_owner_vhca_id,
 						     br_offloads, extack);
 	else if (mlx5_esw_bridge_dev_same_hw(rep, esw))
 		err = info->linking ?
-			mlx5_esw_bridge_vport_peer_link(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_peer_link(upper, vport_num, esw_owner_vhca_id,
 							br_offloads, extack) :
-			mlx5_esw_bridge_vport_peer_unlink(ifindex, vport_num, esw_owner_vhca_id,
+			mlx5_esw_bridge_vport_peer_unlink(upper, vport_num, esw_owner_vhca_id,
 							  br_offloads, extack);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index bb7698e967977..882b87bc45d50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -821,7 +821,7 @@ mlx5_esw_bridge_egress_miss_flow_create(struct mlx5_flow_table *egress_ft,
 	return handle;
 }
 
-static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
+static struct mlx5_esw_bridge *mlx5_esw_bridge_create(struct net_device *br_netdev,
 						      struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_esw_bridge *bridge;
@@ -841,7 +841,7 @@ static struct mlx5_esw_bridge *mlx5_esw_bridge_create(int ifindex,
 		goto err_fdb_ht;
 
 	INIT_LIST_HEAD(&bridge->fdb_list);
-	bridge->ifindex = ifindex;
+	bridge->ifindex = br_netdev->ifindex;
 	bridge->refcnt = 1;
 	bridge->ageing_time = clock_t_to_jiffies(BR_DEFAULT_AGEING_TIME);
 	bridge->vlan_proto = ETH_P_8021Q;
@@ -878,14 +878,14 @@ static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
 }
 
 static struct mlx5_esw_bridge *
-mlx5_esw_bridge_lookup(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads)
+mlx5_esw_bridge_lookup(struct net_device *br_netdev, struct mlx5_esw_bridge_offloads *br_offloads)
 {
 	struct mlx5_esw_bridge *bridge;
 
 	ASSERT_RTNL();
 
 	list_for_each_entry(bridge, &br_offloads->bridges, list) {
-		if (bridge->ifindex == ifindex) {
+		if (bridge->ifindex == br_netdev->ifindex) {
 			mlx5_esw_bridge_get(bridge);
 			return bridge;
 		}
@@ -898,7 +898,7 @@ mlx5_esw_bridge_lookup(int ifindex, struct mlx5_esw_bridge_offloads *br_offloads
 			return ERR_PTR(err);
 	}
 
-	bridge = mlx5_esw_bridge_create(ifindex, br_offloads);
+	bridge = mlx5_esw_bridge_create(br_netdev, br_offloads);
 	if (IS_ERR(bridge) && list_empty(&br_offloads->bridges))
 		mlx5_esw_bridge_ingress_table_cleanup(br_offloads);
 	return bridge;
@@ -1541,15 +1541,15 @@ static int mlx5_esw_bridge_vport_cleanup(struct mlx5_esw_bridge_offloads *br_off
 	return 0;
 }
 
-static int mlx5_esw_bridge_vport_link_with_flags(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
-						 u16 flags,
+static int mlx5_esw_bridge_vport_link_with_flags(struct net_device *br_netdev, u16 vport_num,
+						 u16 esw_owner_vhca_id, u16 flags,
 						 struct mlx5_esw_bridge_offloads *br_offloads,
 						 struct netlink_ext_ack *extack)
 {
 	struct mlx5_esw_bridge *bridge;
 	int err;
 
-	bridge = mlx5_esw_bridge_lookup(ifindex, br_offloads);
+	bridge = mlx5_esw_bridge_lookup(br_netdev, br_offloads);
 	if (IS_ERR(bridge)) {
 		NL_SET_ERR_MSG_MOD(extack, "Error checking for existing bridge with same ifindex");
 		return PTR_ERR(bridge);
@@ -1567,15 +1567,16 @@ static int mlx5_esw_bridge_vport_link_with_flags(int ifindex, u16 vport_num, u16
 	return err;
 }
 
-int mlx5_esw_bridge_vport_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_link(struct net_device *br_netdev, u16 vport_num, u16 esw_owner_vhca_id,
 			       struct mlx5_esw_bridge_offloads *br_offloads,
 			       struct netlink_ext_ack *extack)
 {
-	return mlx5_esw_bridge_vport_link_with_flags(ifindex, vport_num, esw_owner_vhca_id, 0,
+	return mlx5_esw_bridge_vport_link_with_flags(br_netdev, vport_num, esw_owner_vhca_id, 0,
 						     br_offloads, extack);
 }
 
-int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_unlink(struct net_device *br_netdev, u16 vport_num,
+				 u16 esw_owner_vhca_id,
 				 struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct netlink_ext_ack *extack)
 {
@@ -1587,7 +1588,7 @@ int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_
 		NL_SET_ERR_MSG_MOD(extack, "Port is not attached to any bridge");
 		return -EINVAL;
 	}
-	if (port->bridge->ifindex != ifindex) {
+	if (port->bridge->ifindex != br_netdev->ifindex) {
 		NL_SET_ERR_MSG_MOD(extack, "Port is attached to another bridge");
 		return -EINVAL;
 	}
@@ -1598,23 +1599,25 @@ int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_
 	return err;
 }
 
-int mlx5_esw_bridge_vport_peer_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_link(struct net_device *br_netdev, u16 vport_num,
+				    u16 esw_owner_vhca_id,
 				    struct mlx5_esw_bridge_offloads *br_offloads,
 				    struct netlink_ext_ack *extack)
 {
 	if (!MLX5_CAP_ESW(br_offloads->esw->dev, merged_eswitch))
 		return 0;
 
-	return mlx5_esw_bridge_vport_link_with_flags(ifindex, vport_num, esw_owner_vhca_id,
+	return mlx5_esw_bridge_vport_link_with_flags(br_netdev, vport_num, esw_owner_vhca_id,
 						     MLX5_ESW_BRIDGE_PORT_FLAG_PEER,
 						     br_offloads, extack);
 }
 
-int mlx5_esw_bridge_vport_peer_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_unlink(struct net_device *br_netdev, u16 vport_num,
+				      u16 esw_owner_vhca_id,
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct netlink_ext_ack *extack)
 {
-	return mlx5_esw_bridge_vport_unlink(ifindex, vport_num, esw_owner_vhca_id, br_offloads,
+	return mlx5_esw_bridge_vport_unlink(br_netdev, vport_num, esw_owner_vhca_id, br_offloads,
 					    extack);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index bda199cdd931b..7bc66c877ea44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -43,16 +43,18 @@ struct mlx5_esw_bridge_offloads {
 
 struct mlx5_esw_bridge_offloads *mlx5_esw_bridge_init(struct mlx5_eswitch *esw);
 void mlx5_esw_bridge_cleanup(struct mlx5_eswitch *esw);
-int mlx5_esw_bridge_vport_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_link(struct net_device *br_netdev, u16 vport_num, u16 esw_owner_vhca_id,
 			       struct mlx5_esw_bridge_offloads *br_offloads,
 			       struct netlink_ext_ack *extack);
-int mlx5_esw_bridge_vport_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_unlink(struct net_device *br_netdev, u16 vport_num, u16 esw_owner_vhca_id,
 				 struct mlx5_esw_bridge_offloads *br_offloads,
 				 struct netlink_ext_ack *extack);
-int mlx5_esw_bridge_vport_peer_link(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_link(struct net_device *br_netdev, u16 vport_num,
+				    u16 esw_owner_vhca_id,
 				    struct mlx5_esw_bridge_offloads *br_offloads,
 				    struct netlink_ext_ack *extack);
-int mlx5_esw_bridge_vport_peer_unlink(int ifindex, u16 vport_num, u16 esw_owner_vhca_id,
+int mlx5_esw_bridge_vport_peer_unlink(struct net_device *br_netdev, u16 vport_num,
+				      u16 esw_owner_vhca_id,
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct netlink_ext_ack *extack);
 void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16 esw_owner_vhca_id,
-- 
2.53.0



