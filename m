Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21B547255B;
	Mon, 31 Aug 2026 13:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184236; cv=none; b=Z+opKcLy28yVO8T36HseaGQWaQUe5fKUY6IXAl3m3UP2gBVqToADDdiu+3Np2gcJV3gJMKTVaxWk1w/aT5LmaCcEU+87u+yQtg70eUpBXHobxe4s0OQe2/ohSIbR/U86365vvFGzBEj8F5HWK3v6M06rwxd/OlHft3wDBgqevP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184236; c=relaxed/simple;
	bh=Xi1f2OHogCMZxpCGBaEWKW70YUD5mE+GL9T1H2jK7Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTl1e+LHiL3JB7tEQm1wT4TqpW9rZJ1DbxO6ZCnyz9apjNFkg4w11wQbfj70bKEX3pgfE1uRKdre/mhh0Lh06TqJzM296SBBObEdVr3z6WNbDnNEUF2sRBZDX6tVXOlQhQFujBzpJINbUDl6kFfR7UXS6rdKN9ByAlKuF5aB4xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q6+rNSiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q6+rNSiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEB51F00A3F;
	Mon, 31 Aug 2026 13:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184233;
	bh=ISmieA3cxTn7s+iQaLcJUsGULmiOIEuwAETcU4gkNw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6+rNSiuTEd6B51itj0Okth1HGST6KL9CmL5eIB/t6qD5H3nBHGnO4Je+PhyPBFHT
	 O60rYv8bBpL9claTyoWfXKp5FgOTTX2H7fBbJ78wScqXKQSmg7Ku1LJoRkPSTWzIih
	 NwVL9lp6BPZ/3rHKL5shzj7ZWUZMjzjdFcVPBD3eE5hhnFwKXAZZ6x46d/Ibn4uhec
	 /oXvdBkPIskDP0UM/eHced33eq/GeannBcItwHFx6aRQ/v0QHHU0FAJ3pEM7w8rIuO
	 zDNcO2rvTDXdtWhjf1umpqzRzp+yiiE8N+R3nsROBvqlcmexfu/c43vSSDjUOBgstH
	 HfTp/YkGj+gmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] nvme: fix crash and memory leak during invalid cdev teardown
Date: Mon, 31 Aug 2026 09:29:59 -0400
Message-ID: <20260831133314.4125787-571-sashal@kernel.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 26acdaa357cded33a37f575cd5f6bae1033b3a5d ]

In the NVMe multipath code, if nvme_add_ns_head_cdev() fails during
nvme_mpath_set_live(), the error is ignored. However, during teardown,
nvme_remove_head() unconditionally calls nvme_cdev_del(). This teardown
asymmetry leads to a kernel panic if the character device was never
successfully initialized.

BUG: kernel NULL pointer dereference, address: 00000000000000d0
 device_del+0x39/0x3c0
 cdev_device_del+0x15/0x50
 nvme_cdev_del+0xe/0x20 [nvme_core]
 nvme_mpath_shutdown_disk+0x38/0x60 [nvme_core]
 nvme_ns_remove+0x177/0x1f0 [nvme_core]
 nvme_remove_namespaces+0xdc/0x130 [nvme_core]
 nvme_do_delete_ctrl+0x71/0xd0 [nvme_core]

Additionally, a memory leak exists in the nvme_cdev_add() failure path.
Previously, dev_set_name() was called before ida_alloc(). If ida_alloc()
subsequently failed, device_initialize() was never called, meaning
put_device() could not be used to clean up the kobject, leaking the
memory allocated by dev_set_name().

*  Introduces the NVME_NSHEAD_CDEV_LIVE and NVME_NS_CDEV_LIVE bits to track
   the successful creation of the character devices. Teardown routines now
   check these bits before attempting deletion.
*  Refactor nvme_cdev_add() to accept the formatted device name as a
   parameter, moving dev_set_name() after the IDA allocation and
   immediately before device_initialize(). This ensures any internally
   allocated strings are safely cleaned up by put_device() upon failure.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `nvme: fix crash and memory leak during
invalid cdev teardown`

**Local tree:** Linux **6.18.44** (`stable/linux-6.18.y`, `HEAD`
detached at `1efe5d048a391`)

