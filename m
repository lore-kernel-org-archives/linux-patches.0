Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C191548560;
	Mon, 31 Aug 2026 13:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183983; cv=none; b=FqC0ZPakX7g7RUZZyZqjEFaCt1hQu/d6txLoIydLswNZyFFqznaldDCTb8GGbuZ2C8gbC6+sIjJRN0jIHORHNeqiODsHTQxo6yHMpLq77jG2CpLBKj7V9uFai5TiSB5N2NUggKElaw+CdUrimcXUMV2tTu1SvilhXQ0wp56xmDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183983; c=relaxed/simple;
	bh=2Wu+U8uLnyLoAPApa8GYQVpTWhIXnJr2GzjTJM/5b3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VkYrlNAJlP7LuJf/vCt+ArSLRDEOdDRFvTviVB4Z8fR5+n+GHfcira9QOZGuop0CzVZMgliOmTahmfQ4Qjepq2aFvQmFzKEqAZrOlmS9HgrYNT1Xw89GSoqwNsrCRAhr5box+xI/+HRCimMHgAHLD9YcwUcf1W24x7NS//7S5aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCE/S10e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCE/S10e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB4E1F00ACA;
	Mon, 31 Aug 2026 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183979;
	bh=Tba7JTN/NDmEwcN2ivWU87p0C+NN+9jMOsVf9lfWPcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCE/S10evFj6XvsRW7VGRCUcvYgHibvloClPrvZYmCFLzpn5mPAfDK26tO4HYl77M
	 Tca8iK1mvfUDdBuaReEOrK1xCIxjRig2H6KrCYanx2D2BMIBYCec25XfjDYcpSLlBv
	 rGj95HxJTpHUjr5MYvG39fPR8KDL2WnES0l9PIE55GNvfvpp6Gdo6n3KEuTPABPY2A
	 UiVno0pbX6zAw1+Y1gwVeFrWIt/ZeZmpIITLk4x4iPGsjw1CLfme+WjKt5um1UZOBo
	 Jj0laogeD/80RJKjVWFI2CvyHCO2d3TxmaRlapz6KZSSty1a/RJDUTFVM5ONxim58C
	 qor5pqHYCMHsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usx2y: Drain pending US-428 pipe-4 output commands
Date: Mon, 31 Aug 2026 09:27:26 -0400
Message-ID: <20260831133314.4125787-418-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 18977c0dd722f52217027ff75de2811c53cce2cc ]

The US-428 pipe-4 output path submits at most one pending p4out
entry from the shared-memory ring per input interrupt. If userspace
queues more than one command before the interrupt handler runs, later
commands remain pending until later input interrupts, even when async
pipe-4 URBs are available.

Drain pending entries while idle async URBs are available. Copy each
command into the existing per-URB async buffer before submission, so the
submitted transfer does not depend on a userspace-mapped ring slot
remaining unchanged after p4out_sent is advanced.

Also update p4out_sent only after usb_submit_urb() succeeds, so a
failed submission is not reported as sent.

