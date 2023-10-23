Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E079914282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xylGSTGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA96C433C8;
	Mon, 23 Oct 2023 11:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059432;
	bh=Ar0La9h1vNLBvctzfDrDl0zNBH3vk19WAoiUa4OdBPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xylGSTGXV0cWpdQCfzUQClVRTM+j00OG4xvfh+X225QM5wcTetRQs5c80jtqLpy0N
	 WFiM1GQNdETXWcmO/cLAaLKniWHtCNz+OxPH0dBAKvVP+rAx8tZgkOVw9lJtUucLKO
	 XCIQVuY2xbe9tsY+yF/2eumDain/hUIvIUi1B5Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 149/241] net/mlx5: E-switch, register event handler before arming the event
Date: Mon, 23 Oct 2023 12:55:35 +0200
Message-ID: <20231023104837.500867396@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 7624e58a8b3a251e3e5108b32f2183b34453db32 ]

Currently, mlx5 is registering event handler for vport context change
event some time after arming the event. this can lead to missing an
event, which will result in wrong rules in the FDB.
Hence, register the event handler before arming the event.

This solution is valid since FW is sending vport context change event
only on vports which SW armed, and SW arming the vport when enabling
it, which is done after the FDB has been created.

Fixes: 6933a9379559 ("net/mlx5: E-Switch, Use async events chain")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c   | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6e9b1b183190d..51afb97b9e452 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1022,11 +1022,8 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	return ERR_PTR(err);
 }
 
-static void mlx5_eswitch_event_handlers_register(struct mlx5_eswitch *esw)
+static void mlx5_eswitch_event_handler_register(struct mlx5_eswitch *esw)
 {
-	MLX5_NB_INIT(&esw->nb, eswitch_vport_event, NIC_VPORT_CHANGE);
-	mlx5_eq_notifier_register(esw->dev, &esw->nb);
-
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS && mlx5_eswitch_is_funcs_handler(esw->dev)) {
 		MLX5_NB_INIT(&esw->esw_funcs.nb, mlx5_esw_funcs_changed_handler,
 			     ESW_FUNCTIONS_CHANGED);
@@ -1034,13 +1031,11 @@ static void mlx5_eswitch_event_handlers_register(struct mlx5_eswitch *esw)
 	}
 }
 
-static void mlx5_eswitch_event_handlers_unregister(struct mlx5_eswitch *esw)
+static void mlx5_eswitch_event_handler_unregister(struct mlx5_eswitch *esw)
 {
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS && mlx5_eswitch_is_funcs_handler(esw->dev))
 		mlx5_eq_notifier_unregister(esw->dev, &esw->esw_funcs.nb);
 
-	mlx5_eq_notifier_unregister(esw->dev, &esw->nb);
-
 	flush_workqueue(esw->work_queue);
 }
 
@@ -1419,6 +1414,9 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs)
 
 	mlx5_eswitch_update_num_of_vfs(esw, num_vfs);
 
+	MLX5_NB_INIT(&esw->nb, eswitch_vport_event, NIC_VPORT_CHANGE);
+	mlx5_eq_notifier_register(esw->dev, &esw->nb);
+
 	if (esw->mode == MLX5_ESWITCH_LEGACY) {
 		err = esw_legacy_enable(esw);
 	} else {
@@ -1431,7 +1429,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int num_vfs)
 
 	esw->fdb_table.flags |= MLX5_ESW_FDB_CREATED;
 
-	mlx5_eswitch_event_handlers_register(esw);
+	mlx5_eswitch_event_handler_register(esw);
 
 	esw_info(esw->dev, "Enable: mode(%s), nvfs(%d), necvfs(%d), active vports(%d)\n",
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
@@ -1558,7 +1556,8 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw)
 	 */
 	mlx5_esw_mode_change_notify(esw, MLX5_ESWITCH_LEGACY);
 
-	mlx5_eswitch_event_handlers_unregister(esw);
+	mlx5_eq_notifier_unregister(esw->dev, &esw->nb);
+	mlx5_eswitch_event_handler_unregister(esw);
 
 	esw_info(esw->dev, "Disable: mode(%s), nvfs(%d), necvfs(%d), active vports(%d)\n",
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
-- 
2.40.1



