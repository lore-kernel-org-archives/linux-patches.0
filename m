Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E303F7A8A;
	Tue, 28 Apr 2026 10:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372985; cv=none; b=UVgOPDjQwzI115SJfduqzQS+myqKNTotM/X4WG+Fz+JyOrvsNPJjs8C2fuiaRAztna9oQ7gqTGoNIZpE9IgEjvkOzy6ts5VxIwbHAXQ1Ea+x7YtKzTLa5PnNiW4bP04AhSblttPSwnH3UTEBioJU7KbAeFTEdpNOW5kuajyWnQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372985; c=relaxed/simple;
	bh=IXqp27RY7rXo8SpZ9XP8azILoF0q9oEW5FuTsim8Myc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujy+npO3h19VV3x9MaNZ1+L5eDC2EwObfM3r/9q9LKcEnXRBp3IiizejRbjGVB9UXT8ULA/JcDFJ0Vq7rRc90P1WmsjHvYgyrezLr+in2GgRaYQbXaT0cfn7FSnY+cjKjAPrGIAArqmCnx33E6rfq9x0IQSFFGlTHj9+hcTxc1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWWdGQUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWWdGQUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C41C2BCB7;
	Tue, 28 Apr 2026 10:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372985;
	bh=IXqp27RY7rXo8SpZ9XP8azILoF0q9oEW5FuTsim8Myc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWWdGQUp8tcconSH6O8ZDjoTSn/bO4PyxfRLEFjBpPJoAvRGwXCFLzFe1HouoVyEc
	 Iel1rRlck5P4WUeEfYfsh+cJcdP+5SgM3li9ESrFfejYszi/tefIq2lLJCukh3Hay6
	 6bRDhI4l4oRo/s/kgbUoKRen03iPy9mEBBuQsaaYlXKBd7WUDscdDjpD5l8cZI70cQ
	 VfIRSvgRLV0VaV+zEAODkHDhAoSuQLhUi8GTU1T0ve3I80lWotZ+IsLF2+GZ740OIF
	 vnyUlpulds6U5DHWaPMqexhTRbF43wAuc4bvu4+zslTOcqXh/emCleZwK+gssVFHba
	 74xAF2gqZNZEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kelvin Mbogo <addcontent08@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	valentina.manea.m@gmail.com,
	shuah@kernel.org,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] usb: usbip: validate iso frame actual_length in usbip_recv_iso()
Date: Tue, 28 Apr 2026 06:41:14 -0400
Message-ID: <20260428104133.2858589-63-sashal@kernel.org>
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

From: Kelvin Mbogo <addcontent08@gmail.com>

[ Upstream commit 591c1d972d8f19862ecd7279c7ef4df48b0a9b33 ]

usbip_recv_iso() sums each frame's actual_length into an int
accumulator without checking the individual values first:

    total_length += urb->iso_frame_desc[i].actual_length;

A malicious server can send actual_length = 0xFFFFFFFC for one frame
and a small value for the other, making the signed sum wrap around to
match urb->actual_length.  The sanity check passes, and usbip_pad_iso()
later computes a negative actualoffset, feeding it to memmove() as a
source pointer - reads before the allocation, leaked to userspace via
USBDEVFS_REAPURB.

