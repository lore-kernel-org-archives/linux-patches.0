Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02569330B2E;
	Fri, 17 Oct 2025 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716673; cv=none; b=B7YYTSe/Zo3ZiM+Itl1eFZnlq8+qLG9XHZW6yLE1D8e54XKfst83kIiNZHYxbdy1PlfPvNk7SCsS1JEkUipWldWs+mrBF5VbEKHq0vLBMvRQ+VVJ5HKylUbxBy8RoOq8VPEk8tVLOouEcUco6pMvKm8aHbgw4Yelxoh30AP80q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716673; c=relaxed/simple;
	bh=bCY0lkITWSGatl9XKhX8P17WTNF44TZ702lx3Vbza4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRYcsoCDgW3jsB4MgZACjnYDt7k6AHjL5y/vHYYlsiugpfTVzf0U/eiORr1tURGTLz86+ywa1jigoDHJ3lAhn/veoxUQJtOWU9+TluIrYEKcXpQkKTINIq4Z+ZUi0N1QPcrh3CnYNpQJtla4f+zVL8n5Y2Vn/ka4rc8CrxZ6v3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPFrkv6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPFrkv6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC5CC4CEE7;
	Fri, 17 Oct 2025 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716672;
	bh=bCY0lkITWSGatl9XKhX8P17WTNF44TZ702lx3Vbza4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPFrkv6vqXMfxJehzbLKWUyW/0BAI1PjxyCruB6+ztEoXRSHJ5yeLNeUsVkTFSra/
	 4cmkk3kEYTDRqaf77iWrvIuYm62XQPv5kMwOFK6N1isuVCiof+ALzRRbzayLeVkgim
	 DGD/vT4Sccsx4J5VTFJMVjmvtuXT+Iiz+QXiifpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/276] media: pci: ivtv: Add missing check after DMA map
Date: Fri, 17 Oct 2025 16:56:04 +0200
Message-ID: <20251017145152.382510211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 1069a4fe637d0e3e4c163e3f8df9be306cc299b4 ]

The DMA map functions can fail and should be tested for errors.
If the mapping fails, free blanking_ptr and set it to 0.  As 0 is a
valid DMA address, use blanking_ptr to test if the DMA address
is set.

Fixes: 1a0adaf37c30 ("V4L/DVB (5345): ivtv driver for Conexant cx23416/cx23415 MPEG encoder/decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/ivtv/ivtv-irq.c |    2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/ivtv/ivtv-irq.c
+++ b/drivers/media/pci/ivtv/ivtv-irq.c
@@ -351,7 +351,7 @@ void ivtv_dma_stream_dec_prepare(struct
 
 	/* Insert buffer block for YUV if needed */
 	if (s->type == IVTV_DEC_STREAM_TYPE_YUV && f->offset_y) {
-		if (yi->blanking_dmaptr) {
+		if (yi->blanking_ptr) {
 			s->sg_pending[idx].src = yi->blanking_dmaptr;
 			s->sg_pending[idx].dst = offset;
 			s->sg_pending[idx].size = 720 * 16;
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -120,7 +120,7 @@ static int ivtv_yuv_prep_user_dma(struct
 	ivtv_udma_fill_sg_array(dma, y_buffer_offset, uv_buffer_offset, y_size);
 
 	/* If we've offset the y plane, ensure top area is blanked */
-	if (f->offset_y && yi->blanking_dmaptr) {
+	if (f->offset_y && yi->blanking_ptr) {
 		dma->SGarray[dma->SG_length].size = cpu_to_le32(720*16);
 		dma->SGarray[dma->SG_length].src = cpu_to_le32(yi->blanking_dmaptr);
 		dma->SGarray[dma->SG_length].dst = cpu_to_le32(IVTV_DECODER_OFFSET + yuv_offset[frame]);
@@ -924,6 +924,12 @@ static void ivtv_yuv_init(struct ivtv *i
 		yi->blanking_dmaptr = dma_map_single(&itv->pdev->dev,
 						     yi->blanking_ptr,
 						     720 * 16, DMA_TO_DEVICE);
+		if (dma_mapping_error(&itv->pdev->dev, yi->blanking_dmaptr)) {
+			kfree(yi->blanking_ptr);
+			yi->blanking_ptr = NULL;
+			yi->blanking_dmaptr = 0;
+			IVTV_DEBUG_WARN("Failed to dma_map yuv blanking buffer\n");
+		}
 	} else {
 		yi->blanking_dmaptr = 0;
 		IVTV_DEBUG_WARN("Failed to allocate yuv blanking buffer\n");


