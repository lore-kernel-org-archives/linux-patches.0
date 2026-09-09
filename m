Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C052424D48;
	Wed,  9 Sep 2026 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963119; cv=none; b=JxNY1aWWnGfde3SaZQ1AokwTxF4wOJK7VN7zVP/YjOChwaLfyF6e63ErhX0/6oWKf2q3FoBn+Bhgw1KehsJkd39BEnF4sO10606nIxm0ptQWyCkRbkDP6E5dyvWxiIoyfp0L5wO5nCCOz2y/WB0X2CSK8yrKnkgEh6SVLQf5Dqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963119; c=relaxed/simple;
	bh=12aTR8LlPAacc3ZcKsj1Hsp3699aUl4zbIopRGVGaAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A27wlipgRNQP4LGUpZQsghkx51PC0bKJaPici9UdOtHeAV9HUbgWj9Jm4mch9CR1qyCJAfTJ5FomVEfu2dCT879nvP6I1XVdSOx+UyCKLcXZvzEIifoR3mJF78YE4DJ7U4JB2GUNJIIpKA4WxJFxINjDh8KI/XE1sokrknhFKm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXLFoG02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXLFoG02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F42271F00A3A;
	Wed,  9 Sep 2026 14:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963118;
	bh=sjU/WYsFMVD/gl9torTAit1IUvU8ZWRDD/j0f7Yg+jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZXLFoG02Tr4v5hkKNXFEJ17b8ATdvN4uIxsiTni5oth1daasUp3f2C+6co+O69ii6
	 J1Fc/Gh/d6JtBSZigxll6nNO0IjPRIVjN7REsxvtKL8Z3/63Yp4OgfpvSTC71/45f1
	 mxWkc9x8z0won0Rx3Y628CN2hgS9MTzo8lMFCUqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.2 527/556] drm/nouveau/dmem: fix mismatched DMA unmap size for large folios
Date: Wed,  9 Sep 2026 15:43:27 +0200
Message-ID: <20260909134248.954759479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenhao Wan <whi4ed0g@gmail.com>

commit caa1bc2a0a6ca19dcb90bbf88208b0fe2decd66f upstream.

Device-private THP migration maps migration buffers with page_size()
and records that length in dma_info->size.  For a compound folio
page_size() is PAGE_SIZE << order, but two teardown sites still pass a
literal PAGE_SIZE to dma_unmap_page():

  - nouveau_dmem_migrate_to_ram() on the success path, and
  - nouveau_dmem_migrate_copy_one() on the copy-error path.

For an order > 0 folio this unmaps less than was mapped, leaking the
remainder of the IOMMU/IOVA mapping.  The other unmap sites, in
nouveau_dmem_migrate_chunk() and nouveau_dmem_evict_chunk(), already
use the saved size; use it here too.

Fixes: c32287471077 ("gpu/drm/nouveau: enable THP support for GPU memory migration")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Link: https://patch.msgid.link/20260811-b4-nouveau-dmem-thp-fixes-v1-1-2cdf9860af2a@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -267,7 +267,7 @@ static vm_fault_t nouveau_dmem_migrate_t
 	nouveau_fence_new(&fence, dmem->migrate.chan);
 	migrate_vma_pages(&args);
 	nouveau_dmem_fence_done(&fence);
-	dma_unmap_page(drm->dev->dev, dma_info.dma_addr, PAGE_SIZE,
+	dma_unmap_page(drm->dev->dev, dma_info.dma_addr, dma_info.size,
 				DMA_BIDIRECTIONAL);
 done:
 	migrate_vma_finalize(&args);
@@ -786,7 +786,7 @@ static unsigned long nouveau_dmem_migrat
 	return mpfn;
 
 out_dma_unmap:
-	dma_unmap_page(dev, dma_info->dma_addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
+	dma_unmap_page(dev, dma_info->dma_addr, dma_info->size, DMA_BIDIRECTIONAL);
 out_free_page:
 	nouveau_dmem_page_free_locked(drm, dpage);
 out:


