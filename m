Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353823D0938;
	Mon, 20 Apr 2026 13:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691819; cv=none; b=L5swMHszS6ZMAcAROknYFq+BfCczfd85l3FLT+waBohGNBr0tecLvrEwtIFDFi5Tr/gQcjSQXVsN0MTWue7VF+zoqd2g209bB3bWbtplKRmr+xbiLDzdYmgU3bdj3wEAZQUj+65Y1AWMy5DaaUA1VlC1/qxv5QaOLwdcCeSdl1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691819; c=relaxed/simple;
	bh=m8CFpmikgbDVJIP7xd+FqUatg2Sl6tijDEeLmdzOWXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSm7jiFhUHo3rDlxyIAWZ+y7RMuqFVXI16oPPSewDUjPUBYtnWk+67s7KEyGedZj2gwZAhTyvtXAzQn5FhMTFkIuzVl/jEaaPnwVdVr76BrvRC/GA0mW9jmbeoMm5E+ODOdI73KUTff08kHEkO3Ix5mo4aHWmZ0f93ElC2zykms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtBWn/PI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtBWn/PI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED492C19425;
	Mon, 20 Apr 2026 13:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691819;
	bh=m8CFpmikgbDVJIP7xd+FqUatg2Sl6tijDEeLmdzOWXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtBWn/PIZSO4o+pQv5vW/ovLoxrxgi0xqa/Qi3FtOlEP0Tbk5xU2mT6+ndpsOgv+B
	 2XCkqMUG6Eqxr92p/LdxcytAhjKQVuY+QV42ivJMgVdWlxQZd8I9eWDfeHC9J2GXc/
	 LDBJFey0WMISCOwIOXM1+HLM+dSrjxy/D1ESMJkVu/QF6bfA6auIouYsgKl0wOsA0q
	 bhBwMMRHey6u0RRU6rdNLAINxbOg29HHQReTdi3m8hFYzKx1JNlve/H3ESZoH6K5wC
	 LikWQWBpqAPyBM+Zr5/g+ZxOo/NBmGiNMnL+1A2HM+yxV/MNdZuDwtm1K3ZdYEKuZb
	 IlTHeTMnwElUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Nwankwo <Benjamin.Nwankwo@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Nevenko Stupar <nevenko.stupar@amd.com>,
	Chuanyu Tseng <chuanyu.tseng@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
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
Subject: [PATCH AUTOSEL 7.0-6.19] drm/amd/display: Clamp dc_cursor_position x_hotspot to prevent integer overflow
Date: Mon, 20 Apr 2026 09:20:07 -0400
Message-ID: <20260420132314.1023554-213-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Benjamin Nwankwo <Benjamin.Nwankwo@amd.com>

[ Upstream commit a2aa7987de1169548c465f6cc1019d2112e0e8b5 ]

why:
Workaround for duplicate cursor. Cursor offsetting via x_hotspot attempts
to write a 32 bit unsigned integer to the 8 bit field CURSOR_HOT_SPOT_X.
This wraps cursor position back into focus if x_hotspot exceeds 8 bits,
making duplicate cursors visible

