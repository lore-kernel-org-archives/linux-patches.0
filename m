Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE18625CC40;
	Tue, 16 Dec 2025 12:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888094; cv=none; b=RSIrvC/mWWl3GUyh1soaLbkVyqoht6L1wFtJIZJakNNlONndL6K40bIQCjvIgHsMqPJZT8RQp2Uc2/45iw/6806BlRcsI29XuCqDAox8mkRkkPmaUBWL5pGlzkgxGZCMCNp1IRBLuUui7S8fCDON6d/K4DPTtlBC5OLk4gvL0Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888094; c=relaxed/simple;
	bh=E3vfJGVuLG8kBsbt7UvKm8TqYfubJo5uyEd4qfkg30A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZGlr7jN0NW3U7SKUdP+0SsE/WK4Uijyi4WsGXn5UCCL9jMwE4DFHWwYjHXuSv6Wk6TyXFHV9a9ZyqKMbzBMXOErEkKLegiQG61D+M9eIziM1lg3hw4ePD7EE+/9o6HQQTgvqxZ27HhREFZVaW2Y1vvzP95g2M+legPPXvgod5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGiB/f1W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGiB/f1W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19788C4CEF1;
	Tue, 16 Dec 2025 12:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888094;
	bh=E3vfJGVuLG8kBsbt7UvKm8TqYfubJo5uyEd4qfkg30A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGiB/f1Wmpgcn/oFy/HgA5frF/MQ9CoeWPN4ru4J8aWh5l3u2xW6k5dXM6Cyi6eWA
	 O8DSPNOahE7Y0AyqhmXWCud2Trz3ninYiOS2FZ5U9qAqBFUh0Qk5RFPjcDYv/0DjuU
	 7SOHRfX3LI1hayLUVjUQOmvWVZoZg3O+QlVG4Et0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 431/614] drm/panthor: Avoid adding of kernel BOs to extobj list
Date: Tue, 16 Dec 2025 12:13:18 +0100
Message-ID: <20251216111416.989791215@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit ce04ec03a9c2c4f3e60e26f21311b25d5a478208 ]

The kernel BOs unnecessarily got added to the external objects list
of drm_gpuvm, when mapping to GPU, which would have resulted in few
extra CPU cycles being spent at the time of job submission as
drm_exec_until_all_locked() loop iterates over all external objects.

Kernel BOs are private to a VM and so they share the dma_resv object of
the dummy GEM object created for a VM. Use of DRM_EXEC_IGNORE_DUPLICATES
flag ensured the recursive locking of the dummy GEM object was ignored.
Also no extra space got allocated to add fences to the dma_resv object
of dummy GEM object. So no other impact apart from few extra CPU cycles.

This commit sets the pointer to dma_resv object of GEM object of
kernel BOs before they are mapped to GPU, to prevent them from
being added to external objects list.

v2: Add R-bs and fixes tags

Fixes: 8a1cc07578bf ("drm/panthor: Add GEM logical block")
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251120172118.2741724-1-akash.goel@arm.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 14ed09d700f2f..43471babff86c 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -144,6 +144,9 @@ panthor_kernel_bo_create(struct panthor_device *ptdev, struct panthor_vm *vm,
 	bo = to_panthor_bo(&obj->base);
 	kbo->obj = &obj->base;
 	bo->flags = bo_flags;
+	bo->exclusive_vm_root_gem = panthor_vm_root_gem(vm);
+	drm_gem_object_get(bo->exclusive_vm_root_gem);
+	bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 
 	if (vm == panthor_fw_vm(ptdev))
 		debug_flags |= PANTHOR_DEBUGFS_GEM_USAGE_FLAG_FW_MAPPED;
@@ -167,9 +170,6 @@ panthor_kernel_bo_create(struct panthor_device *ptdev, struct panthor_vm *vm,
 		goto err_free_va;
 
 	kbo->vm = panthor_vm_get(vm);
-	bo->exclusive_vm_root_gem = panthor_vm_root_gem(vm);
-	drm_gem_object_get(bo->exclusive_vm_root_gem);
-	bo->base.base.resv = bo->exclusive_vm_root_gem->resv;
 	return kbo;
 
 err_free_va:
-- 
2.51.0



