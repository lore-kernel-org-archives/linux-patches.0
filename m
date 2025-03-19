Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C84213E93;
	Wed, 19 Mar 2025 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395031; cv=none; b=HKRxTZp3yVAy0za0WD5Hh/lZVHysXz+caVJXwo2W2Af7pqRyzWh8vRsFFc6vEiZnZFmPV0/ILDOP4HiJInjkh4XymTOnU7qSUneZc5PH4YYt/vfeeEbs5XPvb5nYqMPVWnfMFfYrup1KsSQxd5bz5yefPsQ+4NXh57FAp2l0sGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395031; c=relaxed/simple;
	bh=AiTtqeNkKu4t9tfbiYvSHIZHCu3whTEv10MDZgpnZ+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qahJg695sDvhRUgS69uMySnhr/ifEGSpWXAl1Sz4wDT7T/sbza/dStvjP2Ldm1uqWx9238ouzzpQnl1PDLmmYZw7uUgGcjXOqjsTFIOpAyU4eVANGTerKs3Enagy4NSBchiODQltSf36e97bWPALof7yQHCOoE3W0lf0d/u9MBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvfC5iSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvfC5iSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD247C4CEE4;
	Wed, 19 Mar 2025 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395031;
	bh=AiTtqeNkKu4t9tfbiYvSHIZHCu3whTEv10MDZgpnZ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvfC5iSfiBkUw0oKFwT7TFo7JOMfVJKec5M22U62BuO7uyI8W+Z3nsBeh/xb8XV1y
	 HdrN9aL6xmJ+XWszItiZEa/rJf37E+kBa0hAFjXObSRYZ+dL+lh8jtCh50vgaGzUE/
	 1tpTZfMpUKczLVuWxwlaO9o6CJ2MkaC+fIWEE0zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/231] net/mlx5: Fix incorrect IRQ pool usage when releasing IRQs
Date: Wed, 19 Mar 2025 07:29:05 -0700
Message-ID: <20250319143028.110926197@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 32d2724db5b2361ab293427ccd5c24f4f2bcca14 ]

mlx5_irq_pool_get() is a getter for completion IRQ pool only.
However, after the cited commit, mlx5_irq_pool_get() is called during
ctrl IRQ release flow to retrieve the pool, resulting in the use of an
incorrect IRQ pool.

Hence, use the newly introduced mlx5_irq_get_pool() getter to retrieve
the correct IRQ pool based on the IRQ itself. While at it, rename
mlx5_irq_pool_get() to mlx5_irq_table_get_comp_irq_pool() which
accurately reflects its purpose and improves code readability.

