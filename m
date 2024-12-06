Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6B4148832;
	Fri,  6 Dec 2024 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497046; cv=none; b=psUFxmba9TTF6O+0nCMVcvNNzrgHSlxMMDDtjmS3DF1XONS6Hsq82VbmGq/8VeBVayO23rUB1QTzyQfTapYD0MJDANRgQdkV1kVoOv7ZiwWVw2YM5Jdc8ej91Uzdh8KAK7oBAvev7cmDsFN5IlIgD40Cg2mzH2w8FZRLfwXLEho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497046; c=relaxed/simple;
	bh=xzYZw24BuXOpaoqXjCANAKlRCiIeyyTBvq23OJ91EQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amhH8yxBstMfwXvlr9aJDGRhGjl0mI+kVmnkLK7CRAORj87N6vw7x/HpIFeSsI5XvCRlGCyyD5fArXowRjO8fZWexr5++bmu0R2MgznyBkLo6kqU7LDxIrNGFyoObrMhpqfYf6A9AxfDXDGd9Tp6dK0ER/meeecZV/OPWL1TnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbxxQT2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbxxQT2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E84C4CED1;
	Fri,  6 Dec 2024 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497046;
	bh=xzYZw24BuXOpaoqXjCANAKlRCiIeyyTBvq23OJ91EQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbxxQT2cF6oHJTIXUiaPvsXMoxk6w+eSaQ4Hsq8oupMXkKNWhWaogk3GJ9H0QYeb1
	 t4yNYRJafkXRvU4z6PrtgnJqDyl0fmKYqdTnCSOZ2olTRltQ7vPmCxMxQ1i4OvdrTU
	 W1nFN6tJYTqwB7+MYOj3M8HvSuHM1GB6fZKg+AxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/676] spi: tegra210-quad: Avoid shift-out-of-bounds
Date: Fri,  6 Dec 2024 15:29:26 +0100
Message-ID: <20241206143659.093845157@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f399051ec1ff02e74ae5c2517aed2cc486fd005b ]

A shift-out-of-bounds issue was identified by UBSAN in the
tegra_qspi_fill_tx_fifo_from_client_txbuf() function.

	 UBSAN: shift-out-of-bounds in drivers/spi/spi-tegra210-quad.c:345:27
	 shift exponent 32 is too large for 32-bit type 'u32' (aka 'unsigned int')
	 Call trace:
	  tegra_qspi_start_cpu_based_transfer

The problem arises when shifting the contents of tx_buf left by 8 times
the value of i, which can exceed 4 and result in an exponent larger than
32 bits.

Resolve this by restrict the value of i to be less than 4, preventing
the shift operation from overflowing.

Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Link: https://patch.msgid.link/20241004125400.1791089-1-leitao@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index e9ad9b0b598b5..d1afa4140e8a2 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -341,7 +341,7 @@ tegra_qspi_fill_tx_fifo_from_client_txbuf(struct tegra_qspi *tqspi, struct spi_t
 		for (count = 0; count < max_n_32bit; count++) {
 			u32 x = 0;
 
-			for (i = 0; len && (i < bytes_per_word); i++, len--)
+			for (i = 0; len && (i < min(4, bytes_per_word)); i++, len--)
 				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_qspi_writel(tqspi, x, QSPI_TX_FIFO);
 		}
-- 
2.43.0



