Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BD03FCB35;
	Tue, 28 Apr 2026 10:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372930; cv=none; b=BeUDtb+M1EdoGx/AfPhHAbgwuefq+/r4I5MFjVoFUzm7p0/vmQwrviU+FCKQiSg6NUtY74Yj7igOsewH0E8CATpnFDZU6zhQkLSfmeTOe+watlqI2GHkOYXTsN6h2beNDATVobkAHPhdRD5f+40vZoSisF7ybocZPcWNtBeFmO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372930; c=relaxed/simple;
	bh=3mn45ZoRanBLRBbFpAnldLw8IwPma1aTJ6SK1DCHZnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pLqg7Q3bchEYaxAzSZIeLbalVupdVDI9UacPR3q4wFdUdedbcbVN4PId5ML6vx8O/ohz+TQrHvwU8P5s1eDdd0JroNB314iQDL4FYOzduUObq/Ccl9FSh6b4dWwb8aUoGNs4bBBFomWRnok9nUeYG1BVF6jjwOsjvRBdtucZRxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEINo8xe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEINo8xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECE6C2BCB5;
	Tue, 28 Apr 2026 10:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372930;
	bh=3mn45ZoRanBLRBbFpAnldLw8IwPma1aTJ6SK1DCHZnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEINo8xecmLm0xi6IsXlQbRpA+9IEt63inidbUxO3ZmGfZxcg6LBJdSBNIK/hZdfQ
	 pULhwqYPamCMstyPptQs79gIfj0C9IcWovrZfFvXU1fySrwRGbhwQKUaTs6J86oMp/
	 z2AAz5jl5F5cmB0KSXuWf3TxAr5/YakhLUxECpprpb3mtxzuw/oOU9S8D1c+L97uan
	 5S6MAO4DzsjtMzb8INiZnpgy25gBHty2+SbYtN1mnvGT+dXgZW37JfKonf7ZWRZA1N
	 S+M6kJvWsbTfJEwVbK2splTVz5Uzp5TsHX6A3CofPM/pyd+LQSuZxSGQ/lh27F7f7v
	 P2eqiihEodSsA==
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
Subject: [PATCH AUTOSEL 7.0-5.10] usb: usbip: fix OOB read/write in usbip_pad_iso()
Date: Tue, 28 Apr 2026 06:40:37 -0400
Message-ID: <20260428104133.2858589-26-sashal@kernel.org>
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

[ Upstream commit 74a2287209a858470d15e2996ead2337bd293ff4 ]

usbip_pad_iso() repositions ISO frame data within the transfer buffer
via memmove().  Neither the source offset (actualoffset, derived by
subtracting wire-supplied actual_length values) nor the destination
offset (iso_frame_desc[i].offset, taken directly from the wire) is
bounds-checked.

If a crafted actual_length wraps actualoffset negative through the
subtraction (see patch 2/3 for the root cause), the memmove source
points before the allocation - slab OOB read, data returned to
userspace.

Independently, iso_frame_desc[i].offset is never validated against
transfer_buffer_length.  Setting offset past the end of the buffer
gives a fully controlled OOB write into whatever sits next in the
slab - confirmed with offset=400 on a 392-byte buffer, 64-byte write.

Add bounds checks for both the source and destination ranges before
each memmove call.  Use unsigned comparisons after the sign check on
actualoffset to avoid signed/unsigned conversion surprises.

Signed-off-by: Kelvin Mbogo <addcontent08@gmail.com>
Link: https://patch.msgid.link/20260325103640.8090-3-addcontent08@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my extensive investigation, I have enough information to
provide a complete analysis.

## Phase 1: Commit Message Forensics

**Step 1.1 Subject:** `usb: usbip: fix OOB read/write in
usbip_pad_iso()` — subsystem `usb:usbip`, verb **fix**, claim: bounds-
check the source/destination offsets used inside `usbip_pad_iso()`'s
`memmove()`.

**Step 1.2 Tags:**
- `Signed-off-by: Kelvin Mbogo <addcontent08@gmail.com>` (author)
- `Link:
  https://patch.msgid.link/20260325103640.8090-3-addcontent08@gmail.com`
  (v2 3/3)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer applied it)
- No `Fixes:`, no explicit `Cc: stable` (expected for this review
  pipeline)

**Step 1.3 Body:** Two distinct attacks documented:
1. Crafted `actual_length` makes `actualoffset` go negative (subtraction
   underflow) → `memmove()` source points **before** the slab allocation
   → slab OOB read whose bytes are returned to userspace via
   `USBDEVFS_REAPURB`.
2. Wire-supplied `iso_frame_desc[i].offset` is never validated against
   `transfer_buffer_length`. Setting offset past buffer end → fully
   controlled OOB write — **confirmed by the author with offset=400 on a
   392-byte buffer producing a 64-byte OOB write**. Record: both an
   info-leak and a controlled heap write, triggered by a malicious
   USB/IP peer.

