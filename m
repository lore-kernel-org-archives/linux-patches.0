Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D55500A99;
	Mon, 19 Oct 2026 13:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418324; cv=none; b=JLX9j7c2fcJE/dNoaR5oBfsRRhT3XWM8ku5IXjFoZusiq6yRn5txJ4RvFlmL2sKyWusJH/D0TnT0gRTmWyVYzleMP4szBGqsASZaVFivzj4pku8Rv2e3AG3KEEJBSaexD3dyFjnWx9ktNB+gDd6/Lysh4KvpBzs5VFDl9Nw0HLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418324; c=relaxed/simple;
	bh=v4i/sp+jK+cJnVRz6+KH9dDUSk7IzusOS5QKSQau6JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/q9rLbXB3LdYqzLW/qn4Saj5C2WwC2Ws8VAqrrW/+jZqRPNF5MGhYhgFmwySJO8PDFN+5e/ifJ2uVeZg9vBQtSDwYmynzfG6SpKTtH+ReulP/fv4aF4mrJ4AnB2OQ1lL07Ztxq/cgDyFIOAENZrZVxS/A2U4DXvdVcNj+0BTvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkGp9nNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkGp9nNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED561F000C8;
	Mon, 19 Oct 2026 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418319;
	bh=W8xraFxeoKo68zra+pQGrg4F7KTb70uKCPQvmJEHKpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OkGp9nNXkKiP5UoxzypzfMQj1L0W/aqWbfVNF9khX2RG7VQxtpLjLpmQOrLnNvEwX
	 bbqlCLPGBN3w1oBGIDGodzQBXPbuCcNVsxlKuXOsrfGTVwGEDKoaFvKuiOJDFChxcK
	 uG81L9ZCvd4/hBISzxvjUSYcGaXSU0RZoHjUgcsXSOt8VA2pO8iI+AdtaHaqMGQ57q
	 6XL/ypzqcf/s+QSgQ5DiU2SUTl5gm/ewxxj1M5OlPA3P/c2DfSoop+DVsSH76BbQ9y
	 6KIkNnp4nV5H7Uf6ilKFpWBLGCMxDfqZpUNPDwYrHsOlFYKUDKcIuHD/HSBW1mlAlO
	 yCRSdkJC/7Qxg==
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
Subject: [PATCH AUTOSEL 6.18] drm/msm: Move nr_cmds initialization
Date: Mon, 19 Oct 2026 09:47:34 -0400
Message-ID: <20261019135441.1420968-163-sashal@kernel.org>
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

[ Upstream commit 9ee2884ed58e6b39da35732146446d5930e4746b ]

Previously if we entered an error path between these two points, we
could leak the relocs tables due to submit->nr_cmds still being zero.

In practice, relocs are disallowed on a6xx+, and non-ancient userspace
will not use relocs on earlier gens unless running on an ancient kernel.
But userspace could use this to trigger a memory leak.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/743085/
Message-ID: <20260729155609.20190-6-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is mainline **v7.3-rc4**. The change is a real, user-
triggerable reloc-table leak in `MSM_GEM_SUBMIT`; it is small, correct,
and belongs in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[drm/msm] [Move] [initialize `submit->nr_cmds` earlier so
error-path cleanup can free reloc tables]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reported-by: Sashiko <sashiko-bot@kernel.org>` — static-analysis bot,
  not syzbot
- `Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>` — msm
  maintainer / author (ignore any pipeline SOB)
- `Patchwork: https://patchwork.freedesktop.org/patch/743085/`
- `Message-ID: <20260729155609.20190-6-robin.clark@oss.qualcomm.com>` —
  v7 series, this is patch 5/17 (msgid -6 because -1 is the cover)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- No `Tested-by` / `Reviewed-by` / `Acked-by` on the committed message

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** If submit hits an error between reloc `kmalloc` in
  `submit_lookup_cmds()` and the late `submit->nr_cmds = args->nr_cmds`,
  destroy walks `nr_cmds == 0` and skips `kfree(relocs)`.
- **Symptom:** Kernel memory leak; userspace can trigger it via
  `DRM_IOCTL_MSM_GEM_SUBMIT`.
- **Author’s caveat:** Relocs are disallowed on a6xx+; modern userspace
  does not use them on older gens. The author still states userspace can
  force the leak.
- **Version info:** None in the message. Introduced with reloc buffering
  in v5.11-rc1.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. It is an explicit error-path resource-leak fix
