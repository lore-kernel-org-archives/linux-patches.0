Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE64F538747;
	Mon, 19 Oct 2026 13:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418173; cv=none; b=cdseK+s54YDA/MqgGaS9nTrdurIT8KIJitc0HrY58ZoSB0Bn6UulAEpm2xf7flhrGNAlq6Seazj+L7ysDLVOaQibAvD1c03XQTg34qmKkLoBYgT3o9t5PL/X4RGXrX2o9euG5e/gKFzBhVMkKaoC5cu9UkZcwBHixjOELqnKc2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418173; c=relaxed/simple;
	bh=GNFR2ygFColmruE9hnRL36mSBBf4NUEBSG6hoWa1ypU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2lve4cZgcq5p5y83HvmXYQBVHgsR55ke7+Je+aHRJxzQWlvwA/gBdh+TlSIu2L5I5v+XOvUFUEHwzAaUJqBxwPdVufmhKZkZ8cGh6Cv4piLc3Ynmrjaa5ALzTPTZMR++tCHVgmO0ORlUEpDSlNaTAgCEDbmvgGjIctA9gt67C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eE0D2dko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eE0D2dko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E641F000C6;
	Mon, 19 Oct 2026 13:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418170;
	bh=wWQZeQDhDv+kA4pq+n9MJZ7tRjBa7W4Nvr6f8lDj1Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eE0D2dkomhOX5+NlQ9h55t3+l6ggC24H0iAu+1VcFyDP0k8eninYBOggTDd0lpxeT
	 Tr48+INyi5ruhehs7c7+NZJPHskMybnOMubbSCNSHr9svlQcwTusQxJa/9g+od1tlw
	 1OhltnGEvU+7ux3+lPMTZJzPO2mnLD8B5lgN/VmwkAGkgklWiLkW7Rwk3wszJJHcRg
	 ygThY0/7RZCM1uu3NPhJ1+5kQzExzokkAlSMtV1Mgu7GqiK2RFt+ibGLnI+tnLexzs
	 swn/388hgL9HHBafmBkuMKJLd9Zaa65KWgkaLOUJxKkNxax7waNrKgCrRBBPPrwJOl
	 HWeUE7TcKzdVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	vaibhavgupta40@gmail.com,
	jens.taprogge@taprogge.org,
	industrypack-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ipack: ipoctal: add rwsem to guard against TOCTOU in remove path
Date: Mon, 19 Oct 2026 09:45:53 -0400
Message-ID: <20261019135441.1420968-62-sashal@kernel.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 7d3a708af7f4e2af9e114d731bd60d30c1ec884e ]

The "removed" flag check in each tty op has a TOCTOU race with
__ipoctal_remove(): the device could be removed between the flag
check and the subsequent access to hardware resources (channel
registers via iowrite8, or xmit_buf in write_tty).

Close this race by introducing a read-write semaphore (remove_sem).
The tty ops acquire the read lock via guard(rwsem_read) for the
full duration of the operation, while __ipoctal_remove() acquires
the write lock via scoped_guard(rwsem_write) when setting the
removed flag.  This ensures that once removed is true, no in-flight
tty op can still be accessing resources that are about to be freed
by the remove path.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/fbce75010a0f0a3a3709a5e06fd0ffd19ca0a0ed.1782870760.git.xiaopei01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (Makefile 7.3.0-rc4). The buggy `removed`
flag is present here (parent UAF fix `b6b5d64cb161a`), and this commit
closes a real TOCTOU on that flag.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[ipack/ipoctal] [add] [rwsem to close TOCTOU between `removed`
check and hardware access in the remove path]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Link:** `https://patch.msgid.link/fbce75010a0f0a3a3709a5e06fd0ffd19c
  a0a0ed.1782870760.git.xiaopei01@kylinos.cn`
- **Signed-off-by:** Pei Xiao `<xiaopei01@kylinos.cn>` (author)
- **Signed-off-by:** Greg Kroah-Hartman (char-misc maintainer; applied
  the patch)
- No **Fixes:**, **Reported-by:**, **Tested-by:**, **Reviewed-by:**,
  **Acked-by:**, or **Cc: stable** on *this* commit (absence is
  expected)
- Parent commit `b6b5d64cb161a` *does* have Reported-by: Shuangpeng Bai,
  Closes: lore KASAN report, Fixes: `05e5027efc9c`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** unlocked `removed` flag check in tty ops races with
  `__ipoctal_remove()`.
