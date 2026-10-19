Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841314FB9B3;
	Mon, 19 Oct 2026 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418087; cv=none; b=EpjhU0MEx4ZmE1Y5iUbM0MIzz5lhnnXYwDibeTrTFYfIBHGDz8WF8SWw8LJAkwwu4U+XpxwFg7UBizvNxWcJOhY1jQ+UR3HmAsmu+Tl9klH7OCNkysaDPwYF+M4psioxgM4FvqWIUFDKOhSD9/JwUwsMAHUs4yOEFdPO3D77hbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418087; c=relaxed/simple;
	bh=mn5hukJcRtbyeAxIN4fIXF2f2sf5d9hrj7E/AZtdEkA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qrTEz9wl2/ccD81LIRRw+UGaxEzrx6V7aSTaE+svEbhspLgcAJ+GAQq94+ZZ7FJc747vBMiA4J8L/Zg8JISdi7wnkiYd8n1zD5ETG6g7as8KRgGm/5+dA5Jr5VgLyQfdYutqYw1qTs1gjcRaNoNk+n81xeYgg3FSglgtMHpb5kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfEUdrgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfEUdrgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A381F000C5;
	Mon, 19 Oct 2026 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418084;
	bh=+rMuxlEzta/xwXzh9GPR/CubwMf9s0sAxRcpqXWWx8M=;
	h=From:To:Cc:Subject:Date;
	b=WfEUdrgfwgbrC9/23O5Nbaey4oT1D1nSaA9w/0Z22Nh+9PYIX4hDk/z3+I4zagQoE
	 73DJAxYXXPVxhygfubRJ5YpPDtvlGyQSE1xHylG6agT3TTT7Hkppl+IWlEdmCPqS32
	 aysGmuhkqryms/zDxuJf6PVZXZ+StAmU9+WDJ2DKgEdUyjvad4xO0j3hwphw4ZaHc8
	 Z1ep0klBKA3rgVA+n6nT903PGhtLOyi0Qz82IjcW4uh9sCK7O0CURZT8g/7naOoubN
	 AEruD50qqmeRMfd82wxkdxqdN47ivlkPRw0dtg+CaQpF6zVkXkUrys4lJQd12ENlTy
	 wfXr0PeRqFAGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	chester.a.unal@arinc9.com,
	andrew@lunn.ch,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] net: dsa: mt7530: check CORE_PLL_GROUP4 access in mt7531_setup()
Date: Mon, 19 Oct 2026 09:44:52 -0400
Message-ID: <20261019135441.1420968-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 1ae63b018d3d70e96d420b59a1334860cf232bc6 ]

mt7531_setup() reads CORE_PLL_GROUP4 through the MT7531 indirect c45
PHY access, modifies it and writes it back to enable the PHY core
PLL, but checks neither the read nor the write. Now that the indirect
access functions propagate command-write failures, a failed read
returns a negative errno that would be bit-modified and written back
into the PLL register, and a failed write-back would go unnoticed.
Check both and bail out. The adjacent EEE advertisement writes push a
constant value and cannot corrupt state, so they are left as is.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://patch.msgid.link/a7dfe3b66ea6ac1ae7915034de0527060e6ddcd4.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real, small error-path fix for this 6.12 tree: an unchecked
CORE_PLL_GROUP4 RMW can write a negative errno into the MT7531 PHY PLL.
The buggy code is present here, and a related callee change already
landed.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: `[net: dsa: mt7530]` `[check]` Check CORE_PLL_GROUP4 read/write
results in `mt7531_setup()`. “check” is used as a missing-return-value
fix, not a feature add.

**Step 1.2 — Tags (from the candidate message)**
Record:
- `Signed-off-by: Daniel Golle <daniel@makrotopia.org>` (author)
- `Link: https://patch.msgid.link/a7dfe3b66ea6ac1ae7915034de0527060e6ddc
  d4.1785811140.git.daniel@makrotopia.org`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer
  applied it)

Ignored per instructions: any pipeline “already selected” markers.

Original mailing-list version (openwall/lkml, same msgid) also had:
- `Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531
  switch")`
