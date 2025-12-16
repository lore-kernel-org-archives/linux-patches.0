Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1102D3612C2;
	Tue, 16 Dec 2025 12:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886887; cv=none; b=al0u3Tjoo1IlXdR+LBy9FU6yaRuDdIqN2rqpLtVIeKkBzpTPiw1jFnH/DldlJTKQSy5cV1wXfTD7I8L93VikDlRll9eZgN0bZcTsmOJww+J8UgW4MIL8Ct4rIH2J3jRGol1ZAkZaMNUH/EAZO1ubaqRAvbo/dxwQggUY/wF6lFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886887; c=relaxed/simple;
	bh=2RINV80KglDjGCuEFuXui0dHXFuXNDersyTVDCokYOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NechDKwesynuSDYULw39+ul7NP1l3J3YcHqhzC/+txgvgyf4US1toGV9EwaBPjq9kF06hi14ANKdsKb07O4yRBaYp2N36BySGRNCYyNpafOnod3j080QvBZuYA6zcdIlxYOq/r9yWfVpaSmFzQSWLQnO1ekAafh5TMijonZgbFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDKLLKeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDKLLKeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8904EC4CEF1;
	Tue, 16 Dec 2025 12:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886886;
	bh=2RINV80KglDjGCuEFuXui0dHXFuXNDersyTVDCokYOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDKLLKeMcokld2iUNvVsdq7tGAoqBq4L3HZd8Y28IyGSVzlE39iTDRy+Oq6oKSlg0
	 LTVe5CsJtM1bggr9A10glLDRULqeLwpVk6yItnTh51SfXmRVo6GeqZHBBODNIe3cVR
	 HYmzRnxKFBCtPqZlPj4zbZg8l4xUyHxBBQ/Ht/RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cyrille Pitchen <cyrille.pitchen@microchip.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Manikandan Muralidharan <manikandan.m@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/614] drm: atmel-hlcdc: fix atmel_xlcdc_plane_setup_scaler()
Date: Tue, 16 Dec 2025 12:06:37 +0100
Message-ID: <20251216111402.401302428@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyrille Pitchen <cyrille.pitchen@microchip.com>

[ Upstream commit a312acdcec57b3955fbf1f3057c13a6d38e4aa2a ]

On SoCs, like the SAM9X75, which embed the XLCDC ip, the registers that
configure the unified scaling engine were not filled with proper values.

Indeed, for YCbCr formats, the VXSCFACT bitfield of the HEOCFG25
register and the HXSCFACT bitfield of the HEOCFG27 register were
incorrect.

For 4:2:0 formats, both vertical and horizontal factors for
chroma chanels should be divided by 2 from the factors for the luma
channel. Hence:

HEOCFG24.VXSYFACT = VFACTOR
HEOCFG25.VSXCFACT = VFACTOR / 2
HEOCFG26.HXSYFACT = HFACTOR
HEOCFG27.HXSCFACT = HFACTOR / 2

However, for 4:2:2 formats, only the horizontal factor for chroma
chanels should be divided by 2 from the factor for the luma channel;
the vertical factor is the same for all the luma and chroma channels.
Hence:

HEOCFG24.VXSYFACT = VFACTOR
HEOCFG25.VXSCFACT = VFACTOR
HEOCFG26.HXSYFACT = HFACTOR
HEOCFG27.HXSCFACT = HFACTOR / 2

Fixes: d498771b0b83 ("drm: atmel_hlcdc: Add support for XLCDC using IP specific driver ops")
Signed-off-by: Cyrille Pitchen <cyrille.pitchen@microchip.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20241014094942.325211-1-manikandan.m@microchip.com
Signed-off-by: Manikandan Muralidharan <manikandan.m@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c   | 27 ++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index 4a7ba0918eca1..3787db014501e 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -365,13 +365,34 @@ void atmel_xlcdc_plane_setup_scaler(struct atmel_hlcdc_plane *plane,
 				    xfactor);
 
 	/*
-	 * With YCbCr 4:2:2 and YCbYcr 4:2:0 window resampling, configuration
-	 * register LCDC_HEOCFG25.VXSCFACT and LCDC_HEOCFG27.HXSCFACT is half
+	 * With YCbCr 4:2:0 window resampling, configuration register
+	 * LCDC_HEOCFG25.VXSCFACT and LCDC_HEOCFG27.HXSCFACT values are half
 	 * the value of yfactor and xfactor.
+	 *
+	 * On the other hand, with YCbCr 4:2:2 window resampling, only the
+	 * configuration register LCDC_HEOCFG27.HXSCFACT value is half the value
+	 * of the xfactor; the value of LCDC_HEOCFG25.VXSCFACT is yfactor (no
+	 * division by 2).
 	 */
-	if (state->base.fb->format->format == DRM_FORMAT_YUV420) {
+	switch (state->base.fb->format->format) {
+	/* YCbCr 4:2:2 */
+	case DRM_FORMAT_YUYV:
+	case DRM_FORMAT_UYVY:
+	case DRM_FORMAT_YVYU:
+	case DRM_FORMAT_VYUY:
+	case DRM_FORMAT_YUV422:
+	case DRM_FORMAT_NV61:
+		xfactor /= 2;
+		break;
+
+	/* YCbCr 4:2:0 */
+	case DRM_FORMAT_YUV420:
+	case DRM_FORMAT_NV21:
 		yfactor /= 2;
 		xfactor /= 2;
+		break;
+	default:
+		break;
 	}
 
 	atmel_hlcdc_layer_write_cfg(&plane->layer, desc->layout.scaler_config + 2,
-- 
2.51.0



