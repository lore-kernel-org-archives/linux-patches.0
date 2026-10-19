Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AC864C41C;
	Mon, 19 Oct 2026 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418822; cv=none; b=UadLGS6/tth2nxUGCKdClShhMQYqPA4PosRooSricBRmtQM0KsgPoi3BrzamkB1sQH6th0HKA1ifhsSeY5P1ydWx1y5iKQzZDeb9KYes1OIu3yymFKK/ozf8uCMUVPQMB0cjnBNkcZtIobG1x1/VoHChq83dbwccg08Y1RM0QB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418822; c=relaxed/simple;
	bh=JePvHHriR9Uz5hahUwNPgpcuWpfGjqwZBG6fLHqZiHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLeTmDhr1KUBZGaVbMEZko3PZ8fdrmcox+Wv7Neyo1v7nUNqHg6YjgcuoudiCe4YqGiF2/bImKZo2XS2ZTdlXjMMicXljuckOWOMGujcE33qWfLuQdTpls/oVj+3bkcLHqT7bezDXA6EZbTHk5/sA/RFtBg2o4WZFR55CfyJJcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VcXRMFJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VcXRMFJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA011F000C6;
	Mon, 19 Oct 2026 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418816;
	bh=B5YYPIxfAI73hAgTN9wvGfVFwk19HyvqgMAuoF0zEaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcXRMFJJYAi+pAkOQzRnssxP31bKxp+nMUW5e/8U9vG1BPRPaPqZExoEgP6tbB1qQ
	 gIg1fSNfW7wtls9qVxkVcDInOIFsy9qezEFw79EArnO7JjprdxlsjD6NW2+NwyC3IS
	 IkgwI6DS91QMvKiysgYC03HadY54S61KSTFERvbeiV7wViv8iU5nFkz9F/qdCx9FGl
	 beDxUGk9KAd25cZ7nubfS2scUfJI8lBSxJAhYo4vwJAmLeOAQI4gJ3KJ2f+pbtYdj+
	 nMEqLLNCQ/LIkCefemydoVAwsrx7d6O4oTpC0KzBYIZQJGuxUAkukiN1Bdp9tJkWKd
	 fuEio8e/go5nA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: brcmfmac: validate msgbuf flowring IDs before use
Date: Mon, 19 Oct 2026 09:53:28 -0400
Message-ID: <20261019135441.1420968-517-sashal@kernel.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 32856f39fefdc75bd253cab999f996750628648e ]

Firmware messages carry flow_ring_id values which brcmfmac converts
to an internal flowid by subtracting
BRCMF_H2D_MSGRING_FLOWRING_IDSTART. The resulting value is used as
a bit index in txstatus_done_map and as an array index into
msgbuf->flowrings and the flowring state.

Validate the firmware supplied flow_ring_id before using it. This
prevents flow_ring_id values below BRCMF_H2D_MSGRING_FLOWRING_IDSTART
from underflowing and rejects values outside msgbuf->max_flowrings.

In the tx status path, complete the packet with an error after
removing a valid packet id so the skb is not leaked when the flow
ring id is invalid.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260723055618.550834-1-pengcan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a 5.15.221 tree (`pending-5.15`). The buggy firmware-ID indexing
is present here, and the patch is a small bounds check that prevents
out-of-bounds writes/crashes and an skb leak.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [subsystem: wifi: brcmfmac] [action verb: validate] [intent:
reject firmware-supplied msgbuf flowring IDs before they are used as
bitmap/array indexes]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record: Tags in the candidate message:
- Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com> (brcmfmac
  maintainer)
- Link:
  https://patch.msgid.link/20260723055618.550834-1-pengcan@kylinos.cn
- Signed-off-by: Can Peng <pengcan@kylinos.cn> (author)
- Signed-off-by: Johannes Berg <johannes.berg@intel.com> (wireless
  maintainer who applied it)