Reject any frame whose actual_length exceeds transfer_buffer_length
(one frame can't carry more data than the whole buffer), and widen the
accumulator to u32 so that many moderately-large frames can't wrap it
either.

Signed-off-by: Kelvin Mbogo <addcontent08@gmail.com>
Link: https://patch.msgid.link/20260325103640.8090-2-addcontent08@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough information to make an informed decision. Let me now
compile the comprehensive analysis.

## Phase 1: Commit Message Forensics

**Step 1.1 - Subject Line**
- Subsystem: `usb: usbip` (USB/IP driver)
- Action verb: `validate` (strong bug-fix indicator, even without "fix")
- Record: `[usb/usbip] [validate/harden] ISO frame actual_length in
  usbip_recv_iso() to prevent integer wraparound and downstream OOB
  read`

**Step 1.2 - Tags Present**
- `Signed-off-by: Kelvin Mbogo` (author)
- `Link:
  https://patch.msgid.link/20260325103640.8090-2-addcontent08@gmail.com`
  (patch 2 of a series)
- `Signed-off-by: Greg Kroah-Hartman` (USB maintainer – strong trust
  signal)
- No `Fixes:` tag (expected for pre-git-era code in staging origin)
- No `Cc: stable` (expected; that's why it's under review)
- Record: Greg KH SOB confirms maintainer applied it; Link shows this is
  patch "-2" of the series.

**Step 1.3 - Body Analysis**
- Bug mechanism: `total_length` is `int` (signed) accumulator; per-frame
  `actual_length` is from the wire (attacker-controlled `unsigned int`)
- Exploit: server sends `actual_length = 0xFFFFFFFC` + small value;
  signed sum wraps to match `urb->actual_length`, passing the sanity
  check
- Downstream impact: `usbip_pad_iso()` computes negative `actualoffset`
  → `memmove()` reads before allocation → data leaked to userspace via
  `USBDEVFS_REAPURB`
- Fix approach: (1) reject any frame whose `actual_length >
  transfer_buffer_length`; (2) widen accumulator from `int` to `u32`
- Record: Concrete, reproducible kernel info-leak from malicious USBIP
  server; commit body explains both root cause and fix clearly.

**Step 1.4 - Hidden Fix Detection**
- "validate" = adds missing input validation = bug fix
- Record: Not hidden - this is an explicit security hardening fix.

## Phase 2: Diff Analysis

**Step 2.1 - Inventory**
- Single file: `drivers/usb/usbip/usbip_common.c`
- +12 / -3 (15 changed lines total)
- Single function modified: `usbip_recv_iso()`
- Classification: small, single-file surgical fix
- Record: Minimal scope; textbook stable-appropriate patch size.

**Step 2.2 - Code-Flow Change**
- Before: `int total_length = 0; ... total_length +=
  urb->iso_frame_desc[i].actual_length;` then `if (total_length !=
  urb->actual_length)`
- After: `u32 total_length = 0;` + per-iteration `if
  (iso_frame_desc[i].actual_length > transfer_buffer_length) return
  -EPROTO;` + cast comparison to u32
- Affected path: RET_SUBMIT handling in vhci-hcd receive path (network-
  sourced data)
- Record: Hardens the receive path for untrusted network input.

**Step 2.3 - Bug Mechanism Category**
- (d) Memory safety + integer overflow: `u32` widening prevents signed
  accumulator wrap; bounds check prevents any single-frame value from
  being > buffer capacity
- Secondary: (g) Logic correctness — format specifier `%d` → `%u` and
  explicit `(u32)` cast make the comparison semantically correct
- Record: Classic "validate untrusted input from the wire" pattern —
  same class as the 2016 commit `b348d7dddb6c4` in the same file.

**Step 2.4 - Fix Quality**
- Obviously correct: bounds check is simple (`actual_length >
  transfer_buffer_length → reject`), u32 widening cannot introduce new
  overflow behavior in a non-negative accumulation
- No regression risk: rejects only genuinely malformed input; legitimate
  clients never produce frames larger than the whole buffer
- Record: High-quality, minimal, safe fix.

## Phase 3: Git History Investigation

**Step 3.1 - Blame**
- `usbip_recv_iso()` was introduced by `05a1f28e879e3` ("Staging:
  USB/IP: add common functions needed", July 2008)
- Record: Vulnerable code present since 2.6.28 — affects every single
  active stable tree.

**Step 3.2 - Fixes: Tag**
- No Fixes: tag present; the buggy pattern dates to the original 2008
  import (pre-git staging era for USBIP)
- Record: N/A — but effectively "Fixes: 05a1f28e879e3" which predates
  all stable branches.

**Step 3.3 - File History**
Recent commits touching `drivers/usb/usbip/usbip_common.c`:
- `2ab833a16a825` usbip: validate number_of_packets in
  usbip_pack_ret_submit() **[has `Cc: stable`]**
- `74a2287209a85` usb: usbip: fix OOB read/write in usbip_pad_iso()
  (patch 3/3 of series)
- `591c1d972d8f1` **← TARGET** (patch 2/3)
- `1897852293fac` usb: usbip: fix integer overflow in usbip_recv_iso()
  (patch 1/3)
- Record: Part of a 3-patch hardening series against malicious USBIP
  server. Companion patch from Nathan Rebello (`2ab833a16a825`)
  explicitly has `Cc: stable`, confirming maintainers view this cluster
  of bugs as stable-worthy.

**Step 3.4 - Author Context**
- Kelvin Mbogo: new contributor sending hardening patches; patches
  vetted by Greg KH with v1→v2 rework
- Greg KH (USB maintainer) applied all three patches
- Record: Proper maintainer review chain, v2 addressed review feedback.

**Step 3.5 - Prerequisite Check**
- The diff hunks in `591c1d972d8f1` (the target) only touch:
  1. `int total_length = 0;` → `u32 total_length = 0;`
  2. Add per-frame actual_length bounds check
  3. Cast/format the comparison
- I verified that stable/linux-6.19.y (and all older stable branches)
  still contain `int total_length = 0;` and the unmodified loop/check —
  so the patch hunks CAN apply standalone without patch 1/3
- However, this patch is part of a security cluster; ideally patches
  1/3, 2/3, 3/3 + Nathan's `2ab833a16a825` all get backported together
- Record: Patch applies cleanly to stable without dependencies, though
  full cluster is the complete fix.

## Phase 4: Mailing List Research

**Step 4.1 - Original Thread (b4 dig)**
- `b4 dig -c 591c1d972d8f1` found match at `https://lore.kernel.org/all/
  20260325103640.8090-2-addcontent08@gmail.com/`
- `b4 dig -a` confirmed series evolution: v1 → v2 (applied version is
  v2)
- v2 changes per Kelvin: "Drop Reported-by (author is signer)"
- Record: v2 is the applied version, v1 received feedback from Greg KH
  and was refined.

**Step 4.2 - Reviewers (b4 dig -w)**
- Originally CC'd: `linux-usb@vger.kernel.org`,
  `gregkh@linuxfoundation.org`, `skhan@linuxfoundation.org` (USBIP
  maintainer)
- Both the USB subsystem maintainer (Greg KH) and the USBIP subsystem
  maintainer (Shuah Khan) were in loop
- Record: Proper maintainer review coverage.

**Step 4.3 - Bug Report**
- No explicit Reported-by/syzbot on v2 (author is signer)
- Exploit scenario clearly described in commit message with concrete
  payload (`0xFFFFFFFC`) and path to userspace via `USBDEVFS_REAPURB`
- Record: Author-discovered security issue; mechanism is well-documented
  in commit body.

**Step 4.4 - Related Patches**
- Thread shows all three patches of the series (patches 1/3, 2/3, 3/3 by
  Kelvin)
- Companion patch from Nathan Rebello posted in same thread got `Acked-
  by: Shuah Khan` and `Cc: stable@vger.kernel.org`, submitted separately
  as `2ab833a16a825`
- Greg KH explicitly asked Nathan to "submit it separately, on top of
  that series, to make it easier to review and apply"
- Record: Maintainers treat this as a coordinated security cluster;
  Nathan's companion patch explicitly nominated for stable.

**Step 4.5 - Stable List**
- Not individually discussed on stable list (fix flew under radar of
  formal stable nomination process for 1/3, 2/3, 3/3 — only the
  separately-submitted Nathan patch has Cc: stable)
- Record: This is exactly the kind of fix that SHOULD be caught by
  autosel review.

## Phase 5: Code Semantic Analysis

**Step 5.1 - Functions Modified**
- `usbip_recv_iso()` (single function changed)

**Step 5.2 - Callers**
- `drivers/usb/usbip/vhci_rx.c:86` → called from
  `vhci_recv_ret_submit()` (vhci-hcd RX path, client side)
- `drivers/usb/usbip/stub_rx.c:605` → stub_rx RET_SUBMIT handling
  (server side)
- `drivers/usb/usbip/vudc_rx.c:173` → VUDC receive path
- Record: Called from every USBIP RET_SUBMIT receive path. Critical path
  for any USBIP user.

**Step 5.3 - Callees**
- `usbip_pack_iso()` — deserialize ISO frame descriptor
- `usbip_iso_packet_correct_endian()` — byte-order conversion
- `usbip_recv()` — TCP socket recv
- Record: Pure data-processing function for wire-format data.

**Step 5.4 - Reachability**
- Call chain: user runs `usbip attach` (CAP_SYS_ADMIN) → vhci-hcd
  connects to USBIP server → kernel RX thread `vhci_rx_loop` →
  `vhci_recv_ret_submit` → `usbip_recv_iso` → on return, `usbip_pad_iso`
  → memmove into user-readable buffer → userspace `USBDEVFS_REAPURB`
  reads kernel memory
- Record: Directly reachable from the network when connected to a
  malicious USBIP server — all the leaked data then reaches userspace.

**Step 5.5 - Similar Patterns**
- `usbip_recv_xbuff()` already validates `size >
  urb->transfer_buffer_length` (from commit `b348d7dddb6c4`, 2016) —
  this patch applies the same defensive pattern to ISO frames
- Record: Patch extends an established validation pattern already
  accepted in the same file.

## Phase 6: Cross-Referencing Stable Trees

**Step 6.1 - Vulnerable Code in Stable**
- Verified via `git show
  stable/linux-6.19.y:drivers/usb/usbip/usbip_common.c` that the
  unpatched vulnerable code (`int total_length`, no per-frame bounds
  check) is present
- Code unchanged since 2008 staging import → present in 5.10.y, 5.15.y,
  6.1.y, 6.6.y, 6.12.y, 6.17.y (if active), 6.18.y, 6.19.y
- Record: All active stable trees contain the bug.

**Step 6.2 - Backport Complications**
- None of prerequisite patch 1/3 (`1897852293fac`) or companion 3/3
  (`74a2287209a85`) is in any stable tree yet
- The specific hunks of this patch do not depend on 1/3 — they modify
  `int total_length` which exists in all stable trees
- Expected: clean apply
- Record: Should apply cleanly to all stable branches; the full security
  benefit requires also backporting 1/3 and 3/3.

**Step 6.3 - Related Fixes in Stable**
- None yet — this entire USBIP security cluster is fresh (March-April
  2026)
- Record: No conflicting/duplicate fixes in stable.

## Phase 7: Subsystem Context

**Step 7.1 - Criticality**
- `drivers/usb/usbip/` = USB/IP driver (used in VM environments, remote
  USB access, Android development, CI with USB test devices)
- Criticality: IMPORTANT (affects users who use USB/IP; not CORE but not
  obscure)
- Record: IMPORTANT criticality — specific user population but real
  attack surface.

**Step 7.2 - Activity**
- USBIP has periodic maintenance with multiple historical security fixes
  (race conditions, shift OOB, buffer validation); active subsystem
- Record: Maintained subsystem with history of similar stable-worthy
  hardening patches.

## Phase 8: Impact & Risk

**Step 8.1 - Who's Affected**
- Any user who runs `usbip attach` to connect to a remote USBIP server
  (then connection to a compromised/malicious server exposes the client)
- Record: USBIP client users — real user population, not a theoretical
  risk.

**Step 8.2 - Trigger**
- Attacker runs malicious USBIP server; user attaches to it; server
  returns crafted RET_SUBMIT
- Attach requires privileged operation, but once attached, reading data
  via `USBDEVFS_REAPURB` is accessible to any process with access to the
  virtual device
- Record: Trigger is "connect to malicious USBIP server" — a very
  realistic scenario (VM escapes, supply-chain USBIP servers,
  compromised networks).

**Step 8.3 - Failure Severity**
- OOB slab read → kernel memory leaked to userspace = **information
  disclosure** (potential leak of sensitive data: kernel pointers,
  credentials, keys)
- Could be chained with other bugs for KASLR bypass or further
  exploitation
- Severity: **HIGH** (info leak, security-relevant)
- Record: HIGH — kernel info leak to userspace via crafted network
  input.

**Step 8.4 - Risk/Benefit**
- Benefit: HIGH — closes a security-relevant info leak in untrusted-
  network parsing path
- Risk: VERY LOW — adds a bounds check and a type widening; cannot
  produce false rejections on legitimate data (no legitimate frame can
  be larger than the whole buffer); u32 widening is semantically
  equivalent for non-overflowing cases
- Record: Excellent benefit/risk ratio.

## Phase 9: Final Synthesis

**Step 9.1 - Evidence Summary**

FOR backporting:
- Security fix: kernel info leak from attacker-controlled network input
  to userspace
- Small (+12/-3), single-file, single-function, surgical
- Obviously correct: simple bounds check + type widening
- Vulnerable code present since 2008 — every active stable affected
- Signed off by USB maintainer Greg KH; reviewed through v1→v2 cycle
- Follows established pattern (`b348d7dddb6c4`, 2016) accepted in same
  file for `usbip_recv_xbuff`
- Companion patch in the same security cluster has explicit `Cc: stable`
- Applies cleanly to stable trees even without prerequisite patch 1/3

AGAINST backporting:
- Patch 2/3 of a series; ideally 1/3 and 3/3 should also be backported
  for complete defense-in-depth
- No explicit `Cc: stable` (but absence is expected — that's the autosel
  context)

Unresolved:
- No CVE assigned yet (not a blocker — many pre-CVE security fixes are
  backported)

**Step 9.2 - Stable Rules Checklist**
1. Obviously correct? ✅ Yes
2. Fixes real bug? ✅ Yes (kernel info leak)
3. Important? ✅ HIGH — security issue
4. Small & contained? ✅ +12/-3, single function
5. No new features? ✅ Pure input validation
6. Applies to stable? ✅ Verified: hunks match stable code

**Step 9.3 - Exception Category**
- Hardening / security validation of untrusted network input — fits
  under "fixes a real bug" (not strictly an exception category, but
  textbook stable material)

**Step 9.4 - Decision**
YES. The benefit (closing a kernel info-leak attackable by a malicious
USBIP server) significantly outweighs the risk (near-zero — the change
is input validation + type widening).

## Verification

- **[Phase 1]** Parsed subject and tags: Verified Link to lore, Greg KH
  SOB (USB maintainer), absence of Fixes/Cc:stable expected for review
  candidate.
- **[Phase 1]** Body analysis: commit explains `0xFFFFFFFC + small =
  wraparound` mechanism, path to `USBDEVFS_REAPURB` info leak.
- **[Phase 2]** Ran `git show 591c1d972d8f1`: confirmed +12/-3 in single
  file, single function `usbip_recv_iso()`.
- **[Phase 2]** Read `include/linux/usb.h`: verified
  `iso_frame_desc[i].actual_length` is `unsigned int` (line 1418),
  `urb->actual_length` is `u32` (line 1655),
  `urb->transfer_buffer_length` is `u32` (line 1654) — confirms signed-
  wrap bug is real.
- **[Phase 3]** `git log --follow` traced `usbip_common.c` back to
  `05a1f28e879e3` (July 2008, staging import) — bug predates all stable
  branches.
- **[Phase 3]** `git log origin/master --
  drivers/usb/usbip/usbip_common.c`: found the 3-patch series
  (1897852293fac, 591c1d972d8f1, 74a2287209a85) plus companion
  `2ab833a16a825` which has `Cc: stable`.
- **[Phase 3]** Read
  `stable/linux-6.19.y:drivers/usb/usbip/usbip_common.c`: confirmed
  unpatched code (`int total_length`, no bounds check) is present.
- **[Phase 4]** `b4 dig -c 591c1d972d8f1`: found `https://lore.kernel.or
  g/all/20260325103640.8090-2-addcontent08@gmail.com/`.
- **[Phase 4]** `b4 dig -c 591c1d972d8f1 -a`: confirmed series went v1 →
  v2 (applied version is v2 after Greg's feedback).
- **[Phase 4]** `b4 dig -c 591c1d972d8f1 -w`: confirmed Greg KH and
  Shuah Khan (USBIP maintainer) were CC'd.
- **[Phase 4]** Read thread mbox: confirmed Greg KH directed Nathan to
  submit his companion patch separately, and that companion got `Acked-
  by: Shuah Khan` + `Cc: stable`.
- **[Phase 5]** Grep on usbip directory: verified `usbip_recv_iso` is
  called from `vhci_rx.c:86`, `stub_rx.c:605`, `vudc_rx.c:173`;
  `usbip_pad_iso` called from `vhci_rx.c:92`.
- **[Phase 5]** Read `vhci_rx.c`: confirmed the exploit path
  `usbip_recv_iso → usbip_pad_iso → memmove into transfer_buffer` that
  later reaches userspace.
- **[Phase 5]** Verified precedent commit `b348d7dddb6c4` (2016) applied
  exactly the same "validate untrusted length" pattern to
  `usbip_recv_xbuff` in the same file.
- **[Phase 6]** Checked `stable-rc-push/linux-*.y` branches: no USBIP
  security series patches applied yet.
- **[Phase 6]** Inspected hunks vs stable code: the three hunks only
  touch `int total_length = 0`, the iso-decode loop, and the post-loop
  comparison — all present in all stable trees. Expected clean apply
  independent of patch 1/3.
- **[Phase 7]** Context: `drivers/usb/usbip/` — IMPORTANT criticality
  (VM/remote USB users).
- **[Phase 8]** Severity: HIGH — kernel slab OOB read → info leak to
  userspace via USBDEVFS_REAPURB, triggered by crafted USBIP server
  replies.
- UNVERIFIED: Exact minor versions of 5.10.y/5.15.y/etc. weren't walked
  line-by-line, but mainline unpatched state in 6.19.y + unchanged code
  since 2008 staging import reliably implies bug exists in all active
  stable branches.

The fix is a small, surgical, obviously-correct validation of attacker-
controlled network input that prevents a kernel information leak. It
applies cleanly to all active stable trees, is signed off by the USB
subsystem maintainer, and follows an established pattern already
accepted in the same file. The companion fix in the same security
cluster is already explicitly nominated for stable. This is textbook
stable material.

**YES**

 drivers/usb/usbip/usbip_common.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index a2b2da1255dda..29d776fbeef74 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -665,7 +665,7 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 	int size = np * sizeof(*iso);
 	int i;
 	int ret;
-	int total_length = 0;
+	u32 total_length = 0;
 
 	if (!usb_pipeisoc(urb->pipe))
 		return 0;
@@ -696,14 +696,23 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 	for (i = 0; i < np; i++) {
 		usbip_iso_packet_correct_endian(&iso[i], 0);
 		usbip_pack_iso(&iso[i], &urb->iso_frame_desc[i], 0);
+		if (urb->iso_frame_desc[i].actual_length >
+				(unsigned int)urb->transfer_buffer_length) {
+			dev_err(&urb->dev->dev,
+				"recv iso: frame actual_length %u exceeds buffer %d\n",
+				urb->iso_frame_desc[i].actual_length,
+				urb->transfer_buffer_length);
+			kfree(buff);
+			return -EPROTO;
+		}
 		total_length += urb->iso_frame_desc[i].actual_length;
 	}
 
 	kfree(buff);
 
-	if (total_length != urb->actual_length) {
+	if (total_length != (u32)urb->actual_length) {
 		dev_err(&urb->dev->dev,
-			"total length of iso packets %d not equal to actual length of buffer %d\n",
+			"total length of iso packets %u not equal to actual length of buffer %d\n",
 			total_length, urb->actual_length);
 
 		if (ud->side == USBIP_STUB || ud->side == USBIP_VUDC)
-- 
2.53.0

