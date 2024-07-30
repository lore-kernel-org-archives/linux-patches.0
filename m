Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACFF183CC3;
	Tue, 30 Jul 2024 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358813; cv=none; b=DVHNohhqfbb0xJIHbnHSM5wODk3+/yLTO03lZVgH19ACLV4Rqn6FrBzQVF4uwsB1qtf0gl9n0CDgHLcowyTy6DiDe4ZxEhsN9Vn9LJ/MTlxPSFVFO02sJpT8TMzR4pkgcG4ogvrSbNpJ4MQfKWCrLAu4MIBNWP5vd502OkeKUpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358813; c=relaxed/simple;
	bh=/JMNEozdpW+oxDyO18SeEgdooVKZ1UwgJS1bW8oTgn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NT5ghTN/xGIYneP9TjI1pZYBlKHNdw6DrkxcJJLOfn+jSAqfkpIAdAnaks+byEdElJwz4YArt6pZ0xCfhqzVgHWTSTd8QdlWplI9pZgoV0BkBhsvI54iq0CnsY7LvK3YQHLDGHRBlopn829SJTo3y938H5Abba3ipRn4Z3d7RR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh+ICCo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh+ICCo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D870C32782;
	Tue, 30 Jul 2024 17:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358813;
	bh=/JMNEozdpW+oxDyO18SeEgdooVKZ1UwgJS1bW8oTgn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh+ICCo7mUVICMo60w69CWkcWEITElivB0ScH5M1hamevmZ9wMNgLegzSKt4zn1Dm
	 8uvbdjL7mPrpTGs2EA0igYqQi/+ay1npyLMYAGETAPclKXLiajyeSqVD7xyRUcFFbg
	 OhhYcIRDC/mivNO00mYkJVZi9il0sPXNt8FgkWh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 424/440] spi: microchip-core: fix the issues in the isr
Date: Tue, 30 Jul 2024 17:50:57 +0200
Message-ID: <20240730151632.343728807@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>

[ Upstream commit 502a582b8dd897d9282db47c0911d5320ef2e6b9 ]

It is possible for the TXDONE interrupt be raised if the tx FIFO becomes
temporarily empty while transmitting, resulting in recursive calls to
mchp_corespi_write_fifo() and therefore a garbage message might be
transmitted depending on when the interrupt is triggered. Moving all of
the tx FIFO writes out of the TXDONE portion of the interrupt handler
avoids this problem.

Most of rest of the TXDONE portion of the handler is problematic too.
Only reading the rx FIFO (and finalising the transfer) when the TXDONE
interrupt is raised can cause the transfer to stall, if the final bytes
of rx data are not available in the rx FIFO when the final TXDONE
interrupt is raised. The transfer should be finalised regardless of
which interrupt is raised, provided that all tx data has been set and
all rx data received.

The first issue was encountered "in the wild", the second is
theoretical.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Signed-off-by: Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20240715-candied-deforest-585685ef3c8a@wendy
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-microchip-core.c b/drivers/spi/spi-microchip-core.c
index d4c08d3668741..202ac889b5ae2 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -389,21 +389,18 @@ static irqreturn_t mchp_corespi_interrupt(int irq, void *dev_id)
 	if (intfield == 0)
 		return IRQ_NONE;
 
-	if (intfield & INT_TXDONE) {
+	if (intfield & INT_TXDONE)
 		mchp_corespi_write(spi, REG_INT_CLEAR, INT_TXDONE);
 
+	if (intfield & INT_RXRDY) {
+		mchp_corespi_write(spi, REG_INT_CLEAR, INT_RXRDY);
+
 		if (spi->rx_len)
 			mchp_corespi_read_fifo(spi);
-
-		if (spi->tx_len)
-			mchp_corespi_write_fifo(spi);
-
-		if (!spi->rx_len)
-			finalise = true;
 	}
 
-	if (intfield & INT_RXRDY)
-		mchp_corespi_write(spi, REG_INT_CLEAR, INT_RXRDY);
+	if (!spi->rx_len && !spi->tx_len)
+		finalise = true;
 
 	if (intfield & INT_RX_CHANNEL_OVERFLOW) {
 		mchp_corespi_write(spi, REG_INT_CLEAR, INT_RX_CHANNEL_OVERFLOW);
@@ -488,8 +485,9 @@ static int mchp_corespi_transfer_one(struct spi_master *master,
 	mchp_corespi_set_xfer_size(spi, (spi->tx_len > FIFO_DEPTH)
 				   ? FIFO_DEPTH : spi->tx_len);
 
-	if (spi->tx_len)
+	while (spi->tx_len)
 		mchp_corespi_write_fifo(spi);
+
 	return 1;
 }
 
-- 
2.43.0



