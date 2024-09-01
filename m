Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39CE28387;
	Sun,  1 Sep 2024 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208128; cv=none; b=P02kkVwozHFjY3PYP+sZAaIElj21qW2QS+0Tnw3nl2aBbwdTedLJZg/tL8lDlpXrJbt/Vl64vLIC3Q6HqrDF1xDfN155d0vSqb9bvNzgzg/Z4M1iDwI2yQt8Pi2SdUe92IiFaZspYdauTtptNZhapeC48VQVQDZw7j9lTwliEzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208128; c=relaxed/simple;
	bh=fU/VbWwLTcQqrPKJppyHAwgnXBJYJMMk34Dof43qRfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzwdcf2bDXJS1MB8rAQ6PSV1WZ6x+6W2YaEoVF4PvV+kK8H4TbqBBShNXLLmReBKQD0dszgYLtAh/h+sXoba+H4lRvEac1impuhyW9J03Krv47DYa7Pnys0Q/ucoGPuGRVomnncrvN4Aqr6tVYSkbd9b1gNBenbBbAhsb8jmomg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gra21v/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gra21v/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C41BC4CEC3;
	Sun,  1 Sep 2024 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208127;
	bh=fU/VbWwLTcQqrPKJppyHAwgnXBJYJMMk34Dof43qRfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gra21v/NovuxBfvwO+hoZXLFGTAermmvsbsmw4MCs93ApekwtOpxn3iBNA90+I/27
	 bZCJJO10Py4UqGmqSnRrJ8DHU+gWX0AMRDWrGLYLG5FoY+fuwujurn4mO5CFlJtr0E
	 8mlqO6Rlt5BagnR+8O8SNgxcWv+CuXXMTaKvpkRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 64/93] bonding: change ipsec_lock from spin lock to mutex
Date: Sun,  1 Sep 2024 18:16:51 +0200
Message-ID: <20240901160809.772955465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 2aeeef906d5a526dc60cf4af92eda69836c39b1f ]

In the cited commit, bond->ipsec_lock is added to protect ipsec_list,
hence xdo_dev_state_add and xdo_dev_state_delete are called inside
this lock. As ipsec_lock is a spin lock and such xfrmdev ops may sleep,
"scheduling while atomic" will be triggered when changing bond's
active slave.

[  101.055189] BUG: scheduling while atomic: bash/902/0x00000200
[  101.055726] Modules linked in:
[  101.058211] CPU: 3 PID: 902 Comm: bash Not tainted 6.9.0-rc4+ #1
[  101.058760] Hardware name:
[  101.059434] Call Trace:
[  101.059436]  <TASK>
[  101.060873]  dump_stack_lvl+0x51/0x60
[  101.061275]  __schedule_bug+0x4e/0x60
[  101.061682]  __schedule+0x612/0x7c0
[  101.062078]  ? __mod_timer+0x25c/0x370
[  101.062486]  schedule+0x25/0xd0
[  101.062845]  schedule_timeout+0x77/0xf0
[  101.063265]  ? asm_common_interrupt+0x22/0x40
[  101.063724]  ? __bpf_trace_itimer_state+0x10/0x10
[  101.064215]  __wait_for_common+0x87/0x190
[  101.064648]  ? usleep_range_state+0x90/0x90
[  101.065091]  cmd_exec+0x437/0xb20 [mlx5_core]
[  101.065569]  mlx5_cmd_do+0x1e/0x40 [mlx5_core]
[  101.066051]  mlx5_cmd_exec+0x18/0x30 [mlx5_core]
[  101.066552]  mlx5_crypto_create_dek_key+0xea/0x120 [mlx5_core]
[  101.067163]  ? bonding_sysfs_store_option+0x4d/0x80 [bonding]
[  101.067738]  ? kmalloc_trace+0x4d/0x350
[  101.068156]  mlx5_ipsec_create_sa_ctx+0x33/0x100 [mlx5_core]
[  101.068747]  mlx5e_xfrm_add_state+0x47b/0xaa0 [mlx5_core]
[  101.069312]  bond_change_active_slave+0x392/0x900 [bonding]
[  101.069868]  bond_option_active_slave_set+0x1c2/0x240 [bonding]
[  101.070454]  __bond_opt_set+0xa6/0x430 [bonding]
[  101.070935]  __bond_opt_set_notify+0x2f/0x90 [bonding]
[  101.071453]  bond_opt_tryset_rtnl+0x72/0xb0 [bonding]
[  101.071965]  bonding_sysfs_store_option+0x4d/0x80 [bonding]
[  101.072567]  kernfs_fop_write_iter+0x10c/0x1a0
[  101.073033]  vfs_write+0x2d8/0x400
[  101.073416]  ? alloc_fd+0x48/0x180
[  101.073798]  ksys_write+0x5f/0xe0
[  101.074175]  do_syscall_64+0x52/0x110
[  101.074576]  entry_SYSCALL_64_after_hwframe+0x4b/0x53

