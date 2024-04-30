Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0320F12C461;
	Tue, 30 Apr 2024 10:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473928; cv=none; b=QdPNqURYv2qr5VXoiRHLRs1Sci+LjjXVt/LNn4FJoxb1NDcHtiTYJo3bVLP0y1nv7+aJMi8pO5zT8EB3vITXXmurUz1dtEfj5QTbmRg0JwZMDARlalr7P9kw11B9Xv2eBa4oDUyP2TnjIkYvrbuZ71GU7Jt6CZb1ZENeNSklzls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473928; c=relaxed/simple;
	bh=rRpxk2yXVK4TtmT+YMlCQfr6wY206MUM2ICUUOZnjE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBy1Brm2W3u62NeKuRnSjwuvJMzW/l5WagXBZcGiKNXo6lSEpDgK83pIQrIk76QGlT5vMv2Cm/qBAOH1Z+j96Bx7BwY7ERdQmRHu9P0yEJF7BLJkfsSbxeuU/carC2yxLggjnD0ouvNrRHKxZCU5rmpsqIva74Kle0zfusSXLPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0gjSRQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0gjSRQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80701C2BBFC;
	Tue, 30 Apr 2024 10:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473927;
	bh=rRpxk2yXVK4TtmT+YMlCQfr6wY206MUM2ICUUOZnjE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0gjSRQ3LdNYtrRxaVzapRG0fMkCGmiaz8T306Nav79hse3oham6ESNRF+yLNSgaY
	 M/zYll/+F0fMmZkw3UiixhVqod+rGTGcxtaG6WVhcxkjJcpWeCBbhFtPxu55MoygBf
	 BHaVkTs83MRN4glLvC7m2u+DuIZA6m81vs/GJ6+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oak Zeng <oak.zeng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/77] drm/amdgpu: restrict bo mapping within gpu address limits
Date: Tue, 30 Apr 2024 12:39:34 +0200
Message-ID: <20240430103042.762486586@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>

[ Upstream commit 8b80d74bdb2285d3022b349c8451eb16535f7906 ]

Have strict check on bo mapping since on some systems, such as A+A or
hybrid, the cpu might support 5 level paging or can address memory above
48 bits but gpu might be limited by hardware to just use 48 bits. In
general, this applies to all asics where this limitation can be checked
against their max_pfn range. This restricts the range to map bo within
pratical limits of cpu and gpu for shared virtual memory access.

Reviewed-by: Oak Zeng <oak.zeng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6fef2d4c00b5 ("drm/amdgpu: validate the parameters of bo mapping operations more clearly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index cdcf9e697c398..acf03c716aca5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2083,7 +2083,8 @@ int amdgpu_vm_bo_map(struct amdgpu_device *adev,
 	/* make sure object fit at this offset */
 	eaddr = saddr + size - 1;
 	if (saddr >= eaddr ||
-	    (bo && offset + size > amdgpu_bo_size(bo)))
+	    (bo && offset + size > amdgpu_bo_size(bo)) ||
+	    (eaddr >= adev->vm_manager.max_pfn << AMDGPU_GPU_PAGE_SHIFT))
 		return -EINVAL;
 
 	saddr /= AMDGPU_GPU_PAGE_SIZE;
@@ -2148,7 +2149,8 @@ int amdgpu_vm_bo_replace_map(struct amdgpu_device *adev,
 	/* make sure object fit at this offset */
 	eaddr = saddr + size - 1;
 	if (saddr >= eaddr ||
-	    (bo && offset + size > amdgpu_bo_size(bo)))
+	    (bo && offset + size > amdgpu_bo_size(bo)) ||
+	    (eaddr >= adev->vm_manager.max_pfn << AMDGPU_GPU_PAGE_SHIFT))
 		return -EINVAL;
 
 	/* Allocate all the needed memory */
-- 
2.43.0



