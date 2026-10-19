Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E960A5008C2;
	Mon, 19 Oct 2026 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418302; cv=none; b=LUFmsJJtsgv5kYVhpkt5t5JVmd7y5wBHWzA/xppAbAZR1eTcENcx55DyOs9kk6tsDWQHPII8pLkKF4R7At+adjHv0r+E+GNy+pPMlo8MGsABn7iM8svC32BCy5SvyJFyb9woDJiWB7IgL/rTotsD5txEqmprYhd15qO6bkF2rG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418302; c=relaxed/simple;
	bh=MAdtxwr6f3VAecwvOqudrm6cmiGHaZfZFD4h5ULS8TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WaHfvinjIcKCpN6YYGtPEIYpWbWVXInugb51Y8p+7NwaZcq0NDS+LnnxNLJqjC5PRynk7vhbrUfZ8iXkr6VbUlt8AVAtaMbFceUhZpD6plgNL+XfgcMnFGhaeGp2H+fkNWP0BzaQiymipJojwwJxSdNyEa/qzSQ2u0T645olENk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHUS8quW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHUS8quW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAB71F000C4;
	Mon, 19 Oct 2026 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418299;
	bh=BTBIKoGo04d3IzgHbjrfw1sqtljCpDWG7rowks+b+mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHUS8quWC8KzYNoTfZ7r/q9r1hKVruusAVPlME6Qhh+25Xckfz/mui9Y51tiBpVHo
	 R/D1iYHIuOLJg9rjoB7X0W52Ey1VVpg5LWrhM2B3WmcT+JNO4CEZS8W4cDkenckMe1
	 4l8jBx5cv7WcTA0Izx4MyoxD05qzmE6Misoh4lhXPpw7GapHfUySHJZb5go+j5Ha0H
	 J/U+qj0tP6twmd3x8CunQmjPoonhuu5Wp3ekbTqUqDhxNa4lvQB2JcLOZLKKZO8uLV
	 X+NZ3sNPXVtWbu8FDeBeumWhVWRJW7BZLSzetZCOtfHP/NtAsGk1pT6a8d/WFHc5ll
	 eBBBfSm4QsG9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	chester.a.unal@arinc9.com,
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
Subject: [PATCH AUTOSEL 6.18-5.10] net: dsa: mt7530: error out on failed PHY_IAC command writes
Date: Mon, 19 Oct 2026 09:47:20 -0400
Message-ID: <20261019135441.1420968-149-sashal@kernel.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 1c95dcb7e923beebccdc79adc3dc1ec8c52295d0 ]

MT7531_PHY_ACS_ST is only ever set by the command write that precedes
each poll in the MT7531 indirect PHY access functions, and that
write's return value is discarded. A failed write leaves ACS_ST at 0
from the previous access, so the poll succeeds on its first iteration
and the functions return stale IAC contents as if they were fresh PHY
data. Check the writes and bail out before polling.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/c34602e63a20ebbfb97babd145c82832d7a0b523.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[net/dsa/mt7530] [error out] Check PHY_IAC command writes and
abort on failure instead of polling stale IAC contents.**

**Step 1.2: Tags**
Record (candidate message, ignoring pipeline SOBs):
- **Reviewed-by:** Andrew Lunn `<andrew@lunn.ch>` (DSA reviewer)
- **Link:** `https://patch.msgid.link/c34602e63a20ebbfb97babd145c82832d7
  a0b523.1785811140.git.daniel@makrotopia.org`
- **Signed-off-by:** Daniel Golle (author; MediaTek switch co-
  maintainer)
- **Signed-off-by:** Jakub Kicinski (netdev)
- No Reported-by / Tested-by / syzbot / Cc: stable in the candidate text

Independent of the candidate text, the original LKML submission also had
**`Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531
switch")`**. That tag is not used as a “already selected” signal; it
only identifies the introducing commit.

**Step 1.3: Body**
Record:
- **Bug:** `MT7531_PHY_ACS_ST` is set only by the command write before
  each poll. The write return is discarded.
- **Failure mode:** A failed write leaves ACS_ST at 0 from the previous
  access. The poll condition `!(val & MT7531_PHY_ACS_ST)` is already
  true, so the poll returns immediately and the helpers treat leftover
  IAC contents as a completed PHY access.