This keeps the shared-memory ABI unchanged and fixes only the local
queue-draining behavior.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260519-alsa-usx2y-p4out-drain-v1-1-8f0a4550bae2@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA usx2y — Drain pending US-428 pipe-4
output commands

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: usx2y]` `[Drain]` — Fix queue-draining for US-428
pipe-4 output commands in the `snd-usb-usx2y` driver.

### Step 1.2: Commit Message Tags
**Record:**
- **Link:** `https://patch.msgid.link/20260519-alsa-usx2y-p4out-
  drain-v1-1-8f0a4550bae2@gmail.com`
- **Signed-off-by:** Cássio Gabriel `<cassiogabrielcontato@gmail.com>`
  (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA subsystem
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer SOB from Takashi Iwai is a strong quality signal;
  no user/fuzzer reports.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** The US-428 pipe-4 output path submits at most one pending
  `p4out` ring entry per input interrupt. If userspace queues multiple
  commands before the interrupt handler runs, later commands stay
  pending even when idle async URBs exist.
- **Symptom:** Lost or severely delayed volume/light/control commands to
  the US-428 hardware surface; possible desync between userspace queue
  state and hardware.
- **Root cause:** Single-shot dequeue per interrupt; URBs pointed
  directly at userspace-mapped shared memory; `p4out_sent` advanced even
  when `usb_submit_urb()` fails.
- **Fix approach:** Drain the pending queue in a loop while idle URBs
  exist; `memcpy()` into per-URB kernel buffers before submit; advance
  `p4out_sent` only after successful submission.
- **Version info:** None stated.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite no "fix" in the subject, this is a functional
bug fix disguised as queue-draining improvement. The in-tree `FIXME`
comment explicitly acknowledges command loss. The `memcpy()` change
fixes a userspace/kernel shared-memory race on in-flight URBs. Deferring
`p4out_sent` update fixes incorrect state tracking on submission
failure.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **File:** `sound/usb/usx2y/usbusx2y.c` (~35 lines changed, well under
  100-line stable limit)
- **Function modified:** `i_usx2y_in04_int()` (pipe-4 input interrupt
  handler)
- **Scope:** Single-file, surgical fix in one interrupt handler path.

### Step 2.2: Code Flow Change (per hunk)
**Record:**

**Hunk 1 (variable declaration):** Adds `len` local for transfer size.

**Hunk 2 (p4out submission path):**
- **Before:** If `p4out_last != p4out_sent`, compute next slot, find one
  idle async URB, `usb_fill_bulk_urb()` pointing at `&p4out->val.vol` in
  shared memory, submit one URB, unconditionally set `p4out_sent`,
  break.
- **After:** `while` loop continues while pending entries exist; for
  each idle URB, compute next slot, `memcpy()` command into
  `as04.urb[j]->transfer_buffer`, set `transfer_buffer_length`, submit;
  only on success update `p4out_sent`; break inner loop and continue
  outer loop if more pending entries and URBs remain.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness bug + shared-memory race + error-path
  correctness.
- **Mechanism:**
  1. **Queue draining:** Only one command dequeued per ~10 ms input
     interrupt even with 10 idle async URBs (`URBS_ASYNC_SEQ == 10`),
     causing backlog and eventual ring-slot overwrite under bursty
     userspace writes (16-slot ring, `N_US428_P4OUT_BUFS == 16`).
  2. **Shared-memory race:** Old code submitted URBs pointing directly
     into the mmap'd `p4out` ring; userspace could overwrite a slot
     after `p4out_sent` advanced but before the async transfer
     completed.
  3. **Error handling:** `p4out_sent` was set even when
     `usb_submit_urb()` returned an error, falsely reporting a command
     as sent.

### Step 2.4: Fix Quality Assessment
**Record:** Fix is obviously correct and minimal. Reuses pre-allocated
per-URB kernel buffers from `usx2y_async_seq04_init()` (each
`URB_DATA_LEN_ASYNC_SEQ == 32` bytes, sufficient for max 5-byte volume
or ~14-byte light payloads). The `while` loop correctly stops when no
idle URBs remain or on error. Low regression risk; no API/ABI changes.
Minor note: removes per-submit `usb_fill_bulk_urb()` call, relying on
init-time URB setup — appropriate since buffer pointer and callback are
already configured.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
**Record:** In this checkout, `git blame` attributes the buggy block to
`a112b91dd6349` (squashed autosel base — not the original introduction).
The driver itself dates to Karsten Wiese, 2003–2005. The `FIXME if more
than 1 p4out is new, 1 gets lost` comment is present in the current tree
at line 232, confirming this is a long-standing known defect, not a
recent regression.

### Step 3.2: Follow Fixes Tag
**Record:** Not applicable — no `Fixes:` tag in the commit message.

### Step 3.3: Related File History
**Record:** This autosel tree has shallow history (50 commits total);
`git log -- sound/usb/usx2y/usbusx2y.c` shows only the base commit. The
usx2y driver code and `FIXME` are fully present in HEAD. No related fix
for this issue found via `git log --grep`.

### Step 3.4: Author's Other Commits
**Record:** No other commits from Cássio Gabriel in this tree. Author
appears to be an ALSA contributor (another patch from same author exists
in workspace mboxes for opti9xx).

### Step 3.5: Prerequisites
**Record:** Standalone fix. All required structures
(`us428ctls_sharedmem`, `us428_p4out`, `as04` async URB pool) exist in
this tree. No patch-series dependency.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c <hash>` not possible — commit is a candidate not
yet in this tree (no commit hash available). `WebFetch` and `curl` to
lore.kernel.org and patch.msgid.link returned 403/bot-protection pages.
Could not retrieve mailing list thread content.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not fetch thread via `b4 dig -w`. Takashi
Iwai maintainer SOB is present in the provided commit message.

