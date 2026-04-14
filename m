Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F2F3DCD95;
	Tue, 14 Apr 2026 11:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165919; cv=none; b=juUeVMxmZIpyoXCyYdF7wC7v6CT+k7B5C5g69XzQfwVcB3btZOtk+n+mUGRVZfFFC38s6WBL5MyPJEYmB2szpqNrMF0WILwtPPEEXvoU60l1sJ6psXUf0SSxniiil/leOkTCYFZCMwqkf/mbz61BwTWDr7bMH5paZQd91O6pRDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165919; c=relaxed/simple;
	bh=5IWa6TshAWH4hjpYTKzLaOdn0cI8aHPYQMWN5ZlDuYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fitziWF5kkHbeC0tw42aPdRuRoCVCmszm8Nmd7gZaOln0gBbpvMPe5MfAXCZ1Bi7yi10eTnrhNvKyLr7agFelGjGgQ9hKAOGea7Y4xdGRnCf4RImqg051TjC8UYqFLj1KHKlt4srL7i6x01LuqdaxnYGv2G/Ow/Wk31f2gxosEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiAeCH/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiAeCH/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A688C2BCB5;
	Tue, 14 Apr 2026 11:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165919;
	bh=5IWa6TshAWH4hjpYTKzLaOdn0cI8aHPYQMWN5ZlDuYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiAeCH/MwX7x0HA5nWAEjLLsucKbpJNSy9E4oWkxvI4NHUChSE4QzvVSfLI5t3av3
	 5Csqui+FWhOL82e0dX9uhHSlx8dnJPfKaDtWnHWuovWPCAiYZ/Ng3Y+OoA5enxpsvq
	 Rtbvi+fGXFHuzj9OSyv1CojM07o2NIptwePukxv5DAKX/D03fgR74/yhrdY0bO25O3
	 bzZUPHtHCET+xMbsjMcWE9SS1gNxGftDmzG7MLxgiTWqXkwuoYl8ULEmdNZ3whYaep
	 qqEyIiWO/4mRrCyeqQ/7In7tDTBTYL7SktVwsBgnDIoX5tMhYqFde5136IrlvJGWc+
	 i6HI82FTIQ6Eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	erazor_de@users.sourceforge.net,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] HID: roccat: fix use-after-free in roccat_report_event
Date: Tue, 14 Apr 2026 07:25:02 -0400
Message-ID: <20260414112509.410217-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414112509.410217-1-sashal@kernel.org>
References: <20260414112509.410217-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.12
Content-Transfer-Encoding: 8bit

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit d802d848308b35220f21a8025352f0c0aba15c12 ]

roccat_report_event() iterates over the device->readers list without
holding the readers_lock. This allows a concurrent roccat_release() to
remove and free a reader while it's still being accessed, leading to a
use-after-free.

Protect the readers list traversal with the readers_lock mutex.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good. Now I have all the information needed for a complete analysis.

---

## FULL ANALYSIS

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `HID: roccat`
- Action verb: "fix"
- Summary: Fix use-after-free in `roccat_report_event` — a clear bug
  fix.
- Record: [HID: roccat] [fix] [use-after-free when iterating readers
  list without lock]

**Step 1.2: Tags**
- `Signed-off-by: Benoît Sevens <bsevens@google.com>` — Author, Google
  security researcher
- `Reviewed-by: Silvan Jegen <s.jegen@gmail.com>` — Review from external
  developer
- `Signed-off-by: Jiri Kosina <jkosina@suse.com>` — HID subsystem
  maintainer accepted it
- No Fixes: tag, no Cc: stable, no Reported-by — expected for manual
  review candidates
- Record: Accepted by HID maintainer Jiri Kosina. Author is a Google
  security researcher (bsevens@google.com — Benoît Sevens is known for
  kernel security work).

**Step 1.3: Commit Body Analysis**
- Bug: `roccat_report_event()` iterates `device->readers` list without
  holding `readers_lock`
- Race: Concurrent `roccat_release()` can remove and free a reader while
  it's being accessed
- Failure mode: Use-after-free — accessing freed memory
- Fix: Add `readers_lock` around the list traversal
- Record: Clear UAF bug. The race is between report_event (iterating
  readers) and release (freeing a reader). Author explains root cause
  clearly.

