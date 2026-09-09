Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D570857981F;
	Wed,  9 Sep 2026 14:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964487; cv=none; b=hNwrs9yI1eGPlDeYoh/twXuICklIcmJ5eBxdPIoHWpMZh/jI/6ksA8ZHWooGaKQI7X3dvPJIbqX+uBAQnJOOYAUjENvXNxNWg2kbQ4gLFpAMoeXzxMJyiuFZJSFjKus232fFEgMiQzh+q2tYnonJvxRX81BNozrBwnnX5dCK9Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964487; c=relaxed/simple;
	bh=w0NCivkSP17NI+0lm6F8DjpjZ8bbKLbQfWSg9U9QqOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZa8Ws5YV9myYsbL35XmCL+Dn11nmzXn6ag8gmhDgq3p/Dzn4PK9NqH06MO8TzJ4YQJG3QOAMj4cYebslcQl73sWNAE60f5utCkwalwk1pd8rnED6eukbOik3PX0KxpeHEmPLUk6/i/FJ1MCcIZkj2QmNFNoggtETnJoaZ8fvmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRtXzMWo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRtXzMWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE771F00A3A;
	Wed,  9 Sep 2026 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964485;
	bh=i1ZlVZ5gHVuUBugqIGAS6GKoP7fWLDk+DCFhj/fGPH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRtXzMWo75B/z7BIwJFuDI95+P9cFYUMmss/MPBrv9WYbVQ27y/poUUDf1/BDIzT2
	 9T6iZF5kctMYWc7h3W+36w92MqEDmrEo7d2m8/Ydmf8BvuWqPOAEDWp0383ugnYEj5
	 ITIJfxy7DIzOZhI+u05CoUwsmYwI6PBJzGaSCQY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 401/583] drm/amdkfd: Fix the case that vm range is hole at svm_migrate_copy_to_vram
Date: Wed,  9 Sep 2026 15:41:26 +0200
Message-ID: <20260909134251.900821074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Xiaogang Chen <xiaogang.chen@amd.com>

commit 520e345ffe05aabef1db82beda4288afb1757ff2 upstream.

When migration vm range is hole at cpu side(MIGRATE_PFN_MIGRATE set +
MIGRATE_PFN_VALID unset) driver still allocates device pages. There is no
dma map of src pages and migration. j is 0 and svm_migrate_copy_memory_gart()
will return an uninitialized r. That can trigger out_free_vram_pages to drop
all VRAM just set up.

Initialize r and only call the last svm_migrate_copy_memory_gart if j > 0.

Current code postponed the last page to the final copy. This patch flushes on
the last page when reach to the end of current drm_buddy_block; avoids another
svm_migrate_copy_memory_gart.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -132,7 +132,7 @@ svm_migrate_copy_memory_gart(struct amdg
 	u64 gart_s, gart_d;
 	struct dma_fence *next;
 	u64 size;
-	int r;
+	int r = 0;
 
 	mutex_lock(&adev->mman.gtt_window_lock);
 
@@ -278,7 +278,7 @@ svm_migrate_copy_to_vram(struct kfd_node
 	dma_addr_t *src;
 	u64 *dst;
 	u64 i, j;
-	int r;
+	int r = 0;
 
 	pr_debug("svms 0x%p [0x%lx 0x%lx 0x%llx]\n", prange->svms, prange->start,
 		 prange->last, ttm_res_offset);
@@ -304,6 +304,7 @@ svm_migrate_copy_to_vram(struct kfd_node
 					      DMA_BIDIRECTIONAL);
 			r = dma_mapping_error(dev, src[i]);
 			if (r) {
+				src[i] = 0;
 				dev_err(dev, "%s: fail %d dma_map_page\n",
 					__func__, r);
 				goto out_free_vram_pages;
@@ -328,7 +329,8 @@ svm_migrate_copy_to_vram(struct kfd_node
 		pr_debug_ratelimited("dma mapping src to 0x%llx, pfn 0x%lx\n",
 				     src[i] >> PAGE_SHIFT, page_to_pfn(spage));
 
-		if (j >= (cursor.size >> PAGE_SHIFT) - 1 && i < npages - 1) {
+		/* accumulated j + 1 pages reach end of current drm_buddy_block */
+		if (j + 1 >= (cursor.size >> PAGE_SHIFT)) {
 			r = svm_migrate_copy_memory_gart(adev, src + i - j,
 							 dst + i - j, j + 1,
 							 FROM_RAM_TO_VRAM,
@@ -342,7 +344,8 @@ svm_migrate_copy_to_vram(struct kfd_node
 		}
 	}
 
-	r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
+	if (j > 0)
+		r = svm_migrate_copy_memory_gart(adev, src + i - j, dst + i - j, j,
 					 FROM_RAM_TO_VRAM, mfence);
 
 out_free_vram_pages:


