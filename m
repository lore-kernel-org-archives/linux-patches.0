Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F1A1D86FF;
	Tue, 11 Nov 2025 01:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824236; cv=none; b=lgmMwatERuRP5+A66bFsAK8Y5nq5dlbZedXU7PBfBuOzjuP9HOBkD4D4q0BBkpZ6kKUNaWvZQhuBRaGqX79mQ6eFta23S9UfGrcxI9yFQ1qn0F9xUXX1P5RuDezdpARw3FYO+x9x5uJeedeDXNHtbr6og4keCU7XZnFIL40cQss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824236; c=relaxed/simple;
	bh=BPh7mlN8IOz/sA3PAIH4dtZdIzsOBPvCAAUj6DacZjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHrwm5WeceVguTgKB4Kg6RqFywOjCYGxUh4wW6+y5J/Gm3l/m1/CdABsn7R+FJVBV+4ateL21K+zdaQHoRwGR2t8jEOPqyM2BEoHIqzoclIXE0YF5Pc3lNa4/U0i/JKFDckt++LIxYAAO4DsZ7zpEtrH3oN6ioh6LqKissmz5DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7WMTddK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7WMTddK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74095C19424;
	Tue, 11 Nov 2025 01:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824235;
	bh=BPh7mlN8IOz/sA3PAIH4dtZdIzsOBPvCAAUj6DacZjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7WMTddKppJAX4nM97xDGaR9GkiAFQUSrbxvP2OXgFxlqhhc3+C58pmw7no5s1wBW
	 eduy5VSWFcAnIftshKhKppxfIfy8ekqDYMLcifOxR900LtKBuKrMyXFtcPPT14gvnf
	 E0Locj3LdehsZDVi4jHAsq7aeuqtjc8XiUoB2S3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 416/565] drm/amd/display: change dc stream color settings only in atomic commit
Date: Tue, 11 Nov 2025 09:44:32 +0900
Message-ID: <20251111004536.223515979@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 51cb93aa0c4a9bb126b76f6e9fd640d88de25cee ]

Don't update DC stream color components during atomic check. The driver
will continue validating the new CRTC color state but will not change DC
stream color components. The DC stream color state will only be
programmed at commit time in the `atomic_setup_commit` stage.

It fixes gamma LUT loss reported by KDE users when changing brightness
quickly or changing Display settings (such as overscan) with nightlight
on and HDR. As KWin can do a test commit with color settings different
from those that should be applied in a non-test-only commit, if the
driver changes DC stream color state in atomic check, this state can be
eventually HW programmed in commit tail, instead of the respective state
set by the non-blocking commit.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4444
Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  2 +
 .../amd/display/amdgpu_dm/amdgpu_dm_color.c   | 86 ++++++++++++++-----
 3 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index ea6bc9517ed86..c314c213c21c3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10773,7 +10773,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	if (dm_new_crtc_state->base.color_mgmt_changed ||
 	    dm_old_crtc_state->regamma_tf != dm_new_crtc_state->regamma_tf ||
 	    drm_atomic_crtc_needs_modeset(new_crtc_state)) {
-		ret = amdgpu_dm_update_crtc_color_mgmt(dm_new_crtc_state);
+		ret = amdgpu_dm_check_crtc_color_mgmt(dm_new_crtc_state, true);
 		if (ret)
 			goto fail;
 	}
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 9603352ee0949..47f6569be54cb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -971,6 +971,8 @@ void amdgpu_dm_init_color_mod(void);
 int amdgpu_dm_create_color_properties(struct amdgpu_device *adev);
 int amdgpu_dm_verify_lut_sizes(const struct drm_crtc_state *crtc_state);
 int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc);
+int amdgpu_dm_check_crtc_color_mgmt(struct dm_crtc_state *crtc,
+				    bool check_only);
 int amdgpu_dm_update_plane_color_mgmt(struct dm_crtc_state *crtc,
 				      struct drm_plane_state *plane_state,
 				      struct dc_plane_state *dc_plane_state);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
index ebabfe3a512f4..e9c765e1c17ce 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
@@ -566,12 +566,11 @@ static int __set_output_tf(struct dc_transfer_func *func,
 	return res ? 0 : -ENOMEM;
 }
 
