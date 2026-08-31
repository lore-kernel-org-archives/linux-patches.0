Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DE64AC16E;
	Mon, 31 Aug 2026 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184032; cv=none; b=CiDJvGIHxxFpSm4qBEL3Sq6z/ajh/fPkK6aHmOQSv82x4nzniUOdku2rxfbeKe14EgieJYACxbl6XaDnAiaj/XFXuBtAB0D7llsF4SH6yhTdfv+awcJwnS+yUqVk+QN9AdXO87f4IZ9KVHj7czJC4QVitkt3QU1e117pGC+0o+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184032; c=relaxed/simple;
	bh=4HLHSj2hNPbAHZ9cadIATamuUPAdAIrgBYM6HLn29eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mD0Bu/IMHxD+htwnlCTxxhobR4AGC9Q3NRoqhm0f5tpl8qqXwVroQYLrjtSZXMGyKvUn2tCPDLrt5qEoTIXabIRoicu+MUXjePg8YBT75VSU0Id9QRqB9CuzXzvhBucgNRTnmCjSbvH4WNq0rPHaWbK/S6ZZuSwrQ2hFLBBQJlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqELMC2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqELMC2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EF31F00A3F;
	Mon, 31 Aug 2026 13:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184029;
	bh=5HZRyet8+MTLqu/lbJCKQrGdFi3h0QJUzugXKI2HVOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqELMC2W1PocPavda7kwl/GRLKGUDVTBKHjfgd2exq34kWPMWofkA0ppN5w42uRKn
	 NNBhQ1oKfqpoX7/8RjzIGJt9ft1NN474N7LeWbQDwHzLh5VIxu3ywJsFMzcWupiIuy
	 Pp0b2R5hnEGkYhwfOO3Ci7jMM6puxzSDq5fJkeXTgDyqBCvXy52lU/Xy/097pjCd/w
	 lpjPB1aFfYPrf7AcNXXuhT/MjI6INUWFXxCQApchiG9Sef3ylsNJZLAsWIm9wMnODJ
	 k1oNvA5rzQbpl6ygChBIqwzMZIx2f84gHs63hcWTJ0zDm9LyqHd+R6CjrHRqtyndi7
	 POXn7eylmKsJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stepan Ionichev <sozdayvek@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: gadget: goku_udc: avoid NULL deref of dev->driver in INT_USBRESET log
Date: Mon, 31 Aug 2026 09:27:56 -0400
Message-ID: <20260831133314.4125787-448-sashal@kernel.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 5bf5e3fba9bc7dfd69701521dbe9809f8ccbdb02 ]

goku_irq() handles a number of bus events under a single ep0 path.
It already guards the gadget driver suspend/resume callbacks against a
NULL ->driver:

	if (dev->gadget.speed != USB_SPEED_UNKNOWN
			&& dev->driver
			&& dev->driver->resume) {
		spin_unlock(&dev->lock);
		dev->driver->resume(&dev->gadget);
		...
	}

but the very next branch unconditionally dereferences dev->driver
when an INT_USBRESET arrives:

	if (stat & INT_USBRESET) {
		ACK(INT_USBRESET);
		INFO(dev, "USB reset done, gadget %s\n",
			dev->driver->driver.name);
	}

If the controller raises INT_USBRESET before any gadget driver has
been bound (or after one has been unbound), dev->driver is NULL and
the printk dereferences NULL.

smatch flags the inconsistency:

  drivers/usb/gadget/udc/goku_udc.c:1618 goku_irq() error:
  we previously assumed 'dev->driver' could be null (see line 1607)

Fall back to a placeholder when the gadget driver is not bound.

No functional change while a gadget driver is bound.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260509110636.19762-1-sozdayvek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[usb: gadget: goku_udc]` `[avoid]` — avoid NULL dereference
of `dev->driver` in the `INT_USBRESET` logging path inside `goku_irq()`.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none (smatch static analysis instead)
- **Tested-by:** — none
- **Reviewed-by:** — none in message
- **Acked-by:** — none
- **Link:**
  `https://patch.msgid.link/20260509110636.19762-1-sozdayvek@gmail.com`
