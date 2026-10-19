Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AFC639ACE;
	Mon, 19 Oct 2026 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418756; cv=none; b=DZWnWYKgQGEXMMSVvcwPhgW0BH4y0xYbAb4+heT5eCzIPIxYZjm+Flg/gbARUNwYGYN/LDoPFV90pL8qxYbgrsWzXjSfktT7Z/ROMJKpBxkes6PDUxVqr5aIq8Wn3wrhgJ/LXMhb2rf1kNRmolDTq6WJrX3KbxFRtym/Ji8sCtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418756; c=relaxed/simple;
	bh=Yf5Zi1ZG1Pr0N7N3RptiN5ozHM77ve8Zfc3vUT3O4Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yo5dYWxisJWSEOUB0rWOhya4A14C/H+Eq2L6kydUIPv9VLpVHed0x7vi6+vdpatW1JFhe5vInK50CG129T30F4S3FewhoFQBViJqTLQvsF5/2MYsLLJaY4idnnK+tB5ETbYSXwNCgm8oPJusAk667mDjClk2GKK3BJXjzUgTFTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5vsjQ+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5vsjQ+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F211F000C4;
	Mon, 19 Oct 2026 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418754;
	bh=gnaWpt4R9lUhHBkyiNEc2cDWssTbHpo6CPzBNunzywA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5vsjQ+co875Pmgk80Cvjjec3f9BYTI/8uXyWJljfNO4dttTLNVu6WLMgfB5zxPfQ
	 tkQ8BgYbdS0OhylSy1j6jvy4qxXIotenJKk8Sv/rgTIms2BBg+RW0wa42eNE++0TjM
	 eOj9rN/XgoCG0QrSK6CxOO2FanvOFrkOaP5wsjPWSHXDpw+9mvPPvy1ekA5eJcyrtw
	 p4xHht3l1VDsU7zNDfPJw1cHjyLX9mcjaZzc0zI/hnmSglYcQ1OaZ6b4WhwBKL8Zk0
	 jwebYxXgl+PVzuOk5cyd8bJp4FgoUV+UrmCRO1zByd34Eoi2p/7JSw4Ql4+3IR0Ani
	 FpIDTfnYs21Qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oleg Proshkin <oleg.pro171@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] mfd: axp20x: Preserve other control bits when powering off
Date: Mon, 19 Oct 2026 09:52:43 -0400
Message-ID: <20261019135441.1420968-472-sashal@kernel.org>
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

From: Oleg Proshkin <oleg.pro171@gmail.com>

[ Upstream commit 3756bf05c963563f1325af105356541882dd5899 ]

axp20x_power_off() triggers shutdown by writing AXP20X_OFF (BIT(7)) to
the power-off control register with regmap_write(), which rewrites the
whole register and clears other control bits in it.

On the AXP221/AXP223 (and the register-compatible AXP228) - that
register also holds the CHGLED auto-control bit.
Clearing it during an orderly shutdown disables the hardware charge
indicator, so the charge LED stays dark while the board is powered off
and charging. Other variants keep unrelated configuration in the same
register too.

Set only the power-off bit with regmap_set_bits() and leave the rest of
the register untouched. The shutdown register is readable on every
variant, so the read-modify-write should be safe.

Tested on a ClockworkPi uConsole (Raspberry Pi Compute Module 4, AXP228,
which enumerates as AXP221): register AXP20X_OFF_CTRL reads 0x08 at
runtime, so the old code left it 0x80 whereas setting only BIT(7)
leaves 0x88. Writing 0x88 at power-off enables the charge LED
while still powering off the PMIC.

Signed-off-by: Oleg Proshkin <oleg.pro171@gmail.com>
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/20260611154629.76607-1-oleg.pro171@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 3)...
Retry attempt 3...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 4)...
Retry attempt 4...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 5)...
Retry attempt 5...
This is a 6.1.y tree (Makefile 6.1.188, `pending-6.1`, `git describe`
`p-6.1-9-g27ef8181b8a64`). The candidate is not an ancestor of HEAD. The
buggy full-register write is present in this tree’s
`axp20x_power_off()`.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[mfd/axp20x] [Preserve] Keep other bits in the PMIC shutdown
register when setting the power-off bit**

