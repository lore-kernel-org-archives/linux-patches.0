Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428CB538748;
	Mon, 19 Oct 2026 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418175; cv=none; b=PeAOu4kXSut+qo02yksOdtd/YONRS7NiEx7lLdYGF4IvmgDlbPI2h/PjXhC4eVmI78XxLhbBEXmfbAY/VG5Y/l2+aBDkcUv/orc8vtLovU03Y9C4US8wscwQv8YjHJ2yydWehF/sFLmkXdl2Bb1Dict9Lp2xfKfQPkULUjOCfZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418175; c=relaxed/simple;
	bh=ojKbfTfbjoT+pOmAsSpXrKEufsS1a47lgmJwSDSoZJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCSM8ZvDybOxN1MT6QvkG0GPVjt/AX1Gx6D+Zo0FqEnqslW1H7xjA9NUpc69oZp/chuPIAqlId9VsFUrD61vn1nZ3hiQPbbVxMH11zgv3YiSaT018LU9pG3mH2QPPm65PvywXkLRqV78x0r4h3+8sIu8b+01VR/7ru1RqWdzc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPbznKCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPbznKCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A32D1F000C8;
	Mon, 19 Oct 2026 13:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418173;
	bh=cafnEB8iBQJmsk1xd6L3vlvyLfpoK8rRBYgY6/Qxe8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPbznKCY3BkVUma8CpKNV4jXzDR3s0pgfZMzAiDyhRcnHvfWCJZiCQjcYhZaAhU1/
	 vRK6Pmp1ntBGl+IQFrrr8+SYbdqU+3JujtkgWnwTJOwalpychyLaGqNfzRr88xBB4E
	 8Y8ipMQF6ocLdR3APBEg0BTw7BBNLz2JzuuQTuS/R5l09PUQebcAW2XqSNNaKUspz/
	 DsHhi8CRPcLbf3pFHGndyPtOrA2V+D3m0clTw4AiUvhnl1sWMngCEm2qGuffvQ/obG
	 Fv+fbyaiZKqNVcVeusLaca9PrTX1fk2TDlbdYPmxkibzaipZw2i3iz7L2swL4tbO4e
	 OvQv8sSklwJ7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: William Hansen-Baird <william.hansen.baird@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding
Date: Mon, 19 Oct 2026 09:45:55 -0400
Message-ID: <20261019135441.1420968-64-sashal@kernel.org>
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

From: William Hansen-Baird <william.hansen.baird@gmail.com>

[ Upstream commit 04a46c2dbf3b516c96a1d19b72917b56055ad6c1 ]

commit 77a6407c6ab2 ("wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 11ad:1723")
adds code which sets ppsc->support_aspm to false in
_rtl_pci_update_default_setting() in order to disable ASPM.
This does not, however, disable ASPM. Rather, it disables driver
control of ASPM, and blocks calls to rtl_pci_enable_aspm()
and rtl_pci_disable_aspm().

In some cases, the pci device supplied to the probe function has
ASPM enabled. The code would therefore not disable ASPM, as it means to,
but rather just leave it enabled.
This was discovered through testing on a Razer Blade 14 2017.

Implement a new __rtl_pci_disable_aspm(hw) function which does not check
ppsc->support_aspm before disabling and call it from
rtl_pci_disable_aspm().

Then move the code added in the previous commit to rtl_pci_init_aspm() to
allow adding a call to __rtl_pci_disable_aspm(hw).
This makes sure ASPM is disabled while still disabling
driver control of ASPM to block it from being enabled later.

Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260630141553.785769-2-william.hansen.baird@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **7.3.0-rc4**. The original incomplete RTL8723BE ASPM
quirk is in this lineage; this commit is a small, tested hardware-quirk
fix that actually clears ASPM instead of only blocking driver control.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE

Record: `[wifi: rtlwifi:] [fix] [ASPM disable for RTL8723BE with AER
flooding actually takes effect]`

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS

Record:
- No `Fixes:` tag (v3 cover letter: “Removed misleading Fixes tag from
  patch 1”)
- No `Reported-by:` / `Tested-by:` on this commit (testing is described
  in the body: Razer Blade 14 2017)
- `Acked-by: Ping-Ke Shih <pkshih@realtek.com>` (rtlwifi maintainer)
- `Signed-off-by: William Hansen-Baird` (author)
- `Signed-off-by: Ping-Ke Shih` (maintainer applied to rtw-next)
- `Link: https://patch.msgid.link/20260630141553.785769-2-
  william.hansen.baird@gmail.com`
