Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305AF44683E;
	Thu, 30 Jul 2026 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427986; cv=none; b=KNCzs6il5jI05ZEfmugN6W4gZC1huZrj1z968Sf1L+L0sJCyZ53l9EetD0S22iSgu0AjoGJe1MoGDmNEO3n3yXd06R35Cu+5U0lutcU5Lql8kXLCgJE6RhdsHkriJr2eD8EBIRr3EhwgKOxrTWsFlUdVx7pUz3JFDLc/mM0wAVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427986; c=relaxed/simple;
	bh=5dwp8nhuCkdbFTKHvqrYM/U5Scn7L2ZYJD0PKrF63RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3Apu7Ji312+deJTRNUAcbYVBA4X0Q9wmfPSJGn4A3NXUcMGoBNpVNeYivrWbzrwpKf4618CuUuBntdRjRUdpDLNdc0q6ltbSTMuRw9kCc/J+N/LuFuO4oLoxxQJF4p8NM5TlQOkepu1p6Xs1jXVgD+ORlGQ6rcZbyZwv5YGG+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4HVxx/E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4HVxx/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3DE1F000E9;
	Thu, 30 Jul 2026 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427985;
	bh=JTXMHx/tEiwKTQPZe/MogCoGfIPKq7bbi9StMTCE6aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4HVxx/EQTT6NqJhc7iKp2+3uCpj37nG/mqUNnKWhlvchN2pm27HFXM+Zw29vx5a1
	 2l8fmK55Y2C/CR0aj7MXTY0/4+jE4/PBCgbbnZbi/1NCF+vFrdOFEBg5VLsdPjqZii
	 waw39Tk+vkjmj0RZFOtV/Zm8OIZ1x4+AM1Q4Bp1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Coia Prant <coiaprant@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 361/484] net: pcs: xpcs: fix SGMII state reading
Date: Thu, 30 Jul 2026 16:14:18 +0200
Message-ID: <20260730141431.318888793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coia Prant <coiaprant@gmail.com>

commit def9a4745e105145133e442dd8a1c126caf0f553 upstream.

Commit 2a22b7ae2fa3 ("net: pcs: xpcs: adapt Wangxun NICs for SGMII mode")
added a path in xpcs_get_state_c37_sgmii() that reads speed/duplex from
BMCR after AN completes. However, BMCR does not reflect the negotiated
result on the hardware where this has been tested:

- On RK3568 (MAC side SGMII), BMCR returns a fixed hardware reset value
- Wangxun engineer Jiawen Wu confirmed that on their side, "BMCR looks
  like it only wants to be return as 0" [0]

The correct information is available in CL37_ANSGM_STS, which contains
the actual link status and negotiated speed/duplex.

This bug was previously masked by phylink core, which overrides the PCS
link state with the PHY state when a PHY is present:

        /* If we have a phy, the "up" state is the union of both the
         * PHY and the MAC
         */
        if (phy)
                link_state.link &= pl->phy_state.link;

Thus, when the link is down, the PHY's link_down state is applied on top
of whatever the PCS reports, hiding the broken PCS state reading path.

Modify xpcs_get_state_c37_sgmii() to:
1. Read link state from CL37_ANSGM_STS
2. If link is up, report speed/duplex from CL37_ANSGM_STS
3. Remove the broken BMCR reading path entirely

Also properly set state->an_complete to reflect the AN completion status,
and clear CL37_ANCMPLT_INTR when link is down to avoid stale state.

[0] https://lore.kernel.org/all/000c01dd1593$2ac0b0f0$804212d0$@trustnetic.com/

Fixes: 2a22b7ae2fa3 ("net: pcs: xpcs: adapt Wangxun NICs for SGMII mode")
Cc: stable@vger.kernel.org
Tested-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Coia Prant <coiaprant@gmail.com>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260717074324.3250043-2-coiaprant@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index f0f41e86a4fb32..680e2b2610860f 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -994,6 +994,7 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 
 	/* Reset link_state */
 	state->link = false;
+	state->an_complete = false;
 	state->speed = SPEED_UNKNOWN;
 	state->duplex = DUPLEX_UNKNOWN;
 	state->pause = 0;
@@ -1005,6 +1006,8 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	if (ret < 0)
 		return ret;
 
+	state->an_complete = ret & DW_VR_MII_AN_STS_C37_ANCMPLT_INTR;
+
 	if (ret & DW_VR_MII_C37_ANSGM_SP_LNKSTS) {
 		int speed_value;
 
@@ -1023,34 +1026,13 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 			state->duplex = DUPLEX_FULL;
 		else
 			state->duplex = DUPLEX_HALF;
-	} else if (ret == DW_VR_MII_AN_STS_C37_ANCMPLT_INTR) {
-		int speed, duplex;
-
-		state->link = true;
-
-		speed = xpcs_read(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1);
-		if (speed < 0)
-			return speed;
-
-		speed &= SGMII_SPEED_SS13 | SGMII_SPEED_SS6;
-		if (speed == SGMII_SPEED_SS6)
-			state->speed = SPEED_1000;
-		else if (speed == SGMII_SPEED_SS13)
-			state->speed = SPEED_100;
-		else if (speed == 0)
-			state->speed = SPEED_10;
-
-		duplex = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE);
-		if (duplex < 0)
-			return duplex;
 
-		if (duplex & DW_FULL_DUPLEX)
-			state->duplex = DUPLEX_FULL;
-		else if (duplex & DW_HALF_DUPLEX)
-			state->duplex = DUPLEX_HALF;
+		return 0;
+	}
 
+	/* Clear AN complete status or interrupt */
+	if (state->an_complete)
 		xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS, 0);
-	}
 
 	return 0;
 }
-- 
2.53.0



