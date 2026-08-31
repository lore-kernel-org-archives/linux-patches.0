Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3643F53CA8A;
	Mon, 31 Aug 2026 13:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183942; cv=none; b=CeScGi/aCGEIZqSNmQlr8Evk7K4m9SjUEWAVb54pcgL6IKUIPh9+cKKSOZ+1aey5HYV+lyq2xcqg3T84eGx3C+ecotAf4NipePn1e0nwFgwFjcUDn3A3jd+3oxwC2ifbzRzjLfr7/95jde0Rfps3WGCXP7sXligRgQAJklVUXks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183942; c=relaxed/simple;
	bh=pWiOcmL05qqBtwUga/Xnye2Td1ckWBlq4qkl34Z93qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXLn8BNh2lHJW877Qz3IRN/m8gVEbASCHWGhEq5Y1B7VhWxiIMzQ+AMjLhH11bZyTCVeX0fTSZhMfXwJy3JgOgOroq2wst18kaAXyEjP/ulLF/jhi8aUO/MLTkk4auQrY9pBtzSO5t5PmrbsJKkgf82TOEIg/bt6vnwPM9NB7hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mb0NIH7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mb0NIH7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E643C1F000E9;
	Mon, 31 Aug 2026 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183938;
	bh=To1z/W0cY9na/zl6r+yTzM85id3mcrKlPbBi1jyEGeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mb0NIH7j9ibywgk2Xz2qfoL+4sSvVQXjcrgLjXJbgBt+BI7XmFwSgB++USgPjWZ7m
	 XKc3RhRyZm60VhcfiR5EE82bUuIL/5MT5sHjYvtBLCKGpo7kDjGvec7VfsNfaUhCBg
	 AmpW6HGwGIqsHSv5xpq14kfF3O8/c2cD64nK/seouBMKtVNp+znVoyKPoaX5Ho8c8M
	 GcF0UViketY7zyd18Ccv0ivX8SUUtr0vZeatgdTk05AUiKc6P9mtccwGMC5HMM2ifI
	 jPo7eWoB9SlE69mRkSpY+jLbWt5zHezZi0TiIWy5qQGEikLcsH/ORE2vj25B+N2wLh
	 VuHggp44m8UeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sunday Clement <Sunday.Clement@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdkfd: Fix OOB memory exposure in get_wave_state()
Date: Mon, 31 Aug 2026 09:27:00 -0400
Message-ID: <20260831133314.4125787-392-sashal@kernel.org>
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

From: Sunday Clement <Sunday.Clement@amd.com>

[ Upstream commit 7ef144458f48d5589e36f1b3d83e83db2e5c5ba5 ]

The get_wave_state() function for v9 trusts cp_hqd_cntl_stack_size and
cp_hqd_cntl_stack_offset values read directly from the MQD, which are
written by GPU microcode and fully attacker-controlled on the
CRIU-restore path (via AMDKFD_IOC_RESTORE_PROCESS with H3).

this leads to an unbounded copy_to_user() that can leak adjacent
GTT/kernel memory. If offset > size, integer underflow produces a ~4 GiB
read length, if size is set to 1 MiB against a 4 KiB allocation, we leak
1 MiB of adjacent kernel memory (other queues' MQDs, ring buffers, KASLR
pointers).

Fix by clamping both cp_hqd_cntl_stack_size to the actual allocated
buffer size (q->ctl_stack_size) and cp_hqd_cntl_stack_offset to the
clamped size before performing arithmetic and copy_to_user().

This ensures we never read beyond the allocated kernel BO regardless of
attacker-supplied MQD field values.

