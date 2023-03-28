Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8108BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64EEC433D2;
	Tue, 28 Mar 2023 14:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014845;
	bh=6arAqQBVgNRQ72DAh1xeuXXHDJd1L84Ez0MDiUU3YDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ct5l0G+xdYgro7skNT095ZPsNSRJuhMBfCpS6tNvNHJ+kUf9hRogrgCc04WvWzRuu
	 O9Z9zfGxiWMe/eRvR4reqoeUHNett598rZYU5ZeUQxdBG83DSn9ORt7J/9xevx9u4E
	 RXOncH2BeYgED3oayX6WMAqE8PxOzGKATtAINoBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huy Nguyen <huyn@mellanox.com>,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Maor Dickman <maord@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 074/240] net/mlx5: Fix steering rules cleanup
Date: Tue, 28 Mar 2023 16:40:37 +0200
Message-Id: <20230328142622.849097624@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit 922f56e9a795d6f3dd72d3428ebdd7ee040fa855 ]

vport's mc, uc and multicast rules are not deleted in teardown path when
EEH happens. Since the vport's promisc settings(uc, mc and all) in
firmware are reset after EEH, mlx5 driver will try to delete the above
rules in the initialization path. This cause kernel crash because these
software rules are no longer valid.

Fix by nullifying these rules right after delete to avoid accessing any dangling
pointers.

Call Trace:
__list_del_entry_valid+0xcc/0x100 (unreliable)
tree_put_node+0xf4/0x1b0 [mlx5_core]
tree_remove_node+0x30/0x70 [mlx5_core]
mlx5_del_flow_rules+0x14c/0x1f0 [mlx5_core]
esw_apply_vport_rx_mode+0x10c/0x200 [mlx5_core]
esw_update_vport_rx_mode+0xb4/0x180 [mlx5_core]
esw_vport_change_handle_locked+0x1ec/0x230 [mlx5_core]
esw_enable_vport+0x130/0x260 [mlx5_core]
mlx5_eswitch_enable_sriov+0x2a0/0x2f0 [mlx5_core]
mlx5_device_enable_sriov+0x74/0x440 [mlx5_core]
mlx5_load_one+0x114c/0x1550 [mlx5_core]
mlx5_pci_resume+0x68/0xf0 [mlx5_core]
eeh_report_resume+0x1a4/0x230
eeh_pe_dev_traverse+0x98/0x170
eeh_handle_normal_event+0x3e4/0x640
eeh_handle_event+0x4c/0x370
eeh_event_handler+0x14c/0x210
kthread+0x168/0x1b0
ret_from_kernel_thread+0x5c/0x84

Fixes: a35f71f27a61 ("net/mlx5: E-Switch, Implement promiscuous rx modes vf request handling")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9daf55e90367b..c8b978014f2c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -959,6 +959,7 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
-- 
2.39.2



