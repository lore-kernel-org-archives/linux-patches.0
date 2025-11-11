Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CB34C97;
	Tue, 11 Nov 2025 00:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822682; cv=none; b=J8krksOe9mZ6CEUKSAg39rVNOtKupvBXY3kP96QBGxbEk2ZI4SMqBMRCb2JdRU7wqoLi2L8Sosvy2Kj9t3lfje3HvGoHSlzC67r+dirhYJflzzclXBiqdzUOqPIhans/2HY89MCAcf09c+PlFI7jWyL8v5XMW9TeN2JvN1zo3nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822682; c=relaxed/simple;
	bh=lkhOVnetfiBFLSGyjn8Q6K1JfJb5k0Mqo1u7+ye9NJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Un1nD2+tmhbIyVITNztRfpPu6YZJIBeLOqLpOFQHo+8jyqAzdu/hciAWiH0dULkEowOdPOIvY/ZunTxPSvxYC0g3kMB3sYz+1t4PwH7dTvZSPRdMO7ZvPmXsSpZ+Ypd+ObgT/59Co+zR47jCvGD5qEQLoS9jm8tghqkj1q79fpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcKD+nSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcKD+nSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2D1C4CEF5;
	Tue, 11 Nov 2025 00:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822682;
	bh=lkhOVnetfiBFLSGyjn8Q6K1JfJb5k0Mqo1u7+ye9NJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcKD+nSyv0RISSqPh4iiZhd1kQaHx/6e3XHEhxdwtnrbMofQWfmY2vUJuIsKUJarM
	 ifZiyXozmFFOqLr5z34kuQsIgqvdLD4YI4VAujP+XaP3htpFiuAbm78ogQ74zAm5I3
	 K3aiXO9GWgr844RjVtpBsymHkxGGNb5T9lw4jg80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Roeschley <kyle.roeschley@ni.com>,
	Brad Mouring <brad.mouring@ni.com>,
	Erick Shepherd <erick.shepherd@ni.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 125/849] mmc: sdhci: Disable SD card clock before changing parameters
Date: Tue, 11 Nov 2025 09:34:55 +0900
Message-ID: <20251111004539.419434780@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erick Shepherd <erick.shepherd@ni.com>

[ Upstream commit 5f755ba95ae10fd4fa28d64345056ffc18d12c5a ]

Per the SD Host Controller Simplified Specification v4.20 §3.2.3, change
the SD card clock parameters only after first disabling the external card
clock. Doing this fixes a spurious clock pulse on Baytrail and Apollo Lake
SD controllers which otherwise breaks voltage switching with a specific
Swissbit SD card. This change is limited to Intel host controllers to
avoid an issue reported on ARM64 devices.

Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
Signed-off-by: Brad Mouring <brad.mouring@ni.com>
Signed-off-by: Erick Shepherd <erick.shepherd@ni.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250724185354.815888-1-erick.shepherd@ni.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 826958992dfe2..47a0a738862b5 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -679,8 +679,19 @@ static int intel_start_signal_voltage_switch(struct mmc_host *mmc,
 	return 0;
 }
 
+static void sdhci_intel_set_clock(struct sdhci_host *host, unsigned int clock)
+{
+	u16 clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
+
+	/* Stop card clock separately to avoid glitches on clock line */
+	if (clk & SDHCI_CLOCK_CARD_EN)
+		sdhci_writew(host, clk & ~SDHCI_CLOCK_CARD_EN, SDHCI_CLOCK_CONTROL);
+
+	sdhci_set_clock(host, clock);
+}
+
 static const struct sdhci_ops sdhci_intel_byt_ops = {
-	.set_clock		= sdhci_set_clock,
+	.set_clock		= sdhci_intel_set_clock,
 	.set_power		= sdhci_intel_set_power,
 	.enable_dma		= sdhci_pci_enable_dma,
 	.set_bus_width		= sdhci_set_bus_width,
@@ -690,7 +701,7 @@ static const struct sdhci_ops sdhci_intel_byt_ops = {
 };
 
 static const struct sdhci_ops sdhci_intel_glk_ops = {
-	.set_clock		= sdhci_set_clock,
+	.set_clock		= sdhci_intel_set_clock,
 	.set_power		= sdhci_intel_set_power,
 	.enable_dma		= sdhci_pci_enable_dma,
 	.set_bus_width		= sdhci_set_bus_width,
-- 
2.51.0



