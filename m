Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C66258CD9;
	Mon, 23 Mar 2026 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278174; cv=none; b=ezLWpqDrmwjl+2J17XFpjoVAhG0OWVaHhe7U5LsUTSjv410NBFImQTfBa5HSfD/KpXv+sTAp+U5/f8Niapj1EfSEqwkz89Bm/ypkiYUS8fCqRt9R6skTPIR47WoiJV1O0Zirjp3xeWvVuXJYHNAhV+nNUegHhdK0ysRX14Uy3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278174; c=relaxed/simple;
	bh=r7GAaWAR2EtYYdKxp0zQ1RsOLSezgLzMrID67Bk/C9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNzxv8sUdSkxrjekWQPhjryFghIb6hYrH+EvTeYIp2GRUt+js+vbSJbCBARxaCITX5ih4zn/LHNsvKM+D0+5EaEX8/u+W+GjWGdZdjr+izO34wfJyaTpdhNSfomsT3Z5p3+36ZAWzxN0Mi+iLjgNYsFxbyqGbpS1gF+BA4juX1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Dsm2TdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Dsm2TdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC1EC2BCB3;
	Mon, 23 Mar 2026 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278174;
	bh=r7GAaWAR2EtYYdKxp0zQ1RsOLSezgLzMrID67Bk/C9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Dsm2TdAh/RMIzYW9Ql1aueLhB52sFFCj/5aDmMqV0vvtpy3l+LdGx02XFusoPYFF
	 e4UpnpFoDxnA+G9pbjoryjN5lJ7j6uRVRCpW2jTtRyMSkdQ4tpvp1pOZ/88ll97w4v
	 4tlDI173Th/SAZUTqXEbR73jwieYUrSYc4KjaJwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/567] net/mlx5: Fix deadlock between devlink lock and esw->wq
Date: Mon, 23 Mar 2026 14:42:23 +0100
Message-ID: <20260323134539.348123688@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit aed763abf0e905b4b8d747d1ba9e172961572f57 ]

esw->work_queue executes esw_functions_changed_event_handler ->
esw_vfs_changed_event_handler and acquires the devlink lock.

.eswitch_mode_set (acquires devlink lock in devlink_nl_pre_doit) ->
mlx5_devlink_eswitch_mode_set -> mlx5_eswitch_disable_locked ->
mlx5_eswitch_event_handler_unregister -> flush_workqueue deadlocks
when esw_vfs_changed_event_handler executes.

Fix that by no longer flushing the work to avoid the deadlock, and using
a generation counter to keep track of work relevance. This avoids an old
handler manipulating an esw that has undergone one or more mode changes:
- the counter is incremented in mlx5_eswitch_event_handler_unregister.
- the counter is read and passed to the ephemeral mlx5_host_work struct.
- the work handler takes the devlink lock and bails out if the current
  generation is different than the one it was scheduled to operate on.
- mlx5_eswitch_cleanup does the final draining before destroying the wq.

No longer flushing the workqueue has the side effect of maybe no longer
cancelling pending vport_change_handler work items, but that's ok since
those are disabled elsewhere:
- mlx5_eswitch_disable_locked disables the vport eq notifier.
- mlx5_esw_vport_disable disarms the HW EQ notification and marks
  vport->enabled under state_lock to false to prevent pending vport
  handler from doing anything.
- mlx5_eswitch_cleanup destroys the workqueue and makes sure all events
  are disabled/finished.

Fixes: f1bc646c9a06 ("net/mlx5: Use devl_ API in mlx5_esw_offloads_devlink_port_register")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260305081019.1811100-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c  |  7 ++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 ++
 .../mellanox/mlx5/core/eswitch_offloads.c      | 18 +++++++++++++-----
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 79fa78b188250..2559237da49c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1068,10 +1068,11 @@ static void mlx5_eswitch_event_handler_register(struct mlx5_eswitch *esw)
 
 static void mlx5_eswitch_event_handler_unregister(struct mlx5_eswitch *esw)
 {
-	if (esw->mode == MLX5_ESWITCH_OFFLOADS && mlx5_eswitch_is_funcs_handler(esw->dev))
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS &&
+	    mlx5_eswitch_is_funcs_handler(esw->dev)) {
 		mlx5_eq_notifier_unregister(esw->dev, &esw->esw_funcs.nb);
-
-	flush_workqueue(esw->work_queue);
+		atomic_inc(&esw->esw_funcs.generation);
+	}
 }
 
 static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 23e612dd329db..48bebc3b8b12c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -311,10 +311,12 @@ struct esw_mc_addr { /* SRIOV only */
 struct mlx5_host_work {
 	struct work_struct	work;
 	struct mlx5_eswitch	*esw;
+	int			work_gen;
 };
 
 struct mlx5_esw_functions {
 	struct mlx5_nb		nb;
+	atomic_t		generation;
 	bool			host_funcs_disabled;
 	u16			num_vfs;
 	u16			num_ec_vfs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c218593dc40f4..e69e0f2c33964 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3387,22 +3387,28 @@ static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
 }
 
 static void
-esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
+esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, int work_gen,
+			      const u32 *out)
 {
 	struct devlink *devlink;
 	bool host_pf_disabled;
 	u16 new_num_vfs;
 
+	devlink = priv_to_devlink(esw->dev);
+	devl_lock(devlink);
+
+	/* Stale work from one or more mode changes ago. Bail out. */
+	if (work_gen != atomic_read(&esw->esw_funcs.generation))
+		goto unlock;
+
 	new_num_vfs = MLX5_GET(query_esw_functions_out, out,
 			       host_params_context.host_num_of_vfs);
 	host_pf_disabled = MLX5_GET(query_esw_functions_out, out,
 				    host_params_context.host_pf_disabled);
 
 	if (new_num_vfs == esw->esw_funcs.num_vfs || host_pf_disabled)
-		return;
+		goto unlock;
 
-	devlink = priv_to_devlink(esw->dev);
-	devl_lock(devlink);
 	/* Number of VFs can only change from "0 to x" or "x to 0". */
 	if (esw->esw_funcs.num_vfs > 0) {
 		mlx5_eswitch_unload_vf_vports(esw, esw->esw_funcs.num_vfs);
@@ -3417,6 +3423,7 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 		}
 	}
 	esw->esw_funcs.num_vfs = new_num_vfs;
+unlock:
 	devl_unlock(devlink);
 }
 
@@ -3433,7 +3440,7 @@ static void esw_functions_changed_event_handler(struct work_struct *work)
 	if (IS_ERR(out))
 		goto out;
 
-	esw_vfs_changed_event_handler(esw, out);
+	esw_vfs_changed_event_handler(esw, host_work->work_gen, out);
 	kvfree(out);
 out:
 	kfree(host_work);
@@ -3453,6 +3460,7 @@ int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned long type
 	esw = container_of(esw_funcs, struct mlx5_eswitch, esw_funcs);
 
 	host_work->esw = esw;
+	host_work->work_gen = atomic_read(&esw_funcs->generation);
 
 	INIT_WORK(&host_work->work, esw_functions_changed_event_handler);
 	queue_work(esw->work_queue, &host_work->work);
-- 
2.51.0



