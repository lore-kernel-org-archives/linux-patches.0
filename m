Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9058C306B0A;
	Mon, 13 Apr 2026 16:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097607; cv=none; b=lw0LsSpJorvWHHg2cUfGkdYIHbfKK/Xw7dedYKDEOGenk2olhprZC8YmTHiMmnzZl3+HAdpPqxaC5ITuDwua6Jd5FPYGsacNllN54eFQR+Hoap/UYIRemJLn2cLK0mf7PR2RpXlgRIpxmMI7i1fRM/oJBZtVph/xftK6m5XHwLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097607; c=relaxed/simple;
	bh=VlEUnKen1HMQC+pcre0yQD8Dy9QB1Rywk2cmJKMKziU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z77Ov2d6W0DKTcgcZAGbAc9pGSAyqi/BNL8HfyJZva1KdONXWK4w9OREDdq8khAtURZK7MRPOFAh5uDhB4gciZ/ImGQX4eEi6pTdmUZyW46Y7DPJEhf92swV+merTrI0KPzANXwT/sKN7uih0F1yjDn7P7x/H8aDiF19U/hORoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pc7ttohh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pc7ttohh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279FFC2BCAF;
	Mon, 13 Apr 2026 16:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097607;
	bh=VlEUnKen1HMQC+pcre0yQD8Dy9QB1Rywk2cmJKMKziU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pc7ttohhXJWKTrDwwYFiQ+HP8xG2bEaHG33HGL9jl0tlwnCyzEC2dLV7Ge5H1ybFe
	 BNZHQUJErAwP/x2J/JtDPMS+YYf7u4Nofhqcp9qWnbHnqdx+4IRF2/mbYD52smHpH8
	 R6OTyTNqeHacYEatRFegAg/rU9BqVhkH7uPJrtJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 203/570] mmc: sdhci-pci-gli: fix GL9750 DMA write corruption
Date: Mon, 13 Apr 2026 17:55:34 +0200
Message-ID: <20260413155838.064070948@linuxfoundation.org>
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
@@ -70,6 +70,9 @@
 #define   GLI_9750_MISC_RX_INV_VALUE     GLI_9750_MISC_RX_INV_OFF
 #define   GLI_9750_MISC_TX1_DLY_VALUE    0x5
 
+#define SDHCI_GLI_9750_GM_BURST_SIZE		  0x510
+#define   SDHCI_GLI_9750_GM_BURST_SIZE_R_OSRC_LMT  GENMASK(17, 16)
+
 #define SDHCI_GLI_9750_TUNING_CONTROL	          0x540
 #define   SDHCI_GLI_9750_TUNING_CONTROL_EN          BIT(4)
 #define   GLI_9750_TUNING_CONTROL_EN_ON             0x1
@@ -188,10 +191,16 @@ static void gli_set_9750(struct sdhci_ho
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


