Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022050;
	b=u2SRrPi4STYKxXVr+ERF1HD/BlIq79Lqq7/TxA+QkZjd0eb60Vd9nRNnGuFb+IbMDUYZ
	 2fx3pL5C/Fs2dhs65Ii0WtZC2104vmrHgCxdGhoN7yEEv9VkMTWi0RKE067NproqfffL/
	 OQIrPRXwGBWoWTxU5KGAjcc9jyCpELI4vyIu3XXAXQP6AKUTONH2Ec1BH16vj7byW12D5
	 fIfwnCFYdMM+mbIv4aeEN2w1mnyTuJfVz1i5R6iIIqXQhrfzQx/ZWuNk7l0+49/oHA1o2
	 n94VhM5LtRzp33gJFvBh4y5ayZCUGE5Hm6vVBT1b9erBtUHFhnGnq1r8vjwvkIGmNHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FeGL4p4Y34qNV8J56j2yP8cU5UHJdwmUSOIol8dxb0=;
	b=ZdfbnRQOrGzYpwiU723915tamjUtuzdvjvXuas+2ElPyuYPJBgjmjI2saj6ZLiwdpMVO
	 ZbqCOR6wmjcG9VTGW77lF4UOc7PIzel3XevU29RskIo8ZBD8hW3zSzDL6WZ39tYMcinLs
	 12t2+Svq2c0cinjIgUVkw31NVeIj37QlDJ7gXkX0wGmxcg52lbpawcLa5mI32snciwcd9
	 l7vKGDQfmLqmx0rvW86t7YnhoaZbqtx8unoSawGhWLaqIR5ocpCONtsCcsJoq49yOtTPM
	 plxd6SXiQac/+Ki6TKYKQOO0ET0C8jNynAWuHs/PXXiF8kB4iJvIgUw7ZTHMwxbXpQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=br63AM1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932E1606A31C;
	Wed, 18 Nov 2026 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=br63AM1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED1B1F000C4;
	Wed, 18 Nov 2026 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022050;
	bh=7FeGL4p4Y34qNV8J56j2yP8cU5UHJdwmUSOIol8dxb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=br63AM1P2EUrDyI0H3ly4XRq1YhpcMeRSYIARIz+zkfeDDnlQ3eZRyiXOcFJu22Gx
	 V3g5UWqbeY7I1KbNyF+TojzUwzccasTGtkesMXaT3tHe5Gop/uS/P0gTq2uNOSgcdl
	 VbbaZquAlfBB8FbYvNLWCjOZJvvvSey+DnKTTvv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2523/2651] nfp: flower: fix use-after-free in neighbour update work
Date: Wed, 18 Nov 2026 16:02:43 +0100
Message-ID: <20261118150415.498264977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ca30702f88780..8f5b0d3eb3778 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -742,7 +742,7 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 	if (!update_work)
 		return NOTIFY_DONE;
 
-	queue_work(system_highpri_wq, &update_work->work);
+	queue_work(app_priv->tun.neigh_wq, &update_work->work);
 
 	return NOTIFY_DONE;
 }
@@ -1515,6 +1515,13 @@ int nfp_tunnel_config_start(struct nfp_app *app)
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
@@ -1527,13 +1534,17 @@ int nfp_tunnel_config_start(struct nfp_app *app)
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
@@ -1543,6 +1554,7 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 	struct list_head *ptr, *storage;
 
 	unregister_netevent_notifier(&priv->tun.neigh_nb);
+	destroy_workqueue(priv->tun.neigh_wq);
 
 	ida_destroy(&priv->tun.mac_off_ids);
 
-- 
2.53.0



