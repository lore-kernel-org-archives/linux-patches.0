Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958A93EC2F6;
	Tue, 24 Mar 2026 11:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774351198; cv=none; b=QY7dHdtJtsW0/2cNwYV07JZsarNQhFQ+MEjB3AfAUqQJ4luxOPdZa+9XRChkztaXCAUvDVTTQH5gYPyyjBX8wZvnaccXHmxLD0t9bk8XWdcDUHIrQ40icL3Anh9SotvlxZmLjlb337S+k1clwed5tWHW5T461DmtYeSZFbs6jGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774351198; c=relaxed/simple;
	bh=ceoOIjRaWqIw9olt44WtWP0/fFeGmksMY20xvhF0trA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E97o5TcUzDo2JGE7WC8Yw3HErQ38d8TvlOaKwHOwVtScGTw/KrmW9tjmStynZV73KfsE2IC1ayi11yvHfoZGx68LBuwkyEqlQDVw+vPZNaN/hqxXt2+JGlNNio+XouIqXBvN+FstEJCkDIL4xBy61VrlTqyHvwqrNencmAePG50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E82k9LDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E82k9LDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF0CC2BCB3;
	Tue, 24 Mar 2026 11:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351198;
	bh=ceoOIjRaWqIw9olt44WtWP0/fFeGmksMY20xvhF0trA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E82k9LDJWUf1/OqcDQN8Sj/0JDrLCQf7tJ5rfADKuJR8+vGYAOSQgYFrEI3J1PK7d
	 iVs0Qqfm5lZcUedVMhIZHm/lSVvdZ5Mj565lJhwzLX4lV2QN3ifW+CZsRhMYMVy4oZ
	 tg4ArGkeeaFUfJ8B115kHe9yV21k3EmKstKLB2hSRd8q+AyKgFZ7rZpxvL5LLSoBZp
	 mHFrcrslIzzyaIU6F5iLRON3roveap1pMBZGF70w8eqoKk7PXiIiz0BH4GVa9XiF4b
	 MO3Dr5h82//VdZ67SlXSVDISw7wBg4H//+1SLfPn16bVthj2e2ED0lNFBhXi0MThwb
	 ScpMkc9lkbixQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] HID: core: Mitigate potential OOB by removing bogus memset()
Date: Tue, 24 Mar 2026 07:19:27 -0400
Message-ID: <20260324111931.3257972-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260324111931.3257972-1-sashal@kernel.org>
References: <20260324111931.3257972-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

[ Upstream commit 0a3fe972a7cb1404f693d6f1711f32bc1d244b1c ]

The memset() in hid_report_raw_event() has the good intention of
clearing out bogus data by zeroing the area from the end of the incoming
data string to the assumed end of the buffer.  However, as we have
previously seen, doing so can easily result in OOB reads and writes in
the subsequent thread of execution.

The current suggestion from one of the HID maintainers is to remove the
memset() and simply return if the incoming event buffer size is not
large enough to fill the associated report.

Suggested-by Benjamin Tissoires <bentiss@kernel.org>

Signed-off-by: Lee Jones <lee@kernel.org>
[bentiss: changed the return value]
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed to complete the analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `HID: core:`
- Action verb: "Mitigate" (fix-oriented)
- Summary: Removes a memset() that causes OOB reads/writes when incoming
  HID event data is shorter than expected report size.
- Record: [HID core] [Mitigate/fix] [Remove memset that causes OOB
  memory corruption]

**Step 1.2: Tags**
- `Suggested-by: Benjamin Tissoires <bentiss@kernel.org>` — HID co-
  maintainer suggested the approach
- `Signed-off-by: Lee Jones <lee@kernel.org>` — author
- `[bentiss: changed the return value]` — maintainer modified the return
  value
- `Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>` — applied by
  HID maintainer
- No Fixes: tag (expected for candidates)
- No Cc: stable (expected)
- No Reported-by tag
- Record: Suggested and accepted by the HID co-maintainer. Strong
  endorsement.

