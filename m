Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620384;
	b=lvPJqLEuZqqdgllBBT5jFjTG17eQFPPBOCoIAl1xA6phG0gaegAebi+rThornRK3wGFv
	 asiDusI5C8dM7GhpSbFnLAhc/H3M1rt/LWMUwEA+5uoorTwNxeZNxLpoWH7bVpTd7o8lH
	 NPYESR2dqqDlmDQr19LpV5UFLCVbFXUiioXmleEIfF4WQA56N5reWim+sVb28xV0lzkTk
	 fCVqGMyvZZZRPQcOnVrUr1pjXPO0iFCEjswX9mINGM7PZSI8zo0ElXUusQD2xhiVVFIcC
	 ZaZKTzbFEWhgMX2TkoMz9vZzDVd2FKy0aUPXv36/M30vV/XMSg4QLtoF00C+PMt1PWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S3qpmuj9tBTXK6vo9KAR9v5Y7fnuKqdQtz44SBaVGFw=;
	b=JGicGs9i3IKjiMjS0LQWtkrsgpyaN0xv/2XzCcCHt46hAZTn1tHxrtBpRbSjkDxWy+m2
	 KqMnVgY+6nPn7ImfQaH9OfoefHQqEYdBR9WvrfcSTV5EiEhXEc3GZXe4PtPdOakgtM5II
	 nAGLTq3RqY9ASmOAiwdHVL8vBXo1sd1RoWkRGyVukpqYBBNSPHv/AKT/IxtnuFmO4+o0B
	 ynXoQAufQQ/YCmuyrwl3calb/bY9gIllXsbv+CCiGdZ2xuvGJvO1oBHN/Cb/65sYfGHew
	 NzOn3g05laqWSCLRZH+1czmYMrNZjGRFJs7qDvEQLpSBUj/ZEklL50ufeqrOmW/lxzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUXUUTEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD8D606A321;
	Wed, 25 Nov 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GUXUUTEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A55C1F000C4;
	Wed, 25 Nov 2026 15:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620384;
	bh=S3qpmuj9tBTXK6vo9KAR9v5Y7fnuKqdQtz44SBaVGFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUXUUTEzC3PyqT8izvFkVW6358ROXzJun39RIaLQsvYHlx/lyh/5fcYn4H7K801xT
	 dxUHPBuvx4B528aZvAvXEuR+BvHAjUG8CPYv+RWF4l8xb+RrG+OYat/WbnSTtkiwu/
	 ye4pQQxH00ZY+HXotTmUbTVSMFEzz8OLom7K+0D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 7.3 0900/1005] misc: bcm-vk: fix DMA allocation memory leak
Date: Wed, 25 Nov 2026 15:37:18 +0100
Message-ID: <20261125143842.774975153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -78,7 +78,8 @@ static int bcm_vk_dma_alloc(struct devic
 		dma->nr_pages = (err >= 0) ? err : 0;
 		dev_err(dev, "get_user_pages_fast, err=%d [%d]\n",
 			err, dma->nr_pages);
-		return err < 0 ? err : -EINVAL;
+		err = err < 0 ? err : -EINVAL;
+		goto err_pages;
 	}
 
 	/* Max size of sg list is 1 per mapped page + fields at start */
@@ -90,8 +91,10 @@ static int bcm_vk_dma_alloc(struct devic
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
@@ -108,8 +111,8 @@ static int bcm_vk_dma_alloc(struct devic
 			       dma->direction);
 	transfer_size = size;
 	if (unlikely(dma_mapping_error(dev, sg_addr))) {
-		__free_page(dma->pages[0]);
-		return -EIO;
+		err = -EIO;
+		goto err_sglist;
 	}
 
 	for (i = 1; i < dma->nr_pages; i++) {
@@ -121,8 +124,8 @@ static int bcm_vk_dma_alloc(struct devic
 				    size,
 				    dma->direction);
 		if (unlikely(dma_mapping_error(dev, addr))) {
-			__free_page(dma->pages[i]);
-			return -EIO;
+			err = -EIO;
+			goto err_unmap;
 		}
 
 		/*
@@ -167,6 +170,32 @@ static int bcm_vk_dma_alloc(struct devic
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


