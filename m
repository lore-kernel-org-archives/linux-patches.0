Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661293C0B;
	Tue, 11 Mar 2025 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707392; cv=none; b=VFGx7+jgpHDFillB1uxNA9QvfOTvAyR3JpDeLrhK9PlXEechVAQFD3ydxMAzS+Gw+5UDPIU77aM1Fh1pkoivi3B+kMOxrL0kr0VCqDzhV6SqylFv7CxYMqnZPAk8pgCb8P4UgXBWhdU+2b5w9IYoSBQ46qo/kdPAueJaJtU1JoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707392; c=relaxed/simple;
	bh=agIpXUwRQVuO9ihvxkgYZUkaU5RQQTlZYtpKZdEs9tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpmqiUfhWmHoIM+VVlpUVOYOn7BbuKWC28+00VHLphJZ3qQjcFf8smiM862Ap76X8jSp6IDmf+Ldg1Au8eYYweCa9RT3GgLVfUiV6e2q/QQp5DwK9LY4J94NETEdtK0+xxAjhj1R0EwOfftYGwTDVkM3IIGZ547NWi8whzMHVwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXTej/Vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXTej/Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F6DC4CEE9;
	Tue, 11 Mar 2025 15:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707392;
	bh=agIpXUwRQVuO9ihvxkgYZUkaU5RQQTlZYtpKZdEs9tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXTej/Vi7Xi4auYt6us8A0E8bHi7ejr3K+nBD8wDF04fvFtSmgtA5f9qWHczGAO7R
	 z0QgQAoOHu8OX9AN7RWAp85+CYLSuYJJfoCJnFHKhQrnL74ZXMB2X92pY3x1dF1RY0
	 7BLnzdn4jA0KbxjO3fu2bSc3YVhJBp70GmAD8CZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BH Hsieh <bhsieh@nvidia.com>,
	Henry Lin <henryl@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 373/462] phy: tegra: xusb: reset VBUS & ID OVERRIDE
Date: Tue, 11 Mar 2025 16:00:39 +0100
Message-ID: <20250311145813.090318108@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -510,6 +510,7 @@ static int tegra186_utmi_phy_exit(struct
 	unsigned int index = lane->index;
 	struct device *dev = padctl->dev;
 	int err;
+	u32 reg;
 
 	port = tegra_xusb_find_usb2_port(padctl, index);
 	if (!port) {
@@ -517,6 +518,16 @@ static int tegra186_utmi_phy_exit(struct
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


