Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F12459FA;
	Tue, 20 May 2025 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749882; cv=none; b=IdokAdkcMZ48+dzs9CiVh0YLcLqohto4UEeDS+4Oh84AumKMfzqs5Ym3lobbloU+VRWXc8fXMGguIMbz2SkIOm/JHkX+Pierstx2idm4NStMDQQKloEyNZbPTrTwLXalGXO70n9uU//Rf7Vcs28Zv7lj5KklBHrAVPAQ0akrI8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749882; c=relaxed/simple;
	bh=nHXPgfmAB0HNeb1rEDXgMbt6PPqaCMe3jbVjJ1a5fLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0QsRctTKCoOrpr6lgSIYGqLUKcTjxPIFJRUmg71Wp7VRsTl+Vk+FbFlmL1g+EH/OBMe+h82aYBphz5J2/0EFtzDJvuKVi7ahtiLu23Qf/IG1PWbGvuYvZAzycYbQlZoHKUZv/79Bd9T5W6PS4DEP4sUBRRwaHSQZxoDaGiD/4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1llz8dBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1llz8dBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F813C4CEEA;
	Tue, 20 May 2025 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749882;
	bh=nHXPgfmAB0HNeb1rEDXgMbt6PPqaCMe3jbVjJ1a5fLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1llz8dBdd/3s9VXwDX7gtxrZgq8TLaQ3HakBICN2Ccf3Z4TriQwkGAppQzcdkiZnD
	 or22pHz4O5ojumngxUaicsrBOhZb6IXLMEi/CmKkiPUgXZtq4VnzXcgjiwnDniJy+1
	 vjqyCcFttVr1QVp7IB6cMVyn4gDfA1ufvK97auB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 083/117] phy: tegra: xusb: Use a bitmask for UTMI pad power state tracking
Date: Tue, 20 May 2025 15:50:48 +0200
Message-ID: <20250520125807.286893024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Chang <waynec@nvidia.com>

commit b47158fb42959c417ff2662075c0d46fb783d5d1 upstream.

The current implementation uses bias_pad_enable as a reference count to
manage the shared bias pad for all UTMI PHYs. However, during system
suspension with connected USB devices, multiple power-down requests for
the UTMI pad result in a mismatch in the reference count, which in turn
produces warnings such as:

[  237.762967] WARNING: CPU: 10 PID: 1618 at tegra186_utmi_pad_power_down+0x160/0x170
[  237.763103] Call trace:
[  237.763104]  tegra186_utmi_pad_power_down+0x160/0x170
[  237.763107]  tegra186_utmi_phy_power_off+0x10/0x30
[  237.763110]  phy_power_off+0x48/0x100
[  237.763113]  tegra_xusb_enter_elpg+0x204/0x500
[  237.763119]  tegra_xusb_suspend+0x48/0x140
[  237.763122]  platform_pm_suspend+0x2c/0xb0
[  237.763125]  dpm_run_callback.isra.0+0x20/0xa0
[  237.763127]  __device_suspend+0x118/0x330
[  237.763129]  dpm_suspend+0x10c/0x1f0
[  237.763130]  dpm_suspend_start+0x88/0xb0
[  237.763132]  suspend_devices_and_enter+0x120/0x500
[  237.763135]  pm_suspend+0x1ec/0x270

The root cause was traced back to the dynamic power-down changes
introduced in commit a30951d31b25 ("xhci: tegra: USB2 pad power controls"),
where the UTMI pad was being powered down without verifying its current
state. This unbalanced behavior led to discrepancies in the reference
count.

To rectify this issue, this patch replaces the single reference counter
with a bitmask, renamed to utmi_pad_enabled. Each bit in the mask
corresponds to one of the four USB2 PHYs, allowing us to track each pad's
enablement status individually.

With this change:
  - The bias pad is powered on only when the mask is clear.
  - Each UTMI pad is powered on or down based on its corresponding bit
    in the mask, preventing redundant operations.
  - The overall power state of the shared bias pad is maintained
    correctly during suspend/resume cycles.

The mutex used to prevent race conditions during UTMI pad enable/disable
operations has been moved from the tegra186_utmi_bias_pad_power_on/off
functions to the parent functions tegra186_utmi_pad_power_on/down. This
change ensures that there are no race conditions when updating the bitmask.

Cc: stable@vger.kernel.org
Fixes: a30951d31b25 ("xhci: tegra: USB2 pad power controls")
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20250408030905.990474-1-waynec@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |   44 +++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -237,6 +237,8 @@
 #define   DATA0_VAL_PD				BIT(1)
 #define   USE_XUSB_AO				BIT(4)
 
