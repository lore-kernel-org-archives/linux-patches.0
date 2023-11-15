Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0320F3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx3qQK8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6069C433C7;
	Wed, 15 Nov 2023 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077384;
	bh=fVcI/NcL4t5pz0dbBwKxkPnejlInDaavEbktCQl7+4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx3qQK8+le1IlkBCpg3UL6Ukaiux5c08WA6cH5KLKr72dmZWi/vlUhv9RWjjfG+LF
	 PCZyONfY5EBAN2MCl+hePikQCM/9MSAWaXwkuNDKWdVnbgdtROMMub8gMdomUGJceD
	 nQweid73TGq7yt0pmF5PTk+QbmMNRtkHQ35BWrL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Marcel Ziswiler <marcel.ziswiler@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Maxim Schwalm <maxim.schwalm@gmail.com>
Subject: [PATCH 6.6 234/603] drm/bridge: tc358768: Use struct videomode
Date: Wed, 15 Nov 2023 14:12:59 -0500
Message-ID: <20231115191629.392381241@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit e5fb21678136a9d009d5c43821881eb4c34fae97 ]

The TC358768 documentation uses HFP, HBP, etc. values to deal with the
video mode, while the driver currently uses the DRM display mode
(htotal, hsync_start, etc).

Change the driver to convert the DRM display mode to struct videomode,
which then allows us to use the same units the documentation uses. This
makes it much easier to work on the code when using the TC358768
documentation as a reference.

Reviewed-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> # Asus TF700T
Tested-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230906-tc358768-v4-6-31725f008a50@ideasonboard.com
Stable-dep-of: f1dabbe64506 ("drm/bridge: tc358768: Fix tc358768_ns_to_cnt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 45 ++++++++++++++++---------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index b668f77673c3d..e42b5259ea344 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -650,6 +650,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	u32 dsiclk, dsibclk, video_start;
 	const u32 internal_delay = 40;
 	int ret, i;
+	struct videomode vm;
 
 	if (mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS) {
 		dev_warn_once(priv->dev, "Non-continuous mode unimplemented, falling back to continuous\n");
@@ -673,6 +674,8 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 		return;
 	}
 
+	drm_display_mode_to_videomode(mode, &vm);
+
 	dsiclk = priv->dsiclk;
 	dsibclk = dsiclk / 4;
 
@@ -681,28 +684,28 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	switch (dsi_dev->format) {
 	case MIPI_DSI_FMT_RGB888:
 		val |= (0x3 << 4);
-		hact = mode->hdisplay * 3;
-		video_start = (mode->htotal - mode->hsync_start) * 3;
+		hact = vm.hactive * 3;
+		video_start = (vm.hsync_len + vm.hback_porch) * 3;
 		data_type = MIPI_DSI_PACKED_PIXEL_STREAM_24;
 		break;
 	case MIPI_DSI_FMT_RGB666:
 		val |= (0x4 << 4);
-		hact = mode->hdisplay * 3;
-		video_start = (mode->htotal - mode->hsync_start) * 3;
+		hact = vm.hactive * 3;
+		video_start = (vm.hsync_len + vm.hback_porch) * 3;
 		data_type = MIPI_DSI_PACKED_PIXEL_STREAM_18;
 		break;
 
 	case MIPI_DSI_FMT_RGB666_PACKED:
 		val |= (0x4 << 4) | BIT(3);
-		hact = mode->hdisplay * 18 / 8;
-		video_start = (mode->htotal - mode->hsync_start) * 18 / 8;
+		hact = vm.hactive * 18 / 8;
+		video_start = (vm.hsync_len + vm.hback_porch) * 18 / 8;
 		data_type = MIPI_DSI_PIXEL_STREAM_3BYTE_18;
 		break;
 
 	case MIPI_DSI_FMT_RGB565:
 		val |= (0x5 << 4);
-		hact = mode->hdisplay * 2;
-		video_start = (mode->htotal - mode->hsync_start) * 2;
+		hact = vm.hactive * 2;
+		video_start = (vm.hsync_len + vm.hback_porch) * 2;
 		data_type = MIPI_DSI_PACKED_PIXEL_STREAM_16;
 		break;
 	default:
@@ -814,43 +817,43 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 		tc358768_write(priv, TC358768_DSI_EVENT, 0);
 
 		/* vact */
-		tc358768_write(priv, TC358768_DSI_VACT, mode->vdisplay);
+		tc358768_write(priv, TC358768_DSI_VACT, vm.vactive);
 
 		/* vsw */
-		tc358768_write(priv, TC358768_DSI_VSW,
-			       mode->vsync_end - mode->vsync_start);
+		tc358768_write(priv, TC358768_DSI_VSW, vm.vsync_len);
+
 		/* vbp */
-		tc358768_write(priv, TC358768_DSI_VBPR,
-			       mode->vtotal - mode->vsync_end);
+		tc358768_write(priv, TC358768_DSI_VBPR, vm.vback_porch);
 
 		/* hsw * byteclk * ndl / pclk */
-		val = (u32)div_u64((mode->hsync_end - mode->hsync_start) *
+		val = (u32)div_u64(vm.hsync_len *
 				   ((u64)priv->dsiclk / 4) * priv->dsi_lanes,
-				   mode->clock * 1000);
+				   vm.pixelclock);
 		tc358768_write(priv, TC358768_DSI_HSW, val);
 
 		/* hbp * byteclk * ndl / pclk */
-		val = (u32)div_u64((mode->htotal - mode->hsync_end) *
+		val = (u32)div_u64(vm.hback_porch *
 				   ((u64)priv->dsiclk / 4) * priv->dsi_lanes,
-				   mode->clock * 1000);
+				   vm.pixelclock);
 		tc358768_write(priv, TC358768_DSI_HBPR, val);
 	} else {
 		/* Set event mode */
 		tc358768_write(priv, TC358768_DSI_EVENT, 1);
 
 		/* vact */
-		tc358768_write(priv, TC358768_DSI_VACT, mode->vdisplay);
+		tc358768_write(priv, TC358768_DSI_VACT, vm.vactive);
 
 		/* vsw (+ vbp) */
 		tc358768_write(priv, TC358768_DSI_VSW,
-			       mode->vtotal - mode->vsync_start);
+			       vm.vsync_len + vm.vback_porch);
+
 		/* vbp (not used in event mode) */
 		tc358768_write(priv, TC358768_DSI_VBPR, 0);
 
 		/* (hsw + hbp) * byteclk * ndl / pclk */
-		val = (u32)div_u64((mode->htotal - mode->hsync_start) *
+		val = (u32)div_u64((vm.hsync_len + vm.hback_porch) *
 				   ((u64)priv->dsiclk / 4) * priv->dsi_lanes,
-				   mode->clock * 1000);
+				   vm.pixelclock);
 		tc358768_write(priv, TC358768_DSI_HSW, val);
 
 		/* hbp (not used in event mode) */
-- 
2.42.0



