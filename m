Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64EA522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87BFC433C9;
	Sun,  9 Jul 2023 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901903;
	bh=cwlFeUbUISGVassFDviXGZOm7pQE/1DaZOp9CEC5Lkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcRBJ7nCJgctiatJXABdy0+5P0ypH0XFI0rofF4pX434PA1U/oodN8i4/B225huMX
	 NTZtxLRtGNhd3XW+Dcl8N5j0wYcxdnf6KqdYfYeWl3l68RktuH0kMPJbQJ1N6DbgQx
	 CRHtu/ek4QtOEVTj9lRMi1ngswHKCRwqoQJC5WCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 158/431] drm/amd/display: fix is_timing_changed() prototype
Date: Sun,  9 Jul 2023 13:11:46 +0200
Message-ID: <20230709111454.869603171@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3306ba4b60b2f3d9ac6bddc587a4d702e1ba2224 ]

Three functions in the amdgpu display driver cause -Wmissing-prototype
warnings:

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_resource.c:1858:6: error: no previous prototype for 'is_timing_changed' [-Werror=missing-prototypes]

is_timing_changed() is actually meant to be a global symbol, but needs
a proper name and prototype.

Fixes: 17ce8a6907f7 ("drm/amd/display: Add dsc pre-validation in atomic check")
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 5 ++---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c           | 6 +++---
 drivers/gpu/drm/amd/display/dc/dc.h                         | 3 +++
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 3da519957f6c8..0096614f2a8be 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -48,8 +48,7 @@
 #endif
 
 #include "dc/dcn20/dcn20_resource.h"
-bool is_timing_changed(struct dc_stream_state *cur_stream,
-		       struct dc_stream_state *new_stream);
+
 #define PEAK_FACTOR_X1000 1006
 
 static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
@@ -1426,7 +1425,7 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 		struct dc_stream_state *stream = dm_state->context->streams[i];
 
 		if (local_dc_state->streams[i] &&
-		    is_timing_changed(stream, local_dc_state->streams[i])) {
+		    dc_is_timing_changed(stream, local_dc_state->streams[i])) {
 			DRM_INFO_ONCE("crtc[%d] needs mode_changed\n", i);
 		} else {
 			int ind = find_crtc_index_in_state_by_stream(state, stream);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 986de684b078e..7b0fd0dc31b34 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1878,7 +1878,7 @@ bool dc_add_all_planes_for_stream(
 	return add_all_planes_for_stream(dc, stream, &set, 1, context);
 }
 
-bool is_timing_changed(struct dc_stream_state *cur_stream,
+bool dc_is_timing_changed(struct dc_stream_state *cur_stream,
 		       struct dc_stream_state *new_stream)
 {
 	if (cur_stream == NULL)
@@ -1903,7 +1903,7 @@ static bool are_stream_backends_same(
 	if (stream_a == NULL || stream_b == NULL)
 		return false;
 
-	if (is_timing_changed(stream_a, stream_b))
+	if (dc_is_timing_changed(stream_a, stream_b))
 		return false;
 
 	if (stream_a->signal != stream_b->signal)
@@ -3527,7 +3527,7 @@ bool pipe_need_reprogram(
 	if (pipe_ctx_old->stream_res.stream_enc != pipe_ctx->stream_res.stream_enc)
 		return true;
 
-	if (is_timing_changed(pipe_ctx_old->stream, pipe_ctx->stream))
+	if (dc_is_timing_changed(pipe_ctx_old->stream, pipe_ctx->stream))
 		return true;
 
 	if (pipe_ctx_old->stream->dpms_off != pipe_ctx->stream->dpms_off)
diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/display/dc/dc.h
index 3fb868f2f6f5b..9307442dc2258 100644
--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -2223,4 +2223,7 @@ void dc_process_dmub_dpia_hpd_int_enable(const struct dc *dc,
 /* Disable acc mode Interfaces */
 void dc_disable_accelerated_mode(struct dc *dc);
 
+bool dc_is_timing_changed(struct dc_stream_state *cur_stream,
+		       struct dc_stream_state *new_stream);
+
 #endif /* DC_INTERFACE_H_ */
-- 
2.39.2



