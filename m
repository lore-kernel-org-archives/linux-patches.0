Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866491F666B;
	Tue, 21 Jan 2025 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483020; cv=none; b=IFu7cQxnHjWLQ2exNuUZq4YWp4WsUWaEkvhe+OWE6qNSZy4taWYUsXOfiIOwK4EvkxululvOGr1us6+N6V7aeCED2JL3tKphMZzAPRTjpaxz4GESjyUAYirOgG/7Bt6VOp1bly8pgeJ+DXYG9ci0dok66ubObGctZpLL81VbHvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483020; c=relaxed/simple;
	bh=4BG//LDR/3M++WMKVXGPZg9ZLKEtaDT0COUdka2HltY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knBFMECO/K8iQpn2trDvxRxe+6uQVezZctUJ4DYbnjnx2Ph9Jyt6sgB/y7Tslu/CCC+zCHDCbSDniiijQ9pTUhU7bw3fmWshYaQHun+zQQIcuct9cvQc22bvuoYH7od5zrhbx5siII801Gq6FZGokWmrqYNUixVK3lLUQyuSEdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBzlZwhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBzlZwhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7EBC4CEDF;
	Tue, 21 Jan 2025 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483020;
	bh=4BG//LDR/3M++WMKVXGPZg9ZLKEtaDT0COUdka2HltY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBzlZwhIlUdKQY7QXOaRaUAMYPfr8hyZLjJsHzXIz+jhurzFTOm8iIzS9HnYfK4ND
	 /VvhQrwgfh+onIqMnPbZKMBhra5Z+OXkH1728kfTd6ewCaEUCpyn1ZukSoS2R5v+Vf
	 6XsHC9r9mWJ2JRcO60Ju4/90FzjrRHvaxb0AGRgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aharon Landau <aharonl@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/127] net/mlx5: Add priorities for counters in RDMA namespaces
Date: Tue, 21 Jan 2025 18:52:40 +0100
Message-ID: <20250121174533.045413855@linuxfoundation.org>
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

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit b8dfed636fc6239396c3a2ae5f812505906cf215 ]

Add additional flow steering priorities in the RDMA namespace.
This allows adding flow counters to count filtered RDMA traffic and then
continue processing in the regular RDMA steering flow.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Stable-dep-of: c08d3e62b2e7 ("net/mlx5: Fix RDMA TX steering prio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 54 ++++++++++++++++---
 include/linux/mlx5/device.h                   |  2 +
 include/linux/mlx5/fs.h                       |  2 +
 3 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 665619ce46746..54409a9307c2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -99,6 +99,9 @@
 #define LEFTOVERS_NUM_LEVELS 1
 #define LEFTOVERS_NUM_PRIOS 1
 
+#define RDMA_RX_COUNTERS_PRIO_NUM_LEVELS 1
+#define RDMA_TX_COUNTERS_PRIO_NUM_LEVELS 1
+
 #define BY_PASS_PRIO_NUM_LEVELS 1
 #define BY_PASS_MIN_LEVEL (ETHTOOL_MIN_LEVEL + MLX5_BY_PASS_NUM_PRIOS +\
 			   LEFTOVERS_NUM_PRIOS)
@@ -206,34 +209,63 @@ static struct init_tree_node egress_root_fs = {
 	}
 };
 
-#define RDMA_RX_BYPASS_PRIO 0
-#define RDMA_RX_KERNEL_PRIO 1
+enum {
+	RDMA_RX_COUNTERS_PRIO,
+	RDMA_RX_BYPASS_PRIO,
+	RDMA_RX_KERNEL_PRIO,
+};
+
+#define RDMA_RX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_REGULAR_PRIOS
+#define RDMA_RX_KERNEL_MIN_LEVEL (RDMA_RX_BYPASS_MIN_LEVEL + 1)
+#define RDMA_RX_COUNTERS_MIN_LEVEL (RDMA_RX_KERNEL_MIN_LEVEL + 2)
+
 static struct init_tree_node rdma_rx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 2,
+	.ar_size = 3,
 	.children = (struct init_tree_node[]) {
+		[RDMA_RX_COUNTERS_PRIO] =
+		ADD_PRIO(0, RDMA_RX_COUNTERS_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_RDMA_RX_NUM_COUNTERS_PRIOS,
+						  RDMA_RX_COUNTERS_PRIO_NUM_LEVELS))),
 		[RDMA_RX_BYPASS_PRIO] =
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS, 0,
+		ADD_PRIO(0, RDMA_RX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_REGULAR_PRIOS,
 						  BY_PASS_PRIO_NUM_LEVELS))),
 		[RDMA_RX_KERNEL_PRIO] =
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_REGULAR_PRIOS + 1, 0,
+		ADD_PRIO(0, RDMA_RX_KERNEL_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_SWITCH_DOMAIN,
 				ADD_MULTIPLE_PRIO(1, 1))),
 	}
 };
 
+enum {
+	RDMA_TX_COUNTERS_PRIO,
+	RDMA_TX_BYPASS_PRIO,
+};
+
+#define RDMA_TX_BYPASS_MIN_LEVEL MLX5_BY_PASS_NUM_PRIOS
+#define RDMA_TX_COUNTERS_MIN_LEVEL (RDMA_TX_BYPASS_MIN_LEVEL + 1)
+
 static struct init_tree_node rdma_tx_root_fs = {
 	.type = FS_TYPE_NAMESPACE,
-	.ar_size = 1,
+	.ar_size = 2,
 	.children = (struct init_tree_node[]) {
-		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
+		[RDMA_TX_COUNTERS_PRIO] =
+		ADD_PRIO(0, RDMA_TX_COUNTERS_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(MLX5_RDMA_TX_NUM_COUNTERS_PRIOS,
+						  RDMA_TX_COUNTERS_PRIO_NUM_LEVELS))),
+		[RDMA_TX_BYPASS_PRIO] =
+		ADD_PRIO(0, RDMA_TX_BYPASS_MIN_LEVEL, 0,
 			 FS_CHAINING_CAPS_RDMA_TX,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
-				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
+				ADD_MULTIPLE_PRIO(RDMA_TX_BYPASS_MIN_LEVEL,
 						  BY_PASS_PRIO_NUM_LEVELS))),
 	}
 };
@@ -2319,6 +2351,12 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		prio = RDMA_RX_KERNEL_PRIO;
 	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX) {
 		root_ns = steering->rdma_tx_root_ns;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS) {
+		root_ns = steering->rdma_rx_root_ns;
+		prio = RDMA_RX_COUNTERS_PRIO;
+	} else if (type == MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS) {
+		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_COUNTERS_PRIO;
 	} else { /* Must be NIC RX */
 		root_ns = steering->root_ns;
 		prio = type;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 1bb4945885cec..476d8fd5a7e5b 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1462,6 +1462,8 @@ static inline u16 mlx5_to_sw_pkey_sz(int pkey_sz)
 	return MLX5_MIN_PKEY_TABLE_SIZE << pkey_sz;
 }
 
+#define MLX5_RDMA_RX_NUM_COUNTERS_PRIOS 2
+#define MLX5_RDMA_TX_NUM_COUNTERS_PRIOS 1
 #define MLX5_BY_PASS_NUM_REGULAR_PRIOS 16
 #define MLX5_BY_PASS_NUM_DONT_TRAP_PRIOS 16
 #define MLX5_BY_PASS_NUM_MULTICAST_PRIOS 1
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 0e43f0fb6d73a..29db7677827d7 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -83,6 +83,8 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_TX,
+	MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS,
+	MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS,
 };
 
 enum {
-- 
2.39.5



