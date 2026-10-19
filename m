Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E334604028;
	Mon, 19 Oct 2026 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418592; cv=none; b=C4jVz1ziPY7U6sE4N0CDU942g9PCPw2mNSgcGFDsgFaky3u4heaORYX/d9o8ZlbUkN3vgSdD9C8kTMhBcDx6CYp1aS//SrguTid2x3NOPMLC2jbSLBJN83HWEwBrPiOxc5PrX7oxGFsqK1821kvquhGU2eAmj7cxdgtPjCAvz0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418592; c=relaxed/simple;
	bh=L0cGnpkzfgU6MS2+uhl8PINua7jozjnL/npf5SYhkLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZXy6ukssbRyWel6sE1h4qi49DhRYmOWdahKVxH5Sydcu+MymLBwIlNA84Hf3Lah/4iid8M48QZEPqU7p0tpFJbggFwhA2J5Xe2oFKnrrRKF/FiV/P4SpSNi0Ou8lwDKmclLgvW0Kql2esUgw0NSOId8NzjYaXcxqdBHngmAnzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+G2BdjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+G2BdjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3D61F000CA;
	Mon, 19 Oct 2026 14:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418589;
	bh=hX+ZzV2E0bDSJBMzRqTbAutJVLZEfQz4z2BU1s2/mpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+G2BdjQEXXoOL2/KtEfyenEBfNYcNOe4E1Z0mr+Ob0MD6g62ii6pTZUt5XH7UWuu
	 T2nqx+OnlCkTcBPM2PBJpHPhY5APWXaq3FTLLnU0h6k/C6yLih3e9ovxYNHDqS3AKn
	 2cb9roLIWpeFl4FDgs48Fx2dj/76X4G2p5yOG+CZOkuPpBLtsDLVljY/WcaevKY4yT
	 Si+mhBensFd/2sloPS5swF7BtdZ1mMJlT3m4gbYZO32YC0fehk9fSmsrNI+wTnmg7G
	 Y3WA8V7wMFX4YgRMRsyobaYTGwvSi/HovWvwhcvnyojLHadvnSccR5YlFSYMkLZNuh
	 0X/E1kNXg085w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jjohnson@kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: ath12k: avoid setting 320MHz support on non 6GHz band
Date: Mon, 19 Oct 2026 09:50:46 -0400
Message-ID: <20261019135441.1420968-355-sashal@kernel.org>
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

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit eaf478b3ea68e1b5df659acd24c4df5850e12325 ]

On a split phy qcn9274 (2.4GHz + 5GHz low), "iw phy" reports 320MHz
related features on the 5GHz band while it should not:

    Wiphy phy1
    [...]
        Band 2:
    [...]
            EHT Iftypes: managed
    [...]
                EHT PHY Capabilities: (0xe2ffdbe018778000):
                    320MHz in 6GHz Supported
    [...]
                    Beamformee SS (320MHz): 7
    [...]
                    Number Of Sounding Dimensions (320MHz): 3
    [...]
                EHT MCS/NSS: (0x22222222222222222200000000):

This is also reflected in the beacons sent by a mesh interface started on
that band. They erroneously advertise 320MHz support too.

This should not happen as IEEE Std 802.11-2024, subclause 9.4.2.323.3 says
we should not set the 320MHz related fields when not operating on a 6GHz
band. For example it says about Bit 0 "Support For 320 MHz In 6 GHz"

  "Reserved if the EHT Capabilities element is indicating capabilities for
   the 2.4 GHz or 5 GHz bands."

