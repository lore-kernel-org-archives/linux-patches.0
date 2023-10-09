Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C532E63E
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZpbUtAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15AEC433C7;
	Mon,  9 Oct 2023 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858176;
	bh=fd/KWS/PvryHqOPaZoqv7n5Ns0Q5OCfkEfSiNzlqtEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZpbUtALqCxn6K97G8VkD+IK4rEwQDoXXOCseQys9fz9KOyUI/A71IRUt2e/bVq1S
	 Zqtzf2QHBRS7TFTv/EO+dI/0Bz08edtCQ5wghtATCfCB7UQAVDRCU6wwU9ynM3Lj4/
	 VDyx20lv1V2IMcKmBmYYbZhqEZNnj8E2LqgJfvrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amanda Liu <amanda.liu@amd.com>,
	Aric Cyr <Aric.Cyr@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/131] drm/amd/display: Reinstate LFC optimization
Date: Mon,  9 Oct 2023 15:01:19 +0200
Message-ID: <20231009130117.508850693@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amanda Liu <amanda.liu@amd.com>

[ Upstream commit ded6119e825aaf0bfc7f2a578b549d610da852a7 ]

[why]
We want to streamline the calculations made when entering LFC.
Previously, the optimizations led to screen tearing and were backed out
to unblock development.

[how]
Integrate other calculations parameters, as well as screen tearing,
fixes with the original LFC calculation optimizations.

Signed-off-by: Amanda Liu <amanda.liu@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 07e388aab042 ("drm/amd/display: prevent potential division by zero errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/modules/freesync/freesync.c   | 32 +++++++++++--------
 .../amd/display/modules/inc/mod_freesync.h    |  1 +
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 7d67cb2c61f04..dbbd7d2765ea5 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -37,8 +37,8 @@
 #define STATIC_SCREEN_RAMP_DELTA_REFRESH_RATE_PER_FRAME ((1000 / 60) * 65)
 /* Number of elements in the render times cache array */
 #define RENDER_TIMES_MAX_COUNT 10
-/* Threshold to exit BTR (to avoid frequent enter-exits at the lower limit) */
-#define BTR_EXIT_MARGIN 2000
+/* Threshold to exit/exit BTR (to avoid frequent enter-exits at the lower limit) */
+#define BTR_MAX_MARGIN 2500
 /* Threshold to change BTR multiplier (to avoid frequent changes) */
 #define BTR_DRIFT_MARGIN 2000
 /*Threshold to exit fixed refresh rate*/
@@ -250,24 +250,22 @@ static void apply_below_the_range(struct core_freesync *core_freesync,
 	unsigned int delta_from_mid_point_in_us_1 = 0xFFFFFFFF;
 	unsigned int delta_from_mid_point_in_us_2 = 0xFFFFFFFF;
 	unsigned int frames_to_insert = 0;
-	unsigned int min_frame_duration_in_ns = 0;
-	unsigned int max_render_time_in_us = in_out_vrr->max_duration_in_us;
 	unsigned int delta_from_mid_point_delta_in_us;
-
-	min_frame_duration_in_ns = ((unsigned int) (div64_u64(
-		(1000000000ULL * 1000000),
-		in_out_vrr->max_refresh_in_uhz)));
+	unsigned int max_render_time_in_us =
+			in_out_vrr->max_duration_in_us - in_out_vrr->btr.margin_in_us;
 
 	/* Program BTR */
-	if (last_render_time_in_us + BTR_EXIT_MARGIN < max_render_time_in_us) {
+	if ((last_render_time_in_us + in_out_vrr->btr.margin_in_us / 2) < max_render_time_in_us) {
 		/* Exit Below the Range */
 		if (in_out_vrr->btr.btr_active) {
 			in_out_vrr->btr.frame_counter = 0;
 			in_out_vrr->btr.btr_active = false;
 		}
-	} else if (last_render_time_in_us > max_render_time_in_us) {
+	} else if (last_render_time_in_us > (max_render_time_in_us + in_out_vrr->btr.margin_in_us / 2)) {
 		/* Enter Below the Range */
-		in_out_vrr->btr.btr_active = true;
+		if (!in_out_vrr->btr.btr_active) {
+			in_out_vrr->btr.btr_active = true;
+		}
 	}
 
 	/* BTR set to "not active" so disengage */
@@ -323,7 +321,9 @@ static void apply_below_the_range(struct core_freesync *core_freesync,
 		/* Choose number of frames to insert based on how close it
 		 * can get to the mid point of the variable range.
 		 */
-		if (delta_from_mid_point_in_us_1 < delta_from_mid_point_in_us_2) {
+		if ((frame_time_in_us / mid_point_frames_ceil) > in_out_vrr->min_duration_in_us &&
+				(delta_from_mid_point_in_us_1 < delta_from_mid_point_in_us_2 ||
+						mid_point_frames_floor < 2)) {
 			frames_to_insert = mid_point_frames_ceil;
 			delta_from_mid_point_delta_in_us = delta_from_mid_point_in_us_2 -
 					delta_from_mid_point_in_us_1;
@@ -339,7 +339,7 @@ static void apply_below_the_range(struct core_freesync *core_freesync,
 		if (in_out_vrr->btr.frames_to_insert != 0 &&
 				delta_from_mid_point_delta_in_us < BTR_DRIFT_MARGIN) {
 			if (((last_render_time_in_us / in_out_vrr->btr.frames_to_insert) <
-					in_out_vrr->max_duration_in_us) &&
+					max_render_time_in_us) &&
 				((last_render_time_in_us / in_out_vrr->btr.frames_to_insert) >
 					in_out_vrr->min_duration_in_us))
 				frames_to_insert = in_out_vrr->btr.frames_to_insert;
@@ -792,6 +792,11 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 		refresh_range = in_out_vrr->max_refresh_in_uhz -
 				in_out_vrr->min_refresh_in_uhz;
 
+		in_out_vrr->btr.margin_in_us = in_out_vrr->max_duration_in_us -
+				2 * in_out_vrr->min_duration_in_us;
+		if (in_out_vrr->btr.margin_in_us > BTR_MAX_MARGIN)
+			in_out_vrr->btr.margin_in_us = BTR_MAX_MARGIN;
+
 		in_out_vrr->supported = true;
 	}
 
@@ -808,6 +813,7 @@ void mod_freesync_build_vrr_params(struct mod_freesync *mod_freesync,
 	in_out_vrr->btr.inserted_duration_in_us = 0;
 	in_out_vrr->btr.frames_to_insert = 0;
 	in_out_vrr->btr.frame_counter = 0;
+
 	in_out_vrr->btr.mid_point_in_us =
 				(in_out_vrr->min_duration_in_us +
 				 in_out_vrr->max_duration_in_us) / 2;
diff --git a/drivers/gpu/drm/amd/display/modules/inc/mod_freesync.h b/drivers/gpu/drm/amd/display/modules/inc/mod_freesync.h
index dc187844d10b1..dbe7835aabcf7 100644
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_freesync.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_freesync.h
@@ -92,6 +92,7 @@ struct mod_vrr_params_btr {
 	uint32_t inserted_duration_in_us;
 	uint32_t frames_to_insert;
 	uint32_t frame_counter;
+	uint32_t margin_in_us;
 };
 
 struct mod_vrr_params_fixed_refresh {
-- 
2.40.1



