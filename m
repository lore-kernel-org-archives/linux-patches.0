Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E1147F797;
	Thu, 20 Aug 2026 17:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248544; cv=none; b=McOxobw8FG177Oi5XyctWViCOGSNImy9uSdvPOOooxDMdz/CFaF/PMWS/rTC/LYSQtViBeAqm09I5a5yjdokrVPX470XTEN3XAKNBCX/6SPw+WHMKoMgX0vUM7tZ+F4Nnr+k80qGi3KGPNPVV+5x68QSLZBgXgyLnHRgO8BZiIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248544; c=relaxed/simple;
	bh=akBRMd4naMTP17n9ykQl9iQQj5T0YLYyXFMZkUvm548=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrcYEXPxwgXhcyc2/5OkXxh1IEbkRbnrCVrJu+GLyPMqdg2Be03j/xCCxFv7TlhP1+S/EocxTIl9OtvUUhrQcTdhWPpMvY1v1Yi4WqFXQRcrOMZlKu/sSqC9u8Gzo3VW/DeEg2Mohp+9cJWkzKvWRT6mNo3vuwwpBdm5gsvS1rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2zhvY22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2zhvY22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EE61F000E9;
	Thu, 20 Aug 2026 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248543;
	bh=GuoMej7G+WCju1aKAo+vE+rzPgoXFoHbgUhg1X0r5yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2zhvY22t8/U5TYMlnAh13VXvF1iqzfD06Os1bmgMEGDh+IAfH7jqRZoJaoYQLIrR
	 sl2CKYIEasGSKYCKBxVDqCcjNRqSX+ljAEIweFgGLR/7MK3A1gX91FAw5vWZQkiUZA
	 QPlCQYrTrMLUrZemrQkBFMfgeMBTXbmHRoZ4pFwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/303] can: rcar_canfd: Use devm_clk_get_optional() for RAM clk
Date: Thu, 20 Aug 2026 16:56:39 +0200
Message-ID: <20260820145301.352390169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/can/rcar/rcar_canfd.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -542,6 +542,7 @@ struct rcar_canfd_global {
 	struct platform_device *pdev;	/* Respective platform device */
 	struct clk *clkp;		/* Peripheral clock */
 	struct clk *can_clk;		/* fCAN clock */
+	struct clk *clk_ram;		/* Clock RAM */
 	enum rcar_canfd_fcanclk fcan;	/* CANFD or Ext clock */
 	unsigned long channels_mask;	/* Enabled channels mask */
 	bool fdmode;			/* CAN FD or Classical CAN only mode */
@@ -1915,6 +1916,11 @@ static int rcar_canfd_probe(struct platf
 		/* CANFD clock is further divided by (1/2) within the IP */
 		fcan_freq /= 2;
 
+	gpriv->clk_ram = devm_clk_get_optional(&pdev->dev, "ram_clk");
+	if (IS_ERR(gpriv->clk_ram))
+		return dev_err_probe(&pdev->dev, PTR_ERR(gpriv->clk_ram),
+				     "cannot get ram clock\n");
+
 	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
 		err = PTR_ERR(addr);
@@ -1979,10 +1985,18 @@ static int rcar_canfd_probe(struct platf
 		goto fail_reset;
 	}
 
+	/* Enable RAM clock  */
+	err = clk_prepare_enable(gpriv->clk_ram);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable RAM clock: %pe\n",
+			ERR_PTR(err));
+		goto fail_clk;
+	}
+
 	err = rcar_canfd_reset_controller(gpriv);
 	if (err) {
 		dev_err(&pdev->dev, "reset controller failed\n");
-		goto fail_clk;
+		goto fail_ram_clk;
 	}
 
 	/* Controller in Global reset & Channel reset mode */
@@ -2032,6 +2046,8 @@ fail_channel:
 		rcar_canfd_channel_remove(gpriv, ch);
 fail_mode:
 	rcar_canfd_disable_global_interrupts(gpriv);
+fail_ram_clk:
+	clk_disable_unprepare(gpriv->clk_ram);
 fail_clk:
 	clk_disable_unprepare(gpriv->clkp);
 fail_reset:
@@ -2056,6 +2072,7 @@ static int rcar_canfd_remove(struct plat
 
 	/* Enter global sleep mode */
 	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
+	clk_disable_unprepare(gpriv->clk_ram);
 	clk_disable_unprepare(gpriv->clkp);
 	reset_control_assert(gpriv->rstc2);
 	reset_control_assert(gpriv->rstc1);


