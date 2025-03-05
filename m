Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B72199E89;
	Wed,  5 Mar 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198713; cv=none; b=JWjTFIiDoS7Gy9n98cGqsXHcvjuLNHiKXP1Yq406xq30dsouRhOkhCxXc9YoQooZ/9oan+Ib8h+yAyR9ZSJ/jVYV1sSue4fU7XpkHrDOH0i5jwfh7HnDWRPy1/OttkNHNJ76Tq4EyD+2FVz1aDctqTkn/m78/S4lxSYVyF9qjFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198713; c=relaxed/simple;
	bh=4BFzAOePrwlW7ulp00xLByXYbb1dRgW8V7maoWsbZ5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIGHC1uom62Y+9jxl6i6iDj4LqMPZgK86m8LaBmYEWdep3uoowPOamQT8NEeJ21ZSRSHWs/2K41hYlOjfsPWzZMsMaH/JwudfCZl0fNGHTCR1w7ArDNXGMDN1+UtJTPhAbI9Y3QTdXE6WbYygmsnI+bil4pOBOSO80tcYLz1Oss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NswrZsXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NswrZsXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346A6C4CEEB;
	Wed,  5 Mar 2025 18:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198713;
	bh=4BFzAOePrwlW7ulp00xLByXYbb1dRgW8V7maoWsbZ5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NswrZsXbyzVbdq0w9x9DzRYn2HcZeFv/NuJgIRg/u60e1t1Jg+CGe+nHekmX1VcVk
	 mm7qr2DywJ4uc6aplrDgDDVR3q3d0ERDbYvNn28S4y56i2LhLZYW6LLnl9o/ynuPOd
	 hi1oBVCzrk0HXKaiIbBWgVG51edHukcbod2H8Nq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BH Hsieh <bhsieh@nvidia.com>,
	Henry Lin <henryl@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.13 121/157] phy: tegra: xusb: reset VBUS & ID OVERRIDE
Date: Wed,  5 Mar 2025 18:49:17 +0100
Message-ID: <20250305174510.170035983@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: BH Hsieh <bhsieh@nvidia.com>

commit 55f1a5f7c97c3c92ba469e16991a09274410ceb7 upstream.

Observed VBUS_OVERRIDE & ID_OVERRIDE might be programmed
with unexpected value prior to XUSB PADCTL driver, this
could also occur in virtualization scenario.

For example, UEFI firmware programs ID_OVERRIDE=GROUNDED to set
a type-c port to host mode and keeps the value to kernel.
If the type-c port is connected a usb host, below errors can be
observed right after usb host mode driver gets probed. The errors
would keep until usb role class driver detects the type-c port
as device mode and notifies usb device mode driver to set both
ID_OVERRIDE and VBUS_OVERRIDE to correct value by XUSB PADCTL
driver.

[  173.765814] usb usb3-port2: Cannot enable. Maybe the USB cable is bad?
[  173.765837] usb usb3-port2: config error

Taking virtualization into account, asserting XUSB PADCTL
reset would break XUSB functions used by other guest OS,
hence only reset VBUS & ID OVERRIDE of the port in
utmi_phy_init.

Fixes: bbf711682cd5 ("phy: tegra: xusb: Add Tegra186 support")
Cc: stable@vger.kernel.org
Change-Id: Ic63058d4d49b4a1f8f9ab313196e20ad131cc591
Signed-off-by: BH Hsieh <bhsieh@nvidia.com>
Signed-off-by: Henry Lin <henryl@nvidia.com>
Link: https://lore.kernel.org/r/20250122105943.8057-1-henryl@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -928,6 +928,7 @@ static int tegra186_utmi_phy_init(struct
 	unsigned int index = lane->index;
 	struct device *dev = padctl->dev;
 	int err;
+	u32 reg;
 
 	port = tegra_xusb_find_usb2_port(padctl, index);
 	if (!port) {
@@ -935,6 +936,16 @@ static int tegra186_utmi_phy_init(struct
 		return -ENODEV;
 	}
 
+	if (port->mode == USB_DR_MODE_OTG ||
+	    port->mode == USB_DR_MODE_PERIPHERAL) {
+		/* reset VBUS&ID OVERRIDE */
+		reg = padctl_readl(padctl, USB2_VBUS_ID);
+		reg &= ~VBUS_OVERRIDE;
+		reg &= ~ID_OVERRIDE(~0);
+		reg |= ID_OVERRIDE_FLOATING;
+		padctl_writel(padctl, reg, USB2_VBUS_ID);
+	}
+
 	if (port->supply && port->mode == USB_DR_MODE_HOST) {
 		err = regulator_enable(port->supply);
 		if (err) {


