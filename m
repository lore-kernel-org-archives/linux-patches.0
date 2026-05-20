Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DA43FC5A9;
	Wed, 20 May 2026 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303066; cv=none; b=cYEZadIgx2blX4BqUXqcTFD6jTqRGPzOViL7xaUzy6lJTbBKM7Nv2RFjpKBhxQfFUmgChc0cy5MJHmyaaqHEuG7b85icp3Lrjhb7Wmw51KcQ0+bmLM1kv0TNhHLif1511HpvXCiLGgx4d6UPrdS7ByXit967VF/qb4HtvFlEt48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303066; c=relaxed/simple;
	bh=lt+Dv5tVIH6iikWfAxZENwHQnck8Y+zQvL0Mki8QkpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSOlpNDr0kTpnCRYZBLuL6twFmeEyIbYycE67G3ntB2k1f8fZ0yqxfjX77H8sZx27M+E1hO0BArnPYGaFgzeVVVDyNVBLEEDWv5KzMRB+ydXsR+Xli7tXR/p2HHq0bO5rZ7PiPhrt9oRG29KdCMR7IG23AGYUvSPYZ2zWfbaVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvRE8DGn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvRE8DGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25F41F000E9;
	Wed, 20 May 2026 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303064;
	bh=M1WI9enX5A9/QmjB3MCDJEaF0ZM3pjKCPMBp/rUCdOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvRE8DGnpjltM2rm9F/8xGcsFkVyaSfqCBBDvCu2IeBZdJ3Ac67OjjKaaFIOi/Q+M
	 p+7V1wN5oXYOIUAWEtrXnFGs/Q0EW4rdm/dUuCTLBKYsFAHgngVNS7cSJNptFF3QKp
	 lynraibM+4BgTA3BF08xjq0fOFQpqmNEOv+afTfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 505/508] spi: sifive: Simplify clock handling with devm_clk_get_enabled()
Date: Wed, 20 May 2026 18:25:28 +0200
Message-ID: <20260520162109.544024816@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 140039c23aca067b9ff0242e3c0ce96276bb95f3 ]

Replace devm_clk_get() followed by clk_prepare_enable() with
devm_clk_get_enabled() for the bus clock. This reduces boilerplate code
and error handling, as the managed API automatically disables the clock
when the device is removed or if probe fails.

Remove the now-unnecessary clk_disable_unprepare() calls from the probe
error path and the remove callback. Adjust the error handling to use the
existing put_host label.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/73d0d8ecb4e1af5a558d6a7866c0f886d94fe3d1.1773885292.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0f25236694a2 ("spi: sifive: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sifive.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/spi/spi-sifive.c
+++ b/drivers/spi/spi-sifive.c
@@ -312,7 +312,8 @@ static int sifive_spi_probe(struct platf
 		goto put_host;
 	}
 
-	spi->clk = devm_clk_get(&pdev->dev, NULL);
+	/* Spin up the bus clock before hitting registers */
+	spi->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(spi->clk)) {
 		dev_err(&pdev->dev, "Unable to find bus clock\n");
 		ret = PTR_ERR(spi->clk);
@@ -342,13 +343,6 @@ static int sifive_spi_probe(struct platf
 		goto put_host;
 	}
 
-	/* Spin up the bus clock before hitting registers */
-	ret = clk_prepare_enable(spi->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to enable bus clock\n");
-		goto put_host;
-	}
-
 	/* probe the number of CS lines */
 	spi->cs_inactive = sifive_spi_read(spi, SIFIVE_SPI_REG_CSDEF);
 	sifive_spi_write(spi, SIFIVE_SPI_REG_CSDEF, 0xffffffffU);
@@ -357,14 +351,14 @@ static int sifive_spi_probe(struct platf
 	if (!cs_bits) {
 		dev_err(&pdev->dev, "Could not auto probe CS lines\n");
 		ret = -EINVAL;
-		goto disable_clk;
+		goto put_host;
 	}
 
 	num_cs = ilog2(cs_bits) + 1;
 	if (num_cs > SIFIVE_SPI_MAX_CS) {
 		dev_err(&pdev->dev, "Invalid number of spi targets\n");
 		ret = -EINVAL;
-		goto disable_clk;
+		goto put_host;
 	}
 
 	/* Define our host */
@@ -393,7 +387,7 @@ static int sifive_spi_probe(struct platf
 			       dev_name(&pdev->dev), spi);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to bind to interrupt\n");
-		goto disable_clk;
+		goto put_host;
 	}
 
 	dev_info(&pdev->dev, "mapped; irq=%d, cs=%d\n",
@@ -402,13 +396,11 @@ static int sifive_spi_probe(struct platf
 	ret = devm_spi_register_controller(&pdev->dev, host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "spi_register_host failed\n");
-		goto disable_clk;
+		goto put_host;
 	}
 
 	return 0;
 
-disable_clk:
-	clk_disable_unprepare(spi->clk);
 put_host:
 	spi_controller_put(host);
 
@@ -422,7 +414,6 @@ static void sifive_spi_remove(struct pla
 
 	/* Disable all the interrupts just in case */
 	sifive_spi_write(spi, SIFIVE_SPI_REG_IE, 0);
-	clk_disable_unprepare(spi->clk);
 }
 
 static int sifive_spi_suspend(struct device *dev)


