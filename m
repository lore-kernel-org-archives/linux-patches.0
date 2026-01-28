Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8E52836A6;
	Wed, 28 Jan 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616069; cv=none; b=n8icMO7HWaAKgBW9VREjaKAHCeyYAUL2vhtW7e2x2qPXxDGcpHOTpNyBiouX8uZD58vmuBkhSWgUp2s6oTeKGPE4UbHWX+e1si5TQrF+1KSOVEjAx3lGo0iNBBjOehWVpZF9QUtd4mppW5aXk2R8ZGdUGbNYZ2UMlqXJnXx9QOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616069; c=relaxed/simple;
	bh=iOhyQtNz4Jj9EOfjw4puMCEyj7Ys3GkrGLP+FUYHyKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpCBzaqv3ihh508rEPBW93WxgIWWu3VcyGEXEMVfBGxPRgzQoBvNO/cRPfAcBbJKLQCnJxgJjNSB0HGd+16XjecqnN3m44aM1xAp+Pi/ApNgy8ZLPZxxo6793T1YDbKECfw87ijBSD/VNtcVzrDWMD6H/egu9MQI6KXlgwW6pvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpKR/oAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpKR/oAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF712C116C6;
	Wed, 28 Jan 2026 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616069;
	bh=iOhyQtNz4Jj9EOfjw4puMCEyj7Ys3GkrGLP+FUYHyKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpKR/oAgb9wpTKfbJAl8D8W6pcwvbWx4C+3TM2szDvKwYXsIIHxbhdD6fGde5qPIv
	 MMENGwJwfwNWb+XGFsrb/OsRXgsoItfMI+d0s4gVOHA9KsPTs/HlYuNHmmjMxo9Gna
	 ej96SO/ZoEPojI7X46Pk+lpysIR/kZPGI3yYkKd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ricky WU <ricky_wu@realtek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 170/227] mmc: rtsx_pci_sdmmc: implement sdmmc_card_busy function
Date: Wed, 28 Jan 2026 16:23:35 +0100
Message-ID: <20260128145350.568400691@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

commit 122610220134b32c742cc056eaf64f7017ac8cd9 upstream.

rtsx_pci_sdmmc does not have an sdmmc_card_busy function, so any voltage
switches cause a kernel warning, "mmc0: cannot verify signal voltage
switch."

Copy the sdmmc_card_busy function from rtsx_pci_usb to rtsx_pci_sdmmc to
fix this.

Fixes: ff984e57d36e ("mmc: Add realtek pcie sdmmc host driver")
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Tested-by: Ricky WU <ricky_wu@realtek.com>
Reviewed-by: Ricky WU <ricky_wu@realtek.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |   41 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1306,6 +1306,46 @@ out:
 	return err;
 }
 
+static int sdmmc_card_busy(struct mmc_host *mmc)
+{
+	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
+	struct rtsx_pcr *pcr = host->pcr;
+	int err;
+	u8 stat;
+	u8 mask = SD_DAT3_STATUS | SD_DAT2_STATUS | SD_DAT1_STATUS
+	| SD_DAT0_STATUS;
+
+	mutex_lock(&pcr->pcr_mutex);
+
+	rtsx_pci_start_run(pcr);
+
+	err = rtsx_pci_write_register(pcr, SD_BUS_STAT,
+				      SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP,
+			       SD_CLK_TOGGLE_EN);
+	if (err)
+		goto out;
+
+	mdelay(1);
+
+	err = rtsx_pci_read_register(pcr, SD_BUS_STAT, &stat);
+	if (err)
+		goto out;
+
+	err = rtsx_pci_write_register(pcr, SD_BUS_STAT,
+				      SD_CLK_TOGGLE_EN | SD_CLK_FORCE_STOP, 0);
+out:
+	mutex_unlock(&pcr->pcr_mutex);
+
+	if (err)
+		return err;
+
+	/* check if any pin between dat[0:3] is low */
+	if ((stat & mask) != mask)
+		return 1;
+	else
+		return 0;
+}
+
 static int sdmmc_execute_tuning(struct mmc_host *mmc, u32 opcode)
 {
 	struct realtek_pci_sdmmc *host = mmc_priv(mmc);
@@ -1418,6 +1458,7 @@ static const struct mmc_host_ops realtek
 	.get_ro = sdmmc_get_ro,
 	.get_cd = sdmmc_get_cd,
 	.start_signal_voltage_switch = sdmmc_switch_voltage,
+	.card_busy = sdmmc_card_busy,
 	.execute_tuning = sdmmc_execute_tuning,
 	.init_sd_express = sdmmc_init_sd_express,
 };


