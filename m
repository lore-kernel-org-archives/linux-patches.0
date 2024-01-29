Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12143157E6D;
	Mon, 29 Jan 2024 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548643; cv=none; b=s5dYj2c7dNB5GU0CoSbHhka0Su2FlxQdZ/sZ/P6FeSnmQYFuichBfH7iCT4uSJbZYNbuhM6K2BBRW91DWKOWXkiJ2MkI6Euba8XgIGZ6Z7WeVMOV0/LVS2S32QjJmuNplVf9XjkOGxss2GB38vv9yC87QZjUKyXcOVfYgwERqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548643; c=relaxed/simple;
	bh=Pe4WkKYICVSEDScCYcpiV3kr+A/8GESJkgdbDBK6rjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euv69xQNtXDDl7GROgcGw07J6WRrJ3WFKNPn9V30zplnlp+Brvmgut3PmW9y1vBcbBJxuNMJy5lWTJqO7m5CifJwgmT9QZ60c0wrjF1ShIcexluXJEH7swFmRL/5Z+w+213cTk5d2320qHE+tUOFZRalOyGuPqiEtgxpzjtjYVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdYfL1Nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdYfL1Nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A28C433C7;
	Mon, 29 Jan 2024 17:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548642;
	bh=Pe4WkKYICVSEDScCYcpiV3kr+A/8GESJkgdbDBK6rjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdYfL1Nw4WJbFv3xWkCBDUmnw4uI/ijOJNrdZIxIXH2SLGVIkvrtq+4wW60Fvoh8S
	 wfy7jeG9kWxdw/uvvBw5UQEk/CmnUQG+WGQ0AhGA9OseWIAH76d3R8Neb/nQ8yS4lo
	 h63HYi9g58kNVHphTDoBOzOj3ii8FEibpqGn28P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 319/331] spi: spi-cadence: Reverse the order of interleaved write and read operations
Date: Mon, 29 Jan 2024 09:06:23 -0800
Message-ID: <20240129170024.218573784@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bd96d8b546cd..5cab7caf4658 100644
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



