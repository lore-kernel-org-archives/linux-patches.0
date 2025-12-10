Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFEF3019B2;
	Wed, 10 Dec 2025 07:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352020; cv=none; b=Ga1Mdy6s2bnxrWDSq72K8DxETyvb9P/gXdXa1WniQ5eX9acN7Hj8DenGdrtb5Zbma2Sxg7NcgNGXcSoQ6ELWVRXtaoox7YKBVLcoRuMxGwsK4tiEPwnFEzh/XGcmz51AOBrAskQEUR2dYvZKg3IyfOqlAyO805YJkGhTQtHNins=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352020; c=relaxed/simple;
	bh=bU4zy7QDvAZYAxmDys7OsaInxECFqjvZ2ql0TVBsSk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXNCDq5wlPhQe3SlLc9O6tSNN6NCqLO6/7o06XAO6iUe2WCQfvlgN1EKZUtgSd0mFA1fUJTP0n5ohHpUvnV+VEPrRb7O5T5fOdg6zq1N8Vlx7pOVC9lfyABuPHMZ3hYAqOrLoGwEEnq1XkNzzrmk94h9Wr2MlAtHTIn/Mm4Etd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGfbc+1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGfbc+1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E91C4CEF1;
	Wed, 10 Dec 2025 07:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352019;
	bh=bU4zy7QDvAZYAxmDys7OsaInxECFqjvZ2ql0TVBsSk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGfbc+1zFYC8cGCF4KmNv8yTfq8gPyc60/6gfWW3uZHlxF90mp/YYwaOdK9y1Hoj8
	 0dKpFhZbh5VqzM3XNpidv1wsQvRR1SlO1PGWyA/ZEk2aTFokq+Y7fAN3gbXqDOQOd4
	 T+O3tALq3bNnRWJ40ygTm5yfUmVaz0iQdz7Hi9Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvaro Gamez Machado <alvaro.gamez@hazent.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 20/60] spi: xilinx: increase number of retries before declaring stall
Date: Wed, 10 Dec 2025 16:29:50 +0900
Message-ID: <20251210072948.333339298@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d59cc8a184846..c86dc56f38b45 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -300,7 +300,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 		/* Read out all the data from the Rx FIFO */
 		rx_words = n_words;
-		stalled = 10;
+		stalled = 32;
 		while (rx_words) {
 			if (rx_words == n_words && !(stalled--) &&
 			    !(sr & XSPI_SR_TX_EMPTY_MASK) &&
-- 
2.51.0



