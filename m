Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA3D243376;
	Wed, 25 Feb 2026 01:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983084; cv=none; b=CZOfbhlMvsoFCFMQ+oNiCViGoWXbGOB8NaM5lftFYCj+mpQqYqOH913NGkJotNge9v382QgEzP9Ok3clMFfz+hyhuu602nl2IN5azHZvdUUxr4uwaDWSfOZPqisdTEUVqHLexqzkiafH+IHcIioUwq7NnFs+v1OWoC4d/L8VfE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983084; c=relaxed/simple;
	bh=JNXizagqVJ4cOyL/Uia+v14FlHn3nTTT/oDr0og4Hy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rXKvnZDeef6l+GGfPpR+FTeO5ef9OHmadFfNr2lqGafYFLqVZn1XWCvQ9dm5SBlLESt3IL6krJyY5bynNZX5WzgegQosje0GOskLFjyjM7BsUZY9EU4MpqFtErBs1DM+L8d/tD4lVh8vI/zTZovlRViWQahb5dahRXDxuUkMs8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2rxHba1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2rxHba1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CA0C116D0;
	Wed, 25 Feb 2026 01:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983083;
	bh=JNXizagqVJ4cOyL/Uia+v14FlHn3nTTT/oDr0og4Hy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2rxHba1gadHSEUsD2YG3bEs78p7j5I+6UofR9SzQ8DK96y4QMTLquYlZQgayMJiT
	 JIgFsEoEPGqa0NXN9El3VXH0DmTDEUlb+pQPsaHrD/ZyffVdATL/Zr/hlt/s/DEij1
	 Ff+o9Qb1Twu6kTWaBdYFrVfNJbZt1lefjQGUehqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 244/781] drm/amd/display: Pass proper DAC encoder ID to VBIOS
Date: Tue, 24 Feb 2026 17:15:53 -0800
Message-ID: <20260225012405.691967988@linuxfoundation.org>
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

[ Upstream commit 436d0d22aa7035a9f9b24fb14cd0e84d6571ea87 ]

Similarly to the analog_engine field, add a new	analog_id field
which contains the encoder ID of the analog encoder that
corresponds to the link encoder.

Previously, the default encoder ID of the link encoder was used,
which meant that we passed the wrong ID in case of DVI-I.

