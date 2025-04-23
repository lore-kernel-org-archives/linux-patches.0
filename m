Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8D020D4F8;
	Wed, 23 Apr 2025 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420882; cv=none; b=nPmaiec9bSHrFUB3R6JFpz5843HwI9AQNgD5gy0sPD8rSx0RyD6UUItNGuBj2xxxJqwx1gLc9AjbhdBNV/bNRuRvhszUzIVfpUjC9ZGIwpg39Y5kc6OfeXJupf4Z/I5S5imdq2CODNe1KEufCNV2kvbOep0YXVd/QPJT58PMbCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420882; c=relaxed/simple;
	bh=nIbiu931ak4Wf1GsLbYTXwsvQjV7TMFaHc2tYA1qhPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIdw5w/3h0T/FjPJ7jK1ZkhHexoIl1xk+tOl6A7sXP9HoOMb61crGZ+HNU4727PvlkSP8SJOr61FSdaQPRVQsyZBVC/Cce1z5U2o+jx3BOtQKZO1EO8QhvgLMtqZOmpMt6lWFbypc7N0y7pp1cJOrBAaYmGEyccIjrTRvejfSXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i01kSkwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i01kSkwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37FDC4CEE3;
	Wed, 23 Apr 2025 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420882;
	bh=nIbiu931ak4Wf1GsLbYTXwsvQjV7TMFaHc2tYA1qhPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i01kSkwI46bdkxo39qHP+GVi/gNMnXQUiph5kuIKLmCHcWa5XMYr0r3vGwkS49pBc
	 +Fu7AH9g+7wL8VdcGjcmWZ4RZmjyZqbwjiWlFtOKQNpgTND0itaIG0qglOLztX3JCO
	 mQrwvjTDLGU376eogeowjlFf2koaaKmSPC+2qyak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 089/291] spi: cadence-qspi: Fix probe on AM62A LP SK
Date: Wed, 23 Apr 2025 16:41:18 +0200
Message-ID: <20250423142627.996981454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1509,6 +1509,12 @@ static int cqspi_request_mmap_dma(struct
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


