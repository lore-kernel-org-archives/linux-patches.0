Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10F7350A0D;
	Tue, 21 Oct 2025 20:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077449; cv=none; b=ViOdI/CKNMW6xJBfZr/TECl6qHrwbAnZVJQWLxlg202+GA2JWmULiI5qiVGTbzphkIjU1sbiRArZIGqBfpwF8XBaLamBtl2GFN89NJuzaR5nYmEPVU4XA57TC2RZI4dG7O18VRJf7Q2bO9szu+PbUkJ/PBqHLV9AExZjTv8mno0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077449; c=relaxed/simple;
	bh=qeraax/UNPw0dBEbMkOoJsXSnCSZNJHQZMIjp+hmvSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=THi3p1Aeofuwx7A2OO4NYPBC2qZj2gbtWKUtM/SXeKnJqN1jdtMB6SSgFic80GBPKtvk1DZUeMT75w0svcqNg2sqM4025ivZ2wcFH6bD8b7Xa4xQBtr3glhKvZf380vkmROY3oYUNjt6gA7f2P0zEGwsBOE11/qB9gY5NdZv9/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5xdiu4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5xdiu4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF91C4CEF7;
	Tue, 21 Oct 2025 20:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077449;
	bh=qeraax/UNPw0dBEbMkOoJsXSnCSZNJHQZMIjp+hmvSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5xdiu4AW0C648/NpP0pETDtCc62LCGujdwixuzM+7P3UvqHjYtCHai1S19u7keyF
	 zNQ/IBlAqRwN4scuZ0aS1wwW9NakdD4wEnKjF0wpf+gHjpcAXATHLpYhQRXzHZZ8kW
	 Yj/MCHgRY2F65dguTkfVZOjB6cDbnFvsisf0W0oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 109/159] drm/amdgpu: set an error on all fences from a bad context
Date: Tue, 21 Oct 2025 21:51:26 +0200
Message-ID: <20251021195045.794566682@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ff780f4f80323148d43198f2052c14160c8428d3 ]

When we backup ring contents to reemit after a queue reset,
we don't backup ring contents from the bad context.  When
we signal the fences, we should set an error on those
fences as well.

v2: misc cleanups
v3: add locking for fence error, fix comment (Christian)
v4: fix wrap around, locking (Christian)

Fixes: 77cc0da39c7c ("drm/amdgpu: track ring state associated with a fence")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 39 ++++++++++++++++++++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c  |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h  |  2 +-
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index bb17af79c24a6..9f79f0cc5ff83 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -759,11 +759,42 @@ void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring)
  * @fence: fence of the ring to signal
  *
  */
-void amdgpu_fence_driver_guilty_force_completion(struct amdgpu_fence *fence)
+void amdgpu_fence_driver_guilty_force_completion(struct amdgpu_fence *af)
 {
-	dma_fence_set_error(&fence->base, -ETIME);
-	amdgpu_fence_write(fence->ring, fence->seq);
-	amdgpu_fence_process(fence->ring);
+	struct dma_fence *unprocessed;
+	struct dma_fence __rcu **ptr;
+	struct amdgpu_fence *fence;
+	struct amdgpu_ring *ring = af->ring;
+	unsigned long flags;
+	u32 seq, last_seq;
+
+	last_seq = amdgpu_fence_read(ring) & ring->fence_drv.num_fences_mask;
+	seq = ring->fence_drv.sync_seq & ring->fence_drv.num_fences_mask;
+
+	/* mark all fences from the guilty context with an error */
+	spin_lock_irqsave(&ring->fence_drv.lock, flags);
+	do {
+		last_seq++;
+		last_seq &= ring->fence_drv.num_fences_mask;
+
+		ptr = &ring->fence_drv.fences[last_seq];
+		rcu_read_lock();
+		unprocessed = rcu_dereference(*ptr);
+
+		if (unprocessed && !dma_fence_is_signaled_locked(unprocessed)) {
+			fence = container_of(unprocessed, struct amdgpu_fence, base);
+
+			if (fence == af)
+				dma_fence_set_error(&fence->base, -ETIME);
+			else if (fence->context == af->context)
+				dma_fence_set_error(&fence->base, -ECANCELED);
+		}
+		rcu_read_unlock();
+	} while (last_seq != seq);
+	spin_unlock_irqrestore(&ring->fence_drv.lock, flags);
+	/* signal the guilty fence */
+	amdgpu_fence_write(ring, af->seq);
+	amdgpu_fence_process(ring);
 }
 
 void amdgpu_fence_save_wptr(struct dma_fence *fence)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 8f6ce948c6841..5ec5c3ff22bb0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -811,7 +811,7 @@ int amdgpu_ring_reset_helper_end(struct amdgpu_ring *ring,
 	if (r)
 		return r;
 
-	/* signal the fence of the bad job */
+	/* signal the guilty fence and set an error on all fences from the context */
 	if (guilty_fence)
 		amdgpu_fence_driver_guilty_force_completion(guilty_fence);
 	/* Re-emit the non-guilty commands */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
index 12783ea3ba0f1..869b486168f3e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -155,7 +155,7 @@ extern const struct drm_sched_backend_ops amdgpu_sched_ops;
 void amdgpu_fence_driver_clear_job_fences(struct amdgpu_ring *ring);
 void amdgpu_fence_driver_set_error(struct amdgpu_ring *ring, int error);
 void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring);
-void amdgpu_fence_driver_guilty_force_completion(struct amdgpu_fence *fence);
+void amdgpu_fence_driver_guilty_force_completion(struct amdgpu_fence *af);
 void amdgpu_fence_save_wptr(struct dma_fence *fence);
 
 int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring);
-- 
2.51.0



