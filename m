Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DF633A033;
	Wed, 20 May 2026 17:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297350; cv=none; b=Sgq7j6oqDb57MDEtDNodTd34lA7wROexpgKbsz/hZs15hdKPuHp/tU/z+0/ok2aBfATmQTDfApA87Ggt3k2oho2m+A6E0fM4+KdVwwC1FjhA0sRDKUPQ4k1UHu5/XXWhlwOhLHbK0z8UwvuVaa/RGW98t+5k8HE2ThwCXjkpDjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297350; c=relaxed/simple;
	bh=pok7uqEav/bEHYlJypf0jibnVESA1J1t7pIE2aMaa2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IodEYkj5mF3Bzhvmp11tzxV+gzBdFmpolGwYyXBRbanJASfjzh/vKI0HJL4mNIKd42Lma5zO5xcrNGCqX/VkO/V2RtOCULKCRMhTHME6VtYABIULUMSj6TVmwwVvRkt9E1nHvrGr8z4AEyCReA0DW4xxHmmcB10mnIYT/lYWy6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmXpta+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmXpta+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21D11F00893;
	Wed, 20 May 2026 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297349;
	bh=FwoDsdIQnXaoCV0z2gt1royBFkiv3Kv6fQUtdGGhSEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmXpta+rwD1busT50qHBkfJP2LDHB/lCHUt00zrj8dT1rXQjGRWop1EyTK4wJ1yP8
	 bxHmnDDMB/gevfuX962bStZVwiXv/AcLdWJeJZcX5a5ay+mXzW/W+IGCGOxfGGsa3y
	 iyatVyVQv5j0PdSZXwwE2lcMMul8vNrQG/Cej7G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yash Shah <yash.shah@sifive.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1146/1146] spi: sifive: fix controller deregistration
Date: Wed, 20 May 2026 18:23:16 +0200
Message-ID: <20260520162214.194682948@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

[ Upstream commit 0f25236694a2854627c1597465a071e6bb6fe572 ]

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind.

Note that clocks were also disabled before the recent commit
140039c23aca ("spi: sifive: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: 484a9a68d669 ("spi: sifive: Add driver for the SiFive SPI controller")
Cc: stable@vger.kernel.org	# 5.1
Cc: Yash Shah <yash.shah@sifive.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-15-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sifive.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sifive.c
+++ b/drivers/spi/spi-sifive.c
@@ -392,7 +392,7 @@ static int sifive_spi_probe(struct platf
 	dev_info(&pdev->dev, "mapped; irq=%d, cs=%d\n",
 		 irq, host->num_chipselect);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "spi_register_host failed\n");
 		goto put_host;
@@ -411,8 +411,14 @@ static void sifive_spi_remove(struct pla
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct sifive_spi *spi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	/* Disable all the interrupts just in case */
 	sifive_spi_write(spi, SIFIVE_SPI_REG_IE, 0);
+
+	spi_controller_put(host);
 }
 
 static int sifive_spi_suspend(struct device *dev)


