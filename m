Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9658A53AE87;
	Mon, 19 Oct 2026 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418178; cv=none; b=S/qwO5dablCU0QDdjQn/Ud2WX6yhEn1OFEVd73k6Lgi2qGE+8UTKo1uP1ssqcXnmOdcbk2Gl+6H2RzAkGl874LUIyJheDU38yaQntuEEA3DmuK6PfQiRGMIGw4r6YLdd2IPq1UkvSwXcDfpKEHdRogKZmlMFc9ZYn8xrzdvHFfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418178; c=relaxed/simple;
	bh=34tPR/w1I3Cwp0ZGrFWOxchSRlS1xKhkm2ybtEcZL9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tYMy00AdR4a5BIGPqC99V5xKVEPQr4W+tfvzhgxygmqsf7Nsk5GKdrWscN9tbbXqcpxw4sKigewJD+DPXuhu09rNM/SLxYoeECut4mKZeAJ1+RHFMq5l8zJ1REym7hhN2ypuc3aLBb5pUPfpTn6qBIDhAteKV4hgrz56Vo0UT4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3k/LumX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3k/LumX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FBB1F000C9;
	Mon, 19 Oct 2026 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418174;
	bh=KUxLdn0xz/vUT+PLJ3jixWo7tdSyz1KnmaUmfDQihSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M3k/LumXRdOBwi2/UczLwZ7Vxbi0X627C/vxgXISXrKomKWHP7zgR2X24d70Gnar0
	 vbch88jcJxy9qRD23lymwyudZo5WoB4naITn5JmihgLercsVhLLRLNQ2j/cMPvLJ5P
	 Imdr+f1iGh7VXxV74KOLqpbkRlafLaKQ2Ur+0Rsm4rFcV9Juq3FX/cROVG6aqsuOan
	 jDM00wA+2BjZmaeIdiQamxoVeiv4YFXjkXpRuGGQjzxSDKSkwHllDESv+n7wfKh1Kg
	 nx5dIppZ3+1+oIiFRFza+XuR0ZyOAOkCLeMRS4kwzFmhbgTDAHVLA3cJ1huGwKvlCg
	 GcXoUvLC7WOTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] arm64/runtime-const: Use aarch64_insn_patch_text_nosync() for patching
Date: Mon, 19 Oct 2026 09:45:56 -0400
Message-ID: <20261019135441.1420968-65-sashal@kernel.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit a6690350a4ae7558b39d15fcc776c4d1ab5bbf39 ]

The current scheme to directly patch the kernel text for runtime
constants runs into the following issue with futex adapted to using
runtime constants on arm64:

  Unable to handle kernel write to read-only memory at virtual address ...

The pc points to the *p assignment in the following call chain:

  futex_init()
    runtime_const_init(shift, __futex_shift)
      __runtime_fixup_shift()
        *p = cpu_to_le32(insn);

which suggests that core_initcall() is too late to patch the kernel text
directly unlike the "d_hash_shift" which is initialized during
vfs_caches_init_early() before the protections are in place.

Use aarch64_insn_patch_text_nosync() to patch the runtime constants
instead of doing it directly to allow runtime_const_init() slightly
later into the boot.

Since aarch64_insn_patch_text_nosync() calls caches_clean_inval_pou()
internally, __runtime_fixup_caches() ends up being redundant.
runtime_const_init() are rare and the overheads of multiple calls to
caches_clean_inval_pou() instead of batching them together should be
negligible in practice.

The cpu_to_le32() conversion of instruction isn't necessary since it is
handled later in the aarch64_insn_patch_text_nosync() call-chain:

  aarch64_insn_patch_text_nosync(addr, insn)
    aarch64_insn_write(addr, insn)
      __aarch64_insn_write(addr, cpu_to_le32(insn))

Sashiko noted that aarch64_insn_patch_text_nosync() does not expect a
lm_alias() address and Catalin suggested it is safe to drop the
lm_alias() for runtime patching since the kernel text is readable. The
address passed to fixup function is interpreted as a __le32 and
dereferenced as is to read the opcode at the patch site.

