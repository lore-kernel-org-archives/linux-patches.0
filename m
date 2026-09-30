Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA5F51AFF5;
	Wed, 30 Sep 2026 18:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793043; cv=none; b=V72F7yBjJkEj8URWsbcaTuxXIc9ObzVWwY1KEjnEUcr6YM9SpcaPJO2EMX+I9QqwC+e8ZbSzaBICPa7a5bpqa9DE2pZLha8gAis5jh2eNLctlyeHSckI0uKtySCto9MIvbAolOLAjHj6pezu8YTzzMYTfAdx4bXhKLn2EE6CBwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793043; c=relaxed/simple;
	bh=lp5QGtfdxcuGDLkG+H2QsuqYsE9hPF9dQN69iZ+4rhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auIsGZVtUua73rHdKpfKB7jvjqdH/u09PyIaXEkwcoQmaZDh9gtZ/NIB19ItZ1kmv4FKhlFIvgesTwPlHWrcfhtERl337os8Mv9MiNozGb1Fx8tdOQzRDXifCIFN4ZgQJnLbc51K60bQzv2seGGw67UemMrqs8TiSHCHX7Ytoto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXJ/cN8X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXJ/cN8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5715A1F000FF;
	Wed, 30 Sep 2026 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793041;
	bh=Yd9ukynkU5xQPeY62GN5FzyaKAJvae4wMTm/Os4qrUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXJ/cN8XuiG1aIn2y7Gl0s4zW0kDJ4NWggDJ9CgHUkz8uVGcVUDV4dqE9Faci/zk6
	 Of17t8g++d9VmHr4b3Rxd+pcDr/edvK2OIG1c6W6viCMa9Zt2I3Egpzgl0vsTKCkj5
	 rWgZPO7qrjg4WrEmwWXz18XoH9tLRQ9gTy05zCwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/395] net: ethernet: mtk_eth_soc: unregister net_devices in case of probe failure
Date: Wed, 30 Sep 2026 17:25:40 +0200
Message-ID: <20260930152342.333537769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 310d1ac61a4d5a2ca8356a3a48d263acf54503ce ]

If register_netdev() fails for one of the MTK_MAX_DEVS devices in
mtk_probe(), the error path jumps to err_deinit_ppe, skipping
mtk_unreg_dev(). The previously registered net_devices are then freed by
mtk_free_dev() while still in NETREG_REGISTERED state, hitting the
BUG_ON(dev->reg_state != NETREG_UNREGISTERED).

Route the register_netdev() failure to err_unreg_netdev so the net_devices
registered so far are properly unregistered before being freed.

Fixes: 8a8a9e89f801 ("net: ethernet: mediatek: cleanup error path inside mtk_hw_init")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-mtk_eth_soc-netdev-fix-v1-1-5dac50eb65b1@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 31eee8739c575..3f43e487d8875 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4509,6 +4509,10 @@ static int mtk_unreg_dev(struct mtk_eth *eth)
 		mac = netdev_priv(eth->netdev[i]);
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_QDMA))
 			unregister_netdevice_notifier(&mac->device_notifier);
+
+		if (eth->netdev[i]->reg_state != NETREG_REGISTERED)
+			continue;
+
 		unregister_netdev(eth->netdev[i]);
 	}
 
@@ -5340,7 +5344,7 @@ static int mtk_probe(struct platform_device *pdev)
 		err = register_netdev(eth->netdev[i]);
 		if (err) {
 			dev_err(eth->dev, "error bringing up device\n");
-			goto err_deinit_ppe;
+			goto err_unreg_netdev;
 		} else
 			netif_info(eth, probe, eth->netdev[i],
 				   "mediatek frame engine at 0x%08lx, irq %d\n",
-- 
2.53.0



