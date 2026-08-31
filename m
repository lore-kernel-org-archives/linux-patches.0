Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54261594803;
	Mon, 31 Aug 2026 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184275; cv=none; b=qHXUiw1BBUDEmSyPzcxshiZq9NfhhtCUmBX4OvQppeXrtsGPp1jbDoPMM5TgHwXiAdX8EDu9SjEz4JGhObHZc9jDaEboiw/DjiI1IfYCPeIV66RZfBdzFdQS+0rkZi1NYqTyhE8HOWVOEdy7/XxyqcSXMzvTVaoISUWUMBrPmS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184275; c=relaxed/simple;
	bh=OZ31Kb4eZeaxh1UcP5wMB7lXoF02WFpXmmdrR8d896k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=laCIXkVYu/kgvAnrUpp9P4JrBS5kG1wx29cUJPTF3fLMYgc1GNskl7Kv+LayNdf1Co2exBjm9bb3EN055gDMswF3/VORFekta+vxVEsUBURvIv5B3LDbpo83gRQdGZXZoBIrBCDsltSQLpl49O5CO9qeipJ6/fsNgsCW9YVbCTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mL+Xn4m1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mL+Xn4m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32B11F00ACA;
	Mon, 31 Aug 2026 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184271;
	bh=Hh6DQaCHIq2VUuDkhUO0gcrJbuyGoDL/mV794VKwMu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mL+Xn4m1+gkOd88nkgLpWhrg4UBoifPG28j23XtsoA0qGCa6t69LimlS/2qdyjBuI
	 hoxAKOFr4EfTX/JvVfm6R6BBJT9j2i3Nij/MQRdG1aGrA3+S+hOQWAgV7yW0Y+mHF4
	 z4FFzyOodsPb4nBuc1SFdar/jH0/Q8MTZT+zCqU6uLJexZMTkggQsSFQhnEa7TqBP6
	 0qeLBL1Pi0XpCyPFZCZv2d0JXRJUto946BDBmY5h4byChVsZYwkAFSRPkMlXu4X2+3
	 eul4g9bV6b5yD7OTLxrPznlDmerOLBjhZ1Ep6x9TVkX97EBmEdHiJlz8VSH0FU8niV
	 9AhgAbdh7zhzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: use atomic operation to achieve lockless serialization
Date: Mon, 31 Aug 2026 09:30:21 -0400
Message-ID: <20260831133314.4125787-593-sashal@kernel.org>
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

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 4d50a14d346141e03a7c3905e496d91e048bc30c ]

In amdgpu_seq64_alloc there is a possibility that two difference cores
from two separate NODES can try to and could get the same free slot.
So this fixes that race here using atomic test_and_set clear operations.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdgpu: use atomic operation to achieve
lockless serialization`

**Local tree:** `v6.18.43` (`VERSION = 6`, `PATCHLEVEL = 18`, `SUBLEVEL
= 43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amdgpu]` — action verb implied **fix** (race) — use
atomic bitops in `amdgpu_seq64_alloc`/`amdgpu_seq64_free` for lockless
serialization of the seq64 slot bitmap.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Sunil Khatri `<sunil.khatri@amd.com>` |
| Reviewed-by | Alex Deucher `<alexander.deucher@amd.com>` |
| Signed-off-by | Alex Deucher `<alexander.deucher@amd.com>` |

**Notable patterns:** Maintainer review from Alex Deucher (amdgpu co-
maintainer). No `Fixes:`, `Reported-by:`, `Cc: stable`, or syzbot tags
(expected for manual review).

### Step 1.3: Body analysis
**Record:**
- **Bug described:** In `amdgpu_seq64_alloc`, two CPU cores on separate
  nodes can race and obtain the same free seq64 slot.
- **Symptom/failure mode:** Duplicate slot assignment → two user-queue
  fence drivers share the same 64-bit fence memory location → broken GPU
  synchronization.
- **Root cause (author):** Non-atomic `find_first_zero_bit` +
  `__set_bit` is not safe under concurrent access; fix uses
  `test_and_set_bit` loop and `clear_bit`.
- **Version info:** None in commit message.

### Step 1.4: Hidden bug fix?
**Record:** Yes — explicitly a race-condition fix, not cosmetic cleanup.
Replacing `__set_bit`/`__clear_bit` with atomic
`test_and_set_bit`/`clear_bit` is the standard kernel pattern for
concurrently accessed bitmaps (`Documentation/atomic_bitops.txt`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c` (+8 / −5, 1
  file)
- **Functions modified:** `amdgpu_seq64_alloc()`, `amdgpu_seq64_free()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow per hunk

**Hunk 1 — `amdgpu_seq64_alloc`:**
- **Before:** `find_first_zero_bit` → early `-ENOSPC` → unconditional
  `__set_bit`
- **After:** Loop: `find_first_zero_bit` → `-ENOSPC` if full →
  `test_and_set_bit`; break only if bit was previously clear (successful
  claim); otherwise retry
- **Path affected:** Normal allocation path for seq64 fence slots

**Hunk 2 — `amdgpu_seq64_free`:**
- **Before:** `__clear_bit` (non-atomic)
- **After:** `clear_bit` (atomic)
- **Path affected:** Slot release on fence-driver teardown

### Step 2.3: Bug mechanism
**Record:** **Category:** Race condition / incorrect non-atomic bitmap
access.

**Mechanism:** `__set_bit`/`__clear_bit` are explicitly non-atomic per
`Documentation/atomic_bitops.txt`. Concurrent alloc and free on
`adev->seq64.used` without atomic ops can corrupt the bitmap or allow a
TOCTOU between `find_first_zero_bit` and bit claim when another CPU
concurrently modifies the same bitmap.

### Step 2.4: Fix quality
**Record:** Fix is obviously correct — standard `test_and_set_bit`
allocator loop. Minimal, no API changes. Low regression risk; loop may
spin under contention but pool has 262144 slots
(`AMDGPU_MAX_SEQ64_SLOTS`), so retry pressure is low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `amdgpu_seq64_alloc`/`free` bitmap logic introduced in
commit `a112b91dd6349` (stable-tree import). Buggy
`__set_bit`/`__clear_bit` pattern present in current `v6.18.43` tree at
lines 178–182 and 208.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** `amdgpu_seq64.c` exists in this tree with the pre-fix code.
Fix commit is **not yet applied** (no `test_and_set_bit` in local file).
This stable tree's git history is flattened through bulk imports,
limiting per-file history granularity.

### Step 3.4: Author commits
**Record:** No commits by Sunil Khatri found in this stable checkout's
`git log`. Author is an AMD developer; patch reviewed by amdgpu
maintainer Alex Deucher.

### Step 3.5: Dependencies
**Record:** Standalone — no series markers, no prerequisite commits.
Applies directly to existing `amdgpu_seq64.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/144553.html (v1 submission, May 14 2026)
- **Series revisions:** v1 only (no v2/v3 found)
- **Reviewer feedback:** Christian König questioned why concurrent calls
  are possible: *"Why can those functions be called in concurrent from
  multiple threads?"* (https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/144650.html)