- No `Cc: stable`, no `Reported-by`, no `Reviewed-by` on this patch
  itself

Cover letter for the series: Andrew Lunn’s `Reviewed-by` was collected
on patches 1–3 and 6, not on this one (it was new in v2).

**Step 1.3 — Body**
Record:
- Bug: `mt7531_setup()` RMW of `CORE_PLL_GROUP4` via
  `mt7531_ind_c45_phy_read/write` does not check either result.
- Failure mode: a failed read returns a negative errno that is bit-
  modified and written into the PHY core PLL; a failed write is ignored.
- Author’s framing: this became acute once the indirect helpers
  propagate command-write failures.
- Adjacent EEE advertisement writes are constant `0`, so they cannot
  corrupt RMW state and are left alone.

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. It is an explicit missing-error-check fix. The “now
that …” wording is series context (patch 3/6), not a cleanup-only
change.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record:
- File: `drivers/net/dsa/mt7530.c` only
- Function: `mt7531_setup()`
- ~10 insertions, ~4 deletions (candidate hunk); net +6 lines of checks
- Scope: single-file surgical caller fix

**Step 2.2 — Flow**
Record: Before, `u32 val = mt7531_ind_c45_phy_read(...)` then OR/AND
bits and write back, ignoring errors. After, store the `int` in `ret`,
return if `ret < 0`, copy into `val` only on success, check the write,
return on write failure. Probe/`sw_setup` fails instead of programming
PLL from an errno.

**Step 2.3 — Bug mechanism**
Record: **Logic / error-path correctness**, specifically “treat errno as
register data.”
- `mt7531_ind_c45_phy_read()` returns `int` (PHY data or negative
  errno).
- Assigned to `u32 val`, then modified (`MT7531_RG_SYSPLL_DMY2 |
  MT7531_PHY_PLL_BYPASS_MODE`, clear `MT7531_PHY_PLL_OFF`).
- Written through `mt7531_ind_c45_phy_write(..., u16 data)`, so a value
  such as `(u32)-ETIMEDOUT` (`0xFFFFFF92`) truncates to
  `0xFF92`/`0xFFD2` and is programmed into the PHY PLL.
- Write errors (already returned on poll timeout in this tree) are
  ignored.

**Step 2.4 — Fix quality**
Record: Obviously correct. `ret` is already declared in
`mt7531_setup()`. No API/locking/data-structure change. Regression risk
is that a failing MDIO access now fails switch setup instead of
continuing with a bogus PLL; that is the intended behavior. Risk of the
fix itself is very low.

## Phase 3: Git history

**Step 3.1 — Blame**
Record:
- Unchecked RMW originates in `c288575f7810` (Landen Chao, 2020-09-14):
  “Add the support of MT7531 switch”.
- Helper names/`MT753X_CTRL_PHY_ADDR` from later Arınç ÜNAL refactors
  (`868ff5f4944aa9`, `06dfcd4098cfdc`, 2024).
- Poll path in this tree already uses `regmap_read_poll_timeout()` from
  `96e0f5184af69` (Daniel Golle, applied 2026-08-09): “error out on
  failed reads in MT7531 PHY polling”.

**Step 3.2 — Fixes: target**
Record: `c288575f7810` **is** an ancestor of this tree. The original
MT7531 support (and this RMW) has been here since well before 6.12.

**Step 3.3 — Related file history**
Record:
- `96e0f5184af69` — already in this tree. Makes poll/read failures
  return negative errno instead of continuing with garbage “success”
  data.
- `93d46870c5440` — already in this tree. Same class: do not treat
  `bus->read()` errno as register data.
- This candidate is the missing **caller** check for the one in-driver
  RMW of `mt7531_ind_c45_phy_read()`.

**Step 3.4 — Author**
Record: Daniel Golle is a regular MT7530 contributor (PLL/PHY access,
MT7988, MT7531BE). Same author as the already-backported poll-error fix.

