Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AAA4A3D2E;
	Mon, 31 Aug 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183761; cv=none; b=JfmFdHENe6fPCWZNijNwsKR4MjZSsLl9pSmJL1GKrh4QEpk+/hvoiqPSQ+a6hp6f4PB2t1XrBBemJne/x6drp9NJh69d44k80mSCbHaYTw8n1uLkyv4k+Q3HPsHND5tMHsaeVU1pxK6fxgzXV/zXSoQDawEmuaL0rAXx/oKrQxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183761; c=relaxed/simple;
	bh=vxmJcLupZkpUAR/HflilJMgIbOetQ4oPQ/ZS9PfmMUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ucnvy3TlS+gh3UnvPwGi7K9oyhH1UVvHV9rqWu1LHulRJLkaEGD0OBSEAgpiHgYyOJU/yg/uwRqSk/4oCOLO4JFlDfUu1EoyIKBoIgBhQ1wDlBckuCi3d0aA3zng4s4+UqNDJXstib5HVz67Bl+rnPs7d0J6Fn/HXThi44EQutU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hs96HTxM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hs96HTxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E253C1F00ACF;
	Mon, 31 Aug 2026 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183758;
	bh=NfOqvkeLMNrceIJZx7M6vieQjyLnddgjmusYXLXfMjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hs96HTxMgEhx7lSDRWO4uFL3rfxnD6p1Oy61hF/gO+OPgSmzfrr7H+xYu8ECAzK6d
	 0hK5+vJ72AHuaDbc4t0iTkazsaNlLjAF6kS6XOazGTCrPyUaSSGNpuers2XQ5X/AOb
	 fEL3yGTMmezfOpUFqyw0F9U1gbj7LnQGZgbeS4EogZK1Z1TGql/QqEU9VJjDzJIYH8
	 7jXXVemgn35YWxFMRR8b4IpMzudG4rRDj1p1ZEAOyBUlbKrfYU4NKTJ6tsVaT4nAss
	 PZuLalYjVNvsIjgMLWcUDEhKwNNCIZkBkOFRlaAaT83kVfsxwr3mV+dg3bdw1nrUp6
	 H6j3B+K3QRFNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Oleksandr Havrylov <goainwo@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: rtw88: Add NULL check for chip->edcca_th in rtw_fw_adaptivity_result()
Date: Mon, 31 Aug 2026 09:25:14 -0400
Message-ID: <20260831133314.4125787-286-sashal@kernel.org>
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

From: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>

[ Upstream commit d5e6f353ce1e1c25b8458ea390ed09d2377412c5 ]

It was recently reported that rtw_fw_adaptivity_result()
in fw.c dereferences rtwdev->chip->edcca_th without
a NULL check. The issue is that devices with the
8821CE chip don't define edcca_th in their chip
info. As a result, when rtw_fw_adaptivity_result()
tries to dereference it, the kernel triggers an oops.

Add a NULL check for edcca_th before dereferencing
it in rtw_fw_adaptivity_result() in fw.c. Placing
the check at the function entry avoids logging any
garbage values.

This change does not address the root cause for
this behavior, but it prevents the NULL dereference
and the resulting oops while a more permanent solution
is developed.

Tested on a 8822CE chip which defines edcca_th, so
this issue is not present on it, but it still uses
this driver and I can verify there are no regressions.

Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Reported-by: Oleksandr Havrylov <goainwo@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221286
Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Oleksandr Havrylov <goainwo@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260415052959.14844-1-npetrakopoulos2003@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[wifi: rtw88]` `[Add]` — Add NULL check for
`chip->edcca_th` in `rtw_fw_adaptivity_result()`.

### Step 1.2: Tags
**Record:**
- **Suggested-by:** Ping-Ke Shih \<pkshih@realtek.com\> (Realtek rtw88
  maintainer)
- **Reported-by:** Oleksandr Havrylov \<goainwo@gmail.com\> (user hit
  the bug on RTL8821CE)
- **Closes:** https://bugzilla.kernel.org/show_bug.cgi?id=221286
- **Tested-by:** Oleksandr Havrylov (commit message); also Panagiotis on
  8822CE
- **Acked-by:** Ping-Ke Shih (v2/v3 review on lore)
- **Signed-off-by:** Panagiotis Petrakopoulos, Ping-Ke Shih
- **Link:** https://patch.msgid.link/20260415052959.14844-1-
  npetrakopoulos2003@gmail.com
- No **Fixes:** tag (expected for manual review)
- No **Cc: stable@vger.kernel.org** (expected; not a negative signal)

Notable: maintainer **Acked-by**, user **Reported-by** + **Tested-by**,
kernel bugzilla filing.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `rtw_fw_adaptivity_result()` in `fw.c` dereferences
  `rtwdev->chip->edcca_th` without a NULL check.
- **Symptom:** Kernel oops (and per bugzilla title, system hang) on
  RTL8821CE when firmware sends `C2H_ADAPTIVITY`.
- **Root cause (as stated):** `rtw8821c_hw_spec` does not set
  `.edcca_th`, so the pointer is NULL for 8821CE.
- **Fix approach:** Early return at function entry if `!edcca_th`.
- **Caveat:** Author notes this is a workaround, not a full root-cause
  fix (maintainer also discussed garbage/malformed C2H as underlying
  issue).
- **Version info:** Bug reported on Linux 6.19.9; patch dated April
  2026.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — despite "Add NULL check" wording, this is a real NULL
pointer dereference crash fix, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/wireless/realtek/rtw88/fw.c` only (v3; `phy.c`
  hunk dropped per maintainer review)
