Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824B5811E6;
	Mon, 15 Apr 2024 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191707; cv=none; b=JqWkKMh23j+GImTmk13jQP22HqE1h+6mgh+yDUz+BonTJupRNVOwL+HCrai6R8faZ7y/RdmbesLTsTg8Pp4Om69HJ8MInD9k6sUhHRN1pIWiHn0PPrh/3konfLkLGgIZtz/zq49awCM+QF0/cZ9nkHqtHq0p65uP5bEYXdh8VaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191707; c=relaxed/simple;
	bh=a5wrMOapMGrkhuFNVFf+b9IRFt4+BXa9MyJWPiYd8SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFul4YDQg2bfzS0l/6xHyV1SImZ+QFYl4V7V7Vs0y/RzpmJgeYoD4cOlIdNBg08JhKkHC5FSx4GaQEMfYUFexH0npnTzzvgSXl02RlP0Iq4HmJei8WngNh2YwMki/VGmlD4xn8M/sGYjOFG3BYX3Y2s2NtuXhC7t/SGou2cXBmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSTuJZZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSTuJZZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3AC2BD10;
	Mon, 15 Apr 2024 14:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191707;
	bh=a5wrMOapMGrkhuFNVFf+b9IRFt4+BXa9MyJWPiYd8SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSTuJZZm2yHR4AYXeypYSbQFOyjdIn75gDro0O7PeZso0FZQba1w6a2UxpNjI5w2f
	 7QCpUQhzbCiPMfWI8gMpa61FDzDF6Eua2afnU3XNxZXNYNNsM/PPzGpyY6ferna3LQ
	 d1ikpOYwrx4JcSTGMJy3MQ9RhvT1NZYRB9nRSMUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/122] net/mlx5e: Fix mlx5e_priv_init() cleanup flow
Date: Mon, 15 Apr 2024 16:20:25 +0200
Message-ID: <20240415141955.179181258@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit ecb829459a841198e142f72fadab56424ae96519 ]

When mlx5e_priv_init() fails, the cleanup flow calls mlx5e_selq_cleanup which
calls mlx5e_selq_apply() that assures that the `priv->state_lock` is held using
lockdep_is_held().

Acquire the state_lock in mlx5e_selq_cleanup().

Kernel log:
=============================
WARNING: suspicious RCU usage
6.8.0-rc3_net_next_841a9b5 #1 Not tainted
-----------------------------
drivers/net/ethernet/mellanox/mlx5/core/en/selq.c:124 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
2 locks held by systemd-modules/293:
 #0: ffffffffa05067b0 (devices_rwsem){++++}-{3:3}, at: ib_register_client+0x109/0x1b0 [ib_core]
 #1: ffff8881096c65c0 (&device->client_data_rwsem){++++}-{3:3}, at: add_client_context+0x104/0x1c0 [ib_core]

stack backtrace:
CPU: 4 PID: 293 Comm: systemd-modules Not tainted 6.8.0-rc3_net_next_841a9b5 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x8a/0xa0
 lockdep_rcu_suspicious+0x154/0x1a0
 mlx5e_selq_apply+0x94/0xa0 [mlx5_core]
 mlx5e_selq_cleanup+0x3a/0x60 [mlx5_core]
 mlx5e_priv_init+0x2be/0x2f0 [mlx5_core]
 mlx5_rdma_setup_rn+0x7c/0x1a0 [mlx5_core]
 rdma_init_netdev+0x4e/0x80 [ib_core]
 ? mlx5_rdma_netdev_free+0x70/0x70 [mlx5_core]
 ipoib_intf_init+0x64/0x550 [ib_ipoib]
 ipoib_intf_alloc+0x4e/0xc0 [ib_ipoib]
 ipoib_add_one+0xb0/0x360 [ib_ipoib]
 add_client_context+0x112/0x1c0 [ib_core]
 ib_register_client+0x166/0x1b0 [ib_core]
 ? 0xffffffffa0573000
 ipoib_init_module+0xeb/0x1a0 [ib_ipoib]
 do_one_initcall+0x61/0x250
 do_init_module+0x8a/0x270
 init_module_from_file+0x8b/0xd0
 idempotent_init_module+0x17d/0x230
 __x64_sys_finit_module+0x61/0xb0
 do_syscall_64+0x71/0x140
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
 </TASK>

Fixes: 8bf30be75069 ("net/mlx5e: Introduce select queue parameters")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240409190820.227554-8-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index f675b1926340f..f66bbc8464645 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -57,6 +57,7 @@ int mlx5e_selq_init(struct mlx5e_selq *selq, struct mutex *state_lock)
 
 void mlx5e_selq_cleanup(struct mlx5e_selq *selq)
 {
+	mutex_lock(selq->state_lock);
 	WARN_ON_ONCE(selq->is_prepared);
 
 	kvfree(selq->standby);
@@ -67,6 +68,7 @@ void mlx5e_selq_cleanup(struct mlx5e_selq *selq)
 
 	kvfree(selq->standby);
 	selq->standby = NULL;
+	mutex_unlock(selq->state_lock);
 }
 
 void mlx5e_selq_prepare_params(struct mlx5e_selq *selq, struct mlx5e_params *params)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3961c2bbc57c..d49c348f89d28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5694,9 +5694,7 @@ void mlx5e_priv_cleanup(struct mlx5e_priv *priv)
 	kfree(priv->tx_rates);
 	kfree(priv->txq2sq);
 	destroy_workqueue(priv->wq);
-	mutex_lock(&priv->state_lock);
 	mlx5e_selq_cleanup(&priv->selq);
-	mutex_unlock(&priv->state_lock);
 	free_cpumask_var(priv->scratchpad.cpumask);
 
 	for (i = 0; i < priv->htb_max_qos_sqs; i++)
-- 
2.43.0



