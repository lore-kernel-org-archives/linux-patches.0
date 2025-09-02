Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F52305062;
	Tue,  2 Sep 2025 13:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819602; cv=none; b=UY+HBdjlbOwFEED8NydAXIkn0aCUcTnmQBHTwDVefRjCwI5seALRBWntTOg271oCC3zYoccMK+QZOsVrlfE1RroVYbSBIHGeBUHeMAPgw8taCT59MQvoBGEYvPn9boq4wgFwHDl9g6K+JIYcuV6Sw95Y+Z0yEnAir5hearYpPWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819602; c=relaxed/simple;
	bh=7fkvEnLWcioi3hhS6SGypaXNPP2Zmk4y+cmWzzxp+J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b13Z8MfyTBpTqTio4YV+uA0LUfQPzjsgRQfO8z7eqpZcsFALjihrsf29+TFvKhB4SVOnI/F3XCnXFPnYTvICCDdfNBqI1CZaVfRSSGXba6XMJSX8P4GYiUqa7HtBGLuNgfsWYLsQPp0RkH1lg669DsfOuGkH5UavBw7L3T2DI68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xy4KTRdL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xy4KTRdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA513C4CEF5;
	Tue,  2 Sep 2025 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819602;
	bh=7fkvEnLWcioi3hhS6SGypaXNPP2Zmk4y+cmWzzxp+J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xy4KTRdLcUQoklwbKleGSjXwWnhD+DRizq3b0f3c7mw2k7RYIxd8u8zqOfxYKIjg8
	 JQzCldsBA703Jdo3veYxrMv83uxE8SdVQWTzA2/3O8I7fEA/jmvNfzn3p3cjaN+cFm
	 DU/k1vlVLsF/KRZJzE/FwDzwXQlf07e8xjA24otI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 083/142] net/mlx5: Fix lockdep assertion on sync reset unload event
Date: Tue,  2 Sep 2025 15:19:45 +0200
Message-ID: <20250902131951.447211698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 902a8bc23a24882200f57cadc270e15a2cfaf2bb ]

Fix lockdep assertion triggered during sync reset unload event. When the
sync reset flow is initiated using the devlink reload fw_activate
option, the PF already holds the devlink lock while handling unload
event. In this case, delegate sync reset unload event handling back to
the devlink callback process to avoid double-locking and resolve the
lockdep warning.

Kernel log:
WARNING: CPU: 9 PID: 1578 at devl_assert_locked+0x31/0x40
[...]
Call Trace:
<TASK>
 mlx5_unload_one_devl_locked+0x2c/0xc0 [mlx5_core]
 mlx5_sync_reset_unload_event+0xaf/0x2f0 [mlx5_core]
 process_one_work+0x222/0x640
 worker_thread+0x199/0x350
 kthread+0x10b/0x230
 ? __pfx_worker_thread+0x10/0x10
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x8e/0x100
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
</TASK>

Fixes: 7a9770f1bfea ("net/mlx5: Handle sync reset unload event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-7-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +-
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 120 ++++++++++--------
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |   1 +
 3 files changed, 69 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 42c70862095e9..ca03dbcb07da0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -107,7 +107,7 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	if (err)
 		return err;
 
-	mlx5_unload_one_devl_locked(dev, false);
+	mlx5_sync_reset_unload_flow(dev, true);
 	err = mlx5_health_wait_pci_up(dev);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "FW activate aborted, PCI reads fail after reset");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 69933addd921e..38b9b184ae01b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -12,7 +12,8 @@ enum {
 	MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
 	MLX5_FW_RESET_FLAGS_PENDING_COMP,
 	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS,
-	MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED
+	MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED,
+	MLX5_FW_RESET_FLAGS_UNLOAD_EVENT,
 };
 
 struct mlx5_fw_reset {
@@ -219,7 +220,7 @@ int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev)
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL0, 0, 0, false);
 }
 
-static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev, bool unloaded)
+static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 	struct devlink *devlink = priv_to_devlink(dev);
@@ -228,8 +229,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev, bool unload
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
 		complete(&fw_reset->done);
 	} else {
-		if (!unloaded)
-			mlx5_unload_one(dev, false);
+		mlx5_sync_reset_unload_flow(dev, false);
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
@@ -272,7 +272,7 @@ static void mlx5_sync_reset_reload_work(struct work_struct *work)
 
 	mlx5_sync_reset_clear_reset_requested(dev, false);
 	mlx5_enter_error_state(dev, true);
-	mlx5_fw_reset_complete_reload(dev, false);
+	mlx5_fw_reset_complete_reload(dev);
 }
 
 #define MLX5_RESET_POLL_INTERVAL	(HZ / 10)
@@ -586,6 +586,65 @@ static int mlx5_sync_pci_reset(struct mlx5_core_dev *dev, u8 reset_method)
 	return err;
 }
 
