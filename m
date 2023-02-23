Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15718257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF28C4339B;
	Thu, 23 Feb 2023 13:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157724;
	bh=FJn8N3A4s3Mr+6qBnhG+biXHH6DNp00RbjSRzR7pBRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rshi1Q1mpwmohRcLDMn5e+A6mU9icmEL8N6Cy/7/kAOW1r1TkRrKWti6kbEosXLeM
	 PU5YGv+3az7xBzU0EEensbbclvKMFjta8uvDWKRvT7xztL8MMUbC3f5tPwgBuv6bMX
	 wm9f12cU9hoh6/z33DjUv5ERHzC2sD5cZLIeeH78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/46] spi: mediatek: Enable irq when pdata is ready
Date: Thu, 23 Feb 2023 14:06:22 +0100
Message-Id: <20230223130432.252826964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

[ Upstream commit c6f7874687f7027d7c4b2f53ff6e4d22850f915d ]

If the device does not come straight from reset, we might receive an IRQ
before we are ready to handle it.

Fixes:

[    0.832328] Unable to handle kernel read from unreadable memory at virtual address 0000000000000010
[    1.040343] Call trace:
[    1.040347]  mtk_spi_can_dma+0xc/0x40
...
[    1.262265]  start_kernel+0x338/0x42c

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221128-spi-mt65xx-v1-0-509266830665@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index d6aff909fc365..6de8360e5c2a9 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1192,11 +1192,6 @@ static int mtk_spi_probe(struct platform_device *pdev)
 	else
 		dma_set_max_seg_size(dev, SZ_256K);
 
-	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
-			       IRQF_TRIGGER_NONE, dev_name(dev), master);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to register irq\n");
-
 	mdata->parent_clk = devm_clk_get(dev, "parent-clk");
 	if (IS_ERR(mdata->parent_clk))
 		return dev_err_probe(dev, PTR_ERR(mdata->parent_clk),
@@ -1266,6 +1261,13 @@ static int mtk_spi_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "failed to register master\n");
 	}
 
+	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
+			       IRQF_TRIGGER_NONE, dev_name(dev), master);
+	if (ret) {
+		pm_runtime_disable(dev);
+		return dev_err_probe(dev, ret, "failed to register irq\n");
+	}
+
 	return 0;
 }
 
-- 
2.39.0



