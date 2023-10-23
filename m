Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DF014282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9DGv95m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DDEC433C9;
	Mon, 23 Oct 2023 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060034;
	bh=+8ki+DfsJGA3wLSsWmw4J1R/Hr45r3PAG8t71nBydd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9DGv95mI8oIG1k0E+QBCaXfZ5m5/sajOz2dpvQts/ZtzpBx3lGN3LE07CBELheQd
	 OiT/0NbObeje1sk3fWksFN90zutljWyYP/D7qML3fP8kOUV9yieWUd7by2bqNxKCiW
	 8j3rntvN9AiIUOzL+lIIsoywIIDwqtG3rSVkwiYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.1 037/196] drm/mediatek: Correctly free sg_table in gem prime vmap
Date: Mon, 23 Oct 2023 12:55:02 +0200
Message-ID: <20231023104829.537787135@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit dcc583c225e659d5da34b4ad83914fd6b51e3dbf upstream.

The MediaTek DRM driver implements GEM PRIME vmap by fetching the
sg_table for the object, iterating through the pages, and then
vmapping them. In essence, unlike the GEM DMA helpers which vmap
when the object is first created or imported, the MediaTek version
does it on request.

Unfortunately, the code never correctly frees the sg_table contents.
This results in a kernel memory leak. On a Hayato device with a text
console on the internal display, this results in the system running
out of memory in a few days from all the console screen cursor updates.

Add sg_free_table() to correctly free the contents of the sg_table. This
was missing despite explicitly required by mtk_gem_prime_get_sg_table().

Also move the "out" shortcut label to after the kfree() call for the
sg_table. Having sg_free_table() together with kfree() makes more sense.
The shortcut is only used when the object already has a kernel address,
in which case the pointer is NULL and kfree() does nothing. Hence this
change causes no functional change.

Fixes: 3df64d7b0a4f ("drm/mediatek: Implement gem prime vmap/vunmap function")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231004083226.1940055-1-wenst@chromium.org/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_gem.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -234,6 +234,7 @@ int mtk_drm_gem_prime_vmap(struct drm_ge
 	npages = obj->size >> PAGE_SHIFT;
 	mtk_gem->pages = kcalloc(npages, sizeof(*mtk_gem->pages), GFP_KERNEL);
 	if (!mtk_gem->pages) {
+		sg_free_table(sgt);
 		kfree(sgt);
 		return -ENOMEM;
 	}
@@ -243,12 +244,15 @@ int mtk_drm_gem_prime_vmap(struct drm_ge
 	mtk_gem->kvaddr = vmap(mtk_gem->pages, npages, VM_MAP,
 			       pgprot_writecombine(PAGE_KERNEL));
 	if (!mtk_gem->kvaddr) {
+		sg_free_table(sgt);
 		kfree(sgt);
 		kfree(mtk_gem->pages);
 		return -ENOMEM;
 	}
-out:
+	sg_free_table(sgt);
 	kfree(sgt);
+
+out:
 	iosys_map_set_vaddr(map, mtk_gem->kvaddr);
 
 	return 0;


