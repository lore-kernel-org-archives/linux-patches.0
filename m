Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DE81DFF4;
	Mon,  1 Apr 2024 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991024; cv=none; b=Z9kfdu4ycqnhJqtmY0ndvSdtqUepNXH3X/sMd78vJRr1LcaIqdFjgQMMxPmNpzRU4mlGHOzSoJ7cYYDZFM4nDx01BGTXosbD116RP898sH0HJB2wSy9yFORQr127c8ilY2YcpbfXsjkavuTEiu+HJ55+cOlBR0ssTpCsUuASl/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991024; c=relaxed/simple;
	bh=UepWmsvNeZHRHIoVm9ctPE5qXVt1VfonMAbwut4MCIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHxQa4PtaLvllv35/GkcHsIL4Fq4B6IuJ6pngaAwyZce5Zp0vy5Cmehxxojj7qPUWa4GVt6KnCgmwCLRZgZmCxKg/+F0yCOMOg069NfypSwgifLpsxoO/im5K0gGVdaWNTe3R8LUfiPFtLY6WRsHuNMUJaW7h9ydpKoTuFRTuxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvPlB0Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvPlB0Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330B5C433F1;
	Mon,  1 Apr 2024 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991023;
	bh=UepWmsvNeZHRHIoVm9ctPE5qXVt1VfonMAbwut4MCIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvPlB0QlAbG1JSjGqCtA7SA1pOB0I38vc2uBzNuLU5t9MxfnxpX0lpyBdzIPs6F/0
	 bGpZSvoowp6Lb+3zluQYzuk4UsYYgXKHoozO3cm/2YxIh7824WTyMvUUR2YouRqHrM
	 OPUZs0I2Brc2HOFbmqFBXVS7gFV+d3sbDPDE15+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Leo Ma <hanghong.ma@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/272] drm/amd/display: Fix noise issue on HDMI AV mute
Date: Mon,  1 Apr 2024 17:45:29 +0200
Message-ID: <20240401152535.023093266@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Ma <hanghong.ma@amd.com>

[ Upstream commit 69e3be6893a7e668660b05a966bead82bbddb01d ]

[Why]
When mode switching is triggered there is momentary noise visible on
some HDMI TV or displays.

[How]
Wait for 2 frames to make sure we have enough time to send out AV mute
and sink receives a full frame.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Leo Ma <hanghong.ma@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 72bec33e371f3..0225b2c96041d 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -651,10 +651,20 @@ void dcn30_set_avmute(struct pipe_ctx *pipe_ctx, bool enable)
 	if (pipe_ctx == NULL)
 		return;
 
-	if (dc_is_hdmi_signal(pipe_ctx->stream->signal) && pipe_ctx->stream_res.stream_enc != NULL)
+	if (dc_is_hdmi_signal(pipe_ctx->stream->signal) && pipe_ctx->stream_res.stream_enc != NULL) {
 		pipe_ctx->stream_res.stream_enc->funcs->set_avmute(
 				pipe_ctx->stream_res.stream_enc,
 				enable);
+
+		/* Wait for two frame to make sure AV mute is sent out */
+		if (enable) {
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VBLANK);
+			pipe_ctx->stream_res.tg->funcs->wait_for_state(pipe_ctx->stream_res.tg, CRTC_STATE_VACTIVE);
+		}
+	}
 }
 
 void dcn30_update_info_frame(struct pipe_ctx *pipe_ctx)
-- 
2.43.0



