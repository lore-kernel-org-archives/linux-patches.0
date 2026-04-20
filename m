Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC38B3F65EE;
	Mon, 20 Apr 2026 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691558; cv=none; b=K4zzAQExjJNpuMV3zCBST1clHNHEayXKs50+4R7Rv0K2PjGs3UvLnFI/I0KvorGBjoWEMKlaBhFG3er2kDy56YxtMP4xAsYyZgIKLyeco8bpQNzZYL6ckcOLK6huBSLKraWggKzU3TeV3Ma0GayINd/BwLr2IlGF30+XQ1eIsAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691558; c=relaxed/simple;
	bh=71mdV0N9Z/K1qMt8sXvaS3zsahUVtusLbp4QJnfwiHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqqsCgYuSvK9/wxkFZfYc8zQv/ug+3O2btqqumQp/mmQj1I1hIjI5iTDQKmny2aGug4WilRe79/t0w1xLAUuRUbhhq0RYMrqlKF/VvYWufjuaL81rfkXFkgTH4bIWeJY9vXICP19A9yJ36MWIMm+hCtx2qsDBalQg00VdlDzQ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s7sJoSiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7sJoSiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A1CC2BCB8;
	Mon, 20 Apr 2026 13:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691558;
	bh=71mdV0N9Z/K1qMt8sXvaS3zsahUVtusLbp4QJnfwiHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7sJoSiL1p5gVjmludGvI7UxYiPyAKXyY3kILFmlQCqMFK/oEgEKo+Fetlwa9FWU4
	 T+5JEfYAw4mjGsoWOslYOQheqGPCjK55Td9LEXwTkkD9i8b0jKHASpw+4JrEmkojF4
	 ymvvhmmmkmQAD08OGz1baJrJg6k8cEqpVOH6gZ7mGOnmS9mLsjLzZOujtmj0o6Ojg/
	 KtQNmzecmw+RKBvtZJ79dz+hx5je2C3v/H1UzdEfXmzx6D7Kt62XIBmBvZJRRSPg0/
	 jvAzzvzBmraCdIdHGkNMLZInTB5PrDLXf80afWEEkdMy2XoHYpLXr18fV/CrUZ2t8X
	 mk9e7tiUn1+Nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Hoffmann <jan@3e8.eu>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] net: sfp: add quirk for ZOERAX SFP-2.5G-T
Date: Mon, 20 Apr 2026 09:18:13 -0400
Message-ID: <20260420132314.1023554-99-sashal@kernel.org>
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

From: Jan Hoffmann <jan@3e8.eu>

[ Upstream commit 911e2c050963ccf239faec6ae9dee0f5e8f1cc5c ]

This is a 2.5G copper module which appears to be based on a Motorcomm
YT8821 PHY. There doesn't seem to be a usable way to to access the PHY
(I2C address 0x56 provides only read-only C22 access, and Rollball is
also not working).

The module does not report the correct extended compliance code for
2.5GBase-T, and instead claims to support SONET OC-48 and Fibre Channel:

  Identifier          : 0x03 (SFP)
  Extended identifier : 0x04 (GBIC/SFP defined by 2-wire interface ID)
  Connector           : 0x07 (LC)
  Transceiver codes   : 0x00 0x01 0x00 0x00 0x40 0x40 0x04 0x00 0x00
  Transceiver type    : FC: Multimode, 50um (M5)
  Encoding            : 0x05 (SONET Scrambled)
  BR Nominal          : 2500MBd

Despite this, the kernel still enables the correct 2500Base-X interface
mode. However, for the module to actually work, it is also necessary to
disable inband auto-negotiation.

Enable the existing "sfp_quirk_oem_2_5g" for this module, which handles
that and also sets the bit for 2500Base-T link mode.

Signed-off-by: Jan Hoffmann <jan@3e8.eu>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20260329191304.720160-1-jan@3e8.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the results.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `net: sfp:`
- Action verb: "add" (adding a quirk entry)
- Summary: Add hardware quirk for ZOERAX SFP-2.5G-T copper SFP module

**Step 1.2: Tags**
- `Signed-off-by: Jan Hoffmann <jan@3e8.eu>` — author
- `Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>` —
  **SFP subsystem maintainer reviewed it**
