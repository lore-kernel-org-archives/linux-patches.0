Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929BA3EF0A3;
	Tue, 24 Mar 2026 11:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351187; cv=none; b=Ud+edT9DV+2ihzgivzVCcUWIuwRb4WH+OMJ0IC5UAG4ZIBUPO1TYvL+f8Soo4aYkKLrjU7W4swFfUw8MqCsJ1akhQ1QOd6LOEcXyL1ddMTOu4+TLC3duxq50FolpeA9/48ztXD6Rn9Gz9PgfIbdgjfrekAQKMETVVpcAYlIKJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351187; c=relaxed/simple;
	bh=OLXKKHiBPHAQTWM4+ZHHndgcMJT9ozjzLjrRjCSobbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rmc0TeFpQu38Fd/Wd9pEkqU4/iq8En0v5BATpH9Q4RpwHw/2lWcmx7rQci59gYBW4253AzDkUPmIGveoiFqc6DXUSGvNN/vslhjVGqYKGJ+zj1jZcbxDKD7PpP/l3U7sIzKF8scrBNe/r2jg23j7UU/pv8XjBR8sLbCscioYDz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rU8NaSSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rU8NaSSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFEAC19424;
	Tue, 24 Mar 2026 11:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351187;
	bh=OLXKKHiBPHAQTWM4+ZHHndgcMJT9ozjzLjrRjCSobbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU8NaSSoyQIkAVXe9M75u0aa53ecgm6VOqpdoO8+h5ntuG3vEK3n6CIYR7X5HTudN
	 x2CYd8F3kIjxdc5+kfsoD3kzxUx00H0svFPFg3XzcWCWr7HwEsc04AVnYjMDptMhWG
	 b6vxP+YEG4n8UfsFjjoefkydTdy5yagZZztLbsgTAQeBtKo3u+MY38AWdpSreihEY7
	 F+MsG0mAuBZ9EC2uz1r6/k4sH9srOFXgK0/aiaZp9s3dtxQOR3sboiPEFJdwkCFcv8
	 9wvw/G4rf/YkZQc+TJ5I2f3+gRU3wsl1qfxid0lYijdtCz8Qfqic0ulWrvoWBKlCNs
	 ZuD9cf6EkyKUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	ping.cheng@wacom.com,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] HID: wacom: fix out-of-bounds read in wacom_intuos_bt_irq
Date: Tue, 24 Mar 2026 07:19:19 -0400
Message-ID: <20260324111931.3257972-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Transfer-Encoding: 8bit

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit 2f1763f62909ccb6386ac50350fa0abbf5bb16a9 ]

The wacom_intuos_bt_irq() function processes Bluetooth HID reports
without sufficient bounds checking. A maliciously crafted short report
can trigger an out-of-bounds read when copying data into the wacom
structure.

Specifically, report 0x03 requires at least 22 bytes to safely read
the processed data and battery status, while report 0x04 (which
falls through to 0x03) requires 32 bytes.

Add explicit length checks for these report IDs and log a warning if
a short report is received.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a complete analysis. Let me compile
everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** HID: wacom (HID subsystem, Wacom tablet driver)
- **Action verb:** "fix" — explicit bug fix
- **Summary:** Fix out-of-bounds read in wacom_intuos_bt_irq when
  processing short Bluetooth HID reports

### Step 1.2: Tags
- **Signed-off-by:** Benoît Sevens <bsevens@google.com> (author, Google
  — security researcher based on commit history)
- **Reviewed-by:** Jason Gerecke <jason.gerecke@wacom.com> (Wacom
  subsystem maintainer — strong endorsement)
- **Signed-off-by:** Jiri Kosina <jkosina@suse.com> (HID subsystem
  maintainer — merged the patch)
- **No Fixes: tag** — expected for commits under review
- **No Cc: stable** — expected
- **No Reported-by** — likely found through code audit/fuzzing by the
  Google security team

