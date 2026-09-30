Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550551B163;
	Wed, 30 Sep 2026 18:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793870; cv=none; b=iMcOD0bNXuSA34oUx/lCzv3ESjrXeyEmEZWeJX6Cc5E1jiqXNgZOFWtvReM8g3DOK13MyrKQXXuM1Gz+2Gcgy9JWU/f5+Q3us9nEnZdWV1nDLCRg2QiB/LXg3TROAnzs5DVUODtErqKg+UjNPGqrcPE4NNHU7aef4mpdSrvcQto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793870; c=relaxed/simple;
	bh=JWc4j9l4T1IVnTgSPa+GtNaxwBvH5QeiJ0E4i/DT/so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWK/n+Wd6CPK9Bkl4u738Y4BmB1tyyuCd5WspBF5HrPWWgwsQMi13B9ozc9rsYZVmtFAGf1takE7ii9Ifou7V7RUPDPOQI3ueBsYKOf1zwvOSFf1P8kcGcmDDpjfDQNnK7OGgqVWb4gM/49a+U7yECIa6FKZ+3N9OASgsJD/eFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ciyp0Tg1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ciyp0Tg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5B51F000FF;
	Wed, 30 Sep 2026 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793869;
	bh=UVqbFp6/zKI+f8luGNzjw8m97aIZ24yG87aJAwsdrg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ciyp0Tg1MdodnG45QaJH8yhvA8HeUzFwWqqpSbmYpJGW32SziNG04chl3vcegTxIH
	 PCxnoO7GDtg7Woy2Vd+2ijl7ASb5Uq4bPfhAPOsPJG6BZtjcpstQEkiEAX8mA2ng55
	 RhjWpYQUdbYYAQr70/tOe2DpXYnFDq2dTIN06S1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjing Liu <wenjing.liu@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0004/1193] drm/amd/display: Fix DPMS using partially updated pipe context
Date: Wed, 30 Sep 2026 17:11:28 +0200
Message-ID: <20260930152434.406782815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bea18f450ac9c..50b860c07ae01 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3225,27 +3225,34 @@ static void commit_planes_do_stream_update(struct dc *dc,
 					stream->test_pattern.cust_pattern_size);
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



