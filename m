Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ADC5B0649;
	Mon, 19 Oct 2026 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418424; cv=none; b=lsYRXoeLcJmPrzNTdgyOvnk4chrouE4KUnvbnqcwshYANboZF3WDlTt3KS/ENQDeJzVcFcHq1bAi0dNzylUmE9mubVYURJhVf7WpPBTup4wf1vzAvhW0MTwQVY4Xnhz0zxMgVpmpAfz+wORksgeSTzdgWrOQmavnWHw2SEqHx1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418424; c=relaxed/simple;
	bh=DH1bph/ZHzpv5mQ+EDceKJUymowJx5xsSPDLBMJMY4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nW537/RUqs5FWV2b8Aldqvp8eF4FGt8K90ehYw3ROSsSwwzlbYHORvFQMrei23gfUT0r+w5wTWnC+AcxOSr7uVu904QPHfHNckv100M2hhx3XtvWo2D+/Uo3q1RroeVsJBeTBWNGTNHuAUGcVa32l/n4ee6kU8EYZbEBZYAKzuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euRUvoFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euRUvoFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463D21F000C9;
	Mon, 19 Oct 2026 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418421;
	bh=HhP0ck/U0ZuxUzCSDns2N0bWfjBU5WBSekm48YEvXjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euRUvoFjq0R3sAUV3ehDp7ayjGlrI7XJ+eK1C5QLHSpVDqmCZ39jK3Kxcdw0707jp
	 O4ax8xoAmO9ZGeYSBGXCoTodlQc3DAfArtVfFIOTpjFb/x96hLcop6ym8nuZu/mjpl
	 DzB2ziB6Er4Zf7nShE9BJXaj4iK6M9ewa+PXiRqSib/513jAROaoFRPxpJx1bo4N+S
	 jq5s4LW2n3MGC2A9bVIQ/tXL53ikN7UwLygZwH0deTNVASDtqFSCWZysvj2YgkvWRK
	 aS8iFrGhtamut/KLBzJIOW56fhrqrsSKcFZsMfqKS8gH6Ll+gmiftnDVic/145l5kH
	 IGJoGZvgHIXJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pu Lehui <pulehui@huawei.com>,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] bpf: Reject callback subprogs invoke tailcall
Date: Mon, 19 Oct 2026 09:48:48 -0400
Message-ID: <20261019135441.1420968-237-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit a41d0c30d764e086c62b049e806fd12df4f4acfc ]

Some JIT compilers, such as x86_64, rely on a register to pass the TCC.
When subprograms of synchronous callback invoke tailcall, C helpers
invoking bpf callback clobber this register, and the corrupted TCC may
bypass the TCC limit, leading to infinite tailcall.

Fix this by rejecting tailcall inside all subprogs of sync callback.
This also cleanly consolidates the existing async and exception callback
checks into a single unified `is_cb` check.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Reported-by: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260716120157.835937-3-pulehui@huaweicloud.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject line**
Record: `[bpf]` `[Reject]` Reject callback subprogs that invoke tailcall
(verifier hardening against TCC clobber / infinite tailcall).

**Step 1.2 — Tags**
Record:
- `Reported-by: Sashiko <sashiko-bot@kernel.org>` — BPF fuzzer found
  this
- `Reported-by: Björn Töpel <bjorn@kernel.org>` — independently reported
  by a BPF JIT developer
- `Acked-by: Eduard Zingerman <eddyz87@gmail.com>` — BPF verifier
  maintainer
- `Link: https://patch.msgid.link/20260716120157.835937-3-
  pulehui@huaweicloud.com` — v3 2/3 of a 3-patch series
- `Signed-off-by: Pu Lehui <pulehui@huawei.com>`
- `Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>`
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present — none on the original commit

**Step 1.3 — Body**
Record:
- **Bug:** Some JITs (x86-64) pass the tail-call counter (TCC) in a
  register. A sync callback is invoked from a C helper, which clobbers
  that register. If a callback subprog then tail-calls, TCC is garbage
  and the limit can be bypassed.
- **Symptom:** Infinite tailcall (CPU hang / soft lockup).
- **Root cause:** Verifier only rejected tailcalls inside exception
  callbacks (`is_exception_cb`), not sync callbacks (`bpf_loop`,
  `bpf_for_each_map_elem`, etc.).
- **Fix:** Reject tailcall on any callback frame via unified `is_cb`.
  Also drop the special async-cb `verifier_bug` in favor of that same
  check.
