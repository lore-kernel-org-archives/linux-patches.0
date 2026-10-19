Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74DC60405F;
	Mon, 19 Oct 2026 14:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418598; cv=none; b=YqIE5cUI1cKqw1YfbwnP9oSTJlYwflGfb+IaUaXneQHtvSonZ36MaAu6uRWN5Z5Ox4vGG4f2fGKLF41h+brI2etJsHiUQh0f0PUGxK/0dGehRW5B40O4/4ONa7Qxn8CcXWHOZ9OF0fhBfEwC1Kr1Ze3QfhU16W4XCby+saxJhb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418598; c=relaxed/simple;
	bh=YBo5zmd88spl13QBuS8ZcFRMMMHz5pOjOCoZNbVAQTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kjzVrlFqSHPVpNKxKGsDji+rTGE0Czd1t/S1f+jpC9SCD4oyeK7QSiEjIBMZay3PYoyzTllpAgGyJYFIVcfx28ykojjbowx/T+ixTcNzMPhhOlXYoaSueL++3sVIYM0yxz6xsXwJeA6pcdGUdLsLxrpIujVazsmDyzS6Yl6CRps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cmmg7EPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cmmg7EPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056B61F000C5;
	Mon, 19 Oct 2026 14:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418595;
	bh=D/nMetE7AC9AwvuL9ehIST2RhDWAAZmzIy6F26VmNhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cmmg7EPnPHvtjTYW13W85VjUkYLEbOMdZxb4vsdlWP2GIwBGwEYR2UsSQio/Ei7dj
	 lOc9gUCVegaei/qpIfWkUkZ3pbgR10PUv25jLmOpLouvzsmf+j2slIP/MeBc6ZSqHs
	 VKuKM9pYjXt8nC/l/klWDnq8aspjgA174yCO2MI0gqAIveXBiaz3K6nUwkzgIU1M5E
	 qaLALqRXPFacGihpP/mYTJ//RVpX5xjCwnreQ00C3VnokTqvQ38GgpTm3VnkkfQoHK
	 vYGf8he5SHJSEMgKB4nMHYphMQzeKbzfW8UvfAxq8qKfBUR1tjqyXjW9urzXHXoO3Z
	 IVbbHnJNpkDig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gabriel Prostitis <prostitisgabriel@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] USB: gadget: inode: fix mm lifetime handling
Date: Mon, 19 Oct 2026 09:50:51 -0400
Message-ID: <20261019135441.1420968-360-sashal@kernel.org>
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

From: Gabriel Prostitis <prostitisgabriel@gmail.com>

[ Upstream commit a1c33c80e11ecd5c3310a38c4be324095dd85ac5 ]

priv stores a pointer to the submitting task's mm_struct,
but does not currently hold a reference to it while async
requests are pending.

This can result in a use-after-free if the task exits before
completion handling finishes.

Take a reference with mmgrab() when queuing the read request
and release it with mmdrop() on request completion.

Reported-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Signed-off-by: Gabriel Prostitis <prostitisgabriel@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260601-mm-uaf-fix-v2-2-3c942a707bce@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[USB gadget / gadgetfs] [fix] [hold an `mm_struct` reference
for pending async endpoint I/O so completion cannot use a freed mm]**

- Subsystem prefix: `USB: gadget: inode:`
- Action verb: **fix**
- Intent: correct mm lifetime in the legacy gadgetfs AIO path

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Reported-by:** Gabriel Prostitis (author reported it)
- **Signed-off-by:** Gabriel Prostitis (author)
- **Acked-by:** Alan Stern (USB gadget reviewer)
- **Link:** https://patch.msgid.link/20260601-mm-uaf-
  fix-v2-2-3c942a707bce@gmail.com
- **Signed-off-by:** Greg Kroah-Hartman (USB maintainer; merged)
- **Fixes:** none (expected for this review path)
- **Cc: stable:** none (expected)
- Ignored pipeline markers: none in the real commit (`a1c33c80e11ec`)

Notable: single reporter (the author), but **Acked-by Alan Stern** and
merge by Greg KH. Cover letter (v2 0/2) states KASAN confirmed the UAF.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `kiocb_priv` stores `current->mm` while async USB requests
  are pending, with no `mm_count` pin.
