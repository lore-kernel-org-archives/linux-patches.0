Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A6B343D69;
	Mon, 18 Aug 2025 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523328; cv=none; b=YxqRILVeIZYOlFO7GT0oWyjXKUNRsZENvR33jHHJD3It5X+PsC1Hl80L19O8/NbMPIkx23PAgvPeHXSpTibwcMHE2OfBSVIu6w8MUeiQEj6UlkRQwwoqaEgNzot/EQfG0TJfurzVz+wykibfkr7zwACII9ZSG7cxFl2UNT9KmlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523328; c=relaxed/simple;
	bh=A35Gt9L8g9fxjNHaxwaA/Bb5jnGajiMmvwOtFJ3vndo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfnWV0bUjFgPEZCptU5igRSgnAHdRlezefn0OIdWUxdpIuGv6wgab33AwOdtKlqo82Kz5NOZIuSeoc9FOM/yCPaRFrGrv070iU3Hxw6SCnBvmrEuQE7vY1PHE1NgMy6okyQQy/lvguNdfDXVnjh6K8qFsvbaUbMB2EiN7CnqsEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M13qZ5Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M13qZ5Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6BBC4CEEB;
	Mon, 18 Aug 2025 13:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523328;
	bh=A35Gt9L8g9fxjNHaxwaA/Bb5jnGajiMmvwOtFJ3vndo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M13qZ5Sibb1Am6DjKbSqf9bB0VaJhGqpuRoqT/631xsV1ubr14FWchKHQ09JMrd4f
	 eQ9w+zunyLsRQCsUIBVkpqpwo5ea5a0M7MQQ14k7EirpG6EB/EZWtK/f94tgeOhg3t
	 V2BFwFKdOrUKnXlkddZNKX6FELFkqZwChu5OnqG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 137/515] EDAC/synopsys: Clear the ECC counters on init
Date: Mon, 18 Aug 2025 14:42:03 +0200
Message-ID: <20250818124503.666301348@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit b1dc7f097b78eb8d25b071ead2384b07a549692b ]

Clear the ECC error and counter registers during initialization/probe to avoid
reporting stale errors that may have occurred before EDAC registration.

