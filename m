Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD2054FE86;
	Mon, 19 Oct 2026 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418215; cv=none; b=T2OjsboUeRb5s9arEnoF0lgzz3xKzDAJUDh9NhFva5g8bKDWKNnABIfWgLKsiX/Slv7NKdbrXLUzISOxSzNX9UwwSVv/2aqfRuSkZpXwmr4TgUe0gzq6zIuRjZwyGoW5K4w+6BhK+o5nOZdkqNku5ZGcxgl4ktLODoD+qUC7KwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418215; c=relaxed/simple;
	bh=IQhLecDtcqdEaGgJc2/Op1sbmyXwy2oT2ijSxdk601E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qrED0uc+sWuQR3nx9kONo+IUy/S+wKf/pWLmtep7Jclp3Suf++HcxNBZTA8iIPUTEiaDnYxFI5Ypl4yv9x7xJ4w7PsoTxU9tkWiFIpK7Q378eBywSpFL9yOYDmoJgkfoyS89r41T7/wW9eISIJr2txeSBh9kbO28uxBn9e6/RQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsqA7Qo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsqA7Qo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80E01F000C8;
	Mon, 19 Oct 2026 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418213;
	bh=N45kJ+5sX/X+h0o4k5A4rBO8ZMU+fiVLgW1Kl2dteRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsqA7Qo3wClGpB2Pth3ldHvddvZ/eU4RHYg5lyWT8ug6iuPPz/7KLUr9GmaKOfwkV
	 VNPQliu4SNt0B4Sq62KQ4xoBpQP7bS1A0pHHGDRAY522em0Sg02D15t/bLlyNKhZia
	 L09Ta/HJdd3WnTszAW+/Wo7YGmjBzGALGarEVJNvILQskIdWQxO7qPgC9ECLi0/V8F
	 xctMQ/1xiff3U9EBhoyALW/mCs57ZTdSjosd4AK/xhqC45WTGww4Ak+T7f2oQYfpT6
	 WtLk2uc93EY6z3JS5Yx47Z6sXt9r8ZbspRPGgo08D5FEIyhFhhWtt/GlqYukhS+p0K
	 /UjxI4CjbUEuQ==
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
Subject: [PATCH AUTOSEL 6.18-5.15] wifi: mt76: set the EOSP bit in the QoS header of the last released frame
Date: Mon, 19 Oct 2026 09:46:23 -0400
Message-ID: <20261019135441.1420968-92-sashal@kernel.org>
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

[ Upstream commit 0b8d2524716099ea4743fa65bc364f94b3106a31 ]

When the driver implements .release_buffered_frames, mac80211 leaves the
U-APSD signalling entirely to the driver: "In this case it is also
responsible for setting the EOSP flag in the QoS header of the frames"
(include/net/mac80211.h). Only IEEE80211_TX_STATUS_EOSP was being set,
which merely ends the service period inside mac80211, so on air the
service period was never terminated. Clients that wait for EOSP before
going back to doze keep the SP open and stop triggering, which stalls all
downlink traffic for that station.

Set the wire EOSP bit on the last frame of a U-APSD service period.
EOSP has no meaning for a PS-Poll response, so pass the release reason
down and leave those frames alone.

Link: https://patch.msgid.link/20260801145334.1166751-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real U-APSD protocol bug in mt76 that already exists in this
5.15.221 tree. The fix is small, applies here, and is independent of the
rest of the series.

## Phase 1: Commit message forensics

**Step 1.1 — subject**
Record: `[wifi: mt76:]` `[set]` set the EOSP bit in the QoS header of
the last released frame. “Set” here is a protocol-correctness fix, not a
feature add.

**Step 1.2 — tags**
Record:
- `Link: https://patch.msgid.link/20260801145334.1166751-4-nbd@nbd.name`
  (linux-wireless, series 04/10)
