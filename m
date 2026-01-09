Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AE71946C8;
	Fri,  9 Jan 2026 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960243; cv=none; b=Qc1lSjf+PPXSq1N1xfVovzxfjWWwGnBdKnm1QhTHKdmWSyvm8DILieQzsX52acpAFWtpvlKQprploeM11dSw5pFCPIjj2tJk5Z2eoqxY6G/UE9bMGuoVwBu/d7FGyoF627YJUgjoAofi8Ld2iWjOXtsFKS7axj4TR84QxyhjL0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960243; c=relaxed/simple;
	bh=KnQvd01aMbCzvIdbX/T9Tafr8BpYCuE5jSbhRGEGzL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgKc1fKQfTcVhsW/oFu6CtW2WpYBIIQnJaYunl7WSQsiSMjDmNezRyQyvfkmyK3mOxzRY6mePawJjyXBqP0GkNlSiPGiVJddnnj9sMK7e6IVbVgX+37CgpshUWSvtoWp5yXFm0ZFU6ozZ20m2vM6pkEUFcQRO5qTfW+apgzalso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=simhj67b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="simhj67b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EBDC4CEF1;
	Fri,  9 Jan 2026 12:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960243;
	bh=KnQvd01aMbCzvIdbX/T9Tafr8BpYCuE5jSbhRGEGzL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=simhj67bqKxIzyoo7GGIisSngv7XuRCFBkJKOdsm4ccT2Vhc1r9EH6gNsUJhCoeJ5
	 mO/1h2koVmBCS8Q2dFafwo5qc3a1+YShEtaKaa8fcLch93Wj7ynhEc4SgHIAFGoqAK
	 kxuOXCALrvh0I/ODlRn9KtKBWozYEY9Kz1Ijh9Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 336/737] mlxsw: spectrum_router: Fix neighbour use-after-free
Date: Fri,  9 Jan 2026 12:37:55 +0100
Message-ID: <20260109112146.631399768@linuxfoundation.org>
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

[ Upstream commit 8b0e69763ef948fb872a7767df4be665d18f5fd4 ]

We sometimes observe use-after-free when dereferencing a neighbour [1].
The problem seems to be that the driver stores a pointer to the
neighbour, but without holding a reference on it. A reference is only
taken when the neighbour is used by a nexthop.

Fix by simplifying the reference counting scheme. Always take a
reference when storing a neighbour pointer in a neighbour entry. Avoid
taking a referencing when the neighbour is used by a nexthop as the
neighbour entry associated with the nexthop already holds a reference.

Tested by running the test that uncovered the problem over 300 times.
Without this patch the problem was reproduced after a handful of
iterations.

[1]
BUG: KASAN: slab-use-after-free in mlxsw_sp_neigh_entry_update+0x2d4/0x310
Read of size 8 at addr ffff88817f8e3420 by task ip/3929

CPU: 3 UID: 0 PID: 3929 Comm: ip Not tainted 6.18.0-rc4-virtme-g36b21a067510 #3 PREEMPT(full)
Hardware name: Nvidia SN5600/VMOD0013, BIOS 5.13 05/31/2023
Call Trace:
 <TASK>
 dump_stack_lvl+0x6f/0xa0
 print_address_description.constprop.0+0x6e/0x300
 print_report+0xfc/0x1fb
 kasan_report+0xe4/0x110
 mlxsw_sp_neigh_entry_update+0x2d4/0x310
 mlxsw_sp_router_rif_gone_sync+0x35f/0x510
 mlxsw_sp_rif_destroy+0x1ea/0x730
 mlxsw_sp_inetaddr_port_vlan_event+0xa1/0x1b0
 __mlxsw_sp_inetaddr_lag_event+0xcc/0x130
 __mlxsw_sp_inetaddr_event+0xf5/0x3c0
 mlxsw_sp_router_netdevice_event+0x1015/0x1580
 notifier_call_chain+0xcc/0x150
 call_netdevice_notifiers_info+0x7e/0x100
 __netdev_upper_dev_unlink+0x10b/0x210
 netdev_upper_dev_unlink+0x79/0xa0
 vrf_del_slave+0x18/0x50
 do_set_master+0x146/0x7d0
 do_setlink.isra.0+0x9a0/0x2880
 rtnl_newlink+0x637/0xb20
 rtnetlink_rcv_msg+0x6fe/0xb90
 netlink_rcv_skb+0x123/0x380
 netlink_unicast+0x4a3/0x770
 netlink_sendmsg+0x75b/0xc90
 __sock_sendmsg+0xbe/0x160
 ____sys_sendmsg+0x5b2/0x7d0
 ___sys_sendmsg+0xfd/0x180
 __sys_sendmsg+0x124/0x1c0
 do_syscall_64+0xbb/0xfd0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
[...]

