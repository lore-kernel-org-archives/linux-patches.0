Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046800;
	b=P54Zr+/1/NPBlzzox2Q031liXDf/m6+YzhxnHCOnz+SYpFgHNBPrO/N3YPZd17/GS4dP
	 RyjdMurpeFY7up9PGUgs6nN+QO0+5MdCOoqFYyV7f6bLnCKe6mRlkDZiSXrqYys8ke7gq
	 KGq20+NgqLoIZu8H6SeB/SM6JtrOIRXdUIwqF+uyIAYoLgiCRKFjdNiwIhQ6JrhVW500U
	 fThbB1fqXringPniyfvjzumDHeq/t14O/W0cO4eyt03rmHvxmENuieCAv7ZUfgZIsyck5
	 HVg88SGtGoe9StAU0WnR/bxx4hTx2HX+nDeLNb53KJD2EF2+P54i6Zkb0ecZo6qbD/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mDXL9hSmgctQFBJyAzs0u36u+64MTDYsHO8Wg4hZI20=;
	b=b6xcd4bH5E7gU1MPz8oro/wOiJzLGcO4Ao+Y6S8fUavZ1RnaBC0WINkYLqlf11Rg7jdG
	 tD4VYeNsEdZXzrN2cHxXERpPAa5SzvHSXVhJES5Xjg6q/T9BYgZ+Q8xXdZSf6b/tTVs70
	 0YcLfUteeltlAC3g9IhGB3OPnNYzPYHD4nTh//F+m/v9MUgLuSnyguedbICFYgB0dU166
	 rGplQZwcWqj6p7zJVS0Cykg+4DeF+gAjlbv+/YkeYV4P9EI4nPXieWddRj3Pi+eENmb7X
	 ThaHg3VH639r0iIsWYPAdnzhGWvgauCUTnpV0Q0I00GDo0pcBWmlMdXDlzKLwkGJVow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UGTBm0xk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180F1606A320;
	Thu, 19 Nov 2026 00:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UGTBm0xk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277C51F000C4;
	Thu, 19 Nov 2026 00:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046799;
	bh=mDXL9hSmgctQFBJyAzs0u36u+64MTDYsHO8Wg4hZI20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGTBm0xkL12kQiSs6BZYkfPkfi+oJaXrIO1UiRf6bcPJcnGc1XICIY4xxf6UB7dYE
	 SPg0y54bzUdJlds2RmaXyBwMj6buubi3orAYYEcCvIjCMGxX5M8OdEOTXTKuHAoImm
	 0RyatmEJtzyev9hFHnkhsojYpcn7zlzuUZVgE4MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1409/2857] spi: cadence-xspi: reject SDMA transfers larger than the requested length
Date: Wed, 18 Nov 2026 15:40:43 +0100
Message-ID: <20261118150252.075149689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted SDMA handling to the existing direct-call and byte-wise I/O implementation without Marvell support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index b8bed8f39d2ae..d5e3bd2cb7722 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -221,6 +221,7 @@ struct cdns_xspi_dev {
 	int irq;
 	int cur_cs;
 	unsigned int sdmasize;
+	unsigned int sdma_xfer_len;
 
 	struct completion cmd_complete;
 	struct completion auto_cmd_complete;
@@ -327,7 +328,7 @@ static int cdns_xspi_controller_init(struct cdns_xspi_dev *cdns_xspi)
 	return 0;
 }
 
-static void cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
+static int cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
 {
 	u32 sdma_size, sdma_trd_info;
 	u8 sdma_dir;
@@ -336,6 +337,13 @@ static void cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
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
@@ -347,6 +355,8 @@ static void cdns_xspi_sdma_handle(struct cdns_xspi_dev *cdns_xspi)
 			     cdns_xspi->out_buffer, sdma_size);
 		break;
 	}
+
+	return 0;
 }
 
 static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
@@ -392,6 +402,7 @@ static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
 
 		cdns_xspi->in_buffer = op->data.buf.in;
 		cdns_xspi->out_buffer = op->data.buf.out;
+		cdns_xspi->sdma_xfer_len = op->data.nbytes;
 
 		cdns_xspi_trigger_command(cdns_xspi, cmd_regs);
 
@@ -400,7 +411,11 @@ static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
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



