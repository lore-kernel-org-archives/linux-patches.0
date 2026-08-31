Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DD147A87F;
	Mon, 31 Aug 2026 13:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183351; cv=none; b=kJ0mzN4V3GxYy0S8oFVfPxR3sqcjEk8IA4sdKDK8jCWBjNR3Zm2VaXUUrxjbQa4C/x/DjoyVTAtpluK9FksLSae8ZmI3paEFV0H3xpsU3cxY2erCtr53jSfTwB56FSsg/ip3xQ9WeZhq2Tk+5BH3HiyBv3dFNgTpFBgVIgUBo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183351; c=relaxed/simple;
	bh=SUrGa9hpVSxXWp6iGgLALxyqevl6hgtPM9V/wOpcCNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YWywiXCtGYEg4HixiE69zAKZnH5EGDGYdUDzU2VFrbLFF8XqSSVoevmeRZIhxxHIAu6exoIMG1gsAMJbIZdUGsG0Xf5CY0VksZxRg4sfN7s+fxEgyKPdNnq9PGpCtWnUg/eI2tN0lhLSzULZs4dF+zLQueC5KhkoXGGA/iCLYUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnpkGrOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnpkGrOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6671F00A3F;
	Mon, 31 Aug 2026 13:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183349;
	bh=/STGmrD+OrQuVINnyV8r9fWm+EQyQVnJ7YvdmWdM7mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnpkGrOs2B3kxK+Q9BYijd+6z2Yz5AZMxepcKSxCOQBeufQq4FBv2Tmo3zMJoHJrh
	 T/Dl9GuhQ/39JD1v2P5TfziDf8cksQI8x8KtPKPMOSp8PDxNXAVyjMlZZIMb9ctIQm
	 /YrK/k6HLlhfykQ8CLX4Z3+1KfXbU9Hx7BvWuQomIQ1eoEEoN9XhKCpKywvtaAd+Au
	 +TvEdHx6ePMR+v94E5EB8jAoBkJbr/vjYujbTl5+PJwZQc3A7zwB7ZvWA7tUyzDZeB
	 QA3c3dqNHyiNBoa2G/Wb3W03CgeGfrh9n4l+hjOqE/Lee4YcL3YqKqMnXo1GgLXcUl
	 /5NpfJoJ60kxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] Bluetooth: RFCOMM: validate skb length in rfcomm_recv_frame
Date: Mon, 31 Aug 2026 09:22:03 -0400
Message-ID: <20260831133314.4125787-95-sashal@kernel.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit b230e5bf501c5edaf2eb0991cb862ac142031d4b ]

rfcomm_recv_frame() casts skb->data to struct rfcomm_hdr and dereferences
hdr->addr and hdr->ctrl without validating skb->len first. A truncated
frame with skb->len less than the minimum header size causes an
out-of-bounds read of uninitialized memory. Additionally, a zero-length
frame causes skb->len-- to underflow to UINT_MAX, making
skb_tail_pointer() read far past the buffer.

