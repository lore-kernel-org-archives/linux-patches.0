Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626092;
	b=EsS1FWMJpqMr6xiRlOrgG8rHZdhJuXKXXbPMz0WuQCKFJwc/1BXOf1/zdkHUMBuy1SvR
	 QZvfQvRECX+NHfufF9teM4/e61EdvRN5JnuOW9/u3ZC8F0AjBBl1+VeLOa6tu8QPRwiog
	 gqCftLy9sz9UX7uhxEnHAoqXcayCjapttZZQZ6+W6wLKE6sjbLD+JJqnb4C7g17iA8d41
	 YTjXq93eqxNy7knpkGOkYaaOg9fsvwDIChUKNNye5HyZJ0rOwClNxD86wKeI6lhtxSddf
	 vWmy8LZgf5Aro1HLXDbj6WBgq3VGQvdsRvFxl9h/3pk7UX8HKa0kr6GBvkB28tbRH8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ozkj4Qnt+/npW48G4ukdhpx/qnR/YV0LwlYZrtp+psQ=;
	b=icSAJ8QroXrg4DdvSk/pLtNd2MEOs0XVQHGafTqa6ZsQh9oa/VD4JQmkRA5DFRb79e+/
	 0dLIsK+yj4Ek+jhbDIKaqUZGI0qicJ62x4MsWc0uqUcK59fnY1sYgM1CroWABWqX3QRR4
	 kF5T1aObyI8bwH/Wn+WQ75OkYHS6AYl+YRBEpyq6lXtFoN9QkZLRoiFkgqY5mJ48zXw1r
	 g7Xhoj8iolmBx1r3HwEYeJZDL6auDDgn5nMZnpLr2CHR8Jg2VgVo3+f3sHdZGWM/SPwCZ
	 WJZnLndktxX8tBpTU+godF5qzbWZwhiABJjdcpJo13CRO4pBK8I5sBvGPDDc4sWY2+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wkj7s2+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CC1606A31E;
	Wed, 25 Nov 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wkj7s2+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522101F000CF;
	Wed, 25 Nov 2026 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626091;
	bh=ozkj4Qnt+/npW48G4ukdhpx/qnR/YV0LwlYZrtp+psQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wkj7s2+gCC5/L+k+HkaSsqBSgZxzIJH2ZHNKr1M88P1OvKjcAmY0bqMIWH5+0kGW5
	 jgraMX3P1hA/j4lSZlstinjeBFxlepK9nNm/KBS1K+fkVRW6sX6liRII978KAYLae5
	 +Qg4H68CzdYKQqI2ubv7B34FI5TFiuJ263rgCpg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 6.12 729/816] misc: bcm-vk: fix DMA allocation memory leak
Date: Wed, 25 Nov 2026 15:37:57 +0100
Message-ID: <20261125143906.056275579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit a36b3db60466d44eefcc5c252ce927c043429922 upstream.

bcm_vk_dma_alloc() leaks dma->pages and pinned user-page references
when page pinning or coherent SG allocation fails. DMA mapping
failures can also leave the SG list and earlier mappings unreleased,
as bcm_vk_sg_alloc() skips the partially initialized slot.

This issue was found by our static analysis tool under development.

Fixes: 111d746bb476 ("misc: bcm-vk: add VK messaging support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20261027150921.137189-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/bcm-vk/bcm_vk_sg.c |   43 +++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/drivers/misc/bcm-vk/bcm_vk_sg.c
+++ b/drivers/misc/bcm-vk/bcm_vk_sg.c
@@ -80,7 +80,8 @@ static int bcm_vk_dma_alloc(struct devic
 		dma->nr_pages = (err >= 0) ? err : 0;
 		dev_err(dev, "get_user_pages_fast, err=%d [%d]\n",
 			err, dma->nr_pages);
-		return err < 0 ? err : -EINVAL;
+		err = err < 0 ? err : -EINVAL;
+		goto err_pages;
 	}
 
 	/* Max size of sg list is 1 per mapped page + fields at start */
@@ -92,8 +93,10 @@ static int bcm_vk_dma_alloc(struct devic
 					 dma->sglen,
 					 &dma->handle,
 					 GFP_KERNEL);
-	if (!dma->sglist)
-		return -ENOMEM;
+	if (!dma->sglist) {
+		err = -ENOMEM;
+		goto err_pages;
+	}
 
 	dma->sglist[SGLIST_NUM_SG] = 0;
 	dma->sglist[SGLIST_TOTALSIZE] = vkdata->size;
@@ -110,8 +113,8 @@ static int bcm_vk_dma_alloc(struct devic
 			       dma->direction);
 	transfer_size = size;
 	if (unlikely(dma_mapping_error(dev, sg_addr))) {
-		__free_page(dma->pages[0]);
-		return -EIO;
+		err = -EIO;
+		goto err_sglist;
 	}
 
 	for (i = 1; i < dma->nr_pages; i++) {
@@ -123,8 +126,8 @@ static int bcm_vk_dma_alloc(struct devic
 				    size,
 				    dma->direction);
 		if (unlikely(dma_mapping_error(dev, addr))) {
-			__free_page(dma->pages[i]);
-			return -EIO;
+			err = -EIO;
+			goto err_unmap;
 		}
 
 		/*
@@ -169,6 +172,32 @@ static int bcm_vk_dma_alloc(struct devic
 #endif
 
 	return 0;
+
+err_unmap:
+	/*
+	 * Unmap completed SG entries and the in-progress DMA range,
+	 * which has not been written to the SG list yet.
+	 */
+	sgdata = (struct _vk_data *)&dma->sglist[SGLIST_VKDATA_START];
+	for (i = 0; i < dma->sglist[SGLIST_NUM_SG]; i++) {
+		size = sgdata[i].size;
+		addr = get_unaligned(&sgdata[i].address);
+		dma_unmap_page(dev, addr, size, dma->direction);
+	}
+	dma_unmap_page(dev, sg_addr, transfer_size, dma->direction);
+
+err_sglist:
+	dma_free_coherent(dev, dma->sglen, dma->sglist, dma->handle);
+
+err_pages:
+	for (i = 0; i < dma->nr_pages; i++)
+		put_page(dma->pages[i]);
+	kfree(dma->pages);
+	dma->pages = NULL;
+	dma->sglist = NULL;
+	dma->sglen = 0;
+	dma->nr_pages = 0;
+	return err;
 }
 
 int bcm_vk_sg_alloc(struct device *dev,


