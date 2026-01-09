Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B851946C8;
	Fri,  9 Jan 2026 12:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960377; cv=none; b=l1DJFLVFHWALSHRMbMlcvSRZHlSWYr+EtLTGY+dI9z1+udXW8Lq6A6VHMmGSzljJM9GOtSWKBIsRt7wfFil0XRnKCO8ZVoZsNQ94+9IhvIGvqqpNkbmJYW4WZothNAK6ocRnkVGuA+TKvp4NMyebr6LcOhc+MBwkHacVefGPybM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960377; c=relaxed/simple;
	bh=vfLLIn2NX6pPghGY8Sq7/nvXsHpxohd439WyFHSFe34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWIT5zT5Sdh+qmR0lRbsVhyxa5F4plrJiep4KTiINrjWCGawOjTbpg60cy8sFbGM7K6OLqFexE5X/ffZ43eJFnkHQe7xSVz98KG/oiaKaDWGScijF7Rgu1695JyDH7PF9SUakhOmqa0s68XgznYCzNWgpUMSzKiayPhOB/c4jGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrekFRXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrekFRXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128A4C4CEF1;
	Fri,  9 Jan 2026 12:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960377;
	bh=vfLLIn2NX6pPghGY8Sq7/nvXsHpxohd439WyFHSFe34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrekFRXlQpcHoE7DFJHE+OW0dgC8LY/lmhuJ5r7X41/DV0pQ69MaYBdvBSAsRJVYo
	 lPl9ZB2QyLzwfGisxFLRrWSgr2oP4Xk7Vg1l0LoqqdMrRp/S9mU33PrD1cm4jkgXAY
	 NCh02AdH08dRxP8PSBDcE33iI5oEtbJAiwKgOBGY=
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
Subject: [PATCH 6.6 355/737] net/mlx5: Serialize firmware reset with devlink
Date: Fri,  9 Jan 2026 12:38:14 +0100
Message-ID: <20260109112147.349627539@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index 8489b5087d9c6..b2532b1c9565a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -144,6 +144,11 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	bool sf_dev_allocated;
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
index 86fb8197594f5..c218593dc40f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -51,6 +51,7 @@
 #include "devlink.h"
 #include "lag/lag.h"
 #include "en/tc/post_meter.h"
+#include "fw_reset.h"
 
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
@@ -3716,6 +3717,11 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
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
index bdcd9e5306331..f7e139279f5f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -15,6 +15,7 @@ enum {
 	MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS,
 	MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED,
 	MLX5_FW_RESET_FLAGS_UNLOAD_EVENT,
+	MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS,
 };
 
 struct mlx5_fw_reset {
@@ -125,6 +126,16 @@ int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
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
@@ -240,6 +251,8 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
 		devl_unlock(devlink);
 	}
+
+	clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
 }
 
 static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
@@ -431,27 +444,48 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
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
@@ -685,6 +719,8 @@ static void mlx5_sync_reset_abort_event(struct work_struct *work)
 
 	if (mlx5_sync_reset_clear_reset_requested(dev, true))
 		return;
+
+	clear_bit(MLX5_FW_RESET_FLAGS_RESET_IN_PROGRESS, &fw_reset->reset_flags);
 	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
 }
 
@@ -721,6 +757,7 @@ static void mlx5_sync_reset_timeout_work(struct work_struct *work)
 
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



