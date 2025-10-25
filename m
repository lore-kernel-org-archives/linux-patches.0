Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8751F1306;
	Sat, 25 Oct 2025 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408666; cv=none; b=ZCU/0kV0Qn30FDoasaSU+48BR9e7DmByBWuNeUpX/5aQ/hQ/H8DCh9b2vFaZnkQsiMmX4vBZbtySGA9jVs0hzKjgBJHbLIPxc8Gi/IeZ4swLMSUYaASpsxTDClrHW+eUPByEUhH9URjXaB4IMTygq6PMwpNi1d0J1HGKapx4wqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408666; c=relaxed/simple;
	bh=19RY7MadudPl1hxDrQqkVGcujDkNlsm6JRLLfQJVsMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Co7DPNaVSe4SpI6HZNXSeYPP2ovYLIcounQNUhZCpQHHaJO2fVXqu4bO6/W6LuxXkDm9OgeQRyMYttOwMvciareN444aGGhZqQ4A3kL/C2e3cA4bMNAakga+P+1ovCFwD8u99yb/o3bp22m5xlrsoFAE2wr3tfWeMkopP1IHwO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JWo9oz4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JWo9oz4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1904C4CEFB;
	Sat, 25 Oct 2025 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408665;
	bh=19RY7MadudPl1hxDrQqkVGcujDkNlsm6JRLLfQJVsMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWo9oz4Y7Vp0EHrGtIGFNYzWGKN5IuG2eN5O06xJdzVhXImGbStNib1nIoCjB0NNG
	 Y3wh8Esfx1l9qQpW47YD5ePa8jrzcA3fl7wOhMH9+yTzjBulLRRBeyyhyv4oYPMCEl
	 OtUZ8/T2hUZVqoO4BvvsgUMgBeAowD8BqTgDSWF5RfIbHNQYhWz+qF04Jz/t0GKyQD
	 MORXasFELCDkzpQTh6V3p5r/Pwxp4fd0P1av+SD0vWRWmVKAP3UCeCedtEL/5PrR1w
	 RjP0G/pC/MXwMhjECEQezSY+EfScuJ7/6YVh55k5Lkp9mYVcL1MZVqENnvkXJtpAEh
	 9URExZw5OS2mw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	mario.limonciello@amd.com,
	alex.hung@amd.com,
	Wayne.Lin@amd.com,
	chiahsuan.chung@amd.com,
	alexandre.f.demers@gmail.com,
	ray.wu@amd.com,
	harry.wentland@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Fix pbn_div Calculation Error
Date: Sat, 25 Oct 2025 11:54:25 -0400
Message-ID: <20251025160905.3857885-34-sashal@kernel.org>
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

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 12cdfb61b32a7be581ec5932e0b6a482cb098204 ]

[Why]
dm_mst_get_pbn_divider() returns value integer coming from
the cast from fixed point, but the casted integer will then be used
in dfixed_const to be multiplied by 4096. The cast from fixed point to integer
causes the calculation error becomes bigger when multiplied by 4096.

That makes the calculated pbn_div value becomes smaller than
it should be, which leads to the req_slot number becomes bigger.

Such error is getting reflected in 8k30 timing,
where the correct and incorrect calculated req_slot 62.9 Vs 63.1.
That makes the wrong calculation failed to light up 8k30
after a dock under HBR3 x 4.

[How]
Restore the accuracy by keeping the fraction part
calculated for the left shift operation.

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real user-visible bug: The old code truncated the MST PBN-per-
  timeslot divider to an integer before converting to fixed20_12,
  enlarging the rounding error and causing over-allocation of VCPI
  slots. As the commit message notes, this leads to 8k30 failing to
  light after docking on HBR3 x4 due to slightly inflated slot
  requirements. The change corrects the math to preserve fractional
  precision and eliminates this failure.

- Small, contained change with clear intent:
  - In drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c:857
    the function is reworked to compute the divider with two decimal
    precision using 64-bit math, then return it in fixed20_12 form:
    - New signature:
      drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c:857
    - Precision-preserving computation:
      drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c:862
    - Convert to fixed20_12 while retaining fraction:
      drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c:870
    - This avoids the earlier integer truncation and preserves the
      fractional part used by MST slot calculations.
  - Header updated accordingly:
    drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h:63
    changes the prototype to return `uint32_t` (the fixed20_12 `.full`
    storage).
  - Call site updated to pass the fixed20_12 directly into the MST
    topology state instead of re-wrapping an integer with dfixed_const:
    - drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:8050 now assigns
      `mst_state->pbn_div.full = dm_mst_get_pbn_divider(...)`.

