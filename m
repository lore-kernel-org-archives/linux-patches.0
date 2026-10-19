Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA9162045C;
	Mon, 19 Oct 2026 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418688; cv=none; b=puX3CifIW1jJhQ4bnAUtN9ypB+5Ixm2P+v/kOjSzHpzXHppgBqaZGiRPukQTqspV2Tu419e0yGODRqOx69Qsg47P2WMINb77gxjQScrYzr6tfMzdkS62TXF8NmBeYi5Y/3SOrsxzari1GomQVR9Jryd6Q3ZiNOOdlBlI34LLN5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418688; c=relaxed/simple;
	bh=KdA9561FDaAktrAwCYGgaOwdlX+FTgvNK3jPw9Cwayw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/3G6QDF/C8HqsaCQlaLAxw6h+Yl07itsnNRP4XCbN2seJRLHn2FhDOzthBk9GGbhibhziBdC7pQdmZD6RPjZLe3FDrNGz/zP7oZv49jRhyYd5pwyAef12sRb586o3ujFZxiwdhEHSQoJ9nfJPKaldqiPP5LwpwOs7J1mf9JKsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onZWBroj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onZWBroj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444881F000CB;
	Mon, 19 Oct 2026 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418684;
	bh=qvbp8f2w9chI37b/MVBFR5OrAMzeWq0Ca+d/8PVVkew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onZWBroj4DATtTVx9lISZyZ/gs3gHXZfO/W4KfTi7azoynNJNsnxQY5u/1cwmG//2
	 jk5zfqcUeIpdTRU5b5Jn8dJtQu+G6eGSGkNCX+65JEHV6pqrgurKfs2AOlg2g5fZAz
	 IWohzr1GXr08r/5cTMoYzpkcoTStDk4dxDCKOaokWUiAKTJYNo0JMedMWRF1OHqrDl
	 3t9XHMS91e4LcxvAJSy74uxeg7QH79fL98sKmvqdWMRgj1ncJSgXKYTrS6v6AWFTAs
	 Au6f96yafjTCIbZa8sqv4Yx0Z2VkQWKDwsR+Yrzid1BpqfkQAF5SDibRJ2e2ha5Wl6
	 K2GGzqj6sNhAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xiang Liu <xiang.liu@amd.com>,
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
Subject: [PATCH AUTOSEL 6.18-5.15] drm/amd/pm: Guard VBIOS AC timing table walk
Date: Mon, 19 Oct 2026 09:51:54 -0400
Message-ID: <20261019135441.1420968-423-sashal@kernel.org>
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

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 2bf6867e5953a140fc91c3159987656e44ed29fb ]

Reject AC timing blocks with a stride smaller than a dword before walking
VBIOS data. A zero stride can otherwise keep reg_data pinned on a
nonmatching MEM_ID forever.

Also bound the data-block and END marker reads by the returned VRAM_Info
table size so malformed index/data sizes do not push the timing walk past
the table.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[drm/amd/pm] [Guard] Reject undersized VBIOS AC timing strides
and bound the table walk`

Subsystem `drm/amd/pm`. Verb is **Guard** (defensive bounds / hang
prevention), not a feature addition.

**Step 1.2: Tags**
Record:
- `Signed-off-by: Xiang Liu <xiang.liu@amd.com>` (author)
- `Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>` (AMD reviewer)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable`
  (absence is expected for this review)
- Pipeline markers (`[ Upstream commit 2bf6867e5953... ]`, `Signed-off-
  by: Sasha Levin`) ignored per instructions

**Step 1.3: Body**
Record:
- **Bug:** `atomctrl_retrieve_ac_timing()` walks VBIOS AC timing blocks
  using `usRegDataBlkSize` as the stride. A zero (or sub-dword) stride
  never advances `reg_data`. If the pinned dword’s MEM_ID does not match
  `index`, `num_ranges` never increases, so the
  `VBIOS_MAX_AC_TIMING_ENTRIES` cap never fires.
- **Symptom:** infinite loop / hang during GPU powerplay init.
- **Second bug:** index/data sizes can walk past the VRAM_Info table;
  unbounded dword reads of the END marker and per-entry payload.
- **Root cause:** firmware table walk trusts VBIOS sizes with no stride
  or table-end check.
- **Version info:** none in the message. Code has been in-tree since
  v4.5.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. It is an explicit hang + OOB hardening of a firmware