- `Link: https://patch.msgid.link/20260329191304.720160-1-jan@3e8.eu`
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` — networking
  maintainer applied it
- No Fixes: tag (expected for a quirk addition)
- No Cc: stable (expected — that's why we're reviewing)

**Step 1.3: Commit Body Analysis**
- Bug: ZOERAX SFP-2.5G-T is a 2.5G copper module based on Motorcomm
  YT8821 PHY
- The PHY is inaccessible (I2C 0x56 is read-only C22, Rollball doesn't
  work)
- Module reports incorrect extended compliance codes (claims SONET OC-48
  + Fibre Channel instead of 2.5GBase-T)
- Despite this, kernel enables correct 2500Base-X mode, BUT inband auto-
  negotiation must be disabled for it to actually work
- The `sfp_quirk_oem_2_5g` quirk handles disabling autoneg and sets
  2500Base-T link mode

**Step 1.4: Hidden Bug Fix Detection**
This is an explicit hardware quirk addition — without it, the ZOERAX
SFP-2.5G-T module does not work. This is a hardware enablement fix.

Record: This is a hardware quirk that makes a specific SFP module
functional.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/net/phy/sfp.c`)
- Lines added: 2 (one blank line, one quirk entry)
- Lines removed: 0
- Scope: Single-line addition to a static const table

**Step 2.2: Code Flow Change**
- Before: ZOERAX SFP-2.5G-T module not in quirk table; module doesn't
  get autoneg disabled; doesn't work
- After: Module matched by vendor/part strings; `sfp_quirk_oem_2_5g`
  applied; sets 2500baseT link mode, 2500BASEX interface, disables
  autoneg

**Step 2.3: Bug Mechanism**
Category: Hardware workaround (h). The module has broken EEPROM data and
requires autoneg to be disabled. The quirk entry matches vendor string
"ZOERAX" and part string "SFP-2.5G-T" and applies the existing
`sfp_quirk_oem_2_5g` handler.

**Step 2.4: Fix Quality**
- Obviously correct: YES — it's a single table entry reusing an
  existing, proven quirk handler
- Minimal/surgical: YES — 1 functional line added
- Regression risk: NONE — only affects this specific module identified
  by vendor+part strings
- No API changes, no logic changes

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The quirk table has been present since v6.1 era (commit 23571c7b964374,
Sept 2022). The `sfp_quirk_oem_2_5g` function was added in v6.4 (commit
50e96acbe1166, March 2023). The `SFP_QUIRK_S` macro was introduced in
v6.18 (commit a7dc35a9e49b10).

**Step 3.2: No Fixes: tag** — expected for quirk additions.

**Step 3.3: Related Changes**
Multiple similar quirk additions have been made to `sfp.c` recently
(Hisense, HSGQ, Lantech, OEM modules). This is a well-established
pattern.

**Step 3.4: Author**
Jan Hoffmann has no prior commits in `sfp.c`, but the patch was reviewed
by Russell King (SFP maintainer) and applied by Jakub Kicinski
(networking maintainer).

