Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA1B288CB0;
	Wed,  7 May 2025 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643375; cv=none; b=ucQLsI0fkUb4BrHDx+GCLyNJdnqmkQUtgNqdbfCIF2hoHEJIcUTg+y3JT6nRbzFe3XT/abqfM1ts9+FfurLJe4Em23uMmw/dq+I0XGi61Qqc8KURDxjOc9ZE8Oxri2/mAcXcTfP0rjvDxcg1gWgRzX0pt8kw7xHp8Z/IvDLJRig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643375; c=relaxed/simple;
	bh=j/MbElfbkBdorHUcbQGDaID2q5ON/1qw1UpsHCotv28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk7p2W2Xrkh+pXA0ej5jgMwT6oi4GhPcU0nehOXXdM1dO3EXQIhvi6TA5eFP3MfzBIYsXGYH4rOJA+2GDjBFVQyKPkDlXUJUG1Sb9PxguFRQ21Vy/RCDCO7+KuB6xggNZwSywXapU3GykNtd5xCX5xSbMBc/7H1mGMtcOLcdPHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKRGkKiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKRGkKiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEE5C4CEE2;
	Wed,  7 May 2025 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643375;
	bh=j/MbElfbkBdorHUcbQGDaID2q5ON/1qw1UpsHCotv28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKRGkKiFl0eVxkcGcw7e0ylJ8iTQPYvJu5Vx9X/nBHgbBwI6P/3X6/7iBG6+lglPZ
	 7asNiEmc4lDU5HrACamEE4uE0bmy2qTeNSiQEEeR777qdDv/8I0rktSPGQh7C1M65k
	 ZU530sAG11Rk9oEfKbkP2mIJF18nZmXTVCWKK8cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/55] net: hns3: fix an interrupt residual problem
Date: Wed,  7 May 2025 20:39:40 +0200
Message-ID: <20250507183800.622418642@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 8e6b9c6ea5a55045eed6526d8ee49e93192d1a58 ]

When a VF is passthrough to a VM, and the VM is killed, the reported
interrupt may not been handled, it will remain, and won't be clear by
the nic engine even with a flr or tqp reset. When the VM restart, the
interrupt of the first vector may be dropped by the second enable_irq
in vfio, see the issue below:
https://gitlab.com/qemu-project/qemu/-/issues/2884#note_2423361621

We notice that the vfio has always behaved this way, and the interrupt
is a residue of the nic engine, so we fix the problem by moving the
vector enable process out of the enable_irq loop.

Fixes: 08a100689d4b ("net: hns3: re-organize vector handle")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250430093052.2400464-3-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 82 +++++++++----------
 1 file changed, 39 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 03fe5e0729f64..af33074267ec9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -473,20 +473,14 @@ static void hns3_mask_vector_irq(struct hns3_enet_tqp_vector *tqp_vector,
 	writel(mask_en, tqp_vector->mask_addr);
 }
 
-static void hns3_vector_enable(struct hns3_enet_tqp_vector *tqp_vector)
+static void hns3_irq_enable(struct hns3_enet_tqp_vector *tqp_vector)
 {
 	napi_enable(&tqp_vector->napi);
 	enable_irq(tqp_vector->vector_irq);
-
-	/* enable vector */
-	hns3_mask_vector_irq(tqp_vector, 1);
 }
 
-static void hns3_vector_disable(struct hns3_enet_tqp_vector *tqp_vector)
+static void hns3_irq_disable(struct hns3_enet_tqp_vector *tqp_vector)
 {
-	/* disable vector */
-	hns3_mask_vector_irq(tqp_vector, 0);
-
 	disable_irq(tqp_vector->vector_irq);
 	napi_disable(&tqp_vector->napi);
 	cancel_work_sync(&tqp_vector->rx_group.dim.work);
@@ -707,11 +701,42 @@ static int hns3_set_rx_cpu_rmap(struct net_device *netdev)
 	return 0;
 }
 
