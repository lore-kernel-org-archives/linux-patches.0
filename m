Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244FD41B37C;
	Wed,  4 Feb 2026 14:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217067; cv=none; b=uBGimB/ZuHeLVbTdYht1NxOHvuUMnx3JWcswK90kuSKVx3nVSjlCWEUBd8C4xq9lWZ7dB85RiZfO/jd7EwAfKPC4725uN0yTgVF9qQDaP+xBIPSWfUPrwlNQS8q3DSyXA/sgRWKSz5Am0qjDEYpdzwYH5/Z4eVZi7ejqnj1Ug4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217067; c=relaxed/simple;
	bh=WhxY5hF5Ny0D1hP6ImfIDzTVkMKYFrP59AquQ3fS+0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nz6J0z0MbwZRqv+518xGquqKqEBvStOfZJ6rXQ8imeoMFwpcXQjhg3D6U5s5pp1H/LqOhDZHfEa8eT9BZiv8QisTAbeZfpIeFBhLNN+hOodsd6Pi/gzU/1e/OiRSensLur52QQv3dMuim2No9xzLFMh19pxrDiZkiv3cIv4e2hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpeyWGD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpeyWGD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B87DC19423;
	Wed,  4 Feb 2026 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217066;
	bh=WhxY5hF5Ny0D1hP6ImfIDzTVkMKYFrP59AquQ3fS+0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpeyWGD6kMpri+PFmEoo10IOW0xgqGQNcmWlffSlVb6hAh9pwitV7uSst9QtmJvZ6
	 BxbY27735GSInHWtblku/5GpG8/Lv0bf3wJ9rY2bqRlkmx9RRKQ/R3SlnZz4Xtysqj
	 Al14lINB4AJNVLh/AeNEakT4vEowA7bKrj/5wTIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ricky WU <ricky_wu@realtek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 113/206] mmc: rtsx_pci_sdmmc: implement sdmmc_card_busy function
Date: Wed,  4 Feb 2026 15:39:04 +0100
Message-ID: <20260204143902.274617862@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1307,6 +1307,46 @@ out:
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
@@ -1405,6 +1445,7 @@ static const struct mmc_host_ops realtek
 	.get_ro = sdmmc_get_ro,
 	.get_cd = sdmmc_get_cd,
 	.start_signal_voltage_switch = sdmmc_switch_voltage,
+	.card_busy = sdmmc_card_busy,
 	.execute_tuning = sdmmc_execute_tuning,
 	.init_sd_express = sdmmc_init_sd_express,
 };