**Step 3.5 — Prerequisites**
Record: This is patch **4/6** of “fix remaining swallowed MDIO access
errors”. Patch 3 (`error out on failed PHY_IAC command writes`, upstream
`1c95dcb7e923`) is **not** in this tree. It is not required to compile
or to apply this hunk: the helpers already return `int`, and
`mt7531_ind_c45_phy_read/write` already return negative errno on
`regmap_read_poll_timeout()` failure. Patch 3 only adds extra error
returns from discarded `mt7530_mii_write()` of `MT7531_PHY_IAC`.
Standalone apply: **yes**.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
Record:
- `b4 dig` on the msgid failed (`Cannot find a commit matching …`).
- lore.kernel.org fetches returned 403.
- Fallback: openwall + lkml + cover letter.
- Lore/openwall URL: msgid `a7dfe3b66ea6ac1ae7915034de0527060e6ddcd4.178
  5811140.git.daniel@makrotopia.org` (Tue 4 Aug 2026).
- Cover: https://lists.openwall.net/netdev/2026/08/04/90
- This patch was **new in v2**, flagged by Sashiko AI review of v1 as
  another swallowed MDIO error.
- Cover letter: “the call site exposed once patch 3 makes the MT7531
  indirect c45 access propagate command-write failures.”
- Applied by Jakub Kicinski; patchwork bot lists upstream as
  `1ae63b018d3d`.
- No NAK found in the material that could be retrieved.

**Step 4.2 — Recipients**
Record: To/Cc included Andrew Lunn, Vladimir Oltean, netdev maintainers,
MediaTek/DSA people, `netdev@`, `linux-mediatek@`. Appropriate audience.
Andrew reviewed 1–3 and 6; this patch 4 had no `Reviewed-by` in the
submission.

**Step 4.3 — Bug report**
Record: No syzbot/bugzilla. Found by AI review of the MDIO-error series,
not a user crash report.

**Step 4.4 — Series**
Record: v2 6-patch series. Patches 1, 2, 3, 5, 6 are **not** in this
tree. This patch is self-contained at the `mt7531_setup()` call site.

**Step 4.5 — Stable list**
Record: No stable-specific discussion found (lore.kernel.org/stable
search did not return this subject). UNVERIFIED: whether anyone later
nominated it on stable@.

## Phase 5: Code semantic analysis

**Step 5.1 — Functions**
Record: `mt7531_setup()` only. Helpers `mt7531_ind_c45_phy_read/write`
are not modified.

**Step 5.2 — Callers**
Record:
- `mt7531_setup` is `.sw_setup` for `ID_MT7531` only (`mt753x_table`).
- `mt753x_setup()` calls `priv->info->sw_setup(ds)` and aborts on error.
- `mt753x_setup` is `.setup` in `mt7530_switch_ops` → DSA switch setup /
  probe.
- MT7988/EN7581 use `mt7988_setup()` → `mt7531_setup_common()`; they do
  **not** run this PLL RMW.

**Step 5.3 — Callees**
Record: `mt7531_ind_c45_phy_read/write` lock the MDIO mutex, write
`MT7531_PHY_IAC`, poll `MT7531_PHY_ACS_ST`. On poll/read failure they
`goto out` and return negative `ret`. `mt7530_mii_write()` already
returns `regmap_write` errors, but those returns are still discarded in
this tree (patch 3).

**Step 5.4 — Reachability**
Record: Probe-time only, when an MT7531 DSA switch is instantiated
(`CONFIG_NET_DSA_MT7530`). Not a syscall hot path. Userspace cannot
trigger it except by causing device probe. Trigger is MDIO/regmap
failure or IAC poll timeout during setup.

**Step 5.5 — Similar patterns**
Record: The only in-driver `mt7531_ind_c45_phy_read()` call site is this
PLL RMW. Other `mt7531_ind_c45_phy_write()` uses in the same function
are constant EEE-adv `0`. Phylib also uses these as `.phy_read_c45` /
`.phy_write_c45`.

## Phase 6: Local tree (6.12.111 / `pending-6.12`)

**Step 6.1 — Buggy code present?**
Record: **Yes.** `drivers/net/dsa/mt7530.c` `mt7531_setup()` still does:

