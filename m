Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35B332F77C;
	Wed,  3 Dec 2025 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777102; cv=none; b=Z+L53yRbIISba+Ohknc5V4DuKxHeJQokvtUhTi0x2D0yMLMwkuhGR0LEqqGaTrZpD2Z4nnETx3Eph0VkWU5w83CGUab81hhGCfzX1Yhmd9uwRzYT9wCbRG1pXknO0bV/aC5+eDHbv0Tg6x4vdPjejczHfh8xptFENV8O+t2zdtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777102; c=relaxed/simple;
	bh=3Wzc6B7/4Ho/O0y9sMSe8LxdTlHUNXqSjCOVPT2Uy1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVvvrE7yQtb9iWp9AYGUGt4Pq3jj2jOmDuIE+g/xbi3pwGsR+B6wwEBsR4Fi4RcVtuAJpwQnAIFBh+ZK2PvJcphwQ3yqp9h5+Z3cXkYggTw0kT3tpWcci/da9Yq2PelQ4VbKTGXThexDTpaKCWe6S2bXaQhvRM06UQ/cXun5KwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKsIQSaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKsIQSaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0ADC4CEF5;
	Wed,  3 Dec 2025 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777101;
	bh=3Wzc6B7/4Ho/O0y9sMSe8LxdTlHUNXqSjCOVPT2Uy1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKsIQSaDzRZ9wFbad1CTzj/3Mc53ALJIQfGplMPHN4EKCCPrIFGnw45PsuW/x4ltv
	 m41NirIRHhGGLM4JOSlYLDNfeFi6qUUaCL+HxOPI/iXTxXKKM+gUvc+M2av+xzFIJI
	 C8p2m72XZyxn3q9H3oG+UEbfcxMzXM0YUhstQ3PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.17 083/146] can: rcar_canfd: Fix CAN-FD mode as default
Date: Wed,  3 Dec 2025 16:27:41 +0100
Message-ID: <20251203152349.500654114@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

commit 6d849ff573722afcf5508d2800017bdd40f27eb9 upstream.

The commit 5cff263606a1 ("can: rcar_canfd: Fix controller mode setting")
has aligned with the flow mentioned in the hardware manual for all SoCs
except R-Car Gen3 and RZ/G2L SoCs. On R-Car Gen4 and RZ/G3E SoCs, due to
the wrong logic in the commit[1] sets the default mode to FD-Only mode
instead of CAN-FD mode.

This patch sets the CAN-FD mode as the default for all SoCs by dropping
the rcar_canfd_set_mode() as some SoC requires mode setting in global
reset mode, and the rest of the SoCs in channel reset mode and update the
rcar_canfd_reset_controller() to take care of these constraints. Moreover,
the RZ/G3E and R-Car Gen4 SoCs support 3 modes compared to 2 modes on the
R-Car Gen3. Use inverted logic in rcar_canfd_reset_controller() to
simplify the code later to support FD-only mode.

[1]
commit 45721c406dcf ("can: rcar_canfd: Add support for r8a779a0 SoC")

Fixes: 5cff263606a1 ("can: rcar_canfd: Fix controller mode setting")
Cc: stable@vger.kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251118123926.193445-1-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |   53 ++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 22 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -726,6 +726,11 @@ static void rcar_canfd_set_bit_reg(void
 	rcar_canfd_update(val, val, addr);
 }
 
+static void rcar_canfd_clear_bit_reg(void __iomem *addr, u32 val)
+{
+	rcar_canfd_update(val, 0, addr);
+}
+
 static void rcar_canfd_update_bit_reg(void __iomem *addr, u32 mask, u32 val)
 {
 	rcar_canfd_update(mask, val, addr);
@@ -772,25 +777,6 @@ static void rcar_canfd_set_rnc(struct rc
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GAFLCFG(w), rnc);
 }
 
-static void rcar_canfd_set_mode(struct rcar_canfd_global *gpriv)
-{
-	if (gpriv->info->ch_interface_mode) {
-		u32 ch, val = gpriv->fdmode ? RCANFD_GEN4_FDCFG_FDOE
-					    : RCANFD_GEN4_FDCFG_CLOE;
-
-		for_each_set_bit(ch, &gpriv->channels_mask,
-				 gpriv->info->max_channels)
-			rcar_canfd_set_bit_reg(&gpriv->fcbase[ch].cfdcfg, val);
-	} else {
-		if (gpriv->fdmode)
-			rcar_canfd_set_bit(gpriv->base, RCANFD_GRMCFG,
-					   RCANFD_GRMCFG_RCMC);
-		else
-			rcar_canfd_clear_bit(gpriv->base, RCANFD_GRMCFG,
-					     RCANFD_GRMCFG_RCMC);
-	}
-}
-
 static int rcar_canfd_reset_controller(struct rcar_canfd_global *gpriv)
 {
 	struct device *dev = &gpriv->pdev->dev;
@@ -823,6 +809,16 @@ static int rcar_canfd_reset_controller(s
 	/* Reset Global error flags */
 	rcar_canfd_write(gpriv->base, RCANFD_GERFL, 0x0);
 
+	/* Set the controller into appropriate mode */
+	if (!gpriv->info->ch_interface_mode) {
+		if (gpriv->fdmode)
+			rcar_canfd_set_bit(gpriv->base, RCANFD_GRMCFG,
+					   RCANFD_GRMCFG_RCMC);
+		else
+			rcar_canfd_clear_bit(gpriv->base, RCANFD_GRMCFG,
+					     RCANFD_GRMCFG_RCMC);
+	}
+
 	/* Transition all Channels to reset mode */
 	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->info->max_channels) {
 		rcar_canfd_clear_bit(gpriv->base,
@@ -840,10 +836,23 @@ static int rcar_canfd_reset_controller(s
 			dev_dbg(dev, "channel %u reset failed\n", ch);
 			return err;
 		}
-	}
 
-	/* Set the controller into appropriate mode */
-	rcar_canfd_set_mode(gpriv);
+		/* Set the controller into appropriate mode */
+		if (gpriv->info->ch_interface_mode) {
+			/* Do not set CLOE and FDOE simultaneously */
+			if (!gpriv->fdmode) {
+				rcar_canfd_clear_bit_reg(&gpriv->fcbase[ch].cfdcfg,
+							 RCANFD_GEN4_FDCFG_FDOE);
+				rcar_canfd_set_bit_reg(&gpriv->fcbase[ch].cfdcfg,
+						       RCANFD_GEN4_FDCFG_CLOE);
+			} else {
+				rcar_canfd_clear_bit_reg(&gpriv->fcbase[ch].cfdcfg,
+							 RCANFD_GEN4_FDCFG_FDOE);
+				rcar_canfd_clear_bit_reg(&gpriv->fcbase[ch].cfdcfg,
+							 RCANFD_GEN4_FDCFG_CLOE);
+			}
+		}
+	}
 
 	return 0;
 }


