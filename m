Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E89532F12;
	Mon, 19 Oct 2026 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418639; cv=none; b=oHpyYQsDoid2voqOHl/P4eFhHQnurg5cL9N28rwG/kMRytDDXdEFmN8ftPxia1TZ/oG5FalyooMZ/aQFO0pac0pqwl11YwKL8zS0CGlIlWgtDibDUSpFl3YjQWNyxmNEGv9K2C1WEnpvjXh4h9jNfv75CEjasBVePNBqsunAlvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418639; c=relaxed/simple;
	bh=4V3nOQOXWlVxyxk11nYbD3SCH6YOMOfTBPWMP77+06w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tvtmOdgFXpsf1usd7FxCzHTtJPufWLqaXkALasLkRxgXaX4GKXkfZ1Y0jRaDFCdeZarBZ0BI71/Q2ZPlovwFQw8pFGFU/BaK8bcHDWSOxzlLS2lJ7e2qCZH07Kgptts+18KTEOsWk3HUujUim8lpdraJ5E33TOU/LZUrI36t+4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZlNEzZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZlNEzZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05F91F000C7;
	Mon, 19 Oct 2026 14:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418636;
	bh=W8JiklxcW1Ss0lfHOVeHQrJF8qC15gIV2j7l7hoO4mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZlNEzZv45ZI5fGxqO3FT+TRQ7CA2/UTcmQjtscXH1RZ8BLdUe4EiA4P7I8LjHCFC
	 pWmTCcB+FSV3RJygEsRjFpGwJm46eykspMRGYyM6CH4RKIdEzyeC4e83DMws/K3WLi
	 4sgrrB2I52Dl9Njn/2DT8cIulH13z0YaNPIeciRlCxqU/d1qTWvIhGeCkvNbQcmsoz
	 fP4f7lzokWQnigOil4Cb/Y00cuVRC8NqGnG9V7gS2mXQ7Gs2cmytQyTJt2M9+dI8A/
	 HWIkhU/fnFnslFT5V6sTPeV92V7Dqbj9BLjyZ/7t7YF2hVtZqhYgaZ/JWDLJL7bZcO
	 eo/rlRBflDssw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sungho Bae <baver.bae@lge.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	amit@kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] virtio_console: fix control queue race during restore
Date: Mon, 19 Oct 2026 09:51:21 -0400
Message-ID: <20261019135441.1420968-390-sashal@kernel.org>
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

From: Sungho Bae <baver.bae@lge.com>

[ Upstream commit 952261953cf79820aa4350679882db0d4f71f493 ]

In virtcons_restore(), after virtio_device_ready() sets DRIVER_OK, the
device becomes active. If the control receive queue (c_ivq) is populated
immediately, the host can instantly deliver pending control messages
(e.g., VIRTIO_CONSOLE_PORT_REMOVE).

This triggers the control_work_handler(), which can modify the
portdev->ports list concurrently with the unprotected list_for_each_entry
loop in virtcons_restore(), leading to list corruption or Use-After-Free.

Fix this by deferring the population of the control receive queue
(fill_queue for c_ivq) until after the list iteration is complete. This
ensures the host cannot inject control messages during the vulnerable
window.

Signed-off-by: Sungho Bae <baver.bae@lge.com>
Link: https://patch.msgid.link/20260603183757.21587-4-baver.bae@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.6.157** (`pending-6.6`). The buggy restore path is
present, the patch applies cleanly, and it is a self-contained UAF/list-
corruption fix.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[virtio_console] [fix] [control queue race during restore]**
- Subsystem: `virtio_console` (guest virtio-serial/console driver)
- Action verb: **fix** — explicit bug fix
- Claimed intent: close a restore-time race between filling the control
  receive queue and iterating `portdev->ports`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none on the commit itself; the v3 cover letter says it
  was runtime-tested on arm64 S4 with `no_console_suspend`
