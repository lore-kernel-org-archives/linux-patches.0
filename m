Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C582737EE;
	Fri,  9 Jan 2026 12:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961415; cv=none; b=jmPyTthHcAeEt+II3+kLoteo7ronfRoPwYq1e/z7J+OqYs61fJqnkyW+E0ZDNxM6SRX676iQVMRdPyu/SOjqGCHct6tVICM2U/FeWIpqCZCrQfVyWY6Qe+TqCa0bq0s8b78NO7rj2d9Fo5KYhPnO/LqNFa8I75QBF4kew6aLBU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961415; c=relaxed/simple;
	bh=Ap2ClbY57MQ+OGTvQkP2frIx2SfgH9GONjZ/gfV9U7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfSGC0g6lMWegvFCgjctw6Ma2OMXPP0UQZQ5kAJf+r10nC+Gl1A34lN88aKtFzeQ5ZcpiwcbHrUyzMZ5+/2za/QwAm98wJBAVI27pfKIGthlt0sNz7E2TFOqkym7FtRFx9j4Xnm5NhTv/wYpB5kK1IDhwVdkpPV4UXtC1FP0bQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+8bMQHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+8bMQHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A44BC4CEF1;
	Fri,  9 Jan 2026 12:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961415;
	bh=Ap2ClbY57MQ+OGTvQkP2frIx2SfgH9GONjZ/gfV9U7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+8bMQHA9kUNZn9RpjEnhg7NIcBLI3+6IpLKugLBEUqSL6sDDxOryURjCXT2pZdce
	 pBOeBJbwzPSIU1Mr3K3UHoPCOBr3BMX9mdDBW3J+DSYQ6Is07o0EQ1oUZZMkpBW56j
	 9uhvnuzAdsIVdT7b+e+yY2SQmgUpvXa7BWBDQDYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b87489410b4efd181bf@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.6 714/737] RDMA/rxe: Remove the direct link to net_device
Date: Fri,  9 Jan 2026 12:44:13 +0100
Message-ID: <20260109112200.938251822@linuxfoundation.org>
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 2ac5415022d16d63d912a39a06f32f1f51140261 ]

The similar patch in siw is in the link:
https://git.kernel.org/rdma/rdma/c/16b87037b48889

This problem also occurred in RXE. The following analyze this problem.
In the following Call Traces:
"
BUG: KASAN: slab-use-after-free in dev_get_flags+0x188/0x1d0 net/core/dev.c:8782
Read of size 4 at addr ffff8880554640b0 by task kworker/1:4/5295

CPU: 1 UID: 0 PID: 5295 Comm: kworker/1:4 Not tainted
6.12.0-rc3-syzkaller-00399-g9197b73fd7bb #0
Hardware name: Google Compute Engine/Google Compute Engine,
BIOS Google 09/13/2024
Workqueue: infiniband ib_cache_event_task
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 dev_get_flags+0x188/0x1d0 net/core/dev.c:8782
 rxe_query_port+0x12d/0x260 drivers/infiniband/sw/rxe/rxe_verbs.c:60
 __ib_query_port drivers/infiniband/core/device.c:2111 [inline]
 ib_query_port+0x168/0x7d0 drivers/infiniband/core/device.c:2143
 ib_cache_update+0x1a9/0xb80 drivers/infiniband/core/cache.c:1494
 ib_cache_event_task+0xf3/0x1e0 drivers/infiniband/core/cache.c:1568
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa65/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
"

1). In the link [1],

"
 infiniband syz2: set down
"

This means that on 839.350575, the event ib_cache_event_task was sent andi
queued in ib_wq.

2). In the link [1],

"
 team0 (unregistering): Port device team_slave_0 removed
"

It indicates that before 843.251853, the net device should be freed.

3). In the link [1],

"
 BUG: KASAN: slab-use-after-free in dev_get_flags+0x188/0x1d0
"

This means that on 850.559070, this slab-use-after-free problem occurred.

In all, on 839.350575, the event ib_cache_event_task was sent and queued
in ib_wq,