- No `Cc: stable@vger.kernel.org` (expected for this pipeline; not a
  negative)
- Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  ignored per instructions

Step 1.3: ANALYZE THE COMMIT BODY TEXT

Record:
- **Bug:** `77a6407c6ab2` set `ppsc->support_aspm = false` intending to
  disable ASPM. That only disables *driver control* of ASPM
  (`rtl_pci_enable_aspm` / `rtl_pci_disable_aspm` return early). If
  firmware/BIOS left ASPM on at probe, it stays on.
- **Symptom:** PCIe AER flooding, heavy lag, poor throughput, occasional
  lock-ups on RTL8723BE (subsystem 11ad:1723; same class of issue on
  other 8723BE cards).
- **Root cause:** Early return `if (!ppsc->support_aspm) return;` in
  `rtl_pci_disable_aspm()` prevents the register write that would clear
  L0s/L1.
- **Fix:** `__rtl_pci_disable_aspm()` skips that check; quirk in
  `rtl_pci_init_aspm()` calls it, then sets `support_aspm = false` so
  ASPM is not re-enabled.
- **Version info:** Fixes incomplete quirk from April 2025; that quirk
  is in this tree (first in v6.16).

Step 1.4: DETECT HIDDEN BUG FIXES

Record: Not hidden. Explicit fix of a broken hardware quirk. Not
cleanup-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES

Record:
- File: `drivers/net/wireless/realtek/rtlwifi/pci.c` only (`26`
  insertions, `13` deletions)
- Functions: `_rtl_pci_update_default_setting` (quirk removed),
  `rtl_pci_disable_aspm` renamed to `__rtl_pci_disable_aspm` (early
  `support_aspm` check dropped), new thin `rtl_pci_disable_aspm`
  wrapper, `rtl_pci_init_aspm` (quirk moved here +
  `__rtl_pci_disable_aspm()` call)
- Scope: single-file surgical hardware-quirk fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

Record:
- **Before:** `_rtl_pci_update_default_setting()` for 11ad:1723 only
  sets `support_aspm = false`. Later `rtl_pci_disable_aspm()` /
  `rtl_pci_enable_aspm()` no-op. `rtl_pci_init_aspm()` never clears
  LNKCTL ASPM bits. RTL8723BE default `const_pci_aspm = 3` would have
  taken `RT_RF_PS_LEVEL_ALWAYS_ASPM` and tried to *enable* ASPM; the
  quirk blocked that enable but did not clear already-set bits.
- **After:** After defaults, matching 11ad:1723 calls
  `__rtl_pci_disable_aspm()` (writes LNKCTL, clears L0s/L1), then
  `support_aspm = false`. ALWAYS_ASPM then calls
  `rtl_pci_enable_aspm()`, which no-ops. Normal disable path still
  respects `support_aspm`.

Step 2.3: IDENTIFY THE BUG MECHANISM

Record:
- Category: **hardware workaround / logic correctness** (quirk did not
  do what it claimed)
- Mechanism: `support_aspm = false` was treated as “ASPM off” but it
  only gated driver helpers. Probe-time ASPM from firmware stayed
  enabled → AER RxErr flood.

Step 2.4: ASSESS THE FIX QUALITY

Record:
- Obviously correct: disable first, then lock out re-enable.
- Minimal: no API change; other chips still go through the guarded
  wrapper.
- Regression risk low: extra disable only for 11ad:1723; wrapper
  preserves old behavior elsewhere.
- Residual limit (pre-existing): `__rtl_pci_disable_aspm()` still
  returns if bridge vendor is UNKNOWN. Not introduced here.
- `_rtl8723be_enable_aspm_back_door()` still runs in `hw_init` and can
  poke L0s/L1 via DBI; `enable_aspm()` afterward no-ops. Same as the
  original quirk. Author testing reported AER flood stopped. Not a
  reason to reject this patch.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES

Record:
- Incomplete quirk introduced by `77a6407c6ab24` (“wifi: rtlwifi:
  disable ASPM for RTL8723BE with subsystem ID 11ad:1723”), 2025-04-28,
  **in v6.16** (not v6.15).
- That commit had `Cc: stable`, `Fixes: a619d1abe20c` (rtl8723be driver
  add), bugzilla 218127, Tested-by.
- ASPM helpers themselves date to the original rtlwifi PCI code (much
  older).

Step 3.2: FOLLOW THE FIXES: TAG

Record: No `Fixes:` on the candidate (intentionally dropped as
“misleading” in v3). Functionally it completes `77a6407c6ab24`. That
commit **is** an ancestor of this HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES

Record: 3-patch series (v4):
1. **This commit** — actual bugfix (standalone)
2. `676e59a3825c6` — if-statement → `rtl_aspm_quirks` table (refactor)
3. `2b7858891b100` — add 17aa:b736 (Razer Blade 14 2017)

This patch does not need 2 or 3. Later `b3943b3c29714` (2023) removed
*bogus bridge* ASPM writes; this patch only uses the remaining device
LNKCTL path, so it does not restore that danger.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS

Record: William Hansen-Baird authored this series plus one unrelated
rtl8723be irq cleanup. Applied and Acked by Ping-Ke Shih (Realtek
rtlwifi maintainer).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS

Record: Needs `77a6407c6ab24` (or equivalent 11ad:1723 quirk) and
existing `rtl_pci_disable_aspm` / `pcie_capability_*` helpers. All
present here. Standalone vs the rest of the series.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION

Record:
- `b4 dig -c 04a46c2dbf3b5` → https://patch.msgid.link/20260630141553.78
  5769-2-william.hansen.baird@gmail.com
- v1 2026-06-14, v2 2026-06-16, v3 2026-06-26, v4 2026-06-30 (applied)
- v2: split `__rtl_pci_disable_aspm()` so the check is bypassed only for
  the quirk
- v3: style nits; **removed misleading Fixes tag**; trailing whitespace
- v4: whitespace/`{}` nits; Acked-by carried forward
- No NAKs. Ping-Ke: “looks good to me” + Acked-by; applied all 3 to rtw-
  next
- No reviewer `Cc: stable` in the saved thread
- lore.kernel.org HTTP fetch returned 403; thread recovered via `b4 dig
  -m`

Step 4.2: CHECK WHO REVIEWED THE PATCH

Record: `b4 dig -w`: author, `pkshih@realtek.com`, `linux-
wireless@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Maintainer
reviewed and applied.

Step 4.3: SEARCH FOR THE BUG REPORT

Record: This commit cites in-person testing on a Razer Blade 14 2017.
Underlying AER issue: kernel bugzilla 218127 and lore discussion from
`77a6407c6ab24` (ASUS F441U/X555UQ, 11ad:1723). Real user impact (lags,
lock-ups), not theoretical.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES

Record: Patch 1 is the mechanism fix and is self-contained. Patches 2–3
are refactor + extra ID; not required for *this* commit.

Step 4.5: CHECK STABLE MAILING LIST HISTORY

Record: **UNVERIFIED** — lore.kernel.org/stable blocked (Anubis). No in-
tree evidence this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF

Record: `_rtl_pci_update_default_setting`, `__rtl_pci_disable_aspm` (new
name of old body), `rtl_pci_disable_aspm` (new wrapper),
`rtl_pci_init_aspm`.

Step 5.2: TRACE CALLERS

Record:
- `rtl_pci_init_aspm()` from `rtl_pci_probe()` (device enumeration)
- `rtl_pci_disable_aspm()` from disconnect and `intf_ops->disable_aspm`
- `disable_aspm`/`enable_aspm` from rtl8723be `hw_init`, other rtlwifi
  chips, and `ps.c` power save
- Probe/init path; not a syscall hot path. Userspace-visible via loading
  the driver on affected laptops.

Step 5.3: TRACE CALLEES

Record: `pcie_capability_read_word` /
`_rtl_pci_platform_switch_device_pci_aspm` →
`pcie_capability_clear_and_set_word` on `PCI_EXP_LNKCTL`; optional
clkreq via `_rtl_pci_switch_clk_req`.

Step 5.4: FOLLOW THE CALL CHAIN

Record: PCI probe → `rtl_pci_init_aspm` → quirk disable. Reachable on
affected hardware when `rtl8723be`/`rtlwifi` loads. Not a
sanitizer/syzbot path; real laptop hardware.

Step 5.5: SEARCH FOR SIMILAR PATTERNS

Record: Toshiba 8192SE still only sets `support_aspm = false` without
forcing disable. Same class of incompleteness; this commit does not
touch it. Follow-up series extends the same disable+flag pattern to
17aa:b736 via an ID table.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?

Record: **Yes.** Checkout is **7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`). `77a6407c6ab24` is an ancestor (present
since v6.16). Parent of the candidate still has the 11ad:1723 block that
only clears `support_aspm`. Driver, PCI ASPM helpers, and
`HARDWARE_TYPE_RTL8723BE` are all here. Bug was **not** introduced after
this tree branched.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS

Record: Against the parent of `04a46c2dbf3b5`, the patch is a clean
apply on this file. Later 7.3 commits already refactored that quirk into
`rtl_aspm_quirks[]`; that is post-fix evolution, not a missing
prerequisite. No rework needed for this tree’s lineage.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE

Record: No alternate fix of the same “flag vs actually clear LNKCTL” bug
besides this series. Original `77a6407c6ab24` is the incomplete version
this completes.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY

Record: `drivers/net/wireless/realtek/rtlwifi` —
**PERIPHERAL/IMPORTANT** for owners of RTL8723BE laptops (ASUS
F441U/X555UQ and similar). Not core mm/fs, but a shipping WiFi adapter
in production machines.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY

Record: Mature driver; still receiving bugfixes. rtlwifi 8723BE is old
but still the in-tree driver for that chip.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED

Record: Driver-specific: RTL8723BE with subsystem **11ad:1723** (ASUSTek
F441U, X555UQ, etc.). Only that ID in *this* commit.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS

Record: Trigger is boot/probe with ASPM already enabled (common). Not a
race. Unprivileged users do not need a special exploit; plugging/using
the laptop is enough. Confirmed on real hardware.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY

Record: AER correctable-error flood → system-wide slowdown, bad WiFi
throughput, **occasional lock-ups**. Severity **HIGH** (hang/lock-up and
severe lag), not a KASAN crash.

Step 8.4: CALCULATE RISK-BENEFIT RATIO

Record:
- **Benefit:** High for affected laptops; makes an already-stable quirk
  actually work.
- **Risk:** Low (~26/+13 lines, one file, ID-gated, maintainer Acked,
  tested).
- **Ratio:** Strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR:**
- Real hardware bug: AER flood, lag, lock-ups on known laptops
- Existing stable-bound quirk (`77a6407c6ab24`) did not disable ASPM
  when it was already on
- Small, obviously correct, ID-scoped
- Hardware quirk exception
- Maintainer Acked-by and applied; author tested
- Prerequisite incomplete quirk is in this 7.3 tree
- Self-contained as patch 1/3

**AGAINST:**
- Affects a specific PCI subsystem ID, not all users
- No `Fixes:`/`Cc: stable` (expected here; Fixes was dropped as
  misleading)
- DBI backdoor in `hw_init` still exists (pre-existing; testing said AER
  stopped)

**UNRESOLVED:**
- Stable mailing-list history (lore/stable fetch blocked)
- Direct lore.kernel.org HTTP (403); discussion recovered via b4

Step 9.2: APPLY THE STABLE RULES CHECKLIST

1. Obviously correct and tested? **PASS** — maintainer ack; tested on
   affected hardware; v2–v4 review
2. Fixes a real bug that affects users? **PASS** — broken quirk left
   ASPM on; AER/lag/lock-ups
3. Important issue? **PASS** — lock-ups and severe performance, not
   cosmetic
4. Small and contained? **PASS** — one file, +26/-13
5. No new features or APIs? **PASS** — completes an existing quirk
6. Can apply to the local tree? **PASS** — `pci.c` and `77a6407c6ab24`
   are here; context matches

Step 9.3: CHECK FOR EXCEPTION CATEGORIES

Record: **Hardware quirk/workaround** for a broken RTL8723BE/ASPM
combination.

Step 9.4: MAKE YOUR DECISION

This tree has the incomplete 11ad:1723 quirk and the rtlwifi ASPM path.
The change is a small, reviewed fix that actually clears ASPM so those
laptops do not keep flooding AER and locking up. It belongs in this
tree.

Verification:
- [Phase 1] Tags: Acked-by Ping-Ke Shih; Link msgid
  20260630141553.785769-2; no Fixes/Cc:stable; v3 changelog said Fixes
  was removed as misleading
- [Phase 1] Body: `support_aspm=false` blocks disable/enable helpers
  instead of clearing ASPM
- [Phase 2] Diff: pci.c +26/-13; quirk moved to `rtl_pci_init_aspm`;
  `__rtl_pci_disable_aspm` skips the flag check
- [Phase 2] RTL8723BE default `const_pci_aspm = 3` / `aspm_support = 1`
  verified in `rtl8723be/sw.c`
- [Phase 3] `git merge-base --is-ancestor 77a6407c6ab24 HEAD` → yes;
  original first in v6.16, not v6.15
- [Phase 3] `git merge-base --is-ancestor 04a46c2dbf3b5 HEAD` → yes; not
  an ancestor of v7.2; is in v7.3-rc1
