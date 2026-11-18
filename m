Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033025;
	b=3D4U+8mroXWwutN6pe5XWNrS8UGMsKc9omNQwDB9476hJeVJSjUXObEfviYKEwh4fp6G
	 nd5q5rERzgJHylp14iFyGx7SlvT5IknHCxQ3f/BkCGrUEH1rHTlfTjw4EidyBrRSmBxbW
	 VqGQ+1lY2KPS7DUbBbjQEpTXD/SByimM37MljwsD98JwUIAZRR5alt4yMJAm78crle8vM
	 uNrWUhXVSEGoG0SuXyILUfxoSuCqUI/g1ppM/XwUsj0MeGaLDADrkHQWT9ONy2b90qHxl
	 HScfKxEhX2xSilrSNTOuvqmbFLgIj0uYn7qUuQBzb/F2Z7uwqezJgR4OR9Lr0HmM/Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NJOJSaY8JfBh7J5U/p1CWNJEoKSV+GdaQsnrtqJ7LHI=;
	b=GvWt/IniwW3+XNsdWt172KpG6JRKDS+nzKqCzVXrkR5XO/wRwhnzO3oUwB+HtMs18mzO
	 BJwd/ZOnCpsfkmH4MuKEouQNa9IfPbLWErVw1eULyljpOXCdfWKn+2u47IlDZtIKmkN21
	 /Wyeq+KTpw8OaqTM9TfAewLv0+rOoycoXCmlLGEfV04vuBh+YdWLw5p8EtUpzzbwTrJeJ
	 +PYlaqGbW61YOvpE4I1Z87cxCNDnJPA+qkiqCHoNZP2fekxojGKFFgxADVRbqHND9EUut
	 WXa5ecCOFiRQYZH/0ajzJiBy/9aPnt0W34lGR/b1PcJKHVMF2eXO+W6wHyU0VPRvg/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gma8/1ix";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63BD606A32A;
	Wed, 18 Nov 2026 20:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gma8/1ix
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103591F000C4;
	Wed, 18 Nov 2026 20:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033025;
	bh=NJOJSaY8JfBh7J5U/p1CWNJEoKSV+GdaQsnrtqJ7LHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gma8/1ixENYzGnFd9OVtxysg3DIEuJjIHOAYfbsizvX2tprOSpp7AxpbAdC0FmKs8
	 2maju4kPJwY7/ScnOeqPV6RoY7hrZ35hJqUwWVMjUtP27/tVTAGtS8OgUYxw0O2vSo
	 Img/wrBoz+j1H/JRQb1DJLbyU06/aIbDfCGY8xdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1621/1756] nfp: flower: fix use-after-free in neighbour update work
Date: Wed, 18 Nov 2026 16:02:28 +0100
Message-ID: <20261118150114.359235722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sicong Huang <congei42@163.com>

[ Upstream commit 083aaafd453c3fb14411519d6ada9a8917573fdb ]

The netevent notifier handles neighbour updates and redirects by
queuing nfp_tun_neigh_update() on system_highpri_wq. Each work item
holds a reference to the neighbour, but only stores a pointer to the
flower app.

During device removal, nfp_tunnel_config_stop() unregisters the
notifier. This waits for notifier callbacks to return, but does not
wait for the work they queued. The teardown then frees app->priv and
app without waiting for these work items. Flushing cmsg_work in
nfp_flower_clean() does not cover the neighbour update work.

A pending work item can therefore run after the app has been freed.
Its call to nfp_flower_get_port_id_from_netdev() can then access freed
memory while checking whether the neighbour's device can be offloaded.
Even notifications for unrelated devices can reach this check. The
same problem affects shutdown and probe error paths that tear down the
app after the netevent notifier has been registered.

