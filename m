Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62515AF68B;
	Mon, 19 Oct 2026 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418489; cv=none; b=OzCfrp6dmwkFbMwKdxdpbJLHH3/zf6nGfSfLTL1cPtAA6bpXKHaZf+3pB7Uo/HkYL0+oUOtoFUx6GilONmznPBcNNJQ027TOMyIHCK8EbkJAmdqlAclp5kxjaujB2shXolj/8SgkxTl07+zlOCN+XicGgKmxKNaZzLK2kfZMSL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418489; c=relaxed/simple;
	bh=Bd8e95cLLC2DBPcFrLahfFGPiSluWfiTct0FPxBJzG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ln78SCRLncyFXmV9MZ/3UNoh5J8og6vm5zsLXwic0yFtC/mLv2VFy92G/96fs+rS0ytZQUjtqyT6dMRST+TZJDNXv5Iyj8IRMOBAmQgjKq4p+wJa6gElcrsxDrVpM9//kRkDK3GzZZBn5P/yH3tb3VPPwC2RlSZigB4qObn1TKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H52FS1Bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H52FS1Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D431F000C6;
	Mon, 19 Oct 2026 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418485;
	bh=J0bjOxGPa4OoEAmDMMIHn67YvxWXcybSpy3sgFMbz48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H52FS1BgNmUagPeyo/8WA6gEpuEEO/zpGYsqmASA5KHzOEjnnyPhlu3oBvuWe6G/E
	 z4J7mu1UXy7BmjblkaDLuVuRrbTxDrAATeiQJrh8gg98eXFDS3MLY4MVHAYMJqYl82
	 XmhkK4DQgLc30zdWSeMLOp+0t4an/OYQsGnFWhjEkrDg/ih9SvL3AEzL1y6FBoedqW
	 sig/Bp2FJCy9UqLHFm6Hz35j/jfaclR+UurADo/whq+e80TYC3WCirRjhoufO5uuNX
	 Ng/HX7cTEQLWWnLlhby/nPmDhAwJ2cYVm/MRBil/uMGhitOvlZtPABRO+bs1MmBmTM
	 9txPFaXkDsBeg==
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
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amd/pm: Validate Vega10 PPTable subtable bounds
Date: Mon, 19 Oct 2026 09:49:33 -0400
Message-ID: <20261019135441.1420968-282-sashal@kernel.org>
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

[ Upstream commit 9914149f99fd2ddcfd2a8c1053a57d96ec43448e ]

v1:
Vega10 PPTable parsing uses VBIOS-provided offsets, revision fields
and entry counts to locate subtables. Malformed data can otherwise
drive out-of-bounds reads from soft_pp_table_size, and voltage lookup
tables can overrun their fixed-size destination arrays.

Add shared bounds helpers and validate fixed-size subtables, dynamic
entry arrays and revision-specific layouts before consuming thermal,
fan, power-tune, clock dependency, PCIE, hard-limit and voltage lookup
data.

v2:
if ucRevId is not matched, fallback to default table size instead of returning -EINVAL.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a memory-safety fix for Vega10 PowerPlay table parsing in
**6.18.53**. The buggy offset/`ucNumEntries` handling is in this tree
and is reachable at probe and via the `pp_table` sysfs write path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[drm/amd/pm] [Validate] [reject malformed Vega10 PPTable
subtables before parsing]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Yang Wang \<kevinyang.wang@amd.com\> (author)
- Reviewed-by: Asad Kamal \<asad.kamal@amd.com\>
- Reviewed-by: Kenneth Feng \<kenneth.feng@amd.com\>
- Signed-off-by: Alex Deucher \<alexander.deucher@amd.com\> (amdgpu
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence
  expected)
- Pipeline markers ignored: `[Upstream commit 9914149f99fd...]`, Sasha
  Levin SOB

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Vega10 PPTable parsers trust VBIOS offsets, `ucRevId`, and
  `ucNumEntries` without checking they fit in `soft_pp_table_size`.
  Voltage lookup copies `ucNumEntries` into arrays allocated with a
  fixed `max_levels`.
- **Symptom:** out-of-bounds reads of the PPTable buffer; destination-
  array overrun on voltage lookup.
- **Version info:** none in the message. Code dates to Vega10 powerplay
  (2017).
- **Root cause:** pointer = `powerplay_table + le16_to_cpu(offset)` with
  no size check; lookup loop bound is `ucNumEntries` while allocation
  uses `max_levels` (8 or 4).
- **v2:** unknown `ucRevId` falls back to a default table size instead
  of `-EINVAL` (fan / power-tune), to avoid rejecting real tables.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit bounds validation for OOB read and array
overrun.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File:
  `drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c`
  (+459 / −105, 564 lines touched)
- New helpers: `vega10_pp_table_has_space`, `get_vega10_subtable`,
  `validate_vega10_table_entries`, plus per-subtable getters (gfxclk,
  clk, mclk, mm, pcie, hard-limit, thermal, fan, power-tune, voltage
  lookup)
- Callers updated: `init_thermal_controller`, `init_over_drive_limits`,
  `init_powerplay_extended_tables`, `init_dpm_2_parameters`
- Scope: single-file, systematic validation of existing parsers (not a
  cross-subsystem refactor)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `init_*` computed subtable pointers as `(unsigned
  long)powerplay_table + le16_to_cpu(offset)` and passed them straight
  into parsers.
