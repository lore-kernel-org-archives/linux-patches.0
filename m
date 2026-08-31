Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EEF43F4A6;
	Mon, 31 Aug 2026 13:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183472; cv=none; b=pTn01E49F+7OK7M9QI6h1l8a73/bAM+OmEjgJctaqWmmFnp/8X39PdYzsF0FwjNUhiCMISdFbAViEStPn42S8VJazgKUK5oReRax0ohpLIavflOi0l2XGmTIhQS4c1G0AqwUiHnkYkRcBtLXJsWuWRDR5eio+denNb/mPk14TsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183472; c=relaxed/simple;
	bh=JpimYiIdHbRg+hr8DlpmCsjPTHZ10S6O2xwHyf2uBeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFUdN/ef3KD9RJs9QW1haLu5lCnAh1TPi/YW5QfIVMq7PBxioJBaAWMNF+4nN60k7vVoH5mSDzP+5Pi537n8UaV1OwRN1Gou+9ZxIQlkRwmZLWpkuGYcUFze9aFdQD9QOO+gdGJAelT55DCO8H8YuNJw3usn/FViTN/sY4hDuEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=myEK7VkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="myEK7VkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21411F00ACA;
	Mon, 31 Aug 2026 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183470;
	bh=b3B60qoFdReGPZO6ITwG4sYGQo/AaMOlvcp0vHFXmyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myEK7VkEEs2d/ncA2PgUaeEEfMEgCMRw0en7kVAvwFzvCRovGQsjrxro7O9AJpk9J
	 Ip8J6J9QmRJEvMKUn7f8TnIY1kqpUSPPs2TUGwSuOVmkAuUStKQP0DHMKiCvw1t9mK
	 LQrsInvVd450R2frfZeHqkcdhJtgfHucBpg2lQZAiCYJcaLNwayMXQvSfKqa32dLj9
	 c710cEC7W7yjMbgbwSZK6ug+QxrGcKrR6UMfFo3y/USjcR7DyPJeCD0oHV5ENslcZG
	 qDQSpyDBEjBAHN/f7N1YlfblsTptNNrVJBD2DlqEgj2FHOqOxuMI0i4j6AWyMlf43q
	 kwA58V4/Ag/0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Shuan He <heshuan@bytedance.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] PCI/proc: Fix race between pci_proc_init() and pci_bus_add_device()
Date: Mon, 31 Aug 2026 09:22:23 -0400
Message-ID: <20260831133314.4125787-115-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 8857f6578b001bcf5f53c8c6a3936647f05291a8 ]

pci_proc_attach_device() creates procfs entries for PCI devices and is
called from pci_bus_add_device().  It lazily creates the per-bus procfs
directory (bus->procdir) via proc_mkdir() on first use, and returns early
if proc_initialized is not yet set.

On x86 with ACPI, PCI enumeration occurs at subsys_initcall, before
pci_proc_init() sets proc_initialized at device_initcall.  The
for_each_pci_dev() loop in pci_proc_init() then creates procfs entries for
these already-enumerated devices, but runs without holding
pci_rescan_remove_lock.

On ARM64 with devicetree, PCI host bridges probe at device_initcall.  With
async probing enabled, pci_bus_add_device() can run concurrently with
pci_proc_init(), and both may call pci_proc_attach_device() for the same
device or for different devices on the same bus.  As pci_host_probe() holds
pci_rescan_remove_lock while pci_proc_init() does not, there is no
serialisation between the two paths.

When two threads concurrently call pci_proc_attach_device() for devices on
the same bus, both observe bus->procdir as NULL and both call proc_mkdir().
The proc filesystem serialises directory creation internally, so only one
caller succeeds.  The other results in a warning like:

  proc_dir_entry '000c:00/00.0' already registered

The caller receives NULL (duplicate entry) and unconditionally stores it to
bus->procdir, corrupting the valid pointer set by the first caller.

Serialise access to proc_initialized, proc_bus_pci_dir, bus->procdir and
dev->procent with a new mutex local to drivers/pci/proc.c, and store the
created entries to bus->procdir and dev->procent only on success, so a
failed creation can never overwrite a valid pointer.

