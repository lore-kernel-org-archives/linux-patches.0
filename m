Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC9F2BF3CF;
	Wed, 23 Apr 2025 15:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422522; cv=none; b=uj8QixD7eWlMn9zOmfHMAO1jQaG5fgriMdzgNTlZztE0geLpFD2AoTYWHhlETgIImFV1gNsJACRWxeM2nPXpQZ3f3aEamTqJkhCxQPzwEJFiqzc4y/UlNwviZQD7D8cmvUUViFi2lMTVbeGraay8JPNX3jFGxeyMLXSr5dyUuZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422522; c=relaxed/simple;
	bh=3EYnCP5RtwtEli1FECfEimCTXzYm+R8awyzjPQgqzvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q7Uc4UIbvT/2szUMkFvWxo9FOpRMAC2ZWkL1e1b1SlL1Qgzz+65na9fUJtlIBFQ3HQtBOqWEfQnpML5fzkoamK8lORnF7/Rzw9xbAj7K5IGBLfZPXkU1AdFoXNXNI6H08ai82JOLxo0fLzKJdZBSTexe6wRNss2ecHEMuZ7977E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTxQsBDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTxQsBDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DD4C4CEE8;
	Wed, 23 Apr 2025 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422522;
	bh=3EYnCP5RtwtEli1FECfEimCTXzYm+R8awyzjPQgqzvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTxQsBDvtiQGjx+Vh8TEk67vMjurNxNLLwhJQqD+JQZIIFkJYIpHDESDFY+m5ivkB
	 uryM+HUmjEUN9ZvhZSKkLOjzF9n4lNWxH6ysT8R4Uj2Vm3PomsArTOPCm8VyaUrsss
	 N6029XuvpDEYBceS5jectCQGgV2nS1I5OXWZwPJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 355/393] drm/amdgpu/dma_buf: fix page_link check
Date: Wed, 23 Apr 2025 16:44:11 +0200
Message-ID: <20250423142658.000897554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -211,7 +211,7 @@ static void amdgpu_dma_buf_unmap(struct
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
-	if (sgt->sgl->page_link) {
+	if (sg_page(sgt->sgl)) {
 		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);


