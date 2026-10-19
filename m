Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5729C5AA687;
	Mon, 19 Oct 2026 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418459; cv=none; b=ILfaVhQIhrU5ma4LDdszqSda9dA/yx8evkG+jAIfRyeoxwjAjBcf0cJnagG3OGOxlNDfIpCJ0m/h8Jk1qsVzuNfuhP7RN7QDfTM46zSnCpyrf5MnJIvS8D2RxJi3cwCumaKSgze8HOfBvt2Bmc8Y1UvXgn1X4CtycxyyYgGsarA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418459; c=relaxed/simple;
	bh=oj/PYRedChixZdNo0sWbXqQF5HOFwV2RZigFF4G3wsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fr3zQ38aF117av6vxV9D2ZcbjvCzVeT7C2BifZIwngSdy0DmnoPpbMfUYWuuQrLK13Ousyl6sGUYbwNix1z4+EmmCKAXSUNYeUHDq9ffDTRyKEnmcKy2KwToFveWm/BulPphIsN7LqMatZBEmFzlFCieyTxd/woQUszviPfBceI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwQ97jbY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwQ97jbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17251F000C8;
	Mon, 19 Oct 2026 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418457;
	bh=4ZOtBPIgms5nlKbJiJRido7CLqFqpIsZ01pQt1kHqMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwQ97jbYU5sB+c/QjBinViZs0bjP3t0Z2MM1u2tIkuqq2atiw8PUFc+/budBCvjyG
	 sgyR5d5p7VrPk8q6+IkcLgXRJmNocJ1/FM/9vjqisiXoL78wQllt1QfJtKCCQ9aW/F
	 YaW/QHdu7oXP/qvR4yQqbqyFOcx//G2DbXHK9Biif1A7DX5aPNqZTYX+HCuyDDOJPg
	 GVxuJ9pLLy4MhRKeew0efFH8pb2IWezrrjGcqk0lw4OX/zAVGjA2O93A//XC4+wcJ0
	 FV5wtH4I+UFytMKXnRFa4IMVTry0L/7lGPnWBN63bQ3BjIkV2GCIcxTEIAwciOYS/I
	 EI4VEgl8XZtlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Junhao He <hejunhao3@h-partners.com>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ACPI: APEI: Handle repeated SEA error storms
Date: Mon, 19 Oct 2026 09:49:13 -0400
Message-ID: <20261019135441.1420968-262-sashal@kernel.org>
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

From: Junhao He <hejunhao3@h-partners.com>

[ Upstream commit e61487226b7df39e5f4683b036ee6aa7a5039d7b ]

When hardware memory corruption occurs and a user process accesses the
corrupted page, the CPU triggers a Synchronous External Abort (SEA).
The kernel invokes do_sea() to handle the exception, which calls
memory_failure() to handle the faulty page.

Scenario 1: Memory Error Interrupt First, then SEA
The page is already poisoned by the memory error interrupt path. The
subsequent SEA handler sends a SIGBUS to the task, which accesses the
poisoned page. This flow is correct.

Scenario 2: SEA first, then memory error interrupt (problematic scenario)
If a user task directly accesses corrupted memory through a PFNMAP-style
mapping (e.g., devmem), the page may still be in the free-buddy state when
SEA is handled. In this case, memory_failure() will poison the page without
invoking kill_accessing_process(), and then takes the free-buddy recovery
path.

After the CPU returns to the task context, the task re-enters the SEA
handler due to the same access. However, ghes_estatus_cached() suppresses
all subsequent entries during the 10-second window, preventing
ghes_do_proc() from being called. This suppression blocks the
MF_ACTION_REQUIRED-based SIGBUS delivery, causing the kernel to fail to
kill the task immediately. Consequently, the process keeps re-entering
the SEA handler, leading to an SEA storm. Later, the memory error
interrupt path also cannot kill the task, leaving the system stuck in
this repeated loop.

