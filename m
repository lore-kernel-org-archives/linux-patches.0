Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE3E4D584;
	Mon,  1 Apr 2024 16:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990402; cv=none; b=bzscoxH2Cskul20m1o7q9CYOec6NQdaQH12NwdlGwCy8c73Cjs0HF24TTYmKzEzQMDkRsN86k1VMcrjSBrkTszdvx1Qdrn5D1ga9XfxMR0dIb/0W0JWk6ESx8IuHi3Ed2N3ADaCtwncN8b91oxbwul9Cifes4sZqtVSW0NWvMNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990402; c=relaxed/simple;
	bh=JDpRSVY3kAkdlSk1wAWCgfb7bMKYRn390OWDoHrjA4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jExAAvmdp3xetz2Iq4pTW0uGmWlHlFv1ZpAiTeK+R2q+J1ZIEToiwIHsWpXBaART42uM5ivQ61WKnw2ozrd5hEznKkV/Dwn2spn/c+VbVluWnsjSH0BTy513xHfOm6fptMP/m3RpgIrvjytG9LK0zCkQZF1QySLIs3VAk00tddU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVXszQoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVXszQoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F26C433F1;
	Mon,  1 Apr 2024 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990402;
	bh=JDpRSVY3kAkdlSk1wAWCgfb7bMKYRn390OWDoHrjA4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVXszQoeioRPN6QeSrfp5Y/ESEznjiaZ6k+J7XIIbD3Unv/h2OSJAi9ohOGrNFLxk
	 BRgD384pj50ILB6IHhgBdiO1fwAGvq7RTrEQKxFU5G/MYy+p4vZngL8patQsRQ80Ai
	 kJUvi03872/V2xefnzuWSGyvEsuzC/5upNbzsnKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Liming Sun <limings@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 334/396] sdhci-of-dwcmshc: disable PM runtime in dwcmshc_remove()
Date: Mon,  1 Apr 2024 17:46:23 +0200
Message-ID: <20240401152557.872192083@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liming Sun <limings@nvidia.com>

commit 03749309909935070253accab314288d332a204d upstream.

This commit disables PM runtime in dwcmshc_remove() to avoid the
error message below when reloading the sdhci-of-dwcmshc.ko

  sdhci-dwcmshc MLNXBF30:00: Unbalanced pm_runtime_enable!

Fixes: 48fe8fadbe5e ("mmc: sdhci-of-dwcmshc: Add runtime PM operations")
Reviewed-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Liming Sun <limings@nvidia.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/b9155963ffb12d18375002bf9ac9a3f98b727fc8.1710854108.git.limings@nvidia.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-of-dwcmshc.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -584,6 +584,17 @@ free_pltfm:
 	return err;
 }
 
+static void dwcmshc_disable_card_clk(struct sdhci_host *host)
+{
+	u16 ctrl;
+
+	ctrl = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
+	if (ctrl & SDHCI_CLOCK_CARD_EN) {
+		ctrl &= ~SDHCI_CLOCK_CARD_EN;
+		sdhci_writew(host, ctrl, SDHCI_CLOCK_CONTROL);
+	}
+}
+
 static void dwcmshc_remove(struct platform_device *pdev)
 {
 	struct sdhci_host *host = platform_get_drvdata(pdev);
@@ -591,8 +602,14 @@ static void dwcmshc_remove(struct platfo
 	struct dwcmshc_priv *priv = sdhci_pltfm_priv(pltfm_host);
 	struct rk35xx_priv *rk_priv = priv->priv;
 
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+
 	sdhci_remove_host(host, 0);
 
+	dwcmshc_disable_card_clk(host);
+
 	clk_disable_unprepare(pltfm_host->clk);
 	clk_disable_unprepare(priv->bus_clk);
 	if (rk_priv)
@@ -683,17 +700,6 @@ static void dwcmshc_enable_card_clk(stru
 		sdhci_writew(host, ctrl, SDHCI_CLOCK_CONTROL);
 	}
 }
-
-static void dwcmshc_disable_card_clk(struct sdhci_host *host)
-{
-	u16 ctrl;
-
-	ctrl = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
-	if (ctrl & SDHCI_CLOCK_CARD_EN) {
-		ctrl &= ~SDHCI_CLOCK_CARD_EN;
-		sdhci_writew(host, ctrl, SDHCI_CLOCK_CONTROL);
-	}
-}
 
 static int dwcmshc_runtime_suspend(struct device *dev)
 {


