Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2061267F6E;
	Tue,  8 Apr 2025 11:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113014; cv=none; b=n5AZTF8xxKmHqAcLDkNG/3lrCxlBBoqXSW9jfq1fA++F72SgRt43BZhC/3MKm/QjvpxCA7/Hx36ZLOQHzddUMbFI0DtBjD/gIVgwfvo/a7kXF6V3wyJcju/fjnd4t/sqytdgOq0lVdcFAiQU96D2Q+DnX3Aj6S0nlpG4hPPhq4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113014; c=relaxed/simple;
	bh=WbLd62lTAfpesUnw9g4u2HiRgk00Bck62cRW6MbB0IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIzQIy0Gm9oouwIIDPrqQGbpXveESriarWax73O8tlQxn/ou22Yq4leQnRiQznf/aZijzOd+IDabpsIjEY7TU9CDjdG4hhPdzXiatE3nmNpC2AuDD1JUXQf1OsLwV1LmAy5ldum+x3ZM0GA5PfoLR3u13FJegbkQzNfrMbQ8aPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKjPJ1go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKjPJ1go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DAC4CEE5;
	Tue,  8 Apr 2025 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113014;
	bh=WbLd62lTAfpesUnw9g4u2HiRgk00Bck62cRW6MbB0IY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKjPJ1go3geZVmzj8YVwJRf6xHroMzah8nnqy4mhP6pnxzwmsk3p+ob2rIv3ipL3X
	 bCHp3nnx8gOsVGt/9pk8s3NdeX7jGNdeo4YBARTObyC5I6O9UdIc+rcFEkgK///trP
	 H5uKXczRWzQrRqj3EtUE7i6h2tYNq5I7Zmipf9lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Cooper <alcooperx@gmail.com>,
	Kamal Dasu <kdasu.kdev@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 253/279] mmc: sdhci-brcmstb: Add ability to increase max clock rate for 72116b0
Date: Tue,  8 Apr 2025 12:50:36 +0200
Message-ID: <20250408104833.210619151@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

From: Kamal Dasu <kdasu.kdev@gmail.com>

[ Upstream commit 97904a59855c7ac7c613085bc6bdc550d48524ff ]

The 72116B0 has improved SDIO controllers that allow the max clock
rate to be increased from a max of 100MHz to a max of 150MHz. The
driver will need to get the clock and increase it's default rate
and override the caps register, that still indicates a max of 100MHz.
The new clock will be named "sdio_freq" in the DT node's "clock-names"
list. The driver will use a DT property, "clock-frequency", to
enable this functionality and will get the actual rate in MHz
from the property to allow various speeds to be requested.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20220520183108.47358-3-kdasu.kdev@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 723ef0e20dbb ("mmc: sdhci-brcmstb: add cqhci suspend/resume to PM ops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-brcmstb.c | 69 +++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-brcmstb.c b/drivers/mmc/host/sdhci-brcmstb.c
index 4d42b1810acea..8fb23b1228875 100644
--- a/drivers/mmc/host/sdhci-brcmstb.c
+++ b/drivers/mmc/host/sdhci-brcmstb.c
@@ -32,6 +32,8 @@
 struct sdhci_brcmstb_priv {
 	void __iomem *cfg_regs;
 	unsigned int flags;
+	struct clk *base_clk;
+	u32 base_freq_hz;
 };
 
 struct brcmstb_match_priv {
@@ -251,9 +253,11 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	struct sdhci_pltfm_host *pltfm_host;
 	const struct of_device_id *match;
 	struct sdhci_brcmstb_priv *priv;
+	u32 actual_clock_mhz;
 	struct sdhci_host *host;
 	struct resource *iomem;
 	struct clk *clk;
+	struct clk *base_clk;
 	int res;
 
 	match = of_match_node(sdhci_brcm_of_match, pdev->dev.of_node);
@@ -331,6 +335,35 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 	if (match_priv->flags & BRCMSTB_MATCH_FLAGS_BROKEN_TIMEOUT)
 		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
+	/* Change the base clock frequency if the DT property exists */
+	if (device_property_read_u32(&pdev->dev, "clock-frequency",
+				     &priv->base_freq_hz) != 0)
+		goto add_host;
+
+	base_clk = devm_clk_get_optional(&pdev->dev, "sdio_freq");
+	if (IS_ERR(base_clk)) {
+		dev_warn(&pdev->dev, "Clock for \"sdio_freq\" not found\n");
+		goto add_host;
+	}
+
+	res = clk_prepare_enable(base_clk);
+	if (res)
+		goto err;
+
+	/* set improved clock rate */
+	clk_set_rate(base_clk, priv->base_freq_hz);
+	actual_clock_mhz = clk_get_rate(base_clk) / 1000000;
+
+	host->caps &= ~SDHCI_CLOCK_V3_BASE_MASK;
+	host->caps |= (actual_clock_mhz << SDHCI_CLOCK_BASE_SHIFT);
+	/* Disable presets because they are now incorrect */
+	host->quirks2 |= SDHCI_QUIRK2_PRESET_VALUE_BROKEN;
+
+	dev_dbg(&pdev->dev, "Base Clock Frequency changed to %dMHz\n",
+		actual_clock_mhz);
+	priv->base_clk = base_clk;
+
+add_host:
 	res = sdhci_brcmstb_add_host(host, priv);
 	if (res)
 		goto err;
@@ -341,6 +374,7 @@ static int sdhci_brcmstb_probe(struct platform_device *pdev)
 err:
 	sdhci_pltfm_free(pdev);
 err_clk:
+	clk_disable_unprepare(base_clk);
 	clk_disable_unprepare(clk);
 	return res;
 }
@@ -352,11 +386,44 @@ static void sdhci_brcmstb_shutdown(struct platform_device *pdev)
 
 MODULE_DEVICE_TABLE(of, sdhci_brcm_of_match);
 
+#ifdef CONFIG_PM_SLEEP
+static int sdhci_brcmstb_suspend(struct device *dev)
+{
+	struct sdhci_host *host = dev_get_drvdata(dev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_brcmstb_priv *priv = sdhci_pltfm_priv(pltfm_host);
+
+	clk_disable_unprepare(priv->base_clk);
+	return sdhci_pltfm_suspend(dev);
+}
+
+static int sdhci_brcmstb_resume(struct device *dev)
+{
+	struct sdhci_host *host = dev_get_drvdata(dev);
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	struct sdhci_brcmstb_priv *priv = sdhci_pltfm_priv(pltfm_host);
+	int ret;
+
+	ret = sdhci_pltfm_resume(dev);
+	if (!ret && priv->base_freq_hz) {
+		ret = clk_prepare_enable(priv->base_clk);
+		if (!ret)
+			ret = clk_set_rate(priv->base_clk, priv->base_freq_hz);
+	}
+
+	return ret;
+}
+#endif
+
+static const struct dev_pm_ops sdhci_brcmstb_pmops = {
+	SET_SYSTEM_SLEEP_PM_OPS(sdhci_brcmstb_suspend, sdhci_brcmstb_resume)
+};
+
 static struct platform_driver sdhci_brcmstb_driver = {
 	.driver		= {
 		.name	= "sdhci-brcmstb",
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
-		.pm	= &sdhci_pltfm_pmops,
+		.pm	= &sdhci_brcmstb_pmops,
 		.of_match_table = of_match_ptr(sdhci_brcm_of_match),
 	},
 	.probe		= sdhci_brcmstb_probe,
-- 
2.39.5



