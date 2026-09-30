Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF63D4C651B;
	Wed, 30 Sep 2026 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783379; cv=none; b=K/eYalfTngFjOW2ukJtARt/rWJbO00GnEWfeF+qrL78X+38xFje1ibN7YV2ZpEu2yN97QMhK33s70zR1GEvu2BCHrcIp8Vcu8xvY+b/13oYnWaDq7URdYdsLj4ZiuWzHww65t2drXn670mqKFnKWggPsQJTj7Bx2LqRUz00L0uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783379; c=relaxed/simple;
	bh=wAWm7AlMvcj9tKO9A0RmYCwqX1GkqrL43xNzSAoFBlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3Xxj2/3TGg/mG4j7Z6Uj/Q3cZ7Tef1UQ3VdlBclebRlXjgWx2VeUwZ8qxWUDrkDs0v8q4WFFZj7IX7xJSOrpGXwrGk5ZupBDTkvuuo7n9vo0Q3sNVdZ2ztQnKm+0o2cSde56M2TI3m15+lEmWQtYM+Fo6ZUoLo5TiPyro6Nelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krCvwJtj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krCvwJtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE681F00893;
	Wed, 30 Sep 2026 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783373;
	bh=NnBemjRQ8UBCTrxfer1WEfQsLsCgl6cvnR6BimJNOSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krCvwJtjxfPV040n1Ew6CoRgz+09zzY9Ijes4gfDyXVyZ2hBfwqMwbMyesqk+64B9
	 Z2ix1clGdPv49+hBU37QfUvkvsQGxkTGebvaj9idWpHwCymhemcxdo4/DlGf9jguHJ
	 g0zoYhrP45S77zyZ+9Z/Z5bUcixsQ39/8Xq0VstY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Dillon Min <dillon.minfei@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 376/595] dma-mapping: simplify dma_init_coherent_memory
Date: Wed, 30 Sep 2026 17:24:29 +0200
Message-ID: <20260930152355.765213432@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a6933571f34a9aee843fff2aa4b96949c57d6274 ]

Return the allocated dma_coherent_mem structure, set the
use_dma_pfn_offset and print the failure warning inside of
dma_init_coherent_memory instead of leaving that to the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Dillon Min <dillon.minfei@gmail.com>
Stable-dep-of: 504981db4f69 ("dma-coherent: report a failed reserved memory assignment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/coherent.c | 78 ++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 45 deletions(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 49aaad3936f19..4de9898e98dab 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -37,51 +37,44 @@ static inline dma_addr_t dma_get_device_base(struct device *dev,
 	return mem->device_base;
 }
 
-static int dma_init_coherent_memory(phys_addr_t phys_addr,
-		dma_addr_t device_addr, size_t size,
-		struct dma_coherent_mem **mem)
+static struct dma_coherent_mem *dma_init_coherent_memory(phys_addr_t phys_addr,
+		dma_addr_t device_addr, size_t size, bool use_dma_pfn_offset)
 {
-	struct dma_coherent_mem *dma_mem = NULL;
-	void *mem_base = NULL;
+	struct dma_coherent_mem *dma_mem;
 	int pages = size >> PAGE_SHIFT;
 	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
-	int ret;
+	void *mem_base;
 
-	if (!size) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!size)
+		return ERR_PTR(-EINVAL);
 
 	mem_base = memremap(phys_addr, size, MEMREMAP_WC);
-	if (!mem_base) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (!mem_base)
+		return ERR_PTR(-EINVAL);
+
 	dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dma_mem) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!dma_mem)
+		goto out_unmap_membase;
 	dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dma_mem->bitmap) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!dma_mem->bitmap)
+		goto out_free_dma_mem;
 
 	dma_mem->virt_base = mem_base;
 	dma_mem->device_base = device_addr;
 	dma_mem->pfn_base = PFN_DOWN(phys_addr);
 	dma_mem->size = pages;
+	dma_mem->use_dev_dma_pfn_offset = use_dma_pfn_offset;
 	spin_lock_init(&dma_mem->spinlock);
 
-	*mem = dma_mem;
-	return 0;
+	return dma_mem;
 
-out:
+out_free_dma_mem:
 	kfree(dma_mem);
-	if (mem_base)
-		memunmap(mem_base);
-	return ret;
+out_unmap_membase:
+	memunmap(mem_base);
+	pr_err("Reserved memory: failed to init DMA memory pool at %pa, size %zd MiB\n",
+		&phys_addr, size / SZ_1M);
+	return ERR_PTR(-ENOMEM);
 }
 
 static void _dma_release_coherent_memory(struct dma_coherent_mem *mem)
@@ -130,9 +123,9 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 	struct dma_coherent_mem *mem;
 	int ret;
 
-	ret = dma_init_coherent_memory(phys_addr, device_addr, size, &mem);
-	if (ret)
-		return ret;
+	mem = dma_init_coherent_memory(phys_addr, device_addr, size, false);
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
 
 	ret = dma_assign_coherent_memory(dev, mem);
 	if (ret)
@@ -327,21 +320,16 @@ static struct reserved_mem *dma_reserved_default_memory __initdata;
 
 static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 {
-	struct dma_coherent_mem *mem = rmem->priv;
-	int ret;
-
-	if (!mem) {
-		ret = dma_init_coherent_memory(rmem->base, rmem->base,
-					       rmem->size, &mem);
-		if (ret) {
-			pr_err("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
-				&rmem->base, (unsigned long)rmem->size / SZ_1M);
-			return ret;
-		}
+	if (!rmem->priv) {
+		struct dma_coherent_mem *mem;
+
+		mem = dma_init_coherent_memory(rmem->base, rmem->base,
+					       rmem->size, true);
+		if (IS_ERR(mem))
+			return PTR_ERR(mem);
+		rmem->priv = mem;
 	}
-	mem->use_dev_dma_pfn_offset = true;
-	rmem->priv = mem;
-	dma_assign_coherent_memory(dev, mem);
+	dma_assign_coherent_memory(dev, rmem->priv);
 	return 0;
 }
 
-- 
2.53.0



