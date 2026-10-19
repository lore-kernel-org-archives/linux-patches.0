Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EB2569811;
	Mon, 19 Oct 2026 13:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418264; cv=none; b=bXjv7P2G2CW/o/PcS6uvPBDrYCJEQajkJw6PpY2IAMaoSK+r1xqy/U7QPoeNSBAewv/qPt0sB6T9Gkct0agjm7py5Zuf/vAcTKzL4/10QddDxn6B74POEy9RuAI6/hECVxRO6ohMwzov4lLt17FTl++JX9uU5OPyOuGyPTJG2fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418264; c=relaxed/simple;
	bh=Suv7eg1aJ7Tifx1fwLy70ni9uREKsxIaRnxp5RBSXq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eR84bPJOPUaDTR5B+0Tpe5MuIh0uz2Ud3KoRYEHvsjnUUgtILkE9KMcGPqezhY8J7V3zFIN3pdgOmDcUzNWED+EzMmWctG007Gq9viq4nXsCwajbZdWBp5FjIcNAnii0JYgSqT1yTC14q3D2Et7LFt+Fv/cg10beUEUd1EW/XQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEy3hyaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEy3hyaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEEE1F000C4;
	Mon, 19 Oct 2026 13:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418262;
	bh=7hnDKs4oRavKgsNuGuZnZCAYPrJeLUboc9yjYXsOnO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEy3hyaB6qvGmREb54C5UY0qjWT2KWjP1pkXn/62caHY4jCv0hci49MXw14R5q6Rm
	 YG3eBp5vFxw1wq3W9jAEVy73LtGsLGZ6Bf2Bip2iuwQS+FtDWjfFrl1gMkYYOJelJO
	 kyCh3rMWvIw6YtSplrE9Fg6z01X6m5YG8w0vx2AFEp4hQjqqwQ86BrM95YvTMyJtmp
	 8Tg1c8KISo45xZ7tIOZlHd+aDAYWu85oa34qJ3wExwGIAdgQ6R4SvcA2iiv6RdgAll
	 lfMkQGy9GZzzGvVUsrlCpF4MewUg5bZ9sKhmU/FGTPKuA/pq/K1mNM3jdUJh0sFggc
	 4y0KKxbfOt8ZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>,
	dwmw2@infradead.org,
	pbonzini@redhat.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] KVM: x86/xen: Prevent runstate times from becoming negative
Date: Mon, 19 Oct 2026 09:46:58 -0400
Message-ID: <20261019135441.1420968-127-sashal@kernel.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit 36a85200643e62d20a91f0bc1a811187b59f7762 ]

When kvm_xen_update_runstate() is invoked to set a vCPU's runstate, the
time spent in the previous runstate is accounted. This is based on the
delta between the current KVM clock time, and the previous value stored
in vcpu->arch.xen.runstate_entry_time.

If the KVM clock goes backwards, that delta will be negative. Or, since
it's an unsigned 64-bit integer, very *large*. Linux guests deal with
that particularly badly, reporting 100% steal time for ever more (well,
for *centuries* at least, until the delta has been consumed).

So when a negative delta is detected, just refrain from updating the
runstate times until the KVM clock catches up with runstate_entry_time
again.

Also clamp steal_ns to delta_ns to prevent steal time from exceeding
the total elapsed time, and handle negative steal_ns (which can happen
if run_delay goes backwards across a scheduler update).

The userspace APIs for setting the runstate times do not allow them to
be set past the current KVM clock, but userspace can still adjust the
KVM clock *after* setting the runstate times, which would cause this
situation to occur.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://patch.msgid.link/20260728144954.355376-21-dwmw2@infradead.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`pending-6.18`). The buggy unsigned
runstate math is in this checkout; the candidate fix is not. This is a
small, self-contained guest steal-time wraparound fix and should be
backported here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `KVM: x86/xen`
- Action verb: **Prevent**
- Claimed intent: stop Xen runstate accounting from wrapping when
  kvmclock or steal time goes backwards

Record: [KVM x86/xen] [prevent] [runstate times wrapping to huge
unsigned values / 100% guest steal]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Fixes: none (expected for this review pipeline)
- Reported-by: none
- Tested-by: none
- Reviewed-by: Paul Durrant `<paul@xen.org>` (Xen maintainer)
- Acked-by: none
- Link: `https://patch.msgid.link/20260728144954.355376-21-
  dwmw2@infradead.org`
- Cc: stable: none (expected)
- Signed-off-by: David Woodhouse `<dwmw@amazon.co.uk>` (author; KVM Xen
  author)