One possible interleaving is shown below. The neighbour belongs to
another network device that remains registered.

  CPU0 (remove)                   CPU1 (notifier / kworker)
                                  nfp_tun_neigh_event_handler()
                                    queue_work(system_highpri_wq, ...)
                                    return
                                  /* Work has not run yet. */
  nfp_tunnel_config_stop()
    unregister_netevent_notifier()
    /* Notifier callbacks have finished, but work may be pending. */
  nfp_flower_clean()
    vfree(app->priv)
    app->priv = NULL
  nfp_app_free()
    kfree(app)
                                  nfp_tun_neigh_update()
                                    app = update_work->app
                                    nfp_flower_get_port_id_from_netdev()
                                      app->priv  /* use-after-free */

The work items are allocated per event and free themselves, so they
cannot be cancelled individually, and flushing system_highpri_wq is
not allowed. Use a dedicated workqueue for neighbour updates instead.
In nfp_tunnel_config_stop(), unregister the notifier and destroy the
workqueue before cleaning up the tunnel state. This prevents new work
from being queued and waits for pending and running work to finish
while the app and its resources are still valid.

Found by code inspection.

Fixes: 0ad722bd9ee3 ("nfp: flower: fix for take a mutex lock in soft irq context and rcu lock")
Signed-off-by: Sicong Huang <congei42@163.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 ++
 .../netronome/nfp/flower/tunnel_conf.c        | 24 ++++++++++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 2b7c947ff4f2a..bd4399758ed4d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -94,6 +94,7 @@ struct nfp_fl_stats_id {
  * @ipv6_off_lock:	Lock for the IPv6 address list
  * @mac_off_ids:	IDA to manage id assignment for offloaded MACs
  * @neigh_nb:		Notifier to monitor neighbour state
+ * @neigh_wq:		Workqueue for neighbour updates
  */
 struct nfp_fl_tunnel_offloads {
 	struct rhashtable offloaded_macs;
@@ -103,6 +104,7 @@ struct nfp_fl_tunnel_offloads {
 	struct mutex ipv6_off_lock;
 	struct ida mac_off_ids;
 	struct notifier_block neigh_nb;
+	struct workqueue_struct *neigh_wq;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 0d7d138d6e0d7..bc7f6d25eca5e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -742,7 +742,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 	if (!update_work)
 		return NOTIFY_DONE;
 
-	queue_work(system_highpri_wq, &update_work->work);
+	queue_work(app_priv->tun.neigh_wq, &update_work->work);
 
 	return NOTIFY_DONE;
 }
@@ -1516,6 +1516,13 @@ int nfp_tunnel_config_start(struct nfp_app *app)
 	if (err)
 		return err;
 
+	priv->tun.neigh_wq = alloc_workqueue("nfp-flower-neigh",
+					     WQ_HIGHPRI | WQ_PERCPU, 0);
+	if (!priv->tun.neigh_wq) {
+		err = -ENOMEM;
+		goto err_free_macs;
+	}
+
 	ida_init(&priv->tun.mac_off_ids);
 
 	/* Initialise priv data for IPv4/v6 offloading. */
@@ -1528,13 +1535,17 @@ int nfp_tunnel_config_start(struct nfp_app *app)
 	priv->tun.neigh_nb.notifier_call = nfp_tun_neigh_event_handler;
 
 	err = register_netevent_notifier(&priv->tun.neigh_nb);
-	if (err) {
-		rhashtable_free_and_destroy(&priv->tun.offloaded_macs,
-					    nfp_check_rhashtable_empty, NULL);
-		return err;
-	}
+	if (err)
+		goto err_destroy_neigh_wq;
 
 	return 0;
+
+err_destroy_neigh_wq:
+	destroy_workqueue(priv->tun.neigh_wq);
+err_free_macs:
+	rhashtable_free_and_destroy(&priv->tun.offloaded_macs,
+				    nfp_check_rhashtable_empty, NULL);
+	return err;
 }
 
 void nfp_tunnel_config_stop(struct nfp_app *app)
@@ -1544,6 +1555,7 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 	struct list_head *ptr, *storage;
 
 	unregister_netevent_notifier(&priv->tun.neigh_nb);
+	destroy_workqueue(priv->tun.neigh_wq);
 
 	ida_destroy(&priv->tun.mac_off_ids);
 
-- 
2.53.0



