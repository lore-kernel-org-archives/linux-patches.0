Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74821DE4CD;
	Tue,  8 Oct 2024 13:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393562; cv=none; b=fLy1b+N8jQjyo11DDLq9GwZLdJ9CAuuUdxG1k9oJ017xFcXLjxTfDrZ25TcDDyRnpczh7JRuaB3HmRUMW1IkwFDr2IJ7faRpxLR29sCCkoe76hnVBsnD1DpGMcZe+SA1ntGAxus7S+biuoTXqFw+d4HiST32mz5OTOUolKQCuD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393562; c=relaxed/simple;
	bh=dw0vUuZ4nxyB3XPmkWoRtKTX3XSOZ0UbNDfRVDTJldY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksLwRZZnnppirltQs6vWX5mRREwKHzm5qKvKJwnVqecS8Mprgj/86hAttpo0B+w9wrdZfVxbOyb72CustPIrSkMy1qUFCRfLVAMAnICL4L1Sk+2TU7Iw5A+fGf1IjwbowemAOBSkQ+YQHitE9Wz6zk/EOMsVPlhTLDkpA/laTCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZbcwqYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZbcwqYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C625C4CEC7;
	Tue,  8 Oct 2024 13:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393561;
	bh=dw0vUuZ4nxyB3XPmkWoRtKTX3XSOZ0UbNDfRVDTJldY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZbcwqYXxH8zqea0DOEsfv/haM9LuHE+yxYwlRPIJJPOyKmGWMlo8vC32qJSM2zRg
	 Vo47wrWwGSpC0CHsEEsqSqc3Pdu9man3zjOgWg9RLxk2EKY3BWwxFwmsoeT/dFxsV2
	 OmDcWJKVRespftGCcP0wZInSEcbzchZuuosSVVcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Li Zetao <lizetao1@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/386] spi: spi-cadence: Use helper function devm_clk_get_enabled()
Date: Tue,  8 Oct 2024 14:07:12 +0200
Message-ID: <20241008115636.770694125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit f64b1600f92e786e502cc30d31d9e3c5f2f6d682 ]

Since commit 7ef9651e9792 ("clk: Provide new devm_clk helpers for prepared
and enabled clocks"), devm_clk_get() and clk_prepare_enable() can now be
replaced by devm_clk_get_enabled() when driver enables (and possibly
prepares) the clocks for the whole lifetime of the device. Moreover, it is
no longer necessary to unprepare and disable the clocks explicitly.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/20230823133938.1359106-9-lizetao1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 67d4a70faa66 ("spi: spi-cadence: Fix pm_runtime_set_suspended() with runtime pm enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 5cab7caf46586..e5140532071d2 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -581,31 +581,19 @@ static int cdns_spi_probe(struct platform_device *pdev)
 		goto remove_ctlr;
 	}
 
-	xspi->pclk = devm_clk_get(&pdev->dev, "pclk");
+	xspi->pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
 	if (IS_ERR(xspi->pclk)) {
 		dev_err(&pdev->dev, "pclk clock not found.\n");
 		ret = PTR_ERR(xspi->pclk);
 		goto remove_ctlr;
 	}
 
-	ret = clk_prepare_enable(xspi->pclk);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to enable APB clock.\n");
-		goto remove_ctlr;
-	}
-
 	if (!spi_controller_is_target(ctlr)) {
-		xspi->ref_clk = devm_clk_get(&pdev->dev, "ref_clk");
+		xspi->ref_clk = devm_clk_get_enabled(&pdev->dev, "ref_clk");
 		if (IS_ERR(xspi->ref_clk)) {
 			dev_err(&pdev->dev, "ref_clk clock not found.\n");
 			ret = PTR_ERR(xspi->ref_clk);
-			goto clk_dis_apb;
-		}
-
-		ret = clk_prepare_enable(xspi->ref_clk);
-		if (ret) {
-			dev_err(&pdev->dev, "Unable to enable device clock.\n");
-			goto clk_dis_apb;
+			goto remove_ctlr;
 		}
 
 		pm_runtime_use_autosuspend(&pdev->dev);
@@ -679,10 +667,7 @@ static int cdns_spi_probe(struct platform_device *pdev)
 	if (!spi_controller_is_target(ctlr)) {
 		pm_runtime_set_suspended(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
-		clk_disable_unprepare(xspi->ref_clk);
 	}
-clk_dis_apb:
-	clk_disable_unprepare(xspi->pclk);
 remove_ctlr:
 	spi_controller_put(ctlr);
 	return ret;
@@ -703,8 +688,6 @@ static void cdns_spi_remove(struct platform_device *pdev)
 
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
-	clk_disable_unprepare(xspi->ref_clk);
-	clk_disable_unprepare(xspi->pclk);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.43.0