No Reported-by, Tested-by, Fixes, or Cc: stable in the candidate text
(absence expected). The original mailing-list submission (v1, same
msgid) did include `Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf
protocol.")` and `Cc: stable@vger.kernel.org`; those are author-
submitted tags, not pipeline markers.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: firmware `flow_ring_id` is converted with `id -
  BRCMF_H2D_MSGRING_FLOWRING_IDSTART` and then used as a bit index in
  `txstatus_done_map` and an array index into `msgbuf->flowrings` /
  flowring state, with no range check.
- Failure mode: IDs below `BRCMF_H2D_MSGRING_FLOWRING_IDSTART` (2)
  underflow a `u16`; IDs above `max_flowrings` index past allocated
  arrays. On the TX-status path, a valid pktid can already have been
  taken, so an early return would leak the skb.
- Version info in the body: none. Original Fixes target is from 2014.
- Root cause (author): missing validation of firmware-supplied ring IDs.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden fix. The subject/body describe a bounds check and
an skb-leak close on the invalid-ID TX-status path.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c`
  (single file)
- Scope: ~40 insertions / 6 deletions (mailing-list v1: 46 lines net in
  that file)
- Functions: adds `brcmf_msgbuf_get_flowid()`; changes
  `brcmf_msgbuf_process_txstatus()`,
  `brcmf_msgbuf_process_flow_ring_create_response()`,
  `brcmf_msgbuf_process_flow_ring_delete_response()`
- Classification: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Helper (new): convert firmware `flow_ring_id` to internal `flowid`
  only if `id >= BRCMF_H2D_MSGRING_FLOWRING_IDSTART` and `(id - START) <
  msgbuf->max_flowrings`. Uses `u32` so the subtract cannot wrap.
- TX status (normal/error path): previously always subtracted then
  `set_bit(flowid, txstatus_done_map)`, `msgbuf->flowrings[flowid]`,
  `atomic_dec`, `brcmf_txfinalize(..., true)`. After: if ID invalid,
  `brcmf_txfinalize(..., false)` and return (skb already taken from
  pktid table).
- Create/delete response: previously subtracted and used the index
  unconditionally (`brcmf_msgbuf_remove_flowring`,
  `brcmf_flowring_open`, `brcmf_flowring_delete`). After: invalid ID
  returns without touching rings.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: memory safety (out-of-bounds index / underflow) plus
  resource leak on the TX-status error path.
- Mechanism: firmware DMA completion messages supply
  `compl_hdr.flow_ring_id`. `BRCMF_H2D_MSGRING_FLOWRING_IDSTART` is 2.
  For ID 0 or 1, `u16 flowid -= 2` wraps to 65534/65535. `set_bit()`
  then writes far past `txstatus_done_map` (sized to `max_flowrings`
  bits). `msgbuf->flowrings[flowid]` is an OOB load and typically a
  crash. Oversized IDs do the same without wrapping. The helper rejects
  both. TX-status also finalizes the skb so `brcmf_msgbuf_get_pktid()`’s
  take is not leaked.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: range check matches how the host builds IDs
  (`flowid + BRCMF_H2D_MSGRING_FLOWRING_IDSTART` in create/delete
  requests). Happy path is unchanged.
- Minimal: one helper, three call sites, no API change.
- Regression risk: low. Invalid create/delete IDs now skip ring
  teardown; that is safer than OOB. A stuck ring on bogus firmware is
  preferable to memory corruption. `brcmf_txfinalize()` already handles
  a NULL `ifp` from a bad `ifidx` by freeing the skb.
- Red flags: none. Double blank line after the helper is style-only (v2
  tried to clean it; Johannes applied v1).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Unvalidated `flowid = le16_to_cpu(...flow_ring_id)` dates to
  9a1bb60250d2 (Hante Meuleman, 2014-07-30), “brcmfmac: Adding msgbuf
  protocol.”
- The subtract of `BRCMF_H2D_MSGRING_FLOWRING_IDSTART` was added in
  be4b092cab84b (Franky Lin, 2016-11-23), “brcmfmac: add pcie host
  dongle interface rev6 support” (replaced
  `BRCMF_NROF_H2D_COMMON_MSGRINGS`, also 2).
- Code has been in-tree for many years, including this 5.15 branch.

Step 3.2: FOLLOW THE FIXES: TAG
Record:
- Original mailing-list Fixes: 9a1bb60250d2. `git merge-base --is-
  ancestor 9a1bb60250d2 HEAD` succeeds.
- Slightly imprecise: large-ID OOB is from 2014; underflow of IDs 0/1 is
  from the 2016 subtract. Both commits are in this tree.
- No later in-tree fix of the same hole (`brcmf_msgbuf_get_flowid` is
  absent; `git log --grep="invalid flowring"` / `--grep="flow_ring_id"`
  on this path found nothing equivalent).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `msgbuf.c` commits here are unrelated (pktid DMA unmap,
allocation-mode plumbing, memleak in attach). Not part of a functional
series that must land first. v2 was whitespace-only prep + the same
validation; Johannes applied v1 and declined the cleanup.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: `git log --author="Can Peng"` on
`drivers/net/wireless/broadcom/brcm80211/` in this tree is empty
(outside contributor). Weight comes from Arend van Spriel’s Acked-by and
Johannes applying the patch.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No new helpers, structs, or APIs. Uses existing `bphy_err`,
`brcmf_txfinalize`, `brcmf_get_ifp`, `msgbuf->max_flowrings`.
Standalone. v2 patch 1/2 (blank-line cleanup) is not required.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 mbox` on msgid `20260723055618.550834-1-pengcan@kylinos.cn`
  retrieved the thread (lore WebFetch returned 403).
