Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D43C339365;
	Sat, 17 Oct 2026 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253502; cv=none; b=F0JCheTh0fSg7/H+St7KuI2m6aly5uvGTqYTQ8n9tXKkFrOPOfa6cYEYQJNwvxjLDm0n6nsLB+JYNmcRIbh0kcNGBl7cRo5/UqPYnD74224mhvANjgqgHH+R9MyqtIWugX1mJZx6xlkZdcJBvT4VZ95EYqb1+2LU6huaGCkhEw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253502; c=relaxed/simple;
	bh=z6uN3FXo0t58Bgz42U45i8ekO+Tzd3AfpwKJQRhmCXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oh3md+pVkUhw5tW3EjLa3mUTjm4mii0XROYkO/ATQeSamvNXEj5ZFpEIyzvT9jUgOEsIZlUIYZpXfQIwUevdB5HWYgbcVevQwLov3fziX+7Ol27zx5ZPqlJ/oBu1msT+z9W2TmlNnipoonlnZisugp3w33oC3lekivnOUB6HBeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSS8bNhp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSS8bNhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE601F000C4;
	Sat, 17 Oct 2026 16:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253501;
	bh=xEOs4cYo+2yLExcT5+hHMwP+A5iAOOKBDRMPMGQz66c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSS8bNhpmvosMUJm30O61TWyj90Jjft6k7mv0GMvY8BoB5m5qA5hbN6QOx08vSN3B
	 4DkEyWoCJ+z1wSW6h8Nrrq2jLPokNqeL0Lt3lk6XlfUumkyEj1gcbpNYiczf1hsTRp
	 pRLu9EZQQDOgDdd8nTf8Oz4y2WX664d0UmWsyhAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/869] net/mlx5: HWS, denote how refcounts are protected
Date: Sat, 17 Oct 2026 17:49:13 +0200
Message-ID: <20261017160039.910368508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 0a1ef807a403b2f386a571133eb35e25c6511808 ]

Some HWS structs have refcounts that are just u32.
Comment how they are protected and add '__must_hold()'
annotation where applicable.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250102181415.1477316-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2c0a959bebdc ("net/mlx5: HWS, Fix memory leak in hws_pool_buddy_init error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.h | 4 ++--
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_cmd.h    | 2 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_definer.h         | 2 +-
 .../mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.h         | 2 +-
 .../ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c  | 3 ++-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.h
index bf5c1b2410060..2de7c3c842f64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_action.h
@@ -70,12 +70,12 @@ struct mlx5hws_action_default_stc {
 	struct mlx5hws_pool_chunk nop_dw6;
 	struct mlx5hws_pool_chunk nop_dw7;
 	struct mlx5hws_pool_chunk default_hit;
-	u32 refcount;
+	u32 refcount; /* protected by context ctrl lock */
 };
 
 struct mlx5hws_action_shared_stc {
 	struct mlx5hws_pool_chunk stc_chunk;
-	u32 refcount;
+	u32 refcount; /* protected by context ctrl lock */
 };
 
 struct mlx5hws_actions_apply_data {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_cmd.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_cmd.h
index 2fbcf4ff571a0..e93955ddfbb83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_cmd.h
@@ -63,7 +63,7 @@ struct mlx5hws_cmd_forward_tbl {
 	u8 type;
 	u32 ft_id;
 	u32 fg_id;
-	u32 refcount;
+	u32 refcount; /* protected by context ctrl lock */
 };
 
 struct mlx5hws_cmd_rtc_create_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.h
index 2f6a7df4021c8..5d186350dc089 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_definer.h
@@ -785,7 +785,7 @@ struct mlx5hws_definer_cache {
 
 struct mlx5hws_definer_cache_item {
 	struct mlx5hws_definer definer;
-	u32 refcount;
+	u32 refcount; /* protected by context ctrl lock */
 	struct list_head list_node;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.h
index 27ca93385b084..8ddb519800445 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pat_arg.h
@@ -31,7 +31,7 @@ struct mlx5hws_pattern_cache_item {
 		u8 *data;
 		u16 num_of_actions;
 	} mh_data;
-	u32 refcount;
+	u32 refcount; /* protected by pattern_cache lock */
 	struct list_head ptrn_list_node;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c
index 9cbe3d71e6f3d..6544d2fcb48ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_table.c
@@ -37,6 +37,7 @@ static void hws_table_set_cap_attr(struct mlx5hws_table *tbl,
 }
 
 static int hws_table_up_default_fdb_miss_tbl(struct mlx5hws_table *tbl)
+__must_hold(&tbl->ctx->ctrl_lock)
 {
 	struct mlx5hws_cmd_ft_create_attr ft_attr = {0};
 	struct mlx5hws_cmd_set_fte_attr fte_attr = {0};
@@ -70,7 +71,6 @@ static int hws_table_up_default_fdb_miss_tbl(struct mlx5hws_table *tbl)
 		return -EINVAL;
 	}
 
-	/* ctx->ctrl_lock must be held here */
 	ctx->common_res[tbl_type].default_miss = default_miss;
 	ctx->common_res[tbl_type].default_miss->refcount++;
 
@@ -79,6 +79,7 @@ static int hws_table_up_default_fdb_miss_tbl(struct mlx5hws_table *tbl)
 
 /* Called under ctx->ctrl_lock */
 static void hws_table_down_default_fdb_miss_tbl(struct mlx5hws_table *tbl)
+__must_hold(&tbl->ctx->ctrl_lock)
 {
 	struct mlx5hws_cmd_forward_tbl *default_miss;
 	struct mlx5hws_context *ctx = tbl->ctx;
-- 
2.53.0



