Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0276A56CE34;
	Mon, 19 Oct 2026 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418283; cv=none; b=FyySsQis1w7Eq9D7Bp+BqqF9v/qT0iuvA6gBdOxKJLutaO6+7k3Vp9WiE9xNzc9/8xmIzU2EFUZ3mrWxnQ3CDzUjNpwaPWZwaIhM2XsgRDsM8kDey//p63Llz7yoYkH9nPo6I4YxPezvV7RDKVqe1LjZb9ckjjfrg/qYvyjbeik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418283; c=relaxed/simple;
	bh=W+Hlaab2fBIP0gIc86zYYaBsA4mTOK9u10R9OqKw6RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PLw0NJCS8PynYRccrt9HG3PALRZLdWmDkORXi7AHAJjKbZPpwvtd/mN0KefF8kLKunLtpG3pfFmVIhlyZa5v54FBA7x7vNFIlskfE6cQVREApGd9FSar22qAfqoY98mT7L7m3AV/ivwQq0hjIaqh+9fmoKmIxx9IH4pwP6kLXe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRkWoKDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRkWoKDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1443A1F000C4;
	Mon, 19 Oct 2026 13:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418280;
	bh=PX6PyxMl4vNcaqRQnGeOld55AoziJEjAbGnzlj4OKJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRkWoKDnr01ZQH1A11I8KzSv6bEGh2+tl4IjtxOFlTwJK6cWk8Gnmt8kBdhceDIWR
	 yHmeczAIl5EpmGUGB4v6xbST+bJl/kfZhP8qik1YWihU8xqQaUu/mNAcH6K8O6K3Cy
	 sSpAideJa3ii51E3/fMfp5kdCLqcsQGw5HGLX9QbWaLEY2XlQv3xNdNLRcq3BAAJGI
	 y0uJjAEhPjOX7lldUcPbfE3jFKXy8z52kzhm/DXMEu+H9B67oKpP3CPmgHesyVeUMO
	 q6zFxCMx+R/QjcHE6QWHpsFwpWFBbGojjfiRy+qOktK0rojIOOqzL4+MOzykTawTgw
	 J1jEGArWoCNYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	b-liu@ti.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: musb: host: clear stale RX interrupt on three-strikes error
Date: Mon, 19 Oct 2026 09:47:07 -0400
Message-ID: <20261019135441.1420968-136-sashal@kernel.org>
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

From: Lucas Martins Alves <lucas.alves@lumal21.com.br>

[ Upstream commit 3a3a48487344a653f46a4aadc9ba296386eb3541 ]

Unplugging a busy USB Ethernet adapter can leave a stale RX interrupt
pending while the host handles MUSB_RXCSR_H_ERROR. On AM335x/DSPS
platforms this can retrigger the same three-strikes error before the
disconnect path completes, flooding the log and potentially leaving the
host port stuck until reboot.

Clear the pending endpoint RX interrupt when aborting the transfer so
the error storm is broken, and rate limit the error message to avoid
spamming the log while the fault path completes.

Signed-off-by: Lucas Martins Alves <lucas.alves@lumal21.com.br>
Link: https://patch.msgid.link/20260714134941.18508-1-lucas.alves@lumal21.com.br
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Local tree