- **Reviewed-by / Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260603183757.21587-4-baver.bae@gmail.com`
  (v3 3/4 of a 4-patch series)
- **Cc: stable:** none (expected; not a negative)
- **Signed-off-by:** Sungho Bae `<baver.bae@lge.com>` (author); Greg
  Kroah-Hartman (char-misc maintainer). Ignore any Sasha Levin SOB from
  candidate prep.
- Mainline SHA (from `fixes-next`, not from candidate markers):
  `952261953cf79820aa4350679882db0d4f71f493`
- AuthorDate: 2026-06-04; CommitDate: 2026-07-31

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** After `virtio_device_ready()` sets `DRIVER_OK`, immediately
  `fill_queue(c_ivq)` lets the host deliver control packets (e.g.
  `VIRTIO_CONSOLE_PORT_REMOVE`) while `virtcons_restore()` is still
  walking `portdev->ports` with unlocked `list_for_each_entry`.
- **Symptom / failure mode:** `control_work_handler()` →
  `handle_control_message()` → `unplug_port()` does `list_del` +
  `kref_put` concurrently with that walk → **list corruption or use-
  after-free**.
- **Version info:** none in the message. The restore path dates to 2011;
  `virtio_device_ready()` before queue use dates to 2014 (see Phase 3).
- **Root cause (author):** host can inject control messages as soon as
  `c_ivq` has buffers after `DRIVER_OK`.
- **Fix:** move `fill_queue(portdev->c_ivq)` until after the list walk.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Subject and body describe a UAF/list-corruption
race. The extra comment is documentation of that race, not a cleanup
disguised as a fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/char/virtio_console.c` only
- Scope: **+12 / −3** (net +9, one function)
- Function: `virtcons_restore()`
- Classification: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: **Before** (this tree, `virtcons_restore` at lines 2201–2235):

1. `init_vqs(portdev)`
2. `virtio_device_ready()` → `DRIVER_OK`, notifications enabled
3. `fill_queue(c_ivq)` if multiport → host can write control packets
4. Unlocked `list_for_each_entry` over `portdev->ports`: rebind vqs,
   `fill_queue(in_vq)`, `PORT_READY` / `PORT_OPEN`

**After:** steps 3 and 4 swap. Control IN buffers are added only after
the walk finishes.

Affected path: **PM restore** (`CONFIG_PM_SLEEP`), not probe. Probe
already fills `c_ivq` before ports exist, so it does not have this walk.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Race / UAF / list corruption]**

Verified chain in this tree:
- `control_intr()` (`drivers/char/virtio_console.c:1792`) →
  `schedule_work(&portdev->control_work)`
- `control_work_handler()` (`:1696`) → `handle_control_message()`
- `VIRTIO_CONSOLE_PORT_REMOVE` (`:1597`) → `unplug_port()`
- `unplug_port()` (`:1507`) takes `ports_lock`, `list_del(&port->list)`,
  later `kref_put`
- `PORT_ADD` (`:1580`) can `add_port()` → `list_add_tail` under
  `ports_lock` (`:1445`)
- `virtcons_restore()` walks the same list **without** `ports_lock`
  (`:2218`)

Other walkers (`find_port_by_id`, `find_port_by_devt_in_portdev`) do
take `ports_lock`. Restore is the unprotected one.

Without `c_ivq` buffers, the host cannot complete used descriptors on
the control IN queue, so `control_intr` cannot fire. Deferring
`fill_queue(c_ivq)` closes the window. `send_control_msg()` uses `c_ovq`
only (`__send_control_msg` at `:541`), so PORT_READY/OPEN still go out
during the loop; host replies wait until IN buffers exist.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Obviously correct:** same two calls, safer order. Matches how virtio
  queues work (no IN buffers ⇒ no host-to-guest control).
- **Minimal:** no API, no new fields, no locking change.
- **Regression risk:** low. Host replies to PORT_READY are delayed until
  `c_ivq` is filled; that is normal virtio backpressure. Probe already
  sends DEVICE_READY only after `fill_queue(c_ivq)` (`:2089–2118`);
  restore now fills `c_ivq` after PORT_READY, which is slightly
  different timing but still valid.
- Residual: the restore walk still does not take `ports_lock`. After
  this patch the only concurrent list mutator on this path is host
  control, which cannot run until `c_ivq` is filled. Device remove is
  serialized with PM restore via the driver/device lock. That is enough
  for this bug.
- Patch 4 of the same series (`pm_freezing`) is a **different**
  freeze/TX race and is not required for this reorder.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Unlocked restore loop and `fill_queue(c_ivq)` before it:
  **`2b8f41d846990c`** (Amit Shah, 2011-12-22) “Add freeze and restore
  handlers to support S4”. Present in this tree (`git merge-base --is-
  ancestor` succeeded).
- `virtio_device_ready()` immediately before `fill_queue(c_ivq)`:
  **`401bbdc901b268`** (Michael S. Tsirkin, 2014-10-15) “enable VQs
  early on restore”. Also an ancestor of HEAD. That is when the host can
  legally deliver as soon as buffers are posted.