For that, unify the Zynq and ZynqMP ECC state reading paths and simplify the
code.

  [ bp: Massage commit message.
    Fix an -Wsometimes-uninitialized warning as reported by
    Reported-by: kernel test robot <lkp@intel.com>
    Closes: https://lore.kernel.org/oe-kbuild-all/202507141048.obUv3ZUm-lkp@intel.com ]

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/20250713050753.7042-1-shubhrajyoti.datta@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/synopsys_edac.c | 97 +++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 51 deletions(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 5ed32a3299c4..51143b3257de 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -332,20 +332,26 @@ struct synps_edac_priv {
 #endif
 };
 
+enum synps_platform_type {
+	ZYNQ,
+	ZYNQMP,
+	SYNPS,
+};
+
 /**
  * struct synps_platform_data -  synps platform data structure.
+ * @platform:		Identifies the target hardware platform
  * @get_error_info:	Get EDAC error info.
  * @get_mtype:		Get mtype.
  * @get_dtype:		Get dtype.
- * @get_ecc_state:	Get ECC state.
  * @get_mem_info:	Get EDAC memory info
  * @quirks:		To differentiate IPs.
  */
 struct synps_platform_data {
+	enum synps_platform_type platform;
 	int (*get_error_info)(struct synps_edac_priv *priv);
 	enum mem_type (*get_mtype)(const void __iomem *base);
 	enum dev_type (*get_dtype)(const void __iomem *base);
-	bool (*get_ecc_state)(void __iomem *base);
 #ifdef CONFIG_EDAC_DEBUG
 	u64 (*get_mem_info)(struct synps_edac_priv *priv);
 #endif
@@ -720,51 +726,38 @@ static enum dev_type zynqmp_get_dtype(const void __iomem *base)
 	return dt;
 }
 
-/**
- * zynq_get_ecc_state - Return the controller ECC enable/disable status.
- * @base:	DDR memory controller base address.
- *
- * Get the ECC enable/disable status of the controller.
- *
- * Return: true if enabled, otherwise false.
- */
-static bool zynq_get_ecc_state(void __iomem *base)
+static bool get_ecc_state(struct synps_edac_priv *priv)
 {
+	u32 ecctype, clearval;
 	enum dev_type dt;
-	u32 ecctype;
-
-	dt = zynq_get_dtype(base);
-	if (dt == DEV_UNKNOWN)
-		return false;
 
-	ecctype = readl(base + SCRUB_OFST) & SCRUB_MODE_MASK;
-	if ((ecctype == SCRUB_MODE_SECDED) && (dt == DEV_X2))
-		return true;
-
-	return false;
-}
-
-/**
- * zynqmp_get_ecc_state - Return the controller ECC enable/disable status.
- * @base:	DDR memory controller base address.
- *
- * Get the ECC enable/disable status for the controller.
- *
- * Return: a ECC status boolean i.e true/false - enabled/disabled.
- */
-static bool zynqmp_get_ecc_state(void __iomem *base)
-{
-	enum dev_type dt;
-	u32 ecctype;
-
-	dt = zynqmp_get_dtype(base);
-	if (dt == DEV_UNKNOWN)
-		return false;
-
-	ecctype = readl(base + ECC_CFG0_OFST) & SCRUB_MODE_MASK;
-	if ((ecctype == SCRUB_MODE_SECDED) &&
-	    ((dt == DEV_X2) || (dt == DEV_X4) || (dt == DEV_X8)))
-		return true;
+	if (priv->p_data->platform == ZYNQ) {
+		dt = zynq_get_dtype(priv->baseaddr);
+		if (dt == DEV_UNKNOWN)
+			return false;
+
+		ecctype = readl(priv->baseaddr + SCRUB_OFST) & SCRUB_MODE_MASK;
+		if (ecctype == SCRUB_MODE_SECDED && dt == DEV_X2) {
+			clearval = ECC_CTRL_CLR_CE_ERR | ECC_CTRL_CLR_UE_ERR;
+			writel(clearval, priv->baseaddr + ECC_CTRL_OFST);
+			writel(0x0, priv->baseaddr + ECC_CTRL_OFST);
+			return true;
+		}
+	} else {
+		dt = zynqmp_get_dtype(priv->baseaddr);
+		if (dt == DEV_UNKNOWN)
+			return false;
+
+		ecctype = readl(priv->baseaddr + ECC_CFG0_OFST) & SCRUB_MODE_MASK;
+		if (ecctype == SCRUB_MODE_SECDED &&
+		    (dt == DEV_X2 || dt == DEV_X4 || dt == DEV_X8)) {
+			clearval = readl(priv->baseaddr + ECC_CLR_OFST) |
+			ECC_CTRL_CLR_CE_ERR | ECC_CTRL_CLR_CE_ERRCNT |
+			ECC_CTRL_CLR_UE_ERR | ECC_CTRL_CLR_UE_ERRCNT;
+			writel(clearval, priv->baseaddr + ECC_CLR_OFST);
+			return true;
+		}
+	}
 
 	return false;
 }
@@ -934,18 +927,18 @@ static int setup_irq(struct mem_ctl_info *mci,
 }
 
 static const struct synps_platform_data zynq_edac_def = {
+	.platform = ZYNQ,
 	.get_error_info	= zynq_get_error_info,
 	.get_mtype	= zynq_get_mtype,
 	.get_dtype	= zynq_get_dtype,
-	.get_ecc_state	= zynq_get_ecc_state,
 	.quirks		= 0,
 };
 
 static const struct synps_platform_data zynqmp_edac_def = {
+	.platform = ZYNQMP,
 	.get_error_info	= zynqmp_get_error_info,
 	.get_mtype	= zynqmp_get_mtype,
 	.get_dtype	= zynqmp_get_dtype,
-	.get_ecc_state	= zynqmp_get_ecc_state,
 #ifdef CONFIG_EDAC_DEBUG
 	.get_mem_info	= zynqmp_get_mem_info,
 #endif
@@ -957,10 +950,10 @@ static const struct synps_platform_data zynqmp_edac_def = {
 };
 
 static const struct synps_platform_data synopsys_edac_def = {
+	.platform = SYNPS,
 	.get_error_info	= zynqmp_get_error_info,
 	.get_mtype	= zynqmp_get_mtype,
 	.get_dtype	= zynqmp_get_dtype,
-	.get_ecc_state	= zynqmp_get_ecc_state,
 	.quirks         = (DDR_ECC_INTR_SUPPORT | DDR_ECC_INTR_SELF_CLEAR
 #ifdef CONFIG_EDAC_DEBUG
 			  | DDR_ECC_DATA_POISON_SUPPORT
@@ -1390,10 +1383,6 @@ static int mc_probe(struct platform_device *pdev)
 	if (!p_data)
 		return -ENODEV;
 
-	if (!p_data->get_ecc_state(baseaddr)) {
-		edac_printk(KERN_INFO, EDAC_MC, "ECC not enabled\n");
-		return -ENXIO;
-	}
 
 	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
 	layers[0].size = SYNPS_EDAC_NR_CSROWS;
@@ -1413,6 +1402,12 @@ static int mc_probe(struct platform_device *pdev)
 	priv = mci->pvt_info;
 	priv->baseaddr = baseaddr;
 	priv->p_data = p_data;
+	if (!get_ecc_state(priv)) {
+		edac_printk(KERN_INFO, EDAC_MC, "ECC not enabled\n");
+		rc = -ENODEV;
+		goto free_edac_mc;
+	}
+
 	spin_lock_init(&priv->reglock);
 
 	mc_init(mci, pdev);
-- 
2.39.5



