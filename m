Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6904852D628;
	Mon, 19 Oct 2026 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418363; cv=none; b=CodrzjJxSviPXddJLBqQ1BKvcNWdijR9Bp0Y8tahubWmtg+97g/G+nURMYZmozPuDoAV1V3conFrSJ546nykiuGks9HX3GqbpjXozc6aCcy9IMgEA8TZRPEAcnqjQKKKoe/SNGZNVFR9iE75KaDj72o9c75Glk8SGFdmRETVpp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418363; c=relaxed/simple;
	bh=hLX6tV2a8q//zAnJq9UR7DaHmMbO1qIDqf13l4I90G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cpyhv1qEj6KNmwWhYSsCXq0fbf7UM/rWFw8oy8GpUm5kxPgJ2zQD4IW/hpG8qYLxmEfQzpJRFm3CT70T/3rdm+3zrKBarOHkQDUJSNdJinVPfBnnSpk4W1r9Yg3+cV37SyDqFv1i9NlfLm0CRI/M01AhX/rR1utc6CxA5R6dQWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URnqqle8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URnqqle8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06E71F000CA;
	Mon, 19 Oct 2026 13:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418360;
	bh=T+X9hDiPIJUdie2qRLfaA8R3nLrc4Y60IcJrzE/Nadc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URnqqle8oJhCQiY4dyXCC9SApgMnofJO70V5bNsN06UnkeV4UtrtQTotOcV0c+gkD
	 W6/54xPY83oZRHiqjRNYsLzR7gzawUT8T6UEDz6yZwv88s5QT/mdmA9zv1KTEtIceC
	 7Vs2GOadrAgEW9FWqGORQYlg6tvcEcLapPoCs61BRxAmyhlTzK260/1y0JTv9pZx2h
	 S1GapXDlXe9zkVbzNKgjHunsLpNFp+9LmJ8dlzjitO779G2evXlgBmTP/tCK9BRzFw
	 i8hrRJhyDYi99xHXBK3y88dEUZNnUiC7CZVdYNG9yJdtUtcriAoNzvJ2hlZ1ieH8lK
	 f7C5qWhvHqs1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] drm/amd/pm: Validate Tonga PPTable subtable bounds
Date: Mon, 19 Oct 2026 09:48:03 -0400
Message-ID: <20261019135441.1420968-192-sashal@kernel.org>
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

[ Upstream commit 53ef33c084c5778cc2dcd1efff25e31b6e231141 ]

v1:
Tonga PPTable parsing also relies on VBIOS offsets, revision fields
and entry counts for several subtables. Malformed data can cause
out-of-bounds reads, while voltage lookup tables can overrun their
fixed-size destination arrays.

Add common bounds helpers and validate fixed subtables, dynamic entry
arrays and revision-specific layouts before consuming voltage lookup,
dependency, PCIE, power-tune, hard-limit, thermal, fan, GPIO, PPM and
VCE state data.

