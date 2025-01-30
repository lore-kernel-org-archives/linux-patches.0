Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5A11DDC22;
	Thu, 30 Jan 2025 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247092; cv=none; b=U0gfN31VazvIQ9afMOU19SKpzHK95YzYgZPz0maAiArgbBjVFG9AMD9aL0Wn/gD3/eRbJ7obKLArGURBv3FnHeSHX+Z3yDM2pKRvQKmE0keiboIV1ls2wRoNLdcoJz2o+1kPUAi809SzE3v4Q9L1OacQucFO1oguNa7rw5uNOZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247092; c=relaxed/simple;
	bh=Z8tJZVSei7+M8Y925ttOvVw0+4LXGRVgIu3RnpcZBBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXzYwG6/kTFLVYbrHCqshRpP5KyD5bIC4ar/35fybdclqrMiWPb92IOi7LMwZqqHt8QJIghgM/AINVGDGO2eQOP4StPSkquLek9wJD3XSbba6he+rA8EaVAcNI8w1XE247fr4SOC3LvVVnCiRAxJ6B4kBvNKgmwAOQLOUv7747Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndcviyes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndcviyes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F13C4CED2;
	Thu, 30 Jan 2025 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247092;
	bh=Z8tJZVSei7+M8Y925ttOvVw0+4LXGRVgIu3RnpcZBBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndcviyesubxktNZedfSdC9AlHaisMkZux4FlD/ePXdKVG7PiK2p5eNf/T/Lb3NwEg
	 UG1HYcLsDZJPvzL39u/hdDJkFX1up7xTL178hPKU05t5QMQmbSTJVb6+CTI3kFZP0d
	 tLi7IR4jFOjIn56xpHdDhWrQ6cYVWcWi94F519AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/133] net/mlx5: Refactor mlx5_get_flow_namespace
Date: Thu, 30 Jan 2025 15:01:09 +0100
Message-ID: <20250130140145.744587830@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 4588fed7beae6d54ef4c67c77fc39364f8fc42af ]

Have all the namespace type check in the same switch case.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: c08d3e62b2e7 ("net/mlx5: Fix RDMA TX steering prio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 44 ++++++++++++++-----
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3f49eff271cf2..3c5e9bf1cde33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2302,6 +2302,22 @@ struct mlx5_flow_namespace *mlx5_get_fdb_sub_ns(struct mlx5_core_dev *dev,
 }
 EXPORT_SYMBOL(mlx5_get_fdb_sub_ns);
 
+static bool is_nic_rx_ns(enum mlx5_flow_namespace_type type)
+{
+	switch (type) {
+	case MLX5_FLOW_NAMESPACE_BYPASS:
+	case MLX5_FLOW_NAMESPACE_LAG:
+	case MLX5_FLOW_NAMESPACE_OFFLOADS:
+	case MLX5_FLOW_NAMESPACE_ETHTOOL:
+	case MLX5_FLOW_NAMESPACE_KERNEL:
+	case MLX5_FLOW_NAMESPACE_LEFTOVERS:
+	case MLX5_FLOW_NAMESPACE_ANCHOR:
+		return true;
+	default:
+		return false;
+	}
+}
+
 struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 						    enum mlx5_flow_namespace_type type)
 {
@@ -2327,31 +2343,35 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		if (steering->sniffer_tx_root_ns)
 			return &steering->sniffer_tx_root_ns->ns;
 		return NULL;
-	default:
-		break;
-	}
-
-	if (type == MLX5_FLOW_NAMESPACE_EGRESS ||
-	    type == MLX5_FLOW_NAMESPACE_EGRESS_KERNEL) {
+	case MLX5_FLOW_NAMESPACE_EGRESS:
+	case MLX5_FLOW_NAMESPACE_EGRESS_KERNEL:
 		root_ns = steering->egress_root_ns;
 		prio = type - MLX5_FLOW_NAMESPACE_EGRESS;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX:
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_BYPASS_PRIO;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL:
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_KERNEL_PRIO;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_TX:
 		root_ns = steering->rdma_tx_root_ns;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS:
 		root_ns = steering->rdma_rx_root_ns;
 		prio = RDMA_RX_COUNTERS_PRIO;
-	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS) {
+		break;
+	case MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS:
 		root_ns = steering->rdma_tx_root_ns;
 		prio = RDMA_TX_COUNTERS_PRIO;
-	} else { /* Must be NIC RX */
+		break;
+	default: /* Must be NIC RX */
+		WARN_ON(!is_nic_rx_ns(type));
 		root_ns = steering->root_ns;
 		prio = type;
+		break;
 	}
 
 	if (!root_ns)
-- 
2.39.5



