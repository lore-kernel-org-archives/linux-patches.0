Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC2B37F8A0;
	Mon, 23 Mar 2026 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275035; cv=none; b=Gxtx4kC4Hbpw+sXmKdqurONNNJVmZGiDVpbtfh1TV6vzN58O+xB0S5iSuLVwvWB9/b9xeYa9Vc1Pz+9fgGIj+Z7rTHef0h/mhgDLJO4F8m3Sxmr77QzcntIx3sCy9rGGNmh4DS1eZH/FJFZuDbLiCQyHPk6m+JIH1pjZlW2c5rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275035; c=relaxed/simple;
	bh=y6NnalIZrokRanI19mudz7gNGNX21B5a8Droz8lX/9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2yMk6eSuc033pbXPHg59C2nrG3oUZRR8dDXH5n7Qt1Q62yIpXVj+6+HIEDrmKKITFrz0IYkEm+f1ur0w/5DxyYUkj7fWjPy3kO/Z9MStJVm+iV+3NHZwPV1hF3Fs4C6N8ECxaL8gObe1xW+3wTH/w5sEkjIgc47PQuViqDBeUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3OFLDbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3OFLDbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E75C4CEF7;
	Mon, 23 Mar 2026 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275035;
	bh=y6NnalIZrokRanI19mudz7gNGNX21B5a8Droz8lX/9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3OFLDbnq7+pUbMfHEBkkkKhJiYtIAyb8J4OZvoATzAm58MZhAft44LZ8gtV62kIX
	 nzHU/w7gkNfDINias/jcf3yBlWnoxrwJKFCpujT/dIzhuY5AKrZ4HrJe8nxDVOMynv
	 gJfRPfbUXUZcqvdSwRv18XD+pfm7MJbvgau2iH9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 199/212] spi: amlogic-spisg: Fix memory leak in aml_spisg_probe()
Date: Mon, 23 Mar 2026 14:47:00 +0100
Message-ID: <20260323134510.079182185@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit b8db9552997924b750e727a625a30eaa4603bbb9 ]

In aml_spisg_probe(), ctlr is allocated by
spi_alloc_target()/spi_alloc_host(), but fails to call
spi_controller_put() in several error paths. This leads
to a memory leak whenever the driver fails to probe after
the initial allocation.

Convert to use devm_spi_alloc_host()/devm_spi_alloc_target()
to fix the memory leak.

Fixes: cef9991e04ae ("spi: Add Amlogic SPISG driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260308-spisg-v1-1-2cace5cafc24@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spisg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-amlogic-spisg.c b/drivers/spi/spi-amlogic-spisg.c
index bcd7ec291ad07..6045c89c37c83 100644
--- a/drivers/spi/spi-amlogic-spisg.c
+++ b/drivers/spi/spi-amlogic-spisg.c
@@ -729,9 +729,9 @@ static int aml_spisg_probe(struct platform_device *pdev)
 	};
 
 	if (of_property_read_bool(dev->of_node, "spi-slave"))
-		ctlr = spi_alloc_target(dev, sizeof(*spisg));
+		ctlr = devm_spi_alloc_target(dev, sizeof(*spisg));
 	else
-		ctlr = spi_alloc_host(dev, sizeof(*spisg));
+		ctlr = devm_spi_alloc_host(dev, sizeof(*spisg));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -750,10 +750,8 @@ static int aml_spisg_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(spisg->map), "regmap init failed\n");
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		ret = irq;
-		goto out_controller;
-	}
+	if (irq < 0)
+		return irq;
 
 	ret = device_reset_optional(dev);
 	if (ret)
@@ -818,8 +816,6 @@ static int aml_spisg_probe(struct platform_device *pdev)
 	if (spisg->core)
 		clk_disable_unprepare(spisg->core);
 	clk_disable_unprepare(spisg->pclk);
-out_controller:
-	spi_controller_put(ctlr);
 
 	return ret;
 }
-- 
2.51.0