This checkout is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`),
i.e. current mainline, not a `-stable` branch. The candidate is already
in this history as `3a3a48487344a`. The verdict below is whether
**this** tree’s code still has the bug and whether the fix is a suitable
stable backport of that code — not whether some other series should take
it.

---

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Subsystem: `usb: musb: host:`
- Action verbs: **clear** (stale IRQ), plus body **rate limit**
- Intent: stop a leftover RX IRQ from re-firing the three-strikes error
  path after unplug

Record: `[usb/musb host] [clear] [ACK leftover RX IRQ on three-strikes
so unplug cannot storm/wedge the host]`

**Step 1.2 — Tags**
- `Signed-off-by: Lucas Martins Alves <lucas.alves@lumal21.com.br>`
  (author)
- `Link: https://patch.msgid.link/20260714134941.18508-1-
  lucas.alves@lumal21.com.br`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer merge)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence is expected for this pipeline)

Record: author SOB + lore msgid + Greg KH SOB. No syzbot, no Fixes tag.

**Step 1.3 — Body**
- Bug: unplug of a **busy USB Ethernet adapter** leaves a pending RX
  interrupt while `MUSB_RXCSR_H_ERROR` is handled.
- Symptom: on **AM335x/DSPS**, the same three-strikes error retriggers
  before disconnect finishes → **log flood** and **host port stuck until
  reboot**.
- Root cause (author): stale endpoint RX interrupt not cleared on abort.
- Fix: `musb_platform_clear_ep_rxintr()` plus `dev_err_ratelimited`.

Record: `[interrupt storm / wedged MUSB host port on unplug] [log spam +
port dead until reboot] [AM335x/DSPS] [stale RX IRQ reasserts H_ERROR]`

**Step 1.4 — Hidden bug fix?**
Not hidden. It is an explicit hardware-IRQ abort fix. Rate-limit is
secondary hardening for the same storm.

Record: `[Not a disguised cleanup; it is a stated interrupt-storm / hang
fix]`

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- File: `drivers/usb/musb/musb_host.c` only (`+13 / -1`)
- Function: `musb_host_rx()`
- Scope: single-file, one error branch

Record: `[musb_host.c +13/-1] [musb_host_rx] [surgical single-file]`

**Step 2.2 — Flow**
Before: on `MUSB_RXCSR_H_ERROR`, log with `dev_err`, set `-ESHUTDOWN`,
zero RX interval, clear `H_ERROR` in RXCSR, then fall through to the
existing fault abort (`musb_h_flush_rxfifo` / giveback).
After: same abort, but (1) `dev_err_ratelimited` with a trailing `\n`,
and (2) `musb_platform_clear_ep_rxintr(musb, epnum)` after clearing
RXCSR.

Record: `[H_ERROR branch: abort URB as before → also ACK platform RX IRQ
and rate-limit the printk]`

**Step 2.3 — Bug mechanism**
Category: **hardware interrupt storm / stale IRQ** (same family as
resource-leak-on-error, but the resource is a latched IRQ).

Verified mechanism:
1. `dsps_interrupt()` reads `epintr_status`, ACKs it, then calls
   `musb_interrupt()` → `musb_host_rx()`.
2. If the Mentor core re-latches RX while `H_ERROR` is still being
   unwound, DSPS delivers another RX IRQ before disconnect.
3. `dsps_musb_clear_ep_rxintr()` writes `(1 << epnum) <<
   wrp->rxep_shift` to `epintr_status` — the same ACK used in
   `musb_cleanup_urb()` (“clear the endpoint's irq status here to avoid
   bogus irqs”).
4. The helper is a **no-op** unless `ops->clear_ep_rxintr` is set; only
   DSPS implements it.

Record: `[stale IRQ storm] [ACK DSPS ep RX status after H_ERROR so
musb_host_rx is not re-entered]`

**Step 2.4 — Fix quality**
Obviously correct: it reuses a 2017 platform hook already used for the
same “bogus RX IRQ” class. No API/data-structure change. Regression risk
is low: non-DSPS platforms no-op; DSPS only ACKs the endpoint whose
error was just handled. Rate-limit cannot change USB behavior. Adding
`\n` only fixes printk formatting.

Record: `[minimal, matches existing abort path] [low regression risk]`

---

## Phase 3: Git history

**Step 3.1 — Blame**
- `H_ERROR` handling exists since `550a7375fe720` (Felipe Balbi, 2008).
- `-ESHUTDOWN` / “three-strikes” comment: `1b967691ecdcf` (Bin Liu,
  2020-05-25, v5.7-rc6 era) — same disconnect/storm class.
- This patch only owns the new call and the ratelimited log.

Record: `[buggy H_ERROR path: 2008; incomplete storm mitigation:
1b967691ecdcf ~v5.7] [long-lived]`

**Step 3.2 — Fixes: tag**
None. The incomplete predecessor is `1b967691ecdcf` (“return -ESHUTDOWN
… three-strikes”), present in this tree (`git merge-base --is-ancestor`
succeeded).

Record: `[no Fixes tag; predecessor 1b967691ecdcf is in this tree]`

**Step 3.3 — File history**
Related:
- `dbac5d07d13e3` (2016): don’t start next RX URB on failure — **system
  freeze** on USB-UART unplug / RX IRQ flood.
- `6def85a396ce7` + `c48400baa0215` (2017, v4.10): add/implement
  `clear_ep_rxintr` for bogus RX IRQ during DMA teardown; **already Cc:
  stable # 4.1+**.
- No later `musb_host.c` commits after this candidate.

Record: `[standalone; same storm family as 2016/2017/2020 musb host
fixes] [no later conflicting musb_host.c commits]`

**Step 3.4 — Author**
Lucas Martins Alves has only this USB commit in-tree. Merge via Greg KH.
Recipients included Bin Liu (`b-liu@ti.com`, long-time MUSB/DSPS
author).

Record: `[outside contributor; Greg KH merged; TI musb maintainer was on
Cc]`

**Step 3.5 — Prerequisites**
Needs `musb_platform_clear_ep_rxintr()` / `ops->clear_ep_rxintr`. Both
are ancestors of HEAD (`6def85a396ce7`, `c48400baa0215`). Call site in
`musb_cleanup_urb()` already exists. Applies standalone.

Record: `[depends on 2017 helper, present here] [standalone apply yes]`

---

## Phase 4: Mailing list / external

**Step 4.1**
`b4 dig -c 3a3a48487344a` → v1 only:
https://patch.msgid.link/20260714134941.18508-1-
lucas.alves@lumal21.com.br
Submitted 2026-07-14, merged 2026-07-17. Saved mbox is **only the
patch**; no replies, NAKs, or `Cc: stable` discussion. WebFetch to lore
returned **403** (verified).

Record: `[lore msgid above] [v1 only, no review comments in thread] [no
NAK]`

**Step 4.2**
`b4 dig -w`: To/Cc Lucas, `b-liu@ti.com`, `gregkh@linuxfoundation.org`,
`linux-usb`, `linux-kernel`.

Record: `[USB maintainer + TI musb author + linux-usb were on the
original To/Cc]`

**Step 4.3**
No `Reported-by` / bugzilla / syzbot. Body reads as first-hand AM335x
unplug. User-count beyond the author is **unverified**.

Record: `[no public bugzilla/syzbot] [UNVERIFIED: how many users besides
the author]`

**Step 4.4**
`b4 dig -a`: single standalone v1, not a series.

Record: `[standalone, not patch X/Y]`

**Step 4.5**
lore.kernel.org/stable WebFetch: **403**. No stable-list discussion
verified.

Record: `[UNVERIFIED: stable@ discussion]`

---

## Phase 5: Semantic / call graph

**Step 5.1**
Modified: `musb_host_rx()`. New call: `musb_platform_clear_ep_rxintr()`
→ `dsps_musb_clear_ep_rxintr()` on DSPS.

**Step 5.2 — Callers** (from `drivers/usb/musb/musb_core.c`)
- `musb_interrupt()`: host IRQ, `for_each_set_bit` on `int_rx`
- `musb_dma_completion()`: DMA completion RX path

Called from hardirq / DMA completion under `musb->lock`. Common host RX
path, not init-only.

**Step 5.3 — Callees in the hunk**
`dev_err_ratelimited`, `musb_writeb` (interval), `musb_writew` (RXCSR),
`musb_platform_clear_ep_rxintr`. Fault path still does
`musb_h_flush_rxfifo` when `status != 0`.

**Step 5.4 — Reachability**
Yes: USB Ethernet bulk IN while the device is yanked. Unprivileged
physical unplug. DSPS glue is `CONFIG_USB_MUSB_DSPS` (`ARCH_OMAP2PLUS` —
AM335x BeagleBone / Sitara class).

**Step 5.5 — Similar pattern**
Same helper already used in `musb_cleanup_urb()` for DMA abort. TX
`H_ERROR` still uses `musb_dbg` and does **not** clear RX IRQ (TX path;
out of this patch’s scope). Historical RX-flood fixes: `dbac5d07d13e3`,
`1b967691ecdcf`.

Record: `[musb_host_rx from IRQ/DMA] [userspace-triggerable unplug]
[same helper as cleanup_urb]`

---

## Phase 6: This checkout

**Step 6.1**
Buggy `H_ERROR` branch is in `musb_host_rx()` here. Helper and DSPS
callback exist. Bug class dates to 2008; `-ESHUTDOWN` mitigation from
~5.7 did not clear the DSPS RX IRQ.

Record: `[yes, musb_host.c H_ERROR path] [introduced 2008 / incomplete
2020]`

**Step 6.2**
Context around the hunk matches the candidate 1:1.
`musb_platform_clear_ep_rxintr` already declared. Expected apply:
**clean**.

Record: `[clean apply on this tree]`

**Step 6.3**
No later musb_host.c commit supersedes this. 2016/2020 patches are
related but **not** equivalent (they stop URB resubmit / next URB start;
they do not ACK `epintr_status`).

Record: `[no substitute fix already covering the stale DSPS RX IRQ]`

---

## Phase 7: Subsystem

**Step 7.1**
`drivers/usb/musb` — Mentor USB OTG host on TI DSPS/AM335x. Criticality:
**IMPORTANT** for those platforms (USB host), **PERIPHERAL** globally.
Not staging.

**Step 7.2**
Mature driver (2008+), still getting probe/UAF/of_node fixes. This is a
late bug in old code, not a new-subsystem feature.

Record: `[usb/musb] [IMPORTANT for AM335x/DSPS host] [mature]`

---

## Phase 8: Impact and risk

**Step 8.1**
Affected: MUSB **host** on platforms with `clear_ep_rxintr`
(DSPS/AM335x). Rate-limit also helps any MUSB host that hits three-
strikes. Trigger is USB Ethernet (and similar always-IN gadgets) unplug.

Record: `[driver/platform-specific: USB_MUSB_DSPS / AM335x; logging on
all musb host]`

**Step 8.2**
Trigger: unplug busy USB-Ethernet while IN URBs are posted — realistic.
Timing-dependent vs disconnect. Unprivileged user can do it physically.

Record: `[common unplug of busy NIC] [not a theoretical race only]
[physical unplug]`

**Step 8.3**
Failure: IRQ retrigger → printk flood + **host port unusable until
reboot**. Same family previously described as **system freeze**
(`dbac5d07d13e3`: hub never reports disconnect because RX ISR never
yields).

Record: `[hang / wedged USB host (+ log flood)] [HIGH, hang-class]`

**Step 8.4**
Benefit: high for AM335x/BeagleBone/industrial Sitara USB hosts.
Risk: very low (13 lines, existing no-op-safe hook, error path only).

Record: `[high benefit / very low risk]`

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real, user-visible hang: USB host stuck until reboot after unplugging
  a busy USB Ethernet adapter.
- Interrupt storm on a path already known to freeze the machine
  (2016/2020 musb host history).
- 13-line change in one function; reuses
  `musb_platform_clear_ep_rxintr()` from 2017 (stable-bound then).
- No-op on glues without the ops hook.
- Merged by Greg KH; TI musb author was CCd.
- Prerequisites exist in this tree; no series dependency.

AGAINST:
- No `Reported-by` / public repro beyond the commit text.
- Affects DSPS/AM335x, not every USB user.
- Thread had no review replies (Greg merged v1 quickly).

UNRESOLVED:
- Could not fetch lore HTML (403); mbox had no replies.
- Could not search stable@ (403).
- Number of independent reporters unverified.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — same ACK used in
   `musb_cleanup_urb`; merged to mainline.
2. Real bug affecting users? **PASS** — unplug of busy USB Ethernet on
   AM335x.
3. Important (crash/security/corruption/deadlock)? **PASS** — host port
   hang until reboot / IRQ storm (HIGH).
4. Small and contained? **PASS** — +13/-1, one file, one branch.
5. No new features/APIs? **PASS** — uses existing ops hook; rate-limit
   is logging only.
6. Applies to this tree? **PASS** — helper, DSPS callback, and hunk
   context all present.

**Step 9.3 — Exceptions**
Not a device-ID/DT/build/docs exception. Closest: **hardware
workaround** (ACK platform IRQ the Mentor core leaves asserted).
Qualifies on ordinary bug-fix rules anyway.

**Step 9.4 — Decision**
This is a small, contained fix for a real disconnect-time IRQ storm that
can leave MUSB host unusable until reboot. It matches prior musb stable-
worthy storm fixes and uses an already-stable helper. Benefit outweighs
risk.

---

### What it solves for stable users

On TI DSPS/AM335x, yanking a busy USB Ethernet adapter can re-assert
endpoint RX IRQ while `musb_host_rx()` is still handling
`MUSB_RXCSR_H_ERROR`. The host keeps taking the same three-strikes
error, floods the log, and can leave the port dead until reboot.
Clearing the platform RX IRQ (and rate-limiting the error) breaks that
loop so disconnect can finish.

### Risk vs benefit

Very low risk (no-op elsewhere, existing helper, error path only) versus
high benefit (avoid a wedged USB host on a widely deployed SoC class).

### Concerns

None that block backport on this tree: no missing helpers, no series, no
API change. User-count beyond the author is unverified and does not
outweigh the hang severity plus the 2016/2020 precedent.

---

## Verification

- [Phase 1] Parsed tags: author SOB, msgid Link, Greg KH SOB; no
  Fixes/Reported-by/Cc stable
- [Phase 1] `git log -1 --format` on `3a3a48487344a`: subject/body match
  the candidate
- [Phase 2] Diff: +13/-1 in `musb_host_rx()` H_ERROR branch; `dev_err` →
  `dev_err_ratelimited`; add `musb_platform_clear_ep_rxintr`
- [Phase 2] Read `musb_host.c` fault path: `status = -ESHUTDOWN` still
  leads to flush/abort
- [Phase 2] Read `musb_core.h`: helper no-ops if ops hook NULL
- [Phase 2] Read `dsps_musb_clear_ep_rxintr`: writes endpoint bit to
  `epintr_status`
- [Phase 2] Read `dsps_interrupt`: ACK all epintr then
  `musb_interrupt()` → re-latch can retrigger
- [Phase 2] `musb_cleanup_urb` already calls the same helper “to avoid
  bogus irqs”
- [Phase 3] `git blame -L 1770,1810 musb_host.c`: H_ERROR from 2008;
  ESHUTDOWN from `1b967691ecdcf`
- [Phase 3] `git merge-base --is-ancestor` 6def85a396ce7 / c48400baa0215
  / 1b967691ecdcf / 3a3a48487344a vs HEAD: all true
- [Phase 3] `git show` 6def85a396ce7 / c48400baa0215: helper added for
  bogus RX IRQ; Cc stable 4.1+
- [Phase 3] `git show` dbac5d07d13e3: earlier RX ISR flood freeze on
  unplug
- [Phase 3] `git log 3a3a48487344a..HEAD -- musb_host.c`: empty (no
  follow-up)
- [Phase 3] `git log --author='Lucas Martins Alves' -- drivers/usb/`:
  only this commit
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 msgid, recipients Bin Liu + Greg KH
  + linux-usb, mbox has patch only
- [Phase 4] WebFetch lore/stable: 403 — UNVERIFIED HTML thread beyond
  mbox
- [Phase 5] `git grep musb_host_rx`: callers `musb_interrupt`,
  `musb_dma_completion`
- [Phase 5] `git grep clear_ep_rxintr`: only DSPS implements the ops
- [Phase 6] `git describe HEAD` / `make kernelversion`: v7.3-rc4 /
  7.3.0-rc4
- [Phase 6] Pre-patch hunk via `git show
  3a3a48487344a^:drivers/usb/musb/musb_host.c`: helper already existed
- [Phase 7] `Kconfig USB_MUSB_DSPS`: ARCH_OMAP2PLUS / TI DSPS
- [Phase 8] Failure mode from commit text + 2016 freeze commit: IRQ
  storm / wedged host, HIGH
- UNVERIFIED: independent user count; stable@ mailing list discussion;
  lore HTML (403)

The fix is small, uses an existing platform ACK, and prevents a real
USB-host hang on unplug.

**YES**

 drivers/usb/musb/musb_host.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 6b4481a867c5e..40f51c388ef59 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1774,7 +1774,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		status = -EPIPE;
 
 	} else if (rx_csr & MUSB_RXCSR_H_ERROR) {
-		dev_err(musb->controller, "ep%d RX three-strikes error", epnum);
+		dev_err_ratelimited(musb->controller,
+				    "ep%d RX three-strikes error\n", epnum);
 
 		/*
 		 * The three-strikes error could only happen when the USB
@@ -1788,6 +1789,17 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		rx_csr &= ~MUSB_RXCSR_H_ERROR;
 		musb_writew(epio, MUSB_RXCSR, rx_csr);
 
+		/*
+		 * Unplugging a USB-Ethernet adapter while it is busy can make
+		 * the controller keep re-asserting the three-strikes error for
+		 * this endpoint before the disconnect is processed. That floods
+		 * the log and can wedge the host port until reboot. Drop the
+		 * stale pending RX interrupt on platforms that support it (e.g.
+		 * AM335x/DSPS) to break the storm; the transfer is still
+		 * aborted below via the fault path.
+		 */
+		musb_platform_clear_ep_rxintr(musb, epnum);
+
 	} else if (rx_csr & MUSB_RXCSR_DATAERROR) {
 
 		if (USB_ENDPOINT_XFER_ISOC != qh->type) {
-- 
2.53.0