how:
Clamp x_hotspot before writing to hardware

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Nevenko Stupar <nevenko.stupar@amd.com>
Signed-off-by: Benjamin Nwankwo <Benjamin.Nwankwo@amd.com>
Signed-off-by: Chuanyu Tseng <chuanyu.tseng@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding of the bug. Let me compile the
full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amd/display` (AMD display driver, DCN401 specifically)
- Action verb: "Clamp" (prevent overflow, clearly a bug fix)
- Summary: Clamp x_hotspot value before writing to 8-bit hardware
  register to prevent integer overflow causing duplicate cursors

**Step 1.2: Tags**
- `Reviewed-by: Charlene Liu` and `Reviewed-by: Nevenko Stupar` - two
  AMD engineers reviewed
- `Signed-off-by: Benjamin Nwankwo` (author), `Signed-off-by: Chuanyu
  Tseng` (submitter)
- `Tested-by: Dan Wheeler` - standard AMD display QA tester
- `Signed-off-by: Alex Deucher` - AMD GPU subsystem maintainer accepted
  the patch
- No Fixes: tag (expected for candidate review)
- No Cc: stable tag (expected)

**Step 1.3: Commit Body**
- Bug: 32-bit `x_hotspot` value written to 8-bit `CURSOR_HOT_SPOT_X`
  hardware register
- Symptom: Value wraps, causing cursor position to jump back, creating
  visible duplicate cursors
- Fix: Clamp `x_hotspot` to 0xFF before hardware register write

**Step 1.4: Hidden Bug Fix Detection**
This is explicitly a bug fix (visual display glitch with duplicate
cursors). Not hidden.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed:
  `drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c`
- +4 lines, -3 lines (net +1)
- Function modified: `hubp401_cursor_set_position()`
- Scope: Single-file surgical fix

**Step 2.2: Code Flow Change**
1. New variable `x_hotspot_clamped = pos->x_hotspot` declared
2. Before writing to HW register, clamp: `if (x_hotspot_clamped > 0xFF)
   x_hotspot_clamped = 0xFF;`
3. Use `x_hotspot_clamped` instead of `pos->x_hotspot` in
   `REG_SET_2(CURSOR_HOT_SPOT, ...)` call

**Step 2.3: Bug Mechanism**
Category: Integer overflow / type mismatch bug. A 32-bit value is
truncated to 8 bits by hardware, causing wraparound. The fix clamps the
value to 8-bit range before writing.

**Step 2.4: Fix Quality**
Obviously correct - the hardware register is 8 bits, so values > 255 are
meaningless. Clamping to 0xFF is the right approach. Zero regression
risk - the clamped path already results in incorrect cursor positioning,
so saturating at max is strictly better than wrapping.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy line (`CURSOR_HOT_SPOT_X, pos->x_hotspot`) was last touched by
commit `518a368c57a0e6` ("Update cursor offload assignments", by Alvin
Lee, 2025-10-02). The underlying bug pattern has existed since the
function was first introduced in commit `ee8287e068a3` ("Fix cursor
issues with ODMs and HW rotations"), first appearing in v6.11.

**Step 3.2: No Fixes: tag** (expected)

**Step 3.3: File History**
17 commits between v6.11 and v7.0 modified this file. The function has
been actively developed. The v7.0 version includes cursor offload
support that doesn't exist in v6.11/v6.12.

**Step 3.4: Author**
Benjamin Nwankwo is an AMD display engineer. The patch was submitted
through Chuanyu Tseng as part of a DC patch series.

**Step 3.5: Dependencies**
The fix is self-contained. No dependencies on other patches. The core
logic (clamp before REG_SET_2) applies regardless of the cursor offload
changes.

## PHASE 4: MAILING LIST RESEARCH

The patch was submitted as [PATCH v2 8/9] in "DC Patches March 10, 2026"
series. It's v2 (revised from v1 - v1 reference:
https://patchwork.freedesktop.org/patch/710768/). The series also
includes other unrelated DC patches. No objections or NAKs found on the
mailing list. No explicit stable nomination by reviewers.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Function**: `hubp401_cursor_set_position()`

**Step 5.2: Callers**
Called via `hubp->funcs->set_cursor_position()` from
`dcn401_set_cursor_position()` in the hwseq layer. This is the main
cursor position programming path for DCN401 hardware.

**Step 5.4: Critical Call Chain - THE ACTUAL TRIGGER PATH**
In `dcn401_set_cursor_position()` (lines 1177-1182 and 1196-1202):

```1177:1202:drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
        if (x_pos < 0) {
                pos_cpy.x_hotspot -= x_pos;
                // ...
                x_pos = 0;
        }
        // ...
        if (bottom_pipe_x_pos < 0) {
                // ...
                pos_cpy.x_hotspot -= bottom_pipe_x_pos;
```

When ODM combining or MPC combining is active and the cursor crosses
slice boundaries, `x_pos` becomes negative. The line `pos_cpy.x_hotspot
-= x_pos` (where `x_pos` is negative) **adds** a potentially large value
to `x_hotspot`. For example, if the cursor is 500 pixels to the left of
an ODM slice boundary, `x_hotspot` grows by 500 -- far exceeding the
8-bit register maximum of 255.

This confirms the bug is **real and triggerable** in ODM/MPC combining
scenarios (multi-monitor, high-resolution displays).

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
The file exists from v6.11 onwards. The ODM hotspot inflation code
(`x_hotspot -= x_pos`) exists in both v6.11 and v6.12. The bug is
present in all versions containing DCN401.

**Step 6.2: Backport Complications**
The v6.11/v6.12 versions of `hubp401_cursor_set_position()` differ from
v7.0 (no cursor offload path, different variable naming). The patch
would need minor rework for older trees but the clamping concept applies
cleanly.

## PHASE 7: SUBSYSTEM CONTEXT

- Subsystem: `drivers/gpu/drm/amd/display` - AMD display driver
- Criticality: IMPORTANT (AMD GPUs are widely used; display bugs affect
  all users of that hardware)
- DCN401 = AMD RDNA4 display controller

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**: Users with AMD DCN401 (RDNA4) GPUs using
ODM combining or MPC combining (multi-monitor, high-resolution displays)

**Step 8.2: Trigger Conditions**: Cursor moves across ODM or MPC slice
boundaries with enough offset to push x_hotspot > 255. Common in multi-
monitor or ultra-wide setups.

**Step 8.3: Failure Mode**: Visible duplicate cursor artifact. Severity:
MEDIUM (user-visible display glitch, not a crash/security/corruption
issue, but very annoying)

**Step 8.4: Risk-Benefit**:
- BENEFIT: High - fixes a visible display bug for AMD GPU users
- RISK: Very Low - 3 lines, obviously correct clamping, zero regression
  potential

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real, user-visible display bug (duplicate cursors)
- Trigger path confirmed: ODM/MPC combining inflates x_hotspot beyond
  8-bit register width
- Fix is minimal (3 effective lines), obviously correct, zero regression
  risk
- Reviewed by 2 AMD engineers, tested, accepted by subsystem maintainer
- Hardware workaround pattern - exactly the type of fix allowed in
  stable
- Bug exists in all stable trees containing DCN401 (v6.11+)

**Evidence AGAINST backporting:**
- Not a crash, security issue, or data corruption
- DCN401 is relatively new hardware (v6.11+)
- Would need minor rework for v6.11/v6.12 due to different function
  structure
- No explicit stable nomination or Fixes: tag

**Stable Rules Checklist:**
1. Obviously correct and tested? YES (trivial clamp, Tested-by)
2. Fixes a real bug? YES (duplicate cursor visible to users)
3. Important issue? MEDIUM (visible display glitch, not crash/security)
4. Small and contained? YES (3 lines, single function)
5. No new features/APIs? YES (pure bug fix)
6. Can apply to stable? YES for 7.0.y; needs minor rework for
   6.11.y/6.12.y

## Verification

- [Phase 1] Parsed tags: 2x Reviewed-by (AMD engineers), Tested-by (Dan
  Wheeler), Signed-off by Alex Deucher (subsystem maintainer)
- [Phase 2] Diff analysis: 3 effective lines in
  `hubp401_cursor_set_position()`, clamps x_hotspot to 0xFF before
  register write
- [Phase 3] git blame: buggy line from commit 518a368c57a0e6 (cursor
  offload update); original function from ee8287e068a3 (v6.11)
- [Phase 3] git ls-tree: confirmed dcn401_hubp.c exists in v6.11, v6.12,
  v6.13, v7.0
- [Phase 4] Found patch at https://lists.freedesktop.org/archives/amd-
  gfx/2026-March/140330.html - part of v2 DC patch series
- [Phase 4] Cover letter at https://lists.freedesktop.org/archives/amd-
  gfx/2026-March/140322.html - no NAKs or concerns
- [Phase 5] Traced caller chain: `dcn401_set_cursor_position()` ->
  `hubp401_cursor_set_position()`. Confirmed at lines 1177-1182 and
  1196-1202 that `pos_cpy.x_hotspot -= x_pos` (with negative x_pos)
  inflates x_hotspot beyond 255 in ODM/MPC combining scenarios
- [Phase 5] Verified x_hotspot inflation code exists in v6.11 and v6.12
  versions of dcn401_hwseq.c
- [Phase 6] DCN401 max_cursor_size=64, but x_hotspot is inflated *after*
  initial position setup in hwseq layer, so 64-pixel limit doesn't
  prevent the overflow
- [Phase 6] Function structure differs between v6.12 and v7.0 (cursor
  offload); backport needs minor adaptation for older trees
- [Phase 8] Failure mode: duplicate cursor visible on screen (MEDIUM
  severity, user-visible display bug)

The fix is a small, safe hardware workaround that fixes a real visual
bug triggered by ODM/MPC combining on AMD DCN401 hardware. It meets
stable criteria as a hardware workaround with minimal risk and clear
benefit.

**YES**

 drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c b/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
index c205500290ecd..806b9bd9a3fcf 100644
--- a/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/hubp/dcn401/dcn401_hubp.c
@@ -739,9 +739,8 @@ void hubp401_cursor_set_position(
 	int x_pos_viewport = 0;
 	int x_hot_viewport = 0;
 	uint32_t cur_en = pos->enable ? 1 : 0;
-
+	uint32_t x_hotspot_clamped = pos->x_hotspot;
 	hubp->curs_pos = *pos;
-
 	/* Recout is zero for pipes if the entire dst_rect is contained
 	 * within preceeding ODM slices.
 	 */
@@ -772,6 +771,8 @@ void hubp401_cursor_set_position(
 
 	ASSERT(param->h_scale_ratio.value);
 
+	if (x_hotspot_clamped > 0xFF)
+		x_hotspot_clamped = 0xFF;
 	if (param->h_scale_ratio.value)
 		dst_x_offset = dc_fixpt_floor(dc_fixpt_div(
 			dc_fixpt_from_int(dst_x_offset),
@@ -792,7 +793,7 @@ void hubp401_cursor_set_position(
 			CURSOR_Y_POSITION, pos->y);
 
 		REG_SET_2(CURSOR_HOT_SPOT, 0,
-			CURSOR_HOT_SPOT_X, pos->x_hotspot,
+			CURSOR_HOT_SPOT_X, x_hotspot_clamped,
 			CURSOR_HOT_SPOT_Y, pos->y_hotspot);
 
 		REG_SET(CURSOR_DST_OFFSET, 0,
-- 
2.53.0