- **After:** helpers require non-zero offset, header-in-bounds,
  `ucNumEntries != 0` (PCIE allows 0), and `offset + header +
  N*entry_size <= soft_pp_table_size`. Voltage lookup also requires
  `ucNumEntries <= max_levels`.
- **Paths:** probe-time `vega10_pp_tables_initialize` and
  `pp_dpm_set_pp_table` → `amd_powerplay_reset` → `hwmgr_hw_init` →
  `pptable_init`. Error paths return `-1`/`-EINVAL` instead of parsing.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** buffer overflow / out-of-bounds (memory safety)
- **OOB read:** VBIOS/sysfs offsets and entry counts can point past
  `soft_pp_table_size`.
- **Heap write OOB:** `get_vddc_lookup_table()` at v6.18.53 does
  `kzalloc(struct_size(..., max_levels))` then loops `i < ucNumEntries`.
  If `ucNumEntries > 8` (VDDC) or `> 4` (VDDMEM/VDDCI), it writes past
  the allocation.
- **Fix:** overflow-safe `offset <= size && size <= table_size -
  offset`; reject oversized lookup tables before
  `get_vddc_lookup_table()`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Overflow check is the usual unsigned form and is correct.
- GFXCLK unknown `ucRevId` still returns `-EINVAL`, matching existing
  `get_gfxclk_voltage_dependency_table()`.
- Fan/power-tune unknown rev uses a fallback size (v2), reducing brick
  risk on odd BIOS revisions.
- `init_over_drive_limits()` now fails if the gfxclk table is
  missing/malformed; previously it always returned 0 (and could read
  garbage). Valid Vega10 tables have this subtable; AMD reviewed that
  change.
- Regression risk: medium for a large parser change, mitigated by v2
  fallback and maintainer review. No public API change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Unvalidated thermal-controller pointer and
`get_vddc_lookup_table()` come from `f83a9991648bb` (“drm/amd/powerplay:
add Vega10 powerplay support (v5)”, 2017-03-29), contained in
**v4.12-rc1**. Present in this 6.18.53 tree (`git merge-base --is-
ancestor f83a9991648bb v6.18.53`).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Buggy code is the original 2017 parser, not a
recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-author series on this branch:
- `10510a4c2c397` drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds
  (parent; adds `get_vega10_state_array`)
- this commit (vega10 subtables)
- `fc93a02036e5f` Tonga subtables (2/3, other file)
- mailing-list 3/3: remaining legacy PPLIB (`processpptables.c`)
This patch is **standalone for Vega10**. 2/3 and 3/3 touch other files.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yang Wang is an AMD pm contributor with several PPTable bounds
patches. Reviewed by Asad Kamal and Kenneth Feng; applied by Alex
Deucher.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Parent `10510a4c2c397` is **not** in v6.18.53. It applies cleanly to
  v6.18.53. This commit applies cleanly **on top of that parent**;
  without it, the first hunk fails because v6.18.53 still has
  `check_powerplay_tables` instead of `get_vega10_state_array`.
- Functional dependency is weak (insert context only). Helpers use
  existing `soft_pp_table_size`.
- 2/3 and 3/3 are not required for this file.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 9914149f99fd2ddcfd2a8c1053a57d96ec43448e` → https://patch.m
  sgid.link/20260623134917.443011-1-kevinyang.wang@amd.com
- v1: https://patch.msgid.link/20260623102319.413960-1-
  kevinyang.wang@amd.com
- v2 applied (fallback instead of `-EINVAL` on unmatched fan/power-tune
  rev)
- Reviewers: Asad Kamal “Series is Reviewed-by”; Kenneth Feng same. No
  NAK in the saved mbox.
- lore.kernel.org/amd-gfx WebFetch returned 403; thread recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: To/Cc: amd-gfx, Alex Deucher, Hawking Zhang, Kenneth Feng, Asad
Kamal. AMD graphics maintainers were on the patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla/Reported-by. Issue is from code audit of
untrusted table parsing, not a public crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: [PATCH v2 1/3] this; 2/3 Tonga; 3/3 remaining PPLIB. Self-
contained for Vega10. Separate Asad Kamal “clamp ucNumEntries” series
exists; this tree’s 6.18.53 baseline has neither.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search was blocked (403 / WebSearch
error). UNVERIFIED whether stable@ already discussed this.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: New validators listed above; modified `init_thermal_controller`,
`init_over_drive_limits`, `init_powerplay_extended_tables`,
`init_dpm_2_parameters`. `vega10_pp_tables_initialize` unchanged except
it now sees errors from those inits.

**Step 5.2: TRACE CALLERS**
Record:
- `vega10_pptable_funcs.pptable_init` → `vega10_pp_tables_initialize`
- `hwmgr.c`: `hwmgr->pptable_func->pptable_init(hwmgr)` during hwmgr
  init
- `pp_dpm_set_pp_table()` copies userspace buffer into `soft_pp_table` /
  `soft_pp_table_size`, then `amd_powerplay_reset()` → `hwmgr_hw_init()`
  → pptable_init
- Also boot: ATOM VBIOS via `smu_atom_get_data_table()`

**Step 5.3: TRACE CALLEES**
Record: `le16_to_cpu`, `offsetof`, `PP_ASSERT_WITH_CODE`, existing
`get_*_voltage_dependency_table` / `get_vddc_lookup_table` after
validation. No new allocations in the helpers.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from GPU probe (Vega10) and from sysfs `pp_table`
(0644 read, owner-write: `S_IRUGO | S_IWUSR`). Not unprivileged; still a
documented upload/re-init path. Boot path runs on every Vega10 load.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same pattern in Tonga (`process_pptables_v1_0.c`) and legacy
PPLIB (`processpptables.c`) — patches 2/3 and 3/3. Voltage-lookup heap
overrun is the same `max_levels` vs `ucNumEntries` bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. v6.18.53 `vega10_processpptables.c` still does raw offset
arithmetic in `init_thermal_controller`, `init_over_drive_limits`,
`init_powerplay_extended_tables`, `init_dpm_2_parameters`, and the
`get_vddc_lookup_table()` overflow loop. Introduced v4.12, still here.
`git describe HEAD` = **v6.18.53-5049-g0f0bdc2b0dffb**; `make
kernelversion` = **6.18.53**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Does not apply to bare v6.18.53 (first hunk expects
`get_vega10_state_array`). Parent `10510a4c2c397` applies cleanly to
v6.18.53 (vega10/12/20); this commit then applies cleanly. Backport
difficulty: **clean apply if parent is taken; otherwise one-hunk context
tweak**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log v6.18.53 --grep=PPTable -- vega10_processpptables.c`
empty. No `vega10_pp_table_has_space` / `pp_entries_max` in v6.18.53. No
earlier fix for this bug in 6.18.53.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drm/amd/pm (legacy powerplay / Vega10 hwmgr)**. Criticality:
**IMPORTANT** — vendor GPU power/thermal init, not core mm/net, but
boot-critical for Vega 56/64 and related cards. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: amdgpu pm is active; this particular file is mature (2017
parser, occasional UBSAN/flex-array cleanups). Long-standing bug, not a
new-code issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Vega10 amdgpu users (`CONFIG_DRM_AMDGPU`). Driver-specific, not
universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Normal valid VBIOS: not triggered.
- Truncated/corrupt VBIOS or crafted `pp_table` sysfs write: triggered.
- Sysfs write is root (`S_IWUSR`). Documented: “Writing to the file will
  attempt to upload a new powerplay table and re-initialize powerplay.”
