Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DCF59C972;
	Mon, 19 Oct 2026 14:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418412; cv=none; b=m1HuITmjih+sE7/YvKFDPlpnh8DN81KCd/RJZyeDUZd02Tnf+k2cgOoY1CKHIC41eLhHD8BcobVqjvJ6RiJAYrxQA5WEi7N9VTY0gFU8j9iyh6XYR26Ob0NRDS+CYA8sRrRTN9OxP0TdNxczDvOfAUEC0QSVsTuiRiI+YuYPtNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418412; c=relaxed/simple;
	bh=gwhDFfaANps3UNfzDYozKCH+2w55PoBIK+sjCeHj9/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6jKjk7YP8VMlJ/RqnhLANDc6JMX8429Ptiu24sCl6Sfl6YoCuGZCZGNzHb627efu5R+Bc4H6xVA62yS/S/32uU6ctfRyC5pzw2KwxRCixn2dir6EYeaDNbCwyBp8TQkmxsyx6F9GvutbanZQ4kpR/d/OX5B1fmc0ln7+Bbn0bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CzoOb6xp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CzoOb6xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C711F000C6;
	Mon, 19 Oct 2026 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418409;
	bh=JgiHzBkzyS7FDTEmPwxdWyzH5N6tMzeSOTJia8FLgVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzoOb6xpW5RNnHTk4aMypOfuaer/+x//lw+hVHoDGCgLbvuSzRE+6dp2n1Qq7fVW8
	 TrP3dNmZzRhZ3b5GuVjtJcupTTFUPEvxSbUnECB55S5mvCQx2bkLqtxwBa53/+pjjn
	 JE6ISc9hMr8AEWu2UQ7c90C0uCyKotmSmcNSYP1YJ1mNSuCxCjf5zNPsi6EAWP0QiI
	 TdQLZxMw1hX3GOrV51tKi6YMd4GnaqFdlL5TlWq9k0UOifqsYgAl2yT0PCvmIyDIWR
	 gl1B+qZ77BQlJw90oP71r7Fi5hprBh9gGi6Z8NFU66gRf2t0ivbsde9zPUKCqBQEls
	 cCMcQwIs0qR+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mt76: mt7603: fix U-APSD service period termination
Date: Mon, 19 Oct 2026 09:48:40 -0400
Message-ID: <20261019135441.1420968-229-sashal@kernel.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 697badc27a9b3b2a8d86092abeed767714f735a2 ]

Frames released from the driver PS queue were all tagged with MORE_DATA
and none of them ever carried the EOSP bit, so from the client's point of
view a U-APSD service period was started but never finished. Clients that
keep their receiver on until EOSP arrives stop sending trigger frames,
and all downlink traffic for that station stalls until they give up.
ieee80211_sta_eosp() only cleared the service period state inside
mac80211, which is why the mismatch went unnoticed.

Assign MORE_DATA per frame and set the wire EOSP bit on the last one. If
the last released frame is a bufferable MMPDU it has no QoS control field
to carry EOSP, so let mac80211 append a QoS-Null frame instead.

Also stop handing the remaining frame budget to
mt76_release_buffered_frames() once frames have been released from the PS
queue: both would signal the end of the same service period. Releasing
fewer frames than requested is allowed, and MORE_DATA tells the client to
trigger again.

Link: https://patch.msgid.link/20260801145334.1166751-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **5.15.221** (`pending-5.15`). The buggy mt7603 U-APSD
path is present here and matches mainline before `697badc27a9b3`. This
is a real protocol fix for a stall, and it should be backported.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[wifi/mt76/mt7603] [fix] [U-APSD service period never ends on
the wire]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Link: https://patch.msgid.link/20260801145334.1166751-5-nbd@nbd.name`
  — patch **05/10** of Felix Fietkau’s series