**Step 1.4: Hidden Bug Fix?**
- No — this is explicitly labeled as a use-after-free fix. Not disguised
  at all.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/hid/hid-roccat.c`)
- Lines added: 2 (`mutex_lock(&device->readers_lock)` and
  `mutex_unlock(&device->readers_lock)`)
- Lines removed: 0
- Functions modified: `roccat_report_event()`
- Scope: Single-file, single-function, 2-line surgical fix
- Record: Minimal +2 line fix in one function in one file.

**Step 2.2: Code Flow Change**
- BEFORE: `roccat_report_event()` takes only `cbuf_lock`, then iterates
  `device->readers` list
- AFTER: `roccat_report_event()` takes `readers_lock` first, then
  `cbuf_lock`, iterates `device->readers`, then unlocks both in reverse
  order
- The readers list traversal is now protected against concurrent
  modification by `roccat_release()`

**Step 2.3: Bug Mechanism**
- Category: Race condition / Use-after-free
- Mechanism: `list_for_each_entry(reader, &device->readers, node)`
  iterates the readers list. Concurrently, `roccat_release()` at line
  218-221 takes `readers_lock`, calls `list_del(&reader->node)`,
  unlocks, then calls `kfree(reader)`. Without `readers_lock` in
  `report_event`, the iterator can be traversing a reader node that gets
  deleted and freed mid-iteration.
- Record: Classic list-traversal-vs-concurrent-deletion UAF. Fix is
  adding the existing designed-for-this-purpose lock.

**Step 2.4: Fix Quality**
- Obviously correct: The lock `readers_lock` was explicitly designed to
  "protect modifications of readers list" (comment at line 48). It's
  already used in `roccat_open()` (line 169) and `roccat_release()`
  (line 218). The fix simply adds it to the one place that was missing.
- Minimal: Just 2 lines.
- Lock ordering: After fix, `readers_lock` -> `cbuf_lock` in
  `roccat_report_event()`. In `roccat_read()`, only `cbuf_lock` is taken
  (no `readers_lock`). In `roccat_open()` and `roccat_release()`, only
  `readers_lock` is taken (no `cbuf_lock`). No conflicting lock ordering
  exists — no deadlock risk.
- Record: Fix is obviously correct, minimal, and safe. No regression
  risk.

### PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The buggy code (list traversal without `readers_lock`) at line 270 was
  introduced by commit `206f5f2fcb5ff5` (Stefan Achatz, 2010-05-19), the
  original roccat module. This code has been present since Linux
  v2.6.35.
- The `cbuf_lock` around it was added later by `cacdb14b1c8d3` (Hyunwoo
  Kim, 2022-09-04) for v6.1.
- Record: Buggy code from 2010, present in ALL stable trees. The
  readers_lock was always available but never used here.

**Step 3.2: Fixes Tag**
- No Fixes: tag present. Based on blame, the bug was introduced by
  `206f5f2fcb5ff5` (v2.6.35, 2010).

**Step 3.3: File History**
- Recent changes to hid-roccat.c are mostly cosmetic (constify,
  sysfs_emit, etc.)
- The most relevant prior fix is `cacdb14b1c8d3` ("HID: roccat: Fix use-
  after-free in roccat_read()") which added `cbuf_lock` to
  `roccat_report_event()`. This fixed a different UAF (concurrent
  read/write of cbuf), but did NOT address the readers list race.
- This commit is standalone — no dependencies on other patches.

**Step 3.4: Author**
- Benoît Sevens (bsevens@google.com) has 2 other commits visible in the
  tree, both security fixes:
  - `3d78386b14445` "HID: wacom: fix out-of-bounds read in
    wacom_intuos_bt_irq"
  - `b909df18ce2a9` "ALSA: usb-audio: Fix potential out-of-bound
    accesses for Extigy and Mbox devices"
- Pattern: Google security researcher finding and fixing kernel
  vulnerabilities.

**Step 3.5: Dependencies**
- The fix depends on `cbuf_lock` existing in the function (added by
  `cacdb14b1c8d3`, v6.1). For trees v6.1+, this applies cleanly.
- For trees older than v6.1 (5.15, 5.10), the cbuf_lock won't exist, so
  the fix would need minor adaptation (just add readers_lock without the
  cbuf_lock context). But the readers list traversal and the
  readers_lock mutex exist in all trees.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.4:** Lore searches were blocked by Anubis CAPTCHA. Could
not access mailing list discussions. Record: UNVERIFIED — could not
access lore.kernel.org.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- Only `roccat_report_event()` is modified.

**Step 5.2: Callers**
- `roccat_report_event()` is an EXPORT_SYMBOL_GPL function called from
  **16 sites** across 10 different roccat HID drivers (arvo, isku, kone,
  koneplus, konepure, kovaplus, pyra, ryos, savu). It's called from
  their `raw_event` handlers — the main HID event processing path for
  these devices.

**Step 5.3-5.4: Call Chain**
- HID subsystem -> raw_event callback in roccat driver ->
  `roccat_report_event()`
- This is the core event reporting path for all Roccat hardware. Any
  user with a Roccat device who opens the chardev and then
  disconnects/closes while events arrive could trigger the race.

**Step 5.5: Similar Patterns**
- The prior fix `cacdb14b1c8d3` fixed an analogous UAF in this same
  function (cbuf access without lock). The readers_lock omission is the
  same class of bug — incomplete locking.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
- The original code is from v2.6.35 (2010). Present in ALL active stable
  trees.
- The `cbuf_lock` context from `cacdb14b1c8d3` exists in v6.1+. For
  v6.1, v6.6, and v6.12+ stable trees, the patch applies cleanly.
- For v5.15 and v5.10 (if still active), minor adaptation needed.

**Step 6.2: Backport Complications**
- For v6.1+: Clean apply expected — the cbuf_lock lines exist as
  context.
- For older trees: Trivial adaptation (readers_lock wrapping only the
  list traversal).

**Step 6.3: Related Fixes Already in Stable**
- `cacdb14b1c8d3` (cbuf_lock fix) is in v6.1+ stable trees. This new
  commit fixes a DIFFERENT, remaining race in the same function.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** HID subsystem, `drivers/hid/` — IMPORTANT level. Roccat
devices are popular gaming peripherals.

**Step 7.2:** The hid-roccat.c core hasn't changed much since 2022; it's
mature code with long-standing bugs.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- Users of Roccat gaming hardware (keyboards, mice) using the roccat
  chardev for special events. This is a hardware-specific driver but
  Roccat is a well-known peripherals brand.

**Step 8.2: Trigger Conditions**
- Race between: event delivery (`roccat_report_event` from HID event
  handler) and file close (`roccat_release` from userspace close()).
  Triggering requires concurrent device events and chardev fd close.
- An unprivileged user who has access to the device can trigger this
  (open/close the chardev while the device is sending events).
- Security relevance: UAF can potentially be exploited for privilege
  escalation.

**Step 8.3: Failure Mode Severity**
- Use-after-free: Accessing freed `roccat_reader` memory during list
  traversal.
- Consequences: kernel crash/oops, potential memory corruption,
  potential security exploit.
- Severity: **HIGH** (UAF = crash or security vulnerability)

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: High — prevents UAF that can crash the kernel or be
  exploited.
- RISK: Very low — 2-line addition of a mutex that was designed for
  exactly this purpose, consistent lock ordering, no deadlock risk.
- Ratio: Strongly favorable for backporting.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes a real use-after-free bug (HIGH severity)
- 2-line surgical fix — minimal scope
- Obviously correct — uses the existing `readers_lock` for its intended
  purpose
- No regression risk — consistent lock ordering verified
- Author is a Google security researcher (credibility)
- Reviewed-by present, accepted by HID maintainer
- Bug present since 2010 — affects all stable trees
- Called from 16 sites across 10 roccat drivers — affects all Roccat
  hardware users

AGAINST backporting:
- No Fixes: tag (expected — that's why it needs review)
- Could not verify lore discussion (Anubis blocked)
- Minor: comment says "called from interrupt handler" but function
  already uses mutexes (pre-existing, not introduced by this fix)

UNRESOLVED:
- Lore discussion not accessible

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — uses existing lock for its
   documented purpose
2. Fixes a real bug? **YES** — use-after-free in readers list traversal
3. Important issue? **YES** — UAF = crash or security vulnerability
4. Small and contained? **YES** — 2 lines in one function in one file
5. No new features or APIs? **YES** — purely adding missing locking
6. Can apply to stable trees? **YES** — clean for v6.1+, trivial
   adaptation for older

**Step 9.3: Exception Categories**
- Not an exception category — this is a standard bug fix (the best kind
  of stable material).

**Step 9.4: Decision**
This is a textbook stable backport candidate: a small, obviously correct
fix for a use-after-free vulnerability found by a security researcher,
with minimal regression risk.

### Verification

- [Phase 1] Parsed tags: Signed-off-by from author (Google security),
  Reviewed-by present, maintainer SOB (Jiri Kosina)
- [Phase 2] Diff analysis: +2 lines adding mutex_lock/unlock of
  readers_lock around list traversal in roccat_report_event()
- [Phase 2] Lock ordering verified: readers_lock (outer) -> cbuf_lock
  (inner) is consistent; roccat_read() takes only cbuf_lock;
  roccat_open()/release() take only readers_lock (under devices_lock).
  No deadlock path.
- [Phase 3] git blame: buggy code from commit 206f5f2fcb5ff5 (Stefan
  Achatz, 2010, v2.6.35), present in all stable trees
- [Phase 3] Prior fix cacdb14b1c8d3 ("Fix use-after-free in
  roccat_read()") added cbuf_lock but NOT readers_lock — this is a
  different remaining bug
- [Phase 3] Author Benoît Sevens has 2 other security fix commits in the
  tree (wacom OOB read, ALSA OOB access)
- [Phase 5] roccat_report_event() called from 16 sites across 10 roccat
  drivers — core event path for all Roccat hardware
- [Phase 5] Race confirmed: roccat_release() does list_del+kfree under
  readers_lock; roccat_report_event() iterates without lock
- [Phase 6] Buggy code exists in all active stable trees (original from
  2010)
- [Phase 6] Clean apply expected for v6.1+ (cbuf_lock context present)
- [Phase 8] Failure mode: UAF -> kernel crash or potential security
  exploit, severity HIGH
- UNVERIFIED: Could not access lore.kernel.org discussion due to Anubis
  CAPTCHA

**YES**

 drivers/hid/hid-roccat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index c7f7562e22e56..e413662f75082 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -257,6 +257,7 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->readers_lock);
 	mutex_lock(&device->cbuf_lock);
 
 	report = &device->cbuf[device->cbuf_end];
@@ -279,6 +280,7 @@ int roccat_report_event(int minor, u8 const *data)
 	}
 
 	mutex_unlock(&device->cbuf_lock);
+	mutex_unlock(&device->readers_lock);
 
 	wake_up_interruptible(&device->wait);
 	return 0;
-- 
2.53.0

