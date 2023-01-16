Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD8046B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76D8C433F0;
	Mon, 16 Jan 2023 16:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885717;
	bh=mB74XMYZ8+OI77BAuONesXFQxd236HB4y3rstC24vaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uY6i6UTz6hcmgvwfZMXVC/SiR0163mBDdWXCrudvK19xmNE3Vjai65pL5+Rj5ozTD
	 GGGJagXEgFTBquVb4mcahG+1qgZz0riNCbdep2sT97ksQy8UsIUo281B4CsC0IYQuT
	 JiVvPb+Sdyku1rwAokMO5e4uWoKriy0JX859RU94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinlei Lee <xinlei.lee@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/658] drm/mediatek: Modify dpi power on/off sequence.
Date: Mon, 16 Jan 2023 16:43:36 +0100
Message-Id: <20230116154915.305997965@linuxfoundation.org>
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

From: Xinlei Lee <xinlei.lee@mediatek.com>

[ Upstream commit ff446c0f6290185cefafe3b376bb86063a3a9f6a ]

Modify dpi power on/off sequence so that the first gpio operation will
take effect.

Fixes: 6bd4763fd532 ("drm/mediatek: set dpi pin mode to gpio low to avoid leakage current")
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_dpi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_dpi.c b/drivers/gpu/drm/mediatek/mtk_dpi.c
index 4a64d8aed9da..7c68a3933915 100644
--- a/drivers/gpu/drm/mediatek/mtk_dpi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dpi.c
@@ -364,9 +364,6 @@ static void mtk_dpi_power_off(struct mtk_dpi *dpi)
 	if (--dpi->refcount != 0)
 		return;
 
-	if (dpi->pinctrl && dpi->pins_gpio)
-		pinctrl_select_state(dpi->pinctrl, dpi->pins_gpio);
-
 	mtk_dpi_disable(dpi);
 	clk_disable_unprepare(dpi->pixel_clk);
 	clk_disable_unprepare(dpi->engine_clk);
@@ -391,9 +388,6 @@ static int mtk_dpi_power_on(struct mtk_dpi *dpi)
 		goto err_pixel;
 	}
 
-	if (dpi->pinctrl && dpi->pins_dpi)
-		pinctrl_select_state(dpi->pinctrl, dpi->pins_dpi);
-
 	return 0;
 
 err_pixel:
@@ -529,12 +523,18 @@ static void mtk_dpi_encoder_disable(struct drm_encoder *encoder)
 	struct mtk_dpi *dpi = mtk_dpi_from_encoder(encoder);
 
 	mtk_dpi_power_off(dpi);
+
+	if (dpi->pinctrl && dpi->pins_gpio)
+		pinctrl_select_state(dpi->pinctrl, dpi->pins_gpio);
 }
 
 static void mtk_dpi_encoder_enable(struct drm_encoder *encoder)
 {
 	struct mtk_dpi *dpi = mtk_dpi_from_encoder(encoder);
 
+	if (dpi->pinctrl && dpi->pins_dpi)
+		pinctrl_select_state(dpi->pinctrl, dpi->pins_dpi);
+
 	mtk_dpi_power_on(dpi);
 	mtk_dpi_set_display_mode(dpi, &dpi->mode);
 	mtk_dpi_enable(dpi);
-- 
2.35.1



