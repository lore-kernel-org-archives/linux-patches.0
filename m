Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F46A426408;
	Mon, 31 Aug 2026 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183304; cv=none; b=t/V4Y8Bv7hYyeV28W2xKU0HoQOcXnL2aWMPsurfPO5ltEoPBJkDS/mwJ7EMt8hn0RPUo/ToApVlCP9+NEhUOWLJl3W+Ghp2+Fs8OBHdWa/eqCRletbwIjQPxoFXWEddx2poL1FQgJVPwKwxhuLJVtkmwtXcoTDEiXB5IpP6FMVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183304; c=relaxed/simple;
	bh=bndRr2yih9ehv2BaHd34aIU21J9MIKGVS4Ua3gwTt1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQxnfLd0lOdtfM8scHKaczP8wMZxAYvFVFXce9QDfuPbyts7oianmIS2tcdiyGnPXYwghWZTAx2SON8+hqHWC1cmOMuPYFxgXDlu7LCYqN6Y0PasELF9PNkrroVRtt+Bo5Jag9mZa5c7T909k1wxa8dM8fHDXYz/8zLWOKE1QFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIiwXdfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIiwXdfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4754D1F00A3F;
	Mon, 31 Aug 2026 13:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183302;
	bh=+rzxmqvMLiTzDYyaBHgsvbWHJ8M1I8wwtkBuvaPp0EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIiwXdfnJ3FQlD0c+xAVLwF3PThDPtTBlU+2MDAcppTUMJP+t+by+tS26cZGSCRGM
	 g/fi6GySKPS8Jynb+yfc8W5WM0p6ODlA5o/AXVz44Z1l+Cgj1IWOR9akKdb/KxU5w8
	 y9mbj6V+SWvITjUrR0OW8TLP0I88RppUt5h0xIrssAAw2Rc/DsYn0DYSkNA+oGhA64
	 1nNIMjYf/drR2t40bSj4vUNaRvKdCcd9DO91SNE0K+EIr28OSxosbM/UPqECelVsOC
	 sz4j4dGsfh+VtfJgaocGlXbdt74xXHAxp2PwCwZKK6kUEE+XRzZ7Ypous1B8RjAotW
	 vOEq6X2R3FuXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Samson Tam <Samson.Tam@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/display: Check for sharpening case when calculating max vtaps for scaler
Date: Mon, 31 Aug 2026 09:21:35 -0400
Message-ID: <20260831133314.4125787-67-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samson Tam <Samson.Tam@amd.com>

[ Upstream commit 4d8cfd570386eb0b6cb8aa0ca9e9db60a0404337 ]

[Why & How]
- calc_lb_num_partitions has check when scaler is not enabled to use
 larger LB in calculations for max vtaps based on viewport being 1:1
- however, scaler is forced on when sharpening is enabled, so need
 to consider this in check
- taps is predetermined in spl_get_optimal_number_of_taps prior to
 calc_lb_num_partitions.  Add check for taps not 1 to handle
 sharpening case

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Samson Tam <Samson.Tam@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[drm/amd/display]` `[Check]` — verify sharpening when computing
max vertical taps for the DCN401 scaler line-buffer partition
calculation.

**Step 1.2 — Tags**
Record:
- `Reviewed-by: Charlene Liu <charlene.liu@amd.com>`
- `Signed-off-by: Samson Tam <Samson.Tam@amd.com>`
- `Signed-off-by: Ray Wu <ray.wu@amd.com>`
- `Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>`
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>`
- No `Fixes:`, `Reported-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
  (expected for manual review)
- Notable: AMD internal review + `Tested-by` from AMD QA; no syzbot or
  public bug report

**Step 1.3 — Body analysis**
Record:
- **Bug:** `dscl401_spl_calc_lb_num_partitions()` treats a 1:1 viewport
  as “scaler disabled” and uses an inflated line-buffer (LB) size for
  max-vtap math, but sharpening forces the scaler on at 1:1.
- **Symptom:** Overestimated max vertical taps → scaler programmed
  beyond real LB capacity → display corruption/underflow risk on DCN401
  with sharpening at native resolution.
- **Root cause:** `spl_get_optimal_number_of_taps()` sets `taps > 1`
  before calling `spl_calc_lb_num_partitions()`, but the LB-size branch
  only checked viewport 1:1, not taps.
- **Version info:** None in the message.

**Step 1.4 — Hidden bug fix?**
Record: Yes. Despite no “fix” in the subject, this is a hardware-
programming correctness bug in the display scaler path, not a cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- 1 file: `drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c` (+6 /
  −2)
- Function: `dscl401_spl_calc_lb_num_partitions()`
- Scope: single-file, surgical (two conditionals in two `lb_config`
  branches)

**Step 2.2 — Code flow change**
Record:
- **Before:** `viewport.width == h_active && viewport.height ==
  v_active` → use enlarged LB constants (e.g. `970+1290+1170` vs
  `970+1290+484`).
- **After:** Same enlarged LB only when viewport is 1:1 **and** `h_taps
  == 1 && v_taps == 1` (scaler truly off).
- **Path:** `spl_get_optimal_number_of_taps()` →
  `spl_calc_lb_num_partitions()` →
  `dscl401_spl_calc_lb_num_partitions()` during mode/plane setup on
  DCN401.

**Step 2.3 — Bug mechanism**
Record: **Logic / hardware correctness fix.**
When sharpening is enabled at 1:1, taps are already 6 (EASF path) before
LB calculation, but the old code still assumed scaler-off and inflated
LB size by ~25% (RGB) or ~55% (YUV420), inflating `num_part_y` and
`max_taps_y`.

**Step 2.4 — Fix quality**
Record: Obviously correct and minimal. Uses taps already set before the
LB call as the scaler-enabled indicator. Low regression risk; only
narrows the enlarged-LB fast path.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Buggy viewport-only check introduced in `70839da636050` (“Add
new DCN401 sources”, 2024-04-26). Present in v6.18.44.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record: DCN401 added in `70839da636050`; ISHARP for DCN401 in
`2998bccfa4197` (2024-05-29). Related DCN401 corruption fix:
`5d74be8c3a941` (YUV color corruption). Standalone one-commit fix.

**Step 3.4 — Author context**
Record: Samson Tam is an active AMD display contributor; same author as
`5d74be8c3a941`.

**Step 3.5 — Dependencies**
Record: None. Only needs `scl_data->taps` fields already used in this
tree. `git apply --check` on mainline commit `4d8cfd570386e` succeeds
cleanly.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: `b4 dig -c 4d8cfd570386e` found no lore.kernel.org match (likely
direct AMD/DRM tree path). lore.kernel.org search blocked by Anubis.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` also found nothing. Commit has `Reviewed-by`
(Charlene Liu), `Tested-by` (Daniel Wheeler), and Alex Deucher as
committer.

