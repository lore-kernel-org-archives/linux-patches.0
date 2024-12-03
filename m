Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D79033FE;
	Tue,  3 Dec 2024 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238190; cv=none; b=snv6W99PEOhwLxff28yYfPM/W6EIILO9cafEW9OIsr7CPOUZTMDIFmRXUvr+uyvVqlygtgZOAv2bD6Yw5xawbKqbbWmZT2MlFD6IedIb7HFPYvGTvw9woOfNW2Mzsxs9YrELuhgz4j1vsegSx3fkht8K6JTzS7DYDn9hun1BV2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238190; c=relaxed/simple;
	bh=SZAaAdip5WAOwORt/+g8LaC6+1sWR4oIFbtOnThbhFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC61Y5eMGS1jMaf3ji4EiD0YM5f4kflegrdAC3Ikkm/qE0tmM/02uKI6TKwN50RV6KVjTU4jYM+RUi4/+2adGrfM0e8kGdVC8Jm9rfb/LwWBLNcxlKF411eD7L6icri83ajROLUtebQwVf3KTtcnAkcne32nNzUaQTpX0Xl5X1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQWp+ftC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQWp+ftC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841B8C4CEE1;
	Tue,  3 Dec 2024 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238189;
	bh=SZAaAdip5WAOwORt/+g8LaC6+1sWR4oIFbtOnThbhFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQWp+ftCk55394+isZxwHUi84CCjhSGpOo+VR2X7LN4s1AX332iGp+XUlvxGCIA1t
	 rhoQVRBp/ndcMl0ThI7EGIbCpieEOP9kP1xdh3XMjgKdEg6O67g+102gOhjBx6gsF7
	 0qwYKB1Fvv7h7OynWZpYP7Wi30bHuetuygNe6Nro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 192/817] spi: tegra210-quad: Avoid shift-out-of-bounds
Date: Tue,  3 Dec 2024 15:36:04 +0100
Message-ID: <20241203144003.233101586@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index afbd64a217eb0..43f11b0e9e765 100644
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



