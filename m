Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FF71CA8F;
	Mon,  1 Apr 2024 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987532; cv=none; b=I9ptxiErM04XW3IgqEUE2JqT0pNhkIFasBudQQS6gMKJd0CZ5pkEomzJf0BEFZHiAq9FcPe24j0lB/4QXM+zvAlF2IY4rlX1mHbDq3MYrD4BjEljy8B+BzgeE5S9GlLQ9/o+31+SfPvtospzKBLNcT7j7kxHqHEnvb19OXzyay4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987532; c=relaxed/simple;
	bh=+UWCiIt0wBUjc1VbYlWeNp8dt1D4M9GcNp7h+4XlI6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqNIIwwS0voGxomRe0VViSc/h+WnRX2o873xEUf5Z2ZqeoXMcKDHVfR/q2kBAmAxVhX73fnUzB4Gz+d5ep2JGLW1kVc1DCWCesGVsDtt2Bv1oRZ+oxaYHvYOniRrrGYMGL4Mi4Dix4fcApFijVIUwooGru8EkWkAMr96xbfonuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrFp+cLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrFp+cLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6681C433F1;
	Mon,  1 Apr 2024 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987532;
	bh=+UWCiIt0wBUjc1VbYlWeNp8dt1D4M9GcNp7h+4XlI6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrFp+cLHqneyCoWgf60AVRD783mgefHnesJrJJ+htrflFtcXSdFnRKkVqewIeSTYM
	 wO+Owo9IMr/hNzB9F7ylzqu8mYRr8DKeUt0QTLJ63QVobvnxhkdIp3tHgZ+Md1wMft
	 XZ+GAhJY4toMRh+7w5QRN5URda2uZNtB9AEz4nMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Liming Sun <limings@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.8 315/399] sdhci-of-dwcmshc: disable PM runtime in dwcmshc_remove()
Date: Mon,  1 Apr 2024 17:44:41 +0200
Message-ID: <20240401152558.588045429@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -933,6 +933,17 @@ free_pltfm:
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
@@ -940,8 +951,14 @@ static void dwcmshc_remove(struct platfo
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
@@ -1032,17 +1049,6 @@ static void dwcmshc_enable_card_clk(stru
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


