Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E2A2D4805;
	Wed, 25 Feb 2026 06:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002746; cv=none; b=SFp59vGcEK4aOHy40xg2WKQpjg23CxlnsD2LfNsd8PA/GfHC1GQ9t7x2eZqt1v6COkRdZwlc/5nfFE/Aj/ZoJMEFwdsozy5r1xgmT7MpZamGHf3LGohbZv8s0Uam1tTu27rDH8xb8j/b+uMJScDgDUCQGziiOlH/MHHGnUlZVPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002746; c=relaxed/simple;
	bh=ULVUy3DtrrBUNPwB1WKhKoM+E9HwhBSCdOxrAzOgRNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9RLd2yCVb5E8ATB8qzRPL+gNVkn630uM5gtLinHmggp1kOcbTdKnK1hd3fkwtAsE19GBAphiw1qb3Ez89Y6r+ONDOsWJ3yRKoifALXlNAcLzh5DtwpcnVURN7xCJYvpQdzcDtUFdd151JocALKrxQMvVji6wjifLP6U/5WDWfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDC3atYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDC3atYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B53AC116D0;
	Wed, 25 Feb 2026 06:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002746;
	bh=ULVUy3DtrrBUNPwB1WKhKoM+E9HwhBSCdOxrAzOgRNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDC3atYNnT3AMmlpI44gON46p8MpLY1j9ZrT7rKYx2O29mPs7J7OS5vpkxJaudBQw
	 d6a4GwN0yQTjWCbZqWFec2Ncxs5q9prF2Y0CKm8hUv+6+EZaT5wRodi+gdxTnEawB7
	 R8V1Ez8JF8i83laTHFKc6K8x8xZlz3tLEmp5OwdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <Jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 561/641] net/mlx5e: Fix deadlocks between devlink and netdev instance locks
Date: Tue, 24 Feb 2026 17:24:47 -0800
Message-ID: <20260225012402.116628172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 83ac0304a2d77519dae1e54c9713cbe1aedf19c9 ]

In the mentioned "Fixes" commit, various work tasks triggering devlink
health reporter recovery were switched to use netdev_trylock to protect
against concurrent tear down of the channels being recovered. But this
had the side effect of introducing potential deadlocks because of
incorrect lock ordering.

The correct lock order is described by the init flow:
probe_one -> mlx5_init_one (acquires devlink lock)
-> mlx5_init_one_devl_locked -> mlx5_register_device
-> mlx5_rescan_drivers_locked -...-> mlx5e_probe -> _mlx5e_probe
-> register_netdev (acquires rtnl lock)
-> register_netdevice (acquires netdev lock)
=> devlink lock -> rtnl lock -> netdev lock.

But in the current recovery flow, the order is wrong:
mlx5e_tx_err_cqe_work (acquires netdev lock)
-> mlx5e_reporter_tx_err_cqe -> mlx5e_health_report
-> devlink_health_report (acquires devlink lock => boom!)
-> devlink_health_reporter_recover
-> mlx5e_tx_reporter_recover -> mlx5e_tx_reporter_recover_from_ctx
-> mlx5e_tx_reporter_err_cqe_recover

The same pattern exists in:
mlx5e_reporter_rx_timeout
mlx5e_reporter_tx_ptpsq_unhealthy
mlx5e_reporter_tx_timeout

Fix these by moving the netdev_trylock calls from the work handlers
lower in the call stack, in the respective recovery functions, where
they are actually necessary.

Fixes: 8f7b00307bf1 ("net/mlx5e: Convert mlx5 netdevs to instance locking")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <Jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260218072904.1764634-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 14 -----
 .../mellanox/mlx5/core/en/reporter_rx.c       | 13 +++++
 .../mellanox/mlx5/core/en/reporter_tx.c       | 52 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 40 --------------
 4 files changed, 61 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index c93ee969ea647..ec715b158a342 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -448,22 +448,8 @@ static void mlx5e_ptpsq_unhealthy_work(struct work_struct *work)
 {
 	struct mlx5e_ptpsq *ptpsq =
 		container_of(work, struct mlx5e_ptpsq, report_unhealthy_work);
-	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
-
-	/* Recovering the PTP SQ means re-enabling NAPI, which requires the
-	 * netdev instance lock. However, SQ closing has to wait for this work
-	 * task to finish while also holding the same lock. So either get the
-	 * lock or find that the SQ is no longer enabled and thus this work is
-	 * not relevant anymore.
-	 */
-	while (!netdev_trylock(sq->netdev)) {
-		if (!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state))
-			return;
-		msleep(20);
-	}
 
 	mlx5e_reporter_tx_ptpsq_unhealthy(ptpsq);
