Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D244457FEC8;
	Mon, 19 Oct 2026 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418321; cv=none; b=Pi8ds7ddbNoWXqzZqdFBf6eyqMFsABdhikD8MK49bI8f1PkCDneP1sZAe/C/nZt0g8HPUWNPTUCaA6NkP692axXUdaj/GQNLQ3WL/ZZ41QPO4lA4XpgaQjuiAr3iPqQR6yeppUsTRpzCayGWLxrQ6cACv1cX1Eae/KPPOIIVPoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418321; c=relaxed/simple;
	bh=CgGtJq0aTEtEMqZrs33JafunuSD6J9ZY0c1lfNQdfis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8L9aWzm4epRFqx5Q7lZcp3i7gwU2jlKETcW9LvsWsvTHW1Xn9rnwyW6c0mZ4WhUKvoJYFV6EY8pqxEgQk/lKso/ePntBUEX2qJxa7CLyEyx1BkhN2x37pJHPfdbUn1YqbMlSoU2T4NSgEwLQRZvyRZrqhQJdWAVYRKoUsOS5Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+HEl9MD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+HEl9MD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4541F000CB;
	Mon, 19 Oct 2026 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418316;
	bh=ODWujkqTHL7NVTZ1jLG8dOyW8QG5FiXF7neQAMrOoSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+HEl9MDA77Qhy7tOAEym86Ys4lOXLcqGO00tdiX7lAMqDcLY56qRLwu3gTNalscd
	 mjAgjkTTTwABL3xgHBvCnO1fXNk/uV7cCVOcbLVnmJTp55Z27rQi+owoLNx3hrJ97g
	 hJk346VMsAYpj1TbjOrH3q1M9yFkF8SWOeeqiYZVbP1kDhN868mO7bMKwbHq11JvhB
	 7sTsHR64mcltHO7bPD/VB92xDKTuT74WwOGymaL3+JprmxrtgwcTIa0T/k3dU4mgx8
	 z0XAqqt3MzM4y0/lGWhL23gKTI/yglKKsYlWLS7SHt536y09Ylml9G0GSiQ71EoMZ3
	 o8J2blfjOY+Fw==
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
Subject: [PATCH AUTOSEL 6.18-6.12] net: dsa: mt7530: check bus->read() error in core_rmw()
Date: Mon, 19 Oct 2026 09:47:32 -0400
Message-ID: <20261019135441.1420968-161-sashal@kernel.org>
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

[ Upstream commit 573d6e3afe3d01e34dc82c77bf22ca96a74d805e ]

core_rmw() accesses the MMD core registers directly rather than
through the regmap and has the same unchecked bus->read() as the
one just fixed in the MDIO regmap backend: a negative errno is
consumed as register data, modified and written back to the switch.
Check the read and bail out like the surrounding bus accesses do.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/48bb9f0b311a9efeda2a6b24a7e05d4792393a3b.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[net: dsa: mt7530]` [`check`] [detect `bus->read()` failure in
`core_rmw()` instead of treating errno as register data]

**Step 1.2: Tags**
Record:
- `Signed-off-by: Daniel Golle <daniel@makrotopia.org>` (author)
- `Reviewed-by: Andrew Lunn <andrew@lunn.ch>` (DSA co-maintainer)
- `Link: https://patch.msgid.link/48bb9f0b311a9efeda2a6b24a7e05d4792393a
  3b.1785811140.git.daniel@makrotopia.org`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer)
- No `Fixes:` in the committed message
- Mailing-list submission **did** include `Fixes: b8f126a8d543 ("net-
  next: dsa: add dsa support for Mediatek MT7530 switch")` (verified in
  the saved mbox); it was dropped before mainline
- No `Reported-by:`, `Tested-by:`, `Cc: stable` in the committed message
  (absence is expected)

**Step 1.3: Body**
Record:
- **Bug:** `core_rmw()` talks to MMD core registers via raw
  `bus->read()`/`bus->write()`, not regmap. A failed `bus->read()`
  returns a negative errno, which is used as the current register value,
  masked/ORed, and written back.
- **Symptom:** garbage RMW into switch MMD registers (clock-gate bits on
  this path).
- **Root cause:** same unchecked-read pattern as the MDIO regmap
  backend, which this tree already has as `93d46870c5440`.