- **Maintainer response:** Alex Deucher gave `Reviewed-by`
  (https://lists.freedesktop.org/archives/amd-gfx/2026-May/144599.html)
- **Stable nominations:** None found in thread
- **NAKs:** None; question raised but patch still reviewed positively by
  maintainer

`b4 dig -c <hash>` could not be run — fix commit hash not present in
this checkout.

### Step 4.2: Reviewers (b4 -w equivalent via lore)
**Record:** Patch submitted to amd-gfx list; reviewed by Alex Deucher
(subsystem maintainer). Christian König (also amdgpu maintainer) raised
concurrency question.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or crash trace.
Theoretical/concurrency-analysis fix from driver developer.

### Step 4.4: Related patches
**Record:** Standalone 1/1 patch, not part of a series.

### Step 4.5: Stable list
**Record:** Not searched on lore.kernel.org (blocked by bot protection).
No stable discussion found on freedesktop amd-gfx thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `amdgpu_seq64_alloc()`, `amdgpu_seq64_free()`

### Step 5.2: Callers
**Record:**
| Function | Callers | Context |
|----------|---------|---------|
| `amdgpu_seq64_alloc` | `amdgpu_userq_fence_driver_alloc()` only |
Called from `amdgpu_userq_create()` during `AMDGPU_USERQ_OP_CREATE`
ioctl |
| `amdgpu_seq64_free` | `amdgpu_userq_fence_driver_alloc()` error path;
`amdgpu_userq_fence_driver_destroy()` via `kref_put` | Destroy path from
queue teardown / refcount drop |

`amdgpu_userq_create()` holds `adev->userq_mutex` during alloc (line
518). `amdgpu_userq_destroy()` holds only per-client
`uq_mgr->userq_mutex`, **not** `adev->userq_mutex` (lines 394–420).
Therefore alloc and free **can run concurrently** from different DRM
clients/processes.

### Step 5.3: Callees
**Record:** `find_first_zero_bit`, `test_and_set_bit`/`__set_bit`,
`clear_bit`/`__clear_bit`, `amdgpu_seq64_get_va_base()`

### Step 5.4: Reachability
**Record:** Reachable from userspace via DRM ioctl
`AMDGPU_USERQ_OP_CREATE` / destroy on GPUs with user-mode queue support
(gfx11, gfx12, SDMA v6/v7 in this tree). Multi-process GPU compute
workloads are a realistic trigger.

### Step 5.5: Similar patterns
**Record:** Kernel bitmap allocators universally use `test_and_set_bit`
loops for concurrent access. Non-atomic `__set_bit` is only valid when
caller holds exclusive access.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current `v6.18.43` tree has the buggy code:

```178:182:drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
        bit_pos = find_first_zero_bit(adev->seq64.used,
adev->seq64.num_sem);
        if (bit_pos >= adev->seq64.num_sem)
                return -ENOSPC;

        __set_bit(bit_pos, adev->seq64.used);
```

```207:208:drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
        if (bit_pos < adev->seq64.num_sem)
                __clear_bit(bit_pos, adev->seq64.used);
```

`amdgpu_seq64_init()` is called during GMC hw init; user-mode queues are
wired on modern ASICs.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — identical file and function
structure; no conflicts detected. 8-line change.

### Step 6.3: Related fixes already present?
**Record:** **No** — `test_and_set_bit` not present in `amdgpu_seq64.c`;
fix not yet in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/amd/amdgpu` — **IMPORTANT** (AMD GPU
driver). Affects user-mode queue fence synchronization on supported
hardware.

### Step 7.2: Subsystem activity
**Record:** Actively developed; user-mode queues and seq64 are
relatively recent features present in this 6.18.y tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of AMDGPU user-mode queues on gfx11/gfx12/SDMA-capable
GPUs running multi-process compute (ROCm, etc.). Config-dependent on
hardware with `userq_funcs` populated.

### Step 8.2: Trigger conditions
**Record:** Concurrent queue create (alloc under `adev->userq_mutex`)
and queue destroy/fence-driver teardown (free without
`adev->userq_mutex`) from different processes, potentially on different
CPU/NUMA nodes. Realistic in multi-tenant GPU workloads. Unprivileged
users can trigger via DRM ioctls (subject to device access permissions).

### Step 8.3: Failure mode severity
**Record:** Duplicate seq64 slot → two fence drivers alias the same
64-bit memory → **HIGH** severity: GPU synchronization corruption,
possible compute wrong-results or GPU hangs. Not a typical kernel oops,
but serious functional corruption.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected userq users — prevents fence memory
  aliasing
- **Risk:** VERY LOW — 8-line, idiomatic atomic bitmap fix, maintainer-
  reviewed
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real concurrent alloc/free paths verified (asymmetric mutex coverage)
- Non-atomic `__set_bit`/`__clear_bit` violate kernel bitmap concurrency
  rules
- Standard, obviously-correct fix pattern
- Small, single-file, no new APIs
- Reviewed by amdgpu maintainer Alex Deucher
- Buggy code confirmed present in `v6.18.43`; fix not yet applied
- User-mode queues active on modern AMD GPUs in this tree

**AGAINST backport:**
- No crash report or syzbot reproduction
- Christian König questioned whether concurrency is possible (though
  code analysis shows alloc/free overlap is real; two simultaneous
  allocs are mutex-serialized)
- Affects only user-mode queue users, not all amdgpu users

**Unresolved:** Author's reply to Christian König's thread question not
found; exact "two nodes both allocating" scenario may be overstated, but
alloc/free concurrency is verified.

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — idiomatic atomic bitmap
fix; maintainer Reviewed-by; no runtime test cited |
| 2. Fixes a real bug affecting users? | **PASS** — concurrent bitmap
access verified in code paths |
| 3. Important issue? | **PASS** — HIGH: fence memory aliasing, GPU sync
corruption |
| 4. Small and contained? | **PASS** — 8 lines, 1 file |
| 5. No new features/APIs? | **PASS** — internal implementation change
only |
| 6. Can apply to local tree? | **PASS** — clean apply to existing
`amdgpu_seq64.c` |

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Standard race-condition bug fix.

### Step 9.4: Decision rationale
The commit fixes a genuine race in the seq64 slot allocator. While
`amdgpu_userq_create()` serializes allocations via `adev->userq_mutex`,
`amdgpu_seq64_free()` runs from fence-driver destruction without that
lock — `amdgpu_userq_destroy()` only takes the per-client mutex.
Concurrent alloc and free on the shared `adev->seq64.used` bitmap with
non-atomic `__set_bit`/`__clear_bit` is incorrect and can corrupt slot
tracking. The fix is minimal, maintainer-reviewed, and applies cleanly
to this `v6.18.43` tree where the buggy code is present and user-mode
queues are supported.

---

## Verification

- [Phase 1] Parsed subject, tags (SOB, Reviewed-by Alex Deucher), body;
  no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: 8 insertions, 5 deletions in `amdgpu_seq64_alloc` and
  `amdgpu_seq64_free`
- [Phase 3] `git describe HEAD`: `v6.18.43`; blame shows buggy
  `__set_bit`/`__clear_bit` in current tree
- [Phase 3] `git log --grep` for commit subject: not found in tree (not
  yet merged)
- [Phase 4] Lore: v1 at https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/144553.html; Reviewed-by at 144599.html; Christian König
  question at 144650.html
- [Phase 4] b4 dig by hash: N/A — commit not in checkout
- [Phase 5] `grep amdgpu_seq64_alloc`: single caller in
  `amdgpu_userq_fence.c`
- [Phase 5] `grep amdgpu_seq64_free`: error path +
  `amdgpu_userq_fence_driver_destroy`
- [Phase 5] Read `amdgpu_userq.c`: create holds `adev->userq_mutex`
  (518); destroy does not (394–420)
- [Phase 5] Read `amdgpu_userq_fence.c`: destroy → `kref_put` →
  `amdgpu_seq64_free`
- [Phase 6] Confirmed buggy code at lines 178–182, 208; no
  `test_and_set_bit` present
- [Phase 6] `amdgpu_seq64_init` present in `amdgpu_device.c` GMC init
  path
- [Phase 6] Userq support on gfx11/gfx12/SDMA via `userq_funcs`
  assignment verified
- [Phase 8] `AMDGPU_MAX_SEQ64_SLOTS` = 2MiB/8 = 262144 slots per
  `amdgpu_seq64.h`
- [Phase 8] `Documentation/atomic_bitops.txt`: `__` prefixed bitops are
  non-atomic
- UNVERIFIED: Author's reply to Christian König's concurrency question
  (not found in fetched threads)
- UNVERIFIED: Whether fix commit SHA exists on mainline (not in this
  stable checkout)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
index a0b479d5fff19..f4be192235889 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_seq64.c
@@ -175,11 +175,14 @@ int amdgpu_seq64_alloc(struct amdgpu_device *adev, u64 *va,
 {
 	unsigned long bit_pos;
 
-	bit_pos = find_first_zero_bit(adev->seq64.used, adev->seq64.num_sem);
-	if (bit_pos >= adev->seq64.num_sem)
-		return -ENOSPC;
+	for (;;) {
+		bit_pos = find_first_zero_bit(adev->seq64.used, adev->seq64.num_sem);
+		if (bit_pos >= adev->seq64.num_sem)
+			return -ENOSPC;
 
-	__set_bit(bit_pos, adev->seq64.used);
+		if (!test_and_set_bit(bit_pos, adev->seq64.used))
+			break;
+	}
 
 	*va = bit_pos * sizeof(u64) + amdgpu_seq64_get_va_base(adev);
 
@@ -205,7 +208,7 @@ void amdgpu_seq64_free(struct amdgpu_device *adev, u64 va)
 
 	bit_pos = (va - amdgpu_seq64_get_va_base(adev)) / sizeof(u64);
 	if (bit_pos < adev->seq64.num_sem)
-		__clear_bit(bit_pos, adev->seq64.used);
+		clear_bit(bit_pos, adev->seq64.used);
 }
 
 /**
-- 
2.53.0

