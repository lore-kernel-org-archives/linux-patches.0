Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65097414A2A;
	Fri,  4 Sep 2026 06:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501693; cv=none; b=HQG048hEAsRqK5wAmj2/7yMSrsAZDqKIXMx6qGBjjwLe8c1wdPGeUc8Fbjo43e9ndwCYpTdlvmvDCdHIamZsizpwPi75AbC1RsD/mCZM4cXTgJDQiXW5sRUt9JpYFLOO1Z+hloUluzKNxfJay9faDxE+VoN4IuKJoOKS/+fspQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501693; c=relaxed/simple;
	bh=cJlo8CYSiDDaFI51lFQBUlAG9nSsodVnRXwFXWtFfeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgucIN2WY0V8ZfsbSQZ+c90lMj9LhmXecB85kUl36DNvFp5ypvB64+EC97/hzJJemIJLZsxqEA26Pau5+prPVVO+gVJ3mVcvJNqzF07bEmqsKiR4Fb1IyIqez0QveqESul6wXYoB9XBc8hBS6D4SPUqF9g8zr+vp4JSm8mTjtEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1N6QNdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1N6QNdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8611F00A3D;
	Fri,  4 Sep 2026 06:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501692;
	bh=Fxgw0Z5AJsI1GkqnoFLHM+afR0ioFczt8uCO4+Stz/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1N6QNdH2DWYHNDqCB4PF5ZHBVuOZo7ryNwnGhxzSTCtP1rh6k1Tg24/Dx2KBpk38
	 gICEhgpk1pkwQRT2gUKpcuGIbu3OZEbhVsj8YTYU3ijXtQC2DG2ZpDx+8T554spw7e
	 DCTgos7zX3DZUFwt+E6d74y33G3I0K/0+xeMbGQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 500/552] ovpn: run deferred work on a module-owned workqueue
Date: Fri,  4 Sep 2026 07:00:57 +0200
Message-ID: <20260904045801.989501778@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

commit e9714db8041763f59dde152c812b96b3de05c6d9 upstream.

ovpn queues several work items whose callbacks execute module text.
These works currently run on the global system workqueues, so module
exit has no driver-owned drain point that guarantees the callbacks have
fully returned before the module text can be freed.

Object references protect the objects used by the callbacks, but they do
not prove that a workqueue function has returned. In particular, a
worker can drop the final reference that unblocks device teardown while
it is still executing ovpn code.

Add a module-owned workqueue and queue all ovpn work items on it. During
module exit, unregister rtnl and netlink first, flush the workqueue so
ordinary ovpn workers finish, run the final RCU barrier, and destroy the
workqueue last. This keeps the workqueue available for cleanup work
queued from RCU callbacks, while ensuring no ovpn work item can outlive
the module text.

The per-device delayed keepalive work remains explicitly disabled during
netdev teardown (disable_delayed_work_sync in ndo_uninit), since
flush_workqueue does not flush delayed work that is still only pending
on its timer.

Fixes: 3ecfd9349f40 ("ovpn: implement keepalive mechanism")
Fixes: 11851cbd60ea ("ovpn: implement TCP transport")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/main.c     | 19 ++++++++++++++++++-
 drivers/net/ovpn/ovpnpriv.h |  4 ++++
 drivers/net/ovpn/peer.c     |  8 ++++----
 drivers/net/ovpn/tcp.c      |  9 ++++-----
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ovpn/main.c b/drivers/net/ovpn/main.c
index 0262926449f2e..c18ed8690baff 100644
--- a/drivers/net/ovpn/main.c
+++ b/drivers/net/ovpn/main.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
+#include <linux/workqueue.h>
 #include <net/gro_cells.h>
 #include <net/ip.h>
 #include <net/rtnetlink.h>
@@ -26,6 +27,9 @@
 #include "tcp.h"
 #include "udp.h"
 
+/* module-owned workqueue on which all ovpn-specific work is queued */
+struct workqueue_struct *ovpn_wq;
+
 static void ovpn_priv_free(struct net_device *net)
 {
 	struct ovpn_priv *ovpn = netdev_priv(net);
@@ -264,10 +268,16 @@ static int __init ovpn_init(void)
 
 	ovpn_tcp_init();
 
+	ovpn_wq = alloc_workqueue("ovpn", WQ_PERCPU, 0);
+	if (!ovpn_wq) {
+		pr_err("ovpn: cannot allocate workqueue\n");
+		return -ENOMEM;
+	}
+
 	err = rtnl_link_register(&ovpn_link_ops);
 	if (err) {
 		pr_err("ovpn: can't register rtnl link ops: %d\n", err);
-		return err;
+		goto destroy_wq;
 	}
 
 	err = ovpn_nl_register();
@@ -280,6 +290,9 @@ static int __init ovpn_init(void)
 
 unreg_rtnl:
 	rtnl_link_unregister(&ovpn_link_ops);
+destroy_wq:
+	destroy_workqueue(ovpn_wq);
+	ovpn_wq = NULL;
 	return err;
 }
 
