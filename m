Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6731A6166;
	Tue, 30 Jul 2024 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357934; cv=none; b=N+7diUxCV1rF42ivAD69LPJN5IDJf6H0VkiW39sJVXbtDAXEZ6o8rfNMaD+u3F0ZfRylUEDqUqqg2dDxmtXWv5pB4+jHNAoEes2XT2dlqju7dguIx1G5/qD2XLft/oJjyO1O3WCD+1BjeAA832K0iSknQXr9a4SANNUA6GTA+9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357934; c=relaxed/simple;
	bh=A/9hniZrVmr+Wz3pomF39UKYvPLZBtGtEEIvolk2VoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4S9bYp+yN2Md0ZQDMR2otGKXBNF75fLm0Vcb1/TSkDUhPlgry++X5lqpBcSHUW3nDGhjzc6nGkpVIWlGp8/OF+9o3QCailCI/1ylr0B0orZ2nomCb2kIVMHYsgwVmaYdKZcGHLnCzhw+9UKtb0E/aSEWMY5C6af6zA+tlkmUHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3HduIeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3HduIeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC81BC4AF0E;
	Tue, 30 Jul 2024 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357934;
	bh=A/9hniZrVmr+Wz3pomF39UKYvPLZBtGtEEIvolk2VoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3HduIeFLeWcEduNQT6lUS5v5MOxEsS0LuSyNyQbzG4iyOGbIZcUEJ9/7VorAlabB
	 /soWOouwV16yx5cYFxNKE7zDtGxUwQeSqR9InKTL6pZm6cVkZL/hRgKZ/OY30FXNPG
	 qbiBN2gq7+veCKy2IItF/1ZhgI/uuD/PZkbccIj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 287/809] media: pci: ivtv: Add check for DMA map result
Date: Tue, 30 Jul 2024 17:42:43 +0200
Message-ID: <20240730151735.929588949@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kobuk <m.kobuk@ispras.ru>

[ Upstream commit 629913d6d79508b166c66e07e4857e20233d85a9 ]

In case DMA fails, 'dma->SG_length' is 0. This value is later used to
access 'dma->SGarray[dma->SG_length - 1]', which will cause out of
bounds access.

Add check to return early on invalid value. Adjust warnings accordingly.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1932dc2f4cf6 ("media: pci/ivtv: switch from 'pci_' to 'dma_' API")
Signed-off-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-udma.c | 8 ++++++++
 drivers/media/pci/ivtv/ivtv-yuv.c  | 6 ++++++
 drivers/media/pci/ivtv/ivtvfb.c    | 6 +++---
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
index 99b9f55ca8292..f467a00492f4b 100644
--- a/drivers/media/pci/ivtv/ivtv-udma.c
+++ b/drivers/media/pci/ivtv/ivtv-udma.c
@@ -131,6 +131,8 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
 
 	/* Fill SG List with new values */
 	if (ivtv_udma_fill_sg_list(dma, &user_dma, 0) < 0) {
+		IVTV_DEBUG_WARN("%s: could not allocate bounce buffers for highmem userspace buffers\n",
+				__func__);
 		unpin_user_pages(dma->map, dma->page_count);
 		dma->page_count = 0;
 		return -ENOMEM;
@@ -139,6 +141,12 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
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
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 582146f8d70d5..2d9274537725a 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -114,6 +114,12 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
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
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 410477e3e6216..d1ab7fee0d057 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -281,10 +281,10 @@ static int ivtvfb_prep_dec_dma_to_device(struct ivtv *itv,
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
 
-- 
2.43.0



