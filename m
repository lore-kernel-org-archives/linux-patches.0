Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7485F189BB0;
	Sun,  7 Sep 2025 20:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276982; cv=none; b=N6zkIyk9Wt6weF6QPsKNHpJHzqFOZ25D1XuWIaSUVIbQ5O0jSrt9TY+xh94jIeeGdhCimgLX+1LqA3Q3cz7Ypjh8Z/pW23aY7SLx/14JcyMQzdJt3roxOI+j1mGsSXB9qv8alHt4MJVYfUNE/MU0INIYzZV3ecNUJDviowdyHUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276982; c=relaxed/simple;
	bh=1jQhRe7rrwnRhEdL4PSG37YyzmtEImpzMCnxN2xk/XA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujlwbtO0ys2bIAwgub1UPQ+5/EMBsxk//481+Z0/7BYd2QZUi+AZIxwPZrAfNcSsm2taDzUjVcFN03P5UCo4vClDNHcjq0LFSMxBKWJLWGq85joP6GYA61qWvz+jeagQXs+bCKAAkjXaFJv8eSlX+Ip73Xez1DJ+uSH4+ESH1ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7QLjXxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7QLjXxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FABC4CEF0;
	Sun,  7 Sep 2025 20:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276982;
	bh=1jQhRe7rrwnRhEdL4PSG37YyzmtEImpzMCnxN2xk/XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7QLjXxPy9oPMEnao/vrucpZcaTelNt8GCsz90R1o6DE8c7i/dxYlCI8b4H/hVcqb
	 0B8apoOA4t9vtTC+OspXm56Q4TCC/uqYxNStXJwWwGlBoVsmot7QXXvaKeQw5ZsA88
	 Q7CLKug7euN2MAg8VGccxSs8MpPefPpGJhwYgjWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/175] mmc: sdhci-of-arasan: Ensure CD logic stabilization before power-up
Date: Sun,  7 Sep 2025 21:57:07 +0200
Message-ID: <20250907195615.622160841@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>

[ Upstream commit e251709aaddb3ee1e8ac1ed5e361a608a1cc92de ]

During SD suspend/resume without a full card rescan (when using
non-removable SD cards for rootfs), the SD card initialization may fail
after resume. This occurs because, after a host controller reset, the
card detect logic may take time to stabilize due to debounce logic.
Without waiting for stabilization, the host may attempt powering up the
card prematurely, leading to command timeouts during resume flow.
Add sdhci_arasan_set_power_and_bus_voltage() to wait for the card detect
stable bit before power up the card. Since the stabilization time
is not fixed, a maximum timeout of one second is used to ensure
sufficient wait time for the card detect signal to stabilize.

Signed-off-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250730060543.1735971-1-sai.krishna.potthuri@amd.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-arasan.c | 33 ++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 0cb05bdec34d5..30daa2db80b19 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -99,6 +99,9 @@
 #define HIWORD_UPDATE(val, mask, shift) \
 		((val) << (shift) | (mask) << ((shift) + 16))
 
+#define CD_STABLE_TIMEOUT_US		1000000
+#define CD_STABLE_MAX_SLEEP_US		10
+
 /**
  * struct sdhci_arasan_soc_ctl_field - Field used in sdhci_arasan_soc_ctl_map
  *
@@ -206,12 +209,15 @@ struct sdhci_arasan_data {
  * 19MHz instead
  */
 #define SDHCI_ARASAN_QUIRK_CLOCK_25_BROKEN BIT(2)
