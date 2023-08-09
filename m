Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6882715AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0639C433C8;
	Wed,  9 Aug 2023 10:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577976;
	bh=tkqxxMeQpY7DsW53OkSkNXtTPbDzpz4T+wyaMix30cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkIQQjiKmGwifn+oNu9c898xBl8a8Hyo1R3RTVH1jrYuR4gs2BZTkscSMBV22k3Kw
	 yFmM9aNOcCflmdbiCnQ2I/ZPfcbbiEyYZRSEWJlhtrh0c4z0b/7l22S1iPxZlVzzoC
	 /QhVpnHzRUM32L6u/+sUAFf/Gf2lDCMrvLyxsgpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Tzin <amirtz@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 034/165] net/mlx5e: Fix crash moving to switchdev mode when ntuple offload is set
Date: Wed,  9 Aug 2023 12:39:25 +0200
Message-ID: <20230809103643.929307509@linuxfoundation.org>
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

From: Amir Tzin <amirtz@nvidia.com>

[ Upstream commit 3ec43c1b082a8804472430e1253544d75f4b540e ]

Moving to switchdev mode with ntuple offload on causes the kernel to
crash since fs->arfs is freed during nic profile cleanup flow.

Ntuple offload is not supported in switchdev mode and it is already
unset by mlx5 fix feature ndo in switchdev mode. Verify fs->arfs is
valid before disabling it.

trace:
[] RIP: 0010:_raw_spin_lock_bh+0x17/0x30
[] arfs_del_rules+0x44/0x1a0 [mlx5_core]
[] mlx5e_arfs_disable+0xe/0x20 [mlx5_core]
[] mlx5e_handle_feature+0x3d/0xb0 [mlx5_core]
[] ? __rtnl_unlock+0x25/0x50
[] mlx5e_set_features+0xfe/0x160 [mlx5_core]
[] __netdev_update_features+0x278/0xa50
[] ? netdev_run_todo+0x5e/0x2a0
[] netdev_update_features+0x22/0x70
[] ? _cond_resched+0x15/0x30
[] mlx5e_attach_netdev+0x12a/0x1e0 [mlx5_core]
[] mlx5e_netdev_attach_profile+0xa1/0xc0 [mlx5_core]
[] mlx5e_netdev_change_profile+0x77/0xe0 [mlx5_core]
[] mlx5e_vport_rep_load+0x1ed/0x290 [mlx5_core]
[] mlx5_esw_offloads_rep_load+0x88/0xd0 [mlx5_core]
[] esw_offloads_load_rep.part.38+0x31/0x50 [mlx5_core]
[] esw_offloads_enable+0x6c5/0x710 [mlx5_core]
[] mlx5_eswitch_enable_locked+0x1bb/0x290 [mlx5_core]
[] mlx5_devlink_eswitch_mode_set+0x14f/0x320 [mlx5_core]
[] devlink_nl_cmd_eswitch_set_doit+0x94/0x120
[] genl_family_rcv_msg_doit.isra.17+0x113/0x150
[] genl_family_rcv_msg+0xb7/0x170
[] ? devlink_nl_cmd_port_split_doit+0x100/0x100
[] genl_rcv_msg+0x47/0xa0
[] ? genl_family_rcv_msg+0x170/0x170
[] netlink_rcv_skb+0x4c/0x130
[] genl_rcv+0x24/0x40
[] netlink_unicast+0x19a/0x230
[] netlink_sendmsg+0x204/0x3d0
[] sock_sendmsg+0x50/0x60

Fixes: 90b22b9bcd24 ("net/mlx5e: Disable Rx ntuple offload for uplink representor")
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index bed0c2d043e70..329d8c90facdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -135,6 +135,16 @@ static void arfs_del_rules(struct mlx5e_flow_steering *fs);
 
 int mlx5e_arfs_disable(struct mlx5e_flow_steering *fs)
 {
+	/* Moving to switchdev mode, fs->arfs is freed by mlx5e_nic_profile
+	 * cleanup_rx callback and it is not recreated when
+	 * mlx5e_uplink_rep_profile is loaded as mlx5e_create_flow_steering()
+	 * is not called by the uplink_rep profile init_rx callback. Thus, if
+	 * ntuple is set, moving to switchdev flow will enter this function
+	 * with fs->arfs nullified.
+	 */
+	if (!mlx5e_fs_get_arfs(fs))
+		return 0;
+
 	arfs_del_rules(fs);
 
 	return arfs_disable(fs);
-- 
2.40.1



