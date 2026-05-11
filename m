Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883A44DB548;
	Mon, 11 May 2026 22:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778537989; cv=none; b=ingE2hSUZ5mKK8g/od+B8d0FJ7kU9DapxXxSsavLDQZcuovlIc3GP/ilr+JWtxAY8Pi3k8HKqoeSwyhsKARZFpF2yMnhGyVhhKLtOfjeE+uOmS7X2boa0ySEdcwG1hMZFwqJgQiFvVFMhgSqE5jOYVqZxSSltFYSt5rXYBbIVk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778537989; c=relaxed/simple;
	bh=zGb5XWpc6ZIDpU9QwhdmaqYvZSeao8Zu2vRfr5h3CZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qOwRSRFEKwGHIxNDk9U+pwVTpVZA0p2+WqQ18+nTvYer0n/YukMC1cWwNc6gUZb2Jw8nh0fLJNO03s8+DXNeh6ed+mgjjY8+ddsVHXziQm29NwMGQi310Ve4DlnoCCfJ0drtHPy1sm5rLwBTiHrbv+uWT8XWbDV4PwL8E9eGDmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9kr+phy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9kr+phy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB62BC2BCF7;
	Mon, 11 May 2026 22:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778537987;
	bh=zGb5XWpc6ZIDpU9QwhdmaqYvZSeao8Zu2vRfr5h3CZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9kr+phy7rRnFIeKi3kiaOVCuFx9zoupJJToECCTXR0hGoqIGj+Qrmw8vag1/HfFy
	 NUST0Uo20I72BjJY10MUJcHn/raRhWQGmN795XPqo0UPxDV0XmmrdZutNJsUXbCj+O
	 5/kpkDU6IgNy/HOrdYbNUxn0dAbFiMNx+ji27UsAtrDWSRHJE6C0bWDqg2qjeLTWKn
	 7zuLLKphQhx5tcWsE2Lxpf/mAzLfcZw0hXWT/6+KxSqIO9rWf881AtVZGU7Rlchrrl
	 uRC3jhK7OCaVgimd9iwqxdfGX03soWDeO8U5sTCfDleTlFX4ERd5oPQANRt59G+0kk
	 4SjyMRDXlsNuw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] powerpc/vmx: avoid KASAN instrumentation in enter_vmx_ops() for kexec
Date: Mon, 11 May 2026 18:19:09 -0400
Message-ID: <20260511221931.2370053-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sourabh Jain <sourabhjain@linux.ibm.com>

[ Upstream commit 38e989d504fc52900a3786b7144fb53cd67e0389 ]

The kexec sequence invokes enter_vmx_ops() via copy_page() with the MMU
disabled. In this context, code must not rely on normal virtual address
translations or trigger page faults.

With KASAN enabled, functions get instrumented and may access shadow
memory using regular address translation. When executed with the MMU
off, this can lead to page faults (bad_page_fault) from which the
kernel cannot recover in the kexec path, resulting in a hang.

The kexec path sets preempt_count to HARDIRQ_OFFSET before entering
the MMU-off copy sequence.

current_thread_info()->preempt_count = HARDIRQ_OFFSET
  kexec_sequence(..., copy_with_mmu_off = 1)
    -> kexec_copy_flush(image)
         copy_segments()
           -> copy_page(dest, addr)
	         bl enter_vmx_ops()
                   if (in_interrupt())
                     return 0
	         beq .Lnonvmx_copy

Since kexec sets preempt_count to HARDIRQ_OFFSET, in_interrupt()
evaluates to true and enter_vmx_ops() returns early.

As in_interrupt() (and preempt_count()) are always inlined, mark
enter_vmx_ops() with __no_sanitize_address to avoid KASAN
instrumentation and shadow memory access with MMU disabled, helping
kexec boot fine with KASAN enabled.

Reported-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260407124349.1698552-2-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record: subsystem `powerpc/vmx`; action verb `avoid`; intent is to
prevent KASAN instrumentation of `enter_vmx_ops()` when it is reached
from the kexec MMU-off copy path.

Record: tags parsed from the candidate message:
- `Reported-by: Aboorva Devarajan <aboorvad@linux.ibm.com>`
- `Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>`
- `Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>`
- `Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>`
- `Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>`
- `Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>`
- `Link: https://patch.msgid.link/20260407124349.1698552-2-
  sourabhjain@linux.ibm.com`
- No `Fixes:` tag in this commit. Absence is not a negative signal.

Record: bug description from the message: `kexec_sequence()` may call
`copy_page()` with the MMU disabled; on PowerPC Book3S this can enter
`copypage_power7.S`, which calls `enter_vmx_ops()`. If KASAN instruments
`enter_vmx_ops()`, the instrumentation may access shadow memory using
normal virtual translation, which is invalid with MMU off and can cause
an unrecoverable `bad_page_fault`/hang in kexec.

