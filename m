Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB792EB5CE;
	Tue, 17 Jun 2025 16:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176526; cv=none; b=OkXGzlltK2dkMHshaktRw79Pw8pWOqbqpM1d42bp2TvAOBPKfN9xfz4Qito2OByqJA1bN+pbR1Pxu+Udr7j2ALog2+PDWdYWY66Fn+LKtjN20nGRKGaQ4g96nZzjnixNDjBE4k+oO1ms7MGuMM1igZsyzm/fU3+U0J57iY70y2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176526; c=relaxed/simple;
	bh=IQ8P9EzTY0nSqtUPfky5Uk3WynUnCgTq+OdKp7uoXsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNcmeB8791bbfFhzayeRnUSam+7WB8KZbRvs1nWdYej09hDFubDigYY99mLuZ66x0m5GyUU8HqdjL186qAWtVy3d68tx0RwqTrBDjiunKvUURh9t2we/5bER4peyZVJR7jjzA2/8lPru4blN3gnFboA8XvzhefHxTXo4MmfDlw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjeqWXpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjeqWXpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D805C4CEE3;
	Tue, 17 Jun 2025 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176524;
	bh=IQ8P9EzTY0nSqtUPfky5Uk3WynUnCgTq+OdKp7uoXsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjeqWXpkSovd13MDhPBcglz6KLMU9hVyJAU1MsFUtwPczpi3OtTf3ZGVtIM5NqlhN
	 uiFVJYxlrlXFcR71VQLtIvQC5Igld9dZmVUsnlyoVRkPV7D6IWGDLVk92B9QSPOpGd
	 s4zQhSKFn03hfSMU1tYuFTxEvAZ3Gak4ExgHBoUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 198/780] bonding: Fix multiple long standing offload races
Date: Tue, 17 Jun 2025 17:18:26 +0200
Message-ID: <20250617152459.533957131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit d2fddbd3479928e52061e1c8dd302006b6283ce8 ]

Refactor the bonding ipsec offload operations to fix a number of
long-standing control plane races between state migration and user
deletion and a few other issues.

xfrm state deletion can happen concurrently with
bond_change_active_slave() operation. This manifests itself as a
bond_ipsec_del_sa() call with x->lock held, followed by a
bond_ipsec_free_sa() a bit later from a wq. The alternate path of
these calls coming from xfrm_dev_state_flush() can't happen, as that
needs the RTNL lock and bond_change_active_slave() already holds it.

1. bond_ipsec_del_sa_all() might call xdo_dev_state_delete() a second
   time on an xfrm state that was concurrently killed. This is bad.
2. bond_ipsec_add_sa_all() can add a state on the new device, but
   pending bond_ipsec_free_sa() calls from the old device will then hit
   the WARN_ON() and then, worse, call xdo_dev_state_free() on the new
   device without a corresponding xdo_dev_state_delete().
3. Resolve a sleeping in atomic context introduced by the mentioned
   "Fixes" commit.

bond_ipsec_del_sa_all() and bond_ipsec_add_sa_all() now acquire x->lock
and check for x->km.state to help with problems 1 and 2. And since
xso.real_dev is now a private pointer managed by the bonding driver in
xfrm state, make better use of it to fully fix problems 1 and 2. In
bond_ipsec_del_sa_all(), set xso.real_dev to NULL while holding both the
mutex and x->lock, which makes sure that neither bond_ipsec_del_sa() nor
bond_ipsec_free_sa() could run concurrently.

Fix problem 3 by moving the list cleanup (which requires the mutex) from
bond_ipsec_del_sa() (called from atomic context) to bond_ipsec_free_sa()

Finally, simplify bond_ipsec_del_sa() and bond_ipsec_free_sa() by using
xso->real_dev directly, since it's now protected by locks and can be
trusted to always reflect the offload device.

Fixes: 2aeeef906d5a ("bonding: change ipsec_lock from spin lock to mutex")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 82 +++++++++++++++------------------
 include/net/xfrm.h              |  7 ++-
 2 files changed, 41 insertions(+), 48 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 14ebbe82a2c5b..4461220bcd58d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -545,7 +545,20 @@ static void bond_ipsec_add_sa_all(struct bonding *bond)
 			slave_warn(bond_dev, real_dev, "%s: failed to add SA\n", __func__);
 			continue;
 		}
+
+		spin_lock_bh(&ipsec->xs->lock);
+		/* xs might have been killed by the user during the migration
+		 * to the new dev, but bond_ipsec_del_sa() should have done
+		 * nothing, as xso.real_dev is NULL.
+		 * Delete it from the device we just added it to. The pending
+		 * bond_ipsec_free_sa() call will do the rest of the cleanup.
+		 */
+		if (ipsec->xs->km.state == XFRM_STATE_DEAD &&
+		    real_dev->xfrmdev_ops->xdo_dev_state_delete)
+			real_dev->xfrmdev_ops->xdo_dev_state_delete(real_dev,
+								    ipsec->xs);
 		ipsec->xs->xso.real_dev = real_dev;
