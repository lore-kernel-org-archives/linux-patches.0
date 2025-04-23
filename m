Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818B8293452;
	Wed, 23 Apr 2025 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422242; cv=none; b=TTgLKM7W8ZqPBKI+wlvmPxQkuFPUeibVv9BbFp3e3NDOKEcAZV8xnbJ7z3hezixVQbaKWqEnBq4wynv77FeAu87+87UF6Jlz1tJO/YfvBU54SC5WTrRlkXK9zuxJg8OMHDLz2E/aK9+7uWivBRGIKb7JQocJQsZ+TEm09CzB4gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422242; c=relaxed/simple;
	bh=aAIu2FxSlWJ9K6jSn7AhiUCrmZVG2wSv6DaO3Y+Rqkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zbx9jIIOt5JnvSe8YB2gkjFPlJNK9mMV04yHGxxgYfD2Gtpzgs/SkyiZSA1u5gW4JNSu6rdjoLdO2D2vqLcXjFgl8hBzX41GPpt3Jqi9VegcZ3sX5gTCFKkLBV/i6ED0oFzB6gxP9N7fjR0cVt7zDFDjNvzBoNtqi4s5UFUzMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZnl93BP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZnl93BP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DE4C4CEE8;
	Wed, 23 Apr 2025 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422240;
	bh=aAIu2FxSlWJ9K6jSn7AhiUCrmZVG2wSv6DaO3Y+Rqkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZnl93BPaDXpVwtwlSbfU36ngqEnMWCMtnufvoUeITQdyr4GG1z9KdLh2DY5G86KD
	 hxobVCp4bjC6p2zofdGKPbntYtyxu4fUB1X7xNnmbq37tQOHoAY/rF6XoBg7y88M1v
	 kfG45M63Gi7qB9kRM6pqKNLloUce7HXl7Pepbzoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 240/291] drm/amdgpu/dma_buf: fix page_link check
Date: Wed, 23 Apr 2025 16:43:49 +0200
Message-ID: <20250423142634.219917441@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -210,7 +210,7 @@ static void amdgpu_dma_buf_unmap(struct
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
-	if (sgt->sgl->page_link) {
+	if (sg_page(sgt->sgl)) {
 		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);


