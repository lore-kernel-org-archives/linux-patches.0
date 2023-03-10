Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94CE8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302F3C433D2;
	Fri, 10 Mar 2023 14:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459981;
	bh=O43vhxBRCnTNB8ZMCLYGbCay8udVuPvXfUkflNi9XjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YEKgBu0rXcNVVoiI4IVV7U7oL9aDdwY+G65DYeL21xAyd0cnsj1jkHEvcnaKWzDY
	 mNinE9956tU0XsechLRgQL27i8hozBYpm2pFWljVv8avIrVTtsm946cgWaLK941JWk
	 G8SPIaWDI52PY4XF1334yCeM+PVnciU4GO05XTt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/529] drm/vc4: dpi: Add option for inverting pixel clock and output enable
Date: Fri, 10 Mar 2023 14:34:56 +0100
Message-Id: <20230310133812.029827526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 3c2707632146b22e97b0fbf6778bab8add2eaa1d ]

DRM provides flags for inverting pixel clock and output enable
signals, but these were not mapped to the relevant registers.

Add those mappings.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-10-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Stable-dep-of: 0870d86eac8a ("drm/vc4: dpi: Fix format mapping for RGB565")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_dpi.c | 66 ++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_dpi.c b/drivers/gpu/drm/vc4/vc4_dpi.c
index a90f2545baee0..0e25add2df071 100644
--- a/drivers/gpu/drm/vc4/vc4_dpi.c
+++ b/drivers/gpu/drm/vc4/vc4_dpi.c
@@ -148,35 +148,45 @@ static void vc4_dpi_encoder_enable(struct drm_encoder *encoder)
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (connector && connector->display_info.num_bus_formats) {
-		u32 bus_format = connector->display_info.bus_formats[0];
-
-		switch (bus_format) {
-		case MEDIA_BUS_FMT_RGB888_1X24:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
-					       DPI_FORMAT);
-			break;
-		case MEDIA_BUS_FMT_BGR888_1X24:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
-					       DPI_FORMAT);
-			dpi_c |= VC4_SET_FIELD(DPI_ORDER_BGR, DPI_ORDER);
-			break;
-		case MEDIA_BUS_FMT_RGB666_1X24_CPADHI:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_2,
-					       DPI_FORMAT);
-			break;
-		case MEDIA_BUS_FMT_RGB666_1X18:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_1,
-					       DPI_FORMAT);
-			break;
-		case MEDIA_BUS_FMT_RGB565_1X16:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_3,
-					       DPI_FORMAT);
-			break;
-		default:
-			DRM_ERROR("Unknown media bus format %d\n", bus_format);
-			break;
+	if (connector) {
+		if (connector->display_info.num_bus_formats) {
+			u32 bus_format = connector->display_info.bus_formats[0];
+
+			switch (bus_format) {
+			case MEDIA_BUS_FMT_RGB888_1X24:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
+						       DPI_FORMAT);
+				break;
+			case MEDIA_BUS_FMT_BGR888_1X24:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
+						       DPI_FORMAT);
+				dpi_c |= VC4_SET_FIELD(DPI_ORDER_BGR,
+						       DPI_ORDER);
+				break;
+			case MEDIA_BUS_FMT_RGB666_1X24_CPADHI:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_2,
+						       DPI_FORMAT);
+				break;
+			case MEDIA_BUS_FMT_RGB666_1X18:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_1,
+						       DPI_FORMAT);
+				break;
+			case MEDIA_BUS_FMT_RGB565_1X16:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_3,
+						       DPI_FORMAT);
+				break;
+			default:
+				DRM_ERROR("Unknown media bus format %d\n",
+					  bus_format);
+				break;
+			}
 		}
+
+		if (connector->display_info.bus_flags & DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE)
+			dpi_c |= DPI_PIXEL_CLK_INVERT;
+
+		if (connector->display_info.bus_flags & DRM_BUS_FLAG_DE_LOW)
+			dpi_c |= DPI_OUTPUT_ENABLE_INVERT;
 	} else {
 		/* Default to 24bit if no connector found. */
 		dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB, DPI_FORMAT);
-- 
2.39.2



