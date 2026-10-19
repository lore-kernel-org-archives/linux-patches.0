Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE2B502575;
	Mon, 19 Oct 2026 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418725; cv=none; b=bMhDVwvoaUawlGwpmjEGkIxvZosVTG8vxK5Vu4c7OEb/AJH0mfR3WetCHbQ/jLq7Xr9CxHw85wDl2wYmEgxDSqXIUKiyPTTitFIMBrtsCfZ6Ae7OTM6fcBdADmjDlx6rXGc1g12LoKoFG5C8Rb9YSUD5267dh003qbR4zhKiKgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418725; c=relaxed/simple;
	bh=py4eFetGP1da8ome80OHmcGkj3eTHPtBq2lC6brfgQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iBfkFipeCTNgwbtmc3V9pWL2w1M6q6Mldn8gFhK2qpKcqMB3s6VeSgOCnoOmdw6ZFEnKcIOoJcs0Wj887M/gw/uH4zHxJgG0ngHDjG6evaP8R+I7CIoS5ZqY17DOwliWjgXwUPD/cuA155TU7tdaces67U8+9WMIRsErhWRWnr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MnOrGbpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnOrGbpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70E71F000C4;
	Mon, 19 Oct 2026 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418722;
	bh=dbCcNERBX+rxiX7NjAejDaHugEo09PdEW6O3V4KTiIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MnOrGbpQRqiP9L0tDDFOyse9UYIjqB26RNr3hXFyL5sMYzObitoAZvkdeiJc6KF2W
	 xizmUVpCpY+j59vqO8v98YeyVhm/CpcK4hnNnNAJzAtaQXK6m69c4RAcnvuIn9eLdS
	 wVpbsMIX6lbssw4wul+aipMOreAEeGXRv3+i4VuRIq5M+App020sSJCRmoPnjXVVMX
	 mTh/RVd2immcUQTwnoCEWwE9XaliStcLdA9Di16mX/xV6yBCscIwZMHU78FwHFTEGQ
	 ooYHq1bfDQHwMaJKbazI0o5wZuI5BgbZb/be+u1XtQlTbIhZahcBs488DBjbJrKER5
	 EbRZudEjNXELQ==
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
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amd/pm: Validate pp_table header before reading size
Date: Mon, 19 Oct 2026 09:52:20 -0400
Message-ID: <20261019135441.1420968-449-sashal@kernel.org>
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

[ Upstream commit a17e79d01f22182a9fcbe79fcbe2ad1477d43e0f ]

smu_sys_set_pp_table() reads usStructureSize from the uploaded
pp_table buffer before validating that the buffer contains a complete
ATOM_COMMON_TABLE_HEADER. A short write can therefore make the driver
read past the supplied sysfs buffer.

Reject empty or header-short uploads before dereferencing the header
pointer.
Keep the existing structure-size check for the full uploaded table.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The short-write path can install a 1-byte table and then SMU re-init
walks it as a full PowerPlay struct, which is a real heap OOB. The rest
of the write-up is the 9-phase analysis for this 6.18.53 tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[drm/amd/pm] [Validate] Validate pp_table header before
reading size.** Intent is to reject undersized sysfs uploads before the
driver reads `usStructureSize` from the buffer.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Yang Wang <kevinyang.wang@amd.com> (author)
- Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
- Signed-off-by: Alex Deucher <alexander.deucher@amd.com> (amdgpu
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence
  expected)
- Pipeline-added tags (ignored): `[Upstream commit
  a17e79d01f22182a9fcbe79fcbe2ad1477d43e0f]`, Signed-off-by: Sasha Levin

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `smu_sys_set_pp_table()` reads `usStructureSize` from the
  uploaded buffer before checking that the buffer holds a full
  `ATOM_COMMON_TABLE_HEADER`.
- Symptom: a short sysfs write can make the driver read past the
  supplied buffer.
- Fix: reject empty or header-short uploads, keep the existing
  structure-size match check.