+		spin_unlock_bh(&ipsec->xs->lock);
 	}
 out:
 	mutex_unlock(&bond->ipsec_lock);
@@ -560,48 +573,20 @@ static void bond_ipsec_del_sa(struct net_device *bond_dev,
 			      struct xfrm_state *xs)
 {
 	struct net_device *real_dev;
-	netdevice_tracker tracker;
-	struct bond_ipsec *ipsec;
-	struct bonding *bond;
-	struct slave *slave;
 
-	if (!bond_dev)
+	if (!bond_dev || !xs->xso.real_dev)
 		return;
 
-	rcu_read_lock();
-	bond = netdev_priv(bond_dev);
-	slave = rcu_dereference(bond->curr_active_slave);
-	real_dev = slave ? slave->dev : NULL;
-	netdev_hold(real_dev, &tracker, GFP_ATOMIC);
-	rcu_read_unlock();
-
-	if (!slave)
-		goto out;
-
-	if (!xs->xso.real_dev)
-		goto out;
-
-	WARN_ON(xs->xso.real_dev != real_dev);
+	real_dev = xs->xso.real_dev;
 
 	if (!real_dev->xfrmdev_ops ||
 	    !real_dev->xfrmdev_ops->xdo_dev_state_delete ||
 	    netif_is_bond_master(real_dev)) {
 		slave_warn(bond_dev, real_dev, "%s: no slave xdo_dev_state_delete\n", __func__);
-		goto out;
+		return;
 	}
 
 	real_dev->xfrmdev_ops->xdo_dev_state_delete(real_dev, xs);
-out:
-	netdev_put(real_dev, &tracker);
-	mutex_lock(&bond->ipsec_lock);
-	list_for_each_entry(ipsec, &bond->ipsec_list, list) {
-		if (ipsec->xs == xs) {
-			list_del(&ipsec->list);
-			kfree(ipsec);
-			break;
-		}
-	}
-	mutex_unlock(&bond->ipsec_lock);
 }
 
 static void bond_ipsec_del_sa_all(struct bonding *bond)
@@ -629,9 +614,15 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 				   __func__);
 			continue;
 		}
+
+		spin_lock_bh(&ipsec->xs->lock);
 		ipsec->xs->xso.real_dev = NULL;
-		real_dev->xfrmdev_ops->xdo_dev_state_delete(real_dev,
-							    ipsec->xs);
+		/* Don't double delete states killed by the user. */
+		if (ipsec->xs->km.state != XFRM_STATE_DEAD)
+			real_dev->xfrmdev_ops->xdo_dev_state_delete(real_dev,
+								    ipsec->xs);
+		spin_unlock_bh(&ipsec->xs->lock);
+
 		if (real_dev->xfrmdev_ops->xdo_dev_state_free)
 			real_dev->xfrmdev_ops->xdo_dev_state_free(real_dev,
 								  ipsec->xs);
@@ -643,34 +634,33 @@ static void bond_ipsec_free_sa(struct net_device *bond_dev,
 			       struct xfrm_state *xs)
 {
 	struct net_device *real_dev;
-	netdevice_tracker tracker;
+	struct bond_ipsec *ipsec;
 	struct bonding *bond;
-	struct slave *slave;
 
 	if (!bond_dev)
 		return;
 
-	rcu_read_lock();
 	bond = netdev_priv(bond_dev);
-	slave = rcu_dereference(bond->curr_active_slave);
-	real_dev = slave ? slave->dev : NULL;
-	netdev_hold(real_dev, &tracker, GFP_ATOMIC);
-	rcu_read_unlock();
-
-	if (!slave)
-		goto out;
 
+	mutex_lock(&bond->ipsec_lock);
 	if (!xs->xso.real_dev)
 		goto out;
 
-	WARN_ON(xs->xso.real_dev != real_dev);
+	real_dev = xs->xso.real_dev;
 
 	xs->xso.real_dev = NULL;
-	if (real_dev && real_dev->xfrmdev_ops &&
+	if (real_dev->xfrmdev_ops &&
 	    real_dev->xfrmdev_ops->xdo_dev_state_free)
 		real_dev->xfrmdev_ops->xdo_dev_state_free(real_dev, xs);
 out:
-	netdev_put(real_dev, &tracker);
+	list_for_each_entry(ipsec, &bond->ipsec_list, list) {
+		if (ipsec->xs == xs) {
+			list_del(&ipsec->list);
+			kfree(ipsec);
+			break;
+		}
+	}
+	mutex_unlock(&bond->ipsec_lock);
 }
 
 /**
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 01783dc3d0e32..1f1861c57e2ad 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -154,8 +154,11 @@ struct xfrm_dev_offload {
 	 */
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
-	/* This is a private pointer used by the bonding driver.
-	 * Device drivers should not use it.
+	/* This is a private pointer used by the bonding driver (and eventually
+	 * should be moved there). Device drivers should not use it.
+	 * Protected by xfrm_state.lock AND bond.ipsec_lock in most cases,
+	 * except in the .xdo_dev_state_del() flow, where only xfrm_state.lock
+	 * is held.
 	 */
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
-- 
2.39.5



