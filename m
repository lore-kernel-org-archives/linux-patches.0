Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F177E6FAF;
	Tue,  5 Dec 2023 03:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSpcyI/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5259CC433C7;
	Tue,  5 Dec 2023 03:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746975;
	bh=b3+lmaKdP1hEN1sofGEGvBsbiByrQjP57+irO1ntGa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSpcyI/WMo86ZgcVKQA2VpSMM38odQTZHCAYoa9rsJUqmbIsDMLDbD37rmik8swlm
	 B6kiEVh60y2Wj8hsR0eR6Gz9ufNhqNM7iTr53hYZA4rksXzeJJRPQYJHvNtFrKZ9XC
	 0qDEIKhsg9mVIB5DLHEnlJutbDUZXYkExIElbRBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kornel=20Dul=C4=99ba?= <korneld@chromium.org>,
	Sven van Ashbrook <svenva@chromium.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 006/107] mmc: sdhci-pci-gli: Disable LPM during initialization
Date: Tue,  5 Dec 2023 12:15:41 +0900
Message-ID: <20231205031531.912808171@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kornel Dulęba <korneld@chromium.org>

commit d9ed644f58670865cf067351deb71010bd87a52f upstream.

To address IO performance commit f9e5b33934ce
("mmc: host: Improve I/O read/write performance for GL9763E")
limited LPM negotiation to runtime suspend state.
The problem is that it only flips the switch in the runtime PM
resume/suspend logic.

Disable LPM negotiation in gl9763e_add_host.
This helps in two ways:
1. It was found that the LPM switch stays in the same position after
   warm reboot. Having it set in init helps with consistency.
2. Disabling LPM during the first runtime resume leaves us susceptible
   to the performance issue in the time window between boot and the
   first runtime suspend.

Fixes: f9e5b33934ce ("mmc: host: Improve I/O read/write performance for GL9763E")
Cc: stable@vger.kernel.org
Signed-off-by: Kornel Dulęba <korneld@chromium.org>
Reviewed-by: Sven van Ashbrook <svenva@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20231114115516.1585361-1-korneld@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |   54 ++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -801,6 +801,32 @@ static void gl9763e_hs400_enhanced_strob
 	sdhci_writel(host, val, SDHCI_GLI_9763E_HS400_ES_REG);
 }
 
+static void gl9763e_set_low_power_negotiation(struct sdhci_pci_slot *slot,
+					      bool enable)
+{
+	struct pci_dev *pdev = slot->chip->pdev;
+	u32 value;
+
+	pci_read_config_dword(pdev, PCIE_GLI_9763E_VHS, &value);
+	value &= ~GLI_9763E_VHS_REV;
+	value |= FIELD_PREP(GLI_9763E_VHS_REV, GLI_9763E_VHS_REV_W);
+	pci_write_config_dword(pdev, PCIE_GLI_9763E_VHS, value);
+
+	pci_read_config_dword(pdev, PCIE_GLI_9763E_CFG, &value);
+
+	if (enable)
+		value &= ~GLI_9763E_CFG_LPSN_DIS;
+	else
+		value |= GLI_9763E_CFG_LPSN_DIS;
+
+	pci_write_config_dword(pdev, PCIE_GLI_9763E_CFG, value);
+
+	pci_read_config_dword(pdev, PCIE_GLI_9763E_VHS, &value);
+	value &= ~GLI_9763E_VHS_REV;
+	value |= FIELD_PREP(GLI_9763E_VHS_REV, GLI_9763E_VHS_REV_R);
+	pci_write_config_dword(pdev, PCIE_GLI_9763E_VHS, value);
+}
+
 static void sdhci_set_gl9763e_signaling(struct sdhci_host *host,
 					unsigned int timing)
 {
@@ -909,6 +935,9 @@ static int gl9763e_add_host(struct sdhci
 	if (ret)
 		goto cleanup;
 
+	/* Disable LPM negotiation to avoid entering L1 state. */
+	gl9763e_set_low_power_negotiation(slot, false);
+
 	return 0;
 
 cleanup:
@@ -960,31 +989,6 @@ static void gli_set_gl9763e(struct sdhci
 }
 
 #ifdef CONFIG_PM
-static void gl9763e_set_low_power_negotiation(struct sdhci_pci_slot *slot, bool enable)
-{
-	struct pci_dev *pdev = slot->chip->pdev;
-	u32 value;
-
-	pci_read_config_dword(pdev, PCIE_GLI_9763E_VHS, &value);
-	value &= ~GLI_9763E_VHS_REV;
-	value |= FIELD_PREP(GLI_9763E_VHS_REV, GLI_9763E_VHS_REV_W);
-	pci_write_config_dword(pdev, PCIE_GLI_9763E_VHS, value);
-
-	pci_read_config_dword(pdev, PCIE_GLI_9763E_CFG, &value);
-
-	if (enable)
-		value &= ~GLI_9763E_CFG_LPSN_DIS;
-	else
-		value |= GLI_9763E_CFG_LPSN_DIS;
-
-	pci_write_config_dword(pdev, PCIE_GLI_9763E_CFG, value);
-
-	pci_read_config_dword(pdev, PCIE_GLI_9763E_VHS, &value);
-	value &= ~GLI_9763E_VHS_REV;
-	value |= FIELD_PREP(GLI_9763E_VHS_REV, GLI_9763E_VHS_REV_R);
-	pci_write_config_dword(pdev, PCIE_GLI_9763E_VHS, value);
-}
-
 static int gl9763e_runtime_suspend(struct sdhci_pci_chip *chip)
 {
 	struct sdhci_pci_slot *slot = chip->slots[0];


