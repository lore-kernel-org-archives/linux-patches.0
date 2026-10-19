Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9634D3BF7;
	Mon, 19 Oct 2026 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418149; cv=none; b=KJLvZm3G04JgI/oCyYiT4+4mnzcSpU+NgEjN6xlYECRUgeIoDUw7lslwqrwXv7TKY54wJjAh7SkkvI2tV58PgjtfrnexXu+YdONBXDbeiByZtbmG3ABEd8fmoLUNOmp2Yw7Hc4nL9560IZO3DEkJ7y+gC5dDxigcl9AAZX2OJ/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418149; c=relaxed/simple;
	bh=bL+sUusgi7hRk4ILth2acdI2eV20kTiIh38Z0+Wh0+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p542Wd9UhR7jVNl1brtVV1dlxvlM9ycSR26DhBVbeLxCEZjzj4HMqtmRQaHNfECP/VwvwVsq/H4eoGiIFPKa9WafXodRTBW+kAAB4HyUAtZrOL2M5QUtGsKHBdWbkcucg2d2wHheYPFuneHNXDgPXI8BgfIiC9ZHXJ+udM4r6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQlzyiSz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQlzyiSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A348A1F000C8;
	Mon, 19 Oct 2026 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418146;
	bh=nHLGTsqgzrpP743iggg/I87NFd+UE+21/5qKzZ490fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQlzyiSzJXFVVTclsV1gkSvWaCCy0xa7cdW8KS/5vL9/zdR+O8EsLA4aU8TC8celb
	 3mfqayR6GI63Ydt+fy+ZBivF4+NKKqE5fmSGJhN4pC1gnsGCRE3P2amRn9Tj8f78i3
	 ZzJRQWZOwY/U26sPUfZ5xapj0WK2SfTIh/EYqCK+n7tjS3THCAA7VaWJSMB1ZnpXLh
	 T/GqDcRCrRCEphJ8U4iTgBLRtC6hZy6jehLwPQ128sGLui7GkH0iDic90xdS6v3FiZ
	 H2AWaQB+LhSr2KQSvMYj3Qcw+pEa1PBK8Bx0q0noX7XS+Akn4fCEtwq1YRHlKC3K+q
	 jiApaQFT4Ad9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chao Shi <coshi036@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] nvme: ratelimit the completion-path messages driven by device data
Date: Mon, 19 Oct 2026 09:45:36 -0400
Message-ID: <20261019135441.1420968-45-sashal@kernel.org>
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

From: Chao Shi <coshi036@gmail.com>

[ Upstream commit c05c86681170e381e24498257db3a879deb1ae89 ]

nvme_find_rq() and nvme_handle_cqe() print an unratelimited message for
every completion queue entry whose command id does not resolve to an
in-flight request.  Both are reached from the completion interrupt path
(nvme_irq() -> nvme_poll_cq() -> nvme_handle_cqe()) and the decision to
print is made entirely from device-supplied data, so a controller that
posts a stream of bogus command ids drives unbounded printk from hard
interrupt context.

This is not hypothetical.  A single boot under an emulated controller
that posts invalid completions produced 846 "could not locate request
for tag 0x0", 846 "invalid id 0 completed on queue 2" and 123 "genctr
mismatch" lines.  Once the tag set has been torn down every subsequent
completion resolves to nothing, so the print rate is bounded only by how
fast the device can post entries.

Ratelimit the three messages.  The information they carry is diagnostic
and repeats, so the suppression count printed by the ratelimit helpers
is enough to tell that the condition persists.  This matches how the
other device-driven error prints in the driver are already handled, for
example the status messages in nvme_log_error() and
nvme_log_err_passthru().

nvme_find_rq() lives in nvme.h and is shared by pci, tcp, rdma, apple and
target-loop, so all transports are covered.

Found by FuzzNvme.

Signed-off-by: Chao Shi <coshi036@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough local-tree and review evidence to decide. The remaining
work is to write the full nine-phase analysis.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[nvme]** **[ratelimit]** Completion-path messages that fire
from device-supplied command IDs are unbounded; the commit rate-limits
those three prints.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Signed-off-by:** Chao Shi \<coshi036@gmail.com\> (author)
- **Signed-off-by:** Keith Busch \<kbusch@kernel.org\> (NVMe maintainer;
  applied the patch)
