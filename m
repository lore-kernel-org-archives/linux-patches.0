Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5925128C5AD;
	Wed, 23 Apr 2025 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421002; cv=none; b=mfxJ6TfTC9OAYBiLd4MTlRSjqobEXInOMqpqXMw76WTgPRUrtqjFKKXRXOnNHmGxEBPfakOyk82zyY4+2K7bhLke47Zh4IttIJqxgCiNZyA9ZRylhcfS3zHAuR0w4VZD0ND16LSHwW3oDEPsXdpr3D8OhpgEXgE6XsZi0Evj1rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421002; c=relaxed/simple;
	bh=C/lw9BVtB5AN/DC/UbWm9g0u+obHbCK+IQuDanwVebo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/NADmLxRR6xTMfq48pXmq8FnTHmop6DForJeIOKPICdqMuC1dFJK9QhhsqC87JtXtZHGQpsXaiBmT327A+1FVzmogIwc7/+qVvPE9WyAE82mBJxxgZxkxQ6iFVXAX4Cyl4Ny1HrWTbrX16A4nX/qRNFuYyh/INLowzh+8WRbUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIP6ptPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIP6ptPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78CDC4CEE2;
	Wed, 23 Apr 2025 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421002;
	bh=C/lw9BVtB5AN/DC/UbWm9g0u+obHbCK+IQuDanwVebo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIP6ptPT6LqAg8LAWJ8CpnCwSoaRXlEm9LK/7jXuJJJkPcN9zPcAL5eqoS4L4Dt9V
	 QI7VQ2SBV4oKeIsclxe2XqZnI9BZiq/sy/2pfTYzDUy8AgpihhD1Y/qmAWHIDEfX5x
	 63vvH8ljQ51e0Cbfi+1e5lRq5maijaCV42tlEFKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 181/223] drm/xe/dma_buf: stop relying on placement in unmap
Date: Wed, 23 Apr 2025 16:44:13 +0200
Message-ID: <20250423142624.542625735@linuxfoundation.org>
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


