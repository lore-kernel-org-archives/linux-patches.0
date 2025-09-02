Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0722DC35C;
	Tue,  2 Sep 2025 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820341; cv=none; b=u10ci+W1W8nkbmzWeLs8EIYAkT9Hk1vW48V41HWM2rikWAtR4goR+45vykgJZy0cKXPvnbX8njVUt/dVDgdVULKl/xHQkQmacOH59W1soKgUjhvmgVDJKMZQOfsNuy/UXtXGpq/lR9PhvrR3dsgQDi87zIRk3UzKH7LmkjLRckA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820341; c=relaxed/simple;
	bh=JCSRRh1HuHuWdG842BmLfaHhx7YZhCYs8VTXVhlRLv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVH8FnYJbm4ZMI9LmzapchUvKGuXojKPp3w1zF8wl615TR35vVzx55LD1sw5drNriKIO5SWUh4KeR7tnbvaSIKr6wQ6x0O1duqeesUhn/pQuyi2N14y7WaZhBThOF2jFhYLinnPil8v4YxXV3zOzM7D5WxMSzuO865OmVJdcuqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbgkvOf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbgkvOf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FFDC4CEED;
	Tue,  2 Sep 2025 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820341;
	bh=JCSRRh1HuHuWdG842BmLfaHhx7YZhCYs8VTXVhlRLv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbgkvOf1hEWDtkqvOQAhbhLm0zvTe9wh6zgYqKwZCD/F3HXtglhFLxwwwcqBAURUH
	 5FT9bZqhG2l8HC126fpBsGoSf5xsoTmBWIFT9v+sRL0hZD9eVEPcXfIUObotq0Ksia
	 dfmOGYF8s8R6nwTBhMtwjJ9n9pdbHCZqohbvWWng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 42/75] net/mlx5: Convert SF port_indices xarray to function_ids xarray
Date: Tue,  2 Sep 2025 15:20:54 +0200
Message-ID: <20250902131936.770063087@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 2284a4836251b3dee348172f69ac84157aa7b03e ]

No need to lookup for sf by a port index. Convert the xarray to have
function id as an index and optimize the remaining function id
based lookup.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 26e42ec7712d ("net/mlx5: Nack sync reset when SFs are present")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 29 +++++++------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 4711dcfe8ba83..3f0ac2d1dde68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -29,7 +29,7 @@ static void *mlx5_sf_by_dl_port(struct devlink_port *dl_port)
 
 struct mlx5_sf_table {
 	struct mlx5_core_dev *dev; /* To refer from notifier context. */
-	struct xarray port_indices; /* port index based lookup. */
+	struct xarray function_ids; /* function id based lookup. */
 	refcount_t refcount;
 	struct completion disable_complete;
 	struct mutex sf_state_lock; /* Serializes sf state among user cmds & vhca event handler. */
@@ -40,24 +40,17 @@ struct mlx5_sf_table {
 static struct mlx5_sf *
 mlx5_sf_lookup_by_function_id(struct mlx5_sf_table *table, unsigned int fn_id)
 {
-	unsigned long index;
-	struct mlx5_sf *sf;
-
-	xa_for_each(&table->port_indices, index, sf) {
-		if (sf->hw_fn_id == fn_id)
-			return sf;
-	}
-	return NULL;
+	return xa_load(&table->function_ids, fn_id);
 }
 
-static int mlx5_sf_id_insert(struct mlx5_sf_table *table, struct mlx5_sf *sf)
+static int mlx5_sf_function_id_insert(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
-	return xa_insert(&table->port_indices, sf->port_index, sf, GFP_KERNEL);
+	return xa_insert(&table->function_ids, sf->hw_fn_id, sf, GFP_KERNEL);
 }
 
-static void mlx5_sf_id_erase(struct mlx5_sf_table *table, struct mlx5_sf *sf)
+static void mlx5_sf_function_id_erase(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
-	xa_erase(&table->port_indices, sf->port_index);
+	xa_erase(&table->function_ids, sf->hw_fn_id);
 }
 
 static struct mlx5_sf *
@@ -94,7 +87,7 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
 	sf->hw_state = MLX5_VHCA_STATE_ALLOCATED;
 	sf->controller = controller;
 
-	err = mlx5_sf_id_insert(table, sf);
+	err = mlx5_sf_function_id_insert(table, sf);
 	if (err)
 		goto insert_err;
 
@@ -347,7 +340,7 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 
 static void mlx5_sf_dealloc(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
-	mlx5_sf_id_erase(table, sf);
+	mlx5_sf_function_id_erase(table, sf);
 
 	if (sf->hw_state == MLX5_VHCA_STATE_ALLOCATED) {
 		mlx5_sf_free(table, sf);
@@ -451,7 +444,7 @@ static void mlx5_sf_deactivate_all(struct mlx5_sf_table *table)
 	/* At this point, no new user commands can start and no vhca event can
 	 * arrive. It is safe to destroy all user created SFs.
 	 */
-	xa_for_each(&table->port_indices, index, sf) {
+	xa_for_each(&table->function_ids, index, sf) {
 		mlx5_eswitch_unload_sf_vport(esw, sf->hw_fn_id);
 		mlx5_sf_dealloc(table, sf);
 	}
@@ -510,7 +503,7 @@ int mlx5_sf_table_init(struct mlx5_core_dev *dev)
 
 	mutex_init(&table->sf_state_lock);
 	table->dev = dev;
-	xa_init(&table->port_indices);
+	xa_init(&table->function_ids);
 	dev->priv.sf_table = table;
 	refcount_set(&table->refcount, 0);
 	table->esw_nb.notifier_call = mlx5_sf_esw_event;
@@ -545,6 +538,6 @@ void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
 	mlx5_esw_event_notifier_unregister(dev->priv.eswitch, &table->esw_nb);
 	WARN_ON(refcount_read(&table->refcount));
 	mutex_destroy(&table->sf_state_lock);
-	WARN_ON(!xa_empty(&table->port_indices));
+	WARN_ON(!xa_empty(&table->function_ids));
 	kfree(table);
 }
-- 
2.50.1



