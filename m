Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE23305E38;
	Tue,  2 Sep 2025 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820338; cv=none; b=bY/IxLgg4Dg5hLsFK2/q6X2l1/5FFVoefzrKgzmphlaQPclZzxVTNXZ7ZK9DzpIo3YKYDZvsJKHAUQpW2SVXGYbcqUTritiQYO5aE740aTL2oD3T7YtfdaZwatPJIVuZRA7q4DHifFIsdjaZVKcO0H0fRajU7xcKkysCTS+RtQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820338; c=relaxed/simple;
	bh=/kVU7cLx/gPx/vAU5l/89HzzWxNDnh6L9lEFIssKUVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kph86ZeqE1P21X/XA6rR8LmvdGuULbZ7wmqkZ4LFKQ4GA1Ag3AeOkLETXRo8yG+knMhQgCDgWiZoBVVaT9zED6eF7+7wJn9mSyT8x8bZoc7P26iRrQKeFTujsQdLNettbV3m4NXvrbwgxoXQyRnaHfEUz5wc0vlOmQFKqrmWvKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAGP3meV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAGP3meV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C41C4CEED;
	Tue,  2 Sep 2025 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820338;
	bh=/kVU7cLx/gPx/vAU5l/89HzzWxNDnh6L9lEFIssKUVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAGP3meVkSEQdPupipAeD4JXmHFZzV1Ty4CglncbVZMa/jQJxC7UnSWEyCz3OBG6X
	 I4Px3yUlRXhXdEwF5jI0CGis2SsWxGkT39c8Pqef6dLOVcKHG25BUZ4c37yTiSifvE
	 b4UyafXsOjMMjhg4mGhxHf89EBCZGg55laBOMpHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 41/75] net/mlx5: Use devlink port pointer to get the pointer of container SF struct
Date: Tue,  2 Sep 2025 15:20:53 +0200
Message-ID: <20250902131936.730007946@linuxfoundation.org>
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

[ Upstream commit 9caeb1475c3e852bcfa6332227c6bb2feaa8eb23 ]

Benefit from the fact that struct devlink_port is eventually embedded
in struct mlx5_sf and use container_of() macro to get it instead of the
xarray lookup in every devlink port op.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 26e42ec7712d ("net/mlx5: Nack sync reset when SFs are present")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  | 44 +++++--------------
 1 file changed, 12 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 1dd01701df20e..4711dcfe8ba83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -20,6 +20,13 @@ struct mlx5_sf {
 	u16 hw_state;
 };
 
+static void *mlx5_sf_by_dl_port(struct devlink_port *dl_port)
+{
+	struct mlx5_devlink_port *mlx5_dl_port = mlx5_devlink_port_get(dl_port);
+
+	return container_of(mlx5_dl_port, struct mlx5_sf, dl_port);
+}
+
 struct mlx5_sf_table {
 	struct mlx5_core_dev *dev; /* To refer from notifier context. */
 	struct xarray port_indices; /* port index based lookup. */
@@ -30,12 +37,6 @@ struct mlx5_sf_table {
 	struct notifier_block vhca_nb;
 };
 
-static struct mlx5_sf *
-mlx5_sf_lookup_by_index(struct mlx5_sf_table *table, unsigned int port_index)
-{
-	return xa_load(&table->port_indices, port_index);
-}
-
 static struct mlx5_sf *
 mlx5_sf_lookup_by_function_id(struct mlx5_sf_table *table, unsigned int fn_id)
 {
@@ -171,26 +172,19 @@ int mlx5_devlink_sf_port_fn_state_get(struct devlink_port *dl_port,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(dl_port->devlink);
+	struct mlx5_sf *sf = mlx5_sf_by_dl_port(dl_port);
 	struct mlx5_sf_table *table;
-	struct mlx5_sf *sf;
-	int err = 0;
 
 	table = mlx5_sf_table_try_get(dev);
 	if (!table)
 		return -EOPNOTSUPP;
 
-	sf = mlx5_sf_lookup_by_index(table, dl_port->index);
-	if (!sf) {
-		err = -EOPNOTSUPP;
-		goto sf_err;
-	}
 	mutex_lock(&table->sf_state_lock);
 	*state = mlx5_sf_to_devlink_state(sf->hw_state);
 	*opstate = mlx5_sf_to_devlink_opstate(sf->hw_state);
 	mutex_unlock(&table->sf_state_lock);
-sf_err:
 	mlx5_sf_table_put(table);
-	return err;
+	return 0;
 }
 
 static int mlx5_sf_activate(struct mlx5_core_dev *dev, struct mlx5_sf *sf,
@@ -256,8 +250,8 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
 				      struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(dl_port->devlink);
+	struct mlx5_sf *sf = mlx5_sf_by_dl_port(dl_port);
 	struct mlx5_sf_table *table;
-	struct mlx5_sf *sf;
 	int err;
 
 	table = mlx5_sf_table_try_get(dev);
@@ -266,14 +260,7 @@ int mlx5_devlink_sf_port_fn_state_set(struct devlink_port *dl_port,
 				   "Port state set is only supported in eswitch switchdev mode or SF ports are disabled.");
 		return -EOPNOTSUPP;
 	}
-	sf = mlx5_sf_lookup_by_index(table, dl_port->index);
-	if (!sf) {
-		err = -ENODEV;
-		goto out;
-	}
-
 	err = mlx5_sf_state_set(dev, table, sf, state, extack);
-out:
 	mlx5_sf_table_put(table);
 	return err;
 }
@@ -384,10 +371,9 @@ int mlx5_devlink_sf_port_del(struct devlink *devlink,
 			     struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_sf *sf = mlx5_sf_by_dl_port(dl_port);
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	struct mlx5_sf_table *table;
-	struct mlx5_sf *sf;
-	int err = 0;
 
 	table = mlx5_sf_table_try_get(dev);
 	if (!table) {
@@ -395,20 +381,14 @@ int mlx5_devlink_sf_port_del(struct devlink *devlink,
 				   "Port del is only supported in eswitch switchdev mode or SF ports are disabled.");
 		return -EOPNOTSUPP;
 	}
-	sf = mlx5_sf_lookup_by_index(table, dl_port->index);
-	if (!sf) {
-		err = -ENODEV;
-		goto sf_err;
-	}
 
 	mlx5_eswitch_unload_sf_vport(esw, sf->hw_fn_id);
 
 	mutex_lock(&table->sf_state_lock);
 	mlx5_sf_dealloc(table, sf);
 	mutex_unlock(&table->sf_state_lock);
-sf_err:
 	mlx5_sf_table_put(table);
-	return err;
+	return 0;
 }
 
 static bool mlx5_sf_state_update_check(const struct mlx5_sf *sf, u8 new_state)
-- 
2.50.1



