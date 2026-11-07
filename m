Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062534;
	b=wFIdVq0bD8doujkGjuqa5A/aXCrHKaVyPOKtEkY021yEkI6VLkLhgX3UQ3lMlfBQdT7e
	 P9bFQnrmm2J015dv/AyfVhdmfe8/cHA1qN/irQEOG6H0oTo5NxSNHoZNZbmmagrfwQVsB
	 tfFa/sgmNdHD/2yrdQTzAgw7mdHNFoGLAH0otNeS891LvusDhv24b6P7YFRYbU/v4U024
	 b5aZq0OBsi99UkV3Lkq90xvwYsP71l3ifNNErQOLO54/oShgbarc1taY0gZnxvGnhWgbw
	 ObauRIXhvmwCWRPAEv5xIMzLPiCaaHRCvYnvfmT2ZDB1OEu19hhe9WM8fNctAKZSkzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZPD/SN3Zu0SUTWcKfz0V9JZ1In8npJ+OHfl/8vT3OGI=;
	b=aTyd8Me0AOCS7iUiol+Isxj4Dgda7fIjJOprOPtW2/7Pyk1d+TdVylow5NamXxUw/klx
	 oXf1+IqcPFHtC7vjikPZfNmiOcyGZVGrc4BjKR/MzDet0iIou2FX5vlQi9vh4fiz0tEk5
	 ATHT0ERg60EVaODbyg8iFciTeeWRi2eYT2tRb2y6pD9l3b5vxI9MOmHjNoHAQxI8XHq4k
	 /HbLX8kPVKPYuIraiGI2V36JnwKYutZaemkfjqB80UpXMgWOmPTjztImGskzR/RmWbZh4
	 wnmb3NbxGyfrkY4yd+OyMiy0TPIF2KF8lhaAli+R+SeWTilQj2T04SOeidqEnw4gOaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMRciuZ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D42F606D80A;
	Sat,  7 Nov 2026 14:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BMRciuZ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA67D1F008A1;
	Sat,  7 Nov 2026 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062534;
	bh=ZPD/SN3Zu0SUTWcKfz0V9JZ1In8npJ+OHfl/8vT3OGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMRciuZ18gL8cFkagHnab3/Jn6cEhUrJMo4SnTgihx6Yi09MjjLd1fvhn8uS/De/1
	 qUjf6KbYHG3AOjrAyCQ9I/CQc0v4nDraMj+sdZka8kiNExRS4AABU44DvtW9XS8Dw1
	 Qbw0BU7B5/9njNVOU1ltfRs+NFUCNhn59zC7gwdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pufan Jin <cyan2254650260@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1425/1536] spi: zynq-qspi: fix address buffer corruption and support 4-byte address
Date: Sat,  7 Nov 2026 08:57:21 -0500
Message-ID: <20261107135037.854466499@linuxfoundation.org>
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
index 8c4f4345c1a93..1dcd67a7198bc 100644
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



