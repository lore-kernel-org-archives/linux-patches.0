Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA13F3019C6;
	Mon,  1 Dec 2025 11:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588401; cv=none; b=YKOMIW8w+UWtVylhUyknTPttFJ8zIaE+ufIXW05Ikrkg9XP+YbPeHNZeKMCvRrpEC1cNnh3ubBdDraKxEedey8TUXv/Si9joqoBoxgtWzQo75lferN9hOafCr3DDK6H7Y8szLUIADNlOQLeN3LjDAFzawtx6b5uniFkwEJoLq/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588401; c=relaxed/simple;
	bh=d5j1mfJlIAMZQQTF5JR15e9KnqofKqzqDaOoa6KfRw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcVfl1D+xvcl/7AfHjeASHbCUEneLME3Pxm499mBCK7uIZRtybW40BI+36H4nTjBbXVQ21SmGbK4E+5meLYtheTNDDVkRZVlipTDO4lNj0o2vjeZ4qo6gzUGtUbtZmio90xPfHJY17uz8Ba4chy1y5bu10qMUg/50/4IX/1j8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8jrfsH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8jrfsH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75039C116D0;
	Mon,  1 Dec 2025 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588400;
	bh=d5j1mfJlIAMZQQTF5JR15e9KnqofKqzqDaOoa6KfRw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8jrfsH13bvkS3BB62PXYeEhANO0ybOlMsr+Xcx+m/nOOtWqUZ62Us+7OmdOYpZmc
	 KBNbOb86LMLOximkAx9gpOW6EijBkmmrq5Tm1kIYvwcpv3kzaKAUlR5WajLDOmXvMy
	 vKa3T2EzD/KhK5BKxs2ipYgg1rOvQaa2ADeIVI8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarthak Garg <quic_sartgarg@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/187] mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card
Date: Mon,  1 Dec 2025 12:22:23 +0100
Message-ID: <20251201112242.519531049@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Garg <quic_sartgarg@quicinc.com>

[ Upstream commit 08b68ca543ee9d5a8d2dc406165e4887dd8f170b ]

For Qualcomm SoCs which needs level shifter for SD card, extra delay is
seen on receiver data path.

To compensate this delay enable tuning for SDR50 mode for targets which
has level shifter. SDHCI_SDR50_NEEDS_TUNING caps will be set for targets
with level shifter on Qualcomm SOC's.

Signed-off-by: Sarthak Garg <quic_sartgarg@quicinc.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-msm.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 5e6f6c951fd4e..23dda8b2b7f03 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -63,6 +63,7 @@
 #define CORE_IO_PAD_PWR_SWITCH_EN	(1 << 15)
 #define CORE_IO_PAD_PWR_SWITCH  (1 << 16)
 #define CORE_HC_SELECT_IN_EN	BIT(18)
+#define CORE_HC_SELECT_IN_SDR50	(4 << 19)
 #define CORE_HC_SELECT_IN_HS400	(6 << 19)
 #define CORE_HC_SELECT_IN_MASK	(7 << 19)
 
@@ -1034,6 +1035,10 @@ static bool sdhci_msm_is_tuning_needed(struct sdhci_host *host)
 {
 	struct mmc_ios *ios = &host->mmc->ios;
 
+	if (ios->timing == MMC_TIMING_UHS_SDR50 &&
+	    host->flags & SDHCI_SDR50_NEEDS_TUNING)
+		return true;
+
 	/*
 	 * Tuning is required for SDR104, HS200 and HS400 cards and
 	 * if clock frequency is greater than 100MHz in these modes.
@@ -1102,6 +1107,8 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	struct mmc_ios ios = host->mmc->ios;
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	const struct sdhci_msm_offset *msm_offset = msm_host->offset;
+	u32 config;
 
 	if (!sdhci_msm_is_tuning_needed(host)) {
 		msm_host->use_cdr = false;
@@ -1118,6 +1125,14 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	 */
 	msm_host->tuning_done = 0;
 
+	if (ios.timing == MMC_TIMING_UHS_SDR50 &&
+	    host->flags & SDHCI_SDR50_NEEDS_TUNING) {
+		config = readl_relaxed(host->ioaddr + msm_offset->core_vendor_spec);
+		config &= ~CORE_HC_SELECT_IN_MASK;
+		config |= CORE_HC_SELECT_IN_EN | CORE_HC_SELECT_IN_SDR50;
+		writel_relaxed(config, host->ioaddr + msm_offset->core_vendor_spec);
+	}
+
 	/*
 	 * For HS400 tuning in HS200 timing requires:
 	 * - select MCLK/2 in VENDOR_SPEC
-- 
2.51.0



