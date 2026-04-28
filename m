Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421AC402433;
	Tue, 28 Apr 2026 10:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372949; cv=none; b=sNuzmgqnx25UATVqq/mfuDdncBikjvoBW6WXjviJV0If6R6eonAmcBB8L/DIdTnhDp8at16IGy2lGAd2qXpfsFqHO3avHHUbsYsL1Q+Fh/gBULEnAFMEU1Fm2BXhcVfoGtk9AZVmIfRbI0IqhnrVHbh/EwDmZ0oBiDGaiEBFezU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372949; c=relaxed/simple;
	bh=WgpkKhPY4oGY/RREmhHzxoDiM6S+HMUhToabAPFHDVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6YT8JOjNKa12g608l1ugLg5pRe+yfdl8+583EsF92NUt4T/al1uGqaUVlhYKcz+/bLXE9WuuIDH3gSZr7wIphRxzCCtaBhVdTbu7gw/P6dzTZXAnfn539Hh9CuCWITSGr0hu/9yboSPag5xYcwH9wr2B63HGjfkGU1ikualejk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQE6Glyc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQE6Glyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4395C2BCB8;
	Tue, 28 Apr 2026 10:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372949;
	bh=WgpkKhPY4oGY/RREmhHzxoDiM6S+HMUhToabAPFHDVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQE6GlycKB4/AUeCTbteb1KEIz/rb2iJXiQZ9g4VKpV6PIsgJgXNvWiGkQHZU3H+s
	 2XKzDqVWnlLtjuZ0qFsrzZzZUjFSb5JbRce7JKBYLfb+FNZJJmMFydHJsadDeE+w8b
	 +aYsGoEwOMR4rve1ukl9ixEOStloxhactlysSSHUF7WjkFF92Sw3R32xsbxG79RpGM
	 ACBiLj74qSYkyJm/iezwOWsrJM/fDksAHAdPxeVtkcrx/9PHQIX2jJpez+xkgPBKPI
	 9ANkehm8Iog0KZQzhcnJDuEO5Idl+ZlsgAkQ9SXc5Bm+BGthnY7kWISKSBNGV73FpA
	 x0m8u/NJPlAIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Justin Chen <justin.chen@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	alcooperx@gmail.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] usb: gadget: bdc: validate status-report endpoint indices
Date: Tue, 28 Apr 2026 06:40:50 -0400
Message-ID: <20260428104133.2858589-39-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a402532ab855620e02a16950aea86fc621c6f87c ]

bdc_sr_xsf() decodes a 5-bit endpoint number from the hardware status
report and uses it to index bdc->bdc_ep_array[] directly. The array is
only allocated to bdc->num_eps for the current controller instance, so a
status report can carry an endpoint number that still fits the 5-bit
field but does not fit the runtime-sized endpoint table.

Reject status reports whose endpoint number is outside bdc->num_eps
before indexing the endpoint array.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Justin Chen <justin.chen@broadcom.com>
Link: https://patch.msgid.link/20260323121730.75245-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough context. Let me write up the complete analysis.

## Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line**
- Subsystem: `usb: gadget: bdc:`
- Action verb: "validate" (typical hardening language; equivalent to
  "add missing bounds check")
- Record: "usb gadget BDC driver adds bounds check on endpoint number
  decoded from hardware status report before indexing the endpoint
  array"

**Step 1.2: Tags**
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>`
  (Broadcom maintainer)
- `Tested-by: Justin Chen <justin.chen@broadcom.com>` (Broadcom
  engineer)
- `Link:
  https://patch.msgid.link/20260323121730.75245-1-pengpeng@iscas.ac.cn`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer)
- No `Fixes:` tag (expected per instructions)
- No `Cc: stable` (expected per instructions)
- No `Reported-by:` (no external bug report)
- Record: reviewed by hardware vendor's kernel team and tested by a
  Broadcom engineer; strong quality signal

**Step 1.3: Commit body**
- Bug described: `bdc_sr_xsf()` decodes a 5-bit endpoint number from the
  hardware status report and indexes `bdc->bdc_ep_array[]` without
  validating it. The array is only `bdc->num_eps` entries long.
- Symptom/failure mode: if hardware delivers an `ep_num` in [num_eps,
  32), an out-of-bounds read occurs followed by a dereference of
  whatever garbage pointer was read.
- Record: author clearly identifies the OOB mechanism; this is a
  defensive bounds check

**Step 1.4: Hidden bug fix detection**
- "validate" + "Reject status reports whose endpoint number is outside
  bdc->num_eps before indexing the endpoint array" = hardening that
  prevents OOB array read; this IS a bug fix