+void mlx5_sync_reset_unload_flow(struct mlx5_core_dev *dev, bool locked)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	unsigned long timeout;
+	int poll_freq = 20;
+	bool reset_action;
+	u8 rst_state;
+	int err;
+
+	if (locked)
+		mlx5_unload_one_devl_locked(dev, false);
+	else
+		mlx5_unload_one(dev, false);
+
+	if (!test_bit(MLX5_FW_RESET_FLAGS_UNLOAD_EVENT, &fw_reset->reset_flags))
+		return;
+
+	mlx5_set_fw_rst_ack(dev);
+	mlx5_core_warn(dev, "Sync Reset Unload done, device reset expected\n");
+
+	reset_action = false;
+	timeout = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, RESET_UNLOAD));
+	do {
+		rst_state = mlx5_get_fw_rst_state(dev);
+		if (rst_state == MLX5_FW_RST_STATE_TOGGLE_REQ ||
+		    rst_state == MLX5_FW_RST_STATE_IDLE) {
+			reset_action = true;
+			break;
+		}
+		if (rst_state == MLX5_FW_RST_STATE_DROP_MODE) {
+			mlx5_core_info(dev, "Sync Reset Drop mode ack\n");
+			mlx5_set_fw_rst_ack(dev);
+			poll_freq = 1000;
+		}
+		msleep(poll_freq);
+	} while (!time_after(jiffies, timeout));
+
+	if (!reset_action) {
+		mlx5_core_err(dev, "Got timeout waiting for sync reset action, state = %u\n",
+			      rst_state);
+		fw_reset->ret = -ETIMEDOUT;
+		goto done;
+	}
+
+	mlx5_core_warn(dev, "Sync Reset, got reset action. rst_state = %u\n",
+		       rst_state);
+	if (rst_state == MLX5_FW_RST_STATE_TOGGLE_REQ) {
+		err = mlx5_sync_pci_reset(dev, fw_reset->reset_method);
+		if (err) {
+			mlx5_core_warn(dev, "mlx5_sync_pci_reset failed, err %d\n",
+				       err);
+			fw_reset->ret = err;
+		}
+	}
+
+done:
+	clear_bit(MLX5_FW_RESET_FLAGS_UNLOAD_EVENT, &fw_reset->reset_flags);
+}
+
 static void mlx5_sync_reset_now_event(struct work_struct *work)
 {
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
@@ -613,17 +672,13 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	mlx5_enter_error_state(dev, true);
 done:
 	fw_reset->ret = err;
-	mlx5_fw_reset_complete_reload(dev, false);
+	mlx5_fw_reset_complete_reload(dev);
 }
 
 static void mlx5_sync_reset_unload_event(struct work_struct *work)
 {
 	struct mlx5_fw_reset *fw_reset;
 	struct mlx5_core_dev *dev;
-	unsigned long timeout;
-	int poll_freq = 20;
-	bool reset_action;
-	u8 rst_state;
 	int err;
 
 	fw_reset = container_of(work, struct mlx5_fw_reset, reset_unload_work);
@@ -632,6 +687,7 @@ static void mlx5_sync_reset_unload_event(struct work_struct *work)
 	if (mlx5_sync_reset_clear_reset_requested(dev, false))
 		return;
 
+	set_bit(MLX5_FW_RESET_FLAGS_UNLOAD_EVENT, &fw_reset->reset_flags);
 	mlx5_core_warn(dev, "Sync Reset Unload. Function is forced down.\n");
 
 	err = mlx5_cmd_fast_teardown_hca(dev);
@@ -640,49 +696,7 @@ static void mlx5_sync_reset_unload_event(struct work_struct *work)
 	else
 		mlx5_enter_error_state(dev, true);
 
-	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags))
-		mlx5_unload_one_devl_locked(dev, false);
-	else
-		mlx5_unload_one(dev, false);
-
-	mlx5_set_fw_rst_ack(dev);
-	mlx5_core_warn(dev, "Sync Reset Unload done, device reset expected\n");
-
-	reset_action = false;
-	timeout = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, RESET_UNLOAD));
-	do {
-		rst_state = mlx5_get_fw_rst_state(dev);
-		if (rst_state == MLX5_FW_RST_STATE_TOGGLE_REQ ||
-		    rst_state == MLX5_FW_RST_STATE_IDLE) {
-			reset_action = true;
-			break;
-		}
-		if (rst_state == MLX5_FW_RST_STATE_DROP_MODE) {
-			mlx5_core_info(dev, "Sync Reset Drop mode ack\n");
-			mlx5_set_fw_rst_ack(dev);
-			poll_freq = 1000;
-		}
-		msleep(poll_freq);
-	} while (!time_after(jiffies, timeout));
-
-	if (!reset_action) {
-		mlx5_core_err(dev, "Got timeout waiting for sync reset action, state = %u\n",
-			      rst_state);
-		fw_reset->ret = -ETIMEDOUT;
-		goto done;
-	}
-
-	mlx5_core_warn(dev, "Sync Reset, got reset action. rst_state = %u\n", rst_state);
-	if (rst_state == MLX5_FW_RST_STATE_TOGGLE_REQ) {
-		err = mlx5_sync_pci_reset(dev, fw_reset->reset_method);
-		if (err) {
-			mlx5_core_warn(dev, "mlx5_sync_pci_reset failed, err %d\n", err);
-			fw_reset->ret = err;
-		}
-	}
-
-done:
-	mlx5_fw_reset_complete_reload(dev, true);
+	mlx5_fw_reset_complete_reload(dev);
 }
 
 static void mlx5_sync_reset_abort_event(struct work_struct *work)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index ea527d06a85f0..d5b28525c960d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -12,6 +12,7 @@ int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel,
 int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev);
 
 int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev);
+void mlx5_sync_reset_unload_flow(struct mlx5_core_dev *dev, bool locked);
 int mlx5_fw_reset_verify_fw_complete(struct mlx5_core_dev *dev,
 				     struct netlink_ext_ack *extack);
 void mlx5_fw_reset_events_start(struct mlx5_core_dev *dev);
-- 
2.50.1



