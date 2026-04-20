Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3774DC543;
	Mon, 20 Apr 2026 13:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692031; cv=none; b=h+/fs678hinqhy7woqnoHdOhL3QIc79serabX4u9R22f8A8xu/4ZWbCh8fWmBBHWJ9oWcV1V9MiyR1+iFCifufLyEXNBUKFikgdQwqEiTybtpxKGrncc6j6BeUFePXVQvuAiyl8eEUkH1vU6ZUiky5y3NaMkItRxxwGE681MxiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692031; c=relaxed/simple;
	bh=bfM8runhSQsGmk9HGK5s+jLFhQeLx7mAZbta7McleiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+JfwOEWKirS4nb1/2DKI/7s+9Roz5/fZdO8IJPLWi5nxfyt1xJv7EJ2Y8enEtr8C9L9oXACZOUzewXk2wr7sG5/+pm1Zu+q9vPyr4j4sjO8M4JXHweBriMeWj2zsVVS3fJRcY86GLwIuCXT2jgRQKmMW0KHGPNx6eFa/vCoxA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjG8Ge9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjG8Ge9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB51C2BCB4;
	Mon, 20 Apr 2026 13:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692031;
	bh=bfM8runhSQsGmk9HGK5s+jLFhQeLx7mAZbta7McleiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjG8Ge9i8VY0QCt5zfWfazNyAUe4XvUA2GzmQd1/ahgqEaVlSqO9TC+SBm9t2TZVw
	 G5KGG61hM1uGIhgZ+Ic4Uv4JlvSABOrY/bVnDsqd2AzHz3l3D3RATPErz0jrHoYTMJ
	 yHmUbRhgEZb7soegHkSczzfQUCdE2T/N//gvIbvWSqnO9EphwK6ymSlR7sXQk+9Srr
	 LyOAbdA+hoTIW9qDi6IlnZqwI3vG0ELlK06OrXBGBn5+KMiyCkzirn+MDlFztIYz2i
	 3pe4tTjEFnVIuukSCZvIG0cPvLmAyAOXQhU4j8y1vlfzcoGy+/SfEfWzgZ08w+wD5t
	 UO1AcwFhAe0/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>,
	pbonzini@redhat.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.1] KVM: x86: Check for injected exceptions before queuing a debug exception
Date: Mon, 20 Apr 2026 09:22:08 -0400
Message-ID: <20260420132314.1023554-334-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yosry Ahmed <yosry@kernel.org>

[ Upstream commit e907b4e72488f1df878e7e8acf88d23e49cb3ca7 ]

