Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7560466B5E;
	Tue, 16 Jun 2026 18:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634528; cv=none; b=FBhj1xs9RDGWZrRTdVhVBbnFx9T082z4AeVeJDfD5IcyJWsnljWxWIiASY8SB1rLq4Bz13Zm9yanF8LaKTqrLkY/qPc8rn+P8oatAWPSv3GNaM1sGPIi1lS2hBB0taCVBltQCnZnEVind9iO/cUwtRVp3AEBq8uK/GmgspFY7ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634528; c=relaxed/simple;
	bh=dNBjmBoGZyThkA8W1+mLbLg2GKdTh4GpENpxNbuAa8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMmPJwsNpCt0QaYB5K9Z+EyYK9EFSXvfojLNYSkEq4EXu5OrrsldZUk+zWhK4290/MX9wCjTQTqVlfabUSZElJAP1FoSiZhf1yNsyvKQHQ+I9zRzV5z4jebwXnJV+8y4lYA1LllKO7jza8R5+wktq91HxVJibTNk470SUn/5oY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaYE1OQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaYE1OQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C616A1F000E9;
	Tue, 16 Jun 2026 18:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634527;
	bh=vgeSvnw6gDrNOUdNIjQYt2RVFfJRKylw3p60IIA9gbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaYE1OQs4LQcOz1lpYB/ldXmsPU6WmNhDZxZzqNOgLwYlY1eDTschv9fI0e2mQAuo
	 UemC0B0ryOrzXdAQvsvLrNV0jUGDFowiCZxuc0XbsBJpfIAESQFcXnNg93+NaYBqCv
	 xfKr7d2MEU+gvbLiuRwjtR921pfQr12zqpqGcHBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/411] mmc: sdhci-of-dwcmshc: Disable clock before DLL configuration
Date: Tue, 16 Jun 2026 20:28:40 +0530
Message-ID: <20260616145116.142166448@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 6546a49bbe656981d99a389195560999058c89c4 ]

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
[ dropped HS200/HS400 block and BIT(4) line, converted the single `return` in `if (clock <= 400000)` to `goto enable_clk` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -213,10 +213,13 @@ static void dwcmshc_rk3568_set_clock(str
 	extra &= ~BIT(0);
 	sdhci_writel(host, extra, reg);
 
+	/* Disable clock while config DLL */
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+
 	if (clock <= 400000) {
 		/* Disable DLL to reset sample clock */
 		sdhci_writel(host, 0, DWCMSHC_EMMC_DLL_CTRL);
-		return;
+		goto enable_clk;
 	}
 
 	/* Reset DLL */
@@ -234,7 +237,7 @@ static void dwcmshc_rk3568_set_clock(str
 				 500 * USEC_PER_MSEC);
 	if (err) {
 		dev_err(mmc_dev(host->mmc), "DLL lock timeout!\n");
-		return;
+		goto enable_clk;
 	}
 
 	extra = 0x1 << 16 | /* tune clock stop en */
@@ -255,6 +258,16 @@ static void dwcmshc_rk3568_set_clock(str
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