- `Signed-off-by: Felix Fietkau <nbd@nbd.name>` (mt76 maintainer; Sasha
  Levin SOB ignored per instructions)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable` (absence is expected)

Mainline SHA (from `origin/master`, path-limited log):
`0b8d2524716099ea4743fa65bc364f94b3106a31`. First containing tag:
`v7.3-rc1`. Not an ancestor of this HEAD.

**Step 1.3 — body**
Record:
- **Bug:** `.release_buffered_frames` means mac80211 does not set the
  on-air EOSP bit; the driver must. mt76 only set
  `IEEE80211_TX_STATUS_EOSP` (ends the SP inside mac80211).
- **Symptom:** U-APSD clients that wait for EOSP never see it, keep the
  service period open, stop triggering, **all downlink for that STA
  stalls**.
- **Root cause:** missing `IEEE80211_QOS_CTL_EOSP` on the last QoS frame
  of a U-APSD SP. PS-Poll must not get EOSP.
- **Version info:** none in the message. Buggy code dates to 2017.

**Step 1.4 — hidden fix?**
Record: Not hidden. Explicit protocol/connectivity fix.

## Phase 2: Diff analysis

**Step 2.1 — inventory**
Record:
- File: `drivers/net/wireless/mediatek/mt76/tx.c` (`+12 / -4`)
- Functions: `mt76_queue_ps_skb`, `mt76_release_buffered_frames`
- Scope: single-file surgical change. `mt76_queue_ps_skb` is static;
  exported `mt76_release_buffered_frames` signature already has
  `reason`.

**Step 2.2 — flow**
Record:
- Before: last PS-release frame gets `IEEE80211_TX_STATUS_EOSP |
  IEEE80211_TX_CTL_REQ_TX_STATUS` and More Data cleared. QoS Control on
  the wire is untouched.
- After: same flags, plus if `reason == IEEE80211_FRAME_RELEASE_UAPSD`
  and the frame is QoS data, OR `IEEE80211_QOS_CTL_EOSP` into the QoS
  control field. `reason` is passed through both call sites.
- Path: U-APSD/PS-Poll release via `.release_buffered_frames`, not the
  normal TX burst path.

**Step 2.3 — bug mechanism**
Record: **Logic / protocol correctness.** mac80211’s own release path
(`net/mac80211/sta_info.c`) does `*qoshdr |= IEEE80211_QOS_CTL_EOSP` for
U-APSD. Drivers that implement `.release_buffered_frames` must do the
same (`include/net/mac80211.h`). mt76 did not.

**Step 2.4 — quality**
Record: Obviously correct and aligned with mac80211. Guards match the
docs (U-APSD only; QoS data only). skb is exclusively owned after
`ieee80211_tx_dequeue`. Header at `skb->data` matches existing
`mt76_skb_set_moredata()`. Regression risk is low: PS-Poll unchanged;
non-QoS last frames still lack wire EOSP (mac80211 already assumes
drivers mostly buffer QoS-data, or add a QoS-Null themselves). Pre-
existing unused `more_data` parameter is not changed.

## Phase 3: Git history

**Step 3.1 — blame**
Record: `mt76_queue_ps_skb` / `mt76_release_buffered_frames` introduced
in `17f1de56df0512` (“mt76: add common code…”, 2017-12-07,
**v4.16-rc1**). `IEEE80211_TX_STATUS_EOSP` added in `7267a7965dd7b`
(2018). Present for the entire 5.15 lifetime.

**Step 3.2 — Fixes: tag**
Record: None. Introducer is `17f1de56df0512`, which **is** in this tree.

**Step 3.3 — related file history**
Record: Recent 5.15 `tx.c` work is unrelated (locking, UAF, queue id).
This tree already has U-APSD AP support: `b807b368c4f9b` (mt76 AP
U-APSD), `4bf04d33f5b7e` (mt7915). No earlier EOSP-on-wire fix.

**Step 3.4 — author**
Record: Felix Fietkau is listed in `MAINTAINERS` as mt76 maintainer.
Sibling series patch 05 (`697badc27a9b3`, mt7603 U-APSD termination) is
a separate chip-specific fix, not a prerequisite.

**Step 3.5 — prerequisites**
Record: Series is **01–10**, but 04 does **not** depend on 01–03. Patch
01 (`a547b414bf7ea`) changes `mt76_txq_send_burst` / HW TIM buffering
and does not touch `mt76_queue_ps_skb`. 02/03/09/10 are
mt7915/mt7996/MLO (mt7996 is not in 5.15). 05–08 are mt7603-only. 04 is
standalone. All helpers used (`ieee80211_is_data_qos`,
`ieee80211_get_qos_ctl`, `IEEE80211_QOS_CTL_EOSP`,
`IEEE80211_FRAME_RELEASE_UAPSD`) exist in this tree via `mt76.h` →
`<net/mac80211.h>` / `ieee80211.h`.

## Phase 4: Mailing list / external

**Step 4.1 — original discussion**
Record: `b4 dig -c 0b8d252471609` →
https://patch.msgid.link/20260801145334.1166751-4-nbd@nbd.name
`b4 dig -a`: single **v1** series, 2026-08-01. Applied version is that
v1. Thread has the 10 patches plus a kernel-test-robot build error on
**10/10** (`ieee80211_txq_aql_pending` / patch 01), **not** on 04. No
NAK, no reviewer concern about EOSP. Merged via `wireless-
next-2026-08-06` into `v7.3-rc1`.

**Step 4.2 — recipients (`b4 dig -w`)**
Record: Felix Fietkau, `linux-wireless@vger.kernel.org`. Maintainer-
authored self-merge; no extra Reviewed-by. Normal for mt76.

**Step 4.3 — bug report**
Record: No syzbot/bugzilla. The series commit messages describe a
concrete on-air failure (clients waiting for EOSP). Unverified: no
public user stack trace beyond the author’s analysis.

**Step 4.4 — series context**
Record: 04 is the common-path EOSP fix. 05 is the mt7603 driver-PS-queue
analogue. Taking 04 without 05 still fixes mac80211-buffered frames on
**all** chips that use `mt76_release_buffered_frames` (mt76x0/x2,
mt7615, mt7915, mt7921, and mt7603’s fallback).

**Step 4.5 — stable list**
Record: `lore.kernel.org/stable/?q=mt76+EOSP+QoS` → **No results
found**. No recorded reason to skip it.

## Phase 5: Semantic / call graph

**Step 5.1 — functions**
Record: `mt76_queue_ps_skb`, `mt76_release_buffered_frames`.

**Step 5.2 — callers**
Record: `mt76_queue_ps_skb` only from `mt76_release_buffered_frames`.
That is `.release_buffered_frames` for mt76x0, mt76x2, mt7615, mt7915,
mt7921; mt7603 wraps it after draining `msta->psq`. mac80211 calls it
from `ieee80211_sta_ps_deliver_response()` →
`drv_release_buffered_frames()`.

**Step 5.3 — callees**
Record: `IEEE80211_SKB_CB`, `ieee80211_is_data_qos`,
`ieee80211_get_qos_ctl`, `mt76_skb_set_moredata`, `__mt76_tx_queue_skb`.
No new locks/allocs.

**Step 5.4 — reachability**
Record: Yes, from the air. AP RX of a U-APSD trigger
(`ieee80211_sta_uapsd_trigger` in `mac80211.c` / `rx.c`) →
`ieee80211_sta_ps_deliver_uapsd` → driver release. This tree sets
`WIPHY_FLAG_AP_UAPSD`. Typical trigger: a phone associated to an mt76
AP.

**Step 5.5 — similar patterns**
Record: mac80211 `sta_info.c` uses the same `*qoshdr |=
IEEE80211_QOS_CTL_EOSP`. Sibling mt7603 patch 05 does the same for TXD-
prefixed PS-queue frames (`skb->data[MT_TXD_SIZE]`). Common-path frames
from `ieee80211_tx_dequeue` have the 802.11 header at `skb->data` (same
as `mt76_skb_set_moredata`).

## Phase 6: This tree (5.15.221)

**Step 6.1 — buggy code present?**
Record: **Yes.** `drivers/net/wireless/mediatek/mt76/tx.c`
`mt76_queue_ps_skb()` (lines 344–358) sets only
`IEEE80211_TX_STATUS_EOSP`, not the QoS EOSP bit. Introduced v4.16;
U-APSD AP enabled here since 2020.

`git describe HEAD`: `p-5.15-2-g6703e5d2f3a29`. `make kernelversion`:
**5.15.221**. `git merge-base --is-ancestor 0b8d252471609 HEAD` → **not
present**.

**Step 6.2 — backport difficulty**
Record: **Clean apply.** `git apply --check` succeeded; hunks applied at
offset −69 only because `mt76_txq_dequeue` still uses
`MT_TX_HW_QUEUE_EXT_PHY` here vs `FIELD_PREP(MT_TX_HW_QUEUE_PHY, …)`
upstream. That function is context, not part of the change.

**Step 6.3 — related fixes already here?**
Record: No. Only `7267a7965dd7b` (TX status for the software EOSP flag),
which is exactly the incomplete behavior this commit finishes.

## Phase 7: Subsystem

**Step 7.1**
Record: `drivers/net/wireless/mediatek/mt76` — Wi-Fi driver.
**IMPORTANT** (not core kernel, but widely used: OpenWrt/home routers,
mt76x0/x2/7603/7615/7915/7921).

**Step 7.2**
Record: Mature driver; this PS-release path has been stable since 2017.
Not a bug in brand-new code.

## Phase 8: Impact and risk

**Step 8.1 — who**
Record: Driver/config-specific: `CONFIG_MT76*` AP mode with U-APSD
clients. Large real-world set (MediaTek AP SoCs).

**Step 8.2 — trigger**
Record: Associated STA in power-save using U-APSD (typical phones) sends
a trigger; AP releases buffered QoS data. Not a rare error path.
Unprivileged on the air (associated client). PS-Poll-only clients are
unaffected by the new bit.

**Step 8.3 — failure mode**
Record: **Station downlink stall** until the client gives up the SP. Not
a kernel oops. Severity: **HIGH** (loss of connectivity for that STA),
not CRITICAL (no panic/corruption).

**Step 8.4 — risk/benefit**
Record: Benefit high for mt76 AP + U-APSD clients. Risk very low: ~12
lines, QoS bit only on last U-APSD QoS-data frame, same pattern as
mac80211, clean apply, no API/struct change. Patch 01’s
`ieee80211_txq_aql_pending` is **not** required.

## Phase 9: Synthesis

**Step 9.1 — evidence**

For:
- Real, documented 802.11 bug: missing on-air EOSP → downlink stall
- Code and AP U-APSD flag exist in 5.15.221
- Bug since v4.16
- Maintainer-authored, merged to mainline (`v7.3-rc1`), no revert, no
  later rewrite of this function
- 12 insertions / 4 deletions, clean apply
- Matches mac80211
- Standalone despite 04/10 numbering

Against:
- Not crash/security/corruption
- No `Reported-by` / syzbot
- No extra reviewer
- mt7603 hardware PS-queue still wrong without patch 05 (does not make
  04 incorrect or unusable)

Unresolved: no independent end-user report found beyond the maintainer’s
analysis.

**Step 9.2 — stable rules**
1. Obviously correct and tested? **PASS** — same as mac80211; in
   mainline since v7.3-rc1
2. Real bug affecting users? **PASS** — U-APSD clients on mt76 APs
3. Important? **PASS** — full downlink stall for the STA (HIGH)
4. Small/contained? **PASS** — one file, ~12 lines
5. No new features/APIs? **PASS** — sets a standard 802.11 bit the
   driver was already required to set
6. Applies to this tree? **PASS** — `git apply --check` clean

**Step 9.3 — exceptions**
Record: None (not an ID/quirk/DT/build/doc exception). Qualifies as a
normal bugfix.

**Step 9.4 — decision**
This 5.15.221 tree has the buggy path, U-APSD AP support, and every API
the patch needs. The change is a small, self-contained protocol fix for
a serious AP-mode connectivity failure. It should be backported here.

---

### What it solves for 5.15 users
On MediaTek mt76 APs, U-APSD service periods never get the EOSP bit on
the last released QoS frame. mac80211 thinks the SP ended
(`IEEE80211_TX_STATUS_EOSP`), but the client never sees EOSP on the air,
stops triggering, and **downlink to that station stalls**. Setting
`IEEE80211_QOS_CTL_EOSP` on the last U-APSD QoS-data frame is what
mac80211 already documents and implements when the driver does not take
`.release_buffered_frames`.

### Stable rules / risk
Meets all six criteria. Benefit is restoring buffered downlink for
U-APSD clients; risk is a one-bit header update on a path that already
rewrites More Data. No series dependencies for this hunk. mt7603’s
separate PS-queue EOSP bug is a sibling, not a blocker.

### Verification
- [Phase 1] Parsed tags: Link to 04/10, author SOB only; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] `git log origin/master --grep='set the EOSP bit' --
  drivers/net/wireless/mediatek/mt76/`: `0b8d252471609`
- [Phase 1] `git describe --contains --match 'v*' 0b8d252471609`:
  `v7.3-rc1~133^2~99^2~15^2~8`
- [Phase 2] Diff: `mt76_queue_ps_skb` + `reason`; EOSP OR on last U-APSD
  QoS-data frame; two call sites
- [Phase 2] Compared to `net/mac80211/sta_info.c:1708` (`*qoshdr |=
  IEEE80211_QOS_CTL_EOSP`) — same mechanism
- [Phase 2] Confirmed `include/net/mac80211.h` requires the driver to
  set EOSP when `.release_buffered_frames` is implemented
- [Phase 3] `git blame` on `tx.c` 345–403: introduced `17f1de56df0512`
  (v4.16-rc1)
- [Phase 3] `git log --grep='EOSP' --
  drivers/net/wireless/mediatek/mt76/`: only TX-status EOSP
  (`7267a7965dd7b`) in this tree
- [Phase 3] Patch 01 `a547b414bf7ea` does not touch `mt76_queue_ps_skb`
  (not a prerequisite)
- [Phase 4] `b4 dig -c 0b8d252471609`: lore URL above; `b4 dig -a`: v1
  only; `b4 dig -w`: linux-wireless + author
- [Phase 4] 11-message mbox: no NAK on 04; kbuild error is on 10/10 /
  patch 01
- [Phase 4] `curl` stable lore for `mt76 EOSP QoS`: no results
- [Phase 5] Callers: mt76x0/x2, mt7615, mt7915, mt7921 ops; mt7603
  wrapper; mac80211 `drv_release_buffered_frames`
- [Phase 5] This tree: `WIPHY_FLAG_AP_UAPSD` and
  `ieee80211_sta_uapsd_trigger` in `mt76/mac80211.c`
- [Phase 6] `git describe HEAD`: `p-5.15-2-g6703e5d2f3a29`; `make
  kernelversion`: 5.15.221
- [Phase 6] `git merge-base --is-ancestor 0b8d252471609 HEAD`: not in
  tree
- [Phase 6] `git apply --check` of 04/10: success, offset −69
- [Phase 6] APIs present: `IEEE80211_QOS_CTL_EOSP` `0x0010`,
  `ieee80211_get_qos_ctl`, `ieee80211_is_data_qos`,
  `IEEE80211_FRAME_RELEASE_UAPSD`
- [Phase 8] Failure mode: STA downlink stall (HIGH), not oops
- UNVERIFIED: no independent user bugzilla/syzbot report; impact
  inferred from protocol + maintainer description

**YES**

 drivers/net/wireless/mediatek/mt76/tx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 731caeda72b52..93275bb692fa5 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -415,16 +415,23 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
 static void
 mt76_queue_ps_skb(struct mt76_phy *phy, struct ieee80211_sta *sta,
-		  struct sk_buff *skb, bool last)
+		  struct sk_buff *skb, bool last,
+		  enum ieee80211_frame_release_type reason)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
-	if (last)
+	if (last) {
 		info->flags |= IEEE80211_TX_STATUS_EOSP |
 			       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+		if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
+		    ieee80211_is_data_qos(hdr->frame_control))
+			*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_EOSP;
+	}
+
 	mt76_skb_set_moredata(skb, !last);
 	__mt76_tx_queue_skb(phy, MT_TXQ_PSD, skb, wcid, sta, NULL);
 }
@@ -457,14 +464,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
 			nframes--;
 			if (last_skb)
-				mt76_queue_ps_skb(phy, sta, last_skb, false);
+				mt76_queue_ps_skb(phy, sta, last_skb, false,
+						  reason);
 
 			last_skb = skb;
 		} while (nframes);
 	}
 
 	if (last_skb) {
-		mt76_queue_ps_skb(phy, sta, last_skb, true);
+		mt76_queue_ps_skb(phy, sta, last_skb, true, reason);
 		dev->queue_ops->kick(dev, hwq);
 	} else {
 		ieee80211_sta_eosp(sta);
-- 
2.53.0

