Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE31C2511F;
	Fri, 24 Nov 2023 19:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duNvJd1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D545C433C7;
	Fri, 24 Nov 2023 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853708;
	bh=8RDQ3P+pPAN9YhDC4hfDmZysWVJGSYP2mGyv6qSGMJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duNvJd1BHtqPAnUBjAEfci83+7rxk/daTdG1XupvGzkQl1Eyhv1MfAQVnJDEd3N8P
	 fhvdKa5TowQbYJOxADIgpEgI5SC3cOtAMPS1Ye2nZFUpfqsEtr7/23AhBIbzxYptXU
	 bZhaB3eTK7zCquVbjdgV48h66wJgnCtwxQq1Wx2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 272/297] mmc: sdhci-pci-gli: A workaround to allow GL9750 to enter ASPM L1.2
Date: Fri, 24 Nov 2023 17:55:14 +0000
Message-ID: <20231124172009.656398242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Shih <victor.shih@genesyslogic.com.tw>

commit d7133797e9e1b72fd89237f68cb36d745599ed86 upstream.

When GL9750 enters ASPM L1 sub-states, it will stay at L1.1 and will not
enter L1.2. The workaround is to toggle PM state to allow GL9750 to enter
ASPM L1.2.

Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Link: https://lore.kernel.org/r/20230912091710.7797-1-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -23,6 +23,9 @@
 #define   GLI_9750_WT_EN_ON	    0x1
 #define   GLI_9750_WT_EN_OFF	    0x0
 
+#define PCI_GLI_9750_PM_CTRL	0xFC
+#define   PCI_GLI_9750_PM_STATE	  GENMASK(1, 0)
+
 #define SDHCI_GLI_9750_CFG2          0x848
 #define   SDHCI_GLI_9750_CFG2_L1DLY    GENMASK(28, 24)
 #define   GLI_9750_CFG2_L1DLY_VALUE    0x1F
@@ -421,8 +424,12 @@ static void sdhci_gl9750_set_clock(struc
 
 static void gl9750_hw_setting(struct sdhci_host *host)
 {
+	struct sdhci_pci_slot *slot = sdhci_priv(host);
+	struct pci_dev *pdev;
 	u32 value;
 
+	pdev = slot->chip->pdev;
+
 	gl9750_wt_on(host);
 
 	value = sdhci_readl(host, SDHCI_GLI_9750_CFG2);
@@ -432,6 +439,13 @@ static void gl9750_hw_setting(struct sdh
 			    GLI_9750_CFG2_L1DLY_VALUE);
 	sdhci_writel(host, value, SDHCI_GLI_9750_CFG2);
 
+	/* toggle PM state to allow GL9750 to enter ASPM L1.2 */
+	pci_read_config_dword(pdev, PCI_GLI_9750_PM_CTRL, &value);
+	value |= PCI_GLI_9750_PM_STATE;
+	pci_write_config_dword(pdev, PCI_GLI_9750_PM_CTRL, value);
+	value &= ~PCI_GLI_9750_PM_STATE;
+	pci_write_config_dword(pdev, PCI_GLI_9750_PM_CTRL, value);
+
 	gl9750_wt_off(host);
 }
 