Additionally, wrap the for_each_pci_dev() loop in pci_proc_init() with
pci_lock_rescan_remove() to serialise against concurrent PCI bus
operations, add an early return in pci_proc_attach_device() when
dev->procent is already set to make the function idempotent, and clear
bus->procdir in pci_proc_detach_bus() to prevent use of a dangling pointer
after proc_remove().

Reported-by: Shuan He <heshuan@bytedance.com>
Closes: https://lore.kernel.org/linux-pci/20250702155112.40124-2-heshuan@bytedance.com/
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20260611150543.511422-1-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: PCI/proc race fix

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`, `make kernelversion` → `6.18.44`)

**Fix status in this tree:** The buggy code is present at HEAD; commit
`3ab0784441504` / upstream `8857f6578b001` is **not** an ancestor of
HEAD.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[PCI/proc]` `[Fix]` — race between `pci_proc_init()` and
`pci_bus_add_device()` during concurrent procfs entry creation.

### Step 1.2: Tags
**Record:**
- **Reported-by:** Shuan He \<heshuan@bytedance.com\> — real-world
  reporter
- **Closes:** https://lore.kernel.org/linux-
  pci/20250702155112.40124-2-heshuan@bytedance.com/ — original bug
  report thread
- **Signed-off-by:** Krzysztof Wilczyński, Bjorn Helgaas (PCI
  maintainer)
- **Link:** https://lore.kernel.org/r/20260611150543.511422-1-
  kwilczynski@kernel.org
- No `Fixes:` tag (expected for manual review)
- No `Cc: stable@vger.kernel.org` (expected)
- Ignore pipeline `Signed-off-by: Sasha Levin`

### Step 1.3: Body analysis
**Record:**
- **Bug:** Concurrent `pci_proc_attach_device()` calls can both see
  `bus->procdir == NULL`, both call `proc_mkdir()`; procfs rejects the
  duplicate with a WARN; the loser stores `NULL` into `bus->procdir`,
  overwriting a valid pointer.
- **Symptom:** `WARN(1, "proc_dir_entry '%s/%s' already registered\n",
  ...)` in dmesg; corrupted `bus->procdir`; missing/broken
  `/proc/bus/pci` entries.
- **Trigger (ARM64 DT):** PCI host bridges probe at `device_initcall`;
  with async probing, `pci_bus_add_device()` can run concurrently with
  `pci_proc_init()`; `pci_host_probe()` holds `pci_rescan_remove_lock`
  but `pci_proc_init()` did not.
- **Trigger (x86 ACPI):** Enumeration at `subsys_initcall` before proc
  init; `pci_proc_init()`'s `for_each_pci_dev()` loop lacked
  `pci_rescan_remove_lock`.
- **Root cause:** No serialization around lazy `bus->procdir` /
  `dev->procent` creation; unconditional assignment of failed
  `proc_mkdir()` result.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly described as a race/pointer-corruption bug
fix, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/pci/proc.c` only (+56 / -23 lines)
- **Functions modified/added:** `__pci_proc_attach_bus()` (new),
  `pci_proc_attach_device()`, `pci_proc_detach_device()`,
  `pci_proc_detach_bus()`, `pci_proc_init()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code flow changes
**Record:**
- **Hunk 1:** Add `pci_proc_lock` mutex.
- **Hunk 2:** Extract `__pci_proc_attach_bus()` — create bus proc dir in
  temp variable, assign to `bus->procdir` only on success; skip if
  already set.
- **Hunk 3:** `pci_proc_attach_device()` — take `pci_proc_lock`; early-
  return if `dev->procent` already set (idempotent); call
  `__pci_proc_attach_bus()`; assign `dev->procent` only on successful
  `proc_create_data()`.
- **Hunk 4:** `pci_proc_detach_device()` / `pci_proc_detach_bus()` —
  serialize under same mutex; clear `bus->procdir = NULL` after
  `proc_remove()`.
