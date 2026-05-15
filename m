Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D8930569C;
	Fri, 15 May 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862572; cv=none; b=A89WaEmxEa445ViBImjyjbAJ647gH52JExHMzJpgvx5p+POBLjHQQyzhDR85O0XQLmoSDU6EWCfGlXg1yAX+hf1/1DNGk43G56XGoJCwb5vDn7qYIRAlpV7oRIFHZIgEHchlP0Wm+s5stYRqZemZZXtMRazpw9M+7R3Nnw/LZR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862572; c=relaxed/simple;
	bh=iudBr4CraeU3Hrh3KyQUb71fLtRVzs8oIISkh9Nmfh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUe63qive1c9xLA5nw+ztK4sVexCBYC0KNj5z7MN2yFgOKAuIjvb8OjP9H2rEkiqk/BOdDEnJHVxP7YDJepPqMNGO44N6ajggvZOFriwut+ZkowxSuArwuQT6/uJeBHH9j1yZhc33qz16of8GD/qu87FJFT+OO8NBoC1V+TbCDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2XbAv9zK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2XbAv9zK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6D4C2BCB0;
	Fri, 15 May 2026 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862572;
	bh=iudBr4CraeU3Hrh3KyQUb71fLtRVzs8oIISkh9Nmfh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2XbAv9zK+C/aJ3xOrvfM728FMzggdfysfW2LeHtp7ocIqibxHxJdr78nGMVhGnkX/
	 P7IkG4+Rp1OrFFgigxj1CM+j5wDXrR9hKSnEVwkwWopIgE9p6BB/6eC05lU+myasT1
	 E5ycejX6yIupMEj5ZOgRy/JaRU9fQDGkbqhfnBmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lanqing Liu <lanqing.liu@spreadtrum.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 101/201] spi: sprd: fix controller deregistration
Date: Fri, 15 May 2026 17:48:39 +0200
Message-ID: <20260515154700.728347340@linuxfoundation.org>
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

commit 123d17dbc5f07059752fa5e616385ca29a8f935a upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Note that the controller is suspended before disabling and releasing
resources since commit de082d866cce ("spi: sprd: Add the SPI irq
function for the SPI DMA mode") which avoids issues like unclocked
accesses but prevents SPI device drivers from doing I/O during
deregistration.

Fixes: e7d973a31c24 ("spi: sprd: Add SPI driver for Spreadtrum SC9860")
Cc: stable@vger.kernel.org	# 4.20
Cc: Lanqing Liu <lanqing.liu@spreadtrum.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-17-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sprd.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -977,7 +977,7 @@ static int sprd_spi_probe(struct platfor
 		goto err_rpm_put;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, sctlr);
+	ret = spi_register_controller(sctlr);
 	if (ret)
 		goto err_rpm_put;
 
@@ -1008,7 +1008,9 @@ static void sprd_spi_remove(struct platf
 	if (ret < 0)
 		dev_err(ss->dev, "failed to resume SPI controller\n");
 
-	spi_controller_suspend(sctlr);
+	spi_controller_get(sctlr);
+
+	spi_unregister_controller(sctlr);
 
 	if (ret >= 0) {
 		if (ss->dma.enable)
@@ -1017,6 +1019,8 @@ static void sprd_spi_remove(struct platf
 	}
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(sctlr);
 }
 
 static int __maybe_unused sprd_spi_runtime_suspend(struct device *dev)