@@ -288,7 +301,11 @@ static __exit void ovpn_cleanup(void)
 	ovpn_nl_unregister();
 	rtnl_link_unregister(&ovpn_link_ops);
 
+	flush_workqueue(ovpn_wq);
 	rcu_barrier();
+
+	destroy_workqueue(ovpn_wq);
+	ovpn_wq = NULL;
 }
 
 module_init(ovpn_init);
diff --git a/drivers/net/ovpn/ovpnpriv.h b/drivers/net/ovpn/ovpnpriv.h
index 5898f6adada7f..84499140e4bd9 100644
--- a/drivers/net/ovpn/ovpnpriv.h
+++ b/drivers/net/ovpn/ovpnpriv.h
@@ -15,6 +15,10 @@
 #include <uapi/linux/if_link.h>
 #include <uapi/linux/ovpn.h>
 
+struct workqueue_struct;
+
+extern struct workqueue_struct *ovpn_wq;
+
 /**
  * struct ovpn_peer_collection - container of peers for MultiPeer mode
  * @by_id: table of peers index by ID
diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 412ef09abd5e7..6b9f5f12fc5a8 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -62,7 +62,7 @@ void ovpn_peer_keepalive_set(struct ovpn_peer *peer, u32 interval, u32 timeout)
 	/* now that interval and timeout have been changed, kick
 	 * off the worker so that the next delay can be recomputed
 	 */
-	mod_delayed_work(system_wq, &peer->ovpn->keepalive_work, 0);
+	mod_delayed_work(ovpn_wq, &peer->ovpn->keepalive_work, 0);
 }
 
 /**
@@ -1366,7 +1366,7 @@ static time64_t ovpn_peer_keepalive_work_single(struct ovpn_peer *peer,
 			   peer->id);
 		if (WARN_ON(!ovpn_peer_hold(peer)))
 			return 0;
-		if (!schedule_work(&peer->keepalive_work))
+		if (!queue_work(ovpn_wq, &peer->keepalive_work))
 			ovpn_peer_put(peer);
 	}
 
@@ -1458,8 +1458,8 @@ void ovpn_peer_keepalive_work(struct work_struct *work)
 		netdev_dbg(ovpn->dev,
 			   "scheduling keepalive work: now=%llu next_run=%llu delta=%llu\n",
 			   next_run, now, next_run - now);
-		schedule_delayed_work(&ovpn->keepalive_work,
-				      (next_run - now) * HZ);
+		queue_delayed_work(ovpn_wq, &ovpn->keepalive_work,
+				   (next_run - now) * HZ);
 	}
 	unlock_ovpn(ovpn, &release_list);
 }
diff --git a/drivers/net/ovpn/tcp.c b/drivers/net/ovpn/tcp.c
index 0af14055c39aa..8fe8a8e750a40 100644
--- a/drivers/net/ovpn/tcp.c
+++ b/drivers/net/ovpn/tcp.c
@@ -151,7 +151,7 @@ static void ovpn_tcp_rcv(struct strparser *strp, struct sk_buff *skb)
 	/* take reference for deferred peer deletion. should never fail */
 	if (WARN_ON(!ovpn_peer_hold(peer)))
 		goto err_nopeer;
-	if (!schedule_work(&peer->tcp.defer_del_work))
+	if (!queue_work(ovpn_wq, &peer->tcp.defer_del_work))
 		ovpn_peer_put(peer);
 	ovpn_dev_dstats_rx_dropped(peer->ovpn->dev);
 err_nopeer:
@@ -284,13 +284,12 @@ static void ovpn_tcp_send_sock(struct ovpn_peer *peer, struct sock *sk)
 			 * stream therefore we abort the connection
 			 */
 			ovpn_peer_hold(peer);
-			if (!schedule_work(&peer->tcp.defer_del_work))
+			if (!queue_work(ovpn_wq, &peer->tcp.defer_del_work))
 				ovpn_peer_put(peer);
 
 			/* we bail out immediately and keep tx_in_progress set
 			 * to true. This way we prevent more TX attempts
-			 * which would lead to more invocations of
-			 * schedule_work()
+			 * which would lead to more invocations of queue_work()
 			 */
 			return;
 		}
@@ -487,7 +486,7 @@ static void ovpn_tcp_write_space(struct sock *sk)
 	rcu_read_lock();
 	sock = rcu_dereference_sk_user_data(sk);
 	if (likely(sock && sock->peer)) {
-		schedule_work(&sock->tcp_tx_work);
+		queue_work(ovpn_wq, &sock->tcp_tx_work);
 		sock->peer->tcp.sk_cb.sk_write_space(sk);
 	}
 	rcu_read_unlock();
-- 
2.53.0



