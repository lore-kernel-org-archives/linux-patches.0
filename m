Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692435A894F;
	Mon, 31 Aug 2026 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184352; cv=none; b=dVdApjIbyEaaAdsa1y9LZHU3nNyszo5uqyh2Zc2T/J5cYaFcFqi9xX2U/LE6KVPs5p7J+g+Ke4HSqWIVorebGVGiB7t/olfo5egnt/TBp5WetzNDdxEl7K2vgNabqBuGu+/FoVuK2EYiCEmhhCE3f93QFlVXn2gCizJ3kg833QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184352; c=relaxed/simple;
	bh=+95dPHh49wA7tjUVY8TfM4AwzprYXtS12gPatx3slwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mTtyHwW001URyCmgVBh2x7PcWRMP4unoazNLwa0CtI1khEWaom0FXCKlmPZxZctx44Gm/YbxpdYO7qUxUNXBvGy61FP+MVpejkC/uS1LK5zODGpV8owMH9PKcf8JEaR8JKeeWvwZh2p9ZCGKd5sDbxCG+tvtbdFpfDJGyxTOauw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TORyXIPY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TORyXIPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6942E1F00A3D;
	Mon, 31 Aug 2026 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184350;
	bh=kdNtiSQAnxOoxykdOmKhKtFC3XRXHyDeV1PknoxHvm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TORyXIPY2BQKwNT3y6cfYQV5nIvFIYJWKZGhvt/yWSe5cGoZ38x1fSnfaHSIHo7t3
	 J+qMrfxJuyBT/UhbDxH96pJg+AfbyzO+CkPbbOZNvKP5maGPbMHQZx7099wSg49hqv
	 RCibPzMdaYpMGAcsctFiSYMqnW1TLy/8JkDaJmmWfPkhY0kD52t2Vzx24F117QY8c9
	 dcMh6fIcSdowfhOqCG3G2RzemDzJ0gztD0oa+bQqAaECUlNUYlD1WMRk8FpdM3mLFK
	 qebYL+PskEXeE/orisT7UvFL5tx0IsW03J6vw3L4rdlLTawIzO886446rNgKRpt0A7
	 q2kCTkjGcbiBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ElXreno <elxreno@gmail.com>,
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
Subject: [PATCH AUTOSEL 6.18] wifi: mt76: route TDLS-peer frames as 3-addr non-DS in HW encap
Date: Mon, 31 Aug 2026 09:31:09 -0400
Message-ID: <20260831133314.4125787-641-sashal@kernel.org>
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

From: ElXreno <elxreno@gmail.com>

[ Upstream commit 5b7154f934c4c1b86e0fbfd95ad570a25bd08662 ]

With HW TX encap offload enabled, the mt76 firmware builds the 802.11
header for the 802.3 frame using the per-WCID context. For a STATION
vif the HDR_TRANS TLV currently sets ToDS=1, which makes the firmware
default to the BSSID as A1 and emit STA->AP-formatted frames
regardless of which peer the WCID points to.

For TDLS-paired peers this is wrong. Data frames go on air addressed
to the AP, the AP MAC-ACKs and silently drops them per IEEE 802.11z
(an AP must not forward to a TDLS-paired peer). Management and
control frames bypass the HW encap path and still reach the peer;
only user data fails.

Add MT_WCID_FLAG_TDLS_PEER, set it in mt7915, mt7921, mt7925 and
mt7996 sta-add paths when sta->tdls is true, and override the
HDR_TRANS TLV in mt76_connac_mcu_wtbl_hdr_trans_tlv() (Connac2 -
mt7915 / mt7921 / mt7922), mt7925_mcu_sta_hdr_trans_tlv() (mt7925)
and mt7996_mcu_sta_hdr_trans_tlv() (mt7996) to set ToDS=0, FromDS=0
when the flag is set. The 3-addr non-DS form matches what 802.11z
uses for direct links; the firmware then constructs the frame with
A1=peer rather than A1=BSSID. HW encap offload remains enabled for
AP and any non-TDLS traffic.

Verified on mt7925e + Samsung S938B over a 5 GHz HE 80 MHz channel
with iperf3 -t 30 to the TDLS peer:

  before fix:  over the TDLS direct link, 7 TDLS Setup action
               frames and 3 RTS frames reach the peer; 0 QoS
               Data frames make it through (mgmt/control paths
               bypass HW encap, the data path does not). iperf3
               stalls.
  after fix:   2.90 GBytes transferred at 830 Mbit/s sustained,
               0 TCP retransmits.