Fix this by clearing the related bits when converting from WMI eht phy
capabilities to mac80211 phy capabilities, for bands other than 6GHz.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00218-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623151613.72113-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a 6.18.y tree (`v6.18.53`). The patch is a small ath12k
firmware-workaround that stops 5 GHz/2.4 GHz from advertising 6 GHz-only
320 MHz EHT bits, including in mesh beacons.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[ath12k / wifi] [avoid] [do not advertise 320 MHz EHT
  capabilities on non-6 GHz bands]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - No `Fixes:` tag (expected for this review; Qualcomm review of v2
    asked for one because the bug is user-visible, and v3 still omitted
    it)
  - No `Reported-by:`, `Tested-by:`, `Cc: stable`
  - `Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>`
  - `Reviewed-by: Rameshkumar Sundaram
    <rameshkumar.sundaram@oss.qualcomm.com>`
  - `Link: https://patch.msgid.link/20260623151613.72113-1-
    nico.escande@gmail.com`
  - `Signed-off-by: Nicolas Escande` (author)
  - `Signed-off-by: Jeff Johnson` (ath maintainer; applied to ath-next)
  - `Tested-on: QCN9274 hw2.0 PCI ...` (hardware test, not a tag)
  - Ignore `[Upstream commit eaf478b3ea68...]` and `Signed-off-by: Sasha
    Levin` (pipeline)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record: On split-phy QCN9274 (2.4 GHz + 5 GHz low), firmware-reported
  EHT PHY caps are copied onto the 5 GHz band, so `iw phy` shows “320MHz
  in 6GHz Supported”, beamformee SS 320 MHz, and 320 MHz sounding
  dimensions. Mesh beacons on that band advertise the same. IEEE
  802.11-2024 9.4.2.323.3 marks those fields reserved off 6 GHz.
- Symptom: wrong userspace capability dump and wrong over-the-air EHT
  Capabilities IE.
- Root cause: WMI EHT PHY caps are copied as-is; 320 MHz/6 GHz bits are
  not cleared for 2.4/5 GHz.
- Version info: none beyond QCN9274 test hardware.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not a disguised cleanup. It is an explicit correctness/spec
  fix (firmware workaround). “Avoid setting” here means “stop
  advertising reserved bits.”

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: Single file `drivers/net/wireless/ath/ath12k/wmi.c`, +16/−1.
  Function: `ath12k_wmi_eht_caps_parse()`. Surgical, one-driver.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Before: after `le32_to_cpu()` of firmware PHY caps, only the 6 GHz
  path ORs back a saved 320 MHz bit. 2.4/5 GHz keep whatever firmware
  sent, including 320 MHz/6 GHz bits.
- After: 6 GHz path unchanged; non-6 GHz path clears eight reserved 320
  MHz/6 GHz fields in the byte view of `eht_cap_phy_info[]`.
- Path: capability parse at firmware ready / MAC-PHY caps-ext, not a hot
  datapath.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: Category (h) firmware workaround + (g) protocol correctness.
- Mechanism: firmware reports 6 GHz/320 MHz caps on the 5 GHz WMI blob.
  Those bits are memcpy’d into mac80211 `ieee80211_sta_eht_cap`
  (`ath12k_mac_copy_eht_cap()`). `ieee80211_eht_mcs_nss_size()` adds 3
  MCS/NSS bytes when `IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ` is set, so
  5 GHz beacons can carry a longer EHT Capabilities IE than a spec-
  compliant peer expects. cfg80211 still refuses 320 MHz off 6 GHz
  (`net/wireless/chan.c`), so the kernel will not actually operate at
  320 MHz on 5 GHz.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: Obviously correct. Masks match
  `include/linux/ieee80211-eht.h`. `WMI_MAX_EHTCAP_PHY_SIZE` is 3 u32s
  (12 bytes); `phy_cap[7]` is in range. u8 overlay of a host-endian u32
  array matches existing ath12k memcpy of the same array into
  `phy_cap_info[]` (little-endian hosts, which is where QCN9274 runs).
  No API/lock/alloc change. Regression risk is low: only reserved bits
  on non-6 GHz are cleared. Review expanded v1’s incomplete mask set; v3
  clears the full set Qualcomm asked for.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: Function added in `1476014fadb662` (“wifi: ath12k: WMI support
  to process EHT capabilities”), contained in `v6.6-rc1`. 320 MHz
  preserve/OR logic added in `d4e244c85e45df` (“enable 320 MHz bandwidth
  for 6 GHz… WCN7850”), in v6.7. Buggy “copy firmware bits onto 5 GHz
  unchanged” behavior is as old as EHT parse in this driver (~v6.6).
  Present throughout 6.18.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Closest introducing commits are
  `1476014fadb662` and `d4e244c85e45df`; both are ancestors of `v6.18`.
  No later follow-up on this file after the upstream commit.

**Step 3.3: CHECK FILE HISTORY**
- Record: Nearby `wmi.c` work is unrelated (endianness, TLV length,
  scan). Standalone; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Nicolas Escande is a regular ath11k/ath12k contributor
  (Freebox/Iliad), not the subsystem maintainer. Jeff Johnson applied
  it. Qualcomm (Baochen Qiang, Rameshkumar Sundaram) reviewed.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: None. Uses existing `NL80211_BAND_*` and
  `IEEE80211_EHT_PHY_CAP*` symbols already in this tree. Applies
  standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `b4 dig -c eaf478b3ea68` →
  https://patch.msgid.link/20260623151613.72113-1-nico.escande@gmail.com
