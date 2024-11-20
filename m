Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788BE1A4F19;
	Wed, 20 Nov 2024 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107511; cv=none; b=N/eejLobwPxQSDUtu6SaexYbBv8u/bVx8uwL8Cc/XjhMYqX4DMYEpWyAKpNdDGu2Prp0rwoHPXIOUK6OjwV06rG2vLfFarbAZainOx5XaPf00r2WcdaM7FB4l/NK9s0pcv3dcfeffc+C42lPa3Ga9PwFkksbpZY+d5YtnvLxHe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107511; c=relaxed/simple;
	bh=QOGEvo3z/t7nHxmQPKmGQwYk7KmlrPGaz7lr+baYu08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cuqc05vPOTwWnKVngu/JQmQKDpuKtSoAKqSbPiMVIsE0BP1AR/G3ZmfDGKP4hhRMvrkhrK4Z3Tj5HF3F9cLEi4qssi53Ir8y8MCfsu6WR9OELtp/g7yeRjZGg7CnnYJwvndMHiz/UdEG9aa/QrnbZS2jQziwRmRbtcdpErcI0WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmrYOwqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmrYOwqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431FBC4CECD;
	Wed, 20 Nov 2024 12:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107511;
	bh=QOGEvo3z/t7nHxmQPKmGQwYk7KmlrPGaz7lr+baYu08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmrYOwqZGjNV7uIolwxnI6mLllntnwuG+w0SS+zzTcvyLQfUCz8Q+w7YPvYG1IDRE
	 +f7zRTbbqz7euLum3t797ACk8mljk5b31MmMyKQFSkUinHP+y1fYrXkQLdTbdiDYIk
	 cueMp2Cy3NE2K5oQ7WhxKsxZpIH/ZewWNCe+FLY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	Amir Tzin <amirtz@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 008/107] net/mlx5: Fix msix vectors to respect platform limit
Date: Wed, 20 Nov 2024 13:55:43 +0100
Message-ID: <20241120125629.871642548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit d0989c9d2b3a89ae5e4ad45fe6d7bbe449fc49fe ]

The number of PCI vectors allocated by the platform (which may be fewer
than requested) is currently not honored when creating the SF pool;
only the PCI MSI-X capability is considered.

As a result, when a platform allocates fewer vectors
(in non-dynamic mode) than requested, the PF and SF pools end up
with an invalid vector range.

This causes incorrect SF vector accounting, which leads to the
following call trace when an invalid IRQ vector is allocated.

This issue is resolved by ensuring that the platform's vector
limit is respected for both the SF and PF pools.

Workqueue: mlx5_vhca_event0 mlx5_sf_dev_add_active_work [mlx5_core]
RIP: 0010:pci_irq_vector+0x23/0x80
RSP: 0018:ffffabd5cebd7248 EFLAGS: 00010246
RAX: ffff980880e7f308 RBX: ffff9808932fb880 RCX: 0000000000000001
RDX: 00000000000001ff RSI: 0000000000000200 RDI: ffff980880e7f308
RBP: 0000000000000200 R08: 0000000000000010 R09: ffff97a9116f0860
R10: 0000000000000002 R11: 0000000000000228 R12: ffff980897cd0160
R13: 0000000000000000 R14: ffff97a920fec0c0 R15: ffffabd5cebd72d0
FS:  0000000000000000(0000) GS:ffff97c7ff9c0000(0000) knlGS:0000000000000000
 ? rescuer_thread+0x350/0x350
 kthread+0x11b/0x140
 ? __kthread_bind_mask+0x60/0x60
 ret_from_fork+0x22/0x30
mlx5_core 0000:a1:00.0: mlx5_irq_alloc:321:(pid 6781): Failed to request irq. err = -22
mlx5_core 0000:a1:00.0: mlx5_irq_alloc:321:(pid 6781): Failed to request irq. err = -22
mlx5_core.sf mlx5_core.sf.6: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0 enhanced)
mlx5_core.sf mlx5_core.sf.7: firmware version: 32.43.356
mlx5_core.sf mlx5_core.sf.6 enpa1s0f0s4: renamed from eth0
mlx5_core.sf mlx5_core.sf.7: Rate limit: 127 rates are supported, range: 0Mbps to 195312Mbps
mlx5_core 0000:a1:00.0: mlx5_irq_alloc:321:(pid 6781): Failed to request irq. err = -22
mlx5_core 0000:a1:00.0: mlx5_irq_alloc:321:(pid 6781): Failed to request irq. err = -22
mlx5_core 0000:a1:00.0: mlx5_irq_alloc:321:(pid 6781): Failed to request irq. err = -22

