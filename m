Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAB71A3176;
	Wed,  5 Mar 2025 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198348; cv=none; b=ZlqSIcupgQfh7T1O9Mt1zkH2JPc/fW3vGg9ocZ2IpsV3fHlt3DNzkuJaY4a4a5jaCZjh3Ki/zFYUSuAlpOr2mScoulFn51rt0z2M9kWApVgUURbwPzdWISseD0Y83ZFiBDDiaaVugKgKarAUrKMazwBG7x5wbcc0RJYMhNeKnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198348; c=relaxed/simple;
	bh=ejM67nwXYuviOTSNaaNcANFx+hgvl46EarvTOlFL3do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7lpl9yEa7VnLfKa6w3O+XrKjAXl9DQ/9PeASkFOPX4z9Kh9IeH+dbunUZybUNb3R9Xpv51Mz1/My4pvyLfR576VWBaMihkP8cA69UolHgTDHE75rXbsGbL9oS8T9GXv2P60xI+qs9bahBBKgvrTo8hGsyVIRuL14xV3tO3Pkjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXH5sD+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXH5sD+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B5AC4CED1;
	Wed,  5 Mar 2025 18:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198348;
	bh=ejM67nwXYuviOTSNaaNcANFx+hgvl46EarvTOlFL3do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXH5sD+FKgwQSLVmklkFnyw2pW/T8Ie4x7dK/L4O5HWXv4RtPfdQJrBETGy3c2ZFN
	 p7bbomxyIgFzUKovUj4FLaDaucbu1AzQhB45/eNY5udqnO+mhjWquzNJzdhbpMSaaB
	 XosHXndPwR2Fv9x9XtgfOMyiIxveAz1M3jsDHlhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BH Hsieh <bhsieh@nvidia.com>,
	Henry Lin <henryl@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 117/150] phy: tegra: xusb: reset VBUS & ID OVERRIDE
Date: Wed,  5 Mar 2025 18:49:06 +0100
Message-ID: <20250305174508.518899768@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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


