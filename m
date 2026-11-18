Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020035;
	b=gMuqKobyEV679kgVqM2+ffIohIR+bhQrN4BAFxkpYr2TsnV5iRqPIJInVKwyP9JuxbSi
	 BLxp/N4SExrClUSJiiYGXETZVJSGjC2Uv6Kqpb5yfSIMMXPxUbB1ezPxNy1sbuR4PHdTl
	 LY3GQiMEQ2xyWHJ39RaXLw0npPCl8J2MQjhezrbZoxN5MXE2Uhvs8/m74jl805T2ai1Ns
	 uG2THxKg1nnZrvurqPWIznqIZ9Y+x/G04078VmbSf+dLTNxAsU8VwWtsRFAPybWzfE/MG
	 O30Uo68VQTZxp8zNHPMhTtWApAo+dRI9MaOlbnKQ4eDEJ2XAs5RFUTUMr5wRWH7PN6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XHts2i3w7k/KB6UpdA7YDwfE+g7qZ9X5/m14T8qQYh8=;
	b=VEmF11FobXjq+PqNMUYhbadxCh8VzLBqDkgOqPaJpL9iy7qSEW9wHRK9FTNLG/66SQHN
	 34z1xBX7+cWQkqHAMwV4cDProkh5AfnJpTs68+0dLbLbVzyzTszu4Gfs/pYVE4stDDqUp
	 d/0772U3iZNndqpUBM+mo4Hf3HuSBYYqbjIXaNNVlZH6PcmjOvouK3K1z4rfhY4TMElZ9
	 9UGVrecmM5fPnv7VwQfrY7I5fCi0UGnVLIWu2ZBFNcR41ODJPrTmjSDa9CBSDlsASYJz1
	 N9KMJy5VTFbUkOVJRKm3QcuCgocBFoOfpKfrT9f3ceaB5/Z7KjStmIoQY9pqZvIqrTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwYfSohe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24921606A325;
	Wed, 18 Nov 2026 16:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwYfSohe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6971F000C5;
	Wed, 18 Nov 2026 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020035;
	bh=XHts2i3w7k/KB6UpdA7YDwfE+g7qZ9X5/m14T8qQYh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwYfSohe0vQ+TMz1JDRnfD/aV6RwBNQb80mUcOcQreZqqcnfGL3ojhfUNHaelafnV
	 9gJ99HcMJKc4TeExNRWU696rH8+hPFlZ5Y0FYdLiJm4aGqQJzyjqlMpjZQMmKFBOeF
	 5BZ8bafpSt/1nlMcZYCW//LhJLQgX/RR+gFCM7zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1808/2651] spi: meson-spicc: fix invalid DMA unmap on mapping failure
Date: Wed, 18 Nov 2026 15:50:48 +0100
Message-ID: <20261118150352.340000241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index fa2d2db2d6e7c..b1f8c823d5d01 100644
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



