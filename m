Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E9262044C;
	Mon, 19 Oct 2026 14:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418680; cv=none; b=DoM2fho8g6d523cqO5jj6gdv8gRZHl0qvUefL4Qs9zubulWmjh9biIjPL0BSuJftyAQHz1WZ/u0tsftGItehpKpgBF8OHdbmSFGk3gMvwN0cuAxcW32wti57CdqCnkwt2BgJS0a9XC+gtxjJiGW3kiV5QbEi6w2jz/ay7x4nDSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418680; c=relaxed/simple;
	bh=B67A8eXe3+J+lFkKW1UCubxmG4KiUYkrRr4S1T6k8ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GUlypB3NU7A3NiAbZHRX/djOydaF2iohknFGeuPlxR3/qJD7ObTkVNxXWx0ofHM6qQF7ZpZ39dTmLAhK+WuKsQX5FIY7CMS390G48mo4PtmH6KtkbCL39foeh8bLRdIc22v+fVeOB9FCp5gc67i82xTmDQGuRa1Z2DlW47GqpIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvIz9x5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvIz9x5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083921F000C8;
	Mon, 19 Oct 2026 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418677;
	bh=tUxqjMydVOQ+CkV40AyW4K1j3ezjia8tYP77IbFRgrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvIz9x5wWkY21K1cIsh9sTE5c9AqjKn4B0QtYk9HoPbDJBvJwSvZIMbkB4U31LJu4
	 fF2XlJdESOFRy8ob5bSDpO7WuuRGupZYBjWJj2qtEHt9g84W4LDQr+PpsLzWVG7RRh
	 MpxHtbENMDw6MUiog8WzPORZ+wy5/31GwPMIw99a1MJ+xToTkpJaYUO9f94lMt57A6
	 PERRHuEwf1AguqZVtHsTCtEegOjpnlZjhysvEcC9SnTvLTRgfFFhdIZYrsBEOtOrRr
	 tA8Aep7Y5uJkXfgs1hyva+G7MDpbA86XkA1styCVdBVVHeaJ8/svw3x2ZpME/85imn
	 Uqr+P2kg6K8pw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Wang <kevinyang.wang@amd.com>,
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
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amd/pm: Validate Tonga PowerPlay state array bounds
Date: Mon, 19 Oct 2026 09:51:49 -0400
Message-ID: <20261019135441.1420968-418-sashal@kernel.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 1ac24df78c566d767a5ef05a1fe0ecc55bac248d ]

process_pptables_v1_0.c builds the Tonga state array pointer
from usStateArrayOffset before checking that the table buffer covers
the referenced data. A truncated PowerPlay table can therefore lead to
out-of-bounds reads while validating the state array.

Validate the fixed table size first, then check the state array offset
and entry range before dereferencing the state array.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the Tonga state-array OOB exists in this
6.18.53 tree, the patch is self-contained, and it applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/amd/pm] [Validate] [Add bounds checks before using the
Tonga PowerPlay state array pointer derived from `usStateArrayOffset`.]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Yang Wang &lt;kevinyang.wang@amd.com&gt; (author)
- Reviewed-by: Hawking Zhang &lt;Hawking.Zhang@amd.com&gt; (AMD GFX
  reviewer; mailing-list reply said the whole 5-patch series is
  Reviewed-by)
- Signed-off-by: Alex Deucher &lt;alexander.deucher@amd.com&gt; (amdgpu
  maintainer)
- No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable (absence
  expected)
- Ignore pipeline-added Upstream commit / Sasha Levin SOB

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `process_pptables_v1_0.c` forms `ATOM_Tonga_State_Array *` from
  `usStateArrayOffset` before proving the PowerPlay buffer covers that
  object.
- Symptom: truncated/malformed PowerPlay table → out-of-bounds reads
  while validating the state array.
- Root cause: pointer arithmetic first, checks after (and the checks
  never used `soft_pp_table_size`).
- Fix: check fixed table size, then offset, then entry span, then
  dereference.