### Step 4.3: Bug Report
**Record:** No `Reported-by:` tag. No syzbot, bugzilla, or user crash
reports referenced. Bug identified through code analysis and existing
`FIXME` comment.

### Step 4.4: Related Patches/Series
**Record:** Link subject suggests `v1` submission (`p4out-drain-v1-1`).
No evidence of multi-patch series dependency from the diff itself.

### Step 4.5: Stable Mailing List History
**Record:** UNVERIFIED — lore.kernel.org inaccessible from this
environment. No stable-list discussion found in local workspace mboxes.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `i_usx2y_in04_int()` modified. Supporting context:
`usx2y_async_seq04_init()`, `i_usx2y_out04_int()`,
`snd_us428ctls_mmap()` in `usX2Yhwdep.c`.

### Step 5.2: Callers
**Record:** `i_usx2y_in04_int` is registered as the completion callback
for the pipe-4 interrupt URB in `usx2y_in04_init()` (10 ms interval).
Called from USB core interrupt completion context (`GFP_ATOMIC`).
Triggered continuously while the US-428 device is initialized and
operational.

### Step 5.3: Callees
**Record:** `usb_submit_urb()`, `memcpy()`, `wake_up()` (for control
snapshots), shared-memory ring access via `us428ctls`.

### Step 5.4: Call Chain / Reachability
**Record:** US-428 device probe → FPGA load via hwdep →
`usx2y_async_seq04_init()` + `usx2y_in04_init()` → continuous pipe-4
interrupts → `i_usx2y_in04_int()`. The `p4out` path is taken when
`usx2y->us04` is NULL (normal operation; `us04` is only set temporarily
during `usx2y_rate_set()`). Userspace writes commands via mmap'd
`us428ctls_sharedmem` hwdep interface. Reachable by userspace control
applications for US-428 fader/light/volume control — not a kernel-init-
only path.