- `Signed-off-by: Felix Fietkau <nbd@nbd.name>` (mt76 maintainer)
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Reviewed-by:`, no
  `Cc: stable` (absence of the last two is expected in this pipeline)
- Ignore any `Signed-off-by: Sasha Levin` / `[Upstream commit ...]` if
  present; they are candidate-prep markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Frames pulled from the driver PS queue all get `MORE_DATA`
  and never `EOSP`. A U-APSD SP starts and never ends on the air.
- **Symptom:** Clients that stay awake until EOSP stop sending trigger
  frames; **all downlink traffic for that STA stalls** until they give
  up.
- **Root cause:** `ieee80211_sta_eosp()` only clears mac80211’s
  `WLAN_STA_SP`. mac80211 documents that a driver implementing
  `.release_buffered_frames` must set the **wire** EOSP bit itself.
- **Second bug in the same function:** leftover `nframes` is handed to
  `mt76_release_buffered_frames()`, which ends the **same** SP a second
  time.
- **Fix:** assign `MORE_DATA`/`EOSP` per frame; QoS-Null via
  `ieee80211_send_eosp_nullfunc()` if the last frame is a bufferable
  MMPDU; do not forward leftover budget once PS-queue frames were
  released.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Subject and body describe a concrete protocol
failure with a user-visible stall.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/mediatek/mt76/mt7603/main.c` (**+63 /
  −11**)
- Functions: `mt7603_ps_skb_hdr()` (new), `mt7603_ps_set_more_data` →
  `mt7603_ps_set_flags`, `mt7603_release_buffered_frames`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** every released PS-queue frame unconditionally ORs
  `IEEE80211_FCTL_MOREDATA`; never sets/clears EOSP;
  `ieee80211_sta_eosp()` is called if the list is non-empty, then
  leftover `nframes` still go to `mt76_release_buffered_frames()`.
- **After:**
  1. Walk remaining PS queue under `ps_lock` and build a pending-TID
     bitmap.
  2. If nothing was dequeued, fall through to
     `mt76_release_buffered_frames()` (unchanged).
  3. If anything was dequeued, **do not** also release from mac80211
     TXQs.
  4. `MORE_DATA` = not-last **or** more frames remain (mac80211
     `more_data` or pending matching TIDs).
  5. Wire `EOSP` only on the last frame and only for
     `IEEE80211_FRAME_RELEASE_UAPSD`.
  6. Last frame not QoS data → `ieee80211_send_eosp_nullfunc()`; else
     `ieee80211_sta_eosp()`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** protocol / correctness (U-APSD SP termination), not
  UAF/leak/race.
- **Mechanism:** driver never put EOSP on the air; clients that wait for
  EOSP stop triggering; downlink stalls.
- Also: `MORE_DATA` was only set, never cleared. Recycled frames from
  `mt7603_filter_tx()` can keep a stale bit; the new helper assigns both
  bits.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Matches mac80211’s `.release_buffered_frames` contract
  (`include/net/mac80211.h`: driver must set EOSP in the QoS header;
  sending fewer frames than requested is allowed).
- `IEEE80211_QOS_CTL_EOSP` (0x0010) on the first QoS-control byte is the
  correct on-wire bit.
- `ieee80211_send_eosp_nullfunc()` uses `IEEE80211_TX_STATUS_EOSP` on
  the NDP; TX status then clears `WLAN_STA_SP`. iwlwifi already calls
  this from BH/TX context; `.release_buffered_frames` must be atomic,
  and `ieee80211_send_null_response()` uses `dev_alloc_skb` (GFP_ATOMIC)
  + `ieee80211_xmit`.
- Regression risk: **low–medium**. Logic is contained; PS-Poll does not
  set wire EOSP (`uapsd` is false). Companion series patches 06–08 make
  TIM / HW buffering / TID filing more complete but are not required for
  this EOSP fix to compile or to be correct on its own.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `mt7603_release_buffered_frames`: `c8846e101502` (2018-11, **mt76: add
  driver for MT7603E and MT7628/7688**)
- Unconditional MORE_DATA: `b126c8897435` (2019-03)
- `ieee80211_sta_eosp()` without wire EOSP: `b7001f46085e` (2019-03)
- All three are ancestors of this 5.15 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No `Fixes:` tag.** Buggy behavior dates to driver introduction
/ 2019 PS-queue helpers, all in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Mainline follow-ups on the same function (not in this tree):
- `d5001f493fef` — tell mac80211 when the PS queue is empty
  (`ieee80211_sta_set_buffered(..., false)`)
