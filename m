Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13D43446B6;
	Tue, 11 Nov 2025 01:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824148; cv=none; b=EJTY76sq4U3y5WDeSyi5Zg9Boo9A7NStTkDqKkYyVBYmo5T+XpHGaCcG/Nf09LXA+pi/EEYgXMyPB0M5xUXSJs5nFhcj1o0+teBk7q4KqGR05wpF+hV6UeILnJ2bqcnXrgdEeYFerWC6HQS3sHxXCBjXkXr0vRyCVdWSwlPaWi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824148; c=relaxed/simple;
	bh=ifeYbH6muKQp5+fn3TB3pCocSfakFzXpylntssnGTNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hH02NCYEgnfb1OyzJEaeyxSdjsgm+qaQRYkTG4GPlgVak9JCh8rxHR790HsPAPy7oEOL7od0JE7km2LSFUcA+cTaP4gJH07CXRhN1lxe8S79OK81Xhs18SmwRP8t7KPv/wNOhkoQc3LsdsZcjp2sThbzN/RHJUujCo8Z+DNQc5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNdE00/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNdE00/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD36BC19422;
	Tue, 11 Nov 2025 01:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824148;
	bh=ifeYbH6muKQp5+fn3TB3pCocSfakFzXpylntssnGTNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNdE00/M1AdyAYZ3Q68UHWD3Bh2y85boWTOpFZ2JpfjDNO6Bhq9xZNMfJ6ZOb8aR+
	 gadDYY7yE+UmBBNiM6J+6rnOlnvYi3aRjOu8qzRfFxSnMGaQ88HhpqlB3S+zlauGpj
	 joG948w2gUFQxA5n8hZpWJFPCpzt6TBG5OuCuf3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 446/849] drm/xe: improve dma-resv handling for backup object
Date: Tue, 11 Nov 2025 09:40:16 +0900
Message-ID: <20251111004547.217717802@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit edb1745fc618ba8ef63a45ce3ae60de1bdf29231 ]

Since the dma-resv is shared we don't need to reserve and add a fence
slot fence twice, plus no need to loop through the dependencies.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://lore.kernel.org/r/20250829164715.720735-2-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c      | 13 +------------
 drivers/gpu/drm/xe/xe_migrate.c |  2 +-
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index d07e23eb1a54d..5a61441d68af5 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1242,14 +1242,11 @@ int xe_bo_evict_pinned(struct xe_bo *bo)
 		else
 			migrate = mem_type_to_migrate(xe, bo->ttm.resource->mem_type);
 
+		xe_assert(xe, bo->ttm.base.resv == backup->ttm.base.resv);
 		ret = dma_resv_reserve_fences(bo->ttm.base.resv, 1);
 		if (ret)
 			goto out_backup;
 
-		ret = dma_resv_reserve_fences(backup->ttm.base.resv, 1);
-		if (ret)
-			goto out_backup;
-
 		fence = xe_migrate_copy(migrate, bo, backup, bo->ttm.resource,
 					backup->ttm.resource, false);
 		if (IS_ERR(fence)) {
@@ -1259,8 +1256,6 @@ int xe_bo_evict_pinned(struct xe_bo *bo)
 
 		dma_resv_add_fence(bo->ttm.base.resv, fence,
 				   DMA_RESV_USAGE_KERNEL);
-		dma_resv_add_fence(backup->ttm.base.resv, fence,
-				   DMA_RESV_USAGE_KERNEL);
 		dma_fence_put(fence);
 	} else {
 		ret = xe_bo_vmap(backup);
@@ -1338,10 +1333,6 @@ int xe_bo_restore_pinned(struct xe_bo *bo)
 		if (ret)
 			goto out_unlock_bo;
 
-		ret = dma_resv_reserve_fences(backup->ttm.base.resv, 1);
-		if (ret)
-			goto out_unlock_bo;
-
 		fence = xe_migrate_copy(migrate, backup, bo,
 					backup->ttm.resource, bo->ttm.resource,
 					false);
@@ -1352,8 +1343,6 @@ int xe_bo_restore_pinned(struct xe_bo *bo)
 
 		dma_resv_add_fence(bo->ttm.base.resv, fence,
 				   DMA_RESV_USAGE_KERNEL);
-		dma_resv_add_fence(backup->ttm.base.resv, fence,
-				   DMA_RESV_USAGE_KERNEL);
 		dma_fence_put(fence);
 	} else {
 		ret = xe_bo_vmap(backup);
diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 2a627ed64b8f8..ba9b8590eccb2 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -901,7 +901,7 @@ struct dma_fence *xe_migrate_copy(struct xe_migrate *m,
 		if (!fence) {
 			err = xe_sched_job_add_deps(job, src_bo->ttm.base.resv,
 						    DMA_RESV_USAGE_BOOKKEEP);
-			if (!err && src_bo != dst_bo)
+			if (!err && src_bo->ttm.base.resv != dst_bo->ttm.base.resv)
 				err = xe_sched_job_add_deps(job, dst_bo->ttm.base.resv,
 							    DMA_RESV_USAGE_BOOKKEEP);
 			if (err)
-- 
2.51.0



