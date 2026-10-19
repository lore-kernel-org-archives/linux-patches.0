Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95573633FFC;
	Mon, 19 Oct 2026 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418740; cv=none; b=BDPDBk02cOICmOAReUS+7QO1JEKy8OcXrNKotv5wYhqQ0xoa910LON8HtaGiQ8+IoZ9quTh2oQXhmSewe4ULi55ijJ+W+jW5rcCyrfE/6YQjESxlm4pcWk+pn/nCBHpdtSR4z4cKSn4nUA5XLU4d/QlFUh2YOy7IbIDQsAyx+Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418740; c=relaxed/simple;
	bh=YLEW8b9yzMQh23dskidj1VjEIgIpLbNfFgxFzUnHCx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2kDTgCZQZW/SVr5eJPyr2XCMWR627tsveajIwfW5N8TdqVmMfSdfkUHV4bPHPVyRGQcmL8t1g4PrOZdBH/w31r7RAA1cYLbEYnVO5h+EZUjQpRXEGOMo5EeT4ayt50qmT2tf4SSQsaUh871NasoqrRyoJkxOQwQ8ruSnP+f9Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wu2GkV8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wu2GkV8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5157D1F000C4;
	Mon, 19 Oct 2026 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418737;
	bh=/jENeapoUpAI6q7vl04UYeMepe/HJl9hNAbGI/jzFjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wu2GkV8JyU/ge3t50zLChNMSpvHxcEHrufNR5Y70i7RGRwmE5MLlbud3AI1JZcNZR
	 Agv3rKc/gkGyyW5zU4TdOtUwW0GyngW2bNtvutonAJKuOfrX+uo6AAGz+pFaKUDwkV
	 A00f4MmLVHa0HXVCo7dwq2jk/g8y8NHO6E7DCnDbyCyGtr8+iEAuBxikD6b2Sls0He
	 vFLYpkqP3xXUAn1UOOKIomQiomhi4Yr+odMGlArkWdzzcEHD3G+5XmUIDHFysT68ES
	 q8Ae8bTUHC7eR/NRZIYw9khGUZsDzRyKV88oMon571leh8SyFRfleRpAdS94NdfVt2
	 sdDT3OuQ22OPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rob Clark <robin.clark@oss.qualcomm.com>,
	Sashiko <sashiko-bot@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lumag@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/msm: Fix barriers accessing ctx vm
Date: Mon, 19 Oct 2026 09:52:31 -0400
Message-ID: <20261019135441.1420968-460-sashal@kernel.org>
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

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit ae88499d71ce80ecd25c055eddddace108266321 ]

Don't rely on store ordering to protect us from caller seeing a
partially initialized vm.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/743079/
Message-ID: <20260729155609.20190-2-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline `7.3.0-rc4`). This commit is a
real ARM memory-ordering fix in lazy GPU VM creation: without
acquire/release, a concurrent ioctl can observe a partially initialized
VM. The change is small, already in this 7.3 lineage, and is appropriate
to keep here.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[drm/msm] [Fix] [barriers when publishing the lazily created
context VM]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reported-by: Sashiko <sashiko-bot@kernel.org>` — AI review bot
  (sashiko.dev), **not** syzbot; static/review finding, no reproducer
- `Signed-off-by: Rob Clark` — MSM Adreno GPU maintainer (ignore any
  Sasha Levin SOB)
- `Patchwork: https://patchwork.freedesktop.org/patch/743079/`
- `Message-ID: <20260729155609.20190-2-robin.clark@oss.qualcomm.com>` —
  **patch 01/17** of a series (msgid `-2` after cover `-1`)
- **No** `Fixes:`, **no** `Cc: stable`, **no** `Reviewed-by` / `Tested-
  by` / `Acked-by` on the committed message (absence of stable tags is
  expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** lazy `ctx->vm` publication used a plain store; a concurrent
  reader could see a non-NULL pointer before VM fields were visible
- **Symptom:** caller observes a **partially initialized VM** (GPU
  IOVA/page-table garbage, kernel deref of uninitialized `drm_gpuvm`
  fields)
- **Version info:** none in the message
- **Root cause (author):** “Don't rely on store ordering” — classic
  double-checked locking without acquire/release. MSM runs on ARM64,
  where that ordering is **not** guaranteed

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Explicit “Fix” plus a documented memory-ordering
hole. The `mutex_lock` → `guard(mutex)` swap is incidental cleanup
around the real barrier change.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/msm/msm_drv.c` — **+7 / -6** (13-line hunk)
- Function: `msm_context_vm()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (before → after):
- Fast path: plain `if (ctx->vm) return ctx->vm` → `vm =
  smp_load_acquire(&ctx->vm); if (vm) return vm`
- Slow path: `mutex_lock` / assign `ctx->vm` / `mutex_unlock` →
  `guard(mutex)` then `smp_store_release(&ctx->vm, vm)`
- Path: concurrent first-use of a DRM context (ioctl), not init-only and
  not an error path

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Synchronization / memory ordering + KCSAN-class data race]**
- Double-checked locking: unlocked read of `ctx->vm` vs locked write
- Broken mechanism: pointer published with a plain store; reader can use
  the object before initialization is visible
