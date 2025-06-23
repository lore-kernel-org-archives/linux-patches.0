Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094354C6E;
	Mon, 23 Jun 2025 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686226; cv=none; b=YtZM00+EBtHq2AJAnCLmL31/7mYbA5t3Xc6BdreD/ldU5drjDrvwy9ptPoNwbGf3zFicc8A8ZGk7jgbxbEvjxnLEAtVxHQwAayyW1EgV5ED0wowz3j0pEBf4jNmHqV4K5YuMzKduzZwqBd99e5/Qld5xsA4qYrFLFjNIeROIcC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686226; c=relaxed/simple;
	bh=TvqqEYtjKWzIG08D7r8SEGYG8K2yOnBT6U52q8vMO4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAmQAtXAbZfWDzkOkkGIOhS8TOgYq4VEQh57oqX53b2e7TlloK4zedJXiP/JIXrKsqyMdaPrDBmYO4yFzKJt7ZWhB4XftuhSVUQ6KCdQ3W27tO2FHAB/IPF6+/5eLtErGiS/BgeYNIPdapJ8Vs4JskiorDCX9jxSr+xvSkztcLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVl5NsES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVl5NsES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D92C4CEEA;
	Mon, 23 Jun 2025 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686225;
	bh=TvqqEYtjKWzIG08D7r8SEGYG8K2yOnBT6U52q8vMO4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVl5NsESEqnNd4kvFtZyAtb612uaS1OxNi74ZqLJHpo84e7qjPRNcVVnH9g2HZewv
	 /tjESF62ugaRhFR+5fDwn0K0HMFFegHuE0mCQs6NAARlY76a6zgRxKq87plhynLEg2
	 tzkUGdwJWIJni4DQ4Xqf0RICtpaWp5k9GG0WM80Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 293/592] drm/amd/display: Fix VUpdate offset calculations for dcn401
Date: Mon, 23 Jun 2025 15:04:11 +0200
Message-ID: <20250623130707.344185926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit fe45e2af4a22e569b35b7f45eb9f040f6fbef94f ]

[WHY&HOW]
DCN401 uses a different structure to store the VStartup offset used to
calculate the VUpdate position, so adjust the calculations to use this
value.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 44 +++++++++++++++++++
 .../amd/display/dc/hwss/dcn401/dcn401_hwseq.h |  1 +
 .../amd/display/dc/hwss/dcn401/dcn401_init.c  |  2 +-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 3af6a3402b894..061553aebd883 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -2646,3 +2646,47 @@ void dcn401_plane_atomic_power_down(struct dc *dc,
 	if (hws->funcs.dpp_root_clock_control)
 		hws->funcs.dpp_root_clock_control(hws, dpp->inst, false);
 }
+
+/*
+ * apply_front_porch_workaround
+ *
+ * This is a workaround for a bug that has existed since R5xx and has not been
+ * fixed keep Front porch at minimum 2 for Interlaced mode or 1 for progressive.
+ */
+static void apply_front_porch_workaround(
+	struct dc_crtc_timing *timing)
+{
+	if (timing->flags.INTERLACE == 1) {
+		if (timing->v_front_porch < 2)
+			timing->v_front_porch = 2;
+	} else {
+		if (timing->v_front_porch < 1)
+			timing->v_front_porch = 1;
+	}
+}
+
+int dcn401_get_vupdate_offset_from_vsync(struct pipe_ctx *pipe_ctx)
+{
+	const struct dc_crtc_timing *dc_crtc_timing = &pipe_ctx->stream->timing;
+	struct dc_crtc_timing patched_crtc_timing;
+	int vesa_sync_start;
+	int asic_blank_end;
+	int interlace_factor;
+
+	patched_crtc_timing = *dc_crtc_timing;
+	apply_front_porch_workaround(&patched_crtc_timing);
+
+	interlace_factor = patched_crtc_timing.flags.INTERLACE ? 2 : 1;
+
+	vesa_sync_start = patched_crtc_timing.v_addressable +
+			patched_crtc_timing.v_border_bottom +
+			patched_crtc_timing.v_front_porch;
+
+	asic_blank_end = (patched_crtc_timing.v_total -
+			vesa_sync_start -
+			patched_crtc_timing.v_border_top)
+			* interlace_factor;
+
+	return asic_blank_end -
+			pipe_ctx->global_sync.dcn4x.vstartup_lines + 1;
+}
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
index 781cf0efccc6c..37c915568afcb 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.h
@@ -109,4 +109,5 @@ void dcn401_detect_pipe_changes(
 void dcn401_plane_atomic_power_down(struct dc *dc,
 		struct dpp *dpp,
 		struct hubp *hubp);
+int dcn401_get_vupdate_offset_from_vsync(struct pipe_ctx *pipe_ctx);
 #endif /* __DC_HWSS_DCN401_H__ */
diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
index fe7aceb2f5104..aa9573ce44fce 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_init.c
@@ -73,7 +73,7 @@ static const struct hw_sequencer_funcs dcn401_funcs = {
 	.init_sys_ctx = dcn20_init_sys_ctx,
 	.init_vm_ctx = dcn20_init_vm_ctx,
 	.set_flip_control_gsl = dcn20_set_flip_control_gsl,
-	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
+	.get_vupdate_offset_from_vsync = dcn401_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
 	.apply_idle_power_optimizations = dcn401_apply_idle_power_optimizations,
 	.does_plane_fit_in_mall = NULL,
-- 
2.39.5



