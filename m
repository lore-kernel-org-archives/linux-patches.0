Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4135527FC3;
	Mon, 19 Oct 2026 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418575; cv=none; b=Sv5lrJyUFPUmo99ap/zEPVZzP5CXBg1T5iaX77yaKUvIgLUn8gFnbFXoOF1iYPnuA4su68hO0773aukZgZgBKElIkDz6/CtsFnu/d1vGOtsiwBzBODstM/Cs4ELQFeita+14Bm8EyUj1WS/7IJBSbBLEH3HTc8SB0Yt0tX4BljM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418575; c=relaxed/simple;
	bh=Y/neO6EHFGwLh8pa7B+NVwTUEpf8aC70WWbL/TXYEYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckpivZsl13UofIG0Tp2VSZrQRjHvh6mAlIoB/Yp4tLNv1mmjG3xe0V5x0sUA4Fn4nFUfnIq+NH9GH2Zo5jLyRNmNSZtmtSR4UdoIXyvmTYAZqUoGbbbTUi7dYahD6EkmaTJ23wtx9g75owOkIrB0mrVopA6WAeM2u8lgwCGt3uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXEwnaul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXEwnaul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CBA1F000C7;
	Mon, 19 Oct 2026 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418572;
	bh=+O0pLDWiJaBqFJBeOjOY6kMwYvWyU4+xf8Id2PyVxzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXEwnaulby7pQ0lJjm6NBmS7obAPyWm0JY7/jnMtDIbnrClXCxq6OVY2GaUx7ccR5
	 erm3pxebsEUAXcXjYz6Fu16Kwvyc0QuFm7RjoEpkn00XkvzFG46f/e/WcSMJBQZ4MT
	 ZI+Df1goPTxYUfhWh7pqq04gpdiOkoI3vL1eIROYP6JptzNz/p44epl1xIilekPiK4
	 IvVWql1NJ47z1WrSbIAnnwOFDUKvlvh2auX4isE/NwKGq9LxP3mZZ3EH+yOn/ALP7b
	 K7wQCE/9w3HSIrQNPCfjHJW3oEKa2C4eBhRY8ODsIabGLLhbsD+PjIQGZf5VdBN/Ep
	 U8rzSK5lMkRcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	scott.branden@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] misc: bcm-vk: validate write size before allocation
Date: Mon, 19 Oct 2026 09:50:34 -0400
Message-ID: <20261019135441.1420968-343-sashal@kernel.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit f66c40cd90954f52809b3eabd386137f56bb6215 ]

bcm_vk_write() uses the user-supplied write count to size a
flexible-array work entry and then copies count bytes into that array.
The allocation expression is evaluated before any overflow check, so a
very large count can wrap the allocation smaller than the subsequent
copy.

Reject empty writes, check the allocation arithmetic before kzalloc(),
and initialize the __counted_by field before copying into to_v_msg[].

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260629160605.29412-1-alhouseenyousef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Subsystem: `misc: bcm-vk`
- Action: **validate** (pre-check / prevent)
- Claimed intent: reject a user-controlled write length that is used as
  an allocation size before the copy.

Record: `[misc/bcm-vk] [validate] [check write count before sizing the
work-entry allocation]`

**Step 1.2: Tags**
- `Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260629160605.29412-1-
  alhouseenyousef@gmail.com`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  (char-misc maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence of the last two is expected in this
  pipeline)
- Sasha Levin SOB is not present on the real commit `f66c40cd90954`

Record: Author SOB + Greg SOB + msgid Link. No syzbot, no Fixes, no
stable CC.

**Step 1.3: Body**
`bcm_vk_write()` sizes a flexible-array work entry with the user
`count`, then `copy_from_user()`s `count` bytes into it. The sum
`sizeof(*entry) + count + vk->ib_sgl_size` is evaluated with wrapping C
addition **before** any overflow check, so a huge `count` can make
`kzalloc()` allocate less than `count`, and the copy overruns the slab
object.

The patch: reject `count == 0`, check the two additions with
`check_add_overflow()` before `kzalloc()`, and set `to_v_blks` (the
`__counted_by` field) before the copy.

Record:
- Bug: integer wrap of allocation size vs subsequent copy length
- Symptom: heap buffer overflow (or HARDENED_USERCOPY abort) on
  `write()`
