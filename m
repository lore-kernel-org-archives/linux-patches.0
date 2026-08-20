Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220BE46D0B6;
	Thu, 20 Aug 2026 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247664; cv=none; b=UnjbA2uRxonvkAELpxhFcf32spEeC5VBiqvdktv5soTggcBG7t4T+/KPrqpTB/txxLdr7KvrzYMkL7a+CtkCBzivIgU+jzruzKFIVQ5mZEgk4Vt1MXrygp+5vYwB2lx8uCdGOIqEJsiPMKEb/1omeWWh8sjx7apjvLZDnrqoD1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247664; c=relaxed/simple;
	bh=GkwxEfbOpDdtxY9mV/A7NSNMrRv1GBpU6WwrF5TrO+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/sO2X0E2qDZeq8mMicsIHX37qLNmNimtWBiIgdJaY6+45uophLe7UVcv3mrbNop4XCkdDyXtdv/PVoD45oZjg5xZMDvaPqvWhinm8/F2h3hdPfIHt7r4dtpvSTykcbcdsglNZu6DSeVjjeUBusCLBX/N6VvX+IqWCZCRX7Umb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMkhhToN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMkhhToN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813611F00ADB;
	Thu, 20 Aug 2026 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247663;
	bh=sZhZee2xMry7q1jerHSDmKKZfY+RLkFBepfPNpJk298=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMkhhToNW4Y1Pe/22tA7sjfeEhEpr8UIdWi93useCR3FoNTpRwbVi4fReWDwiAtUh
	 D7/U7THL6MyZL9VW1U8yK8PzRqpDCuUTEHfLp/XMHm8q8lZ400JAaSlSAjyqzT7ZYW
	 6MAfliCteSAwIaC/deQEYydHuihwP1xBXuqoDXrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tu Nguyen <tu.nguyen.xg@renesas.com>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/166] can: rcar_canfd: change the initializing flow for clocks and resets
Date: Thu, 20 Aug 2026 16:56:25 +0200
Message-ID: <20260820145214.954151999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Tu Nguyen <tu.nguyen.xg@renesas.com>

[ Upstream commit bef9004c5b91debfceaea2841855a4ebe81ff2b3 ]

Testing CANFD on RZ/G3E shows that many registers do not reset to their
initial values with the current flow of deasserting resets first and then
enabling clocks.

Based on the HW manual, clocks should be supplied first and the
resets deasserted afterward.

 section 7.4.3 Procedure for Activating Modules: RZ/G2L
 section 4.4.9.3 Procedure for Starting up Units: RZ/G3E

So, update the order of the initializing flow for resets and clocks
to match the hardware manual, resetting all CANFD registers to their
initial values. Also update rcar_canfd_global_deinit() to assert
resets before disabling clocks, so the teardown path mirrors the new
init ordering.

Fixes: 76e9353a80e9 ("can: rcar_canfd: Add support for RZ/G2L family")
Signed-off-by: Tu Nguyen <tu.nguyen.xg@renesas.com>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260625135216.130450-1-biju.das.jz@bp.renesas.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1999,27 +1999,27 @@ static int rcar_canfd_probe(struct platf
 		}
 	}
 
-	err = reset_control_reset(gpriv->rstc1);
-	if (err)
-		goto fail_dev;
-	err = reset_control_reset(gpriv->rstc2);
-	if (err) {
-		reset_control_assert(gpriv->rstc1);
-		goto fail_dev;
-	}
-
 	/* Enable peripheral clock for register access */
 	err = clk_prepare_enable(gpriv->clkp);
 	if (err) {
 		dev_err(dev, "failed to enable peripheral clock: %pe\n",
 			ERR_PTR(err));
-		goto fail_reset;
+		goto fail_dev;
+	}
+
+	err = reset_control_reset(gpriv->rstc1);
+	if (err)
+		goto fail_clk;
+	err = reset_control_reset(gpriv->rstc2);
+	if (err) {
+		reset_control_assert(gpriv->rstc1);
+		goto fail_clk;
 	}
 
 	err = rcar_canfd_reset_controller(gpriv);
 	if (err) {
 		dev_err(dev, "reset controller failed: %pe\n", ERR_PTR(err));
-		goto fail_clk;
+		goto fail_reset;
 	}
 
 	/* Controller in Global reset & Channel reset mode */
@@ -2070,11 +2070,11 @@ fail_channel:
 		rcar_canfd_channel_remove(gpriv, ch);
 fail_mode:
 	rcar_canfd_disable_global_interrupts(gpriv);
-fail_clk:
-	clk_disable_unprepare(gpriv->clkp);
 fail_reset:
 	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
+fail_clk:
+	clk_disable_unprepare(gpriv->clkp);
 fail_dev:
 	return err;
 }
@@ -2094,9 +2094,9 @@ static void rcar_canfd_remove(struct pla
 
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
-	clk_disable_unprepare(gpriv->clkp);
 	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
+	clk_disable_unprepare(gpriv->clkp);
 }
 
 static int __maybe_unused rcar_canfd_suspend(struct device *dev)