- No stack trace, syzbot, or version range in the message.
- Root cause (author): missing length check before header dereference.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Yes, there is a hidden fix. Besides the header check, the hunk
also replaces `kfree` + `kzalloc` + `memcpy` with `kmemdup` then `kfree`
of the old pointer. That is not called out as a UAF fix, but it stops
the driver from freeing the live table and then failing the realloc,
which leaves `power_play_table` dangling. That UAF exists in this tree
because of `1abb2648698bf1` (`drm/amdgpu: avoid buffer overflow attach
in smu_sys_set_pp_table()`), which is in v6.18.53.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c` (+11 / −8, net +3)
- Function: `smu_sys_set_pp_table()` only
- Scope: single-file surgical change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: cast `buf` to `ATOM_COMMON_TABLE_HEADER *` immediately;
  compare `header->usStructureSize` with `size`; if the existing
  hardcoded table is missing or too small, `kfree` it then
  `kzalloc`/`memcpy`.
- After: require `buf` and `size >= sizeof(*header)` first; then compare
  structure size; `kmemdup` the upload; only then `kfree` the old table
  and swap pointers.
- Path affected: sysfs store of `pp_table` (error/validation and
  allocation), not the get path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: memory safety (short-write / OOB) plus error-path UAF.
- Mechanism: `ATOM_COMMON_TABLE_HEADER` is 4 bytes (`USHORT
  usStructureSize` + 2× `UCHAR`). The old code only needed a 2-byte read
  of `usStructureSize`. A 1-byte write of `0x01` plus kernfs’s trailing
  NUL makes `usStructureSize == 1 == size`, so the driver accepts a
  1-byte table, then `smu_reset()` → `check_powerplay_table()` casts
  that 1-byte allocation to `smu_11_0_powerplay_table` /
  `smu_13_0_0_powerplay_table` and reads `platform_caps`,
  `thermal_controller_type`, and `overdrive_table`. That is a heap OOB.
  The `kmemdup`-first change also fixes the ENOMEM UAF: old code
  `kfree`d `hardcode_pptable` (which `power_play_table` still pointed
  at) before `kzalloc`; on failure `hardcode_pptable` is NULL and
  `power_play_table` is dangling.

Step 2.4: ASSESS THE FIX QUALITY
Record: The header check is obviously correct. `kmemdup` then free is
the same pattern already used by `pp_dpm_set_pp_table()`. Regression
risk is low: always reallocating on write is extra `GFP_KERNEL` traffic
under `adev->pm.mutex`, but the grow path already allocated there. No
API change. Slight remaining gap: a 4-byte upload with matching
`usStructureSize` can still be smaller than the ASIC pptable struct;
that is pre-existing and not a reason to drop this incremental fix.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Unchecked `header->usStructureSize` came from `289921b03fe5e2`
(“drm/amd/powerplay: implement sysfs of pp_table for smu11 (v2)”,
2019-01-11), present by v5.2 (`git describe --contains` →
`v5.2-rc1~...`). The realloc-on-grow `kfree`/`kzalloc` came from
`1abb2648698bf1` (2025-02-07, Cc: stable) and is in v6.18.53.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Related commits on this file: `1abb2648698bf1` (overflow on
grow), `8c685df5c3b26` (get/set UAF race, in v6.18.53), `2895aeb4327c9`
(pp_table sysfs visibility). This patch is standalone for SMU; it is 1/5
of a later bounds-hardening series whose other patches touch legacy
powerplay, not this function.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Yang Wang is an AMD PM contributor (many pptable bounds
patches). Hawking Zhang reviewed; Alex Deucher applied. Nearby author
work is the rest of the 1/5 series (legacy hwmgr bounds), not a
dependency of this hunk.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers. `kmemdup()`, `ATOM_COMMON_TABLE_HEADER`, and
`smu_sys_set_pp_table()` all exist in this tree. Applies standalone.
Series patches 2–5 are independent files (`amd_powerplay.c` / hwmgr
parsers).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c a17e79d01f22182a9fcbe79fcbe2ad1477d43e0f` → https://patch.m
  sgid.link/20260623034151.263746-1-kevinyang.wang@amd.com
- `b4 dig -a`: only v1 of `[PATCH 1/5]`; no later revision.
- Thread: Hawking Zhang: “Series is Reviewed-by: Hawking Zhang”. No NAK,
  no stable nomination in the thread.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` recipients: Yang Wang, amd-gfx, Alexander Deucher,
Hawking Zhang, Kenneth Feng. Maintainer and PM reviewers were on the
original To/Cc.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by, syzbot, or bugzilla. Bug is from code audit of
the sysfs store, not a user crash report.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 5-patch series (Jun 23 2026): (1) this SMU header check, (2)
legacy custom PPTable size, (3) Tonga state array, (4) Vega hwmgr
bounds, (5) legacy hwmgr offsets. Patch 1 is self-contained. 2–5 are not
in v6.18.53 and are not required for this function.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: UNVERIFIED. `https://lore.kernel.org/stable/?q=...` returned
HTTP 403.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `smu_sys_set_pp_table()` only.

