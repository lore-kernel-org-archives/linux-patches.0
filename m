Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796354F6486;
	Mon, 19 Oct 2026 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418159; cv=none; b=CiX/fGppAIYs8MT7tIdmgcKlKBgIJPVpfYk86X+Rqm0xAziG/VCPnWV4iETwo7BLELuVyG0OvzOvyPkLq1R8JTMCpuw+qwqDz0ddCXR758VtFW4A4SOY+chW3oZrQ7eFmn47Pp7igiXin+IcqzSjYsWmU7UDiHo/7Uzs5D/y6A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418159; c=relaxed/simple;
	bh=8BCLxkVuRckgOZWKoJKVWJrHtt++qlhyYCKC5zRM2tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvYijWchTt0EJlkBRSUhsXPE8wW74X5qQavDLAwrn84MF+SHN1F5oC/yGqqdlrRilQ5Mww+0dxL2Yr13AV3bkSg2zUkyS5X0L3Qm3W+6yyo41Er8qiLAUyG2HaYnhwX8q62PEST72Rr/VZZjYBCxKh1GeScG/aETtC6L8XHRXbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATqwBFov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATqwBFov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32DA1F000C5;
	Mon, 19 Oct 2026 13:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418155;
	bh=PMW73po85qg2HoFGGpFYVnNQNBoJVsXQKJEDUxpLCik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATqwBFovNX+yaSjvNTMfDdwwtS/icHX32/HX+b+wcSCtVQ6Z0u0koaw6gyPGX/99T
	 v+aY+NZ9LRn7UX3Z6TGlC37jhXYOZ38ptjxjrAMR0xpgQuhHMPrJ8YCpwEgKiOk7ZL
	 5zpJ6VNgoJ981KwlynRcLIVCzai41Vx58300W3V0wLZqnD13ySrf+YgZYoaY1WkC+O
	 dA30a4P9hP+x8R+5Ub8nM8fH+Rsea1x7DX4FYbrE8Db93+o7P8oKAsIgS+DuVpJ1AY
	 Fg7YvIqiwNmuIZoXwRlQueJyPU0pn15KeYaxie71MRN27ZLucBq0U9fnkb3K6kXK5E
	 LiWirtxbgUhPw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amd/pm: Validate legacy hwmgr PP table offsets
Date: Mon, 19 Oct 2026 09:45:42 -0400
Message-ID: <20261019135441.1420968-51-sashal@kernel.org>
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

[ Upstream commit 0ceb6bc43e62f0e73b282c9de8f4bc4d5498f281 ]

processpptables.c walks several variable-length PPLIB tables by
using offsets from the VBIOS PowerPlay table. Some paths dereference
extended headers, state arrays, clock arrays, non-clock arrays, or VCE
records before checking that the referenced data is inside the table
buffer.

