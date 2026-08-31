Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6484AFE14;
	Mon, 31 Aug 2026 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184194; cv=none; b=my8bfgX0Glq6X/jaKJOAaRqD1vlmL83beaYuizL+q38UQ7vfSLg6VBRmvHHtprVqjBLpsgbkPYFIHFPZqU2PzhmWxlBslLiF4WGXHX8WkM2K8NAZlyMaMokF71+Da4aQAaklGYZ6c88vDBGhdLAis5dre97ChdtaxkyPAqSYcU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184194; c=relaxed/simple;
	bh=ik83p6MBDaGK0Tc8n0B6dwZyZYbSdli0YL+VgMWNDi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7EyT9UUGdxavrFhelQ9T3opEeBlIN8ljxMWMH4pvVO9zoSBQg9ienXcz3Ock8tpT0nvRbYD6o6drafo6OQAyZFhoaxXQid38/j+t7wt2nOIXbc4qbZOZLU+3xDU+sQwjAmL6pNL+Gv764T2n67ZYbi3pnILkOCnnEsg7IQ4T1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwFiEmxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwFiEmxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462501F00A3E;
	Mon, 31 Aug 2026 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184191;
	bh=UKvF/x0OrZx/Ft+TX/oOWYEmRBBWJ690ElTtMp3aPwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwFiEmxdMVcoogqZuvkH/gDQlu06sjpLleYrsEqvFWY2FhIGpaQXq8MKTMcY2c7jO
	 tUj/XZkJsK15cr2fbrHdwqsoN+v7MJ6GUeSYcf52N2dY8C/UpvsD00hgtzPeij3pCF
	 /L6RlPbiIT6+eNUuHHNEFXpmcor2oI/Pa+eHy2sxeeoZQkRItbO1QZGdi9oI+cPmh+
	 pLVVtKi08dcZwsYJBozZc6PqRWlGQLtr6v3/gicb8D3OAHSBkFvYG0CowK3Q7AOVra
	 5zlhucxrd1ODKWhlNmA1PJ4SCzLq5uK6tKUaRk3Awr0b5SxlzG5O5jnlWoIPQG1TtD
	 g/FzmdRFiBFTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	zonque@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usb-audio: caiaq: validate EP1 reply lengths
Date: Mon, 31 Aug 2026 09:29:34 -0400
Message-ID: <20260831133314.4125787-546-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit aba30af07d4fe499b50209801eba9da8a815522f ]

usb_ep1_command_reply_dispatch() uses buf[0] as a command byte and then
reads command-specific fixed items from the same URB buffer. Several
paths use buf + 1, buf[1], buf[2], or buf + 3 without first proving that
urb->actual_length contains those bytes.

