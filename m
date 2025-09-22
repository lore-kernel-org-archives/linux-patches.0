Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EAA2F28F9;
	Mon, 22 Sep 2025 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570370; cv=none; b=BsbSEBrdzlGqgnNp/9UpHpcp6N0Dq6ZfkJTaMI+wK9Swnmj1g01NDrpVXn619s0ZHm0vZ1P+oLS0Y1cJuGoufjiuChLHXesb1C7WjN+wmWv1yMQrpTABi3/GZ0tC4M5bsrJJrfO3dYovSeBlSQCSQVa252MS6YD+OtxrFrcXwPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570370; c=relaxed/simple;
	bh=TXWbr2+raW5r44R1TfE0BjxNKjoDhZLe+4+J+JXZFxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFh4tFvyMsY2tDCKTFY7s5dSCpQgYwIA/W8gsoEL2XL1REjtquaqWPkherfnjWvSGmJ5KWGSZRoSkpwn3VNVnIggDWQWgUdd9IrvJqh3zSIT9BPyMDLVQc0g0HK7ivwLFvcH5IZKOompfXyOvMEAsvCVL24nX27yA6ZPf1aFozQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iUuWauk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iUuWauk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F568C4CEF0;
	Mon, 22 Sep 2025 19:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570369;
	bh=TXWbr2+raW5r44R1TfE0BjxNKjoDhZLe+4+J+JXZFxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUuWauk0HrmsO86k/kIfKJNqppd0pNdRT7P3NIfzaiOON0RSWE7pU5KNBvu2X3of/
	 FI5rnGroNmlf3G94e88hMnRmDIxLUGCiIkNH6hUWXIG6BVhSpiEkC+moqJf/8uikzg
	 SYQBevWhLv4O16SEQ2Uw+w5RVD9hrJjy2La50iQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.16 122/149] ALSA: usb: qcom: Fix false-positive address space check
Date: Mon, 22 Sep 2025 21:30:22 +0200
Message-ID: <20250922192415.951488214@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 44499ecb4f2817743c37d861bdb3e95f37d3d9cd ]

The sanity check previously added to uaudio_transfer_buffer_setup()
assumed the allocated buffer being linear-mapped.  But the buffer
allocated via usb_alloc_coherent() isn't always so, rather to be used
with (SG-)DMA API.  This leaded to a false-positive warning and the
driver failed to work.

Actually uaudio_transfer_buffer_setup() deals only with the DMA-API
addresses for MEM_XFER_BUF type, while other callers of
uaudio_iommu_map() are with pages with physical addresses for
MEM_EVENT_RING and MEM_XFER_RING types.  So this patch splits the
mapping helper function to two different ones, uaudio_iommu_map() for
the DMA pages and uaudio_iommu_map_pa() for the latter, in order to
handle mapping differently for each type.  Along with it, the
unnecessary address check that caused probe error is dropped, too.

Fixes: 3335a1bbd624 ("ALSA: qc_audio_offload: try to reduce address space confusion")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reported-and-tested-by: Luca Weiss <luca.weiss@fairphone.com>
Closes: https://lore.kernel.org/DBR2363A95M1.L9XBNC003490@fairphone.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 92 ++++++++++++++++---------------
 1 file changed, 48 insertions(+), 44 deletions(-)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index a25c5a5316901..9ad76fff741b8 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -538,38 +538,33 @@ static void uaudio_iommu_unmap(enum mem_type mtype, unsigned long iova,
 			umap_size, iova, mapped_iova_size);
 }
 
+static int uaudio_iommu_map_prot(bool dma_coherent)
+{
+	int prot = IOMMU_READ | IOMMU_WRITE;
+
+	if (dma_coherent)
+		prot |= IOMMU_CACHE;
+	return prot;
+}
+
 /**
- * uaudio_iommu_map() - maps iommu memory for adsp
+ * uaudio_iommu_map_pa() - maps iommu memory for adsp
  * @mtype: ring type
  * @dma_coherent: dma coherent
  * @pa: physical address for ring/buffer
  * @size: size of memory region
- * @sgt: sg table for memory region
  *
  * Maps the XHCI related resources to a memory region that is assigned to be
  * used by the adsp.  This will be mapped to the domain, which is created by
  * the ASoC USB backend driver.
  *
  */
