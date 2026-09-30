Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8ED2E7386;
	Wed, 30 Sep 2026 18:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794701; cv=none; b=Z1Fd80Ro/fu4ixjAcxH/5XSoh/5C/xxA+mGl6Il0rZRKmmHIb9Uw5sPtqZN4hfwJQKLwvT8/ow9W9OlanQ9u5STxFZ5rFLgNTiSVVU3E0szcv23BHonHLebFvWhkVisy+RE6M2pIFlGbmsphFfs59FNGF++JRFQ/xdBmTjZ8HPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794701; c=relaxed/simple;
	bh=Ln5x0oO6U1oT1zcmc9bAtDEZif7QgtSP4pb0Ch7p+PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0rELzg6WW6R6Rs3nOkP9Cc/meIqQdqmOPGDjZxxYGCNZejAbsoj3bWykXjA+dKefw8Ob40UH8f8SzGkLLBBK8IBLdypkgm4iQ2tvn5xfXBUKivvhUzI9JjaNudupORtYd+c1X/xwu2H1bfBdRr6c3zcyTNkQ9ju3XbLwuUYE4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+zqSqVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+zqSqVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEF81F000FF;
	Wed, 30 Sep 2026 18:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794699;
	bh=x5DCTUUPaAvtGmI7IsLcz+RkC+58J8SGSmzdFa6/3zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+zqSqVxnALTMJPRi1eP5cZ9KT0AHw5nn0mFU5ObEA39kwSkDvCUd/lIkBjIzwGQD
	 PxZgiIFJWycFBwBhUCMtFO3yGW1XZqBmREO9o3BX+0h6Y4ayk/9QrjWV5oVFQA8Jro
	 936PXQ3z+Uhz83csmCU3oFF6eWmQpJIKv/f8xibo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang YuWei <1973615295@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0303/1193] spi: dw-dma: Wait for controller idle before completing Tx
Date: Wed, 30 Sep 2026 17:16:27 +0200
Message-ID: <20260930152440.883629564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0ecbb6c36e238..96fe5fd0228ee 100644
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



