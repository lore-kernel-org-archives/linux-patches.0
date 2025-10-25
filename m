Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C63064B8;
	Sat, 25 Oct 2025 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409681; cv=none; b=oxBKB1Av7K18erlqrWE+3nDv0Mgf0BHEYZLH+vi4DOMaEznNrIVPZrYQXORx8x8lx8jLcdhEyiO2Fm+CanwbeMfkMGhEFUOKbnKbzYJjJ/jpGXWanFC2CKsqF+0zHU9Do51n+ToDkBCZTSTejyn1vyZTYTVPcx45mwgK1E2pbVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409681; c=relaxed/simple;
	bh=uXV7XS7BXYinESnJI44OYBJ4XhTlm58QVMApSCWQBKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=miSeOBElMov31kLXeeESQEnPjPCvNXxTfhO/tLb3R0ELpYWxMPWyYUiSs8odQko2q2gVZw+rjMFnPyPvvS0L2SvbHoAQch3SCCFR7uf6vBW8LXXvR5DgoPvll6TokGmuqWr4n3JUMwE6xY0hfsebmbfXGM6Ksn8E7NpejVV1Pb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+e/rSnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+e/rSnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F02FC4CEFF;
	Sat, 25 Oct 2025 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409681;
	bh=uXV7XS7BXYinESnJI44OYBJ4XhTlm58QVMApSCWQBKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+e/rSnqiOAZHWwpvPBXBsMrkK+/F1o7CwrlgyU/dTQ+jFu2mi2Za4ngqgiNbNgap
	 9whbtMwv7bbWMrfn474nWQVoB9nBXK1PzqnXzTxWM/ABaMyISB0PbA4YXl21hlgV5s
	 y0rPLK162f7JuyWue8i2Td2ieCS3GpQsK3Hl4V8JLthk6kcRTStDGF3y0GyZ5uN2z7
	 BlrdSaPDTLLBe/XeWpl8xLgI4gBIhCge2quUhEoE1zigVolMNgPrJKRaOTPd1Sc9bF
	 Ag69xv3ZFC7jVbONKC1VQzALeJhH17xLUxQ0e4umNxna+gSeBySRgJtxQkVP5ZA4/3
	 eAlE48EPVK07g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rohan G Thomas <rohan.g.thomas@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hkallweit1@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.10] net: phy: marvell: Fix 88e1510 downshift counter errata
Date: Sat, 25 Oct 2025 12:00:50 -0400
Message-ID: <20251025160905.3857885-419-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rohan G Thomas <rohan.g.thomas@altera.com>

[ Upstream commit deb105f49879dd50d595f7f55207d6e74dec34e6 ]

The 88e1510 PHY has an erratum where the phy downshift counter is not
cleared after phy being suspended(BMCR_PDOWN set) and then later
resumed(BMCR_PDOWN cleared). This can cause the gigabit link to
intermittently downshift to a lower speed.

Disabling and re-enabling the downshift feature clears the counter,
allowing the PHY to retry gigabit link negotiation up to the programmed
retry count times before downshifting. This behavior has been observed
on copper links.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250906-marvell_fix-v2-1-f6efb286937f@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Bug fixed and user impact:
  - The commit addresses a real erratum on 88E1510 where the PHY
    downshift counter is not cleared across suspend/resume, which can
    cause intermittent, user-visible downshift from gigabit to lower
    speeds on copper links.

