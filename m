Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C23D61258F;
	Mon, 19 Oct 2026 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418635; cv=none; b=Dvu/rdS/EQbkO5KmSCwHFo9pS+RJ3djyeDXE2aivhi1rkb17qM+9z7StN9seftONAxs1QeJkcm0a+D1SwQDorLl+rzNuCFlcz8sUOxukYlVlP5myMMnXC8MtifsoXMdviZg6KqOzqKfc1mpy9PZgrOitK9/6JV9y5nmZnClxHUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418635; c=relaxed/simple;
	bh=0/9695QWSJqXIagvEzmbBsJCdE5Lkg6pHDvm2j0EBu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BD9/ssY9n5Nxzh+5kY1H/Qv8gICU6RocmwSnL4xfZgMvvQNI5TdJP+QbpGCFbZRwZ8opUgASbQSlbM3lu8E4XWiatPLS82yKo4iL1pO2aEbqNYBSABJUtGpossRKyNuEmlHnd5XSCVl08EKBSqZyTiWtkyDkB/neFch5CRSB7RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sy9eVxO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sy9eVxO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3661F000C9;
	Mon, 19 Oct 2026 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418632;
	bh=sv6rVlir+RBR5HytJBd1kxyg8GjuUSzazSxRgHWQXJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sy9eVxO9FHnAsiqFgAgXpgE0EwvnrsF0PJpA7VSNtfd2K7T62sa28615clRyVNi3o
	 PIWSaau5ob1MLGp6BPhUCD13+q5CXtSSZzq2z4+p0jOqLIv63N8rWnlXBN5buFWmPU
	 /HFPX4EobkxsXTr09K14UrmHtHnLCSG7u1yly+zqEbUmZNOloSAJ7L5An59BQyAHpg
	 rGfL8KwESeQH89wBj+LkBYfMU2n9ALSDyY2UwkEHtDhuW86ARpQu5Vx1M12efksrbN
	 rMlWynmFS2Fp6/SCImuirwMkJFJkwX7XBk8kTYpHoGooGmv/tk3KHxdqV4p/QIvT8+
	 u7aUJxTelWYxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Devin Wittmayer <lucid_duck@justthetip.ca>,
	0072a70 <90307219+0072a70@users.noreply.github.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Mon, 19 Oct 2026 09:51:18 -0400
Message-ID: <20261019135441.1420968-387-sashal@kernel.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit ddae0bcb01e71c1184bb3f526f9622e31dc38f3b ]

When the fcsfail filter is enabled the hardware passes frames with a bad
FCS up to the driver, but mt76x02_mac_process_rx() never checks
MT_RXINFO_CRCERR and hands them to mac80211 without
RX_FLAG_FAILED_FCS_CRC. In monitor mode the radiotap flags byte then
never gets IEEE80211_RADIOTAP_F_BADFCS set and corrupted frames cannot be
told apart from clean ones.

Set RX_FLAG_FAILED_FCS_CRC from the descriptor CRC error bit, matching
mt7603, mt7615, mt7915, mt7921, mt7925 and mt7996.

