Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E1F2F12AE;
	Thu, 25 Jun 2026 13:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392796; cv=none; b=gG+fC+/7DGMhoVyPIVUHc+xPfOivy8dDnF+DwEwvoNOU2nqgitxZWTH+tCWKfR5HcrlUT72J+pukFqVCeDCsOB6QCQKgkkDocvpe8ARiqTRAbuMScUTQvoYh/SXkRq4eaxujj213pGa+JmV2HBcA3FZjtxN86DuEMLtfth0JhZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392796; c=relaxed/simple;
	bh=KqDqSGRxaqX1UTwyv7O2fx8HJlV/mxHP4rpCaXrS5kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYXmmq1LCWlPOH20hSK6ApUARzcTayNQCYhCaV7pCRt9ggOF8MoAlS6DmFG7aQ2oyu0OkN6dK6mnFu0nxQk83wDRIaA/XBehqV/4ETYw9L0Qf/FUk8ZyOurFVCOZi6LyH8wf6gSLjcCvE9kJMsn5y9JVO44GcyKawiE42a3g6qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ot7kQKiP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ot7kQKiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637021F00A3D;
	Thu, 25 Jun 2026 13:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392793;
	bh=r/MSc/MgR6Gz9je6AR1jkZup2uosCcFgvF1rclDi/UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ot7kQKiPueDby6Yo2fAgcTAtkt/yvxLOpCfekgT+HL+Tv8dp8VdxFs376AIZbR/fZ
	 +/7TxuN+rB3YByCj/qyndwn2cjPr2FTGN3ymkyQynXbxraub9EPw3g3Yw0tMNIB5he
	 AP9ojdaoDCAuEcasjJIf7MxQPPWM0D5hQFnisPB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 11/60] net: qualcomm: rmnet: fix endpoint use-after-free in rmnet_dellink()
Date: Thu, 25 Jun 2026 14:02:56 +0100
Message-ID: <20260625125647.153229904@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

commit d00c953a8f69921f484b629801766da68f27f658 upstream.

rmnet_dellink() removes the endpoint from the hash table with
hlist_del_init_rcu() and then immediately frees it with kfree(). However,
RCU readers on the receive path (rmnet_rx_handler ->
__rmnet_map_ingress_handler) may still hold a reference to the endpoint and
dereference ep->egress_dev after the memory has been freed. The endpoint is
a kmalloc-32 object, and the stale read at offset 8 corresponds to the
egress_dev pointer.

  BUG: unable to handle page fault for address: ffffffffde942eef
  Oops: 0002 [#1] SMP NOPTI
  CPU: 1 UID: 0 PID: 137 Comm: poc_write Not tainted 7.0.0+ #4 PREEMPTLAZY
  RIP: 0010:rmnet_vnd_rx_fixup (rmnet_vnd.c:27)
  Call Trace:
   <TASK>
   __rmnet_map_ingress_handler (rmnet_handlers.c:48 rmnet_handlers.c:101)
   rmnet_rx_handler (rmnet_handlers.c:129 rmnet_handlers.c:235)
   __netif_receive_skb_core.constprop.0 (net/core/dev.c:6096)
   __netif_receive_skb_one_core (net/core/dev.c:6208)
   netif_receive_skb (net/core/dev.c:6467)
   tun_get_user (drivers/net/tun.c:1955)
   tun_chr_write_iter (drivers/net/tun.c:2003)
   vfs_write (fs/read_write.c:688)
   ksys_write (fs/read_write.c:740)
   </TASK>

Add an rcu_head field to struct rmnet_endpoint and replace kfree() with
kfree_rcu() so the endpoint memory remains valid through the RCU grace
period. Also remove the rmnet_vnd_dellink() call and inline only the
nr_rmnet_devs decrement, since rmnet_vnd_dellink() would set
ep->egress_dev to NULL during the grace period, creating a data race
with lockless readers.

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20260514122511.3083479-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |    8 ++++----
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -213,8 +213,8 @@ static void rmnet_dellink(struct net_dev
 	ep = rmnet_get_endpoint(real_port, mux_id);
 	if (ep) {
 		hlist_del_init_rcu(&ep->hlnode);
-		rmnet_vnd_dellink(mux_id, real_port, ep);
-		kfree(ep);
+		real_port->nr_rmnet_devs--;
+		kfree_rcu(ep, rcu);
 	}
 
 	netdev_upper_dev_unlink(real_dev, dev);
@@ -238,9 +238,9 @@ static void rmnet_force_unassociate_devi
 		hash_for_each_safe(port->muxed_ep, bkt_ep, tmp_ep, ep, hlnode) {
 			unregister_netdevice_queue(ep->egress_dev, &list);
 			netdev_upper_dev_unlink(real_dev, ep->egress_dev);
-			rmnet_vnd_dellink(ep->mux_id, port, ep);
 			hlist_del_init_rcu(&ep->hlnode);
-			kfree(ep);
+			port->nr_rmnet_devs--;
+			kfree_rcu(ep, rcu);
 		}
 		rmnet_unregister_real_device(real_dev);
 		unregister_netdevice_many(&list);
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
@@ -18,6 +18,7 @@ struct rmnet_endpoint {
 	u8 mux_id;
 	struct net_device *egress_dev;
 	struct hlist_node hlnode;
+	struct rcu_head rcu;
 };
 
 struct rmnet_egress_agg_params {


