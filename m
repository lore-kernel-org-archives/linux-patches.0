Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CABA225785;
	Mon,  2 Jun 2025 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876830; cv=none; b=hOyLHVbS9odeKFoJZ78+LcpQdVSFhWspVNkPcNlWtQG9rhAaSxLAnHwyfjJuDnUyf2MmS5usdA8b6A5qO0G/5KnfzrSuBSleUUYBIsD74ErRQ5rqtMFz8gFKw4Hay62WVDnQGcA5U8MZ4t5aTbOE5xzLPvuzck/L2lmlBEB7jEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876830; c=relaxed/simple;
	bh=KvLt0M7uljqdd8ckhmJGXzZ2H6jJqv9eSuRfnOQg+XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uha3xLGcAXICTLKu9DqFAa1/l4YKilW/cVpkMremP4ki+UDSPxzRY9ekwY4zjBbyRpRvW+/lxQdlZbHzNTig++ys37fgwAjQOAplNhbMEevSgAAUYXb6Rkqq7aj2AflVblUTpxQR07X4bvOuyJGg5R6YE0v8kVZiX7pImtsQiFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixMInxH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixMInxH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A97C4CEEB;
	Mon,  2 Jun 2025 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876830;
	bh=KvLt0M7uljqdd8ckhmJGXzZ2H6jJqv9eSuRfnOQg+XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixMInxH6SCeqwY1C5oLczs0TIQGM/Ga59hoYysH2BYAMSI3Ih7R39l0V2FrBO/Lb+
	 c2bgb+q/L7CZXnALmJANGg1iZh1Gmn+v0TCoDU5tGB4KB39UFVoyuGFbT1QYlT+JSY
	 V/3OWSV9UwGdUKKoLuEPo6ErwMIWhJJy5f07IqPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Zhikai Zhai <zhikai.zhai@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/325] drm/amd/display: calculate the remain segments for all pipes
Date: Mon,  2 Jun 2025 15:46:04 +0200
Message-ID: <20250602134323.356786338@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhikai Zhai <zhikai.zhai@amd.com>

[ Upstream commit d3069feecdb5542604d29b59acfd1fd213bad95b ]

[WHY]
In some cases the remain de-tile buffer segments will be greater
than zero if we don't add the non-top pipe to calculate, at
this time the override de-tile buffer size will be valid and used.
But it makes the de-tile buffer segments used finally for all of pipes
exceed the maximum.

[HOW]
Add the non-top pipe to calculate the remain de-tile buffer segments.
Don't set override size to use the average according to pipe count
if the value exceed the maximum.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Zhikai Zhai <zhikai.zhai@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/dcn315/dcn315_resource.c   | 42 +++++++++----------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c b/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
index 958170fbfece7..9d643c79afea6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn315/dcn315_resource.c
@@ -1717,7 +1717,7 @@ static int dcn315_populate_dml_pipes_from_context(
 		pipes[pipe_cnt].dout.dsc_input_bpc = 0;
 		DC_FP_START();
 		dcn31_zero_pipe_dcc_fraction(pipes, pipe_cnt);
-		if (pixel_rate_crb && !pipe->top_pipe && !pipe->prev_odm_pipe) {
+		if (pixel_rate_crb) {
 			int bpp = source_format_to_bpp(pipes[pipe_cnt].pipe.src.source_format);
 			/* Ceil to crb segment size */
 			int approx_det_segs_required_for_pstate = dcn_get_approx_det_segs_required_for_pstate(
@@ -1768,28 +1768,26 @@ static int dcn315_populate_dml_pipes_from_context(
 				continue;
 			}
 
-			if (!pipe->top_pipe && !pipe->prev_odm_pipe) {
-				bool split_required = pipe->stream->timing.pix_clk_100hz >= dcn_get_max_non_odm_pix_rate_100hz(&dc->dml.soc)
-						|| (pipe->plane_state && pipe->plane_state->src_rect.width > 5120);
-
-				if (remaining_det_segs > MIN_RESERVED_DET_SEGS && crb_pipes != 0)
-					pipes[pipe_cnt].pipe.src.det_size_override += (remaining_det_segs - MIN_RESERVED_DET_SEGS) / crb_pipes +
-							(crb_idx < (remaining_det_segs - MIN_RESERVED_DET_SEGS) % crb_pipes ? 1 : 0);
-				if (pipes[pipe_cnt].pipe.src.det_size_override > 2 * DCN3_15_MAX_DET_SEGS) {
-					/* Clamp to 2 pipe split max det segments */
-					remaining_det_segs += pipes[pipe_cnt].pipe.src.det_size_override - 2 * (DCN3_15_MAX_DET_SEGS);
-					pipes[pipe_cnt].pipe.src.det_size_override = 2 * DCN3_15_MAX_DET_SEGS;
-				}
-				if (pipes[pipe_cnt].pipe.src.det_size_override > DCN3_15_MAX_DET_SEGS || split_required) {
-					/* If we are splitting we must have an even number of segments */
-					remaining_det_segs += pipes[pipe_cnt].pipe.src.det_size_override % 2;
-					pipes[pipe_cnt].pipe.src.det_size_override -= pipes[pipe_cnt].pipe.src.det_size_override % 2;
-				}
-				/* Convert segments into size for DML use */
-				pipes[pipe_cnt].pipe.src.det_size_override *= DCN3_15_CRB_SEGMENT_SIZE_KB;
-
-				crb_idx++;
+			bool split_required = pipe->stream->timing.pix_clk_100hz >= dcn_get_max_non_odm_pix_rate_100hz(&dc->dml.soc)
+					|| (pipe->plane_state && pipe->plane_state->src_rect.width > 5120);
+
+			if (remaining_det_segs > MIN_RESERVED_DET_SEGS && crb_pipes != 0)
+				pipes[pipe_cnt].pipe.src.det_size_override += (remaining_det_segs - MIN_RESERVED_DET_SEGS) / crb_pipes +
+						(crb_idx < (remaining_det_segs - MIN_RESERVED_DET_SEGS) % crb_pipes ? 1 : 0);
+			if (pipes[pipe_cnt].pipe.src.det_size_override > 2 * DCN3_15_MAX_DET_SEGS) {
+				/* Clamp to 2 pipe split max det segments */
+				remaining_det_segs += pipes[pipe_cnt].pipe.src.det_size_override - 2 * (DCN3_15_MAX_DET_SEGS);
+				pipes[pipe_cnt].pipe.src.det_size_override = 2 * DCN3_15_MAX_DET_SEGS;
+			}
+			if (pipes[pipe_cnt].pipe.src.det_size_override > DCN3_15_MAX_DET_SEGS || split_required) {
+				/* If we are splitting we must have an even number of segments */
+				remaining_det_segs += pipes[pipe_cnt].pipe.src.det_size_override % 2;
+				pipes[pipe_cnt].pipe.src.det_size_override -= pipes[pipe_cnt].pipe.src.det_size_override % 2;
 			}
+			/* Convert segments into size for DML use */
+			pipes[pipe_cnt].pipe.src.det_size_override *= DCN3_15_CRB_SEGMENT_SIZE_KB;
+
+			crb_idx++;
 			pipe_cnt++;
 		}
 	}
-- 
2.39.5



