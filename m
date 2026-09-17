Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94B65304C6;
	Thu, 17 Sep 2026 17:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666065; cv=none; b=CgsWfCg35OZtUnThPFlzJgZfi9E85GnfeIEWx3APScMhIXFrL9xsGYMFI8MEOw1xMrqiyAjLxZrHEMU6w8B8oK5LrOUOY/cgOR6KbtSfzYIGmXd1GbydvzNGGG2CUL4YBb2J4QQ19idCP/i50chQMwXpNN7PJLcpVIxeeHE+AL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666065; c=relaxed/simple;
	bh=AWdXC+3+27s/b10DVByTUDGIOUmNmNhx9TVnajMxa9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqAokqWF38BUvGdHCuqJzIOdJCnWJ98C3jmW5u9pH1cak07/zkSR5x4J/vBqANLX0XBZu5sWu2omDGf7WXiDkYyniWOoayYoC9NaGEq+DvJtJRvk/odWFzRd1IqGChVsd+f+EvdDS+uI2wShja8cRqFgieX2mepqrLojiXqmSCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0BHT/k0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0BHT/k0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD751F000FF;
	Thu, 17 Sep 2026 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666063;
	bh=n1UGwPCemXjgp3V3JzCVT/ZqOyqN/7WCG6iHEB61dHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0BHT/k0ZjWBrsRr5UTuZCzTLSzZ/pOAuTQw8qJsDC5xIsNTow8FViaCgoT2w21Hf
	 fAHOQ3MBQU3sTXgvezYpAmLY1LrJv8PMHKNbIELBfbEBqkg8F7DZbBOMrp3Hv1JDN/
	 5/j7icEVfWe/+xjtqNFJF1w65Fm+9slbIVnboyr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0913/1250] net/mlx5e: Move representor vnic reporter to eswitch devlink port
Date: Thu, 17 Sep 2026 16:11:48 +0100
Message-ID: <20260917151616.742481084@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 7f26a5e8040b4957ef4dbdfcde6cc7ba2db53937 ]

The representor vnic devlink health reporter is created and destroyed
along the representor netdev (un)load path, which is not serialized by
the devlink instance lock. Destroying the reporter from there triggers
a devl_assert_locked() splat on driver unbind:
  WARNING: net/devlink/core.c:259 at devl_assert_locked+0x54/0x70, CPU#2: bash/3758
  Modules linked in: mlx5_vdpa vringh vdpa mlx5_ib mlx5_fwctl mlx5_core ...
  CPU: 2 UID: 0 PID: 3758 Comm: bash Tainted: G        W           6.19.0+ #1 PREEMPT
  Tainted: [W]=WARN
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), ...
  RIP: 0010:devl_assert_locked+0x54/0x70
  Call Trace:
   <TASK>
   devl_health_reporter_destroy+0x3a/0x1b0
   mlx5e_vport_rep_unload+0x12d/0x2b0 [mlx5_core]
   mlx5_eswitch_unregister_vport_reps+0x1b8/0x220 [mlx5_core]
   ? __esw_offloads_unload_rep+0x190/0x190 [mlx5_core]
   ? kernfs_remove_by_name_ns+0xc3/0xf0
   device_release_driver_internal+0x3b2/0x560
   unbind_store+0xce/0xf0

Move the reporter's lifecycle to the eswitch devlink port (un)register
paths, which are already serialized by the devlink instance lock, and
store the handle on mlx5_devlink_port. Use the port's mlx5_vport as the
reporter priv since the diagnose callback only needs a device handle and
a vport number, and mlx5_vport carries both and is initialized before
any representor driver probes.

Fixes: cf14af140a5a ("net/mlx5e: Add vnic devlink health reporter to representors")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260906090700.3761260-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 52 +------------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  1 -
 .../mellanox/mlx5/core/esw/devlink_port.c     | 37 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 4 files changed, 39 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index b716f7cfe8af8..a47fef49ada97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -57,7 +57,6 @@
 #include "lib/vxlan.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
-#include "diag/reporter_vnic.h"
 #include "en_accel/ipsec.h"
 #include "en/tc/int_port.h"
 #include "en/ptp.h"
@@ -1431,51 +1430,6 @@ static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
 	return ARRAY_SIZE(mlx5e_ul_rep_stats_grps);
 }
 
