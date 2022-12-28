Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB73C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322B1C433EF;
	Wed, 28 Dec 2022 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240852;
	bh=QXRs9cy1VSHV67JP2WA2HF8wuo12XqBoOATJGQpR0tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clTIGVUFpC3nxYq4bUEYpBNy7FEuKz6PAzYVk2tEQ3AWOEZ4GRyoJX3lauRlWazVT
	 gFE5HkbPstPo4Uvc6TLFlZt1I217+v8TA+I4ihAbSXcjJBY4MDxohSSTNVP3RxD2Gl
	 DOqDAfVrv/Qu5bdEYSprOudHG3fX0alVUXbHQ328=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Vasut <marex@denx.de>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Liu Ying <victor.liu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0210/1073] drm: lcdif: Switch to limited range for RGB to YUV conversion
Date: Wed, 28 Dec 2022 15:29:58 +0100
Message-Id: <20221228144333.723225565@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit ec39dee8b25229a646271815cc86a8fc865525cf ]

Up to and including v1.3, HDMI supported limited quantization range only
for YCbCr. HDMI v1.4 introduced selectable quantization ranges, but this
feature isn't supported in the dw-hdmi driver that is used in
conjunction with the LCDIF in the i.MX8MP. The HDMI YCbCr output is thus
always advertised in the AVI infoframe as limited range.

The LCDIF driver, on the other hand, configures the CSC to produce full
range YCbCr. This mismatch results in loss of details and incorrect
colours. Fix it by switching to limited range YCbCr.

The coefficients are copied from drivers/media/platforms/nxp/imx-pxp.c
for coherency, as the hardware is most likely identical.

Fixes: 9db35bb349a0 ("drm: lcdif: Add support for i.MX8MP LCDIF variant")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220930083955.31580-4-laurent.pinchart@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/lcdif_kms.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/mxsfb/lcdif_kms.c b/drivers/gpu/drm/mxsfb/lcdif_kms.c
index 1bec1279c8b5..11f881554f74 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_kms.c
+++ b/drivers/gpu/drm/mxsfb/lcdif_kms.c
@@ -53,16 +53,22 @@ static void lcdif_set_formats(struct lcdif_drm_private *lcdif,
 		writel(DISP_PARA_LINE_PATTERN_UYVY_H,
 		       lcdif->base + LCDC_V8_DISP_PARA);
 
-		/* CSC: BT.601 Full Range RGB to YCbCr coefficients. */
-		writel(CSC0_COEF0_A2(0x096) | CSC0_COEF0_A1(0x04c),
+		/*
+		 * CSC: BT.601 Limited Range RGB to YCbCr coefficients.
+		 *
+		 * |Y |   | 0.2568  0.5041  0.0979|   |R|   |16 |
+		 * |Cb| = |-0.1482 -0.2910  0.4392| * |G| + |128|
+		 * |Cr|   | 0.4392  0.4392 -0.3678|   |B|   |128|
+		 */
+		writel(CSC0_COEF0_A2(0x081) | CSC0_COEF0_A1(0x041),
 		       lcdif->base + LCDC_V8_CSC0_COEF0);
-		writel(CSC0_COEF1_B1(0x7d5) | CSC0_COEF1_A3(0x01d),
+		writel(CSC0_COEF1_B1(0x7db) | CSC0_COEF1_A3(0x019),
 		       lcdif->base + LCDC_V8_CSC0_COEF1);
-		writel(CSC0_COEF2_B3(0x080) | CSC0_COEF2_B2(0x7ac),
+		writel(CSC0_COEF2_B3(0x070) | CSC0_COEF2_B2(0x7b6),
 		       lcdif->base + LCDC_V8_CSC0_COEF2);
-		writel(CSC0_COEF3_C2(0x795) | CSC0_COEF3_C1(0x080),
+		writel(CSC0_COEF3_C2(0x7a2) | CSC0_COEF3_C1(0x070),
 		       lcdif->base + LCDC_V8_CSC0_COEF3);
-		writel(CSC0_COEF4_D1(0x000) | CSC0_COEF4_C3(0x7ec),
+		writel(CSC0_COEF4_D1(0x010) | CSC0_COEF4_C3(0x7ee),
 		       lcdif->base + LCDC_V8_CSC0_COEF4);
 		writel(CSC0_COEF5_D3(0x080) | CSC0_COEF5_D2(0x080),
 		       lcdif->base + LCDC_V8_CSC0_COEF5);
-- 
2.35.1



