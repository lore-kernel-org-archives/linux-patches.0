Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C2114389E;
	Tue, 23 Apr 2024 21:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908653; cv=none; b=md1nbRPGS86bCvGSfVGw3JC/YU9mRyr3iUnxuTQhBWYngFtJ0AUXJj4uDrn6Zda/3D6v0is4ryOYVPhBwIB0Ol2tIB4YmtNbI3g1yLLq0ibuUGytKLO3kXlAFjYAax6/c/62vR8Su2rKBZwRMscXJrtDFZjhXBNVCZnkAxYXnq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908653; c=relaxed/simple;
	bh=k6CJ3pSCou6GZwOlonHQhyFiJKpbsuU3fOh5NK0S5Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ez/UG6+n6huFWgwd3KPMxv2FMzYkOgCRXm4mgEa1+iF6VWSObj9NE9qHVsFwjUCTUTzjCyTpFsUVEUtO82vyjlBXP6aWktjtaQvRUPdGzs4XXh43lPTZisw7ADdZjhIRs+eVMlDXWse8BjAwnQByTr9PwapudU8eOib7r5JOG6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyZ6tCDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyZ6tCDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E541C3277B;
	Tue, 23 Apr 2024 21:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908653;
	bh=k6CJ3pSCou6GZwOlonHQhyFiJKpbsuU3fOh5NK0S5Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyZ6tCDuINKpdyxWyDJFdBI8uWfnJS3mrFWWO4suehiAq0vLbw8VSuPHXaNwXtbrF
	 5z/pzzc7+J9vjZskT2QS+9Yv7+JbMpbt4tle/oMv6NcvBiLvKnF2d+2Vz2K+yT43qB
	 qjdzZLDb27kVbmCuBjTCkgSFTbSDPUNCRdXB9Q6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 143/158] drm/amdgpu: remove invalid resource->start check v2
Date: Tue, 23 Apr 2024 14:39:40 -0700
Message-ID: <20240423213900.335757179@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