Record: hidden bug fix: yes. Although phrased as “avoid
instrumentation,” this fixes a real boot/hang failure in the kexec/kdump
path under KASAN.

## Phase 2: Diff Analysis
Record: one file changed: `arch/powerpc/lib/vmx-helper.c`, with 8
insertions and 1 deletion in the fetched v3 patch. The only functional
change is changing `int enter_vmx_ops(void)` to `int
__no_sanitize_address enter_vmx_ops(void)`; the remaining additions are
explanatory comments.

Record: modified function: `enter_vmx_ops()`.

Record: before behavior: `enter_vmx_ops()` could be KASAN-instrumented.
During kexec with MMU off, the function first checks `in_interrupt()`
and should return `0`, but KASAN prologue/body instrumentation can run
before or around normal code and touch shadow memory.

Record: after behavior: `__no_sanitize_address` suppresses KASAN
instrumentation for this function, preserving the intended early return
path when `preempt_count` contains `HARDIRQ_OFFSET`.

Record: bug category: sanitizer/real-mode correctness bug causing kexec
hang. This is a crash/hang class fix, not a cleanup.

Record: fix quality: small, surgical, and low risk. It does not alter
normal logic, public API, data structures, or userspace-visible
behavior. The only behavioral effect is disabling KASAN instrumentation
for one helper that can run in an MMU-off path.

## Phase 3: Git History Investigation
Record: local `HEAD` is a stable release commit, not the candidate. `git
log --grep` on current history, `master`, and `power-next` did not find
the candidate commit locally, so there was no commit hash available for
`b4 dig -c`.

Record: `git blame` on current `arch/powerpc/lib/vmx-helper.c` shows the
unannotated `enter_vmx_ops()` present in the local tree; due this
repository’s history shape, blame attributes the original lines to a
merge/root history point, so the exact original introduction commit was
not verifiable locally.

Record: no candidate `Fixes:` tag to follow. The companion patch in the
same series has `Fixes: 2ab2d5794f14 ("powerpc/kasan: Disable address
sanitization in kexec paths")`; `git show` confirms that commit disabled
sanitization for PowerPC kexec real-mode paths in 2022.

Record: related recent local history: `6bc9c0a905228` changed VMX
usercopy flow and added export context around the same file. That
affects hunk context for older stable trees, but not the actual one-line
fix.

Record: author context: `git log --author="Sourabh Jain" --
arch/powerpc/...` shows multiple PowerPC kexec/crash/fadump commits.
`MAINTAINERS` lists Madhavan Srinivasan and Michael Ellerman as PowerPC
maintainers; Madhavan signed off the candidate.

Record: dependencies: no source-level prerequisite for the annotation
itself. Function `enter_vmx_ops()` and `__no_sanitize_address` exist in
checked stable tags. Functional completeness is best with the companion
patch fixing `KASAN_SANITIZE_core_$(BITS).o`, because review/test
discussion says both patches together make KASAN kexec succeed.

## Phase 4: Mailing List And External Research
Record: `b4 am` for message id
`20260407124349.1698552-2-sourabhjain@linux.ibm.com` fetched a v3 two-
patch series. It reported total patches: 2, current tree apply clean,
and DKIM signature valid for patch 2.

Record: `b4 am -c` checked for newer revisions and did not report a
newer v4. v3 appears to be the latest fetched revision.

Record: `b4 mbox` fetched the v3 thread. Patch 2 was addressed to
`linuxppc-dev` and CC’d PowerPC/kexec stakeholders including Michael
Ellerman, Madhavan Srinivasan, Mahesh Salgaonkar, Hari Bathini, Daniel
Axtens, Venkat Rao Bagalkote, Aboorva Devarajan, and Ritesh Harjani.

Record: `WebFetch` of lore URLs was blocked by Anubis, but `b4` and the
`yhbt.net` lore mirror provided the thread content.

Record: v2 review discussion verified:
- Ritesh Harjani reviewed patch 2 and said “LGTM,” granting `Reviewed-
  by`.
- Aboorva Devarajan reported an actual KASAN-enabled kexec hang on
  pseries PowerVM: system reached “kexec: Starting switchover sequence”
  and then hung.
- Aboorva tested that “with both the patches applied, kexec completes
  successfully with KASAN enabled.”
- v1 annotated both `enter_vmx_ops()` and `exit_vmx_ops()`; v2 removed
  `exit_vmx_ops()` annotation and added the explanatory comment. This
  shows review-driven narrowing of the fix.

