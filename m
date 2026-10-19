Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5508538742;
	Mon, 19 Oct 2026 14:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418672; cv=none; b=TDBxirpgMK/08r/VvYL2G+I2gqfA6XW/C/SrUw3i+unTap43+K41tQGMw9xcEfMTPUa62Yje1HE9gGMPhXUewwO05xurfKa+aM8PQC4dy+gzdGA5DpN5g1oLFGiw00Z/r7B6Sz8VFi3zngA4nshBCGhpZF1Z5F+8cNClp1mkoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418672; c=relaxed/simple;
	bh=EjxSlmTy8JFvikV8qJgUd9kIyeYFf0PdCJaInFSd+qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hm4uMTn/yVLFA4H8JJBl2yzOdp26wVK/DTkzxDOmF7mezIUl/MO3W7i0Mqd47LNIDv6193+La4EA4SZjoNMVK1WJWKa8Unpbz/Z842uIXOBSFP+oBpL5kFXlLdayvdfoWMFD3ZLDc9Wi95NQ1lHE7l0JfCp4avcud34xZN9mB1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkFPUXSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkFPUXSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A20C1F000C7;
	Mon, 19 Oct 2026 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418669;
	bh=VVOn2L6cDpT/VKFx7pY3LlwVkiNm3fP6OW1haLqz78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkFPUXSiTje2U3lObNxX6lsKRjuRrpl7glnojo4BwGWYG61hmQ7yQL6F+CpbRY5nv
	 LNZpEigxLpCRwwTCtJTlP3JXXD+x8Xa9TY6n7h5dlrU2KJPqsJHobfu9bcvXdKMb26
	 vImQt6WO6krl17UqS8ZTgRpDlu6or3nW4V5CLWUmZncqe4N1eOnt3rXIaVvpyJAxe8
	 vjAb5nmMmkLDoSqiz/kB0quSItaBJJ9rcnEcVprUIGB0i1bZaoFUXn5NPhFPcKriKx
	 jqDijUyJJ5LrL5OTq0o9ya1BR/ijrHHRsePcC9Q5zmyE9jVae6fi+T+1t3rtwMcdPU
	 HnK7nudsmSfrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amd/pm: Validate OD DPM triples before mutating tables
Date: Mon, 19 Oct 2026 09:51:44 -0400
Message-ID: <20261019135441.1420968-413-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit b390cb9d776039fc4f0be13b2649299079227d12 ]

vega10_odn_edit_dpm_table() and smu7_odn_edit_dpm_table() could mutate
the live ODN table for valid triples, then return 0 after detecting a
truncated buffer or out-of-range index. Validate all (index, clock,
voltage) triples first and return -EINVAL on any failure; only then
apply updates.

v2: Use distinct message for different error case, removed unused
input_level from validation loop (Lijo)

v3: Reject negative level indices, input[] is long but was compared only
against unsigned table bounds, so negative values could pass and truncate
when assigned to uint32_t input_level.

Set DPMTABLE_OD_UPDATE_SCLK/MCLK only after validation passes,
so a failed sysfs write does not leave need_update_dpm_table set for a
later commit.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The buggy SMU7/Vega10 OverDrive edit path
is present on that series, and the patch applies cleanly.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[drm/amd/pm] [Validate] [reject invalid OD DPM (index, clock,
voltage) triples before writing live tables]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `[Upstream commit b390cb9d776039fc4f0be13b2649299079227d12]` —
  pipeline marker, ignored
- No `Fixes:` tag (expected)
- No `Reported-by:` / `Tested-by:` / `Link:` / `Cc: stable`
- `Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>`
- `Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>`
- `Signed-off-by: Asad Kamal <asad.kamal@amd.com>` (author)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- `Signed-off-by: Sasha Levin` — pipeline marker, ignored

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `vega10_odn_edit_dpm_table()` and `smu7_odn_edit_dpm_table()`
  apply valid triples immediately, then on a later truncated buffer or
  out-of-range index they `return 0`.
- **Symptom:** a failed `pp_od_clk_voltage` write can still change live
  clock/voltage tables, report success, and (Vega10) leave
  `need_update_dpm_table` set so a later `echo c` commits the partial
  change.
- **v3 extra:** `input[]` is `long`; comparing only against unsigned
  table size lets negative indices through, then assignment to `uint32_t
  input_level` truncates and indexes off the array.
