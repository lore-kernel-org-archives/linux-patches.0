Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998573587AE;
	Wed,  3 Dec 2025 16:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780300; cv=none; b=Ybh4AtvUNU7l502RxZUgsUqbdmr2tBLKo+DBuZCzHyIuRgRivzaPti1UtrLG0pSYAooICi+qJPCI6aFRjvHhrSOQ7aF/AAJkdOeJ9euGOsv9AW86vzeMTTIfijC23tzhHRxRfryjFsLI6C8uZ8I/VU6NkKRJBZbehhgQzY7fXjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780300; c=relaxed/simple;
	bh=XOaQIIx0SdO9qv59eBc7g5M9XJIwjP6t7tq90M11Bnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3bGU3N53QpMTJzGdFOoD02ynCWWKDbeIaUk0iUzFgL3HvSHCKc1ExaQ3S4qQsT2dunkhtMx0ZXFIfEbEGQJlRMIc8V00MnQOAS/0UBqur36nPxMotfYMDxyoT/5hPW9SL2NKSgtSZuh3BDzjlFaL6wdSk0Qh7rK71m5W68F7C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nascdf6K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nascdf6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8285C4CEF5;
	Wed,  3 Dec 2025 16:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780300;
	bh=XOaQIIx0SdO9qv59eBc7g5M9XJIwjP6t7tq90M11Bnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nascdf6Ki3QvBszYA40fgEY1p4BAshmiigS/hjWAAcn5dFxYAPI6zx1UeZKssDNd+
	 XnXeIvm8JX5QIQ619anZmwUBvBJN/WVRPp0D2Sv3xMZWjJclpcCDSp8BcQPtHXSEBH
	 fv3CA7nM+TL3ImfTdzvxOtXR1REfGvLdOm0U+FnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Zhou <929513338@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 515/568] spi: bcm63xx: fix premature CS deassertion on RX-only transactions
Date: Wed,  3 Dec 2025 16:28:37 +0100
Message-ID: <20251203152459.577127878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hang Zhou <929513338@qq.com>

[ Upstream commit fd9862f726aedbc2f29a29916cabed7bcf5cadb6 ]

On BCM6358 (and also observed on BCM6368) the controller appears to
only generate as many SPI clocks as bytes that have been written into
the TX FIFO. For RX-only transfers the driver programs the transfer
length in SPI_MSG_CTL but does not write anything into the FIFO, so
chip select is deasserted early and the RX transfer segment is never
fully clocked in.

A concrete failing case is a three-transfer MAC address read from
SPI-NOR:
  - TX 0x03 (read command)
  - TX 3-byte address
  - RX 6 bytes (MAC)

In contrast, a two-transfer JEDEC-ID read (0x9f + 6-byte RX) works
because the driver uses prepend_len and writes dummy bytes into the
TX FIFO for the RX part.

Fix this by writing 0xff dummy bytes into the TX FIFO for RX-only
segments so that the number of bytes written to the FIFO matches the
total message length seen by the controller.

Fixes: b17de076062a ("spi/bcm63xx: work around inability to keep CS up")

Signed-off-by: Hang Zhou <929513338@qq.com>
Link: https://patch.msgid.link/tencent_7AC88FCB3076489A4A7E6C2163DF1ACF8D06@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 2f2a130464651..e57e1f75cd9f9 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -257,6 +257,20 @@ static int bcm63xx_txrx_bufs(struct spi_device *spi, struct spi_transfer *first,
 
 		if (t->rx_buf) {
 			do_rx = true;
+
+			/*
+			 * In certain hardware implementations, there appears to be a
+			 * hidden accumulator that tracks the number of bytes written into
+			 * the hardware FIFO, and this accumulator overrides the length in
+			 * the SPI_MSG_CTL register.
+			 *
+			 * Therefore, for read-only transfers, we need to write some dummy
+			 * value into the FIFO to keep the accumulator tracking the correct
+			 * length.
+			 */
+			if (!t->tx_buf)
+				memset_io(bs->tx_io + len, 0xFF, t->len);
+
 			/* prepend is half-duplex write only */
 			if (t == first)
 				prepend_len = 0;
-- 
2.51.0



