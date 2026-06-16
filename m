Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42A143E4BA;
	Tue, 16 Jun 2026 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626867; cv=none; b=EZM8j5brgLyl+eDKIA1zpoA6TMARD8CV0hs8fqCRAENuJAv+iws4P54jk+qOr5MzmmHgMwuaP0whGAzp7eEyDMJq4GeUbilqBAOVX/9uLgq+rVGVp60ANJj3EcVNgZP7MUNGuOkFQ6Lqi2j1j/iM4HO1Uqacxx+WJrcRd9H9ejA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626867; c=relaxed/simple;
	bh=c9FTHb1GmQD8SnD3PkwqCu5zAXvmsuajUqzvSp9iunA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZozaar7wqfqsLxbkc+62VNn6k+kgFqGlrKeFkHfBM3rcRI1J/qwclQLkqoKfo54s9AS+QA/SHYMtmmWFGE4iKRJ+8fcSF0sZ5zNcFKtdLiQKJ6jbls3RwEc3KeZP1GAuIPModISNiA86WhTiajRLA8p5allSO9kHLrXgiKFhv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nM6oDgMc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nM6oDgMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7671F000E9;
	Tue, 16 Jun 2026 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626866;
	bh=pkFTnejS5Dok2+AahbS0BFGtzlcpJg5XXE84+fdUyRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nM6oDgMch0khxz4gWPuhe4ZfUJaSXASYfkrtnOtzTmR6P5QhQcXpcEoV44jEy0cJo
	 be54RNImK4YROwYEO1mnjcy7A2HBMwndn7q1rMfB7l8kJVgN83G6JZgWHLl94i8AHj
	 DR4XkDLNdhVXU44NHWfcibVxNMHU/lamG7iRe828=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/261] net/mlx5: Fix slab-out-of-bounds in mlx5_query_nic_vport_mac_list
Date: Tue, 16 Jun 2026 20:28:43 +0530
Message-ID: <20260616145048.992422559@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 894e036a24a26a6dd7b17d8d3fb5c53ab48a6074 ]

mlx5_query_nic_vport_mac_list() sizes its firmware command buffer using
the PF's log_max_current_uc/mc_list capabilities. When querying a VF
vport with a larger configured max (via devlink), the firmware response
can overflow this buffer:

 BUG: KASAN: slab-out-of-bounds in mlx5_query_nic_vport_mac_list+0x453/0x4c0 [mlx5_core]
 Read of size 4 at addr ff1100013ffc8a12 by task kworker/u96:2/385

 CPU: 12 UID: 0 PID: 385 Comm: kworker/u96:2 Not tainted 7.0.0-rc6+ #1 PREEMPT
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
 Workqueue: mlx5_esw_wq esw_vport_change_handler [mlx5_core]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x69/0xa0
  print_report+0x176/0x4e4
  kasan_report+0xc8/0x100
  mlx5_query_nic_vport_mac_list+0x453/0x4c0 [mlx5_core]
  esw_update_vport_addr_list+0x2e3/0xda0 [mlx5_core]
  esw_vport_change_handle_locked+0xa1f/0x1060 [mlx5_core]
  esw_vport_change_handler+0x6a/0x90 [mlx5_core]
  process_one_work+0x87f/0x15e0
  worker_thread+0x62b/0x1020
  kthread+0x375/0x490
  ret_from_fork+0x4dc/0x810
  ret_from_fork_asm+0x11/0x20
  </TASK>

Fix by querying the vport's own HCA caps to size the buffer correctly.
Refactor the function to allocate and return the MAC list internally,
removing the caller's dependency on knowing the correct max.