parser. “Guard” here means missing validation, not a cleanup.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c` — **+22 /
  −6**
- Functions: `atomctrl_retrieve_ac_timing`,
  `atomctrl_initialize_mc_reg_table`,
  `atomctrl_initialize_mc_reg_table_v2_2`
- Scope: single-file surgical fix

**Step 2.2: Code flow**
Record:
1. `atomctrl_retrieve_ac_timing`: cache `stride =
   le16_to_cpu(usRegDataBlkSize)`; **before:** walk with raw stride;
   **after:** `-EINVAL` if `stride < 4`.
2. Loop: **before:** `while (*(u32 *)reg_data != END && num_ranges <
   20)`; **after:** also require `(u8 *)reg_data + 4 <= table_end`
   before the read.
3. Inner `DATA_FROM_TABLE` copies: **before:** unbounded `*((u32
   *)reg_data + j)`; **after:** reject if that dword would pass
   `table_end`.
4. Advance: same addition, using cached `stride`.
5. Exit: **before:** `PP_ASSERT_WITH_CODE` that the current dword is
   `END_OF_REG_DATA_BLOCK` (0), which itself can read past the table;
   **after:** bounds-check then compare, return `-EINVAL`.
6. Callers: both init helpers already have `size` from
   `smu_atom_get_data_table()` but unused for the walk; they now set
   `table_end = (u8 *)vram_info + size` and pass it in.

**Step 2.3: Bug mechanism**
Record:
- **Category:** logic / memory-safety (infinite loop + OOB read)
- **Mechanism:** stride 0 pins `reg_data`. `END_OF_REG_DATA_BLOCK` is
  `0x00000000`. If that dword is nonzero and MEM_ID ≠ `index`, the loop
  never terminates. Large stride or oversized index table walks off the
  claimed VRAM_Info blob into adjacent BIOS/kernel memory.

**Step 2.4: Fix quality**
Record: Obviously correct C short-circuit bounds checks. Minimal. No API
change (`atomctrl_retrieve_ac_timing` is static). Regression risk is
low: a valid AC block must be at least one dword (MEM_ID + clock).
`table_end` uses the ATOM header size already returned to these
functions. Residual gap: `atomctrl_set_mc_reg_address_table()` and
`usMemClkPatchTblOffset` are still unchecked; sibling parsers in
`amdgpu_atombios.c` / `radeon_atombios.c` still have the old walk. That
does not make this patch incorrect.

## Phase 3: Git history

**Step 3.1: Blame**
Record: Unbounded walk introduced in `c82baa2818435`
(“drm/amd/powerplay: add Tonga dpm support (v3)”, 2015-12-21), first in
**v4.5-rc1**. Present on this 6.18 tree. Only later touch of the same
loop: `12c6967428a09` (2024) added `if (i)` for `DATA_EQU_PREV` OOB on
`mc_data[-1]`, not this stride/end-marker bug.

**Step 3.2: Fixes: tag**
Record: None. Buggy code is the original 2015 parser, not a recent
regression.

**Step 3.3: File history**
Record: Recent related work on this file: NULL checks in
`atomctrl_initialize_mc_reg_table` (`820116a39f96b`, already in
v6.18.53). No prerequisite refactor. No “patch X/Y”. Standalone.

**Step 3.4: Author**
Record: Xiang Liu is an AMD drm/amdgpu contributor (many amdgpu
commits). Hawking Zhang reviewed; Alex Deucher applied. Not a drive-by.

**Step 3.5: Dependencies**
Record: None. Uses existing `smu_atom_get_data_table(..., &size, ...)`,
existing structs, no new helpers. Applies standalone.

## Phase 4: Mailing list

**Step 4.1:** `b4 dig -c 2bf6867e5953a140fc91c3159987656e44ed29fb`
Record: lore URL
`https://patch.msgid.link/20260623042601.562748-1-xiang.liu@amd.com`.
**v1 only** (no v2/v3). Thread: patch + Hawking `Reviewed-by`. No NAK,
no stable debate, no requested rework. Direct WebFetch of
lore.kernel.org returned **403**; thread recovered via `b4 dig -m`.

**Step 4.2:** `b4 dig -w`
Record: To `amd-gfx@lists.freedesktop.org`; Cc Hawking Zhang, Tao Zhou,
Stanley Yang, YiPeng Chai. Right list and AMD PM reviewers.

**Step 4.3: Bug report**
Record: No `Reported-by` / syzbot / bugzilla. Author-described defect
from code inspection. Unverified whether a specific card hung in the
wild.