As bond_ipsec_add_sa_all and bond_ipsec_del_sa_all are only called
from bond_change_active_slave, which requires holding the RTNL lock.
And bond_ipsec_add_sa and bond_ipsec_del_sa are xfrm state
xdo_dev_state_add and xdo_dev_state_delete APIs, which are in user
context. So ipsec_lock doesn't have to be spin lock, change it to
mutex, and thus the above issue can be resolved.

Fixes: 9a5605505d9c ("bonding: Add struct bond_ipesc to manage SA")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20240823031056.110999-4-jianbol@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 79 ++++++++++++++++++---------------
 include/net/bonding.h           |  2 +-
 2 files changed, 44 insertions(+), 37 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6f61bb2f4b901..53a7b53618d94 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -428,6 +428,7 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs,
 {
 	struct net_device *bond_dev = xs->xso.dev;
 	struct net_device *real_dev;
+	netdevice_tracker tracker;
 	struct bond_ipsec *ipsec;
 	struct bonding *bond;
 	struct slave *slave;
@@ -439,24 +440,26 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs,
 	rcu_read_lock();
 	bond = netdev_priv(bond_dev);
 	slave = rcu_dereference(bond->curr_active_slave);
-	if (!slave) {
-		rcu_read_unlock();
-		return -ENODEV;
+	real_dev = slave ? slave->dev : NULL;
+	netdev_hold(real_dev, &tracker, GFP_ATOMIC);
+	rcu_read_unlock();
+	if (!real_dev) {
+		err = -ENODEV;
+		goto out;
 	}
 
-	real_dev = slave->dev;
 	if (!real_dev->xfrmdev_ops ||
 	    !real_dev->xfrmdev_ops->xdo_dev_state_add ||
 	    netif_is_bond_master(real_dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Slave does not support ipsec offload");
-		rcu_read_unlock();
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
-	ipsec = kmalloc(sizeof(*ipsec), GFP_ATOMIC);
+	ipsec = kmalloc(sizeof(*ipsec), GFP_KERNEL);
 	if (!ipsec) {
-		rcu_read_unlock();
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto out;
 	}
 
 	xs->xso.real_dev = real_dev;
@@ -464,13 +467,14 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs,
 	if (!err) {
 		ipsec->xs = xs;
 		INIT_LIST_HEAD(&ipsec->list);
-		spin_lock_bh(&bond->ipsec_lock);
+		mutex_lock(&bond->ipsec_lock);
 		list_add(&ipsec->list, &bond->ipsec_list);
-		spin_unlock_bh(&bond->ipsec_lock);
+		mutex_unlock(&bond->ipsec_lock);
 	} else {
 		kfree(ipsec);
 	}
-	rcu_read_unlock();
+out:
+	netdev_put(real_dev, &tracker);
 	return err;
 }
 
@@ -481,35 +485,35 @@ static void bond_ipsec_add_sa_all(struct bonding *bond)
 	struct bond_ipsec *ipsec;
 	struct slave *slave;
 
-	rcu_read_lock();
-	slave = rcu_dereference(bond->curr_active_slave);
-	if (!slave)
-		goto out;
+	slave = rtnl_dereference(bond->curr_active_slave);
+	real_dev = slave ? slave->dev : NULL;
+	if (!real_dev)
+		return;
 
-	real_dev = slave->dev;
+	mutex_lock(&bond->ipsec_lock);
 	if (!real_dev->xfrmdev_ops ||
 	    !real_dev->xfrmdev_ops->xdo_dev_state_add ||
 	    netif_is_bond_master(real_dev)) {
-		spin_lock_bh(&bond->ipsec_lock);
 		if (!list_empty(&bond->ipsec_list))
 			slave_warn(bond_dev, real_dev,
 				   "%s: no slave xdo_dev_state_add\n",
 				   __func__);
-		spin_unlock_bh(&bond->ipsec_lock);
 		goto out;
 	}
 
-	spin_lock_bh(&bond->ipsec_lock);
 	list_for_each_entry(ipsec, &bond->ipsec_list, list) {
+		/* If new state is added before ipsec_lock acquired */
+		if (ipsec->xs->xso.real_dev == real_dev)
+			continue;
+
 		ipsec->xs->xso.real_dev = real_dev;
 		if (real_dev->xfrmdev_ops->xdo_dev_state_add(ipsec->xs, NULL)) {
 			slave_warn(bond_dev, real_dev, "%s: failed to add SA\n", __func__);
 			ipsec->xs->xso.real_dev = NULL;
 		}
 	}
-	spin_unlock_bh(&bond->ipsec_lock);
 out:
-	rcu_read_unlock();
+	mutex_unlock(&bond->ipsec_lock);
 }
 
 /**
@@ -520,6 +524,7 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 {
 	struct net_device *bond_dev = xs->xso.dev;
 	struct net_device *real_dev;
+	netdevice_tracker tracker;
 	struct bond_ipsec *ipsec;
 	struct bonding *bond;
 	struct slave *slave;
@@ -530,6 +535,9 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 	rcu_read_lock();
 	bond = netdev_priv(bond_dev);
 	slave = rcu_dereference(bond->curr_active_slave);
+	real_dev = slave ? slave->dev : NULL;
+	netdev_hold(real_dev, &tracker, GFP_ATOMIC);
+	rcu_read_unlock();
 
 	if (!slave)
 		goto out;
@@ -537,7 +545,6 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 	if (!xs->xso.real_dev)
 		goto out;
 
-	real_dev = slave->dev;
 	WARN_ON(xs->xso.real_dev != real_dev);
 
 	if (!real_dev->xfrmdev_ops ||
@@ -549,7 +556,8 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 
 	real_dev->xfrmdev_ops->xdo_dev_state_delete(xs);
 out:
-	spin_lock_bh(&bond->ipsec_lock);
+	netdev_put(real_dev, &tracker);
+	mutex_lock(&bond->ipsec_lock);
 	list_for_each_entry(ipsec, &bond->ipsec_list, list) {
 		if (ipsec->xs == xs) {
 			list_del(&ipsec->list);
@@ -557,8 +565,7 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 			break;
 		}
 	}
-	spin_unlock_bh(&bond->ipsec_lock);
-	rcu_read_unlock();
+	mutex_unlock(&bond->ipsec_lock);
 }
 
 static void bond_ipsec_del_sa_all(struct bonding *bond)
@@ -568,15 +575,12 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 	struct bond_ipsec *ipsec;
 	struct slave *slave;
 
-	rcu_read_lock();
-	slave = rcu_dereference(bond->curr_active_slave);
-	if (!slave) {
-		rcu_read_unlock();
+	slave = rtnl_dereference(bond->curr_active_slave);
+	real_dev = slave ? slave->dev : NULL;
+	if (!real_dev)
 		return;
-	}
 
-	real_dev = slave->dev;
-	spin_lock_bh(&bond->ipsec_lock);
+	mutex_lock(&bond->ipsec_lock);
 	list_for_each_entry(ipsec, &bond->ipsec_list, list) {
 		if (!ipsec->xs->xso.real_dev)
 			continue;
@@ -593,8 +597,7 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 				real_dev->xfrmdev_ops->xdo_dev_state_free(ipsec->xs);
 		}
 	}
-	spin_unlock_bh(&bond->ipsec_lock);
-	rcu_read_unlock();
+	mutex_unlock(&bond->ipsec_lock);
 }
 
 static void bond_ipsec_free_sa(struct xfrm_state *xs)
@@ -5941,7 +5944,7 @@ void bond_setup(struct net_device *bond_dev)
 	/* set up xfrm device ops (only supported in active-backup right now) */
 	bond_dev->xfrmdev_ops = &bond_xfrmdev_ops;
 	INIT_LIST_HEAD(&bond->ipsec_list);
-	spin_lock_init(&bond->ipsec_lock);
+	mutex_init(&bond->ipsec_lock);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't acquire bond device's netif_tx_lock when transmitting */
@@ -5990,6 +5993,10 @@ static void bond_uninit(struct net_device *bond_dev)
 		__bond_release_one(bond_dev, slave->dev, true, true);
 	netdev_info(bond_dev, "Released all slaves\n");
 
+#ifdef CONFIG_XFRM_OFFLOAD
+	mutex_destroy(&bond->ipsec_lock);
+#endif /* CONFIG_XFRM_OFFLOAD */
+
 	bond_set_slave_arr(bond, NULL, NULL);
 
 	list_del(&bond->bond_list);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 5b8b1b644a2db..94594026a5c55 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -258,7 +258,7 @@ struct bonding {
 #ifdef CONFIG_XFRM_OFFLOAD
 	struct list_head ipsec_list;
 	/* protecting ipsec_list */
-	spinlock_t ipsec_lock;
+	struct mutex ipsec_lock;
 #endif /* CONFIG_XFRM_OFFLOAD */
 	struct bpf_prog *xdp_prog;
 };
-- 
2.43.0



