Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D6E3328F6;
	Wed,  3 Dec 2025 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777175; cv=none; b=hpbp37MO7w8Trjlcr6HorrTZBgTEq/LUj0ccXndy4RQCJ6iEUePRB5Qam0ag0OKq7HmGZEtmzsh7Nh3k+C6cQDoesWLnB1ZDnGMDr9U/hHnpOTjFxK8YHjnZYC2NfcR0qNbxbY2TvrBJZOaNbhbyzA7SSOI9PtBFfa58kSqIJP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777175; c=relaxed/simple;
	bh=ZNjNIBovP/XUnrxUFFYukwFvuMb320Xg1kvR4cuYMSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VURRviZ5uq3dOL2Sl7Ly3jHo6FH44Rk2Bun68XiuNR9MRnUdygsu1MQqaY2DonkwsxCmRyNw8rC5VLf/C78VKKOCNF2SXoD9Hb2jDGMC2DB4Ou3LVj/vNUvhI+abaRRBTXgfmtkWC1mItdknY+V0aWPA/QcUaPHckuvkqpVFJpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqDJCu1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqDJCu1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D7BC4CEF5;
	Wed,  3 Dec 2025 15:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777175;
	bh=ZNjNIBovP/XUnrxUFFYukwFvuMb320Xg1kvR4cuYMSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqDJCu1ATKgXMksTBPyAWssruFRpVC8BX184j7BVwPzZV/HbZDJ1eO+Ka2m5RqN5P
	 zaNl8zDIndqJMy9NTwXR+jyzOhH6sKNzNWTTyFW7ewh2O5zSri8/Vn0ZANuv2cItIA
	 HjUMqOHuo+/rM3uDw7TfHnioiI3MaF7DqAbqZvJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 104/146] mmc: sdhci-of-dwcmshc: Promote the th1520 reset handling to ip level
Date: Wed,  3 Dec 2025 16:28:02 +0100
Message-ID: <20251203152350.272719038@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -832,15 +845,7 @@ static void th1520_sdhci_reset(struct sd
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
@@ -886,7 +891,7 @@ static void cv18xx_sdhci_reset(struct sd
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	u32 val, emmc_caps = MMC_CAP2_NO_SD | MMC_CAP2_NO_SDIO;
 
-	sdhci_reset(host, mask);
+	dwcmshc_reset(host, mask);
 
 	if ((host->mmc->caps2 & emmc_caps) == emmc_caps) {
 		val = sdhci_readl(host, priv->vendor_specific_area1 + CV18XX_SDHCI_MSHC_CTRL);
@@ -958,7 +963,7 @@ static void cv18xx_sdhci_post_tuning(str
 	val |= SDHCI_INT_DATA_AVAIL;
 	sdhci_writel(host, val, SDHCI_INT_STATUS);
 
-	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
+	dwcmshc_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 }
 
 static int cv18xx_sdhci_execute_tuning(struct sdhci_host *host, u32 opcode)
@@ -1100,7 +1105,7 @@ static const struct sdhci_ops sdhci_dwcm
 	.set_bus_width		= sdhci_set_bus_width,
 	.set_uhs_signaling	= dwcmshc_set_uhs_signaling,
 	.get_max_clock		= dwcmshc_get_max_clock,
-	.reset			= sdhci_reset,
+	.reset			= dwcmshc_reset,
 	.adma_write_desc	= dwcmshc_adma_write_desc,
 	.irq			= dwcmshc_cqe_irq_handler,
 };