- **Symptom / failure mode:** use-after-free if the submitting task
  exits before completion handling. Cover letter (lore): KASAN UAF in
  the workqueue path; possible **memory corruption in another process’s
  address space** if the freed `mm_struct` is reused. Trigger: async
  reads on OUT endpoints (io_uring called out for FunctionFS; gadgetfs
  has the same `read_iter` AIO path).
- **Version info:** none in the commit; buggy `priv->mm = current->mm`
  dates to 2013 (`a80bf61ef36da4`, contained in v3.10-rc1).
- **Root cause (author):** stored mm pointer without `mmgrab()`;
  completion uses it via `kthread_use_mm()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not hidden.** Subject and body are an explicit UAF/lifetime
fix. The extra `mmget_not_zero()` around `kthread_use_mm()` matches the
documented `mmgrab()` contract in `include/linux/sched/mm.h`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- **File:** `drivers/usb/gadget/legacy/inode.c` — **+13 / −4** (17 lines
  changed)
- **Functions:** `ep_user_copy_worker()`, `ep_aio_complete()`,
  `ep_aio()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
1. **`ep_aio()` (queue):** still stores `priv->mm = current->mm`; now
   **`mmgrab(priv->mm)`**. Fail path after that **`mmdrop(priv->mm)`**.
2. **`ep_aio_complete()` (USB complete, writes / zero-length reads):**
   completes immediately; now **`mmdrop(priv->mm)`** before freeing
   `priv`.
3. **`ep_user_copy_worker()` (async read copy):** previously
   `kthread_use_mm(mm)` on an unpinned pointer. Now `mmget_not_zero(mm)`
   → copy → `mmput` → always **`mmdrop(mm)`**. If the address space is
   already gone, return `-EFAULT` instead of touching a dying mm.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** use-after-free / reference counting
  (`mm_struct.mm_count` / `mm_users`)
- **Mechanism:** `priv->mm` was a raw pointer. `kthread_use_mm()` itself
  does `mmgrab(mm)` (`kernel/kthread.c`), which is a UAF if `mm` is
  already freed. Classic AIO `exit_aio()` does **not** cover io_uring.
  Cover letter: process exit while a request is pending frees mm while
  the worker still holds the pointer.
- **Fix:** pin with `mmgrab()` for the struct lifetime;
  `mmget_not_zero()` before using the address space, as documented.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct and matches
  `mmgrab()`/`mmget_not_zero()` docs. Refcounts are balanced: grab on
  queue; drop on fail, immediate complete, and worker.
- **Minimal:** no unrelated edits.
- **Regression risk:** low. Worst case after process exit is `-EFAULT`
  instead of a copy into a dead mm. No new API, no lock-order change.
  `mmgrab(NULL)` is not a realistic syscall path
  (`ep_read_iter`/`ep_write_iter` from userspace).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy store `priv->mm = current->mm` and worker: **`a80bf61ef36da4`**
  (“gadget: remove only user of aio retry”, Zach Brown, **2013-05-07**,
  **v3.10-rc1**).
- `kthread_use_mm`/`kthread_unuse_mm`: `f5678e7f2ac31c` (2020).
- Pattern has been in tree for many years, including this 7.3 checkout.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No `Fixes:` tag.** Not applicable. Introducer is
`a80bf61ef36da4`, present in this tree (blame on the parent of the fix).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Related: **`5eb5c72c72fef`** “USB: gadget: ffs: fix mm lifetime
  handling” (patch 1/2, parent of this commit). Different file
  (`f_fs.c`); **not a code dependency**.
- After this commit on `inode.c`: only `dd0eed9e165b1` (unrelated ioctl
  NULL deref).
- **Standalone** for gadgetfs.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Gabriel Prostitis has these two USB gadget mm-lifetime commits.
Not the subsystem maintainer. **Alan Stern Acked-by** on this inode
patch; Greg KH merged both.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Uses `mmgrab`/`mmdrop`/`mmget_not_zero`/`kthread_use_mm`, all
present here. No new helpers. Patch 1/2 is a sibling, not a
prerequisite. **Applies standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig:** https://patch.msgid.link/20260601-mm-uaf-
  fix-v2-2-3c942a707bce@gmail.com