Commit 23882b828c3c ("Bluetooth: RFCOMM: validate skb length in MCC
handlers") fixed the same class of missing-length-check bugs in the MCC
sub-handlers, but the top-level rfcomm_recv_frame() was left unfixed.
KMSAN reports:

  BUG: KMSAN: uninit-value in rfcomm_run
  ...
  Uninit was created at:
    __alloc_skb+0x474/0xb60
    vhci_write+0xe9/0x870

Fix this by rejecting frames smaller than sizeof(struct rfcomm_hdr) + 1
(the minimum frame must have a 3-byte header and a 1-byte FCS).

Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[Bluetooth: RFCOMM]` `[validate]` — Add skb length
validation in `rfcomm_recv_frame()` before parsing RFCOMM frame headers.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not present (KMSAN stack trace in body instead)
- **Tested-by:** — not present
- **Reviewed-by:** — not present
- **Acked-by:** — not present
- **Link:** — not present
- **Cc: stable@vger.kernel.org** — not present (expected)
- **Signed-off-by:** Jiale Yao `<yaojiale02@163.com>` (author)
- **Signed-off-by:** Luiz Augusto von Dentz `<luiz.von.dentz@intel.com>`
  (Bluetooth maintainer, committer)

Notable: KMSAN report in body; references prior related fix
`23882b828c3c` for MCC handlers.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `rfcomm_recv_frame()` casts `skb->data` to `struct
  rfcomm_hdr` and reads `hdr->addr`/`hdr->ctrl` without checking
  `skb->len`. Truncated frames cause out-of-bounds reads of
  uninitialized memory. Zero-length frames cause `skb->len--` to
  underflow to `UINT_MAX`, making `skb_tail_pointer()` read far past the
  buffer.
- **Symptom:** KMSAN `uninit-value` in `rfcomm_run`, stack through
  `vhci_write` → `__alloc_skb`.
- **Root cause:** Missing minimum-length check at the top-level frame
  parser; same class of bug fixed in MCC sub-handlers by `23882b828c3c`
  but `rfcomm_recv_frame()` was missed.
- **Fix:** Reject frames with `skb->len < sizeof(struct rfcomm_hdr) + 1`
  (3-byte header + 1-byte FCS minimum).

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit memory-safety bug fix
(OOB read + integer underflow), not cleanup or optimization.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `net/bluetooth/rfcomm/core.c` (+5 lines, 0 removed)
- **Functions modified:** `rfcomm_recv_frame()` only
- **Scope:** Single-file, surgical fix in one function

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (lines ~1792–1796):** Before: after the `!s` session check,
  code immediately dereferenced `hdr->addr` and `hdr->ctrl`. After:
  frames shorter than 4 bytes are dropped with `kfree_skb()` and the
  session is returned unchanged. Normal frames proceed as before.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Memory safety — out-of-bounds read + integer underflow
- **Mechanism:**
  1. `struct rfcomm_hdr` is 3 bytes (`addr`, `ctrl`, `len` in
     `include/net/bluetooth/rfcomm.h`)
  2. Without length check, `hdr->addr`/`hdr->ctrl` read past skb tail on
     truncated frames
  3. `skb->len--` on a zero-length skb wraps to `UINT_MAX`
  4. `*(u8 *)skb_tail_pointer(skb)` then reads arbitrarily far past the
     buffer

### Step 2.4: Fix Quality
**Record:** Obviously correct — mirrors the minimum-size logic described
in the commit message and the pattern established by the MCC handler fix
already in this tree. Minimal change on an error/drop path only. Very
low regression risk.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `rfcomm_recv_frame()` body dates to ancient RFCOMM code
(blame shows merge commit `5d324e5159d9e` as last touch, but the
function predates that). The MCC fix (`3eabc6d47a0ad`, upstream
`23882b828c3c`) explicitly notes `Fixes: 1da177e4c3f4
("Linux-2.6.12-rc2")` for the same class of missing validation — this
top-level path has had the bug since RFCOMM existed.

### Step 3.2: Fixes: Tag
**Record:** No `Fixes:` tag on this commit. Related fix `23882b828c3c`
("Bluetooth: RFCOMM: validate skb length in MCC handlers") is present in
this tree as `3eabc6d47a0ad` and left `rfcomm_recv_frame()` unfixed.

### Step 3.3: Related File History
**Record:** Recent `net/bluetooth/rfcomm/` commits in this tree:
- `780b04d09c941` — RFCOMM session UAF fix
- `3eabc6d47a0ad` — MCC skb length validation (prerequisite/context)
- `8802413ce6317` — listener socket hold fix

Standalone one-patch fix; not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Jiale Yao also authored Bluetooth L2CAP UAF fix
(`58e3c5289ad23`). Committer/maintainer Luiz Augusto von Dentz is the
Bluetooth subsystem maintainer.

### Step 3.5: Dependencies
**Record:** References `23882b828c3c` for context only — does not
require it to apply. The MCC fix is already an ancestor of HEAD in this
tree. `git show b230e5bf501c5 | git apply --check` succeeds cleanly on
current HEAD. Standalone backport.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c b230e5bf501c5` →
https://patch.msgid.link/20260722092616.1122797-1-yaojiale02@163.com.
Single v1 submission (no v2/v3). Patchwork bot and BlueZ test bot
replies only; no NAKs. No explicit stable nomination in thread.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` CC'd Marcel Holtmann, Luiz Augusto von Dentz,
Kees Cook, Jakub Kicinski, linux-bluetooth@vger.kernel.org, linux-
kernel@vger.kernel.org, and others. Committed by subsystem maintainer.

### Step 4.3: Bug Report
**Record:** KMSAN report embedded in commit message — `BUG: KMSAN:
uninit-value in rfcomm_run`, allocation via `vhci_write`. No separate
syzbot Link: tag, but KMSAN finding indicates a reproducible, reachable
bug.

### Step 4.4: Related Patches
**Record:** Companion to MCC handler validation (`23882b828c3c` /
`3eabc6d47a0ad`). That fix is already in this tree; this completes the
same validation gap at the top-level entry point.

### Step 4.5: Stable List History
**Record:** Not searched separately on lore stable@; the related MCC fix
was already backported to this tree (has upstream-commit marker and
stable maintainer SOB), establishing precedent for this class of RFCOMM
skb validation fixes.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rfcomm_recv_frame()` modified.

### Step 5.2: Callers
**Record:** `rfcomm_recv_frame()` is called only from
`rfcomm_process_rx()` (line 1993), which dequeues skbs from the session
socket receive queue.

### Step 5.3: Callees
**Record:** After parsing, calls `rfcomm_recv_sabm()`,
`rfcomm_recv_disc()`, `rfcomm_recv_ua()`, `rfcomm_recv_mcc()`,
`rfcomm_recv_data()`, etc. The bug occurs before any of those sub-
handlers run.

### Step 5.4: Call Chain / Reachability
**Record:**
```
rfcomm_run() → rfcomm_process_sessions() → rfcomm_process_rx() →
rfcomm_recv_frame()
```
`rfcomm_run()` is the `krfcommd` kernel thread (started at module init).
Data arrives via L2CAP PSM RFCOMM (`L2CAP_PSM_RFCOMM` at lines 808,
2116) from connected Bluetooth peers. **Reachable from a remote
Bluetooth device** sending malformed RFCOMM frames over an established
L2CAP connection. KMSAN reproducer used `vhci_write` (virtual HCI),
which exercises the same receive path.

### Step 5.5: Similar Patterns
**Record:** MCC handlers in the same file were fixed by `3eabc6d47a0ad`
using `skb_pull_data()` validation. This commit closes the same gap at
the parent `rfcomm_recv_frame()` entry point that all frame types pass
through first.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`). Current `rfcomm_recv_frame()` at lines
1798–1803 still dereferences `hdr` and decrements `skb->len` without any
length check. Commit `b230e5bf501c5` is **not** in this tree (`git
merge-base --is-ancestor` confirms).

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git show b230e5bf501c5 | git apply
--check` passes with no conflicts. No rework needed.

### Step 6.3: Related Fixes Already Present?
**Record:** MCC handler validation (`3eabc6d47a0ad`) is present. No
duplicate fix for `rfcomm_recv_frame()` (`git log -S "skb->len <
sizeof(*hdr)"` returns empty).

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `net/bluetooth/rfcomm/` — **IMPORTANT** subsystem. RFCOMM is
widely used for Bluetooth serial profiles (SPP, HFP, etc.). Security-
sensitive: processes untrusted input from remote Bluetooth devices.

### Step 7.2: Subsystem Activity
**Record:** Active — multiple recent security/memory-safety fixes in
RFCOMM and broader Bluetooth stack in this tree (UAF, skb validation,
listener socket lifetime).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_BT_RFCOMM` enabled and active Bluetooth
connections — laptops, phones, embedded devices using RFCOMM-based
profiles. Any system accepting inbound Bluetooth RFCOMM traffic.

### Step 8.2: Trigger Conditions
**Record:** Remote peer sends an RFCOMM frame with `skb->len < 4`
(including zero-length). Requires an established Bluetooth L2CAP/RFCOMM
session — not arbitrary internet exposure, but **a paired/connected or
connecting malicious Bluetooth device can trigger it**. KMSAN confirms
reachability.

### Step 8.3: Failure Mode Severity
**Record:**
- Truncated frames: **OOB read of uninitialized memory** (info leak
  potential, KMSAN-detected)
- Zero-length frames: **`skb->len` underflow to UINT_MAX** →
  `skb_tail_pointer()` reads far past buffer (**HIGH** — potential
  crash, further OOB access)
- **Severity: HIGH** (memory safety, remotely triggerable over
  Bluetooth)

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit: HIGH** — closes a remotely reachable memory-safety hole in
  a common Bluetooth code path; completes validation started by the
  already-backported MCC fix
- **Risk: VERY LOW** — 5 lines, drop-path only, no API/behavior change
  for valid frames
- **Ratio: Strongly favors backport**

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real memory-safety bug (OOB read + integer underflow)
- Remotely triggerable via Bluetooth RFCOMM from connected peer
- KMSAN-confirmed reproducible issue
- Small (5 lines), obviously correct fix
- Applies cleanly to this 6.18.44 tree
- Prerequisite MCC fix already present in tree
- Same bug class already deemed stable-worthy (MCC handler fix
  backported)
- Committed by Bluetooth maintainer

**AGAINST backport:**
- None significant

**Unresolved:**
- Lore thread had no explicit `Cc: stable` nomination (not a negative
  signal per instructions)
- WebFetch of lore URL blocked by bot protection (b4 mbox download
  succeeded instead)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   BlueZ test bot ran on submission
2. Fixes a real bug affecting users? **PASS** — KMSAN report, remote
   Bluetooth input path
3. Important issue? **PASS** — memory safety / potential crash / info
   leak, remotely triggerable
4. Small and contained? **PASS** — 5 lines, one function
5. No new features or APIs? **PASS** — validation guard only
6. Can apply to local tree? **PASS** — clean apply verified; buggy code
   confirmed present

### Step 9.3: Exception Categories
**Record:** Not a device-ID/quirk/DT/docs exception — standard
security/memory-safety bug fix.

### Step 9.4: Decision Rationale
This commit closes a gap left by the already-backported MCC skb
validation fix. The buggy code is present in the local **6.18.44** tree,
the patch applies cleanly, and the failure modes (OOB read of
uninitialized memory, `UINT_MAX` length underflow leading to massive
out-of-bounds access) are serious and reachable from a remote Bluetooth
peer. This is exactly the kind of small, surgical, security-relevant fix
stable trees need.

---

## Verification

- **[Phase 1]** Parsed commit `b230e5bf501c5`: subject, body, SOBs from
  Jiale Yao and Luiz von Dentz; KMSAN stack in body
- **[Phase 2]** Diff: +5 lines in `rfcomm_recv_frame()`, adds `skb->len
  < sizeof(*hdr) + 1` guard
- **[Phase 2]** `struct rfcomm_hdr` confirmed 3 bytes in
  `include/net/bluetooth/rfcomm.h` (lines 104–108)
- **[Phase 3]** `git blame -L 1786,1820`: function present since ancient
  RFCOMM code
- **[Phase 3]** `git show 23882b828c3c` / `3eabc6d47a0ad`: related MCC
  fix confirmed, `Fixes: 1da177e4c3f4`
- **[Phase 3]** `git merge-base --is-ancestor 3eabc6d47a0ad HEAD`: MCC
  fix IS in tree
- **[Phase 3]** `git merge-base --is-ancestor b230e5bf501c5 HEAD`: this
  fix NOT in tree
- **[Phase 3]** `git show b230e5bf501c5 | git apply --check`: clean
  apply
- **[Phase 4]** `b4 dig -c b230e5bf501c5`: lore URL found
- **[Phase 4]** `b4 dig -a`: single v1, no revisions
- **[Phase 4]** `b4 dig -w`: Marcel Holtmann, Luiz von Dentz, Kees Cook
  CC'd
- **[Phase 4]** `b4 dig -m /tmp/rfcomm_thread.mbx`: patchwork-bot +
  bluez test bot, no NAKs
- **[Phase 5]** `grep rfcomm_recv_frame`: single caller
  `rfcomm_process_rx()` at line 1993
- **[Phase 5]** Call chain: `rfcomm_run` → `rfcomm_process_sessions` →
  `rfcomm_process_rx` → `rfcomm_recv_frame`
- **[Phase 5]** L2CAP PSM RFCOMM at lines 808, 2116 confirms remote
  Bluetooth input path
- **[Phase 6]** `git describe HEAD`: v6.18.44-2-g1b9e1abadee04 / `make
  kernelversion`: 6.18.44
- **[Phase 6]** Read `core.c` lines 1786–1814: buggy code confirmed
  present, no length check
- **[Phase 6]** `git log -S "skb->len < sizeof(*hdr)"`: no existing fix
  in tree
- **[Phase 8]** Failure modes verified from code: OOB hdr dereference +
  `skb->len` underflow on zero-length frame

**YES**

 net/bluetooth/rfcomm/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index d2c869e8286b2..7e91e31877987 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -1795,6 +1795,11 @@ static struct rfcomm_session *rfcomm_recv_frame(struct rfcomm_session *s,
 		return s;
 	}
 
+	if (skb->len < sizeof(*hdr) + 1) {
+		kfree_skb(skb);
+		return s;
+	}
+
 	dlci = __get_dlci(hdr->addr);
 	type = __get_type(hdr->ctrl);
 
-- 
2.53.0

