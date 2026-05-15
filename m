Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7922D3FF1D1;
	Fri, 15 May 2026 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860258; cv=none; b=AF1fCjOQA7EDrr1+Xd6bIwBbfnqWouotr2zTh4zba2skt9e7+JlyGCUcU0ip+9gO7RFTHZ6aIZUaLL1IG1UiMo033HRzspUSEyU9+AMcq6zMtrPrO9kK0s7hGFkeRharVvhOhOEEoOXjvpSIz8cPQ+WpnKLQA6mXS1YO1ZlIj9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860258; c=relaxed/simple;
	bh=qDcr0oztXwvdg9iE62yed962Fq/RPD63cFgbv/QiP1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOc8SRY+OGFbfZPVZWnXkFgpq4vXHDZThiwIM7w0XtFPr4F2/1iM5RXtOaZfdbA/CIyeQG5xLE1T3m2Sfr/PVsFmh0tyNnM3EtLl+h//tVla97e1fyUrWG+1RMWupl6akO29AligpRqAFcay06z5L2UjykGKfjAym2CaXFFj76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+wtjTmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+wtjTmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6EBC2BCB0;
	Fri, 15 May 2026 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860257;
	bh=qDcr0oztXwvdg9iE62yed962Fq/RPD63cFgbv/QiP1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+wtjTmEenvtJyQtFVvzjBTSfY98s99anS6e6fJPQV+vrIbWAfUp6w/m2XV4YP/mX
	 pyaJIxMyQwPSiNY+Zovp3Z/Sj0x+k7bpEsquBHrqU9vY/wyPBE6AHKDMrqNiES5NVA
	 qe7zfmzhpVvrGmKv/7vzR/lySYsJZ0I5zw8l3N/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian@openwrt.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 008/144] spi: bcm63xx: fix controller deregistration
Date: Fri, 15 May 2026 17:47:14 +0200
Message-ID: <20260515154653.678273671@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit c39e65a4e3b8e764efed0b2f5152a1a8547b80fd upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")
Cc: stable@vger.kernel.org	# 3.4
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-6-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -603,7 +603,7 @@ static int bcm63xx_spi_probe(struct plat
 		goto out_clk_disable;
 
 	/* register and we are done */
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(dev, "spi register failed\n");
 		goto out_clk_disable;
@@ -626,11 +626,17 @@ static void bcm63xx_spi_remove(struct pl
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	/* reset spi block */
 	bcm_spi_writeb(bs, 0, SPI_INT_MASK);
 
 	/* HW shutdown */
 	clk_disable_unprepare(bs->clk);
+
+	spi_controller_put(host);
 }
 
 static int bcm63xx_spi_suspend(struct device *dev)