- No affected-version list in the message.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. Explicit OOB hardening. Also tightens
`entry_index <= ucNumEntries` to `entry_index < ucNumEntries` (off-by-
one on the index check).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c`
  (+40 / −22)
- Functions: `check_powerplay_tables` split into `get_tonga_state_array`
  + thin wrapper; `get_number_of_powerplay_table_entries_v1_0`;
  `get_powerplay_table_entry_v1_0`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Hunk 1 (init validation): Before — compute `state_arrays = table +
  usStateArrayOffset` then assert revision/offset/size/`ucNumEntries`.
  After — require `soft_pp_table_size >= sizeof(*powerplay_table)`, then
  existing header checks, then `offset <= table_size -
  sizeof(*state_arrays)`, then dereference, then `struct_size(...) <=
  remaining`.
- Hunk 2 (`get_number_of_powerplay_table_entries_v1_0`): Before — same
  unvalidated pointer add, return `ucNumEntries`. After — shared helper;
  fail closed on invalid table.
- Hunk 3 (`get_powerplay_table_entry_v1_0`): Before — pointer add +
  offset/`ucNumEntries` checks after the add; `entry_index <=
  ucNumEntries`. After — helper first; `entry_index < ucNumEntries`.
- Paths: GPU powerplay init and power-state table walk (normal device
  bring-up), not a rare error-only path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: memory safety — buffer overflow / OOB read of firmware (and
  optionally sysfs-uploaded) table data.
- Mechanism: `usStateArrayOffset` and `ucNumEntries` were trusted. A
  truncated blob or huge offset reads past the ATOM table.
  `struct_size()` is overflow-safe for the entries span.
- Also logic: exclusive vs inclusive index check.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: size → header → offset → header of subtable → full
  entries span.
- Underflow: `table_size - sizeof(*state_arrays)` is safe because the
  first check is `table_size >= sizeof(*powerplay_table)`, and
  `ATOM_Tonga_POWERPLAYTABLE` is much larger than
  `ATOM_Tonga_State_Array` (header + two `UCHAR`s + flex array).
- Regression: valid VBIOS tables should still pass if `usStructureSize`
  is the full PowerPlay blob (ATOM `CU16(idx)` / `usStructureSize`).
  That is the same size the later Tonga/Vega subtable helpers use; a
  header-only size would reject every Tonga GPU and would not have
  landed.
- No public API / locking / data-structure change. Stale kernel-doc
  above `get_tonga_state_array` still mentions `check_powerplay_tables`
  (later comment-only fix 4986757d); no runtime impact.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy `check_powerplay_tables` body: `c82baa28184356` (yanyang1,
  2015-08-18), originally `tonga_processpptables.c`.
- File rename: `f8a4c11b0a33f9` (2016).
- Bug has been in-tree since PowerPlay v1 (~4.x era), so it is in this
  6.18 tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. N/A.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Same author/series (independent per-ASIC bounds work):
  - 1/5 `Validate pp_table header before reading size` (SWSMU
    `smu_sys_set_pp_table`)
  - 2/5 `Use uploaded size for legacy custom PPTable`
    (`pp_dpm_set_pp_table`)
  - **3/5 this commit**
  - 4/5 Vega hwmgr bounds
  - 5/5 legacy hwmgr offsets
- Follow-up (separate 2/3 series): `Validate Tonga PPTable subtable
  bounds` (~600 lines) for other subtables; later comment-align commit
  for this helper.
- This commit does not call `pp_entries_max()` (autosel parent helper).
  Standalone for the state-array OOB.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Yang Wang is an AMD PM contributor with a run of PPTable
bounds/UAF fixes. Hawking Zhang reviewed; Alex Deucher merged.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Uses existing `hwmgr->soft_pp_table_size` (set in
  `get_powerplay_table()` from ATOM) and kernel `struct_size`
  (`include/linux/overflow.h`). Both exist in v6.18.53.
- 1/5 is a different file (SWSMU). 2/5 improves custom-upload size
  accounting in `amd_powerplay.c` but is not required to compile or to
  bound VBIOS tables.
- Can apply standalone. Confirmed with `patch --dry-run` against
  `v6.18.53` file: clean.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 1ac24df78c566d767a5ef05a1fe0ecc55bac248d` → [PATCH 3/5] htt
  ps://patch.msgid.link/20260623034151.263746-3-kevinyang.wang@amd.com
