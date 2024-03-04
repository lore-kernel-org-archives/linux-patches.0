Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55F31F60A;
	Mon,  4 Mar 2024 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587821; cv=none; b=Vf7rvrbWko/iUJ6Vk1qZM3rtQna/6NXx40OMYTP5p/IZJ+DHvx9qAbYp0uAUvomALw2K2gWRDdLEBmFCLgOLOYx1KgfxmjCfZkRndPYi+1to+j6PU1DAzAvQf45wDzpkgM+2Faj4l2b49o81C2i+x2P4cf83j9Psm5GrsogYaNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587821; c=relaxed/simple;
	bh=VGtHZuFqRTcDE3HqpwHbI+T81K5wpPpBqrAOTEqrIx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UliFb7Mai3+TyF131A6QYjLB/kpErrNBqJlA1VxQWd1MOTiaDjAhYHg4wIUDy2TJcpd8dSQhcixHVTyEvlw8fVmoCua22PnTGbckkTCsY7Cjm5BkBid0kIcPMynIFtQ82PxutOQSrZFLmcapNX5o6wc04LpQrxZeNiDVodeRKxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZ5fpk1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZ5fpk1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B43FC433C7;
	Mon,  4 Mar 2024 21:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587821;
	bh=VGtHZuFqRTcDE3HqpwHbI+T81K5wpPpBqrAOTEqrIx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZ5fpk1sqa+QmxlUjLE8rPiuT0/M9Et2nuMP5yhEkW3KOcJc10pkEcpDkkt9xl+XV
	 zkyBI/2xHHOAE1jeBjxqdb+zsE+4C9CR0/qCGafgomi+HOr01xg/FjvABt66clPBIa
	 DSqSEL748TpoPKQvA3y4vNVV12WKKHLTt3DMI+HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Elad Nachman <enachman@marvell.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 103/162] mmc: sdhci-xenon: fix PHY init clock stability
Date: Mon,  4 Mar 2024 21:22:48 +0000
Message-ID: <20240304211555.111155510@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elad Nachman <enachman@marvell.com>

commit 8e9f25a290ae0016353c9ea13314c95fb3207812 upstream.

Each time SD/mmc phy is initialized, at times, in some of
the attempts, phy fails to completes its initialization
which results into timeout error. Per the HW spec, it is
a pre-requisite to ensure a stable SD clock before a phy
initialization is attempted.

Fixes: 06c8b667ff5b ("mmc: sdhci-xenon: Add support to PHYs of Marvell Xenon SDHC")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Elad Nachman <enachman@marvell.com>
Link: https://lore.kernel.org/r/20240222200930.1277665-1-enachman@marvell.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-xenon-phy.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/mmc/host/sdhci-xenon-phy.c
+++ b/drivers/mmc/host/sdhci-xenon-phy.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/ktime.h>
+#include <linux/iopoll.h>
 #include <linux/of_address.h>
 
 #include "sdhci-pltfm.h"
@@ -218,6 +219,19 @@ static int xenon_alloc_emmc_phy(struct s
 	return 0;
 }
 
+static int xenon_check_stability_internal_clk(struct sdhci_host *host)
+{
+	u32 reg;
+	int err;
+
+	err = read_poll_timeout(sdhci_readw, reg, reg & SDHCI_CLOCK_INT_STABLE,
+				1100, 20000, false, host, SDHCI_CLOCK_CONTROL);
+	if (err)
+		dev_err(mmc_dev(host->mmc), "phy_init: Internal clock never stabilized.\n");
+
+	return err;
+}
+
 /*
  * eMMC 5.0/5.1 PHY init/re-init.
  * eMMC PHY init should be executed after:
@@ -234,6 +248,11 @@ static int xenon_emmc_phy_init(struct sd
 	struct xenon_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	struct xenon_emmc_phy_regs *phy_regs = priv->emmc_phy_regs;
 
+	int ret = xenon_check_stability_internal_clk(host);
+
+	if (ret)
+		return ret;
+
 	reg = sdhci_readl(host, phy_regs->timing_adj);
 	reg |= XENON_PHY_INITIALIZAION;
 	sdhci_writel(host, reg, phy_regs->timing_adj);


