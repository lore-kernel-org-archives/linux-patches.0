Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E4B311C15;
	Wed,  3 Dec 2025 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777540; cv=none; b=LwKzJsJqwom1BoHhJCRq5APgItGlO6eS+CAjtFx8hI9GEzSygWqYKkhacu9K4tUyK+bmUltVsyF1nccjk+XcwvaQnjKbjAKxzlQv+J3IvJ4pgWOxx/eWzUOZBjnT3O99lBruOjFrd3Cs0/OsylCI7XhY6PDxJQ8oHh/w79l645Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777540; c=relaxed/simple;
	bh=+rn7XJgsjglElo+zn04BrgY0dHpKKA8GYsn02AmY3N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6VUI+0eo/aVtWoLLmwc4Gjogg4zM+FXbyReMfwRaan+t4ZyRW19pYriQydLTN9kD264ziP1i4mqvRLYdmA3xWMUM/PwGEsajf6p5J6tHQRgnMuX2Cb7VaDsaeBuPevwOJzXN4CRzFe686TY6CHAUBIFGqw3x9Eay+8f5UZVjUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2fuJF/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2fuJF/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF9FC4CEF5;
	Wed,  3 Dec 2025 15:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777539;
	bh=+rn7XJgsjglElo+zn04BrgY0dHpKKA8GYsn02AmY3N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2fuJF/MteseN1Dr7u9jk7BQhH3DNsizUvWz/d/PfcGnXKkR9pdJmhzEfZ3DgWi1M
	 3oraz3K7QFdVV2fL1WNHJF0fCqhm+xio0dIz2X00LkymecPRlaTg3SemkK1WME46w9
	 UXNv/zDfrReJIw+160ks4VzvNzgWDFgQdklDFLwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarthak Garg <quic_sartgarg@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/392] mmc: sdhci-msm: Enable tuning for SDR50 mode for SD card
Date: Wed,  3 Dec 2025 16:23:41 +0100
Message-ID: <20251203152416.719986791@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index 8fb2ba20e221b..b4c785393be3c 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -79,6 +79,7 @@
 #define CORE_IO_PAD_PWR_SWITCH_EN	BIT(15)
 #define CORE_IO_PAD_PWR_SWITCH	BIT(16)
 #define CORE_HC_SELECT_IN_EN	BIT(18)
+#define CORE_HC_SELECT_IN_SDR50	(4 << 19)
 #define CORE_HC_SELECT_IN_HS400	(6 << 19)
 #define CORE_HC_SELECT_IN_MASK	(7 << 19)
 
@@ -1129,6 +1130,10 @@ static bool sdhci_msm_is_tuning_needed(struct sdhci_host *host)
 {
 	struct mmc_ios *ios = &host->mmc->ios;
 
+	if (ios->timing == MMC_TIMING_UHS_SDR50 &&
+	    host->flags & SDHCI_SDR50_NEEDS_TUNING)
+		return true;
+
 	/*
 	 * Tuning is required for SDR104, HS200 and HS400 cards and
 	 * if clock frequency is greater than 100MHz in these modes.
@@ -1197,6 +1202,8 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	struct mmc_ios ios = host->mmc->ios;
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
+	const struct sdhci_msm_offset *msm_offset = msm_host->offset;
+	u32 config;
 
 	if (!sdhci_msm_is_tuning_needed(host)) {
 		msm_host->use_cdr = false;
@@ -1213,6 +1220,14 @@ static int sdhci_msm_execute_tuning(struct mmc_host *mmc, u32 opcode)
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



