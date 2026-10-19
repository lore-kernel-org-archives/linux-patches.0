Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FFD6167C4;
	Mon, 19 Oct 2026 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418650; cv=none; b=LOTxQhMZFpUQQjj361iM6aW6QaT/NZy5ArtCpUU22mn2otJG7tB5zTIZ4+KPd+xSOnLFUhbmbNAzcOOVBSYgrIaXfNDUAvTFGTTkzoAxppBB5uw/s43fjNHVIpDbrtMmvxlv0FOPnkLd1i4K1XwDDxS5Qb5lhjiwkOFtsVkdEZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418650; c=relaxed/simple;
	bh=d4KjLF+6Ky29BRDAE3GrCI48JQ++OwEMJQV3NzTurgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UluHfaDquCY0foHvPL8iA6SJLRqXnpPDONxWVcaRBgsiGXK00btKBDDlr7dwIOJDU981I55v6/duEOhrZWAOpsNpUYR9gg5Z/Nb4C9YnUpQYCnfH+H/EkwAPH9A77pLiuS2ZJVLq8SBpP1Cf98uyD/kmi9wTSlAveQPqECBYoVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPbvqWED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPbvqWED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9711F000C6;
	Mon, 19 Oct 2026 14:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418648;
	bh=xtfpE39WRfrVjcfSIGjhuyowlpgu8qhBwS2Mm5HbFwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPbvqWEDkNhBebSe2zm+/9xrECMJYF42+DhF0n4wwRgnHq3dNt4rzLZNvrCG/NNdP
	 yEki2+y/bu1JCoH8s9jLC4ql+GJYCeU1o5UB6+HCJPQSkXZUVg7keZd2y8aRYM02cQ
	 xznAeHQCtg80dRItisCR9Hhg+CvRCLG1mYHjH0PdMR+nTgWkMcbcPkY6XwAV1sCyyD
	 Pmdz4fyFY/nD5C0X3XlIuaivdB0xPZp487MYI79EmbvWnVzOT8EuLwdsSIqov9h6kD
	 5ZnF3fIQU92dPLoc4UlSEih6wqMkorjlVtrFJ0WlXSGOuP66snSYqGG8MQpG0JOx0z
	 YjD8NRAaXmF7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	axboe@kernel.dk,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] nvme: don't reference NS after unlocking in nvme_ns_head_ctrl_ioctl()
Date: Mon, 19 Oct 2026 09:51:29 -0400
Message-ID: <20261019135441.1420968-398-sashal@kernel.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 77c57daf98a2ad95ec9ac1371caeff8939cc1f58 ]

