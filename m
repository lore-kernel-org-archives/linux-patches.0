Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670403FD95B;
	Fri, 15 May 2026 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861714; cv=none; b=hj63DH56xVy3ymItjeCGZPiHWB2Za9TYgMcqBs+pIvyXzyZyjYRy9wV/nM0QK6nCgT/5QmwOidVAhTvs3J5wNK9HZiLaFvoq6Od6fWHfgunpm0078CWw8R+1785DPOSPYo07YZtM2YFzJjy20V04W7TqgHDnvRFhGCIDrobkhr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861714; c=relaxed/simple;
	bh=/rAq7ag/ODTGmuR1P8OpGQHj6m/o8ICKb45sqKiiqrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBXbIYNmgJjBPKdfQv3A5UQkRsNlceTRqZ6Hn2OpQ5KR5Yz6AIGcehlEpNIzVEdb+f6l7fXkMZWkQ+aqaleMEauClkG5Q2whsKkQlxw3ct1wNR657fDkuiIJAwjdVqVgBmwz8eZyBfu/ikSKmH8UjDlxcdq9nD/fGBCEnaWculs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RADr6r8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RADr6r8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09C1C2BCB0;
	Fri, 15 May 2026 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861714;
	bh=/rAq7ag/ODTGmuR1P8OpGQHj6m/o8ICKb45sqKiiqrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RADr6r8VJc+62vHRuQ+Ty/+KWhQ5d/nTEbJFao9QT0ypToEjyb7bwmTDrTvA4ptaF
	 oHdC95XSXNWRLRod2Pcxb1rYDaUplMx6vxxVIq01ZelCkwex1N7j0lzB+WdnmmwGuH
	 rWD9mZO0A1kbm4OLjAnURjJ57RsYHIXeNft9KB5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 436/474] spi: tegra20-sflash: fix controller deregistration
Date: Fri, 15 May 2026 17:49:05 +0200
Message-ID: <20260515154724.513956464@linuxfoundation.org>
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

[ Upstream commit ad7310e983327f939dd6c4e801eab13238992572 ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: f12f7318c44a ("spi: tegra20-sflash: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-23-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ translated spi_controller/host API to legacy spi_master/master naming and dropped devm-managed registration ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra20-sflash.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -506,7 +506,7 @@ static int tegra_sflash_probe(struct pla
 	pm_runtime_put(&pdev->dev);
 
 	master->dev.of_node = pdev->dev.of_node;
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
 		goto exit_pm_disable;
@@ -529,11 +529,17 @@ static void tegra_sflash_remove(struct p
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
+
+	spi_master_put(master);
 }
 
 #ifdef CONFIG_PM_SLEEP