- **Version:** Landed in v7.3-rc1 (2026-07-16); this checkout is
  v7.3-rc4.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. Explicit security/correctness fix (infinite
tailcall), plus a small consolidation of existing callback checks. Not
cleanup-only.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `kernel/bpf/verifier.c` (`+2 / -6`, 8 lines)
- Function: `check_max_stack_depth_subprog()`
- Scope: single-file surgical verifier change

**Step 2.2 — Code flow**
Record:
1. **Removed** `if (subprog[sidx].is_async_cb && has_tail_call)
   verifier_bug; return -EFAULT`. Async callbacks with a tailcall are no
   longer a verifier BUG; they fall through to the unified reject.
2. **Changed** the stack-walk guard from `is_exception_cb` (“cannot tail
   call within exception cb”) to `is_cb` (“cannot tail call within
   callback”). Any callback on the bpf2bpf stack of a tailcall-reachable
   subprog is rejected with `-EINVAL`.

**Step 2.3 — Bug mechanism**
Record: **Logic / correctness** in the BPF verifier, with a **hang**
failure mode.
- `is_cb` is set in `push_callback_call()` for every helper/kfunc
  callback, including sync ones.
- `has_tail_call` is set in `check_subprogs()` when a subprog contains
  `BPF_FUNC_tail_call`.
- x86-64 JIT (`emit_prologue_tail_call`) uses `%rax` as TCC / TCC
  pointer. Callback entry is a C ABI call, so `%rax` is clobbered.
- Corrupted TCC can skip `MAX_TAIL_CALL_CNT` and loop forever.

**Step 2.4 — Fix quality**
Record: Minimal and obviously correct. Same pattern already used for
exception callbacks (b9ae0c9dd0aca, 2023). Regression risk is **verifier
tightening**: programs that do `callback → subprog → tailcall` now fail
to load. Those programs were dangerous. Series patch 1 is required to
avoid false rejects of unrelated tailcall branches (see Phase 3). No
API/feature additions.

---

## Phase 3: Git history

**Step 3.1 — Blame**
Record:
- `is_cb` field: 406a6fa44bfbc (2023-12, bitfield conversion);
  assignment in `push_callback_call()`: ab5cfac139ab85 (2023-11)
- Exception-only tailcall reject: b9ae0c9dd0aca (2023-09, “bpf: Add
  support for custom exception callbacks”)
- Async `has_tail_call` verifier_bug: 7ddc80a476c2d (2021-07, “Teach
  stack depth check about async callbacks”)
- `has_tail_call` tracking: 7f6e4312e15a5 (2020)
- `bpf_loop`: e6f2dd0f80674 (2021-11); CAP_BPF: 5679ff2f138f7 (2022-08)
- x86 TCC-in-register: ebf7d1f508a7 (cited by series patch 1)

The hole (sync callbacks + tailcall) has been present for years; this
tree is far newer.

**Step 3.2 — Fixes: tag**
Record: None on this commit. Related: series patch 1 has `Fixes:
ebf7d1f508a7`. GitHub CI suggested `Fixes: b9ae0c9dd0ac` for this patch
(that commit only covered exception callbacks).

**Step 3.3 — Related file history**
Record: v3 series “Fixes for tailcall with subprog and callback”:
1. `3513ea9dab6c1` bpf: Sync tail_call_reachable with callee state on
   entry
2. `a41d0c30d764e` **this commit**
3. `42bfd21a8b701` selftests/bpf: Add testcases for callback with
   tailcall

Follow-up already in this tree: `266aa4ad0b2e8` (“Reject tail calls
directly from callback frames”) — extra reject in `check_helper_call()`
to avoid a verifier WARN; it comments that stack-depth validation
already rejects this.

**Step 3.4 — Author**
Record: Pu Lehui is a regular BPF contributor (JIT/verifier). Acked and
applied by Eduard Zingerman (verifier maintainer).

**Step 3.5 — Prerequisites**
Record: **Not fully standalone.** Patch 1 must come first. Without it,
`tail_call_reachable` leaks across branches, so patch 2 can reject valid
programs that mix a tailcall subprog with a no-tailcall callback
(`tailcall_callback_2` selftest). Both 3513ea9dab6c1 and 42bfd21a8b701
**are ancestors of this HEAD**. `is_cb` is present. Can apply on this
tree (already applied).

---

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
Record:
- Lore: https://patch.msgid.link/20260716120157.835937-3-
  pulehui@huaweicloud.com
