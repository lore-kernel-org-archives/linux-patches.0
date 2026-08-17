Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3F723C51D;
	Mon, 17 Aug 2026 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977895; cv=none; b=iZNaWayXuIfA+vN7DVLUNTpMBEjdeep/QUz78/CmGcH2C4JiwVbSYbmlz08fRkftmMhHItZ7UuKg1Gb5sbRVw2KjsWxEKCGK9FzfXxNAAUvSWqNxDDKLbdmqDofQM2WXD81YOIzHIS0JK5dDcSg22JlRoUBN4//Tvzvy3q3O658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977895; c=relaxed/simple;
	bh=1cGLbL+eO0HxIrKdMkyx6SAktBItUbIeR35uoCD3A+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD/CV2cVopbmyKQ0eFOuncOaAE74bpivxOezsvl6DGA7SM3bV6VX4TyC+rvrLMqki7LaiDwagMeJ86VfWmlFH5b9lCysMjB4AbY6pyV4IG1aphcmBzDVBTD3eizqyyeHRFrCXBjiHrJIAsuAx9XbS57ifBdIRc5j41GW7f1/T0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFqRAOa0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFqRAOa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F551F000E9;
	Mon, 17 Aug 2026 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977893;
	bh=sFHh9UeMYo13AeZ9OghTyNDgYfC1qhZRx3wrxytYyG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFqRAOa0gtnoMq2uUNXp9DV+0IMN/QWBdebAXl4BxObvvj5NNl+LiNxKuxFy+sgkZ
	 7O75SNYw389g0m/Cf0vIkHkOQiuA1TTRQ+KwJ/FPA0oXJriL3+3i+5tyoaX356YKSc
	 jiwZ8/VM7G9mOippa3mck9RrzA4MORT2HxMo/Zx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <wayne.lin@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/181] drm/amd/display: Add AV mute wait frames to dce110_set_avmute
Date: Mon, 17 Aug 2026 15:31:37 +0200
Message-ID: <20260817132535.536371016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Wu <ray.wu@amd.com>

[ Upstream commit 443290d70b01e9c35830c300e3247c06581b594c ]

Port the three-frame wait logic from dcn30_set_avmute to
dce110_set_avmute so that older DCN versions (1.0, 2.0) also
wait for GCP packets to be sent out before proceeding.

This ensures HDMI sinks properly process the mute state,
preventing garbled display after link re-establishment.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5167
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 414da24137ace80d8c59fefd43ba3ec9f5f854ba)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dce110/dce110_hwseq.c | 21 ++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index 551638d9ff613..a4f092eb0857b 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1256,8 +1256,27 @@ void dce110_blank_stream(struct pipe_ctx *pipe_ctx)
 
 void dce110_set_avmute(struct pipe_ctx *pipe_ctx, bool enable)
 {
-	if (pipe_ctx != NULL && pipe_ctx->stream_res.stream_enc != NULL)
+	if (pipe_ctx == NULL || pipe_ctx->stream_res.stream_enc == NULL)
+		return;
+
+	if (dc_is_hdmi_signal(pipe_ctx->stream->signal)) {
 		pipe_ctx->stream_res.stream_enc->funcs->set_avmute(pipe_ctx->stream_res.stream_enc, enable);
+
+		/* Wait for three frames to make sure AV mute is sent out.
+		 * Some HDMI sinks need additional GCP packets to properly
+		 * process the mute state, especially after link re-establishment
+		 * with HDMI 2.0 scrambling enabled.
+		 */
+		if (enable && pipe_ctx->stream_res.tg->funcs->is_tg_enabled(pipe_ctx->stream_res.tg)) {
+			int i;
+
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			for (i = 0; i < 3; i++) {
+				pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
+				pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			}
+		}
+	}
 }
 
 static enum audio_dto_source translate_to_dto_source(enum controller_id crtc_id)
-- 
2.53.0



