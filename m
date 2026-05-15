Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B6B3F928D;
	Fri, 15 May 2026 16:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861913; cv=none; b=bEpMBUT/riq+lhOJB38D1ByMmqnqAFfw0qTJD9PRzrVEsa8zLltNhr2N81QbZTFKDv1Wl0hanxejHoO8qSgnMpXJfS+IOiTZ7uB5dGAPF7EIXG2I5FhDpLSum/1EMWHLY77l1V60uPpoCdZtno5TTx2PV/ad64Dah9puTKdwfQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861913; c=relaxed/simple;
	bh=4XTYx1mU8CusaXmjC5tUqOPcyK01XoYpn5YrE/ZSGUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjqrEVifat3fz8Yo7+racHm/5V9YI+b6+U8nT+5B0HeesXcAUsIfjF2ryDe65nf3tsny/qwfvlymQoQ+Cz1aKRvgelcR+NIO8S2kdmFzFazxHynWaTwT/V625Ss5/7QWQQn3swkCEwe3OvuWptZqJ2nUZORmEpJGFcGJPwDxc1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOxO1/gV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOxO1/gV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D192C2BCB0;
	Fri, 15 May 2026 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861913;
	bh=4XTYx1mU8CusaXmjC5tUqOPcyK01XoYpn5YrE/ZSGUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOxO1/gVBr+M5++Q0+hmP14baifRHWiJwwP4SKTaQDFN2VRWpDlkPwZLj3o9g3itO
	 o2q7507ZI5DGNKTDfXgWKJBvyo0teteZEEN0mgOHM4sRDFefNErAP71/+tLmpEyiTC
	 2LjQHAcuAcaJyPcUP+/jJs80EU38SO1VXN1s+LMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian@openwrt.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 019/188] spi: bcm63xx: fix controller deregistration
Date: Fri, 15 May 2026 17:47:16 +0200
Message-ID: <20260515154657.723486716@linuxfoundation.org>
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