- **Symptom:** Reads return stale IAC data as PHY register values;
  writes return poll-success (`0`) even though the PHY was not written.
- **Root cause:** Missing error check on `mt7530_mii_write()` of
  `MT7531_PHY_IAC`.
- **Version info in body:** none. Introducing commit is from 2020.

**Step 1.4: Hidden bug fix?**
Record: **Not hidden.** This is an explicit error-propagation fix, not a
cleanup.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- **File:** `drivers/net/dsa/mt7530.c` only
- **Scope:** ~+12 / −6 (six identical two-line checks)
- **Functions:** `mt7531_ind_c45_phy_read`, `mt7531_ind_c45_phy_write`,
  `mt7531_ind_c22_phy_read`, `mt7531_ind_c22_phy_write`
- **Classification:** single-file surgical error-path fix

**Step 2.2: Code flow**
Record: each helper already polls until ACS_ST is clear, writes a
command with ACS_ST set, then polls again. **Before:**
`mt7530_mii_write()` result is ignored; polling always runs. **After:**
a negative write return jumps to `out`, which already unlocks the MDIO
mutex and returns `ret`.

**Step 2.3: Bug mechanism**
Record: **logic / error-path correctness.** ACS_ST is `BIT(31)` of
`MT7531_PHY_IAC` (`0x701C`). Poll success is “bit clear.” A failed
command write never sets that bit, so the poll succeeds on the first
iteration.

Verified on the write helpers: after a successful poll, `ret` is `0`
from `regmap_read_poll_timeout()`, so a failed PHY write is currently
reported as **success**. On reads, `ret = val &
MT7531_MDIO_RW_DATA_MASK` returns leftover IAC data as a 16-bit PHY
value.

**Step 2.4: Fix quality**
Record: **obviously correct.** Same `goto out` path already used for
poll failures. No new locks, APIs, or data structures. Regression risk
is low: only failed bus writes change behavior, and they now return the
real errno instead of fake success / stale data.

## Phase 3: Git history

**Step 3.1: Blame**
Record: the unchecked `mt7530_mii_write(..., MT7531_PHY_IAC, ...)` lines
were introduced in **`c288575f7810` (Landen Chao, 2020-09-11), “Add the
support of MT7531 switch”**. `mt7530_mii_write()` has returned `int`
since **`a08c045580e060` (2023-04-03, regmap conversion)**. Both are in
this tree.

**Step 3.2: Fixes: target**
Record: `git merge-base --is-ancestor c288575f7810 HEAD` succeeded. The
bug is in this 6.12 tree. No later local commit already checks these
writes (`ret = mt7530_mii_write(priv, MT7531_PHY_IAC` count is 0).

**Step 3.3: File history / related commits**
Record: this tree already contains the sibling **`96e0f5184af69`**
(`v6.12.103~217`), “error out on failed reads in MT7531 PHY polling”
(upstream `77a9ebe8818cf6`). That converted the polls to
`regmap_read_poll_timeout()` but left command writes unchecked. Also
present: **`93d46870c5440`**, “check bus->read() errors in the MDIO
regmap backend” — same author, same class of swallowed MDIO errors.

**Step 3.4: Author**
Record: Daniel Golle is listed as a **MEDIATEK SWITCH DRIVER**
maintainer. Other mt7530 error-propagation fixes by him are already in
this tree.

**Step 3.5: Dependencies**
Record: **standalone.** Needs `mt7530_mii_write()` returning `int` and
the existing `goto out` + mutex unlock — all present. It does **not**
need the rest of the later 6-patch series (`core_rmw`, CORE_PLL_GROUP4,
FDB/VLAN writes, IRQ serialization).

## Phase 4: Mailing list

**Step 4.1:** Candidate is not a local commit, so `b4 dig -c` on this
SHA was not possible. `b4 dig -c 96e0f5184af69` found the earlier poll-
timeout series. This patch was submitted as **`[PATCH net 3/4]`** then
**`[PATCH net v2 3/6]`** in “fix remaining swallowed MDIO access
errors.”
Record: lore/msgid `c34602e63a20ebbfb97babd145c82832d7a0b523.1785811140.
git.daniel@makrotopia.org`; LKML copy at
https://lkml.iu.edu/hypermail/linux/kernel/2608.0/04802.html. **v2: no
changes** to this patch. Cover letter: this write check was a companion
that had been folded into the already-applied PHY-polling patch and was
split out. No NAKs found.

