Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F370630569A;
	Fri, 15 May 2026 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860803; cv=none; b=OZYJ/uH66ymIblhhWv1MaxV9G2OlzTD41+b/lY8JCgdd8Yj5M1Npea8QOyLEVylesw6JC3iVi2LxPbVIzXdDWuVfKE38pb9zNDYoCzC5gLExXqKcl1b5+LLNTTjSY/r5eQlQaHWCtO9EMe4AtHgGq47Rnft3p+iRcwHTO36IJg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860803; c=relaxed/simple;
	bh=zrREpSnPOSBz510rN+bfyehzlBJwHUszH/tuNS3P4yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvcDcJVXaGAXZ85C/dNngNhmWHXDp4i2wMYuceZ0QfwSaTgeyiyAOhpIY60rqefDwg6uSvaCEE/EubhkOb4dakKkH1lUPqwzZ1NdTb9lIFYStr03wIzeeLwHGIGkqQLRRQcP8W4uHbWjyKVX5rMjQ+PFEXH8MRNHgitOt6yDgaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atVX0aCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atVX0aCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C43C2BCB3;
	Fri, 15 May 2026 16:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860802;
	bh=zrREpSnPOSBz510rN+bfyehzlBJwHUszH/tuNS3P4yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atVX0aCOkzavk2HpQDB2Q0hAj7N6/ppdHIrppbf4L5bc5Wt3Q30d6OEC3UKVL7FIR
	 cxQZCgnQ20rpe6vf5/CyE7Ip/uP6Z3UKki2wIYYzg73NEPmacHhH3kk2PyNx5or+bA
	 ifdgapaz47ZaA1l5EZJxdU5o7qZWjRwW3PuktvWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 085/474] mmc: sdhci-of-dwcmshc: Disable clock before DLL configuration
Date: Fri, 15 May 2026 17:43:14 +0200
Message-ID: <20260515154716.877679896@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -243,12 +243,15 @@ static void dwcmshc_rk3568_set_clock(str
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
@@ -268,7 +271,7 @@ static void dwcmshc_rk3568_set_clock(str
 			DLL_STRBIN_DELAY_NUM_SEL |
 			DLL_STRBIN_DELAY_NUM_DEFAULT << DLL_STRBIN_DELAY_NUM_OFFSET;
 		sdhci_writel(host, extra, DWCMSHC_EMMC_DLL_STRBIN);
-		return;
+		goto enable_clk;
 	}
 
 	/* Reset DLL */
@@ -295,7 +298,7 @@ static void dwcmshc_rk3568_set_clock(str
 				 500 * USEC_PER_MSEC);
 	if (err) {
 		dev_err(mmc_dev(host->mmc), "DLL lock timeout!\n");
-		return;
+		goto enable_clk;
 	}
 
 	extra = 0x1 << 16 | /* tune clock stop en */
@@ -328,6 +331,16 @@ static void dwcmshc_rk3568_set_clock(str
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


