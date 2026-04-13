Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B60306B0A;
	Mon, 13 Apr 2026 16:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097610; cv=none; b=QP6OQV2CQTxYGjl/GUBemF77npuQwyZjLXm8mC0pNMuBbxz19BVgM2R2EO25azMNFEggaFf3skBds6qEjR43YNuosXGUnXwLrIZ22Uu6MgxT31j2dSoNxOseVVgcjmPcRJoffAVovw7NpGQCBeCCzpfQuQgNMRJZHg9eryUHDm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097610; c=relaxed/simple;
	bh=RalkypudCPRBQcfNRSxCwsqU007F0UoBXRhtK/OsMog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5qk3jSdauNxPUENpj/7HxYgNDCA7LB5HQpHVXHDfjKtmR+Nql8v9WDABD4wuBXJlK2K6G0yEqTTKf6idzSthi9ldQMWFtHQwHCV7TNimFGkSlXRNZ4hJCl155x5knO7PJHiChIdpWc7bcB/te4uULb6/8UYVWkpCQLR61+yXuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQFhz/G4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQFhz/G4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD818C2BCAF;
	Mon, 13 Apr 2026 16:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097610;
	bh=RalkypudCPRBQcfNRSxCwsqU007F0UoBXRhtK/OsMog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQFhz/G4DHss53/3ffzEJWZbAHwAMweDEqrWSM+4ztp9H6oeIU0/ZSovvMWQ6Kco8
	 rGyg1ecnbARMQxEG0HZSx46nP1kRo6FNEHeYyizuqtk468Gk64cTDbtLrK86sIhKJh
	 uzehRu4OwOIFm9VCyE1boTHZQCWYDngPyoIrJCEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 204/570] mmc: sdhci: fix timing selection for 1-bit bus width
Date: Mon, 13 Apr 2026 17:55:35 +0200
Message-ID: <20260413155838.100897194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Luke Wang <ziniu.wang_1@nxp.com>

commit 5e3486e64094c28a526543f1e8aa0d5964b7f02d upstream.

When 1-bit bus width is used with HS200/HS400 capabilities set,
mmc_select_hs200() returns 0 without actually switching. This
causes mmc_select_timing() to skip mmc_select_hs(), leaving eMMC
in legacy mode (26MHz) instead of High Speed SDR (52MHz).

Per JEDEC eMMC spec section 5.3.2, 1-bit mode supports High Speed
SDR. Drop incompatible HS200/HS400/UHS/DDR caps early so timing
selection falls through to mmc_select_hs() correctly.

Fixes: f2119df6b764 ("mmc: sd: add support for signal voltage switch procedure")
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -4454,8 +4454,15 @@ int sdhci_setup_host(struct sdhci_host *
 	 * their platform code before calling sdhci_add_host(), and we
 	 * won't assume 8-bit width for hosts without that CAP.
 	 */
-	if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
+	if (host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA) {
+		host->caps1 &= ~(SDHCI_SUPPORT_SDR104 | SDHCI_SUPPORT_SDR50 | SDHCI_SUPPORT_DDR50);
+		if (host->quirks2 & SDHCI_QUIRK2_CAPS_BIT63_FOR_HS400)
+			host->caps1 &= ~SDHCI_SUPPORT_HS400;
+		mmc->caps2 &= ~(MMC_CAP2_HS200 | MMC_CAP2_HS400 | MMC_CAP2_HS400_ES);
+		mmc->caps &= ~(MMC_CAP_DDR | MMC_CAP_UHS);
+	} else {
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
+	}
 
 	if (host->quirks2 & SDHCI_QUIRK2_HOST_NO_CMD23)
 		mmc->caps &= ~MMC_CAP_CMD23;


