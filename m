Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E285189B85;
	Tue, 30 Jul 2024 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359362; cv=none; b=KoH9XWNIht5um4ykEqxaPh0RDBGq8LNC0+5d7/TqZi7bhWuNN8bIkUCYJhXk+aHMkEk9UMZteK30qEm00Cq0YQl0XQuaNDN4Km7mvtZ6LrcYQu/DUtoyur401M7Wh6oQMHJK6/INhiJoJ+8S/e/b1WQ7bOheCp/eBQcGspfoV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359362; c=relaxed/simple;
	bh=q4/2vBkLZ3bHZt3POFY26CGVdfSwCucjPouF8KyMdqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAIenXOl+9FajshEm1/wfIj5jJzYtFbeXlNcQe8gSc8lbwlm1tuNGIOAMHMD45KU9Jco9zOzZSsYS5zNRQ4XqIRB0bdEXN85J39+u5PjMlj2pN+2RqpDQVyiN0kJ3PqjAad9h1B4x9G9aaUobu5QHeb8HK3v9kAsKpdixfH3HT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2N89u8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2N89u8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E597C32782;
	Tue, 30 Jul 2024 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359361;
	bh=q4/2vBkLZ3bHZt3POFY26CGVdfSwCucjPouF8KyMdqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2N89u8BqCJBjaeZkr02WM0I2ISdGM21bgkU0HADAxSaj2MSdEpHdWzFJ+D/RRJVG
	 5xYWv4BQTvzUK/XkaTjNNoitPIjVYlBvhKavdI68MxDVXkFbIFYoY8yTyM/H6USJgJ
	 t5v84WiV2eSt98ewgcaasS+E9BYaZJppJZnQss5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 473/809] RDMA/mana_ib: Set correct device into ib
Date: Tue, 30 Jul 2024 17:45:49 +0200
Message-ID: <20240730151743.419303439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 1df03a4b44146c4f720d793915747272c7773a3e ]

Add mana_get_primary_netdev_rcu helper to get a primary
netdevice for a given port. When mana is used with
netvsc, the VF netdev is controlled by an upper netvsc
device. In a baremetal case, the VF netdev is the
primary device.

Use the mana_get_primary_netdev_rcu() helper in the mana_ib
to get the correct device for querying network states.

Fixes: 8b184e4f1c32 ("RDMA/mana_ib: Enable RoCE on port 1")
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Link: https://lore.kernel.org/r/1720705077-322-1-git-send-email-kotaranov@linux.microsoft.com
Reviewed-by: Long Li <longli@microsoft.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/device.c           | 16 ++++++++--------
 drivers/net/ethernet/microsoft/mana/mana_en.c | 19 +++++++++++++++++++
 include/net/mana/mana.h                       |  2 ++
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index 9a7da2ec9cdbb..7bb7e06392001 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -56,7 +56,7 @@ static int mana_ib_probe(struct auxiliary_device *adev,
 {
 	struct mana_adev *madev = container_of(adev, struct mana_adev, adev);
 	struct gdma_dev *mdev = madev->mdev;
-	struct net_device *upper_ndev;
+	struct net_device *ndev;
 	struct mana_context *mc;
 	struct mana_ib_dev *dev;
 	u8 mac_addr[ETH_ALEN];
@@ -84,17 +84,17 @@ static int mana_ib_probe(struct auxiliary_device *adev,
 	dev->ib_dev.num_comp_vectors = mdev->gdma_context->max_num_queues;
 	dev->ib_dev.dev.parent = mdev->gdma_context->dev;
 
-	rcu_read_lock(); /* required to get upper dev */
-	upper_ndev = netdev_master_upper_dev_get_rcu(mc->ports[0]);
-	if (!upper_ndev) {
+	rcu_read_lock(); /* required to get primary netdev */
+	ndev = mana_get_primary_netdev_rcu(mc, 0);
+	if (!ndev) {
 		rcu_read_unlock();
 		ret = -ENODEV;
-		ibdev_err(&dev->ib_dev, "Failed to get master netdev");
+		ibdev_err(&dev->ib_dev, "Failed to get netdev for IB port 1");
 		goto free_ib_device;
 	}
-	ether_addr_copy(mac_addr, upper_ndev->dev_addr);
-	addrconf_addr_eui48((u8 *)&dev->ib_dev.node_guid, upper_ndev->dev_addr);
-	ret = ib_device_set_netdev(&dev->ib_dev, upper_ndev, 1);
+	ether_addr_copy(mac_addr, ndev->dev_addr);
+	addrconf_addr_eui48((u8 *)&dev->ib_dev.node_guid, ndev->dev_addr);
+	ret = ib_device_set_netdev(&dev->ib_dev, ndev, 1);
 	rcu_read_unlock();
 	if (ret) {
 		ibdev_err(&dev->ib_dev, "Failed to set ib netdev, ret %d", ret);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 608ad31a97022..ad7ae7ba2b8fc 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2950,3 +2950,22 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 	gd->gdma_context = NULL;
 	kfree(ac);
 }
+
+struct net_device *mana_get_primary_netdev_rcu(struct mana_context *ac, u32 port_index)
+{
+	struct net_device *ndev;
+
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "Taking primary netdev without holding the RCU read lock");
+	if (port_index >= ac->num_ports)
+		return NULL;
+
+	/* When mana is used in netvsc, the upper netdevice should be returned. */
+	if (ac->ports[port_index]->flags & IFF_SLAVE)
+		ndev = netdev_master_upper_dev_get_rcu(ac->ports[port_index]);
+	else
+		ndev = ac->ports[port_index];
+
+	return ndev;
+}
+EXPORT_SYMBOL_NS(mana_get_primary_netdev_rcu, NET_MANA);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 561f6719fb4ec..f207a6e1042ae 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -796,4 +796,6 @@ void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
 		   u32 doorbell_pg_id);
 void mana_uncfg_vport(struct mana_port_context *apc);
+
+struct net_device *mana_get_primary_netdev_rcu(struct mana_context *ac, u32 port_index);
 #endif /* _MANA_H */
-- 
2.43.0