- **Scope:** +3 lines, 1 function, single-file surgical fix
- **Function modified:** `rtw_fw_adaptivity_result()`

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Load `edcca_th = rtwdev->chip->edcca_th`, then
  unconditionally use `edcca_th[...]` in `rtw_dbg()` arguments (and
  `rtw_read32_mask()` calls).
- **After:** After loading `edcca_th`, if NULL, return immediately;
  otherwise unchanged.
- **Path affected:** Firmware C2H adaptivity result handling (workqueue
  context).

### Step 2.3: Bug Mechanism
**Record:** **NULL pointer dereference** — category (e). On 8821CE,
`chip->edcca_th` is NULL; indexing `edcca_th[EDCCA_TH_L2H_IDX]` reads
from address 0. Bitterblue's disassembly analysis on lore confirms `movl
(%r12), %esi` with R12=0.

Note: `rtw_dbg()` is a no-op when `CONFIG_RTW88_DEBUG` is unset, but C
still evaluates its arguments before the call, so the crash is not
debug-only.

### Step 2.4: Fix Quality
**Record:** Obviously correct, minimal, low regression risk. Chips that
define `edcca_th` (8822B/C) are unaffected. Maintainer requested check
at function entry (v3) to avoid logging garbage. No API changes.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `rtw_fw_adaptivity_result()` and `C2H_ADAPTIVITY` handling
exist at least since `ac3fd01e4c1ef` (Linux 6.18-rc7), which is an
ancestor of HEAD. `rtw8821c_hw_spec` has never set `.edcca_th` in this
tree (verified at 6.18-rc7 and current HEAD). Git blame in this checkout
is flattened (lines attributed to unrelated squash commit); pickaxe
search confirms code present since 6.18-rc7.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:** Recent rtw88 stable fixes in this tree include OOB read fix
(`01155ded5d4da`), PCI AER fix, USB leak fix — unrelated. This NULL-
check fix is **not** present in HEAD (verified: no `if (!edcca_th)` in
`fw.c`).

### Step 3.4: Author Context
**Record:** Panagiotis Petrakopoulos is a community contributor; Ping-Ke
Shih (Realtek rtw88 maintainer) reviewed v1→v3, provided **Acked-by**,
and guided placement of the NULL check.

### Step 3.5: Dependencies
**Record:** Standalone. v3 is self-contained (1 file, 3 lines). No
prerequisite commits required. Final version dropped unnecessary `phy.c`
hunk.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** Thread found via yhbt.net lore mirror at
https://yhbt.net/lore/linux-
wireless/efc1c1c91b81447a8ca8f9b1d087b371@realtek.com/T/
(lore.kernel.org blocked by bot protection; `b4 shazam` did not find
message-id). Series: v1 (fw.c + phy.c) → v2 (entry check, drop phy.c) →
v3 (subject/tags per maintainer). v3 is the committed version.

### Step 4.2: Reviewers
**Record:** Ping-Ke Shih (maintainer) CC'd throughout; provided review
feedback and **Acked-by** on v2/v3. Reporter Oleksandr Havrylov
participated. Bitterblue Smith referenced for deeper root-cause
analysis.

### Step 4.3: Bug Report
**Record:** Bugzilla #221286 — "NULL pointer dereference in
rtw_fw_adaptivity_result() causes kernel oops and system hang on
RTL8821CE". Reported 2026-03-27 by Oleksandr on kernel 6.19.9. Severity:
kernel oops + hang on common laptop WiFi hardware.

### Step 4.4: Series Context
**Record:** 3-patch revision series; v3 is final and applies only to
`fw.c`. Maintainer noted root cause may be malformed C2H packets, but
endorsed the workaround to prevent oops.

### Step 4.5: Stable List
**Record:** No explicit "Cc: stable" found in lore thread. Maintainer
endorsed resolving bugzilla with this workaround. Absence of stable
nomination is not a negative signal per review rules.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rtw_fw_adaptivity_result()` (modified); callers:
`rtw_fw_c2h_cmd_handle()` case `C2H_ADAPTIVITY`.