**Step 4.3 — Bug report**
Record: N/A — no `Reported-by:` or `Link:` tags.

**Step 4.4 — Series context**
Record: Standalone; not part of a multi-patch series.

**Step 4.5 — Stable list history**
Record: Not searched successfully on lore (bot protection). No evidence
of prior stable rejection.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `dscl401_spl_calc_lb_num_partitions()`, called via SPL callbacks
from `spl_get_optimal_number_of_taps()`.

**Step 5.2 — Callers**
Record:
- `spl_get_optimal_number_of_taps()` (dc_spl.c:1033)
- `spl_calculate_number_of_taps()` → `spl_calculate_scaler_params()` —
  display mode/plane configuration on DCN401

**Step 5.3 — Callees**
Record: Arithmetic on LB memory constants; sets `num_part_y` /
`num_part_c` used to derive `max_taps_y` / `max_taps_c`.

**Step 5.4 — Reachability**
Record: Reachable on normal display use when DCN401 + adaptive
sharpening (ISHARP) at 1:1 scaling. Userspace can enable sharpening via
amdgpu display stack; not an obscure debug-only path.

**Step 5.5 — Similar patterns**
Record: `dscl32_spl_calc_lb_num_partitions()` has the same viewport-only
check without taps check, but this commit targets DCN401 only.
`dscl401_calc_lb_num_partitions()` (non-SPL) unchanged; SPL path is the
sharpening path (`use_spl`).

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.**
`drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c` lines 391–406
lack the taps check. Fix commit `4d8cfd570386e` is **not** in this tree
(`git merge-base --is-ancestor` fails).

**Step 6.2 — Backport complications**
Record: Clean apply verified (`git show 4d8cfd570386e | git apply
--check`). No conflicts expected.

