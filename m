Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2374C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E31CC433D6;
	Mon, 14 Nov 2022 13:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431109;
	bh=i9ZTZcrTBfRkq3T1RAnyHKONDA8QO308Mma+nU06wJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZ5oey35E1Tc0Ob2K/MhKtmy54BCsovM6am//zTdSmqpPGnvLvWC8+npB/rznkSau
	 D5Jlc2cLXQRl6LcWZGhzVoB0fDk1Qhq/ZhvqgkGIfAridOkC93i2uI10JvPBZ5t2hV
	 c8yPouEEwGKl3FGMuzplkm2y1WAviROsi83pHmdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 102/190] stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()
Date: Mon, 14 Nov 2022 13:45:26 +0100
Message-Id: <20221114124503.159481148@linuxfoundation.org>
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

[ Upstream commit fe5b3ce8b4377e543960220f539b989a927afd8a ]

Add missing pci_disable_device() in the error path in loongson_dwmac_probe().

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 16915b4d9505..2d480bc49c51 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -97,7 +97,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 			continue;
 		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
 		if (ret)
-			return ret;
+			goto err_disable_device;
 		break;
 	}
 
@@ -108,7 +108,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	phy_mode = device_get_phy_mode(&pdev->dev);
 	if (phy_mode < 0) {
 		dev_err(&pdev->dev, "phy_mode not found\n");
-		return phy_mode;
+		ret = phy_mode;
+		goto err_disable_device;
 	}
 
 	plat->phy_interface = phy_mode;
@@ -149,6 +150,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 
 err_disable_msi:
 	pci_disable_msi(pdev);
+err_disable_device:
+	pci_disable_device(pdev);
 	return ret;
 }
 
-- 
2.35.1



