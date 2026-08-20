Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5AF28C2BF;
	Thu, 20 Aug 2026 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247265; cv=none; b=c6ud3qZaq8eHr+2AYw2it93EIkdacDHKbJB0lD2XuD2+E/7WeOPNKmMx4vZ9VpFh5zcHNs3W9R5wDPnVIHVatF3MeM1snyc4NXvOaGlXFl5c02td5SpC3bmB570WZr0lilkgwrPCZBx4eB4qpwA0R9QfIEIbiD24yFOL5RZ5/WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247265; c=relaxed/simple;
	bh=nplgFtmWptEqh4zkvs0UkQM1IFBjpkuA/8wSjX0gLr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+xo+mPFuXFdyqTKaF5nGKou3sotP8wS2sYMnlEXK+8LS5YFc8HNL175IOap6BlU2lZtaGBiyBqRVjKRkyUvN/qnJh7zl2JPxMhEvJciYWVaMNR1gC6TxT+U0Hm6GXIV1paQzmj0VUr7oFgz2xxc7VZn9d7w4WXe+tnfpRnevYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKg1+Pqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKg1+Pqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F401F000E9;
	Thu, 20 Aug 2026 17:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247264;
	bh=9mw3nJvnVQuI6pEhJTCVBfHamINlm1TXuBgDYzA6IWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKg1+Pqk94SToHAUtyIzvhD66I018lCtdS1pKzxPlc9nubuQCZFMUGsf5auxrxII1
	 q8O/OSzzJx8bh+AGfOEUl/9wLhxxb4XWox3sQCZ1MMrBAYptdfvfDa9Lr6q95mR0ZZ
	 uRcx1PrEdETJcig6hlqiw+CmCiw5rMYlXK70D8lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 206/220] ASoC: xilinx: formatter_pcm: pass aud_drv_data to irq handlers
Date: Thu, 20 Aug 2026 16:56:36 +0200
Message-ID: <20260820145229.704871979@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17ef053094694..45b178148b98b 100644
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



