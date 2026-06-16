Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB862F12AE;
	Tue, 16 Jun 2026 17:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632673; cv=none; b=CjE/BrXRRQ4VQSWAMzOfhKD2JKfLyZqqHezg8mijX5p4MV+dH/KGPMgW3QgHWdgv1lzmDo/tUMBruh+3EaKtWkIU0CfdR76A1Wvw217wGmgiw2o9iGq4wngTDTJBGqpR2AeHteg5BaI+DxE/32tNUeZX1GQqXy9BPn6aw8AKrpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632673; c=relaxed/simple;
	bh=QuSrIl5+D8L0oAm+zHt6rVELA7Bo925QCVJGd7GyQcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mtad7weghdo/++Va0pBMCtaFQ6QOIFLrUJprioCNSlpGfRwnS8h/bRQajezKhFBCMWXxyjVDIwJ3nU7EDy3swwdmr5jliRom38quh673LawyrZHCbGjltVot74ANq26hl5uOHmcfInEKMXKMqutwmS03waNoqyqEjhDj4oX/JOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNgIOGjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNgIOGjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8C11F000E9;
	Tue, 16 Jun 2026 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632672;
	bh=uKCwEEFoWhAlnUHCu9kcGkBJnwoq+LqRlKJ1mtqQUP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNgIOGjIhHur/D+Xk8dZy3bVFBzBZuiKHxxp4A5yQM1JCqSA9XTKtt053OZ7LEnuO
	 ospj9pRPGvxL6K4HkSA8fnJckmHxQ8nolbn8487QyOy0hzsTwBOLLVoBXYz31l+7uO
	 IR8XRVy95bJl+TI9bB9YIKzx8at/jL0fYkhIyVqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Wei-Cheng Chen <weichengc@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 456/522] phy: tegra: xusb: Fix per-pad high-speed termination calibration
Date: Tue, 16 Jun 2026 20:30:03 +0530
Message-ID: <20260616145147.234732818@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wayne Chang <waynec@nvidia.com>

[ Upstream commit da110228b54f2e2143d97ea7151e0dc22e539d67 ]

The existing code reads a single hs_term_range_adj value from bit field
[10:7] of FUSE_SKU_CALIB_0 and applies it to all USB2 pads uniformly.
However, on SoCs that support per-pad termination, each pad has its own
hs_term_range_adj field: pad 0 in FUSE_SKU_CALIB_0[10:7], and pads 1-3
in FUSE_USB_CALIB_EXT_0 at bit offsets [8:5], [12:9], and [16:13]
respectively.

Fix the calibration by reading per-pad values from the appropriate fuse
registers. For SoCs that do not support per-pad termination, replicate
pad 0's value to all pads to maintain existing behavior.

Add a has_per_pad_term flag to the SoC data to indicate whether per-pad
termination values are available in FUSE_USB_CALIB_EXT_0.

Fixes: 1ef535c6ba8e ("phy: tegra: xusb: Add Tegra194 support")
Cc: stable@vger.kernel.org
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Signed-off-by: Wei-Cheng Chen <weichengc@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260504033305.2283145-1-weichengc@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/tegra/xusb-tegra186.c |   32 +++++++++++++++++++++++++-------
 drivers/phy/tegra/xusb.h          |    1 +
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/phy/tegra/xusb-tegra186.c
+++ b/drivers/phy/tegra/xusb-tegra186.c
@@ -20,8 +20,8 @@
 /* FUSE USB_CALIB registers */
 #define HS_CURR_LEVEL_PADX_SHIFT(x)	((x) ? (11 + (x - 1) * 6) : 0)
 #define HS_CURR_LEVEL_PAD_MASK		0x3f
-#define HS_TERM_RANGE_ADJ_SHIFT		7
-#define HS_TERM_RANGE_ADJ_MASK		0xf
+#define HS_TERM_RANGE_ADJ_PADX_SHIFT(x)	((x) ? (5 + (x - 1) * 4) : 7)
+#define HS_TERM_RANGE_ADJ_PAD_MASK	0xf
 #define HS_SQUELCH_SHIFT		29
 #define HS_SQUELCH_MASK			0x7
 
