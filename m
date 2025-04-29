Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D2F21ABC6;
	Tue, 29 Apr 2025 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950066; cv=none; b=d03GEPntVwcjFQU268DdbJAjqfm0tfnUEcSWHg645k/BVu9VH/WJ+Vv2/k1ei/XLqrHX+mnIrC52bZUcc7xP5cwLUxhvyCGSUO2kttE2tKNm34hxIvXSxZ7KOum+6Cq2YFRg8mm56HOLiA+dvOmnuBNGF07ZfFLoxuDeb1E29/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950066; c=relaxed/simple;
	bh=GV1LXYANz3mUn0u2Mo3wZDz/YTJ8su5dJW8pgHLaHj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqbOmZM1Tm9qEFCJCXA0P4ptCeUQE7m+0D2Vp5hTITTT16KPE+y1DfIQMJX0E8HKrihqSHGS8MW02W/v5RZRWNd9heRB+193lXcJTuQtVHB1kwjjI/uujDuGZuUEaJA65N1YfKNXwTUSJINb2Abvejr8YF6eAC4g1IYAVDIIeZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNgYbnVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNgYbnVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1E7C4CEE3;
	Tue, 29 Apr 2025 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950065;
	bh=GV1LXYANz3mUn0u2Mo3wZDz/YTJ8su5dJW8pgHLaHj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNgYbnVvvjkz5p9wSeepZXKrIncHp57tC4uwkvkPLaapQbf0XPilrifvSPeOyKs2Q
	 g+AsMY2hosQeQRnB/ni6j8Ep6xw0iepcgkHphM6DhsqtkwIRvX0WaQ+X66B8rua7tH
	 0hsGhRfi7PGEgfbyj48pANn/5KpxkfsaRvb0mS+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/167] spi: tegra210-quad: use WARN_ON_ONCE instead of WARN_ON for timeouts
Date: Tue, 29 Apr 2025 18:44:13 +0200
Message-ID: <20250429161057.594470713@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 41c721fc093938745d116c3a21326a0ee03bb491 ]

Some machines with tegra_qspi_combined_seq_xfer hardware issues generate
excessive kernel warnings, severely polluting the logs:

    dmesg | grep -i "WARNING:.*tegra_qspi_transfer_one_message" | wc -l
    94451

This patch replaces WARN_ON with WARN_ON_ONCE for timeout conditions to
reduce log spam. The subsequent error message still prints on each
occurrence, providing sufficient information about the failure, while
the stack trace is only needed once for debugging purposes.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250401-tegra-v2-1-126c293ec047@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 5ac5cb885552b..97f3a4d3c31a9 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1110,7 +1110,7 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 					(&tqspi->xfer_completion,
 					QSPI_DMA_TIMEOUT);
 
-			if (WARN_ON(ret == 0)) {
+			if (WARN_ON_ONCE(ret == 0)) {
 				dev_err(tqspi->dev, "QSPI Transfer failed with timeout: %d\n",
 					ret);
 				if (tqspi->is_curr_dma_xfer &&
-- 
2.39.5



