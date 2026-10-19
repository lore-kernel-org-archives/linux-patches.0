Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E875470843;
	Mon, 19 Oct 2026 14:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418540; cv=none; b=ZUwWQsJy5lQGhWvc6Ofd1N5qX+JXXCsrkDFb+jG0zJM3vgUpEpDuxsEnYuwJ4GHbt2sWTw66KsW2ewEI/83/FH46td+GANniYa1mY3pIrBlecWM1ddAW27ZQsoaKKKZ6i2F/6SDFdUKB8O7LhKueEgh6ZH0pzqR8zJAkZgtl3cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418540; c=relaxed/simple;
	bh=D/Jr8V1Uxrh3hH2U8FbxMScWi9iLcno6wckYdj66BFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S727vX3HfI2SEuYEMNBQl0WK6/CgyTrHzk5C/xeGYpnnBlOJ+pjjGFxU7SBeugsC9lX6qHZzU+kxShJVGn9b5gGq9+eGuYPLBwO9YOd+rRTk2TcopY4QPL8m78I9hWxNQYQavjLSARd5wrzCaoBPWJ1b4TK42obBezelBtPZ8IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nf52wgUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nf52wgUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F10F1F000CE;
	Mon, 19 Oct 2026 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418538;
	bh=Hto6nE9KVYk77CkOPfGOvroggMqY6F6H5MYcWUQu+u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nf52wgUOrYXPfWrMnTSiznGm2w0RKdDDkTBJhnt88DWiuYb+CQ7QdnwZl5GJ6UaRM
	 W/0xhnTeZg9MsppSZeDcWNDIJdSvMuu29WAUqCbv5fu30yYVcFvYlpqVOFS5X0vZFL
	 DfR6+DXBQme2u1XmNtMAyJ5H5Nk2wRJtQJcEDSzh0YrCj8PlDZtAvOey10c4d/UaSw
	 Gkvk+cQsWVNY3w905i2BxvbbCbaaEqyj1+8w/SZFjosNKtNhp5mXNHMJVfgJfANAA5
	 dGyfYpZ+SjquDEE8hSZ+cqi/IhlgYbBVd0pNK4oPLT4CY4oapdUgP4B8mLpH5llJ65
	 2GcrcKCnxYS9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hari Mishal <harimishal1@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	amit@kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] virtio_console: take a kref in find_port_by_vq() to fix port UAF
Date: Mon, 19 Oct 2026 09:50:10 -0400
Message-ID: <20261019135441.1420968-319-sashal@kernel.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 18dd0b4e489e4f0e3b748cf36ccb909c75a3efab ]

find_port_by_vq() returns a raw struct port pointer without taking a
reference on it, unlike find_port_by_devt_in_portdev() which does.
find_port_by_vq()'s only two callers, in_intr() and out_intr(), run as
virtqueue interrupt callbacks, entirely independent of and possibly
concurrently with unplug_port(), which itself runs from a workqueue when
the host sends a VIRTIO_CONSOLE_PORT_REMOVE control message.

unplug_port() removes the port from portdev->ports under ports_lock,
then later drops its last reference with kref_put(), freeing it via
remove_port(). find_port_by_vq() also walks portdev->ports under
ports_lock, so if it finds the port still on the list, the list removal,
and therefore the eventual kref_put(), has not happened yet, and taking
a reference at that point is always safe. Without doing so,
in_intr()/out_intr() can be left holding a pointer to a port that
unplug_port() frees on another core before they are done using it.

Both triggers are host-controlled as the host decides when to send the
PORT_REMOVE control message and when to kick the port's data vq. So a
malicious backend could race the two on purpose, without any guest side
cooperation. The freed object is a generic kmalloc allocation containing
a wait_queue_head_t, which in_intr()/out_intr() pass to
wake_up_interruptible() after touching the stale pointer.
wake_up_interruptible() invokes a function pointer read out of the wait
queue's entries. If the freed slab slot is reclaimed with attacker
influenced content before that call, then this is an arbitrary function
call primitive rather than just undefined behaviour.