**Step 1.4 Hidden fix?** Not hidden at all — "fix OOB read/write" is a
textbook security bug-fix phrasing.

## Phase 2: Diff Analysis

**Step 2.1 Inventory:** Single file `drivers/usb/usbip/usbip_common.c`,
+36 lines, 0 removed. One function: `usbip_pad_iso()`.

**Step 2.2 Flow change:** Before — `memmove(transfer_buffer +
iso_frame_desc[i].offset, transfer_buffer + actualoffset,
iso_frame_desc[i].actual_length)` runs unconditionally on wire-supplied
values. After — two guard blocks reject negative/out-of-range source and
any destination offset that exceeds the buffer, logging and returning
early.

**Step 2.3 Bug mechanism:** (d) memory-safety bounds check + (f)
mitigates signed/unsigned conversion via explicit `actualoffset < 0`
check before the `(unsigned int)` casts. It is categories (a) (input
validation) and (d) (bounds check before `memmove`).

**Step 2.4 Quality:** Fix is surgical, arithmetic is written without
overflow risk (`length > buf - off` pattern, not `off + length > buf`).
Return is early (`void` function), no lock/state changes. Regression
risk: very low — a malformed frame simply skips padding restoration,
which would have corrupted the kernel anyway.

## Phase 3: Git History

**Step 3.1 Blame:** `git blame` shows the vulnerable loop was introduced
in **2011** by `28276a28d8b3cd ("staging: usbip: bugfix for isochronous
packets and optimization")` (Arjan Mels). That commit itself was `Cc:
stable` in 2011, landed in 3.0. Bug has existed in every LTS since then.

**Step 3.2 Fixes: tag:** None declared in the message body, but the
offending code = 28276a28d8b3cd (2011, v3.0).

**Step 3.3 Related changes:** This commit is **patch 3/3** of Kelvin
Mbogo's v2 series. Upstream, the three patches are:
- `1897852293fac` — patch 1/3: integer overflow in `np * sizeof(*iso)`
- `591c1d972d8f1` — patch 2/3: validate per-frame `actual_length`
- `74a2287209a85` — patch 3/3: THIS commit (OOB in `usbip_pad_iso()`)

