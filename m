Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E9419B59C;
	Tue, 16 Jul 2024 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146346; cv=none; b=Z9V/AAIEA+auX96WXauO3zEqQzf6iXv50TSkGgC0OEKEBiNgXc1GJosEsiGPrFuM62T6cNeFkTco/VhwwUhbIvoAH4XGjp06c7sH7byswB4AcpheOLq81yM/SUgFCGUEX56xHCskUsyJGmsEYeRyVBBLb09ISxFK3vt2BmIX6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146346; c=relaxed/simple;
	bh=A6BUUnL/9mUAbyNolZmfreSAqipkJUiKe3j2M/wc6HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KScjZOMaHYg8HEWtYFLOHGP/8jd4lYRJ3sPnm28WNMp1qsxVHRZ2TaRXpbW300ZVaEwUh7/Y9C+JFfE+CBscydaUUzGqPpSRUPnFSlap6uFKnvtrD0PSQtm5aWo2bwLIedbrMSEHqGgbdT3VBZrTDFrwhU/Np6Qu/WYicCiAxrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPUZbqW1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPUZbqW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA647C116B1;
	Tue, 16 Jul 2024 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146346;
	bh=A6BUUnL/9mUAbyNolZmfreSAqipkJUiKe3j2M/wc6HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPUZbqW14q4wJzkDM1z+xPZwpOgNDA6YnErBt2EIHLrPlkyxA28VW/DgfxcGx9j5J
	 XEfPZaSnBT9NwRTQIx4tNPxlB55Yi0o960z/mi70WzqlhUrb1q9rDYcx9J7d2eo+4L
	 m/rE9BFprMokj9fHwBkowyxtCT6lH/8peT5wu9r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/144] i2c: rcar: introduce Gen4 devices
Date: Tue, 16 Jul 2024 17:33:26 +0200
Message-ID: <20240716152757.779545832@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 2b523c46e81ebd621515ab47117f95de197dfcbf ]

So far, we treated Gen4 as Gen3. But we are soon adding FM+ as a Gen4
specific feature, so prepare the code for the new devtype.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: ea5ea84c9d35 ("i2c: rcar: ensure Gen3+ reset does not disturb local targets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rcar.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 5fd45a2402bc3..1efc0230c2cba 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -116,6 +116,7 @@ enum rcar_i2c_type {
 	I2C_RCAR_GEN1,
 	I2C_RCAR_GEN2,
 	I2C_RCAR_GEN3,
+	I2C_RCAR_GEN4,
 };
 
 struct rcar_i2c_priv {
@@ -383,8 +384,8 @@ static void rcar_i2c_dma_unmap(struct rcar_i2c_priv *priv)
 	dma_unmap_single(chan->device->dev, sg_dma_address(&priv->sg),
 			 sg_dma_len(&priv->sg), priv->dma_direction);
 
-	/* Gen3 can only do one RXDMA per transfer and we just completed it */
-	if (priv->devtype == I2C_RCAR_GEN3 &&
+	/* Gen3+ can only do one RXDMA per transfer and we just completed it */
+	if (priv->devtype >= I2C_RCAR_GEN3 &&
 	    priv->dma_direction == DMA_FROM_DEVICE)
 		priv->flags |= ID_P_NO_RXDMA;
 
@@ -828,8 +829,8 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 	if (ret < 0)
 		goto out;
 
-	/* Gen3 needs a reset before allowing RXDMA once */
-	if (priv->devtype == I2C_RCAR_GEN3) {
+	/* Gen3+ needs a reset. That also allows RXDMA once */
+	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->flags &= ~ID_P_NO_RXDMA;
 		ret = rcar_i2c_do_reset(priv);
 		if (ret)
@@ -1019,7 +1020,7 @@ static const struct of_device_id rcar_i2c_dt_ids[] = {
 	{ .compatible = "renesas,rcar-gen1-i2c", .data = (void *)I2C_RCAR_GEN1 },
 	{ .compatible = "renesas,rcar-gen2-i2c", .data = (void *)I2C_RCAR_GEN2 },
 	{ .compatible = "renesas,rcar-gen3-i2c", .data = (void *)I2C_RCAR_GEN3 },
-	{ .compatible = "renesas,rcar-gen4-i2c", .data = (void *)I2C_RCAR_GEN3 },
+	{ .compatible = "renesas,rcar-gen4-i2c", .data = (void *)I2C_RCAR_GEN4 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, rcar_i2c_dt_ids);
@@ -1097,7 +1098,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (of_property_read_bool(dev->of_node, "smbus"))
 		priv->flags |= ID_P_HOST_NOTIFY;
 
-	if (priv->devtype == I2C_RCAR_GEN3) {
+	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 		if (IS_ERR(priv->rstc))
 			goto out_pm_put;
-- 
2.43.0