- `636a883e2feef` — restore hardware PS buffering after an SP
These are related U-APSD bugs, not prerequisites for this diff.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Felix Fietkau is the mt76 maintainer and original author of this
driver. This is a maintainer fix.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Patch **05/10**. Patches 01–03/09–10 target mt7915/mt7996 / MLO
/ new HW TIM — **not needed**. Patch 04 sets wire EOSP in generic
`mt76_release_buffered_frames()` (`tx.c`); mt7603 has its **own**
`.release_buffered_frames` and only calls the generic helper when the
driver PS queue is empty. This patch does not use new APIs or struct
fields. **Can apply standalone.**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 697badc27a9b3` →
  https://patch.msgid.link/20260801145334.1166751-5-nbd@nbd.name
- **v1 only** (no v2/v3)
- Thread is the 10-patch series plus a kernel-test-robot mail
- Robot error is on **patch 10 / patch 1** (`ieee80211_txq_aql_pending`
  missing) — **unrelated** to this patch
- No NAKs, no reviewer risk flags, no `Cc: stable` suggestion in the
  thread

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w`: To/Cc were **Felix Fietkau** and **linux-
wireless@**. No extra reviewer SOB. Maintainer self-applied into
wireless-next (listed in the 2026-08-06 wireless-next pull).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: OpenWrt mt76 users reported U-APSD stalls / **iPhone freezes**
on MT7603 APs (openwrt/mt76#1080 / PR #1084). Testers said an EOSP-
related change made iPhone freezes go away; remaining TX-retry/loss is
the separate HW-buffering bug (series patch 07).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series 01–10 as above. This commit is self-contained. Patch 06
should be considered as a follow-up candidate (TIM never cleared); it is
not required for this hunk.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No evidence this fix was discussed on stable@ or previously
rejected. UNVERIFIED that every stable archive was searchable
(lore.kernel.org returned 403 for some URLs); `b4`/openwall/syzbot CI
were used instead.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `mt7603_release_buffered_frames`, `mt7603_ps_set_flags`,
`mt7603_ps_skb_hdr`

**Step 5.2: TRACE CALLERS**
Record: Assigned as `ieee80211_ops.release_buffered_frames` in this
file. mac80211 calls it for **PS-Poll and U-APSD** from the RX/PS path
(atomic). Reachable whenever an AP-mode STA uses power save.

**Step 5.3: TRACE CALLEES**
Record: `mt7603_wtbl_set_ps`, `mt7603_ps_tx_list` /
`mt76_tx_queue_skb_raw`, `mt76_release_buffered_frames` (empty-PS-queue
only), `ieee80211_sta_eosp`, `ieee80211_send_eosp_nullfunc` — all exist
in this tree.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Client trigger (QoS-Null/PS-Poll) → mac80211 →
`mt7603_release_buffered_frames`. **Yes, userspace/STA traffic triggers
it.** Typical clients: phones with U-APSD.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Generic `mt76_queue_ps_skb()` in this tree still only sets
`IEEE80211_TX_STATUS_EOSP` + MORE_DATA, not wire EOSP (mainline patch
04). `mt7603_rx_loopback_skb()` sets `ieee80211_sta_set_buffered(...,
true)` and never clears it (mainline patch 06). Same U-APSD family,
different bugs.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `mt7603_ps_set_more_data` and
`mt7603_release_buffered_frames` in
`drivers/net/wireless/mediatek/mt76/mt7603/main.c` are **byte-for-byte
identical** to the parent of `697badc27a9b3`. Bug since ~2018/2019.

Local tree: `p-5.15-2-g6703e5d2f3a29`, **5.15.221**. `git merge-base
--is-ancestor 697badc27a9b3 HEAD` → **not in this tree**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Same function bodies; needed APIs
(`ieee80211_send_eosp_nullfunc`, `ieee80211_get_qos_ctl`,
`IEEE80211_QOS_CTL_EOSP`, `IEEE80211_FRAME_RELEASE_UAPSD`) are in 5.15.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No related U-APSD EOSP/TIM/HW-rearm fixes on this file in this
tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **wifi / mt76 / mt7603** (`CONFIG_MT7603E`). Criticality:
**IMPORTANT** for users of that hardware (MT7603E / MT7628/MT7688 APs —
very common home routers), not core mm/net.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (since 5.0-era). This is a long-standing bug, not
a regression in new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific:** AP (or GO) mode on MT7603/MT7628 with
U-APSD (or PS-Poll) clients.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: STA enters power save; hardware redirects frames into
`msta->psq`; STA sends a U-APSD trigger. Common for phones. Unprivileged
wireless clients can trigger it.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Downlink stall / client freeze** until the STA gives up
(disconnect/retry). Not a kernel oops. Severity: **HIGH** for affected
APs (connectivity loss), not CRITICAL kernel crash.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** high for MT7603 AP users — restores U-APSD SP completion
  so phones keep triggering.
- **Risk:** low–medium (contained ~50-line logic in one ops callback; no
  API/lock/core changes).
- **Ratio:** benefit outweighs risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, user-visible stall (U-APSD SP never ends on the air)
- Matches mac80211 driver contract
- Present in this 5.15 tree since driver introduction
- Functions identical to mainline parent → clean apply
- Small, one file, no new APIs
- Maintainer-authored, merged to mainline as `697badc27a9b3`
- Corroborated by OpenWrt MT7603/iPhone freeze reports

**AGAINST:**
- Not crash/UAF/security
- Series 05/10 (other patches are separate bugs/chips)
- Follow-ups 06–08 still missing here (incomplete *overall* U-APSD, but
  this patch is a complete EOSP fix)
- No extra reviewer tags

**UNRESOLVED:**
- Direct lore.kernel.org HTTP often 403; thread recovered via `b4`
- No explicit stable@ discussion found

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — protocol-correct; maintainer
   merged; consistent with mac80211 docs and iwlwifi’s
   `ieee80211_send_eosp_nullfunc` usage
2. Fixes a real bug that affects users? **PASS** — stall / client freeze
   on common AP chipsets
3. Important issue? **PASS** — serious connectivity failure for U-APSD
   STAs (not a panic, but production-breaking for those devices)
4. Small and contained? **PASS** — one file, +63/−11
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean; APIs present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. It is a **driver
protocol bugfix**.

**Step 9.4: DECISION**
Backport to this 5.15 tree. The bug exists here; the fix is self-
contained and applies cleanly. Companion commits `d5001f493fef` and
`636a883e2feef` are worth later evaluation but are not required for this
one.

---

### What the commit solves, and why it matters here

mt7603 implements its own `.release_buffered_frames` because hardware
redirects frames into a driver PS queue. That path tagged every frame
with `MORE_DATA` and never set EOSP on the air. mac80211 only saw
`ieee80211_sta_eosp()`, so the stack thought the SP ended while phones
waiting for EOSP stopped triggering. On 5.15 APs using `CONFIG_MT7603E`,
that is a real stall, not a cleanup.

### Stable rules / risk vs benefit

Surgical, obviously correct vs the documented U-APSD contract, no new
APIs, clean apply. Risk is limited to this driver’s PS release path.
Benefit is restoring downlink for power-save clients on a widely
deployed chipset.

### Concerns

Patches 06–08 (TIM clear, HW PS re-arm, TID filing) address **other**
remaining PS bugs. They are not compile or semantic prerequisites for
this hunk. Patch 04 is the analogous EOSP fix for chips that use generic
`mt76_release_buffered_frames`; mt7603 only hits that when its PS queue
is empty.

---

Verification:
- [Phase 1] Parsed subject/body/tags: Link is 05/10; author Felix
  Fietkau; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: +63/−11 in `mt7603_release_buffered_frames`;
  MORE_DATA+EOSP assignment; stop double SP end; QoS-Null for MMPDU
- [Phase 2] Confirmed `IEEE80211_QOS_CTL_EOSP` is 0x0010 and
  `ieee80211_get_qos_ctl()` returns `u8 *` to the first QoS byte
- [Phase 2] Confirmed `ieee80211_send_eosp_nullfunc()` in 5.15 sets
  `IEEE80211_TX_STATUS_EOSP` on the NDP; TX status clears `WLAN_STA_SP`
- [Phase 3] blame: `c8846e101502` / `b126c8897435` / `b7001f46085e`; all
  ancestors of HEAD
- [Phase 3] `git merge-base --is-ancestor 697badc27a9b3 HEAD` → not
  present
- [Phase 3] Follow-ups on origin/master: `d5001f493fef`, `636a883e2feef`
  only; no revert
- [Phase 4] `b4 dig -c 697badc27a9b3`: v1 series, msgid
  `20260801145334.1166751-5-nbd@nbd.name`
- [Phase 4] `b4 dig -w`: linux-wireless@ + author only
- [Phase 4] `b4 mbox`: 11 messages; robot fail is patch
  10/`ieee80211_txq_aql_pending`, unrelated
- [Phase 4] OpenWrt mt76#1084: EOSP-related change reported to stop
  iPhone freezes
- [Phase 5] ops hook `.release_buffered_frames =
  mt7603_release_buffered_frames`; callers are mac80211 PS-Poll/U-APSD
- [Phase 5] `ieee80211_send_eosp_nullfunc` exists and is exported in
  this tree; iwlwifi calls it from TX/BH
- [Phase 6] `make kernelversion` → 5.15.221; `git describe HEAD` →
  p-5.15-2-g6703e5d2f3a29
- [Phase 6] Byte-for-byte match of both functions vs `697badc27a9b3^`
- [Phase 7] `CONFIG_MT7603E` present for MT7603E/MT7628
- [Phase 8] Failure mode: downlink stall / client freeze, severity HIGH
  for that hardware
- UNVERIFIED: exhaustive stable@ archive search (lore HTTP 403); no
  evidence of a prior stable rejection

**YES**

 .../net/wireless/mediatek/mt76/mt7603/main.c  | 74 ++++++++++++++++---
 1 file changed, 63 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 0d7c84941cd0a..f8a43d9f72f95 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -423,13 +423,33 @@ mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	mt7603_ps_tx_list(dev, &list);
 }
 
