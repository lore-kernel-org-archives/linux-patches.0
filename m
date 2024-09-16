Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0704515748E;
	Mon, 16 Sep 2024 12:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488348; cv=none; b=elqWSiLAPyDP8LlckdoVDer+xCCcUZZSPBP8+gmWzwGnlBYuG5aSaCvXw4SnZaD9wzgLzA4IlXXSWcrqSJtEFg2BQerOgvnw7DvUi7iL2oWowXW8v0S5vGMaA3COLopPAI8scFf9xgpCTpRsNbJy3ooZuxsZdtqIIYWv/9PJA2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488348; c=relaxed/simple;
	bh=tc0M9LGMOy8SfvZsmp/g8MQNVscwy4gpOt9V77keYDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IE94OgN2Vr4othH3niWIj1DHrf7Dquq3hNDyYjfRBUOM2Xw665xstR5hnTodk/10sBpqXlU17HB1PqPDzFda+lyJSJa/GN8XG+AQEIVTCGgkrQwAmg/hsmZXBcz2wbSn+oHNwiq1s5Ggt3ikAayXzpk1NxCrffQV88gdD8n8OXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tCpk51a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tCpk51a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23614C4CEC4;
	Mon, 16 Sep 2024 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488347;
	bh=tc0M9LGMOy8SfvZsmp/g8MQNVscwy4gpOt9V77keYDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tCpk51adqskVoGmOlgwGb1ohx256KXg2EKfj6bfMQvtB+ATwr31CZjuS8VGCLe9q
	 bvYz8uWlkaGCI75Lq2QrHFb9ioUg81phoh2jZ9AUb6cFKojWD1CH/UB7xztQ85z9Dd
	 bFEGiIPFdUJRspZ0q8f+1BxdNer/5nWFC5tkJ0uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 082/121] net/mlx5: Verify support for scheduling element and TSAR type
Date: Mon, 16 Sep 2024 13:44:16 +0200
Message-ID: <20240916114231.859632924@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 861cd9b9cb62feb244b8d77e68fd6ddedbbf66e9 ]

Before creating a scheduling element in a NIC or E-Switch scheduler,
ensure that the requested element type is supported. If the element is
of type Transmit Scheduling Arbiter (TSAR), also verify that the
specific TSAR type is supported.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Fixes: 85c5f7c9200e ("net/mlx5: E-switch, Create QoS on demand")
Fixes: 0fe132eac38c ("net/mlx5: E-switch, Allow to add vports to rate groups")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 44 ++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/qos.c |  7 +++
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 997c412a81af..02a3563f51ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -312,6 +312,25 @@ static int esw_qos_set_group_max_rate(struct mlx5_eswitch *esw,
 	return err;
 }
 
+static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
+{
+	switch (type) {
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_TSAR;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_VPORT;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT_TC:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_VPORT_TC;
+	case SCHEDULING_CONTEXT_ELEMENT_TYPE_PARA_VPORT_TC:
+		return MLX5_CAP_QOS(dev, esw_element_type) &
+		       ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC;
+	}
+	return false;
+}
+
 static int esw_qos_vport_create_sched_element(struct mlx5_eswitch *esw,
 					      struct mlx5_vport *vport,
 					      u32 max_rate, u32 bw_share)
@@ -323,6 +342,9 @@ static int esw_qos_vport_create_sched_element(struct mlx5_eswitch *esw,
 	void *vport_elem;
 	int err;
 
+	if (!esw_qos_element_type_supported(dev, SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT))
+		return -EOPNOTSUPP;
+
 	parent_tsar_ix = group ? group->tsar_ix : esw->qos.root_tsar_ix;
 	MLX5_SET(scheduling_context, sched_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT);
@@ -533,25 +555,6 @@ static int esw_qos_destroy_rate_group(struct mlx5_eswitch *esw,
 	return err;
 }
 
-static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
-{
-	switch (type) {
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_TSAR;
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_VPORT;
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT_TC:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_VPORT_TC;
-	case SCHEDULING_CONTEXT_ELEMENT_TYPE_PARA_VPORT_TC:
-		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC;
-	}
-	return false;
-}
-
 static int esw_qos_create(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
@@ -562,7 +565,8 @@ static int esw_qos_create(struct mlx5_eswitch *esw, struct netlink_ext_ack *exta
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
 		return -EOPNOTSUPP;
 
-	if (!esw_qos_element_type_supported(dev, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR))
+	if (!esw_qos_element_type_supported(dev, SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR) ||
+	    !(MLX5_CAP_QOS(dev, esw_tsar_type) & TSAR_TYPE_CAP_MASK_DWRR))
 		return -EOPNOTSUPP;
 
 	MLX5_SET(scheduling_context, tsar_ctx, element_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
index 8bce730b5c5b..db2bd3ad63ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qos.c
@@ -28,6 +28,9 @@ int mlx5_qos_create_leaf_node(struct mlx5_core_dev *mdev, u32 parent_id,
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
 
+	if (!(MLX5_CAP_QOS(mdev, nic_element_type) & ELEMENT_TYPE_CAP_MASK_QUEUE_GROUP))
+		return -EOPNOTSUPP;
+
 	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_id);
 	MLX5_SET(scheduling_context, sched_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_QUEUE_GROUP);
@@ -44,6 +47,10 @@ int mlx5_qos_create_inner_node(struct mlx5_core_dev *mdev, u32 parent_id,
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {0};
 	void *attr;
 
+	if (!(MLX5_CAP_QOS(mdev, nic_element_type) & ELEMENT_TYPE_CAP_MASK_TSAR) ||
+	    !(MLX5_CAP_QOS(mdev, nic_tsar_type) & TSAR_TYPE_CAP_MASK_DWRR))
+		return -EOPNOTSUPP;
+
 	MLX5_SET(scheduling_context, sched_ctx, parent_element_id, parent_id);
 	MLX5_SET(scheduling_context, sched_ctx, element_type,
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
-- 
2.43.0



