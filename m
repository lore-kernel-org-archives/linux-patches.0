Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331A334EF04;
	Tue, 16 Dec 2025 11:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886129; cv=none; b=W2SGne0OufCIPTp5Zjt3SphUnl9LUzjRxW0mkvGm8f876nCMd9nXoeI5O2ejXRzbQqZxoqqf5SNvj+/tey38ukLzQyShFZ3Txr0PuxDEFZqnJfdLupceI09NmE05dxXHQLdZBb4HdovBKXr5oYLgJs6JzjeEmrfIyqe0SrXsqJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886129; c=relaxed/simple;
	bh=YqDfpA1WdO1XSY8F2lu5naDYKo/x4eBlzHe6ob+9ScM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkEFT7lU6So7BVG48sozFKjyXB9ISV4fe1wHHXjfaBkDTbYhkr4G4gbu70oBR5Y91z2ViUmdSMYAVIrz2ftuw6+ekYexVlAcqh7cdtSQeNiHmq0Ws8hg74zdsr30sRNS1IAdJWpDSxHSQ9Q+phJmrnLjQAY3NP+VkUZlL6pvmU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsM1kC7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsM1kC7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94400C4CEF1;
	Tue, 16 Dec 2025 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886129;
	bh=YqDfpA1WdO1XSY8F2lu5naDYKo/x4eBlzHe6ob+9ScM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fsM1kC7Ztay6vUQ23XQkS5JM6Ajlx1M9Hux15qyEvySDGcqgDp/JIWWtqvx7F05RP
	 2alBnY4EvvDwErDsS58dcrT90MOn6ga+/YwU/pMpfYpBdrucFXurA0tDodW6nohSW7
	 AQNeMlz49pJYABZamAm0FxQ0BeDWeoEpBOPnA9mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 345/507] drm/nouveau: restrict the flush page to a 32-bit address
Date: Tue, 16 Dec 2025 12:13:06 +0100
Message-ID: <20251216111357.959430014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



