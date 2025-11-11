Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081A925CC40;
	Tue, 11 Nov 2025 01:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824001; cv=none; b=kRNxH8bQS/FTDQzirgyRgmpVH1cWWsRy+EG7NhA/fqq+dDMaqhNfS0Y/MT258/CUjeetAhq5VYd6N8wGE1Kb1UZiLywe5ELHKWKuFBj953YAjsq3cLU2TObhQ4ZXyWY3q9bpajpPC1W4E6ACFY4wPJfMW2xij13tKpHrjYE0Llk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824001; c=relaxed/simple;
	bh=meN4BPqI428n9/wURJ2Jagp0ZHMR+WPn/Mpf6nHDoKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvPlv1tDKWjuXP3G2wsVwrUrvpjcWieEz0zf4TSriyWHiyaFAMn1fvggKh3rx929EyD7kRlOvz0Ah0cTNIByTvVpFSQhGYMjxs/LppXK04SnXmgUp3B4NxJbV25Wy2HosUb1BlNqmL9quA9vOQ+VKdSXjpfbRyOaIkm8YJn81Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GwNHlCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GwNHlCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4CFC4CEF5;
	Tue, 11 Nov 2025 01:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824000;
	bh=meN4BPqI428n9/wURJ2Jagp0ZHMR+WPn/Mpf6nHDoKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1GwNHlCEMmuNJvsynC3wPDsVJJCrtP+HEl55JhAZIa60OJ81HNP3GLbr3q9fYgPbJ
	 S+xW5OOJW+RgkeRXwVxPPl57pWhIYAdGmt3KMm7QCp+n6sq5EKIN1+Q1+qpJyworOF
	 e7DiRvQ1Ch9ORlBi5W+XdoM409gCfO7WMSQ89ejo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/565] drm/amdgpu: Use memdup_array_user in amdgpu_cs_wait_fences_ioctl
Date: Tue, 11 Nov 2025 09:43:36 +0900
Message-ID: <20251111004534.966362312@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit dea75df7afe14d6217576dbc28cc3ec1d1f712fb ]

Replace kmalloc_array() + copy_from_user() with memdup_array_user().

This shrinks the source code and improves separation between the kernel
and userspace slabs.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 5df21529b3b13..187263c0406ef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1737,30 +1737,21 @@ int amdgpu_cs_wait_fences_ioctl(struct drm_device *dev, void *data,
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	union drm_amdgpu_wait_fences *wait = data;
-	uint32_t fence_count = wait->in.fence_count;
-	struct drm_amdgpu_fence *fences_user;
 	struct drm_amdgpu_fence *fences;
 	int r;
 
 	/* Get the fences from userspace */
-	fences = kmalloc_array(fence_count, sizeof(struct drm_amdgpu_fence),
-			GFP_KERNEL);
-	if (fences == NULL)
-		return -ENOMEM;
-
-	fences_user = u64_to_user_ptr(wait->in.fences);
-	if (copy_from_user(fences, fences_user,
-		sizeof(struct drm_amdgpu_fence) * fence_count)) {
-		r = -EFAULT;
-		goto err_free_fences;
-	}
+	fences = memdup_array_user(u64_to_user_ptr(wait->in.fences),
+				   wait->in.fence_count,
+				   sizeof(struct drm_amdgpu_fence));
+	if (IS_ERR(fences))
+		return PTR_ERR(fences);
 
 	if (wait->in.wait_all)
 		r = amdgpu_cs_wait_all_fences(adev, filp, wait, fences);
 	else
 		r = amdgpu_cs_wait_any_fence(adev, filp, wait, fences);
 
-err_free_fences:
 	kfree(fences);
 
 	return r;
-- 
2.51.0