- Not an unprivileged attack; still a real kernel heap overflow from a
  supported interface.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Heap write past `kzalloc` in `get_vddc_lookup_table()` →
  **HIGH/CRITICAL** (corruption / crash).
- OOB reads of PPTable → **HIGH** (KASAN/oops, possible info leak).
- Severity: **HIGH**.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for Vega10 — stops heap overflow and OOB reads on
  malformed tables, including sysfs reload.
- **Risk:** medium — +459 lines, parser now fails closed; v2 fallback
  and AMD review reduce brick risk. No API change.
- **Ratio:** benefit outweighs risk for 6.18.y Vega10 users.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real heap overflow: `ucNumEntries` vs `max_levels` in voltage lookup
  (verified in v6.18.53 source).
- Real OOB reads from VBIOS/sysfs offsets (verified).
- Triggerable via documented `pp_table` sysfs write
  (`pp_dpm_set_pp_table`).
- Bug present since v4.12; still in 6.18.53.
- Single file; helpers are overflow-safe; v2 avoids hard-fail on unknown
  fan/power-tune rev.
- Reviewed-by AMD; applied by Deucher.
- Parent + this apply cleanly to v6.18.53.

AGAINST:
- Large (+459); not a 10-line patch.
- Needs parent for a clean apply (or a small context edit).
- No public crash/syzbot report; valid OEM VBIOS is fine.
- `init_over_drive_limits` can now fail probe if gfxclk table is absent.

UNRESOLVED:
- Stable-list discussion (lore 403).
- Full v1 review text (msgid.link 403); v2 intent is in the commit
  message.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — overflow-safe size check;
   AMD Reviewed-by; v2 regression tweak.
2. Fixes a real bug that affects users? **PASS** — heap overflow + OOB
   read; sysfs upload path.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   HIGH, memory safety.
4. Small and contained? **PASS** — one file, no new APIs/refactor; line
   count is high but mechanical validation.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** with parent `10510a4c2c397`
   (verified apply); otherwise minor first-hunk rework.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary memory-
safety fix.

**Step 9.4: MAKE YOUR DECISION**
This should go to **this** 6.18.53 tree. The voltage-lookup overflow and
unvalidated subtable walks are in 6.18.53. The patch is large but
contained and reviewed. Take the parent bounds commit first so it
applies cleanly.

------------------------------------------------------------
What problem it solves and why it matters to 6.18 users
------------------------------------------------------------
Vega10 powerplay treats PPTable offsets and `ucNumEntries` as trusted. A
truncated VBIOS or a crafted `pp_table` sysfs write can read past
`soft_pp_table_size` and, in `get_vddc_lookup_table()`, write past a
heap object sized with `max_levels` (8/4) while looping `ucNumEntries`.
That is crash/corruption on GPU init or table reload.

Does it meet stable rules?
Yes: real memory-safety bug, no new API, one file, AMD-reviewed. Size is
the only stretch; it is validation, not a redesign.

Risk vs benefit
Benefit is a closed heap overflow and OOB read on a supported reload
path. Risk is probe failure on malformed/unexpected tables; v2 fallback
and existing GFXCLK rev checks limit that. Parent should be applied
first.

Concerns
Depends on `10510a4c2c397` for a clean apply to 6.18.53. Sibling 2/3 and
3/3 are other ASICs/files, not required for this fix.

Verification:
- [Phase 1] Tags: author Yang Wang; Reviewed-by Asad Kamal, Kenneth
  Feng; SOB Alex Deucher; no Fixes/syzbot
