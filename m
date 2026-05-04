Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D590C3E024C;
	Mon,  4 May 2026 14:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904692; cv=none; b=anwlHfN/co8KUfsdRsE6yIVEzWm9vlf03BKE0tSbIc95wvicXkpcHK1UU2OZ4jESW43brofJuCUw/1z2UvmfCLywc/6I6v824ZQhJGRHK2kesRYlcbHCuTJlcds+wXHSCMHvfzMg8xnIPZbjV3yFXqyvae7hkopG5QhyiaFdEfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904692; c=relaxed/simple;
	bh=DJU54BEJ05vm5Tb1lnDlskvt8gLHv3W2Fhgph2MnofM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFu8ydQ6sg1iu2xRUhX+OAFwHw2dn8XSLDy+1TAlH47CKjpaUIiBvt7cY9H1VFJ0qQn00UaIM3Kq25qwYJGE5HgTlCTmWLP5V1YUetbLfpZMqAIJBVtpEGC7t+Dr2iqmSnQaZ3yhQHiMRsND/6Wyh19rqqYF1xaiwcUSIsmfGsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZhJolcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZhJolcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA79C2BCB8;
	Mon,  4 May 2026 14:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904692;
	bh=DJU54BEJ05vm5Tb1lnDlskvt8gLHv3W2Fhgph2MnofM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZhJolcL6c4968CTu93+0aIF5fk5S/mWhXou9RCNDu4PS8tDqBa6Es2bw6Jbh1EHt
	 VCDG80sNKpDba8bmpdoamUWiCBEhIJX72ybZpuv7WU6IwEuagjeLNRpaJ756hQALOz
	 m7PSWu1+o1w9YQDyOYZX8rT6UkO7AGFUSUrjP7rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 104/215] mmc: sdhci-of-dwcmshc: Disable clock before DLL configuration
Date: Mon,  4 May 2026 15:52:03 +0200
Message-ID: <20260504135133.951939470@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 6546a49bbe656981d99a389195560999058c89c4 upstream.

According to the ASIC design recommendations, the clock must be
disabled before operating the DLL to prevent glitches that could
affect the internal digital logic. In extreme cases, failing to
do so may cause the controller to malfunction completely.

Adds a step to disable the clock before DLL configuration and
re-enables it at the end.

Fixes: 08f3dff799d4 ("mmc: sdhci-of-dwcmshc: add rockchip platform support")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -649,12 +649,15 @@ static void dwcmshc_rk3568_set_clock(str
 	extra &= ~BIT(0);
 	sdhci_writel(host, extra, reg);
 
+	/* Disable clock while config DLL */
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+
 	if (clock <= 52000000) {
 		if (host->mmc->ios.timing == MMC_TIMING_MMC_HS200 ||
 		    host->mmc->ios.timing == MMC_TIMING_MMC_HS400) {
 			dev_err(mmc_dev(host->mmc),
 				"Can't reduce the clock below 52MHz in HS200/HS400 mode");
-			return;
+			goto enable_clk;
 		}
 
 		/*
@@ -674,7 +677,7 @@ static void dwcmshc_rk3568_set_clock(str
 			DLL_STRBIN_DELAY_NUM_SEL |
 			DLL_STRBIN_DELAY_NUM_DEFAULT << DLL_STRBIN_DELAY_NUM_OFFSET;
 		sdhci_writel(host, extra, DWCMSHC_EMMC_DLL_STRBIN);
-		return;
+		goto enable_clk;
 	}
 
 	/* Reset DLL */
@@ -701,7 +704,7 @@ static void dwcmshc_rk3568_set_clock(str
 				 500 * USEC_PER_MSEC);
 	if (err) {
 		dev_err(mmc_dev(host->mmc), "DLL lock timeout!\n");
-		return;
+		goto enable_clk;
 	}
 
 	extra = 0x1 << 16 | /* tune clock stop en */
@@ -734,6 +737,16 @@ static void dwcmshc_rk3568_set_clock(str
 		DLL_STRBIN_TAPNUM_DEFAULT |
 		DLL_STRBIN_TAPNUM_FROM_SW;
 	sdhci_writel(host, extra, DWCMSHC_EMMC_DLL_STRBIN);
+
+enable_clk:
+	/*
+	 * The sdclk frequency select bits in SDHCI_CLOCK_CONTROL are not functional
+	 * on Rockchip's SDHCI implementation. Instead, the clock frequency is fully
+	 * controlled via external clk provider by calling clk_set_rate(). Consequently,
+	 * passing 0 to sdhci_enable_clk() only re-enables the already-configured clock,
+	 * which matches the hardware's actual behavior.
+	 */
+	sdhci_enable_clk(host, 0);
 }
 
 static void rk35xx_sdhci_reset(struct sdhci_host *host, u8 mask)


