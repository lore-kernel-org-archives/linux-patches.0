Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FBA46DFF2;
	Tue, 21 Jul 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656736; cv=none; b=Z8LFoRiRdI1R2ui4tODr0aM15h6jGn5Rz8nbKJKGFDWpXtB5vRGQrDapWrG9Ipo60P2jfIKz8tm62ufQTBS5OWG9cgxDFW63jN42fHWawVBgM4IqiobX4JMwlV6HYq08XeKGYlnhIwZ12Mi62I/zW1eGI7kbhOtxJKIV8KL2hVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656736; c=relaxed/simple;
	bh=8fLG/DSSMJJiH3O9rptdW7iCOqg42sZCR2qahTpTV4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvCxvwZb7gRTyC+nosU79qle03D6aGMyfR8nfiYrGzQ97OiywreZpO4R6iBQr/7BtB+bION+MUcYyxcikNIkXu7c64BjlPR01pSLN3jGznfZT7P07ilRrapkwoBHmndKul8tPoR9UaHga7qxAUKIgp3EgAc4BggZ0ZeYeBGTeic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itZHCb38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itZHCb38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE461F000E9;
	Tue, 21 Jul 2026 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656734;
	bh=SSZiGRHO+Z59JOGJK0HR7jnqjTLCd2kLR32Uv6gZdbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itZHCb38GxMkh+uELbam3qMo9BxNEzvb3F0OLWJO2VDs9IdkKcSG07M/4J9d0grDo
	 M5DpWxjyBNU5sq5P4MFS1slEghVoqUQeLCFUHFd+x7u0rKncvKhkXIcDR37xv5TvL9
	 4g5QhfZ6Kn+HahhPdRdDoMd6I9SqpoEoDybAvG1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lars=20P=C3=B6schel?= <lars.poeschel@edag.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0498/1611] spi: xilinx: use FIFO occupancy register to determine buffer size
Date: Tue, 21 Jul 2026 17:10:14 +0200
Message-ID: <20260721152526.544948224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars Pöschel <lars.poeschel@edag.com>

[ Upstream commit 47f3b5365536e8c38f264824ab15fdb74454e066 ]

The method the driver uses to determine the size of the FIFO has a
problem. What it currently does is this:
It stops the SPI hardware and writes to the TX FIFO register until TX
FIFO FULL asserts in the status register. But the hardware does not only
have the FIFO, it also has a shift register which can hold a byte. This
can be seen, when writing a byte to the FIFO (while the SPI hardware is
stopped,) the TX FIFO EMPTY is still empty. So, if we have a FIFO size
of 16 for example, the current method returns a 17.
This is a problem, at least when using the driver in irq mode. The same
size determined for the TX FIFO is also assumed for the RX FIFO. When a
SPI transaction wants to write the amount of the FIFO size or more
bytes, the following happens, for example with 16 bytes FIFO size:
The driver stops the SPI hardware and writes 17 bytes to the TX FIFO and
starts the SPI hardware and goes sleep.
The hardware then shifts out 17 bytes (FIFO + shift register) and
simultaneously reads bytes into the RX FIFO, but it only has 16 places,
so it looses one byte. Then TX FIFO empty asserts, wakes the driver
again, which has a fast path and reads 16 bytes from the RX FIFO, but
before reading the last 17th byte (which is lost) it does this:

	sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
	if (!(sr & XSPI_SR_RX_EMPTY_MASK)) {
		xilinx_spi_rx(xspi);
		rx_words--;
	}

It reads the status register and checks if the RX FIFO is not empty.
But it is empty in our case. So this check spins in a while loop
forever locking the driver.

This patch fixes the logic to determine the FIFO size.

Fixes: 4c9a761402d7 ("spi/xilinx: Simplify spi_fill_tx_fifo")
Signed-off-by: Lars Pöschel <lars.poeschel@edag.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260612105244.9076-1-lars.poeschel.linux@edag.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-xilinx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index c86dc56f38b456..8085571913c8b5 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -371,11 +371,18 @@ static int xilinx_spi_find_buffer_size(struct xilinx_spi *xspi)
 		xspi->regs + XIPIF_V123B_RESETR_OFFSET);
 
 	/* Fill the Tx FIFO with as many words as possible */
-	do {
+	while (1) {
 		xspi->write_fn(0, xspi->regs + XSPI_TXD_OFFSET);
 		sr = xspi->read_fn(xspi->regs + XSPI_SR_OFFSET);
+		if (sr & XSPI_SR_TX_FULL_MASK)
+			break;
+
 		n_words++;
-	} while (!(sr & XSPI_SR_TX_FULL_MASK));
+	}
+
+	/* Handle the NO FIFO case separately */
+	if (!n_words)
+		return 1;
 
 	return n_words;
 }
-- 
2.53.0



