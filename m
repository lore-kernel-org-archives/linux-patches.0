Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067881C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD9CC433D2;
	Wed, 28 Dec 2022 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243792;
	bh=HC0FfhjlI8kyJDOK3rKVCwY8CX6bHeXHURJ4PkLH7wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGo9S/C6v+MDeicBGuq0A2q9CjL6g2dmI8tQgonGCPPwtb4+gXdXUhhqeh6TG7QOv
	 3V0+azyQRGsS/OqkJhPzCdZh8AcybnqE/a3VO3x0YYTdITteEmnKe6Lx66g6y9ACuP
	 9c4zhLHMn9AWnyq2Mm667Yy1h6NTy/dkkM2NzvXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0589/1073] PCI: imx6: Initialize PHY before deasserting core reset
Date: Wed, 28 Dec 2022 15:36:17 +0100
Message-Id: <20221228144344.045675116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit ae6b9a65af480144da323436d90e149501ea8937 ]

When the PHY is the reference clock provider then it must be initialized
and powered on before the reset on the client is deasserted, otherwise
the link will never come up. The order was changed in cf236e0c0d59.
Restore the correct order to make the driver work again on boards where
the PHY provides the reference clock. This also changes the order for
boards where the Soc is the PHY reference clock divider, but this
shouldn't do any harm.

Link: https://lore.kernel.org/r/20221101095714.440001-1-s.hauer@pengutronix.de
Fixes: cf236e0c0d59 ("PCI: imx6: Do not hide PHY driver callbacks and refine the error handling")
Tested-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 6e5debdbc55b..6ffe95d68ae7 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -942,12 +942,6 @@ static int imx6_pcie_host_init(struct dw_pcie_rp *pp)
 		}
 	}
 
-	ret = imx6_pcie_deassert_core_reset(imx6_pcie);
-	if (ret < 0) {
-		dev_err(dev, "pcie deassert core reset failed: %d\n", ret);
-		goto err_phy_off;
-	}
-
 	if (imx6_pcie->phy) {
 		ret = phy_init(imx6_pcie->phy);
 		if (ret) {
@@ -955,6 +949,13 @@ static int imx6_pcie_host_init(struct dw_pcie_rp *pp)
 			goto err_phy_off;
 		}
 	}
+
+	ret = imx6_pcie_deassert_core_reset(imx6_pcie);
+	if (ret < 0) {
+		dev_err(dev, "pcie deassert core reset failed: %d\n", ret);
+		goto err_phy_off;
+	}
+
 	imx6_setup_phy_mpll(imx6_pcie);
 
 	return 0;
-- 
2.35.1