- `b4 dig -a`: only v1 of this 5-patch series (no later rewrite of 3/5).
- Freedesktop: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/147288.html
- Hawking on 1/5 (series Ack): “Series is Reviewed-by: Hawking Zhang” —
  https://lists.freedesktop.org/archives/amd-gfx/2026-June/147299.html
- No NAK found. No Cc: stable in the submission.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` To/Cc: amd-gfx, Alex Deucher, Hawking Zhang, Kenneth
Feng. Maintainer merged.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Bug is described as truncated PowerPlay
table OOB. Trigger is firmware parse at init, or root write to
`pp_table` sysfs (documented in `amdgpu_pm.c`).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 5-patch OOB series plus a later Tonga subtable series. This
patch is the Tonga *state array* piece and is self-contained. Other
patches cover other table formats/subtables.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED — lore.kernel.org/stable returned HTTP 403. No
evidence this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `get_tonga_state_array` (new), `check_powerplay_tables`,
`get_number_of_powerplay_table_entries_v1_0`,
`get_powerplay_table_entry_v1_0`.

Step 5.2: TRACE CALLERS
Record:
- `check_powerplay_tables` ← `pp_tables_v1_0_initialize` ←
  `pptable_v1_0_funcs.pptable_init` ← SMU7 when `pp_table_version ==
  PP_TABLE_V1` (`smu7_init_function_pointers`).
- `get_number_of_powerplay_table_entries_v1_0` ←
  `smu7_get_number_of_powerplay_table_entries` ← `psm`
  `get_num_of_pp_table_entries`.
- `get_powerplay_table_entry_v1_0` ← `smu7_get_pp_table_entry_v1` ←
  `psm_init_power_state_table` loop `for (i = 0; i < table_entries;
  i++)`.
- Context: driver init / DPM bring-up, process context.

Step 5.3: TRACE CALLEES
Record: `le16_to_cpu`, `struct_size`, `PP_ASSERT_WITH_CODE` (warns and
runs `return -1` — real control flow, not a debug-only assert).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable on every boot of SMU7 PP_TABLE_V1 ASICs
(Tonga/Fiji/Polaris/VegaM class in this hwmgr). Also reachable if root
writes `/sys/class/drm/cardX/device/pp_table` (`S_IRUGO | S_IWUSR`),
which copies into `hardcode_pp_table` and calls `amd_powerplay_reset` →
re-init. Unprivileged users cannot write the sysfs node.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same unvalidated `table + le16_to_cpu(offset)` pattern in
Vega/legacy processpptables; same author fixed those in 4/5, 5/5, and
the later Tonga subtable patch.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: `v6.18.53-5049-g0f0bdc2b0dffb`, `VERSION=6 PATCHLEVEL=18
  SUBLEVEL=53`, branch `autosel`.
- `git merge-base --is-ancestor f29e53bc54611 v6.18.53` → **not in
  v6.18.53**.
- `v6.18.53:process_pptables_v1_0.c` still has the old
  `check_powerplay_tables` that adds `usStateArrayOffset` before any
  size check (lines 1116–1137).
- Bug introduced ~2015; present here.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected **clean apply**. Dry-run of this commit’s diff onto the
v6.18.53 copy of the file succeeded. Mainline context uses
`kzalloc_obj`; 6.18.53 uses `kzalloc(sizeof(...))` — that line is not
part of the hunks.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: v6.18.53 does **not** contain 1/5, 2/5, this commit, 4/5, or
5/5. No earlier Tonga state-array bounds helper. Follow-up subtable
helpers (`tonga_pp_table_has_space`) are only on the autosel branch
after later candidates — not in v6.18.53.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drm/amd/pm powerplay] [IMPORTANT — widely used AMD GPU DPM for
Tonga/Fiji/Polaris-era cards, not core mm/net, but real hardware in the
field]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained; this is targeted firmware-table hardening,
not a refactor of a brand-new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific: amdgpu SMU7 with PowerPlay table v1
(Tonga/Fiji/Polaris family). Config `CONFIG_DRM_AMDGPU`.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Always parsed at device init from VBIOS/ATOM
  (`smu_atom_get_data_table` → `soft_pp_table_size = usStructureSize`).
- Healthy firmware: no behavior change.
- Truncated/corrupt VBIOS or crafted table: OOB read.
- Sysfs `pp_table` store is root-only. On v6.18.53, short uploads
  `memcpy` into a buffer still sized as the original table
  (`pp_dpm_set_pp_table`); 2/5 would make `soft_pp_table_size` match the
  upload. This commit still stops offsets that run past
  `soft_pp_table_size`.
- Unprivileged users cannot trigger via sysfs.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Kernel OOB read → KASAN/oops, possible info leak from adjacent
BIOS/kernel memory if values are consumed. Severity: **HIGH** (memory
safety). Not a confirmed remote unprivileged exploit.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: HIGH for Tonga/Polaris users with bad/truncated firmware or
  custom PP tables; fail closed instead of reading off the end of the
  ATOM blob.
- Risk: LOW (~40 lines, local helper, existing `PP_ASSERT_WITH_CODE`
  style).
- Ratio: favorable. Residual gap: other subtables still unchecked until
  the large follow-up; that is not a reason to skip this contained
  state-array fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real OOB read: pointer from firmware offset used before buffer
  coverage is proven (code from 2015, present in 6.18.53).
- Small, obviously correct, overflow-safe `struct_size` check.
- Reviewed by Hawking Zhang (series), merged by Alex Deucher.
- Applies cleanly to this tree; no missing types/helpers.
- Shared helper also closes the same hole in entry-count and entry-fetch
  paths.
- Fail closed: init returns error instead of walking garbage.

AGAINST:
- No crash report / syzbot / Fixes: tag.
- Part of 3/5; full PPTable hardening needs later larger patches.
- Sysfs path is root-only; VBIOS path needs a truncated/malformed table.
- Incomplete vs later 600-line subtable patch.

UNRESOLVED:
- Stable list discussion (lore 403).
- No production crash log attached to the patch.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — order of checks is sound;
   maintainer review; in mainline.
2. Fixes a real bug that affects users? **PASS** — OOB read of PowerPlay
   state array from truncated/malformed tables on a live init path.
3. Important issue? **PASS** — kernel OOB read / crash / info-leak
   class; HIGH, not a style cleanup.
4. Small and contained? **PASS** — one file, +40/−22.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — bug present in v6.18.53; dry-
   run apply clean.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs exception. Ordinary memory-safety
bugfix.

Step 9.4: MAKE YOUR DECISION
This should be backported to **this** 6.18.y tree. The buggy pointer
construction is in v6.18.53, the fix is small and independent of the
rest of the 5-patch series, and it prevents out-of-bounds reads during
amdgpu PowerPlay v1 init.

===============================================================
What the commit solves for this tree
===============================================================

On 6.18.53, `check_powerplay_tables()`,
`get_number_of_powerplay_table_entries_v1_0()`, and
`get_powerplay_table_entry_v1_0()` all do:

`state_arrays = (ATOM_Tonga_State_Array *)(powerplay_table +
le16_to_cpu(usStateArrayOffset))`

and then read `ucNumEntries` / `entries[i]`. `soft_pp_table_size` is
already known from ATOM `usStructureSize` but was unused. A truncated
PowerPlay table or an offset past the blob is an out-of-bounds kernel
read during GPU init (Polaris-class cards are still common). The patch
adds the missing coverage checks and an exclusive entry-index test. It
does not add APIs. 1/5 and 2/5 are related hardening but not
compile/runtime prerequisites for this file.

Risk vs benefit: low risk of regressing good firmware; high value if the
table is short or the offset is wrong.

Verification:
- [Phase 1] Tags: author Yang Wang; Reviewed-by Hawking Zhang; SOB Alex
  Deucher; no Fixes/syzbot/stable Cc
- [Phase 2] Diff: +40/−22 in `process_pptables_v1_0.c`; helper + three
  call sites; OOB bounds + off-by-one index
- [Phase 2] `PP_ASSERT_WITH_CODE` in `pp_debug.h` really `pr_warn` +
  executes `return -1`
- [Phase 3] Blame: `c82baa28184356` (2015-08-18) introduced the
  unvalidated pointer add
- [Phase 3] No Fixes: tag
- [Phase 3] Series 1/5 and 2/5 touch other files; this commit does not
  use `pp_entries_max()`
- [Phase 3] `struct_size` in `include/linux/overflow.h`;
  `soft_pp_table_size` set in `get_powerplay_table()`
- [Phase 4] `b4 dig -c 1ac24df78c566d767a5ef05a1fe0ecc55bac248d` → PATCH
  3/5 msgid 20260623034151.263746-3
- [Phase 4] `b4 dig -a`: v1 only for this series
- [Phase 4] `b4 dig -w`: amd-gfx, Deucher, Hawking, Kenneth Feng
- [Phase 4] Hawking: “Series is Reviewed-by”
  https://lists.freedesktop.org/archives/amd-gfx/2026-June/147299.html
- [Phase 4] Patch body: https://lists.freedesktop.org/archives/amd-
  gfx/2026-June/147288.html
- [Phase 5] Callers: `pp_tables_v1_0_initialize`,
  `smu7_get_number_of_powerplay_table_entries`,
  `smu7_get_pp_table_entry_v1` ← `psm_init_power_state_table`
- [Phase 5] `pptable_v1_0_funcs` selected for `PP_TABLE_V1` in
  `smu7_init_function_pointers`
- [Phase 5] sysfs `pp_table` is `S_IRUGO | S_IWUSR`
  (`AMDGPU_DEVICE_ATTR_RW`)
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb; Makefile
  6.18.53
- [Phase 6] commit **not** ancestor of v6.18.53; buggy function present
  at v6.18.53:1116
- [Phase 6] `patch --dry-run` of this diff onto v6.18.53 file: success
- [Phase 6] ATOM size is `usStructureSize` via
  `amdgpu_atom_parse_data_header` `*size = CU16(idx)`
- [Phase 8] Failure mode: OOB read on truncated PP table during amdgpu
  init; HIGH
- UNVERIFIED: lore.kernel.org/stable search (HTTP 403); no public crash
  repro attached to the patch

**YES**

 .../powerplay/hwmgr/process_pptables_v1_0.c   | 62 ++++++++++++-------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
index 6cfef1b295abb..94c1e2c103703 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -1113,15 +1113,17 @@ static int init_thermal_controller(
  * @powerplay_table: Pointer to the PowerPlay Table.
  * Exception:  2 if the powerplay table is incorrect.
  */
-static int check_powerplay_tables(
-		struct pp_hwmgr *hwmgr,
-		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table
-		)
+static int get_tonga_state_array(struct pp_hwmgr *hwmgr,
+	const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+	const ATOM_Tonga_State_Array **state_array)
 {
 	const ATOM_Tonga_State_Array *state_arrays;
+	u16 state_array_offset;
+	size_t state_array_size;
+	size_t table_size = hwmgr->soft_pp_table_size;
 
-	state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)powerplay_table) +
-		le16_to_cpu(powerplay_table->usStateArrayOffset));
+	PP_ASSERT_WITH_CODE((table_size >= sizeof(*powerplay_table)),
+			    "Invalid PowerPlay Table!", return -1);
 
 	PP_ASSERT_WITH_CODE((ATOM_Tonga_TABLE_REVISION_TONGA <=
 		powerplay_table->sHeader.ucTableFormatRevision),
@@ -1130,12 +1132,34 @@ static int check_powerplay_tables(
 		"State table is not set!", return -1);
 	PP_ASSERT_WITH_CODE((0 < powerplay_table->sHeader.usStructureSize),
 		"Invalid PowerPlay Table!", return -1);
+
+	state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+	PP_ASSERT_WITH_CODE((state_array_offset <=
+			     table_size - sizeof(*state_arrays)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)powerplay_table) +
+		state_array_offset);
 	PP_ASSERT_WITH_CODE((0 < state_arrays->ucNumEntries),
 		"Invalid PowerPlay Table!", return -1);
 
+	state_array_size = struct_size(state_arrays, entries, state_arrays->ucNumEntries);
+	PP_ASSERT_WITH_CODE((state_array_size <= table_size - state_array_offset),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*state_array = state_arrays;
+
 	return 0;
 }
 
+static int check_powerplay_tables(struct pp_hwmgr *hwmgr,
+	const ATOM_Tonga_POWERPLAYTABLE *powerplay_table)
+{
+	const ATOM_Tonga_State_Array *state_arrays;
+
+	return get_tonga_state_array(hwmgr, powerplay_table, &state_arrays);
+}
+
 static int pp_tables_v1_0_initialize(struct pp_hwmgr *hwmgr)
 {
 	int result = 0;
@@ -1239,17 +1263,16 @@ const struct pp_table_func pptable_v1_0_funcs = {
 
 int get_number_of_powerplay_table_entries_v1_0(struct pp_hwmgr *hwmgr)
 {
-	ATOM_Tonga_State_Array const *state_arrays;
+	const ATOM_Tonga_State_Array *state_arrays;
 	const ATOM_Tonga_POWERPLAYTABLE *pp_table = get_powerplay_table(hwmgr);
+	int result;
 
 	PP_ASSERT_WITH_CODE((NULL != pp_table),
 			"Missing PowerPlay Table!", return -1);
-	PP_ASSERT_WITH_CODE((pp_table->sHeader.ucTableFormatRevision >=
-			ATOM_Tonga_TABLE_REVISION_TONGA),
-			"Incorrect PowerPlay table revision!", return -1);
 
-	state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)pp_table) +
-			le16_to_cpu(pp_table->usStateArrayOffset));
+	result = get_tonga_state_array(hwmgr, pp_table, &state_arrays);
+	PP_ASSERT_WITH_CODE((result == 0),
+			    "Invalid PowerPlay Table State Array.", return result);
 
 	return (uint32_t)(state_arrays->ucNumEntries);
 }
@@ -1380,15 +1403,11 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
 	if (pp_table->sHeader.ucTableFormatRevision >=
 			ATOM_Tonga_TABLE_REVISION_TONGA) {
-		state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)pp_table) +
-				le16_to_cpu(pp_table->usStateArrayOffset));
-
-		PP_ASSERT_WITH_CODE((0 < pp_table->usStateArrayOffset),
-				"Invalid PowerPlay Table State Array Offset.", return -1);
-		PP_ASSERT_WITH_CODE((0 < state_arrays->ucNumEntries),
-				"Invalid PowerPlay Table State Array.", return -1);
-		PP_ASSERT_WITH_CODE((entry_index <= state_arrays->ucNumEntries),
-				"Invalid PowerPlay Table State Array Entry.", return -1);
+		result = get_tonga_state_array(hwmgr, pp_table, &state_arrays);
+		PP_ASSERT_WITH_CODE((result == 0),
+				    "Invalid PowerPlay Table State Array.", return result);
+		PP_ASSERT_WITH_CODE((entry_index < state_arrays->ucNumEntries),
+				    "Invalid PowerPlay Table State Array Entry.", return -1);
 
 		state_entry = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
 						ATOM_Tonga_State, entries,
@@ -1414,4 +1433,3 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
 	return result;
 }
-
-- 
2.53.0