mt7915, mt7921, mt7922 and mt7996 are not regression-tested in this
change for lack of hardware. Their HDR_TRANS handling mirrors the
verified mt7925 change; the firmware behavior is shared across these
chips.

Signed-off-by: ElXreno <elxreno@gmail.com>
Assisted-by: Claude:claude-opus-4-7 bpftrace tcpdump
Link: https://patch.msgid.link/20260506-mt7925-tdls-fixes-v2-1-46aa826ba8bb@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[wifi: mt76]` `[route]` — Route TDLS-peer frames as 3-address
non-distribution-system (non-DS) frames in hardware TX encapsulation
offload.

**Step 1.2 — Tags**

Record:
- **Signed-off-by:** ElXreno `<elxreno@gmail.com>` (author)
- **Assisted-by:** Claude:claude-opus-4-7 bpftrace tcpdump
- **Link:** https://patch.msgid.link/20260506-mt7925-tdls-
  fixes-v2-1-46aa826ba8bb@gmail.com
- **Signed-off-by:** Felix Fietkau `<nbd@nbd.name>` (mt76 maintainer)
- No `Fixes:` tag
- No `Cc: stable@vger.kernel.org` on the committed version (author
  dropped it in v2; see Phase 4)
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, or `Acked-by:`

**Step 1.3 — Body analysis**

Record:
- **Bug:** With HW TX encap offload, the HDR_TRANS TLV sets `ToDS=1` for
  all STATION vif WCIDs. Firmware therefore builds frames with A1=BSSID
  even for TDLS-peer WCIDs.
- **Symptom:** TDLS data frames are sent to the AP, MAC-ACKed, and
  silently dropped per IEEE 802.11z. Management/control frames still
  work (they bypass HW encap). iperf3 stalls; 0 QoS Data frames reach
  the peer.
- **Root cause:** Incorrect 802.11 header format (STA→AP / ToDS) used
  for TDLS direct-link peers that require 3-addr non-DS (ToDS=0,
  FromDS=0, A1=peer).
- **Fix:** Add `MT_WCID_FLAG_TDLS_PEER`, set on `sta->tdls` in sta-add
  paths, override HDR_TRANS TLV to ToDS=0/FromDS=0 for flagged peers.
- **Verification:** mt7925e + Samsung S938B, iperf3: before = 0 data
  frames; after = 2.90 GBytes at 830 Mbit/s, 0 TCP retransmits.

**Step 1.4 — Hidden bug fix?**

Record: **Yes** — despite the subject using "route" rather than "fix",
this is a clear functional bug fix. TDLS user data is completely non-
functional under HW encap offload.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **8 files, +28 lines, 0 deletions**
- `mt76.h`: +1 enum value `MT_WCID_FLAG_TDLS_PEER`
- `mt76_connac_mcu.c`: +5 lines in
  `mt76_connac_mcu_wtbl_hdr_trans_tlv()`
- `mt7915/main.c`, `mt7921/main.c`, `mt7925/main.c`, `mt7996/main.c`: +3
  lines each in sta-add paths (`set_bit` when `sta->tdls`)
- `mt7925/mcu.c`, `mt7996/mcu.c`: +5 lines each in per-chip HDR_TRANS
  TLV helpers
- **Scope:** Multi-file but surgical; same pattern repeated per chip
  generation.

**Step 2.2 — Code flow per hunk**

Record:
- **Before:** STATION vif always gets `to_ds=true` in HDR_TRANS TLV →
  firmware addresses all frames to BSSID.
- **After:** TDLS-peer WCIDs get `to_ds=false, from_ds=false` → firmware
  builds 3-addr non-DS frames with A1=peer MAC.
- **Execution path:** STA add (sets flag) → MCU WTBL/STA_REC update
  (programs firmware) → every subsequent HW-encapsulated TX data frame
  to TDLS peer.

**Step 2.3 — Bug mechanism**

Record: **Category (g) — Logic/correctness fix.** Wrong 802.11
addressing mode programmed into firmware for TDLS-peer WCIDs. Not
UAF/leak/race; a firmware-facing configuration error causing silent
packet loss.

**Step 2.4 — Fix quality**

