Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB67253B60;
	Mon, 23 Jun 2025 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685316; cv=none; b=kGAy9c/SbaLwE5TQVWnTbpF8K7O9B548Ujl/YAAnYG+uhWnKfLkZApub1QV3wuHeWhU9vFes4SrmuNNZ7n4S1L2egAHuxogjX9NMatQwyc/Sr+qPrwVCZidpVXNo0wcbqaZqexIdRCKXAvniR99TqrFih0TKWqznpdET2VW1/iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685316; c=relaxed/simple;
	bh=E82peAu0aSz0Phn6LYYzQGu1d4zceDg/ARNWUJy69bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fA+RftjLbLkDahmQkpbbGq7aFE8sozruiSzmtUuBDCUbvcN91GF1AzAEwO8qMnnF2mOt7vhAImPZjm9oWI/NN3QIalxKOzObtzmb+l1ropbUZdRFV2bfg0svMU+jhpcEYgn9eZwVmws6F5v1qb0LrMCCaiUhGVWGYjybe/5wvWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu2ye6Yl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu2ye6Yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B53C4CEEA;
	Mon, 23 Jun 2025 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685316;
	bh=E82peAu0aSz0Phn6LYYzQGu1d4zceDg/ARNWUJy69bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu2ye6YlYpWCM2Q+b5cjpk8y5v/N8BBJmVhF+IfOgpXCqc0rx0z8EH1373666bW/w
	 O44KND4mLxH4vCyuTQmIg7nEib/5h0ckpRMTPEjE8w15GeqJCxyXMzNnCk4OnT7YFq
	 xfGZux0g0dIrq7P2w24dcZ3KleQUBGpiuoihS3+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/411] spi: sh-msiof: Fix maximum DMA transfer size
Date: Mon, 23 Jun 2025 15:02:50 +0200
Message-ID: <20250623130633.786400593@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0941d5166629cb766000530945e54b4e49680c68 ]

The maximum amount of data to transfer in a single DMA request is
calculated from the FIFO sizes (which is technically not 100% correct,
but a simplification, as it is limited by the maximum word count values
in the Transmit and Control Data Registers).  However, in case there is
both data to transmit and to receive, the transmit limit is overwritten
by the receive limit.

Fix this by using the minimum applicable FIFO size instead.  Move the
calculation outside the loop, so it is not repeated for each individual
DMA transfer.

As currently tx_fifo_size is always equal to rx_fifo_size, this bug had
no real impact.

Fixes: fe78d0b7691c0274 ("spi: sh-msiof: Fix FIFO size to 64 word from 256 word")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/d9961767a97758b2614f2ee8afe1bd56dc900a60.1747401908.git.geert+renesas@glider.be
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sh-msiof.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index b7b3ec76e2cbd..f118dff626d0b 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -919,6 +919,7 @@ static int sh_msiof_transfer_one(struct spi_controller *ctlr,
 	void *rx_buf = t->rx_buf;
 	unsigned int len = t->len;
 	unsigned int bits = t->bits_per_word;
+	unsigned int max_wdlen = 256;
 	unsigned int bytes_per_word;
 	unsigned int words;
 	int n;
@@ -932,17 +933,17 @@ static int sh_msiof_transfer_one(struct spi_controller *ctlr,
 	if (!spi_controller_is_slave(p->ctlr))
 		sh_msiof_spi_set_clk_regs(p, t);
 
+	if (tx_buf)
+		max_wdlen = min(max_wdlen, p->tx_fifo_size);
+	if (rx_buf)
+		max_wdlen = min(max_wdlen, p->rx_fifo_size);
+
 	while (ctlr->dma_tx && len > 15) {
 		/*
 		 *  DMA supports 32-bit words only, hence pack 8-bit and 16-bit
 		 *  words, with byte resp. word swapping.
 		 */
-		unsigned int l = 0;
-
-		if (tx_buf)
-			l = min(round_down(len, 4), p->tx_fifo_size * 4);
-		if (rx_buf)
-			l = min(round_down(len, 4), p->rx_fifo_size * 4);
+		unsigned int l = min(round_down(len, 4), max_wdlen * 4);
 
 		if (bits <= 8) {
 			copy32 = copy_bswap32;
-- 
2.39.5