before 843.251853, the net device veth was freed.

on 850.559070, this event was executed, and the mentioned freed net device
was called. Thus, the above call trace occurred.

[1] https://syzkaller.appspot.com/x/log.txt?x=12e7025f980000

Reported-by: syzbot+4b87489410b4efd181bf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4b87489410b4efd181bf
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20241220222325.2487767-1-yanjun.zhu@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: - exported ib_device_get_netdev() function.
          - added ib_device_get_netdev() to ib_verbs.h.]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/device.c      |    1 +
 drivers/infiniband/sw/rxe/rxe.c       |   23 +++++++++++++++++++----
 drivers/infiniband/sw/rxe/rxe.h       |    3 ++-
 drivers/infiniband/sw/rxe/rxe_mcast.c |   22 ++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_net.c   |   25 ++++++++++++++++++++-----
 drivers/infiniband/sw/rxe/rxe_verbs.c |   26 +++++++++++++++++++++-----
 drivers/infiniband/sw/rxe/rxe_verbs.h |   11 ++++++++---
 include/rdma/ib_verbs.h               |    2 ++
 8 files changed, 93 insertions(+), 20 deletions(-)

--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2259,6 +2259,7 @@ struct net_device *ib_device_get_netdev(
 
 	return res;
 }
+EXPORT_SYMBOL(ib_device_get_netdev);
 
 /**
  * ib_device_get_by_netdev - Find an IB device associated with a netdev
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -40,6 +40,8 @@ void rxe_dealloc(struct ib_device *ib_de
 /* initialize rxe device parameters */
 static void rxe_init_device_param(struct rxe_dev *rxe)
 {
+	struct net_device *ndev;
+
 	rxe->max_inline_data			= RXE_MAX_INLINE_DATA;
 
 	rxe->attr.vendor_id			= RXE_VENDOR_ID;
@@ -71,8 +73,15 @@ static void rxe_init_device_param(struct
 	rxe->attr.max_fast_reg_page_list_len	= RXE_MAX_FMR_PAGE_LIST_LEN;
 	rxe->attr.max_pkeys			= RXE_MAX_PKEYS;
 	rxe->attr.local_ca_ack_delay		= RXE_LOCAL_CA_ACK_DELAY;
+
+	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
+	if (!ndev)
+		return;
+
 	addrconf_addr_eui48((unsigned char *)&rxe->attr.sys_image_guid,
-			rxe->ndev->dev_addr);
+			ndev->dev_addr);
+
+	dev_put(ndev);
 
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
 }
@@ -109,10 +118,15 @@ static void rxe_init_port_param(struct r
 static void rxe_init_ports(struct rxe_dev *rxe)
 {
 	struct rxe_port *port = &rxe->port;
+	struct net_device *ndev;
 
 	rxe_init_port_param(port);
+	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
+	if (!ndev)
+		return;
 	addrconf_addr_eui48((unsigned char *)&port->port_guid,
-			    rxe->ndev->dev_addr);
+			    ndev->dev_addr);
+	dev_put(ndev);
 	spin_lock_init(&port->port_lock);
 }
 
@@ -169,12 +183,13 @@ void rxe_set_mtu(struct rxe_dev *rxe, un
 /* called by ifc layer to create new rxe device.
  * The caller should allocate memory for rxe by calling ib_alloc_device.
  */
-int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name)
+int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name,
+			struct net_device *ndev)
 {
 	rxe_init(rxe);
 	rxe_set_mtu(rxe, mtu);
 
-	return rxe_register_device(rxe, ibdev_name);
+	return rxe_register_device(rxe, ibdev_name, ndev);
 }
 
 static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
--- a/drivers/infiniband/sw/rxe/rxe.h
+++ b/drivers/infiniband/sw/rxe/rxe.h
@@ -139,7 +139,8 @@ enum resp_states {
 
 void rxe_set_mtu(struct rxe_dev *rxe, unsigned int dev_mtu);
 
-int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name);
+int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name,
+			struct net_device *ndev);
 
 void rxe_rcv(struct sk_buff *skb);
 
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -31,10 +31,19 @@
 static int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	unsigned char ll_addr[ETH_ALEN];