- Series: v1 (2026-01-23) → v2 (2026-06-11) → v3 (2026-06-23, applied).
  v1 incomplete masks; v2/v3 clear remaining 320 MHz/6 GHz fields after
  Qualcomm/Pablo feedback. v3 vs v2 is comment/typo/spec-citation
  cleanup.
- No NAKs. Jeff Johnson: “Applied, thanks!”
- No reviewer `Cc: stable` on v3.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record (`b4 dig -w`): To/Cc `ath12k@lists.infradead.org`, `linux-
  wireless@vger.kernel.org`. Reviewers: Rameshkumar Sundaram, Baochen
  Qiang (Qualcomm). Johannes Berg (mac80211) on v1: this is a firmware
  workaround and belongs in the driver, not mac80211. Pablo MARTIN-GOMEZ
  (Freebox) pointed out missing CAP7 bits.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla. Author reproduced on QCN9274 split-phy;
  `iw phy` dump and mesh beacons in the message. Real hardware, not
  theoretical.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Single-patch series. v1→v3 only refined which reserved bits to
  clear. No hidden dependency.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: No useful stable-list discussion of this subject. WebSearch of
  lore stable did not turn up this patch. UNVERIFIED beyond that (lore
  HTTP 403 on direct fetch; thread recovered via `b4`).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
- Record: `ath12k_wmi_eht_caps_parse()` only.

**Step 5.2: TRACE CALLERS**
- Record: Only from `ath12k_wmi_tlv_mac_phy_caps_ext_parse()` for 2.4 /
  5 / 6 GHz. That is called from `ath12k_wmi_tlv_mac_phy_caps_ext()`,
  registered as the WMI TLV parser for
  `WMI_TAG_MAC_PHY_CAPABILITIES_EXT` during service-ready. Device bring-
  up, not IRQ/hot path.

**Step 5.3: TRACE CALLEES**
- Record: `le32_to_cpu()` and bit clears only. No alloc/lock/IO.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: firmware ready → WMI caps-ext → `ath12k_mac_copy_eht_cap()` →
  mac80211 sband iftype data → `iw phy`, association, and beacon IEs.
  Reachable for any ath12k user with 11be firmware (QCN9274, WCN7850,
  etc.). Unprivileged users cannot trigger a crash; they do
  see/advertise wrong caps. Mesh/AP beacons go over the air.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: rtw89 and mt76 only *set* 320 MHz bits when `band ==
  NL80211_BAND_6GHZ`. mac80211 strips 320 MHz bits when `bw_limit <
  320`. ath12k was the outlier that trusted firmware on 5 GHz.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: Yes. Tree is `v6.18.53` (`VERSION=6 PATCHLEVEL=18
  SUBLEVEL=53`). `git merge-base --is-ancestor eaf478b3ea68 v6.18.53` is
  false — the fix is not in 6.18.53. Parent of the candidate still has
  the old if-only-6 GHz OR. `1476014fadb662` and `d4e244c85e45df` *are*
  in v6.18. Bug exists here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: Clean apply. Context in this tree matches (function at ~4937).
  All masks exist in `include/linux/ieee80211-eht.h`. Expected
  difficulty: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: No other commit in this tree clears these bits in
  `ath12k_wmi_eht_caps_parse()`. `ath12k_mac_filter_eht_cap_mesh()` only
  strips some CAP7 bits for mesh iftypes, not CAP0 320 MHz-in-6 GHz, so
  it does not replace this fix.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
- Record: `drivers/net/wireless/ath/ath12k` — Qualcomm Wi-Fi 7.
  Criticality: IMPORTANT (production Wi-Fi 7, not core mm/net).
  `CONFIG_ATH12K`.

**Step 7.2: SUBSYSTEM ACTIVITY**
- Record: Active (many 2026 ath12k WMI commits). This bug is old (v6.6),
  not a regression from brand-new code.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
- Record: ath12k users, especially split-phy QCN9274 5 GHz (author’s
  case) and any firmware that sets 320 MHz bits in the 2.4/5 GHz WMI
  blob. Not universal.

