Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7ED657B0;
	Tue, 23 Jan 2024 01:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975085; cv=none; b=Dqd9R4Ti3KQD9lH5KRusIJdklJRLxtnpAGVS41Bsestwgx4q0ow+sdiMDB3o7g/M690BEdIb1ZY5FQI+uJ5X2Qh582lcRlrLrYsg6r1O/RNfCyAqiwwh9AWMqUgOf/IfdcxUjJD96NltvYHCRJQz+nC4UxsRyAI/3r6weC52U+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975085; c=relaxed/simple;
	bh=td9JhF917QBLWPpkwLjWdakPwP7i9SPFMGYQtY25G4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWpPsUT6gk/sq2Eg1fzQ8QCnuCTf+W0ezGrlcKZNaCVMW5Sj6so3F06ARnCnIl4Q91GyVW+sZLjkKyxmfdLIjgIv7yW9hmGZy17XSfF1LUZmHcxyXaDq8AtSp1mjpsz7t5E26kd1bhmVaZlCti3Ry303huNfFsLEmUmzv+FF3n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BTx8BL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BTx8BL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C87C433C7;
	Tue, 23 Jan 2024 01:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975085;
	bh=td9JhF917QBLWPpkwLjWdakPwP7i9SPFMGYQtY25G4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BTx8BL/6fny85nXOed1H2aaZxtnSXeQhTBWj4d+mlYvKRINU+rgPOWEVj6DtgT/1
	 ED1MljqDQ0gGEy9hzwq+4c9FIfxTdrsHU82jm7JuBO9AaAOprcYXAgX4QESyaQIEdi
	 z2rPBUWIpVcU+BbHtnmThXPe4tNJzsfTCjjnPdNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/374] mlxsw: spectrum: Use bitmap_zalloc() when applicable
Date: Mon, 22 Jan 2024 16:00:15 -0800
Message-ID: <20240122235757.439400575@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 2c087dfcc9d5e7e8557d217f01f58ba42d1ddbf1 ]

