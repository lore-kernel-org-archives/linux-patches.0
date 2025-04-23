Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574F6283C98;
	Wed, 23 Apr 2025 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421618; cv=none; b=PNq5CqaKCTBbOrn75CF/+M7YiQtPAPBYyyex/0QUXyMsQ0rbUlAVUqAWtaDPIYirZmoR2whL9AM4Q6ZArtqlTTOaF4NhxiJHuRR7twRgbbR10MgUCm/N7aEMLSh04oXhGrFSFHsL/BsoYbEbvb0BpmAT/TACioIFZDw7Q2sodtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421618; c=relaxed/simple;
	bh=tnUac6utk5nc/nppFvT1+IWmfDmoSvpEUWAJDkQrc2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nvaf+GixOgBhnUCdlxGR7yQPWFZtZDO4T8MGcIndFTc+vTV/PvXmQ4cCPFOpwLoQ5lycYHefjm+tWP9TlZnL03dE5mdUKX+j2npr3/jdow5J/ARRZdRp6jJ7j1QnsB1ZkipmKqSakO/IE++BedUpGYPDqhUP8wXjqx2XBt1h1P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlP9mGFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlP9mGFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D73C4CEE2;
	Wed, 23 Apr 2025 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421618;
	bh=tnUac6utk5nc/nppFvT1+IWmfDmoSvpEUWAJDkQrc2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlP9mGFetR/1EKWfD+DWc3nrt5mFPJg7dwue3p2/3JIhDB9cXCKb/YdXQCzq49FBe
	 a1SyDctH7k8QWV+ZhHmg1i6uHmyxj5/ZN7cFEJI7uNw88+eZ4iovLUCRTpMhV2wmMl
	 EsFm0dWOqQ/w8iYM1xW+Mm5DNw3wBtU61uQI5Wfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.14 212/241] drm/xe/dma_buf: stop relying on placement in unmap
Date: Wed, 23 Apr 2025 16:44:36 +0200
Message-ID: <20250423142629.209447971@linuxfoundation.org>
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

commit 25583ad42d091819157832e894179200ba8b54ee upstream.

The is_vram() is checking the current placement, however if we consider
exported VRAM with dynamic dma-buf, it looks possible for the xe driver
to async evict the memory, notifying the importer, however importer does
not have to call unmap_attachment() immediately, but rather just as
"soon as possible", like when the dma-resv idles. Following from this we
would then pipeline the move, attaching the fence to the manager, and
then update the current placement. But when the unmap_attachment() runs
at some later point we might see that is_vram() is now false, and take
the complete wrong path when dma-unmapping the sg, leading to
explosions.

To fix this check if the sgl was mapping a struct page.

v2:
  - The attachment can be mapped multiple times it seems, so we can't
    really rely on encoding something in the attachment->priv. Instead
    see if the page_link has an encoded struct page. For vram we expect
    this to be NULL.

Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4563
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Acked-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250410162716.159403-2-matthew.auld@intel.com
(cherry picked from commit d755887f8e5a2a18e15e6632a5193e5feea18499)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_dma_buf.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -145,10 +145,7 @@ static void xe_dma_buf_unmap(struct dma_
 			     struct sg_table *sgt,
 			     enum dma_data_direction dir)
 {
-	struct dma_buf *dma_buf = attach->dmabuf;
-	struct xe_bo *bo = gem_to_xe_bo(dma_buf->priv);
-
-	if (!xe_bo_is_vram(bo)) {
+	if (sg_page(sgt->sgl)) {
 		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);


