Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720C31D90DB;
	Tue, 15 Oct 2024 11:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992351; cv=none; b=qO3pKgXxL7LwYCQtP0jrxjR3JliXRWOcSaPCBSyv98MvwOmC0Jv/9A8PeAJYCEU/NYl+O/9SDV3agQQpR41EdI2wU+RsM/UKBVRKnJbz1SQdNMCX8vAkFvkm6QJHHzb9ydb3p5n3BYBI8stUDpDmflP7xmh/VPsuXB0Arwf70Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992351; c=relaxed/simple;
	bh=5IUPyqjP32m/DE9fv0vMuuj+90MY7wjIuPkcUSCX7vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QE/z3Ws1JgbKCoJriH/Q3MdkDntKrH3B7SRc7VubT7vSsmXQDHwoRETm+pNVZbC2ZPINLD5JwrUX+3Tt+p5Me9Hkj9yQuZ3im16070fe4hqIRHyxrmjIOsVwAYRUqAMs0OU+mYjbY1kUN6UZDi9+SZlBkASA562UjU5Sq77TSog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMrSmFVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMrSmFVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C05C4CEC6;
	Tue, 15 Oct 2024 11:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992351;
	bh=5IUPyqjP32m/DE9fv0vMuuj+90MY7wjIuPkcUSCX7vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMrSmFVF3+BEmieOqFmE+O0S3G/2eNrEZGXNzqslQuf7uz7sxB+3Xpne8nCiS2TGf
	 EtLNqMyoRfP+jPSeFPoZKBevo00fjBfC6baCKB2qNEmcADL+TgGGrwIlkshvMGdi+3
	 2NIdlGVa6XXTQY0oFMaCHT4xuvUcj5ad+unUlhho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Sun <sherry.sun@nxp.com>,
	Borislav Petkov <bp@suse.de>,
	Shubhrajyoti Datta <Shubhrajyoti.datta@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/691] EDAC/synopsys: Re-enable the error interrupts on v3 hw
Date: Tue, 15 Oct 2024 13:20:40 +0200
Message-ID: <20241015112444.015071187@linuxfoundation.org>
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

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit 4bcffe941758ee17becb43af3b25487f848f6512 ]

zynqmp_get_error_info() writes 0 to the ECC_CLR_OFST register after
an interrupt for a {un-,}correctable error is raised, which disables
the error interrupts. Then the interrupt handler will be called only
once. Therefore, re-enable the error interrupt line at the end of
intr_handler() for v3.x Synopsys EDAC DDR.

Fixes: f7824ded4149 ("EDAC/synopsys: Add support for version 3 of the Synopsys EDAC DDR")
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Shubhrajyoti Datta <Shubhrajyoti.datta@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220427015137.8406-3-sherry.sun@nxp.com
Stable-dep-of: 35e6dbfe1846 ("EDAC/synopsys: Fix error injection on Zynq UltraScale+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/synopsys_edac.c | 47 +++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 88a481043d4c3..a14baeca64004 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -527,6 +527,28 @@ static void handle_error(struct mem_ctl_info *mci, struct synps_ecc_status *p)
 	memset(p, 0, sizeof(*p));
 }
 
+static void enable_intr(struct synps_edac_priv *priv)
+{
+	/* Enable UE/CE Interrupts */
+	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
+		writel(DDR_UE_MASK | DDR_CE_MASK,
+		       priv->baseaddr + ECC_CLR_OFST);
+	else
+		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
+		       priv->baseaddr + DDR_QOS_IRQ_EN_OFST);
+
+}
+
+static void disable_intr(struct synps_edac_priv *priv)
+{
+	/* Disable UE/CE Interrupts */
+	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
+		writel(0x0, priv->baseaddr + ECC_CLR_OFST);
+	else
+		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
+		       priv->baseaddr + DDR_QOS_IRQ_DB_OFST);
+}
+
 /**
  * intr_handler - Interrupt Handler for ECC interrupts.
  * @irq:        IRQ number.
@@ -568,6 +590,9 @@ static irqreturn_t intr_handler(int irq, void *dev_id)
 	/* v3.0 of the controller does not have this register */
 	if (!(priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR))
 		writel(regval, priv->baseaddr + DDR_QOS_IRQ_STAT_OFST);
+	else
+		enable_intr(priv);
+
 	return IRQ_HANDLED;
 }
 
@@ -850,28 +875,6 @@ static void mc_init(struct mem_ctl_info *mci, struct platform_device *pdev)
 	init_csrows(mci);
 }
 
-static void enable_intr(struct synps_edac_priv *priv)
-{
-	/* Enable UE/CE Interrupts */
-	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
-		writel(DDR_UE_MASK | DDR_CE_MASK,
-		       priv->baseaddr + ECC_CLR_OFST);
-	else
-		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
-		       priv->baseaddr + DDR_QOS_IRQ_EN_OFST);
-
-}
-
-static void disable_intr(struct synps_edac_priv *priv)
-{
-	/* Disable UE/CE Interrupts */
-	if (priv->p_data->quirks & DDR_ECC_INTR_SELF_CLEAR)
-		writel(0x0, priv->baseaddr + ECC_CLR_OFST);
-	else
-		writel(DDR_QOSUE_MASK | DDR_QOSCE_MASK,
-		       priv->baseaddr + DDR_QOS_IRQ_DB_OFST);
-}
-
 static int setup_irq(struct mem_ctl_info *mci,
 		     struct platform_device *pdev)
 {
-- 
2.43.0



