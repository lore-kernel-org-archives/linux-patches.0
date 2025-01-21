Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C91A1F3FFE;
	Tue, 21 Jan 2025 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483023; cv=none; b=OVJUvzD/O2+dnpues7XjiILaH9Jr0ouYGJL4E0t9CebV0cu7Seb3UFP1xCXJKW0mhDDR3hO5yX8eG4cgLBWIHTLpHkjffxsP9UjdP1JswLJKwoEp99KSrG3+GlGl5CErOjottFmjjiGGyeBXB1/KodNi69g1hsHyClPHSgiRD1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483023; c=relaxed/simple;
	bh=FX9JeJmLxoCId+k4eX06GjVRA6QY64d6YFo2EJu2Lm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk1B1f8NJdQNIBOQzlPU3nPc1Z4sQnCUwatctgMmzi+wAfDxe9eagqoGmu5o9O0RStTNYHCLj7LFs0djP6lxTTjmMyCPZL7QTn7UL2g5vEqGqM1FTjuiWbChx3dyq/LmEhZs4sbzWWJ+6njg6vaXPWa7CY+AMlfX19ZpuOrOSf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jIqzF/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jIqzF/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEE6C4CEDF;
	Tue, 21 Jan 2025 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483023;
	bh=FX9JeJmLxoCId+k4eX06GjVRA6QY64d6YFo2EJu2Lm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jIqzF/Cq1Fr4CNPk4++jPN69x/FxbKzZ7b/i9PEHPF78njHx+rQKsFp35OMp5U22
	 qUGNGe8XIBej8+WPV/XgvI+px4DccutbykjcsrJlkVdq0luDtveQUCroq/Gccre6Lt
	 dpZAfZ5R8aSGhN0UuzBGcPAaxxoWxRqfFJztljLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/127] net/mlx5: Refactor mlx5_get_flow_namespace
Date: Tue, 21 Jan 2025 18:52:41 +0100
Message-ID: <20250121174533.081654871@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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
index 54409a9307c2d..9632abb83f04c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2310,6 +2310,22 @@ struct mlx5_flow_namespace *mlx5_get_fdb_sub_ns(struct mlx5_core_dev *dev,
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
@@ -2335,31 +2351,35 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
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



