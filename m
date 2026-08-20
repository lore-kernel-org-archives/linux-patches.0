Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F04F36A37A;
	Thu, 20 Aug 2026 15:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238607; cv=none; b=t5wZczULfLuh0qjV0LKLrNulvR4DOwCHE/WAz0jMjwmWHw+JolJo+mhmB+nGCGLHQohT7CTsCUWCQW+4QtlLfwEYfFILiVT0VMVOwVnEad8JIVxnlo48d8h1w5I1Pw+xutbVSO8prNXs6enQXdnK0L5iTYJ4GtMBYH/vTQqhu9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238607; c=relaxed/simple;
	bh=bA5XW8s3Z28+66101CAiEosidB6ilAy0+0C80e5F3Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/a/93Q121+vtElKTwHAYlUzkbjkdhLxlX0JoQ03S0HOpZYHtTygWwN/iWDVHCGkzLL8xbvQHPvIEvrE/6bnw8msAmSqAm9lxm8X0obM+OwEThSpQhY5jJkAMT980emZApZQplOjm8njGjusSR4ia4kop2YOyyjj68YBPbFjX4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKm0YM+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKm0YM+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D983F1F000E9;
	Thu, 20 Aug 2026 15:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238606;
	bh=f9LYaxgEGJYCpVF1Lh7+NCp0SG13xOehK/STKfjHSdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKm0YM+W8f9/tmx/VWy68nzW0/3Z8JIYAAqG4CTRjN2/dYF3PC3rwI8qZG2ue3ELn
	 CTV+xwjogbCk8Dq8cC/sVvExwJyIKsYD1KWC5YEwJ0VAYHxBfGvPwXtkWJ9GA4Yi1b
	 8eIJQMNfGi39NNxZEI92VQ9JvbOYUqlWFsP4EsuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 206/228] ASoC: xilinx: formatter_pcm: pass aud_drv_data to irq handlers
Date: Thu, 20 Aug 2026 16:55:48 +0200
Message-ID: <20260820145251.292601859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8f7a76758535b..f15336197ed31 100644
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



