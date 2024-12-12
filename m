Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ABA21504F;
	Thu, 12 Dec 2024 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016356; cv=none; b=h8nHaHiH6w8vpteUK6PL8Rcc/2fOwco1TEuSVYqmgXAf41IwcREOS+9ixONznwb56S8UaIoQVpMur0/qHSZaR4D0nk4fZkZGakbrH2Ox00djoo2uQ3CJNhWDJJ5Vtx3UtQg73vEJR8H8sCLm48Vikpe4s+XZomBvam233VoK7h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016356; c=relaxed/simple;
	bh=1QQgA6NWX6rwgx4dsp54WmcHhCT0eF5Cli4/OVFDRTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojyNIooCz9gwOnFrlrGHlMJORSyV1ldVyyQiaXqTOkFVFavrgiBnB16xUmLa450MvIoO4I1JglkL4aHj5gqWHDfZpYQ4Fbor5W7if3TjpyLbBIS8QJ0XFkXt/JPehPTa0CachCqtXSdfgKCVtutNuJvEIlsq6AQA6YJmGpH5gmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qq3Pqshs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qq3Pqshs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3680C4CED4;
	Thu, 12 Dec 2024 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016355;
	bh=1QQgA6NWX6rwgx4dsp54WmcHhCT0eF5Cli4/OVFDRTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qq3Pqshsgh2+o7i98aQhPrEqGYpo3DRdaDooP+gvLJWHzyxrn4To7rzJ9wY+qMzow
	 I6alx/Z2RSFkAvf810KlYZxA6laaFZ5llIabOOGnUBzcO1+BZcW2nNlX6d+v2GML0a
	 GXaPgGbbLuDPdNTV5KV77AXgxH6OKYEbv0N+g/HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	George Shen <george.shen@amd.com>,
	Peterson Guo <peterson.guo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 176/466] drm/amd/display: Add a left edge pixel if in YCbCr422 or YCbCr420 and odm
Date: Thu, 12 Dec 2024 15:55:45 +0100
Message-ID: <20241212144313.749459172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peterson Guo <peterson.guo@amd.com>

commit 63e7ee677c74e981257cedfdd8543510d09096ba upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c |   23 ++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn20/dcn20_resource.c
@@ -1511,6 +1511,7 @@ bool dcn20_split_stream_for_odm(
 
 	if (prev_odm_pipe->plane_state) {
 		struct scaler_data *sd = &prev_odm_pipe->plane_res.scl_data;
+		struct output_pixel_processor *opp = next_odm_pipe->stream_res.opp;
 		int new_width;
 
 		/* HACTIVE halved for odm combine */
@@ -1544,7 +1545,28 @@ bool dcn20_split_stream_for_odm(
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
@@ -2133,6 +2155,7 @@ bool dcn20_fast_validate_bw(
 			ASSERT(0);
 		}
 	}
+
 	/* Actual dsc count per stream dsc validation*/
 	if (!dcn20_validate_dsc(dc, context)) {
 		context->bw_ctx.dml.vba.ValidationStatus[context->bw_ctx.dml.vba.soc.num_states] =


