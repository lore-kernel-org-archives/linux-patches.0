Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E4C3DD51C;
	Tue, 16 Jun 2026 19:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636757; cv=none; b=qP/TVVuCZ8QZh6HI6ldFWb5MHs/Om3hcJHeBcwBGlKAqzmj0J1VaFK96f8I3z+yCvN6Q31ZmrZXVW1E6zHaHQ94GAiWPJoAKuaiUcXiqooNEV3bpDIrSV4ybm4jm5LY7dnFBtSAlINUFsR1A1+lW2hvuaPaqm7OVM4LkSTfcQAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636757; c=relaxed/simple;
	bh=wXzzLAbWFLdLShVNfaSkTM1bQCgR8qUhUtlL6aQSv4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnvfEOC1yE39jju3uWCyVbyhbc4xsNEJ7S3Bo71x2q+Gm+afH1rKlxPG7H0E+D9uVCC+j6YeGNbcvcQAMQPfj54QZbXGE7VItrdqlYT6z++J27zj846SaVuixDvwc1/mLBFDXi+QRvWGilj7Sjr2f7eItz8+rbfi0Xa+0DEjoH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APx0ZfjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APx0ZfjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7360C1F000E9;
	Tue, 16 Jun 2026 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636756;
	bh=OFWKOv1mU9PiytBb6L6Y1depqJmzWSLl9qCNMF8waJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APx0ZfjKMN+iy6qNmNLT1hhlF8v+vYdTN7XsIL470h4XZAHrs4zRg5rV/Xeorm3m7
	 3h8Bd4JNEmlptHDHmxd9ewe8uCkvZpW2Q2THcf3BZXXBZU8QRegWJsEqAjIG02WJzV
	 AhOnEbZg5YmoqNm+HQuzolao+uw5aoe/ZsAFbED8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Chang <waynec@nvidia.com>,
	Wei-Cheng Chen <weichengc@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/342] phy: tegra: xusb: Fix per-pad high-speed termination calibration
Date: Tue, 16 Jun 2026 20:29:56 +0530
Message-ID: <20260616145102.409164909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -127,7 +127,7 @@
 struct tegra_xusb_fuse_calibration {
 	u32 *hs_curr_level;
 	u32 hs_squelch;
-	u32 hs_term_range_adj;
+	u32 *hs_term_range_adj;
 	u32 rpd_ctrl;
 };
 
@@ -477,7 +477,7 @@ static int tegra186_utmi_phy_power_on(st
 
 	value = padctl_readl(padctl, XUSB_PADCTL_USB2_OTG_PADX_CTL1(index));
 	value &= ~TERM_RANGE_ADJ(~0);
-	value |= TERM_RANGE_ADJ(priv->calib.hs_term_range_adj);
+	value |= TERM_RANGE_ADJ(priv->calib.hs_term_range_adj[index]);
 	value &= ~RPD_CTRL(~0);
 	value |= RPD_CTRL(priv->calib.rpd_ctrl);
 	padctl_writel(padctl, value, XUSB_PADCTL_USB2_OTG_PADX_CTL1(index));
@@ -895,17 +895,23 @@ static const char * const tegra186_usb3_
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
 	if (err) {
 		if (err != -EPROBE_DEFER)
@@ -924,8 +930,8 @@ tegra186_xusb_read_fuse_calibration(stru
 
 	padctl->calib.hs_squelch = (value >> HS_SQUELCH_SHIFT) &
 					HS_SQUELCH_MASK;
-	padctl->calib.hs_term_range_adj = (value >> HS_TERM_RANGE_ADJ_SHIFT) &
-						HS_TERM_RANGE_ADJ_MASK;
+	hs_term_range_adj[0] = (value >> HS_TERM_RANGE_ADJ_PADX_SHIFT(0)) &
+				HS_TERM_RANGE_ADJ_PAD_MASK;
 
 	err = tegra_fuse_readl(TEGRA_FUSE_USB_CALIB_EXT_0, &value);
 	if (err) {
@@ -937,6 +943,17 @@ tegra186_xusb_read_fuse_calibration(stru
 
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
 
@@ -1095,6 +1112,7 @@ const struct tegra_xusb_padctl_soc tegra
 	.supply_names = tegra194_xusb_padctl_supply_names,
 	.num_supplies = ARRAY_SIZE(tegra194_xusb_padctl_supply_names),
 	.supports_gen2 = true,
+	.has_per_pad_term = true,
 };
 EXPORT_SYMBOL_GPL(tegra194_xusb_padctl_soc);
 #endif
--- a/drivers/phy/tegra/xusb.h
+++ b/drivers/phy/tegra/xusb.h
@@ -415,6 +415,7 @@ struct tegra_xusb_padctl_soc {
 	unsigned int num_supplies;
 	bool supports_gen2;
 	bool need_fake_usb3_port;
+	bool has_per_pad_term;
 };
 
 struct tegra_xusb_padctl {


