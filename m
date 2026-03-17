Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E342F3E3DB1;
	Tue, 17 Mar 2026 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766841; cv=none; b=u3MffjEjXYF7yfSx27zVK3WZi9VbAs7XIh7WESAHDDt1WmtTT0jLfpeWS3c2TzbCZG7GyQZz5k8sTqCfQSdFJrkFjF2T4jBVmvRqAGox/OzyOBOWI/VtgOHcp1JaTK4A7NqucgVgdXkHDR4bbzHeK07gPzCPSgQ/tkex6gd7+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766841; c=relaxed/simple;
	bh=HEVu+d005N1ob4GgHJ2NgFTKCUXEeisZmUO63kvgsw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3ND3jnFDA/ZV570x2f8I9lW5b0/tP8x3ZbU8BEssOST8f5Qg0HPPZrCDywqXOV92ZyZqvJUGFl0vN+JlpgLtFQlROs6FpSrDTjcl6mSFWMlz8jHA5JSzMvWoaaEcp7O2Z7eiNbEdwZ9KsUgIzlf4wCJM0Z1gh/v+8KZoigqskw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8VzeoEB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8VzeoEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D702C4CEF7;
	Tue, 17 Mar 2026 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766840;
	bh=HEVu+d005N1ob4GgHJ2NgFTKCUXEeisZmUO63kvgsw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8VzeoEBb+8TI/SHm8YVvHZJNBIQhx2mRvgxMI8jK+993QHFXeVUtRH855ld6AC7l
	 yxBX5WteQo+pWeP1SSBB4Fc0iN5SUe4QYLzSuXi69TzEMyYDowAqWXvhMmbb8s26YN
	 T2SXPwNQCZF/6WwNkSU7a9zb3uekWcOGg+BrEk5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.19 305/378] drm/bridge: ti-sn65dsi83: halve horizontal syncs for dual LVDS output
Date: Tue, 17 Mar 2026 17:34:22 +0100
Message-ID: <20260317163018.222560885@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Ceresoli <luca.ceresoli@bootlin.com>

commit d0d727746944096a6681dc6adb5f123fc5aa018d upstream.

Dual LVDS output (available on the SN65DSI84) requires HSYNC_PULSE_WIDTH
and HORIZONTAL_BACK_PORCH to be divided by two with respect to the values
used for single LVDS output.

While not clearly stated in the datasheet, this is needed according to the
DSI Tuner [0] output. It also makes sense intuitively because in dual LVDS
output two pixels at a time are output and so the output clock is half of
the pixel clock.

Some dual-LVDS panels refuse to show any picture without this fix.

Divide by two HORIZONTAL_FRONT_PORCH too, even though this register is used
only for test pattern generation which is not currently implemented by this
driver.

[0] https://www.ti.com/tool/DSI-TUNER

Fixes: ceb515ba29ba ("drm/bridge: ti-sn65dsi83: Add TI SN65DSI83 and SN65DSI84 driver")
Cc: stable@vger.kernel.org
Reviewed-by: Marek Vasut <marek.vasut@mailbox.org>
Link: https://patch.msgid.link/20260226-ti-sn65dsi83-dual-lvds-fixes-and-test-pattern-v1-2-2e15f5a9a6a0@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -474,6 +474,7 @@ static void sn65dsi83_atomic_pre_enable(
 					struct drm_atomic_state *state)
 {
 	struct sn65dsi83 *ctx = bridge_to_sn65dsi83(bridge);
+	const unsigned int dual_factor = ctx->lvds_dual_link ? 2 : 1;
 	const struct drm_bridge_state *bridge_state;
 	const struct drm_crtc_state *crtc_state;
 	const struct drm_display_mode *mode;
@@ -606,18 +607,18 @@ static void sn65dsi83_atomic_pre_enable(
 	/* 32 + 1 pixel clock to ensure proper operation */
 	le16val = cpu_to_le16(32 + 1);
 	regmap_bulk_write(ctx->regmap, REG_VID_CHA_SYNC_DELAY_LOW, &le16val, 2);
-	le16val = cpu_to_le16(mode->hsync_end - mode->hsync_start);
+	le16val = cpu_to_le16((mode->hsync_end - mode->hsync_start) / dual_factor);
 	regmap_bulk_write(ctx->regmap, REG_VID_CHA_HSYNC_PULSE_WIDTH_LOW,
 			  &le16val, 2);
 	le16val = cpu_to_le16(mode->vsync_end - mode->vsync_start);
 	regmap_bulk_write(ctx->regmap, REG_VID_CHA_VSYNC_PULSE_WIDTH_LOW,
 			  &le16val, 2);
 	regmap_write(ctx->regmap, REG_VID_CHA_HORIZONTAL_BACK_PORCH,
-		     mode->htotal - mode->hsync_end);
+		     (mode->htotal - mode->hsync_end) / dual_factor);
 	regmap_write(ctx->regmap, REG_VID_CHA_VERTICAL_BACK_PORCH,
 		     mode->vtotal - mode->vsync_end);
 	regmap_write(ctx->regmap, REG_VID_CHA_HORIZONTAL_FRONT_PORCH,
-		     mode->hsync_start - mode->hdisplay);
+		     (mode->hsync_start - mode->hdisplay) / dual_factor);
 	regmap_write(ctx->regmap, REG_VID_CHA_VERTICAL_FRONT_PORCH,
 		     mode->vsync_start - mode->vdisplay);
 	regmap_write(ctx->regmap, REG_VID_CHA_TEST_PATTERN, 0x00);


