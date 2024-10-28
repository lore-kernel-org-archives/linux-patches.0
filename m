Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D648837;
	Mon, 28 Oct 2024 06:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098385; cv=none; b=LG+auBMxh09IqATurw96cgPjIDha/mY7oFtHKPnnqGhANmOFPzx7TtXHkex2KfKxWU94x+3uleU63et+XV5g+DsJ640QE36iHykDcc3si2efQ4YoWPMydlri8O4f0hKsWt9Bnit5hqeLY9XZ3e/VDKcw5VXIh/JR0EgNaTuovwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098385; c=relaxed/simple;
	bh=x03zpb1kTnGrHdtPGgV0QOSV4zwamE+3EXYAtH/uROs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IadIt0vyoGmtokPr5mFyrVHp3uLVOOH/ChA7Hu5sXXY3oHDr1h5Gb0RKwKUxbuSPsT2Temx6iOTv2T/M8wWfb2rT+4AYaAzjONuj3dVN4bQnkVm8Gc3siLp1CaXuC6dX85wdt0WX+XalurmlLQ7th5Tu1g21wgBBX8RN/+4qL4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izup02ge; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izup02ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E91C4CEC3;
	Mon, 28 Oct 2024 06:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098385;
	bh=x03zpb1kTnGrHdtPGgV0QOSV4zwamE+3EXYAtH/uROs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izup02gePcu7pMm0Flu/B7agl86wIqdgLbWAjoNXm9/G8w+uDBWA/mjJacLoa86qQ
	 nunKSfLBgeXqVBGdvBeKqRhyE/NFMbz+7A9iM+hVbk9w/H+rkSb87vnYecYYBds4hH
	 2qN0XN1zNzuDJWWArg6tmBE95at9qX27TmYRW9UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 176/261] net: dsa: microchip: disable EEE for KSZ879x/KSZ877x/KSZ876x
Date: Mon, 28 Oct 2024 07:25:18 +0100
Message-ID: <20241028062316.415053865@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit ee76eb24343bdd5450eb87572865a4d7fffd335b ]

The well-known errata regarding EEE not being functional on various KSZ
switches has been refactored a few times. Recently the refactoring has
excluded several switches that the errata should also apply to.

Disable EEE for additional switches with this errata and provide
additional comments referring to the public errata document.

The original workaround for the errata was applied with a register
write to manually disable the EEE feature in MMD 7:60 which was being
applied for KSZ9477/KSZ9897/KSZ9567 switch ID's.

Then came commit 26dd2974c5b5 ("net: phy: micrel: Move KSZ9477 errata
fixes to PHY driver") and commit 6068e6d7ba50 ("net: dsa: microchip:
remove KSZ9477 PHY errata handling") which moved the errata from the
switch driver to the PHY driver but only for PHY_ID_KSZ9477 (PHY ID)
however that PHY code was dead code because an entry was never added
for PHY_ID_KSZ9477 via MODULE_DEVICE_TABLE.

This was apparently realized much later and commit 54a4e5c16382 ("net:
phy: micrel: add Microchip KSZ 9477 to the device table") added the
PHY_ID_KSZ9477 to the PHY driver but as the errata was only being
applied to PHY_ID_KSZ9477 it's not completely clear what switches
that relates to.

Later commit 6149db4997f5 ("net: phy: micrel: fix KSZ9477 PHY issues
after suspend/resume") breaks this again for all but KSZ9897 by only
applying the errata for that PHY ID.

Following that this was affected with commit 08c6d8bae48c("net: phy:
Provide Module 4 KSZ9477 errata (DS80000754C)") which removes
the blatant register write to MMD 7:60 and replaces it by
setting phydev->eee_broken_modes = -1 so that the generic phy-c45 code
disables EEE but this is only done for the KSZ9477_CHIP_ID (Switch ID).

Lastly commit 0411f73c13af ("net: dsa: microchip: disable EEE for
KSZ8567/KSZ9567/KSZ9896/KSZ9897.") adds some additional switches
that were missing to the errata due to the previous changes.

This commit adds an additional set of switches.

Fixes: 0411f73c13af ("net: dsa: microchip: disable EEE for KSZ8567/KSZ9567/KSZ9896/KSZ9897.")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20241018160658.781564-1-tharvey@gateworks.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1491099528be8..5ec21bda8ab63 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2579,26 +2579,27 @@ static u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
 			return MICREL_KSZ8_P1_ERRATA;
 		break;
 	case KSZ8567_CHIP_ID:
+		/* KSZ8567R Errata DS80000752C Module 4 */
+	case KSZ8765_CHIP_ID:
+	case KSZ8794_CHIP_ID:
+	case KSZ8795_CHIP_ID:
+		/* KSZ879x/KSZ877x/KSZ876x Errata DS80000687C Module 2 */
 	case KSZ9477_CHIP_ID:
+		/* KSZ9477S Errata DS80000754A Module 4 */
 	case KSZ9567_CHIP_ID:
+		/* KSZ9567S Errata DS80000756A Module 4 */
 	case KSZ9896_CHIP_ID:
+		/* KSZ9896C Errata DS80000757A Module 3 */
 	case KSZ9897_CHIP_ID:
-		/* KSZ9477 Errata DS80000754C
-		 *
-		 * Module 4: Energy Efficient Ethernet (EEE) feature select must
-		 * be manually disabled
+		/* KSZ9897R Errata DS80000758C Module 4 */
+		/* Energy Efficient Ethernet (EEE) feature select must be manually disabled
 		 *   The EEE feature is enabled by default, but it is not fully
 		 *   operational. It must be manually disabled through register
 		 *   controls. If not disabled, the PHY ports can auto-negotiate
 		 *   to enable EEE, and this feature can cause link drops when
 		 *   linked to another device supporting EEE.
 		 *
-		 * The same item appears in the errata for the KSZ9567, KSZ9896,
-		 * and KSZ9897.
-		 *
-		 * A similar item appears in the errata for the KSZ8567, but
-		 * provides an alternative workaround. For now, use the simple
-		 * workaround of disabling the EEE feature for this device too.
+		 * The same item appears in the errata for all switches above.
 		 */
 		return MICREL_NO_EEE;
 	}
-- 
2.43.0



