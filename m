Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026656;
	b=r3fkWsRgEheUwV154cM2TVZ6TJoutsQrDgl8vYNKrxEhtYKImxHV0h53o2gdkx6K3/LK
	 4iwcHkPr723kaC7hcTPS/XDbgeyG4ZxRs0MD9kkZzoxE+/5S+ZcqxYTf6UI9ZJA+wbvro
	 d12fq15/wjBTT05W5AAngu3Bw3cWzkbJEOtwphmyDrljTpmYegp/+ct51tQNlUXvXfFGw
	 +UBQFE+oKTO1I4U+pWGL2i/nsblkk06wb1q0ZegFZ5JUwoMNuGGmV6u4kPYlvtxN4eIoL
	 cTas8RR2ThVv1yjzdRUr52ItQ90+p+4x5/DNbg2owPpeI+usTJ/oNhVH4Z+dTZ2ih1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7z0Hc7mulX+HosWgjcGbsCuRI33lkz5u6uTUJ7P/dow=;
	b=JanpQmSpkD8iuMvQ6KsxCprxlnH+ZGYeYNsU3vowOyUptJZe+nEX3teew5/pP/f1kpQt
	 J/Rnn226tJoFm00JeeoA46hfXli9YeWhjOSDTvpROipy+GPpzuWDTv6UT1dnuoW/yd3Th
	 Klvxg8h5C2Ttk0JZZpz2Hjt5YkwVULp1Cy8LkoUyzh0FZdqpFYfqmrpdgX4o9sZu3lgsj
	 dO4if57mB3qO5ew2wqynjcArAgV4/04SaVqVkmEkA+8RFLE7lnvfp5tuRIc0yy9otsE7b
	 HLRPGvjYy9YfmU2qEL7hR9eH1mFr9d0SXKv7WKhdqHAvX4Gnhrq/1BhHeM+bsgXHtyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X/c95T/x";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE901606A31C;
	Wed, 18 Nov 2026 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X/c95T/x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B931F000C4;
	Wed, 18 Nov 2026 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026656;
	bh=7z0Hc7mulX+HosWgjcGbsCuRI33lkz5u6uTUJ7P/dow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/c95T/xzRHOVUUTf4yIzfLdgD2HdMwB11tgfKoWu9bBJiryVWYmXIm66eOQfoQDH
	 gbHVjsdHXEtVH3jNng1Bt9EtqDmiZAnyiNzdloC4qXTlAe5778acCSbmDm2VA2dAhe
	 3BWY9tR8F2nYwxSUXifpQkN4T0twnstunazJzdGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1470/2151] spi: meson-spicc: fix invalid DMA unmap on mapping failure
Date: Wed, 18 Nov 2026 15:53:25 +0100
Message-ID: <20261118150215.442313518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongjian Dai <daihongjian@kylinsec.com.cn>

[ Upstream commit 9d71f9fe5b5de916bded51343138b09b1eb103ed ]

meson_spicc_dma_unmap() decided whether a buffer had to be unmapped by
testing its DMA address for non-zero. On a mapping failure
dma_map_single() returns DMA_MAPPING_ERROR (typically non-zero), so the
error path in meson_spicc_transfer_one() passed that error value to
dma_unmap_single(), unmapping an address which was never mapped. The
same happened for t->rx_dma on TX mapping failure, which is not written
at all.

Initialize both addresses to DMA_MAPPING_ERROR before mapping and use
dma_mapping_error() to decide, so only buffers which were actually
mapped are unmapped.

Fixes: 18197e98353d ("spi: meson-spicc: add DMA support")
Signed-off-by: Hongjian Dai <daihongjian@kylinsec.com.cn>
Link: https://patch.msgid.link/35143466F2F5166F+20261008124704.87708-1-daihongjian@kylinsec.com.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index bb27a3b2bbc21..e8378acc2bb65 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -235,6 +235,13 @@ static int meson_spicc_dma_map(struct meson_spicc_device *spicc,
 {
 	struct device *dev = spicc->host->dev.parent;
 
+	/*
+	 * Mark the DMA addresses as invalid so that meson_spicc_dma_unmap()
+	 * will not try to unmap a buffer which was not (successfully) mapped.
+	 */
+	t->tx_dma = DMA_MAPPING_ERROR;
+	t->rx_dma = DMA_MAPPING_ERROR;
+
 	if (!(t->tx_buf && t->rx_buf))
 		return -EINVAL;
 
@@ -257,9 +264,9 @@ static void meson_spicc_dma_unmap(struct meson_spicc_device *spicc,
 {
 	struct device *dev = spicc->host->dev.parent;
 
-	if (t->tx_dma)
+	if (!dma_mapping_error(dev, t->tx_dma))
 		dma_unmap_single(dev, t->tx_dma, t->len, DMA_TO_DEVICE);
-	if (t->rx_dma)
+	if (!dma_mapping_error(dev, t->rx_dma))
 		dma_unmap_single(dev, t->rx_dma, t->len, DMA_FROM_DEVICE);
 }
 
-- 
2.53.0



