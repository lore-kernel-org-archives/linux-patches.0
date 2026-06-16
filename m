Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F922472771;
	Tue, 16 Jun 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632385; cv=none; b=rpojrThySgZuhGmqLDQYlr8DILrwEUfwV2d384LsFwsLQerwCkWgKNbHDOjF5Oq/OQW10X83HCLgnjwG+xxrUSqMt6pqh11Q6hoLrGK+IieghfT6VI/vf58hJh6H5uPnuK5KSd41xX0S5RY8PpTmIQFsYvhmiw8uCxvlyXOcAmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632385; c=relaxed/simple;
	bh=DGcKTBDXGDTbSa3t0vzwQFNOazXpHYFsUhgLCOO/ui4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwYAXTD5GHvf3jsBjFNYiLoz+NZPUXUWpQSs6Kr0fHYsXwFts807+LIPtz4EpzrBZA1zhE1uV9g3MIn6PI8SPbFTxyV00cUb3UD53zbU9SyOVKUpfYyxINgFKdkSiuo5mx5+TdUy7PMWs5BJG8yj3nt3jk71Pu6JJLv8c3Pu4QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwPUZ50t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwPUZ50t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB361F000E9;
	Tue, 16 Jun 2026 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632383;
	bh=lDLa9YYWIQO/HQJnpKwjN/T1rT41q3hOdi+4Buzi2X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwPUZ50tozcaUIoa9WtieBDIFgI8j1oxCcw7O1ZGEUFF8hMBa1QrSQIGUQmDhh+FB
	 JZv0wFLDsH4kxOHVzGU8GVaZAXjUZZV/Bjgy+Mm811nlDbBAA1IbnSaNFh69m9x817
	 ajpoiAmtyoFC2mm0B342WYL7Qkui43kJV6iWntE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 399/522] spi: tegra114: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:06 +0530
Message-ID: <20260616145144.739112425@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1415,7 +1415,7 @@ static int tegra_spi_probe(struct platfo
 	}
 
 	master->dev.of_node = pdev->dev.of_node;
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
 		goto exit_free_irq;
@@ -1441,6 +1441,10 @@ static int tegra_spi_remove(struct platf
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct tegra_spi_data	*tspi = spi_master_get_devdata(master);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	free_irq(tspi->irq, tspi);
 
 	if (tspi->tx_dma_chan)
@@ -1453,6 +1457,8 @@ static int tegra_spi_remove(struct platf
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_spi_runtime_suspend(&pdev->dev);
 
+	spi_master_put(master);
+
 	return 0;
 }
 