+	struct net_device *ndev;
+	int ret;
+
+	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
+	if (!ndev)
+		return -ENODEV;
 
 	ipv6_eth_mc_map((struct in6_addr *)mgid->raw, ll_addr);
 
-	return dev_mc_add(rxe->ndev, ll_addr);
+	ret = dev_mc_add(ndev, ll_addr);
+	dev_put(ndev);
+
+	return ret;
 }
 
 /**
@@ -47,10 +56,19 @@ static int rxe_mcast_add(struct rxe_dev
 static int rxe_mcast_del(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	unsigned char ll_addr[ETH_ALEN];
+	struct net_device *ndev;
+	int ret;
+
+	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
+	if (!ndev)
+		return -ENODEV;
 
 	ipv6_eth_mc_map((struct in6_addr *)mgid->raw, ll_addr);
 
-	return dev_mc_del(rxe->ndev, ll_addr);
+	ret = dev_mc_del(ndev, ll_addr);
+	dev_put(ndev);
+
+	return ret;
 }
 
 /**
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -509,7 +509,16 @@ out:
  */
 const char *rxe_parent_name(struct rxe_dev *rxe, unsigned int port_num)
 {
-	return rxe->ndev->name;
+	struct net_device *ndev;
+	char *ndev_name;
+
+	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
+	if (!ndev)
+		return NULL;
+	ndev_name = ndev->name;
+	dev_put(ndev);
+
+	return ndev_name;
 }
 
 int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