- **No Fixes:** tag (expected for this review queue)
- **No Cc: stable** (expected; not a negative)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link:**
- Notable: “Found by FuzzNvme” in the body (fuzzer-found, not syzbot)
- Ignore any pipeline “Upstream commit” / “Signed-off-by: Sasha Levin”
  markers

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `nvme_find_rq()` and `nvme_handle_cqe()` print on every CQE
  whose command id does not map to an in-flight request. The print
  decision is made from device-supplied data.
- **Symptom:** Unbounded `printk` from the completion interrupt path
  (`nvme_irq()` → `nvme_poll_cq()` → `nvme_handle_cqe()`). One emulated-
  controller boot produced 846 “could not locate request for tag 0x0”,
  846 “invalid id 0 completed on queue 2”, and 123 “genctr mismatch”
  lines. After the tag set is torn down, every later completion prints;
  rate is limited only by how fast the device posts entries.
- **Version info:** None in the message. The prints have been in-tree
  since v5.15 / v5.9 (verified in Phase 3).
- **Root cause:** Device-controlled, unratelimited diagnostics on the
  hard-IRQ completion path. Other device-driven NVMe error prints
  (`nvme_log_error()`, `nvme_log_err_passthru()`) are already
  ratelimited.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit fix for IRQ-context
log flood. The subject uses “ratelimit” rather than “fix”, but the body
states the failure mode and a concrete reproduction.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- `drivers/nvme/host/nvme.h`: `nvme_find_rq()` — `pr_err` →
  `pr_err_ratelimited`; `dev_err` → `dev_err_ratelimited` (~5 lines net
  churn)
- `drivers/nvme/host/pci.c`: `nvme_handle_cqe()` — `dev_warn` →
  `dev_warn_ratelimited` (3 lines)
- Scope: **single-purpose surgical fix**, two files, ~9 insertions / 8
  deletions. No logic, locking, or API changes.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Hunk 1 (`nvme_find_rq`, missing request): same `return NULL`; only the
  error print is ratelimited.
- Hunk 2 (`nvme_find_rq`, genctr mismatch): same `return NULL`; only the
  error print is ratelimited.
- Hunk 3 (`nvme_handle_cqe`, invalid id): same early return; only the
  warning is ratelimited.
- Affected path: completion / IRQ / poll error path when the device
  posts a bad command id. Success path is unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** Logic / correctness of diagnostics; IRQ-context
  resource/DoS (unbounded `printk` driven by device data).
- **Mechanism:** A malicious or failing controller can post a stream of
  CQEs with bogus command ids. Each entry hits
  `pr_err`/`dev_err`/`dev_warn` in `nvme_irq()`. After tag-set teardown
  the miss path is permanent. `_ratelimited` variants cap volume while
  still reporting that the condition persists (suppression count).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: swap to helpers already used in the same driver
  (`nvme_log_error()`, PCI timeout path).
- Minimal: three call-site changes, no behavior change on the success
  path.
- Regression risk: very low. Worst case is fewer repeated log lines for
  a persistent fault; first occurrences and the ratelimit “suppressed”
  count remain.
- Red flags: none (no API, locking, or data-structure changes).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `nvme_find_rq()` and both prints: `e7006de6c23803` (“nvme: code
  command_id with a genctr for use-after-free validation”, Sagi
  Grimberg, 2021-06-16). Contained in **v5.15-rc1**. Present in this
  tree (`git merge-base --is-ancestor` succeeded).
- PCI “invalid id” print: `50b7c24390a53c` (“nvme-pci: fix NULL req in
  completion handler”, Xianting Tian, 2020-09-22). Contained in
  **v5.9-rc7**. Present in this tree.
- The buggy prints have been in NVMe for years, including all 6.12.y
  history.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. N/A. The introducing commits above are the
functional origin.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `git log --oneline -15 HEAD -- drivers/nvme/host/nvme.h` shows no
  later rewrite of `nvme_find_rq()`.
- `git log --oneline --grep="ratelimit the completion-path" HEAD --
  drivers/nvme/` is empty: this fix is **not** in the local tree.
- Standalone one-patch change. Not “patch X/Y”. Keith applied it to
  nvme-7.3 with only a line-wrap tweak.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Chao Shi: only `4298c52252cf6` (“nvme: reject passthrough of driver-
  managed Set Features”) in this tree under `drivers/nvme/`. Not a
  series dependency.