@@ -238,7 +238,7 @@
 struct tegra_xusb_fuse_calibration {
 	u32 *hs_curr_level;
 	u32 hs_squelch;
-	u32 hs_term_range_adj;
+	u32 *hs_term_range_adj;
 	u32 rpd_ctrl;
 };
 
@@ -868,7 +868,7 @@ static int tegra186_utmi_phy_power_on(st
 
 	value = padctl_readl(padctl, XUSB_PADCTL_USB2_OTG_PADX_CTL1(index));
 	value &= ~TERM_RANGE_ADJ(~0);
-	value |= TERM_RANGE_ADJ(priv->calib.hs_term_range_adj);
+	value |= TERM_RANGE_ADJ(priv->calib.hs_term_range_adj[index]);
 	value &= ~RPD_CTRL(~0);
 	value |= RPD_CTRL(priv->calib.rpd_ctrl);
 	padctl_writel(padctl, value, XUSB_PADCTL_USB2_OTG_PADX_CTL1(index));
@@ -1403,17 +1403,23 @@ static const char * const tegra186_usb3_
 static int
 tegra186_xusb_read_fuse_calibration(struct tegra186_xusb_padctl *padctl)
 {
+	const struct tegra_xusb_padctl_soc *soc = padctl->base.soc;
 	struct device *dev = padctl->base.dev;
 	unsigned int i, count;
 	u32 value, *level;
+	u32 *hs_term_range_adj;
 	int err;
 
-	count = padctl->base.soc->ports.usb2.count;
+	count = soc->ports.usb2.count;
 
 	level = devm_kcalloc(dev, count, sizeof(u32), GFP_KERNEL);
 	if (!level)
 		return -ENOMEM;
 
+	hs_term_range_adj = devm_kcalloc(dev, count, sizeof(u32), GFP_KERNEL);
+	if (!hs_term_range_adj)
+		return -ENOMEM;
+
 	err = tegra_fuse_readl(TEGRA_FUSE_SKU_CALIB_0, &value);
 	if (err)
 		return dev_err_probe(dev, err,
@@ -1429,8 +1435,8 @@ tegra186_xusb_read_fuse_calibration(stru
 
 	padctl->calib.hs_squelch = (value >> HS_SQUELCH_SHIFT) &
 					HS_SQUELCH_MASK;
-	padctl->calib.hs_term_range_adj = (value >> HS_TERM_RANGE_ADJ_SHIFT) &
-						HS_TERM_RANGE_ADJ_MASK;
+	hs_term_range_adj[0] = (value >> HS_TERM_RANGE_ADJ_PADX_SHIFT(0)) &
+				HS_TERM_RANGE_ADJ_PAD_MASK;
 
 	err = tegra_fuse_readl(TEGRA_FUSE_USB_CALIB_EXT_0, &value);
 	if (err) {
@@ -1442,6 +1448,17 @@ tegra186_xusb_read_fuse_calibration(stru
 
 	padctl->calib.rpd_ctrl = (value >> RPD_CTRL_SHIFT) & RPD_CTRL_MASK;
 
+	for (i = 1; i < count; i++) {
+		if (soc->has_per_pad_term)
+			hs_term_range_adj[i] =
+				(value >> HS_TERM_RANGE_ADJ_PADX_SHIFT(i)) &
+				HS_TERM_RANGE_ADJ_PAD_MASK;
+		else
+			hs_term_range_adj[i] = hs_term_range_adj[0];
+	}
+
+	padctl->calib.hs_term_range_adj = hs_term_range_adj;
+
 	return 0;
 }
 
@@ -1645,6 +1662,7 @@ const struct tegra_xusb_padctl_soc tegra
 	.supply_names = tegra194_xusb_padctl_supply_names,
 	.num_supplies = ARRAY_SIZE(tegra194_xusb_padctl_supply_names),
 	.supports_gen2 = true,
+	.has_per_pad_term = true,
 };
 EXPORT_SYMBOL_GPL(tegra194_xusb_padctl_soc);
 #endif
--- a/drivers/phy/tegra/xusb.h
+++ b/drivers/phy/tegra/xusb.h
@@ -433,6 +433,7 @@ struct tegra_xusb_padctl_soc {
 	unsigned int num_supplies;
 	bool supports_gen2;
 	bool need_fake_usb3_port;
+	bool has_per_pad_term;
 };
 
 struct tegra_xusb_padctl {