- **Symptom:** device can be removed between the check and `iowrite8` /
  `xmit_buf` use → MMIO after iounmap (page fault) or use of a freed
  transmit buffer.
- **Root cause:** check-then-use without a lock that spans both.
- **Fix:** `remove_sem` rwsem; tty ops take read lock for the whole op;
  remove takes write lock while setting `removed`.
- **Version info:** none in the message. Parent UAF bug dates to the
  2012 staging move; this TOCTOU exists only after the parent’s
  `removed` flag.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Explicit race/TOCTOU fix. “Add rwsem” is the
synchronization change that closes the window.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/ipack/devices/ipoctal.c` — **+10 / −6** (16 lines)
- **Functions/data:** `struct ipoctal` (`remove_sem`);
  `ipoctal_port_activate`, `ipoctal_write_tty`, `ipoctal_set_termios`,
  `ipoctal_hangup`, `ipoctal_shutdown`; `ipoctal_probe` (`init_rwsem`);
  `__ipoctal_remove` (`scoped_guard` around `removed = true`)
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** each listed tty op reads `ipoctal->removed` with no lock,
  then touches MMIO/`xmit_buf`. Remove stores `removed = true` then
  `free_irq`, `tty_port_free_xmit_buf`, `tty_port_destroy`.
- **After:** ops hold `down_read` for the whole op via
  `guard(rwsem_read)`. Remove’s `down_write` waits for in-flight
  readers, then sets `removed`. Later readers see `removed == true` and
  skip hardware. Then remove frees resources.
- **Path:** device-remove vs concurrent tty ops (write, termios, hangup,
  shutdown, port activate).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Synchronization / race — TOCTOU]** Flag check without a lock
that covers the subsequent access. Writer waits for readers, then
publishes `removed`; new readers bail out. Category (c) not involved (no
get/put change here). Complements parent kref/`removed` UAF fix.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** classic rwsem lifetime barrier; `guard`/`scoped_guard`
  make unlock-on-return automatic. Write lock is only held while storing
  the flag, which is enough because later readers observe `removed`.
- **Verified non-nesting:** `ipoctal_hangup` → `tty_port_hangup` →
  `tty_port_shutdown` calls **`tty_port_operations.shutdown`**, which
  this driver does **not** set. `tty_operations.shutdown`
  (`ipoctal_shutdown`) runs from `release_tty()`, a different path. No
  recursive `down_read` on the same task.
- **`tty_unregister_device`** only does `device_destroy`/`cdev_del`; it
  does not take `tty_lock`. Write lock is dropped before unregister, so
  hangup’s `tty_lock` → read lock vs remove’s write lock → unregister is
  not a held-lock inversion.
- **Regression risk:** low. `down_read` in `write_tty` is legal (tty
  write may sleep). IRQ handler does not take the rwsem; remove still
  `free_irq` after publishing `removed`, which waits out in-flight IRQs.
- **Incompleteness (not a reason to reject):** `write_room` /
  `chars_in_buffer` / `get_icount` still unlocked; they only touch
  `channel` fields kept alive by the parent kref, not MMIO/`xmit_buf`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `removed` and kref: **`b6b5d64cb161a`** (Pei Xiao, 2026-07-17, “fix
  UAF, null-ptr-deref, and use-after-free in cleanup on remove”).
- `remove_sem`: **this commit `7d3a708af7f4e`**.
- Driver core (`struct ipoctal`): 2012 (`ba4dc61fe8c545` staging).
- **The TOCTOU is in code added by the immediate parent**, not in
  ancient unlocked MMIO.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag on this commit.** Parent `b6b5d64cb161a` has
`Fixes: 05e5027efc9c` (“Staging: ipack: move out of staging”,
2012-11-16). `git merge-base --is-ancestor` confirms `05e5027efc9c`,
`b6b5d64cb161a`, and `7d3a708af7f4e` are all ancestors of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Direct parent of this commit **is** `b6b5d64cb161a`. Same author,
  consecutive timestamps (10:01:09 / 10:01:10).
- Mailing-list subject: **`[PATCH 2/2]`**. Patch 1 is the
  UAF/kref/`removed` flag; patch 2 is this rwsem.
- No later commits on this file after `7d3a708af7f4e`.
- **Standalone for this tree: yes**, because patch 1 is already here.
  Not standalone on a tree that lacks `b6b5d64cb161a`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pei Xiao is **not** the ipack maintainer; only these two ipack
commits. Greg KH applied both. Reporter Shuangpeng Bai iterated on the
series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- **Hard dependency:** `removed`, the flag checks, `kref_init` context
  in probe. All from `b6b5d64cb161a`, **present in this tree**.
- `guard(rwsem_read)` / `scoped_guard(rwsem_write)`:
  `DEFINE_LOCK_GUARD_1` in `include/linux/rwsem.h` (includes
  `cleanup.h`) — **present here**.
- Can apply standalone **on this tree: yes**.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig -c 7d3a708af7f4e:** matched series; lore msgid `fbce75010a0f0
  a3a3709a5e06fd0ffd19ca0a0ed.1782441021.git.xiaopei01@kylinos.cn` (and
  committed link with `.1782870760`).
- **b4 dig -a:** evolved RFC → PATCH → **PATCH 1/2 + 2/2**. This commit
  is 2/2.
- Thread started as **`[BUG] KASAN: slab-use-after-free in
  ipoctal_write_tty`** (Shuangpeng Bai, 14 Jun 2026), QEMU TPCI200/IP-
  Octal, repro: open tty then `/sys/bus/pci/drivers/tpci200/unbind`.
- Incomplete earlier versions produced: NULL deref in write, page fault
  in `ipoctal_set_termios` → `iowrite8`, UAF in `ipoctal_cleanup`.
- **Shuangpeng on the 1/2+2/2 series (30 Jun 2026): “I tried this patch
  on my side and no bug is triggered.”**
- **No NAKs.** No reviewer asked for Cc: stable. Greg applied the
  series.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: **b4 dig -w:** To/Cc were Pei Xiao, shuangpeng.kernel@gmail.com,
linux-kernel@. Not a dedicated ipack list. Greg KH (subsystem
maintainer) applied it after Pei asked him to look at
`cover.1782870760`.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record:
- KASAN slab-UAF in `ipoctal_write_tty` via `n_tty_write` /
  `ksys_write`, freed from `tpci200_pci_remove` → `unbind_store`.
- Repro gist referenced in-thread. **Root-only sysfs unbind**, QEMU not
  physical hardware.
- Greg (15–16 Jun 2026): unbind is a testing path; **“As it's not a real
  issue for drivers like this, it's a very low priority”**, but he would
  review patches. He still merged the series.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: **2-patch series.** Patch 1: kref, `carrier_owner` cache,
`removed` flag, NULL `xmit_buf` check. Patch 2 (this): rwsem around that
flag. Both in this tree. Tester signed off on the combination.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** for lore.kernel.org/stable (HTTP 403). No `Cc:
stable` in the thread mbox. No evidence of a prior stable NAK.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `ipoctal_port_activate`, `ipoctal_write_tty`,
`ipoctal_set_termios`, `ipoctal_hangup`, `ipoctal_shutdown`,
`ipoctal_probe`, `__ipoctal_remove`; field `ipoctal.remove_sem`.

**Step 5.2: TRACE CALLERS**
Record:
- `ipoctal_write_tty` ← `tty_operations.write` ← userspace `write()` on
  the tty.
- `ipoctal_set_termios` ← tty ioctl (reporter: `tty_mode_ioctl`).
- `ipoctal_port_activate` ← `tty_port_operations.activate` ←
  `ipoctal_open` → `tty_port_open`.
- `ipoctal_hangup` ← `tty_operations.hangup` ← `__tty_hangup`.
- `ipoctal_shutdown` ← `tty_operations.shutdown` ← `release_tty()`.
- `__ipoctal_remove` ← `ipoctal_remove` ← `ipack_driver_ops.remove`
  (unbind / PCI remove / module teardown).
- **Reachable from userspace tty ops + admin device removal.**

**Step 5.3: TRACE CALLEES**
Record: `iowrite8` / `ipoctal_reset_channel`,
`ipoctal_copy_write_buffer` (`xmit_buf`), `tty_port_hangup` /
`tty_port_set_initialized`, `free_irq` via bus ops,
`tty_port_free_xmit_buf`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Open `/dev/tty*` on IP-OCTAL, keep fd, remove carrier (`unbind`,
`rmmod`, PCI remove). **Yes, userspace-reachable.** Unprivileged
write/ioctl; removal needs privileges or hotplug. Failure is kernel
oops/UAF, not just ENODEV.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same unlocked `if (ipoctal->removed)` was in all hardware-
touching tty ops from patch 1; this patch wraps all of them. No sibling
ipack device driver with the same pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** HEAD is `v7.3-rc4-27-gf0100363d8c37`, version
**7.3.0-rc4**. `struct ipoctal` has `removed` from `b6b5d64cb161a` (in
7.3-rc1 char-misc merge). Without this commit, those checks are
unlocked. Bug introduced **in this 7.3 cycle** by patch 1, not after
this tree branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply on this tree** (same file layout,
`guard`/`scoped_guard`/`kref_init` present). Context uses `kzalloc_obj`
from a treewide change; this hunk only adds `init_rwsem` next to
`kref_init` from patch 1.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Parent UAF fix **is** here. No alternate TOCTOU fix. No later
revert or follow-up on this file.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **`drivers/ipack` (IndustryPack / GE IP-OCTAL UART).**
**PERIPHERAL.** `CONFIG_SERIAL_IPOCTAL` depends on `IPACK_BUS && TTY`,
**default n**. Used in industrial/HEP-style carrier boards (CERN/GE
history), also QEMU TPCI200.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: **Mature / low churn.** Until this 2026 series, last functional
ipoctal work was small tty API conversions and older leak/race fixes.
Not a hot new subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific** (`CONFIG_SERIAL_IPOCTAL`).
Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Concurrent tty op and `__ipoctal_remove`. Reproduced with **root
sysfs unbind** while fd open. Same remove path as PCI remove / module
unload. Unprivileged user cannot unbind; they can issue write/ioctl on
an already-open fd. Race window is real but narrow.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Oops / KASAN UAF / MMIO page fault.** **HIGH** when it fires
(kernel crash). Not a generic unprivileged LPE path. Greg called the
underlying unbind-vs-open-fd class **low priority** for this driver.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium-high *if* patch 1 is present (this tree):
  completes an incomplete UAF mitigation; prevents residual oops on
  remove-with-open-tty.
- **Risk:** low — ~10 lines, one file, scoped guards, no API change.
- **Ratio:** favorable **on this tree**, because shipping patch 1
  without patch 2 leaves a known TOCTOU.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**For backporting to this tree:**
- Real TOCTOU: check `removed` then access MMIO/`xmit_buf` while remove
  frees them.
- Failure is oops/UAF (reporter already hit page fault and KASAN on
  related paths).
- Small, obviously correct rwsem barrier; tester confirmed 1/2+2/2 no
  longer crashes.
- Prerequisite patch 1 **is in this tree**; without this commit the 7.3
  `removed` flag is racy.
- Greg KH applied it; no NAKs.
- Matches stable “race with severe outcome” guidance.

**Against:**
- Explicit **PATCH 2/2** (but dependency is already here).
- Niche `default n` IndustryPack UART.
- Trigger in the report is root sysfs unbind; Greg called that class low
  priority.
- This commit has no Fixes:/Reported-by of its own (expected).
- Not a core-kernel path.

**Unresolved:**
- Stable-list search 403 (no confirmation anyone asked stable@).
- No independent reproduction of *only* the TOCTOU (series tested as a
  whole).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — lock spans check+use;
   Shuangpeng retested the series.
2. Fixes a real bug that affects users? **PASS** — race on this tree’s
   `removed` flag; same remove-vs-open-tty path as the KASAN report.
3. Important issue? **PASS** — oops/UAF/page fault, not a style change.
   Importance is limited by hardware rarity, not by bug class.
4. Small and contained? **PASS** — one file, +10/−6.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — parent, `removed`, and
   `guard(rwsem_*)` all exist here.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **None** (not an ID/quirk/DT/build/doc exception). Qualifies as
a normal race/UAF-completion fix.

**Step 9.4: MAKE YOUR DECISION**

This tree is 7.3-rc4 and already contains the parent UAF fix that added
an unlocked `removed` flag. Leaving that flag without `remove_sem` re-
opens MMIO-after-unmap and freed-`xmit_buf` on remove-while-tty-open.
The patch is small, correct, and was tested as the second half of that
series. That is enough technical merit to backport it **into this
tree**.

It would be the wrong patch to take **alone** on a tree that still lacks
`b6b5d64cb161a`; that is not this tree.

---

## Detailed explanation

The parent commit keeps `struct ipoctal` alive with a kref and uses
`removed` to skip MMIO after unmap. That check is TOCTOU:
`__ipoctal_remove()` can set `removed` and free `xmit_buf`/unmap BARs
between the load of the flag and `iowrite8` / buffer use. The rwsem
makes “still using hardware” and “publish removed” exclusive. That is a
real crash class on a path the reporter already exercised.

Stable rules are met: real bug, crash severity, tiny diff, no new API,
applies here. Peripheral hardware and a root-oriented repro lower
*breadth*, not correctness. Risk is low vs the benefit of not shipping
the incomplete flag.

---

## Verification
- **[Phase 1]** Parsed tags: Link msgid, SOB Pei Xiao + Greg KH; no
  Fixes/Reported-by on this commit; parent has Reported-by Shuangpeng
  Bai + Fixes 05e5027efc9c
- **[Phase 2]** Diff: `drivers/ipack/devices/ipoctal.c` +10/−6; rwsem
  around five tty ops + probe init + remove store
- **[Phase 2]** Confirmed `tty_port_hangup` calls port `.shutdown`, not
  `tty_operations.shutdown`; ipoctal port ops have no `.shutdown`
- **[Phase 2]** `tty_unregister_device` is `device_destroy`/`cdev_del`
  only
- **[Phase 3]** `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` → 7.3.0-rc4
- **[Phase 3]** `git merge-base --is-ancestor` b6b5d64, 7d3a708, 05e5027
  → all in HEAD
- **[Phase 3]** `git log -1 7d3a708^` → parent is exactly the
  UAF/`removed` commit
- **[Phase 3]** blame: `removed` from b6b5d64; `remove_sem` from 7d3a708
- **[Phase 4]** `b4 dig -c 7d3a708af7f4e` / `-a` / `-w` / `-m`: PATCH
  2/2, RFC→v2 series, recipients Pei/Shuangpeng/lkml
- **[Phase 4]** mbox: KASAN report, Greg low-priority comment,
  Shuangpeng “no bug is triggered” on 1/2+2/2
- **[Phase 4]** lore.kernel.org WebFetch/curl: **403** — discussion
  taken from b4 mbox instead
- **[Phase 5]** Callers traced in `ipoctal.c` + `tty_io.c` /
  `tty_port.c`
- **[Phase 6]** Local file has `removed` + `remove_sem`; no later
  follow-up on this file
- **[Phase 7]** Kconfig: `SERIAL_IPOCTAL` default n, depends IPACK_BUS
  && TTY
- **[Phase 8]** Failure mode: UAF/oops/PF on remove vs open tty; trigger
  requires device removal
- **UNVERIFIED:** whether anyone mailed stable@ about this exact commit
  (lore/stable 403)

**YES**

 drivers/ipack/devices/ipoctal.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 474b58858dca6..aab303c4a9837 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kref.h>
+#include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/serial.h>
@@ -54,6 +55,7 @@ struct ipoctal {
 	u8 __iomem			*int_space;
 	struct kref			kref;
 	struct module			*carrier_owner;
+	struct rw_semaphore		remove_sem;
 	bool				removed;
 };
 
@@ -81,7 +83,7 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	channel = dev_get_drvdata(tty->dev);
 	ipoctal = chan_to_ipoctal(channel, tty->index);
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return -ENODEV;
 
@@ -476,7 +478,7 @@ static ssize_t ipoctal_write_tty(struct tty_struct *tty, const u8 *buf,
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	size_t char_copied;
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed || !channel->tty_port.xmit_buf)
 		return 0;
 
@@ -522,7 +524,7 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
 	speed_t baud;
 
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -660,7 +662,7 @@ static void ipoctal_hangup(struct tty_struct *tty)
 		return;
 
 	ipoctal = chan_to_ipoctal(channel, tty->index);
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -686,7 +688,7 @@ static void ipoctal_shutdown(struct tty_struct *tty)
 		return;
 
 	ipoctal = chan_to_ipoctal(channel, tty->index);
-
+	guard(rwsem_read)(&ipoctal->remove_sem);
 	if (ipoctal->removed)
 		return;
 
@@ -736,6 +738,7 @@ static int ipoctal_probe(struct ipack_device *dev)
 		return -ENOMEM;
 
 	kref_init(&ipoctal->kref);
+	init_rwsem(&ipoctal->remove_sem);
 
 	ipoctal->dev = dev;
 	ipoctal->carrier_owner = dev->bus->owner;
@@ -755,7 +758,8 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 {
 	int i;
 
-	ipoctal->removed = true;
+	scoped_guard(rwsem_write, &ipoctal->remove_sem)
+		ipoctal->removed = true;
 
 	ipoctal->dev->bus->ops->free_irq(ipoctal->dev);
 
-- 
2.53.0

