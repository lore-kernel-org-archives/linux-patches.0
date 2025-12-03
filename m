Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5953AA195;
	Wed,  3 Dec 2025 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780767; cv=none; b=FpOegx1RyVGzIfqDumyo/0M2u6dpzSq59JVPqHkpru8A5zaFzTI2VOmJHjGk+6MDOOgmdPa01w05TUsFsFs8w39gfc2RyceLNMDUtBWBURHQT0GedZMnfYQ4DWqtQP8obVS3qZ8njIgKw68+QOeuOWCbPpNp/BxQri7OIbCL0l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780767; c=relaxed/simple;
	bh=r2YzppF9gcafCK5CcMPjs9JWlPjiwqmFNO7gti5/lLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEYuSc8ZQ03KLo5gqV03DtyJRFN8TD6WKF5wpiTUWfSkCba3dG5s8dCFWRohACB7JW83wOVeHhZZfX2wCLW41A1Yr/Ln9KRBm0VsbSn5VjpRfavKgstYOd/vwk/nbf3dYx0KkQ1iiF1cfCUdspUrR4Vd9LlbjrHMnN5CxZ/ehoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrkC0XUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrkC0XUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6494AC4CEF5;
	Wed,  3 Dec 2025 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780765;
	bh=r2YzppF9gcafCK5CcMPjs9JWlPjiwqmFNO7gti5/lLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrkC0XUn5OyjLNSq/ZvC1Mpn7sTJP4vLEwxGfxM8+zcTQHl8oLfvPVXy39s+7gD/9
	 j4WHPbsEqDstFnmQOroeSkR1/K21G3Ajuh/iUBUYQ5RN0mops07NXyQ6IQyi87oAZT
	 VatSpW0yiSgI2h5nyDEpQzRLn1ftIyAshV6YBPZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 083/132] mmc: sdhci-of-dwcmshc: Promote the th1520 reset handling to ip level
Date: Wed,  3 Dec 2025 16:29:22 +0100
Message-ID: <20251203152346.369768607@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

commit 747528729c9b6733839f9c95f300d5bef95ee52c upstream.

Commit 27e8fe0da3b7 ("mmc: sdhci-of-dwcmshc: Prevent stale command
interrupt handling") clears pending interrupts when resetting
host->pending_reset to ensure no pending stale interrupts after
sdhci_threaded_irq restores interrupts. But this fix is only added for
th1520 platforms, in fact per my test, this issue exists on all
dwcmshc users, such as cv1800b, sg2002, and synaptics platforms.

So promote the above reset handling from th1520 to ip level. And keep
reset handling on rk, sg2042 and bf3 as is, until it's confirmed that
the same issue exists on these platforms too.

Fixes: 017199c2849c ("mmc: sdhci-of-dwcmshc: Add support for Sophgo CV1800B and SG2002")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -289,6 +289,19 @@ static void dwcmshc_adma_write_desc(stru
 	sdhci_adma_write_desc(host, desc, addr, len, cmd);
 }
 
+static void dwcmshc_reset(struct sdhci_host *host, u8 mask)
+{
+	sdhci_reset(host, mask);
+
+	/* The dwcmshc does not comply with the SDHCI specification
+	 * regarding the "Software Reset for CMD line should clear 'Command
+	 * Complete' in the Normal Interrupt Status Register." Clear the bit
+	 * here to compensate for this quirk.
+	 */
+	if (mask & SDHCI_RESET_CMD)
+		sdhci_writel(host, SDHCI_INT_RESPONSE, SDHCI_INT_STATUS);
+}
+
 static unsigned int dwcmshc_get_max_clock(struct sdhci_host *host)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
@@ -874,15 +887,7 @@ static void th1520_sdhci_reset(struct sd
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	u16 ctrl_2;
 
-	sdhci_reset(host, mask);
-
-	/* The T-Head 1520 SoC does not comply with the SDHCI specification
-	 * regarding the "Software Reset for CMD line should clear 'Command
-	 * Complete' in the Normal Interrupt Status Register." Clear the bit
-	 * here to compensate for this quirk.
-	 */
-	if (mask & SDHCI_RESET_CMD)
-		sdhci_writel(host, SDHCI_INT_RESPONSE, SDHCI_INT_STATUS);
+	dwcmshc_reset(host, mask);
 
 	if (priv->flags & FLAG_IO_FIXED_1V8) {
 		ctrl_2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);
@@ -928,7 +933,7 @@ static void cv18xx_sdhci_reset(struct sd
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	u32 val, emmc_caps = MMC_CAP2_NO_SD | MMC_CAP2_NO_SDIO;
 
-	sdhci_reset(host, mask);
+	dwcmshc_reset(host, mask);
 
 	if ((host->mmc->caps2 & emmc_caps) == emmc_caps) {
 		val = sdhci_readl(host, priv->vendor_specific_area1 + CV18XX_SDHCI_MSHC_CTRL);
@@ -1000,7 +1005,7 @@ static void cv18xx_sdhci_post_tuning(str
 	val |= SDHCI_INT_DATA_AVAIL;
 	sdhci_writel(host, val, SDHCI_INT_STATUS);
 
-	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
+	dwcmshc_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 }
 
 static int cv18xx_sdhci_execute_tuning(struct sdhci_host *host, u32 opcode)
@@ -1142,7 +1147,7 @@ static const struct sdhci_ops sdhci_dwcm
 	.set_bus_width		= sdhci_set_bus_width,
 	.set_uhs_signaling	= dwcmshc_set_uhs_signaling,
 	.get_max_clock		= dwcmshc_get_max_clock,
-	.reset			= sdhci_reset,
+	.reset			= dwcmshc_reset,
 	.adma_write_desc	= dwcmshc_adma_write_desc,
 	.irq			= dwcmshc_cqe_irq_handler,
 };


