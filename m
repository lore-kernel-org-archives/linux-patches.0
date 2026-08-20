Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B7E47A88F;
	Thu, 20 Aug 2026 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247152; cv=none; b=fqZR6oNg/BW83Mdb3/mlp2gtXGApLK/mWsJ9bl+89vxtmElG+d5SuLD8N/Hddaa3EMr5ik/V46uJ97o6TL+zr6VznWCx9pchlEKRdU/SKkYZjQHC1NDHaBZdG9RFlDaLwjz4cgkEmP3W4cFVmk60H6m/Zk9hXDVTLm0LuIXwI70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247152; c=relaxed/simple;
	bh=jg8ff/lIXhKEzosJoGvDHkeWXnLsgXPiU4ie68PDJXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7gym8xNkiRde2L02vPxgBJmM0t5CRgRe326dMhE+kVfKivHB4vjUgoGs9AFvelc1hKMRmI8GdlK3TZO90jrudEm7XtbC0q11F7IUt89VrEwZzzNwyTpuu2OMcSMcyiDzkdI5ymI53IYqF1Xg//X6YipU67hwRZyg6ZwetvDXuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viQmO1Eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viQmO1Eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79FB1F000E9;
	Thu, 20 Aug 2026 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247151;
	bh=A8XkSA7eRb3wh2MBJ+K4Cc4FgiiHc3MalXTd9rRIgOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viQmO1EgHMw3S/tRLd9D0e18+16eWJMxLotLAsk73xnFlc7MX1b6x57jmAFVNttUH
	 1KSegxAkgjtvb5AoXG36uOM7sg/YWSIEUZjpxfPGE7xgRy4wSDOMmXFhdXHKv0km/p
	 nzVB+3BXcBK9Ndf1gzJOoCCRVwEpgtGV7/Ff00ng=
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
Subject: [PATCH 6.12 167/220] can: rcar_canfd: change the initializing flow for clocks and resets
Date: Thu, 20 Aug 2026 16:55:57 +0200
Message-ID: <20260820145228.495400955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
@@ -1989,27 +1989,27 @@ static int rcar_canfd_probe(struct platf
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
@@ -2061,11 +2061,11 @@ fail_channel:
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
@@ -2085,9 +2085,9 @@ static void rcar_canfd_remove(struct pla
 
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
-	clk_disable_unprepare(gpriv->clkp);
 	reset_control_assert(gpriv->rstc1);
 	reset_control_assert(gpriv->rstc2);
+	clk_disable_unprepare(gpriv->clkp);
 }
 
 static int __maybe_unused rcar_canfd_suspend(struct device *dev)


