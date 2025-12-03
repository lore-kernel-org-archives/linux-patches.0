Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0F932ABC7;
	Wed,  3 Dec 2025 15:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776990; cv=none; b=sVg7zXqbJSY4Dsw6A+EUiAaTrzS03U8iAF87j74xa9xU7ACK79HwInJstLLJdgVyHdMc+LiRUcYDFqq3Tnd00iR6okIUPGnm3NM8CAZ5/ft7dgK0ZEWiKhj6UtjvA9XFv8wp917erEv3DB8Xiua61NOPhX7dn1+YVZLAjy1gN50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776990; c=relaxed/simple;
	bh=vM1cwB9prmsd8+CChzJ1kerK1EnHDd2lY6UpGI/oZvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOEM1bdhXNorTEbOn1XQYT/QKFI+Z+pjyTqdJcpw5VnvZGtLKEN7vl3ek61DobJBoyTwEWBbTQNHczUMktBPdsZQ4Gn9Hx8M3Q2z05zf7a3TJL/uoVayyoVXBCjhdhObGYKh6mHi7AWMmlQZ7uKZmS7/ntvxugRdJxZTBtPGSKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8L34++b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8L34++b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716CEC4CEF5;
	Wed,  3 Dec 2025 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776989;
	bh=vM1cwB9prmsd8+CChzJ1kerK1EnHDd2lY6UpGI/oZvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8L34++bX/FbvdY2kl1kcD5p0VDC7HCV/wodQ/SHJDv7Q6HuRZ0r7I2aLPdQMgn8q
	 VqlNo2dWGK0NA1AVXEwZP8Mg4NhpnZEi523hfxiKVzu9OqYWbf2Dr9oGS9I9Nw0GYX
	 9ozD9FtBIEtq65KBbSNfsHsG7te9s+lHfKt5JfIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Zhou <929513338@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 049/146] spi: bcm63xx: fix premature CS deassertion on RX-only transactions
Date: Wed,  3 Dec 2025 16:27:07 +0100
Message-ID: <20251203152348.267336518@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b56210734caaf..2e3c62f12bef9 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -247,6 +247,20 @@ static int bcm63xx_txrx_bufs(struct spi_device *spi, struct spi_transfer *first,
 
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



