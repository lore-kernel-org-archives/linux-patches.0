Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A9B48423E;
	Thu, 20 Aug 2026 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248547; cv=none; b=Ckxi5xJnrRznkeosQanUKo3PWk+mq3DQrRXBW+W4/jXvFSFW5Mp+MbCw3JsuPY5l4/eq8nK+kKG34kUZJ9/rdQ25WNv0tcIVbMTac56iAsVVn0Do3hqloyCF4NmH2Tox2033RJoRuvagabQt2h0Se4Vn01ZT5RyTTNsplXdfDRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248547; c=relaxed/simple;
	bh=1Gb8zSSkwjCJcCXJGnIa97uSLB6e+DePdPabzbVdFPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGm2978d5m3+lOT11piaQWQ3ufesC7szaKPaXMTyMAFTEgBCyKN3L13CB1F1oOIv9/Oz9+v8MkDKKC1m4PbyVlAs04O4/fmE5TybPaJnJMHwpKJI2mlXm0asQIvLw8xVu7TJ1jgF15aGe2opqBQqxEeTU68w8SO0RuG4G1QHS+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8s7wJUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8s7wJUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39E51F00A3A;
	Thu, 20 Aug 2026 17:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248546;
	bh=TeNyhYq0WcQI0LOLbkDVd/vzwjPXXZcDojxs9j2aPT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8s7wJUZS6FgdRj7HFqUWNiXOFnzXSehvWBmYYZ3U+wn9ycchY7tYqGP8vRhxI4Xt
	 jyRsq2YkWDE74rtC/dwI4HaAHYATXbHlCntPqujhmeG9LUQylhfVBQD6qqab0cK+OQ
	 dKOw2/2/dMQ4QnU6/BZS4f53XhXrjm1e1G3E0MLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 264/303] can: rcar_canfd: Extract rcar_canfd_global_{,de}init()
Date: Thu, 20 Aug 2026 16:56:40 +0200
Message-ID: <20260820145301.384883872@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit fa5f4ec8fff8bc587a2cbf7101303306e045c11f ]

Extract the code to (de)initialize global state into separate functions,
for future reuse.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20251124102837.106973-5-biju.das.jz@bp.renesas.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: bef9004c5b91 ("can: rcar_canfd: change the initializing flow for clocks and resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/rcar/rcar_canfd.c |  182 +++++++++++++++++++++-----------------
 1 file changed, 104 insertions(+), 78 deletions(-)

--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1810,20 +1810,119 @@ static void rcar_canfd_channel_remove(st
 	}
 }
 
+static int rcar_canfd_global_init(struct rcar_canfd_global *gpriv)
+{
+	struct device *dev = &gpriv->pdev->dev;
+	u32 rule_entry = 0;
+	u32 ch, sts;
+	int err;
+
+	err = reset_control_reset(gpriv->rstc1);
+	if (err)
+		return err;
+
+	err = reset_control_reset(gpriv->rstc2);
+	if (err)
+		goto fail_reset1;
+
+	/* Enable peripheral clock for register access */
+	err = clk_prepare_enable(gpriv->clkp);
+	if (err) {
+		dev_err(dev, "failed to enable peripheral clock: %pe\n",
+			ERR_PTR(err));
+		goto fail_reset2;
+	}
+
+	/* Enable RAM clock */
+	err = clk_prepare_enable(gpriv->clk_ram);
+	if (err) {
+		dev_err(dev,
+			"failed to enable RAM clock, error %d\n", err);
+		goto fail_clk;
+	}
+
+	err = rcar_canfd_reset_controller(gpriv);
+	if (err) {
+		dev_err(dev, "reset controller failed: %pe\n", ERR_PTR(err));
+		goto fail_ram_clk;
+	}
+
+	/* Controller in Global reset & Channel reset mode */
+	rcar_canfd_configure_controller(gpriv);
+
+	/* Configure per channel attributes */
+	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
+		/* Configure Channel's Rx fifo */
+		rcar_canfd_configure_rx(gpriv, ch);
+
+		/* Configure Channel's Tx (Common) fifo */
+		rcar_canfd_configure_tx(gpriv, ch);
+
+		/* Configure receive rules */
+		rcar_canfd_configure_afl_rules(gpriv, ch, rule_entry);
+		rule_entry += RCANFD_CHANNEL_NUMRULES;
+	}
+
+	/* Configure common interrupts */
+	rcar_canfd_enable_global_interrupts(gpriv);
+
+	/* Start Global operation mode */
+	rcar_canfd_update_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GMDC_MASK,
+			      RCANFD_GCTR_GMDC_GOPM);
+
+	/* Verify mode change */
+	err = readl_poll_timeout((gpriv->base + RCANFD_GSTS), sts,
+				 !(sts & RCANFD_GSTS_GNOPM), 2, 500000);
+	if (err) {
+		dev_err(dev, "global operational mode failed\n");
+		goto fail_mode;
+	}
+
+	return 0;
+
+fail_mode:
+	rcar_canfd_disable_global_interrupts(gpriv);
+fail_ram_clk:
+	clk_disable_unprepare(gpriv->clk_ram);
+fail_clk:
+	clk_disable_unprepare(gpriv->clkp);
+fail_reset2:
+	reset_control_assert(gpriv->rstc2);
+fail_reset1:
+	reset_control_assert(gpriv->rstc1);
+	return err;
+}
+
+static void rcar_canfd_global_deinit(struct rcar_canfd_global *gpriv, bool full)
+{
+	rcar_canfd_disable_global_interrupts(gpriv);
+
+	if (full) {
+		rcar_canfd_reset_controller(gpriv);
+
+		/* Enter global sleep mode */
+		rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
+	}
+
+	clk_disable_unprepare(gpriv->clk_ram);
+	clk_disable_unprepare(gpriv->clkp);
+	reset_control_assert(gpriv->rstc2);
+	reset_control_assert(gpriv->rstc1);
+}
+
 static int rcar_canfd_probe(struct platform_device *pdev)
 {
 	void __iomem *addr;
-	u32 sts, ch, fcan_freq;
 	struct rcar_canfd_global *gpriv;
 	struct device_node *of_child;
 	unsigned long channels_mask = 0;
 	int err, ch_irq, g_irq;
 	int g_err_irq, g_recc_irq;
-	u32 rule_entry = 0;
 	bool fdmode = true;			/* CAN FD only mode - default */
 	enum rcanfd_chip_id chip_id;
 	int max_channels;
 	char name[9] = "channelX";
+	u32 ch, fcan_freq;
 	int i;
 
 	chip_id = (uintptr_t)of_device_get_match_data(&pdev->dev);
@@ -1968,67 +2067,9 @@ static int rcar_canfd_probe(struct platf
 		}
 	}
 
