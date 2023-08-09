Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF0015AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1445C433C7;
	Wed,  9 Aug 2023 10:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577993;
	bh=eDIPdqYtbarjU1BiTg+BykH+6qGIUHEsQSeZBMRPZP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fe1TaWcbem/G3k3HfeI7IHnL9GOrN9vJVlwlQu5nBTh9gr8LU3CszGINBX2eX+1+H
	 QeqVcFfj+VJKJHziWAbbCDkLAcBf+dSV4r2DF5ArSaX0ns8zR3q72Q7s7ApAHCeWOK
	 hqBNZDTH9KErN8p+jejZEdd5mMaxfMAsBeNVSbmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 038/165] net/mlx5e: kTLS, Fix protection domain in use syndrome when devlink reload
Date: Wed,  9 Aug 2023 12:39:29 +0200
Message-ID: <20230809103644.057669736@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 3e4cf1dd2ce413f4be3e2c9062fb470e2ad2be88 ]

There are DEK objects cached in DEK pool after kTLS is used, and they
are freed only in mlx5e_ktls_cleanup().

mlx5e_destroy_mdev_resources() is called in mlx5e_suspend() to
free mdev resources, including protection domain (PD). However, PD is
still referenced by the cached DEK objects in this case, because
profile->cleanup() (and therefore mlx5e_ktls_cleanup()) is called
after mlx5e_suspend() during devlink reload. So the following FW
syndrome is generated:

 mlx5_cmd_out_err:803:(pid 12948): DEALLOC_PD(0x801) op_mod(0x0) failed,
    status bad resource state(0x9), syndrome (0xef0c8a), err(-22)

To avoid this syndrome, move DEK pool destruction to
mlx5e_ktls_cleanup_tx(), which is called by profile->cleanup_tx(). And
move pool creation to mlx5e_ktls_init_tx() for symmetry.

Fixes: f741db1a5171 ("net/mlx5e: kTLS, Improve connection rate by using fast update encryption key")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ktls.c        |  8 -----
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 29 +++++++++++++++++--
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index cf704f106b7c2..984fa04bd331b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -188,7 +188,6 @@ static void mlx5e_tls_debugfs_init(struct mlx5e_tls *tls,
 
 int mlx5e_ktls_init(struct mlx5e_priv *priv)
 {
-	struct mlx5_crypto_dek_pool *dek_pool;
 	struct mlx5e_tls *tls;
 
 	if (!mlx5e_is_ktls_device(priv->mdev))
@@ -199,12 +198,6 @@ int mlx5e_ktls_init(struct mlx5e_priv *priv)
 		return -ENOMEM;
 	tls->mdev = priv->mdev;
 
-	dek_pool = mlx5_crypto_dek_pool_create(priv->mdev, MLX5_ACCEL_OBJ_TLS_KEY);
-	if (IS_ERR(dek_pool)) {
-		kfree(tls);
-		return PTR_ERR(dek_pool);
-	}
-	tls->dek_pool = dek_pool;
 	priv->tls = tls;
 
 	mlx5e_tls_debugfs_init(tls, priv->dfs_root);
@@ -222,7 +215,6 @@ void mlx5e_ktls_cleanup(struct mlx5e_priv *priv)
 	debugfs_remove_recursive(tls->debugfs.dfs);
 	tls->debugfs.dfs = NULL;
 
-	mlx5_crypto_dek_pool_destroy(tls->dek_pool);
 	kfree(priv->tls);
 	priv->tls = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 0e4c0a093293a..c49363dd6bf9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -908,28 +908,51 @@ static void mlx5e_tls_tx_debugfs_init(struct mlx5e_tls *tls,
 
 int mlx5e_ktls_init_tx(struct mlx5e_priv *priv)
 {
+	struct mlx5_crypto_dek_pool *dek_pool;
 	struct mlx5e_tls *tls = priv->tls;
+	int err;
+
+	if (!mlx5e_is_ktls_device(priv->mdev))
+		return 0;
+
+	/* DEK pool could be used by either or both of TX and RX. But we have to
+	 * put the creation here to avoid syndrome when doing devlink reload.
+	 */
+	dek_pool = mlx5_crypto_dek_pool_create(priv->mdev, MLX5_ACCEL_OBJ_TLS_KEY);
+	if (IS_ERR(dek_pool))
+		return PTR_ERR(dek_pool);
+	tls->dek_pool = dek_pool;
 
 	if (!mlx5e_is_ktls_tx(priv->mdev))
 		return 0;
 
 	priv->tls->tx_pool = mlx5e_tls_tx_pool_init(priv->mdev, &priv->tls->sw_stats);
-	if (!priv->tls->tx_pool)
-		return -ENOMEM;
+	if (!priv->tls->tx_pool) {
+		err = -ENOMEM;
+		goto err_tx_pool_init;
+	}
 
 	mlx5e_tls_tx_debugfs_init(tls, tls->debugfs.dfs);
 
 	return 0;
+
+err_tx_pool_init:
+	mlx5_crypto_dek_pool_destroy(dek_pool);
+	return err;
 }
 
 void mlx5e_ktls_cleanup_tx(struct mlx5e_priv *priv)
 {
 	if (!mlx5e_is_ktls_tx(priv->mdev))
-		return;
+		goto dek_pool_destroy;
 
 	debugfs_remove_recursive(priv->tls->debugfs.dfs_tx);
 	priv->tls->debugfs.dfs_tx = NULL;
 
 	mlx5e_tls_tx_pool_cleanup(priv->tls->tx_pool);
 	priv->tls->tx_pool = NULL;
+
+dek_pool_destroy:
+	if (mlx5e_is_ktls_device(priv->mdev))
+		mlx5_crypto_dek_pool_destroy(priv->tls->dek_pool);
 }
-- 
2.40.1



