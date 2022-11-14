Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8C24C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E553C433D6;
	Mon, 14 Nov 2022 13:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431216;
	bh=BO2nM8sBZJbnpl3ADDD8hL9fsdCAQ+dlUBO1NkiCKYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4ZxQIclzUn36i0S2Xu2wkD4X0RFWMvxarut0ng+V4G+m1THFqLQshMBK6y8Sclo1
	 tHw32k7FBbxMciUmo3wkPEBYB2bxScX12PERXz/Cb+qFekDV4WynMWQz7jKpRXGhZ4
	 K/S8jPwWTpPnTcwsUsScQV+KKP6RyYg37NDpXviA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 103/190] stmmac: dwmac-loongson: fix missing of_node_put() while module exiting
Date: Mon, 14 Nov 2022 13:45:27 +0100
Message-Id: <20221114124503.200235186@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7f94d0498f9c763f37172c08059ae91804c3075a ]

The node returned by of_get_child_by_name() with refcount decremented,
of_node_put() needs be called when finish using it. So add it in the
error path in loongson_dwmac_probe() and in loongson_dwmac_remove().

Fixes: 2ae34111fe4e ("stmmac: dwmac-loongson: fix invalid mdio_node")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-loongson.c  | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 2d480bc49c51..a25c187d3185 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -75,20 +75,24 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
 						   sizeof(*plat->mdio_bus_data),
 						   GFP_KERNEL);
-		if (!plat->mdio_bus_data)
-			return -ENOMEM;
+		if (!plat->mdio_bus_data) {
+			ret = -ENOMEM;
+			goto err_put_node;
+		}
 		plat->mdio_bus_data->needs_reset = true;
 	}
 
 	plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*plat->dma_cfg), GFP_KERNEL);
-	if (!plat->dma_cfg)
-		return -ENOMEM;
+	if (!plat->dma_cfg) {
+		ret = -ENOMEM;
+		goto err_put_node;
+	}
 
 	/* Enable pci device */
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n", __func__);
-		return ret;
+		goto err_put_node;
 	}
 
 	/* Get the base address of device */
@@ -152,13 +156,18 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	pci_disable_msi(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
+err_put_node:
+	of_node_put(plat->mdio_node);
 	return ret;
 }
 
 static void loongson_dwmac_remove(struct pci_dev *pdev)
 {
+	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
 	int i;
 
+	of_node_put(priv->plat->mdio_node);
 	stmmac_dvr_remove(&pdev->dev);
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-- 
2.35.1



