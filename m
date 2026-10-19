Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F5D5D8C9E;
	Mon, 19 Oct 2026 14:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418520; cv=none; b=JX2K+b1HUMeEBvT6xhVfghpWtczqYOW2uMGkgpXrLgrugR6ngoAGs+S8wCZyuuBJ1m8NLaSEhFYsJyUr3o860NACHHuk4IsZeFaaDSU1v00CBoh7GBdxi9sA3gcQJTI9xi6+TjTGwHUMAFz20heq0H7moKfJAq1Fu4BIZXjAD+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418520; c=relaxed/simple;
	bh=xVlrQCCPLvlPZUtYZiBSos6lm5xTuVXPSafdoKMfSy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h33s08AexxHuffw4ZXZ5Hz0ejf9fqX4LWr8a9hCfjoF7RC7zIW2hwtmn2qICypTK0gX3aUQnX1xP7UshQNtQil5eo5rf29NpvJcoyD7l4TP9eXbdvRPLh+MSi098J2/V/bq2ZnWpV9iDbaWmoDkW0nbuGQgsdR0k6khfreQZkSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YRuxaJ/H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YRuxaJ/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D141F000C6;
	Mon, 19 Oct 2026 14:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418517;
	bh=b26spbF1Vl1IOpw5XyJd8gERKkVg0lpaGkI8sA3Ix9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRuxaJ/HxlRZIri8yE2fd9ppP239FyjJNlcRw7MMtG70aFl/N1GtmQWjDo0UMGI+w
	 QyNSm7B8DWhww8wGn6QVWNhLVsAVxvgV7spdiOaCyiAaogyzQAxD6YI3hN7KDY9c5e
	 MmypHKQO/oMl4EZXe2icRtetK2QYo/GdJ90R9gj9/UdXb35YUsg9FnfRHCWuFqWv35
	 jzkjRGveyk5xoIECOWYhsw1kEnmCE7RQhqQirCqEjAPnIYkOKvw0AXYlB0OKgjgvO+
	 mIDr9s3ZLCVOZ6qYOS4HPpzk0YmYNZYhkTaYGdKeYj1IXBCGDXxaNSksfo3Yo+cGBz
	 dgafh57RG8ZPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmitry Antipov <dmantipov@yandex.ru>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	erazor_de@users.sourceforge.net,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] HID: roccat: fix locking in roccat_connect() and roccat_disconnect()
Date: Mon, 19 Oct 2026 09:49:55 -0400
Message-ID: <20261019135441.1420968-304-sashal@kernel.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d76994443eed0af297cb82bd038ae9d76327ef90 ]

Extend critical section in roccat_connect() to ensure that partially
initialized 'struct roccat_device' is never exposed in 'devices' list,
and do the same in roccat_disconnect() to avoid racy 'devices' access
against roccat_release().

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The buggy
locking is present at `v6.18.57`; this commit is not an ancestor of that
tag.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `HID: roccat`
- Action verb: **fix**
- Claimed intent: correct locking around `roccat_connect()` /
  `roccat_disconnect()` so a half-initialized device is not published
  and disconnect cannot race with `roccat_release()`.
