Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E514018DF9D;
	Tue, 26 Aug 2025 11:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208129; cv=none; b=AchDn36fTf3FKp8ZX2BegukCiDWCoi9Oq+Qp1zFwKo9pUIpjMYE8UVl2O8zIPpRvlFibhObVMOZwhhkcR2Gaxk0xPldMWJgIcPgkArXFaZl4UdOckW9siBwmjUGMpvPZC60iL2D1lhHciob4tIcmagstGGMoKHvv49wAEYQcobs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208129; c=relaxed/simple;
	bh=nCKCqbQi7CRA5+zGANzmbc+UoQf8zY3z700bL0ec8us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+U4a8EbRz8ur65+jgu9eYhHaWFuQa9Yyj/GrWfLzUnL3ohVggoRStHVb5p7GQ9CmZLFlRgnNJnFeevDck1hI4bmLG6NwtxPChi/w0qa268frjPsALcfjvrcZQKf7wui3OP1uXvHm1zMS06Hd1D0eCzTQefwQtntLYdW07x/S8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rw8q5CX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rw8q5CX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75691C116B1;
	Tue, 26 Aug 2025 11:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208128;
	bh=nCKCqbQi7CRA5+zGANzmbc+UoQf8zY3z700bL0ec8us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rw8q5CX0cNqdsjeTNbXvmZI9KTmC8xyXHclcI2KOuKXRSwF5+2WotK/ZbT7+xjAnJ
	 iDyBhk16dXBQZTfShVIyc6L+56MfqKeBgb34t25JeT1URVMfy5KwBWDDpzFzd1Ud5N
	 dJDGFm0HusR5wLMsewRFy9MyngGilfWbrLiNdUeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Vesker <valex@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 418/457] net/mlx5: HWS, Fix table creation UID
Date: Tue, 26 Aug 2025 13:11:42 +0200
Message-ID: <20250826110947.623737375@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Vesker <valex@nvidia.com>

[ Upstream commit 8a51507320ebddaab32610199774f69cd7d53e78 ]

During table creation, caller passes a UID using ft_attr. The UID
value was ignored, which leads to problems when the caller sets the
UID to a non-zero value, such as SHARED_RESOURCE_UID (0xffff) - the
internal FT objects will be created with UID=0.

Fixes: 0869701cba3d ("net/mlx5: HWS, added FW commands handling")
Signed-off-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250817202323.308604-7-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/cmd.c  |  1 +
 .../ethernet/mellanox/mlx5/core/steering/hws/cmd.h  |  1 +
 .../mellanox/mlx5/core/steering/hws/fs_hws.c        |  1 +
 .../mellanox/mlx5/core/steering/hws/matcher.c       |  5 ++++-
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h       |  1 +
 .../mellanox/mlx5/core/steering/hws/table.c         | 13 ++++++++++---
 .../mellanox/mlx5/core/steering/hws/table.h         |  3 ++-
 7 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
