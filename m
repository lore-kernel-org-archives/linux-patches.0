Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB44026CE33;
	Fri, 21 Nov 2025 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731489; cv=none; b=h0MnOTr6e7QUpEywEIeRmWlLBiVe6ywO0rkNRK1fcH86TMgqco+e69nwrJjSNLXiApKjRHDpwoVaq35qJyDFNsF9pGJOLmuqgp93Nx2TW1IdZTvSk5B+38uxxqXYd3Jsp3eDrINJsnoQ1YHzjynh/GMWQxnYP8OIkXnvHw+0g3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731489; c=relaxed/simple;
	bh=Ll1whMh/J8X4w3qN8KKGdjKDK3qAN2lNecUBqWxKhMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BE2NAvIe3na1pIzfRerXIJPHppT7qb3lgp6c79jkuxP25O3O4bdikL/kJqrV0T4zm1k1Xr4CvC+nE6aSHrJ04Y5mys3mg7qBx744+//g6oj11zCld1n1WZaE3FTPvkGV+tmF8C2IYyxpRxJFS0KVJikXAUVXpArsddwlh1MJAQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtPiZMkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtPiZMkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AD4C4CEF1;
	Fri, 21 Nov 2025 13:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731488;
	bh=Ll1whMh/J8X4w3qN8KKGdjKDK3qAN2lNecUBqWxKhMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtPiZMkqiP9e3HjQFGQQHctnsGMx1S8e2XzFjPdl8VsCtoveWA1v+sr9BUY6ubq8r
	 sYMB0xt8WwLRzUtzfKTtm1mNz7VFZ+sAD7ECzY6e69W/wpUyd8sG6AJW0vwHHpLCXz
	 GmFpB9Cy5o7BGXYF4Dm6O172gJqE50quIQY+WZsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Rakuram Eswaran <rakuram.e96@gmail.com>,
	Khalid Aziz <khalid@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 191/247] mmc: pxamci: Simplify pxamci_probe() error handling using devm APIs
Date: Fri, 21 Nov 2025 14:12:18 +0100
Message-ID: <20251121130201.578663916@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rakuram Eswaran <rakuram.e96@gmail.com>

commit 9e805625218b70d865fcee2105dbf835d473c074 upstream.

This patch refactors pxamci_probe() to use devm-managed resource
allocation (e.g. devm_dma_request_chan) and dev_err_probe() for
improved readability and automatic cleanup on probe failure.

It also removes redundant NULL assignments and manual resource release
logic from pxamci_probe(), and eliminates the corresponding release
calls from pxamci_remove().

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202510041841.pRlunIfl-lkp@intel.com/
Fixes: 58c40f3faf742c ("mmc: pxamci: Use devm_mmc_alloc_host() helper")
Suggested-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Rakuram Eswaran <rakuram.e96@gmail.com>
Reviewed-by: Khalid Aziz <khalid@kernel.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/pxamci.c | 56 +++++++++++++--------------------------
 1 file changed, 18 insertions(+), 38 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 26d03352af63..b5ea058ed467 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -652,10 +652,9 @@ static int pxamci_probe(struct platform_device *pdev)
 	host->clkrt = CLKRT_OFF;
 
 	host->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(host->clk)) {
-		host->clk = NULL;
-		return PTR_ERR(host->clk);
-	}
+	if (IS_ERR(host->clk))
+		return dev_err_probe(dev, PTR_ERR(host->clk),
+					"Failed to acquire clock\n");
 
 	host->clkrate = clk_get_rate(host->clk);
 
@@ -703,46 +702,37 @@ static int pxamci_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mmc);
 
-	host->dma_chan_rx = dma_request_chan(dev, "rx");
-	if (IS_ERR(host->dma_chan_rx)) {
-		host->dma_chan_rx = NULL;
+	host->dma_chan_rx = devm_dma_request_chan(dev, "rx");
+	if (IS_ERR(host->dma_chan_rx))
 		return dev_err_probe(dev, PTR_ERR(host->dma_chan_rx),
 				     "unable to request rx dma channel\n");
-	}
 
-	host->dma_chan_tx = dma_request_chan(dev, "tx");
-	if (IS_ERR(host->dma_chan_tx)) {
-		dev_err(dev, "unable to request tx dma channel\n");
-		ret = PTR_ERR(host->dma_chan_tx);
-		host->dma_chan_tx = NULL;
-		goto out;
-	}
+
+	host->dma_chan_tx = devm_dma_request_chan(dev, "tx");
+	if (IS_ERR(host->dma_chan_tx))
+		return dev_err_probe(dev, PTR_ERR(host->dma_chan_tx),
+					"unable to request tx dma channel\n");
 
 	if (host->pdata) {
 		host->detect_delay_ms = host->pdata->detect_delay_ms;
 
 		host->power = devm_gpiod_get_optional(dev, "power", GPIOD_OUT_LOW);
-		if (IS_ERR(host->power)) {
-			ret = PTR_ERR(host->power);
-			dev_err(dev, "Failed requesting gpio_power\n");
-			goto out;
-		}
+		if (IS_ERR(host->power))
+			return dev_err_probe(dev, PTR_ERR(host->power),
+						"Failed requesting gpio_power\n");
 
 		/* FIXME: should we pass detection delay to debounce? */
 		ret = mmc_gpiod_request_cd(mmc, "cd", 0, false, 0);
-		if (ret && ret != -ENOENT) {
-			dev_err(dev, "Failed requesting gpio_cd\n");
-			goto out;
-		}
+		if (ret && ret != -ENOENT)
+			return dev_err_probe(dev, ret, "Failed requesting gpio_cd\n");
 
 		if (!host->pdata->gpio_card_ro_invert)
 			mmc->caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
 
 		ret = mmc_gpiod_request_ro(mmc, "wp", 0, 0);
-		if (ret && ret != -ENOENT) {
-			dev_err(dev, "Failed requesting gpio_ro\n");
-			goto out;
-		}
+		if (ret && ret != -ENOENT)
+			return dev_err_probe(dev, ret, "Failed requesting gpio_ro\n");
+
 		if (!ret)
 			host->use_ro_gpio = true;
 
@@ -759,16 +749,8 @@ static int pxamci_probe(struct platform_device *pdev)
 	if (ret) {
 		if (host->pdata && host->pdata->exit)
 			host->pdata->exit(dev, mmc);
-		goto out;
 	}
 
-	return 0;
-
-out:
-	if (host->dma_chan_rx)
-		dma_release_channel(host->dma_chan_rx);
-	if (host->dma_chan_tx)
-		dma_release_channel(host->dma_chan_tx);
 	return ret;
 }
 
@@ -791,8 +773,6 @@ static void pxamci_remove(struct platform_device *pdev)
 
 		dmaengine_terminate_all(host->dma_chan_rx);
 		dmaengine_terminate_all(host->dma_chan_tx);
-		dma_release_channel(host->dma_chan_rx);
-		dma_release_channel(host->dma_chan_tx);
 	}
 }
 
-- 
2.52.0



