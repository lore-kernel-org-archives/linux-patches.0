Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D8A4963D9;
	Fri, 15 May 2026 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861709; cv=none; b=FZ288+kbE1fZGryYTYJysn8TcYyMSgSmtrGyU0QdCPQSErBcbadqZ6GmdT/imQQRyaecRgg1YCF4mlnDx7v5XKnkPKrH5hshd/m+1xhBK4qKoPrjEp/Wrm1wZj9u/qz6nWCFwygpmmMNLjZjgzHfhN8mwPK0glszXPsclvzlwcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861709; c=relaxed/simple;
	bh=Ogcvsuq9gmqG5ZASsxWRab2lknR/XlZxPKyURVUjKW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk4TiXEcoyoA1rRwwWocW0bsPAr+Y0V4/d9mb3hc+5fkJ8VFxDt4mrt4NUbBExGbcEThmDUmLeDx91XgcaUteIeKCf3WStnXDkwCItrqeQIw4GpUMPR3RQb7+RQ4ADnw84UkvW8YYhzT1tLecH44xuwhFcTbR/c7jl0ZTR9f9hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuVoorvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuVoorvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45C2C2BCB0;
	Fri, 15 May 2026 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861709;
	bh=Ogcvsuq9gmqG5ZASsxWRab2lknR/XlZxPKyURVUjKW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuVoorvJK97Cr76AYtbtjXi/wYWOF/lHcP2r6/HG4HjKeeknAMaHF1pVwcX4KUbTw
	 XENunoeKmcKbZcEUK3Bn26IPrvMl2LwAvRWQHwapHLSyp1bfXJ5UrnTa3+gtyYuw4v
	 xMGI1bihhAjcOXh/DQeevKmr7ufQW+HgJLdTRHII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 434/474] spi: sun6i: fix controller deregistration
Date: Fri, 15 May 2026 17:49:03 +0200
Message-ID: <20260515154724.468161196@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit d874a1c33aee0d88fb4ba2f8aeadaa9f1965209a ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 3558fe900e8a ("spi: sunxi: Add Allwinner A31 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-20-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun6i.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -742,7 +742,7 @@ static int sun6i_spi_probe(struct platfo
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI host\n");
 		goto err_pm_disable;
@@ -768,12 +768,18 @@ static void sun6i_spi_remove(struct plat
 {
 	struct spi_controller *host = platform_get_drvdata(pdev);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_force_suspend(&pdev->dev);
 
 	if (host->dma_tx)
 		dma_release_channel(host->dma_tx);
 	if (host->dma_rx)
 		dma_release_channel(host->dma_rx);
+
+	spi_controller_put(host);
 }
 
 static const struct sun6i_spi_cfg sun6i_a31_spi_cfg = {


