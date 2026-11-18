Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027467;
	b=UqrvKsutV9KKe8fpFs9d3BLkcpKttllP2wo5r2keHELkpfTAOUwvZy9gTwhhsS0qIdZu
	 EwAW7azdYymWUaH0ZLlMqsLcyiKZXcH9KecmXZaeFMFYF8BU3tYdKe3kl8aq4wV/a2WWg
	 Eue4ZWNg/v/RA43pDgWuUY4nQFqnZfjTGNbu4qoOfMhxrv80X300tAXbs54708DLBfkdu
	 yylMir3K7+cGK8BE56n1ssG97LFI2CxDKzesfFfN/L+mO73uFrusPj3Wf8AAmmF165EDJ
	 97DpRmO0XH5YR0DgZcNUkcgQSZuSbMfBAn98XKiAc/ivK9SRZHZEMe6Yu9erIBoVnVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=prppkouQgKAxnYlBAvaBUYrjFqIZzFRkSrQkXKllPwY=;
	b=OSrtWbscjL9LpRKxIRMruVg690IQyECKTnWUoGmBTZYk0SYIE0Rp7rZW7wBGgEASlSzr
	 wyrm5DDlrqBxa2ZtUVhG1FIgQso2ZDEeubl3BPztoqokmrF0UMbh/lqBVlaMiXQhg5Cc/
	 jF9Gm7I/M4yanN1jB2coMOKBSswVr8uquTPFI5WaRvD86TttQx/kPeLm3ZSLPySmuP93h
	 gPnWQ2GZPNWNxAB5+WcSS7bqNTE56rbRj1xmGA8xFAABsVsP/D7ZMzM8u/lqNWe5c0o2Z
	 FCOlM59ZptTXCzpDfeM+LtAPrcPGTBlHQvgy4uEjY2cPWI+ZGUeVIHcKXG9gG9UqCAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5Zc025q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65D1606A320;
	Wed, 18 Nov 2026 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5Zc025q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DF71F000C4;
	Wed, 18 Nov 2026 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027467;
	bh=prppkouQgKAxnYlBAvaBUYrjFqIZzFRkSrQkXKllPwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5Zc025q/4nsS+HQUSHETSRZZHTlHcdk747ogFtBWhHflZCS840a1rvhi4r2klSXz
	 Lht7DRJt4Yxd87xjohTDoSTi2F0LEEw8NcPUg3L/ElYvF7rDMT+nNUFd5R2Y/3DHIG
	 9I38btKhsRji31R+6z+VvHhfbNa9vogMNkl3ndhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Moshe Shemesh <moshe@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1800/2151] net/mlx5: HWS, fix modify header pool creation race
Date: Wed, 18 Nov 2026 15:58:55 +0100
Message-ID: <20261118150227.378668392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Cassen <acassen@corp.free.fr>

[ Upstream commit e4ab8ab27ab1c9f0cd1589bee471d93319e20c95 ]

mlx5_cmd_hws_modify_header_alloc() creates a pool at the index after
the last one if no pool matches the pattern. TC and CT allocate modify
headers concurrently, meaning two callers can take the same index and
the second call fails with -EBUSY.

Its error path also destroys the pool it just created although another
caller may already use it. Keep such a pool since cleanup releases it.

Pools now live until cleanup so the lookup needs no lock. A miss looks
again under a mutex before creating the pool.

Tested for regressions on ConnectX-7 with firmware 28.48.1000.

Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261012100555.1317878-3-acassen@corp.free.fr
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/hws/fs_hws.c  | 53 +++++++++++--------
 .../mellanox/mlx5/core/steering/hws/fs_hws.h  |  1 +
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 8267df307c8bf..6a5068ff013a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -63,6 +63,7 @@ static int mlx5_fs_init_hws_actions_pool(struct mlx5_core_dev *dev,
 	xa_init(&hws_pool->el2tol3tnl_pools);
 	xa_init(&hws_pool->el2tol2tnl_pools);
 	xa_init(&hws_pool->mh_pools);
+	mutex_init(&hws_pool->mh_pools_lock);
 	xa_init(&hws_pool->table_dests);
 	xa_init(&hws_pool->vport_dests);
 	xa_init(&hws_pool->vport_vhca_dests);
@@ -111,6 +112,7 @@ static void mlx5_fs_cleanup_hws_actions_pool(struct mlx5_fs_hws_context *fs_ctx)
 	xa_for_each(&hws_pool->mh_pools, i, pool)
 		mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, i);
 	xa_destroy(&hws_pool->mh_pools);
+	mutex_destroy(&hws_pool->mh_pools_lock);
 	xa_for_each(&hws_pool->el2tol2tnl_pools, i, pool)
 		mlx5_fs_destroy_pr_pool(pool, &hws_pool->el2tol2tnl_pools, i);
 	xa_destroy(&hws_pool->el2tol2tnl_pools);
@@ -1461,6 +1463,23 @@ mlx5_fs_destroy_mh_pool(struct mlx5_fs_pool *pool, struct xarray *mh_pools,
 	kfree(pool);
 }
 
+static struct mlx5_fs_pool *
+mlx5_fs_find_mh_pool(struct xarray *mh_pools,
+		     struct mlx5hws_action_mh_pattern *pattern,
+		     unsigned long *cnt)
+{
+	struct mlx5_fs_pool *pool;
+	unsigned long i;
+
+	*cnt = 0;
+	xa_for_each(mh_pools, i, pool) {
+		if (mlx5_fs_hws_mh_pool_match(pool, pattern))
+			return pool;
+		(*cnt)++;
+	}
+	return NULL;
+}
+
 static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 					    u8 namespace, u8 num_actions,
 					    void *modify_actions,
@@ -1471,33 +1490,28 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 	struct mlx5_fs_hws_mh *mh_data = NULL;
 	struct mlx5hws_action *hws_action;
 	struct mlx5_fs_pool *pool;
-	unsigned long i, cnt = 0;
-	bool known_pattern;
+	unsigned long cnt;
 	int err;
 
 	pattern.sz = MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto) * num_actions;
 	pattern.data = modify_actions;
 
-	known_pattern = false;
-	xa_for_each(&hws_pool->mh_pools, i, pool) {
-		if (mlx5_fs_hws_mh_pool_match(pool, &pattern)) {
-			known_pattern = true;
-			break;
-		}
-		cnt++;
-	}
-
-	if (!known_pattern) {
-		pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
-					      &hws_pool->mh_pools, cnt);
+	pool = mlx5_fs_find_mh_pool(&hws_pool->mh_pools, &pattern, &cnt);
+	if (!pool) {
+		mutex_lock(&hws_pool->mh_pools_lock);
+		pool = mlx5_fs_find_mh_pool(&hws_pool->mh_pools, &pattern,
+					    &cnt);
+		if (!pool)
+			pool = mlx5_fs_create_mh_pool(ns->dev, &pattern,
+						      &hws_pool->mh_pools, cnt);
+		mutex_unlock(&hws_pool->mh_pools_lock);
 		if (IS_ERR(pool))
 			return PTR_ERR(pool);
 	}
+
 	mh_data = mlx5_fs_hws_mh_pool_acquire_mh(pool);
-	if (IS_ERR(mh_data)) {
-		err = PTR_ERR(mh_data);
-		goto destroy_pool;
-	}
+	if (IS_ERR(mh_data))
+		return PTR_ERR(mh_data);
 	hws_action = mh_data->bulk->hws_action;
 	mh_data->data = kmemdup(pattern.data, pattern.sz, GFP_KERNEL);
 	if (!mh_data->data) {
@@ -1513,9 +1527,6 @@ static int mlx5_cmd_hws_modify_header_alloc(struct mlx5_flow_root_namespace *ns,
 
 release_mh:
 	mlx5_fs_hws_mh_pool_release_mh(pool, mh_data);
-destroy_pool:
-	if (!known_pattern)
-		mlx5_fs_destroy_mh_pool(pool, &hws_pool->mh_pools, cnt);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
index b92d55b2d147a..344c80112ab78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
@@ -19,6 +19,7 @@ struct mlx5_fs_hws_actions_pool {
 	struct xarray el2tol3tnl_pools;
 	struct xarray el2tol2tnl_pools;
 	struct xarray mh_pools;
+	struct mutex mh_pools_lock; /* serializes pool creation */
 	struct xarray table_dests;
 	struct xarray vport_vhca_dests;
 	struct xarray vport_dests;
-- 
2.53.0