- Signed-off-by: Sean Christopherson `<seanjc@google.com>` (KVM x86
  maintainer; applied)
- Ignore: any pipeline “Upstream commit” / Sasha Levin SOB if present

Record: Reviewed by Xen maintainer, applied by KVM x86 maintainer. Link
shows **v7 20/36** of “Cleaning up the KVM clock mess”. No syzbot, no
user Reported-by.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Bug: `kvm_xen_update_runstate()` accounts time as `now -
runstate_entry_time` in a `u64`. If kvmclock goes backwards, that delta
wraps to ~2^64 ns. Linux guests then show **100% steal time for
centuries**.

Triggers described:
1. kvmclock going backwards
2. userspace `KVM_SET_CLOCK` after runstate times were set (the SET_ATTR
   APIs reject entry_time in the future, but clock can be moved
   afterwards)
3. `steal_ns` negative if `sched_info.run_delay` goes backwards

Fix: treat deltas as signed; skip time accounting while delta is
negative (leave `runstate_entry_time` so a later positive delta covers
the gap); clamp steal to elapsed time; ignore negative steal.

Record: [unsigned wrap of runstate/steal] [guest 100% steal forever] [no
version pin] [root cause: unsigned kvmclock/run_delay subtraction]

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not disguised. Explicit correctness fix for wraparound.

Record: [Not a hidden fix; it is a stated wraparound/steal-time bug fix]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
- File: `arch/x86/kvm/xen.c` only
- Scope: ~22 insertions / ~6 deletions in one function
- Function: `kvm_xen_update_runstate()`
- Classification: single-file surgical fix

Record: [xen.c +22/-6] [kvm_xen_update_runstate] [surgical]

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before (this tree, lines 587–616):
```c
u64 delta_ns = now - vx->runstate_entry_time;
...
u64 steal_ns = run_delay - vx->last_steal;
delta_ns -= steal_ns;
vx->runstate_times[RUNSTATE_runnable] += steal_ns;
vx->runstate_times[vx->current_runstate] += delta_ns;
vx->runstate_entry_time = now;
```
Any `now < entry_time` or `run_delay < last_steal` wraps and adds a huge
value.

After:
- `s64 delta_ns`, `s64 steal_ns`
- `delta_ns < 0` → update current runstate + `last_steal` only; do not
  touch times or `entry_time`
- steal applied only if `steal_ns > 0`, and clamped to `delta_ns`
- `last_steal` always updated (even on the skip path)

Record: [unsigned wrap → skip/clamp signed accounting; guest cache still
updated]

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **logic / type (unsigned wrap) + guest-visible accounting
corruption**

Mechanism:
- `u64` subtraction underflows to ~2^64 ns
- Guest `xen_steal_clock()` is `runnable + offline`
  (`drivers/xen/time.c`)
- Huge runnable/offline → 100% steal until that delta is “consumed”

Record: [unsigned wrap] [skip negative kvmclock delta; clamp/ignore bad
steal_ns]

**Step 2.4: ASSESS THE FIX QUALITY**
Obviously correct: steal cannot exceed elapsed time; negative elapsed
time must not be accounted. Minimal. No API/struct change. Regression
risk is low: a backward clock window is not accounted until kvmclock
catches up, then one positive delta covers it. Neighboring
`kvm_xen_inject_vcpu_vector()` in the posted context uses a 3-arg
`kvm_irq_delivery_to_apic`; this tree has a 4th `NULL` — that function
is **not** in the changed hunk.

Record: [high quality, surgical] [low regression risk]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Entire function blamed to `5ec3289b31ab9` (“Compatibility fixes for
shared runstate area”, 2022-11-18), originally added in `30b5c851af799`
(“Add support for vCPU runstate information”, 2021-03-01,
**v5.12-rc2**).

Record: [30b5c851af799 / 5ec3289b31ab9] [first appeared v5.12; this
shape since v6.2]

**Step 3.2: FOLLOW THE FIXES: TAG**
No Fixes: tag.

Record: [N/A — no Fixes: tag] [introducer is in this tree]

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Recent `xen.c` commits are unrelated (schedop poll, event channels,
timers). No later runstate accounting rewrite in this tree.

Record: [no conflicting local rework] [standalone vs local xen.c
history]

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
David Woodhouse is the author of KVM Xen runstate (Amazon). Related
history is the original runstate feature and later Xen timer/deadlock
fixes. This is a maintainer-area fix.