- Fix: standard publication pattern (`smp_store_release` /
  `smp_load_acquire`)

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct** DCL publication
- Mutex still serializes creation; acquire/release only publishes the
  pointer
- `guard(mutex)` is equivalent to lock/unlock (cleanup.h)
- Regression risk: **low**. Inner `if (!ctx->vm)` remains a plain load
  **under the mutex** (fine). Return after the slow path is also under
  the mutex, so mutex acquire pairs with the other thread’s
  `smp_store_release`
- Pre-existing issue **not** introduced here:
  `msm_gpu_create_private_vm()` can return `ERR_PTR`/`NULL` and that
  value was already stored; later `00dfa76bdfc2f` added `IS_ERR_OR_NULL`
  before the release store

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Lazy VM helper: `6bf32afd37eb6` (“drm/msm: Lazily create context VM”,
  2025-06-29)
- Unlocked DCL + `init_lock`: `feb8ef4636a457` (“drm/msm: Add opt-in for
  VM_BIND”, same day)
- **First appeared:** **v6.17-rc1** (`git describe --contains` / `git
  merge-base --is-ancestor 6bf32afd37eb6 v6.17`)
- Present for many releases before 7.3

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No `Fixes:` tag.** Buggy code is the lazy-VM DCL above.
Confirmed ancestor of this HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (same series, after this commit):
- `ea69d489d3a68` — queuelock → `ctxlock` (patch 02/17)
- `2c26f9e46d395` — VM creation on `ctxlock` instead of static
  `init_lock` (patch 03/17); **keeps** the acquire/release from this
  patch
- `00dfa76bdfc2f` — don’t cache `ERR_PTR` in `ctx->vm` (patch 14/17)
This patch is **standalone**. Later patches refine locking/errors; they
are not prerequisites for the barriers.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: **Rob Clark is the Qualcomm Adreno GPU maintainer**
(`MAINTAINERS`: “DRM DRIVER for Qualcomm Adreno GPUs”). He authored the
buggy lazy-VM code and this fix.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `msm_context_vm()` / lazy `ctx->vm` (in this tree since
6.17). Uses `guard(mutex)` and `smp_load_acquire`/`smp_store_release`
(present in 7.3). **Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c ae88499d71ce8` matched patch-id; lore URL `https://patch.ms
  gid.link/20260729155609.20190-2-robin.clark@oss.qualcomm.com`
- `b4 dig -a` revisions: v1 (different subject) → **v2–v7 this
  subject**; applied version is **v7 01/17** (latest)
- Cover (v7 00/17): *“The VM is created lazily to give userspace a
  chance to opt-in to VM_BIND. But Sashiko noticed a couple paths that
  were not handling this properly.”*
- **No NAK** in the saved thread. No human reviewer replies in that mbox
  (only Sashiko)
- Sashiko on this patch: called remaining `ctx->vm` plain reads /
  `ERR_PTR` caching **pre-existing**, not regressions from this hunk
- Direct lore/WebFetch: **403 (Anubis)**; used `b4 dig -m` instead

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included `dri-devel`, `linux-arm-msm`,
`freedreno`, Sashiko, **Dmitry Baryshkov, Abhinav Kumar, Jessica Zhang,
Sean Paul, Marijn Suijten, David Airlie, Simona Vetter**. Right
lists/maintainers; **no `Reviewed-by` on the commit**.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Sashiko is an **AI review bot**, not a fuzzer with a crash log.
Cover letter confirms it flagged lazy-VM handling. Severity comes from
the **code**, not a user bugzilla.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Started as a small lazy-VM series, grew to **17 patches**. This
one stayed patch 1 from v2 onward and does not depend on 02–17.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search **blocked (403)**. **UNVERIFIED**
whether stable@ discussed this. No `Cc: stable` on the patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `msm_context_vm()`; callee `msm_gpu_create_private_vm()`.

**Step 5.2: TRACE CALLERS**
Record (this tree):
- `msm_ioctl_gem_info_iova` / `msm_ioctl_gem_info_set_iova` — GEM ioctls
- `msm_ioctl_gem_submit` — GPU submit (hot path)
- `msm_ioctl_vm_bind` — VM_BIND ioctl
- `msm_gem_new_handle` — `MSM_BO_NO_SHARE` GEM_NEW
- `msm_submitqueue_create` — VM_BIND submitqueue
- `adreno_get_param` — GET_PARAM
All are **userspace ioctl paths** except destroy/close helpers that read
`ctx->vm` after lifetime rules.

**Step 5.3: TRACE CALLEES**
Record: `msm_gpu_create_private_vm()` may call
`gpu->funcs->create_private_vm`, take a pid ref, or fall back to the
global VM. Returned object is expected to be fully set up **before** the
pointer is published — that is exactly what `smp_store_release` is for.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Unprivileged GPU client (Mesa/VK) opens `/dev/dri/renderD*`,
then two threads hit GEM_SUBMIT/GEM_NEW/GET_IOVA before VM exists.
**Reachable from userspace. Common** for multi-threaded GL/Vulkan.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other `ctx->vm` reads still exist (`msm_gem_close`,
`a6xx_set_pagetable`, `msm_submitqueue` destroy, `EN_VM_BIND`).
Close/destroy/submit-pagetable run after VM exists or on teardown.
Sashiko noted `msm_gem_close` still uses a plain load; that does not
make **this** publication barrier wrong.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` → **7.3.0-rc4**
- Buggy DCL **did exist** here (6.17 through 7.2); this commit is
  **already an ancestor of HEAD** and is in **v7.3-rc1** (`git merge-
  base --is-ancestor ae88499d71ce8 v7.3-rc1`; **not** in v7.2)
