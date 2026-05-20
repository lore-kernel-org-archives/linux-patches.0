Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9F4370D43;
	Wed, 20 May 2026 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299341; cv=none; b=rYoOraMUf2x+3SX/mYSQ8quzXNHAu0iLVo7pA9DOYlVATRV2MutYjJjD5SojLHerPGiYHkronW0XnLY+ePFyhrv/oLwHpF1f1M5lYnZiGqPOwFh/ue3xyx8JKFnoiLkTFv7cSk8d43UCauHml6ISV3BB3sZcz96haSn+cQwMZIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299341; c=relaxed/simple;
	bh=3Wt0teP7F1jU8VxZNGvBtOkFYp9NvS+al4i9HfbUL38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+baKZI53F/MORYB4ErTAAmjMoxUJao8mNrZI8l2yqL+Zys93H6tvSTf5l9/xvpB7g0NhpCPtPtaJkxU8/7I47CXZ+ijGfWYo5KA3il66NPqEaTvyyZZBvQLs6sFesPgCPfxrCTK7T73CVfI5DsF16aWr+Lu2ZvtD1+4ObwkavQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItkIMsdM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItkIMsdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938511F000E9;
	Wed, 20 May 2026 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299340;
	bh=Ugk8sj6GXL0ZUKBKibatNisiB+1jAnExJdCzCn73YJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItkIMsdMtn5NYmX2EanMMa8OuMy9x6YA0bXv7FOdo5bNW/qEldfLh1Blg2GvOyF3d
	 5uFjtMPCeDoRhMgiydB4eWXv3XDM4yAXH/uA2rnK7E9L0XvBobXgBtZISLvUa+rZpk
	 hZVlCSrcnXf7GqAl1GSnSr9dNFGkRBeGha2eW8C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 708/957] net: mana: Implement ndo_tx_timeout and serialize queue resets per port.
Date: Wed, 20 May 2026 18:19:51 +0200
Message-ID: <20260520162149.896141785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit 3b194343c25084a8d2fa0c0f2c9e80f3080fd732 ]

Implement .ndo_tx_timeout for MANA so any stalled TX queue can be detected
and a device-controlled port reset for all queues can be scheduled to a
ordered workqueue. The reset for all queues on stall detection is
recomended by hardware team.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Link: https://patch.msgid.link/20260112130552.GA11785@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 65267c9c4f28 ("net: mana: Fix EQ leak in mana_remove on NULL port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 77 ++++++++++++++++++-
 include/net/mana/gdma.h                       |  7 +-
 include/net/mana/mana.h                       |  3 +-
 3 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index b9cab61d0afe2..12952f7273eb6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -299,6 +299,39 @@ static int mana_get_gso_hs(struct sk_buff *skb)
 	return gso_hs;
 }
 
+static void mana_per_port_queue_reset_work_handler(struct work_struct *work)
+{
+	struct mana_port_context *apc = container_of(work,
+						     struct mana_port_context,
+						     queue_reset_work);
+	struct net_device *ndev = apc->ndev;
+	int err;
+
+	rtnl_lock();
+
+	/* Pre-allocate buffers to prevent failure in mana_attach later */
+	err = mana_pre_alloc_rxbufs(apc, ndev->mtu, apc->num_queues);
+	if (err) {
+		netdev_err(ndev, "Insufficient memory for reset post tx stall detection\n");
+		goto out;
+	}
+
+	err = mana_detach(ndev, false);
+	if (err) {
+		netdev_err(ndev, "mana_detach failed: %d\n", err);
+		goto dealloc_pre_rxbufs;
+	}
+
+	err = mana_attach(ndev);
+	if (err)
+		netdev_err(ndev, "mana_attach failed: %d\n", err);
+
+dealloc_pre_rxbufs:
+	mana_pre_dealloc_rxbufs(apc);
+out:
+	rtnl_unlock();
+}
+
 netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	enum mana_tx_pkt_format pkt_fmt = MANA_SHORT_PKT_FMT;
@@ -847,6 +880,23 @@ static int mana_change_mtu(struct net_device *ndev, int new_mtu)
 	return err;
 }
 
+static void mana_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+{
+	struct mana_port_context *apc = netdev_priv(netdev);
+	struct mana_context *ac = apc->ac;
+	struct gdma_context *gc = ac->gdma_dev->gdma_context;
+
+	/* Already in service, hence tx queue reset is not required.*/
+	if (gc->in_service)
+		return;
+
+	/* Note: If there are pending queue reset work for this port(apc),
+	 * subsequent request queued up from here are ignored. This is because
+	 * we are using the same work instance per port(apc).
+	 */
+	queue_work(ac->per_port_queue_reset_wq, &apc->queue_reset_work);
+}
+
 static int mana_shaper_set(struct net_shaper_binding *binding,
 			   const struct net_shaper *shaper,
 			   struct netlink_ext_ack *extack)
@@ -932,6 +982,7 @@ static const struct net_device_ops mana_devops = {
 	.ndo_bpf		= mana_bpf,
 	.ndo_xdp_xmit		= mana_xdp_xmit,
 	.ndo_change_mtu		= mana_change_mtu,
+	.ndo_tx_timeout		= mana_tx_timeout,
 	.net_shaper_ops         = &mana_shaper_ops,
 };
 
