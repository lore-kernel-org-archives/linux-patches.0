Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA7C535598;
	Mon, 31 Aug 2026 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183915; cv=none; b=QtMDvQED/v3+krF3UepkQxwUzaw8Pg9sQCKrw0TIFJ/LKz1QDRBC3ZQq/aO0zabS+Mvh+HSq3mBo9hkO4cfPEJxYPcgJeFdrKm3cdmkmaqzAFQQskCRkAwv+/ScktIUq8lGSSx7h0DzBRiwNLhopMp+0Pngn2XQasorK+tullbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183915; c=relaxed/simple;
	bh=kPDDjgFocQM3om2n5WyQ1eLP2y6NySXY53TanBDB/tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/JBaON0GFJa73IHLQKsT/fNWN2XU7PPf55dk/93gLMen5aH9k9WzZ77yM1rEIAb1Sb33cwSpHwNeLUhnLaX+3LyVSwuiJxMuF7pcOBxX4EHSR1CLi2XzEME8PobiqDHwYZNgrqrH65oyyy8kMq5Sh0JTh3cy9x508iTUDbY9AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQdWKJ0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQdWKJ0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717731F000E9;
	Mon, 31 Aug 2026 13:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183913;
	bh=69usvIE3lXTbyESy5WR3AEOlbzZ861aOFZCc6aOOWmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQdWKJ0k6vJ9ThUIPr2PBxmxb3x0lNh9L1wtW+KScbpdvinBWODAfqKNKbDUGLo7w
	 cJnBVaSuWbJYkfO7r+LhJ6/SRh9Ggb1NknnwgG0k6aIxotZ1OTjxhfIZ7psD/ThfTf
	 jmeJHYmxyc5tM7/+yG+KhuVN0zbPVXOAQpZFjwRYU9O7UonyxgPHb1VQt/G5otCeNz
	 Vhtoj4yhv/x5YGhNccMZBwilRG0HSOgxQcY21q43zKCQ/Na2lxmUAlwkxdIKn/+Z5y
	 v75RLwLTZgSVcXoVafyRuzX0+NsfGjgB2HKVwCVgibVsFmP023tZPXFxYj811XvOE9
	 zPbTTj/Y3tYgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Lai <justinlai0215@realtek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	larry.chiu@realtek.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] rtase: Fix flow control configuration
Date: Mon, 31 Aug 2026 09:26:45 -0400
Message-ID: <20260831133314.4125787-377-sashal@kernel.org>
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

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit fea3521e043fa1388ec909205687db7d4b0c57ec ]

The hardware has two sets of registers controlling TX/RX flow control.
The effective flow control state is determined by the logical OR of
these two sets of bits.

RTASE_FORCE_TXFLOW_EN and RTASE_FORCE_RXFLOW_EN in RTASE_CPLUS_CMD are
the bits used by the driver to control TX/RX flow control according to
the ethtool pause configuration.

RTASE_TXFLOW_EN and RTASE_RXFLOW_EN in RTASE_GPHY_STD_00 are another
set of TX/RX flow control enable bits. Clear them by default so they do
not keep flow control enabled independently of the driver setting.

With the RTASE_GPHY_STD_00 bits cleared, the effective flow control
state is controlled through RTASE_CPLUS_CMD, so the ethtool setting can
take effect correctly.

Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260505064121.31286-1-justinlai0215@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `rtase: Fix flow control configuration`

