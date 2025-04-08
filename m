Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FA02192F2;
	Tue,  8 Apr 2025 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112312; cv=none; b=Ovx/8dMypc5m0Iv2ZNGBHQFsEEF8aP5KPkrnbJYubeUTjs2u7ZpWmV4JGv1eh4LWg43wWXft32JDy1KKJBEre7onERpdvLyt2J3PEgWMSpxNmiks5/hUvlYs4XL3zgzcqkU1x0Hhz/LtdaOTYUJcY3LhwLL7d7s4RN2qoluJKc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112312; c=relaxed/simple;
	bh=8CB4BG72J7f19BHU4f2gp8d+VdTjZEMx4Iu7uFEPSvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEkva5qHTL8hwG41Q0FyGVmODsxUs63MkYE8J5BJVE23K7Ra9g9EMa8uu+R5DNoPwdryOIOjVjYCap/6uCj1Gw78fbF/w+DIdsQfeaMKN2Npy97ecOtL5Jp0MyAPB381yHjf9/bIgdBm4GnsyhdKea3aFdsNbSpN9Xx6WphXZYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhGQq/vv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhGQq/vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C973C4CEE5;
	Tue,  8 Apr 2025 11:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112312;
	bh=8CB4BG72J7f19BHU4f2gp8d+VdTjZEMx4Iu7uFEPSvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhGQq/vvyhlC/+7vP2RswrNxs5+Rr51W45oNrROWWsQeCyF7PYwWsLDCAC6YpPB45
	 VlAQITlmYrDAvFi3ATqzqwX1zvaE9+PlOniXx8QPbjYscxgspX+aD8FYLD7CVjymtY
	 EGMeSVglTWjMjfzULXDDtb/fEiVde+66J2kL2pOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/279] net/mlx5: Bridge, fix the crash caused by LAG state check
Date: Tue,  8 Apr 2025 12:46:45 +0200
Message-ID: <20250408104826.982467007@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 4b8eeed4fb105770ce6dc84a2c6ef953c7b71cbb ]

When removing LAG device from bridge, NETDEV_CHANGEUPPER event is
triggered. Driver finds the lower devices (PFs) to flush all the
offloaded entries. And mlx5_lag_is_shared_fdb is checked, it returns
false if one of PF is unloaded. In such case,
mlx5_esw_bridge_lag_rep_get() and its caller return NULL, instead of
the alive PF, and the flush is skipped.

Besides, the bridge fdb entry's lastuse is updated in mlx5 bridge
event handler. But this SWITCHDEV_FDB_ADD_TO_BRIDGE event can be
ignored in this case because the upper interface for bond is deleted,
and the entry will never be aged because lastuse is never updated.

To make things worse, as the entry is alive, mlx5 bridge workqueue
keeps sending that event, which is then handled by kernel bridge
notifier. It causes the following crash when accessing the passed bond
netdev which is already destroyed.

To fix this issue, remove such checks. LAG state is already checked in
commit 15f8f168952f ("net/mlx5: Bridge, verify LAG state when adding
bond to bridge"), driver still need to skip offload if LAG becomes
invalid state after initialization.

 Oops: stack segment: 0000 [#1] SMP
 CPU: 3 UID: 0 PID: 23695 Comm: kworker/u40:3 Tainted: G           OE      6.11.0_mlnx #1
 Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 Workqueue: mlx5_bridge_wq mlx5_esw_bridge_update_work [mlx5_core]
 RIP: 0010:br_switchdev_event+0x2c/0x110 [bridge]
 Code: 44 00 00 48 8b 02 48 f7 00 00 02 00 00 74 69 41 54 55 53 48 83 ec 08 48 8b a8 08 01 00 00 48 85 ed 74 4a 48 83 fe 02 48 89 d3 <4c> 8b 65 00 74 23 76 49 48 83 fe 05 74 7e 48 83 fe 06 75 2f 0f b7
 RSP: 0018:ffffc900092cfda0 EFLAGS: 00010297
 RAX: ffff888123bfe000 RBX: ffffc900092cfe08 RCX: 00000000ffffffff
 RDX: ffffc900092cfe08 RSI: 0000000000000001 RDI: ffffffffa0c585f0
 RBP: 6669746f6e690a30 R08: 0000000000000000 R09: ffff888123ae92c8
 R10: 0000000000000000 R11: fefefefefefefeff R12: ffff888123ae9c60
 R13: 0000000000000001 R14: ffffc900092cfe08 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88852c980000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f15914c8734 CR3: 0000000002830005 CR4: 0000000000770ef0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
  ? __die_body+0x1a/0x60
  ? die+0x38/0x60
  ? do_trap+0x10b/0x120
  ? do_error_trap+0x64/0xa0
  ? exc_stack_segment+0x33/0x50
  ? asm_exc_stack_segment+0x22/0x30
  ? br_switchdev_event+0x2c/0x110 [bridge]
  ? sched_balance_newidle.isra.149+0x248/0x390
  notifier_call_chain+0x4b/0xa0
  atomic_notifier_call_chain+0x16/0x20
  mlx5_esw_bridge_update+0xec/0x170 [mlx5_core]
  mlx5_esw_bridge_update_work+0x19/0x40 [mlx5_core]
  process_scheduled_works+0x81/0x390
  worker_thread+0x106/0x250
  ? bh_worker+0x110/0x110
  kthread+0xb7/0xe0
  ? kthread_park+0x80/0x80
  ret_from_fork+0x2d/0x50
  ? kthread_park+0x80/0x80
  ret_from_fork_asm+0x11/0x20
  </TASK>

Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/1741644104-97767-6-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/rep/bridge.c  | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 291bd59639044..28c3667e323f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -48,15 +48,10 @@ mlx5_esw_bridge_lag_rep_get(struct net_device *dev, struct mlx5_eswitch *esw)
 	struct list_head *iter;
 
 	netdev_for_each_lower_dev(dev, lower, iter) {
-		struct mlx5_core_dev *mdev;
-		struct mlx5e_priv *priv;
-
 		if (!mlx5e_eswitch_rep(lower))
 			continue;
 
-		priv = netdev_priv(lower);
-		mdev = priv->mdev;
-		if (mlx5_lag_is_shared_fdb(mdev) && mlx5_esw_bridge_dev_same_esw(lower, esw))
+		if (mlx5_esw_bridge_dev_same_esw(lower, esw))
 			return lower;
 	}
 
@@ -121,7 +116,7 @@ static bool mlx5_esw_bridge_is_local(struct net_device *dev, struct net_device *
 	priv = netdev_priv(rep);
 	mdev = priv->mdev;
 	if (netif_is_lag_master(dev))
-		return mlx5_lag_is_shared_fdb(mdev) && mlx5_lag_is_master(mdev);
+		return mlx5_lag_is_master(mdev);
 	return true;
 }
 
@@ -430,6 +425,9 @@ static int mlx5_esw_bridge_switchdev_event(struct notifier_block *nb,
 	if (!rep)
 		return NOTIFY_DONE;
 
+	if (netif_is_lag_master(dev) && !mlx5_lag_is_shared_fdb(esw->dev))
+		return NOTIFY_DONE;
+
 	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
 		fdb_info = container_of(info,
-- 
2.39.5