The following error logs are explained using the devmem process:
  NOTICE:  SEA Handle
  [Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
  [Hardware Error]: event severity: recoverable
  [Hardware Error]:   section_type: ARM processor error
  [Hardware Error]:    physical fault address: 0x0000001000093c00
  [T54990] Memory failure: 0x1000093: recovery action for free buddy page: Recovered
  [ T9955] EDAC MC0: 1 UE Multi-bit ECC on unknown memory
           (page:0x1000093 offset:0xc00 grain:1 - APEI location: ...)
  NOTICE:  SEA Handle
  NOTICE:  SEA Handle
  ...
  ...        ---> SEA storm
  ...
  NOTICE:  SEA Handle
  [ T9955] Memory failure: 0x1000093: already hardware poisoned
  ghes_print_estatus: 1 callbacks suppressed
  [Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 9
  [Hardware Error]: event severity: recoverable
  [Hardware Error]:   section_type: ARM processor error
  [Hardware Error]:    physical fault address: 0x0000001000093c00
  [T54990] Memory failure: 0x1000093: already hardware poisoned
  [T54990] 0x1000093: Sending SIGBUS to devmem:54990 due to hardware memory corruption

To resolve this, return an error when encountering the same SEA again.
The subsequent SEA handler invocation uses arm64_notify_die() to send a
SIGBUS signal to the task, which terminates the process and prevents it
from re-entering the handler loop.

Signed-off-by: Junhao He <hejunhao3@h-partners.com>
Reviewed-by: Wupeng Ma <mawupeng1@huawei.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20260527082707.2013499-1-hejunhao3@h-partners.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **pending-6.18** (kernel **6.18.53**). The buggy GHES
cache-hit path is present here, the patch applies cleanly, and this is a
real ARM64 SEA-storm hang, so it should be backported.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ACPI: APEI] [Handle] [Stop repeated SEA aborts from looping
when GHES cache suppresses a duplicate error]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Reviewed-by: Wupeng Ma <mawupeng1@huawei.com>
- Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com> (ACPI APEI
  reviewer in MAINTAINERS)
- Reviewed-by: Tony Luck <tony.luck@intel.com> (ACPI APEI reviewer /
  RAS)
- Link: https://patch.msgid.link/20260527082707.2013499-1-hejunhao3@h-
  partners.com
- Signed-off-by: Junhao He <hejunhao3@h-partners.com>
- Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com> (ACPI
  maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / syzbot
- Ignore pipeline SOBs such as Sasha Levin

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: On ARM64 firmware-first SEA, if a userspace PFNMAP access
  (devmem) hits corrupted memory while the page is still a free buddy,
  `memory_failure()` poisons it as recovered and does not kill the task.
  The task retries the same access. `ghes_estatus_cached()` then drops
  duplicates for 10s (`GHES_ESTATUS_IN_CACHE_MAX_NSEC`), so
  `ghes_do_proc()` never runs again and SIGBUS is not delivered. The CPU
  loops in SEA. Firmware logs show a ~10s storm, then SIGBUS only after
  the cache expires.
- Symptom: exception storm / system stuck; related APEI commits note
  firmware threshold reboot or hard lockup from the same class of loop.
- Version info: none in the message. Logs are from a real ARM platform
  (APEI GHES source 9, EDAC MC0).
- Root cause: cache-hit path in `ghes_in_nmi_queue_one_entry()` returns
  success (`rc == 0`), so `apei_claim_sea()` claims the abort and
  `do_sea()` returns without `arm64_notify_die()`.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. This is an explicit hang/storm fix, not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/acpi/apei/ghes.c` only (+9 / -1)
- Function: `ghes_in_nmi_queue_one_entry()`
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: cached estatus → `goto no_work` with `rc` still 0 → callers
  treat it as “successfully handled.”
- After: cached + `is_hest_sync_notify(ghes)` (HEST notify type SEA) →
  `rc = -ECANCELED` → `ghes_notify_sea()` / `apei_claim_sea()` fail →
  `do_sea()` falls through to `arm64_notify_die()` and SIGBUS.
- Path affected: duplicate synchronous SEA only. NMI/SDEI cache hits
  stay `rc = 0`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: logic / correctness in RAS exception handling (hang /
  exception storm).
- Mechanism: success-on-cache-hit hid an incomplete recovery (free-buddy
  poison without kill). Returning an error unclaims the SEA so the arch
  handler can kill the task.

Verified supporting code in this tree:
- `action_result(MF_RECOVERED)` returns 0 (`mm/memory-failure.c`).
- `memory_failure_cb()` returns without SIGBUS if `!ret`.
- Free-buddy path never calls `kill_accessing_process()`.
- `79a5ae3c4c5eb` only `force_sig(SIGBUS)` when `sync && !queued`; the
  first SEA *does* queue work, so that fallback does not fire.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct for the single-source SEA case that matches the
  logs.
- Minimal; no API/data-structure change.
- Regression risk is low: gated by `is_hest_sync_notify()` so x86 NMI /
  SDEI behavior is unchanged.
- Known limitation (discussed on-list, accepted by Tony Luck): if
  several GHES SEA sources are on the list and one still returns 0,
  `-ECANCELED` is discarded. Author: a true multi-source storm is a
  different failure. Not a reason to withhold the single-source fix.
- KVM: `kvm_handle_guest_sea()` currently claims a duplicate SEA
  (`apei_claim_sea() == 0`). After this, it injects SError into the
  guest instead of leaving the host looping. That is an improvement, not
  a new API.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Cache skip introduced in `d9f608dc156487` (“ACPI / APEI: Only use
  queued estatus entry during in_nmi_queue_one_entry()”, 2019-01-29).
  Present in this tree.
- `is_hest_sync_notify()` from `a70297d221325` (2023-12-18). Present.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The bug is interaction among the
2019 cache, long-standing free-buddy recovery, and SEA claim returning
success.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Related commits already in this tree:
- `a70297d221325` — MF_ACTION_REQUIRED on sync events
- `79a5ae3c4c5eb` — SIGBUS if sync error is not queued
- `c1f1fda141373` — run `memory_failure()` in task work for sync SEA
This patch is a remaining hole after those two 2025 SIGBUS fixes: queued
free-buddy recovery still does not kill, then cache blocks the retry.

Standalone. Not “patch X/Y”.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Junhao He has HiSilicon PMU commits here, not APEI. Reviewers
are the APEI/RAS people. Weight is from review, not authorship.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `is_hest_sync_notify()` and the existing
`ghes_in_nmi_queue_one_entry()` cache check. Both are in this tree. Can
apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- v1 msgid: `20251030071321.2763224-1-hejunhao3@h-partners.com`
  (2025-10-30), 12 messages. Returned `-EAGAIN` on every cache hit,
  including NMI/SDEI.
- v2 msgid: `20260527082707.2013499-1-hejunhao3@h-partners.com`
  (2026-05-27), 10 messages. This is the applied version: only SEA via
  `is_hest_sync_notify()`.
- Applied version is v2 (latest).
- No NAKs. Rafael required an APEI-reviewer ACK; Tony Luck then
  Reviewed-by. Rafael: “Applied as 7.3 material.”
- No reviewer Cc: stable.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients/reviewers included ACPI APEI maintainers/reviewers
(Rafael, Tony Luck, Shuai Xue). Shuai asked for an x86 look because the
helper is shared; v2’s SEA-only gate was the answer. Tony Luck R-b after
that explanation.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot. Author included production-style firmware +
kernel logs (`devmem` task, free buddy Recovered, then 10s of “SEA
Handle”, then SIGBUS). Real hardware reproduction, not theoretical.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Single patch. v2 changelog: (1) commit message per Shuai Xue,
(2) SEA-only so other NMI-type GHES handlers are not affected.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org HTTP was 403/Anubis. Thread retrieved with `b4
mbox`. No stable@ discussion found in those threads. UNVERIFIED: other
independent stable-list threads beyond these two.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `ghes_in_nmi_queue_one_entry()`; uses `ghes_estatus_cached()`,
`is_hest_sync_notify()`.

Step 5.2: TRACE CALLERS
Record:
- `ghes_in_nmi_spool_from_list()` ← `ghes_notify_sea()` (SEA) and NMI
  list
- `__ghes_sdei_callback()` (SDEI)
- `ghes_notify_sea()` ← `apei_claim_sea()` ← `do_sea()` (user_mode only)
  and `kvm_handle_guest_sea()`
NMI/SDEI: `is_hest_sync_notify()` is false, so no behavior change.

Step 5.3: TRACE CALLEES
Record: Cache lookup, `gen_pool_free` on `no_work`, no new locks/allocs
on the new path.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace load/store to poisoned PFNMAP memory → SEA → `do_sea`
→ `apei_claim_sea` → GHES. Reachable from userspace (`/dev/mem` in the
logs). Unprivileged trigger depends on who can map that physical page
(typically privileged), but once it fires the host loops. Firmware-first
ARM64 servers are the population.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `ghes_proc()` still calls `ghes_do_proc()` even when cached (IRQ
path). Only the NMI-queue path skips processing on cache hit. That is
unique to this helper; no sibling copy of the same bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `drivers/acpi/apei/ghes.c:1373-1375` is still:

```
if (ghes_estatus_cached(estatus))
    goto no_work;
```

`is_hest_sync_notify()` exists. `CONFIG_ACPI_APEI_SEA` is default y on
ARM64. Bug class present since the 2019 queue path; this 6.18 tree also
has the 2025 task-work SIGBUS series that still misses free-buddy.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Exact hunk matches this file. Expected apply: clean.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `c1f1fda141373` and `79a5ae3c4c5eb` are in HEAD; they do not
cover this cache-hit + free-buddy case. This commit is not in HEAD (`git
log --grep` on the file found nothing).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: ACPI APEI / GHES RAS. IMPORTANT for ARM64 firmware-first
platforms (servers, Huawei/Kunpeng-class). Not core-mm, but memory-error
handling on those machines.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained (CXL CPER, ARM CPER bounds, task-work SEA).
Mature SEA queue dates to 2019.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: ARM64 + ACPI APEI GHES SEA + memory failure. Driver/platform-
specific, not universal. Typical of enterprise ARM RAS.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Hardware UE/poison + userspace access via PFNMAP while page is
free buddy, SEA before (or instead of useful) async kill. Not every
boot. When it hits, it repeats until the 10s cache expires or firmware
reboots. Unprivileged users generally cannot open `/dev/mem`; still a
host-stability bug for RAS/error-injection and any PFNMAP consumer.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Exception storm / stuck task; related APEI text: firmware
threshold reboot or hard lockup. Severity: CRITICAL/HIGH. Logs prove the
10s storm (`1419.78` → `1429.81`).

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for ARM64 RAS — stops a documented SEA storm and
  delivers SIGBUS immediately.
- Risk: low — ~9 lines, SEA-only, no new ABI, clean apply.
- Ratio: benefit ≫ risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real hang/storm with hardware logs
- Small, obviously correct, SEA-gated
- Applies cleanly to this 6.18 tree; helper already present
- Prior APEI SIGBUS fixes in this tree leave this hole
- Reviewed by APEI reviewers (Luck, Xue) and applied by Rafael

AGAINST:
- Trigger is RAS/PFNMAP, not every machine
- No Fixes:/Cc: stable (not a negative per rules)
- Incomplete if multiple concurrent distinct SEA sources all stay cached
  (accepted on-list)

UNRESOLVED:
- Could not HTTP-fetch lore (403); used `b4 mbox` instead
- UNVERIFIED: later mainline follow-ups after this commit
- UNVERIFIED: independent stable@ threads besides v1/v2

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — v2 after review; logs; R-b from
   Luck/Xue/Ma
2. Fixes a real bug that affects users? PASS — documented SEA storm on
   devmem/PFNMAP
3. Important issue? PASS — hang / exception storm / possible firmware
   reboot
4. Small and contained? PASS — one function, ~9 lines
5. No new features or APIs? PASS
6. Can apply to the local tree? PASS — hunk present, helper present, not
   already applied

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID/quirk/DT/build/doc exception). Qualifies
as a normal important bugfix.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18 tree. It closes a remaining ARM64
GHES SEA loop after the task-work SIGBUS work already in 6.18, with
negligible regression risk.

Verification:
- [Phase 1] Parsed tags: 3 Reviewed-by (Ma, Xue, Luck), Link msgid,
  Rafael SOB; no Fixes/Cc:stable/syzbot
- [Phase 2] Diff: +9/-1 in `ghes_in_nmi_queue_one_entry()`; `-ECANCELED`
  only if cached && `is_hest_sync_notify()`
- [Phase 2] Confirmed `action_result(MF_RECOVERED)` returns 0;
  `memory_failure_cb` skips SIGBUS; free-buddy path skips
  `kill_accessing_process`
- [Phase 2] Confirmed `79a5ae3c4c5eb` force-kill is `sync && !queued`
  only, so first SEA that queues work is not covered
- [Phase 3] blame: cache skip `d9f608dc156487` (2019);
  `is_hest_sync_notify` `a70297d221325`; both ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor` : a70297, c1f1fda, 79a5ae3,
  d9f608dc all in this tree
- [Phase 3] `git log --grep='repeated SEA'` on `drivers/acpi/`: empty —
  commit not here
- [Phase 4] `b4 am`/`b4 mbox`: v1 12 msgs (2025-10-30), v2 10 msgs
  (2026-05-27); v2 is applied version
- [Phase 4] Tony Luck questioned SDEI vs SEA callers; author said SEA-
  only; Luck R-b; Rafael applied as 7.3 material
- [Phase 4] lore HTTP 403; discussion taken from b4 mboxes
- [Phase 5] callers: `ghes_in_nmi_spool_from_list`,
  `__ghes_sdei_callback`; user path `do_sea` → `apei_claim_sea`; KVM
  `kvm_handle_guest_sea`
- [Phase 6] `git describe HEAD` = p-6.18-1-g03b85e06ca9bf; `make
  kernelversion` = 6.18.53
- [Phase 6] exact old hunk still in `ghes.c:1373-1375`; new hunk absent
- [Phase 8] Failure mode: SEA storm ~10s (log timestamps 1419 → 1429),
  then SIGBUS; severity HIGH/CRITICAL
- UNVERIFIED: follow-up commits after this one in later mainline; other
  stable@ threads

**YES**

 drivers/acpi/apei/ghes.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 5b52455d86e02..1a77aba0475be 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1371,8 +1371,16 @@ static int ghes_in_nmi_queue_one_entry(struct ghes *ghes,
 	ghes_clear_estatus(ghes, &tmp_header, buf_paddr, fixmap_idx);
 
 	/* This error has been reported before, don't process it again. */
-	if (ghes_estatus_cached(estatus))
+	if (ghes_estatus_cached(estatus)) {
+		/*
+		 * Return failure on duplicate SEA entries so that the
+		 * subsequent SEA handler invocation sends a SIGBUS signal to
+		 * the task to prevent it from re-entering the handler loop.
+		 */
+		if (is_hest_sync_notify(ghes))
+			rc = -ECANCELED;
 		goto no_work;
+	}
 
 	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
 
-- 
2.53.0

