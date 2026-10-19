Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4285D6C69;
	Mon, 19 Oct 2026 14:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418510; cv=none; b=NelI/tZdD+5CqxjYLvnfpgeMgBiN8uvAVkRaOGUnXXtrrrFnR+fvuT6JT6zNGh0LOLPwtgIdisfQ1mOHHWiLbjS2H4/r7CIMv83lNumChp7CJDhOa/a48TFm7HXeF1DsFrlcdv3EeQBimETPBUQbmdjCRPfPFDR/kvZwvsqSaqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418510; c=relaxed/simple;
	bh=vpK4lJlgcXqXdKD2RUDe50UeK6XzNxV47izOTbYUD5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2vRRkCfiV2zT8dTYUY8Xjt1P91FrlqtaFIJFF0L8zN/H9dOGyJSqn/GySEVuhUYLr/6/k91T3g5btcqsH+FxXlLuoI5sV593BIsEU8tPXg/eAgG11MR079rLOnM5w8o+b4MMwyA3zWpP997EWvHQ8BUYYN/wuf8IYW8FMdKexM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHUPQiOI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHUPQiOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B551F000C9;
	Mon, 19 Oct 2026 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418508;
	bh=stDIY3cut1La0RIQyUHVoHa5of1PPIvTxAd31vWKrJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHUPQiOImUOmKZXmKhJrqwHGcIC6mw8ayygxuj25hw9R0sNeiHncPOCc082PnD31H
	 kXhsYZKEIB7BfdJhtW2gnSYyVXm0/Wqi90nX4ylhkhuZSRVW+X6v/7TyOTgYCGxyD+
	 zBZ1H3x9e5RFeHFPu6RPp37dn5T2I+MIW0XqfUS04h6uTWauPLjh1jrA3ZU1aAQ0YR
	 vws7O/CHrSSx9evCGSKYaX80nZm7rTnIut+RRZqVmQGvLTYtEVHANPb0I+EgFAoEKq
	 bGM9TXDm9i3vzwkyHX1s7CV9MtaVDJQ4uiToMpYMkZ0YN2LzBfxsioOpunkeZQ3c2W
	 ncWL/WGDAjFvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Chad Monroe <chad@monroe.io>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates
Date: Mon, 19 Oct 2026 09:49:49 -0400
Message-ID: <20261019135441.1420968-298-sashal@kernel.org>
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

[ Upstream commit 98aff74779da9f417386c589c36848e9c568f0f9 ]

mt7615_tx() falls back to the vif BSS wcid when mac80211 hands a frame
over without a station, e.g. while a station is being torn down, and to
the global wcid when there is no vif either. Both tx_prepare_skb
implementations derive a mt7615_sta from that wcid unconditionally and,
if the rate control probe flag is set, pass it to mt7615_mac_set_rates(),
which dereferences the NULL vif backpointer of the per-vif embedded sta:

  Unable to handle kernel read from unreadable memory at virtual
  address 0000000000000002
  ...
  pc : mt7615_mac_set_rates
  lr : mt7615_tx_prepare_skb

Neither entry is rate controlled by mac80211: the embedded sta has an
empty rate set, and for the global wcid the container_of does not yield a
valid mt7615_sta at all. Only resolve the sta for wcids that belong to a
station.

Reported-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/20260724124813.3961474-23-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[wifi: mt76: mt7615]` `[fix]` `[NULL deref in
mt7615_mac_set_rates when TX uses a non-station wcid]`

**Step 1.2 — Tags**
Record:
- `Reported-by: Chad Monroe <chad@monroe.io>` — real user hit this
- `Link:
  https://patch.msgid.link/20260724124813.3961474-23-nbd@nbd.name` —
  patch 23/29 of an mt76-next series
- `Signed-off-by: Felix Fietkau <nbd@nbd.name>` — mt76 maintainer
- No `Fixes:`, no `Cc: stable` (expected for this review)
- No `Reviewed-by` / `Tested-by` / `Acked-by` on the commit itself
- Ignore `Signed-off-by: Sasha Levin` / `[Upstream commit ...]` if
  present (pipeline)

**Step 1.3 — Body**
Record:
- Bug: `mt7615_tx()` falls back to the vif BSS wcid when mac80211 TX has
  no station (e.g. station teardown), and to `global_wcid` if there is
  no vif. Both `tx_prepare_skb` paths `container_of` that wcid into
  `mt7615_sta` and, if `IEEE80211_TX_CTL_RATE_CTRL_PROBE` is set, call
  `mt7615_mac_set_rates()`.