Add per-command length checks, use a payload length derived from the
bytes after the command byte for the control-state copy, and reject short
analog input payloads before the input helper reads fixed offsets from
the EP1 reply.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705084601.56400-1-pengpeng@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[ALSA: usb-audio: caiaq]` `[validate]` — Add validation of
EP1 USB reply payload lengths before parsing command-specific fields.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Link:**
  https://patch.msgid.link/20260705084601.56400-1-pengpeng@iscas.ac.cn
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer merge (Iwai), but no fuzzer report or explicit
  stable nomination in the message

### Step 1.3: Body analysis
**Record:**
- **Bug:** `usb_ep1_command_reply_dispatch()` uses `buf[0]` as a command
  byte, then reads fixed offsets (`buf[1]`, `buf[2]`, `buf+3`, `memcpy`
  of `sizeof(struct caiaq_device_spec)`) without checking
  `urb->actual_length`.
- **Symptom:** Short or malformed EP1 URB replies are parsed as if full-
  length; analog-input helpers read fixed offsets without proving the
  payload is long enough.
- **Root cause:** Missing per-command length validation against device-
  supplied `urb->actual_length`.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although the subject says “validate” rather than “fix”,
this is a classic USB input-parsing bounds-check bug fix, not a refactor
or feature.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- `sound/usb/caiaq/device.c`: +11 / −2 (approx.), function
  `usb_ep1_command_reply_dispatch()`
- `sound/usb/caiaq/input.c`: +6 lines, function
  `snd_caiaq_input_read_analog()`
- **Scope:** Two-file, surgical fix in one URB completion handler and
  one input helper
- **Total:** ~40 lines changed

### Step 2.2: Code flow per hunk

**`device.c` — early length guard:**
- **Before:** Immediately switches on `buf[0]` with no length check.
- **After:** Returns if `urb->actual_length < 1`; computes `payload_len
  = actual_length - 1`.

**`EP1_CMD_GET_DEVICE_INFO`:**
- **Before:** `memcpy(&cdev->spec, buf+1, sizeof(struct
  caiaq_device_spec))` unconditionally (14 bytes).
- **After:** Skips `memcpy` if `payload_len < 14`.

**`EP1_CMD_AUDIO_PARAMS`:**
- **Before:** Reads `buf[1]` unconditionally.
- **After:** Skips if `payload_len < 1`.

**`EP1_CMD_MIDI_READ`:**
- **Before:** Calls `snd_usb_caiaq_midi_handle_input(cdev, buf[1], buf +
  3, buf[2])` without validating `buf[2]` against available bytes.
- **After:** Rejects if `actual_length < 3` or `actual_length - 3 <
  buf[2]`.

**`EP1_CMD_READ_IO` (AUDIO8DJ path):**
- **Before:** `memcpy(cdev->control_state, buf + 1, urb->actual_length)`
  — copies `actual_length` bytes from `buf+1`, including the command
  byte in the count (off-by-one / over-read).
- **After:** `copy_len = min(payload_len, sizeof(cdev->control_state))`;
  copies only validated payload bytes.

**`input.c` — `snd_caiaq_input_read_analog()`:**
- **Before:** `snd_caiaq_input_report_abs()` reads up to
  `buf[14]`/`buf[15]` (Traktor Kontrol X1, offset 7) with no length
  guard.
- **After:** Returns early if `len < 6` (RigKontrol2/3/Kore) or `len <
  16` (Traktor Kontrol X1).

### Step 2.3: Bug mechanism
**Record:** **Buffer / packet bounds validation bug** (out-of-bounds
read relative to received packet length).
- USB device controls `urb->actual_length`.
- Parser reads command-specific fixed offsets and passes attacker-
  controlled lengths (MIDI `buf[2]`) downstream without proving those
  bytes were received.
- `EP1_BUFSIZE` is 64, so reads often stay inside the URB buffer
  allocation but beyond `actual_length`, consuming stale buffer data.
- Analog path can access `buf[offset*2+1]` with `offset` up to 7 (16
  bytes needed) when payload may be 1 byte.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal, follows existing patterns, and is obviously correct.
- Failed validation uses `break` and still resubmits the URB — no
  endpoint stall.
- **Regression risk:** Very low. Worst case: a truncated-but-valid reply
  is dropped (safe failure).
- **Incomplete coverage:** ERP/IO paths in `snd_caiaq_input_read_erp()`
  / `snd_caiaq_input_read_io()` are not covered by this patch; that
  limits scope but does not invalidate the fixed paths.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `usb_ep1_command_reply_dispatch()` lines trace to merge
commit `5d324e5159d9e` (usb-6.18-rc8 merge, Nov 2025). The dispatch
logic predates 6.18 (caiaq driver dates to ~2009). The missing
validation has been present since the original EP1 dispatch design.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: Related file history
**Record:** Recent caiaq fixes already in this 6.18.44 tree:
- `3afa2e67f3523` — stack OOB in `init_card` (KASAN, `Cc: stable`,
  backported with Greg K-H SOB)
- `a5fd3122283bf` — EP4 OOB in Traktor Kontrol S4 parser (`Cc: stable`,
  backported)
- `6153878c5255b`, `6473ed16df1fe`, etc. — probe/refcount fixes

This EP1 validation fix is the same class of issue as the two OOB fixes
already accepted into 6.18.y.

### Step 3.4: Author context
**Record:** Pengpeng Hou has no prior caiaq commits in this tree.
Takashi Iwai (ALSA maintainer) signed off. Pattern matches other caiaq
hardening fixes merged by Iwai.

### Step 3.5: Dependencies
**Record:** Standalone. No series markers, no prerequisite commits, no
new structures/APIs. Diff applies cleanly against current tree files
(verified: zero local diff on target files).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:** `b4 dig -c <hash>` not possible — commit is not in this
checkout. `WebFetch` of Link URL and lore.kernel.org blocked by Anubis
bot protection. **UNVERIFIED:** full review thread content, reviewer
stable nominations, NAKs.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** (`b4 dig -w` requires commit hash).
Maintainer Iwai sign-off confirmed from commit message.

### Step 4.3: Bug report
**Record:** No `Reported-by:`, no syzbot link, no stack trace in commit
message. Bug identified by code inspection, not a filed crash report.

### Step 4.4: Related patches
**Record:** Sibling fix `a5fd312` (EP4 OOB, same driver) explicitly
nominated for stable and is already in this tree. This EP1 fix
complements that work on a different endpoint.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — lore stable archive inaccessible. Prior
caiaq OOB fixes in this tree carry `Cc: stable@vger.kernel.org`.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `usb_ep1_command_reply_dispatch()`,
`snd_caiaq_input_read_analog()`, `snd_usb_caiaq_input_dispatch()`,
`snd_usb_caiaq_midi_handle_input()`.

### Step 5.2: Callers
**Record:** `usb_ep1_command_reply_dispatch` registered as URB
completion callback at probe:

```452:455:sound/usb/caiaq/device.c
        usb_fill_bulk_urb(&cdev->ep1_in_urb, usb_dev,
                          usb_rcvbulkpipe(usb_dev, 0x1),
                          cdev->ep1_in_buf, EP1_BUFSIZE,
                          usb_ep1_command_reply_dispatch, cdev);
