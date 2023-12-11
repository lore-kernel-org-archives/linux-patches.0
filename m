Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A86C8C8;
	Mon, 11 Dec 2023 18:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNBugqxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B858C433C7;
	Mon, 11 Dec 2023 18:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319584;
	bh=cXh1WiET5EmCPwpcBT0LhqvWiuqbf3BQeuEscmrAP1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNBugqxnSoHLNHkhe6y4hLpW6xs3wtChGG4dYXGJcPrHuuCB9gBQcWhI9ZY3ckR1B
	 ODW/jvy1/pphTMS99lJvpf8/I2AhepOhWlpfMg3UvtctDIWnZDEKx7hgVuzwLP4NPc
	 jKuRJE6xLupi0cStO2RQYY44bYTs/Y+ojFo/+nBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhou <hui.zhou@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 159/244] nfp: flower: fix for take a mutex lock in soft irq context and rcu lock
Date: Mon, 11 Dec 2023 19:20:52 +0100
Message-ID: <20231211182052.982985301@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Hui Zhou <hui.zhou@corigine.com>

commit 0ad722bd9ee3a9bdfca9613148645e4c9b7f26cf upstream.

The neighbour event callback call the function nfp_tun_write_neigh,
this function will take a mutex lock and it is in soft irq context,
change the work queue to process the neighbour event.

Move the nfp_tun_write_neigh function out of range rcu_read_lock/unlock()
in function nfp_tunnel_request_route_v4 and nfp_tunnel_request_route_v6.

Fixes: abc210952af7 ("nfp: flower: tunnel neigh support bond offload")
CC: stable@vger.kernel.org # 6.2+
Signed-off-by: Hui Zhou <hui.zhou@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../netronome/nfp/flower/tunnel_conf.c        | 127 +++++++++++++-----
 1 file changed, 95 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 060a77f2265d..e522845c7c21 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -160,6 +160,18 @@ struct nfp_tun_mac_addr_offload {
 	u8 addr[ETH_ALEN];
 };
 
+/**
+ * struct nfp_neigh_update_work - update neighbour information to nfp
+ * @work:	Work queue for writing neigh to the nfp
+ * @n:		neighbour entry
+ * @app:	Back pointer to app
+ */
+struct nfp_neigh_update_work {
+	struct work_struct work;
+	struct neighbour *n;
+	struct nfp_app *app;
+};
+
 enum nfp_flower_mac_offload_cmd {
 	NFP_TUNNEL_MAC_OFFLOAD_ADD =		0,
 	NFP_TUNNEL_MAC_OFFLOAD_DEL =		1,
@@ -607,38 +619,30 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 	nfp_flower_cmsg_warn(app, "Neighbour configuration failed.\n");
 }
 
-static int
-nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
-			    void *ptr)
+static void
+nfp_tun_release_neigh_update_work(struct nfp_neigh_update_work *update_work)
 {
-	struct nfp_flower_priv *app_priv;
-	struct netevent_redirect *redir;
-	struct neighbour *n;
+	neigh_release(update_work->n);
+	kfree(update_work);
+}
+
+static void nfp_tun_neigh_update(struct work_struct *work)
+{
+	struct nfp_neigh_update_work *update_work;
 	struct nfp_app *app;
+	struct neighbour *n;
 	bool neigh_invalid;
 	int err;
 
-	switch (event) {
-	case NETEVENT_REDIRECT:
-		redir = (struct netevent_redirect *)ptr;
-		n = redir->neigh;
-		break;
-	case NETEVENT_NEIGH_UPDATE:
-		n = (struct neighbour *)ptr;
-		break;
-	default:
-		return NOTIFY_DONE;
-	}
-
-	neigh_invalid = !(n->nud_state & NUD_VALID) || n->dead;
-
-	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
-	app = app_priv->app;
+	update_work = container_of(work, struct nfp_neigh_update_work, work);
+	app = update_work->app;
+	n = update_work->n;
 
 	if (!nfp_flower_get_port_id_from_netdev(app, n->dev))
-		return NOTIFY_DONE;
+		goto out;
 
 #if IS_ENABLED(CONFIG_INET)
+	neigh_invalid = !(n->nud_state & NUD_VALID) || n->dead;
 	if (n->tbl->family == AF_INET6) {
 #if IS_ENABLED(CONFIG_IPV6)
 		struct flowi6 flow6 = {};
@@ -655,13 +659,11 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 			dst = ip6_dst_lookup_flow(dev_net(n->dev), NULL,
 						  &flow6, NULL);
 			if (IS_ERR(dst))
-				return NOTIFY_DONE;
+				goto out;
 
 			dst_release(dst);
 		}
 		nfp_tun_write_neigh(n->dev, app, &flow6, n, true, false);
-#else
-		return NOTIFY_DONE;
 #endif /* CONFIG_IPV6 */
 	} else {
 		struct flowi4 flow4 = {};
@@ -678,17 +680,71 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 			rt = ip_route_output_key(dev_net(n->dev), &flow4);
 			err = PTR_ERR_OR_ZERO(rt);
 			if (err)
-				return NOTIFY_DONE;
+				goto out;
 
 			ip_rt_put(rt);
 		}
 		nfp_tun_write_neigh(n->dev, app, &flow4, n, false, false);
 	}