-	netdev_unlock(sq->netdev);
 }
 
 static int mlx5e_ptp_open_txqsq(struct mlx5e_ptp *c, u32 tisn,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index b1415992ffa24..a09a7c05820d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Mellanox Technologies.
 
+#include <net/netdev_lock.h>
+
 #include "health.h"
 #include "params.h"
 #include "txrx.h"
@@ -177,6 +179,16 @@ static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 	rq = ctx;
 	priv = rq->priv;
 
+	/* Acquire netdev instance lock to synchronize with channel close and
+	 * reopen flows. Either successfully obtain the lock, or detect that
+	 * channels are closing for another reason, making this work no longer
+	 * necessary.
+	 */
+	while (!netdev_trylock(rq->netdev)) {
+		if (!test_bit(MLX5E_STATE_CHANNELS_ACTIVE, &rq->priv->state))
+			return 0;
+		msleep(20);
+	}
 	mutex_lock(&priv->state_lock);
 
 	eq = rq->cq.mcq.eq;
@@ -186,6 +198,7 @@ static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 		clear_bit(MLX5E_SQ_STATE_ENABLED, &rq->icosq->state);
 
 	mutex_unlock(&priv->state_lock);
+	netdev_unlock(rq->netdev);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 9e2cf191ed308..9f6454102cf79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2019 Mellanox Technologies. */
 
+#include <net/netdev_lock.h>
+
 #include "health.h"
 #include "en/ptp.h"
 #include "en/devlink.h"
@@ -78,6 +80,18 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	if (!test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
 		return 0;
 
+	/* Recovering queues means re-enabling NAPI, which requires the netdev
+	 * instance lock. However, SQ closing flows have to wait for work tasks
+	 * to finish while also holding the netdev instance lock. So either get
+	 * the lock or find that the SQ is no longer enabled and thus this work
+	 * is not relevant anymore.
+	 */
+	while (!netdev_trylock(dev)) {
+		if (!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state))
+			return 0;
+		msleep(20);
+	}
+
 	err = mlx5_core_query_sq_state(mdev, sq->sqn, &state);
 	if (err) {
 		netdev_err(dev, "Failed to query SQ 0x%x state. err = %d\n",
@@ -113,9 +127,11 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	else
 		mlx5e_trigger_napi_sched(sq->cq.napi);
 
+	netdev_unlock(dev);
 	return 0;
 out:
 	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
+	netdev_unlock(dev);
 	return err;
 }
 
@@ -136,10 +152,24 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	sq = to_ctx->sq;
 	eq = sq->cq.mcq.eq;
 	priv = sq->priv;
+
+	/* Recovering the TX queues implies re-enabling NAPI, which requires
+	 * the netdev instance lock.
+	 * However, channel closing flows have to wait for this work to finish
+	 * while holding the same lock. So either get the lock or find that
+	 * channels are being closed for other reason and this work is not
+	 * relevant anymore.
+	 */
+	while (!netdev_trylock(sq->netdev)) {
+		if (!test_bit(MLX5E_STATE_CHANNELS_ACTIVE, &priv->state))
+			return 0;
+		msleep(20);
+	}
+
 	err = mlx5e_health_channel_eq_recover(sq->netdev, eq, sq->cq.ch_stats);
 	if (!err) {
 		to_ctx->status = 0; /* this sq recovered */
-		return err;
+		goto out;
 	}
 
 	mutex_lock(&priv->state_lock);
@@ -147,7 +177,7 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	mutex_unlock(&priv->state_lock);
 	if (!err) {
 		to_ctx->status = 1; /* all channels recovered */
-		return err;
+		goto out;
 	}
 
 	to_ctx->status = err;
@@ -155,7 +185,8 @@ static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 	netdev_err(priv->netdev,
 		   "mlx5e_safe_reopen_channels failed recovering from a tx_timeout, err(%d).\n",
 		   err);
-
+out:
+	netdev_unlock(sq->netdev);
 	return err;
 }
 
@@ -172,10 +203,22 @@ static int mlx5e_tx_reporter_ptpsq_unhealthy_recover(void *ctx)
 		return 0;
 
 	priv = ptpsq->txqsq.priv;
+	netdev = priv->netdev;
+
+	/* Recovering the PTP SQ means re-enabling NAPI, which requires the
+	 * netdev instance lock. However, SQ closing has to wait for this work
+	 * task to finish while also holding the same lock. So either get the
+	 * lock or find that the SQ is no longer enabled and thus this work is
+	 * not relevant anymore.
+	 */
+	while (!netdev_trylock(netdev)) {
+		if (!test_bit(MLX5E_SQ_STATE_ENABLED, &ptpsq->txqsq.state))
+			return 0;
+		msleep(20);
+	}
 
 	mutex_lock(&priv->state_lock);
 	chs = &priv->channels;
-	netdev = priv->netdev;
 
 	carrier_ok = netif_carrier_ok(netdev);
 	netif_carrier_off(netdev);
@@ -192,6 +235,7 @@ static int mlx5e_tx_reporter_ptpsq_unhealthy_recover(void *ctx)
 		netif_carrier_on(netdev);
 
 	mutex_unlock(&priv->state_lock);
+	netdev_unlock(netdev);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 59e17b41c3a67..cb993ad2d9ad9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -688,19 +688,7 @@ static void mlx5e_rq_timeout_work(struct work_struct *timeout_work)
 					   struct mlx5e_rq,
 					   rx_timeout_work);
 
