Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43894FB9BB;
	Tue, 13 Oct 2026 11:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892663; cv=none; b=DF9C9TZZe90QLU3/79K9HQJ8uwgXbtuItqJj6wczEb74D0eiqoxkraD+7uMjMVljZEdB3VXBZVzmAa9D0b1jGARteWmviJvGKmOSoTAZ49QJxfq6fpSGPcHT3QB/8MG9aofZ73FlWsDkSrAIypNnm7+LQSTAVTpq0dmIJuRFxxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892663; c=relaxed/simple;
	bh=jv1HsLs6dL2aE2tFYiPP92g+CoRjLMmqGxNVcmTJYxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMkTW7etZToi34XDJAgZW9y88EwjICGjvy6J5zJSUUstsjp3TVJXOb7FMOTTL2gYWw+XllQmE/ALymZiz2rjPmCyi4fTCo4ZD/9Z0e4pO0tFr7BThp5IfrU/rUBG9Q8ueoV0GreQpr1n5Js7CY+pCa3IDYzZBHdUmkydJ0AjEfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsJlyGXm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsJlyGXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C940D1F000FF;
	Tue, 13 Oct 2026 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892660;
	bh=tLJgOWKU5ZMCr/EvWF2p9zHKw4drxlGDd1YjYREyaKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsJlyGXmnWLz++CcYVwrNzmH4QRl2qnr45komaVzxuKcv2clALyUbJjFzFubLWGhV
	 crRO3TeUWu1x3twA9NfxOyvqasy1uf7rC14TczL14BI541Uz98gWiJAMCiz5JSns8B
	 KmQJgqgg72dcGE9pp4ABo3DRAl2sdLTjocBw+qqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <gaohan@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 246/281] spi: sg2044-nor: Honor SPI clock limits
Date: Tue, 13 Oct 2026 13:39:22 +0200
Message-ID: <20261013112901.117007597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <gaohan@iscas.ac.cn>

[ Upstream commit 61d44a2c07b2ad3f7db167f17ff2461ffe78441c ]

The fixed divider ignores device and operation clock limits. Calculate
the divider before each transfer so SCK does not exceed either limit.

Advertise the controller maximum speed so the SPI core supplies a default
when the device omits its maximum speed. Use the fastest divider when no
speed limit is supplied.

Fixes: de16c322eefb ("spi: sophgo: add SG2044 SPI NOR controller driver")
Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20261001-fix-sg204xspi-v2-2-014dbaf22b5e@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sg2044-nor.c | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/spi/spi-sg2044-nor.c b/drivers/spi/spi-sg2044-nor.c
index ff026ca0f7663..bc9a8ee9bce44 100644
--- a/drivers/spi/spi-sg2044-nor.c
+++ b/drivers/spi/spi-sg2044-nor.c
@@ -385,6 +385,29 @@ static ssize_t sg2044_spifmc_trans_reg(struct sg2044_spifmc *spifmc,
 	return 0;
 }
 
+static int sg2044_spifmc_set_speed(struct sg2044_spifmc *spifmc,
+				   unsigned int speed_hz)
+{
+	unsigned long rate = clk_get_rate(spifmc->clk);
+	u64 div;
+	u32 reg;
+
+	if (!rate)
+		return -EINVAL;
+
+	/* SCK = HCLK / (2 * (SckDiv + 1)); round down the resulting SCK. */
+	div = speed_hz ? DIV_ROUND_UP_ULL(rate, 2ULL * speed_hz) : 1;
+	if (div > SPIFMC_CTRL_SCK_DIV_MASK + 1)
+		return -EINVAL;
+
+	reg = readl(spifmc->io_base + SPIFMC_CTRL);
+	reg &= ~SPIFMC_CTRL_SCK_DIV_MASK;
+	reg |= div - 1;
+	writel(reg, spifmc->io_base + SPIFMC_CTRL);
+
+	return 0;
+}
+
 static int sg2044_spifmc_exec_op(struct spi_mem *mem,
 				 const struct spi_mem_op *op)
 {
@@ -395,11 +418,18 @@ static int sg2044_spifmc_exec_op(struct spi_mem *mem,
 
 	mutex_lock(&spifmc->lock);
 
+	ret = sg2044_spifmc_set_speed(spifmc, op->max_freq ?
+				    min(op->max_freq, mem->spi->max_speed_hz) :
+				    mem->spi->max_speed_hz);
+	if (ret)
+		goto out_unlock;
+
 	if (op->addr.nbytes == 0)
 		ret = sg2044_spifmc_trans_reg(spifmc, op);
 	else
 		ret = sg2044_spifmc_trans(spifmc, op);
 
+out_unlock:
 	mutex_unlock(&spifmc->lock);
 
 	return ret;
@@ -409,6 +439,10 @@ static const struct spi_controller_mem_ops sg2044_spifmc_mem_ops = {
 	.exec_op = sg2044_spifmc_exec_op,
 };
 
+static const struct spi_controller_mem_caps sg2044_spifmc_mem_caps = {
+	.per_op_freq = true,
+};
+
 static void sg2044_spifmc_init(struct sg2044_spifmc *spifmc)
 {
 	u32 tran_csr;
@@ -448,6 +482,10 @@ static int sg2044_spifmc_probe(struct platform_device *pdev)
 	if (IS_ERR(spifmc->clk))
 		return dev_err_probe(dev, PTR_ERR(spifmc->clk), "Cannot get and enable AHB clock\n");
 
+	ctrl->max_speed_hz = clk_get_rate(spifmc->clk) / 2;
+	if (!ctrl->max_speed_hz)
+		return dev_err_probe(dev, -EINVAL, "Invalid AHB clock rate\n");
+
 	spifmc->dev = &pdev->dev;
 	spifmc->ctrl = ctrl;
 
@@ -459,6 +497,7 @@ static int sg2044_spifmc_probe(struct platform_device *pdev)
 	ctrl->bits_per_word_mask = SPI_BPW_MASK(8);
 	ctrl->auto_runtime_pm = false;
 	ctrl->mem_ops = &sg2044_spifmc_mem_ops;
+	ctrl->mem_caps = &sg2044_spifmc_mem_caps;
 	ctrl->mode_bits = SPI_RX_DUAL | SPI_TX_DUAL | SPI_RX_QUAD | SPI_TX_QUAD;
 
 	ret = devm_mutex_init(dev, &spifmc->lock);
-- 
2.53.0