- **Series:** v1 (2026-05-31), v2 (2026-06-01). v2 cover: “Fix swapped
  lines in `inode.c`”; v2 is what was merged.
- Cover letter: UAF in FunctionFS **and** gadgetfs; `kthread_use_mm()`
  in workqueue; KASAN; io_uring-style async read + exit; possible cross-
  process corruption.
- **No NAKs.** Ping 2026-06-30; Greg KH replied that the merge window
  delayed review, then merged 2026-07-10.
- **No explicit Cc: stable** in the thread (mbox).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: **b4 dig -w** recipients: author, Greg KH, linux-usb, linux-
kernel, **Alan Stern**. Stern’s Acked-by is on the inode.c patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: Author is the reporter. Cover letter cites KASAN on the
workqueue completion path. Direct lore HTTP fetches returned **403**;
thread body recovered via **`b4 dig -m`**.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: **v2 1/2** `USB: gadget: ffs: fix mm lifetime handling`
(`5eb5c72c72fef`) is the FunctionFS analogue. Independent file. This 2/2
is self-contained for gadgetfs.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search returned **403**. **UNVERIFIED**
whether stable@ discussed this. No Cc: stable on the patch itself (not a
negative signal here).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `ep_aio()`, `ep_aio_complete()`, `ep_user_copy_worker()`.
(semcode MCP not available.)

**Step 5.2: TRACE CALLERS**

Record:
- `ep_aio()` ← `ep_read_iter()` / `ep_write_iter()` when
  `!is_sync_kiocb(iocb)`
- Those are `ep_io_operations.read_iter` / `.write_iter` (gadgetfs
  endpoint files)
- `ep_aio_complete()` ← USB gadget `usb_request.complete` (often
  IRQ/softirq)
- `ep_user_copy_worker()` ← `schedule_work()` from that complete path

Reachable from **io_submit / io_uring** on gadgetfs endpoint fds, plus
USB completion.

**Step 5.3: TRACE CALLEES**

Record: `mmgrab`/`mmdrop`/`mmget_not_zero`/`mmput`,
`kthread_use_mm`/`kthread_unuse_mm`, `copy_to_iter`,
`usb_ep_queue`/`usb_ep_alloc_request`/`usb_ep_free_request`,
`ki_complete`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: userspace AIO/io_uring on gadgetfs ep file → `ep_aio` stores mm
→ USB complete → worker `kthread_use_mm` + `copy_to_iter`. **Userspace-
reachable** if gadgetfs is mounted and configured (typically privileged
USB gadget role).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same bug in `drivers/usb/gadget/function/f_fs.c`
(`io_data->mm`), fixed by sibling `5eb5c72c72fef`. Systematic copy of
the 2013 “stash mm, copy in worker” pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- **Tree:** `git describe HEAD` = **v7.3-rc4-27-gf0100363d8c37**; `make
  kernelversion` = **7.3.0-rc4**
- File and AIO path exist. Pre-fix code is in `a1c33c80e11ec^`.
  Introduced **v3.10** (`a80bf61ef36da4`). **Bug exists in this
  lineage.**
- `git merge-base --is-ancestor a1c33c80e11ec HEAD` → yes (used only to
  inspect the candidate, not as “already selected”).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply on this tree.** Surrounding code matches the diff.
`mmgrab`/`mmdrop`/`mmget_not_zero`/`kthread_use_mm` are present.
`inode.c` does not include `linux/sched/mm.h` directly; `mmgrab` is
visible via existing includes (e.g. `pagemap.h` → `mmap_lock.h` →
`sched/mm.h`) in **this** tree.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No earlier alternate gadgetfs mm-lifetime fix. Sibling
FunctionFS fix is separate. No competing fix for this inode.c UAF.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM**

Record: **USB gadgetfs** (`drivers/usb/gadget/legacy/`).
**IMPORTANT/PERIPHERAL:** not core mm/VFS, but a supported (non-staging)
USB gadget userspace API. FunctionFS is more common; gadgetfs is still
shipped and has the same UAF.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: File is mature (code from 2005–2013 with occasional fixes). Low
churn. Long-lived bug, not a brand-new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Config-specific / driver-specific:** `CONFIG_USB_GADGETFS`,
async I/O on gadgetfs endpoints, process exit before USB complete. Not
all machines, but real gadgetfs userspace drivers.