- **Version info:** none in the body. The inlined form is from
  `7c5e37d7ee78d` (v6.11 era, present here). The mailing-list `Fixes:`
  points at the 2017 driver introduction; the old
  `core_read_mmd_indirect()` had the same unchecked read.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. Explicit error-path correctness fix: missing check →
errno treated as data → written to hardware.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/net/dsa/mt7530.c`
- Scope: ~5 insertions / 1 deletion in one function
- Function: `core_rmw()`
- Classification: single-file surgical fix

**Step 2.2: Code flow**
Record:
- **Before:** after three checked MMD address writes, `val =
  bus->read(...)`. No check. `val &= ~mask; val |= set;` then
  `bus->write(...)`.
- **After:** `ret = bus->read(...)`; if `ret < 0` goto the existing
  `err` path (log + unlock); else `val = ret` and continue the RMW.
- Path: error path of an MDIO read during RMW. Normal success path
  unchanged.

**Step 2.3: Bug mechanism**
Record:
- Category: logic / correctness on an error path (errno consumed as
  register data, then written back). Same class as the already-present
  MDIO regmap fix.
- `mii_bus->read` returns a 16-bit value or a negative errno
  (`include/linux/mdio.h`: “returns value or negative error code”).
  `val` is `u32`, so `-ETIMEDOUT` (-110) becomes `0xffffff92`.
  `bus->write()` takes `u16`, so the switch sees `0xff92` with the
  intended bit tweaks, not the real register contents.
- Mechanism: check `ret < 0` and skip the write, matching the
  surrounding writes.

**Step 2.4: Fix quality**
Record:
- Obviously correct; copies the existing write-error pattern in the same
  function.
- Minimal; no unrelated edits, no API change.
- Regression risk: very low. On read failure it no longer writes.
  `core_rmw()` is still `void` and still only logs (pre-existing); this
  patch does not invent a new return convention.
- `val = ret` after the check is safe: success values are 0..0xffff.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- Unchecked read at lines 155–156: `7c5e37d7ee78d` (“simplify core
  operations”, Arınç ÜNAL, 2024-04-18).
- That commit inlined `core_read_mmd_indirect()`, which already returned
  `bus->read()` without checking. The defect dates to `b8f126a8d543`
  (2017), driver introduction.
- Inlined form is in this tree (`git merge-base --is-ancestor
  7c5e37d7ee78d HEAD` succeeded). `git describe --contains` places it
  around v6.11-rc1, so it is in 6.12.

**Step 3.2: Fixes: tag**
Record: No `Fixes:` on the committed patch. Submission tagged
`b8f126a8d543`, which **is** an ancestor of this tree. Intermediate:
`7c5e37d7ee78d` inlined the helper and kept the bug.

**Step 3.3: File history**
Record:
- This tree already has the sibling: `93d46870c5440` “check bus->read()
  errors in the MDIO regmap backend”.
- Also: `96e0f5184af69` “error out on failed reads in MT7531 PHY
  polling”.
- Candidate `573d6e3afe3d0` is **not** an ancestor of HEAD.
- Standalone vs series: mailing-list subject is `[PATCH net v2 2/6]`.
  Diff does not depend on 1/6 or 3–6/6.

**Step 3.4: Author**
Record: Daniel Golle is a regular MT7530 contributor (OpenWrt/MediaTek).
Nearby commits by him in this tree are the other MDIO-error fixes.
Reviewed by Andrew Lunn.

**Step 3.5: Dependencies**
Record: None for this hunk. It uses existing `ret`, `goto err`, and
`bus->read`/`bus->write`. `git apply --check` succeeded (hunk offset 28
lines only).

---

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
Record:
- `b4 dig -c 573d6e3afe3d0` → https://patch.msgid.link/48bb9f0b311a9efed
  a2a6b24a7e05d4792393a3b.1785811140.git.daniel@makrotopia.org
- Series: `[PATCH net v2 0/6] net: dsa: mt7530: fix remaining swallowed
  MDIO access errors`
- v2: “no changes” for this patch; Andrew’s `Reviewed-by` kept.
- Cover letter: leftover companion of the first “swallowed MDIO read
  errors” series (already on `net`); this is the unchecked `bus->read()`
  in `core_rmw()`.
- Sent to `net` (fixes), not `net-next`.
- No NAK in the saved mbox. Applied by Jakub Kicinski (`0200d48477602`
  merge).

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Andrew Lunn, Vladimir Oltean, netdev maintainers, MediaTek,
`netdev@`, `linux-mediatek@`. Right audience. Lunn reviewed.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Found by review of the same MDIO-error class
(cover letter cites Sashiko AI review of the parent series).

**Step 4.4: Series**
Record: 6 patches. This is 2/6 and is self-contained. 3–5/6 are other
swallowed-error sites; 1/6 is `pcs-mtk-lynxi`; 6/6 is IRQ-chip
serialization. Not required for this hunk.

**Step 4.5: Stable list**
Record: **UNVERIFIED** — lore.kernel.org returned 403/503 to
WebFetch/curl. No local evidence this was rejected for stable.

---

## Phase 5: Code semantics

**Step 5.1: Functions**
Record: `core_rmw()` only.

**Step 5.2: Callers**
Record:
- `core_set()` / `core_clear()` → `core_rmw()`
- `mt7530_pll_setup()`: clear/set `REG_GSWCK_EN` on
  `CORE_TRGMII_GSW_CLK_CG` (switch setup, 40 MHz XTAL)
- `mt7530_setup_port6()`: clear/set `REG_TRGMIICK_EN` (port 6 TRGMII
  clock)
- `mt7530_pll_setup()` from `mt7530_setup()` (~line 2422)
- `mt7530_setup_port6()` from `mt7530_mac_config()` when `port == 6`

**Step 5.3: Callees**
Record: `mt7530_mutex_lock/unlock`, `bus->write`, `bus->read`,
`dev_err`.

**Step 5.4: Reachability**
Record: Yes, from DSA probe/setup and phylink MAC config on MT7530
(common in MediaTek routers). Not a syscall hot path; hit on bring-up
and port-6 mode changes. Userspace/netlink can trigger `mac_config`.

**Step 5.5: Similar patterns**
Record: Same bug already fixed in `mt7530_regmap_read()` in this tree.
`core_write()` only writes (no analogous read). Remaining siblings
(PHY_IAC writes, CORE_PLL_GROUP4, FDB/VLAN cmd) are other series
patches, not prerequisites.

---

## Phase 6: This tree (6.12.y)

**Step 6.1: Buggy code present?**
Record: Yes. Tree is `pending-6.12` / `6.12.111`
(`p-6.12-4-gbf6fcdf761abd`). Current `core_rmw()` still does `val =
bus->read(...)` with no check (`drivers/net/dsa/mt7530.c:155-156`).
`573d6e3afe3d0` is not an ancestor of HEAD.

**Step 6.2: Backport difficulty**
Record: Clean apply (`git apply --check`: hunk succeeded at offset 28).
Surrounding `core_rmw()` matches the pre-image.

**Step 6.3: Related fixes already here?**
Record: Regmap-backend check is here; PHY polling check is here. This
leftover `core_rmw()` instance is not. No alternate fix of this
function.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: `drivers/net/dsa/mt7530.c` — MediaTek MT7530 DSA. **IMPORTANT**
(common embedded/router switch), not core mm/VFS, not staging.

**Step 7.2**
Record: Actively maintained; recent 6.12 backports already include other
MT7530 MDIO-error and hardware fixes.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Driver-specific: `CONFIG_NET_DSA_MT7530` (MDIO-attached
MT7530/MT7531, common on MT7621/MT798x-class boards).

**Step 8.2: Trigger**
Record: `bus->read()` failure during PLL/clock RMW (timeout, NACK, flaky
MDIO). Not every boot if the bus is healthy. Unprivileged users do not
trigger MDIO failure directly; they can hit the RMW via interface/port
config. Timing/hardware dependent.

**Step 8.3: Failure mode**
Record: On MDIO read failure, a truncated errno (e.g. `0xff92`) is
written to `CORE_TRGMII_GSW_CLK_CG` (core / TRGMII clock gates) instead
of toggling bit 0 or 1. That can leave clocks misconfigured (no link /
switch not forwarding) rather than failing closed. Severity: **HIGH** on
that error path (hardware misconfiguration), not a panic/UAF.

**Step 8.4: Risk-benefit**
Record:
- Benefit: stops garbage writes to switch clock-gate MMDs; completes the
  same class already backported via the regmap patch.
- Risk: very low (4–5 lines, existing `err` path, no locking/API
  change).
- Ratio: favorable.

---

## Phase 9: Synthesis

**For backporting**
- Real bug: negative MDIO errno used as register data and written back.
- Consequence: corrupt RMW of switch clock-gate registers.
- Small, obviously correct, reviewed by Andrew Lunn, taken into `net` as
  a fix.
- Buggy code is in this 6.12 tree; patch applies cleanly.
- Same class as `93d46870c5440`, already in this tree; this is the
  leftover `core_rmw()` site.

**Against**
- Error path only (MDIO must already be failing).
- Still `void`; errors are only logged (pre-existing).
- No syzbot/user crash report.
- Labelled 2/6, but this hunk does not need the rest.

**Unresolved**
- Stable-list discussion (lore 403/503). Does not change the technical
  case.

**Stable rules**
1. Obviously correct and tested? **PASS** — matches surrounding checks;
   Lunn `Reviewed-by`; in mainline `net`.
2. Real user-affecting bug? **PASS** — garbage written to MT7530 clock-
   gate MMDs on read failure.
3. Important (crash/security/corruption/deadlock)? **PASS** — hardware
   misconfiguration of switch clocks; same class already accepted in
   this tree.
4. Small and contained? **PASS** — ~5 lines, one function.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — `git apply --check` clean.

**Exception category:** none (not an ID/quirk/DT/build/doc exception).
Qualifies as a normal small driver bugfix.

---

### What the commit solves for this tree

In 6.12, `core_rmw()` still assigns `bus->read()` to `u32 val` without
checking. On timeout/NACK that errno is masked, OR’d, and written to
`CORE_TRGMII_GSW_CLK_CG` during PLL setup and port-6 TRGMII clock
enable. The fix bails out like the three preceding writes. It is the
companion to the regmap-backend check already present here.

Risk is negligible; benefit is avoiding a bad clock-gate RMW when MDIO
fails on a widely used MediaTek DSA switch.

Verification:
- [Phase 1] Parsed tags: Lunn `Reviewed-by`, msgid link; no committed
  `Fixes:`; mbox had `Fixes: b8f126a8d543`
- [Phase 2] Diff: 5 insertions in `core_rmw()`; check `ret < 0` before
  RMW write
- [Phase 3] Blame: inlined by `7c5e37d7ee78d` (v6.11, in this tree);
  original unchecked read in `b8f126a8d543` (2017)
- [Phase 3] `git merge-base --is-ancestor 573d6e3afe3d0 HEAD` → not in
  tree; `7c5e37d7ee78d` is in tree
- [Phase 3] Sibling `93d46870c5440` is in this tree
- [Phase 4] `b4 dig -c 573d6e3afe3d0`: v2 2/6 of “fix remaining
  swallowed MDIO access errors”; v2 no changes; Lunn review on 1–3 and 6
- [Phase 4] Cover letter: leftover `core_rmw()` companion of the first
  MDIO-error series
- [Phase 4] `b4 dig -w`: netdev + DSA + MediaTek CCs
- [Phase 4] lore WebFetch/curl 403/503; thread recovered via `b4 dig -m`
- [Phase 5] Callers: `mt7530_pll_setup`, `mt7530_setup_port6` → DSA
  setup / `mac_config`
- [Phase 5] `bus->read` contract: value or negative errno
  (`include/linux/mdio.h`)
- [Phase 6] `git describe HEAD`: `p-6.12-4-gbf6fcdf761abd`; `make
  kernelversion`: 6.12.111; buggy `val = bus->read` still at
  mt7530.c:155
- [Phase 6] `git apply --check` of `573d6e3afe3d0`: succeeded (offset
  28)
- [Phase 8] Failure mode: truncated errno written to
  `CORE_TRGMII_GSW_CLK_CG`; severity HIGH on that error path
- UNVERIFIED: whether stable@ discussed this commit (lore unreachable)

**YES**

 drivers/net/dsa/mt7530.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 24c7cb225da1a..d2dcc2f1522f4 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -124,8 +124,12 @@ core_rmw(struct mt7530_priv *priv, u32 reg, u32 mask, u32 set)
 		goto err;
 
 	/* Read the content of the MMD's selected register */
-	val = bus->read(bus, MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
+	ret = bus->read(bus, MT753X_CTRL_PHY_ADDR(priv->mdiodev->addr),
 			MII_MMD_DATA);
+	if (ret < 0)
+		goto err;
+	val = ret;
+
 	val &= ~mask;
 	val |= set;
 	/* Write the data into MMD's selected register */
-- 
2.53.0

