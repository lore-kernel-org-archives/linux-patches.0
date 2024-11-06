Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB32E1DF241;
	Wed,  6 Nov 2024 12:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894816; cv=none; b=u/EdgpFpzaHmPU5zAavrxs82YfIAh4JwqZ5CoTZvwzyw5Pxe+OkSTf3v8whcuTydd5yUi700utZlOXGSofQ7raxXd9vvcFZUs5wTVWOTsTVbFJvw/5QNf3WAh6C6wnfiWnWRnkEQ0YAfdwjklWKIs9/VfHxyF1YXlygtX966KDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894816; c=relaxed/simple;
	bh=YdOlRUcrhtlhS+RXnT5vjn5Q3x1VWEi4ow6U+yLd/4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rb7TQJOamquIwGJ3qH+O05cO6LypaGVsUgqTnn4NpI2zWgtybYU//RHgjafHYHG675dPMrCRnlCyiwNGB5V9rCVdfOa2dNDagxe4QYjob0RkB9EVnEj/1VjCXZsbuQH9VBbO/eyT/O2Z9aE4YGCNza2EI8HFom+veQNjZUVcmRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI8qFsHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI8qFsHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC563C4CECD;
	Wed,  6 Nov 2024 12:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894815;
	bh=YdOlRUcrhtlhS+RXnT5vjn5Q3x1VWEi4ow6U+yLd/4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iI8qFsHBb0KdoD0dcy5juZ8ZMQRfor7PJxt55QJ15WU/DGMnSjhvKXv3cEsoz0zT3
	 N54942SkQAbjgAFAQtfSkUURl8XeyiMHxLJKN06mHhv834adZwjgr7k+C76XTc7dFq
	 lCtfZToLnE7NkU4I8UJxBtimKatB9wToJw6jY4XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beniamin Bia <beniamin.bia@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/350] staging: iio: frequency: ad9833: Load clock using clock framework
Date: Wed,  6 Nov 2024 12:58:50 +0100
Message-ID: <20241106120320.928707029@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beniamin Bia <biabeniamin@gmail.com>

[ Upstream commit 8e8040c52e63546d1171c188a24aacf145a9a7e0 ]

The clock frequency is loaded from device-tree using clock framework
instead of statically value. The change allow configuration of
the device via device-trees and better initialization sequence.
This is part of broader effort to add device-tree support to this driver
and take it out from staging.

Signed-off-by: Beniamin Bia <beniamin.bia@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: b48aa9917589 ("staging: iio: frequency: ad9834: Validate frequency parameter value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/frequency/ad9834.c | 35 ++++++++++++++++++--------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/iio/frequency/ad9834.c b/drivers/staging/iio/frequency/ad9834.c
index f6b36eedd48e..5e98ee5dfbdc 100644
--- a/drivers/staging/iio/frequency/ad9834.c
+++ b/drivers/staging/iio/frequency/ad9834.c
@@ -6,6 +6,7 @@
  * Licensed under the GPL-2.
  */
 
+#include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
 #include <linux/device.h>
@@ -71,7 +72,7 @@
 struct ad9834_state {
 	struct spi_device		*spi;
 	struct regulator		*reg;
-	unsigned int			mclk;
+	struct clk			*mclk;
 	unsigned short			control;
 	unsigned short			devid;
 	struct spi_transfer		xfer;
@@ -110,12 +111,15 @@ static unsigned int ad9834_calc_freqreg(unsigned long mclk, unsigned long fout)
 static int ad9834_write_frequency(struct ad9834_state *st,
 				  unsigned long addr, unsigned long fout)
 {
+	unsigned long clk_freq;
 	unsigned long regval;
 
-	if (fout > (st->mclk / 2))
+	clk_freq = clk_get_rate(st->mclk);
+
+	if (fout > (clk_freq / 2))
 		return -EINVAL;
 
-	regval = ad9834_calc_freqreg(st->mclk, fout);
+	regval = ad9834_calc_freqreg(clk_freq, fout);
 
 	st->freq_data[0] = cpu_to_be16(addr | (regval &
 				       RES_MASK(AD9834_FREQ_BITS / 2)));
@@ -413,7 +417,14 @@ static int ad9834_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 	st = iio_priv(indio_dev);
 	mutex_init(&st->lock);
-	st->mclk = 25000000;
+	st->mclk = devm_clk_get(&spi->dev, NULL);
+
+	ret = clk_prepare_enable(st->mclk);
+	if (ret) {
+		dev_err(&spi->dev, "Failed to enable master clock\n");
+		goto error_disable_reg;
+	}
+
 	st->spi = spi;
 	st->devid = spi_get_device_id(spi)->driver_data;
 	st->reg = reg;
@@ -458,31 +469,32 @@ static int ad9834_probe(struct spi_device *spi)
 	ret = spi_sync(st->spi, &st->msg);
 	if (ret) {
 		dev_err(&spi->dev, "device init failed\n");
-		goto error_disable_reg;
+		goto error_clock_unprepare;
 	}
 
 	ret = ad9834_write_frequency(st, AD9834_REG_FREQ0, 1000000);
 	if (ret)
-		goto error_disable_reg;
+		goto error_clock_unprepare;
 
 	ret = ad9834_write_frequency(st, AD9834_REG_FREQ1, 5000000);
 	if (ret)
-		goto error_disable_reg;
+		goto error_clock_unprepare;
 
 	ret = ad9834_write_phase(st, AD9834_REG_PHASE0, 512);
 	if (ret)
-		goto error_disable_reg;
+		goto error_clock_unprepare;
 
 	ret = ad9834_write_phase(st, AD9834_REG_PHASE1, 1024);
 	if (ret)
-		goto error_disable_reg;
+		goto error_clock_unprepare;
 
 	ret = iio_device_register(indio_dev);
 	if (ret)
-		goto error_disable_reg;
+		goto error_clock_unprepare;
 
 	return 0;
-
+error_clock_unprepare:
+	clk_disable_unprepare(st->mclk);
 error_disable_reg:
 	regulator_disable(reg);
 
@@ -495,6 +507,7 @@ static int ad9834_remove(struct spi_device *spi)
 	struct ad9834_state *st = iio_priv(indio_dev);
 
 	iio_device_unregister(indio_dev);
+	clk_disable_unprepare(st->mclk);
 	regulator_disable(st->reg);
 
 	return 0;
-- 
2.43.0



