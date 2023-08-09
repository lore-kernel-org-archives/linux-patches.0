Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E83415AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356EDC433C7;
	Wed,  9 Aug 2023 10:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577998;
	bh=w4I5AQglVYeviVzOg3Rd/c3IvqIv22X4qNiJrdYbujY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urrUmfves0oEHsfsuNhnObY6RCma307VmYo/RLL4N3X15sL0amETlMOeqVYDiFmUK
	 IltzhL+dFEBk7AG+1I1/gQ8NKomMQV8LrGG+0m+rj17clFz20Y4naIW2aSRylkeFy2
	 ex3AuY9GHeWmzsjLzGCPaSesVaY1pcjvT2M42YQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 040/165] net/mlx5: Unregister devlink params in case interface is down
Date: Wed,  9 Aug 2023 12:39:31 +0200
Message-ID: <20230809103644.124193789@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 53d737dfd3d7b023fa9fa445ea3f3db0ac9da402 ]

Currently, in case an interface is down, mlx5 driver doesn't
unregister its devlink params, which leads to this WARN[1].
Fix it by unregistering devlink params in that case as well.

[1]
[  295.244769 ] WARNING: CPU: 15 PID: 1 at net/core/devlink.c:9042 devlink_free+0x174/0x1fc
[  295.488379 ] CPU: 15 PID: 1 Comm: shutdown Tainted: G S         OE 5.15.0-1017.19.3.g0677e61-bluefield #g0677e61
[  295.509330 ] Hardware name: https://www.mellanox.com BlueField SoC/BlueField SoC, BIOS 4.2.0.12761 Jun  6 2023
[  295.543096 ] pc : devlink_free+0x174/0x1fc
[  295.551104 ] lr : mlx5_devlink_free+0x18/0x2c [mlx5_core]
[  295.561816 ] sp : ffff80000809b850
[  295.711155 ] Call trace:
[  295.716030 ]  devlink_free+0x174/0x1fc
[  295.723346 ]  mlx5_devlink_free+0x18/0x2c [mlx5_core]
[  295.733351 ]  mlx5_sf_dev_remove+0x98/0xb0 [mlx5_core]
[  295.743534 ]  auxiliary_bus_remove+0x2c/0x50
[  295.751893 ]  __device_release_driver+0x19c/0x280
[  295.761120 ]  device_release_driver+0x34/0x50
[  295.769649 ]  bus_remove_device+0xdc/0x170
[  295.777656 ]  device_del+0x17c/0x3a4
[  295.784620 ]  mlx5_sf_dev_remove+0x28/0xf0 [mlx5_core]
[  295.794800 ]  mlx5_sf_dev_table_destroy+0x98/0x110 [mlx5_core]
[  295.806375 ]  mlx5_unload+0x34/0xd0 [mlx5_core]
[  295.815339 ]  mlx5_unload_one+0x70/0xe4 [mlx5_core]
[  295.824998 ]  shutdown+0xb0/0xd8 [mlx5_core]
[  295.833439 ]  pci_device_shutdown+0x3c/0xa0
[  295.841651 ]  device_shutdown+0x170/0x340
[  295.849486 ]  __do_sys_reboot+0x1f4/0x2a0
[  295.857322 ]  __arm64_sys_reboot+0x2c/0x40
[  295.865329 ]  invoke_syscall+0x78/0x100
[  295.872817 ]  el0_svc_common.constprop.0+0x54/0x184
[  295.882392 ]  do_el0_svc+0x30/0xac
[  295.889008 ]  el0_svc+0x48/0x160
[  295.895278 ]  el0t_64_sync_handler+0xa4/0x130
[  295.903807 ]  el0t_64_sync+0x1a4/0x1a8
[  295.911120 ] ---[ end trace 4f1d2381d00d9dce  ]---

Fixes: fe578cbb2f05 ("net/mlx5: Move devlink registration before mlx5_load")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d6ee016deae17..c7a06c8bbb7a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1456,6 +1456,7 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
 			       __func__);
+		mlx5_devlink_params_unregister(priv_to_devlink(dev));
 		mlx5_cleanup_once(dev);
 		goto out;
 	}
-- 
2.40.1



