Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEF8246781;
	Thu, 20 Aug 2026 16:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244135; cv=none; b=WCU+Pq/TfB/eU6zoXITu+zFJmoEviv6xPq7i3uEU8VR3sTcsxOIGjLsa6SutZwZYfKNjqHQtHgPppyVTuyHtNiBB8Py7aZOtxe1Q5WnPq0oPA0KcATcic6E6jbR3zexd/5vsrWGucupK0daTGOIykiKu2/T8TABt9qdDo82Vo3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244135; c=relaxed/simple;
	bh=RblHNzzZP3W2EI3YuWsBZmmotoirfHeOWzV+vOvTEwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXWaMcyTRrJoCn8dCQUiwYjNSgErRGvCrAh9qn+btiJF2xOEBZtb+vKVIc3oNoDlI35449+yyyp5/MvlrLIWGwS+WSRugQ2ZNmp8d54wRdcTNcwiv4jPw7BG53yafkvSHu7I7tSNbsNs4y24miqKRSp6/Y6pcmOvJVfSd0cKTVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoMPncNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoMPncNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349711F000E9;
	Thu, 20 Aug 2026 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244133;
	bh=fNFa3YcCgULRmLn3wEcQBdC0tR4bpKvtq5GXmdLZkEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoMPncNr69hdsrCZVH7yPiFIGFVq4Nq16bmZdOWXzK5Y4GKYw8Eejoq80E69RxbYM
	 wu0UAZwF2bN3e0Qblmn7SNPiKfHSnfitgbkGdOKZy4QnMEqVhPRjUS8Svvx1jyPkLg
	 TPT2Hnyn409+Ur/RjBr+KeHL6/+dKfTgouDDpHVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/235] mlxsw: spectrum: Apply RIF configuration when joining a LAG
Date: Thu, 20 Aug 2026 16:55:00 +0200
Message-ID: <20260820145218.388979267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 31e1de4f1242f338eaa62cc53d582116c83b9dd0 ]

In case a router interface (RIF) is configured for a LAG, make sure its
configuration is applied on the new LAG member.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 41c8c1d65b32 ("mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |   17 ++++++++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h        |    4 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |   31 +++++++++++++++---
 3 files changed, 45 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3550,7 +3550,8 @@ static int mlxsw_sp_port_lag_index_get(s
 }
 
 static int mlxsw_sp_port_lag_join(struct mlxsw_sp_port *mlxsw_sp_port,
-				  struct net_device *lag_dev)
+				  struct net_device *lag_dev,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_upper *lag;
@@ -3586,8 +3587,20 @@ static int mlxsw_sp_port_lag_join(struct
 	if (mlxsw_sp_port->default_vlan->fid)
 		mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port->default_vlan);
 
+	/* Join a router interface configured on the LAG, if exists */
+	err = mlxsw_sp_port_vlan_router_join(mlxsw_sp_port->default_vlan,
+					     lag_dev, extack);
+	if (err)
+		goto err_router_join;
+
 	return 0;
 
+err_router_join:
+	lag->ref_count--;
+	mlxsw_sp_port->lagged = 0;
+	mlxsw_core_lag_mapping_clear(mlxsw_sp->core, lag_id,
+				     mlxsw_sp_port->local_port);
+	mlxsw_sp_lag_col_port_remove(mlxsw_sp_port, lag_id);
 err_col_port_add:
 	if (!lag->ref_count)
 		mlxsw_sp_lag_destroy(mlxsw_sp, lag_id);
@@ -3920,7 +3933,7 @@ static int mlxsw_sp_netdevice_port_upper
 		} else if (netif_is_lag_master(upper_dev)) {
 			if (info->linking) {
 				err = mlxsw_sp_port_lag_join(mlxsw_sp_port,
-							     upper_dev);
+							     upper_dev, extack);
 			} else {
 				mlxsw_sp_port_lag_col_dist_disable(mlxsw_sp_port);
 				mlxsw_sp_port_lag_leave(mlxsw_sp_port,
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -665,6 +665,10 @@ mlxsw_sp_netdevice_ipip_ul_event(struct
 				 struct net_device *l3_dev,
 				 unsigned long event,
 				 struct netdev_notifier_info *info);
+int
+mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
+			       struct net_device *l3_dev,
+			       struct netlink_ext_ack *extack);
 void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan);
 void mlxsw_sp_rif_destroy_by_dev(struct mlxsw_sp *mlxsw_sp,
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6676,9 +6676,9 @@ static void mlxsw_sp_rif_subport_put(str
 }
 
 static int
-mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
-			       struct net_device *l3_dev,
-			       struct netlink_ext_ack *extack)
+__mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
+				 struct net_device *l3_dev,
+				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp_port_vlan->mlxsw_sp_port;
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
@@ -6743,6 +6743,27 @@ __mlxsw_sp_port_vlan_router_leave(struct
 	mlxsw_sp_rif_subport_put(rif);
 }
 
+int
+mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
+			       struct net_device *l3_dev,
+			       struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port_vlan->mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_rif *rif;
+	int err = 0;
+
+	mutex_lock(&mlxsw_sp->router->lock);
+	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, l3_dev);
+	if (!rif)
+		goto out;
+
+	err = __mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan, l3_dev,
+					       extack);
+out:
+	mutex_unlock(&mlxsw_sp->router->lock);
+	return err;
+}
+
 void
 mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 {
@@ -6767,8 +6788,8 @@ static int mlxsw_sp_inetaddr_port_vlan_e
 
 	switch (event) {
 	case NETDEV_UP:
-		return mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan,
-						      l3_dev, extack);
+		return __mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan,
+							l3_dev, extack);
 	case NETDEV_DOWN:
 		__mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port_vlan);
 		break;


