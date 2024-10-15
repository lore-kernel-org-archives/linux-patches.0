Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6D91E6339;
	Tue, 15 Oct 2024 11:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992344; cv=none; b=D0eP+F7IFK230ekiIIMNrLwPWKM9NTKuIrATxSTQeiiKKp0T35bmPQccdTZ9Y1HG/REkuWRwXwzN21eJZnPxgo6AZBIntn3Nh+yGVgzkf5evpe+ZeuJRdVJFRrPtZRLpWD2/cxOKFbRdc19BqgMjtKb9/8Mlp5AlnqVc/S8MSG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992344; c=relaxed/simple;
	bh=E5ck5mf3KnSXgkDsY+FCPlEYB3BZirtR87alUS+ErAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqVohrN4wXXpkbHWgK8Xzp/Yh/xBvp8JMtAS2xeyIXQ8I+m8yoztyWtjQa5pKu4aRrJIaaZDjNeZW0/Qs5O+tZ5HXHoz1dNjrTbxQ71u3VvHKiV+Axm7ygUfLlhzT3BJgdurMTbPcqO1eLya1dSJ11qQD3VDffOzGpvT6aFYmNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVRShoXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVRShoXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF365C4CEC6;
	Tue, 15 Oct 2024 11:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992344;
	bh=E5ck5mf3KnSXgkDsY+FCPlEYB3BZirtR87alUS+ErAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVRShoXYxDMZKs7WidesGcMoDBBJE4W0ISdHeC5lnbu3oAIV7HAGPvYuRAdRFvp6q
	 M01MQohTKwxXxRdQmi7jpcdJJSHdGStOMscVkfm1GnV/OX4r6+0KeS8CZlNHAHaa0o
	 MEQ0aSjZoQPnin8wpZZgnSggpFzjhde9HDX/u+DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	Borislav Petkov <bp@suse.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/691] EDAC/synopsys: Add support for version 3 of the Synopsys EDAC DDR
Date: Tue, 15 Oct 2024 13:20:38 +0200
Message-ID: <20241015112443.936816044@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit f7824ded41491d7ebc156a3a2f6fa05cd89da7c2 ]

Add support for version 3.80a of the Synopsys DDR controller. This
version of the controller has the following differences:

- UE/CE are auto cleared
- Interrupts are supported by default

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lkml.kernel.org/r/20211012190709.1504152-2-dinguyen@kernel.org
Stable-dep-of: 35e6dbfe1846 ("EDAC/synopsys: Fix error injection on Zynq UltraScale+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/synopsys_edac.c | 49 ++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 8557781bb8dce..40b1abeca8562 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -101,6 +101,7 @@
 /* DDR ECC Quirks */
 #define DDR_ECC_INTR_SUPPORT		BIT(0)
 #define DDR_ECC_DATA_POISON_SUPPORT	BIT(1)
+#define DDR_ECC_INTR_SELF_CLEAR		BIT(2)
 
 /* ZynqMP Enhanced DDR memory controller registers that are relevant to ECC */
 /* ECC Configuration Registers */
@@ -176,6 +177,10 @@
 #define DDR_QOS_IRQ_EN_OFST		0x20208
 #define DDR_QOS_IRQ_DB_OFST		0x2020C
 
+/* DDR QOS Interrupt register definitions */
+#define DDR_UE_MASK			BIT(9)
+#define DDR_CE_MASK			BIT(8)
+
 /* ECC Corrected Error Register Mask and Shifts*/
 #define ECC_CEADDR0_RW_MASK		0x3FFFF
 #define ECC_CEADDR0_RNK_MASK		BIT(24)
@@ -539,10 +544,16 @@ static irqreturn_t intr_handler(int irq, void *dev_id)
 	priv = mci->pvt_info;
 	p_data = priv->p_data;
 
-	regval = readl(priv->baseaddr + DDR_QOS_IRQ_STAT_OFST);
-	regval &= (DDR_QOSCE_MASK | DDR_QOSUE_MASK);
-	if (!(regval & ECC_CE_UE_INTR_MASK))
-		return IRQ_NONE;
+	/*
+	 * v3.0 of the controller has the ce/ue bits cleared automatically,
+	 * so this condition does not apply.
+	 */
+	if (!(priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)) {
+		regval = readl(priv->baseaddr + DDR_QOS_IRQ_STAT_OFST);
+		regval &= (DDR_QOSCE_MASK | DDR_QOSUE_MASK);
+		if (!(regval & ECC_CE_UE_INTR_MASK))
+			return IRQ_NONE;
+	}
 
 	status = p_data->get_error_info(priv);
 	if (status)
@@ -554,7 +565,9 @@ static irqreturn_t intr_handler(int irq, void *dev_id)
 
 	edac_dbg(3, "Total error count CE %d UE %d\n",
 		 priv->ce_cnt, priv->ue_cnt);
-	writel(regval, priv->baseaddr + DDR_QOS_IRQ_STAT_OFST);
+	/* v3.0 of the controller does not have this register */
+	if (!(priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR))
+		writel(regval, priv->baseaddr + DDR_QOS_IRQ_STAT_OFST);
 	return IRQ_HANDLED;
 }
 
@@ -840,8 +853,13 @@ static void mc_init(struct mem_ctl_info *mci, struct platform_device *pdev)
 static void enable_intr(struct synps_edac_priv *priv)
 {
 	/* Enable UE/CE Interrupts */
-	writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
-			priv->baseaddr + DDR_QOS_IRQ_EN_OFST);
+	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
+		writel(DDR_UE_MASK | DDR_CE_MASK,
+		       priv->baseaddr + ECC_CLR_OFST);
+	else
+		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
+		       priv->baseaddr + DDR_QOS_IRQ_EN_OFST);
+
 }
 
 static void disable_intr(struct synps_edac_priv *priv)
@@ -896,6 +914,19 @@ static const struct synps_platform_data zynqmp_edac_def = {
 			  ),
 };
 
+static const struct synps_platform_data synopsys_edac_def = {
+	.get_error_info	= zynqmp_get_error_info,
+	.get_mtype	= zynqmp_get_mtype,
+	.get_dtype	= zynqmp_get_dtype,
+	.get_ecc_state	= zynqmp_get_ecc_state,
+	.quirks         = (DDR_ECC_INTR_SUPPORT | DDR_ECC_INTR_SELF_CLEAR
+#ifdef CONFIG_EDAC_DEBUG
+			  | DDR_ECC_DATA_POISON_SUPPORT
+#endif
+			  ),
+};
+
+
 static const struct of_device_id synps_edac_match[] = {
 	{
 		.compatible = "xlnx,zynq-ddrc-a05",
@@ -905,6 +936,10 @@ static const struct of_device_id synps_edac_match[] = {
 		.compatible = "xlnx,zynqmp-ddrc-2.40a",
 		.data = (void *)&zynqmp_edac_def
 	},
+	{
+		.compatible = "snps,ddrc-3.80a",
+		.data = (void *)&synopsys_edac_def
+	},
 	{
 		/* end of table */
 	}
-- 
2.43.0