Step 5.2: TRACE CALLERS
Record: Wired as `swsmu_pm_funcs.set_pp_table`. Call chain: sysfs store
`amdgpu_set_pp_table()` → `amdgpu_dpm_set_pp_table()` (takes
`adev->pm.mutex`, already rejects `!buf || !size`) →
`pp_funcs->set_pp_table()`. No other callers. Attribute is
`AMDGPU_DEVICE_ATTR_RW(pp_table, ...)` with `S_IRUGO | S_IWUSR` (root
write, world read).

Step 5.3: TRACE CALLEES
Record: After install, `smu_reset()` → `smu_hw_fini` / `smu_hw_init` /
`smu_late_init`, which runs ASIC `check_powerplay_table()` on
`smu_table.power_play_table`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable from userspace via
`/sys/class/drm/cardX/device/pp_table`. Root-only write. Confirmed
`navi10_check_powerplay_table()` / `smu_v13_0_0_check_powerplay_table()`
dereference `power_play_table` as a full struct with no extra size
check. A matching short write therefore becomes a heap OOB on SMU re-
init, not only a 2-byte header peek.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Legacy `pp_dpm_set_pp_table()` already uses `kmemdup` + `kfree`.
Prior SMU overflow fix `1abb2648698bf1` is the sibling. Same author’s
later series hardens hwmgr parsers.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is **6.18.53** (`git describe HEAD` →
`v6.18.53-5049-g0f0bdc2b0dffb`, `Makefile` VERSION=6 PATCHLEVEL=18
SUBLEVEL=53). At `v6.18.53`, `smu_sys_set_pp_table()` still casts `buf`
before any length check and still does `kfree` then `kzalloc` on grow.
Bug introduced 2019; realloc UAF introduced by `1abb2648698bf1`, which
**is** an ancestor of v6.18.53.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected **clean apply**. The v6.18.53 function body matches the
patch’s “before” hunk. `kmemdup` is already used in this tree.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: The grow-overflow fix (`1abb2648698bf1`) and get/set UAF race
fix (`8c685df5c3b26`) are in v6.18.53. Neither adds the header-length
check or the allocate-before-free swap. No substitute for this patch.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **drm/amd/pm** (AMDGPU SMU powerplay). Criticality:
**IMPORTANT** — common dGPU/APU driver, not core mm/VFS, but widely
deployed.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active. Recent history includes SMU 15.x enablement, pptable
visibility, and several pptable safety fixes. Mature sysfs `pp_table`
path dating to v5.2.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: AMDGPU SWSMU users (Navi and later) with `pp_table` sysfs
visible. Driver-specific. Write is root-only; a failed grow plus later
read is world-readable (`S_IRUGO`).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Short write: `printf '\x01' > pp_table` (or any write with `count < 4`
  that still makes `usStructureSize == count`). Then `smu_reset()`
  parses the truncated table.
- UAF: successful custom table, then a larger upload whose `kzalloc`
  fails.
- Unprivileged users cannot write; they can read after a failed root
  grow. Not a remote unprivileged exploit; still a real local root/admin
  and overclocking-tool path.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Heap OOB during SMU re-init if a short matching table is
accepted → crash / KASAN OOB. ENOMEM grow path → UAF on later
`get_pp_table` (memcpy from dangling `power_play_table`). Severity:
**HIGH**.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit **high** (OOB + UAF on a sysfs node this tree already
treated as overflow-sensitive). Risk **low** (~19 lines, one function,
same pattern as legacy powerplay). Ratio favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real short-write bug: matching `usStructureSize` on a 1-byte upload
  installs a 1-byte table; SMU re-init walks it as a full pptable (heap
  OOB). Verified in `navi10_check_powerplay_table()` and
  `smu_v13_0_0_check_powerplay_table()`.
- Real UAF on realloc-fail, left by in-tree `1abb2648698bf1`.
- Small, obviously correct, maintainer-signed, AMD-reviewed.
- Buggy code is in v6.18.53; patch applies cleanly; no missing APIs.
- Same class of pptable sysfs safety as prior stable commits in this
  tree.

AGAINST:
- Write requires root (`S_IWUSR`).
- No syzbot/user report.
- Header check does not fully prove the table is large enough for every
  ASIC struct (pre-existing).
- Always-`kmemdup` is a minor extra allocation.

UNRESOLVED:
- Stable mailing-list search (lore 403).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — length check + allocate-
   before-free; reviewed by Hawking Zhang, applied by Deucher.
2. Fixes a real bug that affects users? **PASS** — short `pp_table`
   write and realloc-fail UAF.
3. Important issue? **PASS** — heap OOB / UAF (HIGH), not a style
   cleanup.
4. Small and contained? **PASS** — one function, +11/−8.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — v6.18.53 has the old hunk.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/doc exception. Qualifies as a
normal bugfix.