Record: stable-specific discussion: Ritesh explicitly suggested `Cc:
stable@vger.kernel.org` for patch 1. I did not find a direct stable
nomination for patch 2, but patch 2 was reviewed and tested as part of
the same two-patch functional fix.

## Phase 5: Code Semantic Analysis
Record: modified function: `enter_vmx_ops()`.

Record: callers found by exact search:
- `arch/powerpc/lib/copypage_power7.S`
- `arch/powerpc/lib/memcpy_power7.S`
- `arch/powerpc/lib/memcmp_64.S`

Record: relevant kexec call chain verified in code:
`reboot(LINUX_REBOOT_CMD_KEXEC)` -> `kernel_kexec()` ->
`machine_kexec()` -> `default_machine_kexec()` -> `kexec_sequence()` ->
`kexec_copy_flush()` -> `copy_segments()` -> `copy_page()` ->
`copypage_power7.S` -> `enter_vmx_ops()`.

Record: key callees/logic in `enter_vmx_ops()`: `in_interrupt()`,
`preempt_disable()`, and `enable_kernel_altivec()`. In the kexec MMU-off
path, `default_machine_kexec()` sets
`current_thread_info()->preempt_count = HARDIRQ_OFFSET`, and
`include/linux/preempt.h` defines `in_interrupt()` via `irq_count()`,
which observes the hardirq bits.

Record: reachability: reachable from privileged kexec/kdump paths. It is
not unprivileged-user reachable, but kdump reliability is operationally
important.

Record: similar patterns: PowerPC already disables KASAN for sensitive
real-mode/interrupt code in multiple Makefiles and uses
`__no_sanitize_address` in PowerPC interrupt/stack code, so the
attribute is consistent with local practice.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Record: buggy code exists in stable tags checked: `v5.4`, `v5.10`,
`v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.18`, `v6.19`, and `v7.0` all have
`enter_vmx_ops()` without `__no_sanitize_address`.

Record: the kexec `copy_segments()` -> `copy_page()` path and
`preempt_count = HARDIRQ_OFFSET` were verified in `v5.4`, `v5.10`,
`v5.15`, `v6.1`, and current/v7.0-era code.

Record: `copypage_power7.S` calls `enter_vmx_ops()` in `v5.4`, `v5.10`,
`v5.15`, and current code.

Record: `__no_sanitize_address` exists in compiler headers in checked
stable tags, including `v5.4`, `v5.10`, `v6.1`, `v6.6`, and current.

Record: backport difficulty: clean on current `7.0.y` per `git apply
--check` and `b4`. Older stable trees may need a tiny context adjustment
because `EXPORT_SYMBOL(exit_vmx_usercopy)` is not present in older
versions, but the actual function signature is present and the backport
is straightforward.

Record: related fixes already in stable: not verified as already
present; local stable tags checked do not contain the candidate
annotation.

## Phase 7: Subsystem And Maintainer Context
Record: subsystem is PowerPC architecture library/kexec path:
`arch/powerpc/lib` and `arch/powerpc/kexec`.

Record: criticality: important/platform-specific. It affects PowerPC
systems using kexec/kdump with KASAN enabled, especially pseries/PowerVM
cases verified in review. It is not universal across all architectures.

Record: subsystem activity: local history shows recent PowerPC VMX
usercopy and kexec/crash/fadump activity, and the patch was handled
through the PowerPC maintainer path.

## Phase 8: Impact And Risk Assessment
Record: affected users: PowerPC Book3S/PowerVM-style systems using
kexec/kdump with KASAN-enabled kernels and VMX copy paths.

Record: trigger conditions: kexec/kdump switchover, MMU-off copy path,
KASAN enabled, and `copy_page()` selecting the Power7 VMX copy path. The
triggering operation is privileged, but the failure impacts crash dump
capture and reboot into the new kernel.

Record: failure mode: system hang during kexec/kdump. Review discussion
includes an observed hang after “kexec: Starting switchover sequence,”
and the commit message explains unrecoverable `bad_page_fault` risk with
MMU off. Severity: HIGH to CRITICAL for affected debug/crash-dump
deployments.

Record: benefit: high for affected PowerPC KASAN/kdump users because it
prevents a hard hang and restores kexec completion.

Record: risk: very low. One function annotation plus comment; no logic
change. The main concern is that stable maintainers should also take the
companion Makefile fix for full KASAN/kexec coverage.

## Phase 9: Final Synthesis
Record: evidence for backporting:
- Fixes a real, reviewed, and tested kexec hang with KASAN enabled.
- Aboorva Devarajan reported and tested the failure/fix.
- Ritesh Harjani reviewed the final approach.
- The fix is one function attribute and explanatory comment.
- It affects a serious operational path: kexec/kdump boot into a
  new/capture kernel.
