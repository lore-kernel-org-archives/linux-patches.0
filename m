Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF8C3DA7E1;
	Tue, 16 Jun 2026 18:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634713; cv=none; b=j4xK+76rE+9yPHF2OupDU2Nw3iXwzckBIzvxAG5swYdkqp9JUPgo8xzXUVDid72mwR9z2d7IuXhc+NlWsmQ42/SLZGj9+L6XBAKv20ZoG667U38xQ5TFO5reCBJov2B9KjmrK7okA1eJJ6s/w2aZrOFlnDHyruRneQo/LbFXQ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634713; c=relaxed/simple;
	bh=CfA6Is2hUgrN1vJnBxk02A4VHYxoUtj17+eYCvHLWwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7hsckXxZjH3Ut/uUX7ibFK2yiZxOmya2SFJayAn+262EtSL7kkwbZMLHpnPpgXeSr2Z3JuiGw8UEi9nm8Dg8RWxASNJ4m/ZB2XXc7Hah1fjlmTFHZuBISEsjbyA3hXhsvIV9x/tLeZR6gBl9XCT2bwkyJdufKcB+ZuJdtlxCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdV6rVvm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdV6rVvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2E11F000E9;
	Tue, 16 Jun 2026 18:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634712;
	bh=q+gIjWqy1QTJltl8X1RHx+3Fypg0DLyUUXOUmCFm8do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdV6rVvmnYYmL4CdZxQRcBerF6KHEp79hakU7uOh4hc1XWXVxG1AZdVZ4jqMOEW1/
	 mscohTW7VI5SR2hzsK53QAJX+bsaiQ4JXBZ/K1LTw3CWjvpZfObk/KivePgS0nrcxz
	 QCRPlWNNpeHtnqF7iQL5bkCs8mPry5ZRa2dCb06g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/411] spi: tegra114: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:15 +0530
Message-ID: <20260616145118.002992405@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ renamed spi_controller/host APIs to spi_master/master equivalents and placed spi_master_put() before the existing return 0 in remove ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1417,7 +1417,7 @@ static int tegra_spi_probe(struct platfo
 	}
 
 	master->dev.of_node = pdev->dev.of_node;
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
 		goto exit_free_irq;
@@ -1443,6 +1443,10 @@ static int tegra_spi_remove(struct platf
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct tegra_spi_data	*tspi = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	free_irq(tspi->irq, tspi);
 
 	if (tspi->tx_dma_chan)
@@ -1455,6 +1459,8 @@ static int tegra_spi_remove(struct platf
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_spi_runtime_suspend(&pdev->dev);
 
+	spi_master_put(master);
+
 	return 0;
 }
 


