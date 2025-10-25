Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15AC78F36;
	Sat, 25 Oct 2025 16:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409277; cv=none; b=d2tImBga14zy8weqPre6DMxMqyLXBrqPzWsxakzq1ZPVG35IRynXHhki1DWP3WesoLtKNcGrF66SklVU61HXM1wArfj8g1xo9tjSsGRJBR+a7fe9Omu/xq+A8zjs3T1vIWwNgLhZY02qEF6KjGBxW4xvWRwB6AmO33UFUFZXMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409277; c=relaxed/simple;
	bh=U2l0rlnurGlBmBWiNw3mWI+JLwq2dM9+JjgYYRPRM40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FbRYHqUq5Nwf3PAfSKvc4Y56AdxSAm522+EBEZxsPqDLwVBo1bCSXthF4+jKgeZrtchnr7Og6tcy85iDEQ0sUxxiAz3hemirjcNVNJTstjCkhW7V8N7PFcwZaa7XTUGsM8qYc+k3GZirMLlu/Wm3VJ9kAr+i1gFUz60Vv/hew/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHQWQagA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHQWQagA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3102C116D0;
	Sat, 25 Oct 2025 16:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409277;
	bh=U2l0rlnurGlBmBWiNw3mWI+JLwq2dM9+JjgYYRPRM40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHQWQagA/htx7yEjMQK7+jox+pe4GdDnbXYvGGhioF0GXWFa+YWSq7CuHUbdRGlnv
	 u5RyYayN5CCyH4rcWzy78avqUfhp+NBPvu1XnjG7Qn+ujV7jMJLy+pt71LOeO6/4CB
	 3CuQ3Z/Md78yv3zVqqD+iv8AXYR8RsKD2PDYyyoDulf/pydT65/O5LFE7//thAUowR
	 TQ8sy7gOnNu9TMjKntR/1eEMyCiWKg9piQ6ng+T/Dlq49TbFXW7Qh7rtMuBrW1IwNb
	 6kpx9S5IhkSsvR1mPwtmbOr5THA8M53+rPa3//7muhzEkbWCZkeHk/ZfyE+y4cBgMI
	 ZqfilUddcr+Iw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Melissa Wen <mwen@igalia.com>,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	alex.hung@amd.com,
	Wayne.Lin@amd.com,
	aurabindo.pillai@amd.com,
	chiahsuan.chung@amd.com,
	alexandre.f.demers@gmail.com,
	matthew.schwartz@linux.dev,
	ivan.lipski@amd.com,
	Dillon.Varone@amd.com,
	alvin.lee2@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: change dc stream color settings only in atomic commit
Date: Sat, 25 Oct 2025 11:58:09 -0400
Message-ID: <20251025160905.3857885-258-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES
- The check stage now calls the new validator
  `amdgpu_dm_check_crtc_color_mgmt(dm_new_crtc_state, true)` so it only
  verifies LUT sizes/params without mutating the shared
  `dc_stream_state` during test commits
  (`drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:11210`). This
  removes the long-standing race where KWin’s test commits overwrote the
  real gamma state, causing the LUT loss reported in issue 4444.
- `amdgpu_dm_check_crtc_color_mgmt()` factorizes the existing
  programming logic but, when `check_only` is true, it works on a
  temporary transfer-function object allocated with `kvzalloc` and frees
  it before returning, leaving the real stream untouched
  (`drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c:913`,
  `drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c:947`).
- The actual programming still happens in
  `amdgpu_dm_update_crtc_color_mgmt()`, which now simply reuses the
  helper with `check_only = false` before applying the CTM
  (`drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c:1015`), and
  `amdgpu_dm_set_atomic_regamma()` was adjusted to accept the transfer-
  function pointer passed in by either path
  (`drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_color.c:569`).
- Change is tightly scoped to AMD display color management, introduces
  no API churn, and has no external dependencies—making it
  straightforward to backport. The added allocation happens only on
  color-management updates and is paired with `kvfree`, so regression
  risk is minimal compared to the current user-visible gamma breakage.

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