No functional changes are intended.

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Link: https://patch.msgid.link/20260728052540.4728-3-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
## Phase 1: Commit message forensics

**Step 1.1 — Subject line**
- Record: **[arm64/runtime-const] [Use] switch text patching from a
  direct store to `aarch64_insn_patch_text_nosync()`**

**Step 1.2 — Tags**
- Record:
  - Signed-off-by: K Prateek Nayak (author)
  - Signed-off-by: Peter Zijlstra (locking/futex maintainer)
  - Reviewed-by: Catalin Marinas (arm64 maintainer)
  - Reviewed-by: Charlie Jenkins
  - Tested-by: Charlie Jenkins
  - Link: https://patch.msgid.link/20260728052540.4728-3-
    kprateek.nayak@amd.com
  - No Fixes:, no Reported-by, no Cc: stable (absence expected)
  - Ignore pipeline SOBs if present; none in the real commit

**Step 1.3 — Body**
- Record:
  - **Bug:** arm64 runtime-const writes the patched opcode with `*p =
    cpu_to_le32(insn)` through `lm_alias()`. That faults once kernel
    text (including the linear alias) is read-only.
  - **Symptom:** `Unable to handle kernel write to read-only memory`
    during `futex_init()` → `runtime_const_init()` →
    `__runtime_fixup_shift()`.
  - **Root cause:** `d_hash_shift` is patched in
    `vfs_caches_init_early()` while the linear alias is still writable.
    `futex_init()` is a `core_initcall`, after
    `mark_linear_text_alias_ro()`.
  - **Fix:** use the existing text-poking helper (fixmap writable alias
    + cache maintenance). Drop redundant `__runtime_fixup_caches()` and
    `cpu_to_le32()` (done inside the helper). Drop `lm_alias()` because
    the helper wants a kernel-text address.
  - **Version info:** none beyond the futex/runtime-const interaction.

**Step 1.4 — Hidden bug fix?**
- Record: Not hidden. The message describes a concrete oops. “No
  functional changes are intended” means the patched immediates are the
  same; the write path is what changes so late `runtime_const_init()`
  can succeed.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: one file, `arch/arm64/include/asm/runtime-const.h` (~5
  insertions, 12 deletions). Functions: `__runtime_fixup_16()`,
  `__runtime_fixup_caches()` (removed), `__runtime_fixup_ptr()`,
  `__runtime_fixup_shift()`. Surgical, single-header.

**Step 2.2 — Flow change**
- Record:
  - **Before:** read opcode at `lm_alias(where)`, store new insn with
    `*p = cpu_to_le32(insn)`, then `caches_clean_inval_pou()` on the
    original VA.
  - **After:** pass the kernel-text pointer and host-endian insn to
    `aarch64_insn_patch_text_nosync()`, which maps a writable fixmap
    page, writes, and flushes I/D caches.
  - Affected path: boot-time `runtime_const_init()` only (not a hot
    path).

**Step 2.3 — Bug mechanism**
- Record: **logic/correctness of text patching after RO protection**.
  Direct store to RO kernel text. The helper uses `patch_map()` →
  `FIX_TEXT_POKE0`, the same path as kprobes/jump labels/ftrace.

**Step 2.4 — Fix quality**
- Record: Obviously correct. Matches how arm64 already patches text.
  Regression risk is low: leftover `#include <asm/cacheflush.h>` is
  unused after the helper absorbs the flush; return value of the helper
  is ignored (old path had no error check either; kernel text is 4-byte
  aligned). Catalin confirmed dropping `lm_alias()` is safe because
  kernel text remains readable for the opcode load.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Buggy direct-write scheme introduced in `94a2bc0f611cd`
  (“arm64: add 'runtime constant' support”, Linus, 2024-07-09). Present
  since ~v6.11. The crash only appears when `runtime_const_init()` runs
  after `mark_linear_text_alias_ro()`.