- Record: bounds-check fix, effectively a buffer-overread fix

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `drivers/usb/gadget/udc/bdc/bdc_ep.c`
- +4/-0 lines
- Function modified: `bdc_sr_xsf()`
- Record: single-file surgical fix, minimal scope

**Step 2.2: Code flow change**
- Before: decodes `ep_num` from `sreport->offset[3]`, then directly uses
  it as array index into `bdc_ep_array[]`. The subsequent `!ep` check
  only catches the case where the out-of-bounds read happens to return
  NULL.
- After: rejects and logs out-of-range `ep_num` before touching the
  array.
- Record: adds bounds validation on the IRQ-context transfer-complete
  status path

**Step 2.3: Bug mechanism**
- Category (f): memory safety / bounds check
- `bdc->num_eps = num_ieps + num_oeps + 2`, each from 4-bit `NUM_NCS`
  register field (see `drivers/usb/gadget/udc/bdc/bdc_core.c:392-400`),
  so `num_eps` can be as low as 2 and up to 32.
- `ep_num = (le32_to_cpu(sreport->offset[3])>>4) & 0x1f;` yields 0..31.
- For any controller variant where `num_eps < 32`, a status report with
  `ep_num >= num_eps` triggers an out-of-bounds read on
  `bdc_ep_array[ep_num]`, then `ep->flags` dereferences whatever pointer
  was read.
- Record: classic array-index-OOB read on a dynamically-sized array,
  potential NULL-check bypass + dereference of uninitialized/unrelated
  kernel memory

**Step 2.4: Fix quality**
- Obviously correct: `if (ep_num >= bdc->num_eps) return;` is a textbook
  guard.
- Minimal: 4 lines, no unrelated changes.
- Regression risk: ~zero. The only new behavior is rejecting status
  reports with out-of-range endpoint numbers — which the existing code
  could never service correctly anyway.