@@ -3319,6 +3370,8 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->needed_headroom = MANA_HEADROOM;
 	ndev->dev_port = port_idx;
+	/* Recommended timeout based on HW FPGA re-config scenario. */
+	ndev->watchdog_timeo = 15 * HZ;
 	SET_NETDEV_DEV(ndev, gc->dev);
 
 	netif_set_tso_max_size(ndev, GSO_MAX_SIZE);
@@ -3335,6 +3388,10 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	if (err)
 		goto reset_apc;
 
+	/* Initialize the per port queue reset work.*/
+	INIT_WORK(&apc->queue_reset_work,
+		  mana_per_port_queue_reset_work_handler);
+
 	netdev_lockdep_set_classes(ndev);
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
@@ -3524,6 +3581,7 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 {
 	struct gdma_context *gc = gd->gdma_context;
 	struct mana_context *ac = gd->driver_data;
+	struct mana_port_context *apc = NULL;
 	struct device *dev = gc->dev;
 	u8 bm_hostmode = 0;
 	u16 num_ports = 0;
@@ -3581,6 +3639,14 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 	if (ac->num_ports > MAX_PORTS_IN_MANA_DEV)
 		ac->num_ports = MAX_PORTS_IN_MANA_DEV;
 
+	ac->per_port_queue_reset_wq =
+		create_singlethread_workqueue("mana_per_port_queue_reset_wq");
+	if (!ac->per_port_queue_reset_wq) {
+		dev_err(dev, "Failed to allocate per port queue reset workqueue\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
 	if (!resuming) {
 		for (i = 0; i < ac->num_ports; i++) {
 			err = mana_probe_port(ac, i, &ac->ports[i]);
@@ -3596,6 +3662,8 @@ int mana_probe(struct gdma_dev *gd, bool resuming)
 	} else {
 		for (i = 0; i < ac->num_ports; i++) {
 			rtnl_lock();
+			apc = netdev_priv(ac->ports[i]);
+			enable_work(&apc->queue_reset_work);
 			err = mana_attach(ac->ports[i]);
 			rtnl_unlock();
 			/* Log the port for which the attach failed, stop
@@ -3652,13 +3720,15 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 
 	for (i = 0; i < ac->num_ports; i++) {
 		ndev = ac->ports[i];
-		apc = netdev_priv(ndev);
 		if (!ndev) {
 			if (i == 0)
 				dev_err(dev, "No net device to remove\n");
 			goto out;
 		}
 
+		apc = netdev_priv(ndev);
+		disable_work_sync(&apc->queue_reset_work);
+
 		/* All cleanup actions should stay after rtnl_lock(), otherwise
 		 * other functions may access partially cleaned up data.
 		 */
@@ -3685,6 +3755,11 @@ void mana_remove(struct gdma_dev *gd, bool suspending)
 
 	mana_destroy_eq(ac);
 out:
+	if (ac->per_port_queue_reset_wq) {
+		destroy_workqueue(ac->per_port_queue_reset_wq);
+		ac->per_port_queue_reset_wq = NULL;
+	}
+
 	mana_gd_deregister_device(gd);
 
 	if (suspending)
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index eaa27483f99b2..a59bd4035a992 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -598,6 +598,10 @@ enum {
 
 /* Driver can self reset on FPGA Reconfig EQE notification */
 #define GDMA_DRV_CAP_FLAG_1_HANDLE_RECONFIG_EQE BIT(17)
+
+/* Driver detects stalled send queues and recovers them */
+#define GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY BIT(18)
+
 #define GDMA_DRV_CAP_FLAG_1_HW_VPORT_LINK_AWARE BIT(6)
 
 /* Driver supports linearizing the skb when num_sge exceeds hardware limit */
@@ -621,7 +625,8 @@ enum {
 	 GDMA_DRV_CAP_FLAG_1_HW_VPORT_LINK_AWARE | \
 	 GDMA_DRV_CAP_FLAG_1_PERIODIC_STATS_QUERY | \
 	 GDMA_DRV_CAP_FLAG_1_SKB_LINEARIZE | \
-	 GDMA_DRV_CAP_FLAG_1_PROBE_RECOVERY)
+	 GDMA_DRV_CAP_FLAG_1_PROBE_RECOVERY | \
+	 GDMA_DRV_CAP_FLAG_1_HANDLE_STALL_SQ_RECOVERY)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 9fadff78568ea..e199f1d44c8e3 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -480,7 +480,7 @@ struct mana_context {
 	struct mana_ethtool_hc_stats hc_stats;
 	struct mana_eq *eqs;
 	struct dentry *mana_eqs_debugfs;
-
+	struct workqueue_struct *per_port_queue_reset_wq;
 	/* Workqueue for querying hardware stats */
 	struct delayed_work gf_stats_work;
 	bool hwc_timeout_occurred;
@@ -495,6 +495,7 @@ struct mana_context {
 struct mana_port_context {
 	struct mana_context *ac;
 	struct net_device *ndev;
+	struct work_struct queue_reset_work;
 
 	u8 mac_addr[ETH_ALEN];
 
-- 
2.53.0