- Current `msm_context_vm()` still uses `smp_load_acquire` /
  `smp_store_release` (later switched lock to `ctxlock`)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Against **current HEAD**, this exact diff would **not** apply
(lock is `ctxlock`, plus `IS_ERR_OR_NULL`). Against the **pre-fix**
`msm_context_vm()` that this 7.3 series actually shipped from, it
applied cleanly (that is how it landed). Difficulty for this series:
**clean when needed; already present now**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This fix plus later series commits (`2c26f9e46d395`,
`00dfa76bdfc2f`, …) are already in this checkout. No alternate older
barrier fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drm/msm (Qualcomm Adreno GPU)** — **IMPORTANT** (phones,
Chromebooks, embedded), not core mm/vfs, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: **Active** (Rob Clark still landing msm fixes on this tree). Bug
is in relatively new (6.17) VM_BIND/lazy-VM code, not ancient dead code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific** (`CONFIG_DRM_MSM`),
Qualcomm Adreno users. Large production population, not a toy driver.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: two threads racing first `msm_context_vm()` on the same
  `drm_file`
- Likelihood: **realistic** for multi-threaded GPU clients; first
  submit/new/iova after open
- Unprivileged: **yes** (render node ioctls)

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Partially initialized `drm_gpuvm` → kernel oops on VM field
access and/or bad GPU pagetable/IOVA programming. **HIGH** (crash and
possible GPU mapping corruption). Not a panic in every case, but not
cosmetic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: high** — closes a real ARM publication race on a hot ioctl
  path
- **Risk: very low** — ~13 lines, standard barriers, no API/ABI change
- **Ratio: strongly favors including the fix**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real double-checked-locking / weak-memory bug on ARM64 (this driver’s
  CPU)
- Userspace-reachable concurrent ioctl path
- Small, obviously correct acquire/release
- Maintainer-authored; series reviewed on dri-devel / freedreno
- Sashiko flagged the class of lazy-VM mistakes (even though it is not
  syzbot)
- Buggy code existed in this lineage from **v6.17**; 7.3 includes that
  code
- No new feature or uAPI

**AGAINST:**
- No `Reviewed-by`; no runtime reproducer (AI bot, not syzbot)
- Later series patches still touch the same function (not required for
  this hunk)
- Other `ctx->vm` readers still use plain loads (incomplete coverage,
  not a wrong fix)
- lore.kernel.org/stable discussion **unverified** (HTTP 403)

**UNRESOLVED:**
- Whether anyone nominated this on stable@ (could not fetch lore/stable)
- No public crash log; impact inferred from the race, not a filed user
  report

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — textbook publication
   barriers; in mainline 7.3; maintainer-authored
2. Fixes a real bug that affects users? **PASS** — concurrent first-use
   of per-context GPU VM
3. Important issue (crash/security/corruption/deadlock)? **PASS** —
   **HIGH**: crash and/or GPU mapping corruption on ARM
