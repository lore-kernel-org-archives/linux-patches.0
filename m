Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F48B500340;
	Mon, 19 Oct 2026 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418278; cv=none; b=tVsuS0AOM1DAsfHz6Etr4Ju9bfIAMUr1UGbVqoJ2r69vTMNvIEte+sQxTSkTK9keW4/VLEkuElCDaSUZzXW3G//P8yCm4n6idGBFChUiPVCvAtb93+hMRp+GEo97kKxeTGLwIhSSTvA0JNujPqMwSAawsd4M/CUfRaBD7e1y7g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418278; c=relaxed/simple;
	bh=DWHFGp2b1w5r4l1p6O96Ep1ei4zM/7jlwKsd30Af+Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qBn24hMACXyIrdMg+YzzPm4sS3G4EraClWsaQt7try4pxym0Ad8q33G4nk9OPdDeu5BaHy/Rwkm5+D5tjmFsSQFQqUle4k4QF+BnAMohH8bvFV1J8xJi16VaDGDwaYzPW8ZWg7yL/irNZ+GyuDlrs6/NAxuGEGEjux+OYkDWMgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFX+EPfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFX+EPfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860421F000C7;
	Mon, 19 Oct 2026 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418275;
	bh=Ua7FOrvtap76X3pWHhtDl5tS54N9KAgGE6T8hmgUSAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFX+EPfYtLIW13hk3VxO2Lau/4hfffMQ4eGWpmPGm7UMC/hqCsOskZfKFRRRK9D2i
	 wDbWKq5jht1XsLwoVSDulFSmySmLl6ORV2lat4//tumEJUqu5uWIWIPqPiYL+RCS9p
	 7W6xKQvI1kMZQH5jlHc8NKw3rKz5Fx9Banc7ZS2Km8rVrcimCOjjj0hLrqWADhJi7C
	 lZfc89attVBpauIwaG4M1uNVVldBxs8qed1DlQrpNgMALf3aaPHQXlEdRAAe6ZMKv9
	 PC1cDq1jEKW4eXMUtpLQJNaogfGlLXBTNM2EiaMRXiXQDdvHuDbmooJ48TqM2dZ9BI
	 lcd+dM6KRKn+w==
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
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amd/pm: Use uploaded size for legacy custom PPTable
Date: Mon, 19 Oct 2026 09:47:03 -0400
Message-ID: <20261019135441.1420968-132-sashal@kernel.org>
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

[ Upstream commit 055a40c32f3a2dcd4d1a6f85ff4c231cf35f1b53 ]

The legacy powerplay path used to allocate hardcode_pp_table from
the original VBIOS PPTable size, copy only the uploaded bytes into it,
and keep soft_pp_table_size unchanged. If a custom PPTable is shorter
than the original table, later code can still treat the stale tail as
valid table data.