**Local tree:** `v6.18.43-1-gc7f0dac02d232` (kernel 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[rtase] [fix] flow control configuration` — Realtek
automotive Ethernet driver; fixes incorrect hardware flow-control setup.

### Step 1.2: Commit Message Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Justin Lai `<justinlai0215@realtek.com>` |
| Reviewed-by | Andrew Lunn `<andrew@lunn.ch>` |
| Link | https://patch.msgid.link/20260505064121.31286-1-
justinlai0215@realtek.com |
| Signed-off-by | Jakub Kicinski `<kuba@kernel.org>` (committer) |

**Notable patterns:** Reviewed-by from netdev reviewer Andrew Lunn. No
Reported-by, Fixes:, Cc: stable, syzbot, or Tested-by. Absence of stable
tags is expected per pipeline rules.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** Hardware has two independent TX/RX flow-control enable bit
  sets (`RTASE_CPLUS_CMD` and `RTASE_GPHY_STD_00`); effective state is
  logical OR of both.
- **Symptom:** Driver only manages `RTASE_CPLUS_CMD` via ethtool pause,
  but `RTASE_GPHY_STD_00` bits left set by hardware default keep flow
  control enabled even when ethtool disables it.
- **Root cause:** Missing initialization to clear `RTASE_GPHY_STD_00`
  flow-control bits at driver init.
- **Fix:** Clear `RTASE_TXFLOW_EN | RTASE_RXFLOW_EN` in
  `RTASE_GPHY_STD_00` during `rtase_hw_config()` so ethtool pause
  settings take effect.
- **Version info:** None in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicit hardware-configuration bug fix.
`rtase_get_pauseparam()` / `rtase_set_pauseparam()` read/write only
`RTASE_CPLUS_CMD`, so userspace sees disabled pause while hardware still
pauses when GPHY bits remain set.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
| File | Changes | Functions |
|------|---------|-----------|
| `rtase.h` | +4 lines (register + bit defs) | enum/constants only |
| `rtase_main.c` | +3 lines | `rtase_hw_config()` |

**Scope:** Single-file surgical fix in one function (+ header
constants). ~7 lines total.

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`rtase.h`):** Adds `RTASE_GPHY_STD_00 = 0x6024` and
  `RTASE_RXFLOW_EN`/`RTASE_TXFLOW_EN` bit definitions.
- **Hunk 2 (`rtase_main.c`, init path):** Before enabling flow control
  via `RTASE_CPLUS_CMD`, reads `RTASE_GPHY_STD_00`, clears TX/RX flow
  bits, writes back. Then existing CPLUS_CMD enable proceeds unchanged.

**Before:** Only `RTASE_CPLUS_CMD` bits managed; GPHY bits could
independently enable flow control.
**After:** GPHY bits cleared at init; CPLUS_CMD is sole effective
control path for driver/ethtool.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Hardware quirk / logic correctness fix.
**Mechanism:** Hardware OR-combines two register sets; driver assumed
single control path. Clearing the GPHY set at init removes the shadow
enable path.

### Step 2.4: Fix Quality
**Record:** Obviously correct per commit message and hardware behavior
described. Minimal, no API changes. Low regression risk — only clears
two bits once during `rtase_hw_config()`. `rtase_hw_config()` is called
from open, reset, and resume paths (lines 1116, 1746, 2577).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Flow-control lines at 979–982 introduced in `5d324e5159d9e`
(2025-11-28, 6.18-rc8 merge). Bug present since driver introduction in
this tree. No `RTASE_GPHY_STD_00` references anywhere in current HEAD.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: File History
**Record:** Recent rtase commits in this tree:
- `4a4f3aa6af205` — TX hang workaround
- `1bf84f4013fac` — TX subqueue reset
- `54f9cdcd73118` — get_stats64() sleep fix

Standalone fix; not part of a multi-patch series. Patch submission was
v2 (v1→v2: rebase + expanded message only).

### Step 3.4: Author Context
**Record:** Justin Lai is listed maintainer in MAINTAINERS for
`drivers/net/ethernet/realtek/rtase/`. Three prior rtase fixes already
in this tree.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses existing `rtase_r16()`/`rtase_w16()`
helpers. Applies cleanly to current HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Thread at https://lore.kernel.org/netdev/20260505064121.3128
6-1-justinlai0215@realtek.com/ — submitted as `[PATCH net-next v2]`.
Andrew Lunn reviewed: *"Odd design."* + Reviewed-by. No NAKs, no stable
nomination, no user bug reports.

### Step 4.2: Reviewers
**Record:** CC'd: kuba@kernel.org, davem@davemloft.net,
edumazet@google.com, pabeni@redhat.com, andrew+netdev@lunn.ch,
netdev@vger.kernel.org, Realtek maintainers.

### Step 4.3: Bug Reports
**Record:** No external bug reports, syzbot, or crash traces. Vendor-
discovered hardware behavior issue.

### Step 4.4: Related Patches
**Record:** v1→v2 only changed rebase and commit message. Standalone.

### Step 4.5: Stable List
**Record:** No discussion found on lore stable list for "rtase flow
control".

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `rtase_hw_config()` (modified), `rtase_get_pauseparam()`,
`rtase_set_pauseparam()` (unchanged but affected).

### Step 5.2: Callers of `rtase_hw_config()`
**Record:**
- `rtase_open()` — netdev open (userspace `ip link set up`)
- Reset path (~line 1746) — after ring reinit
- Resume path (~line 2577) — PM resume

Common device bring-up and recovery paths.

### Step 5.3: Callees
**Record:** `rtase_r16()`, `rtase_w16()` — standard MMIO register
access.

### Step 5.4: Reachability
**Record:** Triggered on every interface open/reset/resume for
`CONFIG_RTASE` hardware (Realtek RTL9054/9068/9072/9075/9071 PCIe).
Userspace can change pause via `ethtool -A`; broken without fix.

### Step 5.5: Similar Patterns
**Record:** No other GPHY flow-control handling in rtase driver.
`rtase_set_pauseparam()` still only touches `RTASE_CPLUS_CMD` — correct
once GPHY bits are cleared at init.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Current HEAD at lines 979–982 enables flow control
via `RTASE_CPLUS_CMD` only; no `RTASE_GPHY_STD_00` handling. Bug present
since `5d324e5159d9e` (Nov 2025).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Fix commit object `73d7d1b6e1d8c`
exists locally but is NOT an ancestor of HEAD (`git merge-base --is-
ancestor` exit 1). Patch not yet merged into this checkout.

### Step 6.3: Related Fixes Already Present?
**Record:** **NO.** `grep RTASE_GPHY_STD_00` returns no matches in tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/net/ethernet/realtek/rtase/` — network driver,
**PERIPHERAL** (automotive PCIe Ethernet switch chips). Affects users
with `CONFIG_RTASE` hardware only.

### Step 7.2: Subsystem Activity
**Record:** New driver in 6.18 with active post-merge fixes (TX hang,
stats, subqueue). Actively maintained.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Realtek automotive Ethernet PCIe devices with
`CONFIG_RTASE` built-in or as module.

### Step 8.2: Trigger Conditions
**Record:** Any time hardware leaves `RTASE_GPHY_STD_00` flow-control
bits set (default after reset) and user attempts to disable pause via
ethtool, or reads pause state via ethtool after disabling. Common on
every device probe/open. Unprivileged users can trigger via ethtool on
the netdev.

### Step 8.3: Failure Mode Severity
**Record:** Flow control remains enabled when userspace believes it is
disabled; `ethtool -a` reports incorrect state. Can cause unexpected
pause-frame behavior, network tuning failures, or interoperability
issues. **Severity: MEDIUM** (functional/incorrect reporting, not
crash/corruption/security).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — restores correct ethtool pause behavior on
  supported hardware; fixes kernel/userspace state mismatch.
- **Risk:** VERY LOW — 7 lines, register clear at init only, reviewed by
  netdev reviewer.
- **Ratio:** Favorable for a hardware-quirk-style init fix on a driver
  that already exposes ethtool pause API.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible hardware behavior bug (dual OR'd register sets)
- Breaks user-visible ethtool pause API
  (`get_pauseparam`/`set_pauseparam`)
- Small, surgical, reviewed fix
- Buggy code present in 6.18.43 since driver introduction
- Fits hardware quirk/workaround exception category
- Driver maintainer-authored fix

**AGAINST backport:**
- No crashes, data corruption, security, or deadlock
- No user/fuzzer reports — vendor-found during development
- Niche hardware (automotive Realtek switches)
- Driver brand-new in 6.18

**Unresolved:** Whether GPHY bits can be re-set at runtime by firmware
(fix assumes init-time clear is sufficient; commit message supports
this).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — clear register semantics,
   Reviewed-by Andrew Lunn; no runtime test reports.
2. Fixes real bug affecting users? **PASS** — ethtool pause control
   ineffective/misreported.
3. Important issue? **PASS (borderline)** — incorrect netdev
   configuration and userspace/kernel state mismatch on real hardware;
   hardware quirk category.
4. Small and contained? **PASS** — 7 lines, 2 files, one function.
5. No new features/APIs? **PASS** — register init only.
6. Can apply to local tree? **PASS** — driver and buggy code exist;
   clean apply.

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — clearing default hardware
register bits so driver-controlled flow control via ethtool works
correctly.

### Step 9.4: Problem and Decision Rationale

The rtase driver exposes ethtool pause parameters but only programs
`RTASE_CPLUS_CMD`. The Realtek hardware also has independent flow-
control enable bits in `RTASE_GPHY_STD_00` that are OR'd with the CPLUS
bits. Without clearing the GPHY bits at initialization, users cannot
reliably disable flow control, and `ethtool -a` can report a state that
does not match hardware.

For the 6.18.43 tree checked out here, the rtase driver exists with this
bug since its introduction. The fix is minimal, self-contained, and
matches the established stable pattern for hardware register workarounds
that make existing driver interfaces work correctly on real devices.

---

## Verification

- **[Phase 1]** `make kernelversion` → 6.18.43; `git describe HEAD` →
  v6.18.43-1-gc7f0dac02d232
- **[Phase 1]** Parsed commit message tags from user-provided diff and
  lore mbox
- **[Phase 2]** Read `rtase_main.c` lines 979–982 (buggy code) and
  2025–2054 (ethtool pause handlers)
- **[Phase 2]** Confirmed diff: +4 lines in `rtase.h`, +3 lines in
  `rtase_hw_config()`
- **[Phase 3]** `git blame -L 979,982` → introduced in `5d324e5159d9e`
  (2025-11-28)
- **[Phase 3]** `git log --oneline --
  drivers/net/ethernet/realtek/rtase/` → 4 commits total
- **[Phase 3]** `git show
  5d324e5159d9e:drivers/net/ethernet/realtek/rtase/rtase_main.c` → same
  buggy flow-control code at introduction
- **[Phase 4]** Fetched lore mbox via curl from lore.kernel.org — v2
  patch, Andrew Lunn Reviewed-by, no stable nomination
- **[Phase 4]** No stable-list hits for "rtase flow control"
- **[Phase 5]** `grep rtase_hw_config` → called at lines 1116, 1746,
  2577
- **[Phase 5]** `grep RTASE_GPHY_STD_00` in rtase/ → no matches (fix not
  in HEAD)
- **[Phase 6]** `git merge-base --is-ancestor 73d7d1b6e1d8c HEAD` → exit
  1 (fix not merged)
- **[Phase 6]** `git show 73d7d1b6e1d8c --stat` → commit object exists
  locally
- **[Phase 6]** `git log HEAD..73d7d1b6e1d8c` → fix commit is ahead of
  HEAD
- **[Phase 7]** MAINTAINERS entry confirms Justin Lai as rtase
  maintainer
- **[Phase 7]** Kconfig confirms RTASE targets
  RTL9054/9068/9072/9075/9071 PCIe devices
- **[Phase 8]** Failure mode: incorrect ethtool pause state, severity
  MEDIUM

**YES**The background check for whether the flow-control fix is already
in your tree timed out on `git branch -a --contains` (likely due to a
large ref set). I killed that and re-ran a simpler check.

**Result:** commit `73d7d1b6e1d8c` (`rtase: Fix flow control
configuration`) is **not** in your current HEAD (`6.18.43`). The buggy
code is still present — `rtase_hw_config()` only sets `RTASE_CPLUS_CMD`
and never clears `RTASE_GPHY_STD_00`.

**Backport verdict (unchanged):** **YES** — small hardware quirk fix so
ethtool pause settings work on rtase hardware in this tree.

 drivers/net/ethernet/realtek/rtase/rtase.h      | 4 ++++
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase.h b/drivers/net/ethernet/realtek/rtase/rtase.h
index 43087b17a0ff2..03b12d83f6e9d 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase.h
+++ b/drivers/net/ethernet/realtek/rtase/rtase.h
@@ -153,6 +153,10 @@ enum rtase_registers {
 #define RTASE_FORCE_TXFLOW_EN BIT(10)
 #define RTASE_RX_CHKSUM       BIT(5)
 
+	RTASE_GPHY_STD_00 = 0x6024,
+#define RTASE_RXFLOW_EN BIT(7)
+#define RTASE_TXFLOW_EN BIT(6)
+
 	RTASE_Q0_RX_DESC_ADDR0 = 0x00E4,
 	RTASE_Q0_RX_DESC_ADDR4 = 0x00E8,
 	RTASE_Q1_RX_DESC_ADDR0 = 0x4000,
diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index bc9b14614f7a7..e3cd4f7c13804 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -977,6 +977,9 @@ static void rtase_hw_config(struct net_device *dev)
 	rtase_hw_set_features(dev, dev->features);
 
 	/* enable flow control */
+	reg_data16 = rtase_r16(tp, RTASE_GPHY_STD_00);
+	reg_data16 &= ~(RTASE_TXFLOW_EN | RTASE_RXFLOW_EN);
+	rtase_w16(tp, RTASE_GPHY_STD_00, reg_data16);
 	reg_data16 = rtase_r16(tp, RTASE_CPLUS_CMD);
 	reg_data16 |= (RTASE_FORCE_TXFLOW_EN | RTASE_FORCE_RXFLOW_EN);
 	rtase_w16(tp, RTASE_CPLUS_CMD, reg_data16);
-- 
2.53.0