- **Cc: stable:** — not present (expected)
- **Signed-off-by:** Stepan Ionichev `<sozdayvek@gmail.com>`, Greg
  Kroah-Hartman `<gregkh@linuxfoundation.org>`
- **Notable:** smatch-detected inconsistency; Greg KH merged it (USB
  maintainer)

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `goku_irq()` unconditionally dereferences
  `dev->driver->driver.name` on `INT_USBRESET`, while adjacent
  suspend/resume code already treats `dev->driver` as possibly NULL.
- **Symptom:** NULL pointer dereference in interrupt context → kernel
  oops.
- **Trigger:** `INT_USBRESET` before a gadget driver is bound, or after
  one is unbound.
- **Root cause:** Inconsistent NULL handling in the same function;
  logging path missed the guard.
- **Version info:** None stated; code dates to original driver import
  (2005).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit NULL-deref fix. smatch
flagged the inconsistency between line 1607 (NULL check) and line 1619
(unconditional deref).

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/usb/gadget/udc/goku_udc.c` (+2 / -1)
- **Function:** `goku_irq()`
- **Scope:** Single-file, surgical fix (one logging expression)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `INFO(dev, "USB reset done, gadget %s\n",
  dev->driver->driver.name);` — always dereferences `dev->driver`.
- **After:** Ternary: `dev->driver ? dev->driver->driver.name : "<not
  bound>"`.
- **Path:** IRQ handler, `INT_USBRESET` branch under `INT_DEVWIDE`;
  normal USB bus-reset event path.

### Step 2.3: Bug Mechanism
**Record:** **Category:** NULL pointer dereference. **Mechanism:** `%s`
format argument evaluates `dev->driver->driver.name` before `printk`;
when `dev->driver` is NULL, this faults in IRQ context.

### Step 2.4: Fix Quality
**Record:** Obviously correct. Matches the existing pattern at line 1158
in the same file (`dev->driver ? dev->driver->driver.name : "(none)"`).
Minimal change, no behavior change when a driver is bound. Regression
risk: very low.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy lines introduced in `1da177e4c3f41` (Linus Torvalds,
2005-04-16) — present since initial import. Long-standing latent bug.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Related commits in this tree:
- `0d66e04875c5a` — probe-time NULL deref fix (different bug)
- `37a757e31d992` — cast cleanup on `driver.name`
- `2a334cfaf3931` — memory leak in `goku_probe()`
- Standalone one-patch fix; not part of a series.

### Step 3.4: Author Context
**Record:** Stepan Ionichev has other NULL-deref fixes in this tree
(e.g. `1f6a4aec0d366` rtc/msc313). Not the goku_udc maintainer, but
submits credible static-analysis-driven fixes.

