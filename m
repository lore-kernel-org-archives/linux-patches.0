Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774784;
	b=mT6JMgeoAeIjOrzu9cdSnsO82bC6LO9gkvBmImEfbQY5GCwyGi52p7NS1tZawrE0dd69
	 K7DIrznEEUxu+FKxlYR7kJ8N6Pw5AtmCIwGIeYawmShQWd6imiLPYZgbJiiviHvWGlv8B
	 wUEXafC38K+hTg984/T26s2y0Iw1etdmr+KGbHaAeT1GxdWLilyWkITwyyk/ZPFZ+UgGW
	 OB1h8XLDFmoGoTW2dNrLWKb2P2P+9skxDFxcA7k9Vgt2XXjIbOuFK9YbZfZTywZBU1OEA
	 6OKRZRKtVUOGBpQdFOod5CihMbS/4xpItoKqd9papKRrxoCqQIcPLVLEcvzvlaT0jhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ObUFDAokTb8uG6UBU99RqVcycagu6X/zkFciLwWaxJ0=;
	b=ISwXZ/jO6Kdshp7vdqn3n9eeOLgafGhZzlM/rkHgmnMUGJ3RpNtAfWBgeYQqnzBxlLwj
	 Tv23ARbTqYq9jN6vNh4v3TRr9WLITXryeNfkZgWlVdbTpBHlPS1HcHoDH3jQSiOdLvmWQ
	 m3Y6ZFk3MODH3V4crZVjYh09ESw68E26vpMrqlYJH9qBEXZEg2clTuuWHbo9c/FSCO0H9
	 Dm9SwYUiDCYlui+TnR6oSr/+H9KRtCRFQgpfXhAYIwt71MBgjWOGFDfr0cV4qZYIpr7oU
	 7qQQHlf4bWrybaGyQEMTYMvxZLpwsCPpaJDnBFjY+LHb//PtiI78UFHxqmHMEhoBWiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0yG2pUr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C7C606A31A;
	Fri, 23 Oct 2026 16:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0yG2pUr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD791F01825;
	Fri, 23 Oct 2026 16:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774783;
	bh=ObUFDAokTb8uG6UBU99RqVcycagu6X/zkFciLwWaxJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0yG2pUruTnlUwhk0S2URdtr0JJ1Iz4ZUl/p+t3JNZwJvHxD5f38Wfnagummr6Wb/
	 ihFEsDVjVxNsZwuwbFXc998YkNP9Xpc+30X9QNZx2SKbJIOFY6N4VpMYojQowTLnLC
	 4G8IA0VDamoLn44ScN1sD8n7UukDp39rw9u10R1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Leitner <richard.leitner@linux.dev>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 130/242] spi: imx: fix slab corruption from undersized DMA bounce buffers
Date: Fri, 23 Oct 2026 18:39:32 +0200
Message-ID: <20261023163716.857175703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Leitner <richard.leitner@linux.dev>

commit 59eb22641f0c526dd064390b11cff99ae87c2858 upstream.

Since commit faa8e404ad8e ("spi: imx: support dynamic burst length for
ECSPI DMA mode"), the driver allocates its private DMA TX/RX buffers
with kzalloc(dma_len), where dma_len is only rounded up to 4 bytes, but
maps, syncs and unmaps them with DMA_CACHE_ALIGNED_LEN(dma_len), i.e.
rounded up to the cache line size. As a result, the DMA API operates on
memory beyond the end of the allocation.

This was observed on a custom i.MX8MP platform with an mcp251xfd CAN
controller under heavy RPMSG load, as a series of refcount_t warnings
triggered from rpmsg_recv_done() in virtio_rpmsg_bus:

  refcount_t: addition on 0; use-after-free.
  refcount_t: underflow; use-after-free.
  refcount_t: saturated; leaking memory.

Leading finally to an "Unable to handle kernel paging request" oops.
Reproducing this problem took between 30 minutes and roughly 30 hours
under the same workload.

Hardware watchpoints on the refcount of a struct rpmsg_endpoint showed
it was overwritten from 2 to 1 by __pi_memcpy_generic() in the
irq/155-spi2.0 thread. Additionally it was found that a "normal"
rpmsg_recv_done() took 11µs +/-2µs from its kref_get to kref_put. In
the error case the same sequence took about 215µs +/-10µs. Based on
this, an LLM was used to identify the size mismatch fixed here.

Allocate the buffers with DMA_CACHE_ALIGNED_LEN(dma_len) so they cover
the full mapped length, and use the same length for
dma_sync_single_for_cpu() to stay consistent with map and unmap.

With this patch applied, the same workload ran for more than 200 hours
without the problem reproducing.

Assisted-by: LLM
Fixes: faa8e404ad8e ("spi: imx: support dynamic burst length for ECSPI DMA mode")
Cc: stable@vger.kernel.org
Signed-off-by: Richard Leitner <richard.leitner@linux.dev>
Link: https://patch.msgid.link/20261015-fix-spi-imx-dma-v1-1-e28259671392@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1578,11 +1578,13 @@ static int spi_imx_dma_tx_data_handle(st
 		dma_data->dma_len = ALIGN(dma_data->data_len, BYTES_PER_32BITS_WORD);
 	}
 
-	dma_data->dma_tx_buf = kzalloc(dma_data->dma_len, GFP_KERNEL);
+	dma_data->dma_tx_buf = kzalloc(DMA_CACHE_ALIGNED_LEN(dma_data->dma_len),
+				       GFP_KERNEL);
 	if (!dma_data->dma_tx_buf)
 		return -ENOMEM;
 
-	dma_data->dma_rx_buf = kzalloc(dma_data->dma_len, GFP_KERNEL);
+	dma_data->dma_rx_buf = kzalloc(DMA_CACHE_ALIGNED_LEN(dma_data->dma_len),
+				       GFP_KERNEL);
 	if (!dma_data->dma_rx_buf) {
 		kfree(dma_data->dma_tx_buf);
 		return -ENOMEM;
@@ -1920,7 +1922,8 @@ static int spi_imx_dma_package_transfer(
 
 	/* Trim the DMA RX buffer and copy the actual data to rx_buf */
 	dma_sync_single_for_cpu(controller->dma_rx->device->dev, dma_data->dma_rx_addr,
-				dma_data->dma_len, DMA_FROM_DEVICE);
+				DMA_CACHE_ALIGNED_LEN(dma_data->dma_len),
+				DMA_FROM_DEVICE);
 	spi_imx_dma_rx_data_handle(spi_imx, dma_data, transfer->rx_buf + spi_imx->rx_offset,
 				   word_delay);
 	spi_imx->rx_offset += dma_data->data_len;


