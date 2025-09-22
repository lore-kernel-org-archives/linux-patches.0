Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835342F1FE3;
	Mon, 22 Sep 2025 19:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570287; cv=none; b=NoFl3Z5TQT4dim9fHeFpmZ0aDSYzhId9RX1elV7lHLy9p9ZAQa3HF/nYWi7ZPODljXy4rtao0UTgpqNpJvl2uCiFAuagKFCKetmvQfyjuk5dh3F7iV8TobJuFGI1Edk3v3QRSH7PUbLOlf/JZ+muKR1UlTJhOYCoEN6EYneb8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570287; c=relaxed/simple;
	bh=yZ6w/bySmrHm2s5O1of+d1W5ppALhHd3CqtXoXm3GyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2SZH9HannV7NRSbl15U/fWC9Lh8a6SbXEQcQlf7CnooO3tn6bff2ggM+2HgkPW0YUCR2eoP/YErjQdY2VgmWyogSrrrnJVl/7QsiwQrvNw2Wbt8XV34wlfuy9ZoJbyPCggaz5fHfsL+EbQ7FQXb6vgZy+yKH0sMoV2gnT/m86s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPJCzFLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPJCzFLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA3AC4CEF0;
	Mon, 22 Sep 2025 19:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570287;
	bh=yZ6w/bySmrHm2s5O1of+d1W5ppALhHd3CqtXoXm3GyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPJCzFLSfTEuHNxQpYh4OWLRohrhMrLx9pmPtI2xnL78F1t4bL1zb8cMjwRuoE9wK
	 Ay4HKBLsQd5lGDeaxAPLGkElEYYkY1GsrbmZ4mTCYqbSpkAfE2QJbnjW4ZGLj3N3o5
	 c68lwtNalf4oY2weYrfYKruVFLrAVKfTZBhXi5GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.16 090/149] mmc: sdhci-pci-gli: GL9767: Fix initializing the UHS-II interface during a power-on
Date: Mon, 22 Sep 2025 21:29:50 +0200
Message-ID: <20250922192415.154966189@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

commit 77a436c93d10d68201bfd4941d1ca3230dfd1f40 upstream.

According to the power structure of IC hardware design for UHS-II
interface, reset control and timing must be added to the initialization
process of powering on the UHS-II interface.

Fixes: 27dd3b82557a ("mmc: sdhci-pci-gli: enable UHS-II mode for GL9767")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |   68 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -283,6 +283,8 @@
 #define   PCIE_GLI_9767_UHS2_CTL2_ZC_VALUE	  0xb
 #define   PCIE_GLI_9767_UHS2_CTL2_ZC_CTL	  BIT(6)
 #define   PCIE_GLI_9767_UHS2_CTL2_ZC_CTL_VALUE	  0x1
+#define   PCIE_GLI_9767_UHS2_CTL2_FORCE_PHY_RESETN	BIT(13)
+#define   PCIE_GLI_9767_UHS2_CTL2_FORCE_RESETN_VALUE	BIT(14)
 
 #define GLI_MAX_TUNING_LOOP 40
 
@@ -1179,6 +1181,65 @@ static void gl9767_set_low_power_negotia
 	gl9767_vhs_read(pdev);
 }
 
+static void sdhci_gl9767_uhs2_phy_reset(struct sdhci_host *host, bool assert)
+{
+	struct sdhci_pci_slot *slot = sdhci_priv(host);
+	struct pci_dev *pdev = slot->chip->pdev;
+	u32 value, set, clr;
+
+	if (assert) {
+		/* Assert reset, set RESETN and clean RESETN_VALUE */
+		set = PCIE_GLI_9767_UHS2_CTL2_FORCE_PHY_RESETN;
+		clr = PCIE_GLI_9767_UHS2_CTL2_FORCE_RESETN_VALUE;
+	} else {
+		/* De-assert reset, clean RESETN and set RESETN_VALUE */
+		set = PCIE_GLI_9767_UHS2_CTL2_FORCE_RESETN_VALUE;
+		clr = PCIE_GLI_9767_UHS2_CTL2_FORCE_PHY_RESETN;
+	}
+
+	gl9767_vhs_write(pdev);
+	pci_read_config_dword(pdev, PCIE_GLI_9767_UHS2_CTL2, &value);
+	value |= set;
+	pci_write_config_dword(pdev, PCIE_GLI_9767_UHS2_CTL2, value);
+	value &= ~clr;
+	pci_write_config_dword(pdev, PCIE_GLI_9767_UHS2_CTL2, value);
+	gl9767_vhs_read(pdev);
+}
+
+static void __gl9767_uhs2_set_power(struct sdhci_host *host, unsigned char mode, unsigned short vdd)
+{
+	u8 pwr = 0;
+
+	if (mode != MMC_POWER_OFF) {
+		pwr = sdhci_get_vdd_value(vdd);
+		if (!pwr)
+			WARN(1, "%s: Invalid vdd %#x\n",
+			     mmc_hostname(host->mmc), vdd);
+		pwr |= SDHCI_VDD2_POWER_180;
+	}
+
+	if (host->pwr == pwr)
+		return;
+
+	host->pwr = pwr;
+
+	if (pwr == 0) {
+		sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
+	} else {
+		sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
+
+		pwr |= SDHCI_POWER_ON;
+		sdhci_writeb(host, pwr & 0xf, SDHCI_POWER_CONTROL);
+		usleep_range(5000, 6250);
+
+		/* Assert reset */
+		sdhci_gl9767_uhs2_phy_reset(host, true);
+		pwr |= SDHCI_VDD2_POWER_ON;
+		sdhci_writeb(host, pwr, SDHCI_POWER_CONTROL);
+		usleep_range(5000, 6250);
+	}
+}
+
 static void sdhci_gl9767_set_clock(struct sdhci_host *host, unsigned int clock)
 {
 	struct sdhci_pci_slot *slot = sdhci_priv(host);
@@ -1205,6 +1266,11 @@ static void sdhci_gl9767_set_clock(struc
 	}
 
 	sdhci_enable_clk(host, clk);
+
+	if (mmc_card_uhs2(host->mmc))
+		/* De-assert reset */
+		sdhci_gl9767_uhs2_phy_reset(host, false);
+
 	gl9767_set_low_power_negotiation(pdev, true);
 }
 
@@ -1476,7 +1542,7 @@ static void sdhci_gl9767_set_power(struc
 		gl9767_vhs_read(pdev);
 
 		sdhci_gli_overcurrent_event_enable(host, false);
-		sdhci_uhs2_set_power(host, mode, vdd);
+		__gl9767_uhs2_set_power(host, mode, vdd);
 		sdhci_gli_overcurrent_event_enable(host, true);
 	} else {
 		gl9767_vhs_write(pdev);