- Symptom: kernel NULL deref / oops:
  `Unable to handle kernel read from unreadable memory at virtual
  address 0000000000000002`, `pc: mt7615_mac_set_rates`, `lr:
  mt7615_tx_prepare_skb`
- Root cause: BSS-embedded sta has a NULL `vif` backpointer;
  `global_wcid` is not a `mt7615_sta` at all. Neither is rate-
  controlled.
- Fix: only resolve `msta` when `wcid->sta` is set.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. Explicit crash fix with a stack trace and a
reporter.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- `drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c`:
  `mt7615_tx_prepare_skb` — ~3 lines
- `drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c`:
  `mt7663_usb_sdio_tx_prepare_skb` — ~3 lines
- Scope: single-driver surgical fix, two TX prepare paths (PCIe/MMIO and
  USB/SDIO)

**Step 2.2 — Code flow**
Record: Before, any non-NULL `wcid` was treated as `mt7615_sta`. After,
`msta` is set only if `wcid && wcid->sta`. The existing `if (...
RATE_CTRL_PROBE && msta)` already skips `mt7615_mac_set_rates()` when
`msta` is NULL.

**Step 2.3 — Bug mechanism**
Record: `[NULL pointer dereference]` — `mt7615_mac_set_rates()` does
`sta->vif->mt76.omac_idx`. For the per-vif embedded sta, `vif` is never
set. For `global_wcid`, `container_of` is invalid. The fix uses the
existing `wcid->sta` flag.

**Step 2.4 — Fix quality**
Record: Obviously correct. Same pattern already used in this tree
(`wcid_to_sta()`, `mt76_connac_pm_dequeue_skbs()`,
`mt7615_rx_get_wcid()`). Skipping rate-probe setup for non-station wcids
is intended: those entries are not rate-controlled. Regression risk is
very low. No API change.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: The incomplete NULL check is `8d3cdc1bbb1d3` (“mt76: mt7615: fix
NULL pointer dereference in tx_prepare_skb()”, Lorenzo Bianconi, 2021).
That only handled `wcid == NULL` (then `global_wcid`). The BSS-wcid
fallback in `mt7615_tx()` is from 2019 (`04b8e65922f631` /
`2b8cdfb28d3402`). The bug has been in this lineage since mt7615 TX was
added.

**Step 3.2 — Fixes: tag**
Record: None. The incomplete 2021 fix is already in this tree (`git
merge-base --is-ancestor 8d3cdc1bbb1d3 HEAD` succeeded). This commit
closes the remaining hole.

**Step 3.3 — File history**
Record: Recent mt7615 changes in this tree are unrelated (runtime-pm
timeout, TSF, DMA reset). No prerequisite refactor for this two-line
guard. Standalone.

**Step 3.4 — Author**
Record: Felix Fietkau is the mt76 maintainer. Related earlier NULL-deref
fix was also signed off by him.

**Step 3.5 — Dependencies**
Record: Patch 23/29 of an mt76-next batch, but the other patches are
independent (mt7996/mt7915/scan/WED). This hunk only needs `wcid->sta`
and the existing `msta` NULL check, both present here. Standalone.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record: `b4 mbox` saved the thread. Subject: `[PATCH mt76-next 23/29]
wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates`. Sent 24 Jul
2026 by Felix to linux-wireless. 29-message thread is the series itself,
not a v2/v3 of this patch. No NAK. No reviewer `Cc: stable`. Lore HTTP
fetch returned 403; discussion was recovered via `b4`.

**Step 4.2 — Recipients**
Record: To: linux-wireless@vger.kernel.org. Maintainer is the author.

**Step 4.3 — Bug report**
Record: Reported-by Chad Monroe with a concrete oops (`pc:
mt7615_mac_set_rates`, `lr: mt7615_tx_prepare_skb`). Chad also authored
other patches in the same series, so this is a real device user, not a
theoretical report.

**Step 4.4 — Series**
Record: Independent mt76 bug-fix dump. mt7996 patches are irrelevant to
5.15. This patch does not need 1–22 or 24–29.

**Step 4.5 — Stable list**
Record: UNVERIFIED — lore.kernel.org/stable HTTP 403. No evidence it was
rejected for stable.

## Phase 5: Semantic / call-chain

**Step 5.1 — Functions**
Record: `mt7615_tx_prepare_skb`, `mt7663_usb_sdio_tx_prepare_skb`
(callers of `mt7615_mac_set_rates`).

