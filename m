Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ABB517BCD;
	Mon, 31 Aug 2026 13:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183810; cv=none; b=S/yxAAMR4DB9PyGcRqRg7DrDoH0O8EMOjkI/DPvR0Q452Gz2wrUzs3ivEbHIbNqUeZuI3kd1s+7GeCnGdDNcelvWqARkYYdFHsLrDs9BoAduGoZx8vjSlAXyTNEhM06Aaa/78Yzbr2YyrVn9zDZAUp4rrTcvs9TQOjuZCiPkR+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183810; c=relaxed/simple;
	bh=sfbeHYVURt/JMyaDFoxCdkiRi4qgIwKulZlT+yhFceE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BYT5tRblKowHFb9GiN4+mdR/CsSu41ytugpcQ95G7dAHBT0Cj0txPeCPpKWxyF18VC43uxx6z8ACDq+A+o8QDKg3UTg6eZ+TR0BYVMUlLA/0UG1qYmKZzXgKM31PndXsu1ppdiHnlidcqJj3jzJSgHQZRlz7akal93i6O7GAtjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4qcZKEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4qcZKEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFC41F00A3E;
	Mon, 31 Aug 2026 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183806;
	bh=w5aSWtgEz4L2lqYN/2TLjCfJYpJbQprr2NkSEkimnV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4qcZKEbKsc3a5ckvEYqFSm+G+8gY28V0EZoCu1V7vSh09L6kJTAXw8s9fB9hEPRJ
	 FjF4gmIOGGkh1OIPL6l9fGKRHjuZ98lFZVBCJQ93JAhQthQlCdtQS241bdgL/X5CPo
	 sX7gbPnqfRh0LUkJLnQh2i+1dppB/MxVqey3+AKZwyp4dn+slwRs1FLLpABhbaWRM6
	 MsD61+UYEHLAYjgTgxtU6DohtWDjkK1ENZCUoQQfgreMWkN7nSkF1E7VzXi8xEJMev
	 LFcJ/bMnOSjI5s3Kb0tBzN2osvIHrTHLJpiuNP0m82Zs58iM4QQMURpt+p1P8SlGb6
	 QppkeqHggm2ew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oliver Neukum <oneukum@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: core: hcd: fix possible deadlock in rh control transfers
Date: Mon, 31 Aug 2026 09:25:44 -0400
Message-ID: <20260831133314.4125787-316-sashal@kernel.org>
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

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit d5559f43d76b398392b26a15cbc16d731969cd1c ]

>From within the SCSI error handler memory allocations must not
trigger IO. Handling errors in UAS and the storage driver may
involve resetting a device. The thread doing the reset itself
relies on VM magic. However, that is insufficient, as resetting
a device involves resuming it. Resumption as well as resetting
involves conrol transfers to the parent of the device to be reset.
That may be a root hub. Hence usbcore must heed the flags passed
to usb_submit_urb() processing control transfers to root hubs.

The problem exist since the storage driver has been merged.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260429094413.181038-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[usb: core: hcd]` `[fix]` — fix possible deadlock in root-
hub (rh) control transfers.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by / Acked-by:** — none
- **Link:**
  `https://patch.msgid.link/20260429094413.181038-1-oneukum@suse.com`
- **Cc: stable@vger.kernel.org** — not present (not a negative signal)
- **Signed-off-by:** Oliver Neukum `<oneukum@suse.com>`, Greg Kroah-
  Hartman `<gregkh@linuxfoundation.org>`
- **Notable:** Greg K-H merge; same author (Oliver Neukum) has prior USB
  deadlock fixes nominated for stable (e.g. UAS EH deadlock, commit
  `f6cc6093a729e`)

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** SCSI error-handler context must not perform allocations that
  trigger I/O. USB storage/UAS error recovery can reset devices;
  reset/resume issues control transfers to the parent hub, which may be
  the root hub. `usbcore` ignored `mem_flags` from `usb_submit_urb()`
  for root-hub control transfers.
- **Symptom:** Possible deadlock when storage error recovery resets a
  device on a root-hub port.