### Step 5.5: Similar Patterns
**Record:** The `us04` branch in the same function already uses a `do {
... } while` loop to submit multiple URBs per interrupt. The fix aligns
the `p4out` path with this existing pattern. The `FIXME` comment
confirms the authors were aware of the asymmetry.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does Buggy Code Exist?
**Record:** **YES.** Local tree is **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`). Buggy code with `FIXME if more than 1
p4out is new, 1 gets lost` exists at lines 225–242 of
`sound/usb/usx2y/usbusx2y.c`. All related headers and structures
present.

### Step 6.2: Backport Complications
**Record:** Expected **clean apply**. The target code block matches the
patch context exactly. No conflicting recent changes to this function in
this tree.

### Step 6.3: Related Fixes Already Present?
**Record:** None found. The `FIXME` remains; the fix has not been
applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `sound/usb/usx2y` — ALSA USB audio driver for Tascam
US-122/US-224/US-428. **PERIPHERAL** subsystem; `p4out` path is
**US-428-specific** control-surface output. Requires
`CONFIG_SND_USB_USX2Y`.

### Step 7.2: Subsystem Activity
**Record:** Mature, low-churn driver (original code from 2003–2005). The
bug has been latent for the lifetime of the feature.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Driver-specific / config-specific** — users of Tascam
US-428 (`USB_ID_US428`) with `CONFIG_SND_USB_USX2Y` enabled, using the
hwdep mmap control interface for pipe-4 output (volume, lights). US-122
and US-224 are unaffected.

### Step 8.2: Trigger Conditions
**Record:** Userspace queues more than one `p4out` command between input
interrupts (~10 ms), or reuses/overwrites ring slots before the kernel
drains them. Common during rapid fader/light updates. Triggerable by
unprivileged userspace through the hwdep interface (no special
privileges beyond device access). Not a kernel-internal race —
userspace-driven.

### Step 8.3: Failure Mode Severity
**Record:**
- Lost or delayed hardware control commands (volume, lights) —
  **MEDIUM** functional impact
- Possible wrong command sent to hardware via shared-memory race during
  in-flight URB — **MEDIUM** (incorrect hardware state, not kernel
  memory corruption)
- False `p4out_sent` on failed submit can cause queue stall/desync —
  **MEDIUM**
- No kernel oops, panic, deadlock, or memory corruption — **not
  CRITICAL** for kernel stability

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** MEDIUM for affected US-428 users (correct control-surface
  behavior under bursty input)
- **Risk:** VERY LOW (small, localized change; maintainer-reviewed; no
  ABI change)
- **Ratio:** Moderate benefit for a tiny user population vs. very low
  risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, acknowledged bug (`FIXME` in production code)
- Fixes command loss/delay under bursty userspace writes
- Fixes shared-memory race on async URB submission
- Fixes error-path state tracking (`p4out_sent` only on success)
- Small (~35 lines), single-file, obviously correct
- ALSA maintainer (Takashi Iwai) Signed-off-by
- Buggy code confirmed present in 6.18.43 tree; patch applies cleanly
- No new APIs or features; shared-memory ABI unchanged

**AGAINST backport:**
- Very niche hardware (Tascam US-428 only, optional Kconfig)
- No user reports, syzbot, or crash reports
- Does not cause kernel oops, hang, deadlock, or data corruption
- Long-standing latent bug, not a recent regression
- Stable rules emphasize bugs that "bother people" — no evidence of
  widespread user impact
- lore/stable discussion could not be verified

**UNRESOLVED:**
- Full mailing list review thread inaccessible
- Whether reviewers nominated for stable

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** **PASS** — logic is sound;
   maintainer SOB; no `Tested-by` but mechanism is verifiable by
   inspection.
2. **Fixes a real bug affecting users?** **PASS** — `FIXME` confirms;
   affects US-428 control surface users.
3. **Important issue?** **BORDERLINE/PASS** — not
   crash/security/corruption, but causes lost/wrong hardware control
   commands; fits stable rules' "real bug that bothers people" and "oh,
   that's not good" for incorrect hardware state.
4. **Small and contained?** **PASS** — ~35 lines, one function, one
   file.
5. **No new features or APIs?** **PASS** — behavior fix only; ABI
   unchanged.
6. **Can apply to local tree?** **PASS** — buggy code present; clean
   apply expected.

### Step 9.3: Exception Categories
**Record:** Not a device-ID addition, DT update, build fix, or
documentation fix. Closest fit: hardware-related driver correctness fix
for existing supported hardware (analogous to hardware quirk/workaround
category, though this is driver logic rather than a hardware quirk table
entry).

### Step 9.4: Decision Rationale

For **this 6.18.43 tree**, the buggy code is present and the fix is a
small, maintainer-approved correction to a real functional defect that
can cause lost or incorrect US-428 control commands under normal bursty
userspace usage. While the affected user base is small and the issue
does not threaten kernel stability, it is a genuine bug with an explicit
`FIXME` in the source, the fix is low-risk, and stable-kernel-rules.rst
accepts patches that fix "a real bug that bothers people" on existing
hardware. The shared-memory race and queue-desync on submit failure
elevate this beyond mere cosmetic cleanup.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message;
  found Link, two Signed-off-by (author + Takashi Iwai); no
  Fixes/Reported-by/Cc:stable.
- **[Phase 2]** Analyzed diff: ~35 lines in `i_usx2y_in04_int()`; while-
  loop drain, memcpy to kernel buffer, conditional p4out_sent update.
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git blame -L 220,245` →
  FIXME present; shallow tree prevents meaningful origin history.
- **[Phase 3]** `git log -S "FIXME if more than 1 p4out"` → only base
  commit (shallow tree).
- **[Phase 3]** `git log --grep="Drain pending US-428"` → no match (fix
  not yet in tree).
- **[Phase 4]** `b4 dig -c` → not possible (no commit hash in tree);
  WebFetch/curl to lore.kernel.org and patch.msgid.link → 403/bot-
  blocked; thread content UNVERIFIED.
- **[Phase 5]** Read `usbusx2y.c` lines 163–330: confirmed
  `i_usx2y_in04_int` call chain via `usx2y_in04_init()`.
