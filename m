Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5DD2FE571;
	Tue, 12 Aug 2025 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024228; cv=none; b=lZ5AmfVPd1r+Rn/B7K7Q2PzK1PtsoDcjUy5eXzMAcTNa5oUKiqU6MG9s/XKBKa8bD7/mxLRKb5kuOSGdsvudvzHS0IW1aY2AUFyjkw9QmHyVrXmJALmookdhTPG0WmUeaqJwyR6M6O2oqtf2HVtgy+t+hkA9pOHipj1UidBKU+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024228; c=relaxed/simple;
	bh=sbFqEc3OU4ansK2SHVPJyJv6Zfstx5KKuFdWcmij7dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxTTkdSyFRvK0cQEEH8og5yCcpIAJ4TDMeOPiMj/vW/tfhQ01FRU8ni9tlDos47HmNHEjPH+uFrIc+m1Ip4dcKApavDLdRo0MxkP1HWN3WlCfouBSSmrY9Q65F3xboZaKTRcEMEFAnDJIItl0xHQjQ6Vkr7X404BhjAaBUABNTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHEsEfRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHEsEfRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80350C4CEF0;
	Tue, 12 Aug 2025 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024228;
	bh=sbFqEc3OU4ansK2SHVPJyJv6Zfstx5KKuFdWcmij7dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHEsEfRmE31KSyMLr6gFF8kLG/2JNYYt6tGKFEpKDyuasH1xgJVN1nyjdwoRfqtcR
	 xJnQ630Xm5VKoCic0gwhlbIPnWp4/7mTiNSsrFVEZcpmp4naF0YwXtOcvPCKe9sukj
	 zMta4OhQPkzhRlCeAr71fpMTQkJk36dHbJS6/VBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 278/627] net/mlx5e: Fix potential deadlock by deferring RX timeout recovery
Date: Tue, 12 Aug 2025 19:29:33 +0200
Message-ID: <20250812173429.891919605@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit e80d65561571db5024fbdd5ec3f5472cfc485d21 ]

mlx5e_reporter_rx_timeout() is currently invoked synchronously
in the driver's open error flow. This causes the thread holding
priv->state_lock to attempt acquiring the devlink lock, which
can result in a circular dependency with other devlink operations.

For example:

- Devlink health diagnose flow:
  - __devlink_nl_pre_doit() acquires the devlink lock.
  - devlink_nl_health_reporter_diagnose_doit() invokes the
    driver's diagnose callback.
  - mlx5e_rx_reporter_diagnose() then attempts to acquire
    priv->state_lock.

- Driver open flow:
  - mlx5e_open() acquires priv->state_lock.
  - If an error occurs, devlink_health_reporter may be called,
    attempting to acquire the devlink lock.

To prevent this circular locking scenario, defer the RX timeout
recovery by scheduling it via a workqueue. This ensures that the
recovery work acquires locks in a consistent order: first the
devlink lock, then priv->state_lock.

Additionally, make the recovery work acquire the netdev instance
lock to safely synchronize with the open/close channel flows,
similar to mlx5e_tx_timeout_work. Repeatedly attempt to acquire
the netdev instance lock until it is taken or the target RQ is no
longer active, as indicated by the MLX5E_STATE_CHANNELS_ACTIVE bit.

Fixes: 32c57fb26863 ("net/mlx5e: Report and recover from rx timeout")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1753256672-337784-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |  7 +++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 26 ++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5b0d03b3efe8..48bcd6813aff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -728,6 +728,7 @@ struct mlx5e_rq {
 	struct xsk_buff_pool  *xsk_pool;
 
 	struct work_struct     recover_work;
+	struct work_struct     rx_timeout_work;
 
 	/* control */
 	struct mlx5_wq_ctrl    wq_ctrl;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index e75759533ae0..16c44d628eda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -170,16 +170,23 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 {
 	struct mlx5_eq_comp *eq;
+	struct mlx5e_priv *priv;
 	struct mlx5e_rq *rq;
 	int err;
 
 	rq = ctx;
+	priv = rq->priv;
+
+	mutex_lock(&priv->state_lock);
+
 	eq = rq->cq.mcq.eq;
 
 	err = mlx5e_health_channel_eq_recover(rq->netdev, eq, rq->cq.ch_stats);
 	if (err && rq->icosq)
 		clear_bit(MLX5E_SQ_STATE_ENABLED, &rq->icosq->state);
 
+	mutex_unlock(&priv->state_lock);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ea822c69d137..16d818943487 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -707,6 +707,27 @@ static void mlx5e_rq_err_cqe_work(struct work_struct *recover_work)
 	mlx5e_reporter_rq_cqe_err(rq);
 }
 
+static void mlx5e_rq_timeout_work(struct work_struct *timeout_work)
+{
+	struct mlx5e_rq *rq = container_of(timeout_work,
+					   struct mlx5e_rq,
+					   rx_timeout_work);
+
+	/* Acquire netdev instance lock to synchronize with channel close and
+	 * reopen flows. Either successfully obtain the lock, or detect that
+	 * channels are closing for another reason, making this work no longer
+	 * necessary.
+	 */
+	while (!netdev_trylock(rq->netdev)) {
+		if (!test_bit(MLX5E_STATE_CHANNELS_ACTIVE, &rq->priv->state))
+			return;
+		msleep(20);
+	}
+
+	mlx5e_reporter_rx_timeout(rq);
+	netdev_unlock(rq->netdev);
+}
+
 static int mlx5e_alloc_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
 {
 	rq->wqe_overflow.page = alloc_page(GFP_KERNEL);
@@ -830,6 +851,7 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
 
 	rqp->wq.db_numa_node = node;
 	INIT_WORK(&rq->recover_work, mlx5e_rq_err_cqe_work);
+	INIT_WORK(&rq->rx_timeout_work, mlx5e_rq_timeout_work);
 
 	if (params->xdp_prog)
 		bpf_prog_inc(params->xdp_prog);
@@ -1204,7 +1226,8 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time)
 	netdev_warn(rq->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%x] wq cur_sz(%d) min_rx_wqes(%d)\n",
 		    rq->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
 
-	mlx5e_reporter_rx_timeout(rq);
+	queue_work(rq->priv->wq, &rq->rx_timeout_work);
+
 	return -ETIMEDOUT;
 }
 
@@ -1375,6 +1398,7 @@ void mlx5e_close_rq(struct mlx5e_rq *rq)
 	if (rq->dim)
 		cancel_work_sync(&rq->dim->work);
 	cancel_work_sync(&rq->recover_work);
+	cancel_work_sync(&rq->rx_timeout_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
 	mlx5e_free_rq(rq);
-- 
2.39.5