- v1: standalone `[PATCH wireless]` with Fixes + Cc: stable.
- Arend: one nit (double blank line), “To be applied to wireless tree,”
  Acked-by. No NAK.
- v2: 0/2 cover + whitespace cleanup + same validation rebase. Johannes:
  too late, he already applied v1; not rebasing for whitespace.
- Applied version matches the candidate (v1, double blank line kept). No
  later functional revision.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To: Arend van Spriel. Cc: linux-wireless, brcm80211 lists,
linux-kernel, stable@vger.kernel.org. Ack from the brcm80211 maintainer;
applied by Johannes Berg.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot, bugzilla, or user crash in the message. Justification
is code analysis of firmware-supplied indexes. Trigger is a bad
`flow_ring_id` on D2H completion rings (firmware bug, DMA corruption, or
hostile firmware), not a documented userspace repro.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: v2 series is cleanup + this fix. Functional patch is self-
contained. No other msgbuf ID-validation patches in the thread.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: Author Cc’d stable@vger.kernel.org on v1/v2. No separate stable-
list rejection found. lore.kernel.org HTTP from WebFetch was 403;
evidence is the b4-retrieved mbox.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `brcmf_msgbuf_get_flowid` (new);
`brcmf_msgbuf_process_txstatus`;
`brcmf_msgbuf_process_flow_ring_create_response`;
`brcmf_msgbuf_process_flow_ring_delete_response`.

Step 5.2: TRACE CALLERS
Record:
- All three process_* functions are called only from
  `brcmf_msgbuf_process_msgtype()` (`MSGBUF_TYPE_TX_STATUS`,
  `MSGBUF_TYPE_FLOW_RING_CREATE_CMPLT`,
  `MSGBUF_TYPE_FLOW_RING_DELETE_CMPLT`).
- That is called from `brcmf_msgbuf_process_rx()` while draining D2H
  rings.
- `brcmf_proto_msgbuf_rx_trigger()` calls process_rx for RX/TX/control
  complete rings.
- Call site: `brcmf_pcie_isr_thread()` in `pcie.c` on
  `BRCMF_PCIE_MB_INT_D2H_DB` (IRQ thread). Hot path for PCIe FullMAC
  traffic.

