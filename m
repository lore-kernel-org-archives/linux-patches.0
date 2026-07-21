Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D063B6379;
	Tue, 21 Jul 2026 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666144; cv=none; b=idDdwuNO1ZmdngLWHbwTTuYFsuJOQA289CQJkewxTD5bWFDXS5q0hx054l5aNU4GU45KUley5BsSQBepm7uwAlDWAULlE5vwT0ExEGN6hA1gCwXt6WrpkWcNWcQpcrzurw98I/zoJyhpBtqiPQbyFa6LvY3CIWWHqLeVoEAU4gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666144; c=relaxed/simple;
	bh=IRqtjqUJdh9kGY7BbmMvqrs78ctXbo1iLZeVx6qnWMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQfzI11wPMAQBvP0jk5ZF3B9Xuvh0x6TblRwBZg1JALc95d5W8sz9MkrqB1P6+CLU3rotjBXDpymgko+esvokERHCJ/BU+zf+W98ybd033G0PRwKTvWajJc96jatjqyEFI7T9qWaiqsnVLXQ+giqVecLGqbak1wfU+iW/E8Gumw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8bftGnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8bftGnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34661F000E9;
	Tue, 21 Jul 2026 20:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666143;
	bh=LbrXHlkxJOpUrHZ7/h775KGzseHuc2PfDoN3ki91d04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8bftGnneoYCSCYmwor2f6KdXOfCFTddgKHLBQ2BEZDaw3F69RICIsGVb3y71oODC
	 QC8U18hUSRWfQaIIOPg5tj5uIgU34p+p5rkft97YdIGu4Yf+VE1rBoZGYZl/y6IA44
	 /1ofaT7/JLu19pgX3Pjnp3jzn2VbDXVsV8+sTyWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lars=20P=C3=B6schel?= <lars.poeschel@edag.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0571/1266] spi: xilinx: use FIFO occupancy register to determine buffer size
Date: Tue, 21 Jul 2026 17:16:48 +0200
Message-ID: <20260721152454.642930492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b5405d9974ba6b..36362bee7fff81 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -370,11 +370,18 @@ static int xilinx_spi_find_buffer_size(struct xilinx_spi *xspi)
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



