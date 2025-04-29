Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBCA27453;
	Tue, 29 Apr 2025 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946765; cv=none; b=VII+0fNby/nRdjjmpLKlP4qa13celdRB3+JqDohWVinzh09tha8McRMnhA7MUD2isS18ZtUV5TpNJtjQEGotSE+3Dfwmzl4B8u/+qNzN5INRGzd1zDw2dIoRxoZUfv/qj0YxPxmMQz5Z+gmwNnJINc/2M/Vwau+Jo1Tgs5xV0eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946765; c=relaxed/simple;
	bh=3QLrvJ+3pZPzLXI296ftCi2fWHoJNqgoIZDGedmPCNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahGzJWu1jQykn5wqRtdp6MmK5+WGq10QI0RLiJ6KgQ7JvMuAIirLrG6gpEdSZFLQqN74jGa0M4/JYx/v8AfdjqvxEEOsvwjcLHEpclqgiogYc3S3qQmeEfLGH/gFpGMBgNIFjAa4QoYrkn2KKHfd8dgJg5ImlE8af3RxnbqYTl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DoDZJrZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DoDZJrZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E72C4CEE3;
	Tue, 29 Apr 2025 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946765;
	bh=3QLrvJ+3pZPzLXI296ftCi2fWHoJNqgoIZDGedmPCNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DoDZJrZAfsrYV9f8/IJX73/YLhdMiOJNaDsWTT3feL9pgoypb3gZQ+YvrlqmVXu/W
	 HDyJlJvmFsZ3G+hxLkgX4LWy8yjZBVmbmNw0IiPTeIhpczmShPE38Poj8OIlfgUXxe
	 UmTMuCZQunLybX39yl2ELwwX8xKc4kpU9JGvwHk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 061/286] spi: cadence-qspi: Fix probe on AM62A LP SK
Date: Tue, 29 Apr 2025 18:39:25 +0200
Message-ID: <20250429161110.355110881@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit b8665a1b49f5498edb7b21d730030c06b7348a3c upstream.

In 2020, there's been an unnoticed change which rightfully attempted to
report probe deferrals upon DMA absence by checking the return value of
dma_request_chan_by_mask(). By doing so, it also reported errors which
were simply ignored otherwise, likely on purpose.

This change actually turned a void return into an error code. Hence, not
only the -EPROBE_DEFER error codes but all error codes got reported to
the callers, now failing to probe in the absence of Rx DMA channel,
despite the fact that DMA seems to not be supported natively by many
implementations.

Looking at the history, this change probably led to:
ad2775dc3fc5 ("spi: cadence-quadspi: Disable the DAC for Intel LGM SoC")
f724c296f2f2 ("spi: cadence-quadspi: fix Direct Access Mode disable for SoCFPGA")

In my case, the AM62A LP SK core octo-SPI node from TI does not
advertise any DMA channel, hinting that there is likely no support for
it, but yet when the support for the am654 compatible was added, DMA
seemed to be used, so just discarding its use with the
CQSPI_DISABLE_DAC_MODE quirk for this compatible does not seem the
correct approach.

Let's get change the return condition back to:
- return a probe deferral error if we get one
- ignore the return value otherwise
The "error" log level was however likely too high for something that is
expected to fail, so let's lower it arbitrarily to the info level.

Fixes: 935da5e5100f ("mtd: spi-nor: cadence-quadspi: Handle probe deferral while requesting DMA channel")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20250305200933.2512925-2-miquel.raynal@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1120,6 +1120,12 @@ static int cqspi_request_mmap_dma(struct
 	if (IS_ERR(cqspi->rx_chan)) {
 		int ret = PTR_ERR(cqspi->rx_chan);
 		cqspi->rx_chan = NULL;
+		if (ret == -ENODEV) {
+			/* DMA support is not mandatory */
+			dev_info(&cqspi->pdev->dev, "No Rx DMA available\n");
+			return 0;
+		}
+
 		return dev_err_probe(&cqspi->pdev->dev, ret, "No Rx DMA available\n");
 	}
 	init_completion(&cqspi->rx_dma_complete);