Record: [primary KVM Xen runstate author] [this is a follow-on to his
2021 accounting]

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Posted as **v7 20/36** of the kvmclock cleanup series. Cover letter
(verified): fixes/cleanups are ordered **not** to depend on the later
new uAPI. Cover-letter stat for `xen.c` is `28 +-`, matching **only this
patch**. Later patches do not change this function. Local function body
matches the patch “before” exactly.

Record: [no code prerequisites in this tree] [can apply standalone]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- `b4 dig -c` on the candidate SHA failed: `36a85200643e` is **not** in
  this object store (`git merge-base --is-ancestor` exit 1)
- Found via search: [PATCH v7 20/36] on LKML/Patchew
- Cover letter: https://lkml.iu.edu/2607.3/08309.html — “Cleaning up the
  KVM clock mess”
- Patch: https://lkml.iu.edu/2607.3/08399.html
- kvm-x86 commit: `36a85200643e62d20a91f0bc1a811187b59f7762`
- lore.kernel.org fetches returned 403; used LKML/Patchew mirrors

v7 vs v6: same runstate hunk (v6 was 26/36; v7 reordered). No NAK on
this patch in the retrieved pages. `Reviewed-by: Paul Durrant` already
on the submission.

Record: [lore msgid 20260728144954.355376-21] [v6→v7 reorder, same diff]
[no NAK found] [no reviewer Cc: stable on this patch]

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Paul Durrant (Xen). Sean Christopherson applied. Series was on kvm/xen
lists (from msgid/patchew).

Record: [Paul Durrant review; Sean applied]

**Step 4.3: SEARCH FOR THE BUG REPORT**
No syzbot/bugzilla. Bug is described from Xen-on-KVM steal accounting
(author is the feature owner). Guest symptom matches
`xen_steal_clock()`.

Record: [no public user bugzilla] [author-described production-style
steal blow-up]

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Series problem statement includes kvmclock **discontinuities**
(masterclock re-snapshot yanking guest time) and imprecise
`KVM_SET_CLOCK` migration. Patch 36 is a Xen runstate migration
selftest. This hunk is the only `xen.c` change and does not need the new
`KVM_[GS]ET_CLOCK_GUEST` API.

Record: [thematic series; this patch is standalone] [do not need the
other 35 patches for this tree]

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org/stable returned 403.

Record: [UNVERIFIED: no stable@ thread retrieved]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: [`kvm_xen_update_runstate`]

**Step 5.2: TRACE CALLERS**
- `kvm_xen_runstate_set_running()` ← `record_steal_time()` in
  `arch/x86/kvm/x86.c` when `kvm_xen_msr_enabled()` (vCPU enter)
- `kvm_xen_runstate_set_preempted()` ← `kvm_arch_vcpu_put()` (preempt
  path)
- `kvm_xen_vcpu_set_attr()` `KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT`
  and `..._ADJUST` (VMM ioctl)

Hot path for Xen-enabled KVM guests, plus userspace restore.

Record: [vCPU enter/put + Xen runstate ioctls]

**Step 5.3: TRACE CALLEES**
`get_kvmclock_ns()`, `kvm_xen_update_runstate_guest()` (writes guest
runstate area). No new locks/allocs.

Record: [kvmclock read + optional guest shared-area update]

**Step 5.4: FOLLOW THE CALL CHAIN**
Reachable from normal vCPU run when `CONFIG_KVM_XEN` and Xen
MSR/hypercall page are enabled. Userspace can also move kvmclock via
`KVM_SET_CLOCK` (`kvm_vm_ioctl_set_clock` in this tree). The REALTIME
flag tries to avoid stepping backwards, but a plain `KVM_SET_CLOCK`
still sets `kvmclock_offset = data.clock - now_raw_ns` with no
monotonicity check.

Record: [reachable from VMM + guest vCPU run] [KVM_SET_CLOCK can move
clock back]

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Guest steal: `drivers/xen/time.c` `xen_steal_clock()` = runnable +
offline. Same wrap on `steal_ns` would inflate runnable. This tree
already rejects SET_ATTR runstate entry_time **after** current kvmclock
(lines 1039–1043, 1080–1085) but not clock changes afterwards.

Record: [guest steal uses runnable+offline] [SET_ATTR future-time check
exists; SET_CLOCK hole remains]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes. `arch/x86/kvm/xen.c` `kvm_xen_update_runstate()` still uses `u64
delta_ns` / `u64 steal_ns`.
- Tree: `pending-6.18`, `make kernelversion` = **6.18.53**
- Introducer `30b5c851af799` is an ancestor
- Candidate `36a85200643e` is **not** an ancestor