4. Small and contained? **PASS** — one function, ~13 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `msm_context_vm()` exists
   here; this is the 7.3 tree the fix landed in

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **None** (not an ID/quirk/DT/build/docs exception). It qualifies
as a normal important bugfix.

**Step 9.4: MAKE YOUR DECISION**
This tree is **7.3.0-rc4**. The lazy VM and the DCL race are in this
series. The patch is a contained memory-ordering fix on a userspace GPU
ioctl path. Risk is low; skipping it would leave Qualcomm GPU users
exposed to a partially initialized VM. It belongs in this tree’s stable
lineage.

---

### What the commit solves for this tree
`msm_context_vm()` creates the per-process GPU VM on first use so
userspace can opt into VM_BIND. Two threads can hit that helper at once.
The fast path used a plain load of `ctx->vm` and the creator used a
plain store. On ARM64 that can make a reader see the pointer before the
VM object is initialized. `smp_store_release` / `smp_load_acquire` close
that hole.

### Stable rules / risk
Meets the stable criteria: real, important, small, no new API. Benefit
(avoid crash/bad GPU mappings) dwarfs the risk of a 13-line barrier
change.

### Concerns
- Follow-ups in the same series change the lock and error handling; they
  are **not** required for this barrier fix to be correct.
- Sashiko is an AI reviewer, not syzbot; the race is still real on this
  hardware.
- Applying **this exact diff** to current HEAD would conflict because
  later 7.3 commits already evolved the function — that is expected; the
  fix is already in v7.3-rc1.

---

Verification:
- [Phase 1] Parsed tags: `Reported-by: Sashiko`, Patchwork 743079, msgid
  `20190-2` (01/17); no Fixes/Cc:stable/Reviewed-by
- [Phase 2] Diff: +7/-6 in `msm_context_vm()`; acquire on read, release
  on publish, `guard(mutex)`
- [Phase 2] Compared `git show ae88499d71ce8^` vs `ae88499d71ce8` for
  that function
- [Phase 3] `git blame` on parent: DCL from `feb8ef4636a457` /
  `6bf32afd37eb6` (2025-06-29)
- [Phase 3] `git merge-base --is-ancestor 6bf32afd37eb6 v6.17` → yes;
  `ae88499d71ce8` in v7.3-rc1, **not** in v7.2
- [Phase 3] Follow-ups `2c26f9e46d395` / `00dfa76bdfc2f` confirmed; they
  keep/extend barriers, not replace the need for them
- [Phase 4] `b4 dig -c ae88499d71ce8` →
  patch.msgid.link/20260729155609.20190-2-…
- [Phase 4] `b4 dig -a`: v2–v7; applied = v7 01/17
- [Phase 4] `b4 dig -w`: MSM maintainers + dri-devel/freedreno CC’d
- [Phase 4] `b4 dig -m`: cover letter + Sashiko reply; no NAK; Sashiko
  issues labeled pre-existing
- [Phase 4] WebFetch lore/stable/patchwork: **403 Anubis** — UNVERIFIED
  via HTTP
- [Phase 5] `git grep msm_context_vm`: ioctl callers in msm_drv,
  msm_gem, msm_gem_submit, msm_gem_vma, msm_submitqueue, adreno_gpu
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Current `msm_context_vm()` still has
  smp_load_acquire/smp_store_release
- [Phase 7] MAINTAINERS: Rob Clark maintains drm/msm Adreno
- [Phase 8] Failure mode: partially initialized VM → oops / bad GPU
  maps; severity HIGH
- UNVERIFIED: stable@ mailing list discussion (lore 403)

**YES**

 drivers/gpu/drm/msm/msm_drv.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index c2a8aaa33f84a..8094e5e7e9a54 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -226,18 +226,19 @@ struct drm_gpuvm *msm_context_vm(struct drm_device *dev, struct msm_context *ctx
 {
 	static DEFINE_MUTEX(init_lock);
 	struct msm_drm_private *priv = dev->dev_private;
+	struct drm_gpuvm *vm = smp_load_acquire(&ctx->vm);
 
 	/* Once ctx->vm is created it is valid for the lifetime of the context: */
-	if (ctx->vm)
-		return ctx->vm;
+	if (vm)
+		return vm;
+
+	guard(mutex)(&init_lock);
 
-	mutex_lock(&init_lock);
 	if (!ctx->vm) {
-		ctx->vm = msm_gpu_create_private_vm(
+		vm = msm_gpu_create_private_vm(
 			priv->gpu, current, !ctx->userspace_managed_vm);
-
+		smp_store_release(&ctx->vm, vm);
 	}
-	mutex_unlock(&init_lock);
 
 	return ctx->vm;
 }
-- 
2.53.0

