Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677E1390C81;
	Thu,  2 Jul 2026 16:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009599; cv=none; b=QS7OYjgKEuanIcSQfk6nV3xsuNMl0upRDTlEXysfVSvdZZAC26TJB3qGDbtMv6CBxPe7TZMkvJeQ1iinFXDq4UpK8GbxeW2aE+2ELtG1rJG3hqk40FMx0WFzf/qHaCn94EG9a/Wj0HIHCkDg+O+Oychc1wYRXaYTDs1ji5ZnMH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009599; c=relaxed/simple;
	bh=hiBcPYG8Od6Jz3FJos+0pLFfC3dzgh28HZimkzqA28w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKlfCLY1lm2qQUSnq8pldTGGuFFtcSe6Vi5gCjuwPWo7RwsbbXzf5FGHPtPE/119pCPMT/HB9jcztqKwjsjZqT0JzhIDALTFMZg1hTnwdVAOWY1eP3tC+w5lteKbZgA8GrAKpIqfTP0vrjb3CXoS4GeSweKlAYYsrZZPBvm1Nx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=joZW6Sy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="joZW6Sy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C944D1F000E9;
	Thu,  2 Jul 2026 16:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009597;
	bh=PKKv7cK70AwmLGol4xiIvfDD2XU2uqMmgoRzZQdEw2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joZW6Sy7UIHGRuN0B8M7UbWEBNUDKX7CbeQdZsMPY/5wb68KcEvZeSAkvC71Pq45e
	 qSD2Sf5Md1D26lmqvw8d894BTv9Um7TAGgDOx3ZEX8n0QniAa//UQvjMiAZXo9ZIgN
	 y4WqkDwWzP8SryGMAOmmruKq1Z96hCm6bZN5UM5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 16/95] net: qualcomm: rmnet: fix endpoint use-after-free in rmnet_dellink()
Date: Thu,  2 Jul 2026 18:19:19 +0200
Message-ID: <20260702155109.547624775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -205,8 +205,8 @@ static void rmnet_dellink(struct net_dev
 	ep = rmnet_get_endpoint(real_port, mux_id);
 	if (ep) {
 		hlist_del_init_rcu(&ep->hlnode);
-		rmnet_vnd_dellink(mux_id, real_port, ep);
-		kfree(ep);
+		real_port->nr_rmnet_devs--;
+		kfree_rcu(ep, rcu);
 	}
 
 	netdev_upper_dev_unlink(real_dev, dev);
@@ -230,9 +230,9 @@ static void rmnet_force_unassociate_devi
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
@@ -17,6 +17,7 @@ struct rmnet_endpoint {
 	u8 mux_id;
 	struct net_device *egress_dev;
 	struct hlist_node hlnode;
+	struct rcu_head rcu;
 };
 
 /* One instance of this structure is instantiated for each real_dev associated