-	/* Acquire netdev instance lock to synchronize with channel close and
-	 * reopen flows. Either successfully obtain the lock, or detect that
-	 * channels are closing for another reason, making this work no longer
-	 * necessary.
-	 */
-	while (!netdev_trylock(rq->netdev)) {
-		if (!test_bit(MLX5E_STATE_CHANNELS_ACTIVE, &rq->priv->state))
-			return;
-		msleep(20);
-	}
-
 	mlx5e_reporter_rx_timeout(rq);
-	netdev_unlock(rq->netdev);
 }
 
 static int mlx5e_alloc_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
@@ -1997,20 +1985,7 @@ void mlx5e_tx_err_cqe_work(struct work_struct *recover_work)
 	struct mlx5e_txqsq *sq = container_of(recover_work, struct mlx5e_txqsq,
 					      recover_work);
 
-	/* Recovering queues means re-enabling NAPI, which requires the netdev
-	 * instance lock. However, SQ closing flows have to wait for work tasks
-	 * to finish while also holding the netdev instance lock. So either get
-	 * the lock or find that the SQ is no longer enabled and thus this work
-	 * is not relevant anymore.
-	 */
-	while (!netdev_trylock(sq->netdev)) {
-		if (!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state))
-			return;
-		msleep(20);
-	}
-
 	mlx5e_reporter_tx_err_cqe(sq);
-	netdev_unlock(sq->netdev);
 }
 
 static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
@@ -5102,19 +5077,6 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
 	struct net_device *netdev = priv->netdev;
 	int i;
 
-	/* Recovering the TX queues implies re-enabling NAPI, which requires
-	 * the netdev instance lock.
-	 * However, channel closing flows have to wait for this work to finish
-	 * while holding the same lock. So either get the lock or find that
-	 * channels are being closed for other reason and this work is not
-	 * relevant anymore.
-	 */
-	while (!netdev_trylock(netdev)) {
-		if (!test_bit(MLX5E_STATE_CHANNELS_ACTIVE, &priv->state))
-			return;
-		msleep(20);
-	}
-
 	for (i = 0; i < netdev->real_num_tx_queues; i++) {
 		struct netdev_queue *dev_queue =
 			netdev_get_tx_queue(netdev, i);
@@ -5127,8 +5089,6 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
 		/* break if tried to reopened channels */
 			break;
 	}
-
-	netdev_unlock(netdev);
 }
 
 static void mlx5e_tx_timeout(struct net_device *dev, unsigned int txqueue)
-- 
2.51.0



