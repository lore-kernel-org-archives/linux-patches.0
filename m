Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A40647D930;
	Thu, 20 Aug 2026 16:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244635; cv=none; b=IJ0t0Fij9+qGL1DKJEWIC3qBAEM1JHS/spOcs5eCP903qHB3RMSZ2G54V9Whn3r2tDXPRbblcr6Hb7BH55hE3qyqrAmQmZ1ohk65rX/7MNufNWQfBQC6TGOxMYhs7yOYXXX6/MNDQlyiWfPiSDPzMmpl/CK/9y/5gta1QP+k0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244635; c=relaxed/simple;
	bh=J9WIavFNpnlfLfrnXl/yke2JpjsF0XhLOAgSam0jOp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJB6kNLBTbPMp5J3shNvQTQYMP3gm6qxaEy3kGaQtxkRWX1NLeQD2UkHqxts/5J/3lT6sc3yCE9L+ja3xH8e15derZFLewCx89eihf4y6wwG/XJNOFymiyFoY3fGMGHzBxcC7W5o7MgHBDvo3knl4MEweAEnvdDQ2yL7/XLHzdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oF/d5TtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oF/d5TtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C324B1F00A3F;
	Thu, 20 Aug 2026 16:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244634;
	bh=7rvSqCvRbydRSZ+RpG5FdXAvsFgXlGbnPvTqa2gLxwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oF/d5TtDsKX+4sxNRkBal/nRoN+V1PqyoVuPa6hBgYLnzq37tdo4evTHgYSKbzXJd
	 256esShaAS3Q2V46ynTDDiudcjnPt5OVbgb5fQz7uDt+eNWTjZQKtoDqigE/g48PCB
	 TSCwEwEn2N1iuMAQcc2Z9ku0kSZMHUeleWyjVOZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/235] ASoC: xilinx: formatter_pcm: pass aud_drv_data to irq handlers
Date: Thu, 20 Aug 2026 16:57:39 +0200
Message-ID: <20260820145223.377283317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f12afefb7b01f94d6d66d397f323a9914edbf70e ]

The irq handlers take a struct device pointer and call
dev_get_drvdata() to obtain the driver data.  However, the driver
data is only set at the end of probe, after devm_request_irq(),
so an interrupt taken in between causes the handlers to pass a
NULL pointer to readl() and crash.

Pass the private data directly as the devm_request_irq() argument
instead of the device pointer, matching what the handlers expect.

Fixes: 6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260806233231.30631-1-rosenp@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index 5c4158069a5a8..dccc056e0e0a6 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -281,8 +281,7 @@ static irqreturn_t xlnx_mm2s_irq_handler(int irq, void *arg)
 {
 	u32 val;
 	void __iomem *reg;
-	struct device *dev = arg;
-	struct xlnx_pcm_drv_data *adata = dev_get_drvdata(dev);
+	struct xlnx_pcm_drv_data *adata = arg;
 
 	reg = adata->mmio + XLNX_MM2S_OFFSET + XLNX_AUD_STS;
 	val = readl(reg);
@@ -300,8 +299,7 @@ static irqreturn_t xlnx_s2mm_irq_handler(int irq, void *arg)
 {
 	u32 val;
 	void __iomem *reg;
-	struct device *dev = arg;
-	struct xlnx_pcm_drv_data *adata = dev_get_drvdata(dev);
+	struct xlnx_pcm_drv_data *adata = arg;
 
 	reg = adata->mmio + XLNX_S2MM_OFFSET + XLNX_AUD_STS;
 	val = readl(reg);
@@ -637,7 +635,7 @@ static int xlnx_formatter_pcm_probe(struct platform_device *pdev)
 		}
 		ret = devm_request_irq(dev, aud_drv_data->mm2s_irq,
 				       xlnx_mm2s_irq_handler, 0,
-				       "xlnx_formatter_pcm_mm2s_irq", dev);
+				       "xlnx_formatter_pcm_mm2s_irq", aud_drv_data);
 		if (ret) {
 			dev_err(dev, "xlnx audio mm2s irq request failed\n");
 			goto clk_err;
@@ -664,7 +662,7 @@ static int xlnx_formatter_pcm_probe(struct platform_device *pdev)
 		ret = devm_request_irq(dev, aud_drv_data->s2mm_irq,
 				       xlnx_s2mm_irq_handler, 0,
 				       "xlnx_formatter_pcm_s2mm_irq",
-				       dev);
+				       aud_drv_data);
 		if (ret) {
 			dev_err(dev, "xlnx audio s2mm irq request failed\n");
 			goto clk_err;
-- 
2.53.0



