Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A484F3C8C65;
	Mon, 17 Aug 2026 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973953; cv=none; b=rjq840v9WPXFw1MMB0n7DsfGSJ9VXTIkVfPQ3+Oba2AvZL9G/NNFTuh5HPe0FdKcLzNk6b3m160ImZNFW4jJ2HzPEnqNguK3JQHY48OKlSnBb1xMUnqD7E3PYLJMUfggYQD1em7W63+sRGevWSWnXgATX4UwY2LK4I/izZZKYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973953; c=relaxed/simple;
	bh=2m/gmEbpENvtQf989/otsh6ia7v2bhWWJtm4Tcd0W/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcnMinKfkoMy8GGhh3AT+II8+J7XrTMkQeYVQ8nq89hNc1nx1p+FN9AdGv++rwhHmUrjR/NXauCvdfp+u8LrqZdmw2wtK8R+FVcRixwsI0pBmEgCMWKVVKuDtwnEpDMPXa7IXJ3C7D23oBb6n6H3fMhQUNlQ68fzjyJSxl3IkBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3JGmEIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3JGmEIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E901F000E9;
	Mon, 17 Aug 2026 13:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973952;
	bh=XSV/2qUFMFTF1Hr6hfYShcvY6UvO4+DqdF022oAdf0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3JGmEIMrSG98CVpSWnK4IjtOrQabSAPDXa11RH+YsPCJyckllQfcBTNBpBO/6Rn6
	 MDt653Zw17N1Eq7fPq34Sm/ECAE1XgqDDf4vINH+uUMIRaAYc0/vWSmOd8recIFF7Q
	 kRTT2L1964T8g1inpQjuWJaWcCsaX1wLMqyBcVsE=
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
Subject: [PATCH 7.1 005/271] drm/amd/display: Add AV mute wait frames to dce110_set_avmute
Date: Mon, 17 Aug 2026 15:28:50 +0200
Message-ID: <20260817132536.974206254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f0abbb7c2cb24..d2a27aca6cd76 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1320,8 +1320,27 @@ void dce110_blank_stream(struct pipe_ctx *pipe_ctx)
 
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
 
 enum audio_dto_source translate_to_dto_source(enum controller_id crtc_id)
-- 
2.53.0



