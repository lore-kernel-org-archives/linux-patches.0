Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1E224F6;
	Tue,  8 Apr 2025 11:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110658; cv=none; b=ZQy1acPJ2Fo9I9FEeu4+8qIy9shBnOqtX4IL6gAQXFSoKSJpFTIvNyKTtIAkogG6iqGBHWl80TMKVpMLNSK3PFFIZblpnuVwyyZYKQ8H0YDOSkU+QoydGwKUX6hecO7mraadfGnDGdeJX92lJ/F1IPlK1iIAEaEcd4yUoS/CL6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110658; c=relaxed/simple;
	bh=AXcvZQI/drarg3xk6ae+TOjRJuqvWM/x0k/le6EWnDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0KXRoBw51MWYcheBqtt8rJIhJeJC2zgPzg6OUm06zolz4jU+dGB3OJfsP9z9PluBeZtQjJFbmnqvBpKKROerLkn7+OlPMcApEn72VkWMD4PgMYTh43AQytVOufkXw4B/2LxBkmvrKkYrRycbPHn+NswqGMrV1ioY+h85Ne2PR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLuajSMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLuajSMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A26DC4CEEB;
	Tue,  8 Apr 2025 11:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110657;
	bh=AXcvZQI/drarg3xk6ae+TOjRJuqvWM/x0k/le6EWnDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLuajSMC8mZrWHhzC/TFUwlkOAmmR/7/vwGmHDOZfT8jfMM2DyDcbEu2MKLvy8jt8
	 oAXgSfwRUqVblvgmVDWU2Jy3QUymTHBZQaP/VGWTknO40Gw7Nb93jtxyiQxjFPRxtL
	 FrdIxZ+LNiDpr+fUFlP3avwHBXVWXOjqZnpfbAvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 145/731] soc: mediatek: mt8365-mmsys: Fix routing table masks and values
Date: Tue,  8 Apr 2025 12:40:42 +0200
Message-ID: <20250408104917.646851502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit d294d56cb9462e918421fe2bbe5f52a8da82603a ]

The mmsys driver reads the routing table and writes to the
hardware `val & mask`, but multiple entries in the mmsys
routing table for the MT8365 SoC are setting a 0x0 mask:
this effectively writes .. nothing .. to the hardware.

That would never work, and if the display controller was
actually working with the mmsys doing no routing at all,
that was only because the bootloader was correctly setting
the display controller routing registers before booting the
kernel, and the mmsys was never reset.

Make this table to actually set the routing by adding the
correct register masks to it.

While at it, also change MOUT val definitions to BIT(x), as
the MOUT registers are effectively checking for each bit to
enable output to the corresponding HW.
Please note that, for this SoC, only the MOUT registers are
checking bits (as those can enable multiple outputs), while
the others are purely reading a number to select an input.

Fixes: bc3fc5c05100 ("soc: mediatek: mmsys: add MT8365 support")
Link: https://lore.kernel.org/r/20250212100012.33001-7-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mt8365-mmsys.h | 48 ++++++++++++-----------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/soc/mediatek/mt8365-mmsys.h b/drivers/soc/mediatek/mt8365-mmsys.h
index 7abaf048d91e8..ae37945e6c67c 100644
--- a/drivers/soc/mediatek/mt8365-mmsys.h
+++ b/drivers/soc/mediatek/mt8365-mmsys.h
@@ -14,8 +14,9 @@
 #define MT8365_DISP_REG_CONFIG_DISP_DPI0_SEL_IN		0xfd8
 #define MT8365_DISP_REG_CONFIG_DISP_LVDS_SYS_CFG_00	0xfdc
 
+#define MT8365_DISP_MS_IN_OUT_MASK			GENMASK(3, 0)
 #define MT8365_RDMA0_SOUT_COLOR0			0x1
