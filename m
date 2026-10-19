Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CB65ABF57;
	Mon, 19 Oct 2026 14:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418410; cv=none; b=XbLa0htQ1qjEr5yDBvSRKfr4drLYiukV70naRiXCvaYfVmEnWqE7kfky2LhkvOlaZJD0SyBos+FbTxcDBI2xfT+5T5dWFpz9Z5WHGl0uCAtor9y91xdt9qXWQ4Mpr7TV9eLFKoCWZkLMMLpSWVXpvZ+03YqZS3yD+CYw5809Yzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418410; c=relaxed/simple;
	bh=w8MMvD8nuyV7HTbVsYofizP6+RG0NXnACTlYELIEzuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbmpBYbJw2KkKdQg6OIci4v+yC4m5pWmq9BmMc7Ua4a3UoFN1eG9AbWSoNoAGXhEtrkkrKKS7mj84dVmeLFt2esaiF6l+9dPh8SFynrkaGxoiKUGPXVUBpSrVMwIco8Af01NI8UfvKrARj4OmA4zPZ39fuAomNEVnAMH4WSI6vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqnE55RI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqnE55RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FA41F000C4;
	Mon, 19 Oct 2026 14:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418406;
	bh=DpCdTVynjeHLjjg28liknfkVKuaYWI+hiXDXG9A63B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqnE55RIKM/GOvhy+uIS7crS/bUcFdCzW9HsUm6tABlGmJGKk+Y3l6qSgDvdH9tZt
	 vahjSzAO38nql9YLd2RIo5ZadRpp5D1zTiPq6g14Cskz8srd4pY/2yycN9BLF6FLEd
	 B2NKVefs77BWnCYI3TU2rsoO6d8Ph+vs3fpg89tAV8XXWVUK/7xw/zHgh9oS2hyata
	 59vzs07zMUYfOOYs2AnunczAgcBiQpMjDS8reRibu6maELWigdCE1/GUfyS1kSByYT
	 Jt5a9lrn2DHdTP2UxzyuTyjMgywFevDLUycIg3UB62dm7TpQiTzNLgXAdZ0kP/Y6z9
	 XmA2q7VIH2ApA==
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
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211
Date: Mon, 19 Oct 2026 09:48:38 -0400
Message-ID: <20261019135441.1420968-227-sashal@kernel.org>
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

[ Upstream commit 0bbd6c52dfff62b319963f54cd9370f9486e59d2 ]

The PS queue filed redirected frames under the TID taken from the TXD,
while mac80211 was told about the TID taken from the QoS header, or TID 0
for anything that is not a QoS data frame. When the two disagree,
mt7603_release_buffered_frames() skips the frame because it does not
match the requested TIDs, so it stays in the PS queue until the station
wakes up. Buffered MMPDUs hit this whenever they were sent on a
non-zero TID.

Use one TID for both.

Link: https://patch.msgid.link/20260801145334.1166751-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This tree is **6.12.111** (`p-6.12-2`). The mt7603 PS-queue TID mismatch
is present here, the two-line fix applies cleanly, and it is a real AP-
mode buffering bug.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[wifi: mt76: mt7603]** **[file]** buffered frames under the
TID reported to mac80211. “File” here means enqueue/classify; the body
is a correctness fix so mac80211 and the driver PS queue use the same
TID.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Link:**
  `https://patch.msgid.link/20260801145334.1166751-8-nbd@nbd.name`
  (patch 08/10)
- **Signed-off-by:** Felix Fietkau (mt76 maintainer; ignore any Sasha
  Levin SOB)
