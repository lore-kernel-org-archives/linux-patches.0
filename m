Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431D0341069;
	Tue, 16 Dec 2025 11:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884179; cv=none; b=V0tqa54AoLbi9BVaYbNDiQx3gmtDtPf5W8RETJKSX5DPpdSP6t6dXIfQGceuxRBcTtIUA7tYg09Smi/LapYN8v6MuRu/rGHzhM0BAWt0lH5h3gTttlnHuBFbZ03XXmvH71LVmHQSZcRx5SIcM6Z9Rfcau9or4EzGPHm9CxhBvrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884179; c=relaxed/simple;
	bh=LADstBapGfVhYUq9jB57Dh2JabwFJNWHrbPNR7S0/jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo+D84N82xVUXsVpYH8bYbN2u27EOjxV+D6We/5rQFj/xs7qgTSkdIoPQqoh+ZdTgkoCiVrDcBAMR5OlOxTHavRC1Ms/ZcCjx1DyLCJX7ktM6DRKrBsGAKvNeZaRRLQ89KpKIJBgvsuwQxJxZ/o0/BhCXFF9aml9gdoVxwq6AZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saSFdHzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saSFdHzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3847C4CEF1;
	Tue, 16 Dec 2025 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884179;
	bh=LADstBapGfVhYUq9jB57Dh2JabwFJNWHrbPNR7S0/jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saSFdHzXOuPlcH5jQh2b2qf6MzPd0EqDFTo9xwUeH2ENiTqSyaVEV8KJbIALwHFd6
	 OX0PnDC+E7euqg2jCdVdRHsWdxHOVY86J7sIwLaR62OkhJG8uRaJv8t90287TMycFE
	 rCWtVlHU6p8JpT0sl0qMGlsaKANA6osddFJirDYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Ivar Hesselberg Simonsen <lars-ivar.simonsen@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/354] drm/panthor: Fix UAF on kernel BO VA nodes
Date: Tue, 16 Dec 2025 12:11:23 +0100
Message-ID: <20251216111325.127016729@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 98dd5143447af0ee33551776d8b2560c35d0bc4a ]

If the MMU is down, panthor_vm_unmap_range() might return an error.
We expect the page table to be updated still, and if the MMU is blocked,
the rest of the GPU should be blocked too, so no risk of accessing
physical memory returned to the system (which the current code doesn't
cover for anyway).

Proceed with the rest of the cleanup instead of bailing out and leaving
the va_node inserted in the drm_mm, which leads to UAF when other
adjacent nodes are removed from the drm_mm tree.

Reported-by: Lars-Ivar Hesselberg Simonsen <lars-ivar.simonsen@arm.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/issues/57
Fixes: 8a1cc07578bf ("drm/panthor: Add GEM logical block")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20251031154818.821054-2-boris.brezillon@collabora.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index be97d56bc011d..8387a075150bd 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -32,7 +32,6 @@ static void panthor_gem_free_object(struct drm_gem_object *obj)
 void panthor_kernel_bo_destroy(struct panthor_kernel_bo *bo)
 {
 	struct panthor_vm *vm;
-	int ret;
 
 	if (IS_ERR_OR_NULL(bo))
 		return;
@@ -40,18 +39,11 @@ void panthor_kernel_bo_destroy(struct panthor_kernel_bo *bo)
 	vm = bo->vm;
 	panthor_kernel_bo_vunmap(bo);
 
-	if (drm_WARN_ON(bo->obj->dev,
-			to_panthor_bo(bo->obj)->exclusive_vm_root_gem != panthor_vm_root_gem(vm)))
-		goto out_free_bo;
-
-	ret = panthor_vm_unmap_range(vm, bo->va_node.start, bo->va_node.size);
-	if (ret)
-		goto out_free_bo;
-
+	drm_WARN_ON(bo->obj->dev,
+		    to_panthor_bo(bo->obj)->exclusive_vm_root_gem != panthor_vm_root_gem(vm));
+	panthor_vm_unmap_range(vm, bo->va_node.start, bo->va_node.size);
 	panthor_vm_free_va(vm, &bo->va_node);
 	drm_gem_object_put(bo->obj);
-
-out_free_bo:
 	panthor_vm_put(vm);
 	kfree(bo);
 }
-- 
2.51.0