- **Hunk 5:** `pci_proc_init()` — init under `scoped_guard(mutex,
  &pci_proc_lock)`; wrap `for_each_pci_dev()` loop with
  `pci_lock_rescan_remove()` / `pci_unlock_rescan_remove()`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Race condition + pointer corruption
(reference/state bug).
- **Before:** Two threads could race on `bus->procdir`; loser's
  `proc_mkdir()` returned NULL (duplicate), stored unconditionally →
  valid pointer overwritten with NULL.
- **After:** Mutex serializes all proc attach/detach/init; pointer
  assigned only after successful creation; idempotent early returns
  prevent duplicate work.

Verified in `fs/proc/generic.c:403-416`: `proc_register()` returns NULL
on duplicate with `WARN(1, "proc_dir_entry '%s/%s' already
registered\n", ...)`.

### Step 2.4: Fix quality
**Record:** Fix is minimal, obviously correct, and follows existing PCI
patterns (`pci_lock_rescan_remove()`, `guard(mutex)` used elsewhere in
PCI). Low regression risk — adds a local mutex and tightens assignment
logic. `lockdep_assert_held()` documents locking expectations.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Lazy `bus->procdir = proc_mkdir(...)` pattern dates to
initial import (`1da177e4c3f41`, Linux 2.6.12-rc2). Race window widened
when `pci_proc_attach_device()` moved back to `pci_bus_add_device()` in
`ef37702eb3cae` (2013). Bug has been latent for years; practical trigger
on ARM64+async probe is newer.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent `drivers/pci/proc.c` changes are unrelated cleanups
(mmap, PDE_DATA removal). No duplicate fix in this tree. Fix commit
`3ab0784441504` exists on `autosel` branch but not in current HEAD.

### Step 3.4: Author context
**Record:** Krzysztof Wilczyński is an active PCI contributor/maintainer
(multiple PCI commits in this tree). Bjorn Helgaas committed the fix
upstream.

### Step 3.5: Dependencies
**Record:** Standalone — no series prerequisites.
- `guard(mutex)` / `scoped_guard` available via `#include
  <linux/module.h>` → `cleanup.h` (proc.c already includes module.h).
- `pci_lock_rescan_remove()` exists in `drivers/pci/probe.c` and is
  declared in `drivers/pci/pci.h`.
- Patch applies cleanly against current `drivers/pci/proc.c` at HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig -c 3ab0784441504:** https://patch.msgid.link/20260611150543.5
  11422-1-kwilczynski@kernel.org
- **Series revisions:** v1 (2026-04-30) → v2/v3 (2026-06-06) → v4
  (2026-06-11, committed version)
- Lore direct fetch blocked by bot protection; thread retrieved via `b4
  dig -m`.

### Step 4.2: Reviewers
**Record:** **b4 dig -w** CC'd: Bjorn Helgaas, Manivannan Sadhasivam,
Lorenzo Pieralisi, Ilpo Järvinen, Lukas Wunner, Shuan He (reporter),
linux-pci@vger.kernel.org — appropriate PCI maintainer coverage.

### Step 4.3: Bug report
**Record:** Reported-by Shuan He (Bytedance). Closes July 2025 lore
thread. WebFetch to lore blocked; bug mechanism and reporter confirmed
from commit message and mbox metadata.

### Step 4.4: Related patches
**Record:** Standalone v4 patch; no multi-patch series dependency.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found in retrieved mbox thread
(UNVERIFIED for broader stable@ search due to lore access limits).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `pci_proc_attach_device()`, `pci_proc_detach_device()`,
`pci_proc_detach_bus()`, `pci_proc_init()`, `__pci_proc_attach_bus()`.

### Step 5.2: Callers
**Record:**
- `pci_proc_attach_device()` called from `pci_bus_add_device()`
  (`drivers/pci/bus.c:358`) — normal device bring-up path.