In nvme_ns_head_ctrl_ioctl(), once we drop the SRCU read lock we should
not reference the NS to lookup the controller, so use the available
controller pointer directly.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
candidate is a one-line use-after-unlock fix in the NVMe multipath ioctl
path; the rest of this write-up is the forensic check of whether that
fix belongs here as a stable backport.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[nvme] [don't reference] Avoid using the namespace object after
dropping the SRCU lock in nvme_ns_head_ctrl_ioctl()`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reviewed-by: Christoph Hellwig <hch@lst.de>` (NVMe co-maintainer)
- `Signed-off-by: John Garry <john.g.garry@oracle.com>` (author)
- `Signed-off-by: Keith Busch <kbusch@kernel.org>` (NVMe maintainer;
  applied the patch)
- No `Fixes:` tag (expected for this review pipeline)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:`, `Tested-by:`, `Link:`, or syzbot tags

Later mailing-list review also produced `Reviewed-by: Hannes Reinecke
<hare@kernel.org>` (not copied into the committed message).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** After `srcu_read_unlock(&head->srcu)`, the code still did
  `nvme_ctrl_ioctl(ns->ctrl, ...)`.
- **Symptom/failure mode:** Use of `ns` after the SRCU critical section
  ends. `nvme_find_path()` does not take an `ns` kref; SRCU is what
  keeps `ns` alive. After unlock, `nvme_ns_remove()` can finish
  `synchronize_srcu(&ns->head->srcu)` and `nvme_put_ns()` → `kfree(ns)`.
  Loading `ns->ctrl` is then a use-after-free.
- **Version info:** None in the message. History shows the pattern dates
  to `48145b62563a9` (v5.13-rc1 era, 2021).
- **Root cause:** The function already saved `struct nvme_ctrl *ctrl =
  ns->ctrl` and used it for `nvme_put_ctrl(ctrl)`, but the ioctl call
  still went through `ns->ctrl` after unlock.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. The subject is explicit. This is a real lifetime/UAF
fix, not style cleanup. The local `ctrl` variable existed specifically
to survive the unlock; the ioctl call was the leftover unsafe use.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/nvme/host/ioctl.c` — 1 insertion, 1 deletion
- Function: `nvme_ns_head_ctrl_ioctl()`
- Scope: single-file, one-line surgical fix under
  `CONFIG_NVME_MULTIPATH`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
Before:
```
struct nvme_ctrl *ctrl = ns->ctrl;
nvme_get_ctrl(ns->ctrl);          /* still under SRCU — OK */
srcu_read_unlock(&head->srcu, srcu_idx);
ret = nvme_ctrl_ioctl(ns->ctrl, ...);  /* ns used after unlock — BUG */
nvme_put_ctrl(ctrl);
```
After:
```
ret = nvme_ctrl_ioctl(ctrl, ...);  /* uses the pointer saved under SRCU
*/
```
The `nvme_get_ctrl()` before unlock keeps the controller object alive;
only the namespace object was left unprotected.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** use-after-free / lifetime (memory safety), SRCU
  protection dropped too early relative to `ns` use
- **Mechanism:** Path lookup is SRCU-only. Callers drop SRCU *on
  purpose* before controller ioctls so a Delete Namespace passthrough
  cannot deadlock on `synchronize_srcu` (comment at the
  `nvme_ns_head_ioctl` call site). Concurrent `nvme_ns_remove()` can
  then free `ns` while the old code still loaded `ns->ctrl`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: use the already-captured, refcounted `ctrl`.
- Minimal: one identifier change; no API, locking, or control-flow
  change.
- Regression risk: very low. `ctrl` is assigned under SRCU and pinned
  with `nvme_get_ctrl()` before unlock.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Buggy `nvme_ctrl_ioctl(ns->ctrl, ...)` after unlock introduced in
  `48145b62563a9` (`nvme: fix controller ioctl through ns_head`, Minwoo
  Im, 2021-04-22).
- First appeared around **v5.13** (`tags/v5.13-rc1~19^2~1^2~6`).
- `struct nvme_ctrl *ctrl = ns->ctrl` was added in that same commit —
  they saved `ctrl` for `nvme_put_ctrl()` but still passed `ns->ctrl`
  into the ioctl.
- The SRCU unlock in this function has been there since `3e7d1a55165bd`
  / the 2021 rewrite. This is long-lived buggy code, not a recent
  regression.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. The introducing commit is `48145b62563a9`, and
`git merge-base --is-ancestor 48145b62563a9 HEAD` succeeded, so the
buggy code is in this lineage.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Nearby John Garry commits (`627e8bb91a8fd` requeue/SRCU order,
  `a11e0a4cb4189` / `9952f3882ecba` cdev lifetime) are **separate**
  bugs. This diff does not depend on them.
- Not labeled `patch X/Y`. Standalone one-liner.
- Later `86f9536c2d8f4` only changes the sparse annotation `__releases`
  → `__releases_shared`; not a prerequisite.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: John Garry is a regular NVMe contributor (Oracle). Around this
date he also fixed related lifetime issues, but this patch is
independent. Maintainers Christoph Hellwig, Keith Busch, and Hannes
Reinecke all reviewed/acked it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. The preimage already has `ctrl`, `nvme_get_ctrl`, and
`srcu_read_unlock`. The patch applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 77c57daf98a2ad`: https://patch.msgid.link/20260706125402.61
  5277-1-john.g.garry@oracle.com
- `b4 dig -a`: **v1 only**; committed version is that v1.
- Thread (saved via `b4 dig -m`):
  - Christoph Hellwig: “Looks good:” + `Reviewed-by`
  - Keith Busch: “Thanks, applied to nvme-7.3.”
  - Hannes Reinecke: `Reviewed-by: Hannes Reinecke <hare@kernel.org>`
- No NAKs, no requests for a v2, no reviewer concern about the approach.
- No explicit `Cc: stable` in the thread (not a negative; this pipeline
  expects that).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc were `hch@lst.de`, `kbusch@kernel.org`,
`sagi@grimberg.me`, `axboe@fb.com`, `linux-nvme@lists.infradead.org`.
Subsystem maintainers were on the original mail and reviewed it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / syzbot / bugzilla. Found by code inspection
(same author was auditing NVMe lifetime vs SRCU around the same time).
The race is still concrete: ioctl + path removal.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not a numbered series. Sibling lifetime
patches are independent.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org `/stable/` returned HTTP 403 from this
environment. **UNVERIFIED:** no confirmed stable@ discussion. That is
expected for a candidate that has not been auto-selected.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

semcode MCP tools are not available; callers/callees were traced with
grep and file reads.

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `nvme_ns_head_ctrl_ioctl()` only.

**Step 5.2: TRACE CALLERS**
Record:
- `nvme_ns_head_ioctl()` — `block_device_operations.ioctl` for the
  multipath ns-head disk (`/dev/nvmeXnY`)
- `nvme_ns_head_chr_ioctl()` — `file_operations.unlocked_ioctl` for the
  generic ns-head char device (`/dev/ngXnY`)
Both call it when `is_ctrl_ioctl(cmd)` is true: `NVME_IOCTL_ADMIN_CMD`,
`NVME_IOCTL_ADMIN64_CMD`, or SED/opal ioctls.

**Step 5.3: TRACE CALLEES**
Record: `nvme_get_ctrl` / `nvme_put_ctrl` (`get_device`/`put_device` on
`ctrl->device`), `srcu_read_unlock`, `nvme_ctrl_ioctl` (admin
passthrough / SED).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace ioctl on a multipath NVMe ns-head device. Reachable
from userspace. Admin commands typically need privileges, but that does
not make a kernel UAF acceptable; privileged management tools and path
teardown are exactly the production workload.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Non-multipath `nvme_ioctl()` / `nvme_ns_chr_ioctl()` use
`ns->ctrl` without this SRCU drop; those `ns` objects are tied to the
open disk/cdev, so they are a different lifetime model. No second copy
of this exact post-unlock `ns->ctrl` load in `nvme_ns_head_ctrl_ioctl`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **7.3.0-rc4** (`git describe HEAD` =
  `v7.3-rc4-27-gf0100363d8c37`)
- `git merge-base --is-ancestor 77c57daf98a2ad HEAD` → yes (the fix is
  already on this mainline snapshot)
- Preimage (`77c57daf98a2ad^`) still has `nvme_ctrl_ioctl(ns->ctrl,
  ...)` after unlock
- Introducing commit `48145b62563a9` is an ancestor; the bug has been in
  this lineage since ~v5.13
- Current `ioctl.c` already uses `nvme_ctrl_ioctl(ctrl, ...)`

This is a mainline 7.3-rc checkout, not a 6.x.y stable branch. The
question is still whether the *fix* is stable-worthy for this codebase.
The touched function, the `ctrl` local, and the SRCU unlock are all
present. The bug was not introduced after this tree branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this code. The hunk is one argument change. Would
also apply cleanly to any tree that still has the 2021
`nvme_ns_head_ctrl_ioctl` shape (the `ctrl` local + post-unlock ioctl).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the fix. No alternate older fix of the same `ns->ctrl`
load. Related commits fix different lifetime bugs.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/nvme/host` — NVMe host ioctl/multipath. **IMPORTANT**
(common storage stack; not core mm/vfs, but widely deployed). Gated on
`CONFIG_NVME_MULTIPATH` (Kconfig: “If unsure, say Y.”).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active (io_uring passthrough, multipath, ioctl hardening). This
particular function body has been stable in shape since 2021.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: NVMe **multipath** users who issue controller ioctls on the ns-
head block or char device (`NVME_IOCTL_ADMIN_CMD` / `ADMIN64` / SED).
Datacenter NVMe-oF / dual-ported SSD setups.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- `srcu_read_lock` → `nvme_find_path` → controller ioctl →
  **intentional** `srcu_read_unlock` (to avoid deadlock with namespace
  delete) → old code loads `ns->ctrl`
- Concurrent `nvme_ns_remove()` (path loss, controller delete, admin
  Delete NS)
- Timing-dependent. Not every ioctl hits it; when it hits, it is a real
  UAF.
- Triggerable from userspace ioctl; typically privileged admin ioctls.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Use-after-free of `struct nvme_ns` → KASAN report / oops /
potential memory corruption. **Severity: HIGH** (UAF in a production
ioctl path).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** High — closes a UAF that has existed since v5.13 in a
  standard multipath ioctl path.
- **Risk:** Very low — one-line substitution of an already-saved,
  refcounted pointer.
- **Ratio:** Strongly favors backporting.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real UAF: `ns` is SRCU-protected only; used after `srcu_read_unlock`
- `nvme_find_path()` does not take an `ns` kref (verified)
- `nvme_ns_remove()` does `synchronize_srcu(&ns->head->srcu)` then
  `nvme_put_ns()` → `kfree(ns)` (verified)
- Callers drop SRCU early on purpose so namespace delete can proceed —
  the window is intentional
- One-line, obviously correct, uses the pointer the original 2021 code
  already saved
- Reviewed by Hellwig, Busch, Reinecke; applied to nvme-7.3
- Bug present since ~v5.13; no extra prerequisites
- Userspace-reachable ioctl on common NVMe multipath hardware

AGAINST:
- No crash log / syzbot in the commit message (inspection-found)
- No `Fixes:`/`Cc: stable` (expected here; not a reason to reject)
- Gated on `CONFIG_NVME_MULTIPATH`
- This 7.3-rc4 snapshot already contains the commit (it landed for 7.3);
  that does **not** reduce technical merit for selecting it as a stable
  candidate

UNRESOLVED:
- Could not fetch lore.kernel.org in the browser (403); thread was
  recovered via `b4 dig -m`
- Could not search lore `/stable/` (403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one identifier; reviewed by
   three NVMe maintainers
2. Fixes a real bug that affects users? **PASS** — UAF on ns-head
   controller ioctl vs path removal
3. Important issue (crash/security/corruption/deadlock)? **PASS** — UAF
   → oops/corruption; HIGH
4. Small and contained? **PASS** — 1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — function and `ctrl` local
   exist; hunk is the existing post-fix form

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a normal
memory-safety bugfix.

**Step 9.4: MAKE YOUR DECISION**
This is a textbook stable candidate: a long-standing, small, obviously
correct UAF fix in NVMe multipath ioctl handling, with maintainer review
and no dependencies.

---

### What the commit solves (for stable users)
On `CONFIG_NVME_MULTIPATH`, controller ioctls on the namespace-head
device drop `head->srcu` before running the ioctl so a Delete Namespace
passthrough cannot deadlock. The namespace pointer is not refcounted
across that unlock. Passing `ns->ctrl` into `nvme_ctrl_ioctl()` after
unlock can dereference a freed `nvme_ns` if a path is removed
concurrently. Using the `ctrl` pointer saved under SRCU (already pinned
with `nvme_get_ctrl()`) closes that hole.

### Risk vs benefit
Benefit is a UAF/crash fix on a real ioctl path used with NVMe
multipath. Risk is essentially nil.

### Concerns
None for applicability on this tree’s NVMe ioctl code. Nearby Garry
lifetime patches are not required.

---

Verification:
- [Phase 1] Parsed commit `77c57daf98a2ad`: subject, Hellwig Reviewed-
  by, Garry/Busch SOBs; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: only describes not using NS after SRCU unlock
- [Phase 2] `git show 77c57daf98a2ad`: 1 line in
  `nvme_ns_head_ctrl_ioctl`, `ns->ctrl` → `ctrl` after unlock
- [Phase 2] Read current `drivers/nvme/host/ioctl.c`: fix present;
  caller comment documents early SRCU drop to avoid delete-namespace
  deadlock
- [Phase 3] `git blame -L 729,743 drivers/nvme/host/ioctl.c`: buggy
  ioctl-through-ns-head from `48145b62563a9` (2021)
- [Phase 3] `git name-rev --tags 48145b62563a9`:
  `tags/v5.13-rc1~19^2~1^2~6`
- [Phase 3] `git merge-base --is-ancestor 48145b62563a9 HEAD`: yes
- [Phase 3] Parent `627e8bb91a8fd` is a different requeue/SRCU bug; not
  a dependency of this hunk
- [Phase 4] `b4 dig -c 77c57daf98a2ad`: lore at
  patch.msgid.link/20260706125402.615277-1-john.g.garry@oracle.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: linux-nvme + Hellwig/Busch/Grimberg/Axboe
- [Phase 4] `b4 dig -m /tmp/nvme-ns-unlock.mbox`: Hellwig R-b, Busch
  applied to nvme-7.3, Reinecke R-b; no NAK
- [Phase 4] WebFetch lore.kernel.org: 403 — UNVERIFIED via HTTP; thread
  recovered from mbox
- [Phase 5] grep: callers are `nvme_ns_head_ioctl` and
  `nvme_ns_head_chr_ioctl`; wired from `multipath.c` fops
- [Phase 5] `nvme_find_path()` returns path under SRCU only; no
  `nvme_get_ns()`
- [Phase 5] `nvme_free_ns()` kfree’s `ns`; `nvme_ns_remove()`
  synchronize_srcu then `nvme_put_ns()`
- [Phase 6] `make kernelversion` / Makefile: 7.3.0-rc4; `git describe
  HEAD`: v7.3-rc4-27-gf0100363d8c37
- [Phase 6] `git merge-base --is-ancestor 77c57daf98a2ad HEAD`: fix
  already in this mainline snapshot
- [Phase 6] Preimage `git show
  77c57daf98a2ad^:drivers/nvme/host/ioctl.c`: confirmed
  `nvme_ctrl_ioctl(ns->ctrl, ...)` after unlock
- [Phase 7] `drivers/nvme/host/Kconfig`: `NVME_MULTIPATH` “If unsure,
  say Y”
- [Phase 8] Failure mode: UAF of `struct nvme_ns` on controller ioctl vs
  path remove — HIGH
- UNVERIFIED: stable@ mailing-list history (lore /stable/ HTTP 403)
- UNVERIFIED: no public crash reproducer attached to the patch (does not
  override the verified lifetime hole)

The patch is obviously correct, fixes a real UAF, is one line, and
applies to this tree’s NVMe ioctl code.

**YES**

 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index fb8533127116a..b3e58de6f5cc5 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -727,7 +727,7 @@ static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
 
 	nvme_get_ctrl(ns->ctrl);
 	srcu_read_unlock(&head->srcu, srcu_idx);
-	ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp, open_for_write);
+	ret = nvme_ctrl_ioctl(ctrl, cmd, argp, open_for_write);
 
 	nvme_put_ctrl(ctrl);
 	return ret;
-- 
2.53.0