(delayed counter vs allocated objects).

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/gpu/drm/msm/msm_gem_submit.c` (+3 / −2)
- Functions: `submit_lookup_cmds()`, `msm_ioctl_gem_submit()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `submit_lookup_cmds()` `kmalloc`s `cmd[i].relocs` then
  `copy_from_user`. `nr_cmds` stays 0 (kzalloc) until after pin/reloc
  parsing, then `submit->nr_cmds = args->nr_cmds`. Any `goto out` in
  between skips that store. `__msm_gem_submit_destroy()` only frees `i <
  nr_cmds`.
- **After:** `submit->nr_cmds = i + 1` immediately after a successful
  `kmalloc`, before `copy_from_user`. The late assignment is removed.
  Failed `kmalloc` does not bump the counter.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** error-path resource leak (ioctl-reachable, repeatable)
- **Mechanism:** counter used as the free loop bound is updated after
  the allocations. Verified destroy path:

```121:122:drivers/gpu/drm/msm/msm_gem_submit.c
        for (i = 0; i < submit->nr_cmds; i++)
                kfree(submit->cmd[i].relocs);
```

`allow_relocs` is false on a6xx+ (`adreno_gpu.c`: `gpu->allow_relocs =
family < ADRENO_6XX_GEN1`), but that check runs **after** lookup
allocates. Userspace with `nr_relocs > 0` allocates, then hits `EINVAL`
“relocs not allowed” and (before this fix) leaked.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: free bound tracks allocated slots.
- Minimal; no API/data-structure change.
- Regression risk is low. Mid-ioctl code uses `args->nr_cmds` /
  `cmds_to_parse`, not `submit->nr_cmds`. `msm_job_run()` / GPU submit
  run only after a successful job push, when `nr_cmds` already equaled
  `args->nr_cmds`.
- Failed `kmalloc` still does not increment, so a NULL slot is not
  `kfree`d.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Reloc `kmalloc` + destroy `kfree` loop: `20224d715a882`
  (“drm/msm/submit: Move copy_from_user ahead of locking bos”),
  **2020-10-23**, in **v5.11-rc1** (`git merge-base --is-ancestor` vs
  v5.10 failed, vs v5.11-rc1 succeeded).
- Late `submit->nr_cmds = args->nr_cmds`: `2e6a8a1fe2b262` (“drm/msm:
  Add VM_BIND ioctl”, 2025-06-29). Before that it was `submit->nr_cmds =
  i` **after** the parse loop; `goto out` inside that loop still skipped
  the store. The leak is older than VM_BIND.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy pattern starts at `20224d715a882`
(v5.11). That commit is an ancestor of this tree.

**Step 3.3: CHECK FILE HISTORY**
Record:
- Same-day series: `0369a2619c50b` SIZE_MAX cleanup, `7aeada642ebfd`
  overflow check — independent, not required for this leak fix.
- Related but different: `ad70e46e130a7` submit error-path unpin order.
- Standalone for the leak; bundled as v7 05/17 “lazy-vm fixes” for
  convenience.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Rob Clark is the msm GEM/submit maintainer. Nearby work is other
