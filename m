Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9D72F83BA;
	Tue, 26 Aug 2025 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217777; cv=none; b=nmOlIhOEou6V759It0tUfGvpIPfThSbm7ie4lUvl9HjzhfPAyhhGjDZsg+PY1scIk6nR/mX2Tt105naJkUS5KK0CPKNXVha+4RbBXRhSeeV2KPUTsbBFLktcS/7YlsuAsSOvdNJKCvGXSEtql49Zmm8ZXufIMqormed1+BtZQv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217777; c=relaxed/simple;
	bh=0Tbw568gDyy+7hAMHgm0ex+nGHi8/Pi8UScwlvcTEyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrwQ4uTZcUgh4XulXywMtPP6234zLMI6ykHKXvVDWG8pNi3tdDYE121WjgOGPkk9rH4CrAivZHq7vk8b+s48i5bp1lcuZv8Py/4W/nghwdGLiHjmQ6/cSqXGxdhOeCCY+pGh4n2cnTqykBnnGkZLKN8ehTVjZphyuXnw51pQHEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzfqG9Z7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzfqG9Z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A589CC4CEF1;
	Tue, 26 Aug 2025 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217777;
	bh=0Tbw568gDyy+7hAMHgm0ex+nGHi8/Pi8UScwlvcTEyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzfqG9Z7H+NMevbdPpBU2aNwxqnxaDo/bB1m9sCkPbYRqJIbevhqF4ZxeAKr94/oZ
	 tcPIqr6hFJWbY34N3H4ncTVZIpbbQlBnBJ8freRsrC4JhasBeihT5UYXeMbHZ+Kar2
	 2FQ5yLA3oG7ea7nERI/VHDcdXvqQ2X8e79dyIbjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarthak Garg <quic_sartgarg@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/523] mmc: sdhci-msm: Ensure SD card power isnt ON when card removed
Date: Tue, 26 Aug 2025 13:07:30 +0200
Message-ID: <20250826110930.362592462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Garg <quic_sartgarg@quicinc.com>

[ Upstream commit db58532188ebf51d52b1d7693d9e94c76b926e9f ]

Many mobile phones feature multi-card tray designs, where the same
tray is used for both SD and SIM cards. If the SD card is placed
at the outermost location in the tray, the SIM card may come in
contact with SD card power-supply while removing the tray, possibly
resulting in SIM damage.

To prevent that, make sure the SD card is really inserted by reading
the Card Detect pin state. If it's not, turn off the power in
sdhci_msm_check_power_status() and also set the BUS_FAIL power state
on the controller as part of pwr_irq handling for BUS_ON request.

Signed-off-by: Sarthak Garg <quic_sartgarg@quicinc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250701100659.3310386-1-quic_sartgarg@quicinc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-msm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index c9298a986ef0..183617d56b44 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1544,6 +1544,7 @@ static void sdhci_msm_check_power_status(struct sdhci_host *host, u32 req_type)
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	struct mmc_host *mmc = host->mmc;
 	bool done = false;
 	u32 val = SWITCHABLE_SIGNALING_VOLTAGE;
 	const struct sdhci_msm_offset *msm_offset =
@@ -1601,6 +1602,12 @@ static void sdhci_msm_check_power_status(struct sdhci_host *host, u32 req_type)
 				 "%s: pwr_irq for req: (%d) timed out\n",
 				 mmc_hostname(host->mmc), req_type);
 	}
+
+	if ((req_type & REQ_BUS_ON) && mmc->card && !mmc->ops->get_cd(mmc)) {
+		sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
+		host->pwr = 0;
+	}
+
 	pr_debug("%s: %s: request %d done\n", mmc_hostname(host->mmc),
 			__func__, req_type);
 }
@@ -1659,6 +1666,13 @@ static void sdhci_msm_handle_pwr_irq(struct sdhci_host *host, int irq)
 		udelay(10);
 	}
 
+	if ((irq_status & CORE_PWRCTL_BUS_ON) && mmc->card &&
+	    !mmc->ops->get_cd(mmc)) {
+		msm_host_writel(msm_host, CORE_PWRCTL_BUS_FAIL, host,
+				msm_offset->core_pwrctl_ctl);
+		return;
+	}
+
 	/* Handle BUS ON/OFF*/
 	if (irq_status & CORE_PWRCTL_BUS_ON) {
 		pwr_state = REQ_BUS_ON;
-- 
2.39.5