Take a reference in find_port_by_vq() while still holding ports_lock,
matching find_port_by_devt_in_portdev(), and release it in in_intr() and
out_intr() once they are done with the port.

Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Link: https://patch.msgid.link/20260717150622.23636-1-harimishal1@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.6.157** (`pending-6.6`). The virtio_console UAF is
in this tree, and the kref get/put fix is a small, self-contained match
for the existing `find_port_by_devt_in_portdev()` pattern.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[virtio_console] [take / fix] take a kref in
`find_port_by_vq()` to fix port UAF.** Subsystem is the virtio console
character driver. The subject names a use-after-free and the exact
missing refcount.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Signed-off-by:** Hari Mishal \<harimishal1@gmail.com\> (author)
- **Link:**
  https://patch.msgid.link/20260717150622.23636-1-harimishal1@gmail.com
- **Signed-off-by:** Greg Kroah-Hartman \<gregkh@linuxfoundation.org\>
  (char-misc application)
- **No Fixes:** tag (expected for this review)
- **No Cc: stable** (expected; ignored as a negative)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by**
- Ignore pipeline **Signed-off-by: Sasha Levin** / **[Upstream commit
  ...]** if present

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `find_port_by_vq()` returns a raw `struct port *` with no
  `kref_get()`, unlike `find_port_by_devt_in_portdev()`.
- **Race:** `in_intr()` / `out_intr()` (virtqueue callbacks) vs
  `unplug_port()` (workqueue, `VIRTIO_CONSOLE_PORT_REMOVE`).
- **Mechanism:** both walk `portdev->ports` under `ports_lock`. Lookup
  can succeed, drop the lock, then unplug `list_del()`s and later
  `kref_put()` → `remove_port()` → `kfree(port)` while the IRQ path
  still uses the pointer.
- **Symptom:** use-after-free of a kmalloc object that contains a
  `wait_queue_head_t`. `wake_up_interruptible()` follows a function
  pointer from wait-queue entries. If the slab is recycled with
  attacker-controlled content, that is an **arbitrary function call**,
  not just a crash.
- **Trigger:** host-controlled (PORT_REMOVE + data vq kick). A malicious
  virtio backend can race this without guest help.
- **Fix:** `kref_get()` under `ports_lock` in `find_port_by_vq()`;
  `kref_put(..., remove_port)` at the end of `in_intr()` / `out_intr()`.
