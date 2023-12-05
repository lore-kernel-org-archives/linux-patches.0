Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F296FB1;
	Tue,  5 Dec 2023 03:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIaixxcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633A4C433C8;
	Tue,  5 Dec 2023 03:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747090;
	bh=ruBkwq5cyO+2yrjFx+u7WTagxQ5U214yYfhwUpKWk/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIaixxcIvt+izc/nV+aOS/lydIDwpd8VWV/cCJ7WjAnYBC+v4kR2vTI9U/RHmJ2xo
	 uRyLgAG8CQm++iUNB2hmqFquXSuqXqsDKMHjdrQCbUERdCW7lfohrNrQfMx/X/jxDs
	 PpPFbJWx2GVfPX98mVWhg0Fj9RiM72+oiOik/CBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Stanley Chang <stanley_chang@realtek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/107] USB: xhci-plat: fix legacy PHY double init
Date: Tue,  5 Dec 2023 12:16:30 +0900
Message-ID: <20231205031534.809645446@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 16b7e0cccb243033de4406ffb4d892365041a1e7 ]

Commits 7b8ef22ea547 ("usb: xhci: plat: Add USB phy support") and
9134c1fd0503 ("usb: xhci: plat: Add USB 3.0 phy support") added support
for looking up legacy PHYs from the sysdev devicetree node and
initialising them.

This broke drivers such as dwc3 which manages PHYs themself as the PHYs
would now be initialised twice, something which specifically can lead to
resources being left enabled during suspend (e.g. with the
usb_phy_generic PHY driver).

As the dwc3 driver uses driver-name matching for the xhci platform
device, fix this by only looking up and initialising PHYs for devices
that have been matched using OF.

Note that checking that the platform device has a devicetree node would
currently be sufficient, but that could lead to subtle breakages in case
anyone ever tries to reuse an ancestor's node.

Fixes: 7b8ef22ea547 ("usb: xhci: plat: Add USB phy support")
Fixes: 9134c1fd0503 ("usb: xhci: plat: Add USB 3.0 phy support")
Cc: stable@vger.kernel.org      # 4.1
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Stanley Chang <stanley_chang@realtek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Tested-by: Stanley Chang <stanley_chang@realtek.com>
Link: https://lore.kernel.org/r/20231103164323.14294-1-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index c9a101f0e8d01..c9438dc56f5fc 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -184,7 +184,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	int			ret;
 	int			irq;
 	struct xhci_plat_priv	*priv = NULL;
-
+	bool			of_match;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -305,16 +305,23 @@ static int xhci_plat_probe(struct platform_device *pdev)
 					 &xhci->imod_interval);
 	}
 
-	hcd->usb_phy = devm_usb_get_phy_by_phandle(sysdev, "usb-phy", 0);
-	if (IS_ERR(hcd->usb_phy)) {
-		ret = PTR_ERR(hcd->usb_phy);
-		if (ret == -EPROBE_DEFER)
-			goto disable_clk;
-		hcd->usb_phy = NULL;
-	} else {
-		ret = usb_phy_init(hcd->usb_phy);
-		if (ret)
-			goto disable_clk;
+	/*
+	 * Drivers such as dwc3 manages PHYs themself (and rely on driver name
+	 * matching for the xhci platform device).
+	 */
+	of_match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
+	if (of_match) {
+		hcd->usb_phy = devm_usb_get_phy_by_phandle(sysdev, "usb-phy", 0);
+		if (IS_ERR(hcd->usb_phy)) {
+			ret = PTR_ERR(hcd->usb_phy);
+			if (ret == -EPROBE_DEFER)
+				goto disable_clk;
+			hcd->usb_phy = NULL;
+		} else {
+			ret = usb_phy_init(hcd->usb_phy);
+			if (ret)
+				goto disable_clk;
+		}
 	}
 
 	hcd->tpl_support = of_usb_host_tpl_support(sysdev->of_node);
-- 
2.42.0