Add local bounds helpers and validate the relevant offsets and entry
sizes before dereferencing them. This prevents truncated or malformed
legacy PowerPlay tables from driving out-of-bounds reads during hwmgr
initialization and table entry lookup.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Hawking’s series review is on file, and the v6.18.53 parser still has
the unfixed offset walks. I’ll write up the nine-phase verdict from that
evidence.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amd/pm] [Validate] [bounds-check legacy hwmgr PowerPlay
table offsets before dereference]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Yang Wang <kevinyang.wang@amd.com>` (author, AMD)
- `Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>` (AMD reviewer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- No `Fixes:` tag (expected)
- No `Reported-by:` / syzbot / `Cc: stable`
- No `Link:` in the committed message
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  0ceb6bc43e62...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `processpptables.c` walks variable-length PPLIB tables using
  VBIOS offsets and dereferences extended headers, state/clock/non-clock
  arrays, and VCE records without confirming they lie inside the table
  buffer.
- **Symptom:** out-of-bounds kernel reads during hwmgr init and table
  entry lookup on truncated or malformed PowerPlay tables.
- **Root cause:** offset/size taken from untrusted table contents; only
  a weak `usTableSize >= sizeof(POWERPLAYTABLE3)` check existed for
  extended headers; array walks used `ucNumEntries` / `ucEntrySize` with
  no remaining-buffer check.
- **Version info:** none in the message. Author date 2026-06-23;
  upstream commit 2026-07-01 (after v6.18).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit memory-safety fix. Also silently
corrects an off-by-one in `get_state_entry_v2` (`entry_index <=
ucNumEntries` vs `>=`) and adds a missing NULL/size check in
`pp_tables_initialize`.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- One file: `drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c`
- `+316 / -130` (446 lines touched); 21 hunks
- New: `pp_table_has_space()`, `get_extended_header()`
- Modified: VCE/UVD/SAMU/ACP/PowerTune/SCLK offset helpers,
  `get_state_entry_v2`, `pp_tables_get_response_times`,
  `pp_tables_get_num_of_entries`, `pp_tables_get_entry`,
  `get_vce_state_table_entry`, `pp_tables_initialize`
- Classification: single-file surgical hardening (not cross-subsystem)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Extended-header getters:** previously cast `powerplay_table +
  usExtendendedHeaderOffset` after only `usTableSize >=
  sizeof(POWERPLAYTABLE3)`. Now `get_extended_header()` also requires
  the offset and `min_size` to fit in `hwmgr->soft_pp_table_size`.
- **VCE/UVD array size helpers:** previously read `ucNumEntries` and
  computed size with no bounds check. Now require the count byte and the
  full computed array to fit; otherwise return 0 so later offset math
  stops.
- **`get_state_entry_v2`:** previously walked `entry_index` steps if
  `entry_index <= ucNumEntries` (allows OOB when `entry_index ==
  ucNumEntries`) and returned the resulting pointer even if it walked
  off the buffer. Now rejects `entry_index >= ucNumEntries` and checks
  each variable-length entry against the buffer.
- **`pp_tables_get_entry`:** previously used offsets as-is (and
  `entry_index > ucNumEntries`, another off-by-one). Now validates
  state/clock/non-clock array headers, entry sizes, and per-index
  offsets; returns `-1` on failure.
- **`pp_tables_initialize`:** previously used `powerplay_table` with no
  NULL/size check after `get_powerplay_table()`. Now asserts table
  present and large enough for the header.
- Paths: init (`pptable_init` → `hwmgr_hw_init`) and entry lookup
  (power-state construction). Error paths become fail-closed instead of
  OOB.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **(d) Memory safety — out-of-bounds reads** plus **(g)
logic/off-by-one**.
Mechanism: firmware/sysfs PP tables supply offsets and counts; the
parser added them to the base pointer without comparing against
`soft_pp_table_size`. The fix is overflow-safe (`offset <= table_size &&
size <= table_size - offset`) and rejects truncated entries.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct for the paths it covers: fail closed, no new APIs,
  local static helpers.
- Not complete for the whole file: `init_thermal_controller` still uses
  `usFanTableOffset`, and `init_overdrive_limits_V2_1` still uses
  `usExtendendedHeaderOffset`, without `pp_table_has_space()`. Partial
  hardening is still a real fix.
- Regression risk: well-formed VBIOS inside the ATOM-reported size is
  unchanged. Malformed tables that previously “worked” by reading past
  the buffer now fail init (`pptable_init` error → DPM init error). That
  is the intended fail-closed behavior.
- No public API / struct layout change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Unfixed `get_vce_table_offset` at v6.18.53 blames
`3bace359149391` (“drm/amd/powerplay: add hardware manager sub-
component”, 2015-12-21). Present since the powerplay hwmgr was added.
Confirmed ancestor of v6.18.53.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Bug is original parser design, not a later
regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same author series (standalone files, not compile deps for this
patch):
- `Validate pp_table header before reading size` (sysfs/SMU)
- `Use uploaded size for legacy custom PPTable` (`amd_powerplay.c`)
- `Validate Tonga PowerPlay state array bounds`
- `Validate Vega hwmgr PowerPlay table bounds`
This commit is **[PATCH 5/5]** and only touches `processpptables.c`. No
prerequisite refactor in this file. No later follow-up on this file
after upstream `0ceb6bc43e62`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yang Wang is an AMD pm contributor with multiple PP-table
UAF/bounds fixes (`fix pptable use-after-free`, header-size validation,
custom-table size). Hawking Zhang and Alex Deucher reviewed/merged.
Maintainer-backed.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Applies standalone. Uses existing `hwmgr->soft_pp_table_size`
(in `hwmgr.h` at v6.18.53). Sibling patch “Use uploaded size…” is
**not** required for this to compile; it would make short *custom*
uploads match `soft_pp_table_size` more tightly. This patch still stops
offsets past the allocated buffer.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 0ceb6bc43e62...` → only **v1**, msgid
  `20260623034151.263746-5-kevinyang.wang@amd.com`
- Series: `[PATCH 1/5] ... header before reading size` through `[PATCH
  5/5] Validate legacy hwmgr PP table offsets`
- lore.kernel.org fetches returned **403**; thread recovered via
  `https://ratatoskr.run/amd-gfx/2026/06/17163868`
- `b4 dig -a`: only v1 (committed version is the submitted version)
- Merged via Alex Deucher drm-next-7.3 pull
  (`lists.freedesktop.org/archives/amd-gfx/2026-July/148126.html`)