+static void hns3_enable_irqs_and_tqps(struct net_device *netdev)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
+	u16 i;
+
+	for (i = 0; i < priv->vector_num; i++)
+		hns3_irq_enable(&priv->tqp_vector[i]);
+
+	for (i = 0; i < priv->vector_num; i++)
+		hns3_mask_vector_irq(&priv->tqp_vector[i], 1);
+
+	for (i = 0; i < h->kinfo.num_tqps; i++)
+		hns3_tqp_enable(h->kinfo.tqp[i]);
+}
+
+static void hns3_disable_irqs_and_tqps(struct net_device *netdev)
+{
+	struct hns3_nic_priv *priv = netdev_priv(netdev);
+	struct hnae3_handle *h = priv->ae_handle;
+	u16 i;
+
+	for (i = 0; i < h->kinfo.num_tqps; i++)
+		hns3_tqp_disable(h->kinfo.tqp[i]);
+
+	for (i = 0; i < priv->vector_num; i++)
+		hns3_mask_vector_irq(&priv->tqp_vector[i], 0);
+
+	for (i = 0; i < priv->vector_num; i++)
+		hns3_irq_disable(&priv->tqp_vector[i]);
+}
+
 static int hns3_nic_net_up(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
-	int i, j;
 	int ret;
 
 	ret = hns3_nic_reset_all_ring(h);
@@ -720,23 +745,13 @@ static int hns3_nic_net_up(struct net_device *netdev)
 
 	clear_bit(HNS3_NIC_STATE_DOWN, &priv->state);
 
-	/* enable the vectors */
-	for (i = 0; i < priv->vector_num; i++)
-		hns3_vector_enable(&priv->tqp_vector[i]);
-
-	/* enable rcb */
-	for (j = 0; j < h->kinfo.num_tqps; j++)
-		hns3_tqp_enable(h->kinfo.tqp[j]);
+	hns3_enable_irqs_and_tqps(netdev);
 
 	/* start the ae_dev */
 	ret = h->ae_algo->ops->start ? h->ae_algo->ops->start(h) : 0;
 	if (ret) {
 		set_bit(HNS3_NIC_STATE_DOWN, &priv->state);
-		while (j--)
-			hns3_tqp_disable(h->kinfo.tqp[j]);
-
-		for (j = i - 1; j >= 0; j--)
-			hns3_vector_disable(&priv->tqp_vector[j]);
+		hns3_disable_irqs_and_tqps(netdev);
 	}
 
 	return ret;
@@ -823,17 +838,9 @@ static void hns3_reset_tx_queue(struct hnae3_handle *h)
 static void hns3_nic_net_down(struct net_device *netdev)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
-	struct hnae3_handle *h = hns3_get_handle(netdev);
 	const struct hnae3_ae_ops *ops;
-	int i;
 
-	/* disable vectors */
-	for (i = 0; i < priv->vector_num; i++)
-		hns3_vector_disable(&priv->tqp_vector[i]);
-
-	/* disable rcb */
-	for (i = 0; i < h->kinfo.num_tqps; i++)
-		hns3_tqp_disable(h->kinfo.tqp[i]);
+	hns3_disable_irqs_and_tqps(netdev);
 
 	/* stop ae_dev */
 	ops = priv->ae_handle->ae_algo->ops;
@@ -5645,8 +5652,6 @@ int hns3_set_channels(struct net_device *netdev,
 void hns3_external_lb_prepare(struct net_device *ndev, bool if_running)
 {
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
-	struct hnae3_handle *h = priv->ae_handle;
-	int i;
 
 	if (!if_running)
 		return;
@@ -5654,11 +5659,7 @@ void hns3_external_lb_prepare(struct net_device *ndev, bool if_running)
 	netif_carrier_off(ndev);
 	netif_tx_disable(ndev);
 
-	for (i = 0; i < priv->vector_num; i++)
-		hns3_vector_disable(&priv->tqp_vector[i]);
-
-	for (i = 0; i < h->kinfo.num_tqps; i++)
-		hns3_tqp_disable(h->kinfo.tqp[i]);
+	hns3_disable_irqs_and_tqps(ndev);
 
 	/* delay ring buffer clearing to hns3_reset_notify_uninit_enet
 	 * during reset process, because driver may not be able
@@ -5674,18 +5675,13 @@ void hns3_external_lb_restore(struct net_device *ndev, bool if_running)
 {
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	struct hnae3_handle *h = priv->ae_handle;
-	int i;
 
 	if (!if_running)
 		return;
 
 	hns3_nic_reset_all_ring(priv->ae_handle);
 
-	for (i = 0; i < priv->vector_num; i++)
-		hns3_vector_enable(&priv->tqp_vector[i]);
-
-	for (i = 0; i < h->kinfo.num_tqps; i++)
-		hns3_tqp_enable(h->kinfo.tqp[i]);
+	hns3_enable_irqs_and_tqps(ndev);
 
 	netif_tx_wake_all_queues(ndev);
 
-- 
2.39.5



