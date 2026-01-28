Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451D728B4FD;
	Wed, 28 Jan 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614493; cv=none; b=YrcoVHDFsvLNyUuWZwKauac3sW/GqjwIFQMPRHYbjhoKmAPuWT9TaFoKYbZXU4iw+xbVGhvAP9NGFxkfavfD0zXphXi/1dn74qoyOFKcs+7MbCh5RjBlVOlGwi4RQf8c56VEQbKGUO2OdXfnq/tagkI6ZQ7ob20/LgevbrC+53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614493; c=relaxed/simple;
	bh=alTXFjzJWEBhzJrHFQ7HSoT1ppmfxlq1t4pGnsvB1N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOHomuBwSMo8fpvPGdS+OmLPGGqlpVGgs1bGG70Zr4ZgZ6rWGPBD5J5Ss1Os8IOsHymAV3MeedGN7Q4CVTOFINF48R6lEd+TwxOyZ9VWtkZblNoylz1YuOokWGgINCdnjUshbMv6rrT0COCSI2yjYnWrLByrxNzkWxdrbxW+xz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLtq6msH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLtq6msH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE42C4CEF1;
	Wed, 28 Jan 2026 15:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614492;
	bh=alTXFjzJWEBhzJrHFQ7HSoT1ppmfxlq1t4pGnsvB1N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLtq6msHYXEEmC9375Bo2LWKUIAplUeRVr0FCayWVMnRY2boaz4BMgNjpeVPUva5O
	 7bvIhkCVyM2ekSxVGLr6macDXl3Y51/ZaO5+2q/Q2n3Fw52Fwj5yKbSaBJe5KIRxZJ
	 2HtFFxbu65uxT2Qf30U1HZHGswqVectumjuoVJhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/254] spi: sprd: adi: Use devm_register_restart_handler()
Date: Wed, 28 Jan 2026 16:22:10 +0100
Message-ID: <20260128145350.353155053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Andrew Davis <afd@ti.com>

[ Upstream commit 8e6a43961f24cf841d3c0d199521d0b284d948b9 ]

Use device life-cycle managed register function to simplify probe error
path and eliminate need for explicit remove function.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20231117161006.87734-5-afd@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 383d4f5cffcc ("spi: spi-sprd-adi: Fix double free in probe error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index bf01feedbf93f..58c3badd9c79a 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -138,8 +138,7 @@ struct sprd_adi_data {
 	u32 slave_offset;
 	u32 slave_addr_size;
 	int (*read_check)(u32 val, u32 reg);
-	int (*restart)(struct notifier_block *this,
-		       unsigned long mode, void *cmd);
+	int (*restart)(struct sys_off_data *data);
 	void (*wdg_rst)(void *p);
 };
 
@@ -150,7 +149,6 @@ struct sprd_adi {
 	struct hwspinlock	*hwlock;
 	unsigned long		slave_vbase;
 	unsigned long		slave_pbase;
-	struct notifier_block	restart_handler;
 	const struct sprd_adi_data *data;
 };
 
@@ -370,11 +368,9 @@ static void sprd_adi_set_wdt_rst_mode(void *p)
 #endif
 }
 
-static int sprd_adi_restart(struct notifier_block *this, unsigned long mode,
-				  void *cmd, struct sprd_adi_wdg *wdg)
+static int sprd_adi_restart(struct sprd_adi *sadi, unsigned long mode,
+			    const char *cmd, struct sprd_adi_wdg *wdg)
 {
-	struct sprd_adi *sadi = container_of(this, struct sprd_adi,
-					     restart_handler);
 	u32 val, reboot_mode = 0;
 
 	if (!cmd)
@@ -448,8 +444,7 @@ static int sprd_adi_restart(struct notifier_block *this, unsigned long mode,
 	return NOTIFY_DONE;
 }
 
-static int sprd_adi_restart_sc9860(struct notifier_block *this,
-					   unsigned long mode, void *cmd)
+static int sprd_adi_restart_sc9860(struct sys_off_data *data)
 {
 	struct sprd_adi_wdg wdg = {
 		.base = PMIC_WDG_BASE,
@@ -458,7 +453,7 @@ static int sprd_adi_restart_sc9860(struct notifier_block *this,
 		.wdg_clk = PMIC_CLK_EN,
 	};
 
-	return sprd_adi_restart(this, mode, cmd, &wdg);
+	return sprd_adi_restart(data->cb_data, data->mode, data->cmd, &wdg);
 }
 
 static void sprd_adi_hw_init(struct sprd_adi *sadi)
@@ -590,9 +585,9 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	}
 
 	if (sadi->data->restart) {
-		sadi->restart_handler.notifier_call = sadi->data->restart;
-		sadi->restart_handler.priority = 128;
-		ret = register_restart_handler(&sadi->restart_handler);
+		ret = devm_register_restart_handler(&pdev->dev,
+						    sadi->data->restart,
+						    sadi);
 		if (ret) {
 			dev_err(&pdev->dev, "can not register restart handler\n");
 			goto put_ctlr;
@@ -606,14 +601,6 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static void sprd_adi_remove(struct platform_device *pdev)
-{
-	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
-	struct sprd_adi *sadi = spi_controller_get_devdata(ctlr);
-
-	unregister_restart_handler(&sadi->restart_handler);
-}
-
 static struct sprd_adi_data sc9860_data = {
 	.slave_offset = ADI_10BIT_SLAVE_OFFSET,
 	.slave_addr_size = ADI_10BIT_SLAVE_ADDR_SIZE,
@@ -657,7 +644,6 @@ static struct platform_driver sprd_adi_driver = {
 		.of_match_table = sprd_adi_of_match,
 	},
 	.probe = sprd_adi_probe,
-	.remove_new = sprd_adi_remove,
 };
 module_platform_driver(sprd_adi_driver);
 
-- 
2.51.0