- [Phase 3] Series: this commit, then ID-table refactor, then 17aa:b736;
  this patch standalone
- [Phase 4] `b4 dig -c 04a46c2dbf3b5` / `-a` / `-w` / `-m`: v1–v4,
  maintainer Ack, applied to rtw-next; no NAK
- [Phase 4] WebFetch lore 403; stable lore Anubis — UNVERIFIED via HTTP
- [Phase 5] Callers: `rtl_pci_probe` → `rtl_pci_init_aspm`;
  `intf_ops->disable_aspm` from rtl8723be `hw_init` and `ps.c`
- [Phase 6] `make kernelversion` / `git describe HEAD`: 7.3.0-rc4 /
  `v7.3-rc4-27-gf0100363d8c37`; origin torvalds/linux.git
- [Phase 6] Parent of candidate still has 11ad:1723 `support_aspm =
  false` only
- [Phase 8] Failure mode: AER flood, lag, lock-ups — HIGH; change ID-
  gated — low risk
- UNVERIFIED: Whether this was discussed on stable@; whether DBI
  backdoor re-enables L0s/L1 after probe on all machines (testing said
  AER stopped)

The patch is a contained hardware-quirk correctness fix for a bug this
tree actually has.

**YES**

 drivers/net/wireless/realtek/rtlwifi/pci.c | 39 ++++++++++++++--------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 8fb9604c3c533..f9f05252b890e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -156,15 +156,6 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 				PCI_EXP_LNKCTL_ASPM_L1 | PCI_EXP_LNKCTL_CCC))
 		ppsc->support_aspm = false;
 
-	/* RTL8723BE found on some ASUSTek laptops, such as F441U and
-	 * X555UQ with subsystem ID 11ad:1723 are known to output large
-	 * amounts of PCIe AER errors during and after boot up, causing
-	 * heavy lags, poor network throughput, and occasional lock-ups.
-	 */
-	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8723BE &&
-	    (rtlpci->pdev->subsystem_vendor == 0x11ad &&
-	     rtlpci->pdev->subsystem_device == 0x1723))
-		ppsc->support_aspm = false;
 }
 
 static bool _rtl_pci_platform_switch_device_pci_aspm(
@@ -203,7 +194,7 @@ static void _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u16 value)
 }
 
 /*Disable RTL8192SE ASPM & Disable Pci Bridge ASPM*/
-static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
+static void __rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
@@ -215,9 +206,6 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 	u16 aspmlevel = 0;
 	u16 tmp_u1b = 0;
 
-	if (!ppsc->support_aspm)
-		return;
-
 	if (pcibridge_vendor == PCI_BRIDGE_VENDOR_UNKNOWN) {
 		rtl_dbg(rtlpriv, COMP_POWER, DBG_TRACE,
 			"PCI(Bridge) UNKNOWN\n");
@@ -240,6 +228,16 @@ static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
 	_rtl_pci_platform_switch_device_pci_aspm(hw, linkctrl_reg);
 }
 
+static void rtl_pci_disable_aspm(struct ieee80211_hw *hw)
+{
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	if (!ppsc->support_aspm)
+		return;
+
+	__rtl_pci_disable_aspm(hw);
+}
+
 /*Enable RTL8192SE ASPM & Enable Pci Bridge ASPM for
  *power saving We should follow the sequence to enable
  *RTL8192SE first then enable Pci Bridge ASPM
@@ -330,10 +328,25 @@ static void rtl_pci_parse_configuration(struct pci_dev *pdev,
 
 static void rtl_pci_init_aspm(struct ieee80211_hw *hw)
 {
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
 	_rtl_pci_update_default_setting(hw);
 
+	/*
+	 * RTL8723BE found on some ASUSTek laptops, such as F441U and
+	 * X555UQ with subsystem ID 11ad:1723 are known to output large
+	 * amounts of PCIe AER errors during and after boot up, causing
+	 * heavy lags, poor network throughput, and occasional lock-ups.
+	 */
+	if (rtlpriv->rtlhal.hw_type == HARDWARE_TYPE_RTL8723BE &&
+	    (rtlpci->pdev->subsystem_vendor == 0x11ad &&
+	     rtlpci->pdev->subsystem_device == 0x1723)) {
+		__rtl_pci_disable_aspm(hw);
+		ppsc->support_aspm = false;
+	}
+
 	if (ppsc->reg_rfps_level & RT_RF_PS_LEVEL_ALWAYS_ASPM) {
 		/*Always enable ASPM & Clock Req. */
 		rtl_pci_enable_aspm(hw);
-- 
2.53.0

