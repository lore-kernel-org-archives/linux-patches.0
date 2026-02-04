Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C328B29AB1D;
	Wed,  4 Feb 2026 15:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218891; cv=none; b=jYzYDAj5FYolCm+wR2AOWtS/WAARornWkQzexU/oefbWWEmNyAli0F4TejWjfstQvo7lTqmqdh812Qj147Ueh9V/YZK6yz7rcK4leMDhlrh5SOa2UnV1MazcAxXmYizjKiK59zmkfX+XupZzNyoKRnRRvKZaYQECkx3GeEzcTAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218891; c=relaxed/simple;
	bh=OQbECWL7HYwsPMucwct1Z2kT6/e1fuNO1TYn2pB6HSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VksrY0rWqD6H+euChXOP7QyaP9H07skHrMB9GbKX0OFo64ooMBOGioaZE3d0ZeMGyXbMkMjFBIp7mbpSwRKDrmRlk4yLedP7w6Nhh/021wx/XT4nfeXGYIozUcbC7opzXrEZiajP8o4VkuXUHzDsP1upOVJ35LQCB1GSxINzjHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iz/G/ZT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iz/G/ZT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3786FC4CEF7;
	Wed,  4 Feb 2026 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218891;
	bh=OQbECWL7HYwsPMucwct1Z2kT6/e1fuNO1TYn2pB6HSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iz/G/ZT1BXSdYG+cCbs9M32Qtsk3aoTR9CHw/dPykKPZ5+1Sp9oI90VkGarWAT/rr
	 4YTEaUObjhF100I9peZEM2nQIFZovS87ktvFgnK/vlN+PjVOXX3gEopLPtvUKNjJgH
	 cVqPOfL4jA8ZyHaPlTjRS9a96vTbGFO1ui9/DMQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 85/87] net: mana: Change the function signature of mana_get_primary_netdev_rcu
Date: Wed,  4 Feb 2026 15:41:23 +0100
Message-ID: <20260204143849.987193792@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Long Li <longli@microsoft.com>

commit a8445cfec101c42e9d64cdb2dac13973b22c205c upstream.

Change mana_get_primary_netdev_rcu() to mana_get_primary_netdev(), and
return the ndev with refcount held. The caller is responsible for dropping
the refcount.

Also drop the check for IFF_SLAVE as it is not necessary if the upper
device is present.

Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1741821332-9392-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Fixes: 1df03a4b4414 ("RDMA/mana_ib: Set correct device into ib")
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mana/device.c           |    7 +++----
 drivers/infiniband/hw/mana/mana_ib.h          |    1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c |   22 ++++++++++++++--------
 include/net/mana/mana.h                       |    4 +++-
 4 files changed, 21 insertions(+), 13 deletions(-)

--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -84,10 +84,8 @@ static int mana_ib_probe(struct auxiliar
 	dev->ib_dev.num_comp_vectors = mdev->gdma_context->max_num_queues;
 	dev->ib_dev.dev.parent = mdev->gdma_context->dev;
 
-	rcu_read_lock(); /* required to get primary netdev */
-	ndev = mana_get_primary_netdev_rcu(mc, 0);
+	ndev = mana_get_primary_netdev(mc, 0, &dev->dev_tracker);
 	if (!ndev) {
-		rcu_read_unlock();
 		ret = -ENODEV;
 		ibdev_err(&dev->ib_dev, "Failed to get netdev for IB port 1");
 		goto free_ib_device;
@@ -95,7 +93,8 @@ static int mana_ib_probe(struct auxiliar
 	ether_addr_copy(mac_addr, ndev->dev_addr);
 	addrconf_addr_eui48((u8 *)&dev->ib_dev.node_guid, ndev->dev_addr);
 	ret = ib_device_set_netdev(&dev->ib_dev, ndev, 1);
-	rcu_read_unlock();
+	/* mana_get_primary_netdev() returns ndev with refcount held */
+	netdev_put(ndev, &dev->dev_tracker);
 	if (ret) {
 		ibdev_err(&dev->ib_dev, "Failed to set ib netdev, ret %d", ret);
 		goto free_ib_device;
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -64,6 +64,7 @@ struct mana_ib_dev {
 	struct gdma_queue **eqs;
 	struct xarray qp_table_wq;
 	struct mana_ib_adapter_caps adapter_caps;
+	netdevice_tracker dev_tracker;
 };
 
 struct mana_ib_wq {
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -3000,21 +3000,27 @@ out:
 	kfree(ac);
 }
 
-struct net_device *mana_get_primary_netdev_rcu(struct mana_context *ac, u32 port_index)
+struct net_device *mana_get_primary_netdev(struct mana_context *ac,
+					   u32 port_index,
+					   netdevice_tracker *tracker)
 {
 	struct net_device *ndev;
 
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
-			 "Taking primary netdev without holding the RCU read lock");
 	if (port_index >= ac->num_ports)
 		return NULL;
 
-	/* When mana is used in netvsc, the upper netdevice should be returned. */
-	if (ac->ports[port_index]->flags & IFF_SLAVE)
-		ndev = netdev_master_upper_dev_get_rcu(ac->ports[port_index]);
-	else
+	rcu_read_lock();
+
+	/* If mana is used in netvsc, the upper netdevice should be returned. */
+	ndev = netdev_master_upper_dev_get_rcu(ac->ports[port_index]);
+
+	/* If there is no upper device, use the parent Ethernet device */
+	if (!ndev)
 		ndev = ac->ports[port_index];
 
+	netdev_hold(ndev, tracker, GFP_ATOMIC);
+	rcu_read_unlock();
+
 	return ndev;
 }
-EXPORT_SYMBOL_NS(mana_get_primary_netdev_rcu, NET_MANA);
+EXPORT_SYMBOL_NS(mana_get_primary_netdev, NET_MANA);
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -819,5 +819,7 @@ int mana_cfg_vport(struct mana_port_cont
 		   u32 doorbell_pg_id);
 void mana_uncfg_vport(struct mana_port_context *apc);
 
-struct net_device *mana_get_primary_netdev_rcu(struct mana_context *ac, u32 port_index);
+struct net_device *mana_get_primary_netdev(struct mana_context *ac,
+					   u32 port_index,
+					   netdevice_tracker *tracker);
 #endif /* _MANA_H */


