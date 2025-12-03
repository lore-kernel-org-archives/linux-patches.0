Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B44338F45;
	Wed,  3 Dec 2025 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780878; cv=none; b=duWUjkjYUj+Cj9SOAOH0Sh7jhyBMbRgZ8IqMPNZbItRAYvb/gNKnz1Z18YRue0EpGV5PpKI8+VBxMfs6l3F2EiDaVrC3Uoqrc6kUWlQ06XPGFzjIHel47Bi0aReiw26cexX4KyAp4twMmwm23SsHBIWlUxamQdzhVK+Fv61/ZKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780878; c=relaxed/simple;
	bh=6AvCHEULzaJYWnvtuku9qy/fjcF6BWWU4vd9JXZJ8kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3cS3dKfP4cSJEy3UFQ+Ahnh/OXYNv1a14P2ZJtMR/K8mVl4lwPoJT4oL82ZKEx1jbe1sHLWVRN+z8rs0ZRZK7bv2tUmufBl3+1iGYkhj1vtDtfyc/FPbxvEeeqrjM2vRxliURTO7W7NR3np7cFv8vGe25vgjd/MQU/qpVP8CUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlYEPUKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlYEPUKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C74FC4CEF5;
	Wed,  3 Dec 2025 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780878;
	bh=6AvCHEULzaJYWnvtuku9qy/fjcF6BWWU4vd9JXZJ8kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlYEPUKTYHkvde8TfG57r1otsEsKcFg6xQ08G0gSTf/5RsLaGOZCkS/dBNgEwg+VI
	 owg6ZFqw/fBUBn4ywKAXiew56WhlhYPeUmk/Chin8JlzyiHEx4ivR/8a9NT6L+1QhC
	 ZvlADW4XOwsIUIM2QrkdiGxIrr62gTVL3Y4KaLX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/132] can: rcar_canfd: Fix CAN-FD mode as default
Date: Wed,  3 Dec 2025 16:29:56 +0100
Message-ID: <20251203152347.646816017@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 6d849ff573722afcf5508d2800017bdd40f27eb9 ]

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
[ adapted to use existing is_gen4() helper and RCANFD_GEN4_FDCFG() macro instead of new ch_interface_mode field and fcbase struct ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |   53 +++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 23 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -681,26 +681,6 @@ static void rcar_canfd_tx_failure_cleanu
 		can_free_echo_skb(ndev, i, NULL);
 }
 
-static void rcar_canfd_set_mode(struct rcar_canfd_global *gpriv)
-{
-	if (is_gen4(gpriv)) {
-		u32 ch, val = gpriv->fdmode ? RCANFD_GEN4_FDCFG_FDOE
-					    : RCANFD_GEN4_FDCFG_CLOE;
-
-		for_each_set_bit(ch, &gpriv->channels_mask,
-				 gpriv->info->max_channels)
-			rcar_canfd_set_bit(gpriv->base, RCANFD_GEN4_FDCFG(ch),
-					   val);
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
 	u32 sts, ch;
@@ -732,6 +712,16 @@ static int rcar_canfd_reset_controller(s
 	/* Reset Global error flags */
 	rcar_canfd_write(gpriv->base, RCANFD_GERFL, 0x0);
 
+	/* Set the controller into appropriate mode */
+	if (!is_gen4(gpriv)) {
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
@@ -750,10 +740,27 @@ static int rcar_canfd_reset_controller(s
 				"channel %u reset failed\n", ch);
 			return err;
 		}
-	}
 
-	/* Set the controller into appropriate mode */
-	rcar_canfd_set_mode(gpriv);
+		/* Set the controller into appropriate mode */
+		if (is_gen4(gpriv)) {
+			/* Do not set CLOE and FDOE simultaneously */
+			if (!gpriv->fdmode) {
+				rcar_canfd_clear_bit(gpriv->base,
+						     RCANFD_GEN4_FDCFG(ch),
+						     RCANFD_GEN4_FDCFG_FDOE);
+				rcar_canfd_set_bit(gpriv->base,
+						   RCANFD_GEN4_FDCFG(ch),
+						   RCANFD_GEN4_FDCFG_CLOE);
+			} else {
+				rcar_canfd_clear_bit(gpriv->base,
+						     RCANFD_GEN4_FDCFG(ch),
+						     RCANFD_GEN4_FDCFG_FDOE);
+				rcar_canfd_clear_bit(gpriv->base,
+						     RCANFD_GEN4_FDCFG(ch),
+						     RCANFD_GEN4_FDCFG_CLOE);
+			}
+		}
+	}
 
 	return 0;
 }