- No NAK found. No reviewer `Cc: stable` found (absence expected).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w` CC: Yang Wang, amd-gfx, alexander.deucher@amd.com,
hawking.zhang@amd.com, kenneth.feng@amd.com. Hawking replied R-B on the
series (`RE: [PATCH 1/5]` on 2026-06-23); commit carries his `Reviewed-
by`. Alex Deucher signed off.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. The 5-patch series is systematic hardening
of PP-table parsing after related issues (`bound pp_dpm_set_pp_table()
memcpy` heap overflow, pptable UAF). Severity from code: kernel OOB
read.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 5-patch v1 series; this is 5/5, different files. Standalone for
this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search not usable (403). `git log
--grep="Validate legacy"` on v6.18.53: not present. No evidence it was
rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `pp_table_has_space`, `get_extended_header`,
VCE/UVD/SAMU/ACP/PowerTune/SCLK offset helpers, `get_state_entry_v2`,
`pp_tables_get_response_times`, `pp_tables_get_num_of_entries`,
`pp_tables_get_entry`, `get_vce_state_table_entry`,
`pp_tables_initialize`.

**Step 5.2: TRACE CALLERS**
Record:
- `pptable_funcs.pptable_init` = `pp_tables_initialize` →
  `hwmgr_hw_init()` (GPU DPM init / `amd_powerplay_reset` after sysfs
  upload)
- `pptable_funcs` assigned for:
  - SMU7 + `PP_TABLE_V0`: `AMDGPU_FAMILY_CI` (Bonaire/Hawaii),
    `CHIP_TOPAZ` (Iceland)
  - SMU8: `AMDGPU_FAMILY_CZ` (Carrizo/Stoney)
  - SMU10: `CHIP_RAVEN` (dummy table; initialize returns 0 early)
- `pp_tables_get_entry` called from `smu7_hwmgr.c`, `smu8_hwmgr.c`,
  `smu10_hwmgr.c` while building power states.

**Step 5.3: TRACE CALLEES**
Record: `get_powerplay_table()` fills `soft_pp_table` /
`soft_pp_table_size` from ATOM `PowerPlayInfo` or the dummy table.
Helpers then index that buffer.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable on every boot of CI/CZ/Iceland amdgpu with DPM, and on
`pp_table` sysfs write (`S_IWUSR`, typically root) which copies a user
buffer and calls `amd_powerplay_reset()` → `pptable_init` / entry
lookup.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same series adds analogous checks in Tonga
(`process_pptables_v1_0.c`) and Vega parsers. Leftover unguarded
`usFanTableOffset` / overdrive extended-header walks remain in this
file.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Local tree is **6.18.53** (`git describe HEAD` =
`v6.18.53-5049-g0f0bdc2b0dffb`; Makefile `VERSION=6 PATCHLEVEL=18
SUBLEVEL=53`).
- `git merge-base --is-ancestor 0ceb6bc43e62 v6.18.53` → **no** (fix not
  in 6.18.53)
- `git grep pp_table_has_space v6.18.53 -- processpptables.c` → **NOT
  PRESENT**
- Unfixed `get_vce_table_offset` / `get_state_entry_v2` /
  `pp_tables_get_entry` confirmed at v6.18.53.
- Bug introduced 2015; present in this series.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: `patch --dry-run` of this commit onto the v6.18.53 blob: **EXIT
0, clean apply**. File not refactored between 6.18.53 and the patch
context.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No equivalent bounds helper in this file at v6.18.53.
`3334985f8b4c7` (`bound pp_dpm_set_pp_table() memcpy`) is in 6.18.53 and
only caps upload size; it does not validate internal offsets.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/gpu/drm/amd/pm/powerplay` — **IMPORTANT** (legacy AMD
GPU powerplay). Not core mm/vfs, but amdgpu DPM init is a common
production path (CI/CZ laptops and cards still in use).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; this is late hardening of a 10-year-old
parser, not a brand-new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: Driver-specific: amdgpu CI (Bonaire/Hawaii), Iceland/Topaz,
Carrizo/Stoney; sysfs `pp_table` writers on those chips. Not Navi/RDNA
swsmu.

**Step 8.2: TRIGGER CONDITIONS**
Record:
- Probe/init: truncated or offset-inconsistent VBIOS PowerPlay table.
- Sysfs: root write of a malformed table ≤ original size (6.18.53 still
  copies into the VBIOS-sized buffer). Offsets beyond that buffer OOB
  without this patch.
- Off-by-one: `entry_index == ucNumEntries` on format rev ≥ 6.
- Unprivileged users cannot write `pp_table` (`S_IWUSR`). VBIOS path
  runs on device init.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Kernel **out-of-bounds read** → KASAN/oops or info leak.
**HIGH**. Missing table in `pp_tables_initialize` was a possible NULL
deref (**CRITICAL** if hit).

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit: HIGH** — stops OOB reads in DPM init on remaining CI/CZ
  hardware and custom PP tables.
- **Risk: LOW–MEDIUM** — +316 lines but one file, fail-closed checks,
  overflow-safe helper, maintainer-reviewed; leftover unguarded
  fan/overdrive walks are pre-existing, not introduced.
- **Ratio:** benefit outweighs risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real OOB reads in a firmware table parser present since 2015 and still
  in v6.18.53
- Off-by-one in `get_state_entry_v2` / `pp_tables_get_entry`
- Probe-time path plus documented `pp_table` sysfs upload
- Applies cleanly to this tree
- Reviewed by Hawking Zhang, signed off by Alex Deucher
- No new APIs; overflow-safe helper
- No follow-up fix indicating the patch itself was buggy

AGAINST:
- Larger than a typical 10-line stable patch (+316/−130)
- Incomplete (fan/overdrive offset walks still unchecked)
- No syzbot/CVE/user crash report
- Sibling “uploaded size” patch not in 6.18.53 (custom short tables
  still keep VBIOS `soft_pp_table_size`)

UNRESOLVED:
- Full lore thread text (403); ratatoskr + b4 + drm-next pull used
  instead
- Whether any production VBIOS relies on reading past ATOM size
  (unverified; fail-closed is still correct)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — overflow-safe bounds checks;
   v1 applied; maintainer R-B/SOB
2. Fixes a real bug that affects users? **PASS** — OOB reads on
   malformed VBIOS/custom PP tables; CI/CZ still use this parser
3. Important issue? **PASS** — HIGH (OOB read / possible oops); NULL
   deref on missing table
4. Small and contained? **PASS** — one file, no refactor, no API; large
   but contained
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean apply to v6.18.53;
   buggy code present

**Step 9.3: EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Qualifies as a
memory-safety fix.

**Step 9.4: DECISION**
This should be backported to this 6.18.y tree. The parser is in-tree,
the bug is old, the patch applies cleanly, and the failure mode is
kernel OOB during GPU powerplay init.

Verification:
- [Phase 1] Parsed tags: author Yang Wang; Reviewed-by Hawking Zhang;
  SOB Alex Deucher; no Fixes/syzbot/stable Cc
- [Phase 2] Diff: +316/−130 in `processpptables.c`; adds
  `pp_table_has_space`/`get_extended_header`; validates offsets before
  deref; also fixes `entry_index <= ucNumEntries` off-by-one
- [Phase 3] `git blame` at v6.18.53: `3bace359149391` (2015-12-21); `git
  merge-base --is-ancestor 3bace359149391 v6.18.53` = yes
