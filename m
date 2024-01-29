Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31B515EAA8;
	Mon, 29 Jan 2024 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548251; cv=none; b=rH1tZXwZAmsGk61XINEFDvStXKou2RYhszlMY7J8ooc9hdY8AdZZTVm9R+ClosgocYXDcdLKjuj2LqIXf1Px5AJqNW/mYDx2OyPMlU5IQYQJWSfi0Jc6pk7kei/Y4/mubsTuDVG/zQaXq0vKIzrSqUr2Nf5csVeNSKn9ci57XGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548251; c=relaxed/simple;
	bh=cx+dagJoZRg8+XjNj85yh+Z9BjmXY6TRQPT6bMUrv2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sr8t6GKoQ9aVLGams8lX7K9knqgAGknWtNgS2EeWMzWjcmz1uLlZtj+9nVNVHDopK0xrCwKpUYFNb9SVJiBqjuoZK6H30TREoqkzSBScMr9NWVWIrdBiIQcX+9Z57vcoFpyZqjKLkoyJ8ncZoSLjogl/dEYuYW6QN7mpJl4fHPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0ZYrqbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0ZYrqbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF26C433F1;
	Mon, 29 Jan 2024 17:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548251;
	bh=cx+dagJoZRg8+XjNj85yh+Z9BjmXY6TRQPT6bMUrv2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0ZYrqbSEOJUpnG41em5bBdqY6pvh+UP16zXMHsw0zad5VFVDbmW9EiLuUg0WuKGS
	 ESimit1idvZstsHAJe3O1vYQOw4xpIgPjNzlzP89NHkWiWUPj1BGioULesR5NLN0AL
	 YmhvJYbrg9CUPe8AH+YGld+qTFw0ZzEmZ1cD9jkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom St Denis <tom.stdenis@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 273/346] drm/amd/amdgpu: Assign GART pages to AMD device mapping
Date: Mon, 29 Jan 2024 09:05:04 -0800
Message-ID: <20240129170024.409055947@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom St Denis <tom.stdenis@amd.com>

commit e7a8594cc2af920a905db15653c19c362d4ebd3f upstream.

This allows kernel mapped pages like the PDB and PTB to be
read via the iomem debugfs when there is no vram in the system.

Signed-off-by: Tom St Denis <tom.stdenis@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.7.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gart.c
@@ -121,6 +121,7 @@ int amdgpu_gart_table_ram_alloc(struct a
 	struct amdgpu_bo_param bp;
 	dma_addr_t dma_addr;
 	struct page *p;
+	unsigned long x;
 	int ret;
 
 	if (adev->gart.bo != NULL)
@@ -130,6 +131,10 @@ int amdgpu_gart_table_ram_alloc(struct a
 	if (!p)
 		return -ENOMEM;
 
+	/* assign pages to this device */
+	for (x = 0; x < (1UL << order); x++)
+		p[x].mapping = adev->mman.bdev.dev_mapping;
+
 	/* If the hardware does not support UTCL2 snooping of the CPU caches
 	 * then set_memory_wc() could be used as a workaround to mark the pages
 	 * as write combine memory.
@@ -223,6 +228,7 @@ void amdgpu_gart_table_ram_free(struct a
 	unsigned int order = get_order(adev->gart.table_size);
 	struct sg_table *sg = adev->gart.bo->tbo.sg;
 	struct page *p;
+	unsigned long x;
 	int ret;
 
 	ret = amdgpu_bo_reserve(adev->gart.bo, false);
@@ -234,6 +240,8 @@ void amdgpu_gart_table_ram_free(struct a
 	sg_free_table(sg);
 	kfree(sg);
 	p = virt_to_page(adev->gart.ptr);
+	for (x = 0; x < (1UL << order); x++)
+		p[x].mapping = NULL;
 	__free_pages(p, order);
 
 	adev->gart.ptr = NULL;


