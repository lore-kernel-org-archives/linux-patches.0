Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B7143C46;
	Tue, 23 Apr 2024 21:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908523; cv=none; b=RHeTluumrTw+klqkFF4jjlKAqpu9v1O9AjXhdaPvBkUCc61DVO326E3QJB7D5oP37yloRju7GcQfKTosDT4ZMh9HQa7UQDCa0xq8ZcLIZfZUrafNCTER8js8OtlocplYALL9byJD/0cwyKimc2KCw9VcRgf0h+TcffSCxgGfIHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908523; c=relaxed/simple;
	bh=20Z+/bKG1JVrhMkmylVRYoiQvip/LB9lkAgUZL4wpEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFwGS8ectljxCFS7jNRJO2bLdcBAkA1l6ZGJnIkwBH1oxof/jHIV9DNF8elBrwfHaMCp7MP33+zjE6SvgagpNQUW4CwRyVrvVz7c+a3oPbltPYz1UsPDu25hth4q+PAxuC/16SsTNowPhFIdgoqM8PEVddiVNFzTch/mbHUYJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwZyVyVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwZyVyVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ECDC4AF08;
	Tue, 23 Apr 2024 21:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908522;
	bh=20Z+/bKG1JVrhMkmylVRYoiQvip/LB9lkAgUZL4wpEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwZyVyVXBqqVDM52+3Ha4CRIJV6AJ0o6ygYzsVT8tAmbv2ERCe079hvpQApsgSMM1
	 6Q4NJhAfK4NXLETun4x4YEe53GKmcOk1XVnrrXvGaaTiXyKgqPv6XkGld3RQY3feNm
	 m0D+P7Gzk9vtx06JP0jlbeZX8eBqgHZKU9TTe+y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 088/158] net/mlx5: E-switch, store eswitch pointer before registering devlink_param
Date: Tue, 23 Apr 2024 14:38:30 -0700
Message-ID: <20240423213858.803345927@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 0553e753ea9ee724acaf6b3dfc7354702af83567 ]

Next patch will move devlink register to be first. Therefore, whenever
mlx5 will register a param, the user will be notified.
In order to notify the user, devlink is using the get() callback of
the param. Hence, resources that are being used by the get() callback
must be set before the devlink param is registered.

Therefore, store eswitch pointer inside mdev before registering the
param.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c        | 9 +++------
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 4 ++++
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 3047d7015c525..1789800faaeb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1868,6 +1868,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	if (err)
 		goto abort;
 
+	dev->priv.eswitch = esw;
 	err = esw_offloads_init(esw);
 	if (err)
 		goto reps_err;
@@ -1892,11 +1893,6 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
 	else
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
-	if (MLX5_ESWITCH_MANAGER(dev) &&
-	    mlx5_esw_vport_match_metadata_supported(esw))
-		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
-
-	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
 
 	esw_info(dev,
@@ -1908,6 +1904,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 
 reps_err:
 	mlx5_esw_vports_cleanup(esw);
+	dev->priv.eswitch = NULL;
 abort:
 	if (esw->work_queue)
 		destroy_workqueue(esw->work_queue);
@@ -1926,7 +1923,6 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 
 	esw_info(esw->dev, "cleanup\n");
 
-	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	WARN_ON(refcount_read(&esw->qos.refcnt));
 	mutex_destroy(&esw->state_lock);
@@ -1937,6 +1933,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	mutex_destroy(&esw->offloads.decap_tbl_lock);
 	esw_offloads_cleanup(esw);
+	esw->dev->priv.eswitch = NULL;
 	mlx5_esw_vports_cleanup(esw);
 	debugfs_remove_recursive(esw->debugfs_root);
 	devl_params_unregister(priv_to_devlink(esw->dev), mlx5_eswitch_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index baaae628b0a0f..e3cce110e52fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2476,6 +2476,10 @@ int esw_offloads_init(struct mlx5_eswitch *esw)
 	if (err)
 		return err;
 
+	if (MLX5_ESWITCH_MANAGER(esw->dev) &&
+	    mlx5_esw_vport_match_metadata_supported(esw))
+		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
+
 	err = devl_params_register(priv_to_devlink(esw->dev),
 				   esw_devlink_params,
 				   ARRAY_SIZE(esw_devlink_params));
-- 
2.43.0