**Step 8.2: TRIGGER CONDITIONS**

Record: Async read (or write, for the pin) on a gadgetfs endpoint, then
the submitting task exits before `ep_aio_complete` / worker. Cover
letter: io_uring-style async + exit. Timing-dependent but realistic.
Typically needs gadgetfs access (usually privileged), **not** a random
unprivileged syscall on a default desktop.

**Step 8.3: FAILURE MODE SEVERITY**

Record: **Use-after-free of `mm_struct`** → KASAN crash or **cross-
process memory corruption**. **Severity: HIGH** (UAF / security-adjacent
corruption). Not a log-only issue.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit: HIGH** for gadgetfs AIO users — stops UAF/corruption.
- **Risk: LOW** — 13 insertions, 4 deletions, refcount pin matching
  documented API, Acked-by Stern.
- **Ratio:** benefit clearly outweighs risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real UAF of `mm_struct` when async gadgetfs I/O outlives the task
- Cover letter: KASAN; possible corruption of another process’s mm
- Small, contained, refcounts balanced
- Matches `mmgrab()` documentation
- Acked-by Alan Stern; merged by Greg KH
- Code and APIs exist in this v7.3-rc4 tree; bug dates to v3.10
- Standalone (patch 2/2 does not need 1/2)

**AGAINST:**
- Gadgetfs is a narrower, legacy userspace gadget API
- Trigger needs gadgetfs + async I/O + exit-before-complete
- No `Fixes:` / `Cc: stable` (not a negative for this process)

**UNRESOLVED:**
- lore.kernel.org HTTP 403; stable@ discussion not independently
  confirmed beyond the mbox from `b4 dig`
- No public syzbot hash in the commit (KASAN is from the cover letter)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — API-correct pin; v2 after a
   v1 line-swap mistake; Stern ack
2. Fixes a real bug that affects users? **PASS** — UAF on gadgetfs async
   completion
3. Important (crash, security, corruption, deadlock)? **PASS** — UAF /
   possible cross-process corruption (**HIGH**)
4. Small and contained? **PASS** — one file, +13/−4
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — context and helpers exist
   here

**Step 9.3: EXCEPTION CATEGORIES**

Record: none (not a device ID / quirk / DT / build / docs exception).
Qualifies as a normal important bugfix.

**Step 9.4: DECISION**

This is a small, reviewed UAF fix for code that exists in this tree.
Process exit during gadgetfs AIO can free `mm_struct` while
`ep_user_copy_worker()` still calls `kthread_use_mm()`. That is a real
stability/security bug, not cleanup. Risk of the pin itself is low.

### What the commit solves for this tree

`ep_aio()` saved `current->mm` without an `mm_count` reference.
Completion may run after the task is gone (especially io_uring, which is
not `exit_aio()`). The worker then used a dangling `mm_struct`. Pinning
with `mmgrab()` and using `mmget_not_zero()` before the copy closes that
window.

### Risk vs benefit

Benefit is preventing kernel UAF/corruption on a reachable gadgetfs AIO
path. Risk is a few refcount operations on a slow path. No structural or
API change.

### Concerns

Patch 2/2 of a series, but independent of FunctionFS. v1 had swapped
lines; merged v2 is the one to use. Direct lore HTTP was blocked;
discussion was recovered with `b4 dig -m`.

---

### Verification
- **[Phase 1]** `git log -1 a1c33c80e11ec`: subject/tags as above; no
  Fixes/Cc:stable
- **[Phase 2]** `git show a1c33c80e11ec`: +13/−4 in `inode.c`; mmgrab on
  queue; mmdrop on fail, immediate complete, and worker; mmget_not_zero
  around copy
- **[Phase 2]** Read `ep_aio`/`ep_aio_complete`/`ep_user_copy_worker` in
  this tree: refcounts balanced
- **[Phase 2]** `include/linux/sched/mm.h`: mmgrab docs require
  mmget_not_zero before using the address space