Record: Author is a Google security researcher (has other OOB fix
commits: ALSA, UVC). Reviewed by Wacom maintainer. Merged by HID
maintainer.

### Step 1.3: Commit Body
The bug: `wacom_intuos_bt_irq()` processes Bluetooth HID reports without
checking `len`. A short report causes out-of-bounds reads:
- Report 0x03 needs at least 22 bytes (offset 1 + 10 + 10 + 1 = 22)
- Report 0x04 needs at least 32 bytes (offset 1 + 10 + 10 + 10 + 1 = 32,
  due to fallthrough)
- The commit explicitly mentions "maliciously crafted short report" —
  security implication

Record: Clear security bug — a malicious Bluetooth device can trigger
OOB read. Failure mode is memory disclosure or crash.

### Step 1.4: Hidden Bug Fix Detection
Not hidden — explicitly labeled as a fix for out-of-bounds read. The
author even describes the exact byte thresholds.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 (`drivers/hid/wacom_wac.c`)
- **Lines:** +10 added (two bounds-check blocks with `dev_warn` +
  `break`)
- **Functions modified:** `wacom_intuos_bt_irq`
- **Scope:** Single-file, single-function surgical fix

### Step 2.2: Code Flow Change
**Hunk 1 (case 0x04):**
- Before: Immediately calls `wacom_intuos_bt_process_data(wacom, data +
  1)` regardless of `len`
- After: Checks `len < 32`, warns and breaks if too short

**Hunk 2 (case 0x03):**
- Before: Immediately processes data at offset `i` regardless of `len`
- After: Checks `i == 1 && len < 22` (only when entering directly as
  0x03, not via fallthrough from 0x04), warns and breaks if too short

### Step 2.3: Bug Mechanism
**Category:** Buffer overflow / out-of-bounds read (memory safety)

The function accesses `data[i]` where `i` increments by 10 through
multiple `wacom_intuos_bt_process_data` calls. For report 0x03 (direct
entry, i=1): accesses up to data[21]. For report 0x04 (falls through):
accesses up to data[31]. If `len` is smaller than these values, this
reads beyond the allocated buffer.

With current code (post-5e013ad), `data = kmemdup(wacom->data, len,
GFP_KERNEL)` — heap OOB read.
With old code (pre-5e013ad), `unsigned char data[WACOM_PKGLEN_MAX]` +
`memcpy(data, wacom->data, len)` — reads uninitialized stack data beyond
`len`.

### Step 2.4: Fix Quality
- **Obviously correct:** Yes — the length checks match the exact data
  access patterns
- **Minimal:** Yes — 10 lines, only adds bounds checks
- **Regression risk:** Extremely low — only rejects malformed short
  reports