Record: [buggy code present at xen.c:587–616] [since v5.12]

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Function text matches the patch before-image. Expected **clean apply**.

Record: [clean apply]

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
No “Prevent runstate times” commit. kvmclock cleanup series not in this
tree (`git log --grep` empty). 6.18 still has the masterclock
discontinuity issue that series describes.

Record: [no substitute fix present]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
`arch/x86/kvm/xen.c` — KVM Xen PV ABI emulation. **IMPORTANT** for Xen-
on-KVM (cloud/QEMU), not core mm/vfs. `CONFIG_KVM_XEN` defaults to “If
in doubt, N” but is a real production option (author is Amazon; header
copyright Amazon/Oracle).

Record: [KVM Xen] [IMPORTANT, config-specific]

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Mature feature (v5.12+), ongoing Xen timer/evtchn fixes. Not staging.

Record: [mature, still maintained]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Xen-ABI KVM guests with runstate/steal enabled (`CONFIG_KVM_XEN` + VMM
setup). Not all KVM users.

Record: [config/driver-specific: KVM Xen guests]

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
1. `KVM_SET_CLOCK` (live migration/snapshot) after runstate SET_ATTR —
   documented, exists in this tree
2. kvmclock discontinuities from masterclock re-snapshot — still present
   here; the rest of the series is **not**
3. `run_delay < last_steal` unsigned wrap (ioctl uses VMM `current`;
   vCPU path uses the vCPU task)

Unprivileged guest cannot call `KVM_SET_CLOCK`; the VMM can. Guest then
sees broken steal forever.

Record: [migration/SET_CLOCK and steal wrap] [realistic in production
Xen-on-KVM] [VMM-triggered, guest-visible]

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Not a host oops. Guest scheduler steal accounting becomes permanently
wrong (100% steal for ~centuries). That breaks guest CPU accounting,
load, and can stall workloads/watchdogs. **HIGH** for those guests (not
host CRITICAL).

Record: [guest steal corruption / apparent 100% steal] [HIGH]

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Benefit: stops a permanent guest-visible accounting failure on a path
used in migration. Risk: ~20 lines, no locking/API change, skip-
accounting is conservative.

Record: [high benefit for Xen-on-KVM] [very low risk] [favorable]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real wraparound; guest `xen_steal_clock()` turns it into 100% steal
  for centuries
- Buggy `u64` math is in this 6.18.53 tree since v5.12
- Trigger exists here: `KVM_SET_CLOCK` after runstate setup; masterclock
  yanks; steal_ns wrap
- Small, obviously correct, applies cleanly
- Reviewed by Paul Durrant; applied by Sean Christopherson
- Standalone; series cover letter says these cleanups do not depend on
  later uAPI
- This tree does **not** have the rest of the kvmclock series, so
  discontinuities remain

AGAINST:
- Part of a 36-patch series (subject 20/36) — but verified independent
- No Fixes:/Cc: stable (not a negative per rules)
- No crash/CVE; Xen-specific
- No public multi-user Reported-by
- `CONFIG_KVM_XEN` is optional

UNRESOLVED:
- Direct lore.kernel.org and stable@ search 403
- `b4 dig` could not use a local candidate SHA
- Did not independently reproduce 100% steal (author claim + guest steal
  formula are consistent)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — signed math + clamp;
   reviewed; in kvm-x86
2. Fixes a real bug that affects users? **PASS** — guest steal blow-up
   on kvmclock/steal wrap
3. Important issue? **PASS** — permanent 100% steal is a serious guest
   functional failure (HIGH, not host panic)
4. Small and contained? **PASS** — one function, ~28 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present, before-
   image matches

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Not a device-ID/quirk/DT/build/doc exception. Ordinary correctness fix.

**Step 9.4: DECISION**
Backport to **this** 6.18.53 tree. The series around it is not needed;
the bug and the trigger are here.

------------------------------------------------
Detailed explanation
------------------------------------------------
**Problem:** Xen runstate times are accumulated with unsigned kvmclock
and `run_delay` deltas. A backward step wraps to ~2^64 ns. Linux guests
use runnable+offline as steal, so they can show 100% steal for
centuries. That is a live-migration/`KVM_SET_CLOCK` class bug, not a
theoretical one, and 6.18 still allows `KVM_SET_CLOCK` to move the clock
back.

