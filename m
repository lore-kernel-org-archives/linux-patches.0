Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705641;
	b=Kidj8UdD/SqqaN6jyWdHl3kBVf/vacWCnTKmx3OltOlegzmTbis7Zg6dBlCFRJRXkX04
	 f6PVW1oPMBCao+LEWDrJ/Nz5Nr7G/HgoyMekibOXhE8UT6Iuc6WWUOhm2fPn5igF0O3oB
	 d67HGN3rlLn7XsoL3Ajvoox4A/kfVQQo8h2ToxEwvnH0IIbouznpcIZDlNbsfYA0Bvd+X
	 4rWwQUGdTmRAdeWEt+0o/ubypSxOwcqybH20skgnUNVGXBuhhXnfqdW+yz3n9SxOdsBKS
	 NtWyKYNSYPs2b8f2BtlvbLc4sOebeKuFoD5+Y9WW9hIVA3Nf5kX2TrmQR3yjvTwx5Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bjQ9FcaZdnZczgG/mem+VGQLu3uEp1qOGa0zvZPvy6Y=;
	b=kS2jGRZmlbUfn0orX1k+M+mnslXPPaRwM/ViFfkOgkMUNEQ7pEhSD4n7TGHV5kPYtHln
	 7lqWNp4YEQgjO56LiyW3ULH3t/KoqIzdLyWhvYeCQrp4ueJwX2yuvoKhHUP+8bwaFcxjo
	 QZ6ahZzXq5EtyuwzlWp+TIcnyFQ5Evf/yjDZc7CUaqFuoxvEL4TUQv1XW1mrikK/ZOtoA
	 Kwqav6teaLdkXl4BOTaeRjOKzOyfc+gQAq/vjWixvxBGutYhlQAeBraEqksjg3dpeXnlY
	 jHtAV+sVkVmu7YrEOW+Y59bfA1vstu1VOFFFNGd3YGsvtZQ2X20yvQ+TjjBbqzyhGGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqg4JZxr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFFD606A32C;
	Thu, 26 Nov 2026 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sqg4JZxr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E94C1F000C0;
	Thu, 26 Nov 2026 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705640;
	bh=bjQ9FcaZdnZczgG/mem+VGQLu3uEp1qOGa0zvZPvy6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sqg4JZxrbVM5oy6b7BMDbeY6206bifyj9TkvYqFhozJtTTN1dTWbnutl8u234YBw8
	 0AphlX6cq5NLrwxvF7aNm3oCcTQ7gb5eKf6GOlJroVKTsH2V9JYcBlUl3WUuKC2muv
	 CUVIS00JpwVAOLrXcJAFvpVuLdlzquhGQ1VN0Ekg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 5.15 264/319] misc: bcm-vk: fix DMA allocation memory leak
Date: Thu, 26 Nov 2026 15:40:32 +0100
Message-ID: <20261126144012.706921277@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


