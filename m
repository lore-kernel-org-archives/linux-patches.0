Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E915158BD;
	Wed, 30 Sep 2026 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786448; cv=none; b=kOStrTslwXU7u9IaWE4hlZ+sFXWJy43K70QKhyn/9qoeL94cUBQ89Au9XZ0C2vU9k2urOzLjRFhxGoOwRxy0vTHWDxWN3XQNUmdnqhcS6u1lWZoj/sSbFzEBFf1M7FUQVzqF4TmSpytrx1b0QEAThKM+OWKSw+7q/422nFimh7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786448; c=relaxed/simple;
	bh=uGJ+gRMXG3naBO7HtVDeube/Ge2dSr5OcEEzRsBQbs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pY9mF44sgoOSAUXFC26qwrCpFqPv+ZRZmvwqAVKTUDGw025HEjY0nyA4SbkjAM93QTuVAWee83wfpUukUm1jwVlS+5B4zoqIfaKnxch8LbGjHQ+kTjSFMcFRabw8WDlz/NHIUAbmn9ysJEsyWPclwERKTUO4dVMpiuL2VqOBYd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpZO9UyR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpZO9UyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8861F000FF;
	Wed, 30 Sep 2026 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786447;
	bh=Ktg4MLcLWRO1+pbcekAA6hEcTsZuoMRDG8+M2LyR9vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpZO9UyRRmMPW5RyiNuQo4K1BY3hTpKIrhNPH3klvGvSDnvs4NBy99faFg/c42X0G
	 7sI04vRHqt2FUmQ6KuS4AtVMXCWg+QYvBkjkIjbHem9NPPt2B21KclH1OFEYKrDhDk
	 r9QLNYGM0rDpak0rV0VU3zsv1rv5+1/kwSapjtZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 864/982] net/mlx5: Bridge, extract code to lookup parent bridge of port
Date: Wed, 30 Sep 2026 17:26:40 +0200
Message-ID: <20260930152435.308628855@linuxfoundation.org>
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

[ Upstream commit b99c4ef29e278ab0b91406e52df4fa9b634b117e ]

The pattern when function looks up a port by vport_num+vhca_id tuple in
order to just obtain its parent bridge is repeated multiple times in
bridge.c file. Further commits in this series use the pattern even more.
Extract the pattern to standalone mlx5_esw_bridge_from_port_lookup()
function to improve code readability.

This commits doesn't change functionality.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 35e6f970f553 ("net/mlx5: Bridge, don't fail switchdev events of sibling eswitch ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  | 47 ++++++++++---------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index f1752852c70f3..776441b16bb85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -933,6 +933,19 @@ static void mlx5_esw_bridge_port_erase(struct mlx5_esw_bridge_port *port,
 	xa_erase(&br_offloads->ports, mlx5_esw_bridge_port_key(port));
 }
 
+static struct mlx5_esw_bridge *
+mlx5_esw_bridge_from_port_lookup(u16 vport_num, u16 esw_owner_vhca_id,
+				 struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge_port *port;
+
+	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!port)
+		return NULL;
+
+	return port->bridge;
+}
+
 static void mlx5_esw_bridge_fdb_entry_refresh(struct mlx5_esw_bridge_fdb_entry *entry)
 {
 	trace_mlx5_esw_bridge_fdb_entry_refresh(entry);
@@ -1388,28 +1401,26 @@ mlx5_esw_bridge_fdb_entry_init(struct net_device *dev, u16 vport_num, u16 esw_ow
 int mlx5_esw_bridge_ageing_time_set(u16 vport_num, u16 esw_owner_vhca_id, unsigned long ageing_time,
 				    struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_esw_bridge_port *port;
+	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return -EINVAL;
 
-	port->bridge->ageing_time = clock_t_to_jiffies(ageing_time);
+	bridge->ageing_time = clock_t_to_jiffies(ageing_time);
 	return 0;
 }
 
 int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, bool enable,
 				       struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 	bool filtering;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return -EINVAL;
 
-	bridge = port->bridge;
 	filtering = bridge->flags & MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG;
 	if (filtering == enable)
 		return 0;
@@ -1426,15 +1437,13 @@ int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, boo
 int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 proto,
 				   struct mlx5_esw_bridge_offloads *br_offloads)
 {
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id,
-					   br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id,
+						  br_offloads);
+	if (!bridge)
 		return -EINVAL;
 
-	bridge = port->bridge;
 	if (bridge->vlan_proto == proto)
 		return 0;
 	if (proto != ETH_P_8021Q && proto != ETH_P_8021AD) {
@@ -1626,14 +1635,12 @@ void mlx5_esw_bridge_fdb_update_used(struct net_device *dev, u16 vport_num, u16
 				     struct switchdev_notifier_fdb_info *fdb_info)
 {
 	struct mlx5_esw_bridge_fdb_entry *entry;
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return;
 
-	bridge = port->bridge;
 	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
 		esw_debug(br_offloads->esw->dev,
@@ -1680,14 +1687,12 @@ void mlx5_esw_bridge_fdb_remove(struct net_device *dev, u16 vport_num, u16 esw_o
 {
 	struct mlx5_eswitch *esw = br_offloads->esw;
 	struct mlx5_esw_bridge_fdb_entry *entry;
-	struct mlx5_esw_bridge_port *port;
 	struct mlx5_esw_bridge *bridge;
 
-	port = mlx5_esw_bridge_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
-	if (!port)
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
 		return;
 
-	bridge = port->bridge;
 	entry = mlx5_esw_bridge_fdb_lookup(bridge, fdb_info->addr, fdb_info->vid);
 	if (!entry) {
 		esw_warn(esw->dev,
-- 
2.53.0