- `pci_proc_init()` called via `device_initcall` at boot.
- Detach called from `drivers/pci/remove.c` on device/bus removal.
- `pci_bus_add_device()` reached from `pci_host_probe()` →
  `pci_bus_add_devices()` (`probe.c:3318-3320`, under
  `pci_lock_rescan_remove()`).

### Step 5.3: Callees
**Record:** `proc_mkdir()`, `proc_create_data()`, `proc_remove()`,
`proc_set_size()`, `pci_lock_rescan_remove()` /
`pci_unlock_rescan_remove()`.

### Step 5.4: Reachability
**Record:** Boot-time path on ARM64 DT systems with async device probing
— common production configuration. Also reachable during PCI
hotplug/rescan via `pci_bus_add_device()`. Requires `CONFIG_PROC_FS`
(proc.c is wrapped in `#ifdef CONFIG_PROC_FS` in `pci.h`).

### Step 5.5: Similar patterns
**Record:** No other lazy proc-dir creation races found in PCI code;
this is the sole attach point for PCI proc entries.

**Corruption consequence (verified):** If thread A sets `bus->procdir`
valid and thread B overwrites with NULL before A reads `bus->procdir`
for `proc_create_data()`, A passes NULL parent (`proc.c:441-442` at
HEAD). `proc_create_data()` passes parent to `proc_register()` without
NULL guard — potential oops during boot enumeration.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **YES.** At HEAD, `drivers/pci/proc.c:428-437` still has
unconditional `bus->procdir = proc_mkdir(...)` without locking.
`pci_proc_init()` at lines 464-472 lacks `pci_rescan_remove_lock`.
`pci_proc_detach_bus()` does not clear `bus->procdir`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** File structure matches the patch
base. No conflicting recent changes to proc attach logic.
`guard()`/`scoped_guard()` infrastructure present in 6.18.

### Step 6.3: Related fixes already present?
**Record:** **None.** `git merge-base --is-ancestor 3ab0784441504 HEAD`
→ fix NOT in HEAD. `git merge-base --is-ancestor 8857f6578b001 HEAD` →
upstream fix NOT in HEAD.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/pci** — IMPORTANT subsystem. Affects PCI
enumeration/procfs on all platforms with `CONFIG_PCI` +
`CONFIG_PROC_FS`.

### Step 7.2: Activity
**Record:** PCI subsystem actively maintained in 6.18; this is a
targeted fix to long-standing init-race code, not dead code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** ARM64 (and other DT) systems with PCI host controllers
probing at `device_initcall` and async probing enabled. Also any
platform where `pci_proc_init()` races with concurrent
`pci_bus_add_device()`. x86 less likely at boot but hotplug paths remain
relevant.

### Step 8.2: Trigger conditions
**Record:** Concurrent threads calling `pci_proc_attach_device()` for
devices on the same bus during boot init. Timing-dependent but realistic
with async probe. Unprivileged users cannot trigger at boot; hotplug
paths may be root-controlled.

### Step 8.3: Failure mode severity
**Record:**
- Kernel WARN during boot (verified procfs path)
- `bus->procdir` pointer corruption
- Missing `/proc/bus/pci/<bus>/<dev>` entries (tools relying on legacy
  PCI proc interface break)
- Potential NULL-parent `proc_create_data()` if corruption races with
  in-flight attach
- **Severity: HIGH** (pointer corruption + plausible crash during init)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents boot-time race, pointer corruption, and
  broken PCI procfs on affected platforms
- **Risk:** LOW — single-file mutex addition, well-reviewed, no API
  changes
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reported race with concrete dmesg symptom
- Pointer corruption of `bus->procdir` (kernel data structure
  corruption)
- Plausible crash path via NULL `bus->procdir` in `proc_create_data()`
- Small, single-file fix reviewed by PCI maintainer (Bjorn Helgaas)
- Buggy code confirmed present in Linux 6.18.44 tree
- v4 patch after 4 review iterations

**AGAINST backport:**
- Requires `CONFIG_PROC_FS` (most distro kernels have it)
- Timing-dependent race (but realistic on ARM64+async probe)
- Legacy `/proc/bus/pci` interface (less critical than sysfs) —
  mitigated by corruption severity

