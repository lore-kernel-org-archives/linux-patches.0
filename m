Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8668349CF0;
	Tue, 16 Jun 2026 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636550; cv=none; b=ev4383jogof/0ULhIBvX3UtVblcHiWKIAVxs2zFDPn6lRdg99A8TPJf5F6JMif/hsMrDVDZctX2pusZ3gdZK4uviNcrEEpC2punZdcRRguucUwshXVpwJQXIaLRUMoy+5mT4YBwUhoW00m9t5w0qu6kvDV98nJM7v0/raqChgaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636550; c=relaxed/simple;
	bh=cG2AmIooLNinCg37jun76/7nyqE89hX+BtFuYg7qqfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7lTqFEFvjoh8HRMbJEPUav0Jetb7sg2ORMaUOShT5c8ORK8aYeZEtKSdGMDAKb/89iCSNLRdQLjrnTgExYOa1YX4L8OTozuGY0JkBGTc2io35YqhXOlaTmAYpDgNt1pUj4bXulTfo4FywG1k6UJvD3BM/lY37Hhx8sF3pAPBZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAPk0EbV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAPk0EbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA721F000E9;
	Tue, 16 Jun 2026 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636549;
	bh=BLK5pApShqzUq1OXjHCB2NxWP08jpjM9mhkOoazCVtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAPk0EbVEr7wviJ7Mtnvxy9Fu1HgzIqv3YSDtj93bjloZw4be1Ly1Sa/RM8PNhyZe
	 gE4QQKC5XtpMPbLYG2ven8x/EQ1DuUMM+xk+Wk9ppN4NHYZU7ukQi8xP0McvyZG523
	 65UOmmJCca99LNZqzumukCjX+iOgjBJSipdJnkE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/342] spi: tegra20-sflash: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:17 +0530
Message-ID: <20260616145100.415084516@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit ad7310e983327f939dd6c4e801eab13238992572 ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: f12f7318c44a ("spi: tegra20-sflash: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-23-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_controller/host APIs to spi_master/master equivalents and switched devm_spi_register_master to spi_register_master ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra20-sflash.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -508,7 +508,7 @@ static int tegra_sflash_probe(struct pla
 	pm_runtime_put(&pdev->dev);
 
 	master->dev.of_node = pdev->dev.of_node;
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
 		goto exit_pm_disable;
@@ -531,12 +531,18 @@ static int tegra_sflash_remove(struct pl
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct tegra_sflash_data	*tsd = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	free_irq(tsd->irq, tsd);
 
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_sflash_runtime_suspend(&pdev->dev);
 
+	spi_master_put(master);
+
 	return 0;
 }
 


