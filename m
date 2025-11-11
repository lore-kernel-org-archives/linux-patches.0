Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373572DC350;
	Tue, 11 Nov 2025 01:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825019; cv=none; b=QWIND4RYP754ckFRIlJMwyRLhD7yrif5u/BM5vTwWYUN0/A6RFYdi0o/Oun1kngCrhU9562WuQ5jBNBUvjPPL136FMQFBDNml4UXWs6T7idny5UpVLKttIIL9V5iH26KRKGz8QrodZrJXE8vZ78WMKta66sHmd/6EfYky2CPbTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825019; c=relaxed/simple;
	bh=TsxobwVtW4qdtRlQN/ksMd+jxN10aCEIgiPw57ftm7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yks04yEEAyCWOSHe7tm0YZTr/JbfoDiufMyd/b0K20fADPCMv/9mvvJP4g62XWamadCrR92m+xSVaYsSAMi42jHH/uY9TeOQ9OicDOQXQAcGbxOrZSk7xkzV4nR8E13p13v5Avu3XnNDesBs/NmpTyQo5w7TH5sPyNzkGOvClwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFsnEJyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFsnEJyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBC1C4CEF5;
	Tue, 11 Nov 2025 01:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825019;
	bh=TsxobwVtW4qdtRlQN/ksMd+jxN10aCEIgiPw57ftm7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFsnEJyKOsf9B0/4LMeR3MBZXpxQgRy2Y5jK0feEF2rzkYZI7ySD9t3T+e6JMOdok
	 jNN7XjXS49xz92phDxhHIFFhfz9Cc2VcHF3Gg7PF8JVNQKOYRsLRFkswYrJPxfUnHx
	 LWtVt3YaRf52yiopHdzV1yUrN8AmIq/Y/wVmX9yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Melissa Wen <mwen@igalia.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 627/849] drm/amd/display: change dc stream color settings only in atomic commit
Date: Tue, 11 Nov 2025 09:43:17 +0900
Message-ID: <20251111004551.592940148@linuxfoundation.org>
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
index d66c9609efd8d..60eb2c2c79b77 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -11105,7 +11105,7 @@ static int dm_update_crtc_state(struct amdgpu_display_manager *dm,
 	if (dm_new_crtc_state->base.color_mgmt_changed ||
 	    dm_old_crtc_state->regamma_tf != dm_new_crtc_state->regamma_tf ||
 	    drm_atomic_crtc_needs_modeset(new_crtc_state)) {
-		ret = amdgpu_dm_update_crtc_color_mgmt(dm_new_crtc_state);
+		ret = amdgpu_dm_check_crtc_color_mgmt(dm_new_crtc_state, true);
 		if (ret)
 			goto fail;
 	}
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index c18a6b43c76f6..42801caf57b69 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -1037,6 +1037,8 @@ void amdgpu_dm_init_color_mod(void);
 int amdgpu_dm_create_color_properties(struct amdgpu_device *adev);
 int amdgpu_dm_verify_lut_sizes(const struct drm_crtc_state *crtc_state);
 int amdgpu_dm_update_crtc_color_mgmt(struct dm_crtc_state *crtc);
+int amdgpu_dm_check_crtc_color_mgmt(struct dm_crtc_state *crtc,
+				    bool check_only);
 int amdgpu_dm_update_plane_color_mgmt(struct dm_crtc_state *crtc,
 				      struct drm_plane_state *plane_state,
 				      struct dc_plane_state *dc_plane_state);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c
index c0dfe2d8b3bec..d4739b6334c24 100644
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



