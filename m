Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204043AEF4E;
	Mon, 23 Mar 2026 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274615; cv=none; b=jkLh06z0kD2Xlv6jJ3Jsrd8ZTuxjgmV9jCIpDIi0dYQCDNsSfHd+I512odNjnndyBHLR3PRhu/AXO76UAMo7qCGNESEgkp9QOvg1tU6KjwIWlK7xoqZMhhQfUtY12M10/uY6EIY7+L/2VAnAwSWju9m4oZx+JVszOpUs7lgn2bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274615; c=relaxed/simple;
	bh=KyrSSWQSwv1WDq79ghrko66jAACPShmKJLiehdOPXrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3nV2FtPgSbfWAPvOjn/KaVu/RBzA7vi6qf4ysb9mLQkMSkIuFw+nCWrr3l5K0E7wixrWoSpMg3j827/YzWSKUupqbOHA2JZMo/OFYzGTmOI7P8GrUGGliZrljSx1Ly8rZPQQ6VnBCO5Ve7JFGhjl4gKM+t7/3aijRXhOrg5ta0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDrl3/zC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDrl3/zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A042C4CEF7;
	Mon, 23 Mar 2026 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274614;
	bh=KyrSSWQSwv1WDq79ghrko66jAACPShmKJLiehdOPXrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDrl3/zCwnDhz8LppFN8x6trRhcwwGRHAjisQcyEzclzIEAMuQ7qMmkVoyLH9LCVa
	 FoNepkasjNovlPoldqQqG+I5T45C6czECUjqzGWgs1EjZhDqddvhYefEjjaRp23+ab
	 QAooYgvQwzopSp5XW+cYK1rR84GfMo7X5YZB2f2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 053/212] mmc: sdhci-pci-gli: fix GL9750 DMA write corruption
Date: Mon, 23 Mar 2026 14:44:34 +0100
Message-ID: <20260323134505.445290263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

commit 2b76e0cc7803e5ab561c875edaba7f6bbd87fbb0 upstream.

The GL9750 SD host controller has intermittent data corruption during
DMA write operations. The GM_BURST register's R_OSRC_Lmt field
(bits 17:16), which limits outstanding DMA read requests from system
memory, is not being cleared during initialization. The Windows driver
sets R_OSRC_Lmt to zero, limiting requests to the smallest unit.

Clear R_OSRC_Lmt to match the Windows driver behavior. This eliminates
write corruption verified with f3write/f3read tests while maintaining
DMA performance.

Cc: stable@vger.kernel.org
Fixes: e51df6ce668a ("mmc: host: sdhci-pci: Add Genesys Logic GL975x support")
Closes: https://lore.kernel.org/linux-mmc/33d12807-5c72-41ce-8679-57aa11831fad@linux.dev/
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -68,6 +68,9 @@
 #define   GLI_9750_MISC_TX1_DLY_VALUE    0x5
 #define   SDHCI_GLI_9750_MISC_SSC_OFF    BIT(26)
 
+#define SDHCI_GLI_9750_GM_BURST_SIZE		  0x510
+#define   SDHCI_GLI_9750_GM_BURST_SIZE_R_OSRC_LMT  GENMASK(17, 16)
+
 #define SDHCI_GLI_9750_TUNING_CONTROL	          0x540
 #define   SDHCI_GLI_9750_TUNING_CONTROL_EN          BIT(4)
 #define   GLI_9750_TUNING_CONTROL_EN_ON             0x1
@@ -345,10 +348,16 @@ static void gli_set_9750(struct sdhci_ho
 	u32 misc_value;
 	u32 parameter_value;
 	u32 control_value;
+	u32 burst_value;
 	u16 ctrl2;
 
 	gl9750_wt_on(host);
 
+	/* clear R_OSRC_Lmt to avoid DMA write corruption */
+	burst_value = sdhci_readl(host, SDHCI_GLI_9750_GM_BURST_SIZE);
+	burst_value &= ~SDHCI_GLI_9750_GM_BURST_SIZE_R_OSRC_LMT;
+	sdhci_writel(host, burst_value, SDHCI_GLI_9750_GM_BURST_SIZE);
+
 	driving_value = sdhci_readl(host, SDHCI_GLI_9750_DRIVING);
 	pll_value = sdhci_readl(host, SDHCI_GLI_9750_PLL);
 	sw_ctrl_value = sdhci_readl(host, SDHCI_GLI_9750_SW_CTRL);


