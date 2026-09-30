Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A551DE1B;
	Wed, 30 Sep 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789469; cv=none; b=JGLg4SNhCfGtpLruFSbhu7XOoE9KeRSzeErkyVz6m1vwUS5Q9C4S0i9gMZVYQOg5YifjXTvS9CZXb59Nfwk1Px3ksL65neicglnGlkxdFSy9OziwEGkkgQNi9kKXi8H+1EZpV9ZnKF78Ok56yYNv7KXLeX8KmdNxJehs/QTc5Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789469; c=relaxed/simple;
	bh=d3iZD/8Qzzip9AKL+HOuf1YNeU/jTReVq8nyoC7ihSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKs3cVwFLwSwn2wChyETRUTAO7jmv9A+Ltk4XbL0lqD0z9M0uFStBGKJpslDWCQopFuk3dIhVWVUDQXTd8nWYLwyopJ9zxOvjyip4WV/JDCNVmd2T5JPw4HeP3Xg1jdRNLKZGu6jBYOahBfs+i3nPftm5LX1tL+8R0/3WTp9f3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wccqMRH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wccqMRH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599AF1F000FF;
	Wed, 30 Sep 2026 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789467;
	bh=JuOySuJ1thvyosSieUGeJIUPrnZJ3D8r5PluWN1mf1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wccqMRH0Ny2O+gi4QkJj738d66i1MWTFU6fz5GEzWZVp0++WP+DpGBZv6GmCabK5P
	 OrLIqBjYfVBCCjjnSLzKvStsZNKaK2DmWNdMk4nQp97Ru4OS4faQ9Hhng5VMikTLVr
	 XZCSmOEEOQ3paubqyOSnIB5ckOGm+mAw90pcNAFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 486/877] drm/amdgpu: Fix vmid_wait fence leak in amdgpu_ring_init()
Date: Wed, 30 Sep 2026 17:23:17 +0200
Message-ID: <20260930152425.151222580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit aea841bc62a76242396610d22d8ff40c13065f64 upstream.

amdgpu_ring_init() initializes ring->vmid_wait with a reference to the
stub fence taken via dma_fence_get_stub().  When a later step of the
initialization fails, e.g. amdgpu_fence_driver_init_ring(), a writeback
slot allocation or the ring buffer allocation, the function returns an
error without releasing the stub fence reference and the reference is
leaked if the ring is torn down without amdgpu_ring_fini().

Move the stub fence assignment to the end of the initialization, right
before the ring is registered with the GPU scheduler, where no further
failure is possible.  The stub fence is only consumed by command
submission handling in amdgpu_ids.c once the ring is up and running, so
nothing reads it during the error-prone part of the initialization.

Fixes: 48e9fbd1a284 ("drm/amdgpu: initialize the vmid_wait with the stub fence")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f2b96986851203e9c50ca0d13aaa3581ca3e8ebd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -226,7 +226,6 @@ int amdgpu_ring_init(struct amdgpu_devic
 		ring->adev = adev;
 		ring->num_hw_submission = sched_hw_submission;
 		ring->sched_score = sched_score;
-		ring->vmid_wait = dma_fence_get_stub();
 
 		if (!ring->is_mes_queue) {
 			ring->idx = adev->num_rings++;
@@ -355,6 +354,7 @@ int amdgpu_ring_init(struct amdgpu_devic
 
 	ring->max_dw = max_dw;
 	ring->hw_prio = hw_prio;
+	ring->vmid_wait = dma_fence_get_stub();
 
 	if (!ring->no_scheduler && ring->funcs->type < AMDGPU_HW_IP_NUM) {
 		hw_ip = ring->funcs->type;


