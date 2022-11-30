Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4618179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA38FC433C1;
	Wed, 30 Nov 2022 18:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833043;
	bh=aMN0ODm9/+ic3zIBhwAGdEfUsgdV3cDgwPG4ESolaJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrhOYyM7RT2xpoi/tncxppWxcZOw3y7YmDeHtoJAu6ZsYiwkEqliryLX483tBRZ55
	 1+hYkGNekL0D2a567uH787HV2YGdHsAw2nxIWsXTz4cVPLLktBtasEOH2rQ+F6ERtV
	 5JEXowJmWuCqGO/fPVWUd7Ps3Hs/HW6ERNnqO1dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Cooper <alcooperx@gmail.com>,
	Kamal Dasu <kdasu.kdev@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/162] mmc: sdhci-brcmstb: Enable Clock Gating to save power
Date: Wed, 30 Nov 2022 19:23:04 +0100
Message-Id: <20221130180531.282875249@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Cooper <alcooperx@gmail.com>

[ Upstream commit 6bcc55fe648b860ef0c2b8dc23adc05bcddb93c2 ]

Enabling this feature will allow the controller to stop the bus
clock when the bus is idle. The feature is not part of the standard
and is unique to newer Arasan cores and is enabled with a bit in a
vendor specific register. This feature will only be enabled for
non-removable devices because they don't switch the voltage and
clock gating breaks SD Card volatge switching.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20220427180853.35970-3-kdasu.kdev@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 56baa208f910 ("mmc: sdhci-brcmstb: Fix SDHCI_RESET_ALL for CQHCI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-brcmstb.c | 35 +++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index 244780481193..683d0c685748 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -17,11 +17,14 @@
 
 #define SDHCI_VENDOR 0x78
 #define  SDHCI_VENDOR_ENHANCED_STRB 0x1
+#define  SDHCI_VENDOR_GATE_SDCLK_EN 0x2
 
 #define BRCMSTB_MATCH_FLAGS_NO_64BIT		BIT(0)
 #define BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT	BIT(1)
+#define BRCMSTB_MATCH_FLAGS_HAS_CLOCK_GATE	BIT(2)
 
 #define BRCMSTB_PRIV_FLAGS_HAS_CQE		BIT(0)
+#define BRCMSTB_PRIV_FLAGS_GATE_CLOCK		BIT(1)
 
 #define SDHCI_ARASAN_CQE_BASE_ADDR		0x200
 
@@ -36,6 +39,27 @@ struct brcmstb_match_priv {
 	const unsigned int flags;
 };
 
+static inline void enable_clock_gating(struct sdhci_host *host)
+{
+	u32 reg;
+
+	reg = sdhci_readl(host, SDHCI_VENDOR);
+	reg |= SDHCI_VENDOR_GATE_SDCLK_EN;
+	sdhci_writel(host, reg, SDHCI_VENDOR);
+}
+
+void brcmstb_reset(struct sdhci_host *host, u8 mask)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_brcmstb_priv *priv = sdhci_pltfm_priv(pltfm_host);
+
+	sdhci_reset(host, mask);
+
+	/* Reset will clear this, so re-enable it */
+	if (priv->flags & BRCMSTB_PRIV_FLAGS_GATE_CLOCK)
+		enable_clock_gating(host);
+}
+
 static void sdhci_brcmstb_hs400es(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
@@ -131,7 +155,7 @@ static struct sdhci_ops sdhci_brcmstb_ops = {
 static struct sdhci_ops sdhci_brcmstb_ops_7216 = {
 	.set_clock = sdhci_brcmstb_set_clock,
 	.set_bus_width = sdhci_set_bus_width,
-	.reset = sdhci_reset,
+	.reset = brcmstb_reset,
 	.set_uhs_signaling = sdhci_brcmstb_set_uhs_signaling,
 };
 
@@ -147,6 +171,7 @@ static struct brcmstb_match_priv match_priv_7445 = {
 };
 
 static const struct brcmstb_match_priv match_priv_7216 = {
+	.flags = BRCMSTB_MATCH_FLAGS_HAS_CLOCK_GATE,
 	.hs400es = sdhci_brcmstb_hs400es,
 	.ops = &sdhci_brcmstb_ops_7216,
 };
@@ -273,6 +298,14 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	if (res)
 		goto err;
 
+	/*
+	 * Automatic clock gating does not work for SD cards that may
+	 * voltage switch so only enable it for non-removable devices.
+	 */
+	if ((match_priv->flags & BRCMSTB_MATCH_FLAGS_HAS_CLOCK_GATE) &&
+	    (host->mmc->caps & MMC_CAP_NONREMOVABLE))
+		priv->flags |= BRCMSTB_PRIV_FLAGS_GATE_CLOCK;
+
 	/*
 	 * If the chip has enhanced strobe and it's enabled, add
 	 * callback
-- 
2.35.1



