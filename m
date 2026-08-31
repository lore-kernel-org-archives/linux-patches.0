Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C3A4AC141;
	Mon, 31 Aug 2026 13:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184019; cv=none; b=m7vwOHnxMu0iINK+Y2lCcOh2KE5xVk3M/XfBaDwnXwYPlFRw9HZyaQPh7aE3I0E6DnqOpTls1Rb2NHmGLWbXdYbjSIhE3Tlx6geuXUzaf/D7EnqZhFAsdCAd/MapQNau2X56bwoasIBKdtkQ0/wjDggV+JdPCfKeFD9xiSAU2NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184019; c=relaxed/simple;
	bh=Kj7TkwJAVpR5UHf6sZ9+aiWtwMhxFEjBv3Hyq+cvsjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hggrP8C97cKPl2do3evGCxlULYNzrbuO6rtGcAeDut0zuQMZS4l25vO9OwhkOohYLQcyUgH6CQKTX8cIefMfW1DAowseDCpHAOLKkpPAgsNZaYfmViq6ioTSqyJJ22sZ39rrsm8e754IyKiosDQ2Gzbv7peQHP+NMXxgehAX7cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiRXLC1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiRXLC1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AF91F000E9;
	Mon, 31 Aug 2026 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184015;
	bh=IIEgoUmF2LYlCcDHCwqtPlT0V5Gt2pb/D+vWri7BqU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiRXLC1AtaWRa/w4ksbcB/dPnmCJuM6y9EwrsPlc5YqQcfXFkCTY1XI2CMTFlvB+d
	 yAAd1A5RNiF05H8LcHX8lE2JcwlcMaOAN1mh4qMdtpT/Hx7hNo3dtKRWlVFkFAmaNz
	 6Hf3yU2IYe+yhyPkNjHOcZatQxedNLFbxtjmeCEXWWgMNMj+RVPtIBpTzGgLydcBgJ
	 pKp7zb2rrshQLBgfT0ERYobEJtZqMl5batTA+sewsotf48pMcpUMAMtx0r4qRGoC05
	 H4Re5cFoKBeQyWrhqI84YZUM6j/ubp/OiWx3P9FupJTLw1Az/PZEYOQ+a+m2p13dE+
	 aQESmkYHVvG1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdkfd: Unwind debug trap enable on copy_to_user failure
Date: Mon, 31 Aug 2026 09:27:47 -0400
Message-ID: <20260831133314.4125787-439-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 01112e241e37f9ac98b6f418d93ce2e0b87b7ee0 ]

If kfd_dbg_trap_enable() fails while copying runtime_info to userspace,
it had already activated the trap, set debug_trap_enabled, taken an extra
process reference, and opened the debug event file. Return -EFAULT without
unwinding that state, leaving inconsistent trap state and a refcount
imbalance that could break later DISABLE/ENABLE.

On copy_to_user failure, deactivate the trap and undo the rest of the
enable setup before returning.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the Subject Line
**Record:** `[drm/amdkfd]` `[Unwind]` — On `copy_to_user` failure in
`kfd_dbg_trap_enable()`, undo partial debug-trap enable setup that was
left behind.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** Alex Deucher `<alexander.deucher@amd.com>` (AMD DRM
  maintainer)
- **Link:** — none
- **Cc: stable@vger.kernel.org:** — none (expected for manual review)
- **Signed-off-by:** Yongqiang Sun `<Yongqiang.Sun@amd.com>` (author);
  Alex Deucher (committer)

Notable: maintainer **Acked-by** only; no syzbot or user reports.

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug:** If `copy_to_user()` fails after `kfd_dbg_trap_enable()` has
  activated the HW trap, set `debug_trap_enabled`, taken an extra
  `kref`, and opened `dbg_ev_file`, the function returned `-EFAULT`
  without undoing that state.
- **Symptom:** Inconsistent trap state; refcount imbalance; later
  DISABLE/ENABLE can misbehave.
- **Root cause:** Error path only called `kfd_dbg_trap_deactivate()` but
  did not mirror the rest of `kfd_dbg_trap_disable()` cleanup.
- **Version info:** None in the message.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised — explicitly an error-path unwind / resource-
leak / state-machine fix.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory Changes
**Record:**
- **Files:** `drivers/gpu/drm/amd/amdkfd/kfd_debug.c` (+6 / −0)
- **Function:** `kfd_dbg_trap_enable()`
- **Scope:** Single-file, surgical error-path fix

### Step 2.2: Code Flow Change
**Record:** On `copy_to_user()` failure in `kfd_dbg_trap_enable()`:
- **Before:** `kfd_dbg_trap_deactivate(target, false, 0); r = -EFAULT;`
  — HW trap deactivated, but `dbg_ev_file`, `debug_trap_enabled`, extra
  `kref`, and `debugged_process_count` left as if enable succeeded.
- **After:** Same deactivate, then `fput()` + NULL `dbg_ev_file`,
  `atomic_dec(debugged_process_count)`, `debug_trap_enabled = false`,
  `kfd_unref_process(target)`, then `-EFAULT`.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Error-path resource leak + inconsistent state (reference
  counting + flag/file leak)