-	err = reset_control_reset(gpriv->rstc1);
+	err = rcar_canfd_global_init(gpriv);
 	if (err)
-		goto fail_dev;
-	err = reset_control_reset(gpriv->rstc2);
-	if (err) {
-		reset_control_assert(gpriv->rstc1);
-		goto fail_dev;
-	}
-
-	/* Enable peripheral clock for register access */
-	err = clk_prepare_enable(gpriv->clkp);
-	if (err) {
-		dev_err(&pdev->dev,
-			"failed to enable peripheral clock, error %d\n", err);
-		goto fail_reset;
-	}
-
-	/* Enable RAM clock  */
-	err = clk_prepare_enable(gpriv->clk_ram);
-	if (err) {
-		dev_err(&pdev->dev, "failed to enable RAM clock: %pe\n",
-			ERR_PTR(err));
-		goto fail_clk;
-	}
-
-	err = rcar_canfd_reset_controller(gpriv);
-	if (err) {
-		dev_err(&pdev->dev, "reset controller failed\n");
-		goto fail_ram_clk;
-	}
-
-	/* Controller in Global reset & Channel reset mode */
-	rcar_canfd_configure_controller(gpriv);
-
-	/* Configure per channel attributes */
-	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
-		/* Configure Channel's Rx fifo */
-		rcar_canfd_configure_rx(gpriv, ch);
-
-		/* Configure Channel's Tx (Common) fifo */
-		rcar_canfd_configure_tx(gpriv, ch);
-
-		/* Configure receive rules */
-		rcar_canfd_configure_afl_rules(gpriv, ch, rule_entry);
-		rule_entry += RCANFD_CHANNEL_NUMRULES;
-	}
-
-	/* Configure common interrupts */
-	rcar_canfd_enable_global_interrupts(gpriv);
-
-	/* Start Global operation mode */
-	rcar_canfd_update_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GMDC_MASK,
-			      RCANFD_GCTR_GMDC_GOPM);
-
-	/* Verify mode change */
-	err = readl_poll_timeout((gpriv->base + RCANFD_GSTS), sts,
-				 !(sts & RCANFD_GSTS_GNOPM), 2, 500000);
-	if (err) {
-		dev_err(&pdev->dev, "global operational mode failed\n");
 		goto fail_mode;
-	}
 
 	for_each_set_bit(ch, &gpriv->channels_mask, max_channels) {
 		err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq);
@@ -2045,14 +2086,7 @@ fail_channel:
 	for_each_set_bit(ch, &gpriv->channels_mask, max_channels)
 		rcar_canfd_channel_remove(gpriv, ch);
 fail_mode:
-	rcar_canfd_disable_global_interrupts(gpriv);
-fail_ram_clk:
-	clk_disable_unprepare(gpriv->clk_ram);
-fail_clk:
-	clk_disable_unprepare(gpriv->clkp);
-fail_reset:
-	reset_control_assert(gpriv->rstc2);
-	reset_control_assert(gpriv->rstc1);
+	rcar_canfd_global_deinit(gpriv, false);
 fail_dev:
 	return err;
 }
@@ -2062,20 +2096,12 @@ static int rcar_canfd_remove(struct plat
 	struct rcar_canfd_global *gpriv = platform_get_drvdata(pdev);
 	u32 ch;
 
-	rcar_canfd_reset_controller(gpriv);
-	rcar_canfd_disable_global_interrupts(gpriv);
-
 	for_each_set_bit(ch, &gpriv->channels_mask, gpriv->max_channels) {
 		rcar_canfd_disable_channel_interrupts(gpriv->ch[ch]);
 		rcar_canfd_channel_remove(gpriv, ch);
 	}
 
-	/* Enter global sleep mode */
-	rcar_canfd_set_bit(gpriv->base, RCANFD_GCTR, RCANFD_GCTR_GSLPR);
-	clk_disable_unprepare(gpriv->clk_ram);
-	clk_disable_unprepare(gpriv->clkp);
-	reset_control_assert(gpriv->rstc2);
-	reset_control_assert(gpriv->rstc1);
+	rcar_canfd_global_deinit(gpriv, true);
 
 	return 0;
 }