Allocated by task 109:
 kasan_save_stack+0x30/0x50
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x7b/0x90
 __kmalloc_noprof+0x2c1/0x790
 neigh_alloc+0x6af/0x8f0
 ___neigh_create+0x63/0xe90
 mlxsw_sp_nexthop_neigh_init+0x430/0x7e0
 mlxsw_sp_nexthop_type_init+0x212/0x960
 mlxsw_sp_nexthop6_group_info_init.constprop.0+0x81f/0x1280
 mlxsw_sp_nexthop6_group_get+0x392/0x6a0
 mlxsw_sp_fib6_entry_create+0x46a/0xfd0
 mlxsw_sp_router_fib6_replace+0x1ed/0x5f0
 mlxsw_sp_router_fib6_event_work+0x10a/0x2a0
 process_one_work+0xd57/0x1390
 worker_thread+0x4d6/0xd40
 kthread+0x355/0x5b0
 ret_from_fork+0x1d4/0x270
 ret_from_fork_asm+0x11/0x20

Freed by task 154:
 kasan_save_stack+0x30/0x50
 kasan_save_track+0x14/0x30
 __kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x43/0x70
 kmem_cache_free_bulk.part.0+0x1eb/0x5e0
 kvfree_rcu_bulk+0x1f2/0x260
 kfree_rcu_work+0x130/0x1b0
 process_one_work+0xd57/0x1390
 worker_thread+0x4d6/0xd40
 kthread+0x355/0x5b0
 ret_from_fork+0x1d4/0x270
 ret_from_fork_asm+0x11/0x20

Last potentially related work creation:
 kasan_save_stack+0x30/0x50
 kasan_record_aux_stack+0x8c/0xa0
 kvfree_call_rcu+0x93/0x5b0
 mlxsw_sp_router_neigh_event_work+0x67d/0x860
 process_one_work+0xd57/0x1390
 worker_thread+0x4d6/0xd40
 kthread+0x355/0x5b0
 ret_from_fork+0x1d4/0x270
 ret_from_fork_asm+0x11/0x20

Fixes: 6cf3c971dc84 ("mlxsw: spectrum_router: Add private neigh table")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/92d75e21d95d163a41b5cea67a15cd33f547cba6.1764695650.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c   | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f5c34218ba85b..4cd79473ace54 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2264,6 +2264,7 @@ mlxsw_sp_neigh_entry_alloc(struct mlxsw_sp *mlxsw_sp, struct neighbour *n,
 	if (!neigh_entry)
 		return NULL;
 
+	neigh_hold(n);
 	neigh_entry->key.n = n;
 	neigh_entry->rif = rif;
 	INIT_LIST_HEAD(&neigh_entry->nexthop_list);
@@ -2273,6 +2274,7 @@ mlxsw_sp_neigh_entry_alloc(struct mlxsw_sp *mlxsw_sp, struct neighbour *n,
 
 static void mlxsw_sp_neigh_entry_free(struct mlxsw_sp_neigh_entry *neigh_entry)
 {
+	neigh_release(neigh_entry->key.n);
 	kfree(neigh_entry);
 }
 
@@ -4203,6 +4205,8 @@ mlxsw_sp_nexthop_dead_neigh_replace(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_neigh_entry_insert;
 
+	neigh_release(old_n);
+
 	read_lock_bh(&n->lock);
 	nud_state = n->nud_state;
 	dead = n->dead;
@@ -4211,14 +4215,10 @@ mlxsw_sp_nexthop_dead_neigh_replace(struct mlxsw_sp *mlxsw_sp,
 
 	list_for_each_entry(nh, &neigh_entry->nexthop_list,
 			    neigh_list_node) {
-		neigh_release(old_n);
-		neigh_clone(n);
 		__mlxsw_sp_nexthop_neigh_update(nh, !entry_connected);
 		mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh->nhgi->nh_grp);
 	}
 
-	neigh_release(n);
-
 	return 0;
 
 err_neigh_entry_insert:
@@ -4311,6 +4311,11 @@ static int mlxsw_sp_nexthop_neigh_init(struct mlxsw_sp *mlxsw_sp,
 		}
 	}
 
+	/* Release the reference taken by neigh_lookup() / neigh_create() since
+	 * neigh_entry already holds one.
+	 */
+	neigh_release(n);
+
 	/* If that is the first nexthop connected to that neigh, add to
 	 * nexthop_neighs_list
 	 */
@@ -4337,11 +4342,9 @@ static void mlxsw_sp_nexthop_neigh_fini(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_nexthop *nh)
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry = nh->neigh_entry;
-	struct neighbour *n;
 
 	if (!neigh_entry)
 		return;
-	n = neigh_entry->key.n;
 
 	__mlxsw_sp_nexthop_neigh_update(nh, true);
 	list_del(&nh->neigh_list_node);
@@ -4355,8 +4358,6 @@ static void mlxsw_sp_nexthop_neigh_fini(struct mlxsw_sp *mlxsw_sp,
 
 	if (!neigh_entry->connected && list_empty(&neigh_entry->nexthop_list))
 		mlxsw_sp_neigh_entry_destroy(mlxsw_sp, neigh_entry);
-
-	neigh_release(n);
 }
 
 static bool mlxsw_sp_ipip_netdev_ul_up(struct net_device *ol_dev)
-- 
2.51.0



