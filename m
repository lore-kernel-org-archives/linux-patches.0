Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0DF3925E
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1493C433EF;
	Wed,  7 Jun 2023 20:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169303;
	bh=Jw97kesH23gOWRh0Ergps6LTZse/pYVDS4OrC+YvGao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GlwDZuIF6VUgOinStuawoiOSDRbUrnOxHOMWY9KaP+MUeT4IvBVHDDEozekGBMS/
	 2EdBH9UXv/JkMIGbQN7Xys+2w9oirj0R/A2Huica9ucvVt1xedhfkHcbFtzoLpayml
	 IjjiGB3oaiDF8zHoJp4exKi5Iye+nW36erHhZWwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 029/286] net/mlx5e: Use query_special_contexts cmd only once per mdev
Date: Wed,  7 Jun 2023 22:12:08 +0200
Message-ID: <20230607200923.964158480@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 1db1f21caebbb1b6e9b1e7657df613616be3fb49 ]

Don't query the firmware so many times (num rqs * num wqes * wqe frags)
because it slows down linearly the interface creation time when the
product is larger. Do it only once per mdev and store the result in
mlx5e_param.

Due to helper function being called from different files, move it to
an appropriate location. Rename the function with a proper prefix and
add a small cleanup.

This fix applies only for legacy rq.

Fixes: 1b1e4868836a ("net/mlx5e: Use query_special_contexts for mkeys")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++----------------
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 21 ++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 4 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 4a19ef4a98110..5ee90a394fff9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -327,6 +327,7 @@ struct mlx5e_params {
 	unsigned int sw_mtu;
 	int hard_mtu;
 	bool ptp_rx;
+	__be32 terminate_lkey_be;
 };
 
 static inline u8 mlx5e_get_dcb_num_tc(struct mlx5e_params *params)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 579c2d217fdc6..ff579d7d8432c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -668,26 +668,6 @@ static void mlx5e_rq_free_shampo(struct mlx5e_rq *rq)
 	mlx5e_rq_shampo_hd_free(rq);
 }
 
-static __be32 mlx5e_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
-{
-	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
-	int res;
-
-	if (!MLX5_CAP_GEN(dev, terminate_scatter_list_mkey))
-		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
-
-	MLX5_SET(query_special_contexts_in, in, opcode,
-		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
-	res = mlx5_cmd_exec_inout(dev, query_special_contexts, in, out);
-	if (res)
-		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
-
-	res = MLX5_GET(query_special_contexts_out, out,
-		       terminate_scatter_list_mkey);
-	return cpu_to_be32(res);
-}
-
 static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
 			  struct mlx5e_rq_param *rqp,
@@ -852,7 +832,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 			/* check if num_frags is not a pow of two */
 			if (rq->wqe.info.num_frags < (1 << rq->wqe.info.log_num_frags)) {
 				wqe->data[f].byte_count = 0;
-				wqe->data[f].lkey = mlx5e_get_terminate_scatter_list_mkey(mdev);
+				wqe->data[f].lkey = params->terminate_lkey_be;
 				wqe->data[f].addr = 0;
 			}
 		}
@@ -4973,6 +4953,8 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* RQ */
 	mlx5e_build_rq_params(mdev, params);
 
+	params->terminate_lkey_be = mlx5_core_get_terminate_scatter_list_mkey(mdev);
+
 	params->packet_merge.timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 9d735c343a3b8..678f0be813752 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -32,6 +32,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/qp.h>
 #include "mlx5_core.h"
 
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev, u32 *mkey, u32 *in,
@@ -122,3 +123,23 @@ int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num)
 	return mlx5_cmd_exec_in(dev, destroy_psv, in);
 }
 EXPORT_SYMBOL(mlx5_core_destroy_psv);
+
+__be32 mlx5_core_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(query_special_contexts_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_special_contexts_in)] = {};
+	u32 mkey;
+
+	if (!MLX5_CAP_GEN(dev, terminate_scatter_list_mkey))
+		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
+
+	MLX5_SET(query_special_contexts_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_SPECIAL_CONTEXTS);
+	if (mlx5_cmd_exec_inout(dev, query_special_contexts, in, out))
+		return MLX5_TERMINATE_SCATTER_LIST_LKEY;
+
+	mkey = MLX5_GET(query_special_contexts_out, out,
+			terminate_scatter_list_mkey);
+	return cpu_to_be32(mkey);
+}
+EXPORT_SYMBOL(mlx5_core_get_terminate_scatter_list_mkey);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7e225e41d55b8..68a3183d5d589 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1088,6 +1088,7 @@ void mlx5_cmdif_debugfs_cleanup(struct mlx5_core_dev *dev);
 int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
 			 int npsvs, u32 *sig_index);
 int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
+__be32 mlx5_core_get_terminate_scatter_list_mkey(struct mlx5_core_dev *dev);
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common);
 int mlx5_query_odp_caps(struct mlx5_core_dev *dev,
 			struct mlx5_odp_caps *odp_caps);
-- 
2.39.2