- [Phase 2] Diff: +459/−105 in one file; `vega10_pp_table_has_space`
  uses `offset <= size && size <= table_size - offset`
- [Phase 2] v6.18.53 `get_vddc_lookup_table`: alloc `max_levels`, loop
  `ucNumEntries` — heap overflow confirmed
- [Phase 3] Blame: `f83a9991648bb` (2017); `git merge-base --is-ancestor
  f83a9991648bb v6.18.53` → yes; `git describe --contains` → v4.12-rc1
- [Phase 3] No Fixes: tag; parent `10510a4c2c397` not in v6.18.53
- [Phase 4] `b4 dig -c 9914149f99fd`: v2 1/3 at
  patch.msgid.link/20260623134917.443011-1; v1 same day; mbox: both AMD
  reviewers Acked the series; no NAK
- [Phase 4] lore WebFetch 403; discussion taken from `b4 dig -m
  /tmp/vega10-pptable.mbox`
- [Phase 4] UNVERIFIED: stable@ thread
- [Phase 5] Callers: `pptable_init` from `hwmgr.c`;
  `pp_dpm_set_pp_table` sets `soft_pp_table` then `amd_powerplay_reset`
- [Phase 5] `AMDGPU_DEVICE_ATTR_RW(pp_table)` → `S_IRUGO | S_IWUSR`
- [Phase 6] `git describe HEAD` = v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` = 6.18.53
- [Phase 6] Bare v6.18.53: this patch does not apply; parent applies
  cleanly; parent then this applies cleanly
- [Phase 6] No PPTable bounds fix already in v6.18.53 for this file
- [Phase 8] Failure mode: heap OOB write / OOB read; severity HIGH
- UNVERIFIED: v1 mailing-list body (403); whether gfxclk offset is ever
  0 on shipping Vega10 VBIOS

**YES**

 .../powerplay/hwmgr/vega10_processpptables.c  | 564 ++++++++++++++----
 1 file changed, 459 insertions(+), 105 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
index 64cff9f4850a6..63fa6b937d9ef 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
@@ -63,6 +63,46 @@ static const void *get_powerplay_table(struct pp_hwmgr *hwmgr)
 	return table_address;
 }
 
+static bool vega10_pp_table_has_space(struct pp_hwmgr *hwmgr, size_t offset,
+				      size_t size)
+{
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	return offset <= table_size && size <= table_size - offset;
+}
+
+static int get_vega10_subtable(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		u16 table_offset, size_t table_size, const void **table)
+{
+	PP_ASSERT_WITH_CODE((table_offset != 0),
+			    "Invalid PowerPlay Table!", return -1);
+	PP_ASSERT_WITH_CODE((vega10_pp_table_has_space(hwmgr, table_offset,
+						       table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*table = (const void *)(((unsigned long)powerplay_table) + table_offset);
+
+	return 0;
+}
+
+static int validate_vega10_table_entries(struct pp_hwmgr *hwmgr,
+		u16 table_offset, size_t entries_offset,
+		u8 num_entries, size_t entry_size)
+{
+	size_t table_size;
+
+	PP_ASSERT_WITH_CODE((num_entries != 0),
+			    "Invalid PowerPlay Table!", return -1);
+
+	table_size = entries_offset + num_entries * entry_size;
+	PP_ASSERT_WITH_CODE((vega10_pp_table_has_space(hwmgr, table_offset,
+						       table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	return 0;
+}
+
 static int get_vega10_state_array(struct pp_hwmgr *hwmgr,
 	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
 	const ATOM_Vega10_State_Array **state_array)
@@ -102,6 +142,293 @@ static int get_vega10_state_array(struct pp_hwmgr *hwmgr,
 	return 0;
 }
 
+static int get_vega10_gfxclk_dependency_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Vega10_GFXCLK_Dependency_Table **gfxclk_dep_table)
+{
+	const ATOM_Vega10_GFXCLK_Dependency_Table *table;
+	u16 table_offset;
+	size_t table_size;
+	size_t entry_size;
+
+	table_offset = le16_to_cpu(powerplay_table->usGfxclkDependencyTableOffset);
+	if (!table_offset)
+		return -EINVAL;
+
+	PP_ASSERT_WITH_CODE((vega10_pp_table_has_space(hwmgr, table_offset,
+						       sizeof(*table))),
+			    "Invalid PowerPlay Table!", return -1);
+
+	table = (const ATOM_Vega10_GFXCLK_Dependency_Table *)
+		(((unsigned long)powerplay_table) + table_offset);
+	PP_ASSERT_WITH_CODE((table->ucNumEntries != 0),
+			    "Invalid PowerPlay Table!", return -1);
+
+	if (table->ucRevId == 0)
+		entry_size = sizeof(ATOM_Vega10_GFXCLK_Dependency_Record);
+	else if (table->ucRevId == 1)
+		entry_size = sizeof(ATOM_Vega10_GFXCLK_Dependency_Record_V2);
+	else
+		PP_ASSERT_WITH_CODE(false,
+			"Unsupported GFXClockDependencyTable Revision!",
+			return -EINVAL);
+
+	table_size = offsetof(ATOM_Vega10_GFXCLK_Dependency_Table, entries) +
+		table->ucNumEntries * entry_size;
+	PP_ASSERT_WITH_CODE((vega10_pp_table_has_space(hwmgr, table_offset,
+						       table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*gfxclk_dep_table = table;
+
+	return 0;
+}
+
+static int get_vega10_clk_dependency_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		u16 table_offset,
+		const ATOM_Vega10_SOCCLK_Dependency_Table **clk_dep_table)
+{
+	const ATOM_Vega10_SOCCLK_Dependency_Table *table;
+	int ret;
+
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_vega10_table_entries(hwmgr, table_offset,
+					    offsetof(ATOM_Vega10_SOCCLK_Dependency_Table,
+						     entries),
+					    table->ucNumEntries,
+					    sizeof(ATOM_Vega10_CLK_Dependency_Record));
+	if (ret)
+		return ret;
+
+	*clk_dep_table = table;
+
+	return 0;
+}
+
+static int get_vega10_mclk_dependency_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Vega10_MCLK_Dependency_Table **mclk_dep_table)
+{
+	const ATOM_Vega10_MCLK_Dependency_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usMclkDependencyTableOffset);
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_vega10_table_entries(hwmgr, table_offset,
+					    offsetof(ATOM_Vega10_MCLK_Dependency_Table,
+						     entries),
+					    table->ucNumEntries,
+					    sizeof(ATOM_Vega10_MCLK_Dependency_Record));
+	if (ret)
+		return ret;
+
+	*mclk_dep_table = table;
+
+	return 0;
+}
+
+static int get_vega10_mm_dependency_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Vega10_MM_Dependency_Table **mm_dep_table)
+{
+	const ATOM_Vega10_MM_Dependency_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usMMDependencyTableOffset);
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_vega10_table_entries(hwmgr, table_offset,
+					    offsetof(ATOM_Vega10_MM_Dependency_Table,
+						     entries),
+					    table->ucNumEntries,
+					    sizeof(ATOM_Vega10_MM_Dependency_Record));
+	if (ret)
+		return ret;
+
+	*mm_dep_table = table;
+
+	return 0;
+}
+
+static int get_vega10_pcie_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const Vega10_PPTable_Generic_SubTable_Header **pcie_table)
+{
+	const ATOM_Vega10_PCIE_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usPCIETableOffset);
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	if (!table->ucNumEntries) {
+		*pcie_table = (const Vega10_PPTable_Generic_SubTable_Header *)table;
+		return 0;
+	}
+
+	ret = validate_vega10_table_entries(hwmgr, table_offset,
+					    offsetof(ATOM_Vega10_PCIE_Table,
+						     entries),
+					    table->ucNumEntries,
+					    sizeof(ATOM_Vega10_PCIE_Record));
+	if (ret)
+		return ret;
+
+	*pcie_table = (const Vega10_PPTable_Generic_SubTable_Header *)table;
+
+	return 0;
+}
+
+static int get_vega10_hard_limit_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Vega10_Hard_Limit_Table **hard_limit_table)
+{
+	const ATOM_Vega10_Hard_Limit_Table *table;
+	u16 table_offset;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usHardLimitTableOffset);
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	ret = validate_vega10_table_entries(hwmgr, table_offset,
+					    offsetof(ATOM_Vega10_Hard_Limit_Table,
+						     entries),
+					    table->ucNumEntries,
+					    sizeof(ATOM_Vega10_Hard_Limit_Record));
+	if (ret)
+		return ret;
+
+	*hard_limit_table = table;
+
+	return 0;
+}
+
+static int get_vega10_thermal_controller_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const ATOM_Vega10_Thermal_Controller **thermal_controller)
+{
+	u16 table_offset;
+
+	table_offset = le16_to_cpu(powerplay_table->usThermalControllerOffset);
+
+	return get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				   sizeof(**thermal_controller),
+				   (const void **)thermal_controller);
+}
+
+static int get_vega10_fan_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const Vega10_PPTable_Generic_SubTable_Header **fan_table)
+{
+	const Vega10_PPTable_Generic_SubTable_Header *header;
+	u16 table_offset;
+	size_t table_size;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usFanTableOffset);
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*header), (const void **)&header);
+	if (ret)
+		return ret;
+
+	if (header->ucRevId == 10)
+		table_size = sizeof(ATOM_Vega10_Fan_Table);
+	else if (header->ucRevId == 0xb)
+		table_size = sizeof(ATOM_Vega10_Fan_Table_V2);
+	else if (header->ucRevId > 0xb)
+		table_size = sizeof(ATOM_Vega10_Fan_Table_V3);
+	else
+		table_size = sizeof(*header);
+
+	PP_ASSERT_WITH_CODE((vega10_pp_table_has_space(hwmgr, table_offset,
+						       table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*fan_table = header;
+
+	return 0;
+}
+
+static int get_vega10_power_tune_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		const Vega10_PPTable_Generic_SubTable_Header **power_tune_table)
+{
+	const Vega10_PPTable_Generic_SubTable_Header *header;
+	u16 table_offset;
+	size_t table_size;
+	int ret;
+
+	table_offset = le16_to_cpu(powerplay_table->usPowerTuneTableOffset);
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*header), (const void **)&header);
+	if (ret)
+		return ret;
+
+	if (header->ucRevId == 5)
+		table_size = sizeof(ATOM_Vega10_PowerTune_Table);
+	else if (header->ucRevId == 6)
+		table_size = sizeof(ATOM_Vega10_PowerTune_Table_V2);
+	else
+		table_size = sizeof(ATOM_Vega10_PowerTune_Table_V3);
+
+	PP_ASSERT_WITH_CODE((vega10_pp_table_has_space(hwmgr, table_offset,
+						       table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*power_tune_table = header;
+
+	return 0;
+}
+
+static int get_vega10_voltage_lookup_table(struct pp_hwmgr *hwmgr,
+		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+		u16 table_offset, uint32_t max_levels,
+		const ATOM_Vega10_Voltage_Lookup_Table **lookup_table)
+{
+	const ATOM_Vega10_Voltage_Lookup_Table *table;
+	size_t table_size;
+	int ret;
+
+	ret = get_vega10_subtable(hwmgr, powerplay_table, table_offset,
+				  sizeof(*table), (const void **)&table);
+	if (ret)
+		return ret;
+
+	PP_ASSERT_WITH_CODE((table->ucNumEntries != 0 &&
+			     table->ucNumEntries <= max_levels),
+			    "Invalid PowerPlay Table!", return -1);
+
+	table_size = offsetof(ATOM_Vega10_Voltage_Lookup_Table, entries) +
+		table->ucNumEntries * sizeof(ATOM_Vega10_Voltage_Lookup_Record);
+	PP_ASSERT_WITH_CODE((vega10_pp_table_has_space(hwmgr, table_offset,
+						       table_size)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*lookup_table = table;
+
+	return 0;
+}
+
 static int check_powerplay_tables(struct pp_hwmgr *hwmgr,
 	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
 {
@@ -149,14 +476,16 @@ static int init_thermal_controller(
 	const ATOM_Vega10_Fan_Table *fan_table_v1;
 	const ATOM_Vega10_Fan_Table_V2 *fan_table_v2;
 	const ATOM_Vega10_Fan_Table_V3 *fan_table_v3;
-
-	thermal_controller = (ATOM_Vega10_Thermal_Controller *)
-			(((unsigned long)powerplay_table) +
-			le16_to_cpu(powerplay_table->usThermalControllerOffset));
+	int ret;
 
 	PP_ASSERT_WITH_CODE((powerplay_table->usThermalControllerOffset != 0),
 			"Thermal controller table not set!", return -EINVAL);
 
+	ret = get_vega10_thermal_controller_table(hwmgr, powerplay_table,
+						  &thermal_controller);
+	if (ret)
+		return ret;
+
 	hwmgr->thermal_controller.ucType = thermal_controller->ucType;
 	hwmgr->thermal_controller.ucI2cLine = thermal_controller->ucI2cLine;
 	hwmgr->thermal_controller.ucI2cAddress = thermal_controller->ucI2cAddress;
@@ -185,9 +514,9 @@ static int init_thermal_controller(
 	if (!powerplay_table->usFanTableOffset)
 		return 0;
 
-	header = (const Vega10_PPTable_Generic_SubTable_Header *)
-			(((unsigned long)powerplay_table) +
-			le16_to_cpu(powerplay_table->usFanTableOffset));
+	ret = get_vega10_fan_table(hwmgr, powerplay_table, &header);
+	if (ret)
+		return ret;
 
 	if (header->ucRevId == 10) {
 		fan_table_v1 = (ATOM_Vega10_Fan_Table *)header;
@@ -332,12 +661,15 @@ static int init_over_drive_limits(
 		struct pp_hwmgr *hwmgr,
 		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
 {
-	const ATOM_Vega10_GFXCLK_Dependency_Table *gfxclk_dep_table =
-			(const ATOM_Vega10_GFXCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usGfxclkDependencyTableOffset));
+	const ATOM_Vega10_GFXCLK_Dependency_Table *gfxclk_dep_table;
 	bool is_acg_enabled = false;
 	ATOM_Vega10_GFXCLK_Dependency_Record_V2 *patom_record_v2;
+	int ret;
+
+	ret = get_vega10_gfxclk_dependency_table(hwmgr, powerplay_table,
+						 &gfxclk_dep_table);
+	if (ret)
+		return ret;
 
 	if (gfxclk_dep_table->ucRevId == 1) {
 		patom_record_v2 =
@@ -900,51 +1232,13 @@ static int init_powerplay_extended_tables(
 	int result = 0;
 	struct phm_ppt_v2_information *pp_table_info =
 		(struct phm_ppt_v2_information *)(hwmgr->pptable);
-
-	const ATOM_Vega10_MM_Dependency_Table *mm_dependency_table =
-			(const ATOM_Vega10_MM_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usMMDependencyTableOffset));
-	const Vega10_PPTable_Generic_SubTable_Header *power_tune_table =
-			(const Vega10_PPTable_Generic_SubTable_Header *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usPowerTuneTableOffset));
-	const ATOM_Vega10_SOCCLK_Dependency_Table *socclk_dep_table =
-			(const ATOM_Vega10_SOCCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usSocclkDependencyTableOffset));
-	const ATOM_Vega10_GFXCLK_Dependency_Table *gfxclk_dep_table =
-			(const ATOM_Vega10_GFXCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usGfxclkDependencyTableOffset));
-	const ATOM_Vega10_DCEFCLK_Dependency_Table *dcefclk_dep_table =
-			(const ATOM_Vega10_DCEFCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usDcefclkDependencyTableOffset));
-	const ATOM_Vega10_MCLK_Dependency_Table *mclk_dep_table =
-			(const ATOM_Vega10_MCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usMclkDependencyTableOffset));
-	const ATOM_Vega10_Hard_Limit_Table *hard_limits =
-			(const ATOM_Vega10_Hard_Limit_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usHardLimitTableOffset));
-	const Vega10_PPTable_Generic_SubTable_Header *pcie_table =
-			(const Vega10_PPTable_Generic_SubTable_Header *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usPCIETableOffset));
-	const ATOM_Vega10_PIXCLK_Dependency_Table *pixclk_dep_table =
-			(const ATOM_Vega10_PIXCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usPixclkDependencyTableOffset));
-	const ATOM_Vega10_PHYCLK_Dependency_Table *phyclk_dep_table =
-			(const ATOM_Vega10_PHYCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usPhyClkDependencyTableOffset));
-	const ATOM_Vega10_DISPCLK_Dependency_Table *dispclk_dep_table =
-			(const ATOM_Vega10_DISPCLK_Dependency_Table *)
-			(((unsigned long) powerplay_table) +
-			le16_to_cpu(powerplay_table->usDispClkDependencyTableOffset));
+	const ATOM_Vega10_MM_Dependency_Table *mm_dependency_table;
+	const Vega10_PPTable_Generic_SubTable_Header *power_tune_table;
+	const ATOM_Vega10_GFXCLK_Dependency_Table *gfxclk_dep_table;
+	const ATOM_Vega10_MCLK_Dependency_Table *mclk_dep_table;
+	const ATOM_Vega10_Hard_Limit_Table *hard_limits;
+	const Vega10_PPTable_Generic_SubTable_Header *pcie_table;
+	const ATOM_Vega10_SOCCLK_Dependency_Table *clk_dep_table;
 
 	pp_table_info->vdd_dep_on_socclk = NULL;
 	pp_table_info->vdd_dep_on_sclk = NULL;
@@ -956,63 +1250,114 @@ static int init_powerplay_extended_tables(
 	pp_table_info->vdd_dep_on_phyclk = NULL;
 	pp_table_info->vdd_dep_on_dispclk = NULL;
 
-	if (powerplay_table->usMMDependencyTableOffset)
-		result = get_mm_clock_voltage_table(hwmgr,
+	if (powerplay_table->usMMDependencyTableOffset) {
+		result = get_vega10_mm_dependency_table(hwmgr, powerplay_table,
+							&mm_dependency_table);
+		if (!result)
+			result = get_mm_clock_voltage_table(hwmgr,
 				&pp_table_info->mm_dep_table,
 				mm_dependency_table);
+	}
 
-	if (!result && powerplay_table->usPowerTuneTableOffset)
-		result = get_tdp_table(hwmgr,
+	if (!result && powerplay_table->usPowerTuneTableOffset) {
+		result = get_vega10_power_tune_table(hwmgr, powerplay_table,
+						     &power_tune_table);
+		if (!result)
+			result = get_tdp_table(hwmgr,
 				&pp_table_info->tdp_table,
 				power_tune_table);
+	}
 
-	if (!result && powerplay_table->usSocclkDependencyTableOffset)
-		result = get_socclk_voltage_dependency_table(hwmgr,
+	if (!result && powerplay_table->usSocclkDependencyTableOffset) {
+		result = get_vega10_clk_dependency_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usSocclkDependencyTableOffset),
+				&clk_dep_table);
+		if (!result)
+			result = get_socclk_voltage_dependency_table(hwmgr,
 				&pp_table_info->vdd_dep_on_socclk,
-				socclk_dep_table);
+				(const ATOM_Vega10_SOCCLK_Dependency_Table *)
+				clk_dep_table);
+	}
 
-	if (!result && powerplay_table->usGfxclkDependencyTableOffset)
-		result = get_gfxclk_voltage_dependency_table(hwmgr,
-				&pp_table_info->vdd_dep_on_sclk,
-				gfxclk_dep_table);
+	if (!result && powerplay_table->usGfxclkDependencyTableOffset) {
+		result = get_vega10_gfxclk_dependency_table(hwmgr,
+			powerplay_table, &gfxclk_dep_table);
+		if (!result)
+			result = get_gfxclk_voltage_dependency_table(hwmgr,
+					&pp_table_info->vdd_dep_on_sclk,
+					gfxclk_dep_table);
+	}
 
-	if (!result && powerplay_table->usPixclkDependencyTableOffset)
-		result = get_pix_clk_voltage_dependency_table(hwmgr,
+	if (!result && powerplay_table->usPixclkDependencyTableOffset) {
+		result = get_vega10_clk_dependency_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usPixclkDependencyTableOffset),
+				&clk_dep_table);
+		if (!result)
+			result = get_pix_clk_voltage_dependency_table(hwmgr,
 				&pp_table_info->vdd_dep_on_pixclk,
 				(const ATOM_Vega10_PIXCLK_Dependency_Table *)
-				pixclk_dep_table);
+				clk_dep_table);
+	}
 
-	if (!result && powerplay_table->usPhyClkDependencyTableOffset)
-		result = get_pix_clk_voltage_dependency_table(hwmgr,
+	if (!result && powerplay_table->usPhyClkDependencyTableOffset) {
+		result = get_vega10_clk_dependency_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usPhyClkDependencyTableOffset),
+				&clk_dep_table);
+		if (!result)
+			result = get_pix_clk_voltage_dependency_table(hwmgr,
 				&pp_table_info->vdd_dep_on_phyclk,
 				(const ATOM_Vega10_PIXCLK_Dependency_Table *)
-				phyclk_dep_table);
+				clk_dep_table);
+	}
 
-	if (!result && powerplay_table->usDispClkDependencyTableOffset)
-		result = get_pix_clk_voltage_dependency_table(hwmgr,
+	if (!result && powerplay_table->usDispClkDependencyTableOffset) {
+		result = get_vega10_clk_dependency_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usDispClkDependencyTableOffset),
+				&clk_dep_table);
+		if (!result)
+			result = get_pix_clk_voltage_dependency_table(hwmgr,
 				&pp_table_info->vdd_dep_on_dispclk,
 				(const ATOM_Vega10_PIXCLK_Dependency_Table *)
-				dispclk_dep_table);
+				clk_dep_table);
+	}
 
-	if (!result && powerplay_table->usDcefclkDependencyTableOffset)
-		result = get_dcefclk_voltage_dependency_table(hwmgr,
+	if (!result && powerplay_table->usDcefclkDependencyTableOffset) {
+		result = get_vega10_clk_dependency_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usDcefclkDependencyTableOffset),
+				&clk_dep_table);
+		if (!result)
+			result = get_dcefclk_voltage_dependency_table(hwmgr,
 				&pp_table_info->vdd_dep_on_dcefclk,
-				dcefclk_dep_table);
+				(const ATOM_Vega10_DCEFCLK_Dependency_Table *)
+				clk_dep_table);
+	}
 
-	if (!result && powerplay_table->usMclkDependencyTableOffset)
-		result = get_mclk_voltage_dependency_table(hwmgr,
+	if (!result && powerplay_table->usMclkDependencyTableOffset) {
+		result = get_vega10_mclk_dependency_table(hwmgr, powerplay_table,
+							  &mclk_dep_table);
+		if (!result)
+			result = get_mclk_voltage_dependency_table(hwmgr,
 				&pp_table_info->vdd_dep_on_mclk,
 				mclk_dep_table);
+	}
 
-	if (!result && powerplay_table->usPCIETableOffset)
-		result = get_pcie_table(hwmgr,
+	if (!result && powerplay_table->usPCIETableOffset) {
+		result = get_vega10_pcie_table(hwmgr, powerplay_table,
+					       &pcie_table);
+		if (!result)
+			result = get_pcie_table(hwmgr,
 				&pp_table_info->pcie_table,
 				pcie_table);
+	}
 
-	if (!result && powerplay_table->usHardLimitTableOffset)
-		result = get_hard_limits(hwmgr,
+	if (!result && powerplay_table->usHardLimitTableOffset) {
+		result = get_vega10_hard_limit_table(hwmgr, powerplay_table,
+						     &hard_limits);
+		if (!result)
+			result = get_hard_limits(hwmgr,
 				&pp_table_info->max_clock_voltage_on_dc,
 				hard_limits);
+	}
 
 	hwmgr->dyn_state.max_clock_voltage_on_dc.sclk =
 			pp_table_info->max_clock_voltage_on_dc.sclk;
@@ -1140,30 +1485,39 @@ static int init_dpm_2_parameters(
 	}
 
 	if (powerplay_table->usVddcLookupTableOffset) {
-		const ATOM_Vega10_Voltage_Lookup_Table *vddc_table =
-				(ATOM_Vega10_Voltage_Lookup_Table *)
-				(((unsigned long)powerplay_table) +
-				le16_to_cpu(powerplay_table->usVddcLookupTableOffset));
-		result = get_vddc_lookup_table(hwmgr,
-				&pp_table_info->vddc_lookup_table, vddc_table, 8);
+		const ATOM_Vega10_Voltage_Lookup_Table *vddc_table;
+
+		result = get_vega10_voltage_lookup_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usVddcLookupTableOffset),
+				8, &vddc_table);
+		if (!result)
+			result = get_vddc_lookup_table(hwmgr,
+					&pp_table_info->vddc_lookup_table,
+					vddc_table, 8);
 	}
 
-	if (powerplay_table->usVddmemLookupTableOffset) {
-		const ATOM_Vega10_Voltage_Lookup_Table *vdd_mem_table =
-				(ATOM_Vega10_Voltage_Lookup_Table *)
-				(((unsigned long)powerplay_table) +
-				le16_to_cpu(powerplay_table->usVddmemLookupTableOffset));
-		result = get_vddc_lookup_table(hwmgr,
-				&pp_table_info->vddmem_lookup_table, vdd_mem_table, 4);
+	if (!result && powerplay_table->usVddmemLookupTableOffset) {
+		const ATOM_Vega10_Voltage_Lookup_Table *vdd_mem_table;
+
+		result = get_vega10_voltage_lookup_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usVddmemLookupTableOffset),
+				4, &vdd_mem_table);
+		if (!result)
+			result = get_vddc_lookup_table(hwmgr,
+					&pp_table_info->vddmem_lookup_table,
+					vdd_mem_table, 4);
 	}
 
-	if (powerplay_table->usVddciLookupTableOffset) {
-		const ATOM_Vega10_Voltage_Lookup_Table *vddci_table =
-				(ATOM_Vega10_Voltage_Lookup_Table *)
-				(((unsigned long)powerplay_table) +
-				le16_to_cpu(powerplay_table->usVddciLookupTableOffset));
-		result = get_vddc_lookup_table(hwmgr,
-				&pp_table_info->vddci_lookup_table, vddci_table, 4);
+	if (!result && powerplay_table->usVddciLookupTableOffset) {
+		const ATOM_Vega10_Voltage_Lookup_Table *vddci_table;
+
+		result = get_vega10_voltage_lookup_table(hwmgr, powerplay_table,
+				le16_to_cpu(powerplay_table->usVddciLookupTableOffset),
+				4, &vddci_table);
+		if (!result)
+			result = get_vddc_lookup_table(hwmgr,
+					&pp_table_info->vddci_lookup_table,
+					vddci_table, 4);
 	}
 
 	return result;
-- 
2.53.0

