Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EDF15A84C;
	Mon, 27 May 2024 19:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837537; cv=none; b=FC3p2vCqDh5mowUyYOLU+vNWNW9ernYniI9uANkhMOrtWmMiqX08s1ivXndTok5KkbnzQrCWdcrl9YPvO8a61GXZm4rUtN2mfxU/LKDloTk2k/KcFNZg21mZ00pPThJKe7hh/PsABZhQCPlvU/wevo3lu9aL8sGfkbPYFMvsPDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837537; c=relaxed/simple;
	bh=w51HGErJMy9wXKRUZM7giWBL/jHAlcFq6UPaJP+xzH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CimsnMuu4O92TWbWWBsbKUtuDC47k8AbRMrSuD73qoREawuOO8zrEbIQRq0Uuv+YLCZ1FubPcwozWKjz0mQfaW0C5bcsoiyHQakC1buBi/OhuGCSrJ6syJ2U0Hz9mS6kCOX4BKgDUfBbMF/KKVBoe2PPEHgO2Dyz4VqNm9XvyjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UR+/v4BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UR+/v4BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED5EC32781;
	Mon, 27 May 2024 19:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837537;
	bh=w51HGErJMy9wXKRUZM7giWBL/jHAlcFq6UPaJP+xzH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UR+/v4BHX792YPwliuPQQmqBJGiDH5Ci84cIP9rBrdKdUSudxSlstZdVH/oN/5cAZ
	 c6GxsP7tWmhnAWd8WKAi2vv3tedysVtu0pj8NI7NoIga0cR1qxVxfqwSSUflD0QfO2
	 TSOV5WJ5x7knDVLQUXFg1KbpqcmmW3O7SkAW7KVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 050/493] drm/amdkfd: Add VRAM accounting for SVM migration
Date: Mon, 27 May 2024 20:50:52 +0200
Message-ID: <20240527185630.775731085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 1e214f7faaf5d842754cd5cfcd76308bfedab3b5 ]

Do VRAM accounting when doing migrations to vram to make sure
there is enough available VRAM and migrating to VRAM doesn't evict
other possible non-unified memory BOs. If migrating to VRAM fails,
driver can fall back to using system memory seamlessly.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 16 +++++++++++++++-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c     |  2 +-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index bdc01ca9609a7..5c8d81bfce7ab 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -509,10 +509,19 @@ svm_migrate_ram_to_vram(struct svm_range *prange, uint32_t best_loc,
 	start = start_mgr << PAGE_SHIFT;
 	end = (last_mgr + 1) << PAGE_SHIFT;
 
+	r = amdgpu_amdkfd_reserve_mem_limit(node->adev,
+					prange->npages * PAGE_SIZE,
+					KFD_IOC_ALLOC_MEM_FLAGS_VRAM,
+					node->xcp ? node->xcp->id : 0);
+	if (r) {
+		dev_dbg(node->adev->dev, "failed to reserve VRAM, r: %ld\n", r);
+		return -ENOSPC;
+	}
+
 	r = svm_range_vram_node_new(node, prange, true);
 	if (r) {
 		dev_dbg(node->adev->dev, "fail %ld to alloc vram\n", r);
-		return r;
+		goto out;
 	}
 	ttm_res_offset = (start_mgr - prange->start + prange->offset) << PAGE_SHIFT;
 
@@ -545,6 +554,11 @@ svm_migrate_ram_to_vram(struct svm_range *prange, uint32_t best_loc,
 		svm_range_vram_node_free(prange);
 	}
 
+out:
+	amdgpu_amdkfd_unreserve_mem_limit(node->adev,
+					prange->npages * PAGE_SIZE,
+					KFD_IOC_ALLOC_MEM_FLAGS_VRAM,
+					node->xcp ? node->xcp->id : 0);
 	return r < 0 ? r : 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index c50a0dc9c9c07..33205078202b5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3424,7 +3424,7 @@ svm_range_trigger_migration(struct mm_struct *mm, struct svm_range *prange,
 				mm, KFD_MIGRATE_TRIGGER_PREFETCH);
 	*migrated = !r;
 
-	return r;
+	return 0;
 }
 
 int svm_range_schedule_evict_svm_bo(struct amdgpu_amdkfd_fence *fence)
-- 
2.43.0