+#define TEGRA_UTMI_PAD_MAX 4
+
 #define TEGRA186_LANE(_name, _offset, _shift, _mask, _type)		\
 	{								\
 		.name = _name,						\
@@ -269,7 +271,7 @@ struct tegra186_xusb_padctl {
 
 	/* UTMI bias and tracking */
 	struct clk *usb2_trk_clk;
-	unsigned int bias_pad_enable;
+	DECLARE_BITMAP(utmi_pad_enabled, TEGRA_UTMI_PAD_MAX);
 
 	/* padctl context */
 	struct tegra186_xusb_padctl_context context;
@@ -603,12 +605,8 @@ static void tegra186_utmi_bias_pad_power
 	u32 value;
 	int err;
 
-	mutex_lock(&padctl->lock);
-
-	if (priv->bias_pad_enable++ > 0) {
-		mutex_unlock(&padctl->lock);
+	if (!bitmap_empty(priv->utmi_pad_enabled, TEGRA_UTMI_PAD_MAX))
 		return;
-	}
 
 	err = clk_prepare_enable(priv->usb2_trk_clk);
 	if (err < 0)
@@ -667,17 +665,8 @@ static void tegra186_utmi_bias_pad_power
 	struct tegra186_xusb_padctl *priv = to_tegra186_xusb_padctl(padctl);
 	u32 value;
 
-	mutex_lock(&padctl->lock);
-
-	if (WARN_ON(priv->bias_pad_enable == 0)) {
-		mutex_unlock(&padctl->lock);
-		return;
-	}
-
-	if (--priv->bias_pad_enable > 0) {
-		mutex_unlock(&padctl->lock);
+	if (!bitmap_empty(priv->utmi_pad_enabled, TEGRA_UTMI_PAD_MAX))
 		return;
-	}
 
 	value = padctl_readl(padctl, XUSB_PADCTL_USB2_BIAS_PAD_CTL1);
 	value |= USB2_PD_TRK;
@@ -690,13 +679,13 @@ static void tegra186_utmi_bias_pad_power
 		clk_disable_unprepare(priv->usb2_trk_clk);
 	}
 
-	mutex_unlock(&padctl->lock);
 }
 
 static void tegra186_utmi_pad_power_on(struct phy *phy)
 {
 	struct tegra_xusb_lane *lane = phy_get_drvdata(phy);
 	struct tegra_xusb_padctl *padctl = lane->pad->padctl;
+	struct tegra186_xusb_padctl *priv = to_tegra186_xusb_padctl(padctl);
 	struct tegra_xusb_usb2_port *port;
 	struct device *dev = padctl->dev;
 	unsigned int index = lane->index;
@@ -705,9 +694,16 @@ static void tegra186_utmi_pad_power_on(s
 	if (!phy)
 		return;
 
+	mutex_lock(&padctl->lock);
+	if (test_bit(index, priv->utmi_pad_enabled)) {
+		mutex_unlock(&padctl->lock);
+		return;
+	}
+
 	port = tegra_xusb_find_usb2_port(padctl, index);
 	if (!port) {
 		dev_err(dev, "no port found for USB2 lane %u\n", index);
+		mutex_unlock(&padctl->lock);
 		return;
 	}
 
@@ -724,18 +720,28 @@ static void tegra186_utmi_pad_power_on(s
 	value = padctl_readl(padctl, XUSB_PADCTL_USB2_OTG_PADX_CTL1(index));
 	value &= ~USB2_OTG_PD_DR;
 	padctl_writel(padctl, value, XUSB_PADCTL_USB2_OTG_PADX_CTL1(index));
+
+	set_bit(index, priv->utmi_pad_enabled);
+	mutex_unlock(&padctl->lock);
 }
 
 static void tegra186_utmi_pad_power_down(struct phy *phy)
 {
 	struct tegra_xusb_lane *lane = phy_get_drvdata(phy);
 	struct tegra_xusb_padctl *padctl = lane->pad->padctl;
+	struct tegra186_xusb_padctl *priv = to_tegra186_xusb_padctl(padctl);
 	unsigned int index = lane->index;
 	u32 value;
 
 	if (!phy)
 		return;
 
+	mutex_lock(&padctl->lock);
+	if (!test_bit(index, priv->utmi_pad_enabled)) {
+		mutex_unlock(&padctl->lock);
+		return;
+	}
+
 	dev_dbg(padctl->dev, "power down UTMI pad %u\n", index);
 
 	value = padctl_readl(padctl, XUSB_PADCTL_USB2_OTG_PADX_CTL0(index));
@@ -748,7 +754,11 @@ static void tegra186_utmi_pad_power_down
 
 	udelay(2);
 
+	clear_bit(index, priv->utmi_pad_enabled);
+
 	tegra186_utmi_bias_pad_power_off(padctl);
+
+	mutex_unlock(&padctl->lock);
 }
 
 static int tegra186_xusb_padctl_vbus_override(struct tegra_xusb_padctl *padctl,


