Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99052482DF;
	Mon,  1 Apr 2024 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991300; cv=none; b=oMvj4d6LhQAH4VnjtzJySDzAyfHuilOtOKRik89WdaMc8/g7OZyWMVPT8W6dD8/0fglN6KuZAcFMx5j+zZ6KAT1p7TTi/+fC1WmjKpuBloj+hYpZ7/7FCzB8INxVEWwcczv2oIYTQni6JlxyWRHEFE+DUpokxbzLGja2fqZwyLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991300; c=relaxed/simple;
	bh=4N45lYZ1CcBqWV+5xmjwen8sHCAg8InNyfj7EPdgX+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7r0VKO4tMGK5uXEQxDDY6ixqE3WfaAPhyGsANSVs9WYfex7kFlRROGwbyBsGD8Y0GBcgyzPwlS47G5qgF6MwXxuW/mc5WaWmpn7p3gRWXvaNVBJedOjShRP3KRHJY6mS+rbhftU/T4ExnHE8XUeBgikNb5FfIKAX1n1ddUZ/B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGcHnpqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGcHnpqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB87C433F1;
	Mon,  1 Apr 2024 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991300;
	bh=4N45lYZ1CcBqWV+5xmjwen8sHCAg8InNyfj7EPdgX+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGcHnpqGIwGILh+h+zK20Ju2ZM8YJhS8FJ0ximeeP6y9L4vtFeThsB3QVF3wve0n6
	 JNZ5j7qsbdQexkxstxletN9t83kTm15/PWBcvIUgusEzLhhVfmG7qheKFpQVQTBJ6Q
	 0VRzuIu9BQbKOnw3d/CGsM6+qtvz4oX8c48xE82I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.1 224/272] nouveau/dmem: handle kcalloc() allocation failure
Date: Mon,  1 Apr 2024 17:46:54 +0200
Message-ID: <20240401152537.940571424@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -379,9 +379,9 @@ nouveau_dmem_evict_chunk(struct nouveau_
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
@@ -407,11 +407,11 @@ nouveau_dmem_evict_chunk(struct nouveau_
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


