Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902811F667C;
	Tue, 21 Jan 2025 18:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482988; cv=none; b=Xuq3zBGdiT8XjBz4lAGMs2e4ztKYQFvo7azKRAarFlSJSSANhxeO0WdGOrh86dHdevox3g/hzzU+T/McDJBClQzML2T4v5aWr23q4iY5k47UzqdhhUmjAJVZnzk+25Uhia0Wny6l2WoWmVqyZaacXLUJkt4bJ/3TAw241wzwavA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482988; c=relaxed/simple;
	bh=yzPo/8TVQEEXBE1OmG5i41Oi70k1erWmladbmNNvw1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhVYpTQXx3/hdsj5T55zKGyhCVTRV5vTGyVuHB4F3wkPDJD+GQjNMJTVvrS3xl6+J+3TwnHjun2+wXgd/RxpBIgXkBZhNRLixT4G3RD2Y9YTuTDBgN1cZMAm6aVPa5sEjO2b2KfsrCemx1dMeinWDVOpEaWdill60t8XUUkdev8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FytNX8dY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FytNX8dY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAB1C4CEDF;
	Tue, 21 Jan 2025 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482988;
	bh=yzPo/8TVQEEXBE1OmG5i41Oi70k1erWmladbmNNvw1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FytNX8dYpvpIScpcTLJarfGy9uih/QCT1qko/p/yjnaYLmYf3Ys6t+PtU4B8PQBR3
	 Dn2lc1yi4gWPsTonwDyaOvCBN+VOTzevMoPUXlqbVivljBD3jzVkOH87xNxqmDP3ys
	 Y9PX2jC5FUu/Vh4NhFhYz9zCS+rvmvOvBU7fCygc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 078/127] phy: usb: Fix clock imbalance for suspend/resume
Date: Tue, 21 Jan 2025 18:52:30 +0100
Message-ID: <20250121174532.666823195@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

From: Justin Chen <justinpopo6@gmail.com>

commit 8484199c09347bdd5d81ee8a2bc530850f900797 upstream.

We should be disabling clocks when wake from USB is not needed. Since
this wasn't done, we had a clock imbalance since clocks were always
being enabled on resume.

Fixes: ae532b2b7aa5 ("phy: usb: Add "wake on" functionality for newer Synopsis XHCI controllers")
Fixes: b0c0b66c0b43 ("phy: usb: Add support for wake and USB low power mode for 7211 S2/S5")
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/1665005418-15807-7-git-send-email-justinpopo6@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c |    2 --
 drivers/phy/broadcom/phy-brcm-usb-init.h          |    1 -
 drivers/phy/broadcom/phy-brcm-usb.c               |    8 +++++---
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
+++ b/drivers/phy/broadcom/phy-brcm-usb-init-synopsys.c
@@ -430,7 +430,6 @@ void brcm_usb_dvr_init_7216(struct brcm_
 
 	params->family_name = "7216";
 	params->ops = &bcm7216_ops;
-	params->suspend_with_clocks = true;
 }
 
 void brcm_usb_dvr_init_7211b0(struct brcm_usb_init_params *params)
@@ -440,5 +439,4 @@ void brcm_usb_dvr_init_7211b0(struct brc
 
 	params->family_name = "7211";
 	params->ops = &bcm7211b0_ops;
-	params->suspend_with_clocks = true;
 }
--- a/drivers/phy/broadcom/phy-brcm-usb-init.h
+++ b/drivers/phy/broadcom/phy-brcm-usb-init.h
@@ -61,7 +61,6 @@ struct  brcm_usb_init_params {
 	const struct brcm_usb_init_ops *ops;
 	struct regmap *syscon_piarbctl;
 	bool wake_enabled;
-	bool suspend_with_clocks;
 };
 
 void brcm_usb_dvr_init_4908(struct brcm_usb_init_params *params);
--- a/drivers/phy/broadcom/phy-brcm-usb.c
+++ b/drivers/phy/broadcom/phy-brcm-usb.c
@@ -598,7 +598,7 @@ static int brcm_usb_phy_suspend(struct d
 		 * and newer XHCI->2.0-clks/3.0-clks.
 		 */
 
-		if (!priv->ini.suspend_with_clocks) {
+		if (!priv->ini.wake_enabled) {
 			if (priv->phys[BRCM_USB_PHY_3_0].inited)
 				clk_disable_unprepare(priv->usb_30_clk);
 			if (priv->phys[BRCM_USB_PHY_2_0].inited ||
@@ -615,8 +615,10 @@ static int brcm_usb_phy_resume(struct de
 {
 	struct brcm_usb_phy_data *priv = dev_get_drvdata(dev);
 
-	clk_prepare_enable(priv->usb_20_clk);
-	clk_prepare_enable(priv->usb_30_clk);
+	if (!priv->ini.wake_enabled) {
+		clk_prepare_enable(priv->usb_20_clk);
+		clk_prepare_enable(priv->usb_30_clk);
+	}
 	brcm_usb_init_ipp(&priv->ini);
 
 	/*


