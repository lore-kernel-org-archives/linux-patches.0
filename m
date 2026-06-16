Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0CB34FF79;
	Tue, 16 Jun 2026 18:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634718; cv=none; b=gJtjz9QDS4QRJytR4Sn9MnYvsUKBK6dATHLreufWEGdb1z1wkr9GJd/KzNvgrb6ASVGMVtW5sjlrsFHbS8KAH217mqq/z6xYJkZQg785G8Aodbl+kY2vgD2l0tLVRGulQOmPqkrFVfYWWBl9YjLg1dHvZ3VrJbaPe0tS84Ey/+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634718; c=relaxed/simple;
	bh=Ro6Zpg34BHy6ciBE1BdP6wt+jiqG2pwcuQKOWeV/F/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgveXZ47Yh5w3unZBO0T1iZtGiNc53Zzdva8Hg4PbUfhtPJE7lv8kzh60CGUEd+U4foRQ1hs9vFYjanLZwg5RItGqWnoOvTQYkb2AdAndBx+QtHc/a1zFfK87a3mEsak46rglhi/wGjrzYAhLZ+iyh3PjzjyRKhBhyyQ492GjgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cR6F7emx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cR6F7emx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49781F000E9;
	Tue, 16 Jun 2026 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634717;
	bh=gYPQPRF/RcJNgJ8g9sdCzSpBdr6qeMCf/+Tuui6KhgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cR6F7emxkYmplhABHGYb5EzhoH+Y5ScSfBV21C1Und/CSD4QhyhpT2QRjnosUOG+h
	 SK0Ojp1hZqRza7FzynspYiSRpzELDmivN/tiZFF2yW6uAypdQu6HC6yV8S0gfzDqyb
	 4uUv5s/HEO8MKKJ8tpZ84jwxts8RicSNpdU4Fhds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/411] spi: tegra20-sflash: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:16 +0530
Message-ID: <20260616145118.054914297@linuxfoundation.org>
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
@@ -507,7 +507,7 @@ static int tegra_sflash_probe(struct pla
 	pm_runtime_put(&pdev->dev);
 
 	master->dev.of_node = pdev->dev.of_node;
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to master err %d\n", ret);
 		goto exit_pm_disable;
@@ -530,12 +530,18 @@ static int tegra_sflash_remove(struct pl
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
 


