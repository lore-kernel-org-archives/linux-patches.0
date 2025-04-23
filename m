Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BD328E5F1;
	Wed, 23 Apr 2025 15:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421502; cv=none; b=b86kAPRq1hF2ZyoX02Jj/JZ5PyAtU3HUK2p0PDg95QYHffT3q2mQbz7mQq2Kv+sL2n0wAGUARj8+Tgwd5HCy+iwkCMOo9hEY1rPiADbuM1jG73J5xxx0KAbwbUOMqh4Hiza7FmYdM1zIxnen37LcRY9GLdb0x0rX9Bxe6eHioa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421502; c=relaxed/simple;
	bh=+zll/WfkzPKpo3Pqy/9ZCfebHG5Up/a9RJSZRTuKLoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FU8I4w49kj/tGxYKi61ksii1hqiUNBMY4/XjlSue0r9EOIJLnNc6WtzUsm2Hbli61Kh2QiMK2Tn1vSuK8S5mMiyR80/0lJ6WPAZZdX9ke7OvKlo2TKTqFV4hQ+ouF1RMSRgNtgzwa+BgpWp/yeTLp6Sz/pUuGmJ8/NrvdQSGMqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v99Hmqbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v99Hmqbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4C0C4CEE2;
	Wed, 23 Apr 2025 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421502;
	bh=+zll/WfkzPKpo3Pqy/9ZCfebHG5Up/a9RJSZRTuKLoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v99Hmqbq4gUnOx/8FDGSFsW6nvrcjrtIssugOSBwbKM8B3q+K5duvAWEY0qEctw6Y
	 1YnTwj39k0yHW4NSDgxXhTZILHTlLCe150XUBsCc7TdYfh/1aNjVfYS0Jt+6XYmvlJ
	 4skRDMSNYkW23vwkYhiaRFFskTsC5AxG6msJyRIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 196/241] drm/amdgpu/dma_buf: fix page_link check
Date: Wed, 23 Apr 2025 16:44:20 +0200
Message-ID: <20250423142628.517110227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -184,7 +184,7 @@ static void amdgpu_dma_buf_unmap(struct
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
-	if (sgt->sgl->page_link) {
+	if (sg_page(sgt->sgl)) {
 		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);