- Race has existed in this form since ~2014; this is old code, not a
  recent-mainline-only bug.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The enabling commit is `401bbdc901b268`, which
is in this tree. No intermediate fix of this same race on
`drivers/char/virtio_console.c` in this checkout (`git log
--grep="control queue race"` empty on HEAD).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent local history (`git log --oneline -20 --
drivers/char/virtio_console.c`) is unrelated (control-out free,
endian/cols-rows, probe bugs). This commit is **not** in HEAD (`git
merge-base --is-ancestor 952261953cf79 HEAD` failed).

On `fixes-next` the series is:
1. `fc220d6be3c7e` refactor `__send_to_port()` buffer ownership
2. `a616ad344d9f7` hot-unplug races in TX paths
3. **`952261953cf79` this commit**
4. `b187532ac6dba` hvc `put_chars` vs freeze teardown (`pm_freezing`)

Patches 1–2 do not touch `virtcons_restore`. Patch 4 adds `pm_freezing`
clear after the moved `fill_queue`; it does not change this race fix.
**Standalone.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Sungho Bae has no commits on this file in the 6.6 tree. On
`fixes-next` he authored this 4-patch virtio_console PM/hot-unplug set.
Maintainer of record is Amit Shah; the patch was To: amit@kernel.org,
arnd, gregkh and applied by Greg.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Diff uses only `virtio_device_ready`, `use_multiport`,
`fill_queue`, `c_ivq` / `c_ivq_lock`, all present. `git show
952261953cf79 | git apply --check` **applies cleanly**. No prerequisite.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 952261953cf79`: match at
  https://patch.msgid.link/20260603183757.21587-4-baver.bae@gmail.com
- `b4 dig -a`: only **v3** of `[PATCH v3 0/4] virtio_console: fix
  suspend/resume and hot-unplug races`
- v3 change note: split a monolithic patch for grouping/bisectability
- v1
  (https://patchew.org/linux/20260515225259.1054-1-baver.bae@gmail.com/)
  was only the freeze/`pm_freezing` fix; **this restore reorder is new
  in the split v3**
- Saved mbox: five messages (0/4–4/4), **no replies, no NAK, no Cc:
  stable**
- Greg applied it 2026-07-31

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc Amit Shah, Arnd Bergmann, Greg Kroah-
Hartman, `virtualization@lists.linux.dev`, `linux-kernel`. Appropriate
lists/maintainers. No public Reviewed-by; Greg’s SOB is the merge.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot, bugzilla, or user crash report. Cover letter: found
while investigating the freeze/`put_chars` race; runtime-tested on arm64
S4 with `no_console_suspend`. Mechanism is verified in code (Phase 2/5),
not only asserted.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series of 4; this is 3/4 and is self-contained. Patch 4 is a
separate freeze BUG_ON and does not need to ride along. Later `fixes-
next` commits (`allocate the port_buffer with the caller's gfp`, `do not
free control-out buffers on remove`) do not revert this reorder.
`virtcons_restore` on `fixes-next` still has fill-`c_ivq`-after-loop.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: `lore.kernel.org/stable/` fetch returned 403. No stable-thread
evidence in the v3 mbox. **UNVERIFIED** whether anyone already asked for
or rejected this on stable@. Absence of that discussion is not a reason
to skip a UAF fix that applies here.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `virtcons_restore()` only. Related callees: `fill_queue`,
`use_multiport`, `send_control_msg`, `virtio_device_ready`. Related
concurrent path: `control_work_handler` / `unplug_port` / `add_port`.

**Step 5.2: TRACE CALLERS**

Record: `virtcons_restore` is `.restore` of `struct virtio_driver
virtio_console` (`:2247–2249`), compiled under `CONFIG_PM_SLEEP`.
Invoked from virtio PM restore (guest S3/S4 / hibernation restore of the
virtio-console device). Not a syscall hot path; **reachable on any guest
that suspends/hibernates with this driver**.

**Step 5.3: TRACE CALLEES**

Record:
- `init_vqs` registers `control_intr` for the control IN vq (`:1876`)
- `virtio_device_ready` sets `VIRTIO_CONFIG_S_DRIVER_OK`
  (`include/linux/virtio_config.h:270–297`)
- `fill_queue` allocates PAGE_SIZE IN buffers and `add_inbuf` under the
  given lock (`:1323`)
- `send_control_msg` → `__send_control_msg` kicks **c_ovq** only

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Guest suspend/resume or hibernation of a VM using multiport
virtio-console/serial. Host can have pending PORT_REMOVE (port gone
while guest was down) or reply to PORT_READY with PORT_ADD/REMOVE/NAME.
Userspace in the guest does not need to issue a special syscall; PM
restore plus host control is enough. Unprivileged guest users do not
directly trigger it; the **hypervisor/host** does. Severity is still
guest kernel UAF.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `virtcons_freeze()` also walks `portdev->ports` unlocked
(`:2186`), but first `virtio_reset_device` +
`virtqueue_disable_cb(c_ivq)` + `cancel_work_sync(&control_work)`
(`:2173–2184`), so control work cannot run. Probe fills `c_ivq` before
any ports are on the list. Restore was the inconsistent path.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/char/virtio_console.c:2213–2234` still does
`virtio_device_ready` → `fill_queue(c_ivq)` → unlocked
`list_for_each_entry`. Tree: `pending-6.6`, `make kernelversion`
**6.6.157**, `git describe` `p-6.6-4-gaf85e5fc2f380`. Bug introduced
~2014 (`401bbdc901b268`), long before 6.6.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git apply --check` on `952261953cf79`
succeeded). Surrounding `virtcons_restore` matches the pre-image. No
refactor gap.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This SHA is not an ancestor of HEAD. No other “control queue
race” commit on this file in this tree. Freeze-path callback disable is
present and unrelated.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **virtio_console** (`drivers/char/virtio_console.c`,
`CONFIG_VIRTIO_CONSOLE`). **IMPORTANT** for KVM/QEMU/cloud/embedded
guests (virtio-serial, guest console). Not mm/core, but not
staging/obscure. Maintainers: Amit Shah; virtio core: MST / Jason Wang.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature. Freeze/restore since 2011; little churn on this function
in 6.6. Long-lived bug, not a new-subsystem mismatch.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific + config-specific:** `CONFIG_VIRTIO_CONSOLE` +
`CONFIG_PM_SLEEP` + multiport (`VIRTIO_CONSOLE_F_MULTIPORT`, normal for
virtio-serial). Guest suspend/hibernate/restore users.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Guest PM restore while host delivers control messages (pending
PORT_REMOVE, or replies to PORT_READY). Window includes
`fill_queue(c_ivq)` (many PAGE_SIZE allocations) plus the port loop. Not
every boot; **realistic on S3/S4 of VMs with virtio-serial**. Guest
userspace need not be malicious; the host is the other party (trusted in
the virtio model, but still a crash in the guest).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **Use-after-free and list corruption** → oops/panic, possible
memory corruption. **Severity: HIGH** (CRITICAL if the UAF is hit). Not
a WARN-only issue.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** HIGH — prevents UAF/list corruption on a common VM driver
  during restore; code has been wrong for years in this tree.
- **Risk:** VERY LOW — 9-line reorder, same helpers, applies cleanly, no
  new API/locking.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real race: unlocked list walk vs `unplug_port`/`add_port` from control
  work
- Failure is UAF / list corruption (stable-class bug)
- Buggy code is in this 6.6 tree and has been since ~2014
- Fix is a 9-line reorder; `git apply --check` clean
- No dependency on series patches 1/2/4
- Applied by Greg to char-misc; later `fixes-next` still has this order
- Author tested related PM paths on arm64 S4

**AGAINST:**
- No `Reported-by` / syzbot; found during investigation
- Restore-only (S3/S4), not every boot
- No public review comments in the v3 mbox
- Part of a 4-patch series (but this hunk is independent)

**UNRESOLVED:**
- Stable@ discussion (lore/stable 403)
- No independent crash log attached to this specific UAF (mechanism
  still verified in tree)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — reorder is locally
   checkable; series was S4-tested; merged by Greg
2. Fixes a real bug that affects users? **PASS** — restore + multiport
   virtio-console is a real guest path
3. Important issue? **PASS** — UAF / list corruption, HIGH
4. Small and contained? **PASS** — one function, +12/−3
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean apply; all symbols
   exist

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. It qualifies as a
normal **small race/UAF fix**.

**Step 9.4: MAKE YOUR DECISION**

This should be backported to **this** 6.6 tree. The bug exists here, the
fix is surgical and independent of the rest of the series, and the
downside is a mild delay of host control replies until after ports are
rebound — which is the intended barrier.

------------------------------------------------
What it solves for stable users
------------------------------------------------
On guest suspend/resume or hibernation restore, `virtcons_restore()`
currently posts control IN buffers while still walking `portdev->ports`
without `ports_lock`. A host `PORT_REMOVE`/`PORT_ADD` can then free or
insert list nodes under that walk. 6.6 guests using virtio-serial (the
usual QEMU multiport setup) can oops or corrupt kernel memory. Moving
`fill_queue(c_ivq)` after the loop removes that window without changing
APIs.

Risk vs benefit: benefit is avoiding a restore-time UAF; risk is a
small, obviously correct reorder that already applies.

------------------------------------------------
Verification
------------------------------------------------
- [Phase 1] Parsed subject/tags: fix, Link msgid
  `20260603183757.21587-4`, SOB Sungho Bae + Greg; no Fixes/Reported-
  by/stable Cc
- [Phase 1] Mainline SHA from `fixes-next`:
  `952261953cf79820aa4350679882db0d4f71f493` (not treated as “already
  selected”)
- [Phase 2] Diff: only `virtcons_restore()`; move `fill_queue(c_ivq)`
  after unlocked `list_for_each_entry`
- [Phase 2] `control_intr` → `control_work_handler` → `PORT_REMOVE` →
  `unplug_port` `list_del`; restore walk has no `ports_lock` (lines
  1507–1511, 1597–1598, 2218)
- [Phase 2] `__send_control_msg` uses `c_ovq` only (line 551)
- [Phase 3] Blame: loop/`fill_queue` from `2b8f41d846990c` (2011);
  `virtio_device_ready` from `401bbdc901b268` (2014); both ancestors of
  HEAD
- [Phase 3] `git merge-base --is-ancestor 952261953cf79 HEAD` → NOT in
  this tree
- [Phase 3] Series 1–2 do not touch `virtcons_restore`; patch 4 is a
  separate `pm_freezing` freeze race
- [Phase 4] `b4 dig -c 952261953cf79` → v3 3/4 lore URL; `-a` only v3;
  `-w` amit/arnd/gregkh/virtualization; mbox has no replies
- [Phase 4] v1 patchew: freeze-only; this reorder appeared in v3
- [Phase 4] UNVERIFIED: stable@ archives (HTTP 403)
- [Phase 5] `virtio_device_ready` sets `DRIVER_OK`
  (`include/linux/virtio_config.h:297`); `init_vqs` registers
  `control_intr`
- [Phase 6] `git describe HEAD` `p-6.6-4-gaf85e5fc2f380`; `make
  kernelversion` 6.6.157; buggy order at lines 2213–2234
- [Phase 6] `git show 952261953cf79 | git apply --check` → APPLIES
  CLEANLY
- [Phase 8] Failure mode: UAF/list corruption on PM restore; severity
  HIGH
- UNVERIFIED: no captured crash log for this exact UAF (code path still
  verified)

The patch is small, surgical, and meets the stable criteria for this
tree.

**YES**

 drivers/char/virtio_console.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 750c15966d00e..cfda31d5e86ec 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2172,9 +2172,6 @@ static int virtcons_restore(struct virtio_device *vdev)
 
 	virtio_device_ready(portdev->vdev);
 
-	if (use_multiport(portdev))
-		fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
-
 	list_for_each_entry(port, &portdev->ports, list) {
 		port->in_vq = portdev->in_vqs[port->id];
 		port->out_vq = portdev->out_vqs[port->id];
@@ -2191,6 +2188,18 @@ static int virtcons_restore(struct virtio_device *vdev)
 		if (port->guest_connected)
 			send_control_msg(port, VIRTIO_CONSOLE_PORT_OPEN, 1);
 	}
+
+	/*
+	 * Populate the control receive queue only after the list iteration
+	 * is complete. If we fill this queue before iterating, the host could
+	 * immediately deliver a VIRTIO_CONSOLE_PORT_REMOVE message.
+	 * This would trigger the control workqueue, which modifies the
+	 * portdev->ports list concurrently with the unprotected loop above,
+	 * leading to a Use-After-Free and list corruption.
+	 */
+	if (use_multiport(portdev))
+		fill_queue(portdev->c_ivq, &portdev->c_ivq_lock);
+
 	return 0;
 }
 #endif
-- 
2.53.0