**Step 1.2 — Tags**
Record:
- Reviewed-by: Chen-Yu Tsai `<wens@kernel.org>` (Allwinner/sunXi
  maintainer)
- Link: `https://patch.msgid.link/20260611154629.76607-1-
  oleg.pro171@gmail.com`
- Signed-off-by: Oleg Proshkin (author); Lee Jones (MFD maintainer)
- No Fixes:, Reported-by, Tested-by, Cc: stable, or syzbot tags (absence
  is expected)

**Step 1.3 — Body**
Record:
- Bug: `axp20x_power_off()` uses `regmap_write(..., AXP20X_OFF)` (BIT(7)
  only), which zeros every other bit in the shutdown/CHGLED control
  register.
- Symptom: On AXP221/AXP223/AXP228, CHGLED auto-control is cleared, so
  the charge LED stays dark while the board is powered off and charging.
  Author notes other variants store unrelated config in the same
  register.
- Root cause: whole-register write instead of set-bit RMW.
- Evidence: ClockworkPi uConsole (CM4 + AXP228 as AXP221); runtime
  `AXP20X_OFF_CTRL` is 0x08; old write produces 0x80, bit-set produces
  0x88 and the LED works.
- Author states the register is readable on every variant, so RMW is
  safe.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. Explicit hardware-correctness fix (register clobber
at shutdown).

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: `drivers/mfd/axp20x.c` only; 1 insertion, 1 deletion. Function:
`axp20x_power_off`. Surgical single-file change.

**Step 2.2 — Code flow**
Record: Before: write 0x80 to the shutdown register, clearing bits 6–0.
After: `regmap_set_bits()` ORs BIT(7) and leaves the rest. Shutdown path
only (orderly power-off).

**Step 2.3 — Bug mechanism**
Record: **Logic/correctness + hardware control-register clobber.**
`regmap_write` of a single bit value wipes CHGLED/battery-detect/N_OE-
related fields in REG 0x32. Fix is RMW via `regmap_set_bits`.

**Step 2.4 — Fix quality**
Record: Obviously correct one-line change. `regmap_set_bits` in this
tree is `regmap_update_bits_base(map, reg, bits, bits, ...)`. Regression
risk is low: one extra cached RMW at shutdown. 0x32 is not in axp22x
volatile ranges (0x04–0x4c is writeable; 0x32 is not volatile), so RMW
can use the cache. Mainline context (`sys_off_data`, AXP313 switch) is
not in 6.1, so the raw patch does not apply; the equivalent change is
still one write→set_bits.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: The full-register write is from **cfb61a419630a8** (“mfd:
AXP20x: Add mfd driver for AXP20x PMIC”, Carlo Caione, 2014-05-01, first
appeared **v3.16-rc1**). Present for the entire 6.1 lifetime. AXP288
skip is af7e9069543aab (2014). Delay is 179dc63d06c51 (2016);
`msleep`→`mdelay` is 3bcc06c5fd484 (already in this tree).

**Step 3.2 — Fixes: tag**
Record: None. Introducer is cfb61a419630a8, which **is** an ancestor of
HEAD.

**Step 3.3 — File history**
Record: Recent 6.1 file history is unrelated (GPIO cells, AXP288 ranges,
`mdelay` in power-off). No prior CHGLED/bit-preserve fix. Standalone,
not patch x/y.

**Step 3.4 — Author**
Record: Oleg Proshkin has no other `drivers/mfd/` commits in this tree.
Reviewer Chen-Yu Tsai is ARM/Allwinner sunXi maintainer; Lee Jones is
MFD maintainer.

