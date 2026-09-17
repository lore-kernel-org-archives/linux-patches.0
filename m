Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3992A207E00;
	Thu, 17 Sep 2026 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661213; cv=none; b=RQhCCZ6kv9UaJo3d+Vvg42Ldj78M9crwmepWjijgWJLyzRQIQPhsqbCn8Kz7cMeGAK80ybTZ/bS47gdTN9EU/xxi3x+gUhX3Y6XDnO3Rxdq0YVVWwCAXhxjksw0KPaGN3hSMb35fffjHAiICX5yNafTY7yYE3+gbuiRlL6s2xYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661213; c=relaxed/simple;
	bh=ryNq9AOuAODsE8fIafLcPBePsbMTuAjOhuzTwFfGKAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkERS4O6lxtEAKDjGsU8o9ADU/l1yQn7E/5/t7/VFaXbzjl4CiQU9UnWP99pRJCZTZOrt2YwpKWKQLVwbreYxK6gr3ShcYoGLFPhNcyHnQB64AN4lWb2sKlLGqynIt+F7zmqTZeiD7yatZYt2bVQgPhYkGTn3RWTjSIjI+O1rJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMMHUVq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMMHUVq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D1D1F00893;
	Thu, 17 Sep 2026 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661211;
	bh=6zR13ktnxtIii7i7lyen0WiYCk2JWTrGRjfZqnsHMCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMMHUVq4Y59A3n0D9wV8ErYq6DEDP3xFzhwUu36d73KLN0RuLkbUOXaP4uCW+VpBr
	 Lmf4juA5/vVVnP7RjdJBWaiyZ3cc2OvpPKlTQCqIOl+2HVwVPxTTiyniKESD7Vi7KO
	 IUlqcVPMqOuhX2gzaiBod7vIABYxjoilItYvQNJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0081/1250] net/mlx5: Relax capability check for eswitch query paths
Date: Thu, 17 Sep 2026 15:57:56 +0100
Message-ID: <20260917151554.168015245@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 8ca32460815f6876095be8798adcf5ab982e94de ]

Several eswitch functions that only query other functions' HCA
capabilities or read cached vport state are guarded by the
vhca_resource_manager capability. This capability is required for
set_hca_cap operations but query_hca_cap of other functions only
requires the vport_group_manager capability.

Relax the capability check from vhca_resource_manager to
vport_group_manager in the following query-only paths:
- mlx5_esw_vport_caps_get() - queries other function general caps
- esw_ipsec_vf_query_generic() - queries other function ipsec cap
- mlx5_devlink_port_fn_migratable_get() - reads cached vport state
- mlx5_devlink_port_fn_roce_get() - reads cached vport state
- mlx5_devlink_port_fn_max_io_eqs_get() - queries other function caps
- mlx5_esw_vport_enable/disable() - vhca_id map/unmap

Functions that perform also set_hca_cap (migratable_set, roce_set,
max_io_eqs_set, esw_ipsec_vf_set_generic, esw_ipsec_vf_set_bytype)
retain the vhca_resource_manager requirement.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260506133239.276237-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/esw/ipsec.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  6 +++---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 14 ++++++++------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
index da10e04777cf7..1dbafeddd4b2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
@@ -12,7 +12,7 @@ static int esw_ipsec_vf_query_generic(struct mlx5_core_dev *dev, u16 vport_num,
 	void *hca_cap, *query_cap;
 	int err;
 
-	if (!MLX5_CAP_GEN(dev, vhca_resource_manager))
+	if (!MLX5_CAP_GEN(dev, vport_group_manager))
 		return -EOPNOTSUPP;
 
 	if (!mlx5_esw_ipsec_vf_offload_supported(dev)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index bc7ceb4c76e5c..578f4c81f5fb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -799,7 +799,7 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
 	void *hca_caps;
 	int err;
 
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager))
 		return 0;
 
 	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
@@ -952,7 +952,7 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 		vport->info.trusted = true;
 
 	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
-	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
+	    MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
 		ret = mlx5_esw_vport_vhca_id_map(esw, vport);
 		if (ret)
 			goto err_vhca_mapping;
@@ -999,7 +999,7 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 		arm_vport_context_events_cmd(esw->dev, vport_num, 0);
 
 	if (!mlx5_esw_is_manager_vport(esw, vport_num) &&
-	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+	    MLX5_CAP_GEN(esw->dev, vport_group_manager))
 		mlx5_esw_vport_vhca_id_unmap(esw, vport);
 
 	if (vport->vport != MLX5_VPORT_PF &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d5fc07bab1902..fa833c9ba4744 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4535,8 +4535,9 @@ int mlx5_devlink_port_fn_migratable_get(struct devlink_port *port, bool *is_enab
 		return -EOPNOTSUPP;
 	}
 
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
-		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support VHCA management");
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device doesn't support vport group management");
 		return -EOPNOTSUPP;
 	}
 
@@ -4611,8 +4612,9 @@ int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
 	struct mlx5_eswitch *esw = mlx5_devlink_eswitch_nocheck_get(port->devlink);
 	struct mlx5_vport *vport = mlx5_devlink_port_vport_get(port);
 
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
-		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support VHCA management");
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device doesn't support vport group management");
 		return -EOPNOTSUPP;
 	}
 
@@ -4876,9 +4878,9 @@ mlx5_devlink_port_fn_max_io_eqs_get(struct devlink_port *port, u32 *max_io_eqs,
 	int err;
 
 	esw = mlx5_devlink_eswitch_nocheck_get(port->devlink);
-	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager)) {
+	if (!MLX5_CAP_GEN(esw->dev, vport_group_manager)) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Device doesn't support VHCA management");
+				   "Device doesn't support vport group management");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.53.0