- **[Phase 5]** Read `usX2Yhwdep.c`: confirmed mmap hwdep interface for
  US-428 control shared memory.
- **[Phase 5]** Read `usbus428ctldefs.h`: confirmed 16-slot `p4out`
  ring, `N_US428_P4OUT_BUFS == 16`.
- **[Phase 5]** Confirmed `URBS_ASYNC_SEQ == 10`,
  `URB_DATA_LEN_ASYNC_SEQ == 32` in headers.
- **[Phase 5]** Confirmed `us04` only set during `usx2y_rate_set()` in
  `usbusx2yaudio.c`; p4out path is normal operational path.
- **[Phase 6]** `git describe HEAD` + `grep FIXME` → buggy code
  confirmed in 6.18.43 at line 232.
- **[Phase 6]** `git show a112b91dd6349:sound/usb/usx2y/usbusx2y.c` →
  same buggy block in tree base.
- **[Phase 7]** `CONFIG_SND_USB_USX2Y` documented in `sound/usb/Kconfig`
  for US-122/224/428.
- **[Phase 8]** Assessed severity: functional hardware control bug, not
  kernel crash; US-428-specific.
- **[Phase 9]** Read `Documentation/process/stable-kernel-rules.rst`
  criteria for patch acceptance.

**YES**

 sound/usb/usx2y/usbusx2y.c | 39 ++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index f34e78910200a..4190227c5a2a5 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -180,7 +180,7 @@ static void i_usx2y_in04_int(struct urb *urb)
 	struct usx2ydev		*usx2y = urb->context;
 	struct us428ctls_sharedmem	*us428ctls = usx2y->us428ctls_sharedmem;
 	struct us428_p4out *p4out;
-	int i, j, n, diff, send;
+	int i, j, n, diff, send, len;
 
 	usx2y->in04_int_calls++;
 
@@ -222,24 +222,31 @@ static void i_usx2y_in04_int(struct urb *urb)
 			} while (!err && usx2y->us04->submitted < usx2y->us04->len);
 		}
 	} else {
-		if (us428ctls && us428ctls->p4out_last >= 0 && us428ctls->p4out_last < N_US428_P4OUT_BUFS) {
-			if (us428ctls->p4out_last != us428ctls->p4out_sent) {
-				send = us428ctls->p4out_sent + 1;
-				if (send >= N_US428_P4OUT_BUFS)
-					send = 0;
-				for (j = 0; j < URBS_ASYNC_SEQ && !err; ++j) {
-					if (!usx2y->as04.urb[j]->status) {
-						p4out = us428ctls->p4out + send;	// FIXME if more than 1 p4out is new, 1 gets lost.
-						usb_fill_bulk_urb(usx2y->as04.urb[j], usx2y->dev,
-								  usb_sndbulkpipe(usx2y->dev, 0x04), &p4out->val.vol,
-								  p4out->type == ELT_LIGHT ? sizeof(struct us428_lights) : 5,
-								  i_usx2y_out04_int, usx2y);
-						err = usb_submit_urb(usx2y->as04.urb[j], GFP_ATOMIC);
+		while (us428ctls &&
+		       us428ctls->p4out_last >= 0 &&
+		       us428ctls->p4out_last < N_US428_P4OUT_BUFS &&
+		       us428ctls->p4out_last != us428ctls->p4out_sent) {
+			for (j = 0; j < URBS_ASYNC_SEQ && !err; ++j) {
+				if (!usx2y->as04.urb[j]->status) {
+					send = us428ctls->p4out_sent + 1;
+					if (send >= N_US428_P4OUT_BUFS)
+						send = 0;
+
+					p4out = us428ctls->p4out + send;
+					len = p4out->type == ELT_LIGHT ?
+						sizeof(struct us428_lights) : 5;
+					memcpy(usx2y->as04.urb[j]->transfer_buffer,
+					       &p4out->val.vol, len);
+					usx2y->as04.urb[j]->transfer_buffer_length = len;
+					err = usb_submit_urb(usx2y->as04.urb[j], GFP_ATOMIC);
+					if (!err)
 						us428ctls->p4out_sent = send;
-						break;
-					}
+
+					break;
 				}
 			}
+			if (j >= URBS_ASYNC_SEQ || err)
+				break;
 		}
 	}
 
-- 
2.53.0