- [Phase 3] No Fixes: tag; series siblings touch other files only
- [Phase 3] No follow-up on this file after `0ceb6bc43e62`
- [Phase 4] `b4 dig -c 0ceb6bc43e62`: v1 only, msgid
  `20260623034151.263746-5-kevinyang.wang@amd.com`
- [Phase 4] `b4 dig -w`: amd-gfx + Deucher + Hawking + Kenneth Feng
- [Phase 4] lore WebFetch 403; discussion via ratatoskr 17163868; merged
  in drm-next-7.3 pull
- [Phase 5] `pptable_funcs` used by smu7 (PP_TABLE_V0: CI, Topaz), smu8
  (CZ), smu10 (Raven dummy); `hwmgr_hw_init` → `pptable_init`
- [Phase 5] `pp_table` sysfs `AMDGPU_DEVICE_ATTR_RW` with `S_IWUSR`;
  write → `pp_dpm_set_pp_table` → `amd_powerplay_reset`
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` 6.18.53
- [Phase 6] `git merge-base --is-ancestor 0ceb6bc43e62 v6.18.53` = no;
  `pp_table_has_space` absent at v6.18.53
- [Phase 6] patch dry-run against v6.18.53 blob: EXIT 0
- [Phase 8] Failure mode: OOB read during hwmgr init / entry lookup,
  severity HIGH
- UNVERIFIED: full lore review body (403); whether any in-field VBIOS
  depends on reading past table_size

**YES**

 .../amd/pm/powerplay/hwmgr/processpptables.c  | 446 +++++++++++++-----
 1 file changed, 316 insertions(+), 130 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
index f06b29e33ba45..f1009b2973574 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
@@ -47,26 +47,53 @@
 
 #define NUM_BITS_CLOCK_INFO_ARRAY_INDEX 6
 
+static bool pp_table_has_space(struct pp_hwmgr *hwmgr, size_t offset,
+			       size_t size)
+{
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	return offset <= table_size && size <= table_size - offset;
+}
+
+static const ATOM_PPLIB_EXTENDEDHEADER *
+get_extended_header(struct pp_hwmgr *hwmgr,
+		    const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table,
+		    size_t min_size)
+{
+	const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
+	u16 offset;
+
+	if (le16_to_cpu(powerplay_table->usTableSize) <
+	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3) ||
+	    !pp_table_has_space(hwmgr, 0, sizeof(ATOM_PPLIB_POWERPLAYTABLE3)))
+		return NULL;
+
+	powerplay_table3 = (const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
+	offset = le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset);
+	if (!offset || !pp_table_has_space(hwmgr, offset,
+					   sizeof(extended_header->usSize)))
+		return NULL;
+
+	extended_header = (const ATOM_PPLIB_EXTENDEDHEADER *)
+		(((unsigned long)powerplay_table) + offset);
+	if (le16_to_cpu(extended_header->usSize) < min_size ||
+	    !pp_table_has_space(hwmgr, offset, min_size))
+		return NULL;
+
+	return extended_header;
+}
+
 static uint16_t get_vce_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t vce_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	   sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *extended_header =
-						(const ATOM_PPLIB_EXTENDEDHEADER *)
-						(((unsigned long)powerplay_table3) +
-						le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(extended_header->usSize) >=
-			   SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V2)
-				vce_table_offset = le16_to_cpu(extended_header->usVCETableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V2);
+	if (extended_header)
+		vce_table_offset = le16_to_cpu(extended_header->usVCETableOffset);
 
 	return vce_table_offset;
 }
@@ -93,7 +120,14 @@ static uint16_t get_vce_clock_info_array_size(struct pp_hwmgr *hwmgr,
 	if (table_offset > 0) {
 		const VCEClockInfoArray *p = (const VCEClockInfoArray *)
 			(((unsigned long) powerplay_table) + table_offset);
-		table_size = sizeof(uint8_t) + p->ucNumEntries * sizeof(VCEClockInfo);
+		size_t size;
+
+		if (!pp_table_has_space(hwmgr, table_offset, sizeof(p->ucNumEntries)))
+			return 0;
+
+		size = sizeof(uint8_t) + p->ucNumEntries * sizeof(VCEClockInfo);
+		if (pp_table_has_space(hwmgr, table_offset, size))
+			table_size = size;
 	}
 
 	return table_size;
@@ -104,10 +138,13 @@ static uint16_t get_vce_clock_voltage_limit_table_offset(struct pp_hwmgr *hwmgr,
 {
 	uint16_t table_offset = get_vce_clock_info_array_offset(hwmgr,
 							powerplay_table);
+	u16 table_size;
 
-	if (table_offset > 0)
-		return table_offset + get_vce_clock_info_array_size(hwmgr,
-							powerplay_table);
+	if (table_offset > 0) {
+		table_size = get_vce_clock_info_array_size(hwmgr, powerplay_table);
+		if (table_size)
+			return table_offset + table_size;
+	}
 
 	return 0;
 }
@@ -121,8 +158,15 @@ static uint16_t get_vce_clock_voltage_limit_table_size(struct pp_hwmgr *hwmgr,
 	if (table_offset > 0) {
 		const ATOM_PPLIB_VCE_Clock_Voltage_Limit_Table *ptable =
 			(const ATOM_PPLIB_VCE_Clock_Voltage_Limit_Table *)(((unsigned long) powerplay_table) + table_offset);
+		size_t size;
 
-		table_size = sizeof(uint8_t) + ptable->numEntries * sizeof(ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record);
+		if (!pp_table_has_space(hwmgr, table_offset, sizeof(ptable->numEntries)))
+			return 0;
+
+		size = sizeof(uint8_t) +
+			ptable->numEntries * sizeof(ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record);
+		if (pp_table_has_space(hwmgr, table_offset, size))
+			table_size = size;
 	}
 	return table_size;
 }
@@ -130,9 +174,13 @@ static uint16_t get_vce_clock_voltage_limit_table_size(struct pp_hwmgr *hwmgr,
 static uint16_t get_vce_state_table_offset(struct pp_hwmgr *hwmgr, const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t table_offset = get_vce_clock_voltage_limit_table_offset(hwmgr, powerplay_table);
+	u16 table_size;
 
-	if (table_offset > 0)
-		return table_offset + get_vce_clock_voltage_limit_table_size(hwmgr, powerplay_table);
+	if (table_offset > 0) {
+		table_size = get_vce_clock_voltage_limit_table_size(hwmgr, powerplay_table);
+		if (table_size)
+			return table_offset + table_size;
+	}
 
 	return 0;
 }
@@ -143,8 +191,12 @@ static const ATOM_PPLIB_VCE_State_Table *get_vce_state_table(
 {
 	uint16_t table_offset = get_vce_state_table_offset(hwmgr, powerplay_table);
 
-	if (table_offset > 0)
-		return (const ATOM_PPLIB_VCE_State_Table *)(((unsigned long) powerplay_table) + table_offset);
+	if (table_offset > 0) {
+		if (pp_table_has_space(hwmgr, table_offset,
+				       sizeof(((ATOM_PPLIB_VCE_State_Table *)0)->numEntries)))
+			return (const ATOM_PPLIB_VCE_State_Table *)
+				(((unsigned long)powerplay_table) + table_offset);
+	}
 
 	return NULL;
 }
@@ -153,21 +205,13 @@ static uint16_t get_uvd_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t uvd_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
+
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V3);
+	if (extended_header)
+		uvd_table_offset = le16_to_cpu(extended_header->usUVDTableOffset);
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *extended_header =
-					(const ATOM_PPLIB_EXTENDEDHEADER *)
-					(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(extended_header->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V3)
-				uvd_table_offset = le16_to_cpu(extended_header->usUVDTableOffset);
-		}
-	}
 	return uvd_table_offset;
 }
 
@@ -193,8 +237,14 @@ static uint16_t get_uvd_clock_info_array_size(struct pp_hwmgr *hwmgr,
 		const UVDClockInfoArray *p = (const UVDClockInfoArray *)
 					(((unsigned long) powerplay_table)
 					+ table_offset);
-		table_size = sizeof(UCHAR) +
-			     p->ucNumEntries * sizeof(UVDClockInfo);
+		size_t size;
+
+		if (!pp_table_has_space(hwmgr, table_offset, sizeof(p->ucNumEntries)))
+			return 0;
+
+		size = sizeof(UCHAR) + p->ucNumEntries * sizeof(UVDClockInfo);
+		if (pp_table_has_space(hwmgr, table_offset, size))
+			table_size = size;
 	}
 
 	return table_size;
@@ -206,10 +256,13 @@ static uint16_t get_uvd_clock_voltage_limit_table_offset(
 {
 	uint16_t table_offset = get_uvd_clock_info_array_offset(hwmgr,
 						     powerplay_table);
+	u16 table_size;
 
-	if (table_offset > 0)
-		return table_offset +
-			get_uvd_clock_info_array_size(hwmgr, powerplay_table);
+	if (table_offset > 0) {
+		table_size = get_uvd_clock_info_array_size(hwmgr, powerplay_table);
+		if (table_size)
+			return table_offset + table_size;
+	}
 
 	return 0;
 }
@@ -218,21 +271,12 @@ static uint16_t get_samu_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t samu_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *extended_header =
-				(const ATOM_PPLIB_EXTENDEDHEADER *)
-				(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(extended_header->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V4)
-				samu_table_offset = le16_to_cpu(extended_header->usSAMUTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V4);
+	if (extended_header)
+		samu_table_offset = le16_to_cpu(extended_header->usSAMUTableOffset);
 
 	return samu_table_offset;
 }
@@ -254,21 +298,12 @@ static uint16_t get_acp_table_offset(struct pp_hwmgr *hwmgr,
 				const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t acp_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *pExtendedHeader =
-				(const ATOM_PPLIB_EXTENDEDHEADER *)
-				(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(pExtendedHeader->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V6)
-				acp_table_offset = le16_to_cpu(pExtendedHeader->usACPTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V6);
+	if (extended_header)
+		acp_table_offset = le16_to_cpu(extended_header->usACPTableOffset);
 
 	return acp_table_offset;
 }
@@ -290,21 +325,12 @@ static uint16_t get_cacp_tdp_table_offset(
 				const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t cacTdpTableOffset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-				(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *pExtendedHeader =
-					(const ATOM_PPLIB_EXTENDEDHEADER *)
-					(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(pExtendedHeader->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V7)
-				cacTdpTableOffset = le16_to_cpu(pExtendedHeader->usPowerTuneTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V7);
+	if (extended_header)
+		cacTdpTableOffset = le16_to_cpu(extended_header->usPowerTuneTableOffset);
 
 	return cacTdpTableOffset;
 }
@@ -341,22 +367,13 @@ static uint16_t get_sclk_vdd_gfx_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t sclk_vdd_gfx_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-				(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *pExtendedHeader =
-				(const ATOM_PPLIB_EXTENDEDHEADER *)
-				(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(pExtendedHeader->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V8)
-				sclk_vdd_gfx_table_offset =
-					le16_to_cpu(pExtendedHeader->usSclkVddgfxTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V8);
+	if (extended_header)
+		sclk_vdd_gfx_table_offset =
+			le16_to_cpu(extended_header->usSclkVddgfxTableOffset);
 
 	return sclk_vdd_gfx_table_offset;
 }
@@ -770,20 +787,37 @@ static ULONG size_of_entry_v2(ULONG num_dpm_levels)
 }
 
 static const ATOM_PPLIB_STATE_V2 *get_state_entry_v2(
+					struct pp_hwmgr *hwmgr,
 					const StateArray * pstate_arrays,
+					u16 state_array_offset,
 							 ULONG entry_index)
 {
 	ULONG i;
 	const ATOM_PPLIB_STATE_V2 *pstate;
+	size_t entry_offset;
+	size_t entry_size;
+
+	if (entry_index >= pstate_arrays->ucNumEntries)
+		return NULL;
 
+	entry_offset = state_array_offset + sizeof(pstate_arrays->ucNumEntries);
 	pstate = pstate_arrays->states;
-	if (entry_index <= pstate_arrays->ucNumEntries) {
-		for (i = 0; i < entry_index; i++)
-			pstate = (ATOM_PPLIB_STATE_V2 *)(
-						  (unsigned long)pstate +
-			     size_of_entry_v2(pstate->ucNumDPMLevels));
+	for (i = 0; i <= entry_index; i++) {
+		if (!pp_table_has_space(hwmgr, entry_offset, sizeof(*pstate)))
+			return NULL;
+
+		entry_size = size_of_entry_v2(pstate->ucNumDPMLevels);
+		if (!pp_table_has_space(hwmgr, entry_offset, entry_size))
+			return NULL;
+
+		if (i == entry_index)
+			return pstate;
+
+		entry_offset += entry_size;
+		pstate = (ATOM_PPLIB_STATE_V2 *)((unsigned long)pstate + entry_size);
 	}
-	return pstate;
+
+	return NULL;
 }
 
 static const unsigned char soft_dummy_pp_table[] = {
@@ -851,6 +885,8 @@ int pp_tables_get_response_times(struct pp_hwmgr *hwmgr,
 
 	PP_ASSERT_WITH_CODE(NULL != powerplay_tab,
 			    "Missing PowerPlay Table!", return -EINVAL);
+	PP_ASSERT_WITH_CODE(pp_table_has_space(hwmgr, 0, sizeof(*powerplay_tab)),
+			    "Invalid PowerPlay Table!", return -EINVAL);
 
 	*vol_rep_time = (uint32_t)le16_to_cpu(powerplay_tab->usVoltageTime);
 	*bb_rep_time = (uint32_t)le16_to_cpu(powerplay_tab->usBackbiasTime);
@@ -863,13 +899,21 @@ int pp_tables_get_num_of_entries(struct pp_hwmgr *hwmgr,
 {
 	const StateArray *pstate_arrays;
 	const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table = get_powerplay_table(hwmgr);
+	u16 state_array_offset;
 
 	if (powerplay_table == NULL)
 		return -1;
+	if (!pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)))
+		return -1;
 
 	if (powerplay_table->sHeader.ucTableFormatRevision >= 6) {
+		state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+		if (!pp_table_has_space(hwmgr, state_array_offset,
+					sizeof(pstate_arrays->ucNumEntries)))
+			return -1;
+
 		pstate_arrays = (StateArray *)(((unsigned long)powerplay_table) +
-					le16_to_cpu(powerplay_table->usStateArrayOffset));
+					state_array_offset);
 
 		*num_of_entries = (unsigned long)(pstate_arrays->ucNumEntries);
 	} else
@@ -896,49 +940,128 @@ int pp_tables_get_entry(struct pp_hwmgr *hwmgr,
 	const NonClockInfoArray *pnon_clock_arrays;
 
 	const ATOM_PPLIB_STATE *pstate_entry;
+	u16 state_array_offset;
+	u16 clock_info_array_offset;
+	u16 non_clock_info_array_offset;
+	size_t clock_info_offset;
+	size_t non_clock_info_offset;
+	size_t state_entry_offset;
 
 	if (powerplay_table == NULL)
 		return -1;
+	if (!pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)))
+		return -1;
 
 	ps->classification.bios_index = entry_index;
 
 	if (powerplay_table->sHeader.ucTableFormatRevision >= 6) {
+		state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+		if (!pp_table_has_space(hwmgr, state_array_offset,
+					sizeof(pstate_arrays->ucNumEntries)))
+			return -1;
+
 		pstate_arrays = (StateArray *)(((unsigned long)powerplay_table) +
-					le16_to_cpu(powerplay_table->usStateArrayOffset));
+					state_array_offset);
+
+		if (entry_index >= pstate_arrays->ucNumEntries)
+			return -1;
 
-		if (entry_index > pstate_arrays->ucNumEntries)
+		pstate_entry_v2 = get_state_entry_v2(hwmgr, pstate_arrays,
+						     state_array_offset,
+						     entry_index);
+		if (!pstate_entry_v2)
+			return -1;
+
+		clock_info_array_offset =
+			le16_to_cpu(powerplay_table->usClockInfoArrayOffset);
+		if (!pp_table_has_space(hwmgr, clock_info_array_offset,
+					sizeof(*pclock_arrays)))
 			return -1;
 
-		pstate_entry_v2 = get_state_entry_v2(pstate_arrays, entry_index);
 		pclock_arrays = (ClockInfoArray *)(((unsigned long)powerplay_table) +
-					le16_to_cpu(powerplay_table->usClockInfoArrayOffset));
+					clock_info_array_offset);
+		if (!pclock_arrays->ucEntrySize)
+			return -1;
+
+		non_clock_info_array_offset =
+			le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset);
+		if (!pp_table_has_space(hwmgr, non_clock_info_array_offset,
+					sizeof(*pnon_clock_arrays)))
+			return -1;
 
 		pnon_clock_arrays = (NonClockInfoArray *)(((unsigned long)powerplay_table) +
-						le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset));
+						non_clock_info_array_offset);
+		if (!pnon_clock_arrays->ucEntrySize ||
+		    pnon_clock_arrays->ucEntrySize < ATOM_PPLIB_NONCLOCKINFO_VER1 ||
+		    (pnon_clock_arrays->ucEntrySize > ATOM_PPLIB_NONCLOCKINFO_VER1 &&
+		     pnon_clock_arrays->ucEntrySize < ATOM_PPLIB_NONCLOCKINFO_VER2) ||
+		    pstate_entry_v2->nonClockInfoIndex >= pnon_clock_arrays->ucNumEntries)
+			return -1;
 
+		non_clock_info_offset = non_clock_info_array_offset +
+			offsetof(NonClockInfoArray, nonClockInfo) +
+			pstate_entry_v2->nonClockInfoIndex * pnon_clock_arrays->ucEntrySize;
+		if (!pp_table_has_space(hwmgr, non_clock_info_offset,
+					pnon_clock_arrays->ucEntrySize))
+			return -1;
 		pnon_clock_info = (ATOM_PPLIB_NONCLOCK_INFO *)((unsigned long)(pnon_clock_arrays->nonClockInfo) +
 					(pstate_entry_v2->nonClockInfoIndex * pnon_clock_arrays->ucEntrySize));
 
 		result = init_non_clock_fields(hwmgr, ps, pnon_clock_arrays->ucEntrySize, pnon_clock_info);
 
 		for (i = 0; i < pstate_entry_v2->ucNumDPMLevels; i++) {
-			const void *pclock_info = (const void *)(
-							(unsigned long)(pclock_arrays->clockInfo) +
-							(pstate_entry_v2->clockInfoIndex[i] * pclock_arrays->ucEntrySize));
+			const void *pclock_info;
+
+			if (pstate_entry_v2->clockInfoIndex[i] >=
+			    pclock_arrays->ucNumEntries)
+				return -1;
+
+			clock_info_offset = clock_info_array_offset +
+				offsetof(ClockInfoArray, clockInfo) +
+				pstate_entry_v2->clockInfoIndex[i] * pclock_arrays->ucEntrySize;
+			if (!pp_table_has_space(hwmgr, clock_info_offset,
+						pclock_arrays->ucEntrySize))
+				return -1;
+
+			pclock_info = (const void *)
+					((unsigned long)(pclock_arrays->clockInfo) +
+					(pstate_entry_v2->clockInfoIndex[i] *
+					 pclock_arrays->ucEntrySize));
 			res = func(hwmgr, &ps->hardware, i, pclock_info);
 			if ((0 == result) && (0 != res))
 				result = res;
 		}
 	} else {
-		if (entry_index > powerplay_table->ucNumStates)
+		if (entry_index >= powerplay_table->ucNumStates ||
+		    !powerplay_table->ucStateEntrySize ||
+		    !powerplay_table->ucNonClockSize ||
+		    powerplay_table->ucNonClockSize < ATOM_PPLIB_NONCLOCKINFO_VER1 ||
+		    (powerplay_table->ucNonClockSize > ATOM_PPLIB_NONCLOCKINFO_VER1 &&
+		     powerplay_table->ucNonClockSize < ATOM_PPLIB_NONCLOCKINFO_VER2) ||
+		    !powerplay_table->ucClockInfoSize)
+			return -1;
+
+		state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+		state_entry_offset = state_array_offset +
+			entry_index * powerplay_table->ucStateEntrySize;
+		if (!pp_table_has_space(hwmgr, state_entry_offset,
+					powerplay_table->ucStateEntrySize))
 			return -1;
 
 		pstate_entry = (ATOM_PPLIB_STATE *)((unsigned long)powerplay_table +
-						    le16_to_cpu(powerplay_table->usStateArrayOffset) +
+						    state_array_offset +
 						    entry_index * powerplay_table->ucStateEntrySize);
 
+		non_clock_info_array_offset =
+			le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset);
+		non_clock_info_offset = non_clock_info_array_offset +
+			pstate_entry->ucNonClockStateIndex * powerplay_table->ucNonClockSize;
+		if (!pp_table_has_space(hwmgr, non_clock_info_offset,
+					powerplay_table->ucNonClockSize))
+			return -1;
+
 		pnon_clock_info = (ATOM_PPLIB_NONCLOCK_INFO *)((unsigned long)powerplay_table +
-						le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset) +
+						non_clock_info_array_offset +
 						pstate_entry->ucNonClockStateIndex *
 						powerplay_table->ucNonClockSize);
 
@@ -947,12 +1070,23 @@ int pp_tables_get_entry(struct pp_hwmgr *hwmgr,
 							pnon_clock_info);
 
 		for (i = 0; i < powerplay_table->ucStateEntrySize-1; i++) {
-			const void *pclock_info = (const void *)((unsigned long)powerplay_table +
-						le16_to_cpu(powerplay_table->usClockInfoArrayOffset) +
+			const void *pclock_info;
+
+			clock_info_array_offset =
+				le16_to_cpu(powerplay_table->usClockInfoArrayOffset);
+			clock_info_offset = clock_info_array_offset +
+				pstate_entry->ucClockStateIndices[i] *
+				powerplay_table->ucClockInfoSize;
+			if (!pp_table_has_space(hwmgr, clock_info_offset,
+						powerplay_table->ucClockInfoSize))
+				return -1;
+
+			pclock_info = (const void *)((unsigned long)powerplay_table +
+						clock_info_array_offset +
 						pstate_entry->ucClockStateIndices[i] *
 						powerplay_table->ucClockInfoSize);
 
-			int res = func(hwmgr, &ps->hardware, i, pclock_info);
+			res = func(hwmgr, &ps->hardware, i, pclock_info);
 
 			if ((0 == result) && (0 != res))
 					result = res;
@@ -1667,21 +1801,70 @@ static int get_vce_state_table_entry(struct pp_hwmgr *hwmgr,
 							unsigned long *flag)
 {
 	const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table = get_powerplay_table(hwmgr);
+	const ATOM_PPLIB_VCE_State_Table *vce_state_table;
+	const ATOM_PPLIB_VCE_State_Record *record;
+	const VCEClockInfoArray *vce_clock_info_array;
+	const VCEClockInfo *vce_clock_info;
+	const ClockInfoArray *clock_arrays;
+	u16 vce_state_table_offset;
+	u16 vce_clock_info_array_offset;
+	u16 clock_info_array_offset;
+	unsigned long clockInfoIndex;
+	size_t record_offset;
+	size_t vce_clock_info_offset;
+	size_t clock_info_offset;
+
+	if (!powerplay_table || !pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)))
+		return -1;
 
-	const ATOM_PPLIB_VCE_State_Table *vce_state_table = get_vce_state_table(hwmgr, powerplay_table);
+	vce_state_table_offset = get_vce_state_table_offset(hwmgr, powerplay_table);
+	vce_state_table = get_vce_state_table(hwmgr, powerplay_table);
+	if (!vce_state_table || i >= vce_state_table->numEntries)
+		return -1;
+
+	record_offset = vce_state_table_offset +
+		offsetof(ATOM_PPLIB_VCE_State_Table, entries) +
+		i * sizeof(*record);
+	if (!pp_table_has_space(hwmgr, record_offset, sizeof(*record)))
+		return -1;
+
+	record = &vce_state_table->entries[i];
+
+	vce_clock_info_array_offset =
+		get_vce_clock_info_array_offset(hwmgr, powerplay_table);
+	if (!pp_table_has_space(hwmgr, vce_clock_info_array_offset,
+				sizeof(vce_clock_info_array->ucNumEntries)))
+		return -1;
 
-	unsigned short vce_clock_info_array_offset = get_vce_clock_info_array_offset(hwmgr, powerplay_table);
+	vce_clock_info_array = (const VCEClockInfoArray *)
+		(((unsigned long)powerplay_table) + vce_clock_info_array_offset);
+	if (record->ucVCEClockInfoIndex >= vce_clock_info_array->ucNumEntries)
+		return -1;
 
-	const VCEClockInfoArray *vce_clock_info_array = (const VCEClockInfoArray *)(((unsigned long) powerplay_table) + vce_clock_info_array_offset);
+	vce_clock_info_offset = vce_clock_info_array_offset +
+		offsetof(VCEClockInfoArray, entries) +
+		record->ucVCEClockInfoIndex * sizeof(*vce_clock_info);
+	if (!pp_table_has_space(hwmgr, vce_clock_info_offset, sizeof(*vce_clock_info)))
+		return -1;
 
-	const ClockInfoArray *clock_arrays = (ClockInfoArray *)(((unsigned long)powerplay_table) +
-								le16_to_cpu(powerplay_table->usClockInfoArrayOffset));
+	vce_clock_info = &vce_clock_info_array->entries[record->ucVCEClockInfoIndex];
 
-	const ATOM_PPLIB_VCE_State_Record *record = &vce_state_table->entries[i];
+	clock_info_array_offset = le16_to_cpu(powerplay_table->usClockInfoArrayOffset);
+	if (!pp_table_has_space(hwmgr, clock_info_array_offset,
+				sizeof(*clock_arrays)))
+		return -1;
 
-	const VCEClockInfo *vce_clock_info = &vce_clock_info_array->entries[record->ucVCEClockInfoIndex];
+	clock_arrays = (ClockInfoArray *)(((unsigned long)powerplay_table) +
+					  clock_info_array_offset);
+	clockInfoIndex = record->ucClockInfoIndex & 0x3F;
+	if (!clock_arrays->ucEntrySize || clockInfoIndex >= clock_arrays->ucNumEntries)
+		return -1;
 
-	unsigned long clockInfoIndex = record->ucClockInfoIndex & 0x3F;
+	clock_info_offset = clock_info_array_offset +
+		offsetof(ClockInfoArray, clockInfo) +
+		clockInfoIndex * clock_arrays->ucEntrySize;
+	if (!pp_table_has_space(hwmgr, clock_info_offset, clock_arrays->ucEntrySize))
+		return -1;
 
 	*flag = (record->ucClockInfoIndex >> NUM_BITS_CLOCK_INFO_ARRAY_INDEX);
 
@@ -1705,6 +1888,10 @@ static int pp_tables_initialize(struct pp_hwmgr *hwmgr)
 	hwmgr->need_pp_table_upload = true;
 
 	powerplay_table = get_powerplay_table(hwmgr);
+	PP_ASSERT_WITH_CODE((powerplay_table),
+			    "Missing PowerPlay Table!", return -1);
+	PP_ASSERT_WITH_CODE(pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)),
+			    "Invalid PowerPlay Table!", return -1);
 
 	result = init_powerplay_tables(hwmgr, powerplay_table);
 
@@ -1807,4 +1994,3 @@ const struct pp_table_func pptable_funcs = {
 	.pptable_get_vce_state_table_entry =
 						get_vce_state_table_entry,
 };
-
-- 
2.53.0