@@ -521,9 +530,7 @@ int rxe_net_add(const char *ibdev_name,
 	if (!rxe)
 		return -ENOMEM;
 
-	rxe->ndev = ndev;
-
-	err = rxe_add(rxe, ndev->mtu, ibdev_name);
+	err = rxe_add(rxe, ndev->mtu, ibdev_name, ndev);
 	if (err) {
 		ib_dealloc_device(&rxe->ib_dev);
 		return err;
@@ -571,10 +578,18 @@ void rxe_port_down(struct rxe_dev *rxe)
 
 void rxe_set_port_state(struct rxe_dev *rxe)
 {
-	if (netif_running(rxe->ndev) && netif_carrier_ok(rxe->ndev))
+	struct net_device *ndev;
+
+	ndev = rxe_ib_device_get_netdev(&rxe->ib_dev);
+	if (!ndev)
+		return;
+
+	if (netif_running(ndev) && netif_carrier_ok(ndev))
 		rxe_port_up(rxe);
 	else
 		rxe_port_down(rxe);
+
+	dev_put(ndev);
 }
 
 static int rxe_notify(struct notifier_block *not_blk,
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -41,6 +41,7 @@ static int rxe_query_port(struct ib_devi
 			  u32 port_num, struct ib_port_attr *attr)
 {
 	struct rxe_dev *rxe = to_rdev(ibdev);
+	struct net_device *ndev;
 	int err, ret;
 
 	if (port_num != 1) {
@@ -51,19 +52,26 @@ static int rxe_query_port(struct ib_devi
 
 	memcpy(attr, &rxe->port.attr, sizeof(*attr));
 
+	ndev = rxe_ib_device_get_netdev(ibdev);
+	if (!ndev) {
+		err = -ENODEV;
+		goto err_out;
+	}
+
 	mutex_lock(&rxe->usdev_lock);
 	ret = ib_get_eth_speed(ibdev, port_num, &attr->active_speed,
 			       &attr->active_width);
 
 	if (attr->state == IB_PORT_ACTIVE)
 		attr->phys_state = IB_PORT_PHYS_STATE_LINK_UP;
-	else if (dev_get_flags(rxe->ndev) & IFF_UP)
+	else if (dev_get_flags(ndev) & IFF_UP)
 		attr->phys_state = IB_PORT_PHYS_STATE_POLLING;
 	else
 		attr->phys_state = IB_PORT_PHYS_STATE_DISABLED;
 
 	mutex_unlock(&rxe->usdev_lock);
 
+	dev_put(ndev);
 	return ret;
 
 err_out:
@@ -1428,9 +1436,16 @@ static const struct attribute_group rxe_
 static int rxe_enable_driver(struct ib_device *ib_dev)
 {
 	struct rxe_dev *rxe = container_of(ib_dev, struct rxe_dev, ib_dev);
+	struct net_device *ndev;
+
+	ndev = rxe_ib_device_get_netdev(ib_dev);
+	if (!ndev)
+		return -ENODEV;
 
 	rxe_set_port_state(rxe);
-	dev_info(&rxe->ib_dev.dev, "added %s\n", netdev_name(rxe->ndev));
+	dev_info(&rxe->ib_dev.dev, "added %s\n", netdev_name(ndev));
+
+	dev_put(ndev);
 	return 0;
 }
 
@@ -1498,7 +1513,8 @@ static const struct ib_device_ops rxe_de
 	INIT_RDMA_OBJ_SIZE(ib_mw, rxe_mw, ibmw),
 };
 
-int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name)
+int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name,
+						struct net_device *ndev)
 {
 	int err;
 	struct ib_device *dev = &rxe->ib_dev;
@@ -1510,13 +1526,13 @@ int rxe_register_device(struct rxe_dev *
 	dev->num_comp_vectors = num_possible_cpus();
 	dev->local_dma_lkey = 0;
 	addrconf_addr_eui48((unsigned char *)&dev->node_guid,
-			    rxe->ndev->dev_addr);
+			    ndev->dev_addr);
 
 	dev->uverbs_cmd_mask |= BIT_ULL(IB_USER_VERBS_CMD_POST_SEND) |
 				BIT_ULL(IB_USER_VERBS_CMD_REQ_NOTIFY_CQ);
 
 	ib_set_device_ops(dev, &rxe_dev_ops);
-	err = ib_device_set_netdev(&rxe->ib_dev, rxe->ndev, 1);
+	err = ib_device_set_netdev(&rxe->ib_dev, ndev, 1);
 	if (err)
 		return err;
 
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -369,6 +369,7 @@ struct rxe_port {
 	u32			qp_gsi_index;
 };
 
+#define	RXE_PORT	1
 struct rxe_dev {
 	struct ib_device	ib_dev;
 	struct ib_device_attr	attr;
@@ -376,8 +377,6 @@ struct rxe_dev {
 	int			max_inline_data;
 	struct mutex	usdev_lock;
 
-	struct net_device	*ndev;
-
 	struct rxe_pool		uc_pool;
 	struct rxe_pool		pd_pool;
 	struct rxe_pool		ah_pool;
@@ -405,6 +404,11 @@ struct rxe_dev {
 	struct crypto_shash	*tfm;
 };
 
+static inline struct net_device *rxe_ib_device_get_netdev(struct ib_device *dev)
+{
+	return ib_device_get_netdev(dev, RXE_PORT);
+}
+
 static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
 {
 	atomic64_inc(&rxe->stats_counters[index]);
@@ -470,6 +474,7 @@ static inline struct rxe_pd *rxe_mw_pd(s
 	return to_rpd(mw->ibmw.pd);
 }
 
-int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name);
+int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name,
+						struct net_device *ndev);
 
 #endif /* RXE_VERBS_H */
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4444,6 +4444,8 @@ struct net_device *ib_get_net_dev_by_par
 					    const struct sockaddr *addr);
 int ib_device_set_netdev(struct ib_device *ib_dev, struct net_device *ndev,
 			 unsigned int port);
+struct net_device *ib_device_get_netdev(struct ib_device *ib_dev,
+					u32 port);
 struct ib_wq *ib_create_wq(struct ib_pd *pd,
 			   struct ib_wq_init_attr *init_attr);
 int ib_destroy_wq_user(struct ib_wq *wq, struct ib_udata *udata);


