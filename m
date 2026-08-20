Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27926367B6D;
	Thu, 20 Aug 2026 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239114; cv=none; b=OiIbl6PVoGOTUmBuYPZCSEJsewI2ySJTnVB1wuGjbHgt5iu1f1ulWuOdRl8n+uKK5bUKHPTAWOcL0uqpr2Y6akcqI9hVE/VlF3OTWTyrtWc9jQC34j6gX2GHfG/d7S48nFgFUjgwY+KtGY9qL+H1QJ9nx8qpbNI6rUP+MN9eJZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239114; c=relaxed/simple;
	bh=xmaoBxEPD4ajgRcERmJWmt1QvuT2J1TLf+huvqXX4vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDQ2S5UFs5OPipSH+ninX9nlF+tb2/QFh4+lwR6zW58Zv7mZoMGjo5LHv4HQ5SetLaa3aSrnghws1JeDaXigo8UpOFrklsXsHFT0HNdhICL0jmEIOeyf/rE+ING/hTR0GKEi0pjGPZg7XmpT3SDayEB1mkKg0OK0Qyn2LJjxFn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySEJFcBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySEJFcBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B741F000E9;
	Thu, 20 Aug 2026 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239112;
	bh=MXHv0R3xZNieom8+X64a2+J5V+/G5wAkbw1twkW1o+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ySEJFcBp/HMS8LWHPv25siBzTiFxxp89S5iv7ffSxnClglxPDfXWM2GRlLaH1C9eD
	 UcDOP50WpK8/ulcrn7LNvfl0hqg2Bwsz322DYhMHO5FV/MbbGJSQm/jpHJX4smj98M
	 6bmwQtH1oMK2lt3cads0viK0JgtrgLlMpOu98AJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/217] can: rcar_canfd: Use devm_clk_get_optional() for RAM clk
Date: Thu, 20 Aug 2026 16:55:21 +0200
Message-ID: <20260820145242.358911519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit eda3d6c8d784835cec86f42b3f8118c9eb0cc58c ]

Replace devm_clk_get_optional_enabled()->devm_clk_get_optional() as the
RAM clk needs to be enabled in resume for proper operation in STR mode
for RZ/G3E SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251124102837.106973-4-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: bef9004c5b91 ("can: rcar_canfd: change the initializing flow for clocks and resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -468,6 +468,7 @@ struct rcar_canfd_global {
 	struct platform_device *pdev;	/* Respective platform device */
 	struct clk *clkp;		/* Peripheral clock */
 	struct clk *can_clk;		/* fCAN clock */
+	struct clk *clk_ram;		/* Clock RAM */
 	unsigned long channels_mask;	/* Enabled channels mask */
 	bool extclk;			/* CANFD or Ext clock */
 	bool fdmode;			/* CAN FD or Classical CAN only mode */
@@ -1985,7 +1986,6 @@ static int rcar_canfd_probe(struct platf
 	u32 rule_entry = 0;
 	bool fdmode = true;			/* CAN FD only mode - default */
 	char name[9] = "channelX";
-	struct clk *clk_ram;
 	int i;
 
 	info = of_device_get_match_data(dev);
@@ -2075,10 +2075,10 @@ static int rcar_canfd_probe(struct platf
 		gpriv->extclk = gpriv->info->external_clk;
 	}
 
-	clk_ram = devm_clk_get_optional_enabled(dev, "ram_clk");
-	if (IS_ERR(clk_ram))
-		return dev_err_probe(dev, PTR_ERR(clk_ram),
-				     "cannot get enabled ram clock\n");
+	gpriv->clk_ram = devm_clk_get_optional(dev, "ram_clk");
+	if (IS_ERR(gpriv->clk_ram))
+		return dev_err_probe(dev, PTR_ERR(gpriv->clk_ram),
+				     "cannot get ram clock\n");
 
 	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
@@ -2144,10 +2144,18 @@ static int rcar_canfd_probe(struct platf
 		goto fail_reset;
 	}
 
+	/* Enable RAM clock  */
+	err = clk_prepare_enable(gpriv->clk_ram);
+	if (err) {
+		dev_err(dev, "failed to enable RAM clock: %pe\n",
+			ERR_PTR(err));
+		goto fail_clk;
+	}
+
 	err = rcar_canfd_reset_controller(gpriv);
 	if (err) {
 		dev_err(dev, "reset controller failed: %pe\n", ERR_PTR(err));
-		goto fail_clk;
+		goto fail_ram_clk;
 	}
 
 	/* Controller in Global reset & Channel reset mode */
@@ -2199,6 +2207,8 @@ fail_channel:
 		rcar_canfd_channel_remove(gpriv, ch);
 fail_mode:
 	rcar_canfd_disable_global_interrupts(gpriv);
+fail_ram_clk:
+	clk_disable_unprepare(gpriv->clk_ram);
 fail_clk:
 	clk_disable_unprepare(gpriv->clkp);
 fail_reset:
@@ -2223,6 +2233,7 @@ static void rcar_canfd_remove(struct pla
 
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
+	clk_disable_unprepare(gpriv->clk_ram);
 	clk_disable_unprepare(gpriv->clkp);
 	reset_control_assert(gpriv->rstc2);
 	reset_control_assert(gpriv->rstc1);


