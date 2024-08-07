Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3537E76F;
	Wed,  7 Aug 2024 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043756; cv=none; b=RjRUIg0JhhDIFx5Vbs1hS0aBSfx2FuDCkjzZGjuxnhKGIocLnMHzN+zrvhQ9dX14qcFD3/059ZCl2qcnsdz/ee1bmULd07nIw5vmSE71+YIy0OOF3OkpiYjlTUvjgRMEJ9VbgTyUhVvFP5xXUCQpkXjmMgjprydPU0r2Wg0FHaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043756; c=relaxed/simple;
	bh=BDVJXMJQU5vxbv0ejLS1IJkRutVe6byOCoyC48RcUYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EhCk6FF+awW7R+v/m9bAEdIV5eOzYyNF63NbgnagNcnw6QFsZVpdZLzQP2lvSxuiRW4hRO27MgztCkjmBVrVOknP+NPkBi4e1q5Wqp56kCQiW6evSCax9Vt9Yw3yfXvyswXCdAkbeD73YsLL2qBVGyZ/SQCUghY3GSHLXPgp36k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3tmrDLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3tmrDLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF16C4AF0D;
	Wed,  7 Aug 2024 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043756;
	bh=BDVJXMJQU5vxbv0ejLS1IJkRutVe6byOCoyC48RcUYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3tmrDLkk3uQdWAIcje9TUi2dG1vJ1TJuKv+WAmFPYoQFHe8FpLOQs/eiAD1CqtMe
	 dukK6XDBnjBpsPAG4er1MGYSoMGUb4uZRw8vcuGcPeg8eLbYT8R1ctDdiOHg79laIr
	 gAHVhVyUu6Jjh2a9As9TAhyT9pVrBgCr94Ku29dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/86] net/mlx5: Fix missing lock on sync reset reload
Date: Wed,  7 Aug 2024 17:00:40 +0200
Message-ID: <20240807150041.261979575@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 572f9caa9e7295f8c8822e4122c7ae8f1c412ff9 ]

On sync reset reload work, when remote host updates devlink on reload
actions performed on that host, it misses taking devlink lock before
calling devlink_remote_reload_actions_performed() which results in
triggering lock assert like the following:

WARNING: CPU: 4 PID: 1164 at net/devlink/core.c:261 devl_assert_locked+0x3e/0x50
…
 CPU: 4 PID: 1164 Comm: kworker/u96:6 Tainted: G S      W          6.10.0-rc2+ #116
 Hardware name: Supermicro SYS-2028TP-DECTR/X10DRT-PT, BIOS 2.0 12/18/2015
 Workqueue: mlx5_fw_reset_events mlx5_sync_reset_reload_work [mlx5_core]
 RIP: 0010:devl_assert_locked+0x3e/0x50
…
 Call Trace:
  <TASK>
  ? __warn+0xa4/0x210
  ? devl_assert_locked+0x3e/0x50
  ? report_bug+0x160/0x280
  ? handle_bug+0x3f/0x80
  ? exc_invalid_op+0x17/0x40
  ? asm_exc_invalid_op+0x1a/0x20
  ? devl_assert_locked+0x3e/0x50
  devlink_notify+0x88/0x2b0
  ? mlx5_attach_device+0x20c/0x230 [mlx5_core]
  ? __pfx_devlink_notify+0x10/0x10
  ? process_one_work+0x4b6/0xbb0
  process_one_work+0x4b6/0xbb0
[…]

Fixes: 84a433a40d0e ("net/mlx5: Lock mlx5 devlink reload callbacks")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index dec1492da74de..1a818759a9aac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -145,6 +145,7 @@ int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev)
 static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	struct devlink *devlink = priv_to_devlink(dev);
 
 	/* if this is the driver that initiated the fw reset, devlink completed the reload */
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
@@ -155,9 +156,11 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
 			mlx5_load_one(dev, true);
-		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
+		devl_lock(devlink);
+		devlink_remote_reload_actions_performed(devlink, 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
+		devl_unlock(devlink);
 	}
 }
 
-- 
2.43.0