**Step 3.5 — Dependencies**
Record: Mainline uses `sys_off_data` (v6.3) and AXP313a register select
(v6.5). Those are **not** required for the fix. 6.1 already has
`regmap_set_bits` and `AXP20X_OFF_CTRL`. Standalone with a 1-line
context adaptation.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record: `b4 dig -c 3756bf05c96356` →
https://patch.msgid.link/20260611154629.76607-1-oleg.pro171@gmail.com
`b4 dig -a`: single **v1**, no later revisions.
Chen-Yu Tsai: “Makes sense.” + Reviewed-by (openwall 2026-06-12).
Lee Jones applied 2026-06-18 (lkml.iu.edu); no NAK, no stable-risk
comments. lore.kernel.org fetches returned 403; discussion recovered via
b4 and mirrors.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: Oleg Proshkin, Chen-Yu Tsai, Lee Jones, linux-kernel@. Right
maintainers were on the patch.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla. Hardware test is in the commit (ClockworkPi
uConsole, measured 0x08 vs 0x80 vs 0x88).

**Step 4.4 — Series**
Record: Standalone 1/1. No dependents.

**Step 4.5 — Stable list**
Record: lore.kernel.org/stable returned 403. No evidence this was
rejected for stable. UNVERIFIED: no stable-ML thread found.

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
Record: `axp20x_power_off` only.

**Step 5.2 — Callers (this tree)**
Record: Probe sets `pm_power_off = axp20x_power_off` when unset. Invoked
from the kernel power-off path (`kernel_power_off` /
`do_kernel_power_off`). Not IRQ, not a hot path. AXP288 returns
immediately (same as mainline skipping that variant).

**Step 5.3 — Callees**
Record: `regmap_write` today; `regmap_set_bits` after the fix;
`mdelay(500)`.

**Step 5.4 — Reachability**
Record: Yes — `shutdown`/`poweroff` from userspace. Affects
AXP221/223/202/209/803/809/813/806/152 boards that register this
handler. AXP221 is a first-class compatible in `axp20x-i2c.c`.

**Step 5.5 — Similar patterns**
Record: Power-supply code in this tree does not program
`AXP20X_OFF_CTRL`; CHGLED bits come from hardware/boot default (0x08
matches bit 3). No sibling fix already present.

## Phase 6: This tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** HEAD:

```
regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL, AXP20X_OFF);
```

AXP221/AXP223 match and `x-powers,axp221` compatible exist. Bug since
v3.16.

**Step 6.2 — Backport difficulty**
Record: **Minor conflicts / trivial rework.** `git apply --check` of the
mainline hunk fails (`shutdown_reg` / `sys_off_data` not in 6.1).
Equivalent backport:

```
- regmap_write(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
- AXP20X_OFF);
+       regmap_set_bits(axp20x_pm_power_off->regmap, AXP20X_OFF_CTRL,
+                       AXP20X_OFF);
```

**Step 6.3 — Related fixes already here?**
Record: No. Only power-off history is the 500ms delay and `mdelay`
conversion.

## Phase 7: Subsystem context

**Step 7.1**
Record: **MFD / X-Powers AXP20x PMIC.** Criticality **IMPORTANT** for
Allwinner/ARM boards (Pine64, many SBCs, ClockworkPi). Not core mm/fs,
not staging.

**Step 7.2**
Record: Mature driver (2014). 6.1 file log is slow-moving; this is an
old bug, not churn from new code.

## Phase 8: Impact and risk

**Step 8.1 — Who**
Record: Driver-specific: AXP20x/22x users on orderly shutdown,
especially AXP221/223/228 with a charge LED. Config:
`CONFIG_MFD_AXP20X`.

**Step 8.2 — Trigger**
Record: Every orderly power-off on those PMICs. Unprivileged users can
typically run shutdown if policy allows; not a remote exploit path.