Record: **Obviously correct** — matches IEEE 802.11z TDLS direct-link
frame format. Minimal, mirrors existing 4-addr override pattern. **Low
regression risk** — only affects WCIDs with `sta->tdls` set; AP and
normal STA traffic unchanged. TDLS override runs after 4-addr check, so
no conflict.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Buggy `to_ds=true` for STATION vif introduced in `868fe07ee612f`
("mt76: connac: add missing configuration in
mt76_connac_mcu_wtbl_hdr_trans_tlv", May 2021). Present in this tree
since connac2 era. `MT_WCID_FLAG_HDR_TRANS` added Dec 2020
(`90e3abf07c80a`).

**Step 3.2 — Fixes: tag**

Record: N/A — no `Fixes:` tag in committed version. v1 referenced
`5c14a5f944b9`; author dropped it in v2 because the approach changed
entirely.

**Step 3.3 — Related file history**

Record:
- TDLS enabled in mt76 since `dd89a0133c0ce` (May 2020): "mt76: enable
  TDLS support"
- Sibling fix from same series already in this tree: `a7cdc384c9c57`
  ("wifi: mt76: mt7925: don't disable AP BSS when removing TDLS peer") —
  backported by Greg Kroah-Hartman to 6.18.44
- Upstream commit: `5b7154f934c4c` (Jun 9, 2026) — **NOT yet in this
  tree**
- Part of v2 series "wifi: mt76: fix TDLS direct-link on MediaTek
  MT7925" (2 patches)

**Step 3.4 — Author context**

Record: ElXreno authored both TDLS fixes in the series. Felix Fietkau
(mt76 maintainer) committed and signed off. MediaTek developers (Sean
Wang, Shayne Chen, etc.) were CC'd on submission.

**Step 3.5 — Dependencies**

Record: **Standalone.** No prerequisite commits required. All target
functions, `sta->tdls` field, and affected drivers exist in 6.18.44.
Cherry-pick applies cleanly with zero conflicts.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c 5b7154f934c4c` →
  https://patch.msgid.link/20260506-mt7925-tdls-
  fixes-v2-1-46aa826ba8bb@gmail.com
- Series: v1 (May 3) disabled all HW encap for TDLS; v2 (May 6) per-peer
  flag approach after Sean Wang's v1 NACK
- Cover letter CC'd `stable@vger.kernel.org`; patch 1 explicitly dropped
  `Cc: stable` in v2 ("not realistic for a clean cherry-pick into older
  stables")
- Patch 2 retained `Cc: stable@vger.kernel.org` and was backported to
  this tree

**Step 4.2 — Reviewers**

Record: `b4 dig -w` — To: Felix Fietkau, Lorenzo Bianconi, Ryder Lee,
Shayne Chen, Sean Wang, Matthias Brugger, and others. Appropriate
maintainers and mailing lists included. No explicit `Reviewed-
by`/`Acked-by` in committed version; maintainer merge + sign-off is the
quality gate.

**Step 4.3 — Bug report**

Record: No syzbot/bugzilla. Hardware reproduction documented in commit
message and cover letter (Samsung phone auto-TDLS, bpftrace/tcpdump
evidence).

**Step 4.4 — Series context**

Record: 2-patch series. Patch 1 (this commit) = TDLS data path broken.
Patch 2 (`a7cdc384c9c57`) = TDLS teardown collapses AP RX rate. **Patch
2 already backported to 6.18.44 without patch 1** — users get teardown
fix but TDLS data still fails on HW encap.

**Step 4.5 — Stable list history**

Record: Cover letter and patch 2 explicitly nominated for stable. Patch
1's stable nomination was deliberately removed in v2, but stable
maintainers already accepted the series (patch 2 landed). For 6.18.44
specifically, cherry-pick is clean (unlike "older stables" the author
was concerned about).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `mt76_connac_mcu_wtbl_hdr_trans_tlv()`,
`mt7925_mcu_sta_hdr_trans_tlv()`, `mt7996_mcu_sta_hdr_trans_tlv()`,
`mt7915_mac_sta_add()`, `mt7921_mac_sta_add()`,
`mt7925_mac_link_sta_add()`, `mt7996_mac_sta_init_link()`.

**Step 5.2 — Callers**

Record:
- HDR_TRANS TLV helpers called from MCU STA_REC/WTBL update paths during
  sta-add and `sta_set_decap_offload()` (when mac80211 toggles HW encap
  offload via `MT_WCID_FLAG_HDR_TRANS`)
- Sta-add functions called from mac80211 `sta_state` transitions when
  TDLS peers are added
- All affected drivers (mt7915, mt7921, mt7925, mt7996) register
  `sta_set_decap_offload` callbacks

**Step 5.3 — Callees**

Record: `test_bit()`, `set_bit()` on `wcid->flags`; MCU TLV construction
sent to firmware via `mt76_mcu_skb_send_msg()` /
`mt76_connac_mcu_sta_update_hdr_trans()`.

**Step 5.4 — Reachability**

Record: **Userspace-reachable** — TDLS setup via standard
nl80211/cfg80211 (e.g., Samsung phones auto-initiate TDLS on shared
BSS). Once TDLS link is up and HW encap is enabled, every data frame to
the TDLS peer hits the buggy path. Trigger requires TDLS-capable peer +
HW encap offload (default on mt7921/mt7925 with
`sta_set_decap_offload`).

**Step 5.5 — Similar patterns**

Record: Existing `MT_WCID_FLAG_4ADDR` override in the same functions
sets `to_ds=true, from_ds=true`. TDLS fix follows identical pattern with
opposite values. Consistent with driver conventions.

---

## Phase 6: Cross-Referencing Against Local Tree

**Step 6.1 — Buggy code in tree?**

Record: **YES.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44`). Buggy code at `mt76_connac_mcu.c:480-492`,
`mt7925/mcu.c:1082-1104`, `mt7996/mcu.c:1930-1948`. No
`MT_WCID_FLAG_TDLS_PEER` anywhere. `sta->tdls` field exists in
`mac80211.h`. All four affected drivers present (mt7925 since
`c948b5da6bbec`, confirmed ancestor of HEAD).

