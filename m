Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFF2594815;
	Mon, 31 Aug 2026 13:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184276; cv=none; b=o/kJIBf7Q6hcEfG1khd9Ef0Q8z4FOmIRWtFqqInf6t3PkDmxGIb+sOppStTNq4w0UV+hxnZ2IMD5M2aeKNBzlUYIGqgR1+8+vbrnazYKJUARLAPcKQzLox594iYBSAdGpDwggNMbZ/zgl1OSoiBglzL0DdXNa9Re9s+QtF5+ET8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184276; c=relaxed/simple;
	bh=w9LjQbiQkf/ncT2iS1CBNHG/KaIN6aSRmIpMNqAKSkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bS4GUIHP78847iVszNUFkXsdETlNSx9Bj8BlfUaZNzA+C5hK5dPW/Gf1CK4BNo47POG0Ew6YzKd8RaA56lGUN61s9QWIDLUk5MDKMqWcoB/sDCAMR/o31qkFO43avouEiPZ7xrmcihDbhNapbQH2YYCTd7hh7WrXiVYobeTIDQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gCUEQGaP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gCUEQGaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1081F000E9;
	Mon, 31 Aug 2026 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184273;
	bh=pQeFEof46QBMBkVESYK5gF360fC+EaAR/W0HEtI6wnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCUEQGaPSoy4c/8IYXo92US6uA53BUs1iZVrpKtizyOdMG1Cq8qqdDXzxt78eiNDl
	 OggYGODjhVDBcdZvxByyA/d2CcvMH1ExG68jxf7YUA3/i3KCKwjsxSW1HLRAGoay3w
	 49XeD/rZsmykirLp8BxfFFm7kNKGUhx0G6UrtoAlow/Y2VhjweUmyJkQaS8DNo7/B7
	 DnmJGx1N2NAC/rUZ7ot4+o5b8J5nuXq1ejbhpfrT2ZzvX6qG5AIys977un5Jl+aZc0
	 5McKO0eVLgIcI2LAQH8rSmzFnyhEJAefmGCGlzpHqiNCv86WcfMEQYxcUU3semqYWy
	 gooMtfVUL+zPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	stas.yakovlev@gmail.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: libipw: fix key index receive bound checks
Date: Mon, 31 Aug 2026 09:30:22 -0400
Message-ID: <20260831133314.4125787-594-sashal@kernel.org>
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

[ Upstream commit 74ed3669f26803b1761c1f55403062bea44c3466 ]

libipw_rx() reads skb->data[hdrlen + 3] to extract the WEP key index in
both the software-decrypt key selection path and the hardware-decrypted
IV/ICV strip path. In both places the existing guard only checks
skb->len >= hdrlen + 3, which proves bytes up to hdrlen + 2 but not the
byte at hdrlen + 3.