- **Mechanism:** `kref_get()`, `fget()`, `debug_trap_enabled = true`,
  and `atomic_inc()` run before `copy_to_user()`. Failure left software
  state enabled while userspace received `-EFAULT`.

### Step 2.4: Fix Quality
**Record:** Mirrors the corresponding cleanup in
`kfd_dbg_trap_disable()` (lines 682–692). Minimal, obviously correct.
Low regression risk — only runs on an already-failing path. Does not add
`cancel_work_sync()` or clear `debugger_process`; same gap as the pre-
existing partial `kfd_dbg_trap_deactivate()` unwind.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame Changed Lines
**Record:** Buggy `copy_to_user` error path from Jonathan Kim,
2022-04-05 (`218895820e6fcc`). `kfd_dbg_trap_enable()` with
refcount/file/flag setup from `0ab2d7532b05a` (2023-06-09, “prepare per-
process debug enable and disable”). Bug present since ~v6.5+; definitely
in this tree.

### Step 3.2: Follow Fixes Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File History
**Record:** Recent `kfd_debug.c` changes are other debugger fixes (watch
bounds, MES debug, PASID). Fix commit `a50676d5a72a2` is on `all-next`
but **not** on `stable/linux-6.18.y`. Standalone one-commit fix.

### Step 3.4: Author's Other Commits
**Record:** Yongqiang Sun has limited amdkfd history in this tree (e.g.
CWSR overflow fix). Alex Deucher is DRM/AMD maintainer and committed the
fix.

### Step 3.5: Prerequisites
**Record:** No series dependencies. `kfd_dbg_trap_enable()`,
`kfd_dbg_trap_deactivate()`, and `kfd_unref_process()` all exist in this
tree. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c a50676d5a72a2` →
https://patch.msgid.link/20260602141422.4982-1-Yongqiang.Sun@amd.com.
Single revision (no `-a` series). Alex Deucher replied with **Acked-by**
in-thread. No NAKs found in mbox. No explicit `Cc: stable` nomination in
thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — CC'd to `amd-gfx@lists.freedesktop.org`. Alex
Deucher reviewed and acked.

### Step 4.3: Bug Report
**Record:** N/A — no `Reported-by` or `Link:` tags. Code-review / error-
path analysis fix.

### Step 4.4: Related Patches
**Record:** Standalone; not part of a multi-patch series.

### Step 4.5: Stable Mailing List
**Record:** Not searched separately; no stable nomination found in patch
thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `kfd_dbg_trap_enable()` (modified); related:
`kfd_dbg_trap_deactivate()`, `kfd_dbg_trap_disable()`,
`kfd_unref_process()`.

### Step 5.2: Callers
**Record:** `kfd_dbg_trap_enable()` called from `kfd_chardev.c` on
`KFD_IOC_DBG_TRAP_ENABLE` (ioctl path ~line 3029). Reached by ROCm/KFD
GPU debugger tooling via `/dev/kfd`.

### Step 5.3: Callees
**Record:** `fget`, `kfd_dbg_trap_activate`, `kref_get`, `atomic_inc`,
`copy_to_user`, `kfd_dbg_trap_deactivate`, `fput`, `kfd_unref_process`.

### Step 5.4: Call Chain / Reachability
**Record:** Userspace debugger → `KFD_IOC_DBG_TRAP` ioctl →
`kfd_dbg_trap_enable()`. `copy_to_user()` fails on invalid/unmapped
userspace buffers (buggy debugger, bad pointer, page fault under memory
pressure). Not a general unprivileged attack surface, but reachable by
authorized KFD clients.

### Step 5.5: Similar Patterns
**Record:** `kfd_dbg_trap_disable()` already performs the full cleanup
the fix adds. The error path was an incomplete subset of disable logic.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does Buggy Code Exist?
**Record:** **Yes.** Tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44`, `VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`). Buggy code at
`kfd_debug.c:817-819`:

```817:819:drivers/gpu/drm/amd/amdkfd/kfd_debug.c
        if (copy_to_user(runtime_info, (void *)&target->runtime_info,
copy_size)) {
                kfd_dbg_trap_deactivate(target, false, 0);
                r = -EFAULT;
```

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Fix commit diff matches current
file structure; only 6 lines in one hunk.