### Step 3.5: Dependencies
**Record:** No dependencies. Patch applies cleanly (`git apply --check`
succeeded). Self-contained.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:** `b4 am` retrieved the mbox from lore. `b4 dig -c` failed
(commit not in this tree). lore.kernel.org blocked by bot protection;
full thread not readable via WebFetch. Mbox contains only the initial
patch, no review replies.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` unavailable (no commit hash). Mbox shows only
author SOB; Greg KH SOB on committed version indicates maintainer
acceptance.

### Step 4.3: Bug Report
**Record:** smatch static analysis report in commit message. No syzbot,
no user crash reports. smatch cross-reference to line 1607 is concrete
evidence.

### Step 4.4: Related Patches
**Record:** Standalone; no series dependencies.

### Step 4.5: Stable List History
**Record:** Not searched (lore blocked). No stable nomination found in
available sources.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `goku_irq()` (modified), context: `ep0_start()`,
`udc_enable()`, `goku_udc_start()`, `goku_udc_stop()`.

### Step 5.2: Callers
**Record:** `goku_irq()` registered via `request_irq()` in
`goku_probe()` at line 1805. Runs in hard/IRQ context on every
controller interrupt.

### Step 5.3: Callees
**Record:** `readl()`, `writel()`, `ACK()` macro, `INFO()` macro (wraps
`printk`), `ep0_setup()`, suspend/resume callbacks.

### Step 5.4: Call Chain / Reachability
**Record:** Reachable path verified in code:
1. `goku_probe()` registers IRQ (line 1805) before any gadget driver
   binds.
2. On USB connect, `INT_PWRDETECT` → `ep0_start()` (line 1566) enables
   `INT_DEVWIDE | INT_EP0` (line 1340), which includes `INT_USBRESET`.
3. `ep0_start()` can run with `dev->driver == NULL` (driver binds later
   via `goku_udc_start()` at line 1378).
4. Host USB reset → `INT_USBRESET` → unconditional
   `dev->driver->driver.name` deref → oops.

Also reachable after `goku_udc_stop()` sets `dev->driver = NULL` (line
1410) or `INT_SYSERROR` clears it (line 1559).

### Step 5.5: Similar Patterns
**Record:** Same file line 1158 already uses `dev->driver ?
dev->driver->driver.name : "(none)"`. `pxa25x_udc.c` uses the same
idiom. This fix brings `goku_irq()` in line with established convention.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **v6.18.44** (`VERSION=6`,
`PATCHLEVEL=18`, `SUBLEVEL=44`). Buggy code at lines 1618–1619:

```1616:1620:drivers/usb/gadget/udc/goku_udc.c
                if (stat & INT_USBRESET) {              /* hub reset
done */
                        ACK(INT_USBRESET);
                        INFO(dev, "USB reset done, gadget %s\n",
                                dev->driver->driver.name);
                }
```

Bug present since 2005 import; not introduced after this tree branched.

### Step 6.2: Backport Complications
**Record:** Clean apply confirmed. No conflicting changes in this hunk.
Expected difficulty: **clean apply**.

### Step 6.3: Related Fixes Already Present?
**Record:** `0d66e04875c5a` (probe crash fix) is present. This specific
`INT_USBRESET` NULL-deref fix is **not** present.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/usb/gadget/udc/` — USB gadget UDC driver.
**PERIPHERAL** (niche Toshiba TC86C001 PCI hardware, `CONFIG_USB_GOKU`).

