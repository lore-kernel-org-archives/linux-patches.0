Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ED6374EA;
	Mon, 10 Mar 2025 18:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630804; cv=none; b=Tvjox60Z1DFjuyG0ND8RKPV3BojHoyAxTWjuYF1lHncf8Hz32UVHLv1N0zZr+9qtlVHlq58ODhoUZlN/HP2lToDBjhAfyyM0j7QTx47If0rTsMrg2TfeaGUcx0GZrp/dLmpfogrngjre9PoALOq6nGX0aTvQcbAhPCSzFyaNW6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630804; c=relaxed/simple;
	bh=qTFfKgFYWw95zlOBJIw0UH/HBixA3t9QVZSb6XOSyvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fpr/POYrO2NaVtW14caVHp+Z/UokjLgavGqxvMu8wgFxbBzD2PAsuoNYUzdoRiGiShjox+vijWTNx0jkBTijiNtpCinSOk1vG8QbszK2lOFC/Ja7vJyjPuJkI4hSXDgM3ppgqw+Kuia+Bqj9gRlsdpKCqvDgv9xte/KnG76xMc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ry0DEinP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ry0DEinP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D73C4CEE5;
	Mon, 10 Mar 2025 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630804;
	bh=qTFfKgFYWw95zlOBJIw0UH/HBixA3t9QVZSb6XOSyvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ry0DEinPSFMCce7ZF8Ny1m12bChaU5sT9fHriNqvF5GyjDnRu11WAs3abW229eng+
	 R2JAoiNzektZTlxTLfVd1Gp8rUkWWZGBVqQ57F9iCxaqCLDWBzM99J7lEIiPpPas8/
	 OpG1+9QvPapsloWD34eWqqhNvTpiT2iRMijv9fxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BH Hsieh <bhsieh@nvidia.com>,
	Henry Lin <henryl@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 523/620] phy: tegra: xusb: reset VBUS & ID OVERRIDE
Date: Mon, 10 Mar 2025 18:06:09 +0100
Message-ID: <20250310170606.195998226@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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
@@ -897,6 +897,7 @@ static int tegra186_utmi_phy_exit(struct
 	unsigned int index = lane->index;
 	struct device *dev = padctl->dev;
 	int err;
+	u32 reg;
 
 	port = tegra_xusb_find_usb2_port(padctl, index);
 	if (!port) {
@@ -904,6 +905,16 @@ static int tegra186_utmi_phy_exit(struct
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
 		err = regulator_disable(port->supply);
 		if (err) {