### Step 5.2: Callers
**Record:**
- `rtw_fw_c2h_cmd_handle()` ← `rtw_c2h_work()` (workqueue)
- `rtw_c2h_work` queued from `fw.c` when firmware C2H commands arrive
  (`ieee80211_queue_work`)
- Trigger: firmware sends `C2H_ADAPTIVITY` (0x37) to driver

### Step 5.3: Callees
**Record:** `rtw_dbg()`, `rtw_read32_mask()` — the crash is in argument
evaluation for register reads via NULL `edcca_th`.

### Step 5.4: Reachability
**Record:**
- `rtw_phy_dynamic_mechanism()` → `rtw_fw_adaptivity()` when firmware
  advertises `FW_FEATURE_ADAPTIVITY` (regular watchdog path in `main.c`)
- Firmware can respond with `C2H_ADAPTIVITY` →
  `rtw_fw_adaptivity_result()`
- RTL8821CE (`CONFIG_RTW88_8821CE`, `rtw8821ce.c`) uses
  `rtw8821c_hw_spec` which lacks `.edcca_th`
- Reachable during normal WiFi operation on affected hardware; not an
  obscure init-only path

### Step 5.5: Similar Patterns
**Record:** `rtw_phy_set_edcca_th()` in `phy.c` also dereferences
`edcca_th` without check, but is only called from 8822B/C adaptivity
paths that define `edcca_th`. Maintainer correctly had v3 drop that
hunk.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Local tree is **v6.18.43** (`git describe HEAD`).
Current `fw.c` lines 276–291 show unchecked `edcca_th` dereference.
`rtw8821c_hw_spec` (lines 1973–2057 of `rtw8821c.c`) has no `.edcca_th`
field — pointer is NULL for 8821CE.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** v3 hunk targets `fw.c` at lines
matching current tree structure (`@@ -279,6 +279,9 @@`). No conflicting
changes observed.

### Step 6.3: Related Fixes Already Present?
**Record:** **NO.** `grep` confirms `if (!edcca_th)` is absent from
`fw.c`. Fix not yet in this 6.18.43 tree.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `drivers/net/wireless/realtek/rtw88` — **IMPORTANT** (widely
deployed USB/PCI WiFi, especially RTL8821CE in laptops).

### Step 7.2: Activity
**Record:** Actively maintained; recent stable backports in this tree
(OOB read, USB leaks, PCI fixes) show ongoing rtw88 stable attention.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of RTL8821CE (and potentially other 8821C variants)
with `CONFIG_RTW88_8821CE` / rtw88 driver loaded. Driver-specific, but
8821CE is extremely common hardware.

### Step 8.2: Trigger Conditions
**Record:** Firmware sends `C2H_ADAPTIVITY` command while driver is
running. Occurs during normal dynamic mechanism / adaptivity handling.
User-visible during regular WiFi use; unprivileged users can trigger
WiFi traffic that causes firmware interaction.

### Step 8.3: Failure Mode Severity
**Record:** **CRITICAL** — NULL pointer dereference → kernel oops;
bugzilla reports system hang. Workqueue holds `rtwdev->mutex` during
crash, compounding severity.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents crashes/hangs on very common hardware
- **Risk:** VERY LOW — 3-line guard, maintainer-reviewed, tested on
  8822CE for regressions
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible NULL deref → kernel oops/hang
- Affects RTL8821CE, common laptop WiFi
- Tiny, surgical, maintainer-Acked fix
- User-reported with bugzilla, Tested-by from reporter
- Bug present in v6.18.43 tree; fix not yet applied
- Clean apply expected

**AGAINST backport:**
- Workaround only; root cause may be malformed C2H packets (maintainer
  discussion) — but stable trees routinely take crash-prevention
  workarounds while root-cause fixes develop
- No explicit stable nomination in lore — not disqualifying

**Unresolved:** Exact mainline merge commit SHA not verified in this
checkout (fix not merged here yet). Does not affect backport decision
for this tree.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — 3-line NULL guard; Acked-by
   maintainer; Tested-by on 8822CE and reporter testing on 8821CE
