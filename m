Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B0C1C28E;
	Tue, 11 Nov 2025 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822809; cv=none; b=kh5VKwjyr6TJCKyiZ8nQLUouNsQ3QtzxexOz/YK1PxbBpWew5rPi1NNDRJtzlUJeND+7bQQPH8n+yNLQudk69nc3mT3JwbVWAjpc6iaIX40hubaQILPYrfbAe/Q5qXoHqI1WudtGIgx+7DNUNYd8PxMRt0NyZkv2YYbyVk9hQ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822809; c=relaxed/simple;
	bh=nHdXDrNimmdepIewviz/9Z5UzMFkgRk6tkS/NSS7MKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ry9ls9TQp7vxtxTSYb5gcWTJr9oiHgeRhZVfsfVXjzZ+UbyCd5BezL4QZMkRMrqcQV5aeaxPxOvGAEM/gNlw2WXpTVgh09+MARxZGU3ceHvEOoulEVMxGlKKIHSlTqWw3NveFOJk2NowyD1on2p5BMTLqJyiygtzKqD2MtBsgu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGnjkDFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGnjkDFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7987C113D0;
	Tue, 11 Nov 2025 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822808;
	bh=nHdXDrNimmdepIewviz/9Z5UzMFkgRk6tkS/NSS7MKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGnjkDFbcssTe0agm7FsQheiMmS2HWaMye/JOTA8iIv7iPzAI3C75ESfOreAy3j97
	 Dn/xsuhYtsF+dH2LmxytzS82K5rTUuZVcxBiqE7pBgl9m5a2RoGgZ2t5aZ/gXGWAF8
	 IYZO/f77mH9tX/OEMrml+hf2qubisdiNHaCG+X9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarthak Garg <quic_sartgarg@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 175/849] mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card
Date: Tue, 11 Nov 2025 09:35:45 +0900
Message-ID: <20251111004540.664345790@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 9d8e20dc8ca11..e7df864bdcaf6 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -81,6 +81,7 @@
 #define CORE_IO_PAD_PWR_SWITCH_EN	BIT(15)
 #define CORE_IO_PAD_PWR_SWITCH	BIT(16)
 #define CORE_HC_SELECT_IN_EN	BIT(18)
+#define CORE_HC_SELECT_IN_SDR50	(4 << 19)
 #define CORE_HC_SELECT_IN_HS400	(6 << 19)
 #define CORE_HC_SELECT_IN_MASK	(7 << 19)
 
@@ -1133,6 +1134,10 @@ static bool sdhci_msm_is_tuning_needed(struct sdhci_host *host)
 {
 	struct mmc_ios *ios = &host->mmc->ios;
 
+	if (ios->timing == MMC_TIMING_UHS_SDR50 &&
+	    host->flags & SDHCI_SDR50_NEEDS_TUNING)
+		return true;
+
 	/*
 	 * Tuning is required for SDR104, HS200 and HS400 cards and
 	 * if clock frequency is greater than 100MHz in these modes.
@@ -1201,6 +1206,8 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	struct mmc_ios ios = host->mmc->ios;
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	const struct sdhci_msm_offset *msm_offset = msm_host->offset;
+	u32 config;
 
 	if (!sdhci_msm_is_tuning_needed(host)) {
 		msm_host->use_cdr = false;
@@ -1217,6 +1224,14 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
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



