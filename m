Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C557B330B36;
	Fri, 17 Oct 2025 15:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716678; cv=none; b=KqmDm7N11p85hf6hZEoDkMz2U201T3B7KZ01orbVe0coyIb7rAwma08a7GS4NGboOBH6hHgEXD2mZVf9ZXVgeTILJtyxOGUPhLgptdLyFX+W31US6jhrGAWY3YccCyDgPuRc5EKGqigjhI5VbhqDHLZHEjNUwkRnI9iXLf1tTpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716678; c=relaxed/simple;
	bh=ET9FkovHB0tB+vFwfSfQKqYUIrKqzrQlX75ty9uhGyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mu60tgl6mc1N74Bn+ChBvKHPzvnkx/9atHxksjfN4/FE+O7e0z+2qfhdxiiWGi5TrXSd5r2Q6g7ls/Q7XdxPxWfRth4J4DYx3IDz9/kMVumv94mYZzCqwezqSV/jsv1qAwBdnjCK05qb1AYEQN0lAf1/U/usxwubqoJ81408R5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8obA+Oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8obA+Oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F6DC4CEE7;
	Fri, 17 Oct 2025 15:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716678;
	bh=ET9FkovHB0tB+vFwfSfQKqYUIrKqzrQlX75ty9uhGyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8obA+OeIjuRY4XyLI2zWek8y6hAhpmIib7DSYQqK4tgDIwwGI/rorsWrfLAWSj0i
	 TZItgqheEJpWdmNMNdDITiccgpNpJkgEyHVbk9E8sxa6QA9jcZQmUZygmahjTlPPPg
	 YDONNCqt6PCyQk8a29AsnfQ2sTwxHqpH69HvjS8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 273/276] media: pci: ivtv: Add check for DMA map result
Date: Fri, 17 Oct 2025 16:56:06 +0200
Message-ID: <20251017145152.458195037@linuxfoundation.org>
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

From: Mikhail Kobuk <m.kobuk@ispras.ru>

commit 629913d6d79508b166c66e07e4857e20233d85a9 upstream.

In case DMA fails, 'dma->SG_length' is 0. This value is later used to
access 'dma->SGarray[dma->SG_length - 1]', which will cause out of
bounds access.

Add check to return early on invalid value. Adjust warnings accordingly.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1932dc2f4cf6 ("media: pci/ivtv: switch from 'pci_' to 'dma_' API")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/ivtv/ivtv-udma.c |    8 ++++++++
 drivers/media/pci/ivtv/ivtv-yuv.c  |    6 ++++++
 drivers/media/pci/ivtv/ivtvfb.c    |    6 +++---
 3 files changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/media/pci/ivtv/ivtv-udma.c
+++ b/drivers/media/pci/ivtv/ivtv-udma.c
@@ -131,6 +131,8 @@ int ivtv_udma_setup(struct ivtv *itv, un
 
 	/* Fill SG List with new values */
 	if (ivtv_udma_fill_sg_list(dma, &user_dma, 0) < 0) {
+		IVTV_DEBUG_WARN("%s: could not allocate bounce buffers for highmem userspace buffers\n",
+				__func__);
 		unpin_user_pages(dma->map, dma->page_count);
 		dma->page_count = 0;
 		return -ENOMEM;
@@ -139,6 +141,12 @@ int ivtv_udma_setup(struct ivtv *itv, un
 	/* Map SG List */
 	dma->SG_length = dma_map_sg(&itv->pdev->dev, dma->SGlist,
 				    dma->page_count, DMA_TO_DEVICE);
+	if (!dma->SG_length) {
+		IVTV_DEBUG_WARN("%s: DMA map error, SG_length is 0\n", __func__);
+		unpin_user_pages(dma->map, dma->page_count);
+		dma->page_count = 0;
+		return -EINVAL;
+	}
 
 	/* Fill SG Array with new values */
 	ivtv_udma_fill_sg_array (dma, ivtv_dest_addr, 0, -1);
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -115,6 +115,12 @@ static int ivtv_yuv_prep_user_dma(struct
 	}
 	dma->SG_length = dma_map_sg(&itv->pdev->dev, dma->SGlist,
 				    dma->page_count, DMA_TO_DEVICE);
+	if (!dma->SG_length) {
+		IVTV_DEBUG_WARN("%s: DMA map error, SG_length is 0\n", __func__);
+		unpin_user_pages(dma->map, dma->page_count);
+		dma->page_count = 0;
+		return -EINVAL;
+	}
 
 	/* Fill SG Array with new values */
 	ivtv_udma_fill_sg_array(dma, y_buffer_offset, uv_buffer_offset, y_size);
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -281,10 +281,10 @@ static int ivtvfb_prep_dec_dma_to_device
 	/* Map User DMA */
 	if (ivtv_udma_setup(itv, ivtv_dest_addr, userbuf, size_in_bytes) <= 0) {
 		mutex_unlock(&itv->udma.lock);
-		IVTVFB_WARN("ivtvfb_prep_dec_dma_to_device, Error with pin_user_pages: %d bytes, %d pages returned\n",
-			       size_in_bytes, itv->udma.page_count);
+		IVTVFB_WARN("%s, Error in ivtv_udma_setup: %d bytes, %d pages returned\n",
+			       __func__, size_in_bytes, itv->udma.page_count);
 
-		/* pin_user_pages must have failed completely */
+		/* pin_user_pages or DMA must have failed completely */
 		return -EIO;
 	}
 