- **No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable** (absence expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Redirected PS frames are queued under the TXD TID, while
  `ieee80211_sta_set_buffered()` is told the QoS-header TID, or TID 0
  for non-QoS data / MMPDUs.
- **Symptom:** `mt7603_release_buffered_frames()` skips the skb (`tids &
  BIT(skb->priority)` fails). The frame sits in `msta->psq` until the
  station fully wakes (`mt7603_sta_ps()` splices the whole queue).
  Buffered MMPDUs hit this whenever the TXD TID is non-zero.
- **Root cause:** Two different TID sources for the same frame.
- **Fix:** Use the same `tid` for both `skb->priority` and
  `ieee80211_sta_set_buffered()`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit protocol/correctness
fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/net/wireless/mediatek/mt76/mt7603/dma.c` (+1 / −1)
- **Function:** `mt7603_rx_loopback_skb()`
- **Scope:** single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `skb->priority = FIELD_GET(MT_TXD1_TID, val)` (3-bit TXD
  field), then later `ieee80211_sta_set_buffered(sta, tid, true)` with
  `tid` from the QoS header or 0.
- **After:** `skb->priority = tid` after that classification.
- **Path:** hardware PS redirect → MCU RX loopback → driver PS queue.
  Not an init-only path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness.** Enqueue key (`skb->priority`) and
mac80211 TIM/TID bitmap disagree, so `release_buffered_frames` never
dequeues those skbs during PS-Poll/U-APSD.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. `tid` is already 0–7
(`IEEE80211_QOS_CTL_TAG1D_MASK` or 0). No new locks, APIs, or data
structures. Regression risk is very low: release matching becomes
consistent with what mac80211 was already told.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `skb->priority = FIELD_GET(MT_TXD1_TID, val)` comes from the original
  driver (`c8846e1015022`, 2018).
- Split vs mac80211 TID: `e004b700660025` (2019,
  `ieee80211_sta_set_buffered`) and `d55aa5e17461b8` (2019, QoS-only
  TID, default 0).
- Current if/else (QoS / data / bufferable MMPDU) is `b473c0e47f04d`
  (2024, “fix tx queue of loopback packets”), **already in this 6.12
  tree**.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Buggy split has been in the driver since 2019;
MMPDU TID-0 reporting since `d55aa5e17461b8` / `b473c0e47f04d`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `dma.c` history includes `b473c0e47f04d` and
`9b8d932053b8b`. This commit is **not** in HEAD (`git merge-base --is-
ancestor 0bbd6c52dfff62b319963f54cd9370f9486e59d2 HEAD` → not ancestor).
Standalone vs later 2026 PS series (see 3.5).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Felix Fietkau is the mt76 maintainer. Nearby author work on this
driver is unrelated (chainmask, EEPROM, WPDMA EOF). Same 10-patch series
contains other mt7603 PS fixes he wrote.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Upstream SHA `0bbd6c52dfff62b319963f54cd9370f9486e59d2`. Series
08/10. Needed context `b473c0e47f04d` **is** in this tree. Later series
patches are **not** in this tree and are **not** required for this two-
line change:
- `697badc27a9b3` U-APSD EOSP
- `d5001f493fefd` clear buffered-TID when psq empty
- `636a883e2feef` re-arm HW PS after service period
Those fix other PS bugs; this patch only aligns enqueue TID with
`ieee80211_sta_set_buffered()`. It can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 0bbd6c52dfff6` →
  https://patch.msgid.link/20260801145334.1166751-8-nbd@nbd.name
- Single series revision (v1 only; `-a` showed only this series)
- Thread: 11 messages = 10 patches + kernel test robot on **patch 10
  only** (mt7996 OOB, unrelated)
- No NAK, no reviewer risk comments, no Cc: stable on this patch

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: `b4 dig -w`: To `linux-wireless@vger.kernel.org`, From Felix
Fietkau. No extra Reviewed-by. Author is the subsystem maintainer and
applied it himself.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by / bugzilla / syzbot. Failure mode is code-
derived. Related series patch 07 mentions U-APSD retry storms/packet
loss; that is a **different** bug.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: `[PATCH 01/10]` adds `MT_DRV_HW_PS_BUFFERING` for firmware-TIM
chips (mt7915/mt7996), not mt7603 loopback. mt7603 patches 05–07 are
sibling PS fixes, not semantic prerequisites of 08.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No useful stable-list hit for this subject (lore.kernel.org
fetch 403; web search returned unrelated archives). UNVERIFIED that
anyone already requested/rejected it for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `mt7603_rx_loopback_skb()` only.

**Step 5.2: TRACE CALLERS**
Record:
- Called only from `mt7603_queue_rx_skb()` when `q == MT_RXQ_MCU` and
  the packet is not `PKT_TYPE_RX_EVENT` (HW-redirected TX).
- `mt7603_queue_rx_skb` is `.rx_skb` in
  `drivers/net/wireless/mediatek/mt76/mt7603/init.c`.
- Release path: mac80211 `drv_release_buffered_frames` →
  `mt7603_release_buffered_frames()` which filters on
  `BIT(skb->priority)` (verified at `main.c:458`).

**Step 5.3: TRACE CALLEES**
Record: `ieee80211_is_data_qos` / `ieee80211_is_data` /
`ieee80211_is_bufferable_mmpdu(skb)` (present in this tree’s
`ieee80211.h`), `ieee80211_sta_set_buffered`, `skb_queue` under
`ps_lock`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable in AP mode when a station is in PS and the PSE
redirects TX. Userspace/network traffic plus sleeping clients trigger
it. Not a syscall crash path; it is a common AP operation on this
hardware.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other mt76 chips use `mt76_release_buffered_frames()`; mt7603
has its own `psq`. No duplicate of this exact TXD-vs-QoS TID split
elsewhere in this driver.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `dma.c` still has:

```42:75:drivers/net/wireless/mediatek/mt76/mt7603/dma.c
        skb->priority = FIELD_GET(MT_TXD1_TID, val);
        ...
        ieee80211_sta_set_buffered(sta, tid, true);
```

`MT_TXD1_TID` is `GENMASK(22, 20)`. `mt7603_release_buffered_frames()`
still skips on `!(tids & BIT(skb->priority))`. Bug introduced 2019;
still here in 6.12.111. Upstream commit is **not** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** `git apply --check` of `0bbd6c52dfff6`
succeeded. This tree still uses `rcu_dereference(dev->mt76.wcid[idx])`
rather than `mt76_wcid_ptr()`; that is unused context, not a conflict.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No equivalent TID alignment. `git log --grep='buffered frames
under the TID'` on this path is empty. Sibling 2026 PS series patches
are not in this tree.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **wifi / mt76 / mt7603** (`CONFIG_MT7603E`: MT7603E PCIe and
MT7628/MT7688 SoC WLAN). **IMPORTANT** (widely used AP/router silicon),
not core mm/net.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver, still receiving maintainer fixes. Not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific:** AP (and any PS-buffering) users of
MT7603/MT7628/MT7688. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Station in power-save; HW redirects frames into the driver PS
queue; mac80211 later releases by TID (PS-Poll / U-APSD). Common on APs
with phones/IoT clients. Unprivileged Wi-Fi clients can trigger it by
sleeping. MMPDUs with non-zero TXD TID are the documented always-hit
case.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Frames are not released during the service period. They wait
until the station leaves PS, or they can be dropped if `psq` hits 64.
That delays bufferable management (deauth/disassoc/action) and
mismatched-TID data. **Severity: HIGH** for AP connectivity; not a
kernel oops.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit: high** for this hardware (PS buffering actually works
for the TIDs mac80211 asked for). **Risk: very low** (2 lines, no
locking/API change, applies cleanly). Ratio strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, explained bug; mechanism confirmed in this tree’s `dma.c` and
  `main.c`
- User-visible AP PS failure (stuck/delayed frames, possible psq
  overflow drops)
- 2-line, obviously correct, maintainer-authored
- Applies cleanly to 6.12.111
- Prerequisite loopback-queue rewrite (`b473c0e47f04d`) already present
- Does not need the rest of the 10-patch series

AGAINST:
- Not a crash, UAF, or CVE
- No reporter / Tested-by / Fixes tag
- Other mt7603 PS bugs in the same series remain unfixed here (does not
  make this patch wrong)

UNRESOLVED:
- No stable-list discussion found (lore 403 / search noise)
- No independent user report for this exact TID mismatch

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — two-line alignment; in
   mainline from the maintainer
2. Real bug affecting users? **PASS** — PS-buffered frames not released
   until wake
3. Important issue? **PASS** — AP power-save correctness / delayed
   MMPDUs; HIGH not panic
4. Small and contained? **PASS** — 2 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean apply on 6.12.111

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID / quirk / DT / build / docs exception).
Qualifies as a normal contained bugfix.