**Step 1.3: Commit Body**
- Bug: The `memset()` in `hid_report_raw_event()` zeros from `cdata +
  csize` to `cdata + rsize` when `csize < rsize`. However, the actual
  buffer may not be `rsize` bytes — it could be smaller, causing OOB
  writes.
- "as we have previously seen" — acknowledges a history of OOB issues
  from this code.
- The fix: reject short reports entirely with -EINVAL instead of zero-
  padding.
- Record: OOB writes from memset writing past actual buffer boundary.
  Longstanding known issue class.

**Step 1.4: Hidden Bug Fix Detection**
- Not hidden — explicitly describes an OOB vulnerability fix. The word
  "mitigate" and "OOB" make it clear.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files: `drivers/hid/hid-core.c` (+4/-3 lines)
- Function: `hid_report_raw_event()`
- Scope: Single-file, single-function surgical fix
- Record: [1 file, net +1 line] [hid_report_raw_event()] [Single-file
  surgical fix]

**Step 2.2: Code Flow Change**
- BEFORE: When `csize < rsize`, the code logs a debug message and calls
  `memset(cdata + csize, 0, rsize - csize)` to zero-pad the buffer, then
  continues processing.
- AFTER: When `csize < rsize`, the code logs a rate-limited warning and
  returns `-EINVAL` via `goto out`, rejecting the short report entirely.
- Record: [Short report path: zero-pad and continue → reject and return
  -EINVAL]

**Step 2.3: Bug Mechanism**
- Category: **Buffer overflow / OOB write** (memory safety)
- Mechanism: `memset(cdata + csize, 0, rsize - csize)` writes zeros from
  the end of the actual received data to position `rsize`. But the
  underlying buffer (allocated by the transport layer) may only be
  `csize` bytes, meaning the memset writes past the buffer boundary.
- Additionally, subsequent code (like `hid_process_report`) reads up to
  `rsize` bytes from the buffer, causing OOB reads.
- Record: [OOB write from memset] [Buffer may be smaller than rsize,
  memset writes past end]

**Step 2.4: Fix Quality**
- Obviously correct: rejecting a too-short report is safer than
  attempting to zero-pad a buffer of unknown size.