### Step 7.2: Subsystem Activity
**Record:** Low churn recently; mostly header moves and minor cleanups.
Mature, legacy driver.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_USB_GOKU` (Toshiba TC86C001 "Goku-S" PCI
UDC). Small but real embedded/legacy population.

### Step 8.2: Trigger Conditions
**Record:** USB cable connect → host bus reset before gadget driver
bind; or reset after driver unbind/error. **Moderately likely** during
normal enumeration. Not userspace-syscall reachable; requires the
hardware and USB activity.

### Step 8.3: Failure Mode Severity
**Record:** NULL deref in IRQ handler → **kernel oops** (system crash).
**Severity: HIGH** for affected hardware.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents IRQ-context crash on a normal enumeration path;
  smatch-verified real bug.
- **Risk:** Minimal (2-line ternary, matches existing file pattern).
- **Ratio:** Favorable — low risk, real crash prevention.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real NULL pointer dereference in IRQ handler
- Reachable before gadget driver bind (verified call chain)
- Kernel oops when triggered
- smatch static analysis confirmation
- 2-line surgical fix, obviously correct
- Matches existing pattern in same file (line 1158)
- Applies cleanly to v6.18.44
- Greg KH merged (USB maintainer)
- Bug present since 2005 — affects all stable trees with this driver

**AGAINST backport:**
- Niche hardware (`CONFIG_USB_GOKU`)
- Only affects logging path (but deref happens evaluating format args,
  so it still crashes)
- No user crash reports or syzbot report
- Limited mailing-list review visibility

**Unresolved:** Full lore review thread not accessible (bot protection).
No explicit stable nomination found.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — trivial ternary, smatch-
   verified, maintainer-merged.
2. Fixes a real bug affecting users? **PASS** — NULL deref on real
   hardware enumeration path.
3. Important issue? **PASS** — IRQ-context NULL deref → kernel oops
   (HIGH severity for affected users).
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features or APIs? **PASS** — logging safety only.
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: Exception Categories
**Record:** None (not device ID, quirk, DT, build fix, or docs).
Standard bug fix.

### Step 9.4: Decision Rationale

For **this tree (6.18.44)**, the buggy code exists and is reachable:
`ep0_start()` enables `INT_USBRESET` handling on USB connect before any
gadget driver binds, so a host bus reset can trigger a NULL dereference
in `goku_irq()`. The fix is minimal, follows an existing idiom in the
same driver, and prevents a kernel oops on affected hardware. While the
driver serves niche legacy hardware, stable trees routinely accept small
NULL-deref fixes in drivers when the crash path is real and the fix is
obviously safe.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message and mbox file
- **[Phase 1]** Confirmed: no Fixes:/Reported-by:/Cc: stable tags;
  smatch reference in body
- **[Phase 2]** Diff: +2/-1 in `goku_irq()`, ternary NULL guard on
  `dev->driver`
- **[Phase 3]** `git blame -L 1616,1620`: buggy code from
  `1da177e4c3f41` (2005)
- **[Phase 3]** `git log --oneline -20 --
  drivers/usb/gadget/udc/goku_udc.c`: related fixes listed; no duplicate
  of this fix
- **[Phase 3]** `git apply --check`: patch applies cleanly
- **[Phase 4]** `b4 dig -c ac2a984c2f87e`: failed (commit not in tree)
- **[Phase 4]** `b4 am` on message-id: retrieved mbox with patch content
- **[Phase 4]** WebFetch lore URL: blocked by bot protection
  (UNVERIFIED: review thread content)
- **[Phase 5]** Read `goku_irq()`, `ep0_start()`, `goku_probe()`,
  `goku_udc_start/stop`: confirmed reachable NULL-deref path
- **[Phase 5]** `grep dev->driver`: line 1158 has existing NULL-guard
  pattern; line 1619 does not
- **[Phase 5]** `goku_udc.h`: `INT_USBRESET` part of `INT_DEVWIDE`;
  enabled by `ep0_start()`
- **[Phase 6]** `git describe HEAD`: v6.18.44
- **[Phase 6]** `head Makefile`: VERSION=6, PATCHLEVEL=18, SUBLEVEL=44
- **[Phase 6]** Read lines 1616–1620: buggy code confirmed present
- **[Phase 7]** Kconfig: `CONFIG_USB_GOKU` — Toshiba TC86C001 PCI device
- **[Phase 8]** Failure mode: IRQ NULL deref → oops, severity HIGH for
  affected hardware

**YES**The commit **should be backported** to this tree (v6.18.44).

**Summary:** `goku_irq()` can NULL-dereference `dev->driver` when
handling `INT_USBRESET` during USB connect/reset before a gadget driver
is bound — a path `ep0_start()` enables on cable connect. The fix is a
2-line ternary that matches an existing pattern in the same file (line
1158), applies cleanly, and prevents an IRQ-context kernel oops on
`CONFIG_USB_GOKU` hardware.

**Verdict: YES**

 drivers/usb/gadget/udc/goku_udc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/goku_udc.c
index b860c2e764494..c262749a29cc7 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1616,7 +1616,8 @@ static irqreturn_t goku_irq(int irq, void *_dev)
 		if (stat & INT_USBRESET) {		/* hub reset done */
 			ACK(INT_USBRESET);
 			INFO(dev, "USB reset done, gadget %s\n",
-				dev->driver->driver.name);
+				dev->driver ? dev->driver->driver.name :
+					      "<not bound>");
 		}
 		// and INT_ERR on some endpoint's crc/bitstuff/... problem
 	}
-- 
2.53.0