Signed-off-by: Sunday Clement <Sunday.Clement@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `drm/amdkfd: Fix OOB memory exposure in
get_wave_state()`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drm/amdkfd]` `[Fix]` — Fix out-of-bounds kernel memory
exposure in `get_wave_state()` for GFX9 (v9 MQD manager).

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Sunday Clement `<Sunday.Clement@amd.com>` (author) |
| Acked-by | Alex Deucher `<alexander.deucher@amd.com>` |
| Signed-off-by | Alex Deucher `<alexander.deucher@amd.com>` (committer)
|
| Fixes: | **Absent** (expected for candidate review) |
| Cc: stable | **Absent** (expected) |
| Reported-by: | **Absent** |
| Link: | **Absent** |

Notable: Acked-by from AMDGPU/KFD maintainer Alex Deucher is a strong
quality signal.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `get_wave_state()` in `kfd_mqd_manager_v9.c` trusts
  `cp_hqd_cntl_stack_size` and `cp_hqd_cntl_stack_offset` from the MQD
  without bounds checking.
- **Attack vector:** On the CRIU-restore path (`AMDKFD_IOC_CRIU_OP` /
  `KFD_CRIU_OP_RESTORE`), the full MQD is copied from userspace via
  `restore_mqd()` → `memcpy(m, mqd_src, sizeof(*m))`, making those
  fields attacker-controlled.
- **Symptoms:** Unbounded `copy_to_user()` reads beyond the allocated
  control-stack BO, leaking adjacent GTT/kernel memory (other MQDs, ring
  buffers, KASLR pointers). If `offset > size`, unsigned subtraction
  underflows to ~4 GiB copy length.
- **Root cause:** MQD fields used directly for pointer arithmetic and
  copy size without clamping to `q->ctl_stack_size` (the actual
  allocation size).
- **Version info:** Not specified; affects GFX9 v9 MQD path with CWSR
  enabled.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly labeled as a security/memory-
safety fix. Clear OOB read → info-leak vulnerability.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c` (+7/−3
  net, ~10 lines touched)
- **Function:** `get_wave_state()` (static, v9 MQD manager)
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Variable setup | Used raw MQD fields | Declares `cntl_stack_size`,
`cntl_stack_offset`; clamps to `q->ctl_stack_size` |
| Size calculation for copy | `*ctl_stack_used_size =
m->cp_hqd_cntl_stack_size - m->cp_hqd_cntl_stack_offset` (used directly
for copy) | Recalculated as `cntl_stack_size - cntl_stack_offset` after
clamping |
| `copy_to_user` of stack data | `ctl_stack +
m->cp_hqd_cntl_stack_offset`, length `*ctl_stack_used_size` | `ctl_stack
+ cntl_stack_offset`, length clamped `*ctl_stack_used_size` |

Header fields are still populated from unclamped MQD values before the
clamp (pre-existing behavior); the security-critical kernel read is what
gets fixed.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read → kernel
  information disclosure
- **Mechanism:** Attacker-supplied MQD
  `cp_hqd_cntl_stack_size`/`cp_hqd_cntl_stack_offset` drive
  `copy_to_user()` source pointer (`mqd_ctl_stack + offset`) and length
  (`size - offset`) without validation against the BO allocated as
  `ALIGN(q->ctl_stack_size, PAGE_SIZE)` at MQD creation time.

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct: `min_t()` clamping to known allocation bound
  is standard kernel practice.
- Minimal, no API changes, no new features.
- Low regression risk: only affects the data-copy path; worst case
  slightly truncates data returned to userspace when MQD fields are
  corrupt/malicious (correct behavior).
- Alex Deucher noted C89 mixed-declaration issue in v1 (variables after
  statements); the candidate diff moves declarations to function top,
  addressing that.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on lines 336–370 attributes all lines to
`a112b91dd6349` (sunrpc backport marker commit) — this stable tree has
flattened/squashed history, so blame is not reliable for dating the
original code. The `get_wave_state()` function and vulnerable
`copy_to_user` pattern are **present in the current tree**.

### Step 3.2: Fixes: Tag
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: Related File History
**Record:** `git log --oneline --
drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c` returns only one commit
in this tree (history squashed). Cannot trace intermediate fixes from
local git alone.

