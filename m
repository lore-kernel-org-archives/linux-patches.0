Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB22EE266;
	Tue, 17 Jun 2025 16:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177868; cv=none; b=lD6OasJm54YGuGbDEf7xJNUPgSnYHFlx+xW096tFl0RQjrhDEmF3C0B0BuCFS17jL2Ovz4eJ85OljYOMwNj/ZTf9UKHgZ2AYQLR5of9P7z+Ml4FM2P6gpbkcJD7wUypKF0JhQbzoDxOMfTM5pFnYVz3ZNRfTixgF1ObGjfJawzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177868; c=relaxed/simple;
	bh=8/jLO4rak0ikUCgUhtsvBiQ/r89ghrWYezOxhOFrJiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmHoUPL5bumCEVzteSNixpHM21Ek5o/DMlZqeR5NZbruA6chPniZtlanOgNHM72ZJ+82nA9c1uo2MIeZblQAzo2m/a1n0KX+pZxDGe/DQs0Lvnsw4wgjzuo1diOegxUnrZQ1DzfZ7C9MkiD6Q+G3kGRD5BYrMbPEPDEs9KumnaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2CZ4ael; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2CZ4ael"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85173C4CEE7;
	Tue, 17 Jun 2025 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177868;
	bh=8/jLO4rak0ikUCgUhtsvBiQ/r89ghrWYezOxhOFrJiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2CZ4aelQWhjI29VWTJPLGMPB24JkvtiPZ0WDwAS6Q5rJVMo6FvtRS9gTtuFAo4TI
	 7sPj1ekiZx8yNUUnUni0Mzh4rhSzQhJdbwczBm21rd8Xdjv/d/QV/ar/+/dpi74Wot
	 QXtFNcTQEeL1jgquW1/geDjYI8H9HoL4+oEFHlKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 408/512] mmc: sdhci-of-dwcmshc: add PD workaround on RK3576
Date: Tue, 17 Jun 2025 17:26:14 +0200
Message-ID: <20250617152436.107626283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 08f959759e1e6e9c4b898c51a7d387ac3480630b ]

RK3576's power domains have a peculiar design where the PD_NVM power
domain, of which the sdhci controller is a part, seemingly does not have
idempotent runtime disable/enable. The end effect is that if PD_NVM gets
turned off by the generic power domain logic because all the devices
depending on it are suspended, then the next time the sdhci device is
unsuspended, it'll hang the SoC as soon as it tries accessing the CQHCI
registers.

RK3576's UFS support needed a new dev_pm_genpd_rpm_always_on function
added to the generic power domains API to handle what appears to be a
similar hardware design.

Use this new function to ask for the same treatment in the sdhci
controller by giving rk3576 its own platform data with its own postinit
function. The benefit of doing this instead of marking the power domains
always on in the power domain core is that we only do this if we know
the platform we're running on actually uses the sdhci controller. For
others, keeping PD_NVM always on would be a waste, as they won't run
into this specific issue. The only other IP in PD_NVM that could be
affected is FSPI0. If it gets a mainline driver, it will probably want
to do the same thing.

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Fixes: cfee1b507758 ("pmdomain: rockchip: Add support for RK3576 SoC")
Cc: <stable@vger.kernel.org> # v6.15+
Link: https://lore.kernel.org/r/20250423-rk3576-emmc-fix-v3-1-0bf80e29967f@collabora.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c | 40 +++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index 8fd80dac11bfd..bf29aad082a19 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
 #include <linux/sizes.h>
@@ -787,6 +788,29 @@ static void dwcmshc_rk35xx_postinit(struct sdhci_host *host, struct dwcmshc_priv
 	}
 }
 
+static void dwcmshc_rk3576_postinit(struct sdhci_host *host, struct dwcmshc_priv *dwc_priv)
+{
+	struct device *dev = mmc_dev(host->mmc);
+	int ret;
+
+	/*
+	 * This works around the design of the RK3576's power domains, which
+	 * makes the PD_NVM power domain, which the sdhci controller on the
+	 * RK3576 is in, never come back the same way once it's run-time
+	 * suspended once. This can happen during early kernel boot if no driver
+	 * is using either PD_NVM or its child power domain PD_SDGMAC for a
+	 * short moment, leading to it being turned off to save power. By
+	 * keeping it on, sdhci suspending won't lead to PD_NVM becoming a
+	 * candidate for getting turned off.
+	 */
+	ret = dev_pm_genpd_rpm_always_on(dev, true);
+	if (ret && ret != -EOPNOTSUPP)
+		dev_warn(dev, "failed to set PD rpm always on, SoC may hang later: %pe\n",
+			 ERR_PTR(ret));
+
+	dwcmshc_rk35xx_postinit(host, dwc_priv);
+}
+
 static int th1520_execute_tuning(struct sdhci_host *host, u32 opcode)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
@@ -1218,6 +1242,18 @@ static const struct dwcmshc_pltfm_data sdhci_dwcmshc_rk35xx_pdata = {
 	.postinit = dwcmshc_rk35xx_postinit,
 };
 
+static const struct dwcmshc_pltfm_data sdhci_dwcmshc_rk3576_pdata = {
+	.pdata = {
+		.ops = &sdhci_dwcmshc_rk35xx_ops,
+		.quirks = SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
+			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
+		.quirks2 = SDHCI_QUIRK2_PRESET_VALUE_BROKEN |
+			   SDHCI_QUIRK2_CLOCK_DIV_ZERO_BROKEN,
+	},
+	.init = dwcmshc_rk35xx_init,
+	.postinit = dwcmshc_rk3576_postinit,
+};
+
 static const struct dwcmshc_pltfm_data sdhci_dwcmshc_th1520_pdata = {
 	.pdata = {
 		.ops = &sdhci_dwcmshc_th1520_ops,
@@ -1316,6 +1352,10 @@ static const struct of_device_id sdhci_dwcmshc_dt_ids[] = {
 		.compatible = "rockchip,rk3588-dwcmshc",
 		.data = &sdhci_dwcmshc_rk35xx_pdata,
 	},
+	{
+		.compatible = "rockchip,rk3576-dwcmshc",
+		.data = &sdhci_dwcmshc_rk3576_pdata,
+	},
 	{
 		.compatible = "rockchip,rk3568-dwcmshc",
 		.data = &sdhci_dwcmshc_rk35xx_pdata,
-- 
2.39.5