- The buggy code and call path exist across active stable versions
  checked.
- Backport is clean for current `7.0.y` and trivial for older stable
  trees.

Record: evidence against backporting:
- The issue is config/platform specific: PowerPC plus KASAN plus
  kexec/kdump plus VMX copy path.
- Older stable trees may require minor context adjustment.
- The commit is part of a two-patch series; the companion Makefile KASAN
  fix should be included for the tested complete fix.

Record: unresolved questions:
- Exact original introduction commit for `enter_vmx_ops()` could not be
  verified from local history.
- Direct lore `WebFetch` was blocked by Anubis; I used `b4` and a lore
  mirror instead.
- I did not build-test the backport.

Stable rules checklist:
1. Obviously correct and tested: yes. The annotation directly suppresses
   KASAN instrumentation on the one helper that can execute with MMU
   off; tested-by is present.
2. Fixes a real bug: yes. Review discussion reports an actual kexec hang
   with KASAN.
3. Important issue: yes. Failure mode is kexec/kdump hang.
4. Small and contained: yes. One file, one function annotation.
5. No new features/APIs: yes.
6. Can apply to stable: yes for current `7.0.y`; older trees may need
   trivial context adjustment.

Exception category: not a device ID/quirk/build/doc exception. It is a
normal stability fix.

## Verification
- [Phase 1] Parsed the supplied commit message and fetched patch mbox;
  confirmed tags, no `Fixes:` tag in patch 2, and the linked message id.
- [Phase 2] Inspected fetched v3 diff; confirmed `arch/powerpc/lib/vmx-
  helper.c` has 8 insertions and 1 deletion, changing only
  `enter_vmx_ops()`.
- [Phase 3] Ran `git log --grep` on current history, `master`, and
  `power-next`; candidate not present locally.
- [Phase 3] Ran `git blame` around `enter_vmx_ops()`; local history
  could not identify true original introduction beyond repository
  history shape.
- [Phase 3] Ran `git show 2ab2d5794f14`; confirmed related PowerPC kexec
  KASAN sanitization commit from 2022.
- [Phase 4] Ran `b4 am` and `b4 am -c`; fetched v3 two-patch series, no
  newer revision reported, patch 2 DKIM valid.
- [Phase 4] Ran `b4 mbox`; confirmed original recipients and patch
  content.
- [Phase 4] Used lore mirror for v2 thread; confirmed Ritesh review,
  Aboorva tested-by/reported hang, and v1-to-v2 narrowing.
- [Phase 5] Searched call sites; confirmed `copypage_power7.S`,
  `memcpy_power7.S`, and `memcmp_64.S` call `enter_vmx_ops()`.
- [Phase 5] Read kexec and assembly code; confirmed kexec path reaches
  `copy_page()` with MMU-off logic and `preempt_count = HARDIRQ_OFFSET`.
- [Phase 6] Checked stable tags `v5.4` through `v7.0`; confirmed
  `enter_vmx_ops()` exists without the annotation and the relevant
  kexec/copy path exists in checked trees.
- [Phase 6] Ran `git apply --check` on current tree for patch 2 and the
  series; clean on current `7.0.y`.
- [Phase 7] Checked `MAINTAINERS`; confirmed PowerPC maintainers and
  that Madhavan Srinivasan is listed for PowerPC.
- [Phase 8] Verified failure mode from review discussion: KASAN-enabled
  kexec hangs after switchover; with both patches applied, kexec
  completes.

This should be backported, ideally together with the companion
`powerpc/kdump: fix KASAN sanitization flag for core_$(BITS).o` patch
for the tested complete KASAN/kexec fix.

**YES**

 arch/powerpc/lib/vmx-helper.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/vmx-helper.c b/arch/powerpc/lib/vmx-helper.c
index 554b248002b4f..57e897b60db86 100644
--- a/arch/powerpc/lib/vmx-helper.c
+++ b/arch/powerpc/lib/vmx-helper.c
@@ -52,7 +52,14 @@ int exit_vmx_usercopy(void)
 }
 EXPORT_SYMBOL(exit_vmx_usercopy);
 
-int enter_vmx_ops(void)
+/*
+ * Can be called from kexec copy_page() path with MMU off. The kexec
+ * code sets preempt_count to HARDIRQ_OFFSET so we return early here.
+ * Since in_interrupt() is always inline, __no_sanitize_address on this
+ * function is sufficient to avoid KASAN shadow memory accesses in real
+ * mode.
+ */
+int __no_sanitize_address enter_vmx_ops(void)
 {
 	if (in_interrupt())
 		return 0;
-- 
2.53.0