- **Root cause:** `rh_call_control()` hardcodes `kzalloc(...,
  GFP_KERNEL)` while callers (e.g. `usb_start_wait_urb()`) submit with
  `GFP_NOIO`.
- **Version info:** “The problem exist since the storage driver has been
  merged” — longstanding, not a recent regression.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicit deadlock fix. Propagating
`mem_flags` is the correct API behavior documented in
`drivers/usb/core/urb.c`.

---

## Phase 2: Diff Analysis

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/usb/core/hcd.c` only (~15 lines changed)
- **Functions:** `rh_call_control()`, `rh_urb_enqueue()`,
  `usb_hcd_submit_urb()`
- **Scope:** Single-file surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (`rh_call_control`):** Before: `kzalloc(tbuf_size,
  GFP_KERNEL)`. After: `kzalloc(tbuf_size, mem_flags)` with new `gfp_t
  mem_flags` parameter.
- **Hunk 2 (`rh_urb_enqueue`):** Before: calls `rh_call_control(hcd,
  urb)` without flags. After: passes `mem_flags` through.
- **Hunk 3 (`usb_hcd_submit_urb`):** Before: `rh_urb_enqueue(hcd, urb)`
  drops caller flags. After: `rh_urb_enqueue(hcd, urb, mem_flags)` —
  matches the non-root-hub path that already passes `mem_flags` to
  `hcd->driver->urb_enqueue()`.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Deadlock / incorrect GFP context in block/SCSI error-
  recovery path
- **Mechanism:** `usb_submit_urb(urb, GFP_NOIO)` →
  `usb_hcd_submit_urb(urb, mem_flags)` → for root-hub devices,
  `rh_call_control()` allocated with `GFP_KERNEL`, which can trigger
  reclaim/I/O. In SCSI error-handler context (recovering a stuck block
  device), that can deadlock waiting on I/O from the same device stack.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct — mirrors existing non-root-hub
  behavior; minimal change
- **Regression risk:** Very low — only affects root-hub control path;
  honors caller intent
- **Red flags:** None

---

## Phase 3: Git History Investigation

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- `kzalloc(tbuf_size, GFP_KERNEL)` introduced in `e57e780b346a72` (“usb:
  rh_call_control tbuf overflow fix”, 2013-08-13)
- Buggy pattern present since 2013; relevant since USB storage error
  paths use `GFP_NOIO`

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag — N/A

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Recent `hcd.c` changes are unrelated (SuperSpeed root hub
wMaxPacketSize, kcov, dma-noncoherent API). Standalone fix, not part of
a series.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Oliver Neukum is an experienced USB contributor; prior
stable-nominated deadlock fixes in USB storage/UAS (`f6cc6093a729e`).

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies — self-contained signature/plumbing change
within one file. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c` failed (commit not in this tree).
Lore/patch.msgid.link fetch blocked (403/Anubis). **UNVERIFIED:** full
review thread content.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** **UNVERIFIED** (thread inaccessible). Greg K-H merge is a
strong quality signal.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report or syzbot link. Mechanism explained
in commit message and verifiable in code.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone 1-patch fix; related theme with author’s UAS EH
deadlock fix but independent.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** **UNVERIFIED** (could not search lore). No evidence against
stable suitability.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `rh_call_control()`, `rh_urb_enqueue()`,
`usb_hcd_submit_urb()`

### Step 5.2: TRACE CALLERS
**Record:**
- `usb_hcd_submit_urb()` ← `usb_submit_urb()` (`drivers/usb/core/urb.c`)
- `usb_submit_urb(urb, GFP_NOIO)` used widely in block/storage paths:
  - `usb_start_wait_urb()` → `usb_control_msg()` path (`message.c:62`)
  - `usb_stor_msg_common()` → `transport.c:143`
  - `hub.c` hub operations (`usb_clear_port_feature`, port reset/resume)
- SCSI error handler → `eh_device_reset_handler` → e.g.
  `uas_eh_device_reset_handler()` → `usb_reset_device()` (`uas.c:796`),
  or `usb_stor_port_reset()` → `usb_reset_device()` (`transport.c:1455`)
