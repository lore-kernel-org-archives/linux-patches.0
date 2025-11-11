Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C025C818;
	Tue, 11 Nov 2025 01:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825073; cv=none; b=tEW5jf8HJUWjjM9MrG9JSiZnIsoKETJGhd0E7t6GzKi+1R0qH60RR+4MWdUHxeiLt5lobH5t/7n1rhV4btuBwc1zQVbrz/arcUI8Q8r4QTQ5M5/K/RfBHklZMVbGl+M1xzmMffwIG0N/JpY3Bf9NYOq73j9uUJwJnGucH2oJTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825073; c=relaxed/simple;
	bh=VYqycBdqapcDzeKa1OjB0GVw2RU4o1CywwGGGTKfrP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FiJC+ntVZh1QoOmuUlUsbYb6dxUZIm4tynlfcg0lR/MfzPgGfKdKhcfiGcm83GI+PfM3qkj61DsLcZ3dTWOMv6lIy14oXy/3oqdXnM+RQwQE8zcbRpB82knaLAOXaXQEqk3CD3+ol40hMfB7HVPiYqPvsDNcJYHyQCrgP1dcHFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDXmllyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDXmllyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E70BC4CEFB;
	Tue, 11 Nov 2025 01:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825072;
	bh=VYqycBdqapcDzeKa1OjB0GVw2RU4o1CywwGGGTKfrP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDXmllykxcN4ECZ9WzMjesN+LtFDy4ctuk9up1hmfXwnQX1O0VQUs9FTbbiFUqw9m
	 tzhiiOg6olypRT0bVURjHtW23Nd16YTQO9wOD+qMJCtJO5pPY+mhcenfAn7h/HzUOs
	 kYm/CYMTS0rwd0oHP+FCfCPpDIkj2ysG/A6B0Jxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 648/849] drm/amdgpu: Fix fence signaling race condition in userqueue
Date: Tue, 11 Nov 2025 09:43:38 +0900
Message-ID: <20251111004552.092495816@linuxfoundation.org>
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

From: Jesse.Zhang <Jesse.Zhang@amd.com>

[ Upstream commit b8ae2640f9acd4f411c9227d2493755d03fe440a ]

This commit fixes a potential race condition in the userqueue fence
signaling mechanism by replacing dma_fence_is_signaled_locked() with
dma_fence_is_signaled().

The issue occurred because:
1. dma_fence_is_signaled_locked() should only be used when holding
   the fence's individual lock, not just the fence list lock
2. Using the locked variant without the proper fence lock could lead
   to double-signaling scenarios:
   - Hardware completion signals the fence
   - Software path also tries to signal the same fence

By using dma_fence_is_signaled() instead, we properly handle the
locking hierarchy and avoid the race condition while still maintaining
the necessary synchronization through the fence_list_lock.

v2: drop the comment (Christian)

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index c2a983ff23c95..b372baae39797 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -276,7 +276,7 @@ static int amdgpu_userq_fence_create(struct amdgpu_usermode_queue *userq,
 
 	/* Check if hardware has already processed the job */
 	spin_lock_irqsave(&fence_drv->fence_list_lock, flags);
-	if (!dma_fence_is_signaled_locked(fence))
+	if (!dma_fence_is_signaled(fence))
 		list_add_tail(&userq_fence->link, &fence_drv->fences);
 	else
 		dma_fence_put(fence);
-- 
2.51.0