Fixes: 3354822cde5a ("net/mlx5: Use dynamic msix vectors allocation")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241107183527.676877-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 32 ++++++++++++++++---
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 81a9232a03e1b..7db9cab9bedf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -593,9 +593,11 @@ static void irq_pool_free(struct mlx5_irq_pool *pool)
 	kvfree(pool);
 }
 
-static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pcif_vec)
+static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pcif_vec,
+			  bool dynamic_vec)
 {
 	struct mlx5_irq_table *table = dev->priv.irq_table;
+	int sf_vec_available = sf_vec;
 	int num_sf_ctrl;
 	int err;
 
@@ -616,6 +618,13 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pcif_vec)
 	num_sf_ctrl = DIV_ROUND_UP(mlx5_sf_max_functions(dev),
 				   MLX5_SFS_PER_CTRL_IRQ);
 	num_sf_ctrl = min_t(int, MLX5_IRQ_CTRL_SF_MAX, num_sf_ctrl);
+	if (!dynamic_vec && (num_sf_ctrl + 1) > sf_vec_available) {
+		mlx5_core_dbg(dev,
+			      "Not enough IRQs for SFs control and completion pool, required=%d avail=%d\n",
+			      num_sf_ctrl + 1, sf_vec_available);
+		return 0;
+	}
+
 	table->sf_ctrl_pool = irq_pool_alloc(dev, pcif_vec, num_sf_ctrl,
 					     "mlx5_sf_ctrl",
 					     MLX5_EQ_SHARE_IRQ_MIN_CTRL,
@@ -624,9 +633,11 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pcif_vec)
 		err = PTR_ERR(table->sf_ctrl_pool);
 		goto err_pf;
 	}
-	/* init sf_comp_pool */
+	sf_vec_available -= num_sf_ctrl;
+
+	/* init sf_comp_pool, remaining vectors are for the SF completions */
 	table->sf_comp_pool = irq_pool_alloc(dev, pcif_vec + num_sf_ctrl,
-					     sf_vec - num_sf_ctrl, "mlx5_sf_comp",
+					     sf_vec_available, "mlx5_sf_comp",
 					     MLX5_EQ_SHARE_IRQ_MIN_COMP,
 					     MLX5_EQ_SHARE_IRQ_MAX_COMP);
 	if (IS_ERR(table->sf_comp_pool)) {
@@ -715,6 +726,7 @@ int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table)
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 {
 	int num_eqs = mlx5_max_eq_cap_get(dev);
+	bool dynamic_vec;
 	int total_vec;
 	int pcif_vec;
 	int req_vec;
@@ -724,21 +736,31 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	if (mlx5_core_is_sf(dev))
 		return 0;
 
+	/* PCI PF vectors usage is limited by online cpus, device EQs and
+	 * PCI MSI-X capability.
+	 */
 	pcif_vec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() + 1;
 	pcif_vec = min_t(int, pcif_vec, num_eqs);
+	pcif_vec = min_t(int, pcif_vec, pci_msix_vec_count(dev->pdev));
 
 	total_vec = pcif_vec;
 	if (mlx5_sf_max_functions(dev))
 		total_vec += MLX5_MAX_MSIX_PER_SF * mlx5_sf_max_functions(dev);
 	total_vec = min_t(int, total_vec, pci_msix_vec_count(dev->pdev));
-	pcif_vec = min_t(int, pcif_vec, pci_msix_vec_count(dev->pdev));
 
 	req_vec = pci_msix_can_alloc_dyn(dev->pdev) ? 1 : total_vec;
 	n = pci_alloc_irq_vectors(dev->pdev, 1, req_vec, PCI_IRQ_MSIX);
 	if (n < 0)
 		return n;
 
-	err = irq_pools_init(dev, total_vec - pcif_vec, pcif_vec);
+	/* Further limit vectors of the pools based on platform for non dynamic case */
+	dynamic_vec = pci_msix_can_alloc_dyn(dev->pdev);
+	if (!dynamic_vec) {
+		pcif_vec = min_t(int, n, pcif_vec);
+		total_vec = min_t(int, n, total_vec);
+	}
+
+	err = irq_pools_init(dev, total_vec - pcif_vec, pcif_vec, dynamic_vec);
 	if (err)
 		pci_free_irq_vectors(dev->pdev);
 
-- 
2.43.0



