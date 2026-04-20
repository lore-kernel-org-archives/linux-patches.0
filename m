Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82C746AF2D;
	Mon, 20 Apr 2026 13:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691836; cv=none; b=bUSAc4blQw0dDIknNw1yR1jwiKpqWBognzQYyY3emADsVYbRBifN2O7JVhlYi1Vrzt6IcNn80L2Hscmc7D72kcz1qpMPzY3QxgorJDk/3EmrZK67Tyw/hUHeEIeh4Evdw41D0DMRs4yNW8R0d9T1cYWUoaKo/EP0h69JKaGINf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691836; c=relaxed/simple;
	bh=v1cKWJCVFx6J4ytowCiHzotwuUAHOGUrFYtxlnIIG+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPZM9p7NeqJmftoiz0HM8RNa8rA1VGBdIxW97MZQjIOSINQ2y73yR1RWnKyOvBrAmL/pkJA/wjSubdt8x/dvK/akLO7pJmsp9Oe7pIa5oWqHj4+QdFw02jMh7N3yqAmO9JqmLQ3wFW+OLUVVQ+KYjB2ANYpgSpNWz3gd5+vG9J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV74Bdvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV74Bdvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4481AC19425;
	Mon, 20 Apr 2026 13:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691836;
	bh=v1cKWJCVFx6J4ytowCiHzotwuUAHOGUrFYtxlnIIG+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV74BdvwAKbetkVNzbopIPzqv1772i2yK+VeDuJMLDx6q9hkxkMoeCY/9PteF6cE4
	 qeJHXWzLEh6opsmisnnmY4qeVemtVnzwVKmb+IXQ9FyNOuVmhkrDKSKSl7Xwm8EDak
	 ju2rljvz28nxxwLRNkXbpTssQbHCrZibSr+iCQ1IKPwD8xbB6ZN1D5uBd2YhtnjEF+
	 L0rw0MzZV6UCn/XPIWKaxFj8aTSeaHQG3LAPNauIG29WZRAZlRHT+Fio7DKt7XHQvm
	 CoGIAhiEKf+XgYWHYMjFBfL86tOWVBpiV0UrNxdny+fv5EEdaXG+3PPXNdvyNJVh/J
	 a/OCyPsnK+M8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joris Vaisvila <joey@tinyisr.com>,
	Daniel Golle <daniel@makrotpia.org>,
	Stefan Roese <stefan.roese@mailbox.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nbd@nbd.name,
	lorenzo@kernel.org,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 7.0-6.12] net: ethernet: mtk_eth_soc: avoid writing to ESW registers on MT7628
Date: Mon, 20 Apr 2026 09:20:17 -0400
Message-ID: <20260420132314.1023554-223-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joris Vaisvila <joey@tinyisr.com>

[ Upstream commit 9a04d3b2f0708a9e5e1f731bafb69b040bb934a0 ]

The MT7628 has a fixed-link PHY and does not expose MAC control
registers. Writes to these registers only corrupt the ESW VLAN
configuration.

This patch explicitly registers no-op phylink_mac_ops for MT7628, as
after removing the invalid register accesses, the existing
phylink_mac_ops effectively become no-ops.

This code was introduced by commit 296c9120752b
("net: ethernet: mediatek: Add MT7628/88 SoC support")

Signed-off-by: Joris Vaisvila <joey@tinyisr.com>
Reviewed-by: Daniel Golle <daniel@makrotpia.org>
Reviewed-by: Stefan Roese <stefan.roese@mailbox.org>
Link: https://patch.msgid.link/20260226154547.68553-1-joey@tinyisr.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `net: ethernet: mtk_eth_soc`
- Action verb: "avoid" — strongly implies a bug fix (preventing harmful
  behavior)
- Summary: Avoid writing to ESW (Embedded Switch) registers on MT7628 to
  prevent corruption