**Step 3.2 — Fixes: tag**
- Record: none. Introducing commit is `94a2bc0f611cd` (in this tree).
  The late caller that actually faults is `b78b0b6582527` (“futex: Use
  runtime constants for `__futex_hash()` hot path”), also in this tree
  (v7.3-rc1).

**Step 3.3 — File history**
- Record: `94a2bc0f611cd` add support → `0100e495cdf04` modules ban →
  **`a6690350a4ae7` this fix** → `7eccf137dc044`
  `runtime_const_mask_32()`. Same series as the futex conversion; this
  patch is 2/8 and does not depend on later patches. Later mask support
  *uses* this helper.

**Step 3.4 — Author**
- Record: K Prateek Nayak (AMD), not the arm64 maintainer. Arm64 review
  is from Catalin. Peter Zijlstra signed off (locking tree). Related:
  `7eccf137dc044` immediately after.

**Step 3.5 — Dependencies**
- Record: Needs `aarch64_insn_patch_text_nosync()` / `<asm/text-
  patching.h>` — present at the parent and on HEAD. Standalone vs the
  rest of the series. On *this* tree the futex caller is already
  present, so the fix is load-bearing.

## Phase 4: Mailing list

**Step 4.1 — Original discussion**
- Record: `b4 dig -c a6690350a4ae` → `[PATCH v6 2/8] arm64/runtime-
  const: Use aarch64_insn_patch_text_nosync() for patching` at
  https://patch.msgid.link/20260728052540.4728-3-kprateek.nayak@amd.com.
  Cover: `[PATCH v6 0/8] futex: Use runtime constants for futex_hash
  computation`. v5→v6: no diff change on this patch; tags collected. No
  NAKs. Sashiko noted the helper must not get an `lm_alias()` address;
  Catalin said dropping it is fine. No reviewer asked for Cc: stable.

**Step 4.2 — Recipients**
- Record: Catalin Marinas, Will Deacon, Peter Zijlstra, Thomas Gleixner,
  linux-arm-kernel, linux-arch. Right maintainers were on the To/Cc
  list. Catalin Reviewed-by is on the committed patch.

**Step 4.3 — Bug report**
- Record: No syzbot/bugzilla. The oops is from the author’s own
  futex+runtime-const bring-up on arm64. Charlie Jenkins Tested-by.
  Cover letter: build+boot on x86 bare metal and QEMU for other arches.

**Step 4.4 — Series**
- Record: v6 8-patch feature series. This commit is the arm64 text-
  poking prerequisite. Patch 8 adds `runtime_const_init()` in
  `futex_init()`. Both are in this 7.3-rc4 tree.

**Step 4.5 — Stable list**
- Record: UNVERIFIED for a dedicated stable@ thread (lore HTTP 403). No
  stable mention in the saved v6 mbox.

## Phase 5: Code semantics

**Step 5.1 — Functions**
- Record: `__runtime_fixup_16`, `__runtime_fixup_ptr`,
  `__runtime_fixup_shift`; `__runtime_fixup_caches` removed. Current
  tree also has `__runtime_fixup_mask` (later commit) using the same
  helper.

**Step 5.2 — Callers**
- Record: `runtime_const_init()` → `runtime_const_fixup()` → those
  fixups. Call sites in this tree:
  - `kernel/futex/core.c` `futex_init()` — `core_initcall` — **after**
    `smp_cpus_done()` → `mark_linear_text_alias_ro()`
  - `fs/dcache.c`, `fs/file_table.c`, `fs/namei.c` —
    `vfs_caches_init[_early]()` in `start_kernel()` — **before** that RO
    switch

**Step 5.3 — Callees**
- Record: `aarch64_insn_patch_text_nosync()` → `aarch64_insn_write()` →
  `__aarch64_insn_write()` (`patch_map` + `copy_to_kernel_nofault`) +
  `caches_clean_inval_pou()`.

**Step 5.4 — Reachability**
- Record: Unconditional on arm64. `futex_init` is a `core_initcall`.
  Every arm64 boot on this tree hits the late patch. Without this fix:
  boot oops.

**Step 5.5 — Similar patterns**
- Record: x86 runtime-const still does a direct store and documents
  “only at init before text is RO”. arm64’s linear-map alias is marked
  RO earlier (`smp_cpus_done`), so arm64 cannot follow that model for
  `core_initcall`.

## Phase 6: This tree

**Step 6.1 — Buggy code here?**
- Record: Yes. Tree is **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`).
  File exists. Pre-fix body is at `a6690350a4ae^`. `futex_init()` still
  calls `runtime_const_init()` (`kernel/futex/core.c`). The fix commit
  **is already an ancestor of HEAD** (in v7.3-rc1). Current `runtime-
  const.h` already calls `aarch64_insn_patch_text_nosync()`.

**Step 6.2 — Backport difficulty**
- Record: Clean on the parent snapshot. Current HEAD already has this
  plus `runtime_const_mask_32()`; re-applying the exact hunk would be a
  no-op / already-applied.

**Step 6.3 — Related fixes already here**
- Record: This *is* the fix. No later Fixes: for `a6690350`. Follow-up
  `7eccf137dc044` only adds mask patching on the new helper.

## Phase 7: Subsystem

**Step 7.1**
- Record: **arch/arm64** text-patching used by **futex** (core locking).
  Criticality: **IMPORTANT** — every arm64 boot.

**Step 7.2**
- Record: Active in the 7.3 window (futex runtime-const series). The
  underlying helper is old, stable infrastructure.

## Phase 8: Impact and risk

**Step 8.1**
- Record: All arm64 users of this kernel (futex init is not optional).

**Step 8.2**
- Record: Every boot, `core_initcall(futex_init)`. Not userspace-
  triggered; it is a boot breaker.

**Step 8.3**
- Record: Kernel fault writing RO text → boot failure. **CRITICAL**.

**Step 8.4**
- Record: Benefit high (arm64 actually boots with the futex runtime-
  const code this tree already has). Risk low (~one-header, established
  poking API, arm64 maintainer Reviewed-by).

## Phase 9: Synthesis

**Evidence for YES**
- Documented oops: write to RO memory in `__runtime_fixup_shift()`.
- This tree has the late caller (`futex_init` / `core_initcall`) and
  `mark_linear_text_alias_ro()` in `smp_cpus_done()` before
  `do_basic_setup()` / initcalls.
- Small, local, uses the standard arm64 patching API.
- Reviewed by Catalin Marinas; tested by Charlie Jenkins; signed off by
  Peter Zijlstra.
- No new userspace API.

**Evidence against**
- Lives in a feature series (futex hash optimization). On trees
  *without* a late `runtime_const_init()`, the old path never faulted.
- No Fixes:/Cc: stable (not a negative under these rules).
- Already in this 7.3-rc4 history, so a second apply is unnecessary —
  that is not used as a NO (pipeline “already selected” is ignored).

**Unresolved**
- No stable@ thread readable (lore 403). Does not change the local
  technical picture.

**Stable-rules checklist**
1. Obviously correct and tested — **PASS** (Catalin + Tested-by + QEMU
   boot)
2. Real user-visible bug — **PASS** (arm64 boot oops with this tree’s
   futex init)
3. Important (crash) — **PASS** (CRITICAL)
4. Small/contained — **PASS** (one header, ~17 lines)
5. No new features/APIs — **PASS**
6. Applies to this tree — **PASS** (code and helper are here; commit
   already merged in 7.3-rc1)

**Exception category:** none (not an ID/quirk/DT/docs/build-only
change).

This tree ships both the late `runtime_const_init()` and arm64
`STRICT_KERNEL_RWX` linear-alias RO. The old `lm_alias()` store is a
boot crash. Replacing it with `aarch64_insn_patch_text_nosync()` is the
correct, minimal fix and belongs in this series.

### Verification
- [Phase 1] Parsed tags: Reviewed-by Catalin Marinas, Tested-by Charlie
  Jenkins, Link to v6 2/8; no Fixes:/syzbot
- [Phase 2] Diff: one file; direct `*p` store + `lm_alias` +
  `__runtime_fixup_caches` replaced by `aarch64_insn_patch_text_nosync`
- [Phase 2] Confirmed helper: `arch/arm64/kernel/patching.c`
  `aarch64_insn_patch_text_nosync()` → write via `patch_map` +
  `caches_clean_inval_pou`
- [Phase 3] `git describe HEAD` / Makefile: **v7.3-rc4**, `7.3.0-rc4`
- [Phase 3] `git merge-base --is-ancestor a6690350 HEAD`: yes; also in
  v7.3-rc1; not in v7.2
- [Phase 3] Blame: buggy writes from `94a2bc0f611cd` (2024); late caller
  `b78b0b6582527` in this tree
- [Phase 3] Parent file shown: `*p = cpu_to_le32(insn)` + `lm_alias`
- [Phase 4] `b4 dig -c a6690350`: lore match v6 2/8; mbox saved; no NAK;
  Catalin R-b on the patch
- [Phase 4] Cover letter: feature series for futex runtime const; this
  patch is the arm64 poking prerequisite
- [Phase 4] UNVERIFIED: stable@ mailing-list search (lore 403)
- [Phase 5] Callers: futex `core_initcall` (late); VFS caches in
  `start_kernel` (early)
- [Phase 5] `mark_linear_text_alias_ro()` called from `smp_cpus_done()`;
  `do_basic_setup()`/`do_initcalls()` after `smp_init()`
- [Phase 6] Current `runtime-const.h` already uses the helper; `text-
  patching.h` exists at parent
- [Phase 8] Failure mode: RO-text write → boot oops on all arm64,
  CRITICAL
- UNVERIFIED: Catalin’s original review mail text (only R-b + commit-
  message paraphrase in v6 mbox)

The patch is small, uses the existing arm64 text-poking path, and
prevents a boot crash on this tree’s futex `runtime_const_init()`.

**YES**

 arch/arm64/include/asm/runtime-const.h | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/runtime-const.h b/arch/arm64/include/asm/runtime-const.h
index be5915669d239..31a6f94e57955 100644
--- a/arch/arm64/include/asm/runtime-const.h
+++ b/arch/arm64/include/asm/runtime-const.h
@@ -3,6 +3,7 @@
 #define _ASM_RUNTIME_CONST_H
 
 #include <asm/cacheflush.h>
+#include <asm/text-patching.h>
 
 /* Sigh. You can still run arm64 in BE mode */
 #include <asm/byteorder.h>
@@ -46,34 +47,26 @@ static inline void __runtime_fixup_16(__le32 *p, unsigned int val)
 	u32 insn = le32_to_cpu(*p);
 	insn &= 0xffe0001f;
 	insn |= (val & 0xffff) << 5;
-	*p = cpu_to_le32(insn);
-}
-
-static inline void __runtime_fixup_caches(void *where, unsigned int insns)
-{
-	unsigned long va = (unsigned long)where;
-	caches_clean_inval_pou(va, va + 4*insns);
+	aarch64_insn_patch_text_nosync(p, insn);
 }
 
 static inline void __runtime_fixup_ptr(void *where, unsigned long val)
 {
-	__le32 *p = lm_alias(where);
+	__le32 *p = where;
 	__runtime_fixup_16(p, val);
 	__runtime_fixup_16(p+1, val >> 16);
 	__runtime_fixup_16(p+2, val >> 32);
 	__runtime_fixup_16(p+3, val >> 48);
-	__runtime_fixup_caches(where, 4);
 }
 
 /* Immediate value is 6 bits starting at bit #16 */
 static inline void __runtime_fixup_shift(void *where, unsigned long val)
 {
-	__le32 *p = lm_alias(where);
+	__le32 *p = where;
 	u32 insn = le32_to_cpu(*p);
 	insn &= 0xffc0ffff;
 	insn |= (val & 63) << 16;
-	*p = cpu_to_le32(insn);
-	__runtime_fixup_caches(where, 1);
+	aarch64_insn_patch_text_nosync(p, insn);
 }
 
 static inline void runtime_const_fixup(void (*fn)(void *, unsigned long),
-- 
2.53.0

