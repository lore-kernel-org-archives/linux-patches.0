Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D0719753F;
	Wed,  2 Oct 2024 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875821; cv=none; b=thM6VaNnNQWZJI2HC8q0daHzH90BP9LBmGuGWqDH1LiZSyOudOFcMzE2TkERq8xhkYLRnwLy4oGj459g0WUNC7oR/YflBBbWsfwlvzHH9KOqK2ZkdnpAhMj1I+z1/J0bGWkI8aNejJp+YB/tRanRVKk0TRCD727XjirqUAT+Dc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875821; c=relaxed/simple;
	bh=y5TsWEq3F1jHQjlBkiANuvIb6JdklkEghvI8h93y7bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8uluruIk+qk6CVqt6MxBt78Xit4KVDeZZ8050MuEOp1okZmTMH44QZiPJxbpylNv3qbd88CWAZxaGvIhxhzbkbN6zQd+yKtJMlGueICgc5O5RCIwk6+otIb/N/ptWC3mAr1RcW+3jDPDX/Ul1+bvWRMVYclKCmCtmdh3uNJnSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sg/B+Hqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg/B+Hqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F22C4CEC5;
	Wed,  2 Oct 2024 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875821;
	bh=y5TsWEq3F1jHQjlBkiANuvIb6JdklkEghvI8h93y7bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sg/B+HqjOKsUCoAAI1MeBunHDkCN3U95Ade4JUIhJcya6qa+w495MPMOIizAWXec4
	 Tc20+qr6kMcHQAwi/xT0HYVxUgaaZZ1HjwAl0QHTmlX7l4a6KPJdy8Sy2XTTJCPEVH
	 tHLy0obpprZOrWPii0+tu8Ol+vc5eNUJnrbeavBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Lypak <vladimir.lypak@gmail.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 233/695] drm/msm/a5xx: workaround early ring-buffer emptiness check
Date: Wed,  2 Oct 2024 14:53:51 +0200
Message-ID: <20241002125831.751215000@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Lypak <vladimir.lypak@gmail.com>

[ Upstream commit a30f9f65b5ac82d4390548c32ed9c7f05de7ddf5 ]

There is another cause for soft lock-up of GPU in empty ring-buffer:
race between GPU executing last commands and CPU checking ring for
emptiness. On GPU side IRQ for retire is triggered by CACHE_FLUSH_TS
event and RPTR shadow (which is used to check ring emptiness) is updated
a bit later from CP_CONTEXT_SWITCH_YIELD. Thus if GPU is executing its
last commands slow enough or we check that ring too fast we will miss a
chance to trigger switch to lower priority ring because current ring isn't
empty just yet. This can escalate to lock-up situation described in
previous patch.
To work-around this issue we keep track of last submit sequence number
for each ring and compare it with one written to memptrs from GPU during
execution of CACHE_FLUSH_TS event.

Fixes: b1fc2839d2f9 ("drm/msm: Implement preemption for A5XX targets")
Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/612047/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c     | 4 ++++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.h     | 1 +
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c | 4 ++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 6c80d3003966b..7cfefb5e62218 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -65,6 +65,8 @@ void a5xx_flush(struct msm_gpu *gpu, struct msm_ringbuffer *ring,
 
 static void a5xx_submit_in_rb(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 {
+	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	struct a5xx_gpu *a5xx_gpu = to_a5xx_gpu(adreno_gpu);
 	struct msm_ringbuffer *ring = submit->ring;
 	struct drm_gem_object *obj;
 	uint32_t *ptr, dwords;
@@ -109,6 +111,7 @@ static void a5xx_submit_in_rb(struct msm_gpu *gpu, struct msm_gem_submit *submit
 		}
 	}
 
+	a5xx_gpu->last_seqno[ring->id] = submit->seqno;
 	a5xx_flush(gpu, ring, true);
 	a5xx_preempt_trigger(gpu);
 
@@ -210,6 +213,7 @@ static void a5xx_submit(struct msm_gpu *gpu, struct msm_gem_submit *submit)
 	/* Write the fence to the scratch register */
 	OUT_PKT4(ring, REG_A5XX_CP_SCRATCH_REG(2), 1);
 	OUT_RING(ring, submit->seqno);
+	a5xx_gpu->last_seqno[ring->id] = submit->seqno;
 
 	/*
 	 * Execute a CACHE_FLUSH_TS event. This will ensure that the
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.h b/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
index b4d06ca3e499d..9c0d701fe4b85 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
@@ -34,6 +34,7 @@ struct a5xx_gpu {
 	struct drm_gem_object *preempt_counters_bo[MSM_GPU_MAX_RINGS];
 	struct a5xx_preempt_record *preempt[MSM_GPU_MAX_RINGS];
 	uint64_t preempt_iova[MSM_GPU_MAX_RINGS];
+	uint32_t last_seqno[MSM_GPU_MAX_RINGS];
 
 	atomic_t preempt_state;
 	spinlock_t preempt_start_lock;
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
index c65b34a4a8cc2..0469fea550108 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -55,6 +55,8 @@ static inline void update_wptr(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
 /* Return the highest priority ringbuffer with something in it */
 static struct msm_ringbuffer *get_next_ring(struct msm_gpu *gpu)
 {
+	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	struct a5xx_gpu *a5xx_gpu = to_a5xx_gpu(adreno_gpu);
 	unsigned long flags;
 	int i;
 
@@ -64,6 +66,8 @@ static struct msm_ringbuffer *get_next_ring(struct msm_gpu *gpu)
 
 		spin_lock_irqsave(&ring->preempt_lock, flags);
 		empty = (get_wptr(ring) == gpu->funcs->get_rptr(gpu, ring));
+		if (!empty && ring == a5xx_gpu->cur_ring)
+			empty = ring->memptrs->fence == a5xx_gpu->last_seqno[i];
 		spin_unlock_irqrestore(&ring->preempt_lock, flags);
 
 		if (!empty)
-- 
2.43.0



