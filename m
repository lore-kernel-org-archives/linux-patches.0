Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA6E5B394D;
	Mon, 19 Oct 2026 14:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418433; cv=none; b=FEbTAA8l5Ls0dN8jb52IEkTSFI0dQ6vU3593J1wvVDkWqi/X8P1iYo+UvwlagXYKX2MnyE5DBeaPWb4PZWIVHLWOHKfmzTkIqmbHWwSrx4JmFK4vbN1iu8MRyZFKrel8GdpBqZyH/dtSPzfjJyweCiDDbUWkW8dTRaH1jw1PoIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418433; c=relaxed/simple;
	bh=AHNwDKvOLdUuWufglp5nlVMXt0Ki3ZwGNJymiXx/xp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGCDxe63hef5ESZqN9xBN20eOJ1UwCVgLTbChKi7Ecll5dkAfIrhC5rJ6/yoa/H88B+joPGhk5wFVXbiN9Pl9WJdV4tEcIng1W6NRjxvRqysiPJnBZR7PrEgj2ELVY/OTgkZtWkW0bPaBKDrZ0zjqhXRb5F1M6r58RrWXcGHMjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSR0Yht+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSR0Yht+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC131F000C8;
	Mon, 19 Oct 2026 14:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418431;
	bh=+Rl3OQa3hOkkiRn3FzVVz4R/I17UFdTHssGWgPuRvMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aSR0Yht+5Axy+UhkDTog6UnSlenlCUUhH+KKHPaUdzzenP6AhSJSEkSKtzRKqnq+T
	 FlThp5DbdsfjdizSdo2bWuASvJlQEylXZyZRpbfOGPf3g1Wo+2aYf7DETDxYpwESKJ
	 KKZz/e9cpsMPQx1K3zyJ22amBNboOYVOhbcRYeann3yYnXi6V/8DPqoh12XGEEiNR2
	 o8BR0ybKU54+Ty3C9WF0eZQ9t/1gfQdrpFaN7oe3aYlC/oopS+d/89bRkHMN+Ub+gm
	 9fUzoQzQOWZN9kJFdCZkqPlGH1688jqRKSME3SBC/NgjB5HeqqlFuduSyHsSy6i5t2
	 HX04iRqEZZ9hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode
Date: Mon, 19 Oct 2026 09:48:55 -0400
Message-ID: <20261019135441.1420968-244-sashal@kernel.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit dbff9040587e9bd6d3ee337315971957f9f76612 ]

Only the WiFi 6 chips need to initialize RF register when WoWLAN download
FW for some power save issue. Applying the same initialization flow to
WiFi 7 chips might trigger the error
'RF parameters exceed size. path=1, idx=1500.'.

This happens because normal mode uses rtw89_phy_config_rf_reg_v1(), which
skips registers with addresses below 0x100. However, WoWLAN mode uses
rtw89_phy_config_rf_reg_noio(), and WiFi 7 chips do not satisfy the
rtw89_chip_rf_v1() condition. As a result, more RF registers are
configured, causing the size overflow error.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260625061545.44808-11-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`,
`origin/master`). This tree already contains rtw89 WiFi 7
(RTL8922A/RTL8922D) with WoWLAN, which is the path the overflow hits.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[wifi: rtw89: wow] [only … initialize] [gate WoWLAN RF
  register init to WiFi 6 / CHIP_AX]`
