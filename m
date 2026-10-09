Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686403BD64D;
	Fri,  9 Oct 2026 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556870; cv=none; b=LclBWfWtiH7KhfKFde8y7OdTMCTTysZh3vHDk2J0rlG2THb9YX3EdcGPEXz4OPU5t74JStXkZBuyqXCUb0X8uz86j+ldtoIgkP7YimPdnDm+geuHNRoeaA8YHcvn3zt61KWaYLPe7vTnuJ3GsA1xaFLlhzfH5OiuPSkHVIiY6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556870; c=relaxed/simple;
	bh=W+8fFEu9+uODtQwhpQoJMT0GU6M6we3qZiZrarASnK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMMi/3yMbOJjS0/HuXAegcGKwmYXLsYaW4a/zid1hTH1Rz3rtJ4uioH+mH2wZQAvHicqyPlTTkpM2ZzxMQ3nXONfk0tg6TanWwg7THopfmx2ivWXP5pMzpnAk0xDYoO7vJtFZsA48EqCN0CObySCVnPxrozWUxVEphYLEtHo9VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm1x8AyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm1x8AyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29B51F000FF;
	Fri,  9 Oct 2026 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556868;
	bh=JpZlLEM/8b3T76edRESjngSroMKwzn0FGZNJ2cor5mM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm1x8AyFhHue95uzuUJuu6woYeEvO4eaOX1ji710ER7oVJrv9rDJZZ1809AEEA/dw
	 izOvwQzzmwVb113U1gGCzSE4nMfD/ZQPojB+lOhHZ21du0YnHE4s9cfpzk/mMYGyFk
	 jkQUauhL1wLSOKZIUYUi8tNcTxmp/5Iqzduguesk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 306/403] iio: adc: ade9000: request interrupts after powering the device
Date: Fri,  9 Oct 2026 16:11:07 +0200
Message-ID: <20261009140959.371128846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 88fda1ed51a579eb51980436abc6557006a520a3 upstream.

The IRQ handlers do SPI register accesses, but the interrupts were
requested before the vdd regulator was enabled. An interrupt arriving
while the chip is unpowered runs a handler against a dead chip, causing
SPI errors or garbage reads.

Request the interrupts after enabling the regulator. This keeps irq1
registered before ade9000_reset(), which waits on it, and lets devm free
the interrupts before the regulator is disabled.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -1711,18 +1711,6 @@ static int ade9000_probe(struct spi_devi
 	if (ret)
 		return ret;
 
-	ret = ade9000_request_irq(dev, "irq0", ade9000_irq0_thread, indio_dev);
-	if (ret)
-		return ret;
-
-	ret = ade9000_request_irq(dev, "irq1", ade9000_irq1_thread, indio_dev);
-	if (ret)
-		return ret;
-
-	ret = ade9000_request_irq(dev, "dready", ade9000_dready_thread, indio_dev);
-	if (ret)
-		return ret;
-
 	/* External CMOS clock input (optional - crystal can be used instead) */
 	st->clkin = devm_clk_get_optional_enabled(dev, NULL);
 	if (IS_ERR(st->clkin))
@@ -1742,6 +1730,19 @@ static int ade9000_probe(struct spi_devi
 		return dev_err_probe(&spi->dev, ret,
 				     "Failed to get and enable vdd regulator\n");
 
+	/* Request IRQs only after powering the chip; the handlers do SPI access. */
+	ret = ade9000_request_irq(dev, "irq0", ade9000_irq0_thread, indio_dev);
+	if (ret)
+		return ret;
+
+	ret = ade9000_request_irq(dev, "irq1", ade9000_irq1_thread, indio_dev);
+	if (ret)
+		return ret;
+
+	ret = ade9000_request_irq(dev, "dready", ade9000_dready_thread, indio_dev);
+	if (ret)
+		return ret;
+
 	indio_dev->channels = ade9000_channels;
 	indio_dev->num_channels = ARRAY_SIZE(ade9000_channels);
 


