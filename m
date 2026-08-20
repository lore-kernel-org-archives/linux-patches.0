Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DED45FFAD;
	Thu, 20 Aug 2026 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243927; cv=none; b=XmUktOJ3Q69owOs+pa5OzuDdZT+WWY8F07xhvioRIVJOaGECa1mX7EEdaqe4Iwqli1Wz2sBed+QnUCvajO2pH17efkugl9jSbV2kaCCg+Ut3P4xllZFCtXaJjGzk/cO+uKDYZe8Ukwo4lCCrgXtXrD3I8I1OJriD+ZdwvSKrd5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243927; c=relaxed/simple;
	bh=2kM8JGTQes6+BUYafJoZdqA2+QT9Sqen14uvWA+6YSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3brwuZid2zQUAMdkecXINe32ZJS3ha4JqBWUY+cS8kwJRTbN/LUfvn0Tfe4VodkKsdszFi5bcSvn2Kfdl7eKJxYY2Du7nW22SWfpaaXAme0IdcPQJqj9fFRUxLbEfVa60q0oxXj9OgAFWOSFpNv6Ps8k2wWdB5v+S1MA4y76wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYSUgKwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYSUgKwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2AB1F000E9;
	Thu, 20 Aug 2026 16:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243926;
	bh=Ym9v81Y4MdB17qhF9bau8GuWYtVqinTjtQtxTt4fAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYSUgKwqQHKXRzUT5qgyHSA5JW7wF1tFjnFFHrFz2fD/6t9Q7t5M2p3sicVrFSRF8
	 2/OR36MtRFZ9KTcjnk9VOPxlY2CrBk+6kAnguuxvXFccUB8z0wjNY0ocE+YS4e0pLr
	 vNU1ARzCWZL8PUh8g+HsJT4eKuGbqO/rAbiQl1JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/272] ASoC: xilinx: formatter_pcm: pass aud_drv_data to irq handlers
Date: Thu, 20 Aug 2026 16:57:28 +0200
Message-ID: <20260820145239.555887367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



