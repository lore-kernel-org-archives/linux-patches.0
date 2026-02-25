Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65CF1E2834;
	Wed, 25 Feb 2026 01:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983702; cv=none; b=C6IkanJNNOxXXvF+L9PGWet1ktLVP5UPQgcDk1FAw+SHmZCE2Bqhfv9oFYAq841EszvHFiuAO0620wULvgvdYg4ANxPXZUEQRVi5SiiNsfywRQCSVJP06Inknbj/WK6T0x5pFbLL9PvkKWR934UacPiI1R/LxOM9E0A432c+fxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983702; c=relaxed/simple;
	bh=gJ5uysqsrHe5FZEG/3c2ZdfqMNgzGWHBw1l7edlkIkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKxUDbwx6VUEHsMZtEShfxcjrEepquLIyDPNJTo+IuneqpM1kW+3AZb76TqZAeq0SUELwOPMZr9ceVhjNVOfXZitgJIWd9d/gBtIyxsgl7d4LpFi5R2ZJjRPvaoHWNJN1St3jovONgYfLy3t/B8KfNSgCfi9vLEEp6C1hOqZWW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWLux17r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWLux17r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51D9C116D0;
	Wed, 25 Feb 2026 01:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983701;
	bh=gJ5uysqsrHe5FZEG/3c2ZdfqMNgzGWHBw1l7edlkIkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWLux17rYGMK/sach7woa2MKOHSPLEzpxBHT2hk6WXHRqi6z91j+F93l5FnXU8eXT
	 jH/hxfMBMP9Q5fgj3xrmRyOublTpc/2xJo4opE0BeozA23oIYwCg0HFh30ykwJ77bd
	 Ay9TshkT+7ftYoekNzsokZ2BXZENo3V8wXPej+Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mauro Rossi <issor.oruam@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 746/781] drm/amd/display: Turn off DAC in DCE link encoder using VBIOS
Date: Tue, 24 Feb 2026 17:24:15 -0800
Message-ID: <20260225012418.022275485@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit e021ee995056ee7e58114edd92bcd4578d8b4bb5 ]

Apparently, the VBIOS DAC1EncoderControl function is much more
graceful about turning off the DAC. It writes various DAC
registers in a specific sequence. Use that instead of just
clearing the DAC_ENABLE register.

Do this in just the dce110_link_encoder_disable_output
function and remove it from the HWSS.

Fixes: 0fbe321a93ce ("drm/amd/display: Implement DCE analog link encoders (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Tested-by: Mauro Rossi <issor.oruam@gmail.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dce/dce_link_encoder.c | 30 +++++++++++--------
 .../amd/display/dc/hwss/dce110/dce110_hwseq.c |  3 --
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 5c1a10f77733a..2e742950a62c7 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -131,6 +131,21 @@ static enum bp_result link_transmitter_control(
 	return result;
 }
 
+static enum bp_result link_dac_encoder_control(
+	struct dce110_link_encoder *link_enc,
+	enum bp_encoder_control_action action,
+	uint32_t pix_clk_100hz)
+{
+	struct dc_bios *bios = link_enc->base.ctx->dc_bios;
+	struct bp_encoder_control encoder_control = {0};
+
+	encoder_control.action = action;
+	encoder_control.engine_id = link_enc->base.analog_engine;
+	encoder_control.pixel_clock = pix_clk_100hz / 10;
+
+	return bios->funcs->encoder_control(bios, &encoder_control);
+}
+
 static void enable_phy_bypass_mode(
 	struct dce110_link_encoder *enc110,
 	bool enable)
@@ -1337,19 +1352,8 @@ void dce110_link_encoder_disable_output(
 	struct bp_transmitter_control cntl = { 0 };
 	enum bp_result result;
 
-	switch (enc->analog_engine) {
-	case ENGINE_ID_DACA:
-		REG_UPDATE(DAC_ENABLE, DAC_ENABLE, 0);
-		break;
-	case ENGINE_ID_DACB:
-		/* DACB doesn't seem to be present on DCE6+,
-		 * although there are references to it in the register file.
-		 */
-		DC_LOG_ERROR("%s DACB is unsupported\n", __func__);
-		break;
-	default:
-		break;
-	}
+	if (enc->analog_engine != ENGINE_ID_UNKNOWN)
+		link_dac_encoder_control(enc110, ENCODER_CONTROL_DISABLE, 0);
 
 	/* The code below only applies to connectors that support digital signals. */
 	if (enc->transmitter == TRANSMITTER_UNKNOWN)
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index ebd74b43e935e..fd41e52e4d2f1 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1218,9 +1218,6 @@ void dce110_disable_stream(struct pipe_ctx *pipe_ctx)
 		dccg->funcs->disable_symclk_se(dccg, stream_enc->stream_enc_inst,
 					       link_enc->transmitter - TRANSMITTER_UNIPHY_A);
 	}
-
-	if (dc_is_rgb_signal(pipe_ctx->stream->signal))
-		dce110_dac_encoder_control(pipe_ctx, false);
 }
 
 void dce110_unblank_stream(struct pipe_ctx *pipe_ctx,
-- 
2.51.0