Fixes: 5834c33fd3f6 ("drm/amd/display: Add concept of analog encoders (v2)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c |  2 ++
 drivers/gpu/drm/amd/display/dc/inc/hw/link_encoder.h  |  2 ++
 drivers/gpu/drm/amd/display/dc/link/link_factory.c    | 11 ++++++-----
 .../amd/display/dc/resource/dce110/dce110_resource.c  |  2 ++
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 87dbb8d7ed27d..5c1a10f77733a 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -850,6 +850,7 @@ void dce110_link_encoder_construct(
 	enc110->base.funcs = &dce110_lnk_enc_funcs;
 	enc110->base.ctx = init_data->ctx;
 	enc110->base.id = init_data->encoder;
+	enc110->base.analog_id = init_data->analog_encoder;
 
 	enc110->base.hpd_source = init_data->hpd_source;
 	enc110->base.connector = init_data->connector;
@@ -1793,6 +1794,7 @@ void dce60_link_encoder_construct(
 	enc110->base.funcs = &dce60_lnk_enc_funcs;
 	enc110->base.ctx = init_data->ctx;
 	enc110->base.id = init_data->encoder;
+	enc110->base.analog_id = init_data->analog_encoder;
 
 	enc110->base.hpd_source = init_data->hpd_source;
 	enc110->base.connector = init_data->connector;
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/link_encoder.h b/drivers/gpu/drm/amd/display/dc/inc/hw/link_encoder.h
index df512920a9fab..e638325e35ecf 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/link_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/link_encoder.h
@@ -47,6 +47,7 @@ struct encoder_init_data {
 	enum hpd_source_id hpd_source;
 	/* TODO: in DAL2, here was pointer to EventManagerInterface */
 	struct graphics_object_id encoder;
+	struct graphics_object_id analog_encoder;
 	enum engine_id analog_engine;
 	struct dc_context *ctx;
 	enum transmitter transmitter;
@@ -81,6 +82,7 @@ struct link_encoder {
 	int32_t aux_channel_offset;
 	struct dc_context *ctx;
 	struct graphics_object_id id;
+	struct graphics_object_id analog_id;
 	struct graphics_object_id connector;
 	uint32_t output_signals;
 	enum engine_id preferred_engine;
diff --git a/drivers/gpu/drm/amd/display/dc/link/link_factory.c b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
index c79c18efb6f89..d9cb6b6714009 100644
--- a/drivers/gpu/drm/amd/display/dc/link/link_factory.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_factory.c
@@ -433,20 +433,19 @@ static enum channel_id get_ddc_line(struct dc_link *link)
 	return channel;
 }
 
-static enum engine_id find_analog_engine(struct dc_link *link)
+static enum engine_id find_analog_engine(struct dc_link *link, struct graphics_object_id *enc)
 {
 	struct dc_bios *bp = link->ctx->dc_bios;
-	struct graphics_object_id encoder = {0};
 	enum bp_result bp_result = BP_RESULT_OK;
 	int i;
 
 	for (i = 0; i < 3; i++) {
-		bp_result = bp->funcs->get_src_obj(bp, link->link_id, i, &encoder);
+		bp_result = bp->funcs->get_src_obj(bp, link->link_id, i, enc);
 
 		if (bp_result != BP_RESULT_OK)
 			return ENGINE_ID_UNKNOWN;
 
-		switch (encoder.id) {
+		switch (enc->id) {
 		case ENCODER_ID_INTERNAL_DAC1:
 		case ENCODER_ID_INTERNAL_KLDSCP_DAC1:
 			return ENGINE_ID_DACA;
@@ -456,6 +455,7 @@ static enum engine_id find_analog_engine(struct dc_link *link)
 		}
 	}
 
+	memset(enc, 0, sizeof(*enc));
 	return ENGINE_ID_UNKNOWN;
 }
 
@@ -508,7 +508,7 @@ static bool construct_phy(struct dc_link *link,
 	 */
 	bp_funcs->get_src_obj(bios, link->link_id, 0, &link_encoder);
 	transmitter_from_encoder = translate_encoder_to_transmitter(link_encoder);
-	link_analog_engine = find_analog_engine(link);
+	link_analog_engine = find_analog_engine(link, &enc_init_data.analog_encoder);
 
 	if (transmitter_from_encoder == TRANSMITTER_UNKNOWN &&
 	    !analog_engine_supported(link_analog_engine)) {
@@ -648,6 +648,7 @@ static bool construct_phy(struct dc_link *link,
 	enc_init_data.channel = get_ddc_line(link);
 	enc_init_data.hpd_source = get_hpd_line(link);
 	enc_init_data.transmitter = transmitter_from_encoder;
+	enc_init_data.analog_engine = find_analog_engine(link, &enc_init_data.analog_encoder);
 	enc_init_data.encoder = link_encoder;
 	enc_init_data.analog_engine = link_analog_engine;
 
diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c
index cd54382c0af3e..7c09825cd9bd3 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce110/dce110_resource.c
@@ -895,6 +895,8 @@ static void get_pixel_clock_parameters(
 	 */
 	pixel_clk_params->requested_pix_clk_100hz = stream->timing.pix_clk_100hz;
 	pixel_clk_params->encoder_object_id = stream->link->link_enc->id;
+	if (dc_is_rgb_signal(pipe_ctx->stream->signal))
+		pixel_clk_params->encoder_object_id = stream->link->link_enc->analog_id;
 	pixel_clk_params->signal_type = pipe_ctx->stream->signal;
 	pixel_clk_params->controller_id = pipe_ctx->stream_res.tg->inst + 1;
 	/* TODO: un-hardcode*/
-- 
2.51.0