**Step 5.2 — Callers**
Record:
- PCIe/MMIO: `mt7615_tx_prepare_skb` via `mt7615/mmio.c`
  `.tx_prepare_skb`, from `mt76_dma_tx_queue_skb` (`dma.c:409`)
- USB: `usb.c:917`; SDIO: `sdio.c:263`
- Upstream of that: `mt7615_tx()` → `mt76_tx()` /
  `mt76_connac_pm_queue_skb()`

**Step 5.3 — Callees**
Record: `mt7615_mac_set_rates()` immediately uses
`sta->vif->mt76.omac_idx` (mac.c:1063 in this tree).

**Step 5.4 — Reachability**
Record: Yes, from normal wireless TX. `mt7615_tx()`:

```737:743:drivers/net/wireless/mediatek/mt76/mt7615/main.c
        if (vif && !control->sta) {
                struct mt7615_vif *mvif;
                mvif = (struct mt7615_vif *)vif->drv_priv;
                msta = &mvif->sta;
                wcid = &msta->wcid;
        }
```

mac80211 can pass `control->sta == NULL` while
`IEEE80211_TX_CTL_RATE_CTRL_PROBE` is still set on a previously rate-
controlled skb (station teardown). That is a userspace-reachable
AP/client path.

**Step 5.5 — Similar patterns**
Record: Same `wcid && wcid->sta` guard already exists in
`mt76x02_mac.c`, `mt76_connac_mac.c`, `wcid_to_sta()`.
`mt7615_rx_get_wcid()` already refuses non-station wcids. `wcid.sta = 1`
is set only in `mt7615_mac_sta_add()`, not in `mt7615_add_interface()`.

## Phase 6: Local tree (5.15.221 / pending-5.15)

**Step 6.1 — Buggy code present?**
Record: Yes.
- `pci_mac.c:142`: `msta = wcid ? container_of(wcid, struct mt7615_sta,
  wcid) : NULL;`
- `usb_sdio.c:200`: same
- `mac.c:1063`: `u16 idx = sta->vif->mt76.omac_idx;`
- `add_interface` sets `mvif->sta.wcid` but never `mvif->sta.vif` or
  `wcid.sta`
- `wcid->sta` exists in `struct mt76_wcid` (`mt76.h:251`)

**Step 6.2 — Backport difficulty**
Record: Minor context mismatch, easy rework. Mainline USB path has extra
locals (`key`, `pktid`) and an in-function `global_wcid` fallback that
5.15 keeps in `mt7663_usb_sdio_write_txwi()`. PCIe path uses
`MT_TX_HW_QUEUE_EXT_PHY` / `mdev->phy2` here vs later `phys[MT_BAND1]`.
The semantic change is the same two-line `wcid->sta` check.
`mt76_vif_link` in the provided hunk context is *not* required.

**Step 6.3 — Related fixes already here?**
Record: `8d3cdc1bbb1d3` is present and is incomplete. No later
`mt7615_mac_set_rates` NULL-deref fix in this tree.

## Phase 7: Subsystem context

**Step 7.1**
Record: `[drivers/net/wireless/mediatek/mt76/mt7615]` `[IMPORTANT]` —
not core kernel, but a widely used 802.11ac chipset (MT7615E/MT7663E
PCIe, MT7663U USB, MT7663S SDIO, MT7622 SoC WMAC). Common on routers and
embedded boards, including 5.15 LTS/Android/OpenWrt-class systems.

**Step 7.2**
Record: Mature driver; this bug is old, not a new-subsystem issue.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Users of MT7615/MT7663/MT7622 (`CONFIG_MT7615E` /
`CONFIG_MT7663U` / `CONFIG_MT7663S` / `CONFIG_MT7622_WMAC`). Driver-
specific, not universal.

**Step 8.2 — Trigger**
Record: TX without a station while `IEEE80211_TX_CTL_RATE_CTRL_PROBE` is
set — typically station teardown / disconnect with a probe rate sample
in flight. Not every packet, but a normal Wi-Fi event. Unprivileged
clients disconnecting from an AP can induce it.

**Step 8.3 — Failure mode**
Record: `[Kernel oops / NULL deref in hard TX path]` `[CRITICAL]`

**Step 8.4 — Risk vs benefit**
Record: Benefit high for that hardware (prevents oops). Risk very low
(~6 lines, existing flag, same pattern as sibling code). Skipping
`mac_set_rates` on BSS/global wcid is the correct behavior.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real oops with reporter and stack trace
- Bug and incomplete 2021 fix both exist in this 5.15 tree
- Small, obviously correct guard
- Maintainer-authored
- Matches stable rules (crash, contained, no new API)
- Hardware is common on 5.15-era devices

