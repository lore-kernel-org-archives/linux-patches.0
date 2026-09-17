Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA91D497387;
	Thu, 17 Sep 2026 16:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660957; cv=none; b=DdhAEkagiB0qRIC1+3NUOVUMLCtYAmeAWOUdQO+DMHEKFOu4DNGKNoPFHsOQ12EXos6aAnPk412r6OYANmrxTPEHstx5nSwiaj8vfYN7rmB++FFequiXb5Z2nQzbEmPRPc1hKhOkTJhVCOOhvXMysRW81XNem8S+e2M38mlJM/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660957; c=relaxed/simple;
	bh=qHeQkOlKpPzOXzsKwjVk+m8Y0yhEJEqGn86Umbbwhgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Equr5hvHlHr8AoCT/8J9oU+RrsKRmOSAr7Yad7cPixq2vpkmPSjL2jYiJt4D16J6MisYw87ZDQj/SnyVu/U23sTWo4uE57Vl9uAppHpkwiiVhXBJzBuBOUseZGYEXAXNMUzROXsBtSunxdo9k09KUmSwqlBke+o779ZtbU8t4XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQADGFO3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQADGFO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF261F000FF;
	Thu, 17 Sep 2026 16:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660956;
	bh=PeTLp1SSvN1e6sdbKcHwBd2dOt4exKrzHUl0HfLYcvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQADGFO36HcrvNcvg4M80vHMnsq7KzoPo38f9FRSvGmAtnzFEDcxiodXyZfYJk6mx
	 IpHxQq29ESlkJBNAlhQwcYzZu15xrz5dzm2A26w9GT38xWUx9A/ZLvd27sIze3GV+Q
	 VahHjZ8TMLjg33nuHdL8veS8gjZjsHtkvvjEFjYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0009/1250] drm/amd/display: Fix DPMS using partially updated pipe context
Date: Thu, 17 Sep 2026 15:56:44 +0100
Message-ID: <20260917151552.174429758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Kaszewski <dominik.kaszewski@amd.com>

[ Upstream commit 6fd45b5d8955bbc362ac3dfe181529f7b1cfd224 ]

[Why & How]
DPMS functions should not use partially updated pipe context passed
as argument of commit_planes_do_stream_update, and instead use the
one in current_state, which is guaranteed to be the most recently
programmed HW config.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Dominik Kaszewski <dominik.kaszewski@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 927837249479f..627a9fb4c551e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3690,27 +3690,34 @@ static void commit_planes_do_stream_update(struct dc *dc,
 				resource_build_test_pattern_params(&context->res_ctx, pipe_ctx);
 			}
 
+			// DPMS should not use partially updated pipe context
+			struct pipe_ctx *dpms_pipe_ctx = &dc->current_state->res_ctx.pipe_ctx[j];
+
 			if (stream_update->dpms_off) {
 				if (*stream_update->dpms_off) {
-					dc->link_srv->set_dpms_off(pipe_ctx);
+					dc->link_srv->set_dpms_off(dpms_pipe_ctx);
 					/* for dpms, keep acquired resources*/
-					if (pipe_ctx->stream_res.audio && !dc->debug.az_endpoint_mute_only)
-						pipe_ctx->stream_res.audio->funcs->az_disable(pipe_ctx->stream_res.audio);
+					if (dpms_pipe_ctx->stream_res.audio && !dc->debug.az_endpoint_mute_only) {
+						struct audio *audio = dpms_pipe_ctx->stream_res.audio;
+
+						audio->funcs->az_disable(audio);
+					}
 
 					dc->optimized_required = true;
 
 				} else {
 					if (get_seamless_boot_stream_count(context) == 0)
 						dc->hwss.prepare_bandwidth(dc, dc->current_state);
-					dc->link_srv->set_dpms_on(dc->current_state, pipe_ctx);
+					dc->link_srv->set_dpms_on(dc->current_state, dpms_pipe_ctx);
 				}
-			} else if (pipe_ctx->stream->link->wa_flags.blank_stream_on_ocs_change && stream_update->output_color_space
-					&& !stream->dpms_off && dc_is_dp_signal(pipe_ctx->stream->signal)) {
+			} else if (dpms_pipe_ctx->stream->link->wa_flags.blank_stream_on_ocs_change &&
+					stream_update->output_color_space &&
+					!stream->dpms_off && dc_is_dp_signal(dpms_pipe_ctx->stream->signal)) {
 				/*
 				 * Workaround for firmware issue in some receivers where they don't pick up
 				 * correct output color space unless DP link is disabled/re-enabled
 				 */
-				dc->link_srv->set_dpms_on(dc->current_state, pipe_ctx);
+				dc->link_srv->set_dpms_on(dc->current_state, dpms_pipe_ctx);
 			}
 
 			if (stream_update->abm_level && pipe_ctx->stream_res.abm) {
-- 
2.53.0