**Stable rules:** Small, obviously correct, no new API, real guest-
visible failure, applies cleanly to this checkout.

**Risk vs benefit:** Benefit is preventing unusable guest steal
accounting on Xen-on-KVM. Risk is skipping a short accounting window
until kvmclock catches up — the intended recovery.

**Concerns:** Do not pull the rest of the kvmclock series. This hunk is
sufficient. No extra 6.18-specific rework expected.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Paul Durrant; Link msgid
  20260728144954.355376-21; SOB Woodhouse + Sean; no Fixes/Reported-
  by/Cc:stable
- [Phase 1] Subject verb “Prevent”; body describes unsigned wrap → 100%
  steal
- [Phase 2] Diff: only `kvm_xen_update_runstate()` in
  `arch/x86/kvm/xen.c`; signed delta/steal, skip if `delta_ns < 0`,
  clamp steal
- [Phase 3] `git blame` 587–616 → `5ec3289b31ab9`; introducer
  `30b5c851af799` contained in **v5.12-rc2**
- [Phase 3] `git merge-base --is-ancestor 30b5c851af799 HEAD` → yes;
  `36a85200643e` → no
- [Phase 3] Author is original runstate implementer
- [Phase 4] Cover letter LKML: series reordered so fixes do not depend
  on new uAPI; xen.c `28 +-` is this patch only
- [Phase 4] Patch text on lkml.iu.edu/patchew matches the candidate diff
- [Phase 4] UNVERIFIED: lore.kernel.org 403; b4 dig no local SHA;
  stable@ search 403
- [Phase 5] Callers: `record_steal_time` / `kvm_arch_vcpu_put` / Xen
  SET_ATTR; guest steal in `drivers/xen/time.c:145-150`
- [Phase 5] `kvm_vm_ioctl_set_clock` can set `kvmclock_offset` without a
  general “no backwards” check
- [Phase 6] `git describe HEAD` p-6.18-1-g03b85e06ca9bf; `make
  kernelversion` 6.18.53; local function still unsigned
- [Phase 6] Local function body identical to patch before-image → clean
  apply
- [Phase 7] CONFIG_KVM_XEN in `arch/x86/kvm/Kconfig`
- [Phase 8] Failure mode: guest 100% steal, severity HIGH; risk very low
- UNVERIFIED: could not reproduce steal blow-up at runtime; relied on
  code + author description

**YES**

 arch/x86/kvm/xen.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index d6b2a665b499d..b41e67e245a81 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -588,29 +588,45 @@ void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
 {
 	struct kvm_vcpu_xen *vx = &v->arch.xen;
 	u64 now = get_kvmclock_ns(v->kvm);
-	u64 delta_ns = now - vx->runstate_entry_time;
 	u64 run_delay = current->sched_info.run_delay;
+	s64 delta_ns = now - vx->runstate_entry_time;
+	s64 steal_ns = run_delay - vx->last_steal;
 
+	/*
+	 * If the vCPU was never run before, its prior state should
+	 * be considered RUNSTATE_offline.
+	 */
 	if (unlikely(!vx->runstate_entry_time))
 		vx->current_runstate = RUNSTATE_offline;
 
+	/*
+	 * If KVM clock went backwards, just update the current runstate
+	 * but don't account any time. Leave entry_time unchanged so the
+	 * next positive delta covers the full period once the clock
+	 * catches up. Update last_steal every time so stolen time only
+	 * reflects the interval since the most recent call.
+	 */
+	if (delta_ns < 0)
+		goto update_guest;
+
 	/*
 	 * Time waiting for the scheduler isn't "stolen" if the
 	 * vCPU wasn't running anyway.
 	 */
-	if (vx->current_runstate == RUNSTATE_running) {
-		u64 steal_ns = run_delay - vx->last_steal;
+	if (vx->current_runstate == RUNSTATE_running && steal_ns > 0) {
+		if (steal_ns > delta_ns)
+			steal_ns = delta_ns;
 
 		delta_ns -= steal_ns;
-
 		vx->runstate_times[RUNSTATE_runnable] += steal_ns;
 	}
-	vx->last_steal = run_delay;
 
 	vx->runstate_times[vx->current_runstate] += delta_ns;
-	vx->current_runstate = state;
 	vx->runstate_entry_time = now;
 
+ update_guest:
+	vx->current_runstate = state;
+	vx->last_steal = run_delay;
 	if (vx->runstate_cache.active)
 		kvm_xen_update_runstate_guest(v, state == RUNSTATE_runnable);
 }
-- 
2.53.0

