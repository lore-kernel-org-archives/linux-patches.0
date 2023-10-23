Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2549515E86
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jymS1SSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9282AC433C7;
	Mon, 23 Oct 2023 11:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060461;
	bh=gDLuBmdfh9Khc5w00oiL+ds59cvSfyPnL4hRcnSb8QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jymS1SSfycvpYqa0Mj/i4jj7Kr42p41aVwUNWppCKPFkUsUS1JCG4LxjpMFzmDdna
	 6+uv/h7EJxO8ehYSJ0GY+viyu/Relts9acwQqxwxT7z3Lnn5BHj6avxI3nJbA+byay
	 8VvmBW9qYAz3J0/STUXF3FO8wUHkmW2QKkzAsWGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Bambura <jenneron@postmarketos.org>,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/196] drm/panel: Move AUX B116XW03 out of panel-edp back to panel-simple
Date: Mon, 23 Oct 2023 12:57:25 +0200
Message-ID: <20231023104833.486886775@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit ad3e33fe071dffea07279f96dab4f3773c430fe2 ]

In commit 5f04e7ce392d ("drm/panel-edp: Split eDP panels out of
panel-simple") I moved a pile of panels out of panel-simple driver
into the newly created panel-edp driver. One of those panels, however,
shouldn't have been moved.

As is clear from commit e35e305eff0f ("drm/panel: simple: Add AUO
B116XW03 panel support"), AUX B116XW03 is an LVDS panel. It's used in
exynos5250-snow and exynos5420-peach-pit where it's clear that the
panel is hooked up with LVDS. Furthermore, searching for datasheets I
found one that makes it clear that this panel is LVDS.

As far as I can tell, I got confused because in commit 88d3457ceb82
("drm/panel: auo,b116xw03: fix flash backlight when power on") Jitao
Shi added "DRM_MODE_CONNECTOR_eDP". That seems wrong. Looking at the
downstream ChromeOS trees, it seems like some Mediatek boards are
using a panel that they call "auo,b116xw03" that's an eDP panel. The
best I can guess is that they actually have a different panel that has
similar timing. If so then the proper panel should be used or they
should switch to the generic "edp-panel" compatible.

When moving this back to panel-edp, I wasn't sure what to use for
.bus_flags and .bus_format and whether to add the extra "enable" delay
from commit 88d3457ceb82 ("drm/panel: auo,b116xw03: fix flash
backlight when power on"). I've added formats/flags/delays based on my
(inexpert) analysis of the datasheet. These are untested.

NOTE: if/when this is backported to stable, we might run into some
trouble. Specifically, before 474c162878ba ("arm64: dts: mt8183:
jacuzzi: Move panel under aux-bus") this panel was used by
"mt8183-kukui-jacuzzi", which assumed it was an eDP panel. I don't
know what to suggest for that other than someone making up a bogus
panel for jacuzzi that's just for the stable channel.

Fixes: 88d3457ceb82 ("drm/panel: auo,b116xw03: fix flash backlight when power on")
Fixes: 5f04e7ce392d ("drm/panel-edp: Split eDP panels out of panel-simple")
Tested-by: Anton Bambura <jenneron@postmarketos.org>
Acked-by: Hsin-Yi Wang <hsinyi@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230925150010.1.Iff672233861bcc4cf25a7ad0a81308adc3bda8a4@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c    | 29 -----------------------
 drivers/gpu/drm/panel/panel-simple.c | 35 ++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index a163585a2a52b..2d22de9322281 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -978,32 +978,6 @@ static const struct panel_desc auo_b116xak01 = {
 	},
 };
 
-static const struct drm_display_mode auo_b116xw03_mode = {
-	.clock = 70589,
-	.hdisplay = 1366,
-	.hsync_start = 1366 + 40,
-	.hsync_end = 1366 + 40 + 40,
-	.htotal = 1366 + 40 + 40 + 32,
-	.vdisplay = 768,
-	.vsync_start = 768 + 10,
-	.vsync_end = 768 + 10 + 12,
-	.vtotal = 768 + 10 + 12 + 6,
-	.flags = DRM_MODE_FLAG_NVSYNC | DRM_MODE_FLAG_NHSYNC,
-};
-
-static const struct panel_desc auo_b116xw03 = {
-	.modes = &auo_b116xw03_mode,
-	.num_modes = 1,
-	.bpc = 6,
-	.size = {
-		.width = 256,
-		.height = 144,
-	},
-	.delay = {
-		.enable = 400,
-	},
-};
-
 static const struct drm_display_mode auo_b133han05_mode = {
 	.clock = 142600,
 	.hdisplay = 1920,
@@ -1727,9 +1701,6 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "auo,b116xa01",
 		.data = &auo_b116xak01,
-	}, {
-		.compatible = "auo,b116xw03",
-		.data = &auo_b116xw03,
 	}, {
 		.compatible = "auo,b133han05",
 		.data = &auo_b133han05,
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 0e8622ccd3a0f..00bb34c51d0cb 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -893,6 +893,38 @@ static const struct panel_desc auo_b101xtn01 = {
 	},
 };
 
+static const struct drm_display_mode auo_b116xw03_mode = {
+	.clock = 70589,
+	.hdisplay = 1366,
+	.hsync_start = 1366 + 40,
+	.hsync_end = 1366 + 40 + 40,
+	.htotal = 1366 + 40 + 40 + 32,
+	.vdisplay = 768,
+	.vsync_start = 768 + 10,
+	.vsync_end = 768 + 10 + 12,
+	.vtotal = 768 + 10 + 12 + 6,
+	.flags = DRM_MODE_FLAG_NVSYNC | DRM_MODE_FLAG_NHSYNC,
+};
+
+static const struct panel_desc auo_b116xw03 = {
+	.modes = &auo_b116xw03_mode,
+	.num_modes = 1,
+	.bpc = 6,
+	.size = {
+		.width = 256,
+		.height = 144,
+	},
+	.delay = {
+		.prepare = 1,
+		.enable = 200,
+		.disable = 200,
+		.unprepare = 500,
+	},
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+};
+
 static const struct display_timing auo_g070vvn01_timings = {
 	.pixelclock = { 33300000, 34209000, 45000000 },
 	.hactive = { 800, 800, 800 },
@@ -3952,6 +3984,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "auo,b101xtn01",
 		.data = &auo_b101xtn01,
+	}, {
+		.compatible = "auo,b116xw03",
+		.data = &auo_b116xw03,
 	}, {
 		.compatible = "auo,g070vvn01",
 		.data = &auo_g070vvn01,
-- 
2.42.0