Require hdrlen + 4 bytes before reading that item in both paths. This is
a local source-boundary check only; it does not change the key index
semantics.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705083519.23567-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: libipw: fix key index receive bound
checks`

**Local tree:** `v6.18.44` (`6.18.44`, Makefile `VERSION=6 PATCHLEVEL=18
SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[wifi: libipw]` `[fix]` — correct off-by-one bounds check
when reading WEP key index byte from received skb data in `libipw_rx()`.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Link:**
  https://patch.msgid.link/20260705083519.23567-1-pengpeng@iscas.ac.cn
- **Signed-off-by:** Johannes Berg `<johannes.berg@intel.com>` (wireless
  maintainer, committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: no fuzzer or user bug report; maintainer SOB present

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** `libipw_rx()` reads `skb->data[hdrlen + 3]` after checking
  `skb->len >= hdrlen + 3`. That guard only guarantees bytes
  `0..hdrlen+2`; index `hdrlen+3` needs `skb->len >= hdrlen + 4`.
- **Symptom:** Out-of-bounds read past skb tail on truncated protected
  frames.
- **Affected paths:** (1) software-decrypt key selection, (2) hardware-
  decrypt IV/ICV strip path.
- **Root cause:** Classic off-by-one length check (confusing “number of
  bytes after hdrlen” with “index of last byte needed”).

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — explicitly a bounds-check fix. No hidden
semantics change; when the check fails, `keyidx` stays at its
initialized value `0`.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `drivers/net/wireless/intel/ipw2x00/libipw_rx.c` (+2/−2
  lines)
- **Functions:** `libipw_rx()` (two hunks)
- **Scope:** Single-file, surgical fix

### Step 2.2: CODE FLOW CHANGE
**Record:**
- **Hunk 1 (~line 417):** Before: read key index if `len >= hdrlen+3`.
  After: read only if `len >= hdrlen+4`. Affects software-decrypt path
  when `can_be_decrypted` is true.
- **Hunk 2 (~line 663):** Same change on hardware-decrypt IV/ICV strip
  path when `!can_be_decrypted && PROTECTED && host_strip_iv_icv`.
- **Unchanged behavior:** When the frame is long enough, key index
  extraction is identical.

### Step 2.3: BUG MECHANISM
**Record:** **Category:** Memory safety / out-of-bounds read.
**Mechanism:** With `skb->len == hdrlen + 3`, `skb->data[hdrlen + 3]`
reads one byte past allocated skb data — slab OOB read (info leak or
fault under KASAN).

### Step 2.4: FIX QUALITY
**Record:** Obviously correct; minimal; zero functional change for valid
frames. **Regression risk:** Very low — only skips the read on frames
that were already too short to contain the byte.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Blame points to `5d324e5159d9e` (merge, 2025-11-28). This
autosel tree has only **1 commit** touching `libipw_rx.c`; the buggy
`hdrlen + 3` pattern is long-standing legacy code, not a recent
regression.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: FILE HISTORY FOR RELATED CHANGES
**Record:** Recent ipw2x00 activity includes `f442e581a8893` (ipw2100
memory leak fix). No prior fix for this bounds issue. Standalone one-
patch submission.

### Step 3.4: AUTHOR'S OTHER COMMITS
**Record:** Pengpeng Hou has multiple similar validation/bounds fixes
(CAN, media, Bluetooth, hwmon). Johannes Berg is the wireless maintainer
who committed this.

### Step 3.5: DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Patch applies cleanly to current
`libipw_rx.c` (buggy `hdrlen + 3` still present at lines 417 and 663).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: ORIGINAL PATCH DISCUSSION
**Record:** `b4 am 20260705083519.23567-1-pengpeng@iscas.ac.cn` found
the thread. Mbox has a single patch message, no replies. No stable
nomination or NAK in thread. WebFetch of lore URL blocked by bot
protection; content obtained via b4 mbox.

### Step 4.2: REVIEWERS
**Record:** `b4 dig -w` did not yield additional recipient detail beyond
the patch itself. Johannes Berg SOB indicates maintainer acceptance.

### Step 4.3: BUG REPORT
**Record:** No external bug report, syzbot link, or stack trace.
Static/code-review discovery.

### Step 4.4: RELATED PATCHES/SERIES
**Record:** Standalone 1/1 patch, not part of a series.

### Step 4.5: STABLE MAILING LIST HISTORY
**Record:** Not searched separately; no stable discussion found in the
patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: KEY FUNCTIONS
**Record:** `libipw_rx()` — central RX handler for libipw stack.

### Step 5.2: CALLERS
**Record:** Called from:
- `ipw2200.c`: lines 7674, 7831, 8037, 10332
- `ipw2100.c`: lines 2479, 2566

All are RX paths (tasklet/ISR context) for every received 802.11 frame.

### Step 5.3: CALLEES
**Record:** Uses `libipw_get_hdrlen()`, decryption helpers, frame drop
paths. Bug is a direct skb indexed read before further validation.

### Step 5.4: CALL CHAIN / REACHABILITY
**Record:**
1. Wireless frame received by ipw2100/ipw2200 firmware → skb built with
   firmware-reported length
2. `libipw_rx()` validates `skb->len >= 10` and `skb->len >= hdrlen`
3. A protected frame with `skb->len == hdrlen + 3` passes those checks
4. OOB read at `skb->data[hdrlen + 3]`

`ipw2200.c` rejects `length < hdrlen` (line 8315) but not `length <
hdrlen + 4`. `ipw_handle_data_packet()` (line 7663) sets skb length from
hardware with no extra minimum beyond `libipw_rx()` checks.

**Userspace trigger:** Indirect — attacker in radio range can send
malformed 802.11 frames; no syscall needed.

### Step 5.5: SIMILAR PATTERNS
**Record:** Line 286 in `libipw_rx_frame_decrypt()` also reads
`skb->data[hdrlen + 3]` in a debug path after failed decrypt (not fixed
by this patch). The two fixed sites are the ones described in the commit
message.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST?
**Record:** **Yes.** `drivers/net/wireless/intel/ipw2x00/libipw_rx.c`
lines 417 and 663 still use `hdrlen + 3`. Driver and
`CONFIG_LIBIPW`/`CONFIG_IPW2100`/`CONFIG_IPW2200` exist in 6.18.44. Bug
predates this stable branch (legacy code).

### Step 6.2: BACKPORT COMPLICATIONS
**Record:** **Clean apply** — two identical `+3` → `+4` substitutions,
no context conflicts.

### Step 6.3: RELATED FIXES ALREADY PRESENT?
**Record:** **No.** `git log --grep="key index"` and `git log
--grep="hdrlen + 4"` return nothing for this file.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
**Record:** **Subsystem:** `drivers/net/wireless/intel/ipw2x00` (legacy
Intel PRO/Wireless 2100/2200). **Criticality:** PERIPHERAL — deprecated
libipw stack, very old hardware, small active user base.

### Step 7.2: SUBSYSTEM ACTIVITY
**Record:** Intel wireless tree is active (many iwlwifi fixes in
6.18.y). ipw2x00 itself sees occasional maintenance (e.g., memory leak
fix `f442e581a8893`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
**Record:** **Config-specific / driver-specific** — users with `IPW2100`
or `IPW2200` modules loaded and WEP/WPA decryption paths active.

### Step 8.2: TRIGGER CONDITIONS
**Record:** Protected frame with `skb->len == hdrlen + 3` (e.g.,
hdrlen=24, len=27). Requires malformed/truncated over-the-air frame or
firmware passing a short frame. **Likelihood:** Low in normal operation;
realistic for malicious RF traffic. **Unprivileged remote trigger:**
Yes, within wireless range.

### Step 8.3: FAILURE MODE SEVERITY
**Record:** **Out-of-bounds read** past skb buffer. Without KASAN:
possible slab info leak; possible fault at page boundary. With KASAN:
BUG report. **Severity: MEDIUM** (memory safety on network RX; limited
by obsolete hardware and narrow config).

### Step 8.4: RISK-BENEFIT
**Record:**
- **Benefit:** Closes a real OOB read on RX path; defense-in-depth for
  malformed frames; zero-risk 2-line fix.
- **Risk:** Negligible — only tightens an existing guard.
- **Ratio:** Moderate benefit (small user base) vs. very low risk →
  **favorable for backport**.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILED

**FOR backport:**
- Real, verifiable off-by-one OOB read
- Trivial, obviously correct 2-line fix
- RX path reachable from wireless input
- Applies cleanly to 6.18.44
- Maintainer (Johannes Berg) committed
- Matches stable pattern of bounds-check hardening

**AGAINST backport:**
- Legacy deprecated driver (libipw); hardware from ~2003–2005
- No user report, syzbot, or CVE
- Very small installed base today
- Trigger requires specific truncated protected frame

**Unresolved:** Whether firmware typically filters frames short enough
to hit this exact length before they reach `libipw_rx()`.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — mathematically correct
   bounds fix; no Tested-by.
2. Fixes a real bug? **PASS** — OOB read on `skb->data[hdrlen+3]`.
3. Important issue? **PASS (MEDIUM)** — memory safety on network RX,
   remotely triggerable in principle.
4. Small and contained? **PASS** — 2 lines, 1 file.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** — buggy code present, clean apply.

### Step 9.3: EXCEPTION CATEGORIES
**Record:** N/A — standard memory-safety bug fix, not a
quirk/DT/build/doc exception.

### Step 9.4: DECISION RATIONALE

For **6.18.44**, the buggy code is present and the fix is surgical. Even
with a small user population, an out-of-bounds read on a wireless RX
path is appropriate stable material: the patch is obviously correct,
cannot regress valid frames, and closes a reachable memory-safety hole.
The lack of syzbot/user reports lowers urgency but does not negate the
technical merit.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and mbox
- **[Phase 2]** Diff: 2 lines in `libipw_rx.c`, `hdrlen+3` → `hdrlen+4`
  at lines 417 and 663
- **[Phase 3]** `git describe HEAD` → `v6.18.44`; `make kernelversion` →
  `6.18.44`
- **[Phase 3]** `git blame -L 417,419` and `-L 663,664` → lines from
  `5d324e5159d9e`
- **[Phase 3]** `git rev-list --count HEAD -- libipw_rx.c` → 1 (shallow
  history for this file)
- **[Phase 3]** No `Fixes:` tag; no prerequisite commits found
- **[Phase 4]** `b4 am 20260705083519.23567-1-pengpeng@iscas.ac.cn` →
  single-patch thread
- **[Phase 4]** Mbox read: no replies, no stable nomination, no NAK
- **[Phase 4]** WebFetch of lore URL → blocked (bot protection); used b4
  mbox instead
- **[Phase 5]** `grep libipw_rx(` → callers in `ipw2200.c` (4) and
  `ipw2100.c` (2)
- **[Phase 5]** Read `libipw_rx()` lines 325–366: validates `len >= 10`
  and `len >= hdrlen` only
- **[Phase 5]** Read `ipw2200.c` 8315–8324: rejects `length < hdrlen`,
  not `length < hdrlen+4`
- **[Phase 5]** Read `ipw_handle_data_packet()` 7659–7674: skb length
  from firmware, no extra min check
- **[Phase 6]** Grep confirmed buggy `hdrlen + 3` at lines 417, 663; fix
  not present
- **[Phase 6]** Kconfig confirms `IPW2100`, `IPW2200`, `LIBIPW` exist;
  libipw marked deprecated
- **[Phase 8]** Failure mode: OOB read, severity MEDIUM
- **UNVERIFIED:** Exact frequency of firmware delivering frames with
  `len == hdrlen+3` to `libipw_rx()`

**YES**

 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index b7bc94f7abd8a..c8841f9b9ad91 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -414,7 +414,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 	    ieee->host_mc_decrypt : ieee->host_decrypt;
 
 	if (can_be_decrypted) {
-		if (skb->len >= hdrlen + 3) {
+		if (skb->len >= hdrlen + 4) {
 			/* Top two-bits of byte 3 are the key index */
 			keyidx = skb->data[hdrlen + 3] >> 6;
 		}
@@ -660,7 +660,7 @@ int libipw_rx(struct libipw_device *ieee, struct sk_buff *skb,
 		int trimlen = 0;
 
 		/* Top two-bits of byte 3 are the key index */
-		if (skb->len >= hdrlen + 3)
+		if (skb->len >= hdrlen + 4)
 			keyidx = skb->data[hdrlen + 3] >> 6;
 
 		/* To strip off any security data which appears before the
-- 
2.53.0

