Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9649429A0;
	Wed,  7 May 2025 19:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644571; cv=none; b=pISfuOzN15B3eY3NKoHbyvs8IsMd/Yntr/ZeKXKn1QU0SyBs1jvbQ/UXhtL20b1Ly8jbDWDvvmQltWlKGoyod+8w1AFrA8ohcPfdDP2gb6mwmi+FHsH+WSkkuc4FQ1O71aJfY0TFN2MHOnkJkclMk7xDuj2oVBMnhGp4dBSOBj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644571; c=relaxed/simple;
	bh=2USXQwdUTYR+KH5cBYaIn2Mx5+W3FkZ6tkq+pQSrg8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XoS7GOwKMP6hw81vg20juBG+yhpo0nWOG1x4A2v/nNfq7rYrtXvGGz3tQc4c7oST1EmccVSogEOR9jEXBi5PfYUoitsbsN+SAdVF/tr1KOxFR4rU2AOcndbYhcSPaV2TutmAk0ZhMmqDT19RVUdHvMvGdvBB7isrrdcnnDJt/+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpmHyhGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpmHyhGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0595AC4CEE2;
	Wed,  7 May 2025 19:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644571;
	bh=2USXQwdUTYR+KH5cBYaIn2Mx5+W3FkZ6tkq+pQSrg8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpmHyhGtaU+YY2B58RH1H199h2AQj/+p+mhagcwXibjXxIv5tDQdvATT8etUWfo3U
	 /gIT/6UTPazREG08cmm954ll/SPy6VQ/DnIQPInRZehBNuGZEyysjMowaTm2nQE8R/
	 HU5RttS1CNZymznJJ9w7ATF7eyEfAW0uYO7qHfT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/164] net: ethernet: mtk-star-emac: fix spinlock recursion issues on rx/tx poll
Date: Wed,  7 May 2025 20:39:30 +0200
Message-ID: <20250507183824.406102173@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit 6fe0866014486736cc3ba1c6fd4606d3dbe55c9c ]

Use spin_lock_irqsave and spin_unlock_irqrestore instead of spin_lock
and spin_unlock in mtk_star_emac driver to avoid spinlock recursion
occurrence that can happen when enabling the DMA interrupts again in
rx/tx poll.

```
BUG: spinlock recursion on CPU#0, swapper/0/0
 lock: 0xffff00000db9cf20, .magic: dead4ead, .owner: swapper/0/0,
    .owner_cpu: 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
    6.15.0-rc2-next-20250417-00001-gf6a27738686c-dirty #28 PREEMPT
Hardware name: MediaTek MT8365 Open Platform EVK (DT)
Call trace:
 show_stack+0x18/0x24 (C)
 dump_stack_lvl+0x60/0x80
 dump_stack+0x18/0x24
 spin_dump+0x78/0x88
 do_raw_spin_lock+0x11c/0x120
 _raw_spin_lock+0x20/0x2c
 mtk_star_handle_irq+0xc0/0x22c [mtk_star_emac]
 __handle_irq_event_percpu+0x48/0x140
 handle_irq_event+0x4c/0xb0
 handle_fasteoi_irq+0xa0/0x1bc
 handle_irq_desc+0x34/0x58
 generic_handle_domain_irq+0x1c/0x28
 gic_handle_irq+0x4c/0x120
 do_interrupt_handler+0x50/0x84
 el1_interrupt+0x34/0x68
 el1h_64_irq_handler+0x18/0x24
 el1h_64_irq+0x6c/0x70
 regmap_mmio_read32le+0xc/0x20 (P)
 _regmap_bus_reg_read+0x6c/0xac
 _regmap_read+0x60/0xdc
 regmap_read+0x4c/0x80
 mtk_star_rx_poll+0x2f4/0x39c [mtk_star_emac]
 __napi_poll+0x38/0x188
 net_rx_action+0x164/0x2c0
 handle_softirqs+0x100/0x244
 __do_softirq+0x14/0x20
 ____do_softirq+0x10/0x20
 call_on_irq_stack+0x24/0x64
 do_softirq_own_stack+0x1c/0x40
 __irq_exit_rcu+0xd4/0x10c
 irq_exit_rcu+0x10/0x1c
 el1_interrupt+0x38/0x68
 el1h_64_irq_handler+0x18/0x24
 el1h_64_irq+0x6c/0x70
 cpuidle_enter_state+0xac/0x320 (P)
 cpuidle_enter+0x38/0x50
 do_idle+0x1e4/0x260
 cpu_startup_entry+0x34/0x3c
 rest_init+0xdc/0xe0
 console_on_rootfs+0x0/0x6c
 __primary_switched+0x88/0x90
```

Fixes: 0a8bd81fd6aa ("net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://patch.msgid.link/20250424-mtk_star_emac-fix-spinlock-recursion-issue-v2-1-f3fde2e529d8@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 25989c79c92e6..47a00e02365a2 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1163,6 +1163,7 @@ static int mtk_star_tx_poll(struct napi_struct *napi, int budget)
 	struct net_device *ndev = priv->ndev;
 	unsigned int head = ring->head;
 	unsigned int entry = ring->tail;
+	unsigned long flags;
 
 	while (entry != head && count < (MTK_STAR_RING_NUM_DESCS - 1)) {
 		ret = mtk_star_tx_complete_one(priv);
@@ -1182,9 +1183,9 @@ static int mtk_star_tx_poll(struct napi_struct *napi, int budget)
 		netif_wake_queue(ndev);
 
 	if (napi_complete(napi)) {
-		spin_lock(&priv->lock);
+		spin_lock_irqsave(&priv->lock, flags);
 		mtk_star_enable_dma_irq(priv, false, true);
-		spin_unlock(&priv->lock);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 	return 0;
@@ -1341,6 +1342,7 @@ static int mtk_star_rx(struct mtk_star_priv *priv, int budget)
 static int mtk_star_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct mtk_star_priv *priv;
+	unsigned long flags;
 	int work_done = 0;
 
 	priv = container_of(napi, struct mtk_star_priv, rx_napi);
@@ -1348,9 +1350,9 @@ static int mtk_star_rx_poll(struct napi_struct *napi, int budget)
 	work_done = mtk_star_rx(priv, budget);
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
-		spin_lock(&priv->lock);
+		spin_lock_irqsave(&priv->lock, flags);
 		mtk_star_enable_dma_irq(priv, true, false);
-		spin_unlock(&priv->lock);
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
 	return work_done;
-- 
2.39.5