Step 5.3: TRACE CALLEES
Record: `brcmf_msgbuf_get_pktid` (takes skb out of the TX pktid table;
already bounds-checks pktid); `set_bit`; `msgbuf->flowrings[flowid]`;
`atomic_dec(&commonring->outstanding_tx)`; `brcmf_txfinalize`;
`brcmf_get_ifp`; `brcmf_msgbuf_remove_flowring` /
`brcmf_flowring_delete` / `brcmf_flowring_open` (those use `flowid` as
`flow->rings[flowid]` with no extra range check).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace TX → flowring → firmware; firmware posts TX-status /
create / delete completions into DMA rings; host IRQ processes them. Any
PCIe brcmfmac user hits this path. Not a syscall fuzz target by itself;
firmware-supplied fields in DMA completions are still a real input.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Other `flow_ring_id` uses: host-generated create/delete
requests, and ring-status which only logs the ID. No sibling driver copy
of this helper. `brcmf_flowring_delete`/`open` do not bounds-check
`flowid`; they assume the caller already has a valid index.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. This checkout is 5.15.221 (`p-5.15-2-g6703e5d2f3a29`).
Unvalidated subtract is in `msgbuf.c` at process_txstatus (~883–891),
create_response (~1239–1245), delete_response (~1268–1274). Introduced
2014/2016; present here. `brcmf_msgbuf_get_flowid` is not present.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Minor context conflict. 5.15 `brcmf_msgbuf_rxreorder` still has
a `bool inirq` argument (687006e20c445); the candidate hunk context uses
the later two-argument form. Insertion point after
`brcmf_msgbuf_remove_flowring` and the three process_* hunks match.
Expected: trivial context adjust, not a rework. `bphy_err`,
`max_flowrings`, `brcmf_txfinalize` all exist.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No equivalent validation. Unrelated msgbuf fixes (pktid unmap,
attach memleak) do not close this hole.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [brcmfmac msgbuf / PCIe FullMAC Wi-Fi] [IMPORTANT]. Not core
mm/vfs, but used on Raspberry Pi-class boards and many Broadcom PCIe
WLAN cards. `CONFIG_BRCMFMAC_PCIE` selects `BRCMFMAC_PROTO_MSGBUF`.
SDIO/USB FullMAC uses BCDC, not this path.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature. msgbuf protocol from 2014; this file is not under heavy
5.15 churn. Long-standing hole, not a brand-new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / config-specific: `CONFIG_BRCMFMAC_PCIE`
(msgbuf). Does not affect SDIO/USB brcmfmac. Population is still large
for an LTS kernel.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger is a firmware completion with `flow_ring_id` < 2 or `>=
max_flowrings + 2`. Normal firmware should echo host IDs, so the common
path is fine. Realistic triggers: buggy/mismatched firmware, DMA
corruption, compromised firmware. Unprivileged userspace cannot poke the
ID directly; it can generate TX completions by sending traffic.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- `set_bit(underflowed_id, txstatus_done_map)`: out-of-bounds write
  (memory corruption).
- `msgbuf->flowrings[flowid]` / `flow->rings[flowid]`: OOB / NULL deref
  → oops.
- TX-status without finalize: skb leak (the patch closes this).
- Severity: HIGH (crash / memory corruption on a common Wi-Fi driver).
  Not a documented privilege-escalation writeup, but OOB write from
  device DMA is security-relevant.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for PCIe brcmfmac — prevents OOB write/crash and a leak.
- Risk: low — ~40-line helper, no locking/API/data-structure change, no
  happy-path behavior change.
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real OOB index from firmware-supplied IDs (underflow and upper bound),
  present in this 5.15 tree since 2014/2016.
- TX-status path can leak an skb after `brcmf_msgbuf_get_pktid()` if the
  ring ID is bad.
- Small, obviously correct helper; happy path unchanged.
- Maintainer Acked-by; wireless maintainer applied v1.
- Applies with only a trivial rxreorder-context tweak.

AGAINST:
- No public crash/syzbot report; trigger depends on bad firmware IDs.
- Affects only PCIe msgbuf, not all brcmfmac buses.