- Version info: none in the message
- Root cause: unchecked `size_t` addition of a user length

**Step 1.4: Hidden bug fix?**
Not hidden. The subject says “validate”; the body describes wrap, then
copy. The empty-write reject and `__counted_by` move are the same write
path, not a cleanup-only change.

Record: Explicit memory-safety fix, not disguised cleanup.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- File: `drivers/misc/bcm-vk/bcm_vk_msg.c` (+12 / −6; `git show --stat`
  reports 18 lines changed)
- Include: `#include <linux/overflow.h>`
- Function: `bcm_vk_write()` only (the `bcm_vk_msg_init` hunk in the
  prompt is context-only; no functional change there)

Record: Single-file surgical fix in one syscall handler.

**Step 2.2: Code flow**
Before (verified on `f66c40cd90954^`):
1. Reject `count` not a multiple of 16 (`VK_MSGQ_BLK_SIZE`).
2. `kzalloc(sizeof(*entry) + count + vk->ib_sgl_size, GFP_KERNEL)` with
   wrapping add.
3. `copy_from_user(&entry->to_v_msg[0], buf, count)`.
4. Then `entry->to_v_blks = count >> 4`, then a **later** msgq-size
   check.

After:
1. Also reject `count == 0`.
2. `check_add_overflow(sizeof(*entry), count, &entry_size)` then add
   `vk->ib_sgl_size`; fail with `-EOVERFLOW`.
3. `kzalloc(entry_size)`.
4. Set `to_v_blks` **before** the copy.
5. Same copy and later msgq check.

Record: Normal `write()` path; hardening of alloc + copy, not an error-
path-only change.

**Step 2.3: Bug mechanism**
- Category: **integer overflow → heap buffer overflow** (also
  `__counted_by` / bounds-sanitizer correctness).
- User `count` is only required to be a multiple of 16. Near `SIZE_MAX`,
  the sum wraps to a small size, `kzalloc` succeeds, then
  `copy_from_user` uses the original huge `count`. The first mapped user
  page(s) are enough to overflow the slab object before the copy hits
  `-EFAULT`.
- The msgq bound is **after** the copy, so it does not prevent the
  overflow.
- `to_v_msg[]` is `__counted_by(to_v_blks)` in this tree. `kzalloc`
  leaves `to_v_blks == 0`, so the copy used to write into a counted-by-
  zero flexible array.

Record: Alloc-size wrap + copy; `__counted_by` initialized too late.

**Step 2.4: Fix quality**
- Obviously correct: standard `check_add_overflow` + allocate checked
  size.
- Minimal; no API/structure change.
- Regression risk: low. `-EOVERFLOW` / `-EINVAL` for impossible sizes.
  Rejecting `count == 0` is reasonable (zero-length messages are not a
  multiple of a useful blk payload). `check_add_overflow` is an existing
  helper.

Record: High quality, low regression risk.

---

## Phase 3: Git history

**Step 3.1: Blame / introduction**
- Driver messaging (including this alloc+copy) landed in `111d746bb4767`
  (“misc: bcm-vk: add VK messaging support”), contained in `v5.12-rc1`.
- `__counted_by` on `struct bcm_vk_wkent`: `3c69d52e3e12f` (contained in
  `v6.7-rc1`).
- Parent of the fix still had the wrapping `kzalloc` expression.

Record: Buggy alloc/copy since v5.12; counted-by issue since v6.7.

**Step 3.2: Fixes: tag**
None. Ancestor of the bug is `111d746bb4767`, and `git merge-base --is-
ancestor 111d746bb4767 HEAD` is true.

**Step 3.3: File history**
Recent bcm-vk work is mostly style, kmalloc_obj conversion, an
acquire/release change, and this overflow check. No prerequisite series
for this hunk. Standalone.

**Step 3.4: Author**
Yousef Alhouseen also has nearby misc overflow/bounds patches (`hpilo`,
`ibmvmc`, `xilinx_sdfec`, `genwqe`, `sgi-gru`) merged the same day by
Greg. Not the bcm-vk maintainer; a correctness/security sweep. Greg
still took the patch.

