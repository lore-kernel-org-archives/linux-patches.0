Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C417168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081BBC433D2;
	Mon,  8 May 2023 10:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542845;
	bh=hPTzWMg8WGGT0tCP3WoFhtXbJMU9lO28CeqlKwa69PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzZlbvOIe7o3/TiYAyVu2UnEZxOIzYlI5qZrDaAIjT8e0CCkwDdUkw8swP5WcWTK5
	 nw6vzQvDgBD4IZ2ZJa21pmfVPGQ0fttDH8CaIH21v31Guf5Rl4V+GQYyDs+BGHZB6G
	 WbVYCgSDpSSLen9hJsdMSMYQbw4zK4tX33C+QsIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 568/663] RDMA/mlx5: Fix flow counter query via DEVX
Date: Mon,  8 May 2023 11:46:34 +0200
Message-Id: <20230508094447.639062944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 3e358ea8614ddfbc59ca7a3f5dff5dde2b350b2c ]

Commit cited in "fixes" tag added bulk support for flow counters but it
didn't account that's also possible to query a counter using a non-base id
if the counter was allocated as bulk.

When a user performs a query, validate the flow counter id given in the
mailbox is inside the valid range taking bulk value into account.

Fixes: 208d70f562e5 ("IB/mlx5: Support flow counters offset for bulk counters")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Link: https://lore.kernel.org/r/79d7fbe291690128e44672418934256254d93115.1681377114.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 31 ++++++++++++++++++++++++++-----
 include/linux/mlx5/mlx5_ifc.h     |  3 ++-
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 2211a0be16f36..f8e2baed27a5c 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -666,7 +666,21 @@ static bool devx_is_valid_obj_id(struct uverbs_attr_bundle *attrs,
 				      obj_id;
 
 	case MLX5_IB_OBJECT_DEVX_OBJ:
-		return ((struct devx_obj *)uobj->object)->obj_id == obj_id;
+	{
+		u16 opcode = MLX5_GET(general_obj_in_cmd_hdr, in, opcode);
+		struct devx_obj *devx_uobj = uobj->object;
+
+		if (opcode == MLX5_CMD_OP_QUERY_FLOW_COUNTER &&
+		    devx_uobj->flow_counter_bulk_size) {
+			u64 end;
+
+			end = devx_uobj->obj_id +
+				devx_uobj->flow_counter_bulk_size;
+			return devx_uobj->obj_id <= obj_id && end > obj_id;
+		}
+
+		return devx_uobj->obj_id == obj_id;
+	}
 
 	default:
 		return false;
@@ -1517,10 +1531,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		goto obj_free;
 
 	if (opcode == MLX5_CMD_OP_ALLOC_FLOW_COUNTER) {
-		u8 bulk = MLX5_GET(alloc_flow_counter_in,
-				   cmd_in,
-				   flow_counter_bulk);
-		obj->flow_counter_bulk_size = 128UL * bulk;
+		u32 bulk = MLX5_GET(alloc_flow_counter_in,
+				    cmd_in,
+				    flow_counter_bulk_log_size);
+
+		if (bulk)
+			bulk = 1 << bulk;
+		else
+			bulk = 128UL * MLX5_GET(alloc_flow_counter_in,
+						cmd_in,
+						flow_counter_bulk);
+		obj->flow_counter_bulk_size = bulk;
 	}
 
 	uobj->object = obj;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a9ee7bc59c901..90ab0e31ecf46 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9144,7 +9144,8 @@ struct mlx5_ifc_alloc_flow_counter_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x38];
+	u8         reserved_at_40[0x33];
+	u8         flow_counter_bulk_log_size[0x5];
 	u8         flow_counter_bulk[0x8];
 };
 
-- 
2.39.2



