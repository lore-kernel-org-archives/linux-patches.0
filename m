Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1855A3CB2D5;
	Fri, 15 May 2026 16:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862103; cv=none; b=Zw22vG8HbUc91iUHqeTS4Za+t2ESzjj2b8dgOqySMF4XJzMTsTKaD/+uw1uwEi6Vv/nGpgamHsfxkcRPW1JEq60FgiPWueAQsVGY4oV/g3BdxtlVZEh3zZKx/6wUC1MNMemM3Y41buVdJBXanHtwy9nDc36pgOhOPuwmiejX8k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862103; c=relaxed/simple;
	bh=2/Mu6HYyl/J3MLcmft2szwh91mx6WIwsiZl6bjLHhVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJqRCd7WOzxFgWf4GVuphRQF8XiuiboRal4sy8ZCDfRRrf7NnspswpGzifzeMtPkGTawOkAgXzmXsb3IkPV8VVgsjBkDCXhPjo58YbEg94CzxEy3YYQ3l1bNQLodxpD6Cr+oZVYecq0JWSHZNRr9L5dNmaHD5pnwFcyihcVCiNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ry4E8Nd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ry4E8Nd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24CAC2BCB0;
	Fri, 15 May 2026 16:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862103;
	bh=2/Mu6HYyl/J3MLcmft2szwh91mx6WIwsiZl6bjLHhVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ry4E8Nd4lRr2p7CqELPFeUvELu1d89QVXp5bglb8Lt3hse7Ss5rbL4WGVyoOovsz2
	 puer1P/e5QxkK7Y2QafGJJDxCp+atL7Z45u/WIsbbbiQc2r+qG5B00hjjioGT0DgEj
	 NzBuZSGBBfTl/4tZ1ErNCZ+amxs8Fw4GqrciyxsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 068/188] spi: omap2-mcspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:05 +0200
Message-ID: <20260515154658.792260479@linuxfoundation.org>
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

commit fb45f95c377e4a4bdece2c5e17643b459c9c13e7 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: ccdc7bf92573 ("SPI: omap2_mcspi driver")
Cc: stable@vger.kernel.org	# 2.6.23
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-6-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-omap2-mcspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1585,7 +1585,7 @@ static int omap2_mcspi_probe(struct plat
 	if (status < 0)
 		goto disable_pm;
 
-	status = devm_spi_register_controller(&pdev->dev, ctlr);
+	status = spi_register_controller(ctlr);
 	if (status < 0)
 		goto disable_pm;
 
@@ -1606,11 +1606,17 @@ static void omap2_mcspi_remove(struct pl
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct omap2_mcspi *mcspi = spi_controller_get_devdata(ctlr);
 
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	omap2_mcspi_release_dma(ctlr);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
 	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(ctlr);
 }
 
 /* work with hotplug and coldplug */