**Step 3.5: Dependencies**
- `check_add_overflow()` / `linux/overflow.h`: present in this tree
  (helpers date to 2018).
- `__counted_by` field exists here; moving `to_v_blks` does not need
  extra commits.
- Applies standalone.

Record: No missing prerequisites in this checkout.

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
`b4 dig -c f66c40cd90954` matched msgid
`20260629160605.29412-1-alhouseenyousef@gmail.com`.
`b4 dig -a`: **v1 only**, 2026-06-29.
Saved mbox: **one message** (the patch). No replies, NAKs, or reviewer
comments in that thread. Greg applied it to char-misc.

Direct lore HTTP fetch returned 403; discussion content was taken from
the b4 mbox instead.

**Step 4.2: Recipients (`b4 dig -w`)**
- Maintainer: Scott Branden
- Broadcom internal list
- Arnd Bergmann
- Greg Kroah-Hartman
- linux-kernel@vger.kernel.org

Right lists/people were CCed. No `Reviewed-by` on the committed patch.

**Step 4.3: Bug report**
No `Reported-by` / syzbot / bugzilla. Trigger needs `/dev/bcm-vk.N` (PCI
device), so syzbot is unlikely.

**Step 4.4: Series**
Standalone `[PATCH]`, not N/M.

**Step 4.5: Stable list**
Web search did not turn up a stable@ discussion of this subject.
Unverified beyond that (lore search HTTP 403).

Record: v1, maintainer-tree merge, no NAK, no explicit stable nomination
in the thread.

---

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
`bcm_vk_write()` only.

**Step 5.2: Callers**
Wired as `.write = bcm_vk_write` in `bcm_vk_fops` (`bcm_vk_dev.c`). That
is the miscdevice `write()` path. Reachable from the `write` syscall on
`/dev/bcm-vk.N`.

**Step 5.3: Callees**
`bcm_vk_drv_access_ok`, `kzalloc`, `copy_from_user`, later `get_q_num`,
msgq `readl`, `bcm_vk_get_msg_id`. The overflow is **before** queue/id
logic.

**Step 5.4: Reachability**
1. PCI probe of Broadcom Valkyrie (`PCI_DEVICE_ID_VALKYRIE` 0x5e87)
   registers the misc device.
2. `bcm_vk_drv_access_ok()` requires `msgq_inited` (card messaging up);
   otherwise `-EPERM`.
3. Then user `write()` with a 16-aligned huge length hits the wrap.

Userspace-reachable on systems that have this card and a live msgq.

**Step 5.5: Similar patterns**
Same author’s same-day misc write/size checks. Same class of bug, not a
bcm-vk-only refactor.

Record: Syscall-reachable heap overflow on a real device node.

---

## Phase 6: This checkout

**Step 6.1: Local tree**
- `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion`: `7.3.0-rc4`
- Makefile: VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4
- Driver, `bcm_vk_write()`, `check_add_overflow`, and `__counted_by` are
  all present.
- `git merge-base --is-ancestor f66c40cd90954 HEAD` is true (current
  `bcm_vk_write()` already has the checks). That is not used as “already
  selected for stable”; it only confirms the code this patch targets
  exists here.

Record: Buggy path exists in this lineage since v5.12; this tree is
7.3-rc4 and has the helpers the patch needs.

**Step 6.2: Backport difficulty**
Against this tree: clean (the hunk matches current code). `overflow.h`
is already used by the patched file.

**Step 6.3: Other fixes for the same bug**
No earlier overflow check on this alloc. No competing fix.

---

## Phase 7: Subsystem context

**Step 7.1**
- Subsystem: `drivers/misc/bcm-vk` (Broadcom VK PCIe accelerator,
  video/crypto offload).
- Criticality: **PERIPHERAL** hardware, but the handler is a generic
  `write()` with a kernel heap overflow.

**Step 7.2**
Mature driver (v5.12). Low churn besides treewide kmalloc conversions
and this safety patch. Maintainer status: Supported (Scott Branden).

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Users of Broadcom VK (`CONFIG_BCM_VK`, PCI 14e4:5e87). Not universal.
Device node is a miscdevice; `.mode` is unset, so default char-dev
permissions (typically root/udev). Anyone who can open the node can
issue the `write()`.

