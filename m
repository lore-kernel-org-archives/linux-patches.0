Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98172D94A7;
	Thu, 15 Jan 2026 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498861; cv=none; b=GohN9napUWO3hxud2+P7Pa/lSE6Wg6Z1C4nUe568kS4iARlqJWk04/zD6T3X0BjqhAD+CszORB2DZ00K/KbBvm1vJUgT60gFbMn8IYIIBQsN6ZNUadROaQGKMKfZQoIg75T4+o7fx7JqJrvnJc/8A1N5Bw9cciub0IRUic23sIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498861; c=relaxed/simple;
	bh=dQeSJHoZEBWgqtkZ3eFI9vutfb96tfOAc+2tU2O4uHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0gWrhJ0ZUwYJP6AZ0H45+g3j9K1pvLk3m6uePgYC+ybhXIOwtJvx7LV7qX2L4X0HsbiS0PvB82WMdOhSqbBmogYSRpgje43t3K451JkDFB6v2YnXvmXPjqtTukQS38GOCtdJls5v2JzwTd9v0kbXW1KGJFMr6lVM3kLSyGJHgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvG5MTFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvG5MTFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67263C116D0;
	Thu, 15 Jan 2026 17:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498861;
	bh=dQeSJHoZEBWgqtkZ3eFI9vutfb96tfOAc+2tU2O4uHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvG5MTFAwP5rQFfAaHrxIo3BCYydf2Eq8Pit2clgfECuviPBzTsOkF/768uYCfdwe
	 nZkgVYpk9+NgUza+OTdAeM3xzVSAtOtrJ8y989Ndk76yX9+Tq+KsjuS0W1u26O2NrO
	 AOyYuUVypmFiGU5sRYgLQxS7DdGS9p/9J7ykhpVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvaro Gamez Machado <alvaro.gamez@hazent.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/451] spi: xilinx: increase number of retries before declaring stall
Date: Thu, 15 Jan 2026 17:43:38 +0100
Message-ID: <20260115164231.512356687@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 523edfdf5dcd1..d497fc4bc19eb 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -298,7 +298,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 		/* Read out all the data from the Rx FIFO */
 		rx_words = n_words;
-		stalled = 10;
+		stalled = 32;
 		while (rx_words) {
 			if (rx_words == n_words && !(stalled--) &&
 			    !(sr & XSPI_SR_TX_EMPTY_MASK) &&
-- 
2.51.0



