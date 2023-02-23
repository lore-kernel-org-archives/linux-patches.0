Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60292257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7F1C433EF;
	Thu, 23 Feb 2023 13:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157743;
	bh=BLm+F0XesTUSK7UoaRjs/EUOmdazv4Ng2o1cH0ZbzMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkQlrFemhxK08zhWSoRo9GYnh37r1iqi2JfPcLTAoOvpf9hattnJ2zkWIw8hAuI1o
	 MX6yQh9aIW0QDGumFiIBrYMuegRM08XvxvsbCzzDCOsderEo6AIulicB9UUXE/ju3q
	 ij2IkxDRVAwnjZMTM8jagCjyfPhI9i6xy0Grh1wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/46] spi: mediatek: Enable irq before the spi registration
Date: Thu, 23 Feb 2023 14:06:29 +0100
Message-Id: <20230223130432.593273942@linuxfoundation.org>
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

[ Upstream commit b24cded8c065d7cef8690b2c7b82b828cce57708 ]

If the irq is enabled after the spi si registered, there can be a race
with the initialization of the devices on the spi bus.

Eg:
mtk-spi 1100a000.spi: spi-mem transfer timeout
spi-nor: probe of spi0.0 failed with error -110
Unable to handle kernel NULL pointer dereference at virtual address
0000000000000010
...
Call trace:
 mtk_spi_can_dma+0x0/0x2c

Fixes: c6f7874687f7 ("spi: mediatek: Enable irq when pdata is ready")
Reported-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/20221225-mtk-spi-fixes-v1-0-bb6c14c232f8@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mt65xx.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 6de8360e5c2a9..9eab6c20dbc56 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1253,6 +1253,11 @@ static int mtk_spi_probe(struct platform_device *pdev)
 		dev_notice(dev, "SPI dma_set_mask(%d) failed, ret:%d\n",
 			   addr_bits, ret);
 
+	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
+			       IRQF_TRIGGER_NONE, dev_name(dev), master);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to register irq\n");
+
 	pm_runtime_enable(dev);
 
 	ret = devm_spi_register_master(dev, master);
@@ -1261,13 +1266,6 @@ static int mtk_spi_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "failed to register master\n");
 	}
 
-	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
-			       IRQF_TRIGGER_NONE, dev_name(dev), master);
-	if (ret) {
-		pm_runtime_disable(dev);
-		return dev_err_probe(dev, ret, "failed to register irq\n");
-	}
-
 	return 0;
 }
 
-- 
2.39.0