**Step 6.2 — Backport complications**

Record: **Clean apply.** `git cherry-pick --no-commit 5b7154f934c4c`
succeeds with auto-merge on all 8 files, +28 lines, exit 0.

**Step 6.3 — Related fixes already present?**

Record: Sibling fix `a7cdc384c9c57` (patch 2/2) already backported. This
fix (patch 1/2) is **missing**. No alternate fix for the HDR_TRANS/TDLS
data path issue.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**

Record: **IMPORTANT** — `drivers/net/wireless/mediatek/mt76/` WiFi
drivers. mt7921 is one of the most common laptop WiFi chips; mt7925 is
newer WiFi 7. Affects connectivity for TDLS users, not core kernel
paths.

**Step 7.2 — Subsystem activity**

Record: Actively maintained — recent commits in mt7925/mt7996 in this
tree (NULL deref fixes, MLO work, etc.).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: **Driver-specific, config-specific** — users of
mt7915/mt7921/mt7922/mt7925/mt7996 with TDLS direct links and HW TX
encap offload enabled. Not universal, but mt7921/mt7925 have large
installed base.

**Step 8.2 — Trigger conditions**

Record: TDLS peer established (`sta->tdls=true`) + HW encap offload
active (`MT_WCID_FLAG_HDR_TRANS` set via `sta_set_decap_offload`).
Samsung phones and other auto-TDLS peers are documented triggers.
Unprivileged users on same BSS can initiate TDLS with a vulnerable
station.

**Step 8.3 — Failure mode severity**

Record: **Complete TDLS data path failure** — 0 user data frames
delivered; iperf/TCP stalls. Management frames work, so TDLS setup
appears successful (misleading). Not kernel crash/oops/corruption.
Severity: **HIGH functional** (not CRITICAL security/crash).

**Step 8.4 — Risk-benefit**

Record:
- **Benefit: HIGH** for TDLS users — restores entire direct-link data
  path; verified 830 Mbit/s throughput post-fix
- **Risk: VERY LOW** — 28 lines, scoped to TDLS-peer WCIDs only,
  maintainer-reviewed, clean cherry-pick
- **Ratio: Strongly favorable**

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real, reproducible bug with hardware verification
- Complete TDLS data failure (not cosmetic)
- Small, surgical, obviously correct fix
- Applies cleanly to 6.18.44
- Maintainer (Felix Fietkau) signed off and merged
- Sibling patch from same series already backported to this exact tree
- Buggy code present since 2021; all prerequisites in tree
- Follows existing 4-addr override pattern

