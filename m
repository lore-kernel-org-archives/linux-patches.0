Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30D8313527;
	Fri,  7 Aug 2026 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114347; cv=none; b=T+R1NXrX47/Hkgh6tuYNvGnu/gWzfS/wgFUWgQpsAR5FPjfAkBfF39FuUV+yp/wr6NYkuGkP+/1VgR3y9LtINx2dwSNjrlp2XxJNmG0IlL010Loc4Xvhb46ByvouCt9gL7JOFoB+jIK/rsiGW9TpIBkoSkWRfJtsHcOYQM6hx5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114347; c=relaxed/simple;
	bh=xwFvdnBAFwJel25cpamTE7YVWKAtJ1VMG4YoA6pANeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjK+LDQgbIAFMzmKlgOA+oppbvnWpMs3VmYezJsLSpX8Q3d/xGIFeRORz9bs6WzCDuH3hMPftvD+/9YOU2Whp7IAGlNMR/XBHvyLKhS6+qo/zHoRM1VsebSmH2XYz/RniWQibXZycRWqrwf5pul+F1qzDJbEmBTcvEuH2k8e6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0FgfmVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0FgfmVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010201F000E9;
	Fri,  7 Aug 2026 14:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114345;
	bh=xXNGRBP812dYmx32Uqvk+xYfBpVILQzWfl7wPe8Dzlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0FgfmVxL60GTXbXM2Vz0fidzumy2VxNSg25KBPOW8+u3eDQgDVikFVuynTiFZPS5
	 zqq+ppLFnzEYEZrL95nr0v9e11GrW32aohLDh1EQAUltIsLkvRu6qP0f2LKzzTsqEb
	 wbuI6nAEWpg6m4D3I1MnXWG1o+Ql3mtiMSfYc+Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 232/337] can: j1939: use netdevice_tracker for j1939_{priv,session,ecu} tracking
Date: Fri,  7 Aug 2026 16:37:15 +0200
Message-ID: <20260807143423.583541147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit d2fb981384b3a45f690616d550b29046e8ad16a4 upstream.

syzbot is still reporting

  unregister_netdevice: waiting for vcan0 to become free. Usage count = 2

problem. A debug printk() patch in linux-next-20260508 identified that
there is dev_hold()/dev_put() imbalance in j1939_priv management.

  Call trace for vcan0[26] +4 at
     __dev_hold include/linux/netdevice.h:4470 [inline]
     netdev_hold include/linux/netdevice.h:4513 [inline]
     dev_hold include/linux/netdevice.h:4536 [inline]
     j1939_priv_create net/can/j1939/main.c:140 [inline]
     j1939_netdev_start+0x36b/0xc10 net/can/j1939/main.c:268
     j1939_sk_bind+0x853/0xb30 net/can/j1939/socket.c:506
     __sys_bind_socket net/socket.c:1948 [inline]
     __sys_bind+0x2e9/0x410 net/socket.c:1979

  Call trace for vcan0[28] -3 at
     __dev_put include/linux/netdevice.h:4456 [inline]
     netdev_put include/linux/netdevice.h:4523 [inline]
     dev_put include/linux/netdevice.h:4548 [inline]
     __j1939_priv_release net/can/j1939/main.c:166 [inline]
     kref_put include/linux/kref.h:65 [inline]
     j1939_priv_put+0x128/0x270 net/can/j1939/main.c:172
     j1939_sk_sock_destruct+0x52/0x90 net/can/j1939/socket.c:388
     __sk_destruct+0x8d/0x9d0 net/core/sock.c:2352
     rcu_do_batch kernel/rcu/tree.c:2617 [inline]
     rcu_core kernel/rcu/tree.c:2869 [inline]
     rcu_cpu_kthread+0x99e/0x1470 kernel/rcu/tree.c:2957
     smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
     kthread+0x388/0x470 kernel/kthread.c:436
     ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
     ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

This refcount leak in j1939_priv might be caused by a refcount leak in
j1939_{session,ecu} because j1939_{session,ecu} holds a ref on j1939_priv.
For further investigation using upstream kernels, enable netdevice_tracker
in j1939_{priv,session,ecu} management.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260728055835.1151785-2-o.rempel@pengutronix.de
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/j1939/bus.c        |    2 ++
 net/can/j1939/j1939-priv.h |    3 +++
 net/can/j1939/main.c       |    8 ++++----
 net/can/j1939/transport.c  |    2 ++
 4 files changed, 11 insertions(+), 4 deletions(-)

