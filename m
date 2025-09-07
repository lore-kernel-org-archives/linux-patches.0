Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4D626FA77;
	Sun,  7 Sep 2025 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276947; cv=none; b=LWeGvrUEcyRdQrMi+BMPpUOEmf0HJM7HyVIwUW/9RiENzizj/PDbfaJWTX51wE+sU9eYwrh3rvN16z8fjx6sAAk9zr5douYjTn+4BFU7faUo+8fdfpsjKOTCXDR5Hkbq56w8zbhFqIij4xOCYnII+QeVQLwLPdYcj2wcwqO94Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276947; c=relaxed/simple;
	bh=nbrU8vYZVyTMWZjsAZiQuu3QbpSLBPwd9ICqWXLELhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLhOMpxXhjCkH7ckPvqgqW52MVIcUbJY6EC+rZFgH4f4M3j7GzSUcisv1K0K93T7UnJuOYADb2GEQGhvdtxoV4GjWJ5cWuymnwUhLnKcK0ffgC/DBjZ6iB8npEJ2eaqrbXkErJ6IYnsIAU7oqeE8FMzAtI55lRPkODpaFRGp18Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AN6aNeJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AN6aNeJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6F4C4CEF9;
	Sun,  7 Sep 2025 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276946;
	bh=nbrU8vYZVyTMWZjsAZiQuu3QbpSLBPwd9ICqWXLELhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AN6aNeJuObdHTmoCczhCclHPCgeUsyCJt+71DUKIaistrIvsjofeJXDdsZRIUp/ko
	 TAqkoPzbEGroC+y12BnqrdaIu4wrwEWtZJZP6atH5U1rtg/5HKNtPCLNBEXbkhpZNc
	 wyJMSCG1c6vPZWZM546BEhVXiygHMhs4lBlqhud8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Alvin <alvin.paulp@amd.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/175] mmc: sdhci-of-arasan: Support for emmc hardware reset
Date: Sun,  7 Sep 2025 21:57:06 +0200
Message-ID: <20250907195615.601620547@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Alvin <alvin.paulp@amd.com>

[ Upstream commit 11c7d665181c1879b0d5561102c3834ff14a5615 ]

Add hw_reset callback to support emmc hardware reset, this callback get
called from the mmc core only when "cap-mmc-hw-reset" property is
defined in the DT.

Signed-off-by: Paul Alvin <alvin.paulp@amd.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20241007095445.19340-1-alvin.paulp@amd.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: e251709aaddb ("mmc: sdhci-of-arasan: Ensure CD logic stabilization before power-up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-of-arasan.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
index 5edd024347bd5..0cb05bdec34d5 100644
--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -76,6 +76,8 @@
 #define FREQSEL_225M_200M		0x7
 #define PHY_DLL_TIMEOUT_MS		100
 
+#define SDHCI_HW_RST_EN		BIT(4)
+
 /* Default settings for ZynqMP Clock Phases */
 #define ZYNQMP_ICLK_PHASE {0, 63, 63, 0, 63,  0,   0, 183, 54,  0, 0}
 #define ZYNQMP_OCLK_PHASE {0, 72, 60, 0, 60, 72, 135, 48, 72, 135, 0}
@@ -475,6 +477,21 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
 	}
 }
 
+static void sdhci_arasan_hw_reset(struct sdhci_host *host)
+{
+	u8 reg;
+
+	reg = sdhci_readb(host, SDHCI_POWER_CONTROL);
+	reg |= SDHCI_HW_RST_EN;
+	sdhci_writeb(host, reg, SDHCI_POWER_CONTROL);
+	/* As per eMMC spec, minimum 1us is required but give it 2us for good measure */
+	usleep_range(2, 5);
+	reg &= ~SDHCI_HW_RST_EN;
+	sdhci_writeb(host, reg, SDHCI_POWER_CONTROL);
+	/* As per eMMC spec, minimum 200us is required but give it 300us for good measure */
+	usleep_range(300, 500);
+}
+
 static int sdhci_arasan_voltage_switch(struct mmc_host *mmc,
 				       struct mmc_ios *ios)
 {
@@ -505,6 +522,7 @@ static const struct sdhci_ops sdhci_arasan_ops = {
 	.reset = sdhci_arasan_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
 	.set_power = sdhci_set_power_and_bus_voltage,
+	.hw_reset = sdhci_arasan_hw_reset,
 };
 
 static u32 sdhci_arasan_cqhci_irq(struct sdhci_host *host, u32 intmask)
-- 
2.50.1



