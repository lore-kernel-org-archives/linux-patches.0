Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F303E196446;
	Thu,  5 Sep 2024 09:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529475; cv=none; b=CkE6muyD2R4SYKH3QqlMXGeLOeqwnkz68BDEhBe+H8x0UhXX+AjHyX5l4cztvaNEVH5twLh3pfK6VytKO69etT6n9Us1sGDynX9OcA7Z2Ho3h/dypvtesDepXfkH811rAw/OpL3mlHS5XDkfGpIX9UaCBSLmXe3+FA9xeRJThVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529475; c=relaxed/simple;
	bh=SDQr7AWKCJwU8+Pp/HHIas5v6LNfbPMdhdq0Uz8rQmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAt964KPPb/Epzyx4DXrhOlbtY9hYiUFTZV+Kc8EEf8k899UvoxN+rCvw39y8CBg+GYz65oJHYstJ/SynoO38NOoH7imJyHWaTq3I9O92qJ15fAtKv/F7veOefhQtgAjVp9qNbk8NQ+XpQ7Wq55gq9zZuppcp1SC6PFF0a/51tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfpY/E/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfpY/E/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F378AC4CEC3;
	Thu,  5 Sep 2024 09:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529474;
	bh=SDQr7AWKCJwU8+Pp/HHIas5v6LNfbPMdhdq0Uz8rQmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfpY/E/uFQoQK7o+haDW+Ysv5xR8N8/w12R2chmXWoAK1xM5+I5N54BPwmit2TEd1
	 C9Z0kPbs7WthP0m2R4w3bnjmzAdwQc6m87112HB4j022+vPMRjMFkCZZydIiHTDRzh
	 uEkKcMygVLf9n++Pc4qzTp4GZdKZ0I3+TGY79EDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 044/184] drm/amdgpu: Handle sg size limit for contiguous allocation
Date: Thu,  5 Sep 2024 11:39:17 +0200
Message-ID: <20240905093733.969192266@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit b2dba064c9bdd18c7dd39066d25453af28451dbf ]

Define macro AMDGPU_MAX_SG_SEGMENT_SIZE 2GB, because struct scatterlist
length is unsigned int, and some users of it cast to a signed int, so
every segment of sg table is limited to size 2GB maximum.

For contiguous VRAM allocation, don't limit the max buddy block size in
order to get contiguous VRAM memory. To workaround the sg table segment
size limit, allocate multiple segments if contiguous size is bigger than
AMDGPU_MAX_SG_SEGMENT_SIZE.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 6c30eceec896..f91cc149d06c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -31,6 +31,8 @@
 #include "amdgpu_atomfirmware.h"
 #include "atom.h"
 
+#define AMDGPU_MAX_SG_SEGMENT_SIZE	(2UL << 30)
+
 struct amdgpu_vram_reservation {
 	u64 start;
 	u64 size;
@@ -518,9 +520,7 @@ static int amdgpu_vram_mgr_new(struct ttm_resource_manager *man,
 		else
 			min_block_size = mgr->default_page_size;
 
-		/* Limit maximum size to 2GiB due to SG table limitations */
-		size = min(remaining_size, 2ULL << 30);
-
+		size = remaining_size;
 		if ((size >= (u64)pages_per_block << PAGE_SHIFT) &&
 		    !(size & (((u64)pages_per_block << PAGE_SHIFT) - 1)))
 			min_block_size = (u64)pages_per_block << PAGE_SHIFT;
@@ -660,7 +660,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 	amdgpu_res_first(res, offset, length, &cursor);
 	while (cursor.remaining) {
 		num_entries++;
-		amdgpu_res_next(&cursor, cursor.size);
+		amdgpu_res_next(&cursor, min(cursor.size, AMDGPU_MAX_SG_SEGMENT_SIZE));
 	}
 
 	r = sg_alloc_table(*sgt, num_entries, GFP_KERNEL);
@@ -680,7 +680,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 	amdgpu_res_first(res, offset, length, &cursor);
 	for_each_sgtable_sg((*sgt), sg, i) {
 		phys_addr_t phys = cursor.start + adev->gmc.aper_base;
-		size_t size = cursor.size;
+		unsigned long size = min(cursor.size, AMDGPU_MAX_SG_SEGMENT_SIZE);
 		dma_addr_t addr;
 
 		addr = dma_map_resource(dev, phys, size, dir,
@@ -693,7 +693,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 		sg_dma_address(sg) = addr;
 		sg_dma_len(sg) = size;
 
-		amdgpu_res_next(&cursor, cursor.size);
+		amdgpu_res_next(&cursor, size);
 	}
 
 	return 0;
-- 
2.43.0