A related, independent fix by Nathan Rebello — `2ab833a16a825` ("usbip:
validate number_of_packets in `usbip_pack_ret_submit()`") — closed a
fourth related hole; it carried `Cc: stable` and is already backported
as `d374421fc6889` on `pending-7.0`, plus into 6.12/6.6/6.1 pending
branches.

**Step 3.4 Author:** Kelvin Mbogo is a new contributor; fix was applied
by USB maintainer Greg KH. Series acknowledged by `Shuah Khan` (usbip
maintainer) for the parallel Nathan patch.

**Step 3.5 Dependencies:** The commit message references "see patch 2/3
for the root cause" of negative `actualoffset`. Critically, patch 3/3
contains its own `actualoffset < 0` check, so it stands alone; the OOB
write via `iso_frame_desc[i].offset` is **wholly independent** of
patches 1 and 2. Ideally patches 1 and 2 are backported together, but
3/3 still removes a user-triggerable heap OOB write even standalone.

## Phase 4: Mailing-list Research

**Step 4.1 b4 dig / b4 am:** Ran `b4 am -o /tmp/usbip_v3/
20260325103640.8090-3-addcontent08@gmail.com` — lore thread contains v2
patches 1/3, 2/3, 3/3; 4 thread messages + 6 code-review replies. The
committed version is v2, applies cleanly on current tree per b4.

**Step 4.2 Reviewers/CC:** `linux-usb@vger.kernel.org`,
`gregkh@linuxfoundation.org`, `skhan@linuxfoundation.org`. Applied
directly by Greg KH.

**Step 4.3 Bug origin:** Not a syzbot report — found by manual source
audit by the author and independently by Sebastián Alba Vives (spinics
stable-list [SECURITY] post Mar 29 2026: "[SECURITY] usbip:
iso_frame_desc OOB memmove via crafted offset/length"). Two independent
auditors flagging the same class of bug is a strong real-world signal.

**Step 4.4 Series context:** The three-patch series + Nathan Rebello's
complementary patch form a coordinated hardening of the USB/IP receive
path against malicious remote servers.

**Step 4.5 Stable list:** Sebastián's [SECURITY] post on 2026-03-29
proposed validating offset/length for the same issue, targeting stable
explicitly. The class has clear stable-maintainer awareness.

## Phase 5: Code Semantic Analysis

**Step 5.1 Functions modified:** `usbip_pad_iso()` only.

**Step 5.2 Callers:** `grep` shows exactly one caller:
`vhci_recv_ret_submit()` in `drivers/usb/usbip/vhci_rx.c` line 92 — the
vhci (client) receive path. That function runs in the vhci_rx kthread
processing `USBIP_RET_SUBMIT` responses from the remote server over TCP.

**Step 5.3 Callees:** `memmove()`, `dev_err()` — minimal.

**Step 5.4 Reachability:** Path is `vhci_rx_loop → vhci_rx_pdu →
vhci_recv_ret_submit → usbip_recv_xbuff → usbip_recv_iso →
usbip_pad_iso`. Every byte fed into `iso_frame_desc[i].offset` /
`actual_length` comes directly from the TCP stream via
`usbip_pack_iso()` (ref: `usbip_common.c:619-632`). **Fully reachable
from a network peer — no local privilege required on the vhci side.**

**Step 5.5 Similar patterns:** Patches 1 and 2 of same series handle
related missing bounds checks; Nathan's commit (already in
pending-6.1/6.6/6.12/7.0) handles the `number_of_packets` OOB. No other
sibling drivers need this fix.

## Phase 6: Stable Tree Analysis

**Step 6.1 Buggy code in stable?** Verified by reading
`stable/linux-5.4.y`, `stable/linux-5.10.y`, `stable/linux-6.1.y`:
`usbip_pad_iso()` body is character-for-character identical to mainline
pre-fix. Bug exists in **every active LTS** (5.4.y, 5.10.y, 5.15.y,
6.1.y, 6.6.y, 6.12.y, 7.0.y).

**Step 6.2 Backport difficulty:** The surrounding context (comments,
loop) is unchanged for 15 years. Patch will apply with at most line-
offset fuzz. Zero rework expected.

**Step 6.3 Related fix already in stable?** Nathan's `2ab833a16a825` is
in pending-6.1/6.6/6.12/7.0 already, explicitly marked `Cc: stable`.
This Kelvin patch is the complement that closes the remaining
offset/length-derived OOB.

## Phase 7: Subsystem Context

**Step 7.1 Subsystem:** `drivers/usb/usbip` — networked USB
virtualization. PERIPHERAL in user-count, but *security-critical*
because untrusted network bytes reach kernel memory operations.

**Step 7.2 Activity:** USB/IP is actively maintained; recent commits in
2025-2026 include multiple hardening fixes for the same receive path
(Nathan Rebello's commit, Kelvin's series).

## Phase 8: Impact & Risk

**Step 8.1 Affected users:** Anyone running a USB/IP client (vhci-hcd)
and attaching to a remote `usbipd`. Linux distributions ship this
(`CONFIG_USBIP_CORE`, `CONFIG_USBIP_VHCI_HCD`); cloud test labs, VDI
setups, IoT dev boards, and Android-on-x86 all use it.

**Step 8.2 Trigger:** A malicious or compromised USB/IP server sends a
crafted `USBIP_RET_SUBMIT` response with a valid number_of_packets but
poisoned `iso_frame_desc[i].offset` (> transfer_buffer_length) or
manufactured `actual_length` values that wrap `actualoffset` negative.
**No authentication; no local privilege needed on the client.**

**Step 8.3 Severity:** CRITICAL — slab-level OOB **write** of attacker-
controlled size at attacker-controlled offset in kernel heap memory;
plus OOB **read** that leaks kernel heap content back to userspace. This
is the classic "exploit primitive" class of bug.

**Step 8.4 Risk/benefit:**
- Benefit: very high — kernel heap corruption from network is among the
  highest-severity bug classes.
- Risk: very low — adds only input validation with early `return;`; the
  only possible regression is that previously-broken malformed frames
  now fail silently instead of corrupting kernel memory, which is the
  desired behavior.

## Phase 9: Synthesis

**Evidence FOR backport:** Remote OOB read (info leak) + remote OOB
write (controlled heap write) with confirmed reproducer; 15-year-old bug
in every stable tree; minimal surgical diff; USB maintainer SOB; part of
a coordinated hardening series whose companion Nathan patch is already
marked for stable and accepted into pending branches; two independent
security researchers flagged the same class.

**Evidence AGAINST:** Commit message mentions "see patch 2/3 for the
root cause" suggesting a small dependency on patch 2/3 for one of two
attack vectors; however patch 3/3 contains its own `actualoffset < 0`
check so it mitigates that vector standalone, and the
`iso_frame_desc[i].offset` OOB write is fully independent. Best practice
would be to backport the full 3-patch series together, but the
standalone 3/3 is still clearly beneficial.

**Stable rules checklist:** (1) Obviously correct — YES, read of 10
lines; (2) Fixes real bug — YES, OOB read+write; (3) Important — YES,
remote-triggerable memory corruption; (4) Small — YES, 36 lines one
function; (5) No new features — YES, input validation only; (6) Applies
— YES, identical context in every stable tree.

**Exception category:** Security fix, not listed in "exceptions" but
strongly supported by stable rules.

## Verification
- [Phase 1] Parsed tags in candidate commit message: author SOB, Greg KH
  SOB, patch.msgid.link Link.
- [Phase 2] Read full diff; verified guard structure uses underflow-safe
  form `length > buf - off`.
- [Phase 3] `git blame -L 750,760` → loop introduced by `28276a28d8b3cd`
  in 2011 (v3.0).
- [Phase 3] `git show 28276a28d8b3cd` → original commit is `Cc: stable`
  and landed in every LTS.
- [Phase 3] `git log --grep` + `git log pending-{6.1,6.6,6.12,7.0}` →
  confirmed Nathan's `2ab833a16a825` / `d374421fc6889` is companion fix
  already on all stable pending branches.
- [Phase 3] `git branch --contains 74a2287209a85` → commit is on
  `origin/master` and `linux-next/master`, merged via `usb-7.1-rc1`.
- [Phase 4] `b4 am -o /tmp/usbip_v3
  20260325103640.8090-3-addcontent08@gmail.com` → retrieved thread,
  confirmed this is v2 3/3, applies cleanly.
- [Phase 4] Read `/tmp/usbip_patch.mbox` /
  `20260325103640.8090-3-addcontent08@gmail.com.mbx` → reviewer feedback
  by Greg KH, patch accepted.
- [Phase 4] WebSearch confirmed independent [SECURITY] report on spinics
  stable list by Sebastián Alba Vives on 2026-03-29.
- [Phase 5] `Grep "usbip_pad_iso"` → exactly one caller
  `vhci_recv_ret_submit` in `drivers/usb/usbip/vhci_rx.c:92`; confirmed
  the trigger path begins at TCP input.
- [Phase 5] Read `usbip_recv_iso()` + `usbip_pack_iso()` → verified
  `iso_frame_desc[i].offset/actual_length` are copied verbatim from the
  wire.
- [Phase 6] `git show stable/linux-5.4.y:... | sed -n '647,680p'`,
  `linux-5.10.y`, `linux-6.1.y` → confirmed identical pre-fix code in
  every LTS.
- [Phase 8] Failure mode: OOB read into userspace + OOB write of
  attacker-controlled bytes → CRITICAL, remote, unauthenticated.
- UNVERIFIED: Whether a public CVE number has been assigned to this
  specific OOB in `usbip_pad_iso()` (not required for decision).

The fix is small, clearly correct, reproduced by the author, addresses
remote kernel-heap OOB read/write in code that has been present in every
stable tree since 2011, was accepted by the USB maintainer, and is part
of a series whose companion fix was already nominated and accepted for
stable. This is exactly what stable trees exist to carry.

**YES**

 drivers/usb/usbip/usbip_common.c | 36 ++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index fd620e9600394..8ebaaeaf848e5 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -770,6 +770,42 @@ void usbip_pad_iso(struct usbip_device *ud, struct urb *urb)
 	 */
 	for (i = np-1; i > 0; i--) {
 		actualoffset -= urb->iso_frame_desc[i].actual_length;
+
+		/*
+		 * Validate source range: actualoffset can go negative
+		 * via crafted actual_length values from the wire.
+		 */
+		if (actualoffset < 0 ||
+		    (unsigned int)actualoffset >
+				(unsigned int)urb->transfer_buffer_length ||
+		    urb->iso_frame_desc[i].actual_length >
+				(unsigned int)urb->transfer_buffer_length -
+				(unsigned int)actualoffset) {
+			dev_err(&urb->dev->dev,
+				"pad_iso: bad src off=%d len=%u bufsz=%d\n",
+				actualoffset,
+				urb->iso_frame_desc[i].actual_length,
+				urb->transfer_buffer_length);
+			return;
+		}
+
+		/*
+		 * Validate destination range: iso_frame_desc[i].offset
+		 * is wire-supplied and must not exceed the buffer.
+		 */
+		if (urb->iso_frame_desc[i].offset >
+				(unsigned int)urb->transfer_buffer_length ||
+		    urb->iso_frame_desc[i].actual_length >
+				(unsigned int)urb->transfer_buffer_length -
+				urb->iso_frame_desc[i].offset) {
+			dev_err(&urb->dev->dev,
+				"pad_iso: bad dst off=%u len=%u bufsz=%d\n",
+				urb->iso_frame_desc[i].offset,
+				urb->iso_frame_desc[i].actual_length,
+				urb->transfer_buffer_length);
+			return;
+		}
+
 		memmove(urb->transfer_buffer + urb->iso_frame_desc[i].offset,
 			urb->transfer_buffer + actualoffset,
 			urb->iso_frame_desc[i].actual_length);
-- 
2.53.0