- **No red flags:** Single function, no API changes, no locking changes

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The vulnerable code was introduced in commit `81af7e61a774e6` ("Input:
wacom - handle Intuos 4 BT in wacom.ko") by Benjamin Tissoires on
2014-08-06. This code was first released in **v3.18**. The bug has been
present for **~12 years** in every kernel version since.

### Step 3.2: Fixes Tag
No Fixes: tag present. The implicit fix target is 81af7e61a774e6 from
2014.

### Step 3.3: File History
The recent commit `5e013ad206895` ("HID: wacom: Remove static
WACOM_PKGLEN_MAX limit") went into v6.15 and changed the function from
using a stack buffer to `kmemdup`. This changes the context for the fix.
Stable trees v6.14 and earlier have the old stack-buffer code.

### Step 3.4: Author
Benoît Sevens (bsevens@google.com) has other security-fix commits:
- `b909df18ce2a9` "ALSA: usb-audio: Fix potential out-of-bound accesses
  for Extigy and Mbox devices"
- `ecf2b43018da9` "media: uvcvideo: Skip parsing frames of type
  UVC_VS_UNDEFINED"
- `082dd785e2086` "media: uvcvideo: Refactor frame parsing code"

This is consistent with a Google security researcher systematically
finding OOB bugs.

### Step 3.5: Dependencies
The fix itself is standalone — it only adds `if (len < N) break;`
checks. However, for stable trees prior to v6.15, the context will
differ (stack buffer vs kmemdup). The fix should still apply with minor
context adjustment.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Lore Search
Found the patch at `https://lore.kernel.org/all/20260303135828.2374069-
1-bsevens@google.com/`. Replies from Jason Gerecke (2026-03-06) and Jiri
Kosina (2026-03-09). No Cc: stable in the original submission. The patch
was accepted and included in a HID pull request for 7.0-rc5 (i.e.,
6.19-rc5).

### Step 4.2: Bug Report
No separate bug report link — this appears to be found through code
audit by the Google security team.

### Step 4.3-4.4: Related Patches / Stable Discussion
This is a standalone single-patch fix. No evidence of related series or
prior stable discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
- `wacom_intuos_bt_irq` — the only function modified

### Step 5.2: Callers
`wacom_intuos_bt_irq` is called from one location:
- `drivers/hid/wacom_wac.c:3490` in the `INTUOS4WL` case of the main
  wacom IRQ handler

This is the Bluetooth HID report interrupt handler for the Wacom Intuos
4 Wireless tablet. It's triggered every time the device sends a
Bluetooth HID report.

### Step 5.3-5.4: Call Chain
The call chain is: HID subsystem receives BT report → `wacom_raw_event`
→ `wacom_wac_irq` → `wacom_intuos_bt_irq`. This is directly reachable
from any Bluetooth HID device claiming to be an Intuos 4 WL tablet. A
malicious BT device can send arbitrary short reports to trigger this.

### Step 5.5: Similar Patterns
Other wacom IRQ handlers (like `wacom_intuos_irq`) may have similar
issues but are not addressed by this commit.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The buggy code (81af7e61a774e6) has been in the kernel since v3.18
(2014). It exists in **ALL** active stable trees (5.10.y, 5.15.y, 6.1.y,
6.6.y, 6.12.y, 6.14.y).

### Step 6.2: Backport Complications
- For v6.15+ stable trees: the fix should apply cleanly (same kmemdup
  code)
- For v6.14 and earlier: the surrounding context differs (stack buffer
  `unsigned char data[WACOM_PKGLEN_MAX]` + `memcpy` instead of
  `kmemdup`). The bounds-check additions themselves are the same, but
  the diff context won't match. Minor adaptation needed.

### Step 6.3: Related Fixes
No prior fix for this issue in any stable tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Subsystem:** HID / Wacom driver (drivers/hid/)
- **Criticality:** IMPORTANT — Wacom tablets are widely used by artists,
  designers, and professionals. Bluetooth variant is common for wireless
  tablets.

### Step 7.2: Activity
The wacom driver is actively maintained by Jason Gerecke, with regular
commits. 43 commits since v5.15.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Users of Wacom Intuos 4 Wireless (Bluetooth) tablets. Also any system
with Bluetooth HID enabled where a malicious device could pair.

### Step 8.2: Trigger Conditions
- A malicious or malfunctioning Bluetooth HID device sends a short
  report (< 22 or < 32 bytes) with report ID 0x03 or 0x04
- This can be triggered by an unprivileged attacker within Bluetooth
  range
- No special configuration needed — just BT HID enabled (very common)

### Step 8.3: Failure Mode Severity
- **Heap OOB read** (current mainline code with kmemdup) → potential
  info disclosure, crash → **CRITICAL**
- **Uninitialized stack data use** (older code with stack buffer) →
  potential info disclosure, incorrect behavior → **HIGH**
- This is a security-relevant vulnerability exploitable via Bluetooth
  proximity

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — fixes a security-relevant OOB read reachable via
  Bluetooth, present for 12 years
- **Risk:** VERY LOW — 10 lines of bounds checking, obviously correct,
  no behavioral change for well-formed reports
- **Ratio:** Strongly favorable for backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes out-of-bounds read — memory safety / security bug
- Bug present since v3.18 (2014) — affects all stable trees
- Exploitable via Bluetooth by any nearby device
- Author is a Google security researcher with track record of finding
  OOB bugs
- Reviewed by the Wacom subsystem maintainer (Jason Gerecke)
- Merged by the HID subsystem maintainer (Jiri Kosina)
- Fix is tiny (10 lines), obviously correct, zero regression risk
- No behavioral change for valid reports

**AGAINST backporting:**
- For stable trees < v6.15, minor context adaptation needed (stack
  buffer vs kmemdup) — manageable
- No explicit Cc: stable in original patch — expected for commits under
  review

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — simple bounds checks matching
   exact data access patterns, reviewed by maintainer
2. **Fixes a real bug?** YES — out-of-bounds read / security
   vulnerability
3. **Important issue?** YES — memory safety bug exploitable via
   Bluetooth
4. **Small and contained?** YES — 10 lines, single function, single file
5. **No new features or APIs?** Correct — only adds validation
6. **Can apply to stable?** YES for v6.15+; needs minor context
   adaptation for older trees

### Step 9.3: Exception Categories
Not an exception category — this is a standard security bug fix (the
primary category for stable).

### Step 9.4: Decision
This is a clear, small, security-relevant fix for an out-of-bounds read
in a Bluetooth HID handler. It has been present for 12 years, is
exploitable by a nearby attacker, was reviewed by the subsystem
maintainer, and carries essentially zero regression risk.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Jason Gerecke (Wacom maintainer),
  SOB Jiri Kosina (HID maintainer), author from Google
- [Phase 1] Author commit history: confirmed 3 other OOB/security fix
  commits (ALSA, UVC)
- [Phase 2] Diff analysis: +10 lines, two bounds checks in
  `wacom_intuos_bt_irq()`, adds `if (len < 32) break;` and `if (i == 1
  && len < 22) break;`
- [Phase 2] Verified math: report 0x04 accesses data[1] through data[31]
  (1+10+10+10+1=32); report 0x03 accesses data[1] through data[21]
  (1+10+10+1=22)
- [Phase 3] git blame: buggy code introduced in 81af7e61a774e6
  (2014-08-06), confirmed in v3.18
- [Phase 3] git show 5e013ad206895: confirmed this changed stack buffer
  to kmemdup, went into v6.15; stable trees have old code
- [Phase 3] Confirmed 5e013ad not in v6.12, v6.13, v6.14 (via merge-
  base)
- [Phase 4] Lore: found patch at
  20260303135828.2374069-1-bsevens@google.com, accepted with replies
  from Gerecke and Kosina
- [Phase 5] Grep callers: `wacom_intuos_bt_irq` called from line 3490 in
  INTUOS4WL case — BT HID interrupt path
- [Phase 6] Bug exists in all stable trees (code from 2014)
- [Phase 8] Failure mode: heap OOB read (mainline) or uninitialized
  stack read (stable), severity CRITICAL/HIGH

**YES**

 drivers/hid/wacom_wac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 9b2c710f8da18..da1f0ea85625d 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1208,10 +1208,20 @@ static int wacom_intuos_bt_irq(struct wacom_wac *wacom, size_t len)
 
 	switch (data[0]) {
 	case 0x04:
+		if (len < 32) {
+			dev_warn(wacom->pen_input->dev.parent,
+				 "Report 0x04 too short: %zu bytes\n", len);
+			break;
+		}
 		wacom_intuos_bt_process_data(wacom, data + i);
 		i += 10;
 		fallthrough;
 	case 0x03:
+		if (i == 1 && len < 22) {
+			dev_warn(wacom->pen_input->dev.parent,
+				 "Report 0x03 too short: %zu bytes\n", len);
+			break;
+		}
 		wacom_intuos_bt_process_data(wacom, data + i);
 		i += 10;
 		wacom_intuos_bt_process_data(wacom, data + i);
-- 
2.51.0