- `usb_reset_device()` performs hub port reset/resume; parent may be
  root hub → root-hub control transfers

### Step 5.3: TRACE CALLEES
**Record:** `rh_call_control()` calls `kzalloc()` (the problematic
allocation), `usb_hcd_link_urb_to_ep()`, hub descriptor handling.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:**
```
SCSI EH thread → eh_device_reset_handler → usb_reset_device()
  → hub_port_reset / usb_port_resume → usb_control_msg /
usb_submit_urb(GFP_NOIO)
    → usb_hcd_submit_urb(mem_flags=GFP_NOIO) → rh_urb_enqueue →
rh_call_control
      → kzalloc(GFP_KERNEL)  [BUG]
```
Reachable from normal storage error recovery on root-hub ports (common
on laptops/embedded).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `usb_reset_device()` already uses `memalloc_noio_save()` as
a partial workaround (`hub.c:6384–6436`), but root-hub path still
violated the explicit `GFP_NOIO` contract. Non-root-hub `urb_enqueue`
already honors `mem_flags`; root hub was the outlier.

---

## Phase 6: Cross-Referencing Against the Local Tree

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Tree is **v6.18.44** (`VERSION=6`, `PATCHLEVEL=18`,
`SUBLEVEL=44`). Buggy code at `hcd.c:489` (`kzalloc(tbuf_size,
GFP_KERNEL)`) and `hcd.c:1540` (`rh_urb_enqueue(hcd, urb)` without
`mem_flags`). Fix not yet applied.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply** — local file matches the “before”
state in the provided diff; low recent churn in this area.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No equivalent fix found (`grep` for
`rh_call_control.*mem_flags` returns nothing). `usb_reset_device()`’s
`memalloc_noio_save()` workaround exists but does not replace this fix.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **USB core** (`drivers/usb/core/`) — **CORE/IMPORTANT**.
Affects all USB users; deadlock hits common storage error-recovery path.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained; Greg K-H USB tree. Fix addresses
longstanding API inconsistency.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users with USB mass-storage/UAS devices, especially on root-
hub ports, during I/O errors triggering SCSI error-handler device reset.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Storage I/O error → SCSI EH device/bus reset → USB port
reset/resume on root hub. Not every boot, but realistic during error
recovery. Unprivileged users can trigger via normal block I/O to USB
storage.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Deadlock / hung task** in SCSI error-handler context —
**CRITICAL** (storage stuck, system may require reboot; no clean
recovery).

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents real deadlock in error recovery
- **Risk:** VERY LOW — ~15 lines, propagates existing parameter, matches
  non-root-hub behavior
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real deadlock in SCSI/USB storage error recovery
- CRITICAL severity (system hang)
- Small, surgical, obviously correct
- Buggy code confirmed in v6.18.44
- Honors documented `GFP_NOIO` contract in `urb.c`
- Greg K-H merged; author has track record of similar stable fixes
- No new features/APIs

**AGAINST backport:**
- No syzbot/user report (mechanism-based fix)
- Mailing list review details unverified

**UNRESOLVED:**
- Full lore review thread inaccessible

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — logic is clear; Greg K-H
   merge
2. Fixes a real bug affecting users? **PASS** — SCSI EH + USB storage
   reset path
3. Important issue? **PASS** — deadlock/hang, CRITICAL
4. Small and contained? **PASS** — single file, ~15 lines
5. No new features or APIs? **PASS** — internal plumbing only
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected

### Step 9.3: EXCEPTION CATEGORIES
**Record:** N/A — standard bug fix, not a quirk/ID/DT/docs exception.

### Step 9.4: Problem Summary for Stable Users