**Step 9.4: MAKE YOUR DECISION**
Backport. This 6.12 tree has the exact buggy split, the fix is surgical,
and it restores mac80211-driven release of buffered frames (especially
MMPDUs) for a still-deployed wireless SoC.

------------------------------------------------
What the commit solves for stable users
------------------------------------------------
On MT7603/MT7628 APs, hardware-redirected PS frames are advertised to
mac80211 under one TID and stored under another. Service-period release
then skips them, so management and some data stay in the driver queue
until the client fully wakes (or the 64-entry queue drops them). Using
one TID for both makes `release_buffered_frames` find those skbs.

Risk vs benefit: two lines, no API/locking change, clean apply; benefit
is correct PS delivery on real AP hardware.

Concerns: sibling U-APSD/PS-rearm fixes are separate commits and not
required. No backport rewrite needed on this tree.

===============================================================
Verification
===============================================================
- [Phase 1] Tags: Link msgid `20260801145334.1166751-8-nbd@nbd.name`;
  SOB Felix Fietkau; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: move `skb->priority` from `MT_TXD1_TID` to classified
  `tid` in `mt7603_rx_loopback_skb` (+1/−1)
- [Phase 3] `git describe` / Makefile: **6.12.111**
  (`p-6.12-2-gd38d58a4e0359`)