- Minimal: 4 lines changed, net +1 line.
- Regression risk: Some devices that send short reports and relied on
  zero-padding will now have those reports rejected. Tissoires
  acknowledged this ("let's go with it and say sorry if we break some
  devices later on"), meaning the maintainer accepted this tradeoff.
- Record: [High quality, minimal fix] [Low regression risk, maintainer-
  accepted tradeoff]

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The buggy memset line traces to `85cdaf524b7dda` ("HID: make a bus
  from hid code") from 2008-05-16.
- This code has been present since Linux 2.6.26 — it exists in ALL
  active stable trees.
- Record: [Buggy code from 2008, present in all stable trees]

**Step 3.2: Fixes Tag**
- No Fixes: tag present. However, the memset dates to 85cdaf524b7dda
  (2008).

**Step 3.3: File History — Related Changes**
- 966922f26c7fb (2011): Fixed crash from rsize being too large
  (536870912) causing memset crash
- 5ebdffd250988 (2020): Fixed off-by-one in rsize calculation causing
  OOB memset
- b1a37ed00d790 (2023): Added `max_buffer_size` attribute to cap rsize
- ec61b41918587 (2022): Fixed shift-out-of-bounds in the processing
  after the memset
- Record: **Long history of OOB/crash bugs from this exact memset**.
  This is the definitive fix.

**Step 3.4: Author**
- Lee Jones is a prolific kernel contributor and has previously worked
  on HID buffer size hardening (b1a37ed00d790).
- Fix was suggested by and applied by Benjamin Tissoires, HID co-
  maintainer.
- Record: [Experienced author, maintainer-endorsed fix]

**Step 3.5: Dependencies**
- The fix uses `hid_warn_ratelimited`, introduced in commit
  1d64624243af8, which only entered v6.18.
- For stable trees < 6.18, this would need trivial adaptation (use
  `hid_warn` or `dev_warn_ratelimited` instead).
- The companion patch `e716edafedad4` (hid-multitouch report ID check)
  is independent — it adds a defense at the caller level, not a
  prerequisite.
- Record: [Minor dependency on hid_warn_ratelimited macro for older
  trees, trivially resolvable]

## PHASE 4: MAILING LIST RESEARCH

From the lore.kernel.org investigation:
- **v1 (2026-02-27)**: Initial version simply removed the memset
  entirely.
- **Tissoires review (2026-03-02)**: Pushed back — removing memset alone
  isn't enough because `hid_process_report()` would still read OOB.
  Suggested rejecting short reports entirely.
- **v3 (2026-03-09)**: Revised per Tissoires's feedback — now returns
  early with warning.
- **Tissoires final review (2026-03-16)**: Endorsed, changed return to
  -EINVAL, noted "works in 99% of cases" since transport layers allocate
  big enough buffers.
- Applied 2026-03-16, merged to Linus 2026-03-17.
- No explicit stable nomination, but no objections to backporting
  either.
- Record: [Thorough review by HID maintainer, iterated to correct
  approach, accepted]

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**
- `hid_report_raw_event()` — the core HID report processing function.

**Step 5.2: Callers**
- `__hid_input_report()` in hid-core.c (line 2144) — **THE main HID
  input path** for all HID devices
- `wacom_sys.c` — 3 call sites (Wacom tablet driver)
- `hid-gfrm.c` — Google Fiber Remote
- `hid-logitech-hidpp.c` — Logitech HID++
- `hid-primax.c` — Primax keyboards
- `hid-multitouch.c` — multitouch devices
- `hid-vivaldi-common.c` — Vivaldi keyboard
- Record: [Called from core HID input path and multiple drivers — very
  high impact surface]

**Step 5.3-5.4: Call Chain**
- USB HID: `hid_irq_in()` → `hid_input_report()` →
  `__hid_input_report()` → `hid_report_raw_event()`
- This is reachable from any USB HID device event — keyboards, mice,
  touchscreens, gamepads, etc.
- Also reachable from I2C-HID, BT-HID, and other transports.
- Record: [Reachable from any HID device input — universal impact]

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable?**
- The memset dates to 2008. Present in every stable tree.
- Record: [ALL active stable trees contain the buggy code]

**Step 6.2: Backport Complications**
- `hid_warn_ratelimited` only in v6.18+. For older stable trees, trivial
  substitution needed (e.g., `hid_warn`).
- The rest of the code context (csize, rsize, max_buffer_size, goto out)
  is identical in recent stable trees (verified: max_buffer_size was
  added in b1a37ed00d790 from 2023, present in 6.6+).
- Record: [Minor adaptation needed for < 6.18, clean apply otherwise]

**Step 6.3: Related Fixes in Stable**
- Previous mitigations (max_buffer_size capping, off-by-one fix) are in
  stable but didn't eliminate the fundamental OOB risk.
- Record: [No equivalent fix already in stable — this is the definitive
  solution]

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem Criticality**
- HID core — every keyboard, mouse, touchscreen, gamepad, etc. goes
  through this code.
- Criticality: **IMPORTANT** (affects virtually all desktop/laptop
  systems and many embedded devices)

**Step 7.2: Subsystem Activity**
- Very active — multiple fixes per release cycle.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- Every system with HID devices (USB, Bluetooth, I2C) — essentially
  universal for desktops/laptops.

**Step 8.2: Trigger Conditions**
- A HID device sends a report shorter than the expected report size.
- Can be triggered by: malicious USB devices, faulty/buggy HID devices,
  or specific device configurations.
- Potentially exploitable via USB (e.g., BadUSB attacks).
- Record: [Trigger: short HID report] [Moderate likelihood for
  accidental, high for deliberate]

**Step 8.3: Failure Mode**
- **OOB write**: memset writes past buffer boundary → memory corruption,
  potential code execution
- **OOB read**: subsequent `hid_process_report()` reads past buffer →
  info leak or crash
- Severity: **CRITICAL** (OOB writes = security vulnerability, potential
  crash/corruption)

**Step 8.4: Risk-Benefit**
- Benefit: **VERY HIGH** — prevents OOB writes in a core, universally-
  used kernel path. Addresses a class of bugs that has caused multiple
  CVEs/crashes historically.
- Risk: **VERY LOW** — 4-line change, simple logic (reject vs. pad),
  maintainer acknowledged 99% of cases won't be affected, accepted the
  tradeoff.
- Ratio: Strongly favors backporting.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes OOB writes and reads (security-critical memory safety bug)
- In HID core — affects all HID users (universal impact)
- Very small change: 4 lines, single function, single file
- Bug exists since 2008 — present in ALL stable trees
- Long history of crashes/CVEs from this exact memset (966922f, 5ebdffd,
  ec61b41)
- Reviewed and applied by HID co-maintainer (Tissoires)
- Suggested by the maintainer himself
- Fix is the definitive solution after years of band-aid fixes

AGAINST backporting:
- Uses `hid_warn_ratelimited` not available before v6.18 (trivially
  adaptable)
- Tissoires noted potential for breaking devices relying on zero-padding
  (accepted risk)
- No explicit stable nomination (expected for candidates)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — reviewed by maintainer,
   iterated through 3 versions
2. Fixes a real bug? **YES** — OOB write/read in HID core
3. Important issue? **YES** — security vulnerability (OOB write),
   potential crash/corruption
4. Small and contained? **YES** — 4 lines, single function
5. No new features or APIs? **YES** — behavior change only (reject
   instead of pad)
6. Can apply to stable? **YES** — with trivial adaptation for
   hid_warn_ratelimited

**Step 9.3: Exception Categories**
- Not an exception category — this is a standard critical bug fix.

**Step 9.4: Decision**
This is a clear YES. A 4-line fix to a critical OOB write vulnerability
in the core HID input path, present since 2008, with a long history of
related crashes, endorsed by the HID co-maintainer.

## Verification

- [Phase 1] Parsed tags: Suggested-by Tissoires, SOB by Lee Jones and
  Tissoires (maintainer applied)
- [Phase 2] Diff analysis: +4/-3 lines in hid_report_raw_event(),
  replaces memset+dbg_hid with warn+return -EINVAL
- [Phase 3] git blame: buggy memset from commit 85cdaf524b7dda (2008,
  v2.6.26), present in all stable trees
- [Phase 3] git log: found 3 prior fixes to same memset area (966922f,
  5ebdffd, b1a37ed) — confirms recurring issue
- [Phase 3] Author: Lee Jones authored the max_buffer_size hardening
  (b1a37ed), experienced with this code
- [Phase 4] lore.kernel.org: v1 reviewed by Tissoires who requested
  stronger approach; v3 accepted with -EINVAL return; maintainer noted
  "works in 99% of cases"
- [Phase 5] Callers: hid_report_raw_event() called from
  __hid_input_report() (core path) and 6+ drivers
- [Phase 6] hid_warn_ratelimited introduced in v6.18 (1d64624243af8) —
  verified not in v6.12/6.14/6.15/6.16/6.17; needs trivial adaptation
  for older trees
- [Phase 6] Companion patch e716edafedad4 is independent (hid-
  multitouch.c report ID check), not a prerequisite
- [Phase 8] Failure mode: OOB writes via memset → memory corruption,
  severity CRITICAL
- UNVERIFIED: Exact behavior with specific HID devices that send
  intentionally short reports (Tissoires accepted the risk)

**YES**

 drivers/hid/hid-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a5b3a8ca2fcbc..f5587b786f875 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2057,9 +2057,10 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 		rsize = max_buffer_size;
 
 	if (csize < rsize) {
-		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
-				csize, rsize);
-		memset(cdata + csize, 0, rsize - csize);
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %d)\n",
+				     report->id, rsize, csize);
+		ret = -EINVAL;
+		goto out;
 	}
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
-- 
2.51.0