**Step 8.3 — Failure mode**
Record: PMIC REG 0x32 clobbered at power-off. User-visible: charge LED
off while charging with SoC down. Other bits in the same register
(battery detect / CHGLED mode / related config) are also cleared.
**Severity: MEDIUM** (hardware misprogramming, not
oops/corruption/deadlock).

**Step 8.4 — Risk/benefit**
Record: Benefit medium for battery AXP boards (indicator and leftover
PMIC config). Risk **very low** (1-line RMW, cached register,
maintainer-reviewed, hardware-tested). Ratio favors backport.

## Phase 9: Synthesis

**For:** Real, tested hardware bug; 1-line obviously correct RMW;
AXP221/223 exist in 6.1; bug since 2014; Chen-Yu Tsai + Lee Jones;
`regmap_set_bits` already here; shutdown path only.

**Against:** Not a crash/security/corruption bug; mainline hunk needs a
trivial context adapt; no Fixes:/Cc: stable (not a negative).

**Unresolved:** lore.kernel.org 403; no stable-ML thread retrieved.

**Stable rules**
1. Obviously correct and tested? **PASS** — RMW vs full write; tested
   0x08→0x88; Reviewed-by maintainer.
2. Real user-facing bug? **PASS** — charge LED dead after shutdown while
   charging.
3. Important (crash/security/corruption/deadlock)? **PASS** (borderline)
   — PMIC control register clobber at power-off; LED is the reported
   symptom, not a panic. Small enough that this still belongs in LTS.
4. Small and contained? **PASS** — one call site.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** with a one-line backport (raw
   mainline patch fails `git apply --check`).

**Exception:** Not a new ID/DT/build fix. Closest category is hardware-
correctness/quirk-class behavior.

This tree should get the fix: the buggy write is here, AXP221 is
supported, and the adapted change is a single `regmap_set_bits` on
`AXP20X_OFF_CTRL`.

Verification:
- [Phase 1] Tags: Reviewed-by Chen-Yu Tsai, Link msgid, SOBs Oleg/Lee;
  no Fixes/syzbot
- [Phase 2] Diff: `regmap_write` → `regmap_set_bits` in
  `axp20x_power_off`
- [Phase 3] `git blame HEAD -L 835,848`: write from cfb61a419630a8
  (v3.16-rc1); `git merge-base --is-ancestor cfb61a419630a HEAD`
  succeeded
- [Phase 3] `git merge-base --is-ancestor 3756bf05c96356 HEAD` failed
  (candidate not in 6.1)
- [Phase 4] `b4 dig -c 3756bf05c96356`: lore msgid; `-a` v1 only; `-w`
  wens+lee+lkml
- [Phase 4] Chen-Yu “Makes sense.”; Lee Jones applied; lore.kernel.org
  HTTP 403
- [Phase 5] HEAD probe assigns `pm_power_off = axp20x_power_off`; AXP221
  compatible in `axp20x-i2c.c`
- [Phase 6] HEAD Makefile 6.1.188; describe `p-6.1-9-g27ef8181b8a64`;
  branch `pending-6.1`
- [Phase 6] HEAD still has `regmap_write(..., AXP20X_OFF_CTRL,
  AXP20X_OFF)`; `git apply --check` of the mainline hunk fails
- [Phase 6] `regmap_set_bits` exists; 0x32 in axp22x writeable 0x04–0x4c
  and not volatile
- [Phase 8] Failure: CHGLED/other bits cleared at power-off; severity
  MEDIUM
- UNVERIFIED: stable@ mailing list (lore/stable 403)

**YES**

 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index c5f0ebae327f5..85506813f089c 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -1250,7 +1250,7 @@ static int axp20x_power_off(struct sys_off_data *data)
 		break;
 	}
 
-	regmap_write(axp20x->regmap, shutdown_reg, AXP20X_OFF);
+	regmap_set_bits(axp20x->regmap, shutdown_reg, AXP20X_OFF);
 
 	/* Give capacitors etc. time to drain to avoid kernel panic msg. */
 	mdelay(500);
-- 
2.53.0

