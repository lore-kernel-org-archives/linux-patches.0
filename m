Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE8028D822;
	Wed, 23 Apr 2025 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421047; cv=none; b=iEDJR2CoUtrIuYhvtN1SSUVULv42NJ34AesiBfc81oIEM7FJ62keWr2hp1kUZrLdX6x24cdCxJ4vo1qQ4DMzKwwwaBnaFLQmVSsWiM4L3ZTUT50UJV/77t69gW3ksTGoo89lA8VAtfgwGTocRnKMyyqifeQUxPRMYolKrunzA94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421047; c=relaxed/simple;
	bh=jQls2b7GK1yBlkkRMHVaauZJzBOaegY+AeYLXQwlMaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PblhXpKv1BYfZ/Q2hbgADuguB+x66JkxVDVHPQ83x3u/K1dutel+e8NRUyUFMMXO33x3iKhgzCO6+/B/7V7HCtOR6QfbcfcqPVDn4+t9QfxMjzUc+QIHo8HZiW4FEdtakmDW8TE3PBh1cWdhGSKS824n9gRPUjNdCskoRjJBEIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRd4ptTT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRd4ptTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717B0C4CEE2;
	Wed, 23 Apr 2025 15:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421046;
	bh=jQls2b7GK1yBlkkRMHVaauZJzBOaegY+AeYLXQwlMaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRd4ptTTI+vW89Ip4EfbgSQr47shfcwcs8eiEtxSloII5nnRaLyuKvvdksRsmKbkn
	 RRCUzy7DrOuA+9MGuLSp7OzBalc7Xpdtw6LkHS39T0Fq/HJ32+AgrTaNuTvT/Z4tVr
	 OcWwph1bohhZ+NHOyQmSpqBMcPyLEAhRS5ABZAmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 170/223] drm/amdgpu/dma_buf: fix page_link check
Date: Wed, 23 Apr 2025 16:44:02 +0200
Message-ID: <20250423142624.088310148@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -181,7 +181,7 @@ static void amdgpu_dma_buf_unmap(struct
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
-	if (sgt->sgl->page_link) {
+	if (sg_page(sgt->sgl)) {
 		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);


