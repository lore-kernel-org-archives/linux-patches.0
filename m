Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866EA1D0493;
	Wed,  2 Oct 2024 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878690; cv=none; b=sL8kpDRyfrgVxI0P1Ciwj5NJJbwvvCS//fMNTS4RQqiH7pXR+XRJlr468SbJ7P1i/AsKTLgJMbNJ3UPLeE8yM/wr6g3zTPQUUVxWpOHKk1MplPiD1bQz3BylPUlJybrN3AJdDIl3Hbq25pohMHdf/RIAOGa9J9r3Oh0CCvJj65c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878690; c=relaxed/simple;
	bh=iHcVNEl5rwKFjaglsoFa1wRMpJjopD/w2u3baj4U0zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5Le3ZX1yPNPiV77ZxtwvZA9M22vrNCFhxVC04kM0cKdV7yNF8tksj3tycLcjvWlC0OseFggLwGh5jevZLAQGGlATe4MC5tKi/qPedSIWLlx9cJi+LoarserNtj41uAY4wCcA4wczCKRnRK5wiCucUWx7MxA3zWV1W9L1N8mUCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBBTEv70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBBTEv70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000DEC4CEC2;
	Wed,  2 Oct 2024 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878690;
	bh=iHcVNEl5rwKFjaglsoFa1wRMpJjopD/w2u3baj4U0zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBBTEv70QG9RXoWLxxHgLSjqh2kptZI6mbW3w6m4/Bb7yy79bfGp/VEjgf9IFnVW3
	 fPiWCWbB8NGxCAmv/wjgpjU9oCMEg29K32/lTQOsupGr4ALj0yYLak24K95M6V4Ie1
	 RpWqeLC19949iOdFlnl3vqQg8qAA5woNoQrCaO2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Zhikai Zhai <zhikai.zhai@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 499/634] drm/amd/display: Skip to enable dsc if it has been off
Date: Wed,  2 Oct 2024 14:59:59 +0200
Message-ID: <20241002125830.794976280@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhikai Zhai <zhikai.zhai@amd.com>

commit 4bdc5b504af7de1f649004cfdd37445d36db6703 upstream.

[WHY]
It makes DSC enable when we commit the stream which need
keep power off, and then it will skip to disable DSC if
pipe reset at this situation as power has been off. It may
cause the DSC unexpected enable on the pipe with the
next new stream which doesn't support DSC.

[HOW]
Check the DSC used on current pipe status when update stream.
Skip to enable if it has been off. The operation enable
DSC should happen when set power on.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Zhikai Zhai <zhikai.zhai@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c |   14 ++++++++++++++
 drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c |   13 +++++++++++++
 2 files changed, 27 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn32/dcn32_hwseq.c
@@ -991,6 +991,20 @@ static void update_dsc_on_stream(struct
 		struct dsc_config dsc_cfg;
 		struct dsc_optc_config dsc_optc_cfg = {0};
 		enum optc_dsc_mode optc_dsc_mode;
+		struct dcn_dsc_state dsc_state = {0};
+
+		if (!dsc) {
+			DC_LOG_DSC("DSC is NULL for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+			return;
+		}
+
+		if (dsc->funcs->dsc_read_state) {
+			dsc->funcs->dsc_read_state(dsc, &dsc_state);
+			if (!dsc_state.dsc_fw_en) {
+				DC_LOG_DSC("DSC has been disabled for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+				return;
+			}
+		}
 
 		/* Enable DSC hw block */
 		dsc_cfg.pic_width = (stream->timing.h_addressable + stream->timing.h_border_left + stream->timing.h_border_right) / opp_cnt;
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn35/dcn35_hwseq.c
@@ -375,7 +375,20 @@ static void update_dsc_on_stream(struct
 		struct dsc_config dsc_cfg;
 		struct dsc_optc_config dsc_optc_cfg = {0};
 		enum optc_dsc_mode optc_dsc_mode;
+		struct dcn_dsc_state dsc_state = {0};
 
+		if (!dsc) {
+			DC_LOG_DSC("DSC is NULL for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+			return;
+		}
+
+		if (dsc->funcs->dsc_read_state) {
+			dsc->funcs->dsc_read_state(dsc, &dsc_state);
+			if (!dsc_state.dsc_fw_en) {
+				DC_LOG_DSC("DSC has been disabled for tg instance %d:", pipe_ctx->stream_res.tg->inst);
+				return;
+			}
+		}
 		/* Enable DSC hw block */
 		dsc_cfg.pic_width = (stream->timing.h_addressable + stream->timing.h_border_left + stream->timing.h_border_right) / opp_cnt;
 		dsc_cfg.pic_height = stream->timing.v_addressable + stream->timing.v_border_top + stream->timing.v_border_bottom;


