Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574A5341AC5;
	Fri, 21 Nov 2025 13:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732762; cv=none; b=LqRcBfLv+VY67fP8YIH7fZKTq3YigKoXqaHntWMcCYmkmSUER1KqErFrZY5dyMPTnP+Ymq+TXPs6sfrzBXL/Cwk/uwSf1FWXrcr6Ggbc0TFnlxLskrnCvdcxJFZgmPQPr1YbrePkm+iqq5QUIq0zHBfWZlkfMvOOc560q1iS0rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732762; c=relaxed/simple;
	bh=ka/3wg+t3rnXbC+mQf0+XG9nRfaedVneH9nrT+YgsCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spo7mqQ+ikjzfCCHzEF3HYGxkVA0xb6Nwt3vjo3EdQsRW8E+fNcOJZmVbI0SixOZlFDB6jNJqWlnQHoJ1V36husCkyvlTQfwzV2vlBf5virPM2KiaOuPVIBWZQ5rR9SBoNakWqPmLjoRN4I9hKKqX69ptUXubUXNV2cAGWcHruk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ibb9Mmzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ibb9Mmzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC174C4CEF1;
	Fri, 21 Nov 2025 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732762;
	bh=ka/3wg+t3rnXbC+mQf0+XG9nRfaedVneH9nrT+YgsCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ibb9Mmzvky/l2GcK8XjmrJ0LMIIrQT+LfF5godcxKdVKCPKxTo+4/nP5Kr/y4QpBq
	 YxIVJK9heBiioRWwb4brFaPMOVAKmRfR95+qXZWcJ9VjB2/sG0dRIAGI3Li0rIs89l
	 8UATTccKzPWl/JXGOiZ0VHrWpD4PAxzG4x6icTzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/529] drm/amdgpu: Use memdup_array_user in amdgpu_cs_wait_fences_ioctl
Date: Fri, 21 Nov 2025 14:08:52 +0100
Message-ID: <20251121130239.309983075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 13c97ba7a820b..958034bc3b6d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1732,30 +1732,21 @@ int amdgpu_cs_wait_fences_ioctl(struct drm_device *dev, void *data,
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