- Cover: https://patch.msgid.link/20260716120157.835937-1-
  pulehui@huaweicloud.com
- Revisions: v1 (2 patches, 2026-07-11) → v2 (2026-07-14) → **v3 (3
  patches, 2026-07-16)** applied
- v3 added patch 1 after Sashiko found the `tail_call_reachable` leak
- Applied to **bpf-next** (not bpf fixes) by Eduard Zingerman on
  2026-07-17
- Sashiko AI review flagged removing the async `verifier_bug`. Author
  replied: async/exception tailcalls are meaningless (ctx not passed);
  sync callbacks are subprogs so `is_cb` fires; direct tailcall in a
  callback is already rejected earlier in `check_helper_call` via
  unknown R0 vs callback return range
- No NAKs. Eduard acked. Patchwork applied v3 as latest.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: bpf@vger, Alexei, Andrii, Daniel Borkmann, Martin KaFai Lau,
Kartikeya, Yonghong, Song Liu, Jiri Olsa, Björn Töpel, Eduard. Right
maintainers.

**Step 4.3 — Bug report**
Record: Two independent reports:
- Sashiko fuzzer
- Björn Töpel, in review of RISC-V JIT bpf2bpf+tailcall: callback
  entered from C ABI with clobbered TCC, then subprog tailcall. He
  confirmed the verifier accepted `callback → subprog → tailcall`.

**Step 4.4 — Series**
Record: 3 patches; 1+2 are kernel, 3 is selftests. Patch 1 is a
correctness prerequisite for patch 2. Both are in this tree.

**Step 4.5 — Stable list**
Record: lore.kernel.org/stable search returned 403. UNVERIFIED whether
it was discussed on stable@. No `Cc: stable` on the patch. Submitted to
bpf-next during the 7.2 cycle, so it was aimed at 7.3, not 7.2-rc.

---

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: `check_max_stack_depth_subprog()` only.

**Step 5.2 — Callers**
Record: `check_max_stack_depth()` → `do_check` finalization
(`kernel/bpf/verifier.c` ~21334). Runs on every successful
`BPF_PROG_LOAD` before JIT. Called for main (`i==0`) and every
`is_async_cb` subprog.

**Step 5.3 — Callees**
Record: Walks insns, `bpf_find_subprog()`, `bpf_pseudo_call` /
`bpf_pseudo_func`. Sets `tail_call_reachable` from callee
`has_tail_call`, then marks `tail_call_reachable` on the frame stack for
the JIT.

**Step 5.4 — Reachability**
Record: Userspace `BPF_PROG_LOAD`. Typical trigger: TC/XDP/cgroup
program with `bpf_loop` (or similar) whose callback calls a subprog that
tail-calls. `bpf_loop` is CAP_BPF-gated (`kernel/bpf/helpers.c`). Not
fully unprivileged; reachable by any CAP_BPF loader (Cilium, systemd,
containers with CAP_BPF). **Yes, reachable from userspace.**

**Step 5.5 — Similar patterns**
Record: Same `is_cb` walk used for:
- BPF_LD_ABS/IND in callbacks (`e7d28823c6621`)
- `bpf_throw` from callbacks
Later `266aa4ad0b2e8` added a matching reject in `check_helper_call()`.

---

## Phase 6: This tree

