Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D2B34A799;
	Wed,  3 Dec 2025 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780649; cv=none; b=kbLzy5oxz1BGp4ZG/YfxVEroXW5ITIb4rkMWxqJdIweRnYekOL5NGlcoqVPMlcdwHZyGILKd6kUmD6+ja0pZnyxiFrE52xzl8rbhFCfjojyqcyjqp/1HPPVMJoQo8THwO5eIJ5slpy1kvvyu9fUeG/V7UiQr/pHo1E8XroVAc9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780649; c=relaxed/simple;
	bh=G43P2ApgC3Vf4pZYxL4C83yYAupkbG2a57swGufRa2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yir0YSBTgwkCyb11+zTbiDY1xvJuoqRvOvjGfNSnGHKVYy5LXvQl3L3AjOPGcwXI82q/ixRTYv4MqEVKFaE7fTVhcFGT2CCnmKNCu2WanclRAPLF57eWoAC2OqFkuQ4VOzOzzGIJhs/ZLbdLa/2gJ6eq5BYpw5JxhTL3+61XkYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDKQWDjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDKQWDjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB49C4CEF5;
	Wed,  3 Dec 2025 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780649;
	bh=G43P2ApgC3Vf4pZYxL4C83yYAupkbG2a57swGufRa2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDKQWDjor2rKD4g/KPTQQia4NsSnttERaN3t5ke80bNr+kJJcAdOB6doUIn3JTTgM
	 IZoHPyiRwUfbGcVV3nL3sUBIcCDQPRmoXMbw8inLhS6Bhu/1xw/cCciLg4j8z4BcCV
	 jRpyAVoerjiueHW6+Y1IYXFjju86BL6J/Cd+J96Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hang Zhou <929513338@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/132] spi: bcm63xx: fix premature CS deassertion on RX-only transactions
Date: Wed,  3 Dec 2025 16:28:47 +0100
Message-ID: <20251203152345.074692392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a95badb7b7114..ba66fe9f1f543 100644
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