**Step 6.3 — Related fixes already present?**
Record: No equivalent taps check. DCN401 and ISHARP support are both
present.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/gpu/drm/amd/display` — AMDGPU display (DCN401 DPP
scaler). Criticality: **IMPORTANT** (display output for DCN401 hardware
users).

**Step 7.2 — Activity**
Record: Actively maintained; multiple DCN401 fixes in this tree (NULL
deref, color corruption, signal checks).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users of DCN401-based AMD GPUs (discrete/APU) on 6.18.y with
adaptive sharpening at native (1:1) resolution. Driver-specific, not
universal.

**Step 8.2 — Trigger conditions**
Record: DCN401 + sharpening enabled + 1:1 viewport. Common for desktop
use at native panel resolution with sharpening on. Unprivileged users
can trigger via normal display configuration.

**Step 8.3 — Failure mode severity**
Record: Incorrect max-vtap calculation → scaler programmed beyond LB
capacity → **display corruption / underflow** (MEDIUM–HIGH for affected
hardware; not a kernel oops, but user-visible and similar to accepted
DCN401 corruption fixes).

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** MEDIUM–HIGH for DCN401 + sharpening users
- **Risk:** VERY LOW (8-line logic fix, tested, reviewed)
- **Ratio:** Favorable for backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

*For backport:*
- Real bug in v6.18.44 DCN401 SPL scaler LB calculation
- Causes overestimated max vtaps when sharpening forces scaler at 1:1
- Small, reviewed, tested, applies cleanly
- Precedent: `5d74be8c3a941` (DCN401 display corruption) is already in
  this tree
- DCN401 + ISHARP both present since 2024

*Against backport:*
- No public bug report or syzbot finding
- Narrow hardware/feature scope (DCN401 + sharpening at 1:1)
- Display corruption, not documented kernel crash
- No lore discussion found

*Unresolved:*
- No public user reports found
- Exact visual failure modes not documented in the commit message

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic matches commit
   explanation; `Tested-by` + `Reviewed-by`
2. Fixes a real user-affecting bug? **PASS** — incorrect HW scaler
   config on reachable path
3. Important issue? **PASS** — display corruption on affected hardware
   (same class as prior DCN401 stable fix)
4. Small and contained? **PASS** — 8 lines, one function, one file
5. No new features/APIs? **PASS** — correctness fix only
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 — Exception category**
Record: Hardware workaround / driver correctness fix for existing DCN401
hardware support (not a new device ID).

**Step 9.4 — Decision rationale**
For **linux-6.18.y (v6.18.44)**: the buggy code exists, prerequisites
(DCN401, ISHARP, SPL) are present, the fix is minimal and low-risk, and
it prevents display corruption on a real use case (sharpening at native
resolution). This matches the class of AMDGPU display corruption fixes
already carried in this stable tree.

---

## Verification

- [Phase 1] Parsed commit `4d8cfd570386e` message and tags from `git
  show`
- [Phase 2] Read diff and current `dcn401_dpp.c` lines 357–428;
  confirmed missing taps check
- [Phase 2] Traced `spl_get_optimal_number_of_taps()` at
  dc_spl.c:1006–1034 — taps set before LB calc
- [Phase 2] Read sharpening logic at dc_spl.c:1121–1140 and
  dml21_translation_helper.c:558–563
- [Phase 3] `git blame` lines 390–416 → `70839da636050` (2024-04-26)
- [Phase 3] `git log -S "use increased LB size..."` → introduced with
  DCN401
- [Phase 3] `2998bccfa4197` ISHARP support confirmed ancestor of HEAD
- [Phase 3] `git show 4d8cfd570386e | git apply --check` → clean apply
- [Phase 4] `b4 dig -c 4d8cfd570386e` → no lore match
- [Phase 4] `b4 dig -c 4d8cfd570386e -w` and `-a` → no results
- [Phase 4] lore.kernel.org WebFetch → blocked by Anubis
- [Phase 5] Grep callers: `spl_get_optimal_number_of_taps` →
  `spl_calculate_number_of_taps` → display setup
- [Phase 6] `git describe HEAD` → v6.18.44
- [Phase 6] `git merge-base --is-ancestor 4d8cfd570386e HEAD` → fix NOT
  in tree
- [Phase 6] Buggy viewport-only conditions confirmed at lines 391–392
  and 405–406
- [Phase 7] `git log --grep=dcn401` shows active DCN401 maintenance
  including `5d74be8c3a941`
- [Phase 8] Quantified LB overestimate: 3430 vs 2744 (RGB), 5770 vs 3712
  (YUV420)

**YES**

 drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
index b62bbadb0d440..029f59a58c780 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn401/dcn401_dpp.c
@@ -389,9 +389,11 @@ void dscl401_spl_calc_lb_num_partitions(
 		lb_memory_size_a = 1290;
 	} else if (lb_config == LB_MEMORY_CONFIG_3) {
 		if (scl_data->viewport.width  == scl_data->h_active &&
-			scl_data->viewport.height == scl_data->v_active) {
+			scl_data->viewport.height == scl_data->v_active &&
+			scl_data->taps.h_taps == 1 && scl_data->taps.v_taps == 1) {
 			/* 420 mode: luma using all 3 mem from Y, plus 3rd mem from Cr and Cb */
 			/* use increased LB size for calculation only if Scaler not enabled */
+			/* Scaler is forced on when sharpening is on. Add check for taps = 1 */
 			lb_memory_size = 970 + 1290 + 1170 + 1170 + 1170;
 			lb_memory_size_c = 970 + 1290;
 			lb_memory_size_a = 970 + 1290 + 1170;
@@ -403,8 +405,10 @@ void dscl401_spl_calc_lb_num_partitions(
 		}
 	} else {
 		if (scl_data->viewport.width  == scl_data->h_active &&
-			scl_data->viewport.height == scl_data->v_active) {
+			scl_data->viewport.height == scl_data->v_active &&
+			scl_data->taps.h_taps == 1 && scl_data->taps.v_taps == 1) {
 			/* use increased LB size for calculation only if Scaler not enabled */
+			/* Scaler is forced on when sharpening is on. Add check for taps = 1 */
 			lb_memory_size = 970 + 1290 + 1170;
 			lb_memory_size_c = 970 + 1290 + 1170;
 			lb_memory_size_a = 970 + 1290 + 1170;
-- 
2.53.0

