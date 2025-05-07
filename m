Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26B22144C1;
	Wed,  7 May 2025 19:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645072; cv=none; b=Pa3nF2WWwKAObLX4ZwBOS2igMhdF+J4znolobEBPLeUzO6ucFMaHX7k8y7AeuYy7UwLYsvN0wYnAV3fcsrQ7lVMbbkH4e4UUPLNktEaLjO7t7dXd9AJVBD+kywOD3OInhW53510SjIol+3DA8k3BCVkDFO+JZLoyR5+ZhoeDkEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645072; c=relaxed/simple;
	bh=wc3ZVTZj8mTII4LC9kmDJ/lHIDr5O9ouA7cDy5BlWuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si9aylizF2LElLZ9f7qPZKeADR8M75AXvxCDguTu5PD21vlbN6fqel/nSSk8tD1Vi6G6IgrHC1CKm+xA+fNlZh15laqpjeg1kSaNG8mWAwM8O3ma08jLAF7d2Yf9DEMfBi6lVsgMvxl4AWy1UDLDG2vL4i8ldWg3deWv6GS0ZR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjYyKrHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjYyKrHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1132FC4CEE2;
	Wed,  7 May 2025 19:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645072;
	bh=wc3ZVTZj8mTII4LC9kmDJ/lHIDr5O9ouA7cDy5BlWuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjYyKrHz13OMCrpDC4QeJ80KY6d6Nf7ih3A/EOI1f0VpS/wHyMLJy/qu0Pf6Xa980
	 mEQplKuAWtaBkFTDNcP3hnJs5qclgqVMzz0aQ5j5dKo4pF7G+noAzF5ffDdQP3RKpr
	 ww7SJBsG2IVeZI3aGBY6OVlhmRjZrvm+4TYt9a5c=
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
Subject: [PATCH 6.6 055/129] net/mlx5: E-switch, Fix error handling for enabling roce
Date: Wed,  7 May 2025 20:39:51 +0200
Message-ID: <20250507183815.763523186@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7eba3a5bb97ca..326c72b3df867 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3499,7 +3499,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	int err;
 
 	mutex_init(&esw->offloads.termtbl_mutex);
-	mlx5_rdma_enable_roce(esw->dev);
+	err = mlx5_rdma_enable_roce(esw->dev);
+	if (err)
+		goto err_roce;
 
 	err = mlx5_esw_host_number_init(esw);
 	if (err)
@@ -3560,6 +3562,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	esw_offloads_metadata_uninit(esw);
 err_metadata:
 	mlx5_rdma_disable_roce(esw->dev);
+err_roce:
 	mutex_destroy(&esw->offloads.termtbl_mutex);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index f585ef5a34243..5c552b71e371c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -140,17 +140,17 @@ void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev)
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
@@ -165,10 +165,11 @@ void mlx5_rdma_enable_roce(struct mlx5_core_dev *dev)
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