- [Phase 3] Blame/history: TXD priority from `c8846e1015022`; mac80211
  TID from `e004b700660025` / `d55aa5e17461b8`; MMPDU/queue split
  `b473c0e47f04d` **is** ancestor of HEAD
- [Phase 3] `git merge-base --is-ancestor
  0bbd6c52dfff62b319963f54cd9370f9486e59d2 HEAD` → not present
- [Phase 3] Related series SHAs `697badc27a9b3`, `d5001f493fefd`,
  `636a883e2feef` → not in HEAD; not required
- [Phase 4] `b4 dig -c 0bbd6c52dfff6`: lore match, v1 only; `-w`: linux-
  wireless + author; robot reply only on patch 10
- [Phase 4] UNVERIFIED: stable@ discussion (lore 403)
- [Phase 5] Caller: `mt7603_queue_rx_skb` MCU loopback; release uses
  `BIT(skb->priority)` at `main.c:458`
- [Phase 6] Local `dma.c:42` still assigns priority from TXD; `git apply
  --check` of upstream diff **exit 0**
- [Phase 8] Failure mode: PS frames skipped until wake / possible psq
  drop; HIGH connectivity, not oops

**YES**

 drivers/net/wireless/mediatek/mt76/mt7603/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index e26cc78fff949..25009e49e7771 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -39,7 +39,6 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 
 	val = le32_to_cpu(txd[1]);
 	idx = FIELD_GET(MT_TXD1_WLAN_IDX, val);
-	skb->priority = FIELD_GET(MT_TXD1_TID, val);
 
 	if (idx >= MT7603_WTBL_STA - 1)
 		goto free;
@@ -72,6 +71,7 @@ mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
 		hwq = MT_TX_HW_QUEUE_MGMT;
 	}
 
+	skb->priority = tid;
 	ieee80211_sta_set_buffered(sta, tid, true);
 
 	val = le32_to_cpu(txd[0]);
-- 
2.53.0