- **Version info in message:** none.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** This is an explicit UAF/refcount fix, not
cleanup disguised as a fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/char/virtio_console.c` only
- **Scope:** ~14 insertions, 1 deletion (comment + `kref_get` + two
  `kref_put`s)
- **Functions:** `find_port_by_vq()`, `out_intr()`, `in_intr()`
- **Classification:** single-file surgical refcount fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **`find_port_by_vq()`:** before, returned a list pointer after
  dropping `ports_lock`. After, `kref_get(&port->kref)` while still on
  the list and holding the lock; callers must put.
- **`out_intr()`:** still looks up, flushes if missing, then
  `wake_up_interruptible(&port->waitqueue)`; now `kref_put()` after the
  wake.
- **`in_intr()`:** same lookup/inbuf/sigio/wake/hvc path; now
  `kref_put()` after the last use of `port`.
- **Early `if (!port)` returns:** no get was taken, so no put (correct).
- **Path:** virtqueue interrupt/callback vs hot-unplug workqueue.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** **use-after-free / reference counting** (UAF of `struct
  port`).
- **What was broken:** lookup did not pin the object; unplug could free
  it before IRQ handlers finished (waitqueue wake, inbuf,
  `is_rproc_serial(port->portdev->vdev)`, `hvc_poll`).
- **How the fix works:** same lock-held get as
  `find_port_by_devt_in_portdev()`. If the port is still on
  `portdev->ports`, `unplug_port()` has not yet `list_del()`d, so it has
  not yet done the matching `kref_put()`. `kref_get()` is therefore on a
  live ref.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Obviously correct:** matches the 2013 open/close unplug fix
  (`057b82be3ca3d0`) and the existing finder that already takes a kref.
- **Minimal:** no API, no structural change.
- **Regression risk:** low. `remove_port()` in this tree is only
  `kfree(port)`, which is IRQ-safe, so a last `kref_put()` from
  `in_intr()`/`out_intr()` is safe. Puts are at the end of both
  handlers; 6.6 has no extra early return after a successful lookup, so
  get/put is balanced.
- **Residual (not a reason to reject this patch):** `in_intr()` still
  does `is_rproc_serial(port->portdev->vdev)` without a NULL `portdev`
  check. That is a separate NPD if unplug already cleared `portdev`. It
  already exists when a file holds a kref. Sibling series patch 3/4
  addresses it; it is **not** required for kref accounting on this tree.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `find_port_by_vq()` introduced in **`203baab8ba3195`** (“virtio:
  console: Introduce function to hand off data from host to readers”,
  2010-02-24), first in **v2.6.34-rc1**. Present in this 6.6 tree (`git
  merge-base --is-ancestor` succeeded).
- `in_intr()` from **`17634ba25544d6`** (2009). `out_intr()` from
  **`2770c5ea501be6`** (2011).
- **`kref_get` in `find_port_by_devt_in_portdev()`** from
  **`057b82be3ca3d0`** (2013): “fix race with port unplug and
  open/close”, **CC: stable**. Same bug class, same fix pattern, already
  backported historically.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** The missing get was never added for this
finder; the bug is as old as `find_port_by_vq()` / unplug concurrency.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent 6.6 virtio_console commits are unrelated (control-out
buffers, cols/rows, probe). **This UAF fix is not in HEAD**
(`find_port_by_vq()` still has no `kref_get`). Standalone relative to
this tree’s `in_intr()` (no `if (!port->portdev)` early return).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Hari Mishal is not the virtio-console maintainer (MAINTAINERS:
Amit Shah). Greg Kroah-Hartman applied the patch. Related series patches
1–2 touch virtio-mem/virtio_input, not this file.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Originally **patch 4/4** in “virtio: validate device-reported
values across drivers”. Patch 3/4 adds `if (!port->portdev)` in
`in_intr()`; lore diffs of 4/4 therefore had an extra `kref_put` on that
return. **This tree does not have that check** (`if (!port->portdev)`
only in `discard_port_data()` / `reclaim_consumed_buffers()`). The
candidate under review is the form without that hunk, which matches 6.6.
**Can apply standalone.** Patch 3 is complementary, not a build/semantic
prerequisite for this kref change here.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **Lore / msgid:** `20260717150622.23636-1-harimishal1@gmail.com`
  (standalone 2026-07-17 resubmit). Earlier: `[PATCH 4/4]` / `[PATCH v2
  4/4]` 2026-07-15.
- **`b4 mbox` on that msgid:** **1 message in the thread** (no replies).
- **`b4 dig -c <sha>`:** not usable; this SHA is not in the 6.6
  checkout.
- **WebFetch lore.kernel.org:** **403** (could not read lore HTML
  directly).
- Openwall/LKML/Patchew confirm v1 → v2 (comment wording only) →
  standalone resubmit. No NAK found in those archives.
- **UNVERIFIED:** full lore review thread beyond “no replies” from b4.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients included Amit Shah, Arnd Bergmann, Greg Kroah-
Hartman, virtualization@, linux-kernel@. No public Reviewed-by. **Greg’s
SOB** is on the applied commit. Series v1 patches 1 and 3 carried
`Assisted-by: gkh_clanker:t1000`.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No syzbot/bugzilla/CVE found.** Analysis is code-level: host-
controlled race, waitqueue function-pointer UAF. Severity from the
author is crash / possible arbitrary call.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record:
- **3/4** `virtio_console: avoid NULL portdev dereference in in_intr()`
  — NPD on `port->portdev->vdev` after unplug. **Not in this tree.**
  Related, not required for this patch’s get/put balance on 6.6.
- **1/4, 2/4** — virtio-mem / virtio_input validation; independent.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: Web search of lore stable for this subject did **not** find a
prior stable accept/reject. No evidence it was already rejected for
stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

(semcode MCP not available; used grep + file reads.)

**Step 5.1: KEY FUNCTIONS**
Record: `find_port_by_vq`, `in_intr`, `out_intr`; callees `remove_port`,
`unplug_port`, `handle_control_message`.

**Step 5.2: TRACE CALLERS**
Record:
- `find_port_by_vq()`: **only** `in_intr()` and `out_intr()` (verified
  by grep).
- Those are vq callbacks registered in `init_vqs()` (`io_callbacks[j] =
  in_intr` / `out_intr`).
- `unplug_port()`: `handle_control_message()` on
  `VIRTIO_CONSOLE_PORT_REMOVE`, and `virtcons_remove()`.

**Step 5.3: TRACE CALLEES**
Record: `in_intr` uses `get_inbuf`, `discard_port_data`,
`send_sigio_to_port`, `wake_up_interruptible`, `hvc_poll`/`hvc_kick`.
`unplug_port` does `list_del` under `ports_lock`, then inbuf/hvc/sysfs
teardown, then `kref_put`. `remove_port` is `kfree(port)` only.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Guest-visible: virtio-console `/dev/vport*` and hvc console.
Unplug is host-driven (control message). **Reachable** on any VM with
virtio-console and port hot-unplug, and **forcibly racable** by an
untrusted backend. Not a dead config path. `CONFIG_VIRTIO_CONSOLE` is a
normal guest option.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `find_port_by_devt_in_portdev()` already `kref_get()`s under
`ports_lock`. `find_port_by_id()` does not; it is used from the control
work path that also calls `unplug_port()` (same workqueue for
PORT_REMOVE). Different concurrency than vq IRQs.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/char/virtio_console.c`: `find_port_by_vq()` at
309–323 has no `kref_get`; `out_intr` 1734–1745 and `in_intr` 1747–1790
use the raw pointer. Introduced ~v2.6.34. Local tree: **6.6.157**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply expected.** 6.6 `in_intr()` matches the candidate
(no `if (!port->portdev)`). Lore 4/4 needed that extra put; the
candidate already dropped it. Same kref API
(`kref_get`/`kref_put`/`remove_port`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: 2013 open/close kref fix is present. **This vq-interrupt UAF fix
is not.** Patch 3/4 NPD guard is not present in `in_intr()`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **virtio console** (`drivers/char/virtio_console.c`).
**IMPORTANT:** standard VM guest console/serial (`/dev/hvc`,
`/dev/vport*`), QEMU/KVM, clouds, rproc-serial. Not mm/core, but widely
deployed.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (2009–); modest recent churn. Long-lived bug, not
a new-subsystem issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific:** `CONFIG_VIRTIO_CONSOLE`
guests and rproc serial. Large population of VMs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Concurrent **PORT_REMOVE** (or device remove → `unplug_port`)
and **data vq kick**. Legitimate hot-unplug can hit it; a malicious
backend can force it. Guest userspace is not required.
Interrupt/callback vs workqueue.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **UAF** of `struct port`; `wake_up_interruptible()` on a freed
waitqueue. **Severity: HIGH / security-relevant CRITICAL** (crash, or
arbitrary call if the slab is recycled). Host-triggered, so in a fully
trusted-hypervisor model the host is already privileged; it is still a
real guest kernel memory-safety bug and matters for untrusted/vhost-user
backends.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: high** — pins the port for the IRQ path; closes a long-
  standing UAF on a common VM driver.
- **Risk: very low** — ~3 executable lines, existing kref pattern,
  `remove_port` is `kfree`.
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real UAF: vq IRQ vs `unplug_port()`, pointer used after possible
  `kfree`.
- Security-relevant (waitqueue function pointer; host-controlled race).
- Same pattern as `057b82be3ca3d0`, which was **CC: stable**.
- Buggy code present since ~2010; definitely in 6.6.157.
- Small, obviously correct, get/put balanced on this tree.
- virtio-console is a common guest driver.

**AGAINST:**
- No Fixes/Cc-stable/Reported-by/syzbot (not a negative per review
  rules).
- No public review replies on the 2026-07-17 thread.
- Sibling NPD fix (series 3/4) not included; remaining `portdev` NULL
  deref possible. **Does not make this patch wrong.**

**UNRESOLVED:**
- lore.kernel.org HTML 403; b4 showed a 1-message thread only.
- No CVE id found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches existing kref
   finder; Greg applied it. No extra Tested-by, but the change is
   locally verifiable.
2. Fixes a real bug that affects users? **PASS** — UAF on port unplug vs
   data vq.
3. Important issue? **PASS** — UAF / possible arbitrary call;
   HIGH/CRITICAL.
4. Small and contained? **PASS** — one file, ~14 lines.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — 6.6 has the buggy functions;
   candidate already matches this `in_intr()`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Not an exception category.** Ordinary memory-safety bug fix
(the primary stable class).

**Step 9.4: MAKE YOUR DECISION**
Backport to this 6.6.157 tree. It fixes a real, old, host-racable port
UAF with a three-line kref pin that this driver already uses for the
open path.

===============================================================
What this solves for stable users
===============================================================

On 6.6, `find_port_by_vq()` still hands `in_intr()`/`out_intr()` an
unpinned `struct port`. `unplug_port()` can remove it from the list and
drop the last kref (`remove_port()` → `kfree`) while those callbacks
still wake `port->waitqueue`. That is a use-after-free. In VMs that hot-
unplug virtio-console ports, or against a hostile virtio backend, the
guest kernel can oops or worse.

The patch takes a kref under `ports_lock` (safe: still on the list ⇒
unplug has not put yet) and drops it after the last use. That is the
same design as the 2013 stable-bound open/close fix. It does not add
APIs. Residual `portdev == NULL` NPD in `in_intr()` is a separate, older
hole (open ports already hit it); series patch 3/4 would close it later
and is not required for this get/put to be correct here.

Risk is low: `remove_port()` is only `kfree`, so a final put from the vq
callback is fine.

===============================================================
Verification
===============================================================
- **[Phase 1]** Parsed subject/tags/body: UAF + kref; SOB Hari Mishal +
  Greg KH; Link msgid `20260717150622.23636-1-harimishal1@gmail.com`; no
  Fixes/Reported-by.
- **[Phase 2]** Diff: `kref_get` in `find_port_by_vq`; `kref_put` at end
  of `in_intr`/`out_intr`; comment only otherwise.
- **[Phase 2]** Read 6.6 `in_intr`/`out_intr`/`unplug_port`/`remove_port
  `/`handle_control_message`: race and `kfree`-only release confirmed.
- **[Phase 3]** `git describe HEAD` / Makefile: **6.6.157**, HEAD
  `af85e5fc2f380`.
- **[Phase 3]** `git blame` `find_port_by_vq`: `203baab8ba3195`
  (v2.6.34-rc1); `git merge-base --is-ancestor` true.
- **[Phase 3]** `git show 057b82be3ca3d0`: same unplug/kref pattern,
  **CC: stable**.
- **[Phase 3]** grep: no `kref_get` in `find_port_by_vq` on HEAD; only
  two callers.
- **[Phase 4]** Patchew/Openwall/LKML: series 0–4/4, v2 comment-only,
  standalone 17 Jul 2026.
- **[Phase 4]** `b4 mbox` msgid: **1 message**, no replies.
- **[Phase 4]** WebFetch lore: **403**.
- **[Phase 5]** grep callers; `init_vqs` registers `in_intr`/`out_intr`;
  PORT_REMOVE → `unplug_port`.
- **[Phase 6]** 6.6 `in_intr` has no `!port->portdev` early return;
  candidate matches; complementary 3/4 not present.
- **[Phase 7]** Kconfig `VIRTIO_CONSOLE`; MAINTAINERS Amit Shah /
  virtualization list.
- **[Phase 8]** Failure mode: port UAF via waitqueue; HIGH/CRITICAL.
- **UNVERIFIED:** complete lore review beyond b4’s empty thread; CVE
  assignment.

**YES**

 drivers/char/virtio_console.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 76f934b5d84be..750c15966d00e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -304,6 +304,12 @@ static struct port *find_port_by_id(struct ports_device *portdev, u32 id)
 	return port;
 }
 
