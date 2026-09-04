Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467773815E1;
	Fri,  4 Sep 2026 05:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500173; cv=none; b=SNExoprSEoU2NAAqfx/M2brpw5QDmHFlAWruLBgWSD06pOEo4T5EUVTrozgbZK47b0p4jw6rmnxdx+hiQd2tesEokiTYALwe7qTCWS2nnkD/dL0ykULyv9iIzQLVZqH5OFr2Ve4RysNtLeyt8Y0eADK2DKyv2YpXMd741B3c20c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500173; c=relaxed/simple;
	bh=5RhOZkTRr7zVI0hlO4bOnpaGs7Dia0jcJ/VpQOVU0gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUj3HPT/DUxKG7GszTIe3RUA51j3+92CZAkGj71mOSYvS4De/xGPLNCsz3hATcMzsvKeEeS6uKNyR6rK/6xM5h8Ofx37ddTnvkIZDpdMJfLCPPI3Txs7dmKAklJqWMN/90D9/IjQiGdRo1xfH2fDHf3S18E7iNPBx5cHKpA71C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuVnd5GD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuVnd5GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C971F00A3D;
	Fri,  4 Sep 2026 05:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500171;
	bh=+4RyLJLwt0N/0Nl8lTFt+iVZg0O3F912/gU3JBFekms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuVnd5GDCrbj4pJFZatei1KK6tiX1/mQGTRaiFNx0TkpzZRmRL+xWkL0RXx0f0RLe
	 UfpPCajMvFjkumbvXEVxPkP23DXRbekH8jNzpWLWkTTWTeRDUj1LCwBn10eQdf10Yj
	 Ln/XDX+tXHOyKN+ZA287ZsbT8OXoq+Uxp2svJEJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 674/713] i3c: renesas: Perform Dynamic Address Assignment on resume
Date: Fri,  4 Sep 2026 07:00:42 +0200
Message-ID: <20260904045818.941832874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit fbf26154c47953d08c60fb402ab19c5c56c3779f upstream.

The Renesas RZ/G3S SoC supports a power saving mode where power to most
SoC components, including I3C, is turned off.

On systems where the I3C devices also loses power during suspend (e.g. NXP
P3T1085UK-ARD connected to the PMOD1_6A connector of the RZ SMARC Carrier
2 + Renesas RZ/G3S SMARC SOM), the devices becomes unreachable after
resume.

Running DAA in the controller resume path restores communication. However,
DAA relies on interrupts for TX/RX, which are not available in the noirq
suspend/resume phase (unless they are wakeup interrupts). For this, the
suspend/resume callbacks were moved out of the noirq phase. Currently,
there is no identified use case on either the Renesas RZ/G3S or Renesas
RZ/G3E SoCs that requires the controller suspend/resume hooks to be part of
the noirq suspend/resume phase.

Since renesas_i3c_reset() is not called anymore in atomic context
update it to use read_poll_timeout().

Along with this, struct renesas_i3c::DATBASn and its usage were removed,
as they are no longer needed.

Fixes: e7218986319b ("i3c: renesas: Add suspend/resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-7-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -265,7 +265,6 @@ struct renesas_i3c {
 	u8 addrs[RENESAS_I3C_MAX_DEVS];
 	struct renesas_i3c_xferqueue xferqueue;
 	void __iomem *regs;
-	u32 *DATBASn;
 	struct clk_bulk_data *clks;
 	struct reset_control *presetn;
 	struct reset_control *tresetn;
@@ -495,8 +494,8 @@ static int renesas_i3c_reset(struct rene
 	renesas_writel(i3c->regs, BCTL, 0);
 	renesas_set_bit(i3c->regs, RSTCTL, RSTCTL_RI3CRST);
 
-	return read_poll_timeout_atomic(renesas_readl, val, !(val & RSTCTL_RI3CRST),
-					0, 1000, false, i3c->regs, RSTCTL);
+	return read_poll_timeout(renesas_readl, val, !(val & RSTCTL_RI3CRST),
+				 0, 1000, false, i3c->regs, RSTCTL);
 }
 
 static void renesas_i3c_hw_init(struct renesas_i3c *i3c)
@@ -1425,12 +1424,6 @@ static int renesas_i3c_probe(struct plat
 	i3c->maxdevs = RENESAS_I3C_MAX_DEVS;
 	i3c->free_pos = GENMASK(i3c->maxdevs - 1, 0);
 
-	/* Allocate dynamic Device Address Table backup. */
-	i3c->DATBASn = devm_kzalloc(&pdev->dev, sizeof(u32) * i3c->maxdevs,
-				    GFP_KERNEL);
-	if (!i3c->DATBASn)
-		return -ENOMEM;
-
 	return i3c_master_register(&i3c->base, &pdev->dev, &renesas_i3c_ops, false);
 }
 
@@ -1441,17 +1434,13 @@ static void renesas_i3c_remove(struct pl
 	i3c_master_unregister(&i3c->base);
 }
 
-static int renesas_i3c_suspend_noirq(struct device *dev)
+static int renesas_i3c_suspend(struct device *dev)
 {
 	struct renesas_i3c *i3c = dev_get_drvdata(dev);
-	int i, ret;
+	int ret;
 
 	i2c_mark_adapter_suspended(&i3c->base.i2c);
 
-	/* Store Device Address Table values. */
-	for (i = 0; i < i3c->maxdevs; i++)
-		i3c->DATBASn[i] = renesas_readl(i3c->regs, DATBAS(i));
-
 	ret = reset_control_assert(i3c->presetn);
 	if (ret)
 		goto err_mark_resumed;
@@ -1472,10 +1461,10 @@ err_mark_resumed:
 	return ret;
 }
 
-static int renesas_i3c_resume_noirq(struct device *dev)
+static int renesas_i3c_resume(struct device *dev)
 {
 	struct renesas_i3c *i3c = dev_get_drvdata(dev);
-	int i, ret;
+	int ret;
 
 	ret = reset_control_deassert(i3c->tresetn);
 	if (ret)
@@ -1501,15 +1490,19 @@ static int renesas_i3c_resume_noirq(stru
 	renesas_writel(i3c->regs, MSDVAD, MSDVAD_MDYADV |
 		       MSDVAD_MDYAD(i3c->dyn_addr));
 
-	/* Restore Device Address Table values. */
-	for (i = 0; i < i3c->maxdevs; i++)
-		renesas_writel(i3c->regs, DATBAS(i), i3c->DATBASn[i]);
-
 	/* I3C hw init. */
 	renesas_i3c_hw_init(i3c);
 
+	ret = i3c_master_do_daa_ext(&i3c->base, true);
+	if (ret)
+		dev_err(dev, "DAA failed on resume, ret=%d", ret);
+
 	i2c_mark_adapter_resumed(&i3c->base.i2c);
 
+	/*
+	 * I3C devices may have retained their dynamic address anyway. Do not
+	 * fail the resume because of DAA error.
+	 */
 	return 0;
 
 err_clks_disable:
@@ -1522,8 +1515,7 @@ err_tresetn:
 }
 
 static const struct dev_pm_ops renesas_i3c_pm_ops = {
-	NOIRQ_SYSTEM_SLEEP_PM_OPS(renesas_i3c_suspend_noirq,
-				  renesas_i3c_resume_noirq)
+	SYSTEM_SLEEP_PM_OPS(renesas_i3c_suspend, renesas_i3c_resume)
 };
 
 static const struct of_device_id renesas_i3c_of_ids[] = {


