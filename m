Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80201FC0;
	Tue, 13 Oct 2026 12:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895622; cv=none; b=oWKFb3NToLptTm53P7gktHKyPEfTm3HGoc6P37/bpVpbabRW6KJCdq5GiibHinh7e6M+vNqM+d81eRbaUerzuLx8EG2b7YtAHJ3+3taBEtkgEaO3B9S0JkE8DM7tW+d94AGIJKa+CuuFn8wdjgjP3/zhsKos1DvkVOHN5gz007U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895622; c=relaxed/simple;
	bh=bCGzmgrl5WME9SbCz33gEmxh62KDeCp4/a1/INGnpl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrQsymIwrdFypSlNfhU8ZdHAF0eJMGTCVi0tLGtxl+50xGHkaVET/jdODAk7dph/BI2BnzH1Ad1M8RIcpHQOKiAYa8P3ZxQJY1mguuuPGiDilarMhqjIHG0VDpg/tXP2ldQBGIhgUN7DAAEjT78D6WDKPVypGNtK04OOAxlp0F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEERolUy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEERolUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4841F00893;
	Tue, 13 Oct 2026 12:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895617;
	bh=KbOWnddKxgoM1k895NyxYyCiYzfJHr7lUwyVQQYM7Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEERolUy1YD04iR98WhGenBeLAqlDSZH4an3cJ0Ox7wOjvzuorX48+R49RXtnMRpM
	 g7RbenPyPcXqw1o/PNesnPmqG7D7sffBrbZ6tV5HsmFG3R3axLMsnax+lpjgsnHCn9
	 yv31DhWRi1nOvtLr3/I7jfIGRiDMLiff++msoqTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/497] iio: buffer-dmaengine: fix sg entry iteration when building dma_vecs
Date: Tue, 13 Oct 2026 13:38:23 +0200
Message-ID: <20261013112915.880488016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

[ Upstream commit 0d0ffbcc92e30a8d656ad76a6e278fa3400fed85 ]

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
[ sashal: adjusted context due to missing cyclic DMA flag handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iio/buffer/industrialio-buffer-dmaengine.c   | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/buffer/industrialio-buffer-dmaengine.c b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
index 95222f00e5ff4..0de2784ace22f 100644
--- a/drivers/iio/buffer/industrialio-buffer-dmaengine.c
+++ b/drivers/iio/buffer/industrialio-buffer-dmaengine.c
@@ -82,10 +82,13 @@ static int iio_dmaengine_buffer_submit_block(struct iio_dma_buffer_queue *queue,
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
@@ -93,7 +96,8 @@ static int iio_dmaengine_buffer_submit_block(struct iio_dma_buffer_queue *queue,
 
 		len_total = block->bytes_used;
 
-		for (i = 0; i < nents; i++) {
+		sgl = block->sg_table->sgl;
+		for (i = 0; i < nents && len_total; i++) {
 			vecs[i].addr = sg_dma_address(sgl);
 			vecs[i].len = min(sg_dma_len(sgl), len_total);
 			len_total -= vecs[i].len;
@@ -101,6 +105,8 @@ static int iio_dmaengine_buffer_submit_block(struct iio_dma_buffer_queue *queue,
 			sgl = sg_next(sgl);
 		}
 
+		nents = i;
+
 		desc = dmaengine_prep_peripheral_dma_vec(dmaengine_buffer->chan,
 							 vecs, nents, dma_dir,
 							 DMA_PREP_INTERRUPT);
-- 
2.53.0



