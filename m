Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F71F34403B;
	Fri, 21 Nov 2025 13:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732860; cv=none; b=JeZLaW13NvaeYN4o/+sX0ISnQYiVubtmGMmJ+g1UC+Gb/j0oecngcw9xQPY/pk0YXEg7IozSrFsOcp3R6Y1YOiJI1TI+Sk2Dmr3OyAvbVgYIbQ64MRNfQEwr6KDmiB6e83adLYgLDom/DdXjaE9YvC8RaZ4VUb20hNie8Q2yUCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732860; c=relaxed/simple;
	bh=4iF51+GdhGgiL6V97lHPIp0rrV2NO/y7AafZwa1NH5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQHUHMuIOzcvoxIXE1XiqGD+ftFv6N3f2o9alEGnaDNYCpiTmcLEZGNnGv/r8wmZL9yj6EvfhCou1yawjCn0nLaXZVaHRl0usMDDPBwgy5wT3zT3vLyNxcCJo/eGKMzZO9A74r/33/UMBe8NaZS2RJufOWBVuLe6/2RdATJ4CgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYg0UrY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYg0UrY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A535C4CEF1;
	Fri, 21 Nov 2025 13:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732860;
	bh=4iF51+GdhGgiL6V97lHPIp0rrV2NO/y7AafZwa1NH5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYg0UrY95zO5zLbFYaFx7xEf+ut6YprIba6lmIIe+Qqc0z2TD+4z+ieHPsipEg7w8
	 GqqqZ1Z1TPznx95X5j2mM48Wz1Pk/N4v3iPFjy9IVpCmOZVa/q22Y6vFuWhVmnt58e
	 h66uIEJw2vLDuB8IyRg7R2hr6+bX0GOuRv8MAPgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Karthi Kandasamy <karthi.kandasamy@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/529] drm/amd/display: Add AVI infoframe copy in copy_stream_update_to_stream
Date: Fri, 21 Nov 2025 14:09:27 +0100
Message-ID: <20251121130240.558054878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Karthi Kandasamy <karthi.kandasamy@amd.com>

[ Upstream commit c8bedab2d9a1a0daa49ac20f9928a943f7205582 ]

[WHY]
Ensure AVI infoframe updates from stream updates are applied to the active
stream so OS overrides are not lost.

[HOW]
Copy avi_infopacket to stream when valid flag is set.
Follow existing infopacket copy pattern and perform a basic validity check before assignment.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Karthi Kandasamy <karthi.kandasamy@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 7 ++++++-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 6 ++++++
 drivers/gpu/drm/amd/display/dc/dc_stream.h        | 3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index eb71721dfb715..31c53491b8374 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2952,6 +2952,9 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->adaptive_sync_infopacket)
 		stream->adaptive_sync_infopacket = *update->adaptive_sync_infopacket;
 
+	if (update->avi_infopacket)
+		stream->avi_infopacket = *update->avi_infopacket;
+
 	if (update->dither_option)
 		stream->dither_option = *update->dither_option;
 
@@ -3158,7 +3161,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 					stream_update->vsp_infopacket ||
 					stream_update->hfvsif_infopacket ||
 					stream_update->adaptive_sync_infopacket ||
-					stream_update->vtem_infopacket) {
+					stream_update->vtem_infopacket ||
+					stream_update->avi_infopacket) {
 				resource_build_info_frame(pipe_ctx);
 				dc->hwss.update_info_frame(pipe_ctx);
 
@@ -4241,6 +4245,7 @@ static bool full_update_required(struct dc *dc,
 			stream_update->hfvsif_infopacket ||
 			stream_update->vtem_infopacket ||
 			stream_update->adaptive_sync_infopacket ||
+			stream_update->avi_infopacket ||
 			stream_update->dpms_off ||
 			stream_update->allow_freesync ||
 			stream_update->vrr_active_variable ||
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 277b2d205440c..802c0e19d03b3 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -3225,8 +3225,14 @@ static void set_avi_info_frame(
 	unsigned int fr_ind = pipe_ctx->stream->timing.fr_index;
 	enum dc_timing_3d_format format;
 
+	if (stream->avi_infopacket.valid) {
+		*info_packet = stream->avi_infopacket;
+		return;
+	}
+
 	memset(&hdmi_info, 0, sizeof(union hdmi_info_packet));
 
+
 	color_space = pipe_ctx->stream->output_color_space;
 	if (color_space == COLOR_SPACE_UNKNOWN)
 		color_space = (stream->timing.pixel_encoding == PIXEL_ENCODING_RGB) ?
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index d5b3e3a32cc6d..ad020cc246376 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -197,6 +197,7 @@ struct dc_stream_state {
 	struct dc_info_packet hfvsif_infopacket;
 	struct dc_info_packet vtem_infopacket;
 	struct dc_info_packet adaptive_sync_infopacket;
+	struct dc_info_packet avi_infopacket;
 	uint8_t dsc_packed_pps[128];
 	struct rect src; /* composition area */
 	struct rect dst; /* stream addressable area */
@@ -323,6 +324,8 @@ struct dc_stream_update {
 	struct dc_info_packet *hfvsif_infopacket;
 	struct dc_info_packet *vtem_infopacket;
 	struct dc_info_packet *adaptive_sync_infopacket;
+	struct dc_info_packet *avi_infopacket;
+
 	bool *dpms_off;
 	bool integer_scaling_update;
 	bool *allow_freesync;
-- 
2.51.0



