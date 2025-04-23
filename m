Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03073269B07;
	Wed, 23 Apr 2025 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420762; cv=none; b=oPnrN7ODEj74NmI6xyQYEU+ccfwPR21G+yFOUyUEAkZWsTieFYTk901Vn8U8WUli2qZmQssgAQv1RXDlJvIZlNHFvgD6rTdKZBkfL2ubwxb9+Cl6SN1G3kccw/8lacPviWdTsTr3uVz4+9nt+o1fo1Y+KgXud7v3W7uNhEbeMTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420762; c=relaxed/simple;
	bh=pNSsrPr+JOgwsb1c6OA/XhgINNBavOo0g/42pNpDOHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmrR38nTvbx7NMPQZlk7VL99pSgyPkiJ7hybUKjOI3LqASHbCYFPJ4LHduoYGqk+fnIkCHQfdM+/7NgKF0yrYXTkFOaYpgiQnk/0ciEzOGpcT/a6IXctllDZzUiN4xcA01DJCaFQTJKshuIKKljhFMBgW0BnWcUwr8VmOVCfEFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akIFFITw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akIFFITw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868C0C4CEE2;
	Wed, 23 Apr 2025 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420761;
	bh=pNSsrPr+JOgwsb1c6OA/XhgINNBavOo0g/42pNpDOHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akIFFITwo6/sySPShOjDBl1nWxD43i8zf7RM76kI0L5gXKZ2yNGIimnp8wa/54Ki7
	 aOQq1TWhcqpCs4HfICKPNetXWI+MhWZYpV2InTPI39dH27f+kzm/N4TxlbCLrlpuJv
	 DgTQWZBdlQYvvJmQIPe9YB/QTS2g1KQoY5KkRNuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Brendan Tam <Brendan.Tam@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 153/223] drm/amd/display: prevent hang on link training fail
Date: Wed, 23 Apr 2025 16:43:45 +0200
Message-ID: <20250423142623.409283431@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan Tam <Brendan.Tam@amd.com>

commit 8058061ed9d6bc259d1e678607b07d259342c08f upstream.

[Why]
When link training fails, the phy clock will be disabled. However, in
enable_streams, it is assumed that link training succeeded and the
mux selects the phy clock, causing a hang when a register write is made.

[How]
When enable_stream is hit, check if link training failed. If it did, fall
back to the ref clock to avoid a hang and keep the system in a recoverable
state.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Brendan Tam <Brendan.Tam@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c   |    6 +++++-
 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c |    7 +++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -3003,7 +3003,11 @@ void dcn20_enable_stream(struct pipe_ctx
 		dccg->funcs->set_dpstreamclk(dccg, DTBCLK0, tg->inst, dp_hpo_inst);
 
 		phyd32clk = get_phyd32clk_src(link);
-		dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+		if (link->cur_link_settings.link_rate == LINK_RATE_UNKNOWN) {
+			dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
+		} else {
+			dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+		}
 	} else {
 		if (dccg->funcs->enable_symclk_se)
 			dccg->funcs->enable_symclk_se(dccg, stream_enc->stream_enc_inst,
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1001,8 +1001,11 @@ void dcn401_enable_stream(struct pipe_ct
 	if (dc_is_dp_signal(pipe_ctx->stream->signal) || dc_is_virtual_signal(pipe_ctx->stream->signal)) {
 		if (dc->link_srv->dp_is_128b_132b_signal(pipe_ctx)) {
 			dccg->funcs->set_dpstreamclk(dccg, DPREFCLK, tg->inst, dp_hpo_inst);
-
-			dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+			if (link->cur_link_settings.link_rate == LINK_RATE_UNKNOWN) {
+				dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
+			} else {
+				dccg->funcs->enable_symclk32_se(dccg, dp_hpo_inst, phyd32clk);
+			}
 		} else {
 			/* need to set DTBCLK_P source to DPREFCLK for DP8B10B */
 			dccg->funcs->set_dtbclk_p_src(dccg, DPREFCLK, tg->inst);


