Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93D13CF96B;
	Fri, 15 May 2026 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862632; cv=none; b=u6XoJkvIKn6EypJCBS8x6nk7XBnfNXmIQYDLhNkKBBD7u0MXlpcMUC5d2H18P6RrisCkFTzu1gthWGCdZ7y7wiuoEmmtbNGw7oZ2hFXFz8LEN/8D3R7K9il57OGhFwBycTpVLjoZtMUPixBxe9433eHhDCqf7dqoBsUIN55GYxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862632; c=relaxed/simple;
	bh=9emG1OhJJFRV/AcaZ2bBfsH7+S/vWxMojlaLYz/iZAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tx3Zj+2ORt9DrCXDFOFpRwqUrDd+WO2v8yF06dWvRy4LzVQ85gKsBUPd+wD3aOzTBzw2ls8XG9RqycNpSzVAI/Llx/TtqA4yX8ZQl2irtE8ee7dCJYfC5tWt4hx2a+iQIbHzKkbZ2jJ3z2H7NxmF8xsyU5vQ2k3pZnEND8YA8wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUR17zVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUR17zVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D65C2BCB0;
	Fri, 15 May 2026 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862632;
	bh=9emG1OhJJFRV/AcaZ2bBfsH7+S/vWxMojlaLYz/iZAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUR17zVEzMPN/cWjwpaXTZXiWSBBz5Rc5+SD0lqSiQa3ghTvd0O3c5Cf0iNQj8TJm
	 VR0l1Mhgs6Uk4/fvU0w0DvDu3Ih3JQWUAdMZaUSviUcNaUBlegvcsNhswhjqekfz6T
	 w7WcCsmouOlEk3hGSR7o5AbPomFWHEvF5mMWWTyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 122/201] spi: cadence-quadspi: fix runtime pm and clock imbalance on unbind
Date: Fri, 15 May 2026 17:49:00 +0200
Message-ID: <20260515154701.204532697@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5e8bb0cc72f1d52d8ac2a88f4c952e2e98056aed upstream.

Make sure to balance the runtime PM usage count before returning on
probe failure (to allow the controller to suspend after a probe
deferral) and to only drop the usage count on driver unbind to avoid a
clock disable imbalance.

Also restore the autosuspend setting.

Fixes: 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support")
Cc: stable@vger.kernel.org	# 6.7
Cc: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125354.1534871-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1864,10 +1864,6 @@ static int cqspi_probe(struct platform_d
 	if (irq < 0)
 		return -ENXIO;
 
-	ret = pm_runtime_set_active(dev);
-	if (ret)
-		return ret;
-
 	ret = clk_bulk_prepare_enable(CLK_QSPI_NUM, cqspi->clks);
 	if (ret) {
 		dev_err(dev, "Cannot enable QSPI clocks.\n");
@@ -1966,10 +1962,11 @@ static int cqspi_probe(struct platform_d
 	cqspi->sclk = 0;
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
-		pm_runtime_enable(dev);
 		pm_runtime_set_autosuspend_delay(dev, CQSPI_AUTOSUSPEND_TIMEOUT);
 		pm_runtime_use_autosuspend(dev);
 		pm_runtime_get_noresume(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
 	}
 
 	host->num_chipselect = cqspi->num_chipselect;
@@ -2000,8 +1997,12 @@ release_dma_chan:
 	if (cqspi->rx_chan)
 		dma_release_channel(cqspi->rx_chan);
 disable_rpm:
-	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
+	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
 		pm_runtime_disable(dev);
+		pm_runtime_set_suspended(dev);
+		pm_runtime_put_noidle(dev);
+		pm_runtime_dont_use_autosuspend(dev);
+	}
 	cqspi_controller_enable(cqspi, 0);
 disable_clks:
 	clk_bulk_disable_unprepare(CLK_QSPI_NUM, cqspi->clks);
@@ -2038,8 +2039,10 @@ static void cqspi_remove(struct platform
 		clk_bulk_disable_unprepare(CLK_QSPI_NUM, cqspi->clks);
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
-		pm_runtime_put_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
+		pm_runtime_put_noidle(&pdev->dev);
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 	}
 }
 