2. Fixes real bug affecting users? **PASS** — bugzilla #221286, user
   oops on 8821CE
3. Important issue? **PASS** — kernel oops / system hang (CRITICAL)
4. Small and contained? **PASS** — 1 file, +3 lines
5. No new features/APIs? **PASS** — defensive guard only
6. Can apply to local tree? **PASS** — buggy code present, fix not
   present, clean apply

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision Rationale
For **Linux 6.18.43**, the unchecked NULL dereference in
`rtw_fw_adaptivity_result()` is present, affects widely deployed
RTL8821CE hardware, causes kernel oops/hang, and is fixed by a minimal
3-line patch reviewed and Acked by the rtw88 maintainer. This is
textbook stable material.

---

## Verification

- [Phase 1] Parsed subject, tags (Reported-by, Tested-by, Acked-by,
  Closes bugzilla, Suggested-by)
- [Phase 1] Read commit body; identified NULL deref on 8821CE,
  workaround nature noted
- [Phase 2] Confirmed v3 diff: +3 lines in `fw.c` only, early `if
  (!edcca_th) return;`
- [Phase 2] Read current `fw.c:276-296` — buggy code without NULL check
- [Phase 2] Read `rtw8821c_hw_spec` — no `.edcca_th` field (lines
  1973-2057)
- [Phase 2] Compared `rtw8822b_hw_spec` — has `.edcca_th =
  rtw8822b_edcca_th` (line 2568)
- [Phase 2] Read `debug.h:61-62` — `rtw_dbg` is empty inline when debug
  off; args still evaluated in C
- [Phase 3] `git describe HEAD` → v6.18.43; Makefile VERSION 6.18.43
- [Phase 3] `git show ac3fd01e4c1ef:fw.c` — same buggy function at
  6.18-rc7
- [Phase 3] `git show ac3fd01e4c1ef:rtw8821c.c` — no edcca_th at
  6.18-rc7
- [Phase 3] `grep "if (!edcca_th)" fw.c` — NOT present in HEAD
- [Phase 3] Pickaxe search: `C2H_ADAPTIVITY`/`rtw_fw_adaptivity_result`
  present since 6.18-rc7
- [Phase 4] Lore thread via yhbt.net mirror — v1/v2/v3 evolution, Ping-
  Ke Acked-by, review feedback
- [Phase 4] Bugzilla #221286 fetched — oops/hang on RTL8821CE confirmed
- [Phase 4] `b4 shazam` — lore.kernel.org message not found (bot/cache);
  used yhbt mirror instead
- [Phase 5] Traced call chain: firmware C2H → `rtw_c2h_work` →
  `rtw_fw_c2h_cmd_handle` → `rtw_fw_adaptivity_result`
- [Phase 5] `main.c:280` — `rtw_phy_dynamic_mechanism` in watchdog path
  can trigger adaptivity H2C
- [Phase 5] Verified `CONFIG_RTW88_8821CE` exists in Kconfig/Makefile
- [Phase 6] Confirmed local tree 6.18.43 has bug, lacks fix, expects
  clean apply
- [Phase 8] Severity: NULL deref → oops/hang on common hardware

**YES**The pickaxe search finished: `C2H_ADAPTIVITY` handling and
`rtw_fw_adaptivity_result()` have been in this tree since at least Linux
6.18-rc7, and the bug is still present in v6.18.43 — `rtw8821c_hw_spec`
never sets `.edcca_th`, but `fw.c` dereferences it without a check.

**Backport recommendation: YES.** This is a small, maintainer-Acked
NULL-deref fix that prevents kernel oops/hangs on RTL8821CE when
firmware sends adaptivity C2H commands. It should apply cleanly as a
3-line addition to `drivers/net/wireless/realtek/rtw88/fw.c`.

 drivers/net/wireless/realtek/rtw88/fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index c68a9fff68082..7ea8390f4d5a8 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -279,6 +279,9 @@ static void rtw_fw_adaptivity_result(struct rtw_dev *rtwdev, u8 *payload,
 	const struct rtw_hw_reg_offset *edcca_th = rtwdev->chip->edcca_th;
 	struct rtw_c2h_adaptivity *result = (struct rtw_c2h_adaptivity *)payload;
 
+	if (!edcca_th)
+		return;
+
 	rtw_dbg(rtwdev, RTW_DBG_ADAPTIVITY,
 		"Adaptivity: density %x igi %x l2h_th_init %x l2h %x h2l %x option %x\n",
 		result->density, result->igi, result->l2h_th_init, result->l2h,
-- 
2.53.0