+/*
+ * Finds a port by the virtqueue and returns a pointer to struct port
+ * with the reference count incremented.
+ *
+ * Callers MUST decrement it when finished.
+ */
 static struct port *find_port_by_vq(struct ports_device *portdev,
 				    struct virtqueue *vq)
 {
@@ -312,8 +318,10 @@ static struct port *find_port_by_vq(struct ports_device *portdev,
 
 	spin_lock_irqsave(&portdev->ports_lock, flags);
 	list_for_each_entry(port, &portdev->ports, list)
-		if (port->in_vq == vq || port->out_vq == vq)
+		if (port->in_vq == vq || port->out_vq == vq) {
+			kref_get(&port->kref);
 			goto out;
+		}
 	port = NULL;
 out:
 	spin_unlock_irqrestore(&portdev->ports_lock, flags);
@@ -1706,6 +1714,7 @@ static void out_intr(struct virtqueue *vq)
 	}
 
 	wake_up_interruptible(&port->waitqueue);
+	kref_put(&port->kref, remove_port);
 }
 
 static void in_intr(struct virtqueue *vq)
@@ -1751,6 +1760,8 @@ static void in_intr(struct virtqueue *vq)
 
 	if (is_console_port(port) && hvc_poll(port->cons.hvc))
 		hvc_kick();
+
+	kref_put(&port->kref, remove_port);
 }
 
 static void control_intr(struct virtqueue *vq)
-- 
2.53.0

