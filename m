Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF4F2949E0;
	Fri, 15 May 2026 16:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862030; cv=none; b=Jry9HZ+kBkGAfSZLIrCDA4LB487D2RYkjVLp28MUYAtsEisHHuZluu7n7nljIVq/7lIKg4A9SSlJuKbw99wMLwEg95oxIuHXSVZf/85jHb2Tc/Evlvcc7z0n25wWUQTbplcya77IPmAtrjE0K/mJrTuGdC6MuDv/rZc90CvDkcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862030; c=relaxed/simple;
	bh=fJ5ITDNbWWQSWxMLkbLxcI/XBmswRRFozBpOVryuoOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6ecbZDcu+dH9Jrmekw8qUO0zFz9RE0mTI1dX7c6JUap1X26AzUChHbK5JbQXANLBtSxtu5+vtHnk63di4CjxyNZvot7IDMWKmlaQ5xe5UrAGyOQ0RRQAMiJmVmyzEugrsadnZYqWq3t2/7sIvq63BxrRqQ0sw05PyeEc4lQmJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsXONuQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsXONuQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46327C2BCB0;
	Fri, 15 May 2026 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862030;
	bh=fJ5ITDNbWWQSWxMLkbLxcI/XBmswRRFozBpOVryuoOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsXONuQ5o8hfkdV5ECSrsuOEFksseeVjV3vLi6aeN4J+pWESuFwwluovhSQynSX78
	 zHwlvwJXVFBsAtxUbjJI+r0t9nCPl8TfoLmEdTDzPoRCr7qGDLa7n/rcZUBl44NNkb
	 MVfWLWJlQbzENM5GBssQgkV10vrekib+FPkpXERA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 082/188] spi: sh-msiof: fix controller deregistration
Date: Fri, 15 May 2026 17:48:19 +0200
Message-ID: <20260515154659.099977517@linuxfoundation.org>
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

commit 45170f67a08b912ead6ccc387ba06954d1d4e53a upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 1bd6363bc0c6 ("spi: sh-msiof: Use core message handling instead of spi-bitbang")
Cc: stable@vger.kernel.org	# 3.15
Cc: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-14-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sh-msiof.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -1290,9 +1290,9 @@ static int sh_msiof_spi_probe(struct pla
 	if (ret < 0)
 		dev_warn(dev, "DMA not available, using PIO\n");
 
-	ret = devm_spi_register_controller(dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
-		dev_err(dev, "devm_spi_register_controller error.\n");
+		dev_err(dev, "failed to register controller\n");
 		goto err2;
 	}
 
@@ -1310,8 +1310,14 @@ static void sh_msiof_spi_remove(struct p
 {
 	struct sh_msiof_spi_priv *p = platform_get_drvdata(pdev);
 
+	spi_controller_get(p->ctlr);
+
+	spi_unregister_controller(p->ctlr);
+
 	sh_msiof_release_dma(p);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(p->ctlr);
 }
 
 static const struct platform_device_id spi_driver_ids[] = {


