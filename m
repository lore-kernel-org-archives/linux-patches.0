Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2B615C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C8FC433D6;
	Mon,  5 Dec 2022 19:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268334;
	bh=Zb94JEGq9rOVFwl1NdBQhBjuff42FdSt0l59RRiH5EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDyFt9DhrajNuy1BCmipS11YOewzgq+o3bVvcKKdLF8GcyUL9FYe5eTbDEttLeD+1
	 P4EsbpRcCvTI+hDke/phW42ROUKW2ocoZXx6tAOyZK0NMuvf8ykNTlhIS/pR66b8PZ
	 yyEWJd278KEOBIsEhe3q8n+ibZyGVUHfYB0K3PX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 036/124] net/mlx5: E-switch, Fix duplicate lag creation
Date: Mon,  5 Dec 2022 20:09:02 +0100
Message-Id: <20221205190809.469694056@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit e87c6a832f889c093c055a30a7b8c6843e6573bf ]

If creating bond first and then enabling sriov in switchdev mode,
will hit the following syndrome:

mlx5_core 0000:08:00.0: mlx5_cmd_out_err:778:(pid 25543): CREATE_LAG(0x840) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x7d49cb), err(-22)

The reason is because the offending patch removes eswitch mode
none. In vf lag, the checking of eswitch mode none is replaced
by checking if sriov is enabled. But when driver enables sriov,
it triggers the bond workqueue task first and then setting sriov
number in pci_enable_sriov(). So the check fails.

Fix it by checking if sriov is enabled using eswitch internal
counter that is set before triggering the bond workqueue task.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 87ce5a208cb5..5ceed4e6c658 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -731,6 +731,14 @@ void mlx5_eswitch_offloads_destroy_single_fdb(struct mlx5_eswitch *master_esw,
 					      struct mlx5_eswitch *slave_esw);
 int mlx5_eswitch_reload_reps(struct mlx5_eswitch *esw);
 
+static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
+{
+	if (mlx5_esw_allowed(esw))
+		return esw->esw_funcs.num_vfs;
+
+	return 0;
+}
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 065102278cb8..a879e0b0f702 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -649,8 +649,9 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 
 #ifdef CONFIG_MLX5_ESWITCH
 	dev = ldev->pf[MLX5_LAG_P1].dev;
-	if ((mlx5_sriov_is_enabled(dev)) && !is_mdev_switchdev_mode(dev))
-		return false;
+	for (i = 0; i  < ldev->ports; i++)
+		if (mlx5_eswitch_num_vfs(dev->priv.eswitch) && !is_mdev_switchdev_mode(dev))
+			return false;
 
 	mode = mlx5_eswitch_mode(dev);
 	for (i = 0; i < ldev->ports; i++)
-- 
2.35.1



