Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFF1186E47;
	Mon, 12 Aug 2024 16:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478934; cv=none; b=mq68HicOywaF9YREuuebdbGTcVgsiMmjKtWTB8ZbgdjbMN/g8Klh7Xm+ht3v0dGq3yr+DZQG+d2Vv6sqFy25RZVx++3e4ZovjIU06sZiEuyc+oMaDaULgA04dJ+bQabI2YdUiSMSkWSF7pSKAtfrdMmZqNTewUGCHFXuZdcTytU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478934; c=relaxed/simple;
	bh=VPnF5fSuB9U0u2y429DBrTrzB0c9P+atH1rPV8gIxM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6UGvZFi32SO/GfoonZ0ayXGEEjQKSe25Pf/QtFtiPukmVOerUSsczywptHieDIF2Q51rLWKCO44tbFmO/HkiMwWlqtRrxxQMiHbgwBM0wthgKRH5l1LNUyBx0ONvkZN20f+fQNYLUMwxN8ECJbN2QJrzWeLEPqkkUVswlqqli4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKQfWFFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKQfWFFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F21C32782;
	Mon, 12 Aug 2024 16:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478934;
	bh=VPnF5fSuB9U0u2y429DBrTrzB0c9P+atH1rPV8gIxM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKQfWFFY6JkGMNkZ6q6hLT1XRIxLI0uW7cZf8XRgrVDhVbqwN/i9W4JI3giz22dDc
	 vIIRQBIhSlZbihIbbGWSc80XBNrxx/wkyWwduakkV8fUv5REkaiMgd5A5qlx37dveS
	 AT/l9W2uzFo29n7gZdwRsFIi5kpRJCFKEzphVxVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/150] i2c: qcom-geni: add desc struct to prepare support for I2C Master Hub variant
Date: Mon, 12 Aug 2024 18:02:42 +0200
Message-ID: <20240812160128.300198735@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 14d02fbadb5dc1cdf66078ef8430dd1cd22bfd53 ]

The I2C Master Hub is a stripped down version of the GENI Serial Engine
QUP Wrapper Controller but only supporting I2C serial engines without
DMA support.

Those I2C serial engines variants have some requirements:
- a separate "core" clock
- doesn't support DMA, thus no memory interconnect path
- fixed FIFO size not discoverable in the HW_PARAM_0 register