**Step 8.2: TRIGGER CONDITIONS**
- Record: Device probe / cap parse whenever firmware reports those bits.
  Common on affected SKUs. Unprivileged users do not get a kernel
  exploit; they get wrong `iw` output and wrong beacon IEs. Not a race.

**Step 8.3: FAILURE MODE SEVERITY**
- Record: Not a panic/UAF/deadlock. Kernel will not run 320 MHz on 5 GHz
  (`chan.c` requires 6 GHz; MLME 320 MHz limit is `is_6ghz && cap bit`).
  User impact is (1) wrong `iw phy`, (2) reserved bits in beacons, (3)
  extra 3-byte 320 MHz MCS/NSS field in the EHT Capabilities IE, which
  can confuse spec-compliant peers. Severity: MEDIUM (protocol/interop),
  not CRITICAL.

**Step 8.4: RISK-BENEFIT RATIO**
- Benefit: medium for QCN9274/mesh/AP users; stops malformed EHT IEs.
  Risk: very low (~15 lines, reserved-bit clears, reviewed, tested).
  Ratio: favorable.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

FOR:
- Real hardware bug (QCN9274), user-visible `iw phy` and mesh beacons
- Malformed EHT Capabilities IE (reserved bit + extra MCS/NSS bytes) —
  interoperability, not just cosmetics
- Small, obviously correct, constants and function exist in 6.18
- Reviewed by Qualcomm; applied by Jeff Johnson; Johannes agrees it is a
  driver firmware workaround
- No new API; no prerequisites missing in this tree
- Analogous to a hardware/firmware quirk

AGAINST:
- Not a crash, leak, UAF, deadlock, or CVE
- Johannes noted most extra 320 MHz bits are unused at runtime; cfg80211
  already blocks 320 MHz off 6 GHz
- Author never added `Fixes:` even after Rameshkumar asked
- Affects one driver / specific firmware behavior

UNRESOLVED:
- Direct lore.kernel.org HTTP fetch returned 403; discussion recovered
  via `b4` mbox
- No stable-list thread found

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — masks match the spec;
   Tested-on QCN9274; two Qualcomm Reviewed-by
2. Fixes a real bug that affects users? **PASS** — observed wrong caps
   and wrong beacons
3. Important issue? **PASS** (medium) — OTA IE malformation/interop on
   Wi-Fi 7 APs/mesh, not a crash. Within “etc.” for driver protocol bugs
   / firmware quirks
4. Small and contained? **PASS** — 16 insertions, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code and symbols present;
   clean apply

**Step 9.3: EXCEPTION CATEGORIES**
- Record: Firmware/hardware workaround (quirk-like). Not a new device
  ID, DT, or build fix.

**Step 9.4: DECISION**
Backport to this 6.18.y tree. The bug is in 6.18, the fix is surgical,
and wrong EHT IEs on 5 GHz are a real user-visible protocol defect on
shipping QCN9274 hardware.

---

Verification:
- [Phase 1] Parsed tags: Reviewed-by Baochen Qiang, Rameshkumar
  Sundaram; Link msgid; Tested-on QCN9274; no Fixes/Reported-
  by/Cc:stable
- [Phase 1] Body: split-phy QCN9274 `iw phy` + mesh beacons advertise
  320 MHz on 5 GHz; IEEE 802.11-2024 9.4.2.323.3 reserved-bit citation
- [Phase 2] Diff: `ath12k_wmi_eht_caps_parse()` +16/−1; else-branch
  clears 8 reserved PHY bits
- [Phase 2] `WMI_MAX_EHTCAP_PHY_SIZE == 3` (12 bytes); `phy_cap[7]` in
  bounds (`wmi.h:2767`)
- [Phase 2] Masks verified in `include/linux/ieee80211-eht.h` (CAP0
  0x02, CAP1 0xe0, CAP2 0xc0, CAP3 0x01, CAP6 MCS15 0x40 / DUP 0x80,
  CAP7 0x08 / 0x40)
- [Phase 3] `git blame`: function `1476014fadb662` (v6.6-rc1); 320 MHz
  OR `d4e244c85e45df` (v6.7)
- [Phase 3] `git merge-base --is-ancestor 1476014fadb662 v6.18` and
  `d4e244c85e45df v6.18`: both true
- [Phase 3] No `Fixes:` tag; no follow-up on `wmi.c` after upstream
  `eaf478b3ea68`