**Step 8.2: Trigger**
- Hardware present, driver loaded, msgq initialized.
- `write(fd, buf, count)` with `count` a non-zero multiple of 16 large
  enough to wrap `sizeof(*entry) + count + ib_sgl_size` (`ib_sgl_size`
  default 16×16 = 256).
- Not every boot; it is a deliberate/malicious or buggy huge write, not
  a typical message size.
- Unprivileged only if udev grants the node; otherwise local
  privileged/compromised userspace with device access.

**Step 8.3: Failure mode**
Heap overflow of a `kzalloc` object, or `usercopy` abort if
HARDENED_USERCOPY is on. Severity: **HIGH** (memory corruption / crash).
Security-relevant if the node is writable.

**Step 8.4: Risk vs benefit**
- Benefit: stops a user-controlled wrap-and-copy; also makes
  `__counted_by` consistent before the copy.
- Risk: ~12 insertions in one function; overflow helpers already in this
  tree.
- Ratio: high benefit / very low risk for this tree.

---

## Phase 9: Synthesis

**Evidence FOR**
- Real wrap of `kzalloc` size vs `copy_from_user` length; msgq check is
  too late.
- Syscall-reachable (`write` on `/dev/bcm-vk.N`).
- Small, obviously correct, uses existing `check_add_overflow`.
- Merged by Greg KH; CCed to the bcm-vk maintainer.
- Driver and helpers exist in this 7.3-rc4 tree.
- `__counted_by` init-before-copy is required in this tree.

**Evidence AGAINST**
- Niche PCIe accelerator, not a core-path bug.
- No reporter, syzbot, Fixes, or stable CC.
- No mailing-list review comments (v1 applied as-is).
- Author is not the subsystem maintainer (audit-style series).

**Unresolved**
- Full lore HTML was 403; thread content is from `b4 dig -m` (single
  email).
- No stable@ discussion found.

**Stable rules**
1. Obviously correct and tested — **PASS** (standard overflow check;
   merged to char-misc). No extra Tested-by.
2. Real bug affecting users — **PASS** (heap overflow on write for VK
   users).
3. Important (crash/security/corruption) — **PASS** (HIGH: heap smash /
   usercopy BUG).
4. Small and contained — **PASS** (one function, ~12 lines).
5. No new features/APIs — **PASS**.
6. Can apply to this tree — **PASS** (`overflow.h`, `bcm_vk_write`,
   `__counted_by` all present).

**Exception category:** none (not an ID/quirk/DT/build/doc exception).
It is a normal memory-safety fix.

This tree is **7.3.0-rc4**. The driver has had this alloc+copy since
v5.12. The patch is a contained security/correctness fix and belongs
here.

---

## What the commit solves for this tree

`bcm_vk_write()` trusted a user `size_t count` in
`kzalloc(sizeof(*entry) + count + vk->ib_sgl_size)` and then copied
`count` bytes. A 16-aligned huge count wraps the size, allocates a small
object, and overflows it on copy. The later queue-size check does not
run first. The fix checks the arithmetic, rejects empty writes, and sets
`to_v_blks` before touching `to_v_msg[]`.

It matches stable rules: real overflow, small, no new API, helpers
already in this tree. Risk is low; benefit is avoiding a write-triggered
heap overflow on Broadcom VK devices.

---

## Verification
- [Phase 1] `git show f66c40cd90954 --format=fuller`: subject/body/tags
  as above; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff vs parent: overflow.h, `!count` check, two
  `check_add_overflow`, `to_v_blks` moved before `copy_from_user`
- [Phase 2] `git show f66c40cd90954^:drivers/misc/bcm-vk/bcm_vk_msg.c`:
  wrapping `kzalloc` then copy then `to_v_blks`
- [Phase 3] `111d746bb4767` contained in `v5.12-rc1`; `3c69d52e3e12f`
  counted_by in `v6.7-rc1`
- [Phase 3] `git merge-base --is-ancestor 111d746bb4767 HEAD`: driver in
  this tree
- [Phase 3] Author log under `drivers/misc/`: clustered overflow/bounds
  patches merged 2026-07-17
- [Phase 4] `b4 dig -c f66c40cd90954`: msgid 20260629160605.29412-1; v1
  only
