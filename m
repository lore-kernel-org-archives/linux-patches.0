Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E823E33D;
	Mon, 23 Mar 2026 14:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277227; cv=none; b=fej4p7hwXhmdU8Xm+aiXeVZPdMWWcuiTUzE8cosJM8vsGTtSR3+mUnqX0aeBiUx66knjR073tCPaHWIGkqNjK3VDxZGQ+0+H05QsZRWqvI0Vm8ZW9UsBFagavpENXYU+GXI2qdsrj7KHmSl2rKlZyP86GUyk1d4fPH46g9fah6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277227; c=relaxed/simple;
	bh=IRzvck8ZNTivlcSvm+9M6aCmITvlh5Wt7sdPDT9ZjbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/wZgecGIqS1PERIUHRo30GdtHJbVs27GYMbq2mj7zH2tLL67V/scmkiNUiG93+MSWLDpcXLqVPt3ASM3X6XdPaugRTJgmetHZzcXIf71XpRCiMW4lx4rlgoLVwlPxkQ3IGRiQ6L20EavLOWbZPKX6GXD5zcTQ6bfeKAJC7PnhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jaIGSYVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jaIGSYVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766A7C4CEF7;
	Mon, 23 Mar 2026 14:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277226;
	bh=IRzvck8ZNTivlcSvm+9M6aCmITvlh5Wt7sdPDT9ZjbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaIGSYVHscpk466PzhDz8SnO5pgzuAhF8pdKdZlhLzrtYTJicAh7W/Aunezsj81mp
	 3A5fQtz1MJeXa+c3C2pUKqhNaF/eRS3tdJqFLSEc3+9xynuLsibJ3GYRPHGJ6q1voB
	 KdGryEClOvy/vKuSA2YUxZn//MYoM6rf+ht+MEC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 335/460] mmc: sdhci-pci-gli: fix GL9750 DMA write corruption
Date: Mon, 23 Mar 2026 14:45:31 +0100
Message-ID: <20260323134534.762729486@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -67,6 +67,9 @@
 #define   GLI_9750_MISC_TX1_DLY_VALUE    0x5
 #define   SDHCI_GLI_9750_MISC_SSC_OFF    BIT(26)
 
+#define SDHCI_GLI_9750_GM_BURST_SIZE		  0x510
+#define   SDHCI_GLI_9750_GM_BURST_SIZE_R_OSRC_LMT  GENMASK(17, 16)
+
 #define SDHCI_GLI_9750_TUNING_CONTROL	          0x540
 #define   SDHCI_GLI_9750_TUNING_CONTROL_EN          BIT(4)
 #define   GLI_9750_TUNING_CONTROL_EN_ON             0x1
@@ -271,10 +274,16 @@ static void gli_set_9750(struct sdhci_ho
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