Treat the uploaded buffer as the complete custom PPTable: duplicate the
uploaded buffer directly, replace hardcode_pp_table atomically, and set
soft_pp_table_size to the uploaded size.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amd/pm] [Use] Use uploaded size for legacy custom PPTable`
Subsystem: AMDGPU PowerPlay (legacy hwmgr path). Verb “Use” describes
the corrected size source; the body is a correctness fix for stale table
tails.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Yang Wang <kevinyang.wang@amd.com>` (author)
- `Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>` (AMD)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Link:`, or `Cc: stable` on
  the upstream commit (absence expected)
- Pipeline-only markers ignored: `[Upstream commit 055a40c32f3a2…]`,
  `Signed-off-by: Sasha Levin`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `pp_dpm_set_pp_table()` allocated `hardcode_pp_table` at the
  original VBIOS PPTable size, `memcpy`’d only the uploaded bytes, and
  left `soft_pp_table_size` unchanged.
- **Symptom:** A shorter custom table leaves a stale VBIOS tail; later
  parsing still treats that tail as valid table data.
  `pp_dpm_get_pp_table()` also reports the old size.
- **Root cause:** Upload size is not treated as the complete custom
  table.
- **Fix:** `kmemdup(buf, size)`, atomically replace `hardcode_pp_table`,
  set `soft_pp_table_size = size`.
- No stack traces, syzbot, or version range in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit correctness/memory-
safety fix for mixed VBIOS+custom table contents. Also aligns the legacy
path with SWSMU’s `smu_sys_set_pp_table()`.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c` (+8 / −13)
- Function: `pp_dpm_set_pp_table()` only
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: **Before** (this tree at `v6.18.53` / parent of the candidate):
```
if (!hwmgr || !hwmgr->pm_en) return -EINVAL;
if (size > hwmgr->soft_pp_table_size) return -EINVAL;
if (!hardcode_pp_table)
    hardcode_pp_table = kmemdup(soft_pp_table, soft_pp_table_size, ...);
memcpy(hardcode_pp_table, buf, size);
soft_pp_table = hardcode_pp_table;
// soft_pp_table_size unchanged
amd_powerplay_reset();
```
**After:**
```
if (!hwmgr || !hwmgr->pm_en || !buf || !size || size > U32_MAX) return
-EINVAL;
hardcode_pp_table = kmemdup(buf, size, GFP_KERNEL);
kfree(old); assign new;
soft_pp_table = hardcode_pp_table;
soft_pp_table_size = size;
amd_powerplay_reset();
```
Path: privileged sysfs store to `pp_table`, then DPM re-init. Not boot-
default.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic/correctness + memory-safety (stale buffer / wrong
length).**
Broken: partial overwrite of a VBIOS-sized copy; parsers and
`pp_table_has_space()` / `*_pp_table_has_space()` use
`soft_pp_table_size` as the valid span.
Fix: the uploaded buffer *is* the table; size matches allocation.
Removes the overflow `memcpy` by allocating exactly `size` (supersedes
the in-tree `size > soft_pp_table_size` cap). Adds `!buf`, `!size`,
`size > U32_MAX` (`soft_pp_table_size` is `uint32_t`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Minimal and matches SWSMU. `kfree` + replace is serialized by
`adev->pm.mutex` in `amdgpu_dpm_set_pp_table()`. `kfree(NULL)` is safe
on first upload. Destroy path already `kfree`s `hardcode_pp_table`.
Regression risk: low on the common (no custom table) path. Larger-than-
VBIOS uploads are now allowed up to sysfs `PAGE_SIZE`; parsers that
trust header offsets still need the later bounds patches.
Truncated/malformed headers could already OOB in `v6.18.53` without
those checks.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Function added `f3898ea12fc1f` (2016-02, “add some sysfs interfaces
  for powerplay”)
- Upload/reset/memcpy: `4dcf9e6f2e33fe` (2016-07, “add uploading pptable
  and resetting powerplay support”)
- `kmemdup` of VBIOS-sized original: `efdf7a93195a71` (2016-09)
- Overflow cap: `3334985f8b4c7` / upstream `f193e71fa9fab` (“bound
  pp_dpm_set_pp_table() memcpy”) — **already in `v6.18.53`**
Bug is long-standing; this tree still has the stale-tail behavior.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introduced with PowerPlay sysfs upload in 2016.
Present in this 6.18.y tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related in this tree:
- `3334985f8b4c7` — overflow bound (in `v6.18.53`)
- `3149b1bee4fa1` — series 1/5, SWSMU header check (not in `v6.18.53`;
  different file)
- Later descendants: `f29e53bc54611`, `10510a4c2c397`, `c80131588ca2f`
  (series 3–5 bounds; **not** in `v6.18.53`)
- `8c685df5c3b26` — get-path UAF, different files
This patch is **2/5** of Yang Wang’s June 2026 series. It is standalone
(legacy `amd_powerplay.c` only). 3–5 use `soft_pp_table_size` as the
bound, so they want this size to match custom uploads.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yang Wang is an AMD pm contributor with several PPTable
bounds/UAF fixes. Hawking Zhang reviewed; Alex Deucher signed off.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: No missing helpers: `kmemdup`, `U32_MAX`, `hardcode_pp_table`,
`amd_powerplay_reset()` all exist in `v6.18.53`. Does **not** depend on
1/5. Parent blob already has the overflow `if (size >
soft_pp_table_size)` that this diff removes — clean apply on this tree.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 055a40c32f3a2dcd4d1a6f85ff4c231cf35f1b53` → https://patch.m
  sgid.link/20260623034151.263746-2-kevinyang.wang@amd.com
- Series v1 only (no v2/v3)
- `[PATCH 2/5] drm/amd/pm: Use uploaded size for legacy custom PPTable`
- **1/5** SWSMU header + atomic `kmemdup`
- **2/5** this commit
- **3/5** Tonga state-array bounds
- **4/5** Vega hwmgr bounds
- **5/5** legacy `processpptables.c` offset bounds
  (`pp_table_has_space`)
- lore.kernel.org HTTP 403; discussion taken from `b4 dig -m` mbox
  (verified)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc `amd-gfx@lists.freedesktop.org`, Alex
Deucher, Hawking Zhang, Kenneth Feng. Hawking: “Series is Reviewed-by:
Hawking Zhang”. No NAKs in the saved thread.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Bug is described from code
review.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2/5 does not need 1/5. 3–5 are follow-on parser hardening that
treat `soft_pp_table_size` as the valid span; they are stronger with 2/5
but VBIOS parsing still works without it.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — `lore.kernel.org/stable/` returned HTTP 403. No
stable discussion in the amd-gfx mbox.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `pp_dpm_set_pp_table()`; uses `amd_powerplay_reset()`.

**Step 5.2: TRACE CALLERS**
Record:
- `pp_dpm_funcs.set_pp_table` → `amdgpu_dpm_set_pp_table()`
  (`mutex_lock(&adev->pm.mutex)`) → `amdgpu_set_pp_table()` sysfs store
- Attribute: `AMDGPU_DEVICE_ATTR_RW(pp_table, …)` → `S_IRUGO | S_IWUSR`
  (root write)
- HW: legacy PowerPlay (SI/CI/VI/Polaris/Vega via hwmgr), not Navi+
  SWSMU (`smu_sys_set_pp_table`)

**Step 5.3: TRACE CALLEES**
Record: `kmemdup`, `kfree`, `amd_powerplay_reset()` → `hwmgr_hw_fini` /
`hwmgr_hw_init` / `hwmgr_handle_task(AMD_PP_TASK_COMPLETE_INIT)`,
optional `avfs_control(false)`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `write()` to `/sys/class/drm/card*/device/pp_table`
(root). Then full PM re-init from the new table. Reachable, privileged,
documented.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: SWSMU already `kmemdup(buf, size)` and sets
`power_play_table_size = size` (series 1/5 / current
`smu_sys_set_pp_table()`). This is the legacy equivalent.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`;
`Makefile` 6.18.53.
`v6.18.53:drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c` still has
VBIOS-sized `kmemdup` + partial `memcpy` + unchanged
`soft_pp_table_size` (and the overflow cap). Introduced ~2016.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Candidate diff is against the exact `v6.18.53`
function (including `if (size > hwmgr->soft_pp_table_size)`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Overflow cap is in `v6.18.53`; it does **not** fix the short-
table tail. No other in-tree substitute for updating
`soft_pp_table_size` on upload.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/gpu/drm/amd/pm/powerplay` — **IMPORTANT** (amdgpu DPM
on pre-Navi ASICs). Not core mm/vfs, but production GPU power/clocks.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (Alex Deucher). Legacy PowerPlay is mature;
this is hardening of a 2016 sysfs API, not new feature work.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: root users uploading custom PPTables on legacy
PowerPlay AMD GPUs (Polaris/Vega/etc.). Not universal; the sysfs node is
a documented interface.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Write a custom table **shorter** than the VBIOS table. Common
for truncated files or smaller community/AMD PPT blobs. Not boot.
**Not** unprivileged (`S_IWUSR`).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Mixed custom prefix + stale VBIOS tail parsed as one table →
wrong clocks/voltages/DPM (hangs, instability, possible overvoltage).
`get_pp_table` returns too much mixed data. Defeats size-based parser
bounds that key off `soft_pp_table_size`.
**Severity: HIGH** on that path (wrong PM programming / confused
bounds), **MEDIUM** globally (privileged, non-default).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Completes the overflow fix already in 6.18.53; custom
  tables are actually the bytes uploaded; readback size is right; later
  bounds checks can trust the size.
- **Risk:** Low — ~8 insertions, one function, mutex-held, same pattern
  as SWSMU. Idle GPUs that never write `pp_table` are unchanged.
- **Ratio:** Favorable.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real bug: stale VBIOS tail treated as valid PPTable after a short
  custom upload
- Can misprogram GPU power/clocks and break size-based parsing
- Small, obviously correct, matches SWSMU
- Overflow half already in this tree; this is the remaining hole
- AMD review (Hawking) + maintainer SOB (Deucher)
- Applies cleanly; no missing helpers
- Privileged but supported sysfs API

**AGAINST:**
- Not a default-boot crash; root-only
- No syzbot/CVE/user report in the message
- Part of a 5-patch series (2/5 still stands alone)
- Allows uploads larger than the original VBIOS size (capped in practice
  by sysfs `PAGE_SIZE`)

**UNRESOLVED:** Stable-list discussion (lore 403). No evidence this was
rejected for stable.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — SWSMU-equivalent; reviewed
   by AMD; in mainline
2. Fixes a real bug that affects users? **PASS** — documented `pp_table`
   upload
3. Important issue? **PASS** — wrong DPM table contents / bounds (HIGH
   on that path)
4. Small and contained? **PASS** — one function, net −5 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean vs `v6.18.53`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID/quirk/DT/build/docs exception). Qualifies
as a normal small bugfix.

**Step 9.4: DECISION**
This belongs on 6.18.y: the buggy upload path is here, the overflow cap
is already here, and this is the matching fix so a custom PPTable is
exactly the uploaded bytes and length.

### What the commit solves for this tree
On 6.18.53, `pp_dpm_set_pp_table()` still clones the VBIOS table, copies
only the write, and keeps `soft_pp_table_size`. A shorter custom table
leaves a stale tail that init/sysfs still treat as valid, so DPM can run
on a hybrid table. The patch makes the upload the whole table, which is
what the sysfs ABI documents.

### Risk vs benefit
Benefit is real for anyone using `pp_table` on legacy PowerPlay. Risk is
a small, mutex-protected change with no effect unless that sysfs node is
written.

---

Verification:
- [Phase 1] Tags: author Yang Wang; Reviewed-by Hawking Zhang; SOB Alex
  Deucher; no Fixes/Reported-by/Cc: stable on upstream `055a40c32f3a2`
- [Phase 2] Diff: `pp_dpm_set_pp_table()` only; drop VBIOS-sized clone +
  partial memcpy; `kmemdup(buf,size)`; set `soft_pp_table_size`; extra
  `!buf/!size/U32_MAX` checks
- [Phase 3] Blame: memcpy upload `4dcf9e6f2e33fe` (2016); overflow cap
  `3334985f8b4c7` is in `v6.18.53`; this candidate is not
- [Phase 3] `git merge-base --is-ancestor 055a40c32f3a2 HEAD` → not in
  this history as that SHA (expected for a stable cherry-pick
  evaluation)
- [Phase 3] `v6.18.53` file contents confirmed: bound-check +
  kmemdup(original) + memcpy(size) + no size update
- [Phase 4] `b4 dig -c 055a40c32f3a2` → patch 2/5, msgid
  `20260623034151.263746-2`; v1 only; Hawking reviewed the series
- [Phase 4] WebFetch lore/msgid 403; mbox via `b4 dig -m` used instead
- [Phase 4] Stable-list search 403 — UNVERIFIED
- [Phase 5] Callers: `amdgpu_dpm_set_pp_table` under `adev->pm.mutex`
  from sysfs `pp_table` (`S_IWUSR`)
- [Phase 5] SWSMU `smu_sys_set_pp_table()` already uses the same kmemdup
  + size update
- [Phase 6] `git describe HEAD` = `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` 6.18.53; buggy code in this tree
- [Phase 6] Series 3–5 not in `v6.18.53`; this commit does not require
  them to apply
- [Phase 8] Failure mode: mixed PPTable → wrong GPU PM; trigger = root
  write of a shorter custom table
- UNVERIFIED: Whether anyone requested this on stable@ (lore 403)

**YES**

 .../gpu/drm/amd/pm/powerplay/amd_powerplay.c  | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 5e197c463ed96..05c5e7d19ca1c 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -663,25 +663,20 @@ static int amd_powerplay_reset(void *handle)
 static int pp_dpm_set_pp_table(void *handle, const char *buf, size_t size)
 {
 	struct pp_hwmgr *hwmgr = handle;
+	void *hardcode_pp_table;
 	int ret = -ENOMEM;
 
-	if (!hwmgr || !hwmgr->pm_en)
-		return -EINVAL;
-
-	if (size > hwmgr->soft_pp_table_size)
+	if (!hwmgr || !hwmgr->pm_en || !buf || !size || size > U32_MAX)
 		return -EINVAL;
 
-	if (!hwmgr->hardcode_pp_table) {
-		hwmgr->hardcode_pp_table = kmemdup(hwmgr->soft_pp_table,
-						   hwmgr->soft_pp_table_size,
-						   GFP_KERNEL);
-		if (!hwmgr->hardcode_pp_table)
-			return ret;
-	}
-
-	memcpy(hwmgr->hardcode_pp_table, buf, size);
+	hardcode_pp_table = kmemdup(buf, size, GFP_KERNEL);
+	if (!hardcode_pp_table)
+		return ret;
 
+	kfree(hwmgr->hardcode_pp_table);
+	hwmgr->hardcode_pp_table = hardcode_pp_table;
 	hwmgr->soft_pp_table = hwmgr->hardcode_pp_table;
+	hwmgr->soft_pp_table_size = size;
 
 	ret = amd_powerplay_reset(handle);
 	if (ret)
-- 
2.53.0

