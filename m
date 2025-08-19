Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B623043CD;
	Tue, 19 Aug 2025 17:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624546; cv=none; b=aoyfnnxVDtLMKLZwE4jGFTsIMd7nCoCqYtXTUST6d2FSb08YUHF7iXe1opqjTmPcxGlLYETE/SQ4IpcWqzm/N15dN5xhN5t6/JB2KdeyzKfwUYnVouUO+RepsVadb2q7mO+SgyywuDTRHQEH0enOfncD1ixDfiZw2R30xb6GEVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624546; c=relaxed/simple;
	bh=W9oMV0mmx9xPCzXf2g5cR/aqTcge9n/7vAa04NaiQII=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gZtgFv49GkyNW/uDqnVmfsd8Xuepanqa9f9E0EYmIa/1ijHTscYZAEEnSP+maVdstK0FwEMVf2LZJC9AEHnZJ1eJFvn9NdeVRsOP1LzJbQXkRXOGluWXoUj88bHcr6yYCBqjosm4pILaCB/uiWbexxDyZzo1840teFJHJlopCpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvjdT0t6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvjdT0t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF58DC113D0;
	Tue, 19 Aug 2025 17:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755624545;
	bh=W9oMV0mmx9xPCzXf2g5cR/aqTcge9n/7vAa04NaiQII=;
	h=From:Date:Subject:To:Cc:From;
	b=kvjdT0t65vzZJbPLSVQn9dCr56soWZj8hjKjAAeKU3Yyf6vmxD4SlKqfSZha02Gf9
	 34xENmtPV427k6OUzB9nvwBgSjRsL5DchADwC31h9CCdNze5zV2kTPRhCZzvxQ7gon
	 GsbOJdYzmXz4ctTybyzyBfYzvxmzimvR76XcLoM9miFm5UWCPFCvZVZ3Kckkpjx1hS
	 qNkgm5ySGXb0IZ2ppaXG7DLyCzBzpMOdXBCXPtoaA7OY4GGUgVzUxA4UsLTQ/KpPrp
	 cWwEgjCcmewyTghlJHsJqrNiRLKdKIQx8cnoeHYyIdPnSSlpew4h+MvVfU8KB68MQX
	 b5LBTddjqGqHg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 19 Aug 2025 10:28:49 -0700
Subject: [PATCH] mmc: sdhci-cadence: Fix -Wuninitialized in
 sdhci_cdns_tune_blkgap()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-v1-1-94aa2d0c438a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFC0pGgC/x2NywrCQAwAf6XkbKC79dH6K0VKTaKbw6ayUSmU/
 ruLx4FhZgOXouJwbTYo8lXXxSqEQwOUZnsKKleG2MZT24cBcyZ0TqRIM4uR4ENX/JiavjEV7y5
 TXliQKMTjme7dwD3U2qtIFf+n8bbvP16Uvvh5AAAA
X-Change-ID: 20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-cc1246cb39d8
To: Adrian Hunter <adrian.hunter@intel.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>
Cc: =?utf-8?q?Beno=C3=AEt_Monin?= <benoit.monin@bootlin.com>, 
 linux-mmc@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1843; i=nathan@kernel.org;
 h=from:subject:message-id; bh=W9oMV0mmx9xPCzXf2g5cR/aqTcge9n/7vAa04NaiQII=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBlLtsQX2pzS3GpwUNRyrrDbnv4rc+Zdvt9gyzLv/oXeB
 5ybdeJmdZSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJnH3D8E8/hmfj4enn5n+z
 +Hs06GDcRIVHvC+X2hzj+mXVoTvt2AN7hn8aNzduNzIwU4uTZ8hTOHFygyV7xP17uhYvrggfWCL
 NJMIAAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  drivers/mmc/host/sdhci-cadence.c:297:9: error: variable 'hrs37_mode' is uninitialized when used here [-Werror,-Wuninitialized]
    297 |         writel(hrs37_mode, hrs37_reg);
        |                ^~~~~~~~~~
  drivers/mmc/host/sdhci-cadence.c:291:16: note: initialize the variable 'hrs37_mode' to silence this warning
    291 |         u32 hrs37_mode;
        |                       ^
        |                        = 0

A previous revision assigned SDHCI_CDNS_HRS37_MODE_MMC_HS200 to
hrs37_mode in a switch statement but the final revision moved to a
simple if statement. Pass that as the value to writel() and
remove hrs37_mode, clearing up the warning.

Fixes: 60613a8b9b81 ("mmc: sdhci-cadence: implement multi-block read gap tuning")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/mmc/host/sdhci-cadence.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-cadence.c b/drivers/mmc/host/sdhci-cadence.c
index a2a4a5b0ab96..eaa88897a256 100644
--- a/drivers/mmc/host/sdhci-cadence.c
+++ b/drivers/mmc/host/sdhci-cadence.c
@@ -288,13 +288,12 @@ static int sdhci_cdns_tune_blkgap(struct mmc_host *mmc)
 	void __iomem *hrs38_reg = priv->hrs_addr + SDHCI_CDNS_HRS38;
 	int ret;
 	u32 gap;
-	u32 hrs37_mode;
 
 	/* Currently only needed in HS200 mode */
 	if (host->timing != MMC_TIMING_MMC_HS200)
 		return 0;
 
-	writel(hrs37_mode, hrs37_reg);
+	writel(SDHCI_CDNS_HRS37_MODE_MMC_HS200, hrs37_reg);
 
 	for (gap = 0; gap <= SDHCI_CDNS_HRS38_BLKGAP_MAX; gap++) {
 		writel(gap, hrs38_reg);

---
base-commit: 7138017038c42feb682445407974ed736e1ff308
change-id: 20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-cc1246cb39d8

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