- [Phase 4] `b4 dig -w`: Branden, Broadcom list, Arnd, Greg, lkml
- [Phase 4] `b4 dig -m`: 1-message mbox, no replies/NAKs
- [Phase 4] WebFetch lore: 403; stable@ search: no dedicated thread
  found
- [Phase 5] `.write = bcm_vk_write`; `bcm_vk_drv_access_ok` is
  `atomic_read_acquire(&vk->msgq_inited)`
- [Phase 5] PCI id table: Broadcom Valkyrie 0x5e87 only
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `kernelversion` 7.3.0-rc4
- [Phase 6] Current `bcm_vk_write()` already contains
  `check_add_overflow`; `include/linux/overflow.h` defines it
- [Phase 6] `to_v_msg[] __counted_by(to_v_blks)` in `bcm_vk_msg.h`
- [Phase 8] `nr_ib_sgl_blk` default `BCM_VK_DEF_IB_SGL_BLK_LEN` 16;
  `VK_MSGQ_BLK_SIZE` 16
- UNVERIFIED: distro udev mode for `/dev/bcm-vk.N` (whether unprivileged
  open is allowed)

**YES**

 drivers/misc/bcm-vk/bcm_vk_msg.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_msg.c b/drivers/misc/bcm-vk/bcm_vk_msg.c
index a36a6c7d384a9..4663d758de3ce 100644
--- a/drivers/misc/bcm-vk/bcm_vk_msg.c
+++ b/drivers/misc/bcm-vk/bcm_vk_msg.c
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/overflow.h>
 #include <linux/poll.h>
 #include <linux/sizes.h>
 #include <linux/spinlock.h>
@@ -1090,6 +1091,7 @@ ssize_t bcm_vk_write(struct file *p_file,
 	u32 q_num;
 	u32 msg_size;
 	u32 msgq_size;
+	size_t entry_size;
 
 	if (!bcm_vk_drv_access_ok(vk))
 		return -EPERM;
@@ -1097,20 +1099,26 @@ ssize_t bcm_vk_write(struct file *p_file,
 	dev_dbg(dev, "Msg count %zu\n", count);
 
 	/* first, do sanity check where count should be multiple of basic blk */
-	if (count & (VK_MSGQ_BLK_SIZE - 1)) {
-		dev_err(dev, "Failure with size %zu not multiple of %zu\n",
+	if (!count || count & (VK_MSGQ_BLK_SIZE - 1)) {
+		dev_err(dev, "Failure with size %zu not a positive multiple of %zu\n",
 			count, VK_MSGQ_BLK_SIZE);
 		rc = -EINVAL;
 		goto write_err;
 	}
 
+	if (check_add_overflow(sizeof(*entry), count, &entry_size) ||
+	    check_add_overflow(entry_size, vk->ib_sgl_size, &entry_size)) {
+		rc = -EOVERFLOW;
+		goto write_err;
+	}
+
 	/* allocate the work entry + buffer for size count and inband sgl */
-	entry = kzalloc(sizeof(*entry) + count + vk->ib_sgl_size,
-			GFP_KERNEL);
+	entry = kzalloc(entry_size, GFP_KERNEL);
 	if (!entry) {
 		rc = -ENOMEM;
 		goto write_err;
 	}
+	entry->to_v_blks = count >> VK_MSGQ_BLK_SZ_SHIFT;
 
 	/* now copy msg from user space, and then formulate the work entry */
 	if (copy_from_user(&entry->to_v_msg[0], buf, count)) {
@@ -1118,7 +1126,6 @@ ssize_t bcm_vk_write(struct file *p_file,
 		goto write_free_ent;
 	}
 
-	entry->to_v_blks = count >> VK_MSGQ_BLK_SZ_SHIFT;
 	entry->ctx = ctx;
 
 	/* do a check on the blk size which could not exceed queue space */
@@ -1355,4 +1362,3 @@ void bcm_vk_msg_remove(struct bcm_vk *vk)
 	bcm_vk_drain_all_pend(&vk->pdev->dev, &vk->to_v_msg_chan, NULL);
 	bcm_vk_drain_all_pend(&vk->pdev->dev, &vk->to_h_msg_chan, NULL);
 }
-
-- 
2.53.0