### Step 3.4: Author Context
**Record:** Sunday Clement (AMD). Alex Deucher Acked and committed. No
other Sunday Clement commits found in this tree's amdkfd history
(squashed tree).

### Step 3.5: Dependencies
**Record:**
- **Standalone fix** — no series dependency, no prerequisite commits
  referenced.
- Requires existing code: `get_wave_state()` v9 copy path, CRIU restore,
  `q->ctl_stack_size` in `queue_properties`. All verified present in
  6.18.43 tree.
- **v9-specific:** v10+ `get_wave_state()` does not copy control stack
  to userspace (only header metadata), so this bug is unique to the v9
  path.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- `b4 dig` failed in this environment.
- Web search found thread: https://lists.freedesktop.org/archives/amd-
  gfx/2026-May/144498.html
- Submitted May 13, 2026 by Sunday Clement; Alex Deucher replied same
  day with **Acked-by** (after noting C89 declaration placement).
- Single-patch submission, not part of a series.

### Step 4.2: Reviewers
**Record:** Alex Deucher (AMDGPU maintainer) reviewed and Acked.
Appropriate subsystem maintainer involvement confirmed.

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot, or CVE referenced. Security
impact described in commit message and review thread.

### Step 4.4: Related Patches
**Record:** No related patches in a series. v10+ not affected (no stack
copy). No other GFX versions need this exact fix.

### Step 4.5: Stable List Discussion
**Record:** No stable@vger.kernel.org nomination found in the thread.
Not a negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `get_wave_state()` (v9), called via
`get_wave_state_v9_4_3()` for multi-XCC GFX9.4.3+.

### Step 5.2: Callers
**Record:**
```
kfd_ioctl_get_queue_wave_state()          [kfd_chardev.c:541]
  → pqm_get_wave_state()
[kfd_process_queue_manager.c:685]
    → dqm->ops.get_wave_state()
[kfd_device_queue_manager.c:2690]
      → mqd_mgr->get_wave_state()         [kfd_mqd_manager_v9.c:336]
```
`AMDKFD_IOC_GET_QUEUE_WAVE_STATE` has ioctl flag `0` (no special
capability beyond KFD device access).

### Step 5.3: Callees
**Record:** `get_mqd()`, `copy_to_user()` — the vulnerable path copies
from `mqd_ctl_stack` (kernel BO at `mqd + PAGE_SIZE`).

### Step 5.4: Attack Chain (Reachability)
**Record:**
1. Attacker with `CAP_CHECKPOINT_RESTORE` calls `AMDKFD_IOC_CRIU_OP`
   with `KFD_CRIU_OP_RESTORE` (`kfd_ioctl_criu`, flag
   `KFD_IOC_FLAG_CHECKPOINT_RESTORE`).
2. `kfd_criu_restore_queue()` → `copy_from_user()` of MQD →
   `pqm_create_queue()` → `restore_mqd()` → `memcpy(m, mqd_src,
   sizeof(*m))` — **full MQD including malicious stack size/offset
   fields**.
3. Attacker calls `AMDKFD_IOC_GET_QUEUE_WAVE_STATE` on the restored
   queue (queue must be inactive, `cwsr_enabled`).
4. `get_wave_state()` performs OOB `copy_to_user()`, leaking kernel
   memory.

Reachable from userspace ioctl path. Poisoning requires
`CHECKPOINT_RESTORE` capability; the leak ioctl itself does not.

### Step 5.5: Similar Patterns
**Record:** `checkpoint_mqd()` also uses `m->cp_hqd_cntl_stack_size` for
`memcpy` (line 388) — potentially a separate concern on restore, but not
addressed by this commit and not the `get_wave_state` leak path under
review. v10/v11/v12 `get_wave_state()` do not perform the vulnerable
stack copy.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Current tree at `kfd_mqd_manager_v9.c:350-366`:

```350:366:drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
        *ctl_stack_used_size = m->cp_hqd_cntl_stack_size -
                m->cp_hqd_cntl_stack_offset;
        // ...
        if (copy_to_user(ctl_stack + m->cp_hqd_cntl_stack_offset,
                                mqd_ctl_stack +
m->cp_hqd_cntl_stack_offset,
                                *ctl_stack_used_size))
```