- **Version info:** none in the message. Introducing code is from 2018
  (v4.17/v4.18).
- **Root cause:** validate-and-mutate in one loop; wrong error return;
  missing signed-index check; Vega10 dirty-flag set before validation.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit correctness/safety fix (partial update +
false success + OOB index). Not cleanup-only.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `smu7_hwmgr.c`: +20/−14 in `smu7_odn_edit_dpm_table()`
- `vega10_hwmgr.c`: +23/−14 in `vega10_odn_edit_dpm_table()`
- Total: **43 insertions, 28 deletions**, two files, single-function
  surgical change per file.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (same pattern in both):
- **Before:** one loop: on truncated/out-of-range input, print and
  `return 0` after earlier triples already wrote `entries[]` /
  `dpm_levels[]`. Invalid clock/voltage still returned `-EINVAL` but
  only after mutating that iteration’s predecessors. Vega10 ORs
  `DPMTABLE_OD_UPDATE_SCLK/MCLK` before the loop.
- **After:** first loop validates every triple (`i+3 > size`, `input[i]
  < 0 || index >= count`, clock/voltage via existing checkers) and
  returns `-EINVAL` with no writes. Only then set dirty flags (Vega10)
  and apply updates in a second loop.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** memory safety (OOB write) + logic/correctness (partial
  live-table mutation, false success, dirty-flag leak).