-#define MT8365_DITHER_MOUT_EN_DSI0			0x1
+#define MT8365_DITHER_MOUT_EN_DSI0			BIT(0)
 #define MT8365_DSI0_SEL_IN_DITHER			0x1
 #define MT8365_RDMA0_SEL_IN_OVL0			0x0
 #define MT8365_RDMA0_RSZ0_SEL_IN_RDMA0			0x0
@@ -30,52 +31,43 @@ static const struct mtk_mmsys_routes mt8365_mmsys_routing_table[] = {
 	{
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_RDMA0,
 		MT8365_DISP_REG_CONFIG_DISP_OVL0_MOUT_EN,
-		MT8365_OVL0_MOUT_PATH0_SEL, MT8365_OVL0_MOUT_PATH0_SEL
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_OVL0_MOUT_PATH0_SEL
+	}, {
 		DDP_COMPONENT_OVL0, DDP_COMPONENT_RDMA0,
 		MT8365_DISP_REG_CONFIG_DISP_RDMA0_SEL_IN,
-		MT8365_RDMA0_SEL_IN_OVL0, MT8365_RDMA0_SEL_IN_OVL0
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_RDMA0_SEL_IN_OVL0
+	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_COLOR0,
 		MT8365_DISP_REG_CONFIG_DISP_RDMA0_SOUT_SEL,
-		MT8365_RDMA0_SOUT_COLOR0, MT8365_RDMA0_SOUT_COLOR0
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_RDMA0_SOUT_COLOR0
+	}, {
 		DDP_COMPONENT_COLOR0, DDP_COMPONENT_CCORR,
 		MT8365_DISP_REG_CONFIG_DISP_COLOR0_SEL_IN,
-		MT8365_DISP_COLOR_SEL_IN_COLOR0,MT8365_DISP_COLOR_SEL_IN_COLOR0
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_DISP_COLOR_SEL_IN_COLOR0
+	}, {
 		DDP_COMPONENT_DITHER0, DDP_COMPONENT_DSI0,
 		MT8365_DISP_REG_CONFIG_DISP_DITHER0_MOUT_EN,
-		MT8365_DITHER_MOUT_EN_DSI0, MT8365_DITHER_MOUT_EN_DSI0
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_DITHER_MOUT_EN_DSI0
+	}, {
 		DDP_COMPONENT_DITHER0, DDP_COMPONENT_DSI0,
 		MT8365_DISP_REG_CONFIG_DISP_DSI0_SEL_IN,
-		MT8365_DSI0_SEL_IN_DITHER, MT8365_DSI0_SEL_IN_DITHER
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_DSI0_SEL_IN_DITHER
+	}, {
 		DDP_COMPONENT_RDMA0, DDP_COMPONENT_COLOR0,
 		MT8365_DISP_REG_CONFIG_DISP_RDMA0_RSZ0_SEL_IN,
-		MT8365_RDMA0_RSZ0_SEL_IN_RDMA0, MT8365_RDMA0_RSZ0_SEL_IN_RDMA0
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_RDMA0_RSZ0_SEL_IN_RDMA0
+	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
 		MT8365_DISP_REG_CONFIG_DISP_LVDS_SYS_CFG_00,
 		MT8365_LVDS_SYS_CFG_00_SEL_LVDS_PXL_CLK, MT8365_LVDS_SYS_CFG_00_SEL_LVDS_PXL_CLK
-	},
-	{
+	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
 		MT8365_DISP_REG_CONFIG_DISP_DPI0_SEL_IN,
-		MT8365_DPI0_SEL_IN_RDMA1, MT8365_DPI0_SEL_IN_RDMA1
-	},
-	{
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_DPI0_SEL_IN_RDMA1
+	}, {
 		DDP_COMPONENT_RDMA1, DDP_COMPONENT_DPI0,
 		MT8365_DISP_REG_CONFIG_DISP_RDMA1_SOUT_SEL,
-		MT8365_RDMA1_SOUT_DPI0, MT8365_RDMA1_SOUT_DPI0
+		MT8365_DISP_MS_IN_OUT_MASK, MT8365_RDMA1_SOUT_DPI0
 	},
 };
 
-- 
2.39.5