Reported-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Closes: https://github.com/morrownr/mt76/issues/38
Tested-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260613002544.27750-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[wifi: mt76: mt76x02]` `[report]` `[report rx FCS errors to
  mac80211]`
- Subsystem is MediaTek mt76, mt76x02 family (mt76x0 / mt76x2 PCI and
  USB). “Report” here is a correctness fix: the driver already receives
  CRC-failed frames and must mark them.

**Step 1.2 — Tags**
- Record:
  - `Reported-by: 0072a70 <90307219+0072a70@users.noreply.github.com>` —
    real user hit
  - `Closes: https://github.com/morrownr/mt76/issues/38`
  - `Tested-by:` same reporter, on real hardware
  - `Signed-off-by: Devin Wittmayer` (author)
  - `Link: https://patch.msgid.link/20260613002544.27750-3-
    lucid_duck@justthetip.ca`
  - `Signed-off-by: Felix Fietkau` (mt76 maintainer)
  - No `Fixes:` tag (expected for this review)
  - No `Cc: stable` (expected; not a negative)
  - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    ...]`

**Step 1.3 — Body**
- Record:
  - **Bug:** With the `fcsfail` filter enabled, hardware delivers frames
    with `MT_RXINFO_CRCERR` set. `mt76x02_mac_process_rx()` never reads
    that bit, so mac80211 never gets `RX_FLAG_FAILED_FCS_CRC`.
  - **Symptom:** In monitor mode, radiotap never sets
    `IEEE80211_RADIOTAP_F_BADFCS`; corrupted frames look identical to
    clean ones.
  - **Root cause:** Missing descriptor-bit → `rx_status` translation.
    Other mt76 chips already do this.
  - **Version info in the message:** none. Reporter used kernel 7.0.x;
    the code path is much older (see Phase 3).

**Step 1.4 — Hidden bug fix?**
- Record: Not disguised. It is an explicit missing-flag fix that
  implements the documented mac80211 contract for `FIF_FCSFAIL`.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: one file, `drivers/net/wireless/mediatek/mt76/mt76x02_mac.c`.
  Three lines added, none removed. Function: `mt76x02_mac_process_rx()`.
  Surgical single-file change.

**Step 2.2 — Flow**
- Record: After the existing `MT_RXINFO_L2PAD` check, if `rxinfo &
  MT_RXINFO_CRCERR`, set `status->flag |= RX_FLAG_FAILED_FCS_CRC`.
  Normal RX is unchanged for clean frames. Error/monitor path for CRC-
  failed frames is now marked.

**Step 2.3 — Bug mechanism**
- Record: **Logic / correctness** (driver contract). Hardware already
  passes CRC-failed frames when `FIF_FCSFAIL` is on
  (`MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR)` in
  `mt76x02_configure_filter()`). The driver failed to set the flag
  mac80211 requires (`include/net/mac80211.h`: *“pass frames with failed
  FCS (but you need to set RX_FLAG_FAILED_FCS_CRC for them)”*).

Verified mac80211 consequences in this tree:
- `ieee80211_add_rx_radiotap_header()` sets
  `IEEE80211_RADIOTAP_F_BADFCS` only if that flag is present
  (`net/mac80211/rx.c`).
- `should_drop_frame()` treats `RX_FLAG_FAILED_FCS_CRC` as drop-from-
  cooked-path. Without it, `ieee80211_rx_monitor()` copies the frame to
  monitor and **returns the original skb** to
  `__ieee80211_rx_handle_packet()`. FCS-failed frames can therefore
  enter the cooked RX path whenever `fcsfail` is enabled (including
  concurrent monitor + STA/AP).

**Step 2.4 — Fix quality**
- Record: Obviously correct; same pattern as
  `mt7603`/`mt7615`/`mt7915`/`mt7921`/`mt7996` in this tree. Minimal.
  Regression risk is low: only CRCERR frames get a flag they should
  already have. Clean frames are untouched. Does not add APIs or change
  locking.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Insertion point is the 2018 `mt76x02_mac_process_rx()` body
  from `d9f8934ed147b3` (“mt76: move mt76x02_mac_process_rx in
  mt76x02-lib module”), 2018-10-04, first contained in **v4.20-rc1**.
  `MT_RXINFO_CRCERR` is defined in `mt76x02_mac.h:54` since
  `5327b5ea13910d` (2018-09-04). The bit has been defined for years and
  never consumed in RX processing.

**Step 3.2 — Fixes: tag**
- Record: None. The omission dates to the original mt76x02 RX path, not
  a later regression.

**Step 3.3 — File history**
- Record: Same-function sibling from the same series is already in this
  tree: `b6e7958602bd1` (“do not WARN on invalid rx descriptor length”).
  That is patch 1/2 of `[PATCH 0/2] wifi: mt76: mt76x02: rx fixes for
  fcsfail monitor mode`. This candidate is patch 2/2. They touch
  different lines; this one does not depend on patch 1. `git apply
  --check` of this hunk on HEAD is **clean**. No other FCS reporting
  commit exists on this file.

**Step 3.4 — Author**
- Record: Devin Wittmayer; not the subsystem maintainer. Maintainer
  Felix Fietkau signed off. Author also submitted the sibling WARN fix.
  Related author commits in this tree: `b6e7958602bd1`, plus unrelated
  mt7615/mt7921 TXRX_NOTIFY drops.

**Step 3.5 — Prerequisites**
- Record: None beyond symbols already in 6.6: `MT_RXINFO_CRCERR`,
  `RX_FLAG_FAILED_FCS_CRC`, `status->flag`. Commit text mentions mt7925;
  that chip need not exist here — it is comparison only. Standalone
  apply: yes.

## Phase 4: Mailing list / external research

**Step 4.1 — Original discussion**
- Record: `b4 dig -c <sha>` cannot match because this commit is not in
  the local history. Fallback: `b4 mbox
  20260613002544.27750-3-lucid_duck@justthetip.ca`.
  - Cover: https://patch.msgid.link/20260613002544.27750-1-
    lucid_duck@justthetip.ca
  - Series: v1 only (`b4 am --check-newer-revisions`: no later
    revision).
  - Two patches; this is 2/2.
  - Cover: tested on MT7612U and MT7610U; fcsfail monitor captures get
    BADFCS on corrupted frames, clean frames unchanged.
  - No NAKs in the retrieved thread (cover + 2 patches, no review
    replies). Applied by Felix Fietkau.
  - Lore HTTP fetch returned 403; b4 was used instead.

**Step 4.2 — Recipients**
- Record: To Felix Fietkau, Lorenzo Bianconi; Cc Ryder Lee, Shayne Chen,
  Sean Wang, linux-wireless, linux-kernel. Right maintainers/lists.

**Step 4.3 — Bug report**
- Record: GitHub issue #38 (closed). Hardware: Alfa AWUS036ACM, mt7612u,
  driver mt76x2u. With `iw set monitor fcsfail`, radiotap flags were
  always `0x00`; `radiotap.flags.badfcs == 1` matched 0 of 2978 frames.
  After this exact three-line change: 956/7353 frames had BADFCS `0x40`,
  clean frames stayed `0x00`. Confirmed on-list/issue by the reporter
  (`Tested-by`).

**Step 4.4 — Series context**
- Record: Patch 1 (WARN on bogus MPDU length under fcsfail) is already
  in this 6.6 tree. Patch 2 is the functional reporting fix.
  Independent; both target the same user-visible fcsfail path.

**Step 4.5 — stable@ discussion**
- Record: lore.kernel.org/stable HTTP 403. No separate stable-thread
  evidence retrieved. Absence is not a negative for this review.

## Phase 5: Semantic / call-chain analysis

**Step 5.1 — Functions**
- Record: `mt76x02_mac_process_rx()`.

**Step 5.2 — Callers**
- Record: Only `mt76x02_queue_rx_skb()` in `mt76x02_txrx.c` (data RX,
  not MCU queue). That is the USB/PCI RX completion path for mt76x0 and
  mt76x2.

**Step 5.3 — Callees (relevant)**
- Record: Sets `struct mt76_rx_status` in `skb->cb`, then `mt76_rx()` →
  mac80211. `mt76_rx()` already counts `RX_FLAG_FAILED_FCS_CRC` for
  testmode FCS stats (`mac80211.c`).

**Step 5.4 — Reachability**
- Record: Userspace-reachable: `iw set type monitor` + `iw set monitor
  fcsfail` (nl80211 `NL80211_MNTR_FLAG_FCSFAIL` →
  `ieee80211_adjust_monitor_flags()` → `fif_fcsfail` → `FIF_FCSFAIL` →
  hardware CRC filter cleared). Common on USB adapters used for capture
  (Alfa AWUS036ACM and similar).

**Step 5.5 — Similar patterns**
- Record: Same `status->flag |= RX_FLAG_FAILED_FCS_CRC` already present
  in this tree for mt7603, mt7615, mt7915, mt7921, mt7996. mt76x02 is
  the gap. `MT_RXINFO_ICVERR` / `MT_RXINFO_MICERR` are also unused here;
  out of scope for this patch.

## Phase 6: This tree (6.6.157 / pending-6.6)

**Step 6.1 — Does the buggy code exist?**
- Record: Yes. `mt76x02_mac_process_rx()` at `mt76x02_mac.c:794–797` has
  L2PAD then DECRYPT; no CRCERR check. `MT_RXINFO_CRCERR` is defined.
  `git merge-base --is-ancestor d9f8934ed147b3 HEAD` succeeded. Bug
  present since ~v4.20, so it is in 6.6.y.

Local tree identity:
- `git describe HEAD` → `p-6.6-3-g04810563abb71`
- `make kernelversion` → **6.6.157**
- Branch: `pending-6.6`

**Step 6.2 — Backport difficulty**
- Record: **Clean apply.** Context matches; `git apply --check`
  succeeded. Surrounding code is the same as the patch’s index.

**Step 6.3 — Related fixes already here**
- Record: No existing CRCERR → `RX_FLAG_FAILED_FCS_CRC` translation.
  Sibling WARN fix `b6e7958602bd1` is present (different hunk).
  `63fe66f102837` (mt7996 FCS bit in wrong RXD word) is a different
  chip.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `drivers/net/wireless/mediatek/mt76` — **IMPORTANT** (widely
  used WiFi, not core mm/vfs). Covers MT76x0U/E and MT76x2U/E (`Kconfig`
  MT7610/MT7612 USB and PCIe). Peripheral relative to core kernel, but
  these USB NICs are common in the field.

**Step 7.2**
- Record: mt76 is active; mt76x02 RX processing itself has been stable
  for years. This is a long-standing omission, not churn from a new
  subsystem.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: Users of mt76x0/mt76x2 (USB and PCIe) who enable monitor
  `fcsfail`. Normal STA/AP-only operation keeps the hardware CRC filter
  on, so those users are not on this path. Mixed monitor+managed on the
  same phy is affected for cooked RX.

**Step 8.2 — Trigger**
- Record: Explicit monitor `fcsfail` (and typically a busy channel). Not
  every boot. Unprivileged users cannot enable monitor without
  privileges, so this is not a generic local-priv-esc path; it is a
  privileged capture/correctness bug.

**Step 8.3 — Failure mode**
- Record:
  - Monitor: corrupted frames indistinguishable from good ones (broken
    advertised filter). **MEDIUM** for dedicated capture.
  - Cooked path: FCS-failed frames can be processed as valid 802.11 when
    `fcsfail` is on. That is frame-integrity / stack-correctness, not a
    panic. **MEDIUM–HIGH** in mixed-iface setups; not a guaranteed oops.
  - Overall severity: **MEDIUM**, with a real user-visible functional
    break and a documented driver-API violation.

**Step 8.4 — Risk vs benefit**
- Record: **Benefit: medium** (correct FCS reporting; stop garbage
  frames leaking into cooked RX). **Risk: very low** (3 lines, same
  pattern as sibling chips, no lock/API change). Ratio favors backport.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Real, reproduced bug (GitHub #38; Tested-by on MT7612U; author also
  tested MT7610U).
- Violates mac80211 `FIF_FCSFAIL` contract; radiotap BADFCS never set.
- FCS-failed frames can continue into `__ieee80211_rx_handle_packet()`
  without the flag.
- Three-line, obviously correct, matches every other mt76 MAC in this
  tree.
- Applies cleanly to 6.6.157; symbols and call path exist.
- Maintainer SOB (Felix Fietkau).
- Popular USB hardware (e.g. Alfa AWUS036ACM).

Against:
- Not a crash/UAF/deadlock; mainly monitor-mode correctness plus cooked-
  path leakage only when `fcsfail` is enabled.
- No `Fixes:` (omission from original driver, not a later regression).
- Affects a subset of mt76x02 users, not all machines.

Unresolved:
- Direct lore.kernel.org HTTP was 403; discussion recovered via b4.
- No independent stable@ thread found.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — 3 lines, hardware-tested,
   maintainer-acked.
2. Real bug affecting users? **PASS** — reporter could not tell bad-FCS
   frames apart; contract violation is in-tree.
3. Important issue? **PASS** (medium) — broken advertised monitor filter
   plus cooked-path delivery of CRC-failed frames. Not a panic, but it
   is a real correctness/integrity bug, not a feature.
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features/APIs? **PASS** — sets an existing `rx_status` flag
   other mt76 chips already set.
6. Can apply to this tree? **PASS** — clean apply on 6.6.157.

**Step 9.3 — Exception category**
- Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
  driver correctness fix.

**Step 9.4 — Decision**
This tree is **6.6.157**. The buggy RX path, `MT_RXINFO_CRCERR`, and
mac80211 flag handling are all present. The patch is a tiny, tested,
maintainer-accepted fix for a user-visible bug on hardware this driver
supports. Benefit clearly outweighs risk.

---

### What the commit solves for 6.6 users

mt76x02 already programs the hardware to deliver CRC-failed frames when
monitor `fcsfail` is set, but never tells mac80211. Users of
MT7610/MT7612 USB and PCIe adapters then see every frame as clean in
radiotap, and those frames can also continue into the normal RX
handlers. The fix sets `RX_FLAG_FAILED_FCS_CRC` from `MT_RXINFO_CRCERR`,
which is what this tree already does for later mt76 chips.

### Stable-rule fit

Small, obviously correct, no new API, applies cleanly, real user-visible
bug. Importance is monitor/FCS integrity rather than a panic; that is
still within what stable takes for driver contract bugs of this size.

### Risk vs benefit

Very low risk (three lines, clean frames unchanged). Medium benefit for
mt76x02 monitor users and mixed-iface setups.

### Concerns

No functional dependencies. Series mate (WARN drop) is already in this
tree but is not required for this hunk. mt7925 in the commit message is
comparison only.

---

Verification:
- [Phase 1] Parsed tags: Reported-by/Tested-by 0072a70, Closes
  github.com/morrownr/mt76/issues/38, Link msgid `...27750-3...`, SOB
  Felix Fietkau; no Fixes/Cc:stable
- [Phase 2] Diff: +3 lines in `mt76x02_mac_process_rx()` after L2PAD;
  sets `RX_FLAG_FAILED_FCS_CRC` from `MT_RXINFO_CRCERR`
- [Phase 2] Confirmed `mt76x02_configure_filter()` maps `FIF_FCSFAIL` →
  clear `MT_RX_FILTR_CFG_CRC_ERR`
- [Phase 2] Confirmed mac80211 `should_drop_frame()` / radiotap BADFCS /
  `ieee80211_rx_monitor()` cooked-path return behavior in this tree
- [Phase 3] `git blame`: insertion region from `d9f8934ed147b3` (2018);
  `git merge-base --is-ancestor` true; `git describe --contains` →
  v4.20-rc1
- [Phase 3] `MT_RXINFO_CRCERR` defined at `mt76x02_mac.h:54`; `git grep`
  shows it is unused in `.c` files in this tree
- [Phase 3] Sibling `b6e7958602bd1` already in HEAD; this hunk
  independent; `git apply --check` CLEAN
- [Phase 4] `b4 mbox` saved 3-message series; cover tested
  MT7612U/MT7610U; `b4 am --check-newer-revisions` = v1 only, no NAKs
- [Phase 4] WebFetch of GitHub issue #38: reproduced 0 BADFCS; after
  patch 956/7353 frames flagged
- [Phase 4] lore.kernel.org WebFetch: 403 — UNVERIFIED via HTTP;
  recovered via b4
- [Phase 5] Only caller: `mt76x02_queue_rx_skb()`; chips: MT76x0U/E,
  MT76x2U/E
- [Phase 5] Same flag already set in mt7603/mt7615/mt7915/mt7921/mt7996
  in this checkout
- [Phase 6] `git describe HEAD` p-6.6-3-g04810563abb71; `make
  kernelversion` 6.6.157; buggy code present; fix not applied
- [Phase 8] Failure mode: wrong radiotap + possible cooked-path delivery
  of CRC-failed frames; not a panic
- UNVERIFIED: stable@ mailing-list thread content (HTTP 403)

**YES**

 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 06f17da2c0106..17c9782915315 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -792,6 +792,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	if (rxinfo & MT_RXINFO_L2PAD)
 		pad_len += 2;
 
+	if (rxinfo & MT_RXINFO_CRCERR)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
 	if (rxinfo & MT_RXINFO_DECRYPT) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_MMIC_STRIPPED;
-- 
2.53.0