submit/VM fixes in the same series.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**
Record: None for this hunk. It only moves an existing store. Applies
standalone on this tree (already applied as `9ee2884ed58e6`).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 9ee2884ed58e6`: https://patch.msgid.link/20260729155609.201
  90-6-robin.clark@oss.qualcomm.com
- `[PATCH v7 05/17] drm/msm: Move nr_cmds initialization`
- Cover: `[PATCH v7 00/17] drm/msm: A couple lazy-vm fixes`
- Revisions v1–v7 of a growing msm series; this leak fix is in v7.
  Applied version is latest.
- Lore HTTP fetch returned 403; full thread read from `b4 dig -m` mbox.
- Sashiko reply on this patch: only **pre-existing** issues (SIZE_MAX in
  `submit_create`, lazy `ctx->vm` NULL). No NAK of the nr_cmds move.
  Those other bugs are other patches in the same series.
- No reviewer `Cc: stable` in the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To dri-devel; Cc linux-arm-msm, freedreno,
Sashiko, Dmitry Baryshkov, Abhinav Kumar, Jessica Zhang, Sean Paul,
Marijn Suijten, David Airlie, Simona Vetter. Subsystem maintainers were
on the original mail. No human Reviewed-by on the git commit.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Reporter is Sashiko (automated). No syzbot/bugzilla. Author
independently describes a userspace-triggerable leak. That description
matches the code.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 17-patch lazy-VM series. This patch does not need 01–04
(ctxlock/queuelock) or 06+ (SIZE_MAX / VM helpers). Standalone leak fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore.kernel.org/stable for this subject found no
relevant thread.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**
Record: `submit_lookup_cmds`, `msm_ioctl_gem_submit`; cleanup via
`__msm_gem_submit_destroy`.

**Step 5.2: TRACE CALLERS**
Record:
- `msm_ioctl_gem_submit` registered with `DRM_RENDER_ALLOW` in
  `msm_drv.c` (`DRM_IOCTL_MSM_GEM_SUBMIT`).
- Reachable from render-node ioctl; not irq, not module init.

**Step 5.3: TRACE CALLEES**
Record: `kmalloc`, `copy_from_user`, later `submit_reloc` /
`allow_relocs` check. Destroy: `kfree(relocs)` gated by `nr_cmds`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: userspace ioctl → `drm_ioctl` → `msm_ioctl_gem_submit` →
`submit_lookup_cmds` → error `goto out` → `submit_cleanup` →
`msm_gem_submit_put` → `__msm_gem_submit_destroy`. Unprivileged GPU
clients (render node) can trigger it.

**Step 5.5: SIMILAR PATTERNS**
Record: `submit_lookup_objects()` already does `submit->nr_bos = i` on
the way out so partial BO lookups are cleaned. Cmds did not have the
analogous update. No sibling drivers with the same bug in this file.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, in this lineage. `git describe HEAD` =
`v7.3-rc4-27-gf0100363d8c37`, `make kernelversion` = `7.3.0-rc4`. Parent
of `9ee2884ed58e6` still has the late assignment and zero `nr_cmds`
during lookup. Bug present since v5.11; this fix is already an ancestor
of HEAD (`git merge-base --is-ancestor 9ee2884ed58e6 HEAD` succeeded).
Decision is still whether the fix has technical merit for this tree, not
whether a pipeline tag exists.

**Step 6.2: BACKPORT COMPLICATIONS**
Record: On this tree the hunk matches current `msm_gem_submit.c`
(VM_BIND-era `args->nr_cmds` store). Clean apply. (Older pre-VM_BIND
trees would delete `submit->nr_cmds = i` instead; that is not this
checkout.)

**Step 6.3: RELATED FIXES ALREADY HERE**
Record: No earlier equivalent. Follow-ups `0369a2619c50b` /
`7aeada642ebfd` are overflow cleanups, not another leak fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **drm/msm GEM submit**. **IMPORTANT** (Qualcomm Adreno; Android
phones and Snapdragon laptops). Not mm/core, but a common production GPU
driver.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Actively developed (VM_BIND, lazy VM, submit locking). Submit
ioctl itself is old and long-lived.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**
Record: Driver-specific (`CONFIG_DRM_MSM`). Anyone who can open the msm
render node.

**Step 8.2: TRIGGER CONDITIONS**
Record:
- Normal submits with `nr_relocs == 0`: `kmalloc(0)` is not a real leak.
- Trigger: `nr_relocs > 0`, then any error after allocation (bad copy,
  lock fail, invalid cmd size, **relocs not allowed on a6xx+**).
- Easy on modern Adreno: pass nonzero relocs; kernel allocates then
  rejects.
- Unprivileged with render-node access. Repeatable; size chosen by
  userspace.

**Step 8.3: FAILURE MODE SEVERITY**
Record: Kernel memory leak in a hot ioctl, unbounded. **HIGH** (DoS /
memory exhaustion). Not panic/UAF/corruption.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** Stops a userspace-triggerable leak on a widely used GPU
  ioctl. High for msm users.
- **Risk:** Very low (3 insertions, 2 deletions; error/cleanup
  accounting only).
- **Ratio:** Strongly favors applying.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real leak: destroy uses `nr_cmds` as the free count; that count was
  updated too late.
- User-triggerable via `DRM_IOCTL_MSM_GEM_SUBMIT` (`DRM_RENDER_ALLOW`).
- On a6xx+ the “relocs not allowed” path is after allocation, so modern
  hardware is included.
- Present since v5.11; still the same mechanism here until this commit.
- 5-line, obviously correct; msm maintainer authored it.
- Matches the common stable class of ioctl error-path leaks.

AGAINST:
- Not a crash/UAF; “only” a leak.
- Honest userspace rarely uses relocs on current gens.
- Found by Sashiko, not a user oops/syzbot.
- Shipped in a 17-patch series (but this patch is independent).
- No `Fixes:` / `Cc: stable` (not a negative per the rules).

UNRESOLVED:
- Lore.kernel.org HTTP 403; discussion recovered via `b4 dig -m`.
- Patchwork HTML was a bot-check page.
- No stable-list thread found.

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintains allocated-vs-freed
   invariant; maintainer-authored; in mainline since v7.3-rc1.
2. Fixes a real bug that affects users? **PASS** — ioctl-reachable leak.
3. Important (crash/security/corruption/deadlock)? **PASS** at HIGH —
   repeatable kernel memory leak / DoS, not CRITICAL crash.
4. Small and contained? **PASS** — +3/−2, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — already the code in this
   checkout.

**Step 9.3: EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/doc exception). It qualifies as a
normal leak fix.

**Step 9.4: DECISION**
This is a small, correct fix for a long-standing, userspace-triggerable
kernel memory leak in msm GEM submit. It meets stable rules for this
tree. Risk is negligible versus the DoS benefit.

------------------------------------------------
What the commit solves for this tree
------------------------------------------------
`submit_lookup_cmds()` allocated per-cmd reloc arrays while
`submit->nr_cmds` stayed 0 until much later in `msm_ioctl_gem_submit()`.
Destroy only frees `cmd[0..nr_cmds)`. Any error in that window leaked
those allocations. Moving `nr_cmds = i + 1` to right after `kmalloc`
makes cleanup free what was allocated, including the common a6xx+
“relocs not allowed” failure.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] Parsed tags: Sashiko Reported-by; Rob Clark SOB; Patchwork
  743085; msgid 20190-6; no Fixes/Cc-stable
- [Phase 2] Diff: +3/−2 in `msm_gem_submit.c`; `nr_cmds = i+1` after
  kmalloc; removed late `nr_cmds = args->nr_cmds`
- [Phase 2] Destroy loop confirmed at lines 121–122; `allow_relocs` set
  false for a6xx+ at `adreno_gpu.c:1209`; check is after lookup
- [Phase 3] `git blame` on parent: reloc alloc from `20224d715a882`
  (v5.11-rc1); late assign from VM_BIND `2e6a8a1fe2b262`
- [Phase 3] `git merge-base --is-ancestor 20224d715a882 v5.11-rc1` yes;
  vs v5.10 no
- [Phase 3] No Fixes: tag to follow
- [Phase 4] `b4 dig -c 9ee2884ed58e6`: lore msgid.link
  20260729155609.20190-6; v7 05/17
- [Phase 4] `b4 dig -a`: v1–v7 series; applied = v7
- [Phase 4] `b4 dig -w`: dri-devel + msm maintainers CC’d
- [Phase 4] mbox: Sashiko comments were pre-existing issues, not a NAK
  of this change; no stable nomination
- [Phase 4] lore WebFetch 403; patchwork served bot-check; stable search
  found nothing relevant
- [Phase 5] Caller: `DRM_IOCTL_DEF_DRV(..., DRM_RENDER_ALLOW)` in
  `msm_drv.c:804`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor 9ee2884ed58e6 HEAD` succeeded;
  parent still has the leak
- [Phase 8] Failure mode: ioctl-triggered kmalloc leak, severity HIGH
- UNVERIFIED: live lore.kernel.org HTML (403); patchwork page body;
  whether any human mailing-list Reviewed-by was dropped on commit

**YES**

 drivers/gpu/drm/msm/msm_gem_submit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 75d9f35743700..2b6b5297f0592 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -260,6 +260,9 @@ static int submit_lookup_cmds(struct msm_gem_submit *submit,
 			ret = -ENOMEM;
 			goto out;
 		}
+
+		submit->nr_cmds = i + 1;
+
 		ret = copy_from_user(submit->cmd[i].relocs, userptr, sz);
 		if (ret) {
 			ret = -EFAULT;
@@ -717,8 +720,6 @@ int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 			goto out;
 	}
 
-	submit->nr_cmds = args->nr_cmds;
-
 	idr_preload(GFP_KERNEL);
 
 	spin_lock(&queue->idr_lock);
-- 
2.53.0

