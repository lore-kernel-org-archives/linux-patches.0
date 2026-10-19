Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABFC62260E;
	Mon, 19 Oct 2026 14:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418691; cv=none; b=EWvug+JBYMMa56tylME7xY0lP79nYZqKhzzJf0DIlVd7touIUwy/gktEITe3xrl44ihr1FM4lNIaAsS8qRdbpvDnsXgUuM4xzj6Su9N881B0ObwSGeEn9uqKs7Dj/JM09eJuFkpu1NtiopH6iy//DLu5YiJjh+rxUuQtgmE5SGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418691; c=relaxed/simple;
	bh=A0/kukf2XXYs09IUeFpJ7xRBOpHdude9n9tvdxr6DlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnNNO322bnRy1Ax4kQDhV5j0pDycv01BjMb9gnYiSXQCDBpQYVcF00VJPDenh/6z9ZIIPYIGLzyFCQ7m2y8osRvRT6/TPiDy9O0SiY/oYoCoF2SlAT1TbRKevb3B5HUcjsdQTeWCZtFtocsTxgyRNGLR9VrsAwv1peLFvKJ43hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lpQOtIuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpQOtIuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF2A1F000C5;
	Mon, 19 Oct 2026 14:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418686;
	bh=37GP2gLah2l9LWaV6Z4HyU7YDGSYfHzI1n89yuM5wqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpQOtIuE6kLyWsW+yZy6ecufrml/MWrDOH6SDBmvskDMt9oetftV1XOEyFFL/Ix9r
	 5kwl1tWimpZJlBJWK7lP3bvT7VyNSTxMRWvbiehErk4U2BQVxljzW3wHqhMblLll9y
	 b84jN9mRfb3MmNHwGc5bV5Gy2ivcH39k8OtlR0AJHHQZs3gHQumaqvWdpJrKEMxYBe
	 Nn0vpN9Xd0ukzZVbNSvi/guiW3JwlLWFgvn3qtuAgVlHEDJ4Yf9Q0ejz5kZk1ajsYF
	 6Wx1EbGJr2Y5XBVGTva6uvOmkJqt5ghaB9B+CujapN/TWMUTPJPIrED2J9RnOZVJkS
	 kREW+ydX9q7hw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lynxis@fe80.eu,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.6] net: pcs: mtk-lynxi: check regmap reads in mtk_pcs_lynxi_get_state()
Date: Mon, 19 Oct 2026 09:51:55 -0400
Message-ID: <20261019135441.1420968-424-sashal@kernel.org>
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

[ Upstream commit 5cc65c01cdc577621d1320f4aa03a1382c5a4a45 ]

