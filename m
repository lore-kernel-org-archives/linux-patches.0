Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E3C29B77C;
	Tue,  6 Jan 2026 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721249; cv=none; b=aMjsdQZVmG9fZJO48hCNBJGkAeXNG+b8k7WqYdAfdM7qtUJYobiT3/9gWyQf93klyTgKGZIXMgj9ph7CQslEqVCMeXqIsSWHVzW511efaOXodQGHHIWykwWTfau1cl/yWpqpjqhnGZB4LImdjBSXunEno9ROZ6xAw3pvZyYyCsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721249; c=relaxed/simple;
	bh=gUCcFPzjtCkWjnybB19KD1tmWNSqbq0kGup2E/RaWDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kq+4AMG0+uSwY7EAxN2SEeqGdUNUQBy+YZtyRpvL4UVDkeXM/gtPK+xx9aHGFsb3lwsJ6iZp7R+b4cBZDggcXbw0WlZ5fW40+y8x+8vyjSbBydMFRNb32A8NtttsprQi40ediOZJoAcHPI9BTcKvNTlKGMasa8wtYFlpTI/V5nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zyys5oN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zyys5oN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB54C116C6;
	Tue,  6 Jan 2026 17:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721249;
	bh=gUCcFPzjtCkWjnybB19KD1tmWNSqbq0kGup2E/RaWDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zyys5oN+eKYWwaY8K4MWKllmWcNsczNaSyKQgdd1e/IX5xhd9lfmM4OApek9kqeTe
	 98bLj+ReVzZ4OshvD/quWQh1K9C7mtbkDO4DwlDImGKvy9xytGcDG846Z7ncEpqkAH
	 /W9VsTU2mT/OhbvvrcprX1SD5G2XGycSJwVEkEMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 480/567] drm/xe: Drop preempt-fences when destroying imported dma-bufs.
Date: Tue,  6 Jan 2026 18:04:22 +0100
Message-ID: <20260106170509.111241052@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit fe3ccd24138fd391ae8e32289d492c85f67770fc upstream.

When imported dma-bufs are destroyed, TTM is not fully
individualizing the dma-resv, but it *is* copying the fences that
need to be waited for before declaring idle. So in the case where
the bo->resv != bo->_resv we can still drop the preempt-fences, but
make sure we do that on bo->_resv which contains the fence-pointer
copy.

In the case where the copying fails, bo->_resv will typically not
contain any fences pointers at all, so there will be nothing to
drop. In that case, TTM would have ensured all fences that would
have been copied are signaled, including any remaining preempt
fences.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Fixes: fa0af721bd1f ("drm/ttm: test private resv obj on release/destroy")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.16+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Tested-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251217093441.5073-1-thomas.hellstrom@linux.intel.com
(cherry picked from commit 425fe550fb513b567bd6d01f397d274092a9c274)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1041,7 +1041,7 @@ static bool xe_ttm_bo_lock_in_destructor
 	 * always succeed here, as long as we hold the lru lock.
 	 */
 	spin_lock(&ttm_bo->bdev->lru_lock);
-	locked = dma_resv_trylock(ttm_bo->base.resv);
+	locked = dma_resv_trylock(&ttm_bo->base._resv);
 	spin_unlock(&ttm_bo->bdev->lru_lock);
 	xe_assert(xe, locked);
 
@@ -1061,13 +1061,6 @@ static void xe_ttm_bo_release_notify(str
 	bo = ttm_to_xe_bo(ttm_bo);
 	xe_assert(xe_bo_device(bo), !(bo->created && kref_read(&ttm_bo->base.refcount)));
 
-	/*
-	 * Corner case where TTM fails to allocate memory and this BOs resv
-	 * still points the VMs resv
-	 */
-	if (ttm_bo->base.resv != &ttm_bo->base._resv)
-		return;
-
 	if (!xe_ttm_bo_lock_in_destructor(ttm_bo))
 		return;
 
@@ -1077,14 +1070,14 @@ static void xe_ttm_bo_release_notify(str
 	 * TODO: Don't do this for external bos once we scrub them after
 	 * unbind.
 	 */
-	dma_resv_for_each_fence(&cursor, ttm_bo->base.resv,
+	dma_resv_for_each_fence(&cursor, &ttm_bo->base._resv,
 				DMA_RESV_USAGE_BOOKKEEP, fence) {
 		if (xe_fence_is_xe_preempt(fence) &&
 		    !dma_fence_is_signaled(fence)) {
 			if (!replacement)
 				replacement = dma_fence_get_stub();
 
-			dma_resv_replace_fences(ttm_bo->base.resv,
+			dma_resv_replace_fences(&ttm_bo->base._resv,
 						fence->context,
 						replacement,
 						DMA_RESV_USAGE_BOOKKEEP);
@@ -1092,7 +1085,7 @@ static void xe_ttm_bo_release_notify(str
 	}
 	dma_fence_put(replacement);
 
-	dma_resv_unlock(ttm_bo->base.resv);
+	dma_resv_unlock(&ttm_bo->base._resv);
 }
 
 static void xe_ttm_bo_delete_mem_notify(struct ttm_buffer_object *ttm_bo)