- **Mechanism:** `long` index vs `uint32_t` bound: on 64-bit, `-1 >=
  count` is false, then `input_level = (uint32_t)-1` indexes
  `entries[0xFFFFFFFF]`. Arrays are 8 entries (`MAX_REGULAR_DPM_NUMBER`
  / `phm_odn_clock_levels.entries[8]`). Truncated writes previously
  returned 0 so `amdgpu_set_pp_od_clk_voltage()` treated them as success
  (`return count`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct two-pass validate-then-commit. Checker
polarity preserved (`smu7_check_clk_voltage_valid` /
`vega10_check_clk_voltage_valid` return true when valid; new code uses
`if (!check())`). No API change. Regression risk is low: invalid writes
now fail instead of succeeding-with-partial-state; valid writes still
apply the same stores. Slight behavior change for tools that treated
truncated writes as success is the intended fix.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- SMU7 loop: `5e4d4fbea5573` (“drm/amd/pp: Implement edit_dpm_table on
  smu7”, 2018-02-19) — first in **v4.17-rc1**.
- Vega10 loop: `c5a4484941be5` (“drm/amd/pp: Add OVERDRIVE support on
  Vega10”, 2018-05-15) — first in **v4.18-rc1**.
- Both ancestors of v6.18.53. Bug has been in this series since the
  branch point.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introducing commits identified by blame; both
present in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (on v6.18.53, those two files): recent powerplay work is
unrelated (voltage lookup bounds, Hawaii SCLK cap, etc.). Related:
`d27252b5706e5` “amdgpu/pm: prevent array underflow in
vega20_odn_edit_dpm_table()” (2022) — **already in v6.18.53**. Same
class of sysfs-fed negative index. Standalone patch, not `X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Asad Kamal is an AMD contributor; not the tree maintainer. Alex
Deucher applied it. Lijo Lazar / Hawking Zhang reviewed (AMD PM). No
other OD-triple commits by this author on v6.18.53 in this path.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Uses existing helpers and structs. No new functions. `git apply
--check` of this diff onto v6.18.53 copies of both files: **clean**.
Standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore/msgid:
  https://patch.msgid.link/20260604091915.1012329-1-asad.kamal@amd.com
- Revisions: v1 (2026-05-29) → v2 (2026-06-03) → **v3 applied**
  (2026-06-04)
- v1 Lijo: distinct error strings; unused `input_level` in the validate
  loop (style, addressed)
- v2 Lijo: `Reviewed-by`
- v3 Hawking: `Reviewed-by`
- No NAK. v3 added the negative-index check (the OOB hole). No reviewer
  `Cc: stable` in the saved threads.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc: amd-gfx, Lijo Lazar, Hawking Zhang, Le Ma, Shiwu Zhang,
Alex Deucher, Kevin Yang Wang. Right maintainers; two AMD R-b plus
maintainer SOB.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, syzbot, or bugzilla. Bug is described from
code inspection. Direct lore HTTP search was bot-blocked; discussion
recovered via `b4`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone three-revision single patch, not a series. Later
autosel commit `42ba4b5ff5278` (“validate vega10 profile mode inputs”)
is a different function, not a prerequisite.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search was bot-walled. **UNVERIFIED**
whether stable@ already discussed this; no in-tree evidence it was
rejected.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `smu7_odn_edit_dpm_table()`, `vega10_odn_edit_dpm_table()`.
Helpers used unchanged: `smu7_check_clk_voltage_valid()`,
`vega10_check_clk_voltage_valid()`, `vega10_odn_update_soc_table()`.

**Step 5.2: TRACE CALLERS**
Record:
- Registered as `.odn_edit_dpm_table` in each hwmgr func table
- `pp_odn_edit_dpm_table()` in `amd_powerplay.c`
- `amdgpu_dpm_odn_edit_dpm_table()` under `adev->pm.mutex`
- `amdgpu_set_pp_od_clk_voltage()` sysfs store for `pp_od_clk_voltage`

**Step 5.3: TRACE CALLEES**
Record: table writes, clock/voltage range checks, Vega10
`vega10_odn_update_soc_table()`. No alloc/lock added.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `echo "s 0 900 820" > pp_od_clk_voltage` (documented
in `amdgpu_pm.c`). Sysfs is `S_IRUGO | S_IWUSR` (root write). Path
requires `hwmgr->od_enabled`, set only if `PP_OVERDRIVE_MASK` (0x4000).
Default `amdgpu_pp_feature_mask = 0xfff7bfff` **clears** that bit; OD is
opt-in (`ppfeaturemask`), and enabling it taints the kernel. Still a
real sysfs path for overclockers.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Vega20 already rejects bad indices (`d27252b5706e5`, in this
tree). Newer swsmu ppt files have their own OD parsers. This patch only
covers the two powerplay implementations that still mutate-then-`return
0`.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, on **v6.18.53**. Blame on that tag still has `return 0` on
truncated/out-of-range input and Vega10 dirty flags before the loop.
Candidate `25b12527acd6c` is **not** an ancestor of v6.18.53 (`merge-
base --is-ancestor` exit 1). Introduced v4.17/v4.18.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** (`git apply --check` of this diff on v6.18.53
copies of both files, exit 0). Surrounding functions match the hunk
context.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Vega20 underflow fix is present. No equivalent two-pass
validation for SMU7/Vega10 on v6.18.53.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drm/amd/pm powerplay** (SMU7 / Vega10 OverDrive).
**IMPORTANT** for those GPUs, not core mm/scheduler. Polaris/Vega-class
AMD GPUs still in production use.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Files still receive bounds-check and PM fixes on 6.18.y. OD edit
logic itself has been stable since 2018.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific, config-specific: AMD SMU7 (CI/VI/Polaris) and
Vega10 users with OverDrive enabled who write `pp_od_clk_voltage`.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Malformed or truncated sysfs payload (e.g. incomplete triple,
negative level, mix of good then bad triples). Common for tools/scripts.
Unprivileged users cannot write the attr (root/owner only). Not a
default-boot path; OD is off unless `ppfeaturemask` sets bit 14.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Negative index → **OOB write** into 8-entry arrays → memory
  corruption. **HIGH** (gated by OD + root).
- Partial table mutation + `return 0` → userspace thinks commit-ready
  state is good; later `c` can program inconsistent clocks/voltages.
  **HIGH** for hardware (instability / out-of-spec clocks), **MEDIUM**
  as a kernel crash.
- Vega10 dirty-flag leak: failed write still causes a later commit to
  push SCLK/MCLK. **MEDIUM–HIGH**.
Overall: **HIGH**, not a panic-on-boot, but real memory safety + live PM
table corruption.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium–high for OD users (OOB + wrong clocks); low for
  default configs.
- **Risk:** very low (small, local, validate-then-write, maintainer-
  reviewed, applies cleanly).
- **Ratio:** favor backport. Same class as the Vega20 underflow already
  on this tree.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB write (negative `long` index → `uint32_t` wrap)
- Partial mutation of live DPM tables with success return
- Vega10 can commit stale/partial OD state after a failed write
- Small, obviously correct, two-pass fix
- Reviewed by Lijo Lazar and Hawking Zhang; applied by Alex Deucher
- Applies cleanly to v6.18.53; no missing structs/helpers
- Bug present since v4.17/v4.18
- Precedent: Vega20 OD index underflow already in this tree

AGAINST:
- OverDrive off by default
- Sysfs store is root-only
- No syzbot/CVE/user crash report
- No `Fixes:` / `Cc: stable` (not a negative per the review rules)

UNRESOLVED:
- Whether stable@ already discussed this (lore stable search blocked)
- Unprivileged trigger only if something remaps sysfs mode (not
  verified; default is `S_IWUSR`)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two-pass validation; R-b
   from AMD PM; polarity of existing checkers verified in tree
2. Fixes a real bug that affects users? **PASS** — OOB + false-success
   partial OD updates via documented sysfs
3. Important issue? **PASS** — OOB write and inconsistent GPU
   DPM/voltage tables (HIGH, gated)
4. Small and contained? **PASS** — ~70 line-churn, two functions
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean on v6.18.53

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID / quirk / DT / build / doc fix). Qualifies
as a normal bugfix.

**Step 9.4: MAKE YOUR DECISION**
This belongs on 6.18.53. The local tree still has the 2018 validate-
while-mutating loops. The patch closes an OOB write and stops failed
OverDrive sysfs writes from leaving live SCLK/MCLK tables and Vega10
update flags half-applied. It is small, reviewed, and applies without
prerequisites.

### What the commit solves for this tree
On 6.18.53, writing `pp_od_clk_voltage` can (1) store valid triples,
then succeed on a truncated/out-of-range rest of the buffer; (2) turn a
negative level into a huge `uint32_t` index and write off the 8-entry
ODN arrays; (3) on Vega10, mark DPM tables dirty even when the write
fails, so a later commit programs incomplete settings.

### Stable rules / risk
Meets all six criteria. Risk is a behavior change only for previously
accepted-but-invalid writes. Benefit is memory safety and not
programming a GPU with a half-edited OD table.

### Concerns
OD is opt-in and the node is root-writable, so this is not a default-
boot crash. That does not make the OOB or live-table corruption unworthy
of 6.18.y; the analogous Vega20 underflow is already here.

Verification:
- [Phase 1] Tags: R-b Lijo Lazar, R-b Hawking Zhang, SOB Alex Deucher;
  no Fixes/Reported-by
- [Phase 2] Diff: two-pass validate-then-mutate in
  `smu7_odn_edit_dpm_table` / `vega10_odn_edit_dpm_table`; `-EINVAL`
  instead of `return 0`; Vega10 dirty flags moved after validation;
  `input[i] < 0` added
- [Phase 2] Checkers return true when valid (`smu7_hwmgr.c` ~5582–5616)
- [Phase 3] Blame v6.18.53: `5e4d4fbea5573` (v4.17-rc1), `c5a4484941be5`
  (v4.18-rc1); both ancestors of v6.18.53
- [Phase 3] `git merge-base --is-ancestor 25b12527acd6c v6.18.53` → not
  present; `d27252b5706e5` Vega20 underflow **is** present
- [Phase 4] `b4 dig -c b390cb9d7760`: v1–v3; v3 msgid
  20260604091915.1012329-1; Lijo then Hawking R-b; no NAK
- [Phase 4] UNVERIFIED: stable@ thread (HTTP 403/bot wall)
- [Phase 5] Call chain: sysfs `amdgpu_set_pp_od_clk_voltage` →
  `amdgpu_dpm_odn_edit_dpm_table` → hwmgr; attr `S_IRUGO|S_IWUSR`; OD
  mask 0x4000 cleared in default `0xfff7bfff`
- [Phase 5] Arrays: `entries[8]` / `MAX_REGULAR_DPM_NUMBER 8`
- [Phase 6] `git describe HEAD` / Makefile: **6.18.53**; apply-check on
  v6.18.53 file copies: exit 0
- [Phase 8] Failure: OOB write + partial OD table / dirty-flag leak;
  severity HIGH (gated)
- UNVERIFIED: whether udev/distro remaps `pp_od_clk_voltage` to non-root
  write

**YES**

 .../drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   | 34 ++++++++++-------
 .../drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 37 ++++++++++++-------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index ba953654a0206..cf008ed409552 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5661,23 +5661,29 @@ static int smu7_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 	}
 
 	for (i = 0; i < size; i += 3) {
-		if (i + 3 > size || input[i] >= podn_dpm_table_in_backend->num_of_pl) {
-			pr_info("invalid clock voltage input \n");
-			return 0;
+		if (i + 3 > size) {
+			pr_info("truncated clock/voltage input\n");
+			return -EINVAL;
 		}
-		input_level = input[i];
-		input_clk = input[i+1] * 100;
-		input_vol = input[i+2];
-
-		if (smu7_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol)) {
-			podn_dpm_table_in_backend->entries[input_level].clock = input_clk;
-			podn_vdd_dep_in_backend->entries[input_level].clk = input_clk;
-			podn_dpm_table_in_backend->entries[input_level].vddc = input_vol;
-			podn_vdd_dep_in_backend->entries[input_level].vddc = input_vol;
-			podn_vdd_dep_in_backend->entries[input_level].vddgfx = input_vol;
-		} else {
+		if (input[i] < 0 || input[i] >= podn_dpm_table_in_backend->num_of_pl) {
+			pr_info("invalid clock/voltage level\n");
 			return -EINVAL;
 		}
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		if (!smu7_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol))
+			return -EINVAL;
+	}
+
+	for (i = 0; i < size; i += 3) {
+		input_level = input[i];
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		podn_dpm_table_in_backend->entries[input_level].clock = input_clk;
+		podn_vdd_dep_in_backend->entries[input_level].clk = input_clk;
+		podn_dpm_table_in_backend->entries[input_level].vddc = input_vol;
+		podn_vdd_dep_in_backend->entries[input_level].vddc = input_vol;
+		podn_vdd_dep_in_backend->entries[input_level].vddgfx = input_vol;
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index b3fed2a478aab..d6aaba0b3613d 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5645,11 +5645,9 @@ static int vega10_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 	if (PP_OD_EDIT_SCLK_VDDC_TABLE == type) {
 		dpm_table = &data->dpm_table.gfx_table;
 		podn_vdd_dep_table = &data->odn_dpm_table.vdd_dep_on_sclk;
-		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_SCLK;
 	} else if (PP_OD_EDIT_MCLK_VDDC_TABLE == type) {
 		dpm_table = &data->dpm_table.mem_table;
 		podn_vdd_dep_table = &data->odn_dpm_table.vdd_dep_on_mclk;
-		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_MCLK;
 	} else if (PP_OD_RESTORE_DEFAULT_TABLE == type) {
 		memcpy(&(data->dpm_table), &(data->golden_dpm_table), sizeof(struct vega10_dpm_table));
 		vega10_odn_initial_default_setting(hwmgr);
@@ -5667,21 +5665,32 @@ static int vega10_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 	}
 
 	for (i = 0; i < size; i += 3) {
-		if (i + 3 > size || input[i] >= podn_vdd_dep_table->count) {
-			pr_info("invalid clock voltage input\n");
-			return 0;
+		if (i + 3 > size) {
+			pr_info("truncated clock/voltage input\n");
+			return -EINVAL;
 		}
-		input_level = input[i];
-		input_clk = input[i+1] * 100;
-		input_vol = input[i+2];
-
-		if (vega10_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol)) {
-			dpm_table->dpm_levels[input_level].value = input_clk;
-			podn_vdd_dep_table->entries[input_level].clk = input_clk;
-			podn_vdd_dep_table->entries[input_level].vddc = input_vol;
-		} else {
+		if (input[i] < 0 || input[i] >= podn_vdd_dep_table->count) {
+			pr_info("invalid clock/voltage level\n");
 			return -EINVAL;
 		}
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		if (!vega10_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol))
+			return -EINVAL;
+	}
+
+	if (type == PP_OD_EDIT_SCLK_VDDC_TABLE)
+		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_SCLK;
+	else
+		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_MCLK;
+
+	for (i = 0; i < size; i += 3) {
+		input_level = input[i];
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		dpm_table->dpm_levels[input_level].value = input_clk;
+		podn_vdd_dep_table->entries[input_level].clk = input_clk;
+		podn_vdd_dep_table->entries[input_level].vddc = input_vol;
 	}
 	vega10_odn_update_soc_table(hwmgr, type);
 	return 0;
-- 
2.53.0

