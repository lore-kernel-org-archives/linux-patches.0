Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC152282F3A;
	Mon, 23 Mar 2026 16:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282461; cv=none; b=gDqc/YUweN72t3GNsMASL4cRyDCv2bYp3VvB0jzrO+4sNGiHkt1cDXe7T4R2/x0vF8Bz6iJ8lj8DTeYj6nNT7D0qGBiAlvDzHQyED+r/EPgcs0Sg/4rcJagIVZOdgBS4CqdHNHu685C/txrx4ElOcuamyU6zkss6guz2DjtI3Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282461; c=relaxed/simple;
	bh=GvmIR1Y3zDzx4lKioTQUYLe7ycAbXux+5m81fr8Lu0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ybv3Wl8cXlC2bqfZIdzlMHjsEbyGC3UcNIecw5z8yAsMHi/1lPmyE4iH2EgRPQhOM/3jwSIJIu3A4YQPaXnliN3+xjsQR7x2IxbF/6eQZKfG6LB7TPKGPuIvg8uoLtG9t79DmW2NsiCHTsmpGVPZ9eLTPo3x4wHJCW1yT1YBdFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f45S1kCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f45S1kCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FD3C4CEF7;
	Mon, 23 Mar 2026 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282461;
	bh=GvmIR1Y3zDzx4lKioTQUYLe7ycAbXux+5m81fr8Lu0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f45S1kCqoRvEjWFDTBQ9PjwCGMIpq4I8IYjyOI7xzX2AP5ELku6v7qMxZ4jiMIAkE
	 RLBu6fzBf3RzfPOLvRcQNM13flFs8PAA12h++YV2M8AYLDAl4fwq9xKCKziglQNTZI
	 I/YIDIWgI0ZQMbzAv8ZhddpZYqqrm296SRjwyeO8=
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
Subject: [PATCH 6.1 165/481] net/mlx5: Fix deadlock between devlink lock and esw->wq
Date: Mon, 23 Mar 2026 14:42:27 +0100
Message-ID: <20260323134529.250211632@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3255af4313a29..8b2b78f05cbe7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -999,10 +999,11 @@ static void mlx5_eswitch_event_handler_register(struct mlx5_eswitch *esw)
 
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
index ff20b43a551de..00d169a11a0a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -275,10 +275,12 @@ struct esw_mc_addr { /* SRIOV only */
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
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f7f1eae998b5e..2a64d0fd2fe52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3207,22 +3207,28 @@ static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
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
@@ -3237,6 +3243,7 @@ esw_vfs_changed_event_handler(struct mlx5_eswitch *esw, const u32 *out)
 		}
 	}
 	esw->esw_funcs.num_vfs = new_num_vfs;
+unlock:
 	devl_unlock(devlink);
 }
 
@@ -3253,7 +3260,7 @@ static void esw_functions_changed_event_handler(struct work_struct *work)
 	if (IS_ERR(out))
 		goto out;
 
-	esw_vfs_changed_event_handler(esw, out);
+	esw_vfs_changed_event_handler(esw, host_work->work_gen, out);
 	kvfree(out);
 out:
 	kfree(host_work);
@@ -3273,6 +3280,7 @@ int mlx5_esw_funcs_changed_handler(struct notifier_block *nb, unsigned long type
 	esw = container_of(esw_funcs, struct mlx5_eswitch, esw_funcs);
 
 	host_work->esw = esw;
+	host_work->work_gen = atomic_read(&esw_funcs->generation);
 
 	INIT_WORK(&host_work->work, esw_functions_changed_event_handler);
 	queue_work(esw->work_queue, &host_work->work);
-- 
2.51.0



