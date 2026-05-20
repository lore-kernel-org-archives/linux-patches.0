Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627CC373BEB;
	Wed, 20 May 2026 16:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295075; cv=none; b=DL5HDvDtoctEMgcHB1/2EQdkcbYQtzw+v3xTxagoOLo7UpQ1P/ZlIn4gsLdm3thmbUcUU0WdKVnhyYASL+VbY5J9k0k9kVaeAz3I/tAFKIrce0Ze0t1gcLQlc2PI+LzpabKkyST3MYjPZKPB64Cg9/ogZrU2MxPZmCowMUBkfPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295075; c=relaxed/simple;
	bh=T5FD6XFPyv/MdubG2NrivpxnaCwos4euYP5jGynDIUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nzcy9f8BrCI07rXlHtbD9KGwQsMJumnbU15Z4PuGi1luyBf75bg2SdoNcgmrfz4z5R40ArBvSPIgyKU3vOz915EDCLZH23geFUq4tl2K3Z42VLoLC2uPsprXH0lcQYMF7rOY11VwH+fyblw+e3O3s+7/tBHsLkEYgOn1piZmawE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bokxJI3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bokxJI3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D761F000E9;
	Wed, 20 May 2026 16:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295074;
	bh=yNm0ryTY5cF6Bqg/pHC8wkuY2SP1WIlLt1lJLv8NPuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bokxJI3Nw8c7w4eO/N6peQo7Lxvlt91szIQCrMvs8bQw8FA89APoIEi2KCKCybX0L
	 EBTpoOAwW4aqmZP1KPH95LUDXRH3PPYVPVr2aFZNfocNBHFQE8Ws4VFmIf1Yp5bg0N
	 R9HqD/d2NVEh/IrRsQKUO9UWj02YEGEfJ75vqPdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0281/1146] spi: atcspi200: fix mutex initialization order
Date: Wed, 20 May 2026 18:08:51 +0200
Message-ID: <20260520162154.575348582@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 869d5b4b2a8012f6ef6058a1055cac6922c2cb55 ]

The atcspi_exec_mem_op() function may call mutex_lock() on the
driver's mutex before it is properly initialized if a SPI memory
operation is initiated immediately after devm_spi_register_controller()
is called. The mutex initialization currently occurs after the
controller registration, which leaves a window where the mutex could
be used uninitialized.

Move the mutex initialization to the beginning of the probe function,
before any registration or resource allocation.

Fixes: 34e3815ea459 ("spi: atcspi200: Add ATCSPI200 SPI controller driver")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/15a71241affc25108a97d40d9d3dd1bc3d2d69ed.1773282905.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atcspi200.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-atcspi200.c b/drivers/spi/spi-atcspi200.c
index 2665f31a49ceb..02517af9e3987 100644
--- a/drivers/spi/spi-atcspi200.c
+++ b/drivers/spi/spi-atcspi200.c
@@ -567,6 +567,8 @@ static int atcspi_probe(struct platform_device *pdev)
 	spi->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, host);
 
+	mutex_init(&spi->mutex_lock);
+
 	ret = atcspi_init_resources(pdev, spi, &mem_res);
 	if (ret)
 		goto free_controller;
@@ -597,7 +599,6 @@ static int atcspi_probe(struct platform_device *pdev)
 		else
 			spi->use_dma = true;
 	}
-	mutex_init(&spi->mutex_lock);
 
 	return 0;
 
@@ -605,6 +606,7 @@ static int atcspi_probe(struct platform_device *pdev)
 	clk_disable_unprepare(spi->clk);
 
 free_controller:
+	mutex_destroy(&spi->mutex_lock);
 	spi_controller_put(host);
 	return ret;
 }
-- 
2.53.0



