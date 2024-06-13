Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08A456458;
	Thu, 13 Jun 2024 12:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280327; cv=none; b=tPJEBQ1pBh8OhilEOzecYgBRS+cw+U6mcGd+dCR7V5hjJP+6yMUkbYIOEAFsuecEaIug1/bNQ+MtLPqnFernpA94gvCwFbC7h/5YyfzHt0GatFh4nhD84omgFWFHdSxVEwOPXf309OYpGqhHC1IYtMzNGxvp3Kj610m+DZq8vo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280327; c=relaxed/simple;
	bh=eyWNVO3pDoEz7AFMcwacsF1DUwmdMcCWJwRgG9cBMAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=et3zrTIh7QwJZ50/LGQ4lwN6p4LaS/BmTJEe1s8uHktzWgVcuCvgo244aPHBllRO3VeYE4Dq515DFdEayy3qE1DYVneD9eG/GeaLJJBx3/81idCEVwwZUx3yjCoKbOpYEko3Q5Gyh8SZb/bNRtpOv5H8B+tRvubUijYdJUsI5jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mluTJvwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mluTJvwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119ECC2BBFC;
	Thu, 13 Jun 2024 12:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280326;
	bh=eyWNVO3pDoEz7AFMcwacsF1DUwmdMcCWJwRgG9cBMAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mluTJvwz2aRQqq6LHKzLoE4w0AUAMsa+i13qRZnGr17OY7yoONozqxUOyahMdPk3L
	 ldfvSNwLr1y9uWAtfqEIACHNh9ZrTTnhsiWnHwAP0uvoqJelKcsfLpPaSlYoki5kAm
	 JfN7ew3g8Oo3+PbM8Fqv6gPQ4pij+UqB25MeaciQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 6.6 016/137] drm/sun4i: hdmi: Move mode_set into enable
Date: Thu, 13 Jun 2024 13:33:16 +0200
Message-ID: <20240613113223.920831380@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Maxime Ripard <mripard@kernel.org>

commit 9ca6bc2460359ed49b0ee87467fea784b1a42bf5 upstream.

We're not doing anything special in atomic_mode_set so we can simply
merge it into atomic_enable.

Acked-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240222-kms-hdmi-connector-state-v7-33-8f4af575fce2@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c |   38 ++++++++++++---------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
+++ b/drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c
@@ -103,33 +103,11 @@ static void sun4i_hdmi_enable(struct drm
 	struct drm_display_mode *mode = &encoder->crtc->state->adjusted_mode;
 	struct sun4i_hdmi *hdmi = drm_encoder_to_sun4i_hdmi(encoder);
 	struct drm_display_info *display = &hdmi->connector.display_info;
+	unsigned int x, y;
 	u32 val = 0;
 
 	DRM_DEBUG_DRIVER("Enabling the HDMI Output\n");
 
-	clk_prepare_enable(hdmi->tmds_clk);
-
-	sun4i_hdmi_setup_avi_infoframes(hdmi, mode);
-	val |= SUN4I_HDMI_PKT_CTRL_TYPE(0, SUN4I_HDMI_PKT_AVI);
-	val |= SUN4I_HDMI_PKT_CTRL_TYPE(1, SUN4I_HDMI_PKT_END);
-	writel(val, hdmi->base + SUN4I_HDMI_PKT_CTRL_REG(0));
-
-	val = SUN4I_HDMI_VID_CTRL_ENABLE;
-	if (display->is_hdmi)
-		val |= SUN4I_HDMI_VID_CTRL_HDMI_MODE;
-
-	writel(val, hdmi->base + SUN4I_HDMI_VID_CTRL_REG);
-}
-
-static void sun4i_hdmi_mode_set(struct drm_encoder *encoder,
-				struct drm_crtc_state *crtc_state,
-				struct drm_connector_state *conn_state)
-{
-	const struct drm_display_mode *mode = &crtc_state->mode;
-	struct sun4i_hdmi *hdmi = drm_encoder_to_sun4i_hdmi(encoder);
-	unsigned int x, y;
-	u32 val;
-
 	clk_set_rate(hdmi->mod_clk, mode->crtc_clock * 1000);
 	clk_set_rate(hdmi->tmds_clk, mode->crtc_clock * 1000);
 
@@ -181,6 +159,19 @@ static void sun4i_hdmi_mode_set(struct d
 		val |= SUN4I_HDMI_VID_TIMING_POL_VSYNC;
 
 	writel(val, hdmi->base + SUN4I_HDMI_VID_TIMING_POL_REG);
+
+	clk_prepare_enable(hdmi->tmds_clk);
+
+	sun4i_hdmi_setup_avi_infoframes(hdmi, mode);
+	val |= SUN4I_HDMI_PKT_CTRL_TYPE(0, SUN4I_HDMI_PKT_AVI);
+	val |= SUN4I_HDMI_PKT_CTRL_TYPE(1, SUN4I_HDMI_PKT_END);
+	writel(val, hdmi->base + SUN4I_HDMI_PKT_CTRL_REG(0));
+
+	val = SUN4I_HDMI_VID_CTRL_ENABLE;
+	if (display->is_hdmi)
+		val |= SUN4I_HDMI_VID_CTRL_HDMI_MODE;
+
+	writel(val, hdmi->base + SUN4I_HDMI_VID_CTRL_REG);
 }
 
 static enum drm_mode_status sun4i_hdmi_mode_valid(struct drm_encoder *encoder,
@@ -206,7 +197,6 @@ static const struct drm_encoder_helper_f
 	.atomic_check	= sun4i_hdmi_atomic_check,
 	.atomic_disable	= sun4i_hdmi_disable,
 	.atomic_enable	= sun4i_hdmi_enable,
-	.atomic_mode_set	= sun4i_hdmi_mode_set,
 	.mode_valid	= sun4i_hdmi_mode_valid,
 };
 