Use 'bitmap_zalloc()' to simplify code, improve the semantic and avoid
some open-coded arithmetic in allocator arguments.

Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
consistency.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 483ae90d8f97 ("mlxsw: spectrum_acl_tcam: Fix stack corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/spectrum_acl_atcam.c  |  8 +++-----
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c   | 15 ++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum_cnt.c    |  9 +++------
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c  | 11 ++++-------
 4 files changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c
index ded4cf658680..4b713832fdd5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_atcam.c
@@ -119,7 +119,6 @@ mlxsw_sp_acl_atcam_region_12kb_init(struct mlxsw_sp_acl_atcam_region *aregion)
 {
 	struct mlxsw_sp *mlxsw_sp = aregion->region->mlxsw_sp;
 	struct mlxsw_sp_acl_atcam_region_12kb *region_12kb;
-	size_t alloc_size;
 	u64 max_lkey_id;
 	int err;
 
@@ -131,8 +130,7 @@ mlxsw_sp_acl_atcam_region_12kb_init(struct mlxsw_sp_acl_atcam_region *aregion)
 	if (!region_12kb)
 		return -ENOMEM;
 
-	alloc_size = BITS_TO_LONGS(max_lkey_id) * sizeof(unsigned long);
-	region_12kb->used_lkey_id = kzalloc(alloc_size, GFP_KERNEL);
+	region_12kb->used_lkey_id = bitmap_zalloc(max_lkey_id, GFP_KERNEL);
 	if (!region_12kb->used_lkey_id) {
 		err = -ENOMEM;
 		goto err_used_lkey_id_alloc;
@@ -149,7 +147,7 @@ mlxsw_sp_acl_atcam_region_12kb_init(struct mlxsw_sp_acl_atcam_region *aregion)
 	return 0;
 
 err_rhashtable_init:
-	kfree(region_12kb->used_lkey_id);
+	bitmap_free(region_12kb->used_lkey_id);
 err_used_lkey_id_alloc:
 	kfree(region_12kb);
 	return err;
@@ -161,7 +159,7 @@ mlxsw_sp_acl_atcam_region_12kb_fini(struct mlxsw_sp_acl_atcam_region *aregion)
 	struct mlxsw_sp_acl_atcam_region_12kb *region_12kb = aregion->priv;
 
 	rhashtable_destroy(&region_12kb->lkey_ht);
-	kfree(region_12kb->used_lkey_id);
+	bitmap_free(region_12kb->used_lkey_id);
 	kfree(region_12kb);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 7cccc41dd69c..31f7f4c3acc3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -36,7 +36,6 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	u64 max_tcam_regions;
 	u64 max_regions;
 	u64 max_groups;
-	size_t alloc_size;
 	int err;
 
 	mutex_init(&tcam->lock);
@@ -52,15 +51,13 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	if (max_tcam_regions < max_regions)
 		max_regions = max_tcam_regions;
 
-	alloc_size = sizeof(tcam->used_regions[0]) * BITS_TO_LONGS(max_regions);
-	tcam->used_regions = kzalloc(alloc_size, GFP_KERNEL);
+	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
 	if (!tcam->used_regions)
 		return -ENOMEM;
 	tcam->max_regions = max_regions;
 
 	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
-	alloc_size = sizeof(tcam->used_groups[0]) * BITS_TO_LONGS(max_groups);
-	tcam->used_groups = kzalloc(alloc_size, GFP_KERNEL);
+	tcam->used_groups = bitmap_zalloc(max_groups, GFP_KERNEL);
 	if (!tcam->used_groups) {
 		err = -ENOMEM;
 		goto err_alloc_used_groups;
@@ -76,9 +73,9 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_tcam_init:
-	kfree(tcam->used_groups);
+	bitmap_free(tcam->used_groups);
 err_alloc_used_groups:
-	kfree(tcam->used_regions);
+	bitmap_free(tcam->used_regions);
 	return err;
 }
 
@@ -89,8 +86,8 @@ void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
 
 	mutex_destroy(&tcam->lock);
 	ops->fini(mlxsw_sp, tcam->priv);
-	kfree(tcam->used_groups);
-	kfree(tcam->used_regions);
+	bitmap_free(tcam->used_groups);
+	bitmap_free(tcam->used_regions);
 }
 
 int mlxsw_sp_acl_tcam_priority_get(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
index b65b93a2b9bc..fc2257753b9b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c
@@ -122,7 +122,6 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	unsigned int sub_pools_count = ARRAY_SIZE(mlxsw_sp_counter_sub_pools);
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_counter_pool *pool;
-	unsigned int map_size;
 	int err;
 
 	pool = kzalloc(struct_size(pool, sub_pools, sub_pools_count),
@@ -143,9 +142,7 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_COUNTERS,
 					  mlxsw_sp_counter_pool_occ_get, pool);
 
-	map_size = BITS_TO_LONGS(pool->pool_size) * sizeof(unsigned long);
-
-	pool->usage = kzalloc(map_size, GFP_KERNEL);
+	pool->usage = bitmap_zalloc(pool->pool_size, GFP_KERNEL);
 	if (!pool->usage) {
 		err = -ENOMEM;
 		goto err_usage_alloc;
@@ -158,7 +155,7 @@ int mlxsw_sp_counter_pool_init(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 
 err_sub_pools_init:
-	kfree(pool->usage);
+	bitmap_free(pool->usage);
 err_usage_alloc:
 	devlink_resource_occ_get_unregister(devlink,
 					    MLXSW_SP_RESOURCE_COUNTERS);
@@ -176,7 +173,7 @@ void mlxsw_sp_counter_pool_fini(struct mlxsw_sp *mlxsw_sp)
 	WARN_ON(find_first_bit(pool->usage, pool->pool_size) !=
 			       pool->pool_size);
 	WARN_ON(atomic_read(&pool->active_entries_count));
-	kfree(pool->usage);
+	bitmap_free(pool->usage);
 	devlink_resource_occ_get_unregister(devlink,
 					    MLXSW_SP_RESOURCE_COUNTERS);
 	kfree(pool);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 22fede5cb32c..81c7e8a7fcf5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1635,16 +1635,13 @@ mlxsw_sp_mid *__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 				  u16 fid)
 {
 	struct mlxsw_sp_mid *mid;
-	size_t alloc_size;
 
 	mid = kzalloc(sizeof(*mid), GFP_KERNEL);
 	if (!mid)
 		return NULL;
 
-	alloc_size = sizeof(unsigned long) *
-		     BITS_TO_LONGS(mlxsw_core_max_ports(mlxsw_sp->core));
-
-	mid->ports_in_mid = kzalloc(alloc_size, GFP_KERNEL);
+	mid->ports_in_mid = bitmap_zalloc(mlxsw_core_max_ports(mlxsw_sp->core),
+					  GFP_KERNEL);
 	if (!mid->ports_in_mid)
 		goto err_ports_in_mid_alloc;
 
@@ -1663,7 +1660,7 @@ mlxsw_sp_mid *__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 	return mid;
 
 err_write_mdb_entry:
-	kfree(mid->ports_in_mid);
+	bitmap_free(mid->ports_in_mid);
 err_ports_in_mid_alloc:
 	kfree(mid);
 	return NULL;
@@ -1680,7 +1677,7 @@ static int mlxsw_sp_port_remove_from_mid(struct mlxsw_sp_port *mlxsw_sp_port,
 			 mlxsw_core_max_ports(mlxsw_sp->core))) {
 		err = mlxsw_sp_mc_remove_mdb_entry(mlxsw_sp, mid);
 		list_del(&mid->list);
-		kfree(mid->ports_in_mid);
+		bitmap_free(mid->ports_in_mid);
 		kfree(mid);
 	}
 	return err;
-- 
2.43.0



