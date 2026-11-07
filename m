Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063383;
	b=z1CS0cgXQ+TvR7EVnUxVzs7BYE+eX+9jtNBpjcvzeCMB5539EQDhzut+54uHZxCgd8nY
	 dWjPJxjie/+vLLR0UZp7I9U4UTGp7SP3pdN1qlzowzlUD+BOgOfzfsDw7uhOAzT+ofqWS
	 paEecjsoJIxM9jT6DQwpms+xDGiGsPhDkqiVKxAVWSxYtEXA6O10JUhg5WW0q8b3OAy8C
	 2BFsBrxgGhjs13a+9wYn3IkXl7UE/0TmHT5w7GBTR7Py5FS7kBkdOKLNZ7JZ6DSlCjWdf
	 4LcccyAhoeHdxKgYrroXJ3AS1YF5Evdd5wblNOaZ7l0Z4weyIw3Dltn824ljmkfdb9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7sMsRLl4HcEn01YJXHWFu/pWwFFnpNQTqC0gM+eghv8=;
	b=mAmAYTYMSsQ2xClH/6Cn3G/4PcW3j0s313jrIaXbGVppC4yM+B0Bc2vKvkJNbdqUGB0g
	 0Z/w5vFqR/5DZYQTaRxmZR6xSNLxaaJFs2uLHeHASEFiqzSskTDJgaBD0w78bT9pHMhxv
	 RnHC7F8/KX+10R0zR6tCmiHP7GpojNcSGUnU8l9yq6Gf5Z0EEtkoXs9JeskNJMB11uvRu
	 AKiVKYyC38dn2Rf605ZtyglmzAPbzqlPguhQ4wsearPHJPoOG/7WwuvHotTyG9377bobZ
	 jEzEKyn7uYg1cHBwXprLnMj2M0eEs2+znugE5FRz0kPxacHAP1R7wr98pdx51w53+jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOoxRsvJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEC5606D810;
	Sat,  7 Nov 2026 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EOoxRsvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C122A1F0089F;
	Sat,  7 Nov 2026 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063383;
	bh=7sMsRLl4HcEn01YJXHWFu/pWwFFnpNQTqC0gM+eghv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EOoxRsvJy+C4OO0HfqhLz5p9XhWSzD+137yQwBSMLK9WFxGJ0HfFlmawtwRc68I0e
	 HyUEWafMZP2AKjYX2/qAhNsZrPp3AQEuaNQSA08rroKY5RIu0iVioc9Uja7zOR3Lcv
	 3wLMVd2KdENGbkOlTbcaySlFptV0epPyfYbV0BVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 555/869] spi: cadence-xspi: fix stack buffer overflow in the Marvell b0 path
Date: Sat,  7 Nov 2026 08:53:57 -0500
Message-ID: <20261107134912.159347618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit ef9690269999ddf9b204731baca1bd6b7aea1aa7 ]

transfer_one_message_b0() falls back to a 10-byte stack buffer for
transfers which carry no TX data and points both in_buffer and
out_buffer into it.

With a transfer longer than 10 bytes the SDMA branch of the loop moves
up to MRVL_XFER_QWORD_COUNT * MRVL_XFER_QWORD_BYTECOUNT (256) bytes
through those pointers and then advances them by the same amount, so
both directions overflow the scratch buffer: a read transaction copies
SDMA data past the end of the buffer, a write transaction sends stack
contents from beyond it to the SPI bus.

Size the scratch buffer for the largest chunk the loop can request,
keep the buffer pointers pinned to it when the message does not carry
the corresponding TX or RX data, and only advance the pointers which
reference real transfer buffers. Also zero-initialize the scratch
buffer so that padding bytes sent for TX-less transfers no longer leak
uninitialized stack contents.

Fixes: 5cb7651f78e1 ("Marvell HW overlay support for Cadence xSPI")
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20260929081146.41041-3-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index 6dcba0e0ddaa3..c3676b21e8167 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -268,6 +268,7 @@
 #define MRVL_XFER_FUNC_START		 BIT(0)
 #define MRVL_XFER_QWORD_COUNT		 32
 #define MRVL_XFER_QWORD_BYTECOUNT	 8
+#define MRVL_XFER_MAX_LEN (MRVL_XFER_QWORD_COUNT * MRVL_XFER_QWORD_BYTECOUNT)
 
 #define MRVL_XSPI_POLL_TIMEOUT_US	1000
 #define MRVL_XSPI_POLL_DELAY_US		10
@@ -1047,7 +1048,7 @@ static int cdns_xspi_transfer_one_message_b0(struct spi_controller *controller,
 	struct spi_device *spi = m->spi;
 	struct spi_transfer *t = NULL;
 
-	const unsigned int max_len = MRVL_XFER_QWORD_BYTECOUNT * MRVL_XFER_QWORD_COUNT;
+	const unsigned int max_len = MRVL_XFER_MAX_LEN;
 	int current_transfer_len;
 	int cs = spi_get_chipselect(spi, 0);
 	int cs_change = 0;
@@ -1070,13 +1071,16 @@ static int cdns_xspi_transfer_one_message_b0(struct spi_controller *controller,
 	list_for_each_entry(t, &m->transfers, transfer_list) {
 		u8 *txd = (u8 *) t->tx_buf;
 		u8 *rxd = (u8 *) t->rx_buf;
-		u8 data[10];
+		u8 data[MRVL_XFER_MAX_LEN] = {0};
 		u32 cmd_regs[6];
 
 		if (!txd)
 			txd = data;
 
-		cdns_xspi->in_buffer = txd + 1;
+		if (rxd)
+			cdns_xspi->in_buffer = rxd;
+		else
+			cdns_xspi->in_buffer = data;
 		cdns_xspi->out_buffer = txd + 1;
 
 		while (t->len) {
@@ -1101,8 +1105,10 @@ static int cdns_xspi_transfer_one_message_b0(struct spi_controller *controller,
 				if (!cdns_xspi_is_stig_ready(cdns_xspi, true))
 					return -EIO;
 
-				cdns_xspi->in_buffer += current_transfer_len;
-				cdns_xspi->out_buffer += current_transfer_len;
+				if (rxd)
+					cdns_xspi->in_buffer += current_transfer_len;
+				if (t->tx_buf)
+					cdns_xspi->out_buffer += current_transfer_len;
 			}
 
 			if (rxd) {
-- 
2.53.0