+/* Enable CD stable check before power-up */
+#define SDHCI_ARASAN_QUIRK_ENSURE_CD_STABLE	BIT(3)
 };
 
 struct sdhci_arasan_of_data {
 	const struct sdhci_arasan_soc_ctl_map *soc_ctl_map;
 	const struct sdhci_pltfm_data *pdata;
 	const struct sdhci_arasan_clk_ops *clk_ops;
+	u32 quirks;
 };
 
 static const struct sdhci_arasan_soc_ctl_map rk3399_soc_ctl_map = {
@@ -514,6 +520,24 @@ static int sdhci_arasan_voltage_switch(struct mmc_host *mmc,
 	return -EINVAL;
 }
 
+static void sdhci_arasan_set_power_and_bus_voltage(struct sdhci_host *host, unsigned char mode,
+						   unsigned short vdd)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
+	u32 reg;
+
+	/*
+	 * Ensure that the card detect logic has stabilized before powering up, this is
+	 * necessary after a host controller reset.
+	 */
+	if (mode == MMC_POWER_UP && sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_ENSURE_CD_STABLE)
+		read_poll_timeout(sdhci_readl, reg, reg & SDHCI_CD_STABLE, CD_STABLE_MAX_SLEEP_US,
+				  CD_STABLE_TIMEOUT_US, false, host, SDHCI_PRESENT_STATE);
+
+	sdhci_set_power_and_bus_voltage(host, mode, vdd);
+}
+
 static const struct sdhci_ops sdhci_arasan_ops = {
 	.set_clock = sdhci_arasan_set_clock,
 	.get_max_clock = sdhci_pltfm_clk_get_max_clock,
@@ -521,7 +545,7 @@ static const struct sdhci_ops sdhci_arasan_ops = {
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_arasan_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
-	.set_power = sdhci_set_power_and_bus_voltage,
+	.set_power = sdhci_arasan_set_power_and_bus_voltage,
 	.hw_reset = sdhci_arasan_hw_reset,
 };
 
@@ -570,7 +594,7 @@ static const struct sdhci_ops sdhci_arasan_cqe_ops = {
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_arasan_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
-	.set_power = sdhci_set_power_and_bus_voltage,
+	.set_power = sdhci_arasan_set_power_and_bus_voltage,
 	.irq = sdhci_arasan_cqhci_irq,
 };
 
@@ -1447,6 +1471,7 @@ static const struct sdhci_arasan_clk_ops zynqmp_clk_ops = {
 static struct sdhci_arasan_of_data sdhci_arasan_zynqmp_data = {
 	.pdata = &sdhci_arasan_zynqmp_pdata,
 	.clk_ops = &zynqmp_clk_ops,
+	.quirks = SDHCI_ARASAN_QUIRK_ENSURE_CD_STABLE,
 };
 
 static const struct sdhci_arasan_clk_ops versal_clk_ops = {
@@ -1457,6 +1482,7 @@ static const struct sdhci_arasan_clk_ops versal_clk_ops = {
 static struct sdhci_arasan_of_data sdhci_arasan_versal_data = {
 	.pdata = &sdhci_arasan_zynqmp_pdata,
 	.clk_ops = &versal_clk_ops,
+	.quirks = SDHCI_ARASAN_QUIRK_ENSURE_CD_STABLE,
 };
 
 static const struct sdhci_arasan_clk_ops versal_net_clk_ops = {
@@ -1467,6 +1493,7 @@ static const struct sdhci_arasan_clk_ops versal_net_clk_ops = {
 static struct sdhci_arasan_of_data sdhci_arasan_versal_net_data = {
 	.pdata = &sdhci_arasan_versal_net_pdata,
 	.clk_ops = &versal_net_clk_ops,
+	.quirks = SDHCI_ARASAN_QUIRK_ENSURE_CD_STABLE,
 };
 
 static struct sdhci_arasan_of_data intel_keembay_emmc_data = {
@@ -1945,6 +1972,8 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(np, "rockchip,rk3399-sdhci-5.1"))
 		sdhci_arasan_update_clockmultiplier(host, 0x0);
 
+	sdhci_arasan->quirks |= data->quirks;
+
 	if (of_device_is_compatible(np, "intel,keembay-sdhci-5.1-emmc") ||
 	    of_device_is_compatible(np, "intel,keembay-sdhci-5.1-sd") ||
 	    of_device_is_compatible(np, "intel,keembay-sdhci-5.1-sdio")) {
-- 
2.50.1



