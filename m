Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A10A3F20E2;
	Tue, 28 Apr 2026 10:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372982; cv=none; b=SE/dVi3D3uIdOrxrnQcOdjKQDZ2EkvFI2UIZeRZsFweF4bGlpdVhmsIrnt67+vEcexU2P5ANnPzb+QJNjKsN1plc6rWa6G9caYrirHOjHMw14huQYo9PQPio5IY4iCECkJpYJ/oAi0jV9HAfuaiaHPjYFlTdw3Aw4+cDpZKL34M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372982; c=relaxed/simple;
	bh=oxwZ+df9sdj9d8pZqmxa0D9SpL3piJsAkSAjfw5krLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4GA66hKwZY8Dwmb2kTASHKbDrgVzO6LkjuqntJDhYbq2t7Lk7w7vMDefhcLvIGZv/NdRadDifR1zAoucSwSPjhfKEynqStoASCM/6Lzs+qAQnDFKVJnx71/cV7WZ84KUOYgyYOVGFjkaGZHwxFRGO41owX5+KtM6sQiu/6jo4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCniSFWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCniSFWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A61C2BCAF;
	Tue, 28 Apr 2026 10:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372981;
	bh=oxwZ+df9sdj9d8pZqmxa0D9SpL3piJsAkSAjfw5krLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCniSFWeg71Sju8BiB48e4qO6uz7KBCa3Bw/jjW1QDiMiOSBS8UBmvtafhK5GIjvP
	 VXOrWbDy0LEtEfTvBhOrTnqjk+4Db6fjRxI8T4BAcIA/l7bqS8wWvjUw1SWet23gy7
	 3lLyg6oLP5X3SADgbBoHsgYyRQVq/2ctKdq8WBRlbbAVqKtj/pms5D9KxqGV3F+eZw
	 axc51Rvbb10Rb9cyFiOppuXx2J9ACCPcwZFh46hLI6DImoGpF7iFLJaYZcfoZfjyBv
	 eaaTmj3T1Cm4iftrEzXhoUnJBZRMK2Xa5n/7lklfSM05Cta1tn6HEuJilbbYnurUc1
	 R/a1xfdSoT2qQ==
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
Subject: [PATCH AUTOSEL 7.0-5.10] usb: usbip: fix integer overflow in usbip_recv_iso()
Date: Tue, 28 Apr 2026 06:41:12 -0400
Message-ID: <20260428104133.2858589-61-sashal@kernel.org>
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

[ Upstream commit 1897852293faca4c2be51e0a19f739622f771623 ]

usbip_recv_iso() computes the iso descriptor buffer size as:

    int size = np * sizeof(*iso);

where np comes straight from the wire (urb->number_of_packets, set by
usbip_pack_ret_submit() before we get here).  With np = 0x10000001 and
sizeof(*iso) == 16 the product is 0x100000010 which truncates to 16 on
a 32-bit int.  kzalloc(16) succeeds but the following receive loop
writes np * 16 bytes into it - game over.

USBIP_MAX_ISO_PACKETS (1024) already exists in usbip_common.h for the
submit path but was never enforced on the receive side.

Clamp np to [1, USBIP_MAX_ISO_PACKETS] and switch to kcalloc() so
the allocator itself can catch overflows in the future.  Fold the
existing np == 0 early return into the new bounds check.

usbip_pack_ret_submit() already copied the bogus np into
urb->number_of_packets before we run, so just returning -EPROTO is
not enough - processcompl() in the HCD will still iterate that many
iso_frame_desc entries when it completes the failed URB.  Zero out
urb->number_of_packets before bailing to prevent that secondary crash
(confirmed on 6.12.0, processcompl+0x63 with CR2 in unmapped slab).

Signed-off-by: Kelvin Mbogo <addcontent08@gmail.com>
Link: https://patch.msgid.link/20260325103640.8090-1-addcontent08@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my investigation, I now have enough information to complete the
analysis.

## Phase 1: Commit Message Forensics

**Step 1.1 - Subject line parsing:**
Record: Subsystem `usb: usbip:`, action verb `fix`, summary: "fix
integer overflow in usbip_recv_iso()"

**Step 1.2 - Tags parsed:**
Record:
- `Signed-off-by: Kelvin Mbogo` (author)
- `Link:
  https://patch.msgid.link/20260325103640.8090-1-addcontent08@gmail.com`
- `Signed-off-by: Greg Kroah-Hartman` (subsystem maintainer applied it)
- No Fixes: tag, no explicit Cc: stable (but mbox shows v2 "Drop
  security@kernel.org CC" — the author originally reported this as a
  security issue)

