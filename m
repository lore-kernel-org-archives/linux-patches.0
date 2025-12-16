Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CF02E54AA;
	Tue, 16 Dec 2025 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884529; cv=none; b=r1vbFp7bQpMRa1i2RWeeJBaef6ld+e/ODU+JxyQW/yE4MhDeaROA0Bn2j0Dyt94eB5k4d3uj3IocubaJBvMK/y/osni1qFAzhlcyC83I1kPsOKK8MLFxbs+FeSKelyZTAqgk42eZ0G9HpWolSGYM6lFGaIb3fU3tJlyPQFnnqwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884529; c=relaxed/simple;
	bh=BQDw6ooMIcBiojwXsq2SbDAu8IbNH5A30SnzJreYfgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V989kv8Ssi3cOctc6BGyfkXPJPXEOf9DmuOTmXYjQ1U27PGtRsRwAVmBNR+k7uSSCTQYyOsIPeYJj++w3/QbGfa6pU9INZmhs78XrxZYz+diY0dpuszVyaK1JHJk0P8kghQzabU6BlFpaAJMJ8Ov/rL3nD44L3R1RuP24wO6D68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCPcBQGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCPcBQGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917FDC4CEF1;
	Tue, 16 Dec 2025 11:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884529;
	bh=BQDw6ooMIcBiojwXsq2SbDAu8IbNH5A30SnzJreYfgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCPcBQGkMaDC3P/oT0+VKsvCWhyJFCCrD0PP6orMTKHOWZgZs1VlFz2zpjdz45HjP
	 F0Ry+nrXzEjbMqO4992aWuzO3+9W1hsn0oDZu25vMj7wjEiMWdIZKOhcYLfSWMswlS
	 ID2n6z/lRabuVsbwvjq0q8Z9MzFV63ZS6GKuwh4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 222/354] drm/nouveau: restrict the flush page to a 32-bit address
Date: Tue, 16 Dec 2025 12:13:09 +0100
Message-ID: <20251216111328.961413497@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



