Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19E85274;
	Tue, 23 Apr 2024 21:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908557; cv=none; b=PW2RWxHdA4IQkaZqOoObKFopT25HxlOJKDwgo6NqnG63gHCnFibiyR/gt7bmmGhzhUS3TQULC5YlgyF1rbk7UXwoHMXjrDxp8ubWMGxH28sqsOlgr1xDsqPjxqyCVFU4zHBFs85pZPvfxYnfBSxW9ip2DD0HoKNMnr8J43xCEvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908557; c=relaxed/simple;
	bh=hty4y6TT/YVcWow8+dPKzLCFZkszg2vlpQqMtf2wquE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J6cjOq0nd/G/BbwL5YpiokwiDBsn0WzYEn0kh48sasuPr6BWdY3xw5+EoWuNLV0cQPGTvDe0I64zyEWjQid+D1IbGQ8rurWzNPLI84tC4K/VhhFJkl82Ye7at69wp1WTjLRopNYHp5jH6Nj+u7k0kd664lsPve427u1c4w8xkAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJDHhuTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJDHhuTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCA2C116B1;
	Tue, 23 Apr 2024 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908556;
	bh=hty4y6TT/YVcWow8+dPKzLCFZkszg2vlpQqMtf2wquE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJDHhuTsEwFayUAQFFwgTD3x76ft6r3Z+BwMWxulEPZnUlrtt/AXBCupD5j5SKJt6
	 wV/KktmGpAQpxofWbUEcQPZtMgJ/HlbY71sR2zgsWBR9cwZRVtWMoIhcIUZbdsOvAX
	 4y9z8dRGJr/AUCOuZ+yBSzr2nb347hn1D6gQry6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 142/158] drm/amdgpu: remove invalid resource->start check v2
Date: Tue, 23 Apr 2024 14:39:24 -0700
Message-ID: <20240423213900.479846593@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit ca7c4507ba87e9fc22e0ecfa819c3664b3e8287b upstream.

The majority of those where removed in the commit aed01a68047b
("drm/amdgpu: Remove TTM resource->start visible VRAM condition v2")

But this one was missed because it's working on the resource and not the
BO. Since we also no longer use a fake start address for visible BOs
this will now trigger invalid mapping errors.

v2: also remove the unused variable

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: aed01a68047b ("drm/amdgpu: Remove TTM resource->start visible VRAM condition v2")
CC: stable@vger.kernel.org
Acked-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -562,7 +562,6 @@ static int amdgpu_ttm_io_mem_reserve(str
 				     struct ttm_resource *mem)
 {
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bdev);
-	size_t bus_size = (size_t)mem->size;
 
 	switch (mem->mem_type) {
 	case TTM_PL_SYSTEM:
@@ -573,9 +572,6 @@ static int amdgpu_ttm_io_mem_reserve(str
 		break;
 	case TTM_PL_VRAM:
 		mem->bus.offset = mem->start << PAGE_SHIFT;
-		/* check if it's visible */
-		if ((mem->bus.offset + bus_size) > adev->gmc.visible_vram_size)
-			return -EINVAL;
 
 		if (adev->mman.aper_base_kaddr &&
 		    mem->placement & TTM_PL_FLAG_CONTIGUOUS)