Step 9.4: MAKE YOUR DECISION
This belongs on 6.18.y. The tree has the unchecked header read (since
2019) and the kfree-before-realloc UAF from a previous stable overflow
fix. The change is small, matches an existing powerplay pattern, and
prevents a truncated custom pptable from being fed into SMU re-init.

Verification:
- [Phase 1] Parsed tags: author Yang Wang, Reviewed-by Hawking Zhang,
  SOB Alex Deucher; no Fixes/syzbot/Cc stable.
- [Phase 2] Diff: `smu_sys_set_pp_table()` in `amdgpu_smu.c`, +11/−8;
  header length check + `kmemdup` before `kfree`.
- [Phase 2] `ATOM_COMMON_TABLE_HEADER` is 4 bytes in
  `drivers/gpu/drm/amd/include/atombios.h` / radeon `atombios.h`.
- [Phase 3] `git blame` at v6.18.53: header read from `289921b03fe5e2`
  (v5.2); realloc from `1abb2648698bf1` (in v6.18.53).
- [Phase 3] `git merge-base --is-ancestor 1abb2648698bf1 v6.18.53` →
  YES.
- [Phase 4] `b4 dig -c a17e79d01f22`: lore msgid
  `20260623034151.263746-1-kevinyang.wang@amd.com`; v1 only; Hawking R-b
  on the series.
- [Phase 4] `b4 dig -w`: amd-gfx, Deucher, Hawking, Kenneth Feng.
- [Phase 4] UNVERIFIED: lore.kernel.org/stable HTTP 403.
- [Phase 5] Callers: only sysfs `amdgpu_set_pp_table` →
  `amdgpu_dpm_set_pp_table` → SMU `set_pp_table`.
- [Phase 5] `smu_reset()` → hw_init → `navi10_check_powerplay_table()`
  dereferences full `smu_11_0_powerplay_table` with no size check.
- [Phase 5] kernfs write path (`fs/kernfs/file.c`) `kmalloc(len+1)`: a
  1-byte write is a 2-byte alloc, so the 2-byte `usStructureSize` peek
  is in-bounds of that alloc; the serious OOB is after accepting size==1
  and parsing the 1-byte table.
- [Phase 6] `git describe HEAD`: v6.18.53-5049-g0f0bdc2b0dffb; `make
  kernelversion` 6.18.53.
- [Phase 6] `git show
  v6.18.53:drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c`: old buggy
  function present; new `size < sizeof(*header)` check absent.
- [Phase 6] `git merge-base --is-ancestor a17e79d01f22 HEAD` → upstream
  SHA not in this history (expected for a candidate).
- [Phase 8] Failure mode: heap OOB on SMU re-init and UAF after failed
  grow; severity HIGH.
- UNVERIFIED: whether this hash was discussed on the stable list.

**YES**

 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 8473eaac1e7fc..f9f981877ef30 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -636,25 +636,28 @@ static int smu_sys_set_pp_table(void *handle,
 {
 	struct smu_context *smu = handle;
 	struct smu_table_context *smu_table = &smu->smu_table;
-	ATOM_COMMON_TABLE_HEADER *header = (ATOM_COMMON_TABLE_HEADER *)buf;
+	ATOM_COMMON_TABLE_HEADER *header;
+	void *hardcode_pptable;
 	int ret = 0;
 
 	if (!smu->pm_enabled || !smu->adev->pm.dpm_enabled)
 		return -EOPNOTSUPP;
 
+	if (!buf || size < sizeof(*header))
+		return -EINVAL;
+
+	header = (ATOM_COMMON_TABLE_HEADER *)buf;
 	if (header->usStructureSize != size) {
 		dev_err(smu->adev->dev, "pp table size not matched !\n");
 		return -EIO;
 	}
 
-	if (!smu_table->hardcode_pptable || smu_table->power_play_table_size < size) {
-		kfree(smu_table->hardcode_pptable);
-		smu_table->hardcode_pptable = kzalloc(size, GFP_KERNEL);
-		if (!smu_table->hardcode_pptable)
-			return -ENOMEM;
-	}
+	hardcode_pptable = kmemdup(buf, size, GFP_KERNEL);
+	if (!hardcode_pptable)
+		return -ENOMEM;
 
-	memcpy(smu_table->hardcode_pptable, buf, size);
+	kfree(smu_table->hardcode_pptable);
+	smu_table->hardcode_pptable = hardcode_pptable;
 	smu_table->power_play_table = smu_table->hardcode_pptable;
 	smu_table->power_play_table_size = size;
 
-- 
2.53.0

