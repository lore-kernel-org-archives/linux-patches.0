Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062367;
	b=XERyseize/RQwJbyP9gd5Zv1UYIGKA8rH8BKmDUutyPTclFai7hcU64z+FtVjkGWe4jt
	 NGRhzOPSPI0ujxhml6aE7BJCqU0nwx7+sIRhqAiF5Ea5Xa3skqLEGuPzgxhZxjpwBwe2M
	 gRZEBHEFSKXVexXSDvs/JtrOm8bmoIT2BMMNv1GNk8Ql7laE3We46vpPb16HLNJn5Ws9S
	 jCeCRk8Ne29P7paH2XJXYI0H3L6XHyq+YpWyWq7s53Zf7z9WsSCfuEvLC/8MPaXpssTQb
	 G0DKNzCetD0ZSx+Uxcc9NkusR+n6vJtHWXzcfAW/2VcKoBTBPfI2J45EjAOZVcULHHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hUXAysNYpRVOtXoaNWPNLbJN7Tcwt71SqP5Kclaoxrk=;
	b=AzXCOKDc7ZgZnjinzC3DEUmyHxFDbtaLhIOdbW8x3H3uT35wCtBSf5m2AM4OrxO88AMF
	 TvSDYf9WL8dRqEvAbbqLm4CV+Z/unrRH16hz18F82UuFo7eGmuKmJynhzUPkc1kPRJdJl
	 xhVpXrqr9F1Jppgtb5TAA3wgXgZswGzm8QnaEJM1VbVXhDgvoixfpmnGzTHmsCuqYwyAj
	 hQXDrgIIhW4j2OxR837ECT+EVbzauAHZTOJMexR5YQeKXPunouSQmF+FMPBP1tIWG9OZS
	 kdW144s6t/zhyws6NHIkMvmCPuYSRxvkIoLXD1/p5YlRkpIJdkg8xHmzQuUukccIpnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zePvRwQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F9A606D82C;
	Sat,  7 Nov 2026 14:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zePvRwQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706A41F0089F;
	Sat,  7 Nov 2026 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062366;
	bh=hUXAysNYpRVOtXoaNWPNLbJN7Tcwt71SqP5Kclaoxrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zePvRwQEIa8yy0xC+2Rv1JuDWVLCR3guzXxF7i42A5eHjUy4bB1BjEbGeYDaf29u9
	 xnoCCb6AH7CnNJ8AQX3LVqwFgAyTyCSEaVaBTge8XkByY+Mokv1uPmI+mBVhlAOzXT
	 kbnOVUbTrHmtk1Lhfbkjj6EVXvCq69asvIXvxLHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1292/1536] spi: cadence-xspi: fix stack buffer overflow in the Marvell b0 path
Date: Sat,  7 Nov 2026 08:55:08 -0500
Message-ID: <20261107135034.076609771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



