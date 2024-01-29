Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE415703F;
	Mon, 29 Jan 2024 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548338; cv=none; b=Qb158DVWsa7dhD6GmBB0kOMCXQaaJEhBnBRW4QFsXhGIEJEUrMqjLtNapEl0QFh1A2gAAYqrqXgR/qbuYeBl32iuYNVFiGtxqxZdkx6nTjZ432+NkBV4EXf1XRsZgMwT8i3sMpeyEehqBuBGX/OTC8JX8+MvoY774KEBeycR1+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548338; c=relaxed/simple;
	bh=4qakkSwdREWnHRl4WY9hGljDPC3mUkBOJsuqHPAMV2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCUlucSrI2Nll/AwisQwiN53wCrrMUegTnnf1IaqxscBgM+pDnqBbVzmyZ75tdHDaFYo/Lrt/+wbDAXrhC1rgavR+FHzWIN6lqnRWHrvEC+fEdWyLhv8MHQFgMRX6HTyPNZAfDWJTY30DtyrXewfdEOzzcgBcj/k8V6kRmxjGHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIizRtiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIizRtiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC69DC43390;
	Mon, 29 Jan 2024 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548338;
	bh=4qakkSwdREWnHRl4WY9hGljDPC3mUkBOJsuqHPAMV2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIizRtivr+DI6W0yjx7e2sfgPA9zt1EMXj2cm2I/t8+MXR4sLSVmAqtuD3nlS2Rk/
	 13pZA7ZPgNpFUI+/v0NK7pF+uUepTacORWbg/i6yHZhvqKrWCCyohR/jk+XBz+fSxG
	 U+fM+coQXkJahtLqn/5pbn3K42PvdSqEQRXNedVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 333/346] spi: spi-cadence: Reverse the order of interleaved write and read operations
Date: Mon, 29 Jan 2024 09:06:04 -0800
Message-ID: <20240129170026.270374311@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>

[ Upstream commit 633cd6fe6e1993ba80e0954c2db127a0b1a3e66f ]

In the existing implementation, when executing interleaved write and read
operations in the ISR for a transfer length greater than the FIFO size,
the TXFIFO write precedes the RXFIFO read. Consequently, the initially
received data in the RXFIFO is pushed out and lost, leading to a failure
in data integrity. To address this issue, reverse the order of interleaved
operations and conduct the RXFIFO read followed by the TXFIFO write.

Fixes: 6afe2ae8dc48 ("spi: spi-cadence: Interleave write of TX and read of RX FIFO")
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Link: https://msgid.link/r/20231218090652.18403-1-amit.kumar-mahapatra@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index a50eb4db79de..e5140532071d 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -317,6 +317,15 @@ static void cdns_spi_process_fifo(struct cdns_spi *xspi, int ntx, int nrx)
 	xspi->rx_bytes -= nrx;
 
 	while (ntx || nrx) {
+		if (nrx) {
+			u8 data = cdns_spi_read(xspi, CDNS_SPI_RXD);
+
+			if (xspi->rxbuf)
+				*xspi->rxbuf++ = data;
+
+			nrx--;
+		}
+
 		if (ntx) {
 			if (xspi->txbuf)
 				cdns_spi_write(xspi, CDNS_SPI_TXD, *xspi->txbuf++);
@@ -326,14 +335,6 @@ static void cdns_spi_process_fifo(struct cdns_spi *xspi, int ntx, int nrx)
 			ntx--;
 		}
 
-		if (nrx) {
-			u8 data = cdns_spi_read(xspi, CDNS_SPI_RXD);
-
-			if (xspi->rxbuf)
-				*xspi->rxbuf++ = data;
-
-			nrx--;
-		}
 	}
 }
 
-- 
2.43.0