**Step 4.4: Series**
Record: Single standalone `[PATCH]`, not N/M.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable WebFetch 403. **UNVERIFIED** whether
stable@ already discussed this; that does not change the technical
verdict.

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `atomctrl_retrieve_ac_timing`,
`atomctrl_initialize_mc_reg_table`,
`atomctrl_initialize_mc_reg_table_v2_2`.

**Step 5.2: Callers**
Record:
- `tonga_initialize_mc_reg_table` → `atomctrl_initialize_mc_reg_table`
- `iceland_initialize_mc_reg_table` → same
- `ci_initialize_mc_reg_table` → same
- `polaris10_initialize_mc_reg_table` →
  `atomctrl_initialize_mc_reg_table_v2_2`
- Those are `.initialize_mc_reg_table` in SMU7 smumgr;
  `smum_initialize_mc_reg_table()` is called from `smu7_hwmgr.c` during
  DPM enable (device init / resume), **without checking the return
  value**.

**Step 5.3: Callees**
Record: `smu_atom_get_data_table()` → `amdgpu_atom_parse_data_header()`;
pointer is `atom_context->bios + data_start`; `size` is the ATOM table
size.

**Step 5.4: Reachability**
Record: Yes, from normal amdgpu load on CI / Tonga / Iceland / Polaris
(RX 400/500-class, still common). Not a syscall fuzzer path; firmware-
driven probe/resume. Unprivileged users cannot craft VBIOS on a locked
ROM, but custom/modded Polaris VBIOS is common, and a bad image hangs
the kernel in this loop.

**Step 5.5: Similar patterns**
Record: Same unguarded walk remains in
`amdgpu_atombios_init_mc_reg_table()` and `radeon_atombios.c`. This
commit only hardens the powerplay copy. Sibling bugs are not a reason to
reject this fix.

## Phase 6: This tree (6.18.53)