UNRESOLVED:
- Could not HTTP-fetch lore.kernel.org (403); thread was recovered via
  `b4 mbox`.
- No mainline SHA in this checkout to `merge-base --is-ancestor` the fix
  itself (expected: it is not in 5.15 yet).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — range check matches host ID
   encoding; Acked by subsystem maintainer.
2. Fixes a real bug that affects users? PASS — unvalidated device-
   supplied index used as bit/array index; skb leak on that path.
3. Important issue? PASS — OOB write / crash / leak; HIGH.
4. Small and contained? PASS — one file, ~40 lines, three call sites.
5. No new features or APIs? PASS — internal helper only.
6. Can apply to the local tree? PASS — buggy code is here; minor context
   conflict only.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/build/docs exception. It is a
straightforward memory-safety fix.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 5.15 tree. The hole exists here, the
fix is surgical, and the downside of skipping it is memory corruption or
an oops if firmware supplies a bad flowring ID.

Verification:
- [Phase 1] Parsed candidate tags: Acked-by Arend van Spriel, Link
  msgid, SOBs Can Peng / Johannes Berg; no Fixes/Cc in candidate text.
- [Phase 1] `b4 mbox` v1 body: `Fixes: 9a1bb60250d2` and `Cc:
  stable@vger.kernel.org`.
- [Phase 2] Diff: helper `brcmf_msgbuf_get_flowid`; TX-status finalizes
  skb on invalid ID; create/delete return early.
- [Phase 2] Confirmed `BRCMF_H2D_MSGRING_FLOWRING_IDSTART` is 2 in
  `bus.h`; `flowid` is `u16` so subtract underflows.
- [Phase 2] `txstatus_done_map` allocated as
  `BITS_TO_LONGS(max_flowrings) * sizeof(unsigned long)` — overflowed
  bit index is OOB.
- [Phase 2] `brcmf_txfinalize()` NULL-`ifp` path frees the skb
  (`core.c`).
- [Phase 3] `git blame`: unvalidated use 9a1bb60250d2 (2014); subtract
  be4b092cab84b (2016).
- [Phase 3] `git merge-base --is-ancestor 9a1bb60250d2 HEAD`: yes.
- [Phase 3] No `brcmf_msgbuf_get_flowid` in this tree; no prior “invalid
  flowring” fix on this path.
- [Phase 4] `b4 mbox -c`: 7 messages; v1 applied; v2 whitespace declined
  by Johannes; Arend Acked-by, no NAK.
- [Phase 4] WebFetch lore/msgid.link: 403; used b4 instead.
- [Phase 5] Call chain: `brcmf_pcie_isr_thread` →
  `brcmf_proto_msgbuf_rx_trigger` → `brcmf_msgbuf_process_rx` →
  `process_msgtype` → the three functions.
- [Phase 5] Host encodes IDs as `flowid +
  BRCMF_H2D_MSGRING_FLOWRING_IDSTART` at msgbuf.c create/delete request
  sites.
- [Phase 6] `git describe HEAD`: p-5.15-2-g6703e5d2f3a29; `make
  kernelversion`: 5.15.221.
- [Phase 6] Local `process_txstatus` still does unvalidated `flowid -=
  BRCMF_H2D_MSGRING_FLOWRING_IDSTART`.
- [Phase 6] Nearby `brcmf_msgbuf_rxreorder(..., bool inirq)` differs
  from candidate context → minor apply tweak.
- [Phase 7] `Kconfig`: `BRCMFMAC_PCIE` selects `BRCMFMAC_PROTO_MSGBUF`.
- [Phase 8] Failure mode: OOB `set_bit` / OOB `flowrings[]` dereference;
  severity HIGH.
- UNVERIFIED: live firmware that currently emits IDs < 2 (no user report
  in the thread).

**YES**

 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 46 ++++++++++++++++---
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index de47d6b7e02b2..f850e64108c41 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -561,6 +561,28 @@ brcmf_msgbuf_remove_flowring(struct brcmf_msgbuf *msgbuf, u16 flowid)
 	brcmf_flowring_delete(msgbuf->flow, flowid);
 }
 