**AGAINST backport:**
- Not crash/security/data-corruption
- TDLS is a niche feature vs. normal STA→AP traffic
- Author dropped `Cc: stable` from patch 1 (concern about older trees,
  not 6.18.y)
- mt7915/mt7921/mt7996 not hardware-regression-tested (only mt7925
  verified)

**Unresolved:** No independent `Tested-by` beyond author.
mt7915/7921/7996 correctness inferred from shared firmware behavior.

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — 802.11z-correct;
hardware-tested on mt7925e |
| 2. Fixes real bug affecting users? | **PASS** — TDLS data completely
non-functional |
| 3. Important issue? | **PASS** — complete feature breakage on common
hardware (functional HIGH, not crash-level CRITICAL) |
| 4. Small and contained? | **PASS** — 28 lines, 8 files, no refactoring
|
| 5. No new features/APIs? | **PASS** — internal driver flag only |
| 6. Can apply to local tree? | **PASS** — clean cherry-pick verified |

**Step 9.3 — Exception categories**

Record: N/A — not device ID, quirk, DT, build fix, or docs fix. Standard
driver bug fix.

**Step 9.4 — Decision rationale**

This fix should be backported to **Linux 6.18.44**. The buggy HDR_TRANS
configuration exists in this tree, the upstream fix cherry-picks
cleanly, and the stable tree already carries patch 2/2 from the same
TDLS series without patch 1/2 — leaving TDLS data broken even after the
teardown fix. For users with MediaTek WiFi and TDLS peers (including
auto-TDLS from phones), HW encap offload produces frames addressed to
the AP instead of the peer; the result is a silent, total loss of TDLS
data throughput. The fix is minimal, maintainer-approved, and low-risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes/Cc:stable/Reported-by
  on committed version
- [Phase 1] Confirmed hidden bug fix — functional TDLS data path failure
- [Phase 2] Diff inventory: 8 files, +28 lines; logic/correctness bug in
  HDR_TRANS TLV
- [Phase 3] `git describe HEAD` → v6.18.44
- [Phase 3] `git blame` → buggy to_ds logic from 868fe07ee612f (May
  2021)
- [Phase 3] `git log --grep=TDLS` → TDLS since dd89a0133c0ce (2020);
  sibling a7cdc384c9c57 in tree
- [Phase 3] Upstream commit 5b7154f934c4c confirmed NOT in HEAD
- [Phase 3] Cherry-pick test → clean apply, exit 0, +28 lines
- [Phase 4] `b4 dig -c 5b7154f934c4c` → lore URL found
- [Phase 4] `b4 dig -a` → v1→v2 series; v2 per-peer flag after Sean Wang
  NACK on v1
- [Phase 4] `b4 dig -w` → Felix Fietkau, Lorenzo Bianconi, MediaTek devs
  CC'd
- [Phase 4] Mbox cover letter → stable CC'd; patch 1 dropped Cc:stable
  in v2
- [Phase 4] `a7cdc384c9c57` → patch 2/2 backported to 6.18.44 by Greg
  K-H
- [Phase 5] `grep MT_WCID_FLAG_HDR_TRANS` → set via
  sta_set_decap_offload on all affected drivers
- [Phase 5] `grep sta->tdls` → used in mt7925/mt7921/mt7615 main.c
  already
- [Phase 5] `mac80211.h:2530` → `bool tdls` field confirmed
- [Phase 6] `grep MT_WCID_FLAG_TDLS_PEER` → 0 matches (fix absent)
- [Phase 6] Buggy code confirmed at mt76_connac_mcu.c:480-492,
  mt7925/mcu.c:1082-1104, mt7996/mcu.c:1930-1948
- [Phase 6] mt7925 driver ancestor check → present in tree
- [Phase 8] Failure mode: 0 TDLS data frames, iperf stalls — HIGH
  functional severity

**YES**The background searches finished and matched what the full
analysis already used:

- **Upstream commit:** `5b7154f934c4c` on master — "wifi: mt76: route
  TDLS-peer frames as 3-addr non-DS in HW encap"
- **In 6.18.44:** that fix is **not** present; sibling patch
  `a7cdc384c9c57` (TDLS teardown / BSS disable) **is** already
  backported
- **Author search:** only ElXreno's patch 2/2 shows up in this stable
  tree so far