When USB storage error recovery resets a device on a root-hub port,
control transfers to the root hub go through `rh_call_control()`, which
ignored the caller’s `GFP_NOIO` and allocated with `GFP_KERNEL`. That
can trigger I/O during reclaim while the SCSI error handler is trying to
recover the same block device — a classic deadlock. The fix threads
`mem_flags` from `usb_hcd_submit_urb()` through `rh_urb_enqueue()` into
`rh_call_control()`, matching behavior already used for non-root-hub
devices.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Identified Link tag; no Fixes/Reported-by/syzbot
- [Phase 2] Diff analysis: 3 functions changed in `hcd.c`; `GFP_KERNEL`
  → `mem_flags` in `kzalloc`
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame -L 488,489 hcd.c`: `GFP_KERNEL` since
  `e57e780b346a72` (2013)
- [Phase 3] `git log --oneline -20 -- drivers/usb/core/hcd.c`: no
  duplicate fix
- [Phase 3] Author history: Oliver Neukum UAS deadlock fix
  `f6cc6093a729e` with `Cc: stable`
- [Phase 4] `b4 dig -c HEAD`: no match (commit not in tree) — expected
- [Phase 4] `b4 dig -c f6cc6093a729e -w`: b4 works; related author patch
  found
- [Phase 4] Lore/patch.msgid.link fetch: **UNVERIFIED** (403/bot
  protection)
- [Phase 5] `grep usb_submit_urb.*GFP_NOIO`: storage, hub, message paths
  confirmed
- [Phase 5] Traced `uas_eh_device_reset_handler` → `usb_reset_device`
  (`uas.c:796`)
- [Phase 5] Traced `usb_stor_port_reset` → `usb_reset_device`
  (`transport.c:1455`)
- [Phase 5] Read `usb_start_wait_urb`: `usb_submit_urb(urb, GFP_NOIO)`
  (`message.c:62`)
- [Phase 5] Read `urb.c:349-350`: documents `GFP_NOIO` for block/storage
  error paths
- [Phase 5] Read `usb_reset_device`: `memalloc_noio_save()` at
  `hub.c:6384` (partial workaround, not substitute)
- [Phase 6] Confirmed buggy code at `hcd.c:489`, `814-819`, `1539-1540`
- [Phase 6] `grep rh_call_control.*mem_flags`: no match — fix not
  present
- [Phase 8] Failure mode: deadlock in SCSI EH — CRITICAL

**YES**

 drivers/usb/core/hcd.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index e11a8818af74a..4f198351ca9bb 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -450,7 +450,8 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 
 
 /* Root hub control transfers execute synchronously */
-static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
+static int rh_call_control(struct usb_hcd *hcd,
+		struct urb *urb, gfp_t mem_flags)
 {
 	struct usb_ctrlrequest *cmd;
 	u16		typeReq, wValue, wIndex, wLength;
@@ -485,8 +486,8 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 	 * tbuf should be at least as big as the
 	 * USB hub descriptor.
 	 */
-	tbuf_size =  max_t(u16, sizeof(struct usb_hub_descriptor), wLength);
-	tbuf = kzalloc(tbuf_size, GFP_KERNEL);
+	tbuf_size = max_t(u16, sizeof(struct usb_hub_descriptor), wLength);
+	tbuf = kzalloc(tbuf_size, mem_flags);
 	if (!tbuf) {
 		status = -ENOMEM;
 		goto err_alloc;
@@ -811,12 +812,13 @@ static int rh_queue_status (struct usb_hcd *hcd, struct urb *urb)
 	return retval;
 }
 
-static int rh_urb_enqueue (struct usb_hcd *hcd, struct urb *urb)
+static int rh_urb_enqueue(struct usb_hcd *hcd,
+		struct urb *urb, gfp_t mem_flags)
 {
 	if (usb_endpoint_xfer_int(&urb->ep->desc))
 		return rh_queue_status (hcd, urb);
 	if (usb_endpoint_xfer_control(&urb->ep->desc))
-		return rh_call_control (hcd, urb);
+		return rh_call_control(hcd, urb, mem_flags);
 	return -EINVAL;
 }
 
@@ -1537,7 +1539,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	 */
 
 	if (is_root_hub(urb->dev)) {
-		status = rh_urb_enqueue(hcd, urb);
+		status = rh_urb_enqueue(hcd, urb, mem_flags);
 	} else {
 		status = map_urb_for_dma(hcd, urb, mem_flags);
 		if (likely(status == 0)) {
-- 
2.53.0

