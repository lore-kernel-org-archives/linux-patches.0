Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627671A76AD;
	Tue, 30 Jul 2024 17:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360697; cv=none; b=gQ8bPOCJRgOtX5R1gW4JmaQEXpSn/+x5ROZUP+Y8O+KGU4OHRdYWf5X23PLMomGBO1Vwl+kH5lGCGZR8W5heqbKIwdY8Ka0wZ7TNSNUsvEsXJ4rze8UgaCCsh3GVK4CF3vf1arGc85MDUrOqHHbwMmMiWjmESK7jyPdkewyoaog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360697; c=relaxed/simple;
	bh=EA4Ac/i4V/YcpuxYfP21f88MvCTMVCYtawAudA4cvQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elD/UsFeETh/USCVAG+E9womMWbfPpNM69XnODxboK+lXiua6WlGdzaP6rsCkUAXzrGKWsbhV/+JJ1nCXajKl7EKENKJrskedR3bBoh/+JEdBZyz5MVPLG5rCcOQOlxQa0AJTLjuJKWAgoRIqI3rJ8WikpTX87K10tFdZu21WWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0AtPeCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0AtPeCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8100C32782;
	Tue, 30 Jul 2024 17:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360697;
	bh=EA4Ac/i4V/YcpuxYfP21f88MvCTMVCYtawAudA4cvQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0AtPeCjZM1A+w4nTiLAKalgHRBwJEmcFUiOwP0jxWuWSCp85VtSJw/Bi7n6J78pk
	 sV50ZR0g3fcav8ldViaNMysNGBrIn5F1bTMlkBEKS6rr5ewNGeSRAn8Y3d35C6DClH
	 ajOzjrVMLdw+F5RNF3N7D4osmN+feq3dx/pzxwsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 779/809] spi: microchip-core: fix the issues in the isr
Date: Tue, 30 Jul 2024 17:50:55 +0200
Message-ID: <20240730151755.736805063@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c10de45aa4729..003a2bc3cfd1b 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -380,21 +380,18 @@ static irqreturn_t mchp_corespi_interrupt(int irq, void *dev_id)
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
@@ -479,8 +476,9 @@ static int mchp_corespi_transfer_one(struct spi_controller *host,
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