**Unresolved:** Full text of original Bytedance bug report (lore bot-
blocked); no explicit stable@ nomination found in thread.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mutex serialization +
   assign-on-success; reviewed by maintainer; reporter confirmed issue
2. Fixes a real bug affecting users? **PASS** — Bytedance report, ARM64
   DT boot path
3. Important issue? **PASS** — pointer corruption, WARN, possible init
   crash, broken procfs
4. Small and contained? **PASS** — 1 file, ~80 lines total
5. No new features/APIs? **PASS** — synchronization only
6. Can apply to local tree? **PASS** — code present, dependencies
   satisfied, clean apply expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs) — standard
bug-fix backport.

### Step 9.4: Decision rationale
This fix addresses a genuine initialization race in PCI procfs setup
that corrupts `bus->procdir` on a realistic ARM64+async-probe boot path.
The buggy code is present in this 6.18.44 tree, the fix is small and
self-contained, and the failure mode (pointer corruption, WARN, missing
proc entries, possible NULL deref) meets stable importance thresholds.

---

## Verification

- [Phase 1] Parsed subject, tags (Reported-by, Closes, Link, SOBs);
  ignored pipeline SOB
- [Phase 1] Identified explicit race/pointer-corruption bug from commit
  message
- [Phase 2] Read full diff from `git show 3ab0784441504`; confirmed 1
  file, +56/-23
- [Phase 2] Verified `proc_register()` duplicate behavior at
  `fs/proc/generic.c:403-416`
- [Phase 2] Verified current HEAD code at `drivers/pci/proc.c:419-476`
  lacks fix
- [Phase 3] `git blame -L 428,437`: lazy procdir pattern since 2.6.12
- [Phase 3] `git show ef37702eb3cae`: `pci_proc_attach_device` moved to
  `pci_bus_add_device()` in 2013
- [Phase 3] `git merge-base --is-ancestor 3ab0784441504 HEAD` → NOT in
  HEAD
- [Phase 3] `git merge-base --is-ancestor 8857f6578b001 HEAD` → upstream
  NOT in HEAD
- [Phase 4] `b4 dig -c 3ab0784441504` → lore URL found
- [Phase 4] `b4 dig -a` → v1–v4 series, v4 is committed version
- [Phase 4] `b4 dig -w` → PCI maintainers CC'd
- [Phase 4] `b4 dig -m /tmp/pci_proc_race.mbox` → thread saved
- [Phase 4] WebFetch lore URLs → blocked by bot protection (UNVERIFIED
  for inline thread text)
- [Phase 5] `grep pci_proc_attach_device` → caller
  `pci_bus_add_device()` at `bus.c:358`
- [Phase 5] `grep pci_host_probe` → `pci_lock_rescan_remove()` around
  `pci_bus_add_devices()` at `probe.c:3318-3320`
- [Phase 5] Verified `proc_create_data()` uses parent without NULL check
  (`generic.c:587-597`)
- [Phase 6] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 6] Confirmed buggy code present, fix absent at HEAD
- [Phase 6] Verified `guard(mutex)` available via `module.h` →
  `cleanup.h` include chain
- [Phase 6] Verified `pci_lock_rescan_remove()` exists and is used in
  PCI core
- [Phase 7] PCI subsystem classified IMPORTANT
- [Phase 8] Assessed severity HIGH based on pointer corruption +
  verified procfs/proc_create paths

**YES**The background git searches finished successfully.

They confirmed the fix exists as commit `3ab0784441504` (upstream
`8857f6578b001`) on the `autosel` branch, but it is **not** in your
current 6.18.44 HEAD — the race in `drivers/pci/proc.c` is still present
there.

**Verdict from the analysis: YES** — this should be backported to this
tree. It is a small, reviewed fix for a real boot-time race that can
corrupt `bus->procdir` on ARM64 systems with async probing.

 drivers/pci/proc.c | 79 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 9348a0fb80847..34fbacbafe919 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -18,6 +18,7 @@
 #include "pci.h"
 
 static int proc_initialized;	/* = 0 */
