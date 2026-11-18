Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038218;
	b=aQ2VaULH99CUZh2EPD3l3auEYkAG0/ufeUgnz+49WzSlgKEloC6QQSEU0cVZCM2MMeGI
	 NHhahoOeWvltxmCkEcIKaa3RoBu+u80tI6pggIZ+HuKHldpBP9VbE5wwRchZGnL7ogEaL
	 c/Ew/pEjpCcdJA+ALvoAo/33SSD/ntLEZXmiqdYAm7hV63gVqBMYWMrvN2jyA3UvBEGnc
	 DOSRtL+MEhP2w3V21zi8rGXTh08ih1A0GT/64sRwJNFHG4nSwT2N9bi3ThLwhwhMDpl+7
	 zckgdSsSy6e/lfHsvuAhA8hIC8oKNqIBWlltwrHkxxiv9p2b1FibUKHpw9wRH8kUosQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6GeRZv0EK2wZVroPYGrzPSN5ya2p2k7M1dWYRdXJY6Y=;
	b=ja7ehmEZ7Y/si9A1DLwRVGkQSO4nUpr8U+oNPaLFa10OS9xNOlCDA3ZNle+1wMG17+9y
	 p2nWX+lDRFLUHnOC6QLQgMxLlOHG+qJZwJsOZwHC2rpJL/yHdIILs7Ko1UN1fXCvCUoH1
	 H9iOuWc7VKGqIbXEn1vCIHecJqox+GFlloTJ2DlsHqkDiwmoZHxTQ5ulJemZCLOjkzPgr
	 wZpX/YNYHV4inYxN9hdJ07X2tbdS7wDDTDy05w4nwxWoAvhrkQG8Sw1qsl4n8Wa5xalYc
	 +Xw939NuoJoHKj1Ps0CE1qvn/P/PiBBn7VY5Eis5/xaoHnBu1rc2iG42EaHffFc78MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWYSJoM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83014606A320;
	Wed, 18 Nov 2026 21:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWYSJoM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D241F000C4;
	Wed, 18 Nov 2026 21:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038218;
	bh=6GeRZv0EK2wZVroPYGrzPSN5ya2p2k7M1dWYRdXJY6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWYSJoM4OrpKCcA0PcRv78m0xHIfJZutBEdNAg4VqHi8qKc8avjfUuaAy7GAOyIqE
	 sfaSnbZXB+ob9XBD0g53jO1z3h7jyDuBRwl6/ybU2TT7aLZlCzEttONXYZFDEq6lC+
	 UFFBoY53bjDTL5Xww88hpM+OzXAtnW7so/e7vh8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1667/3318] spi: cadence-xspi: reject SDMA transfers larger than the requested length
Date: Wed, 18 Nov 2026 15:38:09 +0100
Message-ID: <20261118150411.793039627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit ea9854a169e9c1437df8829bea21c2f2e80b137c ]

The XSPI controller reports the size of the slave-DMA transaction
through SDMA_SIZE_REG. Both SDMA handlers take this register at face
value and copy the reported number of bytes between the SDMA FIFO and
the transfer buffers, without checking it against the length of the
transfer that was actually requested.

While cdns_xspi_adjust_mem_op_size() clamps the size of the operations
issued by the SPI core, the device can still report a bigger SDMA size
than what was programmed, which makes the handlers read from or write
to memory beyond the end of the transfer buffers.

Track the number of bytes requested for the current data phase in a new
sdma_xfer_len field, set by cdns_xspi_send_stig_command() and by the
Marvell b0 transfer path, and reject any SDMA size that exceeds it.

Fixes: a16cc8077627 ("spi: cadence: add support for Cadence XSPI controller")
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20260929081146.41041-2-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Replaced callback-based SDMA and interrupt dispatch with existing direct function calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index ee342501b759f..407731d20c24d 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -220,6 +220,7 @@ struct cdns_xspi_dev {
 	int irq;
 	int cur_cs;
 	unsigned int sdmasize;
+	unsigned int sdma_xfer_len;
 
 	struct completion cmd_complete;
 	struct completion auto_cmd_complete;
@@ -326,7 +327,7 @@ static int cdns_xspi_controller_init(struct cdns_xspi_dev *cdns_xspi)
 	return 0;
 }
 
-static void cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
+static int cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
 {
 	u32 sdma_size, sdma_trd_info;
 	u8 sdma_dir;
@@ -335,6 +336,13 @@ static void cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
 	sdma_trd_info = readl(cdns_xspi->iobase + CDNS_XSPI_SDMA_TRD_INFO_REG);
 	sdma_dir = FIELD_GET(CDNS_XSPI_SDMA_DIR, sdma_trd_info);
 
+	if (sdma_size > cdns_xspi->sdma_xfer_len) {
+		dev_err(cdns_xspi->dev,
+			"SDMA size %u exceeds the requested length %u\n",
+			sdma_size, cdns_xspi->sdma_xfer_len);
+		return -EINVAL;
+	}
+
 	switch (sdma_dir) {
 	case CDNS_XSPI_SDMA_DIR_READ:
 		ioread8_rep(cdns_xspi->sdmabase,
@@ -346,6 +354,8 @@ static void cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
 			     cdns_xspi->out_buffer, sdma_size);
 		break;
 	}
+
+	return 0;
 }
 
 static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
@@ -391,6 +401,7 @@ static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
 
 		cdns_xspi->in_buffer = op->data.buf.in;
 		cdns_xspi->out_buffer = op->data.buf.out;
+		cdns_xspi->sdma_xfer_len = op->data.nbytes;
 
 		cdns_xspi_trigger_command(cdns_xspi, cmd_regs);
 
@@ -399,7 +410,11 @@ static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
 			cdns_xspi_set_interrupts(cdns_xspi, false);
 			return -EIO;
 		}
-		cdns_xspi_sdma_handle(cdns_xspi);
+		ret = cdns_xspi_sdma_handle(cdns_xspi);
+		if (ret) {
+			cdns_xspi_set_interrupts(cdns_xspi, false);
+			return ret;
+		}
 	}
 
 	wait_for_completion(&cdns_xspi->cmd_complete);
-- 
2.53.0



