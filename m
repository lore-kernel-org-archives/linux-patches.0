Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045785;
	b=wq+8RSz8twRKBRUJT9lUiiAwparbyV8jNU0KngDru0MrY2+3T8+q1lHAw1atrcchBrG6
	 k04AMqGHCOf4Ar1w2bMoqch8RSZgKRn/k8omoNiD/11VilJ62MR8ip+ilYlT/ImVsuRov
	 r64q7rCaB13r5oAjiyhBiJsoH7x+0kPyNoqE/XzhwG6BsHGLBVPUN8Ezmuf7MZsEF5hJl
	 bmWLDfwuViI9EOOb76Mglh2KQkviM5VubkUFxpxriQw3tdbT6g4XDtItPSDiwK9kpODxN
	 BTdjz/dcYC8TpQA4CZaEAwmb5qfgidN72cZPD3dimLMK73/1FFdj6lVOxLxBF6Q51WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=07jJzPKFUH1kQ8bVTCcJwRvctjNK2TFeLKN/zpvfJLU=;
	b=imzDUECyacZ9lDSgY16iRDfHRNuKHQRhYzxLtpBmPPqFMz4zAXOh5g+a3KySflLFM3sW
	 0s5K/oiA4pzrrsxS9b+GjA33+ISELgzCN52C6ZDpMEApT62uLhQ1vL5960Xrl+yrvYK/i
	 1hPPe0M8X5Hxmuvnl4ZjaxyG5IdrA6c1/5pRHCqka+jIldtwHbt9oIo5hHazX613UtUyq
	 slXQD5uCfNdwdg7PR9R1jjmhHvn6DV4+FyVlEoFcpgp2tG2slMr7u2CbLEHLpi+qh85aU
	 MKzoYj5yVNTL1WrhCcfiQT4J4rJOp/OyezCTY0+ywje6TJ+sQI9rPaaSoyi833vEGfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHC7cpNp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07834606A31C;
	Wed, 18 Nov 2026 23:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EHC7cpNp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F1B1F000C4;
	Wed, 18 Nov 2026 23:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045784;
	bh=07jJzPKFUH1kQ8bVTCcJwRvctjNK2TFeLKN/zpvfJLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHC7cpNpu4Zg4rDkDIL3wNXcKNhguPBkoS1RzT/rfAP5AmORDhufpdZgLuoh2O0ya
	 sNnbaRITn4qCfpxOUcJ8iD45qiPaeS2XjYGz0lYBdMhPhFydEj0d24Gi9KUrYDCIxu
	 LmbVYEbnkM4Gwlk7XPhIToYM5AWM1BwQVjN4gKUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pufan Jin <cyan2254650260@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1030/2857] spi: zynq-qspi: fix address buffer corruption and support 4-byte address
Date: Wed, 18 Nov 2026 15:34:24 +0100
Message-ID: <20261118150238.684048931@linuxfoundation.org>
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

From: Pufan Jin <cyan2254650260@gmail.com>

[ Upstream commit dc5ca34f5e8dc10c566ef39aa3b1a201a17ca734 ]

In zynq_qspi_exec_mem_op(), when transmitting address bytes, the driver
iterates over op->addr.nbytes and populates xqspi->txbuf[i]. However,
xqspi->txbuf is never re-assigned before populating the address, meaning
it still points to (u8 *)&op->cmd.opcode from the command phase.

This causes two severe issues:
1. Memory corruption: Writing into xqspi->txbuf writes past the opcode
   buffer on the stack (which was passed as const struct spi_mem_op *).
   If opcode is zero, xqspi->txbuf is uninitialized.
2. In zynq_qspi_supports_op(), operations with op->addr.nbytes > 3 are
   rejected. When paired with SPI NOR flashes larger than 16MB (such as
   Winbond W25Q256), spi_nor_spimem_check_read_pp_op() tests 4-byte address
   support, which fails and causes spi_nor_select_read() to drop all read
   capabilities, failing probe with -EINVAL (-22).

The Zynq-7000 QSPI controller hardware in manual I/O mode natively supports
transmitting 1 to 4 address bytes via its TXD FIFO registers
(ZYNQ_QSPI_TXD_00_00_OFFSET).

Fix this by introducing a local opaddr[4] buffer in zynq_qspi_exec_mem_op()
and explicitly setting xqspi->txbuf = opaddr before populating address
bytes. Also allow up to 4 address bytes in zynq_qspi_supports_op().

Fixes: 67dca5e580f1 ("spi: spi-mem: Add support for Zynq QSPI controller")
Cc: stable@vger.kernel.org
Signed-off-by: Pufan Jin <cyan2254650260@gmail.com>
Link: https://patch.msgid.link/20261016130812.282624-1-cyan2254650260@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynq-qspi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-zynq-qspi.c b/drivers/spi/spi-zynq-qspi.c
index 1ba321f0e57ce..9e7bea8daa47c 100644
--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -229,11 +229,10 @@ static bool zynq_qspi_supports_op(struct spi_mem *mem,
 		return false;
 
 	/*
-	 * The number of address bytes should be equal to or less than 3 bytes.
+	 * The number of address bytes should be equal to or less than 4 bytes.
 	 */
-	if (op->addr.nbytes > 3)
+	if (op->addr.nbytes > 4)
 		return false;
-
 	return true;
 }
 
@@ -524,6 +523,7 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 				 const struct spi_mem_op *op)
 {
 	struct zynq_qspi *xqspi = spi_controller_get_devdata(mem->spi->controller);
+	u8 opaddr[4] __aligned(4);
 	int err = 0, i;
 	u8 *tmpbuf;
 
@@ -549,12 +549,13 @@ static int zynq_qspi_exec_mem_op(struct spi_mem *mem,
 	}
 
 	if (op->addr.nbytes) {
-		for (i = 0; i < op->addr.nbytes; i++) {
-			xqspi->txbuf[i] = op->addr.val >>
+		for (i = 0; i < op->addr.nbytes; i++)
+			opaddr[i] = op->addr.val >>
 					(8 * (op->addr.nbytes - i - 1));
-		}
 
 		reinit_completion(&xqspi->data_completion);
+		xqspi->txbuf = opaddr;
+
 		xqspi->rxbuf = NULL;
 		xqspi->tx_bytes = op->addr.nbytes;
 		xqspi->rx_bytes = op->addr.nbytes;
-- 
2.53.0



