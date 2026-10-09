Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A67181ACD;
	Fri,  9 Oct 2026 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557638; cv=none; b=SelbiB2xSIJBJj+A9bsBsJZfQWO4w1rHhTHTOG4mDPaQYVnXnhDYAEx1k6XqQFtpJmKjj4i+/+cSJZv1hF28NdV46iyYLXR+uQ49Y2BHuNEi8wIiMvG06c0Hw2/yada3s3ExkrcnPoZAINxlrBle2sGWstQtbEll33MZrmMSqpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557638; c=relaxed/simple;
	bh=59ZAyncmwkKhNEnaS7MJT758oAU/AGbQ+nh0sKrHp+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HM17MaeTbqzI2+MKl1KaXViVgNuCkYlL2GzZHD/CY6IO2sMQWMISo6s4HSK13+zf6ww0fMxTy85N2Lv7KN4kIO7iNhcpQPGscV9ZKaa5LaPMsLbAoU3sJBxXtAIQblynFXQfPKjXdoXtTmLA3qYEMjpd/4hIt91tYdfUQnTNvFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fziKpVzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fziKpVzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C792E1F000FF;
	Fri,  9 Oct 2026 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557637;
	bh=643URxoC5e0ppboO8SPxYKEH0EYasGUNHItA5bVD/Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fziKpVzzNFPCv+z6kXyJm/t6bHLLP+qvUcnr38MsFXghlrnFLu1eaRkloNjCm5O5B
	 qQNfyI1mS1cBd3v7Ym27/1ZICcoDS/M5CCgZDvK067o+Tx+yEZUIJeFYT/uzMu9r2H
	 254Lp8oxXsEKibtHUU5ZnLAvUQny5v0dkeU5QMcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 428/428] iio: buffer-dmaengine: fix sg entry iteration when building dma_vecs
Date: Fri,  9 Oct 2026 16:12:45 +0200
Message-ID: <20261009140955.651151120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit 0d0ffbcc92e30a8d656ad76a6e278fa3400fed85 upstream.

iio_dmaengine_buffer_submit_block() counts scatterlist entries with
sg_nents_for_len(), which walks the CPU-side lengths (sg->length), but
then consumes the DMA-side fields (sg_dma_address()/sg_dma_len()).
After dma_map_sgtable() the two views may differ: an IOMMU can coalesce
the mapping so that only the first sgt->nents entries carry valid DMA
addresses, with nents < orig_nents.

On x86 with an IOMMU enabled, a DMABUF block backed by two 1 MiB
system-heap chunks maps to a single 2 MiB IOVA range. The CPU-side
count is 2, so the loop reads one entry past the mapped set and emits a
garbage vec ({addr = ~0, len = 0}). The DMA engine driver rejects the
vec array (prep returns NULL), the fence is signalled with -ENOMEM,
which a userspace poller cannot observe, and the block is left in
ACTIVE state so every further enqueue of it fails with -EBUSY. The
visible symptom is a stream of zero-filled blocks followed by a wedged
buffer.

Platforms without an IOMMU never hit this because nents == orig_nents.

Size the vec array with sgt->nents, i.e. the DMA-mapped view, and stop
the fill loop once bytes_used is covered - which is allowed to be
smaller than the block size - passing the number of vecs actually
filled to dmaengine_prep_peripheral_dma_vec().

One vec per mapped entry is enough since coalescing can only ever
reduce the number of entries. A single mapped entry longer than the
device's maximum segment size would need more than one, but the DMA API
already assumes no single segment exceeds it [1], and splitting a vec
down to the hardware descriptor size is the DMA engine driver's job -
which both current .device_prep_peripheral_dma_vec() implementations
do.

[1]: commit ab2cbeb0ed30 ("iommu/dma: Handle SG length overflow better")

Assisted-by: Claude:claude-fable-5
Fixes: 7a86d469983a ("iio: buffer-dmaengine: Support new DMABUF based userspace API")
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: Adjusted context for the missing IIO DMAengine cyclic-transfer implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/iio/buffer/industrialio-buffer-dmaengine.c
+++ b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
@@ -80,10 +80,13 @@ static int iio_dmaengine_buffer_submit_b
 		dma_dir = DMA_MEM_TO_DEV;
 
 	if (block->sg_table) {
-		sgl = block->sg_table->sgl;
-		nents = sg_nents_for_len(sgl, block->bytes_used);
-		if (nents < 0)
-			return nents;
+		/*
+		 * Only the first sgt->nents entries carry a valid
+		 * sg_dma_address()/sg_dma_len() pair as mapping the table may
+		 * have coalesced entries, in which case nents is smaller than
+		 * orig_nents.
+		 */
+		nents = block->sg_table->nents;
 
 		vecs = kmalloc_array(nents, sizeof(*vecs), GFP_ATOMIC);
 		if (!vecs)
@@ -91,7 +94,8 @@ static int iio_dmaengine_buffer_submit_b
 
 		len_total = block->bytes_used;
 
-		for (i = 0; i < nents; i++) {
+		sgl = block->sg_table->sgl;
+		for (i = 0; i < nents && len_total; i++) {
 			vecs[i].addr = sg_dma_address(sgl);
 			vecs[i].len = min(sg_dma_len(sgl), len_total);
 			len_total -= vecs[i].len;
@@ -99,6 +103,8 @@ static int iio_dmaengine_buffer_submit_b
 			sgl = sg_next(sgl);
 		}
 
+		nents = i;
+
 		desc = dmaengine_prep_peripheral_dma_vec(dmaengine_buffer->chan,
 							 vecs, nents, dma_dir,
 							 DMA_PREP_INTERRUPT);