mtk_pcs_lynxi_get_state() ignores regmap_read()'s return value; a
failed read leaves bm and adv holding uninitialized stack values
which are then decoded into the reported link state. The regmaps
backing the MT7531 SGMII PCS instances sit on an MDIO bus where
reads can fail. Check both reads and report the link as down on
error; phylink presets state->link before the callback, so a bare
return would leave a failed read reported as link-up.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/fce70657fc03bbaf60a04c0fbf2f418531135c4f.1785811140.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real uninitialized-data bug in MediaTek LynxI PCS link
polling, and the buggy path exists in this 6.12 tree. It should be
backported.

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[net: pcs: mtk-lynxi:]` `[check]` `[validate
regmap_read() in mtk_pcs_lynxi_get_state() so failed MDIO reads are not
decoded as link state]`

**Step 1.2:** Record: tags in the candidate message:
- `Signed-off-by: Daniel Golle <daniel@makrotopia.org>` (author; driver
  co-maintainer)
- `Reviewed-by: Andrew Lunn <andrew@lunn.ch>` (netdev/DSA reviewer)
- `Link: https://patch.msgid.link/fce70657fc03bbaf60a04c0fbf2f418531135c
  4f.1785811140.git.daniel@makrotopia.org`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (netdev maintainer)
- No `Reported-by`, `Tested-by`, `Cc: stable` in the candidate text
  (absence is expected)
- Original mailing-list submission **did** include `Fixes: 4765a9722e09
  ("net: pcs: add driver for MediaTek SGMII PCS")`; that tag is not in
  the candidate body

**Step 1.3:** Record: `[Bug: ignored regmap_read() errors leave
`bm`/`adv` uninitialized and phylink decodes them as BMSR/LPA]`
`[Symptom: false or garbage link/speed/duplex; failed read can be
reported as link-up because phylink presets `state->link`]` `[Version:
bug dates to driver introduction]` `[Root cause: MDIO-backed MT7531
SGMII PCS regmaps can fail; output is not written on error]`

**Step 1.4:** Record: `[Not a disguised cleanup. This is an explicit
missing-check / uninitialized-use fix. v2 of the patch added
`state->link = false` after review, because a bare return left phylink's
preset link-up.]`

## Phase 2: Diff analysis

**Step 2.1:** Record: `[drivers/net/pcs/pcs-mtk-lynxi.c: +5 / -2 in
`mtk_pcs_lynxi_get_state()`]` `[single-file surgical fix]`

**Step 2.2:** Record: `[Before: two unchecked `regmap_read()`s, then
`phylink_mii_c22_pcs_decode_state()` on `bm`/`adv`. After: if either
read fails, set `state->link = false` and return; otherwise decode as
before. Error path only.]`

**Step 2.3:** Record: `[Category: initialization / missing return-value
check]` `[Mechanism: failed `regmap_read()` does not write `*val`;
`unsigned int bm, adv` stay uninitialized;
`phylink_mii_c22_pcs_decode_state()` does `state->link = !!(bmsr &
BMSR_LSTATUS)` on that garbage. Fix matches
`phylink_mii_c22_pcs_get_state()`, which already treats read errors as
link-down.]`

**Step 2.4:** Record: `[Obviously correct, 5-line change, no
API/locking/refcount changes.]` `[Regression risk: very low. Worst case
is reporting link-down on a failed register read, which is the intended
fail-safe.]`

## Phase 3: Git history

**Step 3.1:** Record: `[Buggy reads introduced in 4765a9722e0976 ("net:
pcs: add driver for MediaTek SGMII PCS", Daniel Golle, 2023-03-19)]`
`[First appeared in v6.4-rc1; present for the life of this driver]`

**Step 3.2:** Record: `[Fixes target 4765a9722e0976 is an ancestor of
HEAD. No later lynxi get_state error-handling in this tree.]`

**Step 3.3:** Record: `[File history on this tree: 4765a9722e097 (add
driver), 3b2de56a146f3 (neg_mode), 90308679c297f (pcs_disable),
be884c15de370 (MODULE_DESCRIPTION).]` `[Standalone functionally; series
patch 1/6, other patches touch `mt7530.c` only.]` `[Prerequisite already
here: 93d46870c5440 ("net: dsa: mt7530: check bus->read() errors in the
MDIO regmap backend") — after that, a failed MDIO read returns an error
and leaves the output unwritten instead of truncated garbage.]`

**Step 3.4:** Record: `[Daniel Golle is listed as maintainer of MEDIATEK
ETHERNET PCS DRIVER. Related MDIO error-propagation work on mt7530 is by
the same author.]`

**Step 3.5:** Record: `[No missing functions. This tree's
`mtk_pcs_lynxi_get_state()` still has the 6.12 signature (no
`neg_mode`); the check itself is independent. Can apply standalone with
a small context adaptation.]`

## Phase 4: Mailing list

**Step 4.1:** Record: `[Lore thread retrieved via b4 mbox: msgid fce7065
7fc03bbaf60a04c0fbf2f418531135c4f.1785811140.git.daniel@makrotopia.org]`
`[v1 of this remaining-errors series was `[PATCH net 1/4]`; v2 is
`[PATCH net v2 1/6]`. Applied version is v2.]` `[v2 change: set
`state->link = false` because phylink presets link-up (Sashiko
review).]` `[Andrew Lunn Reviewed-by on v1; author kept it on v2 for the
small in-spirit change. No NAKs.]` `[Patchwork bot: applied by Jakub
Kicinski as netdev commit 5cc65c01cdc5.]`

**Step 4.2:** Record: `[To/Cc included Andrew Lunn, Vladimir Oltean,
Russell King, netdev, linux-mediatek, DSA and MediaTek maintainers.
Right audience.]`

**Step 4.3:** Record: `[No syzbot/bugzilla user report. Found during
mt7530 MDIO error-handling review. Still a concrete, reachable bug:
`pcs.poll = true` so this runs from phylink's 1 Hz poll.]`

**Step 4.4:** Record: `[Series: "fix remaining swallowed MDIO access
errors". Patch 1 is the only pcs-mtk-lynxi change and does not depend on
patches 2–6.]` `[Earlier companion 93d46870c5440 / 96e0f5184af69 are
already in this tree.]`

**Step 4.5:** Record: `[UNVERIFIED: lore.kernel.org/stable search
blocked by Anubis. No stable-list discussion found via b4.]`

## Phase 5: Semantic analysis

**Step 5.1:** Record: `[Modified: `mtk_pcs_lynxi_get_state`. Wired as
`.pcs_get_state`.]`

**Step 5.2:** Record: `[Callers: `phylink_mac_pcs_get_state()` → in-band
resolve (`MLO_AN_INBAND`), ethtool `phylink_ethtool_ksettings_get()`,
and MII emulation. `mpcs->pcs.poll = true` so `phylink_fixed_poll` runs
`phylink_run_resolve()` every HZ.]`

**Step 5.3:** Record: `[Callees: `regmap_read`,
`phylink_mii_c22_pcs_decode_state`.]`

**Step 5.4:** Record: `[Reachable from userspace: ethtool link settings,
and continuously while the netdev is up in in-band
SGMII/1000Base-X/2500Base-X.]` `[Hardware: MT7531 DSA ports 5/6
(`mt7531_create_sgmii()` uses an MDIO-backed regmap) and MediaTek SoC
SGMII (`mtk_eth_soc` syscon/MMIO, rarely fails). The MDIO path is the
one that matters.]`

**Step 5.5:** Record: `[Same pattern already handled in
`phylink_mii_c22_pcs_get_state()` and `phylink_mii_c45_pcs_get_state()`
in this tree. Lynx PCS uses those helpers; lynxi did not.]`

## Phase 6: Local tree (6.12.111, `pending-6.12`)

**Step 6.1:** Record: `[Yes. `drivers/net/pcs/pcs-mtk-lynxi.c:98-99`
still has unchecked `regmap_read()` into uninitialized `bm`/`adv`.
Introduced v6.4, present here.]` `[Verified: `git describe HEAD` →
p-6.12-4-gbf6fcdf761abd; `make kernelversion` → 6.12.111.]`

**Step 6.2:** Record: `[Minor context rework, not a semantic fork. This
tree has no `mtk_pcs_lynxi_inband_caps`, no `neg_mode` argument, and
`phylink_mii_c22_pcs_decode_state(state, bmsr, lpa)` not the later 4-arg
form. The 5-line check ports 1:1 into the existing function body.]`

**Step 6.3:** Record: `[No lynxi get_state error-check already present.
Prerequisite MDIO backend error propagation is already here, which is
why this follow-up is needed: failed reads no longer write `*val`.]`

## Phase 7: Subsystem context

**Step 7.1:** Record: `[drivers/net/pcs + consumers in net/dsa/mt7530
and net/ethernet/mediatek]` `[IMPORTANT: common OpenWrt/router SGMII CPU
ports, not core mm/VFS, but production networking]`

**Step 7.2:** Record: `[Driver is mature since v6.4; this file has only
a handful of commits on this tree. Bug is long-standing, newly exposed
as true uninitialized use after the MDIO backend fix.]`

## Phase 8: Impact and risk

**Step 8.1:** Record: `[Driver-specific: MT7531 SGMII (MDIO) and
MediaTek SoC SGMII (MMIO).]`

**Step 8.2:** Record: `[Trigger: failed `regmap_read` on the PCS map.
Common on flaky/timeout MDIO; not every boot. Unprivileged userspace can
observe the result via ethtool/carrier; the poll path runs while the
interface is up.]`

**Step 8.3:** Record: `[Failure mode: uninitialized stack decoded as
link/speed/duplex; false carrier possible because phylink presets
`state->link = 1`.]` `[Severity: HIGH for wrong datapath/carrier on MDIO
error; not a panic. Uninitialized use is the same class as KMSAN-class
bugs.]`

**Step 8.4:** Record: `[Benefit: high for MT7531 in-band SGMII — stops
garbage link state after a bus error, especially now that the backend
returns real errors.]` `[Risk: very low — 5 lines, fail-closed to link-
down.]` `[Ratio: strongly favors backport.]`

## Phase 9: Synthesis

**For backporting:**
- Real bug: uninitialized `bm`/`adv` decoded into phylink link state
- User-visible: false/garbage carrier, speed, duplex; ethtool reports it
- Tiny, obviously correct, matches phylink's own C22 helper
- Reviewed by Andrew Lunn, applied by Jakub Kicinski, written by the PCS
  maintainer
- Buggy code has been in this driver since v6.4 and is in 6.12.111
- Companion to MDIO error-propagation already in this tree
  (93d46870c5440); without this, a failed MT7531 PCS read now leaves
  stack garbage instead of even truncated-but-defined data
- No new API/feature

**Against:**
- Not a crash/UAF/deadlock
- Raw upstream hunk will not apply cleanly (later `neg_mode` /
  `inband_caps` context)
- No external user/syzbot report
- Series 1/6, but this patch does not need 2–6

**Unresolved:** stable-list discussion (lore/stable fetch blocked)

**Stable rules:**
1. Obviously correct and tested? **PASS** — same pattern as
   `phylink_mii_c22_pcs_get_state()`; Reviewed-by Andrew Lunn; merged
2. Fixes a real bug that affects users? **PASS** — wrong link state /
   uninitialized data on MDIO failure for MT7531 SGMII
3. Important issue? **PASS** — uninitialized memory used as live link
   state on a 1 Hz poll; can keep carrier up after a failed read
4. Small and contained? **PASS** — 5 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to this tree? **PASS** — needs a trivial context backport,
   not missing code

**Exception category:** none (normal small correctness fix)

The problem for 6.12 users is that `mtk_pcs_lynxi_get_state()` still
consumes uninitialized stack as BMSR/LPA. Phylink presets `state->link =
1` (`phylink.c:1328`) and this PCS polls every second. After the
already-landed MT7530 MDIO backend fix, a failed read returns an error
and does not fill `*val`, so this is the necessary follow-up. Benefit is
preventing false/garbage link state; risk is a fail-closed link-down on
I/O error.

Verification:
- [Phase 1] Parsed candidate tags; original lore patch had `Fixes:
  4765a9722e09`
- [Phase 2] Diff is 5 lines in `mtk_pcs_lynxi_get_state()` wrapping two
  `regmap_read()`s
- [Phase 2] Confirmed `phylink_mac_pcs_get_state()` sets `state->link =
  1` before the callback
- [Phase 2] Confirmed `phylink_mii_c22_pcs_decode_state()` uses `bmsr`
  for `state->link` and that `phylink_mii_c22_pcs_get_state()` already
  sets `state->link = false` on read failure
- [Phase 3] `git blame` on lines 98–99: 4765a9722e0976; `git describe
  --contains` → v6.4-rc1
- [Phase 3] `git merge-base --is-ancestor 4765a9722e0976 HEAD` succeeded
- [Phase 3] `git merge-base --is-ancestor 93d46870c5440 HEAD` succeeded
  (MDIO backend now returns errors without writing `*val`)
- [Phase 4] `b4 mbox` on the msgid: 8-message thread; series v2 1/6;
  Andrew Lunn Reviewed-by; no NAK
- [Phase 4] Cover letter: this check was added because a failed read can
  now leave output unwritten
- [Phase 4] UNVERIFIED: lore.kernel.org/stable search (Anubis 403)
- [Phase 5] Callers: phylink in-band resolve, ethtool get, 1 Hz
  `link_poll`; consumers `mt7530-mdio.c` and `mtk_eth_soc.c`
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.12.111 on
  `pending-6.12`; unchecked reads still at `pcs-mtk-lynxi.c:98-99`
- [Phase 6] Function signature here lacks `neg_mode`; backport is a
  local 5-line edit
- [Phase 8] Failure mode: uninitialized link state / possible false
  carrier, severity HIGH, not a panic
- UNVERIFIED: whether this SHA is already in some other stable series
  (decision is for this tree only)

**YES**

 drivers/net/pcs/pcs-mtk-lynxi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-mtk-lynxi.c b/drivers/net/pcs/pcs-mtk-lynxi.c
index 87df3a9dfc9bc..64fb17c189afc 100644
--- a/drivers/net/pcs/pcs-mtk-lynxi.c
+++ b/drivers/net/pcs/pcs-mtk-lynxi.c
@@ -110,8 +110,11 @@ static void mtk_pcs_lynxi_get_state(struct phylink_pcs *pcs,
 	unsigned int bm, adv;
 
 	/* Read the BMSR and LPA */
-	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
-	regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv);
+	if (regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm) ||
+	    regmap_read(mpcs->regmap, SGMSYS_PCS_ADVERTISE, &adv)) {
+		state->link = false;
+		return;
+	}
 
 	phylink_mii_c22_pcs_decode_state(state, neg_mode,
 					 FIELD_GET(SGMII_BMSR, bm),
-- 
2.53.0

