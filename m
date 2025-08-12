Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7B826FA77;
	Tue, 12 Aug 2025 19:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025876; cv=none; b=offwCT3575u7ZomLyGELDr4xg0Zkg1b2A8Y12fn3iBcpnI3xbQfg/f2Y8Dd5xUHF0pG6xht4K7rFj7tLIOW6rEJcfIHjJdcP5pMTFZ3gzwJwPBfxLuw0Hq5Q8fZl7T8IRbK8ZQm5BHR5B4YlRnRYZnr2MPsmvJDkZuyEJv4BRVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025876; c=relaxed/simple;
	bh=ynS/ax+GMZgS5utRd08vGC0pmkLuK/c5IUsfFHJjhPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEA3JEP0ItLv+VZh/8TxN1LWYZi1KD37MXOoZffS9dWwcLbpaI8omunDIHIWbR4pb8sRt5Cmwf/dxG2U7aeKpw/0WAXXhZod3F9IoZbJEm0Fut9q1iJqJ7ECFgMofIgf5F1BkuJ7vEzUxu+xieK3W0wj1HpaJ87rCz6bk17tdfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8QUWebw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8QUWebw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0097C4CEF0;
	Tue, 12 Aug 2025 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025876;
	bh=ynS/ax+GMZgS5utRd08vGC0pmkLuK/c5IUsfFHJjhPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8QUWebwKOsSL0TGQRGdfW4+c5omFydyloSRKi2RUXyQP2jxM/KUdWZLmwMtDdsBc
	 5ZRrVbAt22JK77Lh6OFfJ4pDagYTWWM+isL/utO9BIAv/MCPVgyoPWlFzEMkloZxDH
	 Fn/Jf5IPOq3Wh7soGFTAmkXXR1JXBAFrzxuKQyp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 170/480] drm/amdgpu/gfx10: fix kiq locking in KCQ reset
Date: Tue, 12 Aug 2025 19:46:18 +0200
Message-ID: <20250812174404.530370587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a4b2ba8f631d3e44b30b9b46ee290fbfe608b7d0 ]

The ring test needs to be inside the lock.

Fixes: 097af47d3cfb ("drm/amdgpu/gfx10: wait for reset done before remap")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jiadong Zhu <Jiadong.Zhu@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 2144d124c910..cd4605362a93 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -9567,9 +9567,8 @@ static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
 	kiq->pmf->kiq_unmap_queues(kiq_ring, ring, RESET_QUEUES,
 				   0, 0);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r)
 		return r;
 
@@ -9605,9 +9604,8 @@ static int gfx_v10_0_reset_kcq(struct amdgpu_ring *ring,
 	}
 	kiq->pmf->kiq_map_queues(kiq_ring, ring);
 	amdgpu_ring_commit(kiq_ring);
-	spin_unlock_irqrestore(&kiq->ring_lock, flags);
-
 	r = amdgpu_ring_test_ring(kiq_ring);
+	spin_unlock_irqrestore(&kiq->ring_lock, flags);
 	if (r)
 		return r;
 
-- 
2.39.5



