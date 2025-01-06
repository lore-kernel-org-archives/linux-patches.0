Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6351DDC1F;
	Mon,  6 Jan 2025 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178785; cv=none; b=gRD5wbk8jLZa/5bpykCY9P6oQe6p2YM49/UKCijmrpofGDKLnJl3I4uIBb0iIskfRSF+2SxdarHmeztQCq2Djw2ikBlwCVNSJOcbx2Gk5c372iq1PBik1D6oiuU5L3BDCC5Lb/m44pSz4VySb3eUI9MXx6eNp5+ioCIjaArsIlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178785; c=relaxed/simple;
	bh=+lGotaIvodxhL9DnrzrlcIiXyHg6y8cbANKDzbuakFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDhP3MRElRvYVpPl7T6FFBn4v0Cgr/yABo0vZkARwZluvZCyyYS/8bHSiVVReQJOkA7y+GbxvvnHe0MoN0SYwl/fSANOdeTpHMPIN2WO0tZWDshDjjkFnZBOuu5KigMuhj6Iw8LB+LdPl1xp3SZewmNCOOmqT38WUXBpB43BNXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrJiCCxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrJiCCxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA48C4CEDF;
	Mon,  6 Jan 2025 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178785;
	bh=+lGotaIvodxhL9DnrzrlcIiXyHg6y8cbANKDzbuakFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FrJiCCxLucbT7EzUbTmRUp6YBFYZjmo8GWmbHGe5Hag05/FttXLjLSKYe5rh5zYnD
	 KxFvsPib2M+wkFznpWTbiv/vxH8cpEo0iUwglyFKUFVrI8Ov47SaKBMks0o6SSAeyj
	 FWu861xuujLwmJBdKMMby7w4eQfEUIZc7O49iTnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	George Shen <george.shen@amd.com>,
	Peterson Guo <peterson.guo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/168] drm/amd/display: Add a left edge pixel if in YCbCr422 or YCbCr420 and odm
Date: Mon,  6 Jan 2025 16:16:39 +0100
Message-ID: <20250106151141.902285619@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peterson Guo <peterson.guo@amd.com>

[ Upstream commit 63e7ee677c74e981257cedfdd8543510d09096ba ]

[WHY]
On some cards when odm is used, the monitor will have 2 separate pipes
split vertically. When compression is used on the YCbCr colour space on
the second pipe to have correct colours, we need to read a pixel from the
end of first pipe to accurately display colours. Hardware was programmed
properly to account for this extra pixel but it was not calculated
properly in software causing a split screen on some monitors.

[HOW]
The fix adjusts the second pipe's viewport and timings if the pixel
encoding is YCbCr422 or YCbCr420.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: George Shen <george.shen@amd.com>
Signed-off-by: Peterson Guo <peterson.guo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/dcn20/dcn20_resource.c | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 04b370e7e732..6688c40f3c70 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -1899,6 +1899,7 @@ bool dcn20_split_stream_for_odm(
 
 	if (prev_odm_pipe->plane_state) {
 		struct scaler_data *sd = &prev_odm_pipe->plane_res.scl_data;
+		struct output_pixel_processor *opp = next_odm_pipe->stream_res.opp;
 		int new_width;
 
 		/* HACTIVE halved for odm combine */
@@ -1932,7 +1933,28 @@ bool dcn20_split_stream_for_odm(
 		sd->viewport_c.x += dc_fixpt_floor(dc_fixpt_mul_int(
 				sd->ratios.horz_c, sd->h_active - sd->recout.x));
 		sd->recout.x = 0;
+
+		/*
+		 * When odm is used in YcbCr422 or 420 colour space, a split screen
+		 * will be seen with the previous calculations since the extra left
+		 *  edge pixel is accounted for in fmt but not in viewport.
+		 *
+		 * Below are calculations which fix the split by fixing the calculations
+		 * if there is an extra left edge pixel.
+		 */
+		if (opp && opp->funcs->opp_get_left_edge_extra_pixel_count
+				&& opp->funcs->opp_get_left_edge_extra_pixel_count(
+					opp, next_odm_pipe->stream->timing.pixel_encoding,
+					resource_is_pipe_type(next_odm_pipe, OTG_MASTER)) == 1) {
+			sd->h_active += 1;
+			sd->recout.width += 1;
+			sd->viewport.x -= dc_fixpt_ceil(dc_fixpt_mul_int(sd->ratios.horz, 1));
+			sd->viewport_c.x -= dc_fixpt_ceil(dc_fixpt_mul_int(sd->ratios.horz, 1));
+			sd->viewport_c.width += dc_fixpt_ceil(dc_fixpt_mul_int(sd->ratios.horz, 1));
+			sd->viewport.width += dc_fixpt_ceil(dc_fixpt_mul_int(sd->ratios.horz, 1));
+		}
 	}
+
 	if (!next_odm_pipe->top_pipe)
 		next_odm_pipe->stream_res.opp = pool->opps[next_odm_pipe->pipe_idx];
 	else
@@ -2905,6 +2927,7 @@ bool dcn20_fast_validate_bw(
 			ASSERT(0);
 		}
 	}
+
 	/* Actual dsc count per stream dsc validation*/
 	if (!dcn20_validate_dsc(dc, context)) {
 		context->bw_ctx.dml.vba.ValidationStatus[context->bw_ctx.dml.vba.soc.num_states] =
-- 
2.39.5