Add a desc struct specifying all those requirements which will be used in
a next change when adding the I2C Master Hub serial engine compatible.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 9ba48db9f77c ("i2c: qcom-geni: Add missing geni_icc_disable in geni_i2c_runtime_resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c | 50 ++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qcom-geni.c b/drivers/i2c/busses/i2c-qcom-geni.c
index 75b9c3f26bba6..67bf0a27d37ed 100644
--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -88,6 +88,7 @@ struct geni_i2c_dev {
 	int cur_wr;
 	int cur_rd;
 	spinlock_t lock;
+	struct clk *core_clk;
 	u32 clk_freq_out;
 	const struct geni_i2c_clk_fld *clk_fld;
 	int suspended;
@@ -100,6 +101,13 @@ struct geni_i2c_dev {
 	bool abort_done;
 };
 
+struct geni_i2c_desc {
+	bool has_core_clk;
+	char *icc_ddr;
+	bool no_dma_support;
+	unsigned int tx_fifo_depth;
+};
+
 struct geni_i2c_err_log {
 	int err;
 	const char *msg;
@@ -763,6 +771,7 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	u32 proto, tx_depth, fifo_disable;
 	int ret;
 	struct device *dev = &pdev->dev;
+	const struct geni_i2c_desc *desc = NULL;
 
 	gi2c = devm_kzalloc(dev, sizeof(*gi2c), GFP_KERNEL);
 	if (!gi2c)
@@ -775,6 +784,14 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	if (IS_ERR(gi2c->se.base))
 		return PTR_ERR(gi2c->se.base);
 
+	desc = device_get_match_data(&pdev->dev);
+
+	if (desc && desc->has_core_clk) {
+		gi2c->core_clk = devm_clk_get(dev, "core");
+		if (IS_ERR(gi2c->core_clk))
+			return PTR_ERR(gi2c->core_clk);
+	}
+
 	gi2c->se.clk = devm_clk_get(dev, "se");
 	if (IS_ERR(gi2c->se.clk) && !has_acpi_companion(dev))
 		return PTR_ERR(gi2c->se.clk);
@@ -818,7 +835,7 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	gi2c->adap.dev.of_node = dev->of_node;
 	strscpy(gi2c->adap.name, "Geni-I2C", sizeof(gi2c->adap.name));
 
-	ret = geni_icc_get(&gi2c->se, "qup-memory");
+	ret = geni_icc_get(&gi2c->se, desc ? desc->icc_ddr : "qup-memory");
 	if (ret)
 		return ret;
 	/*
@@ -828,12 +845,17 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	 */
 	gi2c->se.icc_paths[GENI_TO_CORE].avg_bw = GENI_DEFAULT_BW;
 	gi2c->se.icc_paths[CPU_TO_GENI].avg_bw = GENI_DEFAULT_BW;
-	gi2c->se.icc_paths[GENI_TO_DDR].avg_bw = Bps_to_icc(gi2c->clk_freq_out);
+	if (!desc || desc->icc_ddr)
+		gi2c->se.icc_paths[GENI_TO_DDR].avg_bw = Bps_to_icc(gi2c->clk_freq_out);
 
 	ret = geni_icc_set_bw(&gi2c->se);
 	if (ret)
 		return ret;
 
+	ret = clk_prepare_enable(gi2c->core_clk);
+	if (ret)
+		return ret;
+
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret) {
 		dev_err(dev, "Error turning on resources %d\n", ret);
@@ -843,10 +865,15 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	if (proto != GENI_SE_I2C) {
 		dev_err(dev, "Invalid proto %d\n", proto);
 		geni_se_resources_off(&gi2c->se);
+		clk_disable_unprepare(gi2c->core_clk);
 		return -ENXIO;
 	}
 
-	fifo_disable = readl_relaxed(gi2c->se.base + GENI_IF_DISABLE_RO) & FIFO_IF_DISABLE;
+	if (desc && desc->no_dma_support)
+		fifo_disable = false;
+	else
+		fifo_disable = readl_relaxed(gi2c->se.base + GENI_IF_DISABLE_RO) & FIFO_IF_DISABLE;
+
 	if (fifo_disable) {
 		/* FIFO is disabled, so we can only use GPI DMA */
 		gi2c->gpi_mode = true;
@@ -858,6 +885,16 @@ static int geni_i2c_probe(struct platform_device *pdev)
 	} else {
 		gi2c->gpi_mode = false;
 		tx_depth = geni_se_get_tx_fifo_depth(&gi2c->se);
+
+		/* I2C Master Hub Serial Elements doesn't have the HW_PARAM_0 register */
+		if (!tx_depth && desc)
+			tx_depth = desc->tx_fifo_depth;
+
+		if (!tx_depth) {
+			dev_err(dev, "Invalid TX FIFO depth\n");
+			return -EINVAL;
+		}
+
 		gi2c->tx_wm = tx_depth - 1;
 		geni_se_init(&gi2c->se, gi2c->tx_wm, tx_depth);
 		geni_se_config_packing(&gi2c->se, BITS_PER_BYTE,
@@ -866,6 +903,7 @@ static int geni_i2c_probe(struct platform_device *pdev)
 		dev_dbg(dev, "i2c fifo/se-dma mode. fifo depth:%d\n", tx_depth);
 	}
 
+	clk_disable_unprepare(gi2c->core_clk);
 	ret = geni_se_resources_off(&gi2c->se);
 	if (ret) {
 		dev_err(dev, "Error turning off resources %d\n", ret);
@@ -931,6 +969,8 @@ static int __maybe_unused geni_i2c_runtime_suspend(struct device *dev)
 		gi2c->suspended = 1;
 	}
 
+	clk_disable_unprepare(gi2c->core_clk);
+
 	return geni_icc_disable(&gi2c->se);
 }
 
@@ -943,6 +983,10 @@ static int __maybe_unused geni_i2c_runtime_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	ret = clk_prepare_enable(gi2c->core_clk);
+	if (ret)
+		return ret;
+
 	ret = geni_se_resources_on(&gi2c->se);
 	if (ret)
 		return ret;
-- 
2.43.0



