Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E67233B6E8;
	Fri, 15 May 2026 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862560; cv=none; b=um2nvsnPWwgwlK07TbgjK5scgNGqiJ2Gm4O1JMYr+/RACtln6sFv+NYIoApzVrOSutiK7mCfeffl9Z36ikevyq7fvK7rvCsGR5Vk6Xe9Aoe8gPZ244ZXOg3uByURR/1kfBmYS50xcCVeZRRetMfPR2k4IpSJCFi3rDm0I/a2uHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862560; c=relaxed/simple;
	bh=QZHQRlSNsvusj836FQWSDR1XG2VBUK691+tU2N80xpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biGwWqbo3Qj7yn3TyjFmfFTFp54cdZ8T6+PDk73GI+3M3I8m1sAEdfGpOv/Rk+W4XpKBOTnZytvXs3J6o24c/bi3pdldqwGLAzqNg6+9IXX2O1GlF3I3ACuL1eR3ONOzMWmFbTK80N1V5FwE3KGys8Uzb6nqjNldPM30JkAliPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLV7i2Bs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLV7i2Bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C73CC2BCB0;
	Fri, 15 May 2026 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862559;
	bh=QZHQRlSNsvusj836FQWSDR1XG2VBUK691+tU2N80xpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLV7i2Bsb/QWxuRSgq7CroqoKbFQJXf/26ikrQnMkQH84b7xmCsmkfTsfF3nGVxmo
	 ZiWQ1yncOItm/jIut96aFrY4LmGpiHmNbXPd6DNB1DNsHuQIdp6KSQvIogLOup2KEH
	 toQEjd6HEUO5m4aGIwROaboAhTcANXJEEwnaQ6EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 096/201] spi: bcmbca-hsspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:34 +0200
Message-ID: <20260515154700.613282942@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

commit c3d97c3320b9a1ebbd6119857341be034f7b3efc upstream.

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind to allow SPI drivers to
do I/O during deregistration.

Note that clocks were also disabled before the recent commit
e532e21a246d ("spi: bcm63xx-hsspi: Simplify clock handling with
devm_clk_get_enabled()").

Fixes: a38a2233f23b ("spi: bcmbca-hsspi: Add driver for newer HSSPI controller")
Cc: stable@vger.kernel.org	# 6.3: deb269e0394f
Cc: stable@vger.kernel.org	# 6.3
Cc: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-8-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcmbca-hsspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -549,7 +549,7 @@ static int bcmbca_hsspi_probe(struct pla
 	}
 
 	/* register and we are done */
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_sysgroup_disable;
 
@@ -571,6 +571,8 @@ static void bcmbca_hsspi_remove(struct p
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct bcmbca_hsspi *bs = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	/* reset the hardware and block queue progress */
 	__raw_writel(0, bs->regs + HSSPI_INT_MASK_REG);
 	clk_disable_unprepare(bs->pll_clk);


