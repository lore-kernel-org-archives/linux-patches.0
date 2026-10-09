Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FEB2EBBAF;
	Fri,  9 Oct 2026 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557496; cv=none; b=XKpgr/cs8qDAkic4fcFg4h+k4NE+2lB7G5tx4cXSsOur7krIUtYLSaiuv+ElhrPCCbPakn9MrBCR1f0kLAUfuQrkJtCpjtmG+oB8XTOZVDmk3U+WzRUwUwZfg/u8y7CBhqRAoMjI4UhpqB+NEd3GWKH4o6KTHxVNH6NyXSae3u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557496; c=relaxed/simple;
	bh=5x2GM5BxAmV+cbreb/Azb82CgpiXQ19ByDk1lwY3HJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPmKyUi5bfdHhGriw5F3eNJC8dRJLNtcYl9AZgYXu/zIYkm4cqcoI7pvtCg0BzJZ/qpiP+Ik5kaFEM26xbJhiO3rRlqRtfPrMaaXi+Drms4cLf7wOqei423O//T6te2cxplpppnRIuVAUlmJNKJ4OTWjEO6vk49zQiAo9zDuoyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLgsHDaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLgsHDaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EE11F000FF;
	Fri,  9 Oct 2026 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557495;
	bh=xq/NGAv5w5D3CfiLPsQQUAPf0mprQ3nvjJIwBHUD02U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLgsHDaqIfp5ssDStu7Cwj/5cWexJmi6FP1MG8MxXwpuMriIuMAfWK4wCwn2r4k0f
	 xoJPvvRn8sFqc7Gfot7vmL0oWkI5FwefMs1tnfnmYXvW0nf3MCOYpc2u8BBT0tyy+S
	 EeoJVBjRmG+yq9dbOgJ882/zH0HfhuDnUJF3PYqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 379/428] iio: adc: ade9000: request interrupts after powering the device
Date: Fri,  9 Oct 2026 16:11:56 +0200
Message-ID: <20261009140954.517266674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1706,18 +1706,6 @@ static int ade9000_probe(struct spi_devi
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
@@ -1737,6 +1725,19 @@ static int ade9000_probe(struct spi_devi
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
 