- Record: fix quality very high; virtually no regression risk

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- `git blame` on the target lines shows the buggy code was introduced by
  `efed421a94e62` ("usb: gadget: Add UDC driver for Broadcom USB3.0
  device controller IP BDC") by Ashwini Pahuja, 2014-11-13.
- `git describe --contains efed421a94e62` → `v3.19-rc1~80^2~32^2~37`.
  Code present since v3.19 (2015).
- Record: bug has been latent in the driver since v3.19 — present in
  every currently supported stable tree

**Step 3.2: Fixes: tag**
- None present (expected).
- Record: no explicit Fixes target; buggy code is the original driver
  submission

**Step 3.3: Related file history**
- `git log --oneline -20 -- drivers/usb/gadget/udc/bdc/bdc_ep.c` shows
  only minor cleanups since 2014 — no semantic churn.
- Record: no prerequisites; patch is self-contained

**Step 3.4: Author history**
- Author Pengpeng Hou is a systematic hardening contributor doing
  "validate X indices" / "bound Y buffer" patches across multiple
  subsystems (wifi, NFC, Bluetooth, USB, tracing, etc.).
- Record: author has a consistent track record of bounds-check hardening
  fixes

**Step 3.5: Dependencies**
- None; patch only adds a local `if` block. No new functions or
  structures referenced.
- Record: standalone fix

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1: b4 dig**
- `b4 dig -c a402532ab8556` found the original thread:
  https://patch.msgid.link/20260323121730.75245-1-pengpeng@iscas.ac.cn
- `b4 dig -c a402532ab8556 -a` shows only v1 exists; applied version is
  the submitted version.
- Mbox thread read: Florian Fainelli (Broadcom) Reviewed-by; Justin Chen
  (Broadcom) Tested-by. No NAKs, no concerns, no stable discussion.

**Step 4.2: Recipients**
- `b4 dig -c ... -w`: Justin Chen, Al Cooper, Broadcom kernel feedback
  list, Greg KH, linux-usb, LKML. Correct mailing lists and Broadcom
  maintainers were CC'd.

**Step 4.3: Bug report**
- No `Reported-by:` tag, no syzbot/bugzilla link. Patch is author-
  initiated hardening.

**Step 4.4: Series**
- Single-patch series; no dependencies.

**Step 4.5: Stable list**
- No explicit stable nomination in the thread.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**
- `bdc_sr_xsf()` only.

**Step 5.2: Callers**
- `bdc->sr_handler[0] = bdc_sr_xsf;` in `bdc_core.c:301`
- Called from `bdc_udc_interrupt()` in `bdc_udc.c:331` via the
  sr_handler dispatch
- Context: hard IRQ handler, executes whenever hardware posts a
  transfer-complete status report into the SRR ring (DMA-backed memory
  read via `rmb()`)
- Record: hot path in the IRQ handler, runs on every transfer completion

**Step 5.3: Callees**
- Reads DMA-backed `sreport`, indexes `bdc_ep_array[]`, dispatches by
  sr_status.

**Step 5.4: Call chain reachability**
- Any functioning USB gadget transfer on BDC-based hardware will
  generate XSF status reports. The path is reachable every time a device
  does USB I/O.

**Step 5.5: Similar patterns**
- Multiple "validate endpoint index" siblings exist in USB gadget UDC
  drivers, all have gone through stable:
  - `ee0d382feb44` usb: gadget: aspeed_udc: validate endpoint index — in
    6.1.y, 6.6.y, 6.12.y
  - `ce9daa2efc08` usb: gadget: fsl_qe_udc: validate endpoint index — in
    pending-6.6
  - `f880aac8a57e` (cherry `e4c25cedbbeee`) usb: gadget: renesas_usb3:
    validate endpoint index — in pending-6.6
  - `7f14c7227f34` USB: gadget: validate endpoint index for xilinx udc —
    has Cc: stable
- Record: consistent pattern; this is exactly the same class of fix

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code in stable?**
- Checked `stable/linux-6.1.y`, `stable/linux-6.6.y`,
  `stable/linux-6.12.y` — the vulnerable snippet in `bdc_sr_xsf()` is
  identical to mainline pre-patch. Present since v3.19.
- Record: all active stable trees (6.1+) contain the buggy code

**Step 6.2: Backport complications**
- The surrounding function is unchanged in all stable branches; patch
  applies verbatim.
- Record: clean apply expected

**Step 6.3: Related fixes already in stable?**
- None. The other UDC driver "validate endpoint" fixes target different
  files.

### PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `drivers/usb/gadget/udc/bdc/` — USB gadget device controller driver
  for Broadcom STB SoCs
- Criticality: PERIPHERAL — specific Broadcom SoC hardware
- Record: niche driver but active; used on Broadcom STB/set-top box
  platforms

**Step 7.2: Activity**
- Low-churn driver; mostly cleanup commits in the past years, no major
  refactors.

### PHASE 8: IMPACT / RISK

**Step 8.1: Affected users**
- Users of BDC-based Broadcom hardware (ARM STB platforms with USB
  gadget).
- Record: driver-specific; small-to-moderate population

**Step 8.2: Trigger conditions**
- `num_eps` is derived from hardware registers
  (`BDC_FSCNIC`/`BDC_FSCNOC`, `NUM_NCS() = val >> 28`, so 4-bit
  quantities). For any BDC variant with fewer than 30 configurable
  endpoints, `num_eps < 32` and the 5-bit `ep_num` space can overflow
  the array. Triggering requires the hardware/firmware to post a status
  report with an unexpected `ep_num`, or DMA corruption, or a stale
  entry in the SRR.
- Record: not user-triggerable directly; triggered by hardware/firmware
  behavior

**Step 8.3: Failure mode severity**
- OOB read of a `struct bdc_ep *` pointer beyond the kzalloc'd array →
  dereference at `ep->flags` of arbitrary adjacent heap data. Potential
  outcomes:
  - If read yields 0: caught by `!ep` check (benign).
  - If read yields non-NULL garbage: kernel dereferences it → oops /
    crash / info leak / possibly exploitable.
- Severity: MEDIUM-HIGH (kernel OOB read + potential crash in IRQ
  context)

**Step 8.4: Risk-benefit**
- Benefit: eliminates a real OOB array read in an IRQ handler of a long-
  lived driver; matches a widely-backported pattern for UDC drivers.
- Risk: 4-line additive guard on an error path; cannot affect valid code
  flow.
- Record: very favorable risk/benefit

### PHASE 9: SYNTHESIS

**Evidence for backport:**
- Real OOB array access (array dynamically sized to `num_eps < 32`,
  index from 5-bit field 0..31)
- Small, obviously correct 4-line fix
- Reviewed by the Broadcom maintainer (Florian Fainelli)
- Tested by a Broadcom engineer (Justin Chen)
- Applied by the USB subsystem maintainer (Greg KH)
- Clean apply to all active stable trees
- Strong and consistent precedent: identical "validate endpoint index"
  patches in `aspeed_udc`, `fsl_qe_udc`, `renesas_usb3`, `xilinx udc`
  have all been taken into stable, many without `Fixes:` tags
- Latent since v3.19; present in every supported stable tree

**Evidence against:**
- No concrete crash report / `Reported-by:` / syzbot link
- Hardware/firmware-triggered rather than userspace-triggered
- Driver is peripheral (Broadcom STB hardware)

**Stable rules checklist:**
1. Obviously correct and tested? YES (reviewed and tested by the
   hardware vendor)
2. Fixes a real bug? YES (OOB array read potential)
3. Important issue (crash/security)? YES (kernel OOB in IRQ context)
4. Small and contained? YES (+4 lines)
5. No new features/APIs? YES
6. Applies cleanly? YES

**Exception category:** hardware hardening fix — matches the well-
established "validate endpoint index" pattern for USB UDC drivers.

## Verification

- [Phase 1] Parsed all tags via `git show a402532ab8556`: Reviewed-by
  Florian Fainelli (Broadcom), Tested-by Justin Chen (Broadcom), Signed-
  off-by Greg KH. No Fixes/Cc-stable/Reported-by.
- [Phase 2] Diff analysis: 4 lines added at `bdc_ep.c:1650`, bounds
  check `if (ep_num >= bdc->num_eps)` before `ep =
  bdc->bdc_ep_array[ep_num]`.
- [Phase 2] Confirmed `num_eps` derivation in
  `drivers/usb/gadget/udc/bdc/bdc_core.c:392-400`: `num_ieps + num_oeps
  + 2`, where each comes from `NUM_NCS()` (4-bit hardware register
  field). `num_eps` range ≤ 32.
- [Phase 3] `git blame -L 1646,1656
  drivers/usb/gadget/udc/bdc/bdc_ep.c`: buggy code from `efed421a94e62`
  (2014).
- [Phase 3] `git describe --contains efed421a94e62` →
  `v3.19-rc1~80^2~32^2~37` (v3.19 kernel).
- [Phase 4] `b4 dig -c a402532ab8556`: original submission found.
- [Phase 4] `b4 dig -c a402532ab8556 -a`: only v1 exists.
- [Phase 4] `b4 dig -c a402532ab8556 -w`: correct Broadcom maintainers
  CC'd.
- [Phase 4] Read `/tmp/bdc/thread.mbox`: Florian Fainelli Reviewed-by,
  Justin Chen Tested-by, no concerns raised.
- [Phase 5] `git grep sr_handler`: caller is `bdc_udc_interrupt()` in
  `drivers/usb/gadget/udc/bdc/bdc_udc.c:331`. Runs in hard IRQ context
  on every transfer completion.
- [Phase 5] Sibling "validate endpoint index" patches identified:
  `ee0d382feb44` aspeed, `ce9daa2efc08` fsl_qe_udc, `f880aac8a57e`
  renesas_usb3, `7f14c7227f34` xilinx.
- [Phase 6] `git show
  stable/linux-6.1.y:drivers/usb/gadget/udc/bdc/bdc_ep.c`, same for
  6.6.y and 6.12.y: identical pre-patch code present — patch applies
  cleanly to all active stable trees.
- [Phase 6] `git log --grep="aspeed_udc: validate endpoint"
  stable/linux-{6.1,6.6,6.12}.y`: confirmed identical-pattern aspeed_udc
  patch was backported to all three stable trees despite having no
  Fixes: tag and no Cc: stable.
- [Phase 8] Failure mode: OOB read of `struct bdc_ep *` beyond kzalloc'd
  array in IRQ context → potential oops when the garbage pointer is
  dereferenced at `ep->flags`; severity MEDIUM-HIGH.
- UNVERIFIED: I did not confirm specific BDC hardware variants ship with
  `num_eps < 32`, though the register encoding clearly allows it and the
  commit message plus hardware-vendor Tested-by imply it is realistic.
  The precedent-based reasoning does not depend on this detail.

The fix is a minimal, obviously-correct bounds check that prevents a
real out-of-bounds array read in an interrupt handler of a driver
present since v3.19. It has been reviewed by the subsystem maintainer,
tested by the hardware vendor, and precisely matches a pattern
("validate endpoint index for <udc>") that stable has consistently
accepted, including patches without `Fixes:` tags.

**YES**

 drivers/usb/gadget/udc/bdc/bdc_ep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_ep.c b/drivers/usb/gadget/udc/bdc/bdc_ep.c
index c0ab3347059a0..a7a22e5ec47ba 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_ep.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_ep.c
@@ -1647,6 +1647,10 @@ void bdc_sr_xsf(struct bdc *bdc, struct bdc_sr *sreport)
 	u8 ep_num;
 
 	ep_num = (le32_to_cpu(sreport->offset[3])>>4) & 0x1f;
+	if (ep_num >= bdc->num_eps) {
+		dev_err(bdc->dev, "xsf for invalid ep %u\n", ep_num);
+		return;
+	}
 	ep = bdc->bdc_ep_array[ep_num];
 	if (!ep || !(ep->flags & BDC_EP_ENABLED)) {
 		dev_err(bdc->dev, "xsf for ep not enabled\n");
-- 
2.53.0