On KVM_SET_GUEST_DEBUG, if a #DB or #BP is injected with
KVM_GUESTDBG_INJECT_DB or KVM_GUESTDBG_INJECT_BP, KVM fails with -EBUSY
if there is an existing pending exception. This was introduced in
commit 4f926bf29186 ("KVM: x86: Polish exception injection via
KVM_SET_GUEST_DEBUG") to avoid a warning in kvm_queue_exception(),
presumably to avoid overriding a pending exception.

This added another (arguably nice) property, if there's a pending
exception, KVM_SET_GUEST_DEBUG cannot cause a #DF or triple fault.
However, if an exception is injected, KVM_SET_GUEST_DEBUG will cause
a #DF or triple fault in the guest, as kvm_multiple_exception() combines
them.

Check for both pending and injected exceptions for
KVM_GUESTDBG_INJECT_DB and KVM_GUESTDBG_INJECT_BP, to avoid accidentally
injecting a #DB or triple fault.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
base-commit: a68a4bbc5b9ce5b722473399f05cb05217abaee8
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have sufficient information to complete my analysis. Let me write up
the findings.

# Analysis: KVM x86 - Check for injected exceptions before queuing debug
exception

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: SUBJECT LINE**
Record: Subsystem = "KVM: x86"; Action verb = "Check for" (implicit fix
- adds missing check); Summary = adds check for injected exceptions (not
just pending) before queuing #DB/#BP in KVM_SET_GUEST_DEBUG to prevent
accidental #DF/triple fault.

**Step 1.2: TAGS**
Record:
- Signed-off-by: Yosry Ahmed (author) and Sean Christopherson (KVM x86
  maintainer, committer)
- base-commit: a68a4bbc5b9c
- NO Fixes: tag (expected - this is candidate review)
- NO Reported-by: (no syzbot tag directly on this patch, though cover
  letter referenced syzkaller repro for the series)
- NO Reviewed-by/Tested-by/Acked-by on the final committed patch
- NO Cc: stable

**Step 1.3: COMMIT BODY**
Record:
- Bug description: `kvm_arch_vcpu_ioctl_set_guest_debug()` only checks
  `kvm_is_exception_pending()` before queuing a #DB/#BP; if an exception
  is currently *injected* (not pending), the check passes and
  `kvm_queue_exception()` combines the two via
  `kvm_multiple_exception()`, escalating to #DF or triple fault.
- Failure mode: Accidental #DF (double fault) or triple fault in the
  guest.
- Author mentions introducing commit 4f926bf29186 from 2009.

**Step 1.4: HIDDEN BUG FIX?**
Record: Subject uses "Check for" rather than "fix", but body explicitly
describes a bug and the mechanism. This IS a bug fix.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY**
Record: Single file `arch/x86/kvm/x86.c`, 1 line added, 1 line removed.
Function: `kvm_arch_vcpu_ioctl_set_guest_debug`. Surgical single-file
fix.

**Step 2.2: CODE FLOW CHANGE**
Record: Before: only returned -EBUSY if `kvm_is_exception_pending()`
(which checks `exception.pending`, `exception_vmexit.pending`,
`KVM_REQ_TRIPLE_FAULT`). After: also returns -EBUSY if
`vcpu->arch.exception.injected`.

**Step 2.3: BUG MECHANISM**
Record: Category (g) Logic/correctness fix - missing condition in
return-value check. Looking at `kvm_multiple_exception()` (x86.c:837+),
if another exception is already present (injected or pending), it either
synthesizes #DF (for contributory+contributory or PF+non-benign), or
escalates to triple fault if previous was DF. The fix prevents entering
`kvm_queue_exception` when injection is in progress.

**Step 2.4: FIX QUALITY**
Record: Obviously correct; surgical one-line addition of a boolean
condition to existing guard. No risk of deadlock/regression - it only
adds another case that returns -EBUSY, which is existing ioctl behavior
that userspace must already tolerate. Aligns with architectural
behavior: you cannot queue a new exception while one is being delivered.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME**
Record: Checked line; the code has been structured this way since
introduction in 2009.

**Step 3.2: ORIGINAL BUGGY COMMIT**
Record: Bug introduced in commit `4f926bf291863` ("KVM: x86: Polish
exception injection via KVM_SET_GUEST_DEBUG") by Jan Kiszka, Oct 2009.
`git describe --contains` = `v2.6.33-rc1~387^2~10`. This means the bug
exists in every active stable tree (5.4, 5.10, 5.15, 6.1, 6.6, 6.12,
etc.).

**Step 3.3: FILE HISTORY**
Record: `arch/x86/kvm/x86.c` has had 479 commits since v6.6. The
`kvm_is_exception_pending()` helper was introduced in commit
`7709aba8f7161` (v6.1-rc1). For stable trees >= v6.1, the fix applies
cleanly. For v5.15 and v5.10, an equivalent inline check against
`vcpu->arch.exception.pending || vcpu->arch.exception.injected` would be
needed (trivial adaptation).

**Step 3.4: AUTHOR CONTEXT**
Record: Yosry Ahmed is a regular KVM contributor (multiple nSVM/SVM
fixes merged, plus memory management). Sean Christopherson applied the
patch - he is the KVM x86 maintainer. Strong pedigree.

**Step 3.5: DEPENDENCIES**
Record: The commit was patch 3/3 of a series. Sean explicitly confirmed
on the list: "So you'll apply patch 3 as-is, drop patch 2, and
(potentially) take patch 1 and build another series on top of it?" --
"Yeah, that's where I'm trending." Patch 3 is explicitly standalone.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: ORIGINAL DISCUSSION**
Record: `b4 dig -c e907b4e72488f` found the patch at
https://lore.kernel.org/all/20260227011306.3111731-4-yosry@kernel.org/.
Single revision (v1). Sean Christopherson reviewed explicitly and said:
"First off, this patch looks good irrespective of nested crud.
Disallowing injection of #DB/#BP while there's already an injected
exception aligns with architectural behavior; KVM needs to finish
delivering the exception and thus 'complete' the instruction before
queueing a new exception." This is a strong endorsement from the
subsystem maintainer.

**Step 4.2: REVIEWERS**
Record: `b4 dig -w` showed recipients: Sean Christopherson (KVM x86
maintainer), Paolo Bonzini (KVM maintainer), kvm@ and linux-kernel@
mailing lists. Appropriate review coverage.

**Step 4.3: BUG REPORT**
Record: Cover letter references a syzkaller reproducer that triggers
nested_run_pending WARN; the series was motivated by syzkaller findings.
Patch 3 addresses an architectural correctness issue that the author
noticed while investigating, more than a direct syzkaller report.

**Step 4.4: SERIES CONTEXT**
Record: Part of "[PATCH 0/3] KVM: x86: Fix incorrect handling of triple
faults". Sean confirmed he'd apply patch 3 standalone and defer patches
1-2.

**Step 4.5: STABLE DISCUSSION**
Record: No explicit stable nomination was made by the author or reviewer
on the mailing list.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `kvm_arch_vcpu_ioctl_set_guest_debug` is the only modified
function.

**Step 5.2: CALLERS**
Record: `kvm_arch_vcpu_ioctl_set_guest_debug` is the top-level ioctl
handler for `KVM_SET_GUEST_DEBUG` - invoked directly from userspace
through the KVM ioctl interface.

**Step 5.3: CALLEES**
Record: Relevant callees: `kvm_is_exception_pending()` (x86.h:198-203,
checks pending + exception_vmexit.pending + KVM_REQ_TRIPLE_FAULT),
`kvm_queue_exception()` → `kvm_multiple_exception()` (x86.c:837, which
is the function that synthesizes #DF or triple fault).

**Step 5.4: CALL CHAIN / REACHABILITY**
Record: Reachable directly from userspace ioctl `KVM_SET_GUEST_DEBUG`.
Any VMM/debugger that uses this ioctl with `KVM_GUESTDBG_INJECT_DB` or
`KVM_GUESTDBG_INJECT_BP` can hit this code path.

**Step 5.5: SIMILAR PATTERNS**
Record: Grep shows `vmx/vmx.c:6130` already combines both checks:
`(kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected)`. The
fix makes `kvm_arch_vcpu_ioctl_set_guest_debug` consistent with this
existing VMX pattern.

## PHASE 6: CROSS-REFERENCING STABLE TREE

**Step 6.1: CODE EXISTS IN STABLE?**
Record: The buggy code exists in ALL stable trees back to v2.6.33
(2010). The specific `kvm_is_exception_pending()` helper was added in
v6.1 (Oct 2022). For trees v6.1+, direct apply. For v5.15.y, v5.10.y,
the equivalent fix would use `vcpu->arch.exception.pending ||
vcpu->arch.exception.injected` directly.

**Step 6.2: BACKPORT COMPLICATIONS**
Record: For v6.1, v6.6, v6.12: clean apply expected. For v5.15 and
earlier: need to replace `kvm_is_exception_pending(vcpu)` with raw field
check (`vcpu->arch.exception.pending`) — trivial adaptation.

**Step 6.3: RELATED FIXES IN STABLE?**
Record: No prior fix for this specific issue in stable (checked mainline
history - single commit e907b4e72488f).

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: SUBSYSTEM**
Record: `arch/x86/kvm/` - KVM (Kernel-based Virtual Machine) x86
implementation. Criticality: IMPORTANT. KVM is widely used in
cloud/server workloads and affects any distro running VMs.

**Step 7.2: ACTIVITY**
Record: 479 commits since v6.6 in x86.c alone; very active subsystem.
Bug is not recent though - it's a 15-year-old latent bug.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: AFFECTED POPULATION**
Record: Users of KVM_SET_GUEST_DEBUG ioctl with INJECT_DB/BP - primarily
debuggers (gdb stub), QEMU, and other VMMs that perform guest
introspection. Not all VMMs use this, but it's common enough.

**Step 8.2: TRIGGER CONDITIONS**
Record: Requires (1) a VMM/debugger using KVM_SET_GUEST_DEBUG with
KVM_GUESTDBG_INJECT_DB or KVM_GUESTDBG_INJECT_BP, AND (2) timing where
the target vCPU has an already-injected exception at that moment. Not an
unprivileged trigger (VMM-level access needed).

**Step 8.3: FAILURE MODE**
Record: Accidental injection of #DF or triple fault into the guest -
causes guest kernel crash / reset. Severity: MEDIUM - guest-only impact
(no host compromise, no security escalation, no host-level crash).

**Step 8.4: RISK-BENEFIT**
Record: BENEFIT: medium (prevents unexpected guest crashes in a
debugger/VMM corner case, matches architectural behavior). RISK: very
low - 1-line addition of a condition to an existing -EBUSY return path
that userspace must already handle. Ratio strongly favors backporting.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**
FOR backporting:
- Minimal, surgical 1-line fix
- Explicitly endorsed by KVM x86 maintainer Sean Christopherson ("patch
  looks good irrespective of nested crud")
- Fixes real bug present since 2009 in every active stable tree
- Matches architectural behavior and makes code consistent with
  vmx.c:6130
- Fix quality is obvious by reading the code
- Low regression risk (only expands an existing -EBUSY guard)
- Author/committer are experienced KVM contributors

AGAINST backporting:
- No explicit stable tag/nomination on the list
- Impact is guest-only (not host)
- Requires specific user action via KVM_SET_GUEST_DEBUG ioctl
- For pre-v6.1 trees, minor adaptation is needed (inline the helper's
  check)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? YES - reviewed by maintainer, trivial
   change, matches existing pattern.
2. Fixes a real bug? YES - guest-side #DF or triple fault.
3. Important issue? MEDIUM - guest kernel crash but not host-side.
4. Small and contained? YES - 1 line.
5. No new features or APIs? YES.
6. Applies cleanly? YES for v6.1+; trivial adaptation for v5.15 and
   earlier.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Does not fall into a trivial exception category (not a device
ID, not a quirk, not DT, not docs). But it IS a small, surgical bug fix
that fits the general stable criteria.

**Step 9.4: DECISION**
This is a small, surgical, well-reviewed fix for a long-standing latent
bug that can cause guest crashes through a KVM ioctl path. The subsystem
maintainer explicitly endorsed the patch as architecturally correct.
Regression risk is minimal (just an extra -EBUSY condition). The bug has
been present in every stable tree for 15+ years.

## Verification

- [Phase 1] Parsed tags: only SOB tags; no Fixes:/Reported-by:/Cc:stable
  as expected for candidate patch.
- [Phase 2] Diff analysis: confirmed 1 line added / 1 removed in
  `kvm_arch_vcpu_ioctl_set_guest_debug()`; verified the change adds `||
  vcpu->arch.exception.injected` to existing condition.
- [Phase 2] `kvm_multiple_exception()` in x86.c:837-898 confirmed: when
  `exception.injected=true`, code goes into #DF/triple-fault synthesis
  path.
- [Phase 3] `git show 4f926bf29186` confirmed bug introduced by Jan
  Kiszka in Oct 2009.
- [Phase 3] `git describe --contains 4f926bf29186` =
  `v2.6.33-rc1~387^2~10` → bug present in all stable trees.
- [Phase 3] `git describe --contains e907b4e72488f` =
  `next-20260313~...` → fix is in linux-next, not yet in a released tag.
- [Phase 3] `git describe --contains 7709aba8f7161` =
  `v6.1-rc1~107^2~19` → `kvm_is_exception_pending()` helper exists only
  in v6.1+.
- [Phase 4] `b4 dig -c e907b4e72488f` found original submission at
  https://lore.kernel.org/all/20260227011306.3111731-4-yosry@kernel.org/
- [Phase 4] `b4 dig -a` confirmed single v1 revision; no v2/v3 needed.
- [Phase 4] `b4 dig -w` confirmed recipients included Sean
  Christopherson and Paolo Bonzini.
- [Phase 4] Read thread mbox: Sean explicitly said "this patch looks
  good irrespective of nested crud" and confirmed he would apply patch 3
  as-is, dropping patches 1-2 for later work.
- [Phase 4] Cover letter references syzkaller reproducer (manually
  modified) but for the series as a whole; patch 3 itself is
  architectural correctness.
- [Phase 5] `grep kvm_is_exception_pending` confirmed vmx.c:6130 uses
  exactly the same combined check pattern - fix makes x86.c consistent.
- [Phase 6] File exists in all stable trees; helper
  `kvm_is_exception_pending()` only in v6.1+, minor adaptation needed
  for v5.15/v5.10.
- [Phase 7] `git log --pretty | rg "^Yosry"` confirmed Yosry Ahmed is
  regular KVM contributor.
- [Phase 8] Reachability: KVM_SET_GUEST_DEBUG is the direct ioctl
  handler - reachable from userspace VMMs/debuggers.
- UNVERIFIED: Whether any real-world VMM has actually hit this bug in
  production (no specific user report in the patch).
- UNVERIFIED: Exact backport complexity for v5.15.y/v5.10.y - not tested
  but a trivial inline expansion.

The fix is small, surgical, maintainer-endorsed as architecturally
correct, applies to a 15-year-old latent bug, is reachable from
userspace VMMs, and has very low regression risk. It meets stable kernel
criteria.

**YES**

 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd1c4a36b5936..58f7247814e06 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12529,7 +12529,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
 		r = -EBUSY;
-		if (kvm_is_exception_pending(vcpu))
+		if (kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected)
 			goto out;
 		if (dbg->control & KVM_GUESTDBG_INJECT_DB)
 			kvm_queue_exception(vcpu, DB_VECTOR);
-- 
2.53.0

