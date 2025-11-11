Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305012DC328;
	Tue, 11 Nov 2025 01:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823667; cv=none; b=k5zsg3UAoJAlAoikOy7DjQQo5iFIIDP6eDTDwu9RNjk9Aw362WNUqKK6d1AdvX4jaDYRDg60OEVv9vqMeD6jlyPMzA+MxD0ateP4p3ImBV2d8KIR8TQPZFVq1qjnpQvvI6pHd2VIi7ghvPd07dyPeYIfjO2Ud4W7mVVwMs5zm70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823667; c=relaxed/simple;
	bh=1Kyum33o7pMYV2OAoH3MMpV/ZbfGYDqSArgTtXepRAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neA3myHcD6MggR7K2gbVvZ3blJTiPreScZTgNEFY+NF0LWB+6h4duFsHV44W0O1nRgc/MS+ANrJVT+p+F1mXETHSzkD3MMduJBGkY0Kx9FA7RpkfO8mRwcfyfhYXQzLafX4yjFz8I6+cSyJRnmBzlLHzv0h+CDjdu7A8nHkE5hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsnmgmyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsnmgmyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5ADC116B1;
	Tue, 11 Nov 2025 01:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823666;
	bh=1Kyum33o7pMYV2OAoH3MMpV/ZbfGYDqSArgTtXepRAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsnmgmyId5eHz5MY5LpGV9ptztgJroM2rHhKgrilXQ1vU+Q9x99YR+aK7Qhh4ITat
	 lkVsXHHyydZ7UlIoRzwBwpLL1voSYkeGEq90j4Ia8UyEjls2wOR+wdmi5EQ5nAP2Zo
	 5F1ghrKq+0vp896Mrpm0lk33O8dQHQMBrq3GrDDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 346/849] drm/panel: ilitek-ili9881c: move display_on/_off dcs calls to (un-)prepare
Date: Tue, 11 Nov 2025 09:38:36 +0900
Message-ID: <20251111004544.784057282@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 5efa82492066fcb32308210fb3f0b752af74334f ]

At least for panel-bridges, the atomic_enable call is defined as being
called right after the preceding element in the display pipe is enabled.

It is also stated that "The bridge can assume that the display pipe (i.e.
clocks and timing signals) feeding it is running when this callback is
called"

This means the DSI controller driving this display would have already
switched over to video-mode from command mode and thus dcs functions
should not be called anymore at this point.

This caused a non-working display for me, when trying to enable
the rk3576 dsi controller using a display using this controller.

Therefore move the display_on/off calls the more appropriate
prepare/unprepare callbacks.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250707164906.1445288-3-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c | 27 +++++--------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
index 3af22a5f5700c..7ed65d6762d86 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -1509,35 +1509,24 @@ static int ili9881c_prepare(struct drm_panel *panel)
 	if (ret)
 		goto disable_power;
 
-	return 0;
-
-disable_power:
-	regulator_disable(ctx->power);
-	return ret;
-}
-
-static int ili9881c_enable(struct drm_panel *panel)
-{
-	struct ili9881c *ctx = panel_to_ili9881c(panel);
-
 	msleep(120);
 
-	mipi_dsi_dcs_set_display_on(ctx->dsi);
+	ret = mipi_dsi_dcs_set_display_on(ctx->dsi);
+	if (ret)
+		goto disable_power;
 
 	return 0;
-}
 
-static int ili9881c_disable(struct drm_panel *panel)
-{
-	struct ili9881c *ctx = panel_to_ili9881c(panel);
-
-	return mipi_dsi_dcs_set_display_off(ctx->dsi);
+disable_power:
+	regulator_disable(ctx->power);
+	return ret;
 }
 
 static int ili9881c_unprepare(struct drm_panel *panel)
 {
 	struct ili9881c *ctx = panel_to_ili9881c(panel);
 
+	mipi_dsi_dcs_set_display_off(ctx->dsi);
 	mipi_dsi_dcs_enter_sleep_mode(ctx->dsi);
 	regulator_disable(ctx->power);
 	gpiod_set_value_cansleep(ctx->reset, 1);
@@ -1710,8 +1699,6 @@ static enum drm_panel_orientation ili9881c_get_orientation(struct drm_panel *pan
 static const struct drm_panel_funcs ili9881c_funcs = {
 	.prepare	= ili9881c_prepare,
 	.unprepare	= ili9881c_unprepare,
-	.enable		= ili9881c_enable,
-	.disable	= ili9881c_disable,
 	.get_modes	= ili9881c_get_modes,
 	.get_orientation = ili9881c_get_orientation,
 };
-- 
2.51.0



