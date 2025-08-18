Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3520927B358;
	Mon, 18 Aug 2025 13:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525547; cv=none; b=rwjYnCNF1MKT+WJs+Hjsl23uCcM5r9q51qW8hETG03/fKCcgnDa0M8SxIt8kvE1a1ieE8NzZjAmlLGDEO7MhH3cUxXiUrKCJCoBY+iMNorRIqHbFnPy5E8ueFS8REy6CKXuPMJzGhCHdUB2D6zoOcNXBk8hi968n3VX8551MvOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525547; c=relaxed/simple;
	bh=Gk16XEps7z2W5oGGPkWamH1dP9b+KopYJg8HZn75R10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAbwTPe7GZg3jw56KeWL9ue4yG+yI7MRwUewDE+RHwwUgfkqlKBM4eIle9+AK6Xr5adFdl3m992Q0x1YDE0YKjarC+QxQVFDghSrasU+eTUy+iMhdEkvZ1DRWGu2RIUBcFh5a7hgZPm02UEU3vUXBMhZKK/pVEaBioNC8oSCeR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWHswkYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWHswkYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C5C4CEEB;
	Mon, 18 Aug 2025 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525547;
	bh=Gk16XEps7z2W5oGGPkWamH1dP9b+KopYJg8HZn75R10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWHswkYzm9qT1WD8G9Yww/LgQBgsRcHRJf0L35vg04ZHbfYAtK1cwSRSDXrvti1XK
	 YCKHyeer2GqXZUqOfehgqD+8V1qBpGrI9nPjA8Cpg9ZMCTawccUUWCT1ZO4Fqeee/8
	 d/EXnElOfKts8gRGWIQKcO4C0lplcvuXuTuplHCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 295/570] drm/panel: raydium-rm67200: Move initialization from enable() to prepare stage
Date: Mon, 18 Aug 2025 14:44:42 +0200
Message-ID: <20250818124517.215844091@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andy.yan@rock-chips.com>

[ Upstream commit 691674a282bdbf8f8bce4094369a2d1e4b5645e9 ]

The DSI host has different modes in prepare() and enable() functions,
prepare() is in LP command mode and enable() is in HS video mode.

>From our experience, generally the initialization sequence needs to be
sent in the LP command mode.

Move the setup init function from enable() to prepare() to fix a display
shift on rk3568 evb.

Tested on rk3568/rk3576/rk3588 EVB.

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250618091520.691590-1-andyshrk@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-raydium-rm67200.c | 22 ++++++-------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-raydium-rm67200.c b/drivers/gpu/drm/panel/panel-raydium-rm67200.c
index 64b685dc11f6..6d4d00d4cd74 100644
--- a/drivers/gpu/drm/panel/panel-raydium-rm67200.c
+++ b/drivers/gpu/drm/panel/panel-raydium-rm67200.c
@@ -318,6 +318,7 @@ static void w552793baa_setup(struct mipi_dsi_multi_context *ctx)
 static int raydium_rm67200_prepare(struct drm_panel *panel)
 {
 	struct raydium_rm67200 *ctx = to_raydium_rm67200(panel);
+	struct mipi_dsi_multi_context mctx = { .dsi = ctx->dsi };
 	int ret;
 
 	ret = regulator_bulk_enable(ctx->num_supplies, ctx->supplies);
@@ -328,6 +329,12 @@ static int raydium_rm67200_prepare(struct drm_panel *panel)
 
 	msleep(60);
 
+	ctx->panel_info->panel_setup(&mctx);
+	mipi_dsi_dcs_exit_sleep_mode_multi(&mctx);
+	mipi_dsi_msleep(&mctx, 120);
+	mipi_dsi_dcs_set_display_on_multi(&mctx);
+	mipi_dsi_msleep(&mctx, 30);
+
 	return 0;
 }
 
@@ -343,20 +350,6 @@ static int raydium_rm67200_unprepare(struct drm_panel *panel)
 	return 0;
 }
 
-static int raydium_rm67200_enable(struct drm_panel *panel)
-{
-	struct raydium_rm67200 *rm67200 = to_raydium_rm67200(panel);
-	struct mipi_dsi_multi_context ctx = { .dsi = rm67200->dsi };
-
-	rm67200->panel_info->panel_setup(&ctx);
-	mipi_dsi_dcs_exit_sleep_mode_multi(&ctx);
-	mipi_dsi_msleep(&ctx, 120);
-	mipi_dsi_dcs_set_display_on_multi(&ctx);
-	mipi_dsi_msleep(&ctx, 30);
-
-	return ctx.accum_err;
-}
-
 static int raydium_rm67200_disable(struct drm_panel *panel)
 {
 	struct raydium_rm67200 *rm67200 = to_raydium_rm67200(panel);
@@ -381,7 +374,6 @@ static const struct drm_panel_funcs raydium_rm67200_funcs = {
 	.prepare = raydium_rm67200_prepare,
 	.unprepare = raydium_rm67200_unprepare,
 	.get_modes = raydium_rm67200_get_modes,
-	.enable = raydium_rm67200_enable,
 	.disable = raydium_rm67200_disable,
 };
 
-- 
2.39.5



