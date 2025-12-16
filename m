Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4982F36D51F;
	Tue, 16 Dec 2025 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888042; cv=none; b=X+IyERpJsbE0VprX4bwCYuEjH6sdMFGKzphTWjIALcla9szgH6AU0DzRC8OptmGZlXOsrdVQam8MR5/xU63zu9tN9ky/oc3eUgc66PWukKf2Uyu7B8JZRhuJm0DJ5Pnz+8nk27EgsNgFJsDeSOuD253x2qmZzLtLiBXdXsabnV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888042; c=relaxed/simple;
	bh=KtbqM5YfbvRzUGDVUELM0Tc+plfskDUwTFWgP0eWZPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOIs5mrmxWymuLUsqDXjIUY2acslic3oaYy63ppdq6D9lXdwOoePll2hKJUpwquPlkGur8Ygq1nbDR+NiL8x96w9LqPzCfZpHcxFlaqiFr1ButA/egTDEx5zjgyVL050ch7GHAjdgEKoLMo8fNQoydlfIG+/i1Mcs9Ye8y1pSpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUBRhFJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUBRhFJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B2FC16AAE;
	Tue, 16 Dec 2025 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888042;
	bh=KtbqM5YfbvRzUGDVUELM0Tc+plfskDUwTFWgP0eWZPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUBRhFJGzx8q2Nk8DPleP9MDlv5716hPViLvVT2fXt0qI/f1oKFIsjLPasPkFCRlh
	 7dsemr5W/w/xD7H8JK/uVLdx1SMn+8b/lOeGiNEw4M4/ec59xVGdfdI3mWzodfSUJ3
	 7j4hwzR9Iq2CkLDDImXdxZ3bidkCY6cTtwisQ7I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 413/614] drm/nouveau: restrict the flush page to a 32-bit address
Date: Tue, 16 Dec 2025 12:13:00 +0100
Message-ID: <20251216111416.335001189@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 04d98b3452331fa53ec3b698b66273af6ef73288 ]

The flush page DMA address is stored in a special register that is not
associated with the GPU's standard DMA range.  For example, on Turing,
the GPU's MMU can handle 47-bit addresses, but the flush page address
register is limited to 40 bits.

At the point during device initialization when the flush page is
allocated, the DMA mask is still at its default of 32 bits.  So even
though it's unlikely that the flush page could exist above a 40-bit
address, the dma_map_page() call could fail, e.g. if IOMMU is disabled
and the address is above 32 bits.  The simplest way to achieve all
constraints is to allocate the page in the DMA32 zone.  Since the flush
page is literally just a page, this is an acceptable limitation.  The
alternative is to temporarily set the DMA mask to 40 (or 52 for Hopper
and later) bits, but that could have unforseen side effects.

In situations where the flush page is allocated above 32 bits and IOMMU
is disabled, you will get an error like this:

nouveau 0000:65:00.0: DMA addr 0x0000000107c56000+4096 overflow (mask ffffffff, bus limit 0).

Fixes: 5728d064190e ("drm/nouveau/fb: handle sysmem flush page from common code")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20251113230323.1271726-1-ttabi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
index 8a286a9349ac6..7ce1b65e2c1c2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/base.c
@@ -279,7 +279,7 @@ nvkm_fb_ctor(const struct nvkm_fb_func *func, struct nvkm_device *device,
 	mutex_init(&fb->tags.mutex);
 
 	if (func->sysmem.flush_page_init) {
-		fb->sysmem.flush_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		fb->sysmem.flush_page = alloc_page(GFP_KERNEL | GFP_DMA32 | __GFP_ZERO);
 		if (!fb->sysmem.flush_page)
 			return -ENOMEM;
 
-- 
2.51.0



