Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318704B8DEF;
	Fri, 15 May 2026 16:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861712; cv=none; b=BEvC9KFQ/ZfyLqHITj3RgK5iF7WJoSs2BGPMbWg+k6FPxZPiYUwFWpHYLThrxIU78EMAexbgbQw271E93TWSulH83nizaQpOVpWZGVii4RiYNEUap1Wf/QB9NG/4E5YnZMBKnApLDDqdR13b8UQsn2nnYPird5H8cyQbcoTTvvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861712; c=relaxed/simple;
	bh=TPJOYNNBHTm7ejohGH+3lH2NChK0yj40ddHRRp82ntc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPLc3sfaw+wAzH+t0DPWAcMNk7wkXJULzQ3Xh3DIt/L1kKuRUiiFj7S6kOt7G3fYS1ITLnQPv+hfdpI5oNgDZGN/O4GneLQtkVyBTu7Pa+7J4PcoWe3A17ynCOINQs7wBFu6hoWh3xT5n2Ch/WSWniLBmtzBez/voQZYHB69XDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJyn8mqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJyn8mqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3F5C2BCB0;
	Fri, 15 May 2026 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861711;
	bh=TPJOYNNBHTm7ejohGH+3lH2NChK0yj40ddHRRp82ntc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJyn8mqKxKXjk+1Edo1HeGSPl0InUIVlXBcJTLLF6Cl8daxn6nU3VTb4FUuJWsN6+
	 cJkyPAgZh/iiLlFeTKLbTELX4lO9GGcdd34g9Z/MElP9n9zKkaAyr1q0jzbDpwMwTX
	 EWTWX04N5SyhmJ1JzDrZitmZQxSdRa4bO9Hp+3co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 435/474] spi: tegra114: fix controller deregistration
Date: Fri, 15 May 2026 17:49:04 +0200
Message-ID: <20260515154724.490780988@linuxfoundation.org>
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

[ Upstream commit 9c9c27ff2058142d8f800de3186d6864184958de ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 5c8096439600 ("spi: tegra114: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-22-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_controller/host API calls to spi_master/master equivalents ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1416,7 +1416,7 @@ static int tegra_spi_probe(struct platfo
 	}
 
 	master->dev.of_node = pdev->dev.of_node;
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
 		goto exit_free_irq;
@@ -1442,6 +1442,10 @@ static void tegra_spi_remove(struct plat
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct tegra_spi_data	*tspi = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	free_irq(tspi->irq, tspi);
 
 	if (tspi->tx_dma_chan)
@@ -1453,6 +1457,8 @@ static void tegra_spi_remove(struct plat
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_spi_runtime_suspend(&pdev->dev);
+
+	spi_master_put(master);
 }
 
 #ifdef CONFIG_PM_SLEEP