- Subsystem: Realtek rtw89 WoWLAN. The verb is a restriction (“only …
  initialize”), i.e. stop a wrong flow on WiFi 7.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record:
  - `Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>` (author)
  - `Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>` (rtw89
    maintainer; applied to rtw-next)
  - `Link:
    https://patch.msgid.link/20260625061545.44808-11-pkshih@realtek.com`
  - No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Reviewed-by:`,
    no `Cc: stable` (absence is expected)
  - Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit …]`
    if present — not in the git object

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record:
  - **Bug:** WoWLAN firmware swap always calls
    `rtw89_phy_init_rf_reg(rtwdev, true)`. That is needed only on WiFi 6
    (AX) for a power-save issue.
  - **Symptom:** On WiFi 7, `'RF parameters exceed size. path=1,
    idx=1500.'`
  - **Root cause:** Normal mode uses `rtw89_phy_config_rf_reg_v1()`,
    which skips RF addresses `< 0x100`. WoWLAN uses
    `rtw89_phy_config_rf_reg_noio()`, which skips `< 0x100` only when
    `rtw89_chip_rf_v1()` is true. WiFi 7 chips use `write_rf_v2`/`v3`,
    so they do not skip those registers, fill more than 1500 H2C slots,
    and hit the size cap.
  - **Version info:** none in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not hidden. It is an explicit chip-generation bug fix (wrong
  RF init on BE causing H2C RF table overflow).

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: `drivers/net/wireless/realtek/rtw89/wow.c` — 2 insertions, 1
  deletion. Function: `rtw89_wow_swap_fw()`. Scope: single-file, one-
  call gate.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record: After WoWLAN/normal FW download, the code **always** collected
  RF regs with `noio=true` and sent them via H2C. After the fix, that
  runs **only** if `chip->chip_gen == RTW89_CHIP_AX`. WiFi 7
  (`RTW89_CHIP_BE`) skips it. BE already has a separate restore:
  `rtw89_phy_rfk_pre_ntfy_and_wait()` later in the same function.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: **Logic / hardware-generation mismatch**, not a kernel buffer
  overwrite.
  - Store path in `rtw89_phy_cofig_rf_reg_store()`:
    - `RTW89_H2C_RF_PAGE_SIZE == 500`, `RTW89_H2C_RF_PAGE_NUM == 3` →
      cap **1500**
    - `idx=1500` ⇒ `page = 3 >= 3` → `rtw89_warn(...)` and **drop** the
      register (no OOB write)
  - Extra entries are dropped; 1500 params are still sent. Result:
    warning spam + incomplete RF programming of WoWLAN FW.
  - Category: hardware/chip-gen workaround + functional correctness of
    suspend/WoWLAN.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: Obviously correct. `chip` is already `rtwdev->chip` in this
  function; `RTW89_CHIP_AX` is the existing gen enum. AX still gets the
  power-save RF init; BE does not. Regression risk is low: BE never
  needed this path (vendor statement + separate RFK notify). No
  API/data-structure change.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: Unconditional `rtw89_phy_init_rf_reg(rtwdev, true)` came from
  `19e28c7fcc740` (“wifi: rtw89: add WoWLAN function support”,
  2022-10-27, in v6.2-rc1). The `noio` collector is `d9112042d994` (same
  era). The bug becomes real when WiFi 7 chips (empty `rf_table`,
  firmware `rf_radio[]` elements, `write_rf` not v1) run that WoWLAN
  path. RTL8922A chip info: `c0a04552e36e1` (~v6.8). RTL8922D is newer
  (2026).

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: Nearby wow.c work is MLO ARP, 8922D interrupt disable, cipher
  messages — independent. This is **10/10** of a mixed rtw-next series,
  not a dependent chain. Cover letter: independent MAC/FW/PCI/WoWLAN
  items; this patch does not need 01–09.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Chih-Kang Chang is a regular Realtek rtw89 contributor. Ping-
  Ke Shih is the **rtw89 maintainer** (MAINTAINERS) and applied the
  series to rtw-next.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: Standalone. Needs only `chip->chip_gen` / `RTW89_CHIP_AX`
  (present since `f698afa7ce374`, 2023) and `rtw89_phy_init_rf_reg()`.
  Both exist in this tree. No new helpers.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `b4 dig -c dbff9040587e9` →
  https://patch.msgid.link/20260625061545.44808-11-pkshih@realtek.com
  - Series: `[PATCH rtw-next 00/10] wifi: rtw89: update some MAC, FW and
    WoWLAN settings`
  - This commit is **10/10**. `b4 dig -a`: only **v1**.
  - Cover letter does not call out this patch as the headline fix (it
    highlights 4/10 scan and 7/10 typo). No reviewer NAK. Maintainer
    applied all 10 to rtw-next (mbox reply 2026-07-03).
  - No `Cc: stable` in the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: `b4 dig -w` To/Cc: Ping-Ke Shih, linux-wireless, gary.chang,
  timlee, dian_syuan0116, kevin_yang (all Realtek rtw89). No external
  Reviewed-by. Maintainer SOB + apply is the review signal.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No public bugzilla/syzbot. The message quotes a concrete
  driver warning (`path=1, idx=1500`), which matches the H2C cap.
  Vendor-observed, not a user mailing-list report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Series mates (MAC TX complete, chip version to FW, UDM1 log
  level, packet offload drop, sniffer RX filter, PCI phy error, LPS MLO
  link ID, MLO ARP) are **not** prerequisites of this 2-line gate.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: **UNVERIFIED.** lore.kernel.org returned HTTP 403 for
  `/stable/` and thread HTML. mbox from `b4 dig -m` had no stable
  discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: `rtw89_wow_swap_fw()`; callees of interest:
  `rtw89_phy_init_rf_reg()`, `rtw89_phy_config_rf_reg_noio()`,
  `rtw89_phy_cofig_rf_reg_store()`.

