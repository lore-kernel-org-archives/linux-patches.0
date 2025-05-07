Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9F814A4C7;
	Wed,  7 May 2025 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643316; cv=none; b=sPpDATkKWzh8oRYT+AULsWk4ZuL4Wekc2lWZ5WKO7E0RoQ5YsAdg54AssdJ5UR0eZ45tK4yGoAjqabdg6P7wo/i8yITezgpaSj1zXQXlpdJBKtiMI+aWC0oKoalDw66ge4mRq5ZrZPiHgI72qI0yY2VaR3/6GSAzruWAzlC8ido=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643316; c=relaxed/simple;
	bh=7rwHFvlOX+QHoFVpWOsgiLbMtCpJNJirc6WmklbK+YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWNMbrw/RYjCJO39Utlw2aE4Xd3TuYw+kZaDu5G6O9AfAiO2fDOoMi10/OV6KQgxti9VvUKpL51jsdHNeDrWIxdnbDi9Lp5dCmcNbRByc7Y+h1vB10kkNwiMvZjAzWv8bWxFqdz4EZJuigf7PHU6Pst0H97IO34+XQqq4X3Efvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5vLDuIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5vLDuIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9585C4CEE2;
	Wed,  7 May 2025 18:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643315;
	bh=7rwHFvlOX+QHoFVpWOsgiLbMtCpJNJirc6WmklbK+YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5vLDuIccl427cjoxsulCJt+Mpq086ai8viKRRyCKLWhgtWGqzZv0l7WZXF28bGeK
	 JIFl8jKoaJoak+YfBvGZxme7x3PRZUr47gx7hcFkMTg3yLrMmuZbr7NTKkvjnj2Fxm
	 pVEXYkT2x2VgLFRevBPBU4KOPuyYylBC/p4PCCw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/55] net/mlx5: E-switch, Fix error handling for enabling roce
Date: Wed,  7 May 2025 20:39:20 +0200
Message-ID: <20250507183759.819735723@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 90538d23278a981e344d364e923162fce752afeb ]

The cited commit assumes enabling roce always succeeds. But it is
not true. Add error handling for it.

Fixes: 80f09dfc237f ("net/mlx5: Eswitch, enable RoCE loopback traffic")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250423083611.324567-6-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c           | 9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/rdma.h           | 4 ++--
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 829f703233a9e..766a05f557fba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3138,7 +3138,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	int err;
 
 	mutex_init(&esw->offloads.termtbl_mutex);
-	mlx5_rdma_enable_roce(esw->dev);
+	err = mlx5_rdma_enable_roce(esw->dev);
+	if (err)
+		goto err_roce;
 
 	err = mlx5_esw_host_number_init(esw);
 	if (err)
@@ -3198,6 +3200,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	esw_offloads_metadata_uninit(esw);
 err_metadata:
 	mlx5_rdma_disable_roce(esw->dev);
+err_roce:
 	mutex_destroy(&esw->offloads.termtbl_mutex);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index ab5afa6c5e0fd..e61a4fa46d772 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -152,17 +152,17 @@ void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev)
 	mlx5_nic_vport_disable_roce(dev);
 }
 
-void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
+int mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
 {
 	int err;
 
 	if (!MLX5_CAP_GEN(dev, roce))
-		return;
+		return 0;
 
 	err = mlx5_nic_vport_enable_roce(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to enable RoCE: %d\n", err);
-		return;
+		return err;
 	}
 
 	err = mlx5_rdma_add_roce_addr(dev);
@@ -177,10 +177,11 @@ void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
 		goto del_roce_addr;
 	}
 
-	return;
+	return err;
 
 del_roce_addr:
 	mlx5_rdma_del_roce_addr(dev);
 disable_roce:
 	mlx5_nic_vport_disable_roce(dev);
+	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.h b/drivers/net/ethernet/mellanox/mlx5/core/rdma.h
index 750cff2a71a4b..3d9e76c3d42fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.h
@@ -8,12 +8,12 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
-void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev);
+int mlx5_rdma_enable_roce(struct mlx5_core_dev *dev);
 void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev);
 
 #else /* CONFIG_MLX5_ESWITCH */
 
-static inline void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev) {}
+static inline int mlx5_rdma_enable_roce(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev) {}
 
 #endif /* CONFIG_MLX5_ESWITCH */
-- 
2.39.5