-#else
-	return NOTIFY_DONE;
 #endif /* CONFIG_INET */
+out:
+	nfp_tun_release_neigh_update_work(update_work);
+}
 
-	return NOTIFY_OK;
+static struct nfp_neigh_update_work *
+nfp_tun_alloc_neigh_update_work(struct nfp_app *app, struct neighbour *n)
+{
+	struct nfp_neigh_update_work *update_work;
+
+	update_work = kzalloc(sizeof(*update_work), GFP_ATOMIC);
+	if (!update_work)
+		return NULL;
+
+	INIT_WORK(&update_work->work, nfp_tun_neigh_update);
+	neigh_hold(n);
+	update_work->n = n;
+	update_work->app = app;
+
+	return update_work;
+}
+
+static int
+nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
+			    void *ptr)
+{
+	struct nfp_neigh_update_work *update_work;
+	struct nfp_flower_priv *app_priv;
+	struct netevent_redirect *redir;
+	struct neighbour *n;
+	struct nfp_app *app;
+
+	switch (event) {
+	case NETEVENT_REDIRECT:
+		redir = (struct netevent_redirect *)ptr;
+		n = redir->neigh;
+		break;
+	case NETEVENT_NEIGH_UPDATE:
+		n = (struct neighbour *)ptr;
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+#if IS_ENABLED(CONFIG_IPV6)
+	if (n->tbl != ipv6_stub->nd_tbl && n->tbl != &arp_tbl)
+#else
+	if (n->tbl != &arp_tbl)
+#endif
+		return NOTIFY_DONE;
+
+	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
+	app = app_priv->app;
+	update_work = nfp_tun_alloc_neigh_update_work(app, n);
+	if (!update_work)
+		return NOTIFY_DONE;
+
+	queue_work(system_highpri_wq, &update_work->work);
+
+	return NOTIFY_DONE;
 }
 
 void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb)
@@ -706,6 +762,7 @@ void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb)
 	netdev = nfp_app_dev_get(app, be32_to_cpu(payload->ingress_port), NULL);
 	if (!netdev)
 		goto fail_rcu_unlock;
+	dev_hold(netdev);
 
 	flow.daddr = payload->ipv4_addr;
 	flow.flowi4_proto = IPPROTO_UDP;
@@ -725,13 +782,16 @@ void nfp_tunnel_request_route_v4(struct nfp_app *app, struct sk_buff *skb)
 	ip_rt_put(rt);
 	if (!n)
 		goto fail_rcu_unlock;
+	rcu_read_unlock();
+
 	nfp_tun_write_neigh(n->dev, app, &flow, n, false, true);
 	neigh_release(n);
-	rcu_read_unlock();
+	dev_put(netdev);
 	return;
 
 fail_rcu_unlock:
 	rcu_read_unlock();
+	dev_put(netdev);
 	nfp_flower_cmsg_warn(app, "Requested route not found.\n");
 }
 
@@ -749,6 +809,7 @@ void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb)
 	netdev = nfp_app_dev_get(app, be32_to_cpu(payload->ingress_port), NULL);
 	if (!netdev)
 		goto fail_rcu_unlock;
+	dev_hold(netdev);
 
 	flow.daddr = payload->ipv6_addr;
 	flow.flowi6_proto = IPPROTO_UDP;
@@ -766,14 +827,16 @@ void nfp_tunnel_request_route_v6(struct nfp_app *app, struct sk_buff *skb)
 	dst_release(dst);
 	if (!n)
 		goto fail_rcu_unlock;
+	rcu_read_unlock();
 
 	nfp_tun_write_neigh(n->dev, app, &flow, n, true, true);
 	neigh_release(n);
-	rcu_read_unlock();
+	dev_put(netdev);
 	return;
 
 fail_rcu_unlock:
 	rcu_read_unlock();
+	dev_put(netdev);
 	nfp_flower_cmsg_warn(app, "Requested IPv6 route not found.\n");
 }
 
-- 
2.43.0



