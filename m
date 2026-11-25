Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623531;
	b=SrlS2aefgDjfenPN6rJGsWoPfT3OA5dKvU7y+UsjeJ6dV9GJaQw+Rwm9VGXurYPXiYP9
	 ybP+TFAr5x9lTpUG8gIItKUdBTYQOb9LIjTcrxr1kAb+Uer7rUISrE9xVxh1ogdIsKdge
	 KjhDcTL3kXLLAHNN30FD8Fv7VYiBA5IN0yFTXHAP+CPZ5cxCXwjS6K0pu75ZiebwAwtJ/
	 SwsR4DXrpAki7tGk2XK2/qoKgriZAXSSyGZm3KRLrH4kxrlQM6KQhqXJdeRa4bmSZcNjJ
	 7778EUImxDxu13FeGysQEADUTwMdmS/xkBKpGxk03YYvkzCEx4W7cXYLxA58HPkX14Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6G9yEpvArjMjUUGHLruKsndLLL8Egggk7ZHwLzRfBrU=;
	b=zgUjbkzCH9gtDS85R0YzLF7h+oGpB3dEWvxP6i0+vgOmuHSwKHmaZrvTmkdRNS/bZjYJ
	 mr1cuuJK6Tf8oguGibJpmru9YMU6pRFlXDIYxC3NVmY69rVk8J3CShbRDfKBSsva4/uR4
	 FtvTFeARRKhKlRaF5cAJR97bHR2eI0TK8zEzOeujZiEKb33jp+ja11jQOguzgvk9vrHO5
	 Rew7AcqCJM/iWzenrgtHpVo8/TlIdZmIGmiQ8woreGuP5vNcJTgmSFZhbEK0eCC8zvxCp
	 zpAWxbayJIKBMZ9zFulfVkkPwQnpqTln/9s7CXGokcTDEpIp3RwM7K8DlNz3PY4uVng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzUEFwH8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D009606A327;
	Wed, 25 Nov 2026 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzUEFwH8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9913D1F000C4;
	Wed, 25 Nov 2026 16:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623531;
	bh=6G9yEpvArjMjUUGHLruKsndLLL8Egggk7ZHwLzRfBrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzUEFwH8IZoLjMbgrUXs06H4/IYcQsoJu1w0x9f+zB3+wbGh8Wzlw+Ivj9yfwDewB
	 FMk9IOrdOsqLO2x2CrIooU9NFTzqJyeK+JSJBMge3MYDzO0iF+13wiCjcQndieB31k
	 i4FzFPfF6XSBXqHqm4zlNo/xqV/IU98/68le3Qsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 6.18 891/990] misc: bcm-vk: fix DMA allocation memory leak
Date: Wed, 25 Nov 2026 15:37:38 +0100
Message-ID: <20261125143842.882881219@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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


