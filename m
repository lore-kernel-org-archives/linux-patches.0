Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C56F8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA28C433C8;
	Sun, 16 Jul 2023 19:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537513;
	bh=I0ROZG7K6JZg63HNOA9sccLuSks0W9uzujzCZonuHds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upAGcILRLoRVFp1knoUhwAZocIPu0kRCK/mbeEgDBt4irjhOUlDV/gS7+C8Wjkhaa
	 cn0xa6ZN1MPscgej6YPHA4IOk/2iHmrkxS8zuf3KRFLBmWRNIiuIYNk6MIP8uQeofp
	 A7TVpPK2X6N+1GsQ57JtjWASj6hOQEyKcMtMTKvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 123/800] spi: dw: Round of n_bytes to power of 2
Date: Sun, 16 Jul 2023 21:39:36 +0200
Message-ID: <20230716194951.962327302@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joy Chakraborty <joychakr@google.com>

[ Upstream commit 9f34baf67e4d08908fd94ff29c825bb673295336 ]

n_bytes variable in the driver represents the number of bytes per word
that needs to be sent/copied to fifo. Bits/word can be between 8 and 32
bits from the client but in memory they are a power of 2, same is mentioned
in spi.h header:
"
 * @bits_per_word: Data transfers involve one or more words; word sizes
 *      like eight or 12 bits are common.  In-memory wordsizes are
 *      powers of two bytes (e.g. 20 bit samples use 32 bits).
 *      This may be changed by the device's driver, or left at the
 *      default (0) indicating protocol words are eight bit bytes.
 *      The spi_transfer.bits_per_word can override this for each transfer.
"

Hence, round of n_bytes to a power of 2 to avoid values like 3 which
would generate unalligned/odd accesses to memory/fifo.

* tested on Baikal-T1 based system with DW SPI-looped back interface
transferring a chunk of data with DFS:8,12,16.

Fixes: a51acc2400d4 ("spi: dw: Add support for 32-bits max xfer size")
Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com
Signed-off-by: Joy Chakraborty <joychakr@google.com
Reviewed-by: Serge Semin <fancer.lancer@gmail.com
Tested-by: Serge Semin <fancer.lancer@gmail.com
Link: https://lore.kernel.org/r/20230512104746.1797865-4-joychakr@google.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-core.c b/drivers/spi/spi-dw-core.c
index ae3108c70f508..7778b19bcb6c6 100644
--- a/drivers/spi/spi-dw-core.c
+++ b/drivers/spi/spi-dw-core.c
@@ -426,7 +426,10 @@ static int dw_spi_transfer_one(struct spi_controller *master,
 	int ret;
 
 	dws->dma_mapped = 0;
-	dws->n_bytes = DIV_ROUND_UP(transfer->bits_per_word, BITS_PER_BYTE);
+	dws->n_bytes =
+		roundup_pow_of_two(DIV_ROUND_UP(transfer->bits_per_word,
+						BITS_PER_BYTE));
+
 	dws->tx = (void *)transfer->tx_buf;
 	dws->tx_len = transfer->len / dws->n_bytes;
 	dws->rx = transfer->rx_buf;
-- 
2.39.2