**Step 6.1:**
Record: Local tree is **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`,
branch `autosel`).
`git merge-base --is-ancestor 2bf6867e5953... v6.18.53` → **not an
ancestor**.
v6.18.53 still has the unguarded `while (*(uint32_t *)reg_data !=
END_OF_REG_DATA_BLOCK && ...)` in `atomctrl_retrieve_ac_timing()`. Bug
exists here.

**Step 6.2:**
Record: `git apply --check` of the upstream diff onto a v6.18.53 copy of
the file **succeeded** (exit 0). Clean apply. No structural drift.

**Step 6.3:**
Record: `12c6967428a09` and `820116a39f96b` are in v6.18.53; they do not
implement stride/table_end guards. No alternate fix present.

## Phase 7: Subsystem

**Step 7.1:**
Record: `drivers/gpu/drm/amd/pm/powerplay` — **IMPORTANT** (legacy GCN
powerplay, not core mm/net, but production GPU init).

**Step 7.2:**
Record: File is mature (2015). Little recent churn besides docs, a NULL
check, and the 2024 `mc_data[i-1]` guard. Long-lived bug, not a new-
subsystem issue.

## Phase 8: Impact and risk

**Step 8.1:** Driver-specific: CI/Tonga/Iceland/Polaris via powerplay
(`CONFIG_DRM_AMDGPU`, typically `DRM_AMDGPU_CIK` for CI). Polaris is
still widely deployed.

**Step 8.2:** Trigger: GPU DPM bring-up when VRAM_Info AC timing has
`usRegDataBlkSize < 4` or truncated/malformed blocks. Common on
**valid** VBIOS: no. Realistic on corrupted, truncated, or vendor-modded
VBIOS: yes. Not a userspace syscall primitive.

**Step 8.3:** Failure mode:
- Zero stride + nonmatching MEM_ID → **infinite loop in probe/resume** →
  **CRITICAL** hang
- Walk past table → **OOB read** → **HIGH** (crash / KASAN)

**Step 8.4:** Benefit: prevent hang/OOB on a long-lived parser used at
init. Risk: ~22 lines, error-path only for bad firmware. Valid tables
keep working. Ratio is favorable.

Ignored `smum_initialize_mc_reg_table()` return means a now-failing
parse no longer hangs; MC timing table may stay empty. That is still
better than a soft lockup, and matches other `-EINVAL` paths already in
these helpers.

## Phase 9: Synthesis

**For:**
- Real hang (zero stride) and real OOB (unbounded VBIOS walk)
- Code present since v4.5; **present and unfixed in this 6.18.53 tree**
- Small, obviously correct, no new API
- Maintainer SOB + AMD review; v1 accepted as-is
- Clean apply to this tree; no prerequisites
- Polar / CI powerplay still used here

**Against:**
- No public reproducer / syzbot / CVE
- Trigger is malformed firmware, not every boot
- Sibling parsers not fixed in the same patch
- `usMemClkPatchTblOffset` still unchecked (pre-existing)

**Unresolved:** stable@ discussion (lore 403); whether a specific
customer VBIOS hit this.

**Stable rules:**
1. Obviously correct and tested — **PASS** (reviewed, merged, logic is
   local bounds checks)
2. Real bug affecting users — **PASS** (hang/OOB on bad VBIOS; Polaris
   custom BIOS is a real population)
3. Important (crash/hang) — **PASS** (infinite loop in GPU init)
4. Small and contained — **PASS** (22/6, one file)
5. No new features/APIs — **PASS**
6. Applies to this tree — **PASS** (clean on v6.18.53)

**Exception category:** not a device-ID/quirk/DT/build/doc exception. It
is a firmware-parser safety fix.

This meets stable rules for **this** 6.18.y tree: the buggy walk is
here, the fix is surgical, and the failure mode is a hang or OOB during
amdgpu powerplay init.

### What it solves for stable users

On CI/Tonga/Iceland/Polaris, powerplay walks the VBIOS AC timing table
with a stride taken from the image. A zero stride can spin forever; a
bad size can read past the table. The patch rejects sub-dword strides
and caps every dword access by the ATOM-reported VRAM_Info size, turning
a probe hang/OOB into `-EINVAL`.

### Risk vs benefit

Benefit is avoiding a hard-to-debug init hang and OOB on firmware that
is already treated as untrusted input. Risk is a few bounds checks on an
error path; valid VBIOS is unchanged. Residual unfixed copies elsewhere
do not block this backport.

### Concerns

No `Fixes:` lineage; leftover unbounded walks in
`atomctrl_set_mc_reg_address_table` and `amdgpu_atombios.c`. Neither is
a dependency of this patch. Apply to 6.18.53 is clean.

Verification:
- [Phase 1] Parsed tags: author Xiang Liu, R-b Hawking Zhang, SOB Alex
  Deucher; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +22/−6 in `ppatomctrl.c`; stride `< sizeof(u32)`
  reject; `table_end` on loop, payload, END marker
- [Phase 2] `END_OF_REG_DATA_BLOCK` is `0x00000000` in
  `atombios.h:7486`; zero stride + nonzero nonmatching MEM_ID loops
  forever
- [Phase 3] `git blame` on v6.18.53: walk from `c82baa2818435`
  (v4.5-rc1)
- [Phase 3] `git merge-base --is-ancestor 2bf6867e5953 v6.18.53` → not
  present in 6.18.53
- [Phase 3] `12c6967428a09` / `820116a39f96b` do not implement this
  guard; latter is already in 6.18.53
- [Phase 4] `b4 dig -c 2bf6867e5953`: v1 only,
  https://patch.msgid.link/20260623042601.562748-1-xiang.liu@amd.com
- [Phase 4] `b4 dig -a`: single revision; `b4 dig -w`: amd-gfx + AMD
  reviewers; mbox: Hawking Reviewed-by, no NAK
- [Phase 4] WebFetch lore/stable: 403 — UNVERIFIED stable-list history
- [Phase 5] Callers: tonga/iceland/ci + polaris10 smumgr →
  `smum_initialize_mc_reg_table` from `smu7_hwmgr.c:1582` (return
  ignored)
- [Phase 5] Same pattern still in `amdgpu_atombios.c:1511` and
  `radeon_atombios.c:4031`
- [Phase 6] `make kernelversion` / `git describe`: 6.18.53; pre-image
  matches; apply --check on v6.18.53 copy exit 0
- [Phase 8] Failure: infinite loop or OOB at GPU DPM init; severity
  hang/crash
- UNVERIFIED: whether a specific shipping VBIOS has been observed with
  stride 0

**YES**

 .../drm/amd/pm/powerplay/hwmgr/ppatomctrl.c   | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 1fff7567bca27..4b796d60b03d4 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -46,16 +46,22 @@ union voltage_object_info {
 static int atomctrl_retrieve_ac_timing(
 		uint8_t index,
 		ATOM_INIT_REG_BLOCK *reg_block,
+		u8 *table_end,
 		pp_atomctrl_mc_reg_table *table)
 {
 	uint32_t i, j;
+	u16 stride = le16_to_cpu(reg_block->usRegDataBlkSize);
 	uint8_t tmem_id;
 	ATOM_MEMORY_SETTING_DATA_BLOCK *reg_data = (ATOM_MEMORY_SETTING_DATA_BLOCK *)
 		((uint8_t *)reg_block + (2 * sizeof(uint16_t)) + le16_to_cpu(reg_block->usRegIndexTblSize));
 
 	uint8_t num_ranges = 0;
 
-	while (*(uint32_t *)reg_data != END_OF_REG_DATA_BLOCK &&
+	if (stride < sizeof(uint32_t))
+		return -EINVAL;
+
+	while ((uint8_t *)reg_data + sizeof(uint32_t) <= table_end &&
+	       *(uint32_t *)reg_data != END_OF_REG_DATA_BLOCK &&
 			num_ranges < VBIOS_MAX_AC_TIMING_ENTRIES) {
 		tmem_id = (uint8_t)((*(uint32_t *)reg_data & MEM_ID_MASK) >> MEM_ID_SHIFT);
 
@@ -67,6 +73,10 @@ static int atomctrl_retrieve_ac_timing(
 			for (i = 0, j = 1; i < table->last; i++) {
 				if ((table->mc_reg_address[i].uc_pre_reg_data &
 							LOW_NIBBLE_MASK) == DATA_FROM_TABLE) {
+					if ((uint8_t *)reg_data +
+					    (j + 1) * sizeof(uint32_t) > table_end)
+						return -EINVAL;
+
 					table->mc_reg_table_entry[num_ranges].mc_data[i] =
 						(uint32_t)*((uint32_t *)reg_data + j);
 					j++;
@@ -81,11 +91,13 @@ static int atomctrl_retrieve_ac_timing(
 		}
 
 		reg_data = (ATOM_MEMORY_SETTING_DATA_BLOCK *)
-			((uint8_t *)reg_data + le16_to_cpu(reg_block->usRegDataBlkSize)) ;
+			((uint8_t *)reg_data + stride);
 	}
 
-	PP_ASSERT_WITH_CODE((*(uint32_t *)reg_data == END_OF_REG_DATA_BLOCK),
-			"Invalid VramInfo table.", return -1);
+	if ((uint8_t *)reg_data + sizeof(uint32_t) > table_end ||
+	    *(uint32_t *)reg_data != END_OF_REG_DATA_BLOCK)
+		return -EINVAL;
+
 	table->num_entries = num_ranges;
 
 	return 0;
@@ -136,6 +148,7 @@ int atomctrl_initialize_mc_reg_table(
 {
 	ATOM_VRAM_INFO_HEADER_V2_1 *vram_info;
 	ATOM_INIT_REG_BLOCK *reg_block;
+	u8 *table_end;
 	int result = 0;
 	u8 frev, crev;
 	u16 size;
@@ -157,6 +170,7 @@ int atomctrl_initialize_mc_reg_table(
 	}
 
 	if (0 == result) {
+		table_end = (uint8_t *)vram_info + size;
 		reg_block = (ATOM_INIT_REG_BLOCK *)
 			((uint8_t *)vram_info + le16_to_cpu(vram_info->usMemClkPatchTblOffset));
 		result = atomctrl_set_mc_reg_address_table(reg_block, table);
@@ -164,7 +178,7 @@ int atomctrl_initialize_mc_reg_table(
 
 	if (0 == result) {
 		result = atomctrl_retrieve_ac_timing(module_index,
-					reg_block, table);
+					reg_block, table_end, table);
 	}
 
 	return result;
@@ -177,6 +191,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 {
 	ATOM_VRAM_INFO_HEADER_V2_2 *vram_info;
 	ATOM_INIT_REG_BLOCK *reg_block;
+	u8 *table_end;
 	int result = 0;
 	u8 frev, crev;
 	u16 size;
@@ -198,6 +213,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 	}
 
 	if (0 == result) {
+		table_end = (uint8_t *)vram_info + size;
 		reg_block = (ATOM_INIT_REG_BLOCK *)
 			((uint8_t *)vram_info + le16_to_cpu(vram_info->usMemClkPatchTblOffset));
 		result = atomctrl_set_mc_reg_address_table(reg_block, table);
@@ -205,7 +221,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 
 	if (0 == result) {
 		result = atomctrl_retrieve_ac_timing(module_index,
-					reg_block, table);
+					reg_block, table_end, table);
 	}
 
 	return result;
-- 
2.53.0

