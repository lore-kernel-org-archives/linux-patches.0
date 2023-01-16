Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6134C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64FBC433D2;
	Mon, 16 Jan 2023 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885738;
	bh=4ZxKZasQcdYyW62R6n8Q4C2YNvwkAHjbpiBKmcpW050=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvo8eXdjX0eZ8kyCnaLemtycQXHRNIvc4eI8Z/sEEWSAO2E6mwprT+LYHu+FVt5cu
	 hFKdBvwFaIyCnKOJQ9EuurNsWpwyF0wExEmYuJDnckuLKQF+wNB/EAGD+4I/th+Uw9
	 A38p3RR8bxntWIdHDH0aDkImiloorY4Rm49sWZVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/658] ASoC: mediatek: mt8173: Enable IRQ when pdata is ready
Date: Mon, 16 Jan 2023 16:44:14 +0100
Message-Id: <20230116154917.063676166@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 4cbb264d4e9136acab2c8fd39e39ab1b1402b84b ]

If the device does not come straight from reset, we might receive an IRQ
before we are ready to handle it.

Fixes:

[    2.334737] Unable to handle kernel read from unreadable memory at virtual address 00000000000001e4
[    2.522601] Call trace:
[    2.525040]  regmap_read+0x1c/0x80
[    2.528434]  mt8173_afe_irq_handler+0x40/0xf0
...
[    2.598921]  start_kernel+0x338/0x42c

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Fixes: ee0bcaff109f ("ASoC: mediatek: Add AFE platform driver")
Link: https://lore.kernel.org/r/20221128-mt8173-afe-v1-0-70728221628f@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c b/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
index 0ee29255e731..f3dbd8164b86 100644
--- a/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
+++ b/sound/soc/mediatek/mt8173/mt8173-afe-pcm.c
@@ -1073,16 +1073,6 @@ static int mt8173_afe_pcm_dev_probe(struct platform_device *pdev)
 
 	afe->dev = &pdev->dev;
 
-	irq_id = platform_get_irq(pdev, 0);
-	if (irq_id <= 0)
-		return irq_id < 0 ? irq_id : -ENXIO;
-	ret = devm_request_irq(afe->dev, irq_id, mt8173_afe_irq_handler,
-			       0, "Afe_ISR_Handle", (void *)afe);
-	if (ret) {
-		dev_err(afe->dev, "could not request_irq\n");
-		return ret;
-	}
-
 	afe->base_addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(afe->base_addr))
 		return PTR_ERR(afe->base_addr);
@@ -1158,6 +1148,16 @@ static int mt8173_afe_pcm_dev_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_pm_disable;
 
+	irq_id = platform_get_irq(pdev, 0);
+	if (irq_id <= 0)
+		return irq_id < 0 ? irq_id : -ENXIO;
+	ret = devm_request_irq(afe->dev, irq_id, mt8173_afe_irq_handler,
+			       0, "Afe_ISR_Handle", (void *)afe);
+	if (ret) {
+		dev_err(afe->dev, "could not request_irq\n");
+		goto err_pm_disable;
+	}
+
 	dev_info(&pdev->dev, "MT8173 AFE driver initialized.\n");
 	return 0;
 
-- 
2.35.1



