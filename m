Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5CF1A76A5;
	Tue, 30 Jul 2024 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360710; cv=none; b=M0Pkn8H3MItAEo+OnndMM6s2fwhvLhFYdNMkcKnsrmfVDRCSM63P7f1eVhDOgMO+GZ7WM5mZ/jYdCrNRiIZkwPCxuZK2/vH8kEsZAjiz2fqEP/TQ9GktX35U+KqihLvCsNvglmtXRdOOUTYL+vSbLx0VpDK5CeXUVGVUSGk5ZTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360710; c=relaxed/simple;
	bh=1U5/twqxTGSGkYs8N4biDr6rL7zWhCuv/NTN7dLYSP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhgwC8JN039AV1Of08qURy8a8irGuPLFtibInXvh1LFDf1m7Em9/9EhGnDgqgrzENrJ09eSRflcrwxvIdh1G78K2P5uo5jw6ySlpL5JalgVK9LpwQkIjDe/TF8tZYg9h8rmKobRxQuz5rUiurpgyM1l1SSHF2uIcniOlUKVG0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1aj5Lax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1aj5Lax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E0DC4AF0A;
	Tue, 30 Jul 2024 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360710;
	bh=1U5/twqxTGSGkYs8N4biDr6rL7zWhCuv/NTN7dLYSP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1aj5Lax00t8FwrY3H0CDAGEaaWGRBFTTS+lQV0i2pdqhVX7hoo0gB8JbYH0fVZGU
	 aySohX7ed03JqVhSWu9cBeI2X5qaT95lRoexzzCIlmzNUuvq9ppe6cH2ks9XKwmz9w
	 fwU+1RGwyk+T4h3EawT5SqQ6YJmdi5Own4jUOafo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wilkins <steve.wilkins@raymarine.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 783/809] spi: microchip-core: ensure TX and RX FIFOs are empty at start of a transfer
Date: Tue, 30 Jul 2024 17:50:59 +0200
Message-ID: <20240730151755.893421734@linuxfoundation.org>
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

From: Steve Wilkins <steve.wilkins@raymarine.com>

[ Upstream commit 9cf71eb0faef4bff01df4264841b8465382d7927 ]

While transmitting with rx_len == 0, the RX FIFO is not going to be
emptied in the interrupt handler. A subsequent transfer could then
read crap from the previous transfer out of the RX FIFO into the
start RX buffer. The core provides a register that will empty the RX and
TX FIFOs, so do that before each transfer.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Signed-off-by: Steve Wilkins <steve.wilkins@raymarine.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20240715-flammable-provoke-459226d08e70@wendy
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-microchip-core.c b/drivers/spi/spi-microchip-core.c
index 78a073664f60b..99c25e6a937fd 100644
--- a/drivers/spi/spi-microchip-core.c
+++ b/drivers/spi/spi-microchip-core.c
@@ -91,6 +91,8 @@
 #define REG_CONTROL2		(0x28)
 #define REG_COMMAND		(0x2c)
 #define  COMMAND_CLRFRAMECNT	BIT(4)
+#define  COMMAND_TXFIFORST		BIT(3)
+#define  COMMAND_RXFIFORST		BIT(2)
 #define REG_PKTSIZE		(0x30)
 #define REG_CMD_SIZE		(0x34)
 #define REG_HWSTATUS		(0x38)
@@ -493,6 +495,8 @@ static int mchp_corespi_transfer_one(struct spi_controller *host,
 	mchp_corespi_set_xfer_size(spi, (spi->tx_len > FIFO_DEPTH)
 				   ? FIFO_DEPTH : spi->tx_len);
 
+	mchp_corespi_write(spi, REG_COMMAND, COMMAND_RXFIFORST | COMMAND_TXFIFORST);
+
 	mchp_corespi_write(spi, REG_SLAVE_SELECT, spi->pending_slave_select);
 
 	while (spi->tx_len)
-- 
2.43.0