--- a/net/can/j1939/bus.c
+++ b/net/can/j1939/bus.c
@@ -20,6 +20,7 @@ static void __j1939_ecu_release(struct k
 	struct j1939_priv *priv = ecu->priv;
 
 	list_del(&ecu->list);
+	netdev_put(priv->ndev, &ecu->priv_dev_tracker);
 	kfree(ecu);
 	j1939_priv_put(priv);
 }
@@ -155,6 +156,7 @@ struct j1939_ecu *j1939_ecu_create_locke
 	if (!ecu)
 		return ERR_PTR(-ENOMEM);
 	kref_init(&ecu->kref);
+	netdev_hold(priv->ndev, &ecu->priv_dev_tracker, gfp_any());
 	ecu->addr = J1939_IDLE_ADDR;
 	ecu->name = name;
 
--- a/net/can/j1939/j1939-priv.h
+++ b/net/can/j1939/j1939-priv.h
@@ -38,6 +38,7 @@ struct j1939_ecu {
 	struct hrtimer ac_timer;
 	struct kref kref;
 	struct j1939_priv *priv;
+	netdevice_tracker priv_dev_tracker;
 
 	/* count users, to help transport protocol decide for interaction */
 	int nusers;
@@ -60,6 +61,7 @@ struct j1939_priv {
 	rwlock_t lock;
 
 	struct net_device *ndev;
+	netdevice_tracker dev_tracker;
 
 	/* list of 256 ecu ptrs, that cache the claimed addresses.
 	 * also protected by the above lock
@@ -229,6 +231,7 @@ enum j1939_session_state {
 
 struct j1939_session {
 	struct j1939_priv *priv;
+	netdevice_tracker priv_dev_tracker;
 	struct list_head active_session_list_entry;
 	struct list_head sk_session_queue_entry;
 	struct kref kref;
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -137,7 +137,7 @@ static struct j1939_priv *j1939_priv_cre
 	priv->ndev = ndev;
 	kref_init(&priv->kref);
 	kref_init(&priv->rx_kref);
-	dev_hold(ndev);
+	netdev_hold(ndev, &priv->dev_tracker, GFP_KERNEL);
 
 	netdev_dbg(priv->ndev, "%s : 0x%p\n", __func__, priv);
 
@@ -163,7 +163,7 @@ static void __j1939_priv_release(struct
 	WARN_ON_ONCE(!list_empty(&priv->ecus));
 	WARN_ON_ONCE(!list_empty(&priv->j1939_socks));
 
-	dev_put(ndev);
+	netdev_put(ndev, &priv->dev_tracker);
 	kfree(priv);
 }
 
@@ -281,7 +281,7 @@ struct j1939_priv *j1939_netdev_start(st
 		 */
 		kref_get(&priv_new->rx_kref);
 		mutex_unlock(&j1939_netdev_lock);
-		dev_put(ndev);
+		netdev_put(ndev, &priv->dev_tracker);
 		kfree(priv);
 		return priv_new;
 	}
@@ -298,7 +298,7 @@ struct j1939_priv *j1939_netdev_start(st
 	j1939_priv_set(ndev, NULL);
 	mutex_unlock(&j1939_netdev_lock);
 
-	dev_put(ndev);
+	netdev_put(ndev, &priv->dev_tracker);
 	kfree(priv);
 
 	return ERR_PTR(ret);
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -282,6 +282,7 @@ static void j1939_session_destroy(struct
 		kfree_skb(skb);
 	}
 	__j1939_session_drop(session);
+	netdev_put(session->priv->ndev, &session->priv_dev_tracker);
 	j1939_priv_put(session->priv);
 	kfree(session);
 }
@@ -1510,6 +1511,7 @@ static struct j1939_session *j1939_sessi
 	INIT_LIST_HEAD(&session->active_session_list_entry);
 	INIT_LIST_HEAD(&session->sk_session_queue_entry);
 	kref_init(&session->kref);
+	netdev_hold(priv->ndev, &session->priv_dev_tracker, gfp_any());
 
 	j1939_priv_get(priv);
 	session->priv = priv;