-static int
-mlx5e_rep_vnic_reporter_diagnose(struct devlink_health_reporter *reporter,
-				 struct devlink_fmsg *fmsg,
-				 struct netlink_ext_ack *extack)
-{
-	struct mlx5e_rep_priv *rpriv = devlink_health_reporter_priv(reporter);
-	struct mlx5_eswitch_rep *rep = rpriv->rep;
-
-	mlx5_reporter_vnic_diagnose_counters(rep->esw->dev, fmsg, rep->vport,
-					     true);
-	return 0;
-}
-
-static const struct devlink_health_reporter_ops mlx5_rep_vnic_reporter_ops = {
-	.name = "vnic",
-	.diagnose = mlx5e_rep_vnic_reporter_diagnose,
-};
-
-static void mlx5e_rep_vnic_reporter_create(struct mlx5e_priv *priv,
-					   struct devlink_port *dl_port)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct devlink_health_reporter *reporter;
-
-	reporter = devl_port_health_reporter_create(dl_port,
-						    &mlx5_rep_vnic_reporter_ops,
-						    rpriv);
-	if (IS_ERR(reporter)) {
-		mlx5_core_err(priv->mdev,
-			      "Failed to create representor vnic reporter, err = %pe\n",
-			      reporter);
-		return;
-	}
-
-	rpriv->rep_vnic_reporter = reporter;
-}
-
-static void mlx5e_rep_vnic_reporter_destroy(struct mlx5e_priv *priv)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-
-	if (!IS_ERR_OR_NULL(rpriv->rep_vnic_reporter))
-		devl_health_reporter_destroy(rpriv->rep_vnic_reporter);
-}
-
 static const struct mlx5e_profile mlx5e_rep_profile = {
 	.init			= mlx5e_init_rep,
 	.cleanup		= mlx5e_cleanup_rep,
@@ -1599,10 +1553,8 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	dl_port = mlx5_esw_offloads_devlink_port(dev->priv.eswitch,
 						 rpriv->rep->vport);
-	if (!IS_ERR(dl_port)) {
+	if (!IS_ERR(dl_port))
 		SET_NETDEV_DEVLINK_PORT(netdev, dl_port);
-		mlx5e_rep_vnic_reporter_create(priv, dl_port);
-	}
 
 	err = register_netdev(netdev);
 	if (err) {
@@ -1615,7 +1567,6 @@ mlx5e_vport_vf_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	return 0;
 
 err_detach_netdev:
-	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(netdev_priv(netdev));
 err_cleanup_profile:
 	priv->profile->cleanup(priv);
@@ -1673,7 +1624,6 @@ mlx5e_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	}
 
 	unregister_netdev(netdev);
-	mlx5e_rep_vnic_reporter_destroy(priv);
 	mlx5e_detach_netdev(priv);
 	priv->profile->cleanup(priv);
 	mlx5e_destroy_netdev(netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 70640fa1ad7bc..bcd7b4e814d06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -118,7 +118,6 @@ struct mlx5e_rep_priv {
 	struct rtnl_link_stats64 prev_vf_vport_stats;
 	struct mlx5_flow_handle *send_to_vport_meta_rule;
 	struct rhashtable tc_ht;
-	struct devlink_health_reporter *rep_vnic_reporter;
 };
 
 static inline
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 37e52f29a8149..bac24f158978b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -4,6 +4,26 @@
 #include <linux/mlx5/driver.h>
 #include "eswitch.h"
 #include "devlink.h"
+#include "diag/reporter_vnic.h"
+
+static int
+mlx5_esw_rep_vnic_reporter_diagnose(struct devlink_health_reporter *reporter,
+				    struct devlink_fmsg *fmsg,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = devlink_health_reporter_priv(reporter);
+
+	mlx5_reporter_vnic_diagnose_counters(vport->dev, fmsg, vport->vport,
+					     true);
+
+	return 0;
+}
+
+static const
+struct devlink_health_reporter_ops mlx5_esw_rep_vnic_reporter_ops = {
+	.name = "vnic",
+	.diagnose = mlx5_esw_rep_vnic_reporter_diagnose,
+};
 
 static void
 mlx5_esw_get_port_parent_id(struct mlx5_core_dev *dev, struct netdev_phys_item_id *ppid)
@@ -189,6 +209,7 @@ static void mlx5_esw_devlink_port_res_unregister(struct devlink_port *dl_port)
 
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
+	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *dev = esw->dev;
 	const struct devlink_port_ops *ops;
 	struct mlx5_devlink_port *dl_port;
@@ -227,6 +248,16 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx
 				       err);
 	}
 
+	reporter = devl_port_health_reporter_create(
+		&dl_port->dl_port, &mlx5_esw_rep_vnic_reporter_ops,
+		vport);
+	if (IS_ERR(reporter))
+		mlx5_core_err(dev,
+			      "Failed to create vnic health reporter for vport %d: %pe\n",
+			      vport_num, reporter);
+	else
+		dl_port->vnic_reporter = reporter;
+
 	return 0;
 
 rate_err:
@@ -241,6 +272,12 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_vport *vport)
 	if (!vport->dl_port)
 		return;
 	dl_port = vport->dl_port;
+
+	if (dl_port->vnic_reporter) {
+		devl_health_reporter_destroy(dl_port->vnic_reporter);
+		dl_port->vnic_reporter = NULL;
+	}
+
 	mlx5_esw_devlink_port_res_unregister(&dl_port->dl_port);
 
 	mlx5_esw_qos_vport_update_parent(vport, NULL, NULL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index eca24c1929eb4..01f56519334cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -179,6 +179,7 @@ struct mlx5_vport;
 struct mlx5_devlink_port {
 	struct devlink_port dl_port;
 	struct mlx5_vport *vport;
+	struct devlink_health_reporter *vnic_reporter;
 };
 
 static inline void mlx5_devlink_port_init(struct mlx5_devlink_port *dl_port,
-- 
2.53.0