Fixes: e16aea2744ab ("net/mlx5: Introduce access functions to modify/query vport mac lists")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260604135849.458060-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 13 +---
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 72 ++++++++++++++-----
 include/linux/mlx5/vport.h                    |  4 +-
 3 files changed, 59 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 864e88f0577145..383ca082e8419d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -533,23 +533,16 @@ static void esw_update_vport_addr_list(struct mlx5_eswitch *esw,
 				       struct mlx5_vport *vport, int list_type)
 {
 	bool is_uc = list_type == MLX5_NVPRT_LIST_TYPE_UC;
-	u8 (*mac_list)[ETH_ALEN];
+	u8 (*mac_list)[ETH_ALEN] = NULL;
 	struct l2addr_node *node;
 	struct vport_addr *addr;
 	struct hlist_head *hash;
 	struct hlist_node *tmp;
-	int size;
+	int size = 0;
 	int err;
 	int hi;
 	int i;
 
-	size = is_uc ? MLX5_MAX_UC_PER_VPORT(esw->dev) :
-		       MLX5_MAX_MC_PER_VPORT(esw->dev);
-
-	mac_list = kcalloc(size, ETH_ALEN, GFP_KERNEL);
-	if (!mac_list)
-		return;
-
 	hash = is_uc ? vport->uc_list : vport->mc_list;
 
 	for_each_l2hash_node(node, tmp, hash, hi) {
@@ -561,7 +554,7 @@ static void esw_update_vport_addr_list(struct mlx5_eswitch *esw,
 		goto out;
 
 	err = mlx5_query_nic_vport_mac_list(esw->dev, vport->vport, list_type,
-					    mac_list, &size);
+					    &mac_list, &size);
 	if (err)
 		goto out;
 	esw_debug(esw->dev, "vport[%d] context update %s list size (%d)\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index b04024d0ae676c..fdee284835e001 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -250,35 +250,63 @@ int mlx5_modify_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 mtu)
 }
 EXPORT_SYMBOL_GPL(mlx5_modify_nic_vport_mtu);
 
+static int mlx5_vport_max_mac_list_size(struct mlx5_core_dev *dev, u16 vport,
+					enum mlx5_list_type list_type)
+{
+	void *query_ctx, *hca_caps;
+	int ret = 0;
+
+	if (!vport && !mlx5_core_is_ecpf(dev))
+		return list_type == MLX5_NVPRT_LIST_TYPE_UC ?
+			1 << MLX5_CAP_GEN(dev, log_max_current_uc_list) :
+			1 << MLX5_CAP_GEN(dev, log_max_current_mc_list);
+
+	query_ctx = kzalloc(MLX5_ST_SZ_BYTES(query_hca_cap_out), GFP_KERNEL);
+	if (!query_ctx)
+		return -ENOMEM;
+
+	ret = mlx5_vport_get_other_func_general_cap(dev, vport, query_ctx);
+	if (ret)
+		goto out;
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	ret = list_type == MLX5_NVPRT_LIST_TYPE_UC ?
+		1 << MLX5_GET(cmd_hca_cap, hca_caps, log_max_current_uc_list) :
+		1 << MLX5_GET(cmd_hca_cap, hca_caps, log_max_current_mc_list);
+
+out:
+	kfree(query_ctx);
+
+	return ret;
+}
+
 int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 				  u16 vport,
 				  enum mlx5_list_type list_type,
-				  u8 addr_list[][ETH_ALEN],
-				  int *list_size)
+				  u8 (**addr_list)[ETH_ALEN],
+				  int *addr_list_size)
 {
 	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)] = {0};
+	int allowed_list_size;
 	void *nic_vport_ctx;
 	int max_list_size;
-	int req_list_size;
 	int out_sz;
 	void *out;
 	int err;
 	int i;
 
-	req_list_size = *list_size;
+	if (!addr_list || !addr_list_size)
+		return -EINVAL;
 
-	max_list_size = list_type == MLX5_NVPRT_LIST_TYPE_UC ?
-		1 << MLX5_CAP_GEN(dev, log_max_current_uc_list) :
-		1 << MLX5_CAP_GEN(dev, log_max_current_mc_list);
+	*addr_list = NULL;
+	*addr_list_size = 0;
 
-	if (req_list_size > max_list_size) {
-		mlx5_core_warn(dev, "Requested list size (%d) > (%d) max_list_size\n",
-			       req_list_size, max_list_size);
-		req_list_size = max_list_size;
-	}
+	max_list_size = mlx5_vport_max_mac_list_size(dev, vport, list_type);
+	if (max_list_size < 0)
+		return max_list_size;
 
 	out_sz = MLX5_ST_SZ_BYTES(query_nic_vport_context_out) +
-			req_list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
+			max_list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
 
 	out = kvzalloc(out_sz, GFP_KERNEL);
 	if (!out)
@@ -297,16 +325,24 @@ int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 
 	nic_vport_ctx = MLX5_ADDR_OF(query_nic_vport_context_out, out,
 				     nic_vport_context);
-	req_list_size = MLX5_GET(nic_vport_context, nic_vport_ctx,
-				 allowed_list_size);
+	allowed_list_size = MLX5_GET(nic_vport_context, nic_vport_ctx,
+				     allowed_list_size);
+	if (!allowed_list_size)
+		goto out;
+
+	*addr_list = kcalloc(allowed_list_size, ETH_ALEN, GFP_KERNEL);
+	if (!*addr_list) {
+		err = -ENOMEM;
+		goto out;
+	}
 
-	*list_size = req_list_size;
-	for (i = 0; i < req_list_size; i++) {
+	for (i = 0; i < allowed_list_size; i++) {
 		u8 *mac_addr = MLX5_ADDR_OF(nic_vport_context,
 					nic_vport_ctx,
 					current_uc_mac_address[i]) + 2;
-		ether_addr_copy(addr_list[i], mac_addr);
+		ether_addr_copy((*addr_list)[i], mac_addr);
 	}
+	*addr_list_size = allowed_list_size;
 out:
 	kvfree(out);
 	return err;
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index c36cc6d829267e..80992c370fb074 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -95,8 +95,8 @@ int mlx5_query_hca_vport_node_guid(struct mlx5_core_dev *dev,
 int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 				  u16 vport,
 				  enum mlx5_list_type list_type,
-				  u8 addr_list[][ETH_ALEN],
-				  int *list_size);
+				  u8 (**mac_list)[ETH_ALEN],
+				  int *mac_list_size);
 int mlx5_modify_nic_vport_mac_list(struct mlx5_core_dev *dev,
 				   enum mlx5_list_type list_type,
 				   u8 addr_list[][ETH_ALEN],
-- 
2.53.0



