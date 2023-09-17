Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C599F6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ECFC433C9;
	Sun, 17 Sep 2023 19:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980292;
	bh=MyeElyos/gJfIy/td5kL8NWCdul7FK0+RIHonk36q04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7sIUMUTBm0sL9RYzzbLlBTddwaVa8IP+9k6UBP02I6MXbCr9coWkOW+ySr/h+bUe
	 EFoLMU9xTtlG40qsdulSbNXdJKMyt47HKR33rCWy+U+0l5g7NtxkcQFgcAp8wdEKnK
	 939oF3DPWJHuByq5laBnBQ512IJydTtQF1R6czKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 150/285] net/mlx5: Rework devlink port alloc/free into init/cleanup
Date: Sun, 17 Sep 2023 21:12:30 +0200
Message-ID: <20230917191056.880714565@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 4c0dac1ef8abc6295a91197884f5ceb5d11c2bd9 ]

In order to prepare the devlink port registration function to be common
for PFs/VFs and SFs, change the existing devlink port allocation and
free functions into PF/VF init and cleanup, so similar helpers could be
later on introduced for SFs. Make the init/cleanup helpers responsible
for setting/clearing the vport->dl_port pointer.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 344134609a56 ("mlx5/core: E-Switch, Create ACL FT for eswitch manager in switchdev mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     | 65 ++++++++++++-------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index fdf2be548e855..463bde802e45e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -22,20 +22,17 @@ static bool mlx5_esw_devlink_port_supported(struct mlx5_eswitch *esw, u16 vport_
 	       mlx5_core_is_ec_vf_vport(esw->dev, vport_num);
 }
 
-static struct devlink_port *mlx5_esw_dl_port_alloc(struct mlx5_eswitch *esw, u16 vport_num)
+static void mlx5_esw_offloads_pf_vf_devlink_port_attrs_set(struct mlx5_eswitch *esw,
+							   u16 vport_num,
+							   struct devlink_port *dl_port)
 {
 	struct mlx5_core_dev *dev = esw->dev;
 	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
-	struct devlink_port *dl_port;
 	u32 controller_num = 0;
 	bool external;
 	u16 pfnum;
 
-	dl_port = kzalloc(sizeof(*dl_port), GFP_KERNEL);
-	if (!dl_port)
-		return NULL;
-
 	mlx5_esw_get_port_parent_id(dev, &ppid);
 	pfnum = mlx5_get_dev_index(dev);
 	external = mlx5_core_is_ecpf_esw_manager(dev);
@@ -63,12 +60,40 @@ static struct devlink_port *mlx5_esw_dl_port_alloc(struct mlx5_eswitch *esw, u16
 		devlink_port_attrs_pci_vf_set(dl_port, 0, pfnum,
 					      vport_num - 1, false);
 	}
-	return dl_port;
 }
 
-static void mlx5_esw_dl_port_free(struct devlink_port *dl_port)
+static int mlx5_esw_offloads_pf_vf_devlink_port_init(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct devlink_port *dl_port;
+	struct mlx5_vport *vport;
+
+	if (!mlx5_esw_devlink_port_supported(esw, vport_num))
+		return 0;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	dl_port = kzalloc(sizeof(*dl_port), GFP_KERNEL);
+	if (!dl_port)
+		return -ENOMEM;
+
+	mlx5_esw_offloads_pf_vf_devlink_port_attrs_set(esw, vport_num, dl_port);
+
+	vport->dl_port = dl_port;
+	return 0;
+}
+
+static void mlx5_esw_offloads_pf_vf_devlink_port_cleanup(struct mlx5_eswitch *esw, u16 vport_num)
 {
-	kfree(dl_port);
+	struct mlx5_vport *vport;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport) || !vport->dl_port)
+		return;
+
+	kfree(vport->dl_port);
+	vport->dl_port = NULL;
 }
 
 static const struct devlink_port_ops mlx5_esw_dl_port_ops = {
@@ -89,16 +114,17 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 	struct devlink *devlink;
 	int err;
 
-	if (!mlx5_esw_devlink_port_supported(esw, vport_num))
-		return 0;
-
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
 	if (IS_ERR(vport))
 		return PTR_ERR(vport);
 
-	dl_port = mlx5_esw_dl_port_alloc(esw, vport_num);
+	err = mlx5_esw_offloads_pf_vf_devlink_port_init(esw, vport_num);
+	if (err)
+		return err;
+
+	dl_port = vport->dl_port;
 	if (!dl_port)
-		return -ENOMEM;
+		return 0;
 
 	devlink = priv_to_devlink(dev);
 	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
@@ -111,13 +137,12 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 	if (err)
 		goto rate_err;
 
-	vport->dl_port = dl_port;
 	return 0;
 
 rate_err:
 	devl_port_unregister(dl_port);
 reg_err:
-	mlx5_esw_dl_port_free(dl_port);
+	mlx5_esw_offloads_pf_vf_devlink_port_cleanup(esw, vport_num);
 	return err;
 }
 
@@ -125,11 +150,8 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vpo
 {
 	struct mlx5_vport *vport;
 
-	if (!mlx5_esw_devlink_port_supported(esw, vport_num))
-		return;
-
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
-	if (IS_ERR(vport))
+	if (IS_ERR(vport) || !vport->dl_port)
 		return;
 
 	if (vport->dl_port->devlink_rate) {
@@ -138,8 +160,7 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vpo
 	}
 
 	devl_port_unregister(vport->dl_port);
-	mlx5_esw_dl_port_free(vport->dl_port);
-	vport->dl_port = NULL;
+	mlx5_esw_offloads_pf_vf_devlink_port_cleanup(esw, vport_num);
 }
 
 struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u16 vport_num)
-- 
2.40.1



