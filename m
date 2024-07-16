Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880EB19F49F;
	Tue, 16 Jul 2024 15:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145512; cv=none; b=p7pN/aNEnxUC4liPQU0RGXzoMKOSPyQxKYFs2AI9hAMj145MIHrgpUbC9rJ3/HwNPuLdX1z5k34GHq/NpPmCRSlon42jru0WXPHeqZQk1cMns3NUCxgsPZLsK/XPN7UnSnhl6RYUxceEbcmX2+uljz8vN9xvhu6IttjH36D/F7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145512; c=relaxed/simple;
	bh=poXPRwglf4aBtZsb6VjX7J6GGVmHnCW4WD1nbUJCwa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+sfnj0KxZ5uZzATcKFPZmbSx3BXtV2OdN1CA/t+qaDxOc4+jhMEclNWYBNwUhd1ab2Dhb0xeRrEfiyeMMDDNK1/VVNrTod/xjVLCDCmhdgDNDcFE+J7VDs8pF6VE+LDqBsWEewzM0M4IQZ7EJ4TOGYioaEOAtH6wkx/8oo5Mj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEXNiQPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEXNiQPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA511C116B1;
	Tue, 16 Jul 2024 15:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145511;
	bh=poXPRwglf4aBtZsb6VjX7J6GGVmHnCW4WD1nbUJCwa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEXNiQPOmKoVUz46uXEhu1xGw8OUCmmEtqpBwPAsZy/RZFVHBa8J8LMmDt0DpPmD9
	 dTvCKwSx0k2Z6YgWsb9REFUBIboU/tCuL3+4HFcUiTaVSG4kEKKymBisMtlkJWZBe1
	 Z52dlCU654H/ZlKGZmQ4hrStVY7VJ+g2s7n7f3l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 89/96] i2c: rcar: introduce Gen4 devices
Date: Tue, 16 Jul 2024 17:32:40 +0200
Message-ID: <20240716152749.936875879@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f08045a61d62..975bba5e4a344 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -114,6 +114,7 @@ enum rcar_i2c_type {
 	I2C_RCAR_GEN1,
 	I2C_RCAR_GEN2,
 	I2C_RCAR_GEN3,
+	I2C_RCAR_GEN4,
 };
 
 struct rcar_i2c_priv {
@@ -394,8 +395,8 @@ static void rcar_i2c_cleanup_dma(struct rcar_i2c_priv *priv, bool terminate)
 	dma_unmap_single(chan->device->dev, sg_dma_address(&priv->sg),
 			 sg_dma_len(&priv->sg), priv->dma_direction);
 
-	/* Gen3 can only do one RXDMA per transfer and we just completed it */
-	if (priv->devtype == I2C_RCAR_GEN3 &&
+	/* Gen3+ can only do one RXDMA per transfer and we just completed it */
+	if (priv->devtype >= I2C_RCAR_GEN3 &&
 	    priv->dma_direction == DMA_FROM_DEVICE)
 		priv->flags |= ID_P_NO_RXDMA;
 
@@ -849,8 +850,8 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 	if (ret < 0)
 		goto out;
 
-	/* Gen3 needs a reset before allowing RXDMA once */
-	if (priv->devtype == I2C_RCAR_GEN3) {
+	/* Gen3+ needs a reset. That also allows RXDMA once */
+	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->flags &= ~ID_P_NO_RXDMA;
 		ret = rcar_i2c_do_reset(priv);
 		if (ret)
@@ -1035,7 +1036,7 @@ static const struct of_device_id rcar_i2c_dt_ids[] = {
 	{ .compatible = "renesas,rcar-gen1-i2c", .data = (void *)I2C_RCAR_GEN1 },
 	{ .compatible = "renesas,rcar-gen2-i2c", .data = (void *)I2C_RCAR_GEN2 },
 	{ .compatible = "renesas,rcar-gen3-i2c", .data = (void *)I2C_RCAR_GEN3 },
-	{ .compatible = "renesas,rcar-gen4-i2c", .data = (void *)I2C_RCAR_GEN3 },
+	{ .compatible = "renesas,rcar-gen4-i2c", .data = (void *)I2C_RCAR_GEN4 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, rcar_i2c_dt_ids);
@@ -1113,7 +1114,7 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (of_property_read_bool(dev->of_node, "smbus"))
 		priv->flags |= ID_P_HOST_NOTIFY;
 
-	if (priv->devtype == I2C_RCAR_GEN3) {
+	if (priv->devtype >= I2C_RCAR_GEN3) {
 		priv->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
 		if (IS_ERR(priv->rstc))
 			goto out_pm_put;
-- 
2.43.0