- Aligns with DRM MST core expectations: The MST core uses fixed20_12
  for `pbn_div` and divides fixed-point PBN by this divider to compute
  timeslots:
  - req_slots uses fixed math in drm core:
    drivers/gpu/drm/display/drm_dp_mst_topology.c:4471
    (`DIV_ROUND_UP(dfixed_const(pbn), topology_state->pbn_div.full)`).
    Feeding an accurate fixed20_12 divider here is exactly what the MST
    helpers expect. Previously, providing a fixed point made from a
    truncated integer degraded accuracy.

- Impacted calculations and symptom match: The report of 62.9 vs 63.1
  “req_slot” pre-rounding reflects exactly the error introduced by
  integer-truncating the divider; with the fix, the preserved fractional
  component makes the “ceil(pbn / pbn_div)” calculation correct,
  avoiding off-by-one slot failures that can prevent 8k30 mode setup.

- Regression risk assessment:
  - Scope: Only the AMD DM MST divider computation and its immediate use
    are changed. No architectural changes, no new features.
  - API: The function now returns the fixed20_12 `.full` value as
    `uint32_t`, which is used directly to populate
    `mst_state->pbn_div.full`
    (drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:8050). This is
    consistent and safe.
  - Other AMD call site: In the DSC fairness helper for non-DSC paths,
    `pbn_div` is still treated as an integer when computing a local
    `slot_num` (drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:8121,
    8133). That value is not used by the MST helpers for actual VCPI
    allocation, which relies on `drm_dp_atomic_find_time_slots()` and
    the state’s `pbn_div`
    (drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:8065). Thus, this
    path does not gate the real allocation and does not introduce a
    regression; it could be cleaned up by truncating the fixed divider
    if needed, but it is not a blocker for the bugfix.
  - Math safety: Uses 64-bit intermediate (`div64_u64`) and bounds check
    for null link; no risk of overflow with realistic link bandwidth
    values.

- Stable criteria:
  - Important bugfix with user impact (8k30 MST failure).
  - Minimal, localized changes.
  - No architectural churn; aligns with existing fixed20_12 usage in DRM
    MST core.
  - Low regression risk; behavior is improved and consistent with core
    expectations.

Given the correctness and limited scope, and the clear real-world
failure it fixes, this is a good candidate for backporting to stable
trees.

 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c   |  2 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 13 ++++++++++---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h |  2 +-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index aca57cc815514..afe3a8279c3a9 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7974,7 +7974,7 @@ static int dm_encoder_helper_atomic_check(struct drm_encoder *encoder,
 	if (IS_ERR(mst_state))
 		return PTR_ERR(mst_state);
 
-	mst_state->pbn_div.full = dfixed_const(dm_mst_get_pbn_divider(aconnector->mst_root->dc_link));
+	mst_state->pbn_div.full = dm_mst_get_pbn_divider(aconnector->mst_root->dc_link);
 
 	if (!state->duplicated) {
 		int max_bpc = conn_state->max_requested_bpc;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 77a9d2c7d3185..5412bf046062c 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -822,13 +822,20 @@ void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
 	drm_connector_attach_dp_subconnector_property(&aconnector->base);
 }
 
-int dm_mst_get_pbn_divider(struct dc_link *link)
+uint32_t dm_mst_get_pbn_divider(struct dc_link *link)
 {
+	uint32_t pbn_div_x100;
+	uint64_t dividend, divisor;
+
 	if (!link)
 		return 0;
 
-	return dc_link_bandwidth_kbps(link,
-			dc_link_get_link_cap(link)) / (8 * 1000 * 54);
+	dividend = (uint64_t)dc_link_bandwidth_kbps(link, dc_link_get_link_cap(link)) * 100;
+	divisor = 8 * 1000 * 54;
+
+	pbn_div_x100 = div64_u64(dividend, divisor);
+
+	return dfixed_const(pbn_div_x100) / 100;
 }
 
 struct dsc_mst_fairness_params {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index 600d6e2210111..179f622492dbf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -59,7 +59,7 @@ enum mst_msg_ready_type {
 struct amdgpu_display_manager;
 struct amdgpu_dm_connector;
 
-int dm_mst_get_pbn_divider(struct dc_link *link);
+uint32_t dm_mst_get_pbn_divider(struct dc_link *link);
 
 void amdgpu_dm_initialize_dp_connector(struct amdgpu_display_manager *dm,
 				       struct amdgpu_dm_connector *aconnector,
-- 
2.51.0

