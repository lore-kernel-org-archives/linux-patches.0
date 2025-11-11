Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EEB26E16C;
	Tue, 11 Nov 2025 01:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825113; cv=none; b=htCOhhCNPE4Ol4AXIhzNIayBA4k7TUcX1kMHnXinVl4ZIO75Pi0j1iqoQcUSY7BuSDUd9ahdcmnfifpsARReWji9cbE7Q5SHe08dE9CMcjPejq3ifs1b+Pz2wbqceFSPgT+xidoE0ff7G5IMzw///PvOHo/nb0Ew3000ofRCGRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825113; c=relaxed/simple;
	bh=S+GsYSptzVPttWQhp3qp9YIuC2lw881B2D8NfH+vR7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMdM09XdB+Vs3ZgNHsbBVy1LXOsxh2az/N7aPD0O1KcA+LuK4Z3xFUhKnMo/YcTkKLej2gycXil9XVEhz6aLe4YYvL4RCcVv0IOsG3YwtuWDC+TavipdRz6ZK3vbFdnLmKdm3Y24LhdlFu5JdoNgjn/0SXDYoxxLPzvr5f1pOqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0VXIyjV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0VXIyjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6D0C4CEFB;
	Tue, 11 Nov 2025 01:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825112;
	bh=S+GsYSptzVPttWQhp3qp9YIuC2lw881B2D8NfH+vR7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0VXIyjVIlafYLKQH4ydfuddpMmGUGkMvabRw2pip+GjzHWvQspUaX47rVfFV3hri
	 LJBwLRjtTVtE11Yd79Qxex+4D8Wm90HOuqNaz6r6A1hDSXSO1+82HrGsJbhYccgKLE
	 xxqff2uzLngcSJqDjaWqjBwMySpqp0XK3AHjFWCI=
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
Subject: [PATCH 6.17 623/849] drm/amd/display: Add AVI infoframe copy in copy_stream_update_to_stream
Date: Tue, 11 Nov 2025 09:43:13 +0900
Message-ID: <20251111004551.493348042@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 74efd50b7c23a..77a842cf84e08 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3307,6 +3307,9 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->adaptive_sync_infopacket)
 		stream->adaptive_sync_infopacket = *update->adaptive_sync_infopacket;
 
+	if (update->avi_infopacket)
+		stream->avi_infopacket = *update->avi_infopacket;
+
 	if (update->dither_option)
 		stream->dither_option = *update->dither_option;
 
@@ -3601,7 +3604,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 					stream_update->vsp_infopacket ||
 					stream_update->hfvsif_infopacket ||
 					stream_update->adaptive_sync_infopacket ||
-					stream_update->vtem_infopacket) {
+					stream_update->vtem_infopacket ||
+					stream_update->avi_infopacket) {
 				resource_build_info_frame(pipe_ctx);
 				dc->hwss.update_info_frame(pipe_ctx);
 
@@ -5073,6 +5077,7 @@ static bool full_update_required(struct dc *dc,
 			stream_update->hfvsif_infopacket ||
 			stream_update->vtem_infopacket ||
 			stream_update->adaptive_sync_infopacket ||
+			stream_update->avi_infopacket ||
 			stream_update->dpms_off ||
 			stream_update->allow_freesync ||
 			stream_update->vrr_active_variable ||
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index d712548b1927d..d37fc14e27dbf 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -4417,8 +4417,14 @@ static void set_avi_info_frame(
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
index 5fc6fea211de3..76cf9fdedab0e 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -203,6 +203,7 @@ struct dc_stream_state {
 	struct dc_info_packet hfvsif_infopacket;
 	struct dc_info_packet vtem_infopacket;
 	struct dc_info_packet adaptive_sync_infopacket;
+	struct dc_info_packet avi_infopacket;
 	uint8_t dsc_packed_pps[128];
 	struct rect src; /* composition area */
 	struct rect dst; /* stream addressable area */
@@ -335,6 +336,8 @@ struct dc_stream_update {
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