- Keith Busch is an NVMe maintainer; his SOB is a strong quality signal.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers or structs. `pr_err_ratelimited` /
`dev_err_ratelimited` / `dev_warn_ratelimited` exist in this tree
(`include/linux/printk.h`, `include/linux/dev_printk.h`) and are already
used in `drivers/nvme/host/core.c` and `pci.c`. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c <msgid>` failed: the landed commit is not in this checkout,
  so there is no local commit-ish to match.
- Thread recovered from Patchew and Openwall (lore.kernel.org returned
  403):
  - Submission: https://patchew.org/linux/20260810220258.1960208-1-
    coshi036@gmail.com/
  - Message-ID: `20260810220258.1960208-1-coshi036@gmail.com`
    (2026-08-10)
  - Single v1 patch (not a multi-revision series).
- Keith Busch: agreed that dumping every garbage CQE adds no diagnostic
  value; **applied to nvme-7.3** with a minor overly-long-line wrap. No
  NAK, no stability concern.
- Author replied that later submissions would avoid long lines. That is
  style only; Keith already applied the wrap.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To/Cc on the v1: Keith Busch, Jens Axboe, Christoph Hellwig,
Sagi Grimberg, linux-nvme, linux-kernel. Maintainer applied it. No
separate Reviewed-by on the provided commit text.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot link. Reproduction is in the commit: FuzzNvme
+ emulated controller, 1815 diagnostic lines in one boot. Severity from
the author’s data: hard-IRQ printk flood, unbounded after tag-set
teardown.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. Sibling unratelimited prints remain in
apple/tcp/rdma/loop *after* `nvme_find_rq()` fails; those are extra
transport messages, not prerequisites. This patch still covers the
shared `nvme_find_rq()` prints on all of those transports.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. Openwall/Patchew
show no stable NAK or “already rejected” discussion. UNVERIFIED: no
evidence this was previously declined for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `nvme_find_rq()` (inline in `nvme.h`); `nvme_handle_cqe()`
(`pci.c`).

Step 5.2: TRACE CALLERS
Record (verified with grep + reads):
- `nvme_find_rq()`:
  - `nvme_handle_cqe()` — PCI
  - `nvme_tcp_process_nvme_cqe()`, `nvme_tcp_handle_c2h_data()`,
    `nvme_tcp_handle_r2t()` — TCP
  - `nvme_rdma_process_nvme_rsp()` — RDMA
  - `apple_nvme_handle_cqe()` — Apple
  - `nvme_loop` completion path — target-loop
- `nvme_handle_cqe()` ← `nvme_poll_cq()` ← `nvme_irq()` (hard IRQ or
  threaded IRQ), `nvme_poll_irqdisable()`, `nvme_poll()`,
  `nvme_reap_pending_cqes()`.
- Impact: every NVMe transport’s completion path. PCI hard-IRQ is the
  hottest and the one the commit calls out.

Step 5.3: TRACE CALLEES
Record: `blk_mq_tag_to_rq()`, genctr helpers, then `pr_*` / `dev_*`. No
allocation, no new locking.

Step 5.4: FOLLOW THE CALL CHAIN
Record: PCI: device posts CQE → MSI/MSI-X → `nvme_irq()` →
`nvme_poll_cq()` → `nvme_handle_cqe()` → `nvme_find_rq()`. Reachable
whenever an NVMe controller is attached, including VMs/emulators and
failing real devices. Userspace does not need a special syscall; a bad
device is enough. FuzzNvme reached it.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same driver already ratelimits device-driven errors
(`nvme_log_error`, `nvme_log_err_passthru`, PCI timeout
`dev_warn_ratelimited`). Apple still has an unratelimited “invalid id”
`dev_warn`; TCP/RDMA/loop have their own unratelimited “bad command_id”
prints. Those leftovers do not block this fix.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** Local tree is **6.12.111** (`git describe HEAD` →
`p-6.12-3-gc504cf0baa3d8`, `make kernelversion` → 6.12.111).
- `drivers/nvme/host/nvme.h:598-607` still uses `pr_err` / `dev_err`.
- `drivers/nvme/host/pci.c:1128-1130` still uses `dev_warn`.
- Introducing commits are ancestors of HEAD. Bug present since v5.15
  (find_rq) / v5.9 (PCI invalid-id print).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply (line-number offset only).** The 6.12
`nvme_find_rq()` body matches the hunk. `nvme_handle_cqe()` differs
later (`trace_nvme_sq` lacks the newer `data_race()` comment in this
tree), but that is after the changed warn. No conflicting refactor.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No commit in this tree ratelimits these three messages. No
alternate fix found.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **NVMe host** (`drivers/nvme/host/`). **IMPORTANT** — primary
block storage on servers, workstations, and many embedded/Android
platforms. Not core mm/VFS, but a very common production driver.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Active in this 6.12 branch (recent PCI IRQ, doorbell, quirk, and
core lifetime fixes). The buggy prints themselves have been unchanged
since 2021.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific**, all NVMe host transports via
`nvme_find_rq()`; PCI users are the main hard-IRQ case. Large user
population whenever a controller posts invalid completions (faulty
firmware, reset/teardown, emulator, fuzzer, passthrough VM).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: CQE with a command id that does not resolve, or genctr
  mismatch; also every completion after tag-set teardown.
- Commonness: rare on healthy hardware; realistic on failing devices,
  resets, and VMs. FuzzNvme hit it in one boot.
- Unprivileged userspace: not via a normal syscall on a healthy disk. A
  VM user with an emulated/passthrough NVMe device, or a malicious
  controller, can drive it. Device-controlled printk from IRQ is a host
  DoS vector in those setups.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure mode:** Unbounded `printk` from hard IRQ / completion
  context. Can stall on `console_lock`, flood the log, and contribute to
  soft lockups on slow consoles. Not a UAF/oops by itself.
- **Severity: HIGH** (IRQ-context flood / hang risk), not CRITICAL (no
  panic/corruption on the success path).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** High for NVMe users who hit a dying, resetting, or
  emulated controller — stops IRQ printk storms that have been
  demonstrated in practice.
- **Risk:** Very low (3 call-site swaps to existing ratelimit helpers).
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Real, reproduced bug (1815 lines in one boot; FuzzNvme).
- Hard-IRQ, device-controlled printk — known lockup/DoS class.
- After tag-set teardown the miss path is permanent; print rate = device
  CQE rate.
- Tiny, obviously correct, matches existing NVMe style.
- Maintainer (Keith Busch) applied it with agreement, no NAK.
- Buggy code present in this 6.12.111 tree since v5.15/v5.9.
- Applies cleanly; no prerequisites.
- `nvme_find_rq()` is shared across PCI/TCP/RDMA/Apple/loop.

**AGAINST:**
- Not a crash, UAF, or data-corruption fix.
- Healthy devices rarely hit the path.
- Transport-local “bad command_id” prints in tcp/rdma/apple/loop stay
  unratelimited (incomplete sibling coverage, not a dependency).

**UNRESOLVED:**
- lore.kernel.org 403; discussion recovered from Patchew/Openwall.
- `b4 dig -c` could not run against a local SHA (commit not in this
  tree).
- No stable-list discussion found (search blocked).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — three `_ratelimited` swaps;
   maintainer applied; FuzzNvme reproduction.
2. Fixes a real bug that affects users? **PASS** — documented IRQ printk
   flood; teardown path makes it unbounded.
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   IRQ-context flood can stall the console / soft-lockup; device-driven
   DoS. Severity HIGH.
4. Small and contained? **PASS** — ~9/+8 lines, two files, error prints
   only.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — buggy code present; helpers
   present; clean apply expected.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID / quirk / DT / build / docs exception. Qualifies
as a normal small stability fix.

Step 9.4: MAKE YOUR DECISION
This belongs on 6.12.y. The tree still has the unratelimited IRQ prints,
the fix is surgical, and the failure mode is a real host-stability
problem on failing or emulated NVMe — not a feature or cleanup.

Detailed explanation:
The problem is unbounded `printk` from NVMe completion handling when the
device supplies a command id that does not map to an in-flight request.
That path runs from `nvme_irq()` in hard interrupt context (or the
equivalent completion callbacks on other transports). After the tag set
is torn down, every CQE misses, so a broken controller can print as fast
as it can post completions. That is a real production concern during
reset/remove of a failing disk and in VMs; FuzzNvme already produced
thousands of lines in one boot. Rate-limiting those three diagnostics
matches `nvme_log_error()` and does not change I/O completion logic.
Risk is negligible; benefit is avoiding IRQ-context log storms on a
widely deployed storage stack.

Verification:
- [Phase 1] Parsed tags: author SOB Chao Shi; maintainer SOB Keith
  Busch; no Fixes/Cc stable/Reported-by (expected).
- [Phase 1] Body: concrete counts (846/846/123) and IRQ path `nvme_irq`
  → `nvme_poll_cq` → `nvme_handle_cqe`.
- [Phase 2] Diff: `pr_err`/`dev_err`/`dev_warn` → `_ratelimited` in
  `nvme_find_rq` and `nvme_handle_cqe` only.
- [Phase 3] `git blame drivers/nvme/host/nvme.h`: prints from
  `e7006de6c23803` (v5.15-rc1).
- [Phase 3] `git blame drivers/nvme/host/pci.c`: invalid-id print from
  `50b7c24390a53c` (v5.9-rc7).
- [Phase 3] `git merge-base --is-ancestor e7006de6c23803 HEAD` and
  `50b7c24390a53c HEAD`: both ancestors.
- [Phase 3] `git log --grep="ratelimit the completion-path" HEAD --
  drivers/nvme/`: empty; fix not in this tree.
- [Phase 4] `b4 dig` needs a local commit-ish; candidate is not in this
  checkout — UNVERIFIED via b4.
- [Phase 4] Patchew + Openwall: v1 applied by Keith Busch to nvme-7.3;
  no NAK.
- [Phase 4] lore.kernel.org fetch: 403 — discussion taken from
  Patchew/Openwall instead.
- [Phase 5] Callers of `nvme_find_rq`: pci, tcp, rdma, apple,
  target/loop (grep).
- [Phase 5] `nvme_poll_cq` called from `nvme_irq`,
  `nvme_poll_irqdisable`, `nvme_poll`, `nvme_reap_pending_cqes`.
- [Phase 5] `queue_request_irq()` registers `nvme_irq` as the hard-IRQ
  handler (or thread fn).
- [Phase 5] Ratelimit macros present in `include/linux/printk.h` and
  `include/linux/dev_printk.h`; already used in `nvme_log_error()`.
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111
  (`p-6.12-3-gc504cf0baa3d8`).
- [Phase 6] Read `nvme.h:598-607` and `pci.c:1126-1131`: unratelimited
  prints still present.
- [Phase 8] Failure mode: device-driven printk flood from hard IRQ;
  severity HIGH (lockup/DoS), not oops/UAF.
- UNVERIFIED: whether this SHA already exists on some other remote
  branch (not required; local tree does not have the fix).
- UNVERIFIED: stable mailing-list history (lore/stable 403).

**YES**

 drivers/nvme/host/nvme.h | 6 +++---
 drivers/nvme/host/pci.c  | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ec03a07617af1..b28c1a82f79e6 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -672,12 +672,12 @@ static inline struct request *nvme_find_rq(struct blk_mq_tags *tags,
 
 	rq = blk_mq_tag_to_rq(tags, tag);
 	if (unlikely(!rq)) {
-		pr_err("could not locate request for tag %#x\n",
-			tag);
+		pr_err_ratelimited("could not locate request for tag %#x\n",
+				   tag);
 		return NULL;
 	}
 	if (unlikely(nvme_genctr_mask(nvme_req(rq)->genctr) != genctr)) {
-		dev_err(nvme_req(rq)->ctrl->device,
+		dev_err_ratelimited(nvme_req(rq)->ctrl->device,
 			"request %#x genctr mismatch (got %#x expected %#x)\n",
 			tag, genctr, nvme_genctr_mask(nvme_req(rq)->genctr));
 		return NULL;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4efb55f1e3833..6e4261b0a0821 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1375,9 +1375,9 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq,
 
 	req = nvme_find_rq(nvme_queue_tagset(nvmeq), command_id);
 	if (unlikely(!req)) {
-		dev_warn(nvmeq->dev->ctrl.device,
-			"invalid id %d completed on queue %d\n",
-			command_id, le16_to_cpu(cqe->sq_id));
+		dev_warn_ratelimited(nvmeq->dev->ctrl.device,
+				     "invalid id %d completed on queue %d\n",
+				     command_id, le16_to_cpu(cqe->sq_id));
 		return;
 	}
 
-- 
2.53.0