- [Phase 4] `b4 dig -c eaf478b3ea68`: lore URL; v1/v2/v3; v3 applied as
  `eaf478b3ea68`
- [Phase 4] `b4 dig -w`: ath12k + linux-wireless lists
- [Phase 4] v1 mbox: Johannes — firmware workaround, belongs in driver;
  Pablo — missing CAP7; Rameshkumar — also clear CAP3/CAP6 DUP/CAP7
- [Phase 4] v2 mbox: Rameshkumar asked for `Fixes:` because it is user-
  visible; author did not add it in v3
- [Phase 4] v3 mbox: both Qualcomm Reviewed-by; Jeff Johnson applied; no
  NAK; no Cc:stable
- [Phase 4] lore WebFetch 403; thread read from `b4 dig -m` / `b4 mbox`
- [Phase 5] Callers: only `ath12k_wmi_tlv_mac_phy_caps_ext_parse` → WMI
  service-ready. Impact via `ath12k_mac_copy_eht_cap` /
  `ath12k_mac_copy_eht_mcs_nss` (320 MHz MCS copy gated on CAP0 bit)
- [Phase 5] `ieee80211_eht_mcs_nss_size()` adds 3 bytes when CAP0 320
  MHz bit is set — IE length bug on 5 GHz
- [Phase 5] `net/wireless/chan.c`: 320 MHz rejected unless band is 6 GHz
  — no local 320 MHz operation on 5 GHz
- [Phase 6] `git describe HEAD`: `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion`: 6.18.53
- [Phase 6] `git merge-base --is-ancestor eaf478b3ea68 v6.18.53`: false
  — fix not in 6.18.53
- [Phase 6] Parent of candidate still has old if-only-6 GHz code;
  constants present
- [Phase 7] Subsystem ath12k, CONFIG_ATH12K, important Wi-Fi 7 driver
- [Phase 8] Failure mode: wrong IEs / interop, not oops; severity
  MEDIUM; backport risk very low
- UNVERIFIED: no independent user bugzilla beyond the author’s QCN9274
  report; stable@ lore search did not find this patch

The fix is small, already reviewed, and addresses a real over-the-air
capability bug that exists in this 6.18 tree.

**YES**

 drivers/net/wireless/ath/ath12k/wmi.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index ade14ba6703f3..39d5110eca901 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4939,6 +4939,7 @@ static void ath12k_wmi_eht_caps_parse(struct ath12k_pdev *pdev, u32 band,
 				       __le32 cap_info_internal)
 {
 	struct ath12k_band_cap *cap_band = &pdev->cap.band[band];
+	u8 *phy_cap = (u8 *)&cap_band->eht_cap_phy_info[0];
 	u32 support_320mhz;
 	u8 i;
 
@@ -4952,8 +4953,22 @@ static void ath12k_wmi_eht_caps_parse(struct ath12k_pdev *pdev, u32 band,
 	for (i = 0; i < WMI_MAX_EHTCAP_PHY_SIZE; i++)
 		cap_band->eht_cap_phy_info[i] = le32_to_cpu(cap_phy_info[i]);
 
-	if (band == NL80211_BAND_6GHZ)
+	if (band == NL80211_BAND_6GHZ) {
 		cap_band->eht_cap_phy_info[0] |= support_320mhz;
+	} else {
+		/*
+		 * Firmware may report 6 GHz/320 MHz specific capabilities for
+		 * non-6 GHz bands, so explicitly clear them.
+		 */
+		phy_cap[0] &= ~IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ;
+		phy_cap[1] &= ~IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK;
+		phy_cap[2] &= ~IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_320MHZ_MASK;
+		phy_cap[3] &= ~IEEE80211_EHT_PHY_CAP3_SOUNDING_DIM_320MHZ_MASK;
+		phy_cap[6] &= ~IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_320MHZ;
+		phy_cap[6] &= ~IEEE80211_EHT_PHY_CAP6_EHT_DUP_6GHZ_SUPP;
+		phy_cap[7] &= ~IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_320MHZ;
+		phy_cap[7] &= ~IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_320MHZ;
+	}
 
 	cap_band->eht_mcs_20_only = le32_to_cpu(supp_mcs[0]);
 	cap_band->eht_mcs_80 = le32_to_cpu(supp_mcs[1]);
-- 
2.53.0