```2665:2672:drivers/net/dsa/mt7530.c
        val = mt7531_ind_c45_phy_read(priv,
MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
                                      MDIO_MMD_VEND2, CORE_PLL_GROUP4);
        val |= MT7531_RG_SYSPLL_DMY2 | MT7531_PHY_PLL_BYPASS_MODE;
        val &= ~MT7531_PHY_PLL_OFF;
        mt7531_ind_c45_phy_write(priv,
MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
                                 MDIO_MMD_VEND2, CORE_PLL_GROUP4, val);
```

Bug introduced with MT7531 support (`c288575f7810`, v5.10-era). Present
in 6.12.

**Step 6.2 — Backport difficulty**
Record: **Clean apply** aside from line-number offset (2665 here vs 2764
in the candidate diff). Surrounding comments and EEE loop match. `ret`
is already in scope.

**Step 6.3 — Related fixes already here**
Record: `96e0f5184af69` already backported. That change makes failed IAC
polls/reads return errno into this unchecked caller, so this tree
already has the callee half of the fix without the caller half. No
equivalent caller check exists yet.

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/net/dsa/mt7530.c` — MediaTek MT7530/MT7531 DSA.
**IMPORTANT** for MediaTek routers/SBCs (MT7621/MT7622/MT7531), not core
mm/vfs. `CONFIG_NET_DSA_MT7530`.

**Step 7.2**
Record: File is actively maintained; recent 6.12 backports already
include two MDIO-error fixes from the same author.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
Record: Driver-specific: MT7531 switch users (common on MediaTek ARM
routers). Not MT7988/EN7581 setup (`mt7988_setup`).

**Step 8.2 — Trigger**
Record: MDIO/regmap failure or PHY_IAC poll timeout during `dsa_switch`
setup. Uncommon on healthy hardware. Not an unprivileged syscall
trigger. After `96e0f5184af69`, a failed bus read during poll is a
**negative errno**, not silent garbage success — so this caller bug is
easier to hit than before that backport.

**Step 8.3 — Failure mode**
Record: Hardware misconfiguration: PHY core PLL programmed from a
truncated errno instead of a real `CORE_PLL_GROUP4` value, then setup
continues. Switch can probe “successfully” with PHYs/PLL in a bad state.
Not a KASAN crash. Severity: **HIGH** for that hardware (silent wrong
PLL), not a generic kernel panic. Failing probe is the correct outcome.

**Step 8.4 — Risk/benefit**
Record:
- Benefit: medium-high for MT7531 — closes a hole opened/worsened by the
  already-applied poll-error backport; avoids writing errno into PLL.
- Risk: very low (6 lines of `if (ret < 0) return ret`).
- Ratio: favorable.

## Phase 9: Synthesis

**Evidence FOR**
- Real bug: negative errno used as PLL register data, then written back.
- Buggy RMW is in this 6.12 tree; `Fixes:` target `c288575f7810` is
  here.
- Companion to `96e0f5184af69`, already in this tree: that commit made
  failed reads return errno; this caller still treats the result as PHY
  data.
- Small, obviously correct, no new API, applies cleanly.
- Same class as other swallowed-MDIO fixes already accepted here
  (`93d46870c5440`, `96e0f5184af69`).
- Author intended it as a bug fix (`Fixes: c288575f7810` on the list).
- Applied to mainline by Jakub Kicinski (`1ae63b018d3d`).

**Evidence AGAINST**
- Error path only; no syzbot/user crash report.
- Driver-specific, probe-time, not a UAF/panic/CVE.
- Series patch 4/6; Andrew Lunn did not `Reviewed-by` this specific
  patch.
- Patch 3 (PHY_IAC command-write checks) is not in this tree; the
  author’s “now that writes propagate” story is only fully true after
  patch 3.

**Unresolved / UNVERIFIED**
- Full lore thread (403); no individual review replies beyond cover
  letter and patchwork apply notice.
- Whether patch 3 will be evaluated separately for this tree (not
  required for this hunk).

**Stable rules**
1. Obviously correct and tested? **PASS** — trivial return-value checks;
   merged to net by Kicinski.
2. Real bug affecting users? **PASS** — MT7531 setup can program PHY PLL
   from errno on MDIO/poll failure.
3. Important? **PASS** — hardware PLL corruption and silent “success”
   after a failed access; worsened by an already-backported callee fix.
   Not a generic oops, but it is serious for this switch.
4. Small and contained? **PASS** — one function, ~6 net lines.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS**.

**Exception category:** none (not a device ID/quirk/DT/build/docs
exception). It qualifies on ordinary bug-fix rules.

The missing patch 3 does not make this a NO: poll timeout and failed
`regmap_read_poll_timeout()` already return errno here, and those values
are what get written into `CORE_PLL_GROUP4` today.

### What it solves for this tree
On MT7531 probe, a failed indirect C45 read of `CORE_PLL_GROUP4` is
currently folded into the PLL enable RMW and written back. This tree
already backported the helper change that returns those failures as
errno. Without this caller check, 6.12 can program the PHY core PLL from
that errno and keep going. The fix fails setup instead. It is small,
matches local code, and does not need the rest of the series.

Verification:
- [Phase 1] Parsed subject/tags/body; list version has `Fixes:
  c288575f7810`; candidate message has Link + Golle/Kicinski SOBs
- [Phase 2] Diff: `mt7531_setup()` only; check read and write; `ret`
  already declared
- [Phase 3] `git blame` on 2660–2686: RMW from `c288575f7810`; helpers
  renamed later; poll uses `96e0f5184af69`
- [Phase 3] `git merge-base --is-ancestor c288575f7810 HEAD` → yes
- [Phase 3] `git merge-base --is-ancestor 96e0f5184af69 HEAD` → yes
  (callee error propagation already here)
- [Phase 3] `git log --grep="PHY_IAC command writes"` → patch 3 **not**
  in this tree
- [Phase 3] `git show 96e0f5184af69` confirms
  `regmap_read_poll_timeout()` returns negative on failed reads
- [Phase 4] `b4 dig` on msgid failed; lore 403; used openwall/lkml/cover
  letter; upstream SHA `1ae63b018d3d`; v2 new patch; Andrew reviewed 1–3
  and 6 only
- [Phase 4] UNVERIFIED: full review-reply text; stable@ thread
- [Phase 5] grep: only in-driver `mt7531_ind_c45_phy_read` call is this
  RMW; `.sw_setup = mt7531_setup` for `ID_MT7531`; `mt753x_setup()`
  returns that error
- [Phase 6] `git describe HEAD` → `p-6.12-4-gbf6fcdf761abd`; `make
  kernelversion` → 6.12.111; buggy code at mt7530.c:2665–2672
- [Phase 6] Pre-image matches the candidate hunk; clean apply expected
- [Phase 8] Failure mode: PHY PLL programmed from truncated errno on
  probe MDIO failure; severity HIGH for MT7531, trigger uncommon but
  real after `96e0f5184af69`

**YES**

 drivers/net/dsa/mt7530.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index d2dcc2f1522f4..4f391ef797ea3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2758,14 +2758,20 @@ mt7531_setup(struct dsa_switch *ds)
 	 * phy_[read,write]_mmd_indirect is called, we provide our own
 	 * mt7531_ind_mmd_phy_[read,write] to complete this function.
 	 */
-	val = mt7531_ind_c45_phy_read(priv,
+	ret = mt7531_ind_c45_phy_read(priv,
 				      MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
 				      MDIO_MMD_VEND2, CORE_PLL_GROUP4);
+	if (ret < 0)
+		return ret;
+
+	val = ret;
 	val |= MT7531_RG_SYSPLL_DMY2 | MT7531_PHY_PLL_BYPASS_MODE;
 	val &= ~MT7531_PHY_PLL_OFF;
-	mt7531_ind_c45_phy_write(priv,
-				 MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
-				 MDIO_MMD_VEND2, CORE_PLL_GROUP4, val);
+	ret = mt7531_ind_c45_phy_write(priv,
+				       MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
+				       MDIO_MMD_VEND2, CORE_PLL_GROUP4, val);
+	if (ret < 0)
+		return ret;
 
 	/* Disable EEE advertisement on the switch PHYs. */
 	for (i = MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr);
-- 
2.53.0