- Record: `[HID/roccat] [fix] [locking around connect/disconnect vs
  devices[] publication]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Upstream `d76994443eed0af297cb82bd038ae9d76327ef90`:
- Signed-off-by: Dmitry Antipov `<dmantipov@yandex.ru>` (author)
- Signed-off-by: Jiri Kosina `<jkosina@suse.com>` (HID maintainer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (expected
  for this review)
- Ignore pipeline `[Upstream commit ...]` and `Signed-off-by: Sasha
  Levin`

The series cover letter for patch 2/2 (not this commit) had:
- Reported-by: syzbot+d632e93ffcd1452bc61e@syzkaller.appspotmail.com
- Closes: https://syzkaller.appspot.com/bug?extid=d632e93ffcd1452bc61e

A competing same-week patch for the same races (Deepanshu Kartikey) had:
- Reported-by: syzbot+c492a9e154f81127551f@syzkaller.appspotmail.com
- Tested-by: syzbot
- Closes: https://syzkaller.appspot.com/bug?extid=c492a9e154f81127551f
  Title: **KASAN: slab-use-after-free Read in roccat_disconnect**

Record: No tags on this commit itself; the same UAF is a documented
syzbot KASAN crash.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Bug: `devices[minor]` is published, then `devices_lock` is dropped
  before `struct roccat_device` is fully initialized. Disconnect also
  drops the lock between lookup and teardown, racing `roccat_release()`.
- Symptom: concurrent open/ioctl/release vs probe/remove can use an
  uninitialized mutex or free the object while disconnect still reads
  `device->open`.
- Version: none stated. Blame shows the pattern since 2010
  (`206f5f2fcb5ff`).
- Root cause (author): critical section too short.

Record: `[UAF / uninitialized-mutex race] [KASAN UAF in disconnect;
possible lock on uninit mutex in open] [present since 2010] [lock
dropped too early]`

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not disguised. Record: `[Not a hidden fix; explicit locking/race fix]`

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY**
- File: `drivers/hid/hid-roccat.c` — 3 insertions, 5 deletions (net −2)
- Functions: `roccat_connect()`, `roccat_disconnect()`
- Record: `[1 file, +3/-5] [roccat_connect, roccat_disconnect] [single-
  file surgical]`

**Step 2.2: CODE FLOW CHANGE**

Hunk 1 — `roccat_connect()` at v6.18.57:
- Before: under `devices_lock`, slot `devices[minor]`,
  `device_create()`, **unlock**, then `init_waitqueue_head`,
  `mutex_init(readers_lock/cbuf_lock)`, set `hid`, `exist`,
  `report_size`.
- After: same work, but unlock only after those initializers.
- Path: probe / `roccat_connect()` from hid-roccat-* drivers.

Hunk 2 — `roccat_disconnect()`:
- Before: lock, load `devices[minor]`, **unlock**; `exist=0`;
  `device_destroy()`; lock, `devices[minor]=NULL`, unlock; then read
  `device->open` and either `hid_hw_close`+wakeup or
  `roccat_free_device()`.
- After: one critical section covering lookup, `exist=0`, destroy, NULL
  slot, free-or-keep.
- Path: USB unplug / driver remove (`savu_remove`, `kone_remove`, etc.).

**Step 2.3: BUG MECHANISM**
Category: **race / UAF** plus **uninitialized mutex**.

Verified against v6.18.57:

1. Connect publishes `devices[minor]` then drops the lock before
   `mutex_init(&device->readers_lock)`. `roccat_open()` takes
   `devices_lock`, then `mutex_lock(&device->readers_lock)`. That is a
   lock on an uninitialized mutex if open wins the race after
   `device_create()`.

2. Disconnect reads `device` and drops the lock. `roccat_release()`
   (also under `devices_lock`) can see `exist==0` and `open==0` and call
   `roccat_free_device()`. Disconnect then reads `device->open` at old
   line 382 — **KASAN slab-use-after-free**. Syzbot’s stack matches:
   freed in `roccat_release`, use in `roccat_disconnect`.

Record: `[race/UAF + uninit mutex] [extend devices_lock so publication
and teardown are atomic vs open/release]`

**Step 2.4: FIX QUALITY**
- Correct for the reported UAF: release and disconnect both need
  `devices_lock` for the whole free-or-keep decision. After this, they
  cannot interleave.
- Correct for the uninit-mutex race: open/ioctl wait on `devices_lock`
  until mutexes exist.
- Minimal; no API change.
- Residual issues (pre-existing, not introduced):
  - If files are still open, disconnect NULLs `devices[minor]` and does
    not free. `roccat_release()` then sees NULL and returns `-ENODEV`
    without `roccat_free_device()` — **leak on unplug-while-open**. That
    was already the non-racy outcome of the old NULL-then-close
    sequence; the racy outcome was UAF. UAF → leak is an improvement.
  - Patch 2/2 (`kref`) was meant to finish lifetime handling; Jiri
    Kosina did **not** apply it (kref accounting bugs).
  - `roccat_report_event()` still loads `devices[minor]` without the
    lock (pre-existing).
- Regression risk: disconnect now holds `devices_lock` across
  `device_destroy()` and `hid_hw_close()`. `roccat_release()` already
  held that lock across `hid_hw_close()`. `device_create()` was already
  inside the lock. hidraw uses the same “hold table lock for the whole
  connect/disconnect” pattern.

Record: `[obviously correct for the UAF; residual leak is pre-existing
common path] [low regression risk]`

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME**
- Buggy unlock-before-init in connect: `206f5f2fcb5ff` (Stefan Achatz,
  2010-05-19), v2.6.35-era.
- Disconnect split lock / `devices[minor]=NULL`: `e6fa47af5542d`
  (2011-01-30).
- Record: `[206f5f2fcb5ff / e6fa47af5542d] [present since ~2010,
  including 6.18.y]`

**Step 3.2: FIXES TAG**
None. Introducer is `206f5f2fcb5ff`, which **is** in this tree.

**Step 3.3: FILE HISTORY**
At v6.18.57:
- `da00eac19feef` HID: roccat: free buffered reports when destroying
  device (already in 6.18.57; this patch only moves the existing
  `roccat_free_device()` call)
- `36bb2d0b91501` HID: roccat: fix use-after-free in roccat_report_event
  (CVE-2026-43111, already in 6.18.24+)

No later commit on this file after the candidate. Standalone 1/2; 2/2
not merged.

**Step 3.4: AUTHOR**
Dmitry Antipov — not the original driver author; HID maintainer Jiri
Kosina applied 1/2. No other Antipov hid-roccat commits in this tree
besides this one.

**Step 3.5: DEPENDENCIES**
- Uses existing `devices_lock` and `roccat_free_device()` (the latter
  from `da00eac19feef`, already in 6.18.57).
- Patch 2/2 is **not** required: maintainer applied 1/2 alone.
- Record: `[standalone; applies on 6.18.57]`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: ORIGINAL DISCUSSION**
`b4 dig -c d76994443eed0af297cb82bd038ae9d76327ef90`:
- https://patch.msgid.link/20260902094551.200587-1-dmantipov@yandex.ru
- Series: **v1 only**, `[PATCH 1/2]` + `[PATCH 2/2] HID: roccat: use
  kref to manage device instances`

Jiri Kosina (11 Sep 2026): **applied 1/2**. On 2/2: “the issues that
Sashiko pointed out with 2/2 are real, so please fix them and resubmit
separately.”

Syzbot bug still listed, but Oct 8 upstream retests reported **no
crash**; later Oct 16 tests are extra lifetime patches in `hid.git
for-7.4/roccat`, not a revert of 1/2.

**Step 4.2: RECIPIENTS (`b4 dig -w`)**
Dmitry Antipov, Jiri Kosina, Benjamin Tissoires, linux-input@, lvc-
project@. HID maintainers were on the To/Cc list.

**Step 4.3: BUG REPORT**
https://syzkaller.appspot.com/bug?extid=c492a9e154f81127551f
- KASAN slab-use-after-free Read in `roccat_disconnect`
- C repro, 20 crashes, prio:high
- Freed in `roccat_release`, used at `if (device->open)` in disconnect
- Trigger: USB disconnect vs close of the roccat char dev (syzbot USB
  gadget)
- Security assessment on the dashboard: DoS exploitable, peripheral
  trigger

**Step 4.4: RELATED SERIES**
- 2/2 kref: not applied (broken accounting / dangling `devices[]`
  pointer).
- Competing Kartikey patch: same disconnect lock extension; also inits
  the device **before** publishing. Maintainer took Antipov’s smaller
  1/2 instead. Disconnect half is equivalent.

**Step 4.5: STABLE LIST**
No prior stable-thread rejection found (lore.kernel.org/stable search
did not return a relevant hit). Absence of Cc: stable is expected.

Record: `[lore thread via b4; 1/2 applied, 2/2 rejected; syzbot KASAN
UAF with C repro]`

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: FUNCTIONS**
`roccat_connect()`, `roccat_disconnect()`.

**Step 5.2: CALLERS**
`roccat_connect` / `roccat_disconnect` from probe/remove of:
- hid-roccat-pyra, ryos, savu, arvo, isku, kone, koneplus, konepure,
  kovaplus

Syzbot crash: `savu_remove` → `roccat_disconnect` on USB disconnect
workqueue vs `roccat_release` from `__fput`.

`devices_lock` also used by `roccat_open`, `roccat_release`,
`roccat_ioctl` — those are the racing syscalls.

**Step 5.3: CALLEES**
`device_create` / `device_destroy`, `hid_hw_close`,
`wake_up_interruptible`, `roccat_free_device`.

**Step 5.4: REACHABILITY**
Yes. Unprivileged USB gadget / physical unplug plus close of
`/dev/roccat*`. Syzbot has a C repro.

**Step 5.5: SIMILAR PATTERNS**
hidraw holds `minors_rwsem` for the whole `hidraw_connect()` /
`hidraw_disconnect()`. Same idea.

Record: `[USB remove vs fput; userspace-reachable; HID-roccat family]`

---

## PHASE 6: CROSS-REFERENCING AGAINST THIS TREE

**Step 6.1: BUGGY CODE IN THIS TREE?**
Yes, at `v6.18.57:drivers/hid/hid-roccat.c` `roccat_connect()` unlocks
at old line 347 before init; `roccat_disconnect()` unlocks at old line
372 then later reads `device->open`.

`git merge-base --is-ancestor 7e1d29620273b v6.18.57` → not an ancestor.
`git merge-base --is-ancestor d76994443eed v6.18.57` → not an ancestor.

**Step 6.2: BACKPORT DIFFICULTY**
`patch --dry-run -p1` of the upstream diff against
`v6.18.57:drivers/hid/hid-roccat.c` → **clean apply**.

**Step 6.3: RELATED FIXES ALREADY HERE**
- `36bb2d0b91501` — different UAF (readers list in
  `roccat_report_event`), already in 6.18.y.
- `da00eac19feef` — leak of cbuf reports, already in 6.18.y.
- This disconnect/open race is **not** fixed in 6.18.57.

Record: `[bug present; clean apply; no substitute fix]`

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** `drivers/hid/hid-roccat.c` — HID char device for Roccat
mice/keyboards (`CONFIG_HID_ROCCAT`, depends on `USB_HID`). Criticality:
**PERIPHERAL**, but the UAF is real for those devices and for syzbot USB
emulation.

**Step 7.2:** Driver is old (2010) and low-churn except recent UAF/leak
fixes. Mature code with a long-standing race, not a new subsystem.

Record: `[HID/roccat] [PERIPHERAL] [mature, recent UAF fixes]`

---

## PHASE 8: IMPACT AND RISK

**Step 8.1:** Users of Roccat HID devices with `CONFIG_HID_ROCCAT`; also
fuzzers/USB gadget. Not universal.

**Step 8.2:** Trigger: unplug (or driver unbind) while userspace has the
char device open/closing. Timing-dependent but **reproduced** (syzbot C
repro). Not a normal unprivileged syscall-only path without USB, but USB
remove is a normal user action.

**Step 8.3:** Failure: KASAN UAF in `roccat_disconnect` on `usb_hub_wq`
→ kernel oops / memory corruption. Severity: **HIGH** (crash, potential
memory-safety issue).

**Step 8.4:**
- Benefit: high for affected hardware / USB remove-vs-close; closes a
  confirmed UAF.
- Risk: low (8-line lock-scope change, same lock already used around
  `hid_hw_close` in release).
- Ratio: **benefit >> risk**. Residual leak on unplug-while-open is
  worse than nothing but far better than UAF.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

For:
- Confirmed KASAN UAF, syzbot C repro, crash on USB disconnect vs
  `roccat_release`
- Second race: open can lock uninitialized `readers_lock`
- Code in 6.18.57 matches the buggy version
- 8-line lock-scope change, clean apply
- HID maintainer applied 1/2 as a standalone fix
- No new API; not a feature
- Same class of fix already accepted for this file (CVE-2026-43111)

Against:
- Niche HID driver
- Incomplete lifetime (leak if unplug while fds remain); 2/2 kref not
  merged
- `roccat_report_event()` still lockless on `devices[]` (pre-existing)
- Connect still publishes the pointer before init, but now under the
  lock so open waits

Unresolved:
- Whether a later hid.git for-7.4 kref series will replace this; that
  does not make 1/2 unsafe for 6.18.y.

**Step 9.2: STABLE RULES**
1. Obviously correct and tested? **PASS** — lock covers the UAF window;
   syzbot repro exists; maintainer applied it.
2. Real bug affecting users? **PASS** — KASAN UAF on unplug vs close.
3. Important (crash/security/corruption)? **PASS** — UAF/oops, HIGH.
4. Small and contained? **PASS** — +3/−5, one file.
5. No new features/APIs? **PASS**.
6. Applies to local tree? **PASS** — clean on v6.18.57.

**Step 9.3: EXCEPTIONS**
Not an ID/quirk/DT/build/docs exception. It is a normal race/UAF fix.

**Step 9.4: DECISION**
Backport to this 6.18.y tree. The bug is here, the fix is small, and it
addresses a real UAF, not a refactor.

---

### What the commit solves for 6.18.y users

On 6.18.57, `roccat_disconnect()` drops `devices_lock` and then reads
`device->open`. Concurrent `roccat_release()` can free that object.
Syzbot hits that as **KASAN slab-use-after-free in
`roccat_disconnect`**. Connect also exposes the object before mutex
init. Extending the existing `devices_lock` critical sections closes
both windows. Remaining leak-if-still-open is the old non-racy path, not
a new regression.

Risk vs benefit: a few lines of lock-scope change vs a demonstrated UAF.
Patch 2/2 is not a prerequisite.

---

Verification:
- [Phase 1] Parsed upstream `d76994443eed`; tags: author SOB + Jiri
  Kosina SOB only
- [Phase 1] Series 2/2 has syzbot `d632e93ffcd1452bc61e`; competing
  patch has syzbot `c492a9e154f81127551f`
- [Phase 2] Diff +3/−5 in `roccat_connect`/`roccat_disconnect`; compared
  to `v6.18.57:drivers/hid/hid-roccat.c`
- [Phase 2] Confirmed open takes `readers_lock` after `devices_lock`;
  connect used to init that mutex after unlock
- [Phase 2] Confirmed disconnect old line 382 is `if (device->open)` —
  matches KASAN “Read of size 4”
- [Phase 3] `git blame -L 309,387 v6.18.57 -- drivers/hid/hid-roccat.c`:
  2010/2011 introducers
- [Phase 3] `git merge-base --is-ancestor 7e1d29620273b v6.18.57` →
  false; not in 6.18.57
- [Phase 3] `da00eac19feef` / `36bb2d0b91501` already in 6.18.57;
  different bugs
- [Phase 4] `b4 dig -c d76994443eed` → msgid
  `20260902094551.200587-1-dmantipov@yandex.ru`
- [Phase 4] `b4 mbox` thread: Jiri applied 1/2, rejected 2/2
- [Phase 4] `b4 dig -w`: Kosina, Tissoires, linux-input
- [Phase 4] WebFetch syzbot: KASAN UAF, C repro, 20 crashes; Oct 8
  upstream retest no crash
- [Phase 5] grep callers: nine hid-roccat-* probe/remove paths; syzbot
  used savu
- [Phase 6] `git describe HEAD` → `v6.18.57-155-gcdf239ca885b2`; `make
  kernelversion` → 6.18.57
- [Phase 6] `patch --dry-run -p1` of upstream diff on v6.18.57 file →
  success
- [Phase 7] Kconfig `HID_ROCCAT` depends on `USB_HID`
- [Phase 8] Failure mode verified from syzbot report, not inferred
- UNVERIFIED: later hid.git for-7.4 kref work (not in this tree; 2/2 was
  rejected from mainline)
- UNVERIFIED: lore.kernel.org HTTP fetch (403); used `b4` +
  openwall/syzkaller instead

The patch is a small, correct UAF/race fix that applies cleanly to this
6.18.57 tree.

**YES**

 drivers/hid/hid-roccat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index e54b6a8a92ef7..77042c7edf765 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -344,8 +344,6 @@ int roccat_connect(const struct class *klass, struct hid_device *hid, int report
 		return temp;
 	}
 
-	mutex_unlock(&devices_lock);
-
 	init_waitqueue_head(&device->wait);
 	INIT_LIST_HEAD(&device->readers);
 	mutex_init(&device->readers_lock);
@@ -356,6 +354,7 @@ int roccat_connect(const struct class *klass, struct hid_device *hid, int report
 	device->cbuf_end = 0;
 	device->report_size = report_size;
 
+	mutex_unlock(&devices_lock);
 	return minor;
 }
 EXPORT_SYMBOL_GPL(roccat_connect);
@@ -369,15 +368,12 @@ void roccat_disconnect(int minor)
 
 	mutex_lock(&devices_lock);
 	device = devices[minor];
-	mutex_unlock(&devices_lock);
 
 	device->exist = 0; /* TODO exist maybe not needed */
 
 	device_destroy(device->dev->class, MKDEV(roccat_major, minor));
 
-	mutex_lock(&devices_lock);
 	devices[minor] = NULL;
-	mutex_unlock(&devices_lock);
 
 	if (device->open) {
 		hid_hw_close(device->hid);
@@ -385,6 +381,8 @@ void roccat_disconnect(int minor)
 	} else {
 		roccat_free_device(device);
 	}
+
+	mutex_unlock(&devices_lock);
 }
 EXPORT_SYMBOL_GPL(roccat_disconnect);
 
-- 
2.53.0

