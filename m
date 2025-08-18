Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B46B21CC58;
	Mon, 18 Aug 2025 13:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523796; cv=none; b=KX9PIaZMCbbwR7TxErQc2B77YZF+97H7O+DS6RIMWhzXI2h3d3pRiVSqqpYkIgARl3a5OWgnOPI6VC+P2peqRhEBsMf5ZF1Q5mFITABzRM8k03or/+g1GCJ0EjfDwmqkgBZy1njPOE4VkSJT4UI9kT+XaOlCY9s3YQzpQxaTYbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523796; c=relaxed/simple;
	bh=ND/vVST3fuLWkSyrmGStfVUTEYKfrTPtfDfG3FV9Hbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7zgUKaJkFWS6/VLCdsfTq8HN6aszdeBXpLfKRiAXG3qvVApmeuOKrPfzWXArEBjnxkBEiwNrbCHtJj80NtF5F/pSZmE6bOdjSUg2d3bw8cQywWSRoygmg4H6ImC6V5+U6McHHg+aEpcnJGHxFw8O/uxmKQrBzzVv04bUMgE8tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqlN5SUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqlN5SUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D0DC4CEEB;
	Mon, 18 Aug 2025 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523796;
	bh=ND/vVST3fuLWkSyrmGStfVUTEYKfrTPtfDfG3FV9Hbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqlN5SUH0bVl7bL8Una/XwShDwLGRzYv3q5B4T7U6/MitUw/a+bSfjNKC14uDLpxJ
	 S+64deFhv0VF8/tZvky98/9YMVhsuP7QursmqLdamtaOmYPaVtX7mRk5fk2jpZVIE5
	 UjEfKvaaOpCJ4Q4Yfx9BaC+CjT3HfslbXzvviLt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 275/515] drm/panel: raydium-rm67200: Move initialization from enable() to prepare stage
Date: Mon, 18 Aug 2025 14:44:21 +0200
Message-ID: <20250818124509.005686034@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