**Step 3.5: Dependencies**
- `sfp_quirk_oem_2_5g` function: present since v6.4
- `SFP_QUIRK_S` macro: present since v6.18
- For 7.0.y stable: no dependencies needed, applies cleanly
- For trees older than 6.18: the macro format would need adaptation

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1:** b4 dig could not match the commit by message-id (the
commit hasn't been indexed yet or format mismatch). Lore was not
accessible due to bot protection. The Link: tag points to the original
submission at `patch.msgid.link`.

**Step 4.2:** Reviewed-by Russell King (SFP subsystem
author/maintainer). Applied by Jakub Kicinski (net maintainer). Strong
review chain.

**Step 4.3-4.5:** No bug report — this is a new hardware quirk, not a
regression fix. No prior stable discussion needed.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** No functions modified — only a table entry added.

**Step 5.2-5.4:** The `sfp_quirk_oem_2_5g` function is already used by
the existing `"OEM", "SFP-2.5G-T"` entry. The new entry simply extends
the same quirk to a different vendor's module. The matching logic in
`sfp_match()` is well-tested and unchanged.

**Step 5.5:** This is the exact same pattern as the OEM SFP-2.5G-T quirk
(line 583). The ZOERAX module is apparently the same hardware (Motorcomm
YT8821 PHY) under a different vendor brand.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The `sfp_quirk_oem_2_5g` function exists in stable trees
from v6.4+. The `SFP_QUIRK_S` macro exists from v6.18+. For the 7.0.y
stable tree, both prerequisites exist.

**Step 6.2:** For 7.0.y: clean apply expected. For older stable trees
(6.6.y, 6.1.y): would need adaptation to use the old macro format.

**Step 6.3:** No related fixes for ZOERAX already in stable.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Subsystem: networking / SFP PHY driver. Criticality:
IMPORTANT — SFP modules are used in many networking setups.

**Step 7.2:** The SFP quirk table is actively maintained with frequent
additions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affected users: anyone with a ZOERAX SFP-2.5G-T module
(specific hardware users).

**Step 8.2:** Trigger: module insertion — every time the module is used.
Without the quirk, the module simply doesn't work at all.

**Step 8.3:** Failure mode: Module non-functional (no network
connectivity). Severity: MEDIUM-HIGH for affected users — their hardware
doesn't work.

**Step 8.4:**
- Benefit: HIGH — makes specific hardware work
- Risk: VERY LOW — single table entry, affects only this specific module
- Ratio: Very favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- This is a textbook hardware quirk addition — explicitly listed as a
  YES exception in stable rules
- Single line added to a static table, reusing existing proven quirk
  handler
- Zero regression risk — only matches one specific module by vendor+part
  strings
- Reviewed by the SFP subsystem maintainer (Russell King)
- Applied by networking maintainer (Jakub Kicinski)
- Without this quirk, the ZOERAX SFP-2.5G-T module is non-functional
- Follows the well-established pattern of dozens of similar quirk
  additions

**Evidence AGAINST backporting:**
- None significant. The only concern is that older stable trees
  (pre-6.18) would need the macro format adapted.

**Stable Rules Checklist:**
1. Obviously correct and tested? YES — single table entry, reviewed by
   maintainer
2. Fixes a real bug? YES — hardware doesn't work without it
3. Important issue? YES for affected users (complete hardware non-
   functionality)
4. Small and contained? YES — 1 functional line
5. No new features or APIs? Correct — just a quirk entry
6. Can apply to stable? YES for 7.0.y; minor adaptation needed for older
   trees

**Exception Category:** SFP/Network hardware quirk — automatic YES.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Russell King (SFP maintainer),
  applied by Jakub Kicinski
- [Phase 2] Diff analysis: 1 line added to `sfp_quirks[]` table:
  `SFP_QUIRK_S("ZOERAX", "SFP-2.5G-T", sfp_quirk_oem_2_5g)`
- [Phase 3] git blame: quirk table present since v6.1 era;
  `sfp_quirk_oem_2_5g` since v6.4 (50e96acbe1166); `SFP_QUIRK_S` since
  v6.18 (a7dc35a9e49b10)
- [Phase 3] git tag --contains: `sfp_quirk_oem_2_5g` in v6.4+,
  `SFP_QUIRK_S` in v6.18+
- [Phase 3] git log --author: Russell King is the SFP subsystem
  maintainer with 10+ commits in sfp.c
- [Phase 4] b4 dig could not find match; lore blocked by bot protection
- [Phase 5] sfp_quirk_oem_2_5g already used by OEM SFP-2.5G-T entry
  (line 583) — proven handler
- [Phase 6] Both dependencies present in 7.0.y tree; clean apply
  expected
- [Phase 8] Failure mode: hardware non-functional without quirk
- UNVERIFIED: Could not access lore.kernel.org discussion due to bot
  protection (does not affect decision — the technical merits are clear)

**YES**

 drivers/net/phy/sfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 6b7b8ae15d106..bd970f753beb6 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -588,6 +588,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_F("Turris", "RTSFP-2.5G", sfp_fixup_rollball),
 	SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
 	SFP_QUIRK_F("Turris", "RTSFP-10G", sfp_fixup_rollball),
+
+	SFP_QUIRK_S("ZOERAX", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 };
 
 static size_t sfp_strlen(const char *str, size_t maxlen)
-- 
2.53.0