CRIU restore infrastructure (`kfd_criu_restore_queue`, `restore_mqd`,
`AMDKFD_IOC_CRIU_OP`) all present. Control stack BO allocated at
`ALIGN(q->ctl_stack_size, PAGE_SIZE)` in `alloc_mqd()` (line 139).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Single hunk in one file. No
structural conflicts observed. Candidate diff uses top-of-function
variable declarations (addresses maintainer C89 feedback).

### Step 6.3: Related Fixes Already Present?
**Record:** `git log --grep="OOB"` and `--grep="get_wave_state"` in
amdkfd returned no results. Fix is **not** already in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/gpu/drm/amd/amdkfd` — AMDGPU KFD (HSA compute).
**IMPORTANT** subsystem: affects AMD GPU compute users (ROCm, HPC, ML
workloads). Security-relevant ioctl path.

### Step 7.2: Subsystem Activity
**Record:** Active development (CRIU, MES, multi-XCC support visible in
tree). CRIU restore is a relatively newer code path where insufficient
validation is plausible.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of AMD GFX9 GPUs (Vega20, MI50, MI100, etc.) with:
- `CONFIG_HSA_AMD`/amdkfd enabled
- CWSR (`cwsr_enabled`) enabled
- CRIU checkpoint/restore used (containers, migration)

### Step 8.2: Trigger Conditions
**Record:**
- Requires `CAP_CHECKPOINT_RESTORE` to poison MQD via CRIU restore
- Then `AMDKFD_IOC_GET_QUEUE_WAVE_STATE` on inactive queue
- Not every boot path — specific to CRIU restore + wave state query
- Unprivileged direct trigger: **No** (needs CHECKPOINT_RESTORE for
  poisoning step)

### Step 8.3: Failure Mode Severity
**Record:**
- **Failure mode:** Kernel memory information disclosure to userspace
  (KASLR pointers, adjacent BO contents)
- **Secondary:** Integer underflow could attempt multi-GB copy
  (potential crash/hang)
- **Severity: HIGH** (security — info leak, KASLR bypass aid)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit: HIGH** — closes a real kernel memory leak on a security-
  sensitive ioctl path
- **Risk: VERY LOW** — 7 lines, bounds clamping only, maintainer-Acked
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real security bug: OOB kernel read → info leak (KASLR, adjacent BOs)
- Small, surgical, maintainer-Acked fix
- Buggy code and CRIU infrastructure exist in 6.18.43
- v9-specific `copy_to_user` of control stack is the vulnerable
  operation
- Integer underflow can produce ~4 GiB copy attempt
- Defense-in-depth: kernel must not trust MQD fields without validation

**AGAINST backport:**
- Requires `CAP_CHECKPOINT_RESTORE` for the poisoning step (limits
  attack surface to CRIU-capable contexts)
- Only affects GFX9 (v9 MQD manager), not GFX10+
- Header metadata still uses unclamped values (minor, not the security
  issue)

**Unresolved:** Exact mainline commit SHA not available in this tree;
original introduction date of vulnerable code not determinable due to
squashed stable history.

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — `min_t()` clamping is
standard; Acked by maintainer |
| 2. Fixes real bug affecting users? | **PASS** — kernel memory info
leak via ioctl |
| 3. Important issue? | **PASS** — security (info disclosure, KASLR
leak) |
| 4. Small and contained? | **PASS** — 1 file, ~10 lines |
| 5. No new features/APIs? | **PASS** — validation only |
| 6. Can apply to local tree? | **PASS** — buggy code present, clean
apply expected |

### Step 9.3: Exception Categories
**Record:** None of the hardware-quirk/DT/device-ID exceptions apply.
This is a security bug fix.

### Step 9.4: Decision Rationale

For **Linux 6.18.43**, the vulnerable `get_wave_state()` code exists,
the CRIU restore attack path is present, and the fix is a minimal
bounds-check that closes a kernel memory information disclosure. This
meets all stable kernel criteria for a security fix. The
`CAP_CHECKPOINT_RESTORE` requirement limits who can trigger it, but
container/CRIU environments are exactly where stable kernels with AMDGPU
compute are deployed, and leaking KASLR/kernel pointers is a meaningful
security impact.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query;
  confirmed Acked-by Alex Deucher
- **[Phase 1]** No Fixes:/Reported-by:/Cc: stable tags (expected)
- **[Phase 2]** Read diff and current `kfd_mqd_manager_v9.c:336-370` —
  vulnerable `copy_to_user` confirmed
- **[Phase 2]** Verified BO allocation size uses `q->ctl_stack_size` at
  `kfd_mqd_manager_v9.c:139`
- **[Phase 3]** `git blame -L 336,370` — squashed history, unreliable
  for dating
- **[Phase 3]** `git log --oneline -- kfd_mqd_manager_v9.c` — single
  commit (squashed tree)
- **[Phase 3]** No Fixes: tag to follow
- **[Phase 4]** `b4 dig` — **failed** (tool unavailable)
- **[Phase 4]** WebFetch lore thread — Alex Deucher Acked-by confirmed
  at https://lists.freedesktop.org/archives/amd-gfx/2026-May/144498.html
- **[Phase 4]** No stable list nomination found
- **[Phase 5]** Traced call chain: `kfd_ioctl_get_queue_wave_state` →
  `pqm_get_wave_state` → `get_wave_state` (v9)
- **[Phase 5]** Verified CRIU restore path: `kfd_criu_restore_queue` →
  `restore_mqd` → `memcpy(m, mqd_src, sizeof(*m))` at line 422
- **[Phase 5]** Verified v10 `get_wave_state` does NOT copy stack data
  (only header) — bug v9-specific
- **[Phase 6]** `git describe HEAD` → v6.18.43; `Makefile` → 6.18.43
- **[Phase 6]** Buggy code present; fix not yet applied
- **[Phase 6]** CRIU ioctl `KFD_CRIU_OP_RESTORE` present with
  `KFD_IOC_FLAG_CHECKPOINT_RESTORE`
- **[Phase 8]** Failure mode: kernel info leak, severity HIGH

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index f2dee320fada4..e3a33a92b1799 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -341,11 +341,15 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
 {
 	struct v9_mqd *m;
 	struct kfd_context_save_area_header header;
+	u32 cntl_stack_size;
+	u32 cntl_stack_offset;
 
 	/* Control stack is located one page after MQD. */
 	void *mqd_ctl_stack = (void *)((uintptr_t)mqd + PAGE_SIZE);
 
 	m = get_mqd(mqd);
+	cntl_stack_size = min_t(u32, m->cp_hqd_cntl_stack_size,   q->ctl_stack_size);
+	cntl_stack_offset = min_t(u32, m->cp_hqd_cntl_stack_offset, cntl_stack_size);
 
 	*ctl_stack_used_size = m->cp_hqd_cntl_stack_size -
 		m->cp_hqd_cntl_stack_offset;
@@ -361,9 +365,10 @@ static int get_wave_state(struct mqd_manager *mm, void *mqd,
 	if (copy_to_user(ctl_stack, &header, sizeof(header.wave_state)))
 		return -EFAULT;
 
-	if (copy_to_user(ctl_stack + m->cp_hqd_cntl_stack_offset,
-				mqd_ctl_stack + m->cp_hqd_cntl_stack_offset,
-				*ctl_stack_used_size))
+	*ctl_stack_used_size = cntl_stack_size - cntl_stack_offset;
+
+	if (copy_to_user(ctl_stack + cntl_stack_offset, mqd_ctl_stack + cntl_stack_offset,
+					*ctl_stack_used_size))
 		return -EFAULT;
 
 	return 0;
-- 
2.53.0