**Step 6.1 — Does the buggy code exist?**
Record: **Yes, in this lineage, and the fix is already merged.**
- Tree: **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`)
- `git merge-base --is-ancestor a41d0c30d764e HEAD` → true
- `git describe --contains a41d0c30d764e` → `v7.3-rc1~134^2~141^2~1`
- Not in v7.2 (`merge-base --is-ancestor` failed)
- Before this commit, `check_max_stack_depth_subprog()` only tested
  `is_exception_cb`. Sync callbacks were unprotected. That is the 7.3
  code this commit fixed.
- Reverse `git apply --check` of the commit succeeds: working tree
  already has the after-state.

**Step 6.2 — Backport difficulty**
Record: **Already applied** on this tree. `is_cb`,
`check_max_stack_depth_subprog()`, and series patch 1 are present. Would
apply cleanly to the pre-commit parent; no extra rework for 7.3.

**Step 6.3 — Related fixes already here**
Record: Series 1/3 and 3/3, plus follow-up `266aa4ad0b2e8`. No alternate
fix that would make this redundant; the follow-up depends on this
diagnostic.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: **BPF verifier** (`kernel/bpf/verifier.c`). **IMPORTANT** (core
BPF safety; all BPF loaders). Not mm/scheduler, but verifier bugs are
security-relevant.

**Step 7.2**
Record: Highly active in 7.3. This is a mature path
(`check_max_stack_depth` has existed for years), not new infrastructure.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Config-specific / BPF users. Needs JIT that passes TCC in a
register (x86-64 is the cited case; Björn noted RISC-V too). Sync
callbacks (`bpf_loop`, for-each helpers) plus tailcall.

**Step 8.2 — Trigger**
Record: Load and run a BPF program: callback subprog tail-calls. Timing-
independent. Needs CAP_BPF (and usually CAP_NET_ADMIN/PERFMON for the
program type). Confirmed accepted by the old verifier.

**Step 8.3 — Failure mode**
Record: **Infinite tailcall → CPU hang / soft lockup.** Severity
**HIGH** (DoS / hang). Not a verified memory-corruption UAF, but a real
stability/security issue.

**Step 8.4 — Risk-benefit**
Record:
- **Benefit:** Stops a hang/DoS in a common BPF pattern (loop callback +
  tailcall) on x86-64.
- **Risk:** Low. 8-line verifier reject. Can break previously accepted
  (unsafe) programs. False-positive risk is handled by patch 1, already
  in this tree.
- **Ratio:** High benefit / low risk.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For backporting / keeping this in this tree:
- Real hang: TCC clobber → infinite tailcall (x86-64 JIT, independently
  described by Töpel)
- Two reporters (Sashiko + Björn Töpel)
- Verifier maintainer Acked-by and applied
- 8-line, obviously correct extension of an existing guard
- Selftests in 42bfd21a8b701
- Call path is `BPF_PROG_LOAD` (userspace)
- This tree has the code, patch 1, and `is_cb`

Against:
- Sent to bpf-next, not bpf fixes; no `Fixes:` / `Cc: stable`
- Tightens verifier (rejects previously valid programs)
- Series member 2/3; needs patch 1 (present here)
- Original commit already in v7.3-rc1, so this checkout already contains
  the fix

Unresolved: whether anyone asked for it on stable@ (lore/stable 403).

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — Acked, applied, selftests,
   follow-up confirms the check
2. Real bug affecting users? **PASS** — accepted programs can hang a CPU
3. Important (crash/security/corruption/deadlock)? **PASS** — hang/DoS;
   HIGH
4. Small and contained? **PASS** — 8 lines, one function
5. No new features/APIs? **PASS** — verifier reject only
6. Can apply to this tree? **PASS** — already in v7.3-rc1; prerequisites
   present

**Step 9.3 — Exceptions**
Record: None (not a device ID / quirk / DT / build / docs patch).
Qualifies as a normal important bugfix.

**Step 9.4 — Decision**
This tree is **v7.3-rc4**. The bug is in this series’ BPF verifier/JIT,
the fix is small and correct, and the only dependency (patch 1) is
already here. Already merged in 7.3-rc1 is not a reason to treat it as
unsuitable; it is evidence it belongs in this tree. Technical merit
supports including it.

---

### What the commit solves, and why it matters here

x86-64 (and similar JITs) pass the tail-call counter in a register. Sync
BPF callbacks run from C helpers, which clobber that register. If a
callback’s subprogram tail-calls, the counter can be garbage, the
33-call limit is skipped, and the CPU can tail-call forever.

The verifier only blocked that for exception callbacks. This patch uses
the existing `is_cb` bit so **all** callbacks are rejected. That is a
real hang/DoS for CAP_BPF program loaders on this kernel.

It meets stable rules: obviously correct, important, 8 lines, no new
API. Patch 1 of the same series is already in this tree, so the false-
reject leak is not an issue here.

### Risk vs benefit

Benefit is high (prevents hang). Risk is low (reject unsafe programs).
The only behavioral change is failing `BPF_PROG_LOAD` for
callback+tailcall, which is the intended safety net.

### Concerns

- Needs series patch 1 (`3513ea9dab6c1`) — **already in this tree**
- Selftests (`42bfd21a8b701`) are nice-to-have, not required for the
  kernel fix — **already in this tree**
- Follow-up `266aa4ad0b2e8` is a separate WARN-avoidance fix, not a
  prerequisite for this one

---

### Verification

- **[Phase 1]** Parsed tags: Sashiko + Björn Töpel Reported-by; Eduard
  Acked-by/SOB; Link msgid `835937-3` (v3 2/3); no Fixes/Cc-stable
- **[Phase 1]** `git show a41d0c30d764e --format=full`: infinite
  tailcall from TCC clobber; reject via `is_cb`
- **[Phase 2]** Diff: `kernel/bpf/verifier.c` +2/-6 in
  `check_max_stack_depth_subprog()`; `is_exception_cb` → `is_cb`; remove
  async `verifier_bug`
- **[Phase 2]** Current code at 5480–5482 already has `if
  (subprog[tmp].is_cb)` / `"cannot tail call within callback"`
- **[Phase 3]** `git describe HEAD` / `make kernelversion`:
  **v7.3-rc4**, 7.3.0-rc4
- **[Phase 3]** `git merge-base --is-ancestor a41d0c30d764e HEAD`: yes
  (already in this tree, v7.3-rc1)
- **[Phase 3]** `git merge-base --is-ancestor a41d0c30d764e v7.2`: no
  (7.2 does not have it; not used as a split verdict)
- **[Phase 3]** Parent `3513ea9dab6c1` is series 1/3; `git merge-base
  --is-ancestor 3513ea9dab6c1 HEAD`: yes
- **[Phase 3]** Blame: exception check b9ae0c9dd0aca (2023); async bug
  7ddc80a476c2d (2021); `is_cb` 406a6fa44bfbc / ab5cfac139ab85 (2023)
- **[Phase 3]** Follow-up `266aa4ad0b2e8` already in tree; extra reject
  in `check_helper_call()` at 11320
- **[Phase 4]** `b4 dig -c a41d0c30d764e`: lore msgid
  20260716120157.835937-3
- **[Phase 4]** `b4 dig -a`: v1→v2→v3; v3 applied; v3 added patch 1
  after Sashiko
- **[Phase 4]** `b4 dig -w`: bpf maintainers CC’d (Alexei, Eduard,
  Daniel, Andrii, Björn, Kartikeya)
- **[Phase 4]** mbox: Eduard applied to bpf-next; Sashiko AI concern
  answered by author; no NAK
- **[Phase 4]** WebSearch: Töpel RISC-V thread confirms verifier
  accepted callback→subprog→tailcall
- **[Phase 4]** lore.kernel.org/stable: **UNVERIFIED** (403)
- **[Phase 5]** `check_max_stack_depth()` at 5552 calls this; verifier
  finalize at 21334 on every successful load
- **[Phase 5]** `push_callback_call()` sets `is_cb` at 9847;
  `check_subprogs()` sets `has_tail_call` at 3031
- **[Phase 5]** x86 JIT `emit_prologue_tail_call` uses `%rax` for TCC
  (arch/x86/net/bpf_jit_comp.c:500–526)
- **[Phase 5]** `bpf_loop` behind CAP_BPF (`kernel/bpf/helpers.c:2124`)
- **[Phase 5]** Selftest
  `tools/testing/selftests/bpf/progs/tailcall_callback.c` expects
  `"cannot tail call within callback"`
- **[Phase 6]** Reverse `git apply --check` of this commit: success (fix
  already present)
- **[Phase 8]** Failure mode: infinite tailcall hang, severity HIGH;
  trigger CAP_BPF BPF_PROG_LOAD
- **UNVERIFIED:** Stable mailing-list discussion (HTTP 403)

The local tree is v7.3-rc4. The buggy verifier path exists in this
series, the 8-line reject is a real hang fix, prerequisites are present,
and the change belongs in this tree.

**YES**

 kernel/bpf/verifier.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b89a5d717e422..5cc3e9a990ef7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6808,10 +6808,6 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 		if (verifier_bug_if(sidx < 0, env, "callee not found at insn %d", next_insn))
 			return -EFAULT;
 		if (subprog[sidx].is_async_cb) {
-			if (subprog[sidx].has_tail_call) {
-				verifier_bug(env, "subprog has tail_call and async cb");
-				return -EFAULT;
-			}
 			/* async callbacks don't increase bpf prog stack size unless called directly */
 			if (!bpf_pseudo_call(insn + i))
 				continue;
@@ -6852,8 +6848,8 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 	 */
 	if (tail_call_reachable)
 		for (tmp = idx; tmp >= 0; tmp = dinfo[tmp].caller) {
-			if (subprog[tmp].is_exception_cb) {
-				verbose(env, "cannot tail call within exception cb\n");
+			if (subprog[tmp].is_cb) {
+				verbose(env, "cannot tail call within callback\n");
 				return -EINVAL;
 			}
 			subprog[tmp].tail_call_reachable = true;
-- 
2.53.0

