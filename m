Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17525335561;
	Fri,  9 Jan 2026 11:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959874; cv=none; b=AEKSLz07sA46s46BhAzJPw+PaIQC6ROaZAi5mH1Qy3Wz+mP8U5QnK2tgm66uxz5pr8SJVzahHPn5RAjJ0Bhx/kCGYL4jPT2VO98TIHGqaDa2mR10qOLIBQa4oJicNEkT2it8wWh8LdXP/CeCRfTM+wqhBNj5ZYenVK+0L0HH/NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959874; c=relaxed/simple;
	bh=+fFrH0ige1nlQJNQUxpnE4O2aSiUNT4Mluh40+qCZu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6P8vrCk10AIhIj1eMQawbWeA/Vx5dRdGkZh5Hq74YNb5IOWfZ51nIy2NPc5czvOBkL+LbwVZj6Ur+7EuloIDeNT2rYMqeyRr7BFCzxXki/zR6qYxWUsZZ356PIu0SlqURIjileGMfyxPRt5ybr8+HL7ZxAVLebys4Xdbuc+gdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z8+/Sv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z8+/Sv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86212C4CEF1;
	Fri,  9 Jan 2026 11:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959873;
	bh=+fFrH0ige1nlQJNQUxpnE4O2aSiUNT4Mluh40+qCZu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Z8+/Sv8N4OJ/Yh21VjAcl0I+jKJgq0QUP/c3D0mAzAcZk9wUSNm0+IZdlFyT2LdM
	 jNaWC7yK/5rfoOvGBHZgKQc6AvRPeJMVQ3rsz3DTfAkKxQ5LCtKxbRi6503y4Shu0R
	 7QBfgXZeWsfXPWroifiAdBDnSbvm6991Nsznf0fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 205/737] drm/nouveau: restrict the flush page to a 32-bit address
Date: Fri,  9 Jan 2026 12:35:44 +0100
Message-ID: <20260109112141.712948520@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