+static bool brcmf_msgbuf_get_flowid(struct brcmf_msgbuf *msgbuf,
+				    u16 flow_ring_id, u16 *flowid)
+{
+	u32 id = flow_ring_id;
+
+	if (id < BRCMF_H2D_MSGRING_FLOWRING_IDSTART) {
+		bphy_err(msgbuf->drvr, "invalid flowring id %u\n",
+			 flow_ring_id);
+		return false;
+	}
+
+	id -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	if (id >= msgbuf->max_flowrings) {
+		bphy_err(msgbuf->drvr, "invalid flowring id %u\n",
+			 flow_ring_id);
+		return false;
+	}
+
+	*flowid = id;
+	return true;
+}
+
 
 static struct brcmf_msgbuf_work_item *
 brcmf_msgbuf_dequeue_work(struct brcmf_msgbuf *msgbuf)
@@ -881,17 +903,23 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 	struct msgbuf_tx_status *tx_status;
 	u32 idx;
 	struct sk_buff *skb;
+	u16 flow_ring_id;
 	u16 flowid;
 
 	tx_status = (struct msgbuf_tx_status *)buf;
 	idx = le32_to_cpu(tx_status->msg.request_id) - 1;
-	flowid = le16_to_cpu(tx_status->compl_hdr.flow_ring_id);
-	flowid -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	flow_ring_id = le16_to_cpu(tx_status->compl_hdr.flow_ring_id);
 	skb = brcmf_msgbuf_get_pktid(msgbuf->drvr->bus_if->dev,
 				     msgbuf->tx_pktids, idx);
 	if (!skb)
 		return;
 
+	if (!brcmf_msgbuf_get_flowid(msgbuf, flow_ring_id, &flowid)) {
+		brcmf_txfinalize(brcmf_get_ifp(msgbuf->drvr, tx_status->msg.ifidx),
+				 skb, false);
+		return;
+	}
+
 	set_bit(flowid, msgbuf->txstatus_done_map);
 	commonring = msgbuf->flowrings[flowid];
 	atomic_dec(&commonring->outstanding_tx);
@@ -1238,13 +1266,16 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 	struct msgbuf_flowring_create_resp *flowring_create_resp;
 	u16 status;
 	u16 flowid;
+	u16 flow_ring_id;
 
 	flowring_create_resp = (struct msgbuf_flowring_create_resp *)buf;
 
-	flowid = le16_to_cpu(flowring_create_resp->compl_hdr.flow_ring_id);
-	flowid -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	flow_ring_id = le16_to_cpu(flowring_create_resp->compl_hdr.flow_ring_id);
 	status =  le16_to_cpu(flowring_create_resp->compl_hdr.status);
 
+	if (!brcmf_msgbuf_get_flowid(msgbuf, flow_ring_id, &flowid))
+		return;
+
 	if (status) {
 		bphy_err(drvr, "Flowring creation failed, code %d\n", status);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
@@ -1267,13 +1298,16 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 	struct msgbuf_flowring_delete_resp *flowring_delete_resp;
 	u16 status;
 	u16 flowid;
+	u16 flow_ring_id;
 
 	flowring_delete_resp = (struct msgbuf_flowring_delete_resp *)buf;
 
-	flowid = le16_to_cpu(flowring_delete_resp->compl_hdr.flow_ring_id);
-	flowid -= BRCMF_H2D_MSGRING_FLOWRING_IDSTART;
+	flow_ring_id = le16_to_cpu(flowring_delete_resp->compl_hdr.flow_ring_id);
 	status =  le16_to_cpu(flowring_delete_resp->compl_hdr.status);
 
+	if (!brcmf_msgbuf_get_flowid(msgbuf, flow_ring_id, &flowid))
+		return;
+
 	if (status) {
 		bphy_err(drvr, "Flowring deletion failed, code %d\n", status);
 		brcmf_flowring_delete(msgbuf->flow, flowid);
-- 
2.53.0

