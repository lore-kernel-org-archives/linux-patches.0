Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA197B
	for <patches@lists.linux.dev>; Fri,  6 Jan 2023 03:01:11 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id c4so373321plc.5
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 19:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FLEA2wQkQBIO15nu3HyGaLDd58pUqyHA63e/BahflBg=;
        b=gr1lwpg+ZbMVA7VcYOW5YvvzRvyk56qGEw34yRLVGhuBq+su/XvHWcwtgeYG5Q5API
         kQWl20V6HCSzhC+y3lpli6F+e5NnCI736lNGtNY3CR7LWYw9K1WOVN8CmTdTLHH/VHT1
         /UbBKNWAAha3z8idSR8hR8tlBNBJY87nnTfCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FLEA2wQkQBIO15nu3HyGaLDd58pUqyHA63e/BahflBg=;
        b=BqD+BiPEEKHhLPICqJIaaxjM0gBF+EhZYtls+28++wwkL9PQZSo4zWEGmmxiEBkxis
         LhuKmZUE/WNMBOO7LwR6YZxD68iNQwDokpy9YEZwgWzyRmWQwH8qdgdirCffIS4zuUZ6
         Wl7l5B2XzJ4JKBlghALv8s8HHn9MDUaqCwpgkfAbr0GFvUcWimHYevp3q7AkwG+MIdRQ
         cmn8Pf4wGAHtgp3ARuO127qdilV/MBuAZcNtWnbMc/KlqqGfyms5r6ss6dZExjniKjN9
         E8x6TUnm8U8sGAuyML/XU0imEnXoypMEe/8TFew1UpJBr/Xh23bSoxohxVoAe9+G/4Zx
         T3aw==
X-Gm-Message-State: AFqh2kq4ayJBjjWR98oT+XKCAZHDxDAHA57HIXYxSx3NBWCVn5mIE3yV
	YWG2oN/ab9oQSErjgrVilU2E7g==
X-Google-Smtp-Source: AMrXdXsomxVgbccv1usflDMgeLmsRP7BhyBVOMFDU6WowU+xXCKfXlkP0R8LnNIfb1r5yNksWji+AQ==
X-Received: by 2002:a05:6a20:cb44:b0:af:e129:cc4 with SMTP id hd4-20020a056a20cb4400b000afe1290cc4mr51387940pzb.41.1672974071148;
        Thu, 05 Jan 2023 19:01:11 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:d024:f69:ad7c:2653])
        by smtp.gmail.com with ESMTPSA id g38-20020a635666000000b004768b74f208sm21320pgm.4.2023.01.05.19.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 19:01:10 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	yangcong <yangcong5@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Jitao Shi <jitao.shi@mediatek.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Rob Clark <robdclark@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH] drm/panel: boe-tv101wum-nl6: Ensure DSI writes succeed during disable
Date: Thu,  5 Jan 2023 19:01:08 -0800
Message-Id: <20230106030108.2542081-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The unprepare sequence has started to fail after moving to panel bridge
code in the msm drm driver (commit 007ac0262b0d ("drm/msm/dsi: switch to
DRM_PANEL_BRIDGE")). You'll see messages like this in the kernel logs:

   panel-boe-tv101wum-nl6 ae94000.dsi.0: failed to set panel off: -22

This is because boe_panel_enter_sleep_mode() needs an operating DSI link
to set the panel into sleep mode. Performing those writes in the
unprepare phase of bridge ops is too late, because the link has already
been torn down by the DSI controller in post_disable, i.e. the PHY has
been disabled, etc. See dsi_mgr_bridge_post_disable() for more details
on the DSI .

Split the unprepare function into a disable part and an unprepare part.
For now, just the DSI writes to enter sleep mode are put in the disable
function. This fixes the panel off routine and keeps the panel happy.

My Wormdingler has an integrated touchscreen that stops responding to
touch if the panel is only half disabled too. This patch fixes it. And
finally, this saves power when the screen is off because without this
fix the regulators for the panel are left enabled when nothing is being
displayed on the screen.

Fixes: 007ac0262b0d ("drm/msm/dsi: switch to DRM_PANEL_BRIDGE")
Fixes: a869b9db7adf ("drm/panel: support for boe tv101wum-nl6 wuxga dsi video mode panel")
Cc: yangcong <yangcong5@huaqin.corp-partner.google.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Jitao Shi <jitao.shi@mediatek.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Clark <robdclark@chromium.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index 857a2f0420d7..c924f1124ebc 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -1193,14 +1193,11 @@ static int boe_panel_enter_sleep_mode(struct boe_panel *boe)
 	return 0;
 }
 
-static int boe_panel_unprepare(struct drm_panel *panel)
+static int boe_panel_disable(struct drm_panel *panel)
 {
 	struct boe_panel *boe = to_boe_panel(panel);
 	int ret;
 
-	if (!boe->prepared)
-		return 0;
-
 	ret = boe_panel_enter_sleep_mode(boe);
 	if (ret < 0) {
 		dev_err(panel->dev, "failed to set panel off: %d\n", ret);
@@ -1209,6 +1206,16 @@ static int boe_panel_unprepare(struct drm_panel *panel)
 
 	msleep(150);
 
+	return 0;
+}
+
+static int boe_panel_unprepare(struct drm_panel *panel)
+{
+	struct boe_panel *boe = to_boe_panel(panel);
+
+	if (!boe->prepared)
+		return 0;
+
 	if (boe->desc->discharge_on_disable) {
 		regulator_disable(boe->avee);
 		regulator_disable(boe->avdd);
@@ -1528,6 +1535,7 @@ static enum drm_panel_orientation boe_panel_get_orientation(struct drm_panel *pa
 }
 
 static const struct drm_panel_funcs boe_panel_funcs = {
+	.disable = boe_panel_disable,
 	.unprepare = boe_panel_unprepare,
 	.prepare = boe_panel_prepare,
 	.enable = boe_panel_enable,

base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
-- 
https://chromeos.dev

