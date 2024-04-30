Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E246812D209;
	Tue, 30 Apr 2024 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476359; cv=none; b=GtBhGpX5K6g89gUlHch8HjifBigZxJo2ySrzxpHAU7fuun1nB6mACt6hr4LGBrpx+71zNS43qyZbWar2tqpE1C5idUMmH88V+PwG8UxA+zcZsLHw5LhRdDZT53lKoJwVCGSHxj2DDaRgPe+VyZRpeVj742k5sE3T0ypq7AeoI8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476359; c=relaxed/simple;
	bh=kS2+MhBAfK8Rg6bNVE1jqaR/JNWVc6bzyaUYzJaliis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kh5bmEkFoc6xs3kCmGpd7eYob3tS+0NDheE2NoweqvJrog2O4Np+RB4FEQAmm9g+B8nvcHihLC+rLExbX6/VHHrOyXpB1KD9aUghfRgS7NhFB/3OtdZjE//mskRAncf7siI+I29Kse8ZvuKs+PPJqhZRYDeNDE2odjGHnjVwoKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSEbSOcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSEbSOcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F977C2BBFC;
	Tue, 30 Apr 2024 11:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476358;
	bh=kS2+MhBAfK8Rg6bNVE1jqaR/JNWVc6bzyaUYzJaliis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSEbSOcJ0jvUQJBfS3bGDe8X3V+/zQl1T9jOdONPp1Et/a/B3RJJth6ylGUldLX+J
	 rpnTf+u1dcZqyj8XDgUPK9K9fZFYaMoovMHacsFbun0jcoG2AVlXQCQ0ImVc1ytVBd
	 Rne8sSkcP5YBBfTsI0iyXvYPCMLzAGNZrhHazLJ8=
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
Subject: [PATCH 5.4 081/107] drm/amdgpu: restrict bo mapping within gpu address limits
Date: Tue, 30 Apr 2024 12:40:41 +0200
Message-ID: <20240430103047.049076273@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index dcf23b43f323c..88f2707c69ce7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2130,7 +2130,8 @@ int amdgpu_vm_bo_map(struct amdgpu_device *adev,
 	/* make sure object fit at this offset */
 	eaddr = saddr + size - 1;
 	if (saddr >= eaddr ||
-	    (bo && offset + size > amdgpu_bo_size(bo)))
+	    (bo && offset + size > amdgpu_bo_size(bo)) ||
+	    (eaddr >= adev->vm_manager.max_pfn << AMDGPU_GPU_PAGE_SHIFT))
 		return -EINVAL;
 
 	saddr /= AMDGPU_GPU_PAGE_SIZE;
@@ -2195,7 +2196,8 @@ int amdgpu_vm_bo_replace_map(struct amdgpu_device *adev,
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