### Step 6.3: Related Fixes Already Present?
**Record:** **No.** `git log stable/linux-6.18.y --grep="Unwind debug
trap"` returns nothing. Fix exists on `all-next` (`a50676d5a72a2`) but
not in this stable checkout.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/gpu/drm/amd/amdkfd` — **IMPORTANT** (AMD GPU
compute/ROCm KFD driver). Debug-trap path only; not core kernel, but
affects production debugger workflows.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — recent stable-relevant amdkfd fixes
(debugger auth, overflows, CRIU, NULL deref).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of AMD KFD GPU debugging (ROCm debugger,
`KFD_IOC_DBG_TRAP_ENABLE`). Requires `CONFIG_HSA_AMD` / amdkfd. Not
universal, but real for that population.

### Step 8.2: Trigger Conditions
**Record:** `copy_to_user()` failure during debug-trap enable — uncommon
but valid (bad userspace buffer). **Likelihood:** low in normal use,
easy to hit with a buggy debugger or invalid pointer. **Privilege:** KFD
device access required.

### Step 8.3: Failure Mode Severity
**Record:**
- Extra `kref` leak on `kfd_process` → process object retained longer
  than intended
- `dbg_ev_file` leak → kernel `struct file` refcount leak
- `debug_trap_enabled` stuck `true` while ioctl returned error →
  subsequent enable returns `-EALREADY` (verified: line 779-780)
- `debugged_process_count` skew → wrong debugger session accounting
- **Severity:** **MEDIUM-HIGH** for debugger users (broken
  retry/disable-enable cycle, resource leaks); **LOW** for non-debug
  workloads

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores correct error recovery; prevents leaks and stuck
  debug state
- **Risk:** Very low — 6 lines on failure-only path, mirrors existing
  disable logic
- **Ratio:** Favorable for stable

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug in error path present since 2023
- Resource leaks (`kref`, `struct file`)
- Functional breakage: `-EALREADY` on retry after failed enable
- Small (6 lines), maintainer-acked
- Buggy code confirmed in Linux 6.18.44; fix not yet applied
- Clean backport

**AGAINST backport:**
- No user report or syzbot — code-review discovery
- Affects debugger-only path, not general workloads
- “Important issue” bar is borderline vs crash/security (no oops/UAF
  demonstrated)

**Unresolved:** Whether `debugger_process` should also be cleared on
failure (fix matches partial unwind intent, not full disable).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors
   `kfd_dbg_trap_disable()`; maintainer acked; no Tested-by
2. Fixes a real bug? **PASS** — refcount/file leak and stuck
   `debug_trap_enabled`
3. Important issue? **PASS (MEDIUM)** — resource leaks + broken debug
   enable/disable state machine
4. Small and contained? **PASS** — 6 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists; clean apply

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
error-path bug fix.

### Step 9.4: Decision Rationale

For **Linux 6.18.y** specifically: the incomplete unwind in
`kfd_dbg_trap_enable()` is present, the fix is absent, and the patch is
a minimal error-path correction that prevents reference and file leaks
and restores consistent debug-trap state after `-EFAULT`. This matches
the kind of driver error-recovery fixes routinely accepted for stable,
especially with AMD maintainer acknowledgment.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and `git show a50676d5a72a2`
- **[Phase 2]** Read diff and current `kfd_debug.c:772-825`,
  `kfd_dbg_trap_disable()` at 667-694
- **[Phase 3]** `git blame -L 817,820` → `218895820e6fcc` (2022); `git
  show 0ab2d7532b05a` → introduced enable setup (2023); `git log
  stable/linux-6.18.y --grep="Unwind debug trap"` → empty
- **[Phase 3]** `git log --oneline -5 --
  drivers/gpu/drm/amd/amdkfd/kfd_debug.c`
- **[Phase 4]** `b4 dig -c a50676d5a72a2` → lore URL; `b4 dig -m
  /tmp/kfd_debug_trap.mbx` → Alex Deucher Acked-by in thread; `b4 dig
  -a` → no revisions
- **[Phase 5]** `grep kfd_dbg_trap_enable` → caller in
  `kfd_chardev.c:3029`; `grep debug_trap_enabled` across amdkfd
- **[Phase 6]** `git describe HEAD` → `v6.18.44`; Makefile `6.18.44`;
  confirmed buggy lines at 817-819 without fix
- **[Phase 6]** `git log stable/linux-6.18.y..all-next --
  drivers/gpu/drm/amd/amdkfd/kfd_debug.c` → fix commit listed, not in
  stable
- **[Phase 6]** `git branch --contains a50676d5a72a2` → `all-next` and
  others, not `stable/linux-6.18.y`
- **[Phase 7]** `git log --oneline -20 -- drivers/gpu/drm/amd/amdkfd/` →
  active subsystem
- **[Phase 8]** Verified `-EALREADY` guard at line 779-780; verified
  `kfd_dbg_trap_disable()` cleanup pattern at 682-692

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
index 986cb297de8f8..78e1dfdb27147 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
@@ -816,6 +816,12 @@ int kfd_dbg_trap_enable(struct kfd_process *target, uint32_t fd,
 
 	if (copy_to_user(runtime_info, (void *)&target->runtime_info, copy_size)) {
 		kfd_dbg_trap_deactivate(target, false, 0);
+		fput(target->dbg_ev_file);
+		target->dbg_ev_file = NULL;
+		if (target->debugger_process)
+			atomic_dec(&target->debugger_process->debugged_process_count);
+		target->debug_trap_enabled = false;
+		kfd_unref_process(target);
 		r = -EFAULT;
 	}
 
-- 
2.53.0