**Verdict stands: YES** — this should be backported to 6.18.y. It
cherry-picks cleanly (+28 lines, 8 files) and closes the gap where patch
2 is in stable but TDLS data over HW encap is still broken.

 drivers/net/wireless/mediatek/mt76/mt76.h            | 1 +
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt7915/main.c     | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7921/main.c     | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7925/main.c     | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c      | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt7996/main.c     | 3 +++
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c      | 5 +++++
 8 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 125ac1eb2d541..e4e92b0e7f698 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -348,6 +348,7 @@ enum mt76_wcid_flags {
 	MT_WCID_FLAG_PS,
 	MT_WCID_FLAG_4ADDR,
 	MT_WCID_FLAG_HDR_TRANS,
+	MT_WCID_FLAG_TDLS_PEER,
 };
 
 #define MT76_N_WCIDS 1088
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 2aa7b711c774e..9a81040e19007 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -490,6 +490,11 @@ void mt76_connac_mcu_wtbl_hdr_trans_tlv(struct sk_buff *skb,
 		htr->to_ds = true;
 		htr->from_ds = true;
 	}
+
+	if (test_bit(MT_WCID_FLAG_TDLS_PEER, &wcid->flags)) {
+		htr->to_ds = false;
+		htr->from_ds = false;
+	}
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_wtbl_hdr_trans_tlv);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 6f594677474b0..ebfd5282db2ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -760,6 +760,9 @@ int mt7915_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	msta->wcid.phy_idx = ext_phy;
 	msta->jiffies = jiffies;
 
+	if (sta->tdls)
+		set_bit(MT_WCID_FLAG_TDLS_PEER, &msta->wcid.flags);
+
 	ewma_avg_signal_init(&msta->avg_ack_signal);
 
 	mt7915_mac_wtbl_update(dev, idx,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index ce11666a32db9..da49c0ed7d109 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -828,6 +828,9 @@ int mt7921_mac_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	msta->deflink.last_txs = jiffies;
 	msta->deflink.sta = msta;
 
+	if (sta->tdls)
+		set_bit(MT_WCID_FLAG_TDLS_PEER, &msta->deflink.wcid.flags);
+
 	ret = mt76_connac_pm_wake(&dev->mphy, &dev->pm);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 910713e62e14a..e0e4e31a851d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -870,6 +870,9 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 	mlink->wcid.link_valid = !!link_sta->sta->valid_links;
 	mlink->sta = msta;
 
+	if (link_sta->sta->tdls)
+		set_bit(MT_WCID_FLAG_TDLS_PEER, &mlink->wcid.flags);
+
 	wcid = &mlink->wcid;
 	ewma_signal_init(&wcid->rssi);
 	rcu_assign_pointer(dev->mt76.wcid[wcid->idx], wcid);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 647efa963db48..18efcfa614400 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1102,6 +1102,11 @@ mt7925_mcu_sta_hdr_trans_tlv(struct sk_buff *skb,
 		hdr_trans->to_ds = true;
 		hdr_trans->from_ds = true;
 	}
+
+	if (test_bit(MT_WCID_FLAG_TDLS_PEER, &wcid->flags)) {
+		hdr_trans->to_ds = false;
+		hdr_trans->from_ds = false;
+	}
 }
 
 int mt7925_mcu_wtbl_update_hdr_trans(struct mt792x_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 20da0c10669a9..945646f99e5db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1018,6 +1018,9 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	msta_link->wcid.link_valid = !!sta->valid_links;
 	msta_link->wcid.def_wcid = &msta->deflink.wcid;
 
+	if (link_sta->sta->tdls)
+		set_bit(MT_WCID_FLAG_TDLS_PEER, &msta_link->wcid.flags);
+
 	ewma_avg_signal_init(&msta_link->avg_ack_signal);
 	ewma_signal_init(&msta_link->wcid.rssi);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 72851399575f9..e5ad169dd15fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1946,6 +1946,11 @@ mt7996_mcu_sta_hdr_trans_tlv(struct mt7996_dev *dev, struct sk_buff *skb,
 		hdr_trans->from_ds = true;
 		hdr_trans->mesh = true;
 	}
+
+	if (test_bit(MT_WCID_FLAG_TDLS_PEER, &wcid->flags)) {
+		hdr_trans->to_ds = false;
+		hdr_trans->from_ds = false;
+	}
 }
 
 static enum mcu_mmps_mode
-- 
2.53.0