index 9c83753e4592..0bdcab2e5cf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.c
@@ -55,6 +55,7 @@ int mlx5hws_cmd_flow_table_create(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(create_flow_table_in, in, opcode, MLX5_CMD_OP_CREATE_FLOW_TABLE);
 	MLX5_SET(create_flow_table_in, in, table_type, ft_attr->type);
+	MLX5_SET(create_flow_table_in, in, uid, ft_attr->uid);
 
 	ft_ctx = MLX5_ADDR_OF(create_flow_table_in, in, flow_table_context);
 	MLX5_SET(flow_table_context, ft_ctx, level, ft_attr->level);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.h
index fa6bff210266..122ccc671628 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/cmd.h
@@ -36,6 +36,7 @@ struct mlx5hws_cmd_set_fte_attr {
 struct mlx5hws_cmd_ft_create_attr {
 	u8 type;
 	u8 level;
+	u16 uid;
 	bool rtc_valid;
 	bool decap_en;
 	bool reformat_en;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index bf4643d0ce17..47e3947e7b51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -267,6 +267,7 @@ static int mlx5_cmd_hws_create_flow_table(struct mlx5_flow_root_namespace *ns,
 
 	tbl_attr.type = MLX5HWS_TABLE_TYPE_FDB;
 	tbl_attr.level = ft_attr->level;
+	tbl_attr.uid = ft_attr->uid;
 	tbl = mlx5hws_table_create(ctx, &tbl_attr);
 	if (!tbl) {
 		mlx5_core_err(ns->dev, "Failed creating hws flow_table\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c
index ce28ee1c0e41..6000f2c641e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/matcher.c
@@ -85,6 +85,7 @@ static int hws_matcher_create_end_ft_isolated(struct mlx5hws_matcher *matcher)
 
 	ret = mlx5hws_table_create_default_ft(tbl->ctx->mdev,
 					      tbl,
+					      0,
 					      &matcher->end_ft_id);
 	if (ret) {
 		mlx5hws_err(tbl->ctx, "Isolated matcher: failed to create end flow table\n");
@@ -112,7 +113,9 @@ static int hws_matcher_create_end_ft(struct mlx5hws_matcher *matcher)
 	if (mlx5hws_matcher_is_isolated(matcher))
 		ret = hws_matcher_create_end_ft_isolated(matcher);
 	else
-		ret = mlx5hws_table_create_default_ft(tbl->ctx->mdev, tbl,
+		ret = mlx5hws_table_create_default_ft(tbl->ctx->mdev,
+						      tbl,
+						      0,
 						      &matcher->end_ft_id);
 
 	if (ret) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
index d8ac6c196211..a2fe2f9e832d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
@@ -75,6 +75,7 @@ struct mlx5hws_context_attr {
 struct mlx5hws_table_attr {
 	enum mlx5hws_table_type type;
 	u32 level;
+	u16 uid;
 };
 
 enum mlx5hws_matcher_flow_src {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
index 568f691733f3..6113383ae47b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.c
@@ -9,6 +9,7 @@ u32 mlx5hws_table_get_id(struct mlx5hws_table *tbl)
 }
 
 static void hws_table_init_next_ft_attr(struct mlx5hws_table *tbl,
+					u16 uid,
 					struct mlx5hws_cmd_ft_create_attr *ft_attr)
 {
 	ft_attr->type = tbl->fw_ft_type;
@@ -16,7 +17,9 @@ static void hws_table_init_next_ft_attr(struct mlx5hws_table *tbl,
 		ft_attr->level = tbl->ctx->caps->fdb_ft.max_level - 1;
 	else
 		ft_attr->level = tbl->ctx->caps->nic_ft.max_level - 1;
+
 	ft_attr->rtc_valid = true;
+	ft_attr->uid = uid;
 }
 
 static void hws_table_set_cap_attr(struct mlx5hws_table *tbl,
@@ -119,12 +122,12 @@ static int hws_table_connect_to_default_miss_tbl(struct mlx5hws_table *tbl, u32
 
 int mlx5hws_table_create_default_ft(struct mlx5_core_dev *mdev,
 				    struct mlx5hws_table *tbl,
-				    u32 *ft_id)
+				    u16 uid, u32 *ft_id)
 {
 	struct mlx5hws_cmd_ft_create_attr ft_attr = {0};
 	int ret;
 
-	hws_table_init_next_ft_attr(tbl, &ft_attr);
+	hws_table_init_next_ft_attr(tbl, uid, &ft_attr);
 	hws_table_set_cap_attr(tbl, &ft_attr);
 
 	ret = mlx5hws_cmd_flow_table_create(mdev, &ft_attr, ft_id);
@@ -189,7 +192,10 @@ static int hws_table_init(struct mlx5hws_table *tbl)
 	}
 
 	mutex_lock(&ctx->ctrl_lock);
-	ret = mlx5hws_table_create_default_ft(tbl->ctx->mdev, tbl, &tbl->ft_id);
+	ret = mlx5hws_table_create_default_ft(tbl->ctx->mdev,
+					      tbl,
+					      tbl->uid,
+					      &tbl->ft_id);
 	if (ret) {
 		mlx5hws_err(tbl->ctx, "Failed to create flow table object\n");
 		mutex_unlock(&ctx->ctrl_lock);
@@ -239,6 +245,7 @@ struct mlx5hws_table *mlx5hws_table_create(struct mlx5hws_context *ctx,
 	tbl->ctx = ctx;
 	tbl->type = attr->type;
 	tbl->level = attr->level;
+	tbl->uid = attr->uid;
 
 	ret = hws_table_init(tbl);
 	if (ret) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.h
index 0400cce0c317..1246f9bd8422 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/table.h
@@ -18,6 +18,7 @@ struct mlx5hws_table {
 	enum mlx5hws_table_type type;
 	u32 fw_ft_type;
 	u32 level;
+	u16 uid;
 	struct list_head matchers_list;
 	struct list_head tbl_list_node;
 	struct mlx5hws_default_miss default_miss;
@@ -47,7 +48,7 @@ u32 mlx5hws_table_get_res_fw_ft_type(enum mlx5hws_table_type tbl_type,
 
 int mlx5hws_table_create_default_ft(struct mlx5_core_dev *mdev,
 				    struct mlx5hws_table *tbl,
-				    u32 *ft_id);
+				    u16 uid, u32 *ft_id);
 
 void mlx5hws_table_destroy_default_ft(struct mlx5hws_table *tbl,
 				      u32 ft_id);
-- 
2.50.1