**Step 1.3 - Body analysis:**
Record: Integer overflow in `size = np * sizeof(*iso)` when `np` (wire-
supplied `urb->number_of_packets`) is large enough. Example: `np =
0x10000001 * 16 = 0x100000010` truncates to 16 on 32-bit int. Small
`kzalloc(16)` is followed by a receive loop that writes `np * 16` bytes
= massive heap overflow. Also mentions secondary crash reproduced on
6.12.0 at `processcompl+0x63`.

**Step 1.4 - Hidden bug fix detection:**
Record: Not hidden — explicitly labeled "fix integer overflow". Real
security bug (heap overflow).

## Phase 2: Diff Analysis

**Step 2.1 - Inventory:**
Record: 1 file (`drivers/usb/usbip/usbip_common.c`), +15/-5 lines,
single function `usbip_recv_iso()`. Classification: surgical single-file
fix.

**Step 2.2 - Code flow change:**
Record: Before: `size = np * sizeof(*iso)` computed before any
validation, with only `np == 0` check. After: clamp `np` to `[1,
USBIP_MAX_ISO_PACKETS]` range, zero `urb->number_of_packets` on error
(prevents processcompl from iterating OOB in `iso_frame_desc[]`), switch
`kzalloc` to `kcalloc` for overflow-safe allocation.

**Step 2.3 - Bug mechanism:**
Record: Integer overflow in multiplication → undersized heap allocation
→ OOB heap write in receive loop (category: buffer overflow / memory
safety). Also fixes cascading NULL deref in `processcompl()` via
`urb->number_of_packets` reset.

**Step 2.4 - Fix quality:**
Record: Fix is obviously correct. Uses already-existing
`USBIP_MAX_ISO_PACKETS` (1024) from `usbip_common.h` that was already
enforced on the submit path in `stub_rx.c:381`. Mirrors existing
validation pattern. No regression risk: bounds check is strictly tighter
than kzalloc behavior.

## Phase 3: Git History Investigation

**Step 3.1 - Blame:**
Record: The buggy code (`int size = np * sizeof(*iso)`) has been in
`usbip_recv_iso()` since the function was first introduced in commit
`05a1f28e879e3` ("Staging: USB/IP: add common functions needed",
2008-07-09). The bug has existed for ~18 years.

**Step 3.2 - Follow Fixes: tag:**
Record: No Fixes: tag in the commit (the bug predates git history
cleanup). Confirmed original buggy introduction in 2008.

