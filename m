Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71DF17730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9FDC4339B;
	Mon, 15 May 2023 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684174023;
	bh=TWeHQE8V1n7idXRbaByFCCGlEcGWlI0GkH4fh2CbHLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJBCmVYs3yAA2HpQRMk6oPDOH/FF6elEiCBTot6aLVhHULFfRYwCD87JwWguiGSo5
	 znHNr3SHMyMBx27EF3YXeqauEVJGCmY/EI7BitPuVp1M6OXYq6Y8sd6akJ4m9ROFBh
	 8NQqMo3IUyrFeBlPl5uODVbZ1LWvA2rvoRVyw3sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <Alvin.Lee2@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 282/282] drm/amd/display: Fix hang when skipping modeset
Date: Mon, 15 May 2023 18:31:00 +0200
Message-Id: <20230515161730.860063043@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit da5e14909776edea4462672fb4a3007802d262e7 upstream.

[Why&How]

When skipping full modeset since the only state change was a front porch
change, the DC commit sequence requires extra checks to handle non
existant plane states being asked to be removed from context.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 ++++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5776,6 +5776,8 @@ static void amdgpu_dm_commit_planes(stru
 			continue;
 
 		dc_plane = dm_new_plane_state->dc_state;
+		if (!dc_plane)
+			continue;
 
 		bundle->surface_updates[planes_count].surface = dc_plane;
 		if (new_pcrtc_state->color_mgmt_changed) {
@@ -7029,8 +7031,9 @@ static int dm_update_plane_state(struct
 			return -EINVAL;
 		}
 
+		if (dm_old_plane_state->dc_state)
+			dc_plane_state_release(dm_old_plane_state->dc_state);
 
-		dc_plane_state_release(dm_old_plane_state->dc_state);
 		dm_new_plane_state->dc_state = NULL;
 
 		*lock_and_validation_needed = true;
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1315,6 +1315,9 @@ bool dc_remove_plane_from_context(
 	struct dc_stream_status *stream_status = NULL;
 	struct resource_pool *pool = dc->res_pool;
 
+	if (!plane_state)
+		return true;
+
 	for (i = 0; i < context->stream_count; i++)
 		if (context->streams[i] == stream) {
 			stream_status = &context->stream_status[i];