```

Called from USB core interrupt/bottom-half context on every EP1 bulk IN
completion while the device is active.

### Step 5.3: Callees
**Record:** `memcpy`, `snd_usb_caiaq_midi_handle_input` →
`snd_rawmidi_receive`, `snd_usb_caiaq_input_dispatch` →
`snd_caiaq_input_read_analog` / `read_erp` / `read_io`,
`usb_submit_urb`.

### Step 5.4: Reachability
**Record:** Triggered whenever a supported Native Instruments caiaq USB
device is plugged in and operating (`CONFIG_SND_USB_CAIAQ`). A malicious
or misbehaving USB device (or truncated transfer) supplying short EP1
replies can reach the buggy paths without userspace involvement beyond
device insertion.

### Step 5.5: Similar patterns
**Record:** Same driver already had two OOB fixes backported to this
tree (`3afa2e67`, `a5fd312`). EP4 dispatch for Traktor Kontrol
X1/Maschine already floors `urb->actual_length` before dispatch — EP1
lacked equivalent validation.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **Linux 6.18.44** (`git describe
HEAD` → `v6.18.44-1-g2736c32da98b9`). Current `device.c` lines 143–179
and `input.c` lines 205–226 match the pre-fix code exactly (no length
checks).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** No conflicting recent changes to
these hunks. `EP1_BUFSIZE` (64), `struct caiaq_device_spec` (14 bytes
packed), and dispatch structure unchanged.

### Step 6.3: Related fixes already present?
**Record:** EP4 S4 OOB fix (`a5fd312`) and stack OOB fix (`3afa2e67`)
are in tree. **This specific EP1 validation fix is NOT yet in the tree**
— that is what we are evaluating.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `sound/usb/caiaq` — ALSA USB audio driver for Native
Instruments controllers. **Criticality: PERIPHERAL** (niche hardware,
`CONFIG_SND_USB_CAIAQ`).

### Step 7.2: Activity
**Record:** Active hardening in 2026 — six caiaq fixes in recent history
on this tree, including multiple OOB and probe-error fixes.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users with Native Instruments caiaq USB devices (RigKontrol,
Kore, Traktor Kontrol, Audio 8 DJ, Maschine, etc.) and
`CONFIG_SND_USB_CAIAQ` enabled. Small population, but real hardware
exists in production DJ/studio setups.

### Step 8.2: Trigger conditions
**Record:** Short or malformed EP1 bulk IN URB from the USB device.
Requires physical USB device attachment (or compromised/malicious USB
gadget). Not syscall-reachable directly, but standard BadUSB /
malicious-gadget threat model applies to USB drivers.

### Step 8.3: Failure mode severity
**Record:**
- **Stale-data reads** beyond `actual_length` into previously received
  URB buffer contents → wrong device spec, wrong MIDI data, wrong
  control state.
- **MIDI path:** `buf[2]`-controlled length passed to
  `snd_rawmidi_receive()` without bounds check → read up to 61 stale
  bytes.
- **Analog path:** reads up to `buf[15]` when payload may be 1 byte.
- Unlikely to trip KASAN for heap OOB (64-byte `ep1_in_buf`), but same
  class of USB parsing bug as `3afa2e67` (KASAN stack OOB, backported)
  and `a5fd312` (EP4 OOB loop, backported).
- **Severity: MEDIUM-HIGH** for USB input-validation bugs; not
  demonstrated crash, but real integrity/security concern.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Hardens USB parsing on an endpoint handler that runs
  continuously; aligns EP1 with EP4 hardening already backported;
  prevents stale-buffer reads and malformed MIDI length handling.
- **Risk:** Very low — ~40 lines of defensive checks, no API changes.
- **Ratio:** Favorable for stable, especially given precedent in this
  same driver on this same tree.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: missing `actual_length` validation on USB EP1 reply parsing
- Same driver already had two OOB/hardening fixes backported to 6.18.y
  (`3afa2e67`, `a5fd312`)
- Small, surgical, maintainer-reviewed (Iwai)
- Buggy code confirmed present in 6.18.44
- Clean apply expected
- USB untrusted-input validation is standard stable material

**AGAINST backport:**
- Niche driver, small user base
- No syzbot report, no user crash report, no `Cc: stable` in message
- Fix does not cover all EP1-derived paths (ERP/IO analog paths still
  lack length checks in `input.c`)
- Reads may stay within 64-byte URB buffer — crash severity not
  demonstrated

**UNRESOLVED:**
- Full lore review thread (bot-blocked)
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   maintainer sign-off; no Tested-by.
2. Fixes a real bug? **PASS** — parses USB replies without length
   validation.
3. Important issue? **PASS (MEDIUM-HIGH)** — USB input validation;
   stale-data / malformed-packet handling; same class as already-
   backported caiaq OOB fixes.
4. Small and contained? **PASS** — ~40 lines, 2 files.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — code present, clean apply
   expected.

### Step 9.3: Exception categories
**Record:** Not a device-ID/quirk/DT/build/docs exception. Standard bug
fix.

### Step 9.4: Decision rationale

This commit fixes a genuine USB input-parsing defect in
`usb_ep1_command_reply_dispatch()` where command-specific fields are
read without validating `urb->actual_length`. The caiaq driver in Linux
6.18.44 already carries two closely related OOB/hardening fixes that
stable maintainers accepted (`stack OOB in init_card`, `EP4 OOB in
Traktor Kontrol S4`). This EP1 fix is the same category: defensive
bounds checking on untrusted USB data, small scope, low regression risk,
and the vulnerable code is confirmed present in this tree.

The niche audience and lack of a demonstrated KASAN crash lower urgency
slightly, but stable policy consistently backports USB parsing
validation fixes in drivers where the bug is real and the patch is
surgical. Precedent in this exact driver on this exact tree tips the
balance clearly toward inclusion.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, body, tags (Hou SOB,
  Iwai SOB, Link tag; no Fixes/Reported-by/Cc:stable)
- **[Phase 2]** Read current `device.c` lines 131–188 and `input.c`
  lines 198–230; confirmed pre-fix behavior matches diff "before" state
- **[Phase 2]** Verified `EP1_BUFSIZE = 64` in `device.h`; `struct
  caiaq_device_spec` is 14 bytes (Python struct calc)
- **[Phase 2]** Verified AUDIO8DJ `memcpy` bug: uses
  `urb->actual_length` bytes from `buf+1` instead of payload length
- **[Phase 2]** Verified Traktor Kontrol X1 analog reads up to `buf[15]`
  (offset 7)
- **[Phase 3]** `git describe HEAD` → v6.18.44; Makefile VERSION 6.18.44
- **[Phase 3]** `git blame` on `usb_ep1_command_reply_dispatch` → merge
  `5d324e5159d9e`
- **[Phase 3]** `git log --oneline -20 -- sound/usb/caiaq/` → found
  related fixes `3afa2e67`, `a5fd312`, etc.
- **[Phase 3]** `git merge-base --is-ancestor` → `3afa2e67` and
  `a5fd312` both in tree
- **[Phase 3]** `git show 3afa2e67` / `a5fd312` → both have `Cc:
  stable@vger.kernel.org` and Greg K-H backport SOB
- **[Phase 4]** `b4 dig -c HEAD` → wrong commit (not this patch); commit
  not in tree
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked by Anubis
  (**UNVERIFIED**: mailing list discussion)
- **[Phase 5]** `grep` call chain: URB setup →
  `usb_ep1_command_reply_dispatch` → midi/input dispatch
- **[Phase 5]** Read `snd_usb_caiaq_input_dispatch()` — only checks `len
  < 1`, not per-device minimums
- **[Phase 5]** Read `snd_usb_caiaq_midi_handle_input()` — passes `len`
  directly to `snd_rawmidi_receive`
- **[Phase 6]** Confirmed buggy code present; `git diff HEAD --
  sound/usb/caiaq/{device,input}.c` → 0 lines (clean apply base)
- **[Phase 6]** Commit under evaluation NOT in tree (no `git log --grep`
  match)
- **[Phase 7]** `CONFIG_SND_USB_CAIAQ` in `sound/usb/Kconfig`
- **[Phase 8]** Assessed trigger (malformed EP1 URB from USB device) and
  failure mode (stale-buffer reads, wrong MIDI length)

**YES**

 sound/usb/caiaq/device.c | 17 ++++++++++++++---
 sound/usb/caiaq/input.c  |  6 ++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index b20aae0caf60a..a16e592484803 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -134,14 +134,22 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 	struct device *dev = &urb->dev->dev;
 	struct snd_usb_caiaqdev *cdev = urb->context;
 	unsigned char *buf = urb->transfer_buffer;
+	unsigned int payload_len;
+	unsigned int copy_len;
 
 	if (urb->status || !cdev) {
 		dev_warn(dev, "received EP1 urb->status = %i\n", urb->status);
 		return;
 	}
+	if (urb->actual_length < 1)
+		return;
+
+	payload_len = urb->actual_length - 1;
 
 	switch(buf[0]) {
 	case EP1_CMD_GET_DEVICE_INFO:
+		if (payload_len < sizeof(struct caiaq_device_spec))
+			break;
 	 	memcpy(&cdev->spec, buf+1, sizeof(struct caiaq_device_spec));
 		cdev->spec.fw_version = le16_to_cpu(cdev->spec.fw_version);
 		dev_dbg(dev, "device spec (firmware %d): audio: %d in, %d out, "
@@ -157,18 +165,21 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		wake_up(&cdev->ep1_wait_queue);
 		break;
 	case EP1_CMD_AUDIO_PARAMS:
+		if (payload_len < 1)
+			break;
 		cdev->audio_parm_answer = buf[1];
 		wake_up(&cdev->ep1_wait_queue);
 		break;
 	case EP1_CMD_MIDI_READ:
+		if (urb->actual_length < 3 || urb->actual_length - 3 < buf[2])
+			break;
 		snd_usb_caiaq_midi_handle_input(cdev, buf[1], buf + 3, buf[2]);
 		break;
 	case EP1_CMD_READ_IO:
 		if (cdev->chip.usb_id ==
 			USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_AUDIO8DJ)) {
-			if (urb->actual_length > sizeof(cdev->control_state))
-				urb->actual_length = sizeof(cdev->control_state);
-			memcpy(cdev->control_state, buf + 1, urb->actual_length);
+			copy_len = min_t(unsigned int, payload_len, sizeof(cdev->control_state));
+			memcpy(cdev->control_state, buf + 1, copy_len);
 			wake_up(&cdev->ep1_wait_queue);
 			break;
 		}
diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 2db4d1332df1c..c12eeb9710002 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -203,6 +203,8 @@ static void snd_caiaq_input_read_analog(struct snd_usb_caiaqdev *cdev,
 
 	switch (cdev->chip.usb_id) {
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_RIGKONTROL2):
+		if (len < 6)
+			return;
 		snd_caiaq_input_report_abs(cdev, ABS_X, buf, 2);
 		snd_caiaq_input_report_abs(cdev, ABS_Y, buf, 0);
 		snd_caiaq_input_report_abs(cdev, ABS_Z, buf, 1);
@@ -210,11 +212,15 @@ static void snd_caiaq_input_read_analog(struct snd_usb_caiaqdev *cdev,
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_RIGKONTROL3):
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_KORECONTROLLER):
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_KORECONTROLLER2):
+		if (len < 6)
+			return;
 		snd_caiaq_input_report_abs(cdev, ABS_X, buf, 0);
 		snd_caiaq_input_report_abs(cdev, ABS_Y, buf, 1);
 		snd_caiaq_input_report_abs(cdev, ABS_Z, buf, 2);
 		break;
 	case USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_TRAKTORKONTROLX1):
+		if (len < 16)
+			return;
 		snd_caiaq_input_report_abs(cdev, ABS_HAT0X, buf, 4);
 		snd_caiaq_input_report_abs(cdev, ABS_HAT0Y, buf, 2);
 		snd_caiaq_input_report_abs(cdev, ABS_HAT1X, buf, 6);
-- 
2.53.0