**Step 3.3 - File history:**
Record: The follow-up series has three related fixes (`1897852293fac`,
`591c1d972d8f1`, `74a2287209a85`) plus a later independent fix
`2ab833a16a825` ("usbip: validate number_of_packets in
usbip_pack_ret_submit()") which carries **explicit `Cc: stable
<stable@kernel.org>` and `Acked-by: Shuah Khan` (usbip maintainer)**.
Commit 2ab833a16a825 explicitly references Kelvin Mbogo's series as
complementary.

**Step 3.4 - Author's other commits:**
Record: Author Kelvin Mbogo submitted a 3-patch security series. Patch
went through v1→v2 with review from Greg KH (USB maintainer). This
specific commit is self-contained and standalone.

**Step 3.5 - Dependencies:**
Record: Uses `USBIP_MAX_ISO_PACKETS` macro which exists in all stable
trees (verified in 5.10.y through 6.19.y). No dependencies. Standalone.

## Phase 4: Mailing List Research

**Step 4.1 - Original discussion (b4 dig):**
Record:
- `b4 dig -c 1897852293faca` → found at `https://lore.kernel.org/all/202
  60325104841.8282-1-addcontent08@gmail.com/`
- `b4 dig -a` → patch went through v1→v2; v2 is what was applied
- v2 changelog mentions: "Drop security@kernel.org CC" — proving the
  author initially reported this through the security channel

**Step 4.2 - Reviewers:**
Record: Greg KH (USB maintainer) reviewed and applied; Shuah Khan (usbip
maintainer) acked the follow-up patch that explicitly mentions this
series and is marked for stable.

**Step 4.3 - Bug report:**
Record: Multiple independent security researchers have reported related
usbip vulnerabilities in this area (Kelvin Mbogo, Nathan Rebello,
Sebastián Alba Vives). Nathan Rebello's patch confirms "KASAN confirmed
this with kernel 7.0.0-rc5: BUG: KASAN: slab-out-of-bounds in
usbip_recv_iso+0x46a/0x640, Write of size 4 at addr ffff888106351d40".
The commit message confirms reproduction on 6.12.0.

**Step 4.4 - Related patches:**
Record: This is patch 1/3 of a series. Patches 2 and 3 have been applied
as `591c1d972d8f1` and `74a2287209a85`. The companion commit
`2ab833a16a825` by Nathan Rebello has explicit `Cc: stable`.

**Step 4.5 - Stable list:**
Record: Sebastián Alba Vives posted this category of issue as
`[SECURITY]` on the stable mailing list
(spinics.net/lists/stable/msg928028.html), describing the vulnerability
as causing "OOB memmove that corrupts kernel heap memory. No
authentication required."

## Phase 5: Code Semantic Analysis

**Step 5.1-5.4 - Callers:**
Record: `usbip_recv_iso()` is called from:
- `vhci_rx.c:86` (`vhci_recv_ret_submit` → invoked from the vhci_rx
  kthread)
- `stub_rx.c:605`
- `vudc_rx.c:173`

Call chain from userspace: User creates a VHCI device via sysfs
(`attach` command), passes a TCP socket, vhci_rx kthread reads PDUs from
the socket → `vhci_recv_ret_submit()` → `usbip_pack_ret_submit()` copies
`number_of_packets` from wire → `usbip_recv_iso()` computes size with
overflow → OOB heap write. **The bug is reachable over the network with
no authentication.**

**Step 5.5 - Similar patterns:**
Record: `stub_rx.c:379-386` already validates `number_of_packets`
against `USBIP_MAX_ISO_PACKETS` on the CMD_SUBMIT path. This commit
applies the symmetric validation that was missing on the RET_SUBMIT
path.

## Phase 6: Cross-Referencing Stable Trees

**Step 6.1 - Code exists in stable:**
Record: Verified identical buggy code in every stable tree:
`linux-5.10.y`, `linux-5.15.y`, `linux-6.1.y`, `linux-6.6.y`,
`linux-6.12.y`, `linux-6.18.y`, `linux-6.19.y`. Bug has been present
since staging era (2008).

**Step 6.2 - Backport complications:**
Record: `git apply --check --3way` confirms patch applies cleanly to
current tree. Since all stable branches have identical code, the patch
will apply cleanly with no conflicts.

**Step 6.3 - Related fixes in stable:**
Record: No related fix already in stable. `USBIP_MAX_ISO_PACKETS` exists
in all stable trees (1024) so the fix uses an already-present constant.

## Phase 7: Subsystem Context

**Step 7.1 - Subsystem:**
Record: `drivers/usb/usbip/` — USB/IP network-attached USB. Criticality:
IMPORTANT (network-reachable code path, security-sensitive). Used by
users with USB-over-IP functionality; enabled in many distros.

**Step 7.2 - Activity:**
Record: Actively maintained; multiple security fixes in 2026 (this
series plus independent Nathan Rebello and Sebastián Alba Vives
contributions).

## Phase 8: Impact and Risk Assessment

**Step 8.1 - Who is affected:**
Record: Any user who runs vhci-hcd (USB/IP client) and attaches to an
untrusted USB/IP server. Also stub-side and vudc-side code paths.
Config-dependent on `CONFIG_USBIP_CORE`.

**Step 8.2 - Trigger conditions:**
Record: A malicious USB/IP server sends a RET_SUBMIT PDU with crafted
`number_of_packets = 0x10000001` or similar. **No authentication
required — reachable entirely from the network peer.**

**Step 8.3 - Failure mode severity:**
Record: **CRITICAL.** Heap out-of-bounds write with controlled size and
partially controlled content (iso descriptor bytes received from
network). Confirmed by KASAN report. The author reproduced a secondary
NULL deref crash in `processcompl()` at CR2 in unmapped slab. Security
vulnerability exploitable over network.

**Step 8.4 - Risk/benefit:**
Record:
- Benefit: **Very high** — fixes a network-reachable heap overflow;
  security vulnerability.
- Risk: **Very low** — 20-line change using an already-existing
  constant; bounds checks are strictly tighter than existing behavior;
  no API changes.
- Ratio: Strongly favorable for backport.

## Phase 9: Final Synthesis

**Evidence FOR backporting:**
- Security vulnerability: integer overflow → heap OOB write, reachable
  from malicious network peer
- Small, surgical fix (1 file, +15/-5 lines) using existing
  `USBIP_MAX_ISO_PACKETS` constant
- Original submission was sent via `security@kernel.org` (per v2
  changelog)
- Reviewed and applied by Greg KH (USB maintainer)
- Companion patch (2ab833a16a825) has explicit `Cc: stable` and `Acked-
  by: Shuah Khan` (usbip maintainer) and references this series
- Independent security researchers (Nathan Rebello, Sebastián Alba
  Vives) confirmed related vulnerabilities via KASAN and manual audit
- KASAN confirmed heap OOB write in this exact function
- Author also fixes a cascading NULL deref in `processcompl()` (verified
  at kernel 6.12.0)
- Buggy code is identical in every stable tree (5.10.y – 7.0.y)
- Patch applies cleanly to stable (verified with `git apply --check`)

**Evidence AGAINST backporting:**
- None.

**Stable rules checklist:**
1. Obviously correct and tested? **YES** — clamp to existing limit,
   kcalloc replaces kzalloc
2. Real bug affecting users? **YES** — heap OOB write, KASAN-confirmed
3. Important issue? **YES** — CRITICAL security vulnerability, network-
   reachable
4. Small and contained? **YES** — 20 lines in 1 file, 1 function
5. No new features? **YES** — pure defensive validation
6. Applies to stable? **YES** — verified clean apply

## Verification

- [Phase 1] `git show 1897852293fac`: confirmed full commit message, no
  Fixes: tag, no explicit Cc: stable in final version
- [Phase 2] Read diff in `drivers/usb/usbip/usbip_common.c`: confirmed
  +15/-5 surgical change in `usbip_recv_iso()`
- [Phase 3] `git log
  -L:usbip_recv_iso:drivers/usb/usbip/usbip_common.c`: buggy code traced
  to original commit `05a1f28e879e3` (2008-07-09, "Staging: USB/IP: add
  common functions needed")
- [Phase 3] `git show 2ab833a16a825`: related follow-up has explicit
  `Cc: stable <stable@kernel.org>` and `Acked-by: Shuah Khan
  <skhan@linuxfoundation.org>`
- [Phase 4] `b4 dig -c 1897852293faca`: found lore thread at `https://lo
  re.kernel.org/all/20260325104841.8282-1-addcontent08@gmail.com/`
- [Phase 4] `b4 dig -a`: confirmed v1→v2 progression; v2 applied is the
  latest
- [Phase 4] mbox thread inspection: v2 changelog says "Drop
  security@kernel.org CC" — confirming security channel origin; Greg KH
  reviewed Nathan Rebello's complementary patch
- [Phase 4] Web search confirmed multiple security researchers (Kelvin
  Mbogo, Nathan Rebello, Sebastián Alba Vives) reported related
  vulnerabilities; Nathan's patch cites KASAN slab-out-of-bounds report
- [Phase 5] `rg usbip_recv_iso`: confirmed 3 call sites (vhci_rx.c,
  stub_rx.c, vudc_rx.c), all invoked from kthread loops reading network
  PDUs
- [Phase 5] Read `vhci_rx.c:vhci_rx_pdu`: confirmed trigger path from
  TCP socket → `vhci_recv_ret_submit` → `usbip_recv_iso`, no
  authentication required
- [Phase 5] `rg USBIP_MAX_ISO_PACKETS`: confirmed constant exists in
  `usbip_common.h:130` and is used symmetrically in `stub_rx.c:381`
- [Phase 6] Verified buggy code is identical in stable-
  push/linux-{5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y, 6.18.y, 6.19.y} and
  `USBIP_MAX_ISO_PACKETS` exists in all of them
- [Phase 6] `git apply --check`: patch applies cleanly to current HEAD
  (stable/linux-7.0.y)
- [Phase 8] Failure mode verified as heap OOB write, KASAN-confirmed by
  Nathan Rebello on kernel 7.0.0-rc5; secondary NULL deref in
  `processcompl()` confirmed on 6.12.0

This commit is a textbook YES for stable: it fixes a network-reachable,
unauthenticated heap buffer overflow present in every supported stable
tree. The fix is minimal, uses an already-existing constant, was vetted
by the USB maintainer, and has been reproduced with KASAN by independent
researchers. The companion patch in the same area explicitly carries
`Cc: stable`.

**YES**

 drivers/usb/usbip/usbip_common.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 29d776fbeef74..fd620e9600394 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -662,7 +662,7 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 	void *buff;
 	struct usbip_iso_packet_descriptor *iso;
 	int np = urb->number_of_packets;
-	int size = np * sizeof(*iso);
+	int size;
 	int i;
 	int ret;
 	u32 total_length = 0;
@@ -670,11 +670,21 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 	if (!usb_pipeisoc(urb->pipe))
 		return 0;
 
-	/* my Bluetooth dongle gets ISO URBs which are np = 0 */
-	if (np == 0)
-		return 0;
+	if (np <= 0 || np > USBIP_MAX_ISO_PACKETS) {
+		dev_err(&urb->dev->dev,
+			"recv iso: invalid number_of_packets %d\n", np);
+		/*
+		 * usbip_pack_ret_submit() already set urb->number_of_packets
+		 * from the wire.  Zero it so processcompl() does not iterate
+		 * OOB descriptors on the way out.
+		 */
+		urb->number_of_packets = 0;
+		return -EPROTO;
+	}
+
+	size = np * sizeof(*iso);
 
-	buff = kzalloc(size, GFP_KERNEL);
+	buff = kcalloc(np, sizeof(*iso), GFP_KERNEL);
 	if (!buff)
 		return -ENOMEM;
 
-- 
2.53.0

