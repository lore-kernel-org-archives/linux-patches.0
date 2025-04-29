Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC60242D73;
	Tue, 29 Apr 2025 17:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949129; cv=none; b=U8xIo7PDheDSxe9NFQfYMxBEssnArEZMdHnveKZlqEvnDSOYfhXw/HG2GTY1boOaleYahJnzPRJwkbY7xnwmt/xoeXz+qbqYM89Vbn4fEIxRW4FAsV38KGoGdwXhZ9m5fCJcsi6nB8d+06ofFf7BCliqUwGmBXtS/7n08mCp77U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949129; c=relaxed/simple;
	bh=x8UL9Fx91CSyn/hVtA7O0R8Z/lZU4Y2oR7lWcsCA11s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4SJBvbmDT5qBIxH/4w4lhyQwo/khB/GRbHXHF+UP9zzrh6illUuT13+u/BUw46A6uU4Oe6/SC2mCvL3aTykFKdp80V6pepJWda7bLKFZ4YSzy5MW3wpH4aTZVzPL3wS3x4Tcvcy1dSv1wBUFYFDzUZ+3FHsT29c4Eqe6H7Go1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAsFfYPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAsFfYPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1422C4CEE3;
	Tue, 29 Apr 2025 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949129;
	bh=x8UL9Fx91CSyn/hVtA7O0R8Z/lZU4Y2oR7lWcsCA11s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAsFfYPSKIE62IsUxYz7ZkgFloT2tMIpk+FTWMziePcALHd0WJS/9IL6f70VW2lEb
	 8JhXgPabARpfGYhuhgpMQAC2UkwoECJqY+NDx3bAZOV7vNBEQqYq3FZ4ORUPUzlyHi
	 3p8xB03aRNoQGs/f/vuaqg/v1R84oRGceBrXl3dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 183/373] drm/amdgpu/dma_buf: fix page_link check
Date: Tue, 29 Apr 2025 18:41:00 +0200
Message-ID: <20250429161130.688822528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit c0dd8a9253fadfb8e5357217d085f1989da4ef0a upstream.

The page_link lower bits of the first sg could contain something like
SG_END, if we are mapping a single VRAM page or contiguous blob which
fits into one sg entry. Rather pull out the struct page, and use that in
our check to know if we mapped struct pages vs VRAM.

Fixes: f44ffd677fb3 ("drm/amdgpu: add support for exporting VRAM using DMA-buf v3")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -225,7 +225,7 @@ static void amdgpu_dma_buf_unmap(struct
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
-	if (sgt->sgl->page_link) {
+	if (sg_page(sgt->sgl)) {
 		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);


