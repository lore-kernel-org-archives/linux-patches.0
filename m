Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028DF3F9F21;
	Wed, 20 May 2026 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299975; cv=none; b=bEVgQbEPH8aG33sGcK6eulrKiC49G/n6l3hRNunmz2nDv6lKgwNyfnaSKjIYcj8V8/DFqwHEgUW9idDzCackAW5dhI+nOJzi6dWobAouyC0kZJUNLD6ScMlARKts019zBaBPc07XoeHpJ9mc2FWsj1txyplNiphxPmHFjXOOyJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299975; c=relaxed/simple;
	bh=9jsZ4JtDBSp3Z5MWv6z8JA/5u6OzZA8omjd7yA97tw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxUgJ+S45bi3HNYFc2XGFL7SEAQMdI1i8LiWrmjjIBvFLq+M7vEKSAVZi1ZtYsHtnr0Evyla0qpFg76mY3Y0O5QeUQeavF4H1Kb970kOZtdxfeq7WOaINmp/RYvmUcrL+WngdYH8SgXqJmLfl01MNhhE6LcsFuwW03Q8YmOarSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eV964CBD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eV964CBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1981F00894;
	Wed, 20 May 2026 17:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299973;
	bh=btJOTmid8lkO9uN07eDu8PvfGiKZlTJxA9BAGXLZRBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eV964CBDxkWCY/SxR9TtCvozYtH7QA6SkH4akUOXSG9bQwCVx1msNiUbVfHzVf3qn
	 oiXpDNHP8py+eLf+kg3bhIToP+Aek+vAXb1dnge5Pkljg6ej9NFRzOxAbse/CCjKtg
	 eFMlClZk2sFRN7qD6TJ0D+PPD0F6D/Mb8BAeBbS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yash Shah <yash.shah@sifive.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 957/957] spi: sifive: fix controller deregistration
Date: Wed, 20 May 2026 18:24:00 +0200
Message-ID: <20260520162155.356504864@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
@@ -393,7 +393,7 @@ static int sifive_spi_probe(struct platf
 	dev_info(&pdev->dev, "mapped; irq=%d, cs=%d\n",
 		 irq, host->num_chipselect);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "spi_register_host failed\n");
 		goto put_host;
@@ -412,8 +412,14 @@ static void sifive_spi_remove(struct pla
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


