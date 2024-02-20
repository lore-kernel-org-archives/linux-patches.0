Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45457133987;
	Tue, 20 Feb 2024 21:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463129; cv=none; b=Hg5G2u2RuUjXFVyoRVYPpA7sG2/35MG0NUSWZEzmkS5gHX7OCVJ+eLJJj5vXoNJnAWBFLvwxj44/9dLsJi+bkkM/JQ3PDioB0u3QVzkhtOuWB8PfjGakB9BI8KxMCOJmYml6AUCvGUSNdlMkmYNESg3W70PmPoMEL1orvZ8ERUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463129; c=relaxed/simple;
	bh=C/xRJ9A76ZMVGP+mvVff7Quge0iuB7t090bc9AElvfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BII6VsVZB7ua48lJD2N0s/ast5mCWKJDRAn5cRwhAbihJh1ZRSpwTFGS6jeyM0beDsd41E7+YcrFUNtobxVpuzw2d5bzoy1Bo/MQPxD3r41OLsbaVgZUynT7xSFYXCH8Qmyo0/p/RNA71Eb5st/M9LjaPwA5EZ02YRZaT9fb6bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vimpNjT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vimpNjT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C300C433C7;
	Tue, 20 Feb 2024 21:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463128;
	bh=C/xRJ9A76ZMVGP+mvVff7Quge0iuB7t090bc9AElvfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vimpNjT0iNBVAvcwq3wEo4aRWvIdg9A7c7zFta58c6mlCD7Jezc9OJxigQ3feVZIS
	 DDIK4zLb2qNa3Ma0qgn3Vrogpr6MGPGJS9gcsg1IhMiYaPPWzEmK1x9+iQ/2IdZ947
	 B+oDDKFu7acRZ2TEj3QmVXoejVn6k6MQx3iumwaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Ai <fred.ai@bayhubtech.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 145/197] mmc: sdhci-pci-o2micro: Fix a warm reboot issue that disk cant be detected by BIOS
Date: Tue, 20 Feb 2024 21:51:44 +0100
Message-ID: <20240220204845.406727284@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -602,6 +602,35 @@ static void sdhci_pci_o2_set_clock(struc
 	sdhci_o2_enable_clk(host, clk);
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
@@ -911,6 +940,7 @@ static const struct sdhci_ops sdhci_pci_
 	.set_bus_width = sdhci_set_bus_width,
 	.reset = sdhci_reset,
 	.set_uhs_signaling = sdhci_set_uhs_signaling,
+	.set_power = sdhci_pci_o2_set_power,
 };
 
 const struct sdhci_pci_fixes sdhci_o2 = {