+static DEFINE_MUTEX(pci_proc_lock);
 
 static loff_t proc_bus_pci_lseek(struct file *file, loff_t off, int whence)
 {
@@ -416,40 +417,64 @@ static const struct seq_operations proc_bus_pci_devices_op = {
 
 static struct proc_dir_entry *proc_bus_pci_dir;
 
-int pci_proc_attach_device(struct pci_dev *dev)
+static int __pci_proc_attach_bus(struct pci_bus *bus)
 {
-	struct pci_bus *bus = dev->bus;
-	struct proc_dir_entry *e;
+	struct proc_dir_entry *dir;
 	char name[16];
 
+	lockdep_assert_held(&pci_proc_lock);
+
 	if (!proc_initialized)
 		return -EACCES;
 
-	if (!bus->procdir) {
-		if (pci_proc_domain(bus)) {
-			sprintf(name, "%04x:%02x", pci_domain_nr(bus),
-					bus->number);
-		} else {
-			sprintf(name, "%02x", bus->number);
-		}
-		bus->procdir = proc_mkdir(name, proc_bus_pci_dir);
-		if (!bus->procdir)
-			return -ENOMEM;
-	}
+	if (bus->procdir)
+		return 0;
+
+	if (pci_proc_domain(bus))
+		sprintf(name, "%04x:%02x", pci_domain_nr(bus), bus->number);
+	else
+		sprintf(name, "%02x", bus->number);
+
+	dir = proc_mkdir(name, proc_bus_pci_dir);
+	if (!dir)
+		return -ENOMEM;
+
+	bus->procdir = dir;
+
+	return 0;
+}
+
+int pci_proc_attach_device(struct pci_dev *dev)
+{
+	struct pci_bus *bus = dev->bus;
+	struct proc_dir_entry *entry;
+	char name[16];
+	int ret;
+
+	guard(mutex)(&pci_proc_lock);
+
+	if (dev->procent)
+		return 0;
+
+	ret = __pci_proc_attach_bus(bus);
+	if (ret)
+		return ret;
 
 	sprintf(name, "%02x.%x", PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
-	e = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR, bus->procdir,
-			     &proc_bus_pci_ops, dev);
-	if (!e)
+	entry = proc_create_data(name, S_IFREG | S_IRUGO | S_IWUSR,
+				 bus->procdir, &proc_bus_pci_ops, dev);
+	if (!entry)
 		return -ENOMEM;
-	proc_set_size(e, dev->cfg_size);
-	dev->procent = e;
+
+	proc_set_size(entry, dev->cfg_size);
+	dev->procent = entry;
 
 	return 0;
 }
 
 int pci_proc_detach_device(struct pci_dev *dev)
 {
+	guard(mutex)(&pci_proc_lock);
 	proc_remove(dev->procent);
 	dev->procent = NULL;
 	return 0;
@@ -457,19 +482,27 @@ int pci_proc_detach_device(struct pci_dev *dev)
 
 int pci_proc_detach_bus(struct pci_bus *bus)
 {
+	guard(mutex)(&pci_proc_lock);
 	proc_remove(bus->procdir);
+	bus->procdir = NULL;
 	return 0;
 }
 
 static int __init pci_proc_init(void)
 {
 	struct pci_dev *dev = NULL;
-	proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
-	proc_create_seq("devices", 0, proc_bus_pci_dir,
-		    &proc_bus_pci_devices_op);
-	proc_initialized = 1;
+
+	scoped_guard(mutex, &pci_proc_lock) {
+		proc_bus_pci_dir = proc_mkdir("bus/pci", NULL);
+		proc_create_seq("devices", 0, proc_bus_pci_dir,
+				&proc_bus_pci_devices_op);
+		proc_initialized = 1;
+	}
+
+	pci_lock_rescan_remove();
 	for_each_pci_dev(dev)
 		pci_proc_attach_device(dev);
+	pci_unlock_rescan_remove();
 
 	return 0;
 }
-- 
2.53.0