- What the patch changes:
  - Adds a device-specific resume wrapper `m88e1510_resume()` which
    first performs the normal resume sequence and then clears the stale
    downshift counter by toggling the downshift feature off and back on
    with the existing configured retry count.
    - `drivers/net/phy/marvell.c:1915` defines `m88e1510_resume(struct
      phy_device *phydev)`: it calls `marvell_resume()` to do the
      standard fiber/copper resume, then reads the configured downshift
      count via `m88e1011_get_downshift()`. If non-zero, it disables and
      re-enables downshift with the same count to clear the counter.
    - `drivers/net/phy/marvell.c:1875` shows `marvell_resume(struct
      phy_device *phydev)`, which handles the dual-mode (fiber/copper)
      page sequencing and invokes `genphy_resume()`. `m88e1510_resume()`
      invokes this first to keep existing resume behavior intact.
    - `drivers/net/phy/marvell.c:1138` `m88e1011_get_downshift()` reads
      the current downshift configuration (returns 0 if disabled).
    - `drivers/net/phy/marvell.c:1154` `m88e1011_set_downshift()`
      programs the downshift count and performs a soft reset to apply
      the change, which is exactly what is needed to reliably clear the
      counter.
  - Hooks the new resume into the 88E1510 driver entry only:
    - `drivers/net/phy/marvell.c:3961` sets `.resume = m88e1510_resume`
      for `MARVELL_PHY_ID_88E1510`, replacing the generic
      `marvell_resume` only for that PHY.

- Why it’s safe and minimal:
  - Scope-limited: Only 88E1510’s `.resume` is changed; other Marvell
    PHYs keep their existing resume paths.
  - No API or architectural changes: The patch only introduces a small
    wrapper and uses existing helper functions already used elsewhere in
    this driver.
  - Preserves user configuration: It reads the current downshift setting
    and restores the same count, doing nothing if downshift is disabled
    (`cnt == 0`), so it does not override user-set policy.
  - Correct sequencing and pages: `m88e1510_resume()` defers to
    `marvell_resume()` first, which restores the page to copper before
    calling the downshift helpers. The helpers operate on the copper
    page registers.
  - Side effects are minimal and expected: `m88e1011_set_downshift()`
    performs a soft reset to apply changes; the wrapper may cause two
    quick resets (disable then re-enable), slightly delaying link bring-
    up on resume but preventing the intermittent low-speed fallback — a
    clear net improvement for users.

- Stable backport criteria:
  - Fixes a real, user-facing bug (intermittent downshift after resume).
  - Small, isolated change to a single driver with no cross-subsystem
    impact.
  - Low regression risk and no new features or behavior changes beyond
    clearing the erratum condition.
  - Aligns with existing driver patterns and uses proven helper
    functions.

Given the above, this is a good candidate for stable backporting.

 drivers/net/phy/marvell.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 623292948fa70..0ea366c1217eb 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1902,6 +1902,43 @@ static int marvell_resume(struct phy_device *phydev)
 	return err;
 }
 
+/* m88e1510_resume
+ *
+ * The 88e1510 PHY has an erratum where the phy downshift counter is not cleared
+ * after phy being suspended(BMCR_PDOWN set) and then later resumed(BMCR_PDOWN
+ * cleared). This can cause the link to intermittently downshift to a lower speed.
+ *
+ * Disabling and re-enabling the downshift feature clears the counter, allowing
+ * the PHY to retry gigabit link negotiation up to the programmed retry count
+ * before downshifting. This behavior has been observed on copper links.
+ */
+static int m88e1510_resume(struct phy_device *phydev)
+{
+	int err;
+	u8 cnt = 0;
+
+	err = marvell_resume(phydev);
+	if (err < 0)
+		return err;
+
+	/* read downshift counter value */
+	err = m88e1011_get_downshift(phydev, &cnt);
+	if (err < 0)
+		return err;
+
+	if (cnt) {
+		/* downshift disabled */
+		err = m88e1011_set_downshift(phydev, 0);
+		if (err < 0)
+			return err;
+
+		/* downshift enabled, with previous counter value */
+		err = m88e1011_set_downshift(phydev, cnt);
+	}
+
+	return err;
+}
+
 static int marvell_aneg_done(struct phy_device *phydev)
 {
 	int retval = phy_read(phydev, MII_M1011_PHY_STATUS);
@@ -3923,7 +3960,7 @@ static struct phy_driver marvell_drivers[] = {
 		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
-		.resume = marvell_resume,
+		.resume = m88e1510_resume,
 		.suspend = marvell_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
-- 
2.51.0

