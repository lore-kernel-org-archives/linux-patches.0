Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52126A0A7;
	Wed, 10 Dec 2025 07:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351972; cv=none; b=YjRY0lICtV6fEHm+nkYrQBncrOQjeWernmfHMPIRXSmDtaXFU3MwuxBhlSELxkasBsRxMMovrtQ0Xwmb8Qq0Pod+haw8f+JKG6W3DHO+wx8HWYsycvTuanY5TP56BMS+imfgPlxcL6mI9zW3DlmtQrJLSQPmgI+w7Yyf3tGF2i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351972; c=relaxed/simple;
	bh=FmTn78XXylywS7bdB1pIKuvWjAw65N1rcX0gBAaLF4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5azWHzP2ciLgPJsuf6XGTvLo3GWB1o2yYUw18sAZzwUoFaRMKLt4CocJjOV4pMjw1VMv4aPol/T7wL7pa4HsaXKI8PPOr5F5nAc4H/ucemdPn1Pb1sIdtV9k/KG7oByOYWzlJkLXe6bs6K5rcMbLvPoEKv9Dwn6efePrWao8ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJMqTat+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJMqTat+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C96C4CEF1;
	Wed, 10 Dec 2025 07:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351972;
	bh=FmTn78XXylywS7bdB1pIKuvWjAw65N1rcX0gBAaLF4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJMqTat+T/Q1rDGBVJ2TnTFg5VFJfR4CtzZwIW6QeiKce3vbG2Oh0RCqVwEgR/tes
	 MPTu1iVeuoIdJCiekQKBlCagKurr4JSHOpO8DW6XaNaKG9pipum1T9cQoV7bXQEOcy
	 X5xatAmUWwESN/hQUdf1utZDkuvR2anyZmMdFrds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvaro Gamez Machado <alvaro.gamez@hazent.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 21/49] spi: xilinx: increase number of retries before declaring stall
Date: Wed, 10 Dec 2025 16:29:51 +0900
Message-ID: <20251210072948.650375246@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

From: Alvaro Gamez Machado <alvaro.gamez@hazent.com>

[ Upstream commit 939edfaa10f1d22e6af6a84bf4bd96dc49c67302 ]

SPI devices using a (relative) slow frequency need a larger time.

For instance, microblaze running at 83.25MHz and performing a
3 bytes transaction using a 10MHz/16 = 625kHz needed this stall
value increased to at least 20. The SPI device is quite slow, but
also is the microblaze, so set this value to 32 to give it even
more margin.

Signed-off-by: Alvaro Gamez Machado <alvaro.gamez@hazent.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20251106134545.31942-1-alvaro.gamez@hazent.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-xilinx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 7795328427a68..f5e41813b9582 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -299,7 +299,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 		/* Read out all the data from the Rx FIFO */
 		rx_words = n_words;
-		stalled = 10;
+		stalled = 32;
 		while (rx_words) {
 			if (rx_words == n_words && !(stalled--) &&
 			    !(sr & XSPI_SR_TX_EMPTY_MASK) &&
-- 
2.51.0



