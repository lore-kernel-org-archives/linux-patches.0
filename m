Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199AA7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F66C433C1;
	Wed,  2 Nov 2022 03:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358083;
	bh=syo4KOhjJrsSf4qkVFJjChOD4MS5LUWT+ntRqqpVvCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4HxdpcC4QHo00Mp1+vwIEWG7XzqkAQvdpsLn0yyFfwEukE0M+ozOc6ExGloyzY66
	 lrrpgt/Tr3SRh6EiI/O6qogS+OeNExbxYiTTwIK7lQmaJ/i3h749ulXZKpyXCgkFH6
	 egmpBViwP4NQVhHZSj716yeRXJ4wnXoFBl/Fcc8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Thompson <ptf@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 038/132] mmc: sdhci-pci-core: Disable ES for ASUS BIOS on Jasper Lake
Date: Wed,  2 Nov 2022 03:32:24 +0100
Message-Id: <20221102022100.632662730@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrick Thompson <ptf@google.com>

commit 9dc0033e4658d6f9d9952c3c0c6be3ec25bc2985 upstream.

Enhanced Strobe (ES) does not work correctly on the ASUS 1100 series of
devices. Jasper Lake eMMCs (pci_id 8086:4dc4) are supposed to support
ES. There are also two system families under the series, thus this is
being scoped to the ASUS BIOS.

The failing ES prevents the installer from writing to disk. Falling back
to HS400 without ES fixes the issue.

Signed-off-by: Patrick Thompson <ptf@google.com>
Fixes: 315e3bd7ac19 ("mmc: sdhci-pci: Add support for Intel JSL")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221013210017.3751025-1-ptf@google.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -978,6 +978,12 @@ static bool glk_broken_cqhci(struct sdhc
 		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
 }
 
+static bool jsl_broken_hs400es(struct sdhci_pci_slot *slot)
+{
+	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_JSL_EMMC &&
+			dmi_match(DMI_BIOS_VENDOR, "ASUSTeK COMPUTER INC.");
+}
+
 static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)
 {
 	int ret = byt_emmc_probe_slot(slot);
@@ -986,9 +992,11 @@ static int glk_emmc_probe_slot(struct sd
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE;
 
 	if (slot->chip->pdev->device != PCI_DEVICE_ID_INTEL_GLK_EMMC) {
-		slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
-		slot->host->mmc_host_ops.hs400_enhanced_strobe =
-						intel_hs400_enhanced_strobe;
+		if (!jsl_broken_hs400es(slot)) {
+			slot->host->mmc->caps2 |= MMC_CAP2_HS400_ES;
+			slot->host->mmc_host_ops.hs400_enhanced_strobe =
+							intel_hs400_enhanced_strobe;
+		}
 		slot->host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
 	}
 