**Step 1.2: Tags**
- No `Fixes:` tag, but commit body references `296c9120752b` ("net:
  ethernet: mediatek: Add MT7628/88 SoC support") from August 2019 as
  the introducing commit
- `Signed-off-by: Joris Vaisvila <joey@tinyisr.com>` — author
- `Reviewed-by: Daniel Golle <daniel@makrotpia.org>` — MediaTek ethernet
  maintainer/expert
- `Reviewed-by: Stefan Roese <stefan.roese@mailbox.org>` — original
  author of the MT7628 support commit
- `Link:` to patch.msgid.link (standard netdev submission)
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` — netdev maintainer
  applied it

Record: Two reviewer tags from highly relevant people (original MT7628
author + subsystem expert). No syzbot. No explicit Cc: stable.

**Step 1.3: Commit Body**
- Bug: MT7628 has a fixed-link PHY and does not expose MAC control
  registers. Writes to `MTK_MAC_MCR(x)` (offset 0x10100) on MT7628 hit
  the ESW VLAN configuration instead of non-existent MAC control
  registers.
- Symptom: VLAN configuration corruption on MT7628
- Root cause: The phylink_mac_ops callbacks (`link_down`, `link_up`,
  `mac_finish`) write to `MTK_MAC_MCR` registers without checking for
  MT7628

**Step 1.4: Hidden Bug Fix Detection**
This is clearly a data corruption fix. The word "avoid" means preventing
invalid register writes that corrupt VLAN config.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/net/ethernet/mediatek/mtk_eth_soc.c`
- Approximate: +27 lines added, -5 lines removed
- Functions modified: `mtk_mac_config` (guard removed), `mtk_add_mac`
  (ops selection added)
- Functions added: `rt5350_mac_config`, `rt5350_mac_link_down`,
  `rt5350_mac_link_up` (all no-ops), `rt5350_phylink_ops` (new ops
  struct)

**Step 2.2: Code Flow Change**
1. In `mtk_mac_config`: The `!MTK_HAS_CAPS(eth->soc->caps,
   MTK_SOC_MT7628)` guard was removed. Safe because MT7628 now uses
   entirely different (no-op) ops, so this function is never called for
   MT7628.
2. In `mtk_add_mac`: Added conditional to select `rt5350_phylink_ops`
   for MT7628 instead of `mtk_phylink_ops`.
3. New no-op functions: `rt5350_mac_config`, `rt5350_mac_link_down`,
   `rt5350_mac_link_up` — all empty.

**Step 2.3: Bug Mechanism**
Category: **Hardware workaround / data corruption fix**

The bug: On MT7628, register offset 0x10100 is part of the ESW VLAN
configuration, not a MAC control register. The existing
`mtk_mac_link_down()`, `mtk_mac_link_up()`, and `mtk_mac_finish()` all
write to `MTK_MAC_MCR(mac->id)` (= 0x10100) without MT7628 checks. Only
`mtk_mac_config()` had a guard. Every link state change event corrupts
the VLAN configuration.

**Step 2.4: Fix Quality**
- Obviously correct: The fix prevents ALL register writes by
  substituting no-op callbacks
- Minimal regression risk: Empty callbacks for a fixed-link PHY that
  never needed MAC configuration
- Self-contained in one file
- Reviewed by the original MT7628 author (Stefan Roese) and MediaTek
  network expert (Daniel Golle)

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The buggy code in `mtk_mac_link_down`/`mtk_mac_link_up` was introduced
  by `b8fc9f30821ec0` (René van Dorst, 2019-08-25) during the phylink
  conversion
- The `mtk_mac_config` guard was already in `b8fc9f30821ec0` but was
  never added to `link_down`/`link_up`/`finish`

**Step 3.2: Original commit**
- `296c9120752b` ("Add MT7628/88 SoC support") was merged in v5.3-rc6
  (August 2019)
- This commit is present in all stable trees from v5.3 onwards
  (confirmed in p-5.10, p-5.15 tags)

**Step 3.3/3.4: Author & File History**
- Joris Vaisvila is not a frequent kernel contributor (only 1-2 commits
  found)
- However, both reviewers are well-known in this subsystem
- File has 231 commits since 296c9120752b; 32 since v6.12

**Step 3.5: Dependencies**
- The patch is self-contained. The no-op ops pattern doesn't depend on
  any other patches.
- In v6.6, the `mtk_mac_finish` function also writes to `MTK_MAC_MCR`
  without MT7628 guard — same bug. The no-op ops approach fixes all
  callbacks at once.

## PHASE 4: MAILING LIST

Lore/b4 dig returned results but couldn't access full discussions due to
Anubis protection. The patch was submitted as
`20260226154547.68553-1-joey@tinyisr.com` and accepted by Jakub Kicinski
(netdev maintainer).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Impact Surface**
- `mtk_mac_link_down` is called by phylink whenever the link goes down —
  every cable disconnect, PHY negotiation change
- `mtk_mac_link_up` is called on every link up event
- `mtk_mac_finish` is called during PHY configuration
- On MT7628, these are called regularly during normal operation
- `mtk_set_mcr_max_rx` at line 3886 already has its own `MTK_SOC_MT7628`
  guard, confirming the developers know these registers don't exist on
  MT7628

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The buggy code exists in ALL stable trees from v5.3+,
including v5.15, v6.1, v6.6, and 6.12.
- In v6.6: `mtk_mac_link_down` at line 689 unconditionally writes to
  `MTK_MAC_MCR` — confirmed the same bug
- In v6.6: `mtk_mac_link_up` at line 769 also unconditionally writes to
  `MTK_MAC_MCR` — confirmed
- In v6.6: `mtk_mac_finish` at line 660 also writes to `MTK_MAC_MCR` —
  confirmed

**Step 6.2: Backport Difficulty**
For v7.0: Should apply cleanly or with minor fuzz.
For v6.6 and older: Will need rework. The `mtk_mac_link_down`/`link_up`
implementations differ significantly (v7.0 has xgmii handling added by
`51cf06ddafc91e`). However, the *concept* of the fix (separate no-op
ops) is portable.

## PHASE 7: SUBSYSTEM CONTEXT

- Subsystem: Network driver (embedded Ethernet), IMPORTANT criticality
  for MT7628 users
- MT7628/MT7688 is a widely-used MIPS SoC found in popular embedded
  platforms (Omega2, VoCore2, many OpenWrt routers)

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- All MT7628/MT7688 users (embedded routers running Linux with VLANs)

**Step 8.2: Trigger Conditions**
- Triggered on every link state change (boot, cable plug/unplug, PHY
  state change)
- Extremely common — happens during normal boot

**Step 8.3: Failure Mode**
- **ESW VLAN configuration corruption** — MEDIUM-HIGH severity
- VLAN configuration is silently corrupted, leading to incorrect network
  behavior
- Not a crash but a data corruption issue affecting network
  configuration

**Step 8.4: Risk-Benefit**
- Benefit: HIGH — prevents VLAN corruption on every MT7628 system
- Risk: LOW — the fix adds empty callback functions and selects them
  conditionally; the no-op approach is obviously correct for a fixed-
  link PHY with no MAC control registers

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
1. Fixes real data corruption (VLAN config) on real hardware
   (MT7628/MT7688)
2. Bug present since v5.3 (2019) — affects all stable trees
3. Reviewed by original MT7628 author and subsystem expert
4. Accepted by netdev maintainer (Jakub Kicinski)
5. Fix is obviously correct (no-op callbacks for hardware without MAC
   registers)
6. Single file change, well-contained
7. Other code in the same file already has MT7628 guards for the same
   registers (`mtk_set_mcr_max_rx` at line 3886)

**Evidence AGAINST backporting:**
1. ~30 lines of new code (not trivially small, but straightforward)
2. May need rework for older stable trees (6.6, 6.1, 5.15) due to
   function refactoring
3. No explicit Cc: stable (expected for commits under review)

**Stable Rules Checklist:**
1. Obviously correct and tested? YES — reviewed by 2 experts, one the
   original author
2. Fixes a real bug? YES — VLAN config corruption on MT7628
3. Important issue? YES — data corruption, affects all MT7628 users
4. Small and contained? YES — single file, ~30 lines
5. No new features? CORRECT — only prevents invalid register writes
6. Can apply to stable? YES for 7.0; needs rework for older trees

**Verification:**
- [Phase 1] Parsed tags: Reviewed-by from Daniel Golle and Stefan Roese,
  Link to netdev submission
- [Phase 2] Diff analysis: Adds no-op phylink_mac_ops for MT7628,
  selects them in `mtk_add_mac()`, removes now-unreachable guard in
  `mtk_mac_config()`
- [Phase 3] git blame: buggy code from `b8fc9f30821ec0` (2019), phylink
  conversion missing MT7628 guards in link_down/link_up
- [Phase 3] git show 296c9120752b: confirmed original MT7628 support
  commit from v5.3 era (2019-08-16)
- [Phase 3] git tag --contains: original commit present in p-5.10,
  p-5.15 tags (all active stable trees)
- [Phase 5] Verified `mtk_mac_link_down` writes to
  `MTK_MAC_MCR(mac->id)` without MT7628 check (line 731 in current code)
- [Phase 5] Verified `mtk_mac_link_up`→`mtk_gdm_mac_link_up` writes to
  `MTK_MAC_MCR(mac->id)` (line 846) without MT7628 check
- [Phase 5] Verified `mtk_mac_finish` writes to `MTK_MAC_MCR(mac->id)`
  (line 709/716) without MT7628 check
- [Phase 5] Confirmed `mtk_set_mcr_max_rx` (line 3886) already guards
  against MT7628, proving developers know these registers don't exist on
  MT7628
- [Phase 6] Verified v6.6 stable has the same bug: `mtk_mac_link_down`
  (line 689) and `mtk_mac_link_up` (line 769) unconditionally write to
  `MTK_MAC_MCR`
- [Phase 6] `MTK_MAC_MCR(x)` = 0x10100 + x*0x100, confirmed in header
  file (line 453)
- [Phase 8] VLAN corruption confirmed by commit message: "Writes to
  these registers only corrupt the ESW VLAN configuration"
- UNVERIFIED: Could not access full lore.kernel.org discussion due to
  Anubis protection; relied on tags in the commit message

**YES**

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 34 ++++++++++++++++++---
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ddc321a02fdae..bb8ced22ca3be 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -562,9 +562,7 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 	int val, ge_mode, err = 0;
 	u32 i;
 
-	/* MT76x8 has no hardware settings between for the MAC */
-	if (!MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628) &&
-	    mac->interface != state->interface) {
+	if (mac->interface != state->interface) {
 		/* Setup soc pin functions */
 		switch (state->interface) {
 		case PHY_INTERFACE_MODE_TRGMII:
@@ -956,6 +954,30 @@ static const struct phylink_mac_ops mtk_phylink_ops = {
 	.mac_enable_tx_lpi = mtk_mac_enable_tx_lpi,
 };
 
+static void rt5350_mac_config(struct phylink_config *config, unsigned int mode,
+				const struct phylink_link_state *state)
+{
+}
+
+static void rt5350_mac_link_down(struct phylink_config *config, unsigned int mode,
+				phy_interface_t interface)
+{
+}
+
+static void rt5350_mac_link_up(struct phylink_config *config,
+			    struct phy_device *phy,
+			    unsigned int mode, phy_interface_t interface,
+			    int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+}
+
+/* MT76x8 (rt5350-eth) does not expose any MAC control registers */
+static const struct phylink_mac_ops rt5350_phylink_ops = {
+	.mac_config = rt5350_mac_config,
+	.mac_link_down = rt5350_mac_link_down,
+	.mac_link_up = rt5350_mac_link_up,
+};
+
 static void mtk_mdio_config(struct mtk_eth *eth)
 {
 	u32 val;
@@ -4780,6 +4802,7 @@ static const struct net_device_ops mtk_netdev_ops = {
 
 static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 {
+	const struct phylink_mac_ops *mac_ops = &mtk_phylink_ops;
 	const __be32 *_id = of_get_property(np, "reg", NULL);
 	phy_interface_t phy_mode;
 	struct phylink *phylink;
@@ -4914,9 +4937,12 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 			  mac->phylink_config.supported_interfaces);
 	}
 
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
+		mac_ops = &rt5350_phylink_ops;
+
 	phylink = phylink_create(&mac->phylink_config,
 				 of_fwnode_handle(mac->of_node),
-				 phy_mode, &mtk_phylink_ops);
+				 phy_mode, mac_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
 		goto free_netdev;
-- 
2.53.0

