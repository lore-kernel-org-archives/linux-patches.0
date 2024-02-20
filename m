Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD4C151CCD;
	Tue, 20 Feb 2024 21:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465186; cv=none; b=cGl8jI2rMmsn6TsfxZhi8bcy5LR5kFDfOWyzxhPXG0oESpyZ3FAqONgPNzEFzrVVmBqJo2qduZkOpsdwTDMLXQaAIXU8yFG/8r+dPGVF+xf5ke40amblrDyBi8gaB+HFe0snYvoKVTCVtcRIEvJoq3OZoZIzwLyOYqrEkJXppZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465186; c=relaxed/simple;
	bh=8KQex3E8Vr9VNvqdgG0fx6MsMxtijDAsMY2gvlo5abY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fStmpTbaplVdFpXg1P5bEDdTjSR18MPriuTuTi/2DujUgt/f2IxRckNnrJD1T2jzMQ3Sjz9naGhpdYfK0loVMh9p+ap1kZ2F/l+2eOiCJ+Fd1mNjuxwujqHG2VVsPiTZa0GMM/iQnLvQ1GTytMyTxBhlWmEgtKmffx6zwmltQ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rob83Coq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rob83Coq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E8BC433F1;
	Tue, 20 Feb 2024 21:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465186;
	bh=8KQex3E8Vr9VNvqdgG0fx6MsMxtijDAsMY2gvlo5abY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rob83CoqeMqegNa8CntzM9jgG9A8kArgdj0QAFfFGwq7ELlPYpja5nEYYsYxdrzwk
	 yV/qQJbKD9t3/Ho6N2u46CirywPs3rNKLOdOImS32W9Gyz+sP8fOS9VxqYz4LcdeSi
	 YfsI7c6kHEd3Nn3R2wp2878tzvvwAfoZkdNkzZCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Ai <fred.ai@bayhubtech.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 264/309] mmc: sdhci-pci-o2micro: Fix a warm reboot issue that disk cant be detected by BIOS
Date: Tue, 20 Feb 2024 21:57:03 +0100
Message-ID: <20240220205641.415482248@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