AGAINST:
- Driver-specific, not core
- Won’t `git am` cleanly (context only)
- Part of a 29-patch series (other patches are unrelated)
- No `Fixes:` / `Cc: stable` (not a negative under these rules)
- No mailing-list review tags on this specific patch

UNRESOLVED:
- Could not fetch lore/stable over HTTP (403); recovered the thread with
  `b4`
- Exact crash address `...0002` matches a newer `vif` layout; in 5.15
  `omac_idx` is at offset 1. Same NULL `vif` deref either way.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — maintainer fix; user-
   reported oops; logic matches existing `wcid->sta` usage
2. Real bug affecting users? **PASS** — Chad Monroe crash
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   oops in TX
4. Small and contained? **PASS** — two functions, ~6 lines
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — code is here; needs a trivial
   context tweak, not a rewrite

**Step 9.3 — Exceptions**
Record: None (not a device-ID/quirk/DT/build/docs exception). It
qualifies as a normal crash fix.

**Step 9.4 — Decision**
This is a real NULL deref in the mt7615 TX path that 5.15 still has. The
2021 patch only covered a NULL wcid; the BSS-wcid fallback still
crashes. Backport it.

## What the commit solves for this tree

On 5.15.221, `mt7615_tx()` still substitutes the per-vif embedded sta
when mac80211 has no station. `tx_prepare_skb` still `container_of`s
that wcid and can call `mt7615_mac_set_rates()`, which immediately loads
`sta->vif->mt76.omac_idx` while `vif` is NULL. That oopses. Restricting
`msta` to `wcid->sta` stops it. Same change belongs in both PCIe and
USB/SDIO prepare paths.

Risk is a skipped rate-probe update on wcids that were never valid for
rate control. Benefit is avoiding a driver oops during client teardown.

## Verification
- [Phase 1] Parsed tags: Reported-by Chad Monroe; Link to 23/29
  mt76-next; SOB Felix Fietkau; no Fixes/Cc stable
- [Phase 2] Diff: two `msta` assignments; require `wcid->sta` before
  `container_of`
- [Phase 3] Blame: 8d3cdc1bbb1d3 (2021) only NULL-wcid; BSS fallback
  since 2019
- [Phase 3] `git merge-base --is-ancestor 8d3cdc1bbb1d3 HEAD`: yes,
  incomplete fix is here
- [Phase 3] `git log --grep="fix NULL deref in mt7615_mac_set_rates" --
  mt7615/`: not in this tree
- [Phase 4] `b4 mbox 20260724124813.3961474-23-nbd@nbd.name`: 29-message
  independent mt76 series; this patch standalone; no NAK
- [Phase 4] lore HTTP 403; UNVERIFIED stable@ discussion
- [Phase 5] Call chain: mac80211 `drv_tx` → `mt7615_tx` → `mt76_tx` /
  DMA `tx_prepare_skb` → `mt7615_mac_set_rates`
- [Phase 5] `mt7615_add_interface` does not set `mvif->sta.vif` or
  `wcid.sta`; only `mt7615_mac_sta_add` sets `wcid.sta = 1`
- [Phase 6] `make kernelversion` / Makefile: **5.15.221**, branch
  `pending-5.15`
- [Phase 6] Buggy lines present in `pci_mac.c:142` and `usb_sdio.c:200`;
  deref at `mac.c:1063`
- [Phase 6] Surrounding context differs (phy2 vs phys[MT_BAND1], USB
  locals); semantic apply is still two lines
- [Phase 8] Failure: NULL deref oops in TX; severity CRITICAL for
  MT7615/MT7663/MT7622 users

**YES**

 drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c  | 5 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
index b795d11d943d0..61efdf59133f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
@@ -68,10 +68,11 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	int pid, id;
 	u8 *txwi = (u8 *)txwi_ptr;
 	struct mt76_txwi_cache *t;
-	struct mt7615_sta *msta;
+	struct mt7615_sta *msta = NULL;
 	void *txp;
 
-	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
+	if (wcid && wcid->sta)
+		msta = container_of(wcid, struct mt7615_sta, wcid);
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 820b395900275..01e79f37649c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -187,10 +187,11 @@ int mt7663_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct sk_buff *skb = tx_info->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
-	struct mt7615_sta *msta;
+	struct mt7615_sta *msta = NULL;
 	int pad, err, pktid;
 
-	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
+	if (wcid && wcid->sta)
+		msta = container_of(wcid, struct mt7615_sta, wcid);
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
-- 
2.53.0