v2:
correct to handle get_tonga_ppm_table() return value.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[drm/amd/pm] [Validate] Tonga PPTable subtable bounds`

**Step 1.2 — Tags**
- Record: `Reviewed-by: Asad Kamal <asad.kamal@amd.com>`; `Reviewed-by:
  Kenneth Feng <kenneth.feng@amd.com>`; `Signed-off-by: Yang Wang
  <kevinyang.wang@amd.com>`; `Signed-off-by: Alex Deucher
  <alexander.deucher@amd.com>`.
- No `Fixes:`, `Reported-by`, `Tested-by`, `Link:`, or `Cc: stable`
  (absence is expected).
- Pipeline markers (`[Upstream commit …]`, `Signed-off-by: Sasha Levin`)
  ignored.

**Step 1.3 — Body**
- Record: Tonga PPTable parsing trusts VBIOS offsets, revision IDs, and
  entry counts. Malformed data can cause out-of-bounds reads; voltage
  lookup tables can overrun fixed-size destination arrays.
- Symptom: kernel OOB read/write while parsing PowerPlay tables at init
  or after a `pp_table` upload.
- Root cause: pointer = `powerplay_table + le16_to_cpu(offset)` with no
  check against `soft_pp_table_size`, plus `ucNumEntries` used past
  allocated destination size.
- v2 only corrects `get_tonga_ppm_table()` return handling.

**Step 1.4 — Hidden bug fix?**
- Record: Not hidden. Explicit bounds-check fix for OOB reads and
  destination-array overrun.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: One file,
  `drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c`.
  Upstream: **+521 / −85**.
- New helpers: `tonga_pp_table_has_space`, `get_tonga_subtable`,
  `validate_tonga_table_entries`, plus getters for voltage lookup,
  MCLK/MM/SCLK/PCIE/hard-limit/thermal/fan/power-tune/PPM/GPIO/VCE.
- Callers updated: `init_dpm_2_parameters`,
  `init_clock_voltage_dependency`, `init_thermal_controller`,
  `ppt_get_num_of_vce_state_table_entries_v1_0`,
  `ppt_get_vce_state_table_entry_v1_0`.
- Scope: single-file parser hardening, not a cross-subsystem refactor.

**Step 2.2 — Flow change**
- Record: Before, every subtable pointer was `powerplay_table + offset`
  with no size check. After, each access goes through helpers that
  require a non-zero offset, that the header fits, and that
  `entries_offset + num_entries * entry_size` fits in
  `soft_pp_table_size`.
- Voltage lookup: `ucNumEntries` must be in `(0, max_levels]` (16)
  before `get_vddc_lookup_table()`.
- GPIO: previously `gpio_table` was always a non-NULL computed pointer,
  so `get_gpio_table()` ran even when `usGPIOTableOffset == 0`. After,
  that path runs only if the offset is non-zero.
- VCE: SCLK records are indexed as Tonga vs Polaris by `ucRevId`;
  SCLK/MM/MCLK indices are range-checked.

**Step 2.3 — Bug mechanism**
- Record: **Memory safety (OOB read + heap OOB write)**, plus a Polaris
  VCE layout correctness bug.
- Verified on this tree’s pre-fix `get_vddc_lookup_table()` (v6.18.53):

```
table = kzalloc(struct_size(table, entries, max_levels), GFP_KERNEL);
table->count = vddc_lookup_pp_tables->ucNumEntries;
for (i = 0; i < vddc_lookup_pp_tables->ucNumEntries; i++)
```

  Allocation uses `max_levels` (16); the loop uses raw `ucNumEntries`
(u8, up to 255). That is a real heap overflow.
- Subtable offsets/counts can also walk past `soft_pp_table_size` (VBIOS
  blob or uploaded table).

**Step 2.4 — Fix quality**
- Record: Helpers are overflow-safe (`offset <= table_size && size <=
  table_size - offset`). `PP_ASSERT_WITH_CODE` always runs the failure
  `return` (not debug-only). Leaf parsers already rejected `ucNumEntries
  == 0`, so that check is not a new behavior cliff.
- Regression risk: low–medium. Over-strict revision-based fan/power-tune
  sizes could reject a corrupt-but-previously-parsed table. No public
  API change. Patch is large because every subtable is wrapped, not
  because control flow is redesigned.

## Phase 3: Git history

**Step 3.1 — Blame / introduction**
- Record: Parser has been here since the Tonga PowerPlay path
  (`processpptable_v1_0`, later moved in `e098bc9612c2b`, 2020).
  Unbounded offset arithmetic is old, not a recent regression.

**Step 3.2 — Fixes: tag**
- Record: None. Not applicable.

**Step 3.3 — Related file history**
- Record: Same-day AMD series:
  - `1ac24df78c566` — Tonga state-array bounds
  - `3a8d8e0b7f61c` — Vega hwmgr bounds
  - `0ceb6bc43e62f` — legacy hwmgr offsets
  - `9914149f99fd2` — Vega10 subtable bounds
  - `53ef33c084c57` — this commit
- Standalone for this file. State-array helpers
  (`get_tonga_state_array`) are a sibling, not a call-graph dependency
  of these new getters.

**Step 3.4 — Author**
- Record: Yang Wang (AMD). Same author as the rest of this PPTable
  validation series. Merged by Alex Deucher.

**Step 3.5 — Prerequisites**
- Record: No new APIs. Upstream context uses `kzalloc_obj(*ptr)` in an
  unchanged hunk; v6.18.53 still has `kzalloc(sizeof(*ptr), GFP_KERNEL)`
  in that function. That is a trivial context tweak, not a functional
  dependency. Vega10/legacy patches in the same series touch other files
  and are not required for this one.

## Phase 4: Mailing list / external

**Step 4.1 — Original submission**
- Record: `b4 dig -c 53ef33c084c5778cc2dcd1efff25e31b6e231141` → `[PATCH
  v2 2/3] drm/amd/pm: Validate Tonga PPTable subtable bounds`
  https://patch.msgid.link/20260623134917.443011-2-
  kevinyang.wang@amd.com
- v1 → v2; v2 is what landed. v2 changelog: handle
  `get_tonga_ppm_table()` return value.
- No NAKs in the saved thread.

**Step 4.2 — Reviewers**
- Record: To/Cc: amd-gfx, Alex Deucher, Hawking Zhang, Kenneth Feng,
  Asad Kamal.
- Asad: “Series is Reviewed-by”. Kenneth Feng: same. Maintainer SOB from
  Alex Deucher.

**Step 4.3 — Bug report**
- Record: No syzbot/bugzilla/CVE in the message or thread. Bug is
  described from code inspection of the parser.

**Step 4.4 — Series**
- Record: v2 1/3 Vega10 subtables; **2/3 this patch**; 3/3 remaining
  legacy PPLIB. This patch is self-contained.

**Step 4.5 — stable@**
- Record: lore.kernel.org HTTP 403 from WebFetch/curl. `b4 dig` mbox has
  no `Cc: stable` and no stable-list discussion. UNVERIFIED vs
  lore.kernel.org/stable search.

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
- Record: New `tonga_pp_table_has_space` / `get_tonga_*` /
  `validate_tonga_table_entries`; callers listed in 2.1.

**Step 5.2 — Callers**
- Record: `pptable_v1_0_funcs.pptable_init` →
  `pp_tables_v1_0_initialize` → `init_thermal_controller` /
  `init_clock_voltage_dependency` / `init_dpm_2_parameters`. Wired from
  `smu7_init_function_pointers()` when `pp_table_version ==
  PP_TABLE_V1`.
- VCE getters run when userspace/KFD queries VCE states.

**Step 5.3 — Callees**
- Record: Existing leaf parsers (`get_vddc_lookup_table`,
  `get_mclk_voltage_dependency_table`, `get_cac_tdp_table`, …). No new
  allocations in the helpers.

**Step 5.4 — Reachability**
- Record: Yes. Driver load on Tonga/Fiji/Polaris/VegaM. Also
  `pp_dpm_set_pp_table()` after a sysfs write to `pp_table` (`S_IRUGO |
  S_IWUSR`, owner-writable; typically root).

**Step 5.5 — Similar patterns**
- Record: Same pattern as Vega10/legacy PPLIB validation in the same
  series; same class as earlier Tonga state-array bounds.

## Phase 6: This tree (6.18.y)

**Step 6.1 — Does the bug exist here?**
- Record: Local tree is **v6.18.53** (`6.18.53`, branch `autosel`).
  Vanilla v6.18.53 still has unbounded offset arithmetic and the
  voltage-lookup heap overflow. Bug was not introduced after this
  branch.

**Step 6.2 — Backport difficulty**
- Record: **Minor conflicts**. `git apply --check` of upstream onto
  v6.18.53 fails on `kzalloc_obj` vs `kzalloc` context in
  `get_platform_power_management_table()`. Logic applies with that
  mechanical adjustment. No missing types/helpers required by the new
  code (`soft_pp_table_size` is already set in `get_powerplay_table()`).

**Step 6.3 — Related fixes already here?**
- Record: v6.18.53 does **not** have this validation, `pp_entries_max`
  clamping in this file, or the Tonga state-array bounds commit. No
  alternate fix for the voltage-lookup overflow is present on vanilla
  6.18.53.

## Phase 7: Subsystem

**Step 7.1**
- Record: `drm/amd/pm` PowerPlay v1 parser. **IMPORTANT** (not core
  mm/VFS; Polar/Tonga/Fiji/VegaM still common, especially RX 400/500).

**Step 7.2**
- Record: Mature parser; recent work is bounds hardening, not feature
  churn.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: AMDGPU SMU7 with PP table v1: Tonga, Fiji, Polaris10/11/12,
  VegaM (`hwmgr.c` keeps default `PP_TABLE_V1` for those chips).

**Step 8.2 — Trigger**
- Record: GPU init (every boot with those ASICs) if VBIOS is
  truncated/corrupt. Also root write to `pp_table`. Unprivileged users
  cannot write that sysfs node under normal permissions.

**Step 8.3 — Failure mode**
- Record: Heap overflow in voltage lookup (**CRITICAL** if triggered).
  OOB reads of BIOS/uploaded buffer (**HIGH**). Wrong Polaris VCE SCLK
  stride (**MEDIUM** functional). Malformed table now fails init instead
  of walking off the end.

**Step 8.4 — Risk/benefit**
- Record: Benefit high for Polar/Tonga users and for `pp_table` upload.
  Risk: large-ish one-file change; conservative rejects of garbage
  tables. Ratio favors backport: the overflow is real and the helpers
  are local.

## Phase 9: Synthesis

**For**
- Confirmed heap overflow: `kzalloc(..., max_levels)` vs loop on
  `ucNumEntries`.
- Confirmed OOB reads from unchecked VBIOS/upload offsets.
- Reachable on driver init and via `pp_table`.
- Polaris VCE record-size bug also fixed.
- Reviewed by AMD PM; merged by the DRM AMD maintainer.
- One file; no new UAPI; v2 already fixed PPM error handling.
- Buggy code is in this 6.18.y tree.

**Against**
- +521 lines is large for stable.
- No public crash/CVE/syzbot report.
- Needs a small `kzalloc` context tweak vs upstream.
- Sibling series patches are separate (not blockers).

**Unresolved**
- Could not query lore.kernel.org/stable (HTTP 403). No stable
  discussion in the `b4` mbox.

**Stable rules**
1. Obviously correct and tested? **PASS** — overflow-safe helpers; AMD
   review; v2 PPM fix.
2. Real user-visible bug? **PASS** — OOB on Tonga/Polaris PPTable parse
   / `pp_table` upload.
3. Important (crash/security/corruption)? **PASS** — heap overflow + OOB
   read.
4. Small and contained? **PASS** (borderline on size, **contained**: one
   parser file, no architecture change).
5. No new features/APIs? **PASS**.
6. Can apply here? **PASS** with minor `kzalloc_obj` context adjustment.

**Exception category:** none (not a device-ID/quirk/DT/docs/build-only
change). It is a memory-safety fix.

This is a real bounds-check for a long-lived AMD PowerPlay parser that
this 6.18.y tree still ships. Size is the only serious stable concern;
the overflow and OOB are concrete enough that omitting it would be the
worse mistake.

### Verification
- [Phase 1] Parsed tags: Reviewed-by Asad Kamal and Kenneth Feng; Alex
  Deucher SOB; no Fixes/syzbot/Cc stable.
- [Phase 2] Diff: +521/−85 in `process_pptables_v1_0.c`; helpers +
  caller validation.
- [Phase 2] v6.18.53 `get_vddc_lookup_table`: allocates `max_levels`,
  iterates `ucNumEntries` — heap overflow confirmed.
- [Phase 2] `PP_ASSERT_WITH_CODE` in `pp_debug.h` always executes the
  failure `code`.
- [Phase 3] No Fixes tag. Parser present since Tonga PowerPlay v1; file
  moved in `e098bc9612c2b`.
- [Phase 3] Series: 1/3 Vega10, 2/3 this, 3/3 legacy PPLIB; this file
  does not need 1/3 or 3/3.
- [Phase 4] `b4 dig -c 53ef33c084c5778`: lore msgid
  `20260623134917.443011-2`; v2 of 2/3.
- [Phase 4] mbox: Asad and Kenneth “Series is Reviewed-by”; no NAK; v2
  PPM return handling.
- [Phase 4] WebFetch/curl to lore.kernel.org: 403. UNVERIFIED: stable@
  archives.
- [Phase 5] `pptable_v1_0_funcs` used from `smu7_init_function_pointers`
  for `PP_TABLE_V1`.
- [Phase 5] `pp_table` sysfs: `AMDGPU_DEVICE_ATTR_RW(..., S_IRUGO |
  S_IWUSR)`; `pp_dpm_set_pp_table()` replaces `soft_pp_table` and re-
  inits.
- [Phase 6] `git describe HEAD`: `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion`: 6.18.53.
- [Phase 6] `git merge-base --is-ancestor 53ef33c084c5778 HEAD` → not
  ancestor (upstream SHA not in this history).
- [Phase 6] Apply onto v6.18.53: fails on `kzalloc_obj` context;
  functional backport is still straightforward.
- [Phase 6] `pp_entries_max` not in v6.18.53; this commit is the
  voltage-lookup cap for this tree.
- [Phase 7/8] `hwmgr.c`: Tonga/Fiji/Polaris10/11/12/VegaM keep
  `PP_TABLE_V1` and call `smu7_init_function_pointers()`.
- [Phase 8] Failure mode: heap overflow / OOB read on PPTable parse —
  HIGH/CRITICAL if triggered.

**YES**

 .../powerplay/hwmgr/process_pptables_v1_0.c   | 606 +++++++++++++++---
 1 file changed, 521 insertions(+), 85 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
index 94c1e2c103703..78037edb4752c 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -150,6 +150,368 @@ static const void *get_powerplay_table(struct pp_hwmgr *hwmgr)
 	return table_address;
 }
 
+static bool tonga_pp_table_has_space(struct pp_hwmgr *hwmgr, size_t offset,
+				     size_t size)
+{
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	return offset <= table_size && size <= table_size - offset;
+}
+
+static int get_tonga_subtable(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		u16 table_offset, size_t table_size, const void **table)
+{
+	PP_ASSERT_WITH_CODE((table_offset != 0),
+			    "Invalid PowerPlay Table!", return -1);
+	PP_ASSERT_WITH_CODE((tonga_pp_table_has_space(hwmgr, table_offset,
+						      table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*table = (const void *)(((unsigned long)powerplay_table) + table_offset);
+
+	return 0;
+}
+
+static int validate_tonga_table_entries(struct pp_hwmgr *hwmgr,
+		u16 table_offset, size_t entries_offset,
+		u8 num_entries, size_t entry_size)
+{
+	size_t table_size;
+
+	PP_ASSERT_WITH_CODE((num_entries != 0),
+			    "Invalid PowerPlay Table!", return -1);
+
+	table_size = entries_offset + num_entries * entry_size;
+	PP_ASSERT_WITH_CODE((tonga_pp_table_has_space(hwmgr, table_offset,
+						      table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	return 0;
+}
+
+static int get_tonga_voltage_lookup_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		u16 table_offset, uint32_t max_levels,
+		const ATOM_Tonga_Voltage_Lookup_Table **lookup_table)
+{
+	const ATOM_Tonga_Voltage_Lookup_Table *table;
+	size_t table_size;
+	int ret;
+
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	PP_ASSERT_WITH_CODE((table->ucNumEntries != 0 &&
+			     table->ucNumEntries <= max_levels),
+			    "Invalid PowerPlay Table!", return -1);
+
+	table_size = offsetof(ATOM_Tonga_Voltage_Lookup_Table, entries) +
+		table->ucNumEntries * sizeof(ATOM_Tonga_Voltage_Lookup_Record);
+	PP_ASSERT_WITH_CODE((tonga_pp_table_has_space(hwmgr, table_offset,
+						      table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*lookup_table = table;
+
+	return 0;
+}
+
+static int get_tonga_mclk_dependency_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Tonga_MCLK_Dependency_Table **mclk_dep_table)
+{
+	const ATOM_Tonga_MCLK_Dependency_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usMclkDependencyTableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_tonga_table_entries(hwmgr, table_offset,
+					   offsetof(ATOM_Tonga_MCLK_Dependency_Table,
+						    entries),
+					   table->ucNumEntries,
+					   sizeof(ATOM_Tonga_MCLK_Dependency_Record));
+	if (ret)
+		return ret;
+
+	*mclk_dep_table = table;
+
+	return 0;
+}
+
+static int get_tonga_mm_dependency_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Tonga_MM_Dependency_Table **mm_dep_table)
+{
+	const ATOM_Tonga_MM_Dependency_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usMMDependencyTableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_tonga_table_entries(hwmgr, table_offset,
+					   offsetof(ATOM_Tonga_MM_Dependency_Table,
+						    entries),
+					   table->ucNumEntries,
+					   sizeof(ATOM_Tonga_MM_Dependency_Record));
+	if (ret)
+		return ret;
+
+	*mm_dep_table = table;
+
+	return 0;
+}
+
+static int get_tonga_sclk_dependency_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const PPTable_Generic_SubTable_Header **sclk_dep_table)
+{
+	const PPTable_Generic_SubTable_Header *header;
+	u16 table_offset;
+	size_t entries_offset;
+	size_t entry_size;
+	u8 num_entries;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usSclkDependencyTableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*header), (const void **)&header);
+	if (ret)
+		return ret;
+
+	if (header->ucRevId < 1) {
+		const ATOM_Tonga_SCLK_Dependency_Table *table =
+			(const ATOM_Tonga_SCLK_Dependency_Table *)header;
+
+		entries_offset = offsetof(ATOM_Tonga_SCLK_Dependency_Table, entries);
+		entry_size = sizeof(ATOM_Tonga_SCLK_Dependency_Record);
+		num_entries = table->ucNumEntries;
+	} else {
+		const ATOM_Polaris_SCLK_Dependency_Table *table =
+			(const ATOM_Polaris_SCLK_Dependency_Table *)header;
+
+		entries_offset = offsetof(ATOM_Polaris_SCLK_Dependency_Table, entries);
+		entry_size = sizeof(ATOM_Polaris_SCLK_Dependency_Record);
+		num_entries = table->ucNumEntries;
+	}
+
+	ret = validate_tonga_table_entries(hwmgr, table_offset, entries_offset,
+					   num_entries, entry_size);
+	if (ret)
+		return ret;
+
+	*sclk_dep_table = header;
+
+	return 0;
+}
+
+static int get_tonga_pcie_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const PPTable_Generic_SubTable_Header **pcie_table)
+{
+	const PPTable_Generic_SubTable_Header *header;
+	u16 table_offset;
+	size_t entries_offset;
+	size_t entry_size;
+	u8 num_entries;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usPCIETableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*header), (const void **)&header);
+	if (ret)
+		return ret;
+
+	if (header->ucRevId < 1) {
+		const ATOM_Tonga_PCIE_Table *table =
+			(const ATOM_Tonga_PCIE_Table *)header;
+
+		entries_offset = offsetof(ATOM_Tonga_PCIE_Table, entries);
+		entry_size = sizeof(ATOM_Tonga_PCIE_Record);
+		num_entries = table->ucNumEntries;
+	} else {
+		const ATOM_Polaris10_PCIE_Table *table =
+			(const ATOM_Polaris10_PCIE_Table *)header;
+
+		entries_offset = offsetof(ATOM_Polaris10_PCIE_Table, entries);
+		entry_size = sizeof(ATOM_Polaris10_PCIE_Record);
+		num_entries = table->ucNumEntries;
+	}
+
+	ret = validate_tonga_table_entries(hwmgr, table_offset, entries_offset,
+					   num_entries, entry_size);
+	if (ret)
+		return ret;
+
+	*pcie_table = header;
+
+	return 0;
+}
+
+static int get_tonga_hard_limit_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Tonga_Hard_Limit_Table **hard_limit_table)
+{
+	const ATOM_Tonga_Hard_Limit_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usHardLimitTableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_tonga_table_entries(hwmgr, table_offset,
+					   offsetof(ATOM_Tonga_Hard_Limit_Table,
+						    entries),
+					   table->ucNumEntries,
+					   sizeof(ATOM_Tonga_Hard_Limit_Record));
+	if (ret)
+		return ret;
+
+	*hard_limit_table = table;
+
+	return 0;
+}
+
+static int get_tonga_thermal_controller_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Tonga_Thermal_Controller **thermal_controller)
+{
+	u16 table_offset;
+
+	table_offset = le16_to_cpu(powerplay_table->usThermalControllerOffset);
+
+	return get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(**thermal_controller),
+				  (const void **)thermal_controller);
+}
+
+static int get_tonga_fan_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const PPTable_Generic_SubTable_Header **fan_table)
+{
+	const PPTable_Generic_SubTable_Header *header;
+	u16 table_offset;
+	size_t table_size;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usFanTableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*header), (const void **)&header);
+	if (ret)
+		return ret;
+
+	if (header->ucRevId < 8)
+		table_size = sizeof(ATOM_Tonga_Fan_Table);
+	else if (header->ucRevId == 8)
+		table_size = sizeof(ATOM_Fiji_Fan_Table);
+	else
+		table_size = sizeof(ATOM_Polaris_Fan_Table);
+
+	PP_ASSERT_WITH_CODE((tonga_pp_table_has_space(hwmgr, table_offset,
+						      table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*fan_table = header;
+
+	return 0;
+}
+
+static int get_tonga_power_tune_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const PPTable_Generic_SubTable_Header **power_tune_table)
+{
+	const PPTable_Generic_SubTable_Header *header;
+	u16 table_offset;
+	size_t table_size;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usPowerTuneTableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*header), (const void **)&header);
+	if (ret)
+		return ret;
+
+	if (header->ucRevId < 3)
+		table_size = sizeof(ATOM_Tonga_PowerTune_Table);
+	else if (header->ucRevId < 4)
+		table_size = sizeof(ATOM_Fiji_PowerTune_Table);
+	else
+		table_size = sizeof(ATOM_Polaris_PowerTune_Table);
+
+	PP_ASSERT_WITH_CODE((tonga_pp_table_has_space(hwmgr, table_offset,
+						      table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*power_tune_table = header;
+
+	return 0;
+}
+
+static int get_tonga_ppm_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Tonga_PPM_Table **ppm_table)
+{
+	u16 table_offset;
+
+	table_offset = le16_to_cpu(powerplay_table->usPPMTableOffset);
+
+	return get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(**ppm_table), (const void **)ppm_table);
+}
+
+static int get_tonga_gpio_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Tonga_GPIO_Table **gpio_table)
+{
+	u16 table_offset;
+
+	table_offset = le16_to_cpu(powerplay_table->usGPIOTableOffset);
+
+	return get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(**gpio_table), (const void **)gpio_table);
+}
+
+static int get_tonga_vce_state_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Tonga_VCE_State_Table **vce_state_table)
+{
+	const ATOM_Tonga_VCE_State_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usVCEStateTableOffset);
+	ret = get_tonga_subtable(hwmgr, powerplay_table, table_offset,
+				 sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_tonga_table_entries(hwmgr, table_offset,
+					   offsetof(ATOM_Tonga_VCE_State_Table,
+						    entries),
+					   table->ucNumEntries,
+					   sizeof(ATOM_Tonga_VCE_State_Record));
+	if (ret)
+		return ret;
+
+	*vce_state_table = table;
+
+	return 0;
+}
+
 static int get_vddc_lookup_table(
 		struct pp_hwmgr	*hwmgr,
 		phm_ppt_v1_voltage_lookup_table	**lookup_table,
@@ -198,7 +560,7 @@ static int get_vddc_lookup_table(
  */
 static int get_platform_power_management_table(
 		struct pp_hwmgr *hwmgr,
-		ATOM_Tonga_PPM_Table *atom_ppm_table)
+		const ATOM_Tonga_PPM_Table *atom_ppm_table)
 {
 	struct phm_ppm_table *ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
 	struct phm_ppt_v1_information *pp_table_information =
@@ -246,7 +608,7 @@ static int init_dpm_2_parameters(
 {
 	int result = 0;
 	struct phm_ppt_v1_information *pp_table_information = (struct phm_ppt_v1_information *)(hwmgr->pptable);
-	ATOM_Tonga_PPM_Table *atom_ppm_table;
+	const ATOM_Tonga_PPM_Table *atom_ppm_table;
 	uint32_t disable_ppm = 0;
 	uint32_t disable_power_control = 0;
 
@@ -275,30 +637,39 @@ static int init_dpm_2_parameters(
 	}
 
 	if (0 != powerplay_table->usVddcLookupTableOffset) {
-		const ATOM_Tonga_Voltage_Lookup_Table *pVddcCACTable =
-			(ATOM_Tonga_Voltage_Lookup_Table *)(((unsigned long)powerplay_table) +
-			le16_to_cpu(powerplay_table->usVddcLookupTableOffset));
-
-		result = get_vddc_lookup_table(hwmgr,
-			&pp_table_information->vddc_lookup_table, pVddcCACTable, 16);
+		const ATOM_Tonga_Voltage_Lookup_Table *pVddcCACTable;
+
+		result = get_tonga_voltage_lookup_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usVddcLookupTableOffset),
+				16, &pVddcCACTable);
+		if (!result)
+			result = get_vddc_lookup_table(hwmgr,
+				&pp_table_information->vddc_lookup_table,
+				pVddcCACTable, 16);
 	}
 
-	if (0 != powerplay_table->usVddgfxLookupTableOffset) {
-		const ATOM_Tonga_Voltage_Lookup_Table *pVddgfxCACTable =
-			(ATOM_Tonga_Voltage_Lookup_Table *)(((unsigned long)powerplay_table) +
-			le16_to_cpu(powerplay_table->usVddgfxLookupTableOffset));
+	if (!result && 0 != powerplay_table->usVddgfxLookupTableOffset) {
+		const ATOM_Tonga_Voltage_Lookup_Table *pVddgfxCACTable;
 
-		result = get_vddc_lookup_table(hwmgr,
-			&pp_table_information->vddgfx_lookup_table, pVddgfxCACTable, 16);
+		result = get_tonga_voltage_lookup_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usVddgfxLookupTableOffset),
+				16, &pVddgfxCACTable);
+		if (!result)
+			result = get_vddc_lookup_table(hwmgr,
+				&pp_table_information->vddgfx_lookup_table,
+				pVddgfxCACTable, 16);
 	}
 
 	disable_ppm = 0;
 	if (0 == disable_ppm) {
-		atom_ppm_table = (ATOM_Tonga_PPM_Table *)
-			(((unsigned long)powerplay_table) + le16_to_cpu(powerplay_table->usPPMTableOffset));
-
 		if (0 != powerplay_table->usPPMTableOffset) {
-			if (get_platform_power_management_table(hwmgr, atom_ppm_table) == 0) {
+			int ret;
+
+			ret = get_tonga_ppm_table(hwmgr, powerplay_table,
+						  &atom_ppm_table);
+			if (!ret &&
+			    get_platform_power_management_table(hwmgr,
+							       atom_ppm_table) == 0) {
 				phm_cap_set(hwmgr->platform_descriptor.platformCaps,
 					PHM_PlatformCaps_EnablePlatformPowerManagement);
 			}
@@ -792,28 +1163,13 @@ static int init_clock_voltage_dependency(
 	int result = 0;
 	struct phm_ppt_v1_information *pp_table_information =
 		(struct phm_ppt_v1_information *)(hwmgr->pptable);
-
-	const ATOM_Tonga_MM_Dependency_Table *mm_dependency_table =
-		(const ATOM_Tonga_MM_Dependency_Table *)(((unsigned long) powerplay_table) +
-		le16_to_cpu(powerplay_table->usMMDependencyTableOffset));
-	const PPTable_Generic_SubTable_Header *pPowerTuneTable =
-		(const PPTable_Generic_SubTable_Header *)(((unsigned long) powerplay_table) +
-		le16_to_cpu(powerplay_table->usPowerTuneTableOffset));
-	const ATOM_Tonga_MCLK_Dependency_Table *mclk_dep_table =
-		(const ATOM_Tonga_MCLK_Dependency_Table *)(((unsigned long) powerplay_table) +
-		le16_to_cpu(powerplay_table->usMclkDependencyTableOffset));
-	const PPTable_Generic_SubTable_Header *sclk_dep_table =
-		(const PPTable_Generic_SubTable_Header *)(((unsigned long) powerplay_table) +
-		le16_to_cpu(powerplay_table->usSclkDependencyTableOffset));
-	const ATOM_Tonga_Hard_Limit_Table *pHardLimits =
-		(const ATOM_Tonga_Hard_Limit_Table *)(((unsigned long) powerplay_table) +
-		le16_to_cpu(powerplay_table->usHardLimitTableOffset));
-	const PPTable_Generic_SubTable_Header *pcie_table =
-		(const PPTable_Generic_SubTable_Header *)(((unsigned long) powerplay_table) +
-		le16_to_cpu(powerplay_table->usPCIETableOffset));
-	const ATOM_Tonga_GPIO_Table *gpio_table =
-		(const ATOM_Tonga_GPIO_Table *)(((unsigned long) powerplay_table) +
-		le16_to_cpu(powerplay_table->usGPIOTableOffset));
+	const ATOM_Tonga_MM_Dependency_Table *mm_dependency_table;
+	const PPTable_Generic_SubTable_Header *pPowerTuneTable;
+	const ATOM_Tonga_MCLK_Dependency_Table *mclk_dep_table;
+	const PPTable_Generic_SubTable_Header *sclk_dep_table;
+	const ATOM_Tonga_Hard_Limit_Table *pHardLimits;
+	const PPTable_Generic_SubTable_Header *pcie_table;
+	const ATOM_Tonga_GPIO_Table *gpio_table;
 
 	pp_table_information->vdd_dep_on_sclk = NULL;
 	pp_table_information->vdd_dep_on_mclk = NULL;
@@ -821,29 +1177,58 @@ static int init_clock_voltage_dependency(
 	pp_table_information->pcie_table = NULL;
 	pp_table_information->gpio_table = NULL;
 
-	if (powerplay_table->usMMDependencyTableOffset != 0)
-		result = get_mm_clock_voltage_table(hwmgr,
-		&pp_table_information->mm_dep_table, mm_dependency_table);
+	if (powerplay_table->usMMDependencyTableOffset != 0) {
+		result = get_tonga_mm_dependency_table(hwmgr, powerplay_table,
+						       &mm_dependency_table);
+		if (!result)
+			result = get_mm_clock_voltage_table(hwmgr,
+				&pp_table_information->mm_dep_table,
+				mm_dependency_table);
+	}
 
-	if (result == 0 && powerplay_table->usPowerTuneTableOffset != 0)
-		result = get_cac_tdp_table(hwmgr,
-		&pp_table_information->cac_dtp_table, pPowerTuneTable);
+	if (result == 0 && powerplay_table->usPowerTuneTableOffset != 0) {
+		result = get_tonga_power_tune_table(hwmgr, powerplay_table,
+						    &pPowerTuneTable);
+		if (!result)
+			result = get_cac_tdp_table(hwmgr,
+				&pp_table_information->cac_dtp_table,
+				pPowerTuneTable);
+	}
 
-	if (result == 0 && powerplay_table->usSclkDependencyTableOffset != 0)
-		result = get_sclk_voltage_dependency_table(hwmgr,
-		&pp_table_information->vdd_dep_on_sclk, sclk_dep_table);
+	if (result == 0 && powerplay_table->usSclkDependencyTableOffset != 0) {
+		result = get_tonga_sclk_dependency_table(hwmgr, powerplay_table,
+							 &sclk_dep_table);
+		if (!result)
+			result = get_sclk_voltage_dependency_table(hwmgr,
+				&pp_table_information->vdd_dep_on_sclk,
+				sclk_dep_table);
+	}
 
-	if (result == 0 && powerplay_table->usMclkDependencyTableOffset != 0)
-		result = get_mclk_voltage_dependency_table(hwmgr,
-		&pp_table_information->vdd_dep_on_mclk, mclk_dep_table);
+	if (result == 0 && powerplay_table->usMclkDependencyTableOffset != 0) {
+		result = get_tonga_mclk_dependency_table(hwmgr, powerplay_table,
+							 &mclk_dep_table);
+		if (!result)
+			result = get_mclk_voltage_dependency_table(hwmgr,
+				&pp_table_information->vdd_dep_on_mclk,
+				mclk_dep_table);
+	}
 
-	if (result == 0 && powerplay_table->usPCIETableOffset != 0)
-		result = get_pcie_table(hwmgr,
-		&pp_table_information->pcie_table, pcie_table);
+	if (result == 0 && powerplay_table->usPCIETableOffset != 0) {
+		result = get_tonga_pcie_table(hwmgr, powerplay_table,
+					      &pcie_table);
+		if (!result)
+			result = get_pcie_table(hwmgr,
+				&pp_table_information->pcie_table, pcie_table);
+	}
 
-	if (result == 0 && powerplay_table->usHardLimitTableOffset != 0)
-		result = get_hard_limits(hwmgr,
-		&pp_table_information->max_clock_voltage_on_dc, pHardLimits);
+	if (result == 0 && powerplay_table->usHardLimitTableOffset != 0) {
+		result = get_tonga_hard_limit_table(hwmgr, powerplay_table,
+						    &pHardLimits);
+		if (!result)
+			result = get_hard_limits(hwmgr,
+				&pp_table_information->max_clock_voltage_on_dc,
+				pHardLimits);
+	}
 
 	hwmgr->dyn_state.max_clock_voltage_on_dc.sclk =
 		pp_table_information->max_clock_voltage_on_dc.sclk;
@@ -864,9 +1249,13 @@ static int init_clock_voltage_dependency(
 		result = get_valid_clk(hwmgr, &pp_table_information->valid_sclk_values,
 		pp_table_information->vdd_dep_on_sclk);
 
-	if (!result && gpio_table)
-		result = get_gpio_table(hwmgr, &pp_table_information->gpio_table,
-				gpio_table);
+	if (!result && powerplay_table->usGPIOTableOffset) {
+		result = get_tonga_gpio_table(hwmgr, powerplay_table,
+					      &gpio_table);
+		if (!result)
+			result = get_gpio_table(hwmgr,
+				&pp_table_information->gpio_table, gpio_table);
+	}
 
 	return result;
 }
@@ -911,14 +1300,17 @@ static int init_thermal_controller(
 		)
 {
 	const PPTable_Generic_SubTable_Header *fan_table;
-	ATOM_Tonga_Thermal_Controller *thermal_controller;
+	const ATOM_Tonga_Thermal_Controller *thermal_controller;
+	int ret;
 
-	thermal_controller = (ATOM_Tonga_Thermal_Controller *)
-		(((unsigned long)powerplay_table) +
-		le16_to_cpu(powerplay_table->usThermalControllerOffset));
 	PP_ASSERT_WITH_CODE((0 != powerplay_table->usThermalControllerOffset),
 		"Thermal controller table not set!", return -1);
 
+	ret = get_tonga_thermal_controller_table(hwmgr, powerplay_table,
+						 &thermal_controller);
+	if (ret)
+		return ret;
+
 	hwmgr->thermal_controller.ucType = thermal_controller->ucType;
 	hwmgr->thermal_controller.ucI2cLine = thermal_controller->ucI2cLine;
 	hwmgr->thermal_controller.ucI2cAddress = thermal_controller->ucI2cAddress;
@@ -946,12 +1338,13 @@ static int init_thermal_controller(
 		return 0;
 	}
 
-	fan_table = (const PPTable_Generic_SubTable_Header *)
-		(((unsigned long)powerplay_table) +
-		le16_to_cpu(powerplay_table->usFanTableOffset));
-
 	PP_ASSERT_WITH_CODE((0 != powerplay_table->usFanTableOffset),
 		"Fan table not set!", return -1);
+
+	ret = get_tonga_fan_table(hwmgr, powerplay_table, &fan_table);
+	if (ret)
+		return ret;
+
 	PP_ASSERT_WITH_CODE((0 < fan_table->ucRevId),
 		"Unsupported fan table format!", return -1);
 
@@ -1313,13 +1706,15 @@ static int ppt_get_num_of_vce_state_table_entries_v1_0(struct pp_hwmgr *hwmgr)
 {
 	const ATOM_Tonga_POWERPLAYTABLE *pp_table = get_powerplay_table(hwmgr);
 	const ATOM_Tonga_VCE_State_Table *vce_state_table;
+	int ret;
 
 
 	if (pp_table == NULL)
 		return 0;
 
-	vce_state_table = (void *)pp_table +
-			le16_to_cpu(pp_table->usVCEStateTableOffset);
+	ret = get_tonga_vce_state_table(hwmgr, pp_table, &vce_state_table);
+	if (ret)
+		return 0;
 
 	return vce_state_table->ucNumEntries;
 }
@@ -1328,18 +1723,39 @@ static int ppt_get_vce_state_table_entry_v1_0(struct pp_hwmgr *hwmgr, uint32_t i
 		struct amd_vce_state *vce_state, void **clock_info, uint32_t *flag)
 {
 	const ATOM_Tonga_VCE_State_Record *vce_state_record;
-	ATOM_Tonga_SCLK_Dependency_Record *sclk_dep_record;
+	ATOM_Tonga_SCLK_Dependency_Record *sclk_dep_record = NULL;
+	ATOM_Polaris_SCLK_Dependency_Record *polaris_sclk_dep_record = NULL;
 	ATOM_Tonga_MCLK_Dependency_Record *mclk_dep_record;
 	ATOM_Tonga_MM_Dependency_Record *mm_dep_record;
 	const ATOM_Tonga_POWERPLAYTABLE *pptable = get_powerplay_table(hwmgr);
-	const ATOM_Tonga_VCE_State_Table *vce_state_table = (ATOM_Tonga_VCE_State_Table *)(((unsigned long)pptable)
-							  + le16_to_cpu(pptable->usVCEStateTableOffset));
-	const ATOM_Tonga_SCLK_Dependency_Table *sclk_dep_table = (ATOM_Tonga_SCLK_Dependency_Table *)(((unsigned long)pptable)
-							  + le16_to_cpu(pptable->usSclkDependencyTableOffset));
-	const ATOM_Tonga_MCLK_Dependency_Table *mclk_dep_table = (ATOM_Tonga_MCLK_Dependency_Table *)(((unsigned long)pptable)
-							  + le16_to_cpu(pptable->usMclkDependencyTableOffset));
-	const ATOM_Tonga_MM_Dependency_Table *mm_dep_table = (ATOM_Tonga_MM_Dependency_Table *)(((unsigned long)pptable)
-							  + le16_to_cpu(pptable->usMMDependencyTableOffset));
+	const ATOM_Tonga_VCE_State_Table *vce_state_table;
+	const PPTable_Generic_SubTable_Header *sclk_dep_table_header;
+	const ATOM_Tonga_SCLK_Dependency_Table *sclk_dep_table;
+	const ATOM_Tonga_MCLK_Dependency_Table *mclk_dep_table;
+	const ATOM_Tonga_MM_Dependency_Table *mm_dep_table;
+	int ret;
+
+	if (!pptable)
+		return -EINVAL;
+
+	ret = get_tonga_vce_state_table(hwmgr, pptable, &vce_state_table);
+	if (ret)
+		return ret;
+
+	ret = get_tonga_sclk_dependency_table(hwmgr, pptable,
+					      &sclk_dep_table_header);
+	if (ret)
+		return ret;
+	sclk_dep_table = (const ATOM_Tonga_SCLK_Dependency_Table *)
+		sclk_dep_table_header;
+
+	ret = get_tonga_mclk_dependency_table(hwmgr, pptable, &mclk_dep_table);
+	if (ret)
+		return ret;
+
+	ret = get_tonga_mm_dependency_table(hwmgr, pptable, &mm_dep_table);
+	if (ret)
+		return ret;
 
 	PP_ASSERT_WITH_CODE((i < vce_state_table->ucNumEntries),
 			 "Requested state entry ID is out of range!",
@@ -1348,10 +1764,27 @@ static int ppt_get_vce_state_table_entry_v1_0(struct pp_hwmgr *hwmgr, uint32_t i
 	vce_state_record = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
 					ATOM_Tonga_VCE_State_Record,
 					entries, vce_state_table, i);
-	sclk_dep_record = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
-					ATOM_Tonga_SCLK_Dependency_Record,
-					entries, sclk_dep_table,
-					vce_state_record->ucSCLKIndex);
+	PP_ASSERT_WITH_CODE((vce_state_record->ucSCLKIndex <
+			     sclk_dep_table->ucNumEntries),
+			    "Invalid PowerPlay Table!", return -EINVAL);
+	PP_ASSERT_WITH_CODE((vce_state_record->ucVCEClockIndex <
+			     mm_dep_table->ucNumEntries),
+			    "Invalid PowerPlay Table!", return -EINVAL);
+	PP_ASSERT_WITH_CODE((mclk_dep_table->ucNumEntries != 0),
+			    "Invalid PowerPlay Table!", return -EINVAL);
+
+	if (sclk_dep_table_header->ucRevId < 1)
+		sclk_dep_record = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
+						ATOM_Tonga_SCLK_Dependency_Record,
+						entries, sclk_dep_table,
+						vce_state_record->ucSCLKIndex);
+	else
+		polaris_sclk_dep_record = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
+						ATOM_Polaris_SCLK_Dependency_Record,
+						entries,
+						(ATOM_Polaris_SCLK_Dependency_Table *)
+						sclk_dep_table_header,
+						vce_state_record->ucSCLKIndex);
 	mm_dep_record = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
 					ATOM_Tonga_MM_Dependency_Record,
 					entries, mm_dep_table,
@@ -1360,7 +1793,10 @@ static int ppt_get_vce_state_table_entry_v1_0(struct pp_hwmgr *hwmgr, uint32_t i
 
 	vce_state->evclk = le32_to_cpu(mm_dep_record->ulEClk);
 	vce_state->ecclk = le32_to_cpu(mm_dep_record->ulEClk);
-	vce_state->sclk = le32_to_cpu(sclk_dep_record->ulSclk);
+	if (sclk_dep_record)
+		vce_state->sclk = le32_to_cpu(sclk_dep_record->ulSclk);
+	else
+		vce_state->sclk = le32_to_cpu(polaris_sclk_dep_record->ulSclk);
 
 	if (vce_state_record->ucMCLKIndex >= mclk_dep_table->ucNumEntries)
 		mclk_dep_record = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
-- 
2.53.0