Fixes: 0477d5168bbb ("net/mlx5: Expose SFs IRQs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/1741644104-97767-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c        |  2 +-
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h  |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c   | 13 ++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h   |  2 +-
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 68cb86b37e561..4241cf07a0306 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -887,8 +887,8 @@ static void comp_irq_release_sf(struct mlx5_core_dev *dev, u16 vecidx)
 
 static int comp_irq_request_sf(struct mlx5_core_dev *dev, u16 vecidx)
 {
+	struct mlx5_irq_pool *pool = mlx5_irq_table_get_comp_irq_pool(dev);
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_irq_pool *pool = mlx5_irq_pool_get(dev);
 	struct irq_affinity_desc af_desc = {};
 	struct mlx5_irq *irq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
index 1477db7f5307e..2691d88cdee1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
@@ -175,7 +175,7 @@ mlx5_irq_affinity_request(struct mlx5_core_dev *dev, struct mlx5_irq_pool *pool,
 
 void mlx5_irq_affinity_irq_release(struct mlx5_core_dev *dev, struct mlx5_irq *irq)
 {
-	struct mlx5_irq_pool *pool = mlx5_irq_pool_get(dev);
+	struct mlx5_irq_pool *pool = mlx5_irq_get_pool(irq);
 	int cpu;
 
 	cpu = cpumask_first(mlx5_irq_get_affinity_mask(irq));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
index 0881e961d8b17..586688da9940e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
@@ -10,12 +10,15 @@
 
 struct mlx5_irq;
 struct cpu_rmap;
+struct mlx5_irq_pool;
 
 int mlx5_irq_table_init(struct mlx5_core_dev *dev);
 void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev);
 int mlx5_irq_table_create(struct mlx5_core_dev *dev);
 void mlx5_irq_table_destroy(struct mlx5_core_dev *dev);
 void mlx5_irq_table_free_irqs(struct mlx5_core_dev *dev);
+struct mlx5_irq_pool *
+mlx5_irq_table_get_comp_irq_pool(struct mlx5_core_dev *dev);
 int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table);
 int mlx5_irq_table_get_sfs_vec(struct mlx5_irq_table *table);
 struct mlx5_irq_table *mlx5_irq_table_get(struct mlx5_core_dev *dev);
@@ -38,7 +41,6 @@ struct cpumask *mlx5_irq_get_affinity_mask(struct mlx5_irq *irq);
 int mlx5_irq_get_index(struct mlx5_irq *irq);
 int mlx5_irq_get_irq(const struct mlx5_irq *irq);
 
-struct mlx5_irq_pool;
 #ifdef CONFIG_MLX5_SF
 struct mlx5_irq *mlx5_irq_affinity_irq_request_auto(struct mlx5_core_dev *dev,
 						    struct cpumask *used_cpus, u16 vecidx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index d9362eabc6a1c..2c5f850c31f68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -378,6 +378,11 @@ int mlx5_irq_get_index(struct mlx5_irq *irq)
 	return irq->map.index;
 }
 
+struct mlx5_irq_pool *mlx5_irq_get_pool(struct mlx5_irq *irq)
+{
+	return irq->pool;
+}
+
 /* irq_pool API */
 
 /* requesting an irq from a given pool according to given index */
@@ -405,18 +410,20 @@ static struct mlx5_irq_pool *sf_ctrl_irq_pool_get(struct mlx5_irq_table *irq_tab
 	return irq_table->sf_ctrl_pool;
 }
 
-static struct mlx5_irq_pool *sf_irq_pool_get(struct mlx5_irq_table *irq_table)
+static struct mlx5_irq_pool *
+sf_comp_irq_pool_get(struct mlx5_irq_table *irq_table)
 {
 	return irq_table->sf_comp_pool;
 }
 
-struct mlx5_irq_pool *mlx5_irq_pool_get(struct mlx5_core_dev *dev)
+struct mlx5_irq_pool *
+mlx5_irq_table_get_comp_irq_pool(struct mlx5_core_dev *dev)
 {
 	struct mlx5_irq_table *irq_table = mlx5_irq_table_get(dev);
 	struct mlx5_irq_pool *pool = NULL;
 
 	if (mlx5_core_is_sf(dev))
-		pool = sf_irq_pool_get(irq_table);
+		pool = sf_comp_irq_pool_get(irq_table);
 
 	/* In some configs, there won't be a pool of SFs IRQs. Hence, returning
 	 * the PF IRQs pool in case the SF pool doesn't exist.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
index c4d377f8df308..cc064425fe160 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
@@ -28,7 +28,6 @@ struct mlx5_irq_pool {
 	struct mlx5_core_dev *dev;
 };
 
-struct mlx5_irq_pool *mlx5_irq_pool_get(struct mlx5_core_dev *dev);
 static inline bool mlx5_irq_pool_is_sf_pool(struct mlx5_irq_pool *pool)
 {
 	return !strncmp("mlx5_sf", pool->name, strlen("mlx5_sf"));
@@ -40,5 +39,6 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 int mlx5_irq_get_locked(struct mlx5_irq *irq);
 int mlx5_irq_read_locked(struct mlx5_irq *irq);
 int mlx5_irq_put(struct mlx5_irq *irq);
+struct mlx5_irq_pool *mlx5_irq_get_pool(struct mlx5_irq *irq);
 
 #endif /* __PCI_IRQ_H__ */
-- 
2.39.5