+static struct ieee80211_hdr *
+mt7603_ps_skb_hdr(struct sk_buff *skb)
+{
+	return (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
+}
+
+/*
+ * Buffered frames can be recycled into the PS queue by mt7603_filter_tx(), so
+ * both bits have to be assigned, not just set.
+ */
 static void
-mt7603_ps_set_more_data(struct sk_buff *skb)
+mt7603_ps_set_flags(struct sk_buff *skb, bool more_data, bool eosp)
 {
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = mt7603_ps_skb_hdr(skb);
+
+	if (more_data)
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	else
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
 
-	hdr = (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
-	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	if (eosp)
+		*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_EOSP;
+	else
+		*ieee80211_get_qos_ctl(hdr) &= ~IEEE80211_QOS_CTL_EOSP;
 }
 
 static void
@@ -442,7 +462,10 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 	struct mt7603_dev *dev = hw->priv;
 	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
 	struct sk_buff_head list;
-	struct sk_buff *skb, *tmp;
+	struct sk_buff *skb, *tmp, *last;
+	bool eosp_null, uapsd;
+	u16 pending = 0;
+	u8 last_tid;
 
 	__skb_queue_head_init(&list);
 
@@ -458,20 +481,49 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 
 		skb_set_queue_mapping(skb, MT_TXQ_PSD);
 		__skb_unlink(skb, &msta->psq);
-		mt7603_ps_set_more_data(skb);
 		__skb_queue_tail(&list, skb);
 		nframes--;
 	}
+
+	skb_queue_walk(&msta->psq, skb)
+		pending |= BIT(skb->priority);
 	spin_unlock_bh(&dev->ps_lock);
 
-	if (!skb_queue_empty(&list))
-		ieee80211_sta_eosp(sta);
+	last = skb_peek_tail(&list);
+	if (!last) {
+		mt76_release_buffered_frames(hw, sta, tids, nframes, reason,
+					     more_data);
+		return;
+	}
+
+	/*
+	 * End the service period here instead of passing the remaining frame
+	 * budget on to mt76_release_buffered_frames(), which would signal the
+	 * end of the same service period a second time.
+	 */
+	uapsd = reason == IEEE80211_FRAME_RELEASE_UAPSD;
+	more_data |= !!(pending & tids);
+
+	skb_queue_walk(&list, skb)
+		mt7603_ps_set_flags(skb, skb != last || more_data,
+				    skb == last && uapsd);
+
+	/*
+	 * EOSP lives in the QoS control field, so a bufferable MMPDU cannot
+	 * terminate a U-APSD service period on its own. In that case mac80211
+	 * has to append a QoS-Null frame, which ends the SP through its tx
+	 * status.
+	 */
+	eosp_null = uapsd &&
+		    !ieee80211_is_data_qos(mt7603_ps_skb_hdr(last)->frame_control);
+	last_tid = __fls(tids);
 
 	mt7603_ps_tx_list(dev, &list);
 
-	if (nframes)
-		mt76_release_buffered_frames(hw, sta, tids, nframes, reason,
-					     more_data);
+	if (eosp_null)
+		ieee80211_send_eosp_nullfunc(sta, last_tid);
+	else
+		ieee80211_sta_eosp(sta);
 }
 
 static int
-- 
2.53.0

