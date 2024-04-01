Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61D617FD;
	Mon,  1 Apr 2024 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989036; cv=none; b=KP8t+095f00ydz1SfBtHYbH0ohlG0dcXDWwrn9HxouWrUPe1WDhhFwvjA+prSjM5bDVCl2bgH3dMXMAEAXJ/sQ/6rbKLsQv7dy6C/749wTFRm1IBj0ZYagOS1ZK0WaGKArdqHoetRfgmwyn4H2rEHJxKSpPA0V8hB5AKSshpT+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989036; c=relaxed/simple;
	bh=n2qds4O40oHzcUalaZX9l0XpWIprhE0jPZtx5Rlp3MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNonqt9FaKL/l8u8zfZjucJ1LZJccxfGYnrzDAvxV571bNdbF61IVx2Gzn5AFy0khvvsoDYBcC6ZkOXn0ABBDSo8N2belpmumEn/5KGPbBthcklwTu51Hxlph/FBkAOF7q/6fG0+WORYX0KRdE2tIu6YWbFNBnSbs7aQk/aQVwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sjr7q6a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sjr7q6a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F5C433F1;
	Mon,  1 Apr 2024 16:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989036;
	bh=n2qds4O40oHzcUalaZX9l0XpWIprhE0jPZtx5Rlp3MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sjr7q6a/cgG0zXozMkoZqTr/2/4Y6cxWcgv+gsCTC14j+HQJkBwnF8HOaMmJR6XJy
	 bq1EpH4s6fkWEKymyhP9z8ys4nI2q3G7ON415kSQvuBymf7kSZCQjD8E3SXa3Ya9S4
	 IEau5gh3qerlE9g//+uPArGf/eh4BbcJ9SMK8qsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.7 363/432] nouveau/dmem: handle kcalloc() allocation failure
Date: Mon,  1 Apr 2024 17:45:50 +0200
Message-ID: <20240401152604.094147780@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

commit 16e87fe23d4af6df920406494ced5c0f4354567b upstream.

The kcalloc() in nouveau_dmem_evict_chunk() will return null if
the physical memory has run out. As a result, if we dereference
src_pfns, dst_pfns or dma_addrs, the null pointer dereference bugs
will happen.

Moreover, the GPU is going away. If the kcalloc() fails, we could not
evict all pages mapping a chunk. So this patch adds a __GFP_NOFAIL
flag in kcalloc().

Finally, as there is no need to have physically contiguous memory,
this patch switches kcalloc() to kvcalloc() in order to avoid
failing allocations.

CC: <stable@vger.kernel.org> # v6.1
Fixes: 249881232e14 ("nouveau/dmem: evict device private memory during release")
Suggested-by: Danilo Krummrich <dakr@redhat.com>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240306050104.11259-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -378,9 +378,9 @@ nouveau_dmem_evict_chunk(struct nouveau_
 	dma_addr_t *dma_addrs;
 	struct nouveau_fence *fence;
 
-	src_pfns = kcalloc(npages, sizeof(*src_pfns), GFP_KERNEL);
-	dst_pfns = kcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL);
-	dma_addrs = kcalloc(npages, sizeof(*dma_addrs), GFP_KERNEL);
+	src_pfns = kvcalloc(npages, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(npages, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dma_addrs = kvcalloc(npages, sizeof(*dma_addrs), GFP_KERNEL | __GFP_NOFAIL);
 
 	migrate_device_range(src_pfns, chunk->pagemap.range.start >> PAGE_SHIFT,
 			npages);
@@ -406,11 +406,11 @@ nouveau_dmem_evict_chunk(struct nouveau_
 	migrate_device_pages(src_pfns, dst_pfns, npages);
 	nouveau_dmem_fence_done(&fence);
 	migrate_device_finalize(src_pfns, dst_pfns, npages);
-	kfree(src_pfns);
-	kfree(dst_pfns);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 	for (i = 0; i < npages; i++)
 		dma_unmap_page(chunk->drm->dev->dev, dma_addrs[i], PAGE_SIZE, DMA_BIDIRECTIONAL);
-	kfree(dma_addrs);
+	kvfree(dma_addrs);
 }
 
 void