**Step 5.2: TRACE CALLERS**
- Record: `rtw89_wow_swap_fw()` is called from `rtw89_wow_enable()`
  (wow=true) and `rtw89_wow_disable()` (wow=false). Those are called
  from `rtw89_wow_suspend()` / resume. `rtw89_ops_suspend()` in
  `mac80211.c` is the mac80211 suspend op (`CONFIG_PM`). Reachable from
  userspace suspend with WoWLAN (NetworkManager magic-
  packet/disconnect/net-detect). Not a syscall crash path; it is a
  common laptop suspend path.

**Step 5.3: TRACE CALLEES**
- Record: `rtw89_phy_init_rf_reg(noio=true)` walks firmware or chip RF
  tables and stores H2C pages (no MMIO). Overflow is handled as
  warn+drop, then `rtw89_phy_config_rf_reg_fw()` still sends up to 1500
  entries.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: userspace suspend → `ieee80211` suspend → `rtw89_ops_suspend`
  → `rtw89_wow_suspend` → `rtw89_wow_enable` → `rtw89_wow_swap_fw` → RF
  init. **Yes, reachable** on RTL8922A/D with WoWLAN enabled. Both chips
  have `wowlan_stub` in this tree.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Same function already special-cases BE
  (`rtw89_phy_rfk_pre_ntfy_and_wait`) and AX (`disable_intr_for_dlfw`).
  This gate matches that pattern. `rtw89_chip_rf_v1()` is true only for
  8852B/BT/C and 8851B (`write_rf_v1`). 8852A is AX but not rf_v1 —
  still correctly keeps RF init because the new check is `CHIP_AX`, not
  `chip_rf_v1()`.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: **Yes, the affected stack exists.** This tree has
  `RTW89_CHIP_BE` chips (`rtw8922a.c`, `rtw8922d.c`) with WoWLAN stubs,
  firmware `rf_radio[]` tables, `write_rf` v2/v3 (so
  `rtw89_chip_rf_v1()` is false), and `rtw89_wow_swap_fw()`.
- The **unconditional** call is already replaced here by commit
  `dbff9040587e9` (ancestor of HEAD). That is this tree’s current code,
  not a reason to treat the bug as fictional: without this change, BE
  WoWLAN still hits the 1500-entry cap.
- Bug introduced relative to this codebase: WoWLAN RF collect since
  v6.2; overflow on BE once WiFi 7 + firmware radio tables are used
  (8922A from ~6.8, 8922D in this 7.3 cycle).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: On **this** 7.3-rc4 tree the hunk is already applied; a re-
  apply would be empty. Context (`chip`, `RTW89_CHIP_AX`,
  `rtw89_phy_init_rf_reg`) matches. Expected difficulty if it were
  missing: **clean apply**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: This is the fix. Follow-ups on wow.c (`73aecc221e7df` cipher
  debug, `d946a4e031167` scan V3) do not replace it. No revert.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: `[drivers/net/wireless/realtek/rtw89]` — **IMPORTANT**
  (shipping WiFi 6/7, not core mm/VFS). Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Actively developed (WiFi 7 8922D, MLO WoWLAN). Maintainer:
  Ping-Ke Shih. Mature AX WoWLAN plus newer BE support.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **Driver-specific / config-specific:** `CONFIG_PM` + rtw89 +
  RTL8922A or RTL8922D (and any other BE chip using this wow path). AX
  users unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: Suspend/resume with WoWLAN (or wow FW swap on resume). Common
  on laptops. Unprivileged users cannot directly invoke it; suspend
  typically needs policy/login, but it is a normal user flow. Not a
  race.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: **MEDIUM (functional HIGH for affected NICs).** Not a
  KASAN/UAF/panic. Verified: no kernel OOB write. User-visible:
  `rtw89_warn` (can repeat per extra register) and truncated RF H2C, so
  WoWLAN/power-save RF state on WiFi 7 can be wrong (failed wake or bad
  RF after resume). That is a real suspend bug, not cosmetic-only.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record: **Benefit: high for BE WoWLAN users in this tree. Risk: very
  low** (2 lines, existing enum, AX path unchanged). Ratio favors
  applying it.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, vendor-documented overflow of the 1500-slot RF H2C table on WiFi
  7 WoWLAN (`idx=1500` = `3*500`).
- This tree **has** BE chips with WoWLAN; the wrong `noio` path is used
  because they are not `rf_v1`.
- 2-line, obviously correct gen check; AX still initialized; BE already
  uses RFK pre-notify.
- Maintainer SOB and applied to rtw-next; self-contained despite 10/10
  series.
- Typical stable-class hardware/suspend workaround.

AGAINST:
- Not a crash, UAF, deadlock, or security bug.
- No `Fixes:` / public user reports / syzbot.
- Warning-and-drop, not memory corruption.
- Only rtw89 WiFi 7 + WoWLAN.

UNRESOLVED:
- lore `/stable/` search 403; no confirmation of prior stable
  discussion.
- Exact user-visible radio failure beyond the warning is vendor-
  described, not independently reproduced here.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mechanism matches code;
   maintainer applied.
2. Fixes a real bug that affects users? **PASS** — BE WoWLAN RF H2C
   overflow/truncation on suspend.
3. Important issue? **PASS** (medium-high functional / suspend) — not
   panic, but broken WoWLAN RF on shipping WiFi 7 is important for this
   tree.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — context exists; already
   present as `dbff9040587e9`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: Hardware workaround / chip-generation quirk (do not run AX-
  only RF init on BE). Qualifies under quirks/workarounds.

**Step 9.4: MAKE YOUR DECISION**
This tree is 7.3-rc4 with RTL8922A/8922D WoWLAN. The bug is real here:
firmware RF tables plus `rtw89_phy_config_rf_reg_noio()` without the v1
`< 0x100` skip overflow the 1500-entry H2C buffer and mis-init RF during
wow FW swap. The fix is a one-condition guard, no series dependency, no
new API. Benefit outweighs risk.

---

## What the commit solves for this tree

On WiFi 7 rtw89, WoWLAN firmware download used the WiFi 6 “collect RF
regs, no MMIO” path. BE chips are not `rf_v1`, so addresses `< 0x100`
were included, `curr_idx` hit 1500, and the driver warned and dropped
the rest. Suspend/WoWLAN RF programming was incomplete. Gating on
`RTW89_CHIP_AX` restores the intended split: AX keeps the power-save RF
init; BE keeps RFK notify only.

It meets stable rules: small, correct, no features, real user-facing
suspend bug on hardware this tree supports. Risk is negligible.

## Verification
- [Phase 1] Parsed git object `dbff9040587e9`: SOB Chang + Shih, Link
  msgid `…44808-11…`; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: wow.c `rtw89_wow_swap_fw`: wrap
  `rtw89_phy_init_rf_reg(rtwdev, true)` in `chip->chip_gen ==
  RTW89_CHIP_AX`
- [Phase 2] `fw.h`: `RTW89_H2C_RF_PAGE_SIZE 500`, `PAGE_NUM 3` → 1500;
  `phy.c` warns at `page >= PAGE_NUM` without OOB store
- [Phase 2] `rtw89_chip_rf_v1()` is `write_rf == rtw89_phy_write_rf_v1`;
  8922A=`v2`, 8922D=`v3`; 8852B/C/BT/8851B=`v1`
- [Phase 3] blame: RF init from `19e28c7fcc740` (v6.2-rc1); chip_gen
  from `f698afa7ce374`; 8922A `c0a04552e36e1`
- [Phase 3] `git merge-base --is-ancestor dbff9040587e9 HEAD` → yes
  (already in this 7.3-rc4 tree)
- [Phase 3] Series 0819de0fd2906..dbff9040587e9 is 10 independent rtw-
  next patches; this one only touches wow.c
- [Phase 4] `b4 dig -c dbff9040587e9`: lore thread found; `-a` v1 only;
  `-w` linux-wireless + Realtek; `-m` 12 msgs, maintainer “10 patch(es)
  applied”
- [Phase 4] WebFetch lore HTML: 403; stable-list search UNVERIFIED
- [Phase 5] Call chain: `rtw89_ops_suspend` → `rtw89_wow_suspend` →
  `rtw89_wow_enable` → `rtw89_wow_swap_fw`; 8922A/D have `wowlan_stub`
- [Phase 5] BE path already calls `rtw89_phy_rfk_pre_ntfy_and_wait` in
  the same function
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `VERSION=7 PATCHLEVEL=3 EXTRAVERSION=-rc4`
- [Phase 6] Current wow.c already has the AX gate (this commit)
- [Phase 7] MAINTAINERS: Ping-Ke Shih maintains rtw89
- [Phase 8] Failure mode verified as warn+truncate, not kernel memory
  overflow; severity MEDIUM/HIGH functional for BE WoWLAN
- UNVERIFIED: independent reproduction of failed wake; stable@
  discussion (lore 403)

**YES**

 drivers/net/wireless/realtek/rtw89/wow.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index f6cdbc15dcc4a..90046d6f620ef 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -1299,7 +1299,8 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	if (disable_intr_for_dlfw)
 		rtw89_hci_enable_intr(rtwdev);
 
-	rtw89_phy_init_rf_reg(rtwdev, true);
+	if (chip->chip_gen == RTW89_CHIP_AX)
+		rtw89_phy_init_rf_reg(rtwdev, true);
 
 	ret = rtw89_fw_h2c_role_maintain(rtwdev, rtwvif_link, rtwsta_link,
 					 RTW89_ROLE_FW_RESTORE);
-- 
2.53.0