-static int amdgpu_dm_set_atomic_regamma(struct dc_stream_state *stream,
+static int amdgpu_dm_set_atomic_regamma(struct dc_transfer_func *out_tf,
 					const struct drm_color_lut *regamma_lut,
 					uint32_t regamma_size, bool has_rom,
 					enum dc_transfer_func_predefined tf)
 {
-	struct dc_transfer_func *out_tf = &stream->out_transfer_func;
 	int ret = 0;
 
 	if (regamma_size || tf != TRANSFER_FUNCTION_LINEAR) {
@@ -885,33 +884,33 @@ int amdgpu_dm_verify_lut_sizes(const struct drm_crtc_state *crtc_state)
 }
 
 /**
- * amdgpu_dm_update_crtc_color_mgmt: Maps DRM color management to DC stream.
+ * amdgpu_dm_check_crtc_color_mgmt: Check if DRM color props are programmable by DC.
  * @crtc: amdgpu_dm crtc state
+ * @check_only: only check color state without update dc stream
  *
- * With no plane level color management properties we're free to use any
- * of the HW blocks as long as the CRTC CTM always comes before the
- * CRTC RGM and after the CRTC DGM.
- *
- * - The CRTC RGM block will be placed in the RGM LUT block if it is non-linear.
- * - The CRTC DGM block will be placed in the DGM LUT block if it is non-linear.
- * - The CRTC CTM will be placed in the gamut remap block if it is non-linear.
+ * This function just verifies CRTC LUT sizes, if there is enough space for
+ * output transfer function and if its parameters can be calculated by AMD
+ * color module. It also adjusts some settings for programming CRTC degamma at
+ * plane stage, using plane DGM block.
  *
  * The RGM block is typically more fully featured and accurate across
  * all ASICs - DCE can't support a custom non-linear CRTC DGM.
  *
  * For supporting both plane level color management and CRTC level color
- * management at once we have to either restrict the usage of CRTC properties
- * or blend adjustments together.
+ * management at once we have to either restrict the usage of some CRTC
+ * properties or blend adjustments together.
  *
  * Returns:
- * 0 on success. Error code if setup fails.
+ * 0 on success. Error code if validation fails.
  */
-int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc)
+
+int amdgpu_dm_check_crtc_color_mgmt(struct dm_crtc_state *crtc,
+				    bool check_only)
 {
 	struct dc_stream_state *stream = crtc->stream;
 	struct amdgpu_device *adev = drm_to_adev(crtc->base.state->dev);
 	bool has_rom = adev->asic_type <= CHIP_RAVEN;
-	struct drm_color_ctm *ctm = NULL;
+	struct dc_transfer_func *out_tf;
 	const struct drm_color_lut *degamma_lut, *regamma_lut;
 	uint32_t degamma_size, regamma_size;
 	bool has_regamma, has_degamma;
@@ -940,6 +939,14 @@ int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc)
 	crtc->cm_has_degamma = false;
 	crtc->cm_is_degamma_srgb = false;
 
+	if (check_only) {
+		out_tf = kvzalloc(sizeof(*out_tf), GFP_KERNEL);
+		if (!out_tf)
+			return -ENOMEM;
+	} else {
+		out_tf = &stream->out_transfer_func;
+	}
+
 	/* Setup regamma and degamma. */
 	if (is_legacy) {
 		/*
@@ -954,8 +961,8 @@ int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc)
 		 * inverse color ramp in legacy userspace.
 		 */
 		crtc->cm_is_degamma_srgb = true;
-		stream->out_transfer_func.type = TF_TYPE_DISTRIBUTED_POINTS;
-		stream->out_transfer_func.tf = TRANSFER_FUNCTION_SRGB;
+		out_tf->type = TF_TYPE_DISTRIBUTED_POINTS;
+		out_tf->tf = TRANSFER_FUNCTION_SRGB;
 		/*
 		 * Note: although we pass has_rom as parameter here, we never
 		 * actually use ROM because the color module only takes the ROM
@@ -963,16 +970,12 @@ int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc)
 		 *
 		 * See more in mod_color_calculate_regamma_params()
 		 */
-		r = __set_legacy_tf(&stream->out_transfer_func, regamma_lut,
+		r = __set_legacy_tf(out_tf, regamma_lut,
 				    regamma_size, has_rom);
-		if (r)
-			return r;
 	} else {
 		regamma_size = has_regamma ? regamma_size : 0;
-		r = amdgpu_dm_set_atomic_regamma(stream, regamma_lut,
+		r = amdgpu_dm_set_atomic_regamma(out_tf, regamma_lut,
 						 regamma_size, has_rom, tf);
-		if (r)
-			return r;
 	}
 
 	/*
@@ -981,6 +984,43 @@ int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc)
 	 * have to place the CTM in the OCSC in that case.
 	 */
 	crtc->cm_has_degamma = has_degamma;
+	if (check_only)
+		kvfree(out_tf);
+
+	return r;
+}
+
+/**
+ * amdgpu_dm_update_crtc_color_mgmt: Maps DRM color management to DC stream.
+ * @crtc: amdgpu_dm crtc state
+ *
+ * With no plane level color management properties we're free to use any
+ * of the HW blocks as long as the CRTC CTM always comes before the
+ * CRTC RGM and after the CRTC DGM.
+ *
+ * - The CRTC RGM block will be placed in the RGM LUT block if it is non-linear.
+ * - The CRTC DGM block will be placed in the DGM LUT block if it is non-linear.
+ * - The CRTC CTM will be placed in the gamut remap block if it is non-linear.
+ *
+ * The RGM block is typically more fully featured and accurate across
+ * all ASICs - DCE can't support a custom non-linear CRTC DGM.
+ *
+ * For supporting both plane level color management and CRTC level color
+ * management at once we have to either restrict the usage of CRTC properties
+ * or blend adjustments together.
+ *
+ * Returns:
+ * 0 on success. Error code if setup fails.
+ */
+int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc)
+{
+	struct dc_stream_state *stream = crtc->stream;
+	struct drm_color_ctm *ctm = NULL;
+	int ret;
+
+	ret = amdgpu_dm_check_crtc_color_mgmt(crtc, false);
+	if (ret)
+		return ret;
 
 	/* Setup CRTC CTM. */
 	if (crtc->base.ctm) {
-- 
2.51.0



