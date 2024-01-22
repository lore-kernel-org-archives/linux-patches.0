Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC595371;
	Tue, 23 Jan 2024 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969474; cv=none; b=t//CogQFBKiXVzv7Ixlv9cikXKEhwlEWjdFXn20pVjivXwXGpA/mpW+Hz2PheMvosaVtadAezavDzF17pkk4kzJKClqNAg5C2Z+JxEKt1jZvSc/FTeNqHUfN5fCsJPmOGbzD1pBIy/KCaZSZ+x19gfNRIDIdTvmu1nF6QisxVFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969474; c=relaxed/simple;
	bh=Kt33JVBzf0jnDIe2ns+BV6U24SAcP9NeS9Zleu3ZxOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dz4GixJ4alGknlLRMUOOcEwsxzntY0gLpmCwlVpBFsVlXP6MNWnPWLepc2s/0ADOrMcNXfjb6JVyEek4PHxJES/0CzAyGiPhRylxWTju+O0iQcza6z+O+K+8gQo3G08QbqYO3hODOl40WLJHEdwVCm2DSw4F3SIb5OXu35vHBaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnwkIKsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnwkIKsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A395C43390;
	Tue, 23 Jan 2024 00:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969474;
	bh=Kt33JVBzf0jnDIe2ns+BV6U24SAcP9NeS9Zleu3ZxOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnwkIKsasYxtxQRlrFHXWKeLaPWNYqZxM7iiLUsSu2GNNxuAEu7RaxWrlg8EkDoxy
	 zbC1REndFBvsTTencl/oGCN5l4uAmqUUCrJRsdQuNm29BQPuSDeMi/U6qmnLenNzzW
	 hPPVYBpGbCIGC9pPgb8d6JLYBWPuVo4xJSf7qrYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manasi Navare <manasi.d.navare@intel.com>,
	Lyude Paul <lyude@redhat.com>,
	Harry Wentland <harry.wentland@amd.com>,
	David Francis <David.Francis@amd.com>,
	Mikita Lipski <mikita.lipski@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 245/641] drm/dp_mst: Fix fractional DSC bpp handling
Date: Mon, 22 Jan 2024 15:52:29 -0800
Message-ID: <20240122235825.593192096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 7707dd6022593f3edd8e182e7935870cf326f874 ]

The current code does '(bpp << 4) / 16' in the MST PBN
calculation, but that is just the same as 'bpp' so the
DSC codepath achieves absolutely nothing. Fix it up so that
the fractional part of the bpp value is actually used instead
of truncated away. 64*1006 has enough zero lsbs that we can
just shift that down in the dividend and thus still manage
to stick to a 32bit divisor.

And while touching this, let's just make the whole thing more
straightforward by making the passed in bpp value .4 binary
fixed point always, instead of having to pass in different
things based on whether DSC is enabled or not.

v2:
- Fix DSC kunit test cases.

Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: David Francis <David.Francis@amd.com>
Cc: Mikita Lipski <mikita.lipski@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Fixes: dc48529fb14e ("drm/dp_mst: Add PBN calculation for DSC modes")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
[Imre: Fix kunit test cases]
Acked-by: Maxime Ripard <mripard@kernel.org>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Acked-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231030155843.2251023-3-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 +-
 .../display/amdgpu_dm/amdgpu_dm_mst_types.c   |  2 +-
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 20 +++++--------------
 drivers/gpu/drm/i915/display/intel_dp_mst.c   |  5 ++---
 drivers/gpu/drm/nouveau/dispnv50/disp.c       |  3 +--
 .../gpu/drm/tests/drm_dp_mst_helper_test.c    |  6 +++---
 include/drm/display/drm_dp_mst_helper.h       |  2 +-
 7 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4e82ee4d74ac..d8c967cee498 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -6928,7 +6928,7 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 								    max_bpc);
 		bpp = convert_dc_color_depth_into_bpc(color_depth) * 3;
 		clock = adjusted_mode->clock;
-		dm_new_connector_state->pbn = drm_dp_calc_pbn_mode(clock, bpp, false);
+		dm_new_connector_state->pbn = drm_dp_calc_pbn_mode(clock, bpp << 4);
 	}
 
 	dm_new_connector_state->vcpi_slots =
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 11da0eebee6c..9b71643d8a89 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1642,7 +1642,7 @@ enum dc_status dm_dp_mst_is_port_support_mode(
 	} else {
 		/* check if mode could be supported within full_pbn */
 		bpp = convert_dc_color_depth_into_bpc(stream->timing.display_color_depth) * 3;
-		pbn = drm_dp_calc_pbn_mode(stream->timing.pix_clk_100hz / 10, bpp, false);
+		pbn = drm_dp_calc_pbn_mode(stream->timing.pix_clk_100hz / 10, bpp << 4);
 		if (pbn > full_pbn)
 			return DC_FAIL_BANDWIDTH_VALIDATE;
 	}
diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 0e0d0e76de06..772b00ebd57b 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -4718,13 +4718,12 @@ EXPORT_SYMBOL(drm_dp_check_act_status);
 
 /**
  * drm_dp_calc_pbn_mode() - Calculate the PBN for a mode.
- * @clock: dot clock for the mode
- * @bpp: bpp for the mode.
- * @dsc: DSC mode. If true, bpp has units of 1/16 of a bit per pixel
+ * @clock: dot clock
+ * @bpp: bpp as .4 binary fixed point
  *
  * This uses the formula in the spec to calculate the PBN value for a mode.
  */
-int drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc)
+int drm_dp_calc_pbn_mode(int clock, int bpp)
 {
 	/*
 	 * margin 5300ppm + 300ppm ~ 0.6% as per spec, factor is 1.006
@@ -4735,18 +4734,9 @@ int drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc)
 	 * peak_kbps *= (1006/1000)
 	 * peak_kbps *= (64/54)
 	 * peak_kbps *= 8    convert to bytes
-	 *
-	 * If the bpp is in units of 1/16, further divide by 16. Put this
-	 * factor in the numerator rather than the denominator to avoid
-	 * integer overflow
 	 */
-
-	if (dsc)
-		return DIV_ROUND_UP_ULL(mul_u32_u32(clock * (bpp / 16), 64 * 1006),
-					8 * 54 * 1000 * 1000);
-
-	return DIV_ROUND_UP_ULL(mul_u32_u32(clock * bpp, 64 * 1006),
-				8 * 54 * 1000 * 1000);
+	return DIV_ROUND_UP_ULL(mul_u32_u32(clock * bpp, 64 * 1006 >> 4),
+				1000 * 8 * 54 * 1000);
 }
 EXPORT_SYMBOL(drm_dp_calc_pbn_mode);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index aa1061262613..03ac2817664e 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -106,8 +106,7 @@ static int intel_dp_mst_find_vcpi_slots_for_bpp(struct intel_encoder *encoder,
 			continue;
 
 		crtc_state->pbn = drm_dp_calc_pbn_mode(adjusted_mode->crtc_clock,
-						       dsc ? bpp << 4 : bpp,
-						       dsc);
+						       bpp << 4);
 
 		slots = drm_dp_atomic_find_time_slots(state, &intel_dp->mst_mgr,
 						      connector->port,
@@ -979,7 +978,7 @@ intel_dp_mst_mode_valid_ctx(struct drm_connector *connector,
 		return ret;
 
 	if (mode_rate > max_rate || mode->clock > max_dotclk ||
-	    drm_dp_calc_pbn_mode(mode->clock, min_bpp, false) > port->full_pbn) {
+	    drm_dp_calc_pbn_mode(mode->clock, min_bpp << 4) > port->full_pbn) {
 		*status = MODE_CLOCK_HIGH;
 		return 0;
 	}
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 118807e38422..d093549f6eb7 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -982,8 +982,7 @@ nv50_msto_atomic_check(struct drm_encoder *encoder,
 		const int clock = crtc_state->adjusted_mode.clock;
 
 		asyh->or.bpc = connector->display_info.bpc;
-		asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3,
-						    false);
+		asyh->dp.pbn = drm_dp_calc_pbn_mode(clock, asyh->or.bpc * 3 << 4);
 	}
 
 	mst_state = drm_atomic_get_mst_topology_state(state, &mstm->mgr);
diff --git a/drivers/gpu/drm/tests/drm_dp_mst_helper_test.c b/drivers/gpu/drm/tests/drm_dp_mst_helper_test.c
index 545beea33e8c..e3c818dfc0e6 100644
--- a/drivers/gpu/drm/tests/drm_dp_mst_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_dp_mst_helper_test.c
@@ -42,13 +42,13 @@ static const struct drm_dp_mst_calc_pbn_mode_test drm_dp_mst_calc_pbn_mode_cases
 		.clock = 332880,
 		.bpp = 24,
 		.dsc = true,
-		.expected = 50
+		.expected = 1191
 	},
 	{
 		.clock = 324540,
 		.bpp = 24,
 		.dsc = true,
-		.expected = 49
+		.expected = 1161
 	},
 };
 
@@ -56,7 +56,7 @@ static void drm_test_dp_mst_calc_pbn_mode(struct kunit *test)
 {
 	const struct drm_dp_mst_calc_pbn_mode_test *params = test->param_value;
 
-	KUNIT_EXPECT_EQ(test, drm_dp_calc_pbn_mode(params->clock, params->bpp, params->dsc),
+	KUNIT_EXPECT_EQ(test, drm_dp_calc_pbn_mode(params->clock, params->bpp << 4),
 			params->expected);
 }
 
diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
index 4429d3b1745b..655862b3d2a4 100644
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -842,7 +842,7 @@ struct edid *drm_dp_mst_get_edid(struct drm_connector *connector,
 int drm_dp_get_vc_payload_bw(const struct drm_dp_mst_topology_mgr *mgr,
 			     int link_rate, int link_lane_count);
 
-int drm_dp_calc_pbn_mode(int clock, int bpp, bool dsc);
+int drm_dp_calc_pbn_mode(int clock, int bpp);
 
 void drm_dp_mst_update_slots(struct drm_dp_mst_topology_state *mst_state, uint8_t link_encoding_cap);
 
-- 
2.43.0



