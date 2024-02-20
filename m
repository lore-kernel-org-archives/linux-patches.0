Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993EB1509BC;
	Tue, 20 Feb 2024 21:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464084; cv=none; b=ZUU6kZ1m0/Ws1fWUkMEDgp8fr0STJA9s8bLWKBevuLUtIaOcKhNdDsJ1MZbbm/KFbeGRTPDrL+lQT97sueeu6EWBC6h39MrMCDhK9Efy961A3b055UUiDKuwj0YV/nn0BYIXfmYg83AGW4Dsdo8Xbv3CMq69LOyjzPSepZfJR5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464084; c=relaxed/simple;
	bh=//c/HyO/K5N1U0Z0wKMT1u2zNiP6fNBb1M5mgt9eagM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYW8bl0V7RohYoCi514DFQn3FhaTt5CdufkNadIZyPjc8rTwcRNYAojjKVPoZ3rtu35KJjbRIWS9axEy7fCiIoK0gPxUPvD+lltNFvM5habNkssagi1lZ7gAbJC/caWVQfRTrHTMI0rDVVTxriXCilWm7c9qbny1/bjLwblWEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCexzRmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCexzRmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1494C43394;
	Tue, 20 Feb 2024 21:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464084;
	bh=//c/HyO/K5N1U0Z0wKMT1u2zNiP6fNBb1M5mgt9eagM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCexzRmHZr7NQfwXeEfOD7I8wgtrc5AteYEOraRv4rT9k2i5dtbWk3ZZFXhmnNnx3
	 iFQ4BEVkocC7OqcT++PTnxi8gBBuxx9HRizn5FuzsP0XP5u1rey5HeAMRQvJYbpWaf
	 r2jQWIMm1AoaR0lEXGKr2mKuXoMsIauzJcHC/G4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Ai <fred.ai@bayhubtech.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 218/331] mmc: sdhci-pci-o2micro: Fix a warm reboot issue that disk cant be detected by BIOS
Date: Tue, 20 Feb 2024 21:55:34 +0100
Message-ID: <20240220205644.590767950@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fred Ai <fred.ai@bayhubtech.com>

commit 58aeb5623c2ebdadefe6352b14f8076a7073fea0 upstream.

Driver shall switch clock source from DLL clock to
OPE clock when power off card to ensure that card
can be identified with OPE clock by BIOS.

Signed-off-by: Fred Ai <fred.ai@bayhubtech.com>
Fixes:4be33cf18703 ("mmc: sdhci-pci-o2micro: Improve card input timing at SDR104/HS200 mode")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240203102908.4683-1-fredaibayhubtech@126.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-o2micro.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -693,6 +693,35 @@ static int sdhci_pci_o2_init_sd_express(
 	return 0;
 }
 
+static void sdhci_pci_o2_set_power(struct sdhci_host *host, unsigned char mode,  unsigned short vdd)
+{
+	struct sdhci_pci_chip *chip;
+	struct sdhci_pci_slot *slot = sdhci_priv(host);
+	u32 scratch_32 = 0;
+	u8 scratch_8 = 0;
+
+	chip = slot->chip;
+
+	if (mode == MMC_POWER_OFF) {
+		/* UnLock WP */
+		pci_read_config_byte(chip->pdev, O2_SD_LOCK_WP, &scratch_8);
+		scratch_8 &= 0x7f;
+		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch_8);
+
+		/* Set PCR 0x354[16] to switch Clock Source back to OPE Clock */
+		pci_read_config_dword(chip->pdev, O2_SD_OUTPUT_CLK_SOURCE_SWITCH, &scratch_32);
+		scratch_32 &= ~(O2_SD_SEL_DLL);
+		pci_write_config_dword(chip->pdev, O2_SD_OUTPUT_CLK_SOURCE_SWITCH, scratch_32);
+
+		/* Lock WP */
+		pci_read_config_byte(chip->pdev, O2_SD_LOCK_WP, &scratch_8);
+		scratch_8 |= 0x80;
+		pci_write_config_byte(chip->pdev, O2_SD_LOCK_WP, scratch_8);
+	}
+
+	sdhci_set_power(host, mode, vdd);
+}
+
 static int sdhci_pci_o2_probe_slot(struct sdhci_pci_slot *slot)
 {
 	struct sdhci_pci_chip *chip;
@@ -1051,6 +1080,7 @@ static const struct sdhci_ops sdhci_pci_
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
+	.set_power = sdhci_pci_o2_set_power,
 };
 
 const struct sdhci_pci_fixes sdhci_o2 = {


