Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A9E330D42;
	Mon, 29 Dec 2025 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025183; cv=none; b=SucqUJr1a9VLT8uqzjv4V8tqkAfxWuJW4n9DSIlq4jIDryznkqm+kk03ACnSumFqFeV97/liVbZXNGHpaJtjHAUQJd3FODAaR9+f0N9TKi0ns0pSl0ONByFs3HON/cMfC3eIZMIk0dsigbmtPpQnjgv64QGQhWln8tdw4TezLGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025183; c=relaxed/simple;
	bh=uSyeIffZKoGqSvb7rl+prdqJ08/FUGfFaOsZuBm4nKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVixVv2/oFmJBTTcCeFf8qgRQykaqlfnhDBztODu9uINAPcEnWdSlmwYf/B/WvavBGorARonyq5aYBJJRemYmlH6FVpjdMe7bC0WQXU1R5qsRHerD+plt686uDoaCShIqOGY4toVCRk9fgyw55EpfzpEQ4cjlmcRzPjTZ4jYY5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xq2rRUZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xq2rRUZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A0FC4CEF7;
	Mon, 29 Dec 2025 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025183;
	bh=uSyeIffZKoGqSvb7rl+prdqJ08/FUGfFaOsZuBm4nKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xq2rRUZAgvNsiuWHsDKBLceMf5tzZ8MIB4nB/GReZkVydDjdZXYUN3tL0MRl9bW0s
	 pRtKU6LqOBkvYF17t4NwYFh/IeoMns3RkVQjMTbOcpFMEuXdYuximY61DgXz0KEJW0
	 sVQmyhVTK/CHnuMCIm/8kaQv3xGaiIaocackjwdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mateusz Berezecki <mberezecki@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/430] net/mlx5: Serialize firmware reset with devlink
Date: Mon, 29 Dec 2025 17:08:18 +0100
Message-ID: <20251229160727.895845343@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 367e501f8b095eca08d2eb0ba4ccea5b5e82c169 ]

The firmware reset mechanism can be triggered by asynchronous events,
which may race with other devlink operations like devlink reload or
devlink dev eswitch set, potentially leading to inconsistent states.

This patch addresses the race by using the devl_lock to serialize the
firmware reset against other devlink operations. When a reset is
requested, the driver attempts to acquire the lock. If successful, it
sets a flag to block devlink reload or eswitch changes, ACKs the reset
to firmware and then releases the lock. If the lock is already held by
another operation, the driver NACKs the firmware reset request,
indicating that the reset cannot proceed.

Firmware reset does not keep the devl_lock and instead uses an internal
firmware reset bit. This is because firmware resets can be triggered by
asynchronous events, and processed in different threads. It is illegal
and unsafe to acquire a lock in one thread and attempt to release it in
another, as lock ownership is intrinsically thread-specific.

This change ensures that firmware resets and other devlink operations
are mutually exclusive during the critical reset request phase,
preventing race conditions.

Fixes: 38b9f903f22b ("net/mlx5: Handle sync reset request event")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mateusz Berezecki <mberezecki@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-6-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  5 +++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  6 +++
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 45 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  1 +
 4 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 887adf4807d16..ea77fbd98396a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -197,6 +197,11 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	struct pci_dev *pdev = dev->pdev;
 	int ret = 0;
 
+	if (mlx5_fw_reset_in_progress(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't reload during firmware reset");
+		return -EBUSY;
+	}
+
 	if (mlx5_dev_is_lightweight(dev)) {
 		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT)
 			return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 44a142a041b2f..784130cdf6c07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -52,6 +52,7 @@
 #include "devlink.h"
 #include "lag/lag.h"
 #include "en/tc/post_meter.h"
+#include "fw_reset.h"
 
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
@@ -3807,6 +3808,11 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
+	if (mlx5_fw_reset_in_progress(esw->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Can't change eswitch mode during firmware reset");
+		return -EBUSY;
+	}
+
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 33df0418e5754..4544f1968f73f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -15,6 +15,7 @@ enum {
 	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS,
 	MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED,
 	MLX5_FW_RESET_FLAGS_UNLOAD_EVENT,
+	MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS,
 };
 
 struct mlx5_fw_reset {
@@ -127,6 +128,16 @@ int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 	return mlx5_reg_mfrl_query(dev, reset_level, reset_type, NULL, NULL);
 }
 
+bool mlx5_fw_reset_in_progress(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	if (!fw_reset)
+		return false;
+
+	return test_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
+}
+
 static int mlx5_fw_reset_get_reset_method(struct mlx5_core_dev *dev,
 					  u8 *reset_method)
 {
@@ -242,6 +253,8 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
 		devl_unlock(devlink);
 	}
+
+	clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
 }
 
 static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
@@ -461,27 +474,48 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
 						      reset_request_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
+	bool nack_request = false;
+	struct devlink *devlink;
 	int err;
 
 	err = mlx5_fw_reset_get_reset_method(dev, &fw_reset->reset_method);
-	if (err)
+	if (err) {
+		nack_request = true;
 		mlx5_core_warn(dev, "Failed reading MFRL, err %d\n", err);
+	} else if (!mlx5_is_reset_now_capable(dev, fw_reset->reset_method) ||
+		   test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
+			    &fw_reset->reset_flags)) {
+		nack_request = true;
+	}
 
-	if (err || test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags) ||
-	    !mlx5_is_reset_now_capable(dev, fw_reset->reset_method)) {
+	devlink = priv_to_devlink(dev);
+	/* For external resets, try to acquire devl_lock. Skip if devlink reset is
+	 * pending (lock already held)
+	 */
+	if (nack_request ||
+	    (!test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP,
+		       &fw_reset->reset_flags) &&
+	     !devl_trylock(devlink))) {
 		err = mlx5_fw_reset_set_reset_sync_nack(dev);
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Nack %s",
 			       err ? "Failed" : "Sent");
 		return;
 	}
+
 	if (mlx5_sync_reset_set_reset_requested(dev))
-		return;
+		goto unlock;
+
+	set_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
 
 	err = mlx5_fw_reset_set_reset_sync_ack(dev);
 	if (err)
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack Failed. Error code: %d\n", err);
 	else
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack. Device reset is expected.\n");
+
+unlock:
+	if (!test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags))
+		devl_unlock(devlink);
 }
 
 static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev, u16 dev_id)
@@ -721,6 +755,8 @@ static void mlx5_sync_reset_abort_event(struct work_struct *work)
 
 	if (mlx5_sync_reset_clear_reset_requested(dev, true))
 		return;
+
+	clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
 	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
 }
 
@@ -757,6 +793,7 @@ static void mlx5_sync_reset_timeout_work(struct work_struct *work)
 
 	if (mlx5_sync_reset_clear_reset_requested(dev, true))
 		return;
+	clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
 	mlx5_core_warn(dev, "PCI Sync FW Update Reset Timeout.\n");
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index d5b28525c960d..2d96b2adc1cdf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -10,6 +10,7 @@ int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel,
 				 struct netlink_ext_ack *extack);
 int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev);
+bool mlx5_fw_reset_in_progress(struct mlx5_core_dev *dev);
 
 int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev);
 void mlx5_sync_reset_unload_flow(struct mlx5_core_dev *dev, bool locked);
-- 
2.51.0



