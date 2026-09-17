Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32C4547045;
	Thu, 17 Sep 2026 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668542; cv=none; b=byfCx/A+NaI0BmnQK7NV5VQAf8bV3OupSGMI4I6didlJhl9nXtqZdXINd6gZ5Jpi5D+yeNqPrCXi+JtgWoVxdEVNVCeVs164j/2WL6lzBV1nCOVGXoKMuZQ5/eaRwqhe51YfpNB7vbbpp4dpjkLhn2YUE70iJEvHKcHY/j7cnHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668542; c=relaxed/simple;
	bh=6vv34Zul512kD4UboyGGMeI8+4HjL7U8r9OGaMD417E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5Y7/xPXskLgiIBUeg6NgSfx1pvmFqY6H1tPL33t/kpF+OiAplblz0/Lf1OcCNnatJUib9pYDkMUfVYzOB4RtQpS3bv4Btd+7jq+6qAGUjU9RcNxg/9QVHOrwVy0kyqCZzjGCAkN6l7c5kUunaUMYnzFYpCYKyr81fVnAv7MhS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxzeUSfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxzeUSfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C5A1F000FF;
	Thu, 17 Sep 2026 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668540;
	bh=ykN+zAjRPkCuo2OEXT+QoaHw5kvNjhaa/PndSipIQ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxzeUSfRf3QLEztFXnn73cEV73CpsETQtUd7W3iqyhKPDlZf1p9syRoiHASGYRkHb
	 nY8RQXbcyIpZcXsu2RNNXYGMWuBimEVrdX8AqR0SLGhRIHfFe1W71dgZ9CZ5IsRbzz
	 Q2u+2gszgAAMVqAYt10+8xLzlPF8qOjid+jYRGuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang YuWei <1973615295@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0412/1102] spi: dw-dma: Wait for controller idle before completing Tx
Date: Thu, 17 Sep 2026 16:05:55 +0100
Message-ID: <20260917151550.008236701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Wang YuWei <1973615295@qq.com>

[ Upstream commit 0bcd59706aeda8a5d48ba656bab74cb26f2b423e ]

dw_spi_dma_wait_tx_done() polls dw_spi_dma_tx_busy(), which only checks
DW_SPI_SR_TF_EMPT. An empty TX FIFO merely means the last data word has
been moved into the shift register; the transfer is not complete on the
bus until DW_SPI_SR_BUSY is also cleared. As a result the wait can
return while the controller is still shifting out the final word.

Any caller that tears down or reconfigures the controller right after
the transfer can then lose the tail of the transfer.

The memory-operation path in spi-dw-core.c already waits for both
DW_SPI_SR_BUSY == 0 and DW_SPI_SR_TF_EMPT == 1. Use the same completion
condition in the DMA path so the transfer is guaranteed to be finished
on the bus before the wait returns.

Signed-off-by: Wang YuWei <1973615295@qq.com>
Link: https://patch.msgid.link/tencent_4EA7B5C94669ED4C38A5F6C1C9126E5D9106@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index 4104e1bc2d5bd..a469626c50d53 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -281,7 +281,8 @@ static int dw_spi_dma_wait(struct dw_spi *dws, unsigned int len, u32 speed)
 
 static inline bool dw_spi_dma_tx_busy(struct dw_spi *dws)
 {
-	return !(dw_readl(dws, DW_SPI_SR) & DW_SPI_SR_TF_EMPT);
+	return (dw_readl(dws, DW_SPI_SR) &
+		(DW_SPI_SR_BUSY | DW_SPI_SR_TF_EMPT)) != DW_SPI_SR_TF_EMPT;
 }
 
 static int dw_spi_dma_wait_tx_done(struct dw_spi *dws,
-- 
2.53.0