**Step 4.2:** Recipients included DSA/netdev maintainers (Lunn, Oltean,
Kicinski, netdev). Andrew Lunn replied **Reviewed-by** with no requested
changes (https://www.spinics.net/lists/kernel/msg6350713.html).

**Step 4.3:** No syzbot or bugzilla. Mechanism is from code review
(cover letter: Sashiko AI review of the earlier series).

**Step 4.4:** Series mates are independent swallowed-error checks. This
hunk set does not depend on them.

**Step 4.5:** Search of lore.kernel.org/stable for this subject found
**no** prior stable discussion or rejection.

## Phase 5: Semantic / call graph

semcode MCP is not available; callers were found with grep.

**Step 5.1:** Functions listed in 2.1.

**Step 5.2: Callers**
- Wired as `phy_read/write_c22/c45` for **ID_MT7531, ID_MT7988,
  ID_EN7581** in `mt753x_table`.
- MDIO bus ops: `mt7530_setup_mdio()` sets
  `bus->read/write/read_c45/write_c45` to wrappers that call these
  helpers. That is the phylib/phylink path (link polling, PHY config).
- Direct: `mt7531_setup()` uses `mt7531_ind_c45_phy_read/write` for
  CORE_PLL_GROUP4 / EEE (those call sites still ignore the return; a
  later series patch addresses that and is **not** required for this
  MDIO-bus fix).

**Step 5.3: Callees**
`mt7530_mutex_lock/unlock`, `mt7530_mii_write` → `regmap_write`,
`regmap_read_poll_timeout`.

**Step 5.4: Reachability**
Yes, from userspace-visible networking: phylib MDIO reads/writes on
MT7531/MT7988/EN7581 switch PHYs. Trigger is a failed switch register
write (MDIO/MMIO/regmap error), not a rare debug ioctl.

**Step 5.5:** Same swallowed-error pattern already fixed for MDIO
backend reads and PHY_IAC **polls** in this tree. This is the remaining
write side of that PHY_IAC path.

## Phase 6: This tree (6.12.y)

**Step 6.1:** Local tree is **`pending-6.12` / 6.12.111**. All six
PHY_IAC command writes are still unchecked. Bug exists here.

**Step 6.2:** Current source matches the patch “before” context
(including `regmap_read_poll_timeout` from `96e0f5184af69`). **Expected
apply: clean.**

**Step 6.3:** No other local commit already checks these writes. The
poll-timeout backport left this hole open; this is the companion.

## Phase 7: Subsystem

**Step 7.1:** `drivers/net/dsa/mt7530.c` — MediaTek DSA switch.
**IMPORTANT** (not core mm/VFS, but common on MT7988/MT7531 routers,
OpenWrt, embedded). Config: `NET_DSA_MT7530`.

**Step 7.2:** File is actively maintained; several mt7530 fixes already
landed in this 6.12 branch.

## Phase 8: Impact and risk

**Step 8.1:** Users of MT7531, MT7988, and EN7581 switches (not
MT7530/MT7621, which use nested `mdiobus_*` instead of these indirect
helpers).

**Step 8.2:** Triggers on failed `regmap_write` of PHY_IAC. Unprivileged
users do not need a special exploit; phylib link/config traffic hits
this path. Frequency is error-path, but MDIO/MMIO glitches on these
boards are real.

**Step 8.3:** Failure mode: **silent wrong PHY data / false write
success**, not an oops. Phylib can see a live link or apply settings
that never reached the PHY. Severity: **HIGH** for networking
correctness on error; not a panic.

**Step 8.4:**
- **Benefit:** Completes the already-backported PHY_IAC poll hardening;
  stops fake-success writes and stale reads.
- **Risk:** Very low (12 lines, error path only).
- **Ratio:** Favorable.

## Phase 9: Synthesis

**For backporting**
- Real bug with a verified mechanism (ACS_ST only set by the discarded
  write).
- Write helpers currently return **0 on a failed PHY write**.
- Small, obviously correct, maintainer-authored, Reviewed-by Andrew
  Lunn.
- Buggy code and `Fixes:` target are in this 6.12 tree.
- Sibling poll-timeout fix is already here; this closes the remaining
  hole that series called out.
- Applies cleanly; no new API.

**Against**
- Error-path only (healthy bus never hits it).
- Driver-specific, not a universal crash/UAF.
- No user crash report; found by review.

**Unresolved**
- Could not `b4 dig` this exact SHA (not in the checkout); lore/LKML
  used instead.
- lore.kernel.org WebFetch returned 403; discussion taken from
  LKML/spinics.

**Stable rules**
1. Obviously correct and tested? **PASS** (Reviewed-by Lunn; merged via
   netdev)
2. Real user-visible bug? **PASS** (false MDIO success / stale PHY data)
3. Important? **PASS** (silent PHY misconfiguration; same class as
   already-backported mt7530 MDIO error fixes)
4. Small/contained? **PASS** (~12 lines, one file)
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS**

Not an ID/quirk/DT/docs exception; it qualifies as a normal contained
bugfix.

This should be backported to this 6.12 tree: the bug is present, the fix
is surgical, and it finishes error handling that 6.12 already took for
the same helpers.

Verification:
- [Phase 1] Parsed candidate tags: Reviewed-by Andrew Lunn, msgid link,
  Golle/Kicinski SOBs; original LKML also had Fixes: c288575f7810
- [Phase 2] Diff: six `ret = mt7530_mii_write(); if (ret < 0) goto out;`
  in four PHY_IAC helpers
- [Phase 2] Header: ACS_ST is BIT(31); poll waits for it clear —
  confirmed in mt7530.h
- [Phase 2] Write helpers return poll `ret` (0 on success) — failed
  write currently looks successful
- [Phase 3] Blame: writes from c288575f7810 (2020); ancestor of HEAD
- [Phase 3] Sibling 96e0f5184af69 already in tree (v6.12.103~217);
  93d46870c5440 MDIO read-error fix also in tree
- [Phase 3] `git log --grep='PHY_IAC command writes'` on this file:
  empty
- [Phase 4] LKML v2 3/6: “v2: no changes”; Lunn Reviewed-by, no NAK
- [Phase 4] Cover letter: companion to already-applied PHY polling patch
- [Phase 4] stable@ search: no hits
- [Phase 5] Callers: mt753x_table ID_MT7531/MT7988/EN7581;
  bus->read/write in mt7530_setup_mdio
- [Phase 6] `git describe HEAD` / Makefile: 6.12.111 pending-6.12; six
  unchecked PHY_IAC writes remain
- [Phase 6] Current lines match the patch context (including
  regmap_read_poll_timeout)
- [Phase 7] MAINTAINERS: Daniel Golle is MediaTek switch co-maintainer
- [Phase 8] Failure: stale PHY data / false write success, not oops
- UNVERIFIED: b4 dig of this exact mainline SHA (commit not in
  checkout); lore.kernel.org 403

**YES**

 drivers/net/dsa/mt7530.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index bd0a37ead0dec..24c7cb225da1a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -557,7 +557,9 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -568,7 +570,9 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_READ | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad);
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -602,7 +606,9 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_ADDR | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | regnum;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -613,7 +619,9 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 
 	reg = MT7531_MDIO_CL45_WRITE | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_DEV_ADDR(devad) | data;
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -646,7 +654,9 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 	val = MT7531_MDIO_CL22_READ | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_REG_ADDR(regnum);
 
-	mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, val | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, val,
 				       !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -681,7 +691,9 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 	reg = MT7531_MDIO_CL22_WRITE | MT7531_MDIO_PHY_ADDR(port) |
 	      MT7531_MDIO_REG_ADDR(regnum) | data;
 
-	mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	ret = mt7530_mii_write(priv, MT7531_PHY_IAC, reg | MT7531_PHY_ACS_ST);
+	if (ret < 0)
+		goto out;
 
 	ret = regmap_read_poll_timeout(priv->regmap, MT7531_PHY_IAC, reg,
 				       !(reg & MT7531_PHY_ACS_ST), 20, 100000);
-- 
2.53.0

