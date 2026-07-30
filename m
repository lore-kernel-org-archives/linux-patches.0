Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1026442F707;
	Thu, 30 Jul 2026 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423092; cv=none; b=ZrOv6ewiUNeqQj9NuFcVR1df/jW4/MpDR2xcssBdRk27pbLXqKkplZ0/+aGaNdoDWOgMDONT3HekQQGBSiBrjwNp0T/fO3BgMim/AFXP0Czrn20c/WclEQbF4K986qk+h6r79h7WTVRD2ptYZ62g6aJ+iJ0beDQXVFBUMpeRID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423092; c=relaxed/simple;
	bh=OEcnqmJKF2KfgkkrhkOK0jcLh2NGpruQKUgqR9VLKCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwRuT+//RzJOXckHnIvZ1TL2HgI742vsZEKgQCkgOQZNGzvRixySF+RSNOn/fCP1U7eiRe6TrvL1Fig8K3V9wUN401SlgwZVJycYyDlqmuW7gzhwkZg3GM68zCXuhK4p3DEshC9uB4X17TGCD+pR8MwSP7L39mA0l2NlvGxwSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8c94KT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8c94KT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EE41F000E9;
	Thu, 30 Jul 2026 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423091;
	bh=mhfn7MKe2K1r6AYTJMLTO0tcp6LF98tf/OfGgfzORB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E8c94KT9l9tEguUvkGaquyeytOPGHHIyFqZBM64Gq0x3zHgA2BLcFezrGtYKEWZoJ
	 AdXYvALcGCmQubiw0iYBpdl5pKRoBTLQ0RyWcPiTZ78PZ3qQllf152QquOFx3DbfEv
	 RYC/E0p3WncRusVlDOE4e6c+Sg6SYq2TfTcfAzFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Coia Prant <coiaprant@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 664/744] net: pcs: xpcs: fix SGMII state reading
Date: Thu, 30 Jul 2026 16:15:37 +0200
Message-ID: <20260730141458.379633980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pcs/pcs-xpcs.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1058,6 +1058,7 @@ static int xpcs_get_state_c37_sgmii(stru
 
 	/* Reset link_state */
 	state->link = false;
+	state->an_complete = false;
 	state->speed = SPEED_UNKNOWN;
 	state->duplex = DUPLEX_UNKNOWN;
 	state->pause = 0;
@@ -1069,6 +1070,8 @@ static int xpcs_get_state_c37_sgmii(stru
 	if (ret < 0)
 		return ret;
 
+	state->an_complete = ret & DW_VR_MII_AN_STS_C37_ANCMPLT_INTR;
+
 	if (ret & DW_VR_MII_C37_ANSGM_SP_LNKSTS) {
 		int speed_value;
 
@@ -1086,34 +1089,13 @@ static int xpcs_get_state_c37_sgmii(stru
 			state->duplex = DUPLEX_FULL;
 		else
 			state->duplex = DUPLEX_HALF;
-	} else if (ret == DW_VR_MII_AN_STS_C37_ANCMPLT_INTR) {
-		int speed, duplex;
-
-		state->link = true;
-
-		speed = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_BMCR);
-		if (speed < 0)
-			return speed;
 
-		speed &= BMCR_SPEED100 | BMCR_SPEED1000;
-		if (speed == BMCR_SPEED1000)
-			state->speed = SPEED_1000;
-		else if (speed == BMCR_SPEED100)
-			state->speed = SPEED_100;
-		else if (speed == 0)
-			state->speed = SPEED_10;
-
-		duplex = xpcs_read(xpcs, MDIO_MMD_VEND2, MII_ADVERTISE);
-		if (duplex < 0)
-			return duplex;
-
-		if (duplex & ADVERTISE_1000XFULL)
-			state->duplex = DUPLEX_FULL;
-		else if (duplex & ADVERTISE_1000XHALF)
-			state->duplex = DUPLEX_HALF;
+		return 0;
+	}
 
+	/* Clear AN complete status or interrupt */
+	if (state->an_complete)
 		xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS, 0);
-	}
 
 	return 0;
 }