-static unsigned long uaudio_iommu_map(enum mem_type mtype, bool dma_coherent,
-				      phys_addr_t pa, size_t size,
-				      struct sg_table *sgt)
+static unsigned long uaudio_iommu_map_pa(enum mem_type mtype, bool dma_coherent,
+					 phys_addr_t pa, size_t size)
 {
-	struct scatterlist *sg;
 	unsigned long iova = 0;
-	size_t total_len = 0;
-	unsigned long iova_sg;
-	phys_addr_t pa_sg;
 	bool map = true;
-	size_t sg_len;
-	int prot;
-	int ret;
-	int i;
-
-	prot = IOMMU_READ | IOMMU_WRITE;
-
-	if (dma_coherent)
-		prot |= IOMMU_CACHE;
+	int prot = uaudio_iommu_map_prot(dma_coherent);
 
 	switch (mtype) {
 	case MEM_EVENT_RING:
@@ -583,20 +578,41 @@ static unsigned long uaudio_iommu_map(enum mem_type mtype, bool dma_coherent,
 				     &uaudio_qdev->xfer_ring_iova_size,
 				     &uaudio_qdev->xfer_ring_list, size);
 		break;
-	case MEM_XFER_BUF:
-		iova = uaudio_get_iova(&uaudio_qdev->curr_xfer_buf_iova,
-				     &uaudio_qdev->xfer_buf_iova_size,
-				     &uaudio_qdev->xfer_buf_list, size);
-		break;
 	default:
 		dev_err(uaudio_qdev->data->dev, "unknown mem type %d\n", mtype);
 	}
 
 	if (!iova || !map)
-		goto done;
+		return 0;
+
+	iommu_map(uaudio_qdev->data->domain, iova, pa, size, prot, GFP_KERNEL);
 
-	if (!sgt)
-		goto skip_sgt_map;
+	return iova;
+}
+
+static unsigned long uaudio_iommu_map_xfer_buf(bool dma_coherent, size_t size,
+					       struct sg_table *sgt)
+{
+	struct scatterlist *sg;
+	unsigned long iova = 0;
+	size_t total_len = 0;
+	unsigned long iova_sg;
+	phys_addr_t pa_sg;
+	size_t sg_len;
+	int prot = uaudio_iommu_map_prot(dma_coherent);
+	int ret;
+	int i;
+
+	prot = IOMMU_READ | IOMMU_WRITE;
+
+	if (dma_coherent)
+		prot |= IOMMU_CACHE;
+
+	iova = uaudio_get_iova(&uaudio_qdev->curr_xfer_buf_iova,
+			       &uaudio_qdev->xfer_buf_iova_size,
+			       &uaudio_qdev->xfer_buf_list, size);
+	if (!iova)
+		goto done;
 
 	iova_sg = iova;
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
@@ -618,11 +634,6 @@ static unsigned long uaudio_iommu_map(enum mem_type mtype, bool dma_coherent,
 		uaudio_iommu_unmap(MEM_XFER_BUF, iova, size, total_len);
 		iova = 0;
 	}
-	return iova;
-
-skip_sgt_map:
-	iommu_map(uaudio_qdev->data->domain, iova, pa, size, prot, GFP_KERNEL);
-
 done:
 	return iova;
 }
@@ -1020,7 +1031,6 @@ static int uaudio_transfer_buffer_setup(struct snd_usb_substream *subs,
 	struct sg_table xfer_buf_sgt;
 	dma_addr_t xfer_buf_dma;
 	void *xfer_buf;
-	phys_addr_t xfer_buf_pa;
 	u32 len = xfer_buf_len;
 	bool dma_coherent;
 	dma_addr_t xfer_buf_dma_sysdev;
@@ -1051,18 +1061,12 @@ static int uaudio_transfer_buffer_setup(struct snd_usb_substream *subs,
 	if (!xfer_buf)
 		return -ENOMEM;
 
-	/* Remapping is not possible if xfer_buf is outside of linear map */
-	xfer_buf_pa = virt_to_phys(xfer_buf);
-	if (WARN_ON(!page_is_ram(PFN_DOWN(xfer_buf_pa)))) {
-		ret = -ENXIO;
-		goto unmap_sync;
-	}
 	dma_get_sgtable(subs->dev->bus->sysdev, &xfer_buf_sgt, xfer_buf,
 			xfer_buf_dma, len);
 
 	/* map the physical buffer into sysdev as well */
-	xfer_buf_dma_sysdev = uaudio_iommu_map(MEM_XFER_BUF, dma_coherent,
-					       xfer_buf_pa, len, &xfer_buf_sgt);
+	xfer_buf_dma_sysdev = uaudio_iommu_map_xfer_buf(dma_coherent,
+							len, &xfer_buf_sgt);
 	if (!xfer_buf_dma_sysdev) {
 		ret = -ENOMEM;
 		goto unmap_sync;
@@ -1143,8 +1147,8 @@ uaudio_endpoint_setup(struct snd_usb_substream *subs,
 	sg_free_table(sgt);
 
 	/* data transfer ring */
-	iova = uaudio_iommu_map(MEM_XFER_RING, dma_coherent, tr_pa,
-			      PAGE_SIZE, NULL);
+	iova = uaudio_iommu_map_pa(MEM_XFER_RING, dma_coherent, tr_pa,
+				   PAGE_SIZE);
 	if (!iova) {
 		ret = -ENOMEM;
 		goto clear_pa;
@@ -1207,8 +1211,8 @@ static int uaudio_event_ring_setup(struct snd_usb_substream *subs,
 	mem_info->dma = sg_dma_address(sgt->sgl);
 	sg_free_table(sgt);
 
-	iova = uaudio_iommu_map(MEM_EVENT_RING, dma_coherent, er_pa,
-			      PAGE_SIZE, NULL);
+	iova = uaudio_iommu_map_pa(MEM_EVENT_RING, dma_coherent, er_pa,
+				   PAGE_SIZE);
 	if (!iova) {
 		ret = -ENOMEM;
 		goto clear_pa;
-- 
2.51.0



