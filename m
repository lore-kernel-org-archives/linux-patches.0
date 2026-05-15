Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CF039734B;
	Fri, 15 May 2026 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862245; cv=none; b=e5knBgHtCnmUR2HZjiLKuJtDnea8rc24zU9k9CUaL+xAYOixHD7KeS+Ul6KzgTFCFizh/3L2nrLEXHsML3vIfcH20FFSRshDLB5rycNzj1efMNb145+OYRUR2NKHbnWId2GO63qcHPSyPutdEXAeU2UeaTBoKRIeixPp/a2262Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862245; c=relaxed/simple;
	bh=ANo4BUnj1QzQM0aW+biGOTZ/qNEV8UnApohH+TEcx2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StuED25kMHeca/aX64ySUIGZViCpGVaanpgElBw1IufGwVOtHHKsjHBDmNrpP6ctLrD4OmAYeMlpsquwB8LxpHsIdC78EA6LnAKhBS71kag4OOwKH2ToXkO/7MXCf9v074nv7EWQDGcujes9fn9T0Rgb9CUDvgXdZtUYWiYWkGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOpiFPZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOpiFPZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4080FC2BCB0;
	Fri, 15 May 2026 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862245;
	bh=ANo4BUnj1QzQM0aW+biGOTZ/qNEV8UnApohH+TEcx2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOpiFPZD7X8ueOuhp2RCJQ6/YhHVFvu4LpLABqS9gTRoE1vjpC3xwOmdBjEaavzh2
	 MbtAdoCNg+f40IdNT8TykKLFimI40Ch/WOU7XHO09zG57OF95Is6eg5v4X51OYrZc3
	 40336iSF55PduFGaVwQGcm3eW3QSeE/OVMu/yJ7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/188] spi: tegra114: fix controller deregistration
Date: Fri, 15 May 2026 17:49:42 +0200
Message-ID: <20260515154700.912141179@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 9c9c27ff2058142d8f800de3186d6864184958de ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 5c8096439600 ("spi: tegra114: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-22-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kept `host->dev.of_node = pdev->dev.of_node;` context line above the `spi_register_controller()` conversion ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1416,7 +1416,7 @@ static int tegra_spi_probe(struct platfo
 	}
 
 	host->dev.of_node = pdev->dev.of_node;
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to host err %d\n", ret);
 		goto exit_free_irq;
@@ -1442,6 +1442,10 @@ static void tegra_spi_remove(struct plat
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct tegra_spi_data	*tspi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	free_irq(tspi->irq, tspi);
 
 	if (tspi->tx_dma_chan)
@@ -1453,6 +1457,8 @@ static void tegra_spi_remove(struct plat
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_spi_runtime_suspend(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


