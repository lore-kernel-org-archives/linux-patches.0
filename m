Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0618F32A3C9;
	Tue, 16 Jun 2026 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632241; cv=none; b=bw6fG5RQoKs0ceuPnpEHEfR3KZTNhPIobiMci07lNExZkkvxludZIvzR5vZC5BccpR9gyJG8K6cqK40WnILX+M1AJkB5Km9Q55ww04ktK97RXcVu/9mhUCTt2vmPI2KVT+KVr8tmrJ3+z6XPK88Mvsxah+GYHOlLowu6sGjZAnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632241; c=relaxed/simple;
	bh=LtC3Xhl94Tv9y2LAvGcpocHOpmN9cUYgXJgd56Dgpb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1PSbDeDM8otZAvbcjsww/rYEstX8NpsomNSsnTJZsxOOdcfaYaXSn1ComY+XpOL3iH7LmiinS5+bTcdHz8jEDULW+NsIhep2nguFbaB4SSoR10YY/yn6WCZGXv+izM7chcRnnLompbT17JvGgeyDQ6N3u4RQIt8L1wbr9IHgxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh4Y2iYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh4Y2iYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F224E1F00A3A;
	Tue, 16 Jun 2026 17:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632239;
	bh=h5w9Ef8VO2t+g0/yBzeUL4j7YWDYDcDtBtyA6Xc62V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eh4Y2iYcS+F1Tm1drAhTSDZnYnXYbAHOxfJjnTne/l9FG4nS9D6kmgOPbfC9BgFVP
	 sGj4Mb08TDcshHh/VVz/Revc6RGNgrE+MQXDRYquabMmWL1y6ojpFGZiTzmiMwNjVc
	 nZw6H7xWNiFRYJ+toUpXIcVwCCxnXYD6Qrsnw5cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 341/522] spi: imx: fix use-after-free on unbind
Date: Tue, 16 Jun 2026 20:28:08 +0530
Message-ID: <20260616145141.767931382@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 1c78c2002380a1fe31bfb01a3d5f29809e55a096 ]

The SPI subsystem frees the controller and any subsystem allocated
driver data as part of deregistration (unless the allocation is device
managed).

Take another reference before deregistering the controller so that the
driver data is not freed until the driver is done with it.

Fixes: 307c897db762 ("spi: spi-imx: replace struct spi_imx_data::bitbang by pointer to struct spi_controller")
Cc: stable@vger.kernel.org	# 5.19
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260324082326.901043-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1885,6 +1885,8 @@ static void spi_imx_remove(struct platfo
 	struct spi_imx_data *spi_imx = spi_controller_get_devdata(controller);
 	int ret;
 
+	spi_controller_get(controller);
+
 	spi_unregister_controller(controller);
 
 	ret = pm_runtime_get_sync(spi_imx->dev);
@@ -1898,6 +1900,8 @@ static void spi_imx_remove(struct platfo
 	pm_runtime_disable(spi_imx->dev);
 
 	spi_imx_sdma_exit(spi_imx);
+
+	spi_controller_put(controller);
 }
 
 static int __maybe_unused spi_imx_runtime_resume(struct device *dev)