- **[Phase 2]** `kernel/kthread.c` `kthread_use_mm()`: mmgrab on the
  passed mm — UAF if mm already freed
- **[Phase 3]** `git blame` on parent: `priv->mm` from `a80bf61ef36da4`
  (v3.10-rc1, 2013)
- **[Phase 3]** `git describe --contains a80bf61ef36da4` →
  `v3.10-rc1~50^2~20`
- **[Phase 3]** Sibling `5eb5c72c72fef` is f_fs.c only; not required for
  inode.c
- **[Phase 3]** `git log --author="Gabriel Prostitis" -- drivers/usb/`:
  only these two mm-lifetime commits
- **[Phase 3]** `git merge-base --is-ancestor a1c33c80e11ec HEAD`: is
  ancestor (inspection only)
- **[Phase 4]** `b4 dig -c a1c33c80e11ec`: v2 2/2 lore URL
- **[Phase 4]** `b4 dig -a`: v1 then v2; v2 cover notes inode.c swapped-
  line fix
- **[Phase 4]** `b4 dig -w`: Greg KH, linux-usb, Alan Stern
- **[Phase 4]** `b4 dig -m /tmp/gadget-mm-uaf.mbox`: KASAN, io_uring
  trigger, cross-process corruption; Stern ack; no NAK; Greg delay-then-
  merge
- **[Phase 4]** WebFetch/curl lore: **403** — UNVERIFIED via HTTP; mbox
  used instead
- **[Phase 4]** stable@ search: **403** — UNVERIFIED
- **[Phase 5]** grep: `ep_aio` only from `ep_read_iter`/`ep_write_iter`;
  those are `ep_io_operations`
- **[Phase 5]** Same mm stash in `f_fs.c`, fixed separately
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: **v7.3-rc4**
  / **7.3.0-rc4**
- **[Phase 6]** Buggy path present before `a1c33c80e11ec`; helpers
  present
- **[Phase 7]** `USB_GADGETFS` in `drivers/usb/gadget/legacy/Kconfig`
- **[Phase 8]** Failure mode: mm UAF → oops or cross-process corruption;
  HIGH
- **UNVERIFIED:** whether stable@ already discussed this (lore 403); no
  syzbot ID in the commit

**YES**

 drivers/usb/gadget/legacy/inode.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 7c72267c0c53b..a46b6a6b1f836 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -473,11 +473,17 @@ static void ep_user_copy_worker(struct work_struct *work)
 	struct kiocb *iocb = priv->iocb;
 	size_t ret;
 
-	kthread_use_mm(mm);
-	ret = copy_to_iter(priv->buf, priv->actual, &priv->to);
-	kthread_unuse_mm(mm);
-	if (!ret)
+	if (mmget_not_zero(mm)) {
+		kthread_use_mm(mm);
+		ret = copy_to_iter(priv->buf, priv->actual, &priv->to);
+		kthread_unuse_mm(mm);
+		mmput(mm);
+		if (!ret)
+			ret = -EFAULT;
+	} else {
 		ret = -EFAULT;
+	}
+	mmdrop(mm);
 
 	/* completing the iocb can drop the ctx and mm, don't touch mm after */
 	iocb->ki_complete(iocb, ret);
@@ -503,6 +509,7 @@ static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
 	 * complete the aio request immediately.
 	 */
 	if (priv->to_free == NULL || unlikely(req->actual == 0)) {
+		mmdrop(priv->mm);
 		kfree(req->buf);
 		kfree(priv->to_free);
 		kfree(priv);
@@ -543,6 +550,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 	priv->epdata = epdata;
 	priv->actual = 0;
 	priv->mm = current->mm; /* mm teardown waits for iocbs in exit_aio() */
+	mmgrab(priv->mm);
 
 	/* each kiocb is coupled to one usb_request, but we can't
 	 * allocate or submit those if the host disconnected.
@@ -572,6 +580,7 @@ static ssize_t ep_aio(struct kiocb *iocb,
 
 fail:
 	spin_unlock_irq(&epdata->dev->lock);
+	mmdrop(priv->mm);
 	kfree(priv->to_free);
 	kfree(priv);
 	put_ep(epdata);
-- 
2.53.0

