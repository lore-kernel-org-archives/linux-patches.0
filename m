Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D069A35A92E;
	Fri,  9 Jan 2026 12:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960248; cv=none; b=ZHBO5cpQ5H/znOa8ip8JY3dXD/4m6Y3+tc3Uah/L6uwQRbtJoqkpF2bnCEbjEE5ntLfui6LzN9CxwmvVf7JRi5Wo0bEzMPDwsPyP0xMihbZJ6obKftO4kns4Frk4sUOkidDBbClaeRC5FB6Zk7DUC+NB3wFSG6Ir6DYgyz8Gqqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960248; c=relaxed/simple;
	bh=utSeAN/aTbKCkiDh1Pk8dhYnfYhVlsFcJdEMTnQ6IhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuFc4DQeYn57NfKypx0tJbyg2eAOAt3nkoRBS0TyEPLfTXor319rFG6X1bV7jh+L5BHfFnQkoLVW1NdV+/nLGZN7UN6txKWN+NTkzTA2XbrvPBd1Os+u9okgLJ5tcpXkpQtUTX/iLqh9vZbaN9HtCGF+ZiuLKDCcMiGWMCOEj4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMMyj+3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMMyj+3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A220C4CEF1;
	Fri,  9 Jan 2026 12:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960248;
	bh=utSeAN/aTbKCkiDh1Pk8dhYnfYhVlsFcJdEMTnQ6IhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMMyj+3pBTfgcw9aiNpqUq+779AwnDhFTIoa8C6cI1uIdbCkcFbo1L7kpqZkWYpIO
	 xakiUMQbrqnfChkFAN/UV7VWUBp1CQrAO8TQe9373954YBIfCPgs/VrTAcWE4SGyk4
	 I6tgsi3cYau4BWrK+dDkj0G/dsuKodkQDZxEOx9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 337/737] mlxsw: spectrum_mr: Fix use-after-free when updating multicast route stats
Date: Fri,  9 Jan 2026 12:37:56 +0100
Message-ID: <20260109112146.668026672@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8ac1dacec458f55f871f7153242ed6ab60373b90 ]

Cited commit added a dedicated mutex (instead of RTNL) to protect the
multicast route list, so that it will not change while the driver
periodically traverses it in order to update the kernel about multicast
route stats that were queried from the device.

One instance of list entry deletion (during route replace) was missed
and it can result in a use-after-free [1].

Fix by acquiring the mutex before deleting the entry from the list and
releasing it afterwards.

[1]
BUG: KASAN: slab-use-after-free in mlxsw_sp_mr_stats_update+0x4a5/0x540 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c:1006 [mlxsw_spectrum]
Read of size 8 at addr ffff8881523c2fa8 by task kworker/2:5/22043

CPU: 2 UID: 0 PID: 22043 Comm: kworker/2:5 Not tainted 6.18.0-rc1-custom-g1a3d6d7cd014 #1 PREEMPT(full)
Hardware name: Mellanox Technologies Ltd. MSN2010/SA002610, BIOS 5.6.5 08/24/2017
Workqueue: mlxsw_core mlxsw_sp_mr_stats_update [mlxsw_spectrum]
Call Trace:
 <TASK>
 dump_stack_lvl+0xba/0x110
 print_report+0x174/0x4f5
 kasan_report+0xdf/0x110
 mlxsw_sp_mr_stats_update+0x4a5/0x540 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c:1006 [mlxsw_spectrum]
 process_one_work+0x9cc/0x18e0
 worker_thread+0x5df/0xe40
 kthread+0x3b8/0x730
 ret_from_fork+0x3e9/0x560
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 29933:
 kasan_save_stack+0x30/0x50
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x8f/0xa0
 mlxsw_sp_mr_route_add+0xd8/0x4770 [mlxsw_spectrum]
 mlxsw_sp_router_fibmr_event_work+0x371/0xad0 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:7965 [mlxsw_spectrum]
 process_one_work+0x9cc/0x18e0
 worker_thread+0x5df/0xe40
 kthread+0x3b8/0x730
 ret_from_fork+0x3e9/0x560
 ret_from_fork_asm+0x1a/0x30

Freed by task 29933:
 kasan_save_stack+0x30/0x50
 kasan_save_track+0x14/0x30
 __kasan_save_free_info+0x3b/0x70
 __kasan_slab_free+0x43/0x70
 kfree+0x14e/0x700
 mlxsw_sp_mr_route_add+0x2dea/0x4770 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c:444 [mlxsw_spectrum]
 mlxsw_sp_router_fibmr_event_work+0x371/0xad0 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:7965 [mlxsw_spectrum]
 process_one_work+0x9cc/0x18e0
 worker_thread+0x5df/0xe40
 kthread+0x3b8/0x730
 ret_from_fork+0x3e9/0x560
 ret_from_fork_asm+0x1a/0x30

Fixes: f38656d06725 ("mlxsw: spectrum_mr: Protect multicast route list with a lock")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/f996feecfd59fde297964bfc85040b6d83ec6089.1764695650.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 5afe6b155ef0d..81935f87bfcd7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -440,7 +440,9 @@ int mlxsw_sp_mr_route_add(struct mlxsw_sp_mr_table *mr_table,
 		rhashtable_remove_fast(&mr_table->route_ht,
 				       &mr_orig_route->ht_node,
 				       mlxsw_sp_mr_route_ht_params);
+		mutex_lock(&mr_table->route_list_lock);
 		list_del(&mr_orig_route->node);
+		mutex_unlock(&mr_table->route_list_lock);
 		mlxsw_sp_mr_route_destroy(mr_table, mr_orig_route);
 	}
 
-- 
2.51.0



