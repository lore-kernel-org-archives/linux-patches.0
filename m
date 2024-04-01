Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86F263E;
	Mon,  1 Apr 2024 16:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990480; cv=none; b=IVIpD98YDK/0d2ne4zBqP3oQ24jouxmRNQ7mMVfbHEuq2Q4PNpf+iswtlBigT0MpGqJuKahI+uvfHbnKNjLGC3MvfqT/C8XgywL8N5O0ssQExiC/8Hqr0TQIb7OM0orTg3lFZozK5lMX49XN79MB67ceRtqmJgSANmzpd7uBfHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990480; c=relaxed/simple;
	bh=B2cpJnooL38kJcI245iDpG4ZePx5VvZYisg71wlNK5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHAJ/QUoRPvbEAHHHPBmN1khSXvD5SlsscTxQNfEsjtZYSfT4UKAJo0gZXGQrfow3sMsbUHP0ACCsgsI805FQeG+awo4RrNRuWS3Zrd8z573GYOc54mpuHOOGpVzPrQ5WgjQ/anV5JSFPDzoXXvjioWvPjRixoCQlAuvN0UPCuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3OHCMpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3OHCMpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EFEC433F1;
	Mon,  1 Apr 2024 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990480;
	bh=B2cpJnooL38kJcI245iDpG4ZePx5VvZYisg71wlNK5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3OHCMpYVQUHjkA408+bWpRmD++sWX7pMlJuNASQGzG4V91+SrgTrbArSuIAMErUD
	 cIKzofw9r41gtIrWcsNwO9U2UBSGL0viRufAqSbfy+IipdhX53k6LjAgkSbzf43VLu
	 HyJo11DXADZahC0SumvqnTU2pHB45cbqlbvFCQUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>,
	Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 6.6 337/396] nouveau/dmem: handle kcalloc() allocation failure
Date: Mon,  1 Apr 2024 17:46:26 +0200
Message-ID: <20240401152557.959659348@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


