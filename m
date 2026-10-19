Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1BB6189B8;
	Mon, 19 Oct 2026 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418659; cv=none; b=eWfvaSSqo9G9VwaWSG+MJKWEGizSOOdHfFfV1ZMnKwfWA9Y4wk46/Gk402J5XIpb7wAnD02fEfC8VqdYcUE1cYSciXJBSSiPosrMO4S1mIyfeR9Q6/d3eriSdTNaqRxt1SDiFqfQXMvlEPwyF4MK9DCiu9K7m+12+F24uOU6q4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418659; c=relaxed/simple;
	bh=TlDmeP1l/b9CFDL45t3ek8Dtjmnsqaq9WRqzufQvjVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5f8H7pJ9P380TnL43QDOWHGKvLwoD3rZPqGi2nFM8eW/zQtuo6Q63mRZ43rcvyc6A8JyfHwcBlmYuGUmMx0XN45zGPvvt8Y+AOYaKAbCWWe3DF/J1WwW2cmUsYkpUKoE0iCaRZMlvpHybr57vAUG8aM6o1hEB2fQNkIRFkvkCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWRg59d1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWRg59d1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1581F000C6;
	Mon, 19 Oct 2026 14:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418656;
	bh=SCr4BBJJW0EneM2gThIHMNghpsiw6Dl1HXjh37Woi30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWRg59d1h/yuyXJNCDMldkzXqlKCXco4re+EJWwV7hSNtop0RFy5xIyYrneHC4ZAj
	 QAGOLe7imd7xOFl4bs41UZITZH00FeA3rTY8EMBSzWeAgBn41HCQc59XrDnMlWN3pP
	 vfAxBOX2rxLoG0d1HOGZ/l1reqXr47xAU6hhxRlhDrXKIDoBgF8df36IVvyx9/GYWs
	 LxAfRB5eGEYQ2ko6MOoGn5bW1byUHJnKmN0wn6DhiphO4lvCd6kRoOiZkdvs4rrHhh
	 cg2sHXZ7Ky2609XW9UZsrJ4GiMkGe5JWnANXb64ECUprqbPEe7Q+cc0TsAkWFbFNO9
	 ajqxBR1CzBuWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Heiko Carstens <hca@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] s390/mm: Fix handling of vmalloc area in do_secure_storage_access()
Date: Mon, 19 Oct 2026 09:51:35 -0400
Message-ID: <20261019135441.1420968-404-sashal@kernel.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit a2e5a9d853e015bc876399eb18435aa88101c60a ]

Secure storage access exceptions in vmalloc area need to be handled
separately since virt_to_phys() does not work on such addresses. Given
that there cannot be a valid access let such exceptions fail
immediately. The kernel will either fixup or crash.

Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>> ---
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough history, the series context, and the local `fault.c` path
to decide. The remaining work is to write the phase-by-phase analysis.

## Phase 1: Commit message forensics

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[s390/mm]** **[Fix]** handling of vmalloc addresses in
`do_secure_storage_access()` — kernel secure-storage exceptions on
vmalloc must not go through `virt_to_folio()` / `virt_to_phys()`.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>`
- `Signed-off-by: Heiko Carstens <hca@linux.ibm.com>` (author; s390 arch
  maintainer)
- `Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>`
  (KVM/s390)
- `Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>` (s390 tree
  maintainer)
- No `Fixes:` tag (expected for this review pipeline)
- No `Reported-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
- Ignore any later Sasha Levin SOB / “Upstream commit” markers (none on
  the raw commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** PGM 0x3d (secure storage access) on a vmalloc address is fed
  to `virt_to_folio()` / `virt_to_phys()`, which are not valid for
  vmalloc.
- **Symptom:** wrong folio/PFN, then `uv_convert_from_secure()` on the
  wrong physical page, or a failed get and an unresolved fault (retry
  loop). Cover letter: kernel should fix up or crash, not convert a
  random page.
- **Version info in message:** none. Git places it in v7.3-rc1
  (`v7.3-rc1~73^2~35`).
- **Root cause (author):** vmalloc is not a linear kernel mapping; there
  is no legitimate convert-from-secure for that address, so fail
  immediately via the existing fault-error path.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject and body say **Fix**. Cover letter for v4 of
the series lists this as a real pre-existing bug, distinct from two
later “cosmetics” patches the author explicitly said were not bug fixes.

---

## Phase 2: Diff analysis

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `arch/s390/mm/fault.c` (+2 / −0)
- Function: `do_secure_storage_access()`
- Scope: **single-file surgical fix**, two lines in the kernel-fault
  branch

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `is_kernel_fault()` → `virt_to_folio((void *)addr)` →
  `folio_try_get` → `uv_convert_from_secure(folio_to_phys(folio))`.
- **After:** if `is_vmalloc_addr(addr)`, `return
  handle_fault_error_nolock(regs, 0)` (exception-table fixup, or
  oops/`die`). Linear-map kernel faults unchanged.
- Path: kernel (not user) PGM 0x3d on a vmalloc address.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** memory-safety / logic — invalid virt-to-phys on vmalloc;
  can become wrong-page UV export or an unresolved fault.
- **Mechanism:** `virt_to_folio()` uses `virt_to_page()` → `__pa()`. On
  s390 `__pa()` is identity/KASLR linear-map math
  (`arch/s390/include/asm/page.h`), not a page-table walk. A vmalloc
  address yields a bogus PFN. `uv_convert_from_secure()` then talks to
  the Ultravisor about that PFN.
- **Fix:** reject vmalloc up front; same helper already used on other
  kernel-fault failures in this file.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: vmalloc is not a valid convert-from-secure target;
  the author states there is no valid access.
- Minimal; no unrelated edits; no new API.
- Regression risk is low. Kernel-mode `handle_fault_error_nolock(...,
  0)` does not take the user `WARN_ON_ONCE(!si_code)` path; it
  `fixup_exception()` or oopses. That matches “fixup or crash.”
- Follow-up `ecb00aa6fb7f4` still keeps this check after switching to
  `__pa(addr)`, which confirms the check is not a folio-API workaround.

---

## Phase 3: Git history investigation

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Handler introduced in `084ea4d611a3` (2020, “s390/mm: add (non)secure
  page access exceptions handlers”) — `phys_to_page(addr)` on
  KERNEL_FAULT (virt treated as phys).
- `b95e0e792822b` (v7.1-rc2) switched that to `virt_to_folio()` (“Fix
  phys_to_folio() usage”). Correct for the linear map, still wrong for
  vmalloc.
- The two new lines are this commit, `a2e5a9d853e01` (Heiko Carstens,
  2026-07-20).
- Current tree still has them (blame on `arch/s390/mm/fault.c` lines
  440–441).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Closest introduction of the *current* wrong
helper is `b95e0e792822b`; the vmalloc hole exists conceptually since
`084ea4d611a3`. Both are ancestors of this checkout.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-day series (AuthorDate 2026-07-20):
1. `7cf227b2707ed` — NULL `mm` check (user path; Sashiko)
2. `79ef8d384fdfb` — `lock_mm_and_find_vma()` (user path)
3. **`a2e5a9d853e01` — this vmalloc check (kernel path)**
4. `ecb00aa6fb7f4` — drop folio_try_get race; use `__pa()`
5. `da1f5a7dcf182` / `e462200886fb5` — author-labeled cosmetics
6. `656db3022083a` — re-enable `DCACHE_WORD_ACCESS`

This hunk is on the kernel-fault branch only and does not depend on 1–2.
Standalone as a two-line insert. `handle_fault_error_nolock` already
existed (`a5600f05d3d7a`, v6.13 era) and was already used in this
function (`b00be77302d7e`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Heiko Carstens is the s390 arch maintainer and owns most of this
function’s recent history. Christian Borntraeger tested and reviewed.
Not a drive-by.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `is_kernel_fault()`, `is_vmalloc_addr()` (`<linux/mm.h>`,
already included), and `handle_fault_error_nolock()`. All present here.
Does **not** require re-enabling `DCACHE_WORD_ACCESS`. `git merge-base
--is-ancestor a2e5a9d853e01 HEAD` succeeds — already in this tree as a
historical fact, not as a selection marker.

---

## Phase 4: Mailing list and external research

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a2e5a9d853e01` →
  https://patch.msgid.link/20260720085834.898025-5-hca@linux.ibm.com
- **[PATCH v4 4/8]** in “s390: Reintroduce support for
  DCACHE_WORD_ACCESS”
- Revisions: v1 (2026-07-16) → v2 → v3 → **v4 (applied)**
- v3 changelog: “Fix two more pre-existing bugs reported by Sashiko”
- Cover letter lists this as one of the real problems, separate from
  kcore VM_SPARSE and from the folio-race patch
- Direct review: Borntraeger `Reviewed-by`; no NAK
- Vasily Gorbik: “Applied, thank you!”
- lore.kernel.org HTTP fetch returned 403 (Anubis). Thread recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Heiko Carstens, Alexander Gordeev, Sven Schnelle,
Vasily Gorbik, Christian Borntraeger, Janosch Frank, Claudio Imbrenda,
David Hildenbrand; `linux-s390@`, `kvm@`, `linux-kernel@`. Right
maintainers and lists.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Concrete trigger is documented in the **same
series**:
- Cover letter: DCACHE_WORD_ACCESS was reverted in `37540b8c287fc`
  because secure-storage handling was incomplete (endless exception
  loop); that revert had `Cc: stable`.
- Patch 1 (`aab0734094cef`): “The guest variable storage area is
  allocated with **vmalloc** and then donated to the ultravisor. Any
  kernel access to that area will result in a secure storage access
  exception.” `/proc/kcore` via `vread_iter()` was a known short-
  read/exception.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 8-patch v4 series. This patch is self-contained. Later
`ecb00aa6fb7f4` keeps the vmalloc check. Re-enabling DCACHE_WORD_ACCESS
is a **feature** and is not required for this fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Direct lore.kernel.org/stable search blocked (403). Unverified
whether anyone mailed stable@ for this SHA. The related revert
`37540b8c287fc` **was** tagged `Cc: stable`, so stable trees that had
word-at-a-time already treated this class of bug as important.

---

## Phase 5: Code semantic analysis

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `do_secure_storage_access()` only.

**Step 5.2: TRACE CALLERS**
Record:
- `arch/s390/kernel/traps.c` program-check table `[0x3d] =
  do_secure_storage_access`
- Hardware PGM 0x3d (secure-storage access), not a syscall helper
- Compiled only under `#if IS_ENABLED(CONFIG_KVM)` in `fault.c`

**Step 5.3: TRACE CALLEES**
Record: `is_vmalloc_addr()`, `handle_fault_error_nolock()` →
`fixup_exception()` / `kfence_handle_page_fault()` / `die()`. Pre-fix
callees: `virt_to_folio`, `folio_try_get`, `uv_convert_from_secure`,
`folio_put`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from:
- Kernel access to UV-donated **vmalloc** (guest variable storage;
  kcore)
- `load_unaligned_zeropad()` spanning into a donated page once
  DCACHE_WORD_ACCESS is on (this tree has it again via `656db3022083a`)
Unprivileged user can trigger kcore only with privilege; zeropad/dcache
is a common kernel path (namei/dcache) and can touch adjacent pages.
Protected-virt hosts are the affected population.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: No other `virt_to_folio` in this handler’s kernel-fault path
after `ecb00aa6fb7f4`. `uv_convert_from_secure()` in
`arch/s390/kernel/uv.c` takes a **physical** address; callers must not
pass vmalloc virt.

---

## Phase 6: Cross-referencing against the local tree

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` → **7.3.0-rc4**
- This is mainline 7.3-rc, not a `-stable` y-tree
- Function exists at `arch/s390/mm/fault.c:408`
- Current kernel-fault path still has the vmalloc check (lines 440–441)
  then `__pa(addr)`
- Bug is real in any tree that still does `virt_to_folio`/`__pa` on the
  fault address without a vmalloc guard — including this line of
  development before `a2e5a9d853e01`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Against **this** checkout the patch is already applied; the
surrounding kernel-fault `if` matches the parent of `a2e5a9d853e01`.
Expected difficulty on a tree that still has `folio =
virt_to_folio((void *)addr);` in that `if`: **clean apply**. Helpers
exist here.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix is already an ancestor of HEAD. That is mainline
history, not “already selected for stable.” No substitute vmalloc guard
appears before `a2e5a9d853e01`.

---

## Phase 7: Subsystem and maintainer context

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **arch/s390 MM + KVM protected virtualization**. Criticality:
**IMPORTANT** for s390 KVM PV (Ultravisor / confidential guests) — not
universal, but confidentiality and host stability for that platform.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (Heiko/Vasily/Borntraeger). Handler dates to
2020; this is a long-standing hole, not a brand-new subsystem.

---

## Phase 8: Impact and risk assessment

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Platform-specific + config-specific:** s390, `CONFIG_KVM`,
protected-virt host (pages donated to UV). Not all Linux users; all such
hosts that can take PGM 0x3d on vmalloc.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Kernel access to UV-donated vmalloc (documented: former vmalloc
  stor_var + `/proc/kcore`)
- Word-at-a-time / zeropad crossing into donated memory (this tree has
  DCACHE_WORD_ACCESS again)
- Not a userspace-unprivileged primitive in the usual sense; kcore needs
  privilege; zeropad is kernel-internal but common on PV hosts

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Wrong PFN → `uv_convert_from_secure()` on the **wrong** page: guest-
  confidentiality break / host page state corruption → **CRITICAL** on
  PV
- `folio_try_get` fail → silent return → instruction retry → **endless
  PGM 0x3d** (the failure mode that forced the DCACHE revert) →
  **CRITICAL** (lockup)
- Severity: **CRITICAL** when it hits; trigger is not every boot, but it
  is a documented real path

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for s390 PV — avoids wrong UV export and exception
  storms
- **Risk:** very low — two lines, existing helper, linear-map path
  unchanged
- **Ratio:** strongly favors backport

---

## Phase 9: Final synthesis

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real bug: `virt_to_folio`/`__pa` on vmalloc is invalid on s390
- Failure modes: wrong-page `uv_convert_from_secure`, unresolved fault /
  infinite PGM 0x3d
- Documented trigger: vmalloc UV storage; kcore; later zeropad
- 2-line, surgical, uses existing `handle_fault_error_nolock`
- Written/acked by s390 maintainers; Tested-by + Reviewed-by Borntraeger
- Author treated it as a bug fix, not as the DCACHE feature patch
- Follow-up kept the same check with `__pa`
- Code and helpers exist in this 7.3-rc4 tree

**AGAINST:**
- s390 + KVM PV only (smaller user base than core mm)
- Part of a larger DCACHE series — but this hunk does not enable that
  feature
- No `Fixes:` / `Cc: stable` (not a negative per the rules)
- Direct stable@ lore search could not be completed (403)

**UNRESOLVED:**
- Whether stable@ already discussed this exact SHA (lore HTTP blocked)
- Exact older-stable context outside this checkout — not used for the
  verdict

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two-line guard; Tested-by
   Borntraeger
2. Fixes a real bug that affects users? **PASS** — wrong phys conversion
   / exception loop on PV hosts
3. Important (crash, security, corruption, deadlock)? **PASS** — UV
   export of the wrong page and/or host lockup
4. Small and contained? **PASS** — +2 lines, one function
5. No new features or APIs? **PASS** — not the DCACHE re-enable
6. Can apply to the local tree? **PASS** — helpers and call site exist;
   this checkout already contains the change as mainline history

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device-ID/quirk/DT/build/doc exception). Qualifies
as a normal important bug fix.

**Step 9.4: MAKE YOUR DECISION**

This tree is **Linux 7.3-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
surrounding handler, `is_vmalloc_addr()`, and
`handle_fault_error_nolock()` are all here. The bug is using linear-map
virt-to-phys on a vmalloc PGM 0x3d, which can export the wrong page from
secure storage or never resolve the fault.

The patch is two lines, maintainer-written, tested, and independent of
re-enabling `DCACHE_WORD_ACCESS`. Benefit is high for s390 protected-
virt; regression risk is very low. It meets the stable-kernel rules for
**this** checkout.

---

### What the commit solves (for this tree)

`do_secure_storage_access()` handled kernel PGM 0x3d by converting the
fault address with `virt_to_folio()`. That is only valid for the
identity/KASLR linear map. Vmalloc (including UV guest variable storage
allocated with vmalloc, and later word-at-a-time probes) must not take
that path. The fix fails those faults immediately so the kernel can
exception-fixup or oops instead of converting a random physical page.

### Verification
- **[Phase 1]** Parsed tags: Tested-by/Reviewed-by Borntraeger; SOB
  Heiko + Vasily; no Fixes/Cc stable/syzbot
- **[Phase 2]** Diff: +2 lines in `do_secure_storage_access()` kernel-
  fault branch; `is_vmalloc_addr` then `handle_fault_error_nolock`
- **[Phase 2]** Read `arch/s390/include/asm/page.h` `__pa_nodebug`:
  linear map only, not vmalloc
- **[Phase 2]** Read `include/linux/mm.h` `virt_to_folio`:
  `virt_to_page` → `__pa`
- **[Phase 3]** `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- **[Phase 3]** `git merge-base --is-ancestor a2e5a9d853e01 HEAD`: yes
  (mainline ancestor, not a selection marker)
- **[Phase 3]** `git show a2e5a9d853e01`: matches the provided diff
- **[Phase 3]** `git blame` on `fault.c` 408–470: handler from
  `084ea4d611a3` (2020); vmalloc lines from this commit
- **[Phase 3]** `git show b95e0e792822b`: phys_to_folio → virt_to_folio
  in v7.1-rc2; vmalloc still wrong
- **[Phase 3]** `git show ecb00aa6fb7f4`: later `__pa` path **keeps**
  the vmalloc check
- **[Phase 3]** `git show 37540b8c287fc`: DCACHE revert; endless PGM
  0x3d; `Cc: stable`
- **[Phase 4]** `b4 dig -c/-a/-w/-m`: v4 4/8; lore msgid
  `20260720085834.898025-5-hca@linux.ibm.com`; v1–v4; s390/KVM CCs;
  Borntraeger R-b; Gorbik applied
- **[Phase 4]** WebFetch lore.kernel.org: 403; discussion taken from b4
  mbox instead
- **[Phase 4]** Cover letter: this is a listed pre-existing bug, not
  cosmetics
- **[Phase 4]** `git show aab0734094cef`: stor_var was vmalloc then
  donated to UV; kernel access → PGM 0x3d
- **[Phase 5]** Callers: `traps.c` `[0x3d]`; `#if
  IS_ENABLED(CONFIG_KVM)`
- **[Phase 5]** Read `handle_fault_error_nolock`: kernel path fixup or
  `die`
- **[Phase 6]** Read current `fault.c` 439–449: vmalloc check still
  present
- **[Phase 8]** Failure mode: wrong UV export and/or infinite exception
  — CRITICAL for s390 PV
- **UNVERIFIED:** stable@ mailing-list threads for this SHA (lore 403)

The fix is small, obviously correct, and addresses a real
crash/corruption/confidentiality bug on this tree’s s390 KVM PV path.

**YES**

 arch/s390/mm/fault.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 46e5748b5b1b3..9d7d3ef99fc16 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -433,6 +433,8 @@ void do_secure_storage_access(struct pt_regs *regs)
 		panic("Unexpected PGM 0x3d with TEID bit 61=0");
 	}
 	if (is_kernel_fault(regs)) {
+		if (is_vmalloc_addr((void *)addr))
+			return handle_fault_error_nolock(regs, 0);
 		folio = virt_to_folio((void *)addr);
 		if (unlikely(!folio_try_get(folio)))
 			return;
-- 
2.53.0

