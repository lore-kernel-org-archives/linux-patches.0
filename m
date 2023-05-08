Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CF8168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113C7C433D2;
	Mon,  8 May 2023 11:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544596;
	bh=tI7ovG0zgPhW9+Vv+jwNupxyLiICWhU9AILYA/zMfUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqdY5vW2mSfE1I+JIYazy/t9enS4VEW2nXDxyv619OXDpQUP9wr86rUPP5JSBihXL
	 y/hV17Ko3s2CYfvj6AZS/c0xeBjJh8TfUQvqbkGCiytkRpRGXT2bTvns/8Ui1gRzXC
	 14ZfNZsmt5/dSzEuhNwwiTO3Zosmd8qMedvIclpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 462/694] net/mlx5: E-switch, Create per vport table based on devlink encap mode
Date: Mon,  8 May 2023 11:44:57 +0200
Message-Id: <20230508094448.686987203@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit fd745f4c0abe41ebb09d11bf622b054a0f3e7b49 ]

Currently when creating per vport table, create flags are hardcoded.
Devlink encap mode is set based on user input and HW capability.
Create per vport table based on devlink encap mode.

Fixes: c796bb7cd230 ("net/mlx5: E-switch, Generalize per vport table API")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c   |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/esw/vporttbl.c   | 12 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h    |  2 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   |  2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index 558a776359af6..5db239cae8145 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -14,10 +14,10 @@
 
 #define MLX5_ESW_VPORT_TBL_SIZE_SAMPLE (64 * 1024)
 
-static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_sample_ns = {
+static struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_sample_ns = {
 	.max_fte = MLX5_ESW_VPORT_TBL_SIZE_SAMPLE,
 	.max_num_groups = 0,    /* default num of groups */
-	.flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT | MLX5_FLOW_TABLE_TUNNEL_EN_DECAP,
+	.flags = 0,
 };
 
 struct mlx5e_tc_psample {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
index 9e72118f2e4c0..749c3957a1280 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
@@ -11,7 +11,7 @@ struct mlx5_vport_key {
 	u16 prio;
 	u16 vport;
 	u16 vhca_id;
-	const struct esw_vport_tbl_namespace *vport_ns;
+	struct esw_vport_tbl_namespace *vport_ns;
 } __packed;
 
 struct mlx5_vport_table {
@@ -21,6 +21,14 @@ struct mlx5_vport_table {
 	struct mlx5_vport_key key;
 };
 
+static void
+esw_vport_tbl_init(struct mlx5_eswitch *esw, struct esw_vport_tbl_namespace *ns)
+{
+	if (esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE)
+		ns->flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
+			      MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
+}
+
 static struct mlx5_flow_table *
 esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns,
 		     const struct esw_vport_tbl_namespace *vport_ns)
@@ -80,6 +88,7 @@ mlx5_esw_vporttbl_get(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr
 	u32 hkey;
 
 	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	esw_vport_tbl_init(esw, attr->vport_ns);
 	hkey = flow_attr_to_vport_key(esw, attr, &skey);
 	e = esw_vport_tbl_lookup(esw, &skey, hkey);
 	if (e) {
@@ -127,6 +136,7 @@ mlx5_esw_vporttbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr
 	u32 hkey;
 
 	mutex_lock(&esw->fdb_table.offloads.vports.lock);
+	esw_vport_tbl_init(esw, attr->vport_ns);
 	hkey = flow_attr_to_vport_key(esw, attr, &key);
 	e = esw_vport_tbl_lookup(esw, &key, hkey);
 	if (!e || --e->num_rules)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 19e9a77c46336..9d5a5756a15a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -674,7 +674,7 @@ struct mlx5_vport_tbl_attr {
 	u32 chain;
 	u16 prio;
 	u16 vport;
-	const struct esw_vport_tbl_namespace *vport_ns;
+	struct esw_vport_tbl_namespace *vport_ns;
 };
 
 struct mlx5_flow_table *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 25a8076a77bff..706746cd10af5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -73,7 +73,7 @@
 
 #define MLX5_ESW_FT_OFFLOADS_DROP_RULE (1)
 
-static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
+static struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
 	.max_fte = MLX5_ESW_VPORT_TBL_SIZE,
 	.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS,
 	.flags = 0,
-- 
2.39.2