**Commit under review:** `26acdaa357cde` (on `master`, **not** in this
tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[nvme]` `[fix]` — crash and memory leak during invalid
character-device teardown in NVMe namespace cdev paths.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Maurizio Lombardi, Keith Busch (NVMe maintainer)

Notable: commit includes a concrete **BUG:** stack trace (NULL pointer
dereference). No syzbot report.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Teardown asymmetry in NVMe multipath — if
  `nvme_add_ns_head_cdev()` fails during `nvme_mpath_set_live()`, the
  error is ignored, but `nvme_remove_head()` unconditionally calls
  `nvme_cdev_del()`.
- **Symptom:** Kernel panic — NULL pointer dereference in `device_del()`
  during controller/namespace removal (`nvme_do_delete_ctrl` →
  `nvme_remove_namespaces` → `nvme_ns_remove` → multipath head removal).
- **Secondary bug:** Memory leak when `dev_set_name()` runs before
  `ida_alloc()` in the cdev-add path; if `ida_alloc()` fails,
  `device_initialize()` never runs and `put_device()` cannot free the
  kobject name.
- **Root cause:** No tracking of whether cdev creation actually
  succeeded; teardown assumes it did.
- **Version info:** None explicit in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly labeled as crash + memory leak
fix. The `nvme_cdev_add()` refactor is a real resource-management fix,
not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `drivers/nvme/host/core.c` | ~33 lines changed |
| `drivers/nvme/host/multipath.c` | ~19 lines changed |
| `drivers/nvme/host/nvme.h` | ~5 lines changed |

**Functions modified:** `nvme_cdev_add()`, `nvme_add_ns_cdev()`,
`nvme_ns_remove()`, `nvme_add_ns_head_cdev()`, `nvme_remove_head()`

**Scope:** Single-subsystem, surgical fix across 3 files (~57 lines
total). Not a refactor.

### Step 2.2: Code Flow Changes
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| `nvme_cdev_add()` | `ida_alloc` only; callers set name separately |
Accepts `name`, calls `dev_set_name()` after `ida_alloc`, before
`device_initialize()` |
| `nvme_add_ns_cdev()` / `nvme_add_ns_head_cdev()` | `dev_set_name()`
then `nvme_cdev_add()`; no success tracking | `snprintf` name, call
refactored `nvme_cdev_add()`, set `NVME_NS_CDEV_LIVE` /
`NVME_NSHEAD_CDEV_LIVE` on success |
| `nvme_ns_remove()` | Unconditionally `nvme_cdev_del()` for non-
multipath | Only if `NVME_NS_CDEV_LIVE` bit set |
| `nvme_remove_head()` | Unconditionally `nvme_cdev_del()` | Only if
`NVME_NSHEAD_CDEV_LIVE` bit set |

### Step 2.3: Bug Mechanism
**Record:**
- **Category (a):** Resource leak on error path — `dev_set_name()`
  before `ida_alloc()`/`device_initialize()`.
- **Category (d):** NULL pointer dereference — `nvme_cdev_del()` →
  `cdev_device_del()` → `device_del()` on uninitialized/failed cdev.
- **Category (g):** Logic/correctness — teardown does not match setup;
  success bit flags align init and teardown.

**Specific mechanism:** In current 6.18.44 code at
`multipath.c:794-801`, `NVME_NSHEAD_DISK_LIVE` is set after
`device_add_disk()` succeeds, then `nvme_add_ns_head_cdev(head)` is
called with **return value ignored**. On failure, `nvme_remove_head()`
at line 698 still calls `nvme_cdev_del()`.

### Step 2.4: Fix Quality
**Record:**
- Fix is obviously correct: only delete cdev when creation succeeded.
- Minimal, surgical; uses existing `flags` bitfields with free bit
  positions (2 and 6).
- Low regression risk: adds guards on teardown paths only; does not
  change successful init behavior.
- `nvme_cdev_add()` signature change is internal to `nvme_core` (no new
  userspace API).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `nvme_cdev_add()` / `nvme_add_ns_head_cdev()`: introduced in
  `2637baed7801` (Apr 2021, "introduce generic per-namespace chardev") —
  **present in this tree**.
- `nvme_remove_head()` unconditional `nvme_cdev_del`: `62188639ec160`
  (May 2025, delayed multipath head removal) — **present in this tree**.
- Stack trace references `nvme_mpath_shutdown_disk`; renamed to
  `nvme_mpath_remove_disk` in `9e221d8cf90b8` — **this tree uses
  `nvme_mpath_remove_disk`**.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag. Bug latent since cdev introduction
(2021); exposed by multipath head lifecycle code (2025).

### Step 3.3: Related File History
**Record:**
- Recent related fix: `3d8f35e182c80` "nvme-multipath: fix leak on
  try_module_get failure" — separate issue.
- Follow-up on master: `869567bcbe2dc` makes cdev-add functions return
  `void` (cleanup after this fix; **not a prerequisite**).
- Standalone fix; not part of a multi-patch dependency series.

### Step 3.4: Author Context
**Record:** Maurizio Lombardi — active NVMe contributor (nvme-tcp, nvme-
pci fixes). Keith Busch committed as NVMe maintainer. No indication this
is experimental.

### Step 3.5: Dependencies
**Record:** No prerequisites. All touched code exists in 6.18.44. `git
apply --check --3way` succeeds on this tree. Plain `git apply --check`
fails on `nvme.h` line offsets only (struct layout drift vs. mainline);
3-way merge applies cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c 26acdaa357cde`:
  https://patch.msgid.link/20260608155357.256966-1-mlombard@redhat.com
- Series: v1 (Jun 5) → v2 (Jun 8) → v3 (Jun 8); committed version
  matches v3.
- Lore thread content could not be fetched (Anubis bot protection on
  lore.kernel.org and patch.msgid.link).

### Step 4.2: Reviewers
**Record:** `b4 dig -w`: CC'd `kbusch@kernel.org`, `hch@lst.de`, `linux-
nvme@lists.infradead.org`, `dwagner@suse.de`. Keith Busch committed the
patch.

### Step 4.3: Bug Report
**Record:** Stack trace in commit message only. No external
bugzilla/syzbot link. Reproducible via cdev-add failure during multipath
namespace bring-up followed by controller removal.

### Step 4.4: Related Patches
**Record:** `869567bcbe2dc` on master is optional follow-up cleanup, not
required for correctness.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — could not search lore stable archive due to
fetch blocking. No evidence in this tree that the fix was already
backported.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `nvme_mpath_set_live()`, `nvme_add_ns_head_cdev()`,
`nvme_remove_head()`, `nvme_mpath_remove_disk()`, `nvme_ns_remove()`,
`nvme_add_ns_cdev()`, `nvme_cdev_add()`, `nvme_cdev_del()`.

### Step 5.2: Callers
**Record:**
- `nvme_mpath_set_live()` ← `nvme_mpath_add_disk()` ← namespace
  scan/alloc path (`core.c:4186`)
- `nvme_remove_head()` ← `nvme_mpath_remove_disk()` ← `nvme_ns_remove()`
  when last path removed (`core.c:4275-4276`)
- `nvme_ns_remove()` ← `nvme_remove_namespaces()` ←
  `nvme_do_delete_ctrl()` (controller delete/hot-unplug)
- `nvme_add_ns_cdev()` ← namespace alloc when not multipath
  (`core.c:4183-4184`)

### Step 5.3: Callees
**Record:** `device_add_disk()`, `dev_set_name()`, `ida_alloc()`,
`device_initialize()`, `cdev_device_add()`, `cdev_device_del()`,
`put_device()`, `del_gendisk()`.

### Step 5.4: Reachability
**Record:**
- **Crash path:** Controller removal / namespace teardown — common
  during driver unload, device hot-unplug, reset, or error recovery.
- Trigger requires `nvme_add_ns_head_cdev()` or `nvme_add_ns_cdev()`
  failure (memory pressure, `ida_alloc` exhaustion, `cdev_device_add`
  failure).
- Multipath crash path: `CONFIG_NVME_MULTIPATH=y`.
- Memory-leak fix: all configs using NVMe namespace cdevs.

### Step 5.5: Similar Patterns
**Record:** Same asymmetry in both multipath head cdev (`multipath.c`)
and per-namespace cdev (`core.c`). Fix addresses both consistently.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Verified in checkout:
- `multipath.c:801` — `nvme_add_ns_head_cdev(head)` with ignored return
- `multipath.c:698` — unconditional `nvme_cdev_del()`
- `core.c:4184` — `nvme_add_ns_cdev(ns)` with ignored return
- `core.c:4264` — unconditional `nvme_cdev_del()` for non-multipath
- `core.c:3876-3877` — `dev_set_name()` before `nvme_cdev_add()` (which
  does `ida_alloc` first internally, but caller already set name)

Bug introduced with cdev code in 2021; present throughout 6.18.y.

### Step 6.2: Backport Complications
**Record:** Minor line-offset drift in `nvme.h` vs. mainline (missing
`io_requeue_*` counters in 6.18). `git apply --check --3way` applies
cleanly. Expected difficulty: **clean apply with minor context
adjustment** if needed.

### Step 6.3: Fix Already Present?
**Record:** **NO.** `git merge-base --is-ancestor 26acdaa357cde HEAD`
returns exit code 1. No grep hits for `NVME_NSHEAD_CDEV_LIVE` or
`NVME_NS_CDEV_LIVE` in tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/nvme/` — **IMPORTANT** (block storage, widely
deployed; multipath used in enterprise/high-availability setups).

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y (recent multipath fixes in
2025–2026). Mature subsystem with ongoing lifecycle bug fixes.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:**
- **Crash:** Users with `CONFIG_NVME_MULTIPATH` who hit cdev creation
  failure during namespace bring-up, then remove controller/namespace.
- **Leak:** Any NVMe user where `dev_set_name` succeeds but subsequent
  `ida_alloc` or `cdev_device_add` fails.
- Population: storage/multipath deployments (RHEL, SLES, cloud block
  storage with multipath).

### Step 8.2: Trigger Conditions
**Record:**
- `ida_alloc()` failure under memory pressure (realistic).
- `cdev_device_add()` failure (less common but possible).
- Followed by controller delete / namespace removal (normal admin or
  error-recovery path).
- Unprivileged direct trigger: **no** (requires device admin/removal),
  but failure during init can be triggered by kernel memory pressure.

### Step 8.3: Failure Severity
**Record:**
- **Crash:** NULL pointer dereference → kernel oops/panic during
  teardown — **CRITICAL**
- **Leak:** kmemleak-reported kobject name leak on error path — **HIGH**
  (contributes to memory pressure)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents kernel panic on realistic error+teardown
  path; fixes resource leak.
- **Risk:** LOW — ~57 lines, guarded teardown only, no API changes,
  applies cleanly with 3-way merge.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes verified kernel panic (NULL deref) with stack trace
- Fixes memory leak on cdev-add error path
- Small, contained, obviously correct
- Buggy code confirmed present in 6.18.44
- Patch applies cleanly (3-way) to this tree
- NVMe maintainer (Keith Busch) committed
- Longstanding latent bug in production cdev/multipath code

**AGAINST backport:**
- Requires `CONFIG_NVME_MULTIPATH` for the primary crash scenario (but
  leak fix is broader)
- Trigger needs cdev-add failure (not everyday, but realistic under
  memory pressure)
- No explicit stable nomination found (UNVERIFIED due to lore fetch
  failure)

**Unresolved:** Full lore review thread content; whether distros already
carry an equivalent private fix.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is clear; v1→v3
review series; maintainer commit |
| 2. Fixes real bug affecting users? | **PASS** — panic + leak on NVMe
teardown |
| 3. Important issue? | **PASS** — CRITICAL crash, HIGH leak |
| 4. Small and contained? | **PASS** — 3 files, ~57 lines |
| 5. No new features/APIs? | **PASS** — internal flags + error-path fix
only |
| 6. Can apply to local tree? | **PASS** — 3-way apply clean |

### Step 9.3: Exception Categories
**Record:** None (standard bug fix, not device ID/quirk/DT/docs).

### Step 9.4: Decision Rationale
This commit fixes a real teardown asymmetry in NVMe multipath cdev
handling that causes a **kernel panic** when cdev creation fails but the
namespace head disk is live, plus a **memory leak** in the cdev-add
error path. The buggy code is present in Linux 6.18.44, the fix is small
and surgical, and it meets all stable-kernel criteria. The follow-up
commit making cdev functions return `void` is optional cleanup and not
required.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body; no Fixes/Reported-
  by/Cc:stable tags
- **[Phase 1]** Identified explicit BUG stack trace in commit message
- **[Phase 2]** Diff: 3 files, ~57 lines; flag bits + guarded teardown +
  `nvme_cdev_add()` refactor
- **[Phase 2]** Read current `multipath.c:689-703`,
  `multipath.c:794-801`, `core.c:3829-3883`, `core.c:4183-4184`,
  `core.c:4263-4264`
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame`: cdev code from `2637baed7801` (2021);
  `nvme_remove_head` from `62188639ec160` (2025)
- **[Phase 3]** `git log`: `9e221d8cf90b8` renamed
  `nvme_mpath_shutdown_disk` → `nvme_mpath_remove_disk`
- **[Phase 3]** `git merge-base --is-ancestor 26acdaa357cde HEAD`: exit
  1 (fix NOT in tree)
- **[Phase 3]** Related commit `3596a06583a16` (2021 put_device leak
  fix) is separate/prior issue
- **[Phase 3]** Follow-up `869567bcbe2dc` on master is optional, not
  prerequisite
- **[Phase 4]** `b4 dig -c 26acdaa357cde`: lore URL found
- **[Phase 4]** `b4 dig -a`: v1/v2/v3 series; v3 committed
- **[Phase 4]** `b4 dig -w`: NVMe maintainers CC'd
- **[Phase 4]** UNVERIFIED: lore thread content (Anubis blocked fetch)
- **[Phase 5]** Traced call chain: `nvme_mpath_set_live` → ignored
  failure → `nvme_ns_remove` → `nvme_mpath_remove_disk` →
  `nvme_remove_head` → `nvme_cdev_del`
- **[Phase 6]** Buggy code confirmed present in 6.18.44 checkout
- **[Phase 6]** `git apply --check --3way` on `26acdaa357cde`: applies
  cleanly
- **[Phase 6]** No `NVME_NSHEAD_CDEV_LIVE` / `NVME_NS_CDEV_LIVE` in
  current tree
- **[Phase 8]** Failure mode: NULL deref panic — CRITICAL; memory leak —
  HIGH

**YES**

 drivers/nvme/host/core.c      | 33 ++++++++++++++++++++++++---------
 drivers/nvme/host/multipath.c | 19 +++++++++++++------
 drivers/nvme/host/nvme.h      |  5 ++++-
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5ea331e933c55..de2f47d7ffd3d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3838,7 +3838,8 @@ void nvme_cdev_del(struct cdev *cdev, struct device *cdev_device)
 	put_device(cdev_device);
 }
 
-int nvme_cdev_add(struct cdev *cdev, struct device *cdev_device,
+int nvme_cdev_add(const char *name, struct cdev *cdev,
+		struct device *cdev_device,
 		const struct file_operations *fops, struct module *owner)
 {
 	int minor, ret;
@@ -3846,6 +3847,12 @@ int nvme_cdev_add(struct cdev *cdev, struct device *cdev_device,
 	minor = ida_alloc(&nvme_ns_chr_minor_ida, GFP_KERNEL);
 	if (minor < 0)
 		return minor;
+
+	ret = dev_set_name(cdev_device, name);
+	if (ret) {
+		ida_free(&nvme_ns_chr_minor_ida, minor);
+		return ret;
+	}
 	cdev_device->devt = MKDEV(MAJOR(nvme_ns_chr_devt), minor);
 	cdev_device->class = &nvme_ns_chr_class;
 	cdev_device->release = nvme_cdev_rel;
@@ -3883,15 +3890,21 @@ static const struct file_operations nvme_ns_chr_fops = {
 static int nvme_add_ns_cdev(struct nvme_ns *ns)
 {
 	int ret;
+	char name[32];
 
 	ns->cdev_device.parent = ns->ctrl->device;
-	ret = dev_set_name(&ns->cdev_device, "ng%dn%d",
-			   ns->ctrl->instance, ns->head->instance);
-	if (ret)
-		return ret;
+	snprintf(name, sizeof(name), "ng%dn%d", ns->ctrl->instance,
+		 ns->head->instance);
 
-	return nvme_cdev_add(&ns->cdev, &ns->cdev_device, &nvme_ns_chr_fops,
-			     ns->ctrl->ops->module);
+	ret = nvme_cdev_add(name, &ns->cdev, &ns->cdev_device,
+			    &nvme_ns_chr_fops, ns->ctrl->ops->module);
+	if (ret) {
+		dev_err(ns->ctrl->device, "Unable to create the %s device\n",
+			name);
+	} else {
+		set_bit(NVME_NS_CDEV_LIVE, &ns->flags);
+	}
+	return ret;
 }
 
 static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
@@ -4272,8 +4285,10 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	/* guarantee not available in head->list */
 	synchronize_srcu(&ns->head->srcu);
 
-	if (!nvme_ns_head_multipath(ns->head))
-		nvme_cdev_del(&ns->cdev, &ns->cdev_device);
+	if (!nvme_ns_head_multipath(ns->head)) {
+		if (test_and_clear_bit(NVME_NS_CDEV_LIVE, &ns->flags))
+			nvme_cdev_del(&ns->cdev, &ns->cdev_device);
+	}
 
 	nvme_mpath_remove_sysfs_link(ns);
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 616d1ce6b8e5c..d61c4e9543040 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -643,14 +643,20 @@ static const struct file_operations nvme_ns_head_chr_fops = {
 static int nvme_add_ns_head_cdev(struct nvme_ns_head *head)
 {
 	int ret;
+	char name[32];
 
 	head->cdev_device.parent = &head->subsys->dev;
-	ret = dev_set_name(&head->cdev_device, "ng%dn%d",
-			   head->subsys->instance, head->instance);
-	if (ret)
-		return ret;
-	ret = nvme_cdev_add(&head->cdev, &head->cdev_device,
+	snprintf(name, sizeof(name), "ng%dn%d", head->subsys->instance,
+		 head->instance);
+
+	ret = nvme_cdev_add(name, &head->cdev, &head->cdev_device,
 			    &nvme_ns_head_chr_fops, THIS_MODULE);
+	if (ret) {
+		dev_err(disk_to_dev(head->disk),
+			"Unable to create the %s device\n", name);
+	} else {
+		set_bit(NVME_NSHEAD_CDEV_LIVE, &head->flags);
+	}
 	return ret;
 }
 
@@ -695,7 +701,8 @@ static void nvme_remove_head(struct nvme_ns_head *head)
 		 */
 		kblockd_schedule_work(&head->requeue_work);
 
-		nvme_cdev_del(&head->cdev, &head->cdev_device);
+		if (test_and_clear_bit(NVME_NSHEAD_CDEV_LIVE, &head->flags))
+			nvme_cdev_del(&head->cdev, &head->cdev_device);
 		synchronize_srcu(&head->srcu);
 		del_gendisk(head->disk);
 	}
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 102fae6a231c5..2708003e5b40f 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -510,6 +510,7 @@ struct nvme_ns_head {
 	unsigned int		delayed_removal_secs;
 #define NVME_NSHEAD_DISK_LIVE		0
 #define NVME_NSHEAD_QUEUE_IF_NO_PATH	1
+#define NVME_NSHEAD_CDEV_LIVE		2
 	struct nvme_ns __rcu	*current_path[];
 #endif
 };
@@ -545,6 +546,7 @@ struct nvme_ns {
 #define NVME_NS_FORCE_RO		3
 #define NVME_NS_READY			4
 #define NVME_NS_SYSFS_ATTR_LINK	5
+#define NVME_NS_CDEV_LIVE		6
 
 	struct cdev		cdev;
 	struct device		cdev_device;
@@ -916,7 +918,8 @@ int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
 		void *log, size_t size, u64 offset);
 bool nvme_tryget_ns_head(struct nvme_ns_head *head);
 void nvme_put_ns_head(struct nvme_ns_head *head);
-int nvme_cdev_add(struct cdev *cdev, struct device *cdev_device,
+int nvme_cdev_add(const char *name, struct cdev *cdev,
+		struct device *cdev_device,
 		const struct file_operations *fops, struct module *owner);
 void nvme_cdev_del(struct cdev *cdev, struct device *cdev_device);
 int nvme_ioctl(struct block_device *bdev, blk_mode_t mode,
-- 
2.53.0

