Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622466;
	b=VhOO4WjZ0epi+5kxj5fQBWhPEQeefHzyqGLZkVbbW+6st97rhOuf69lrLLCppg4RdFl6
	 IUmo/eufL/UVTMEq0Mpv5R7gwvqd47TLhsJuD74zHsGonuXMANtuPS6PqkzLp5Bg/aInY
	 A6xTx5fWT5Prs6y3qu3lUH2hbmr1JGxtV1XfKzvVaxRPAa/JnS1Ub2/1YlVloXjR+89BT
	 3rqceuVEsgx2IDWwLjGK5y46h2iI+HlYJ2IJnEBQ52dwSGhWUTH7qX2pOUrNhIVMto+ur
	 hx4R/Zdo1CuChqXLx1Yw/OvRi8KuwAQD6xo1Dgj7x85Yx8EEYXRX5WRNTbSS5lK2ojA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ebsvlVhD0WiOJzzWV8my9To6ZENy9EY5tB5nmqb0ano=;
	b=sP3QD1oIowzHXuPwLqNBKE1okeRA/5zE2WcxPPaFTX1W16IgBWshj20fRHzs+Fw6QwcR
	 rO5l9HXh3lyVQCd5gGpTij9QCmnp1sEiD4lbd7PJ6/rZ28RZPLaN+8pLBWIBwRZs1BMCQ
	 WukTgqMCU94yyDcQA4TacqNR+kzItcbXylGSGtaufEKYiTTQrUjGQXgR2mbKnBAmEJnf3
	 acs00t9zF/AlBTeANHBFAhQF2e6UF963EEhYVWVv28qJGv6veWQ/EWQbfFF7o0/PDh9Xz
	 aemedd5ys4w7rx9/ug0JE/Xsj7bM2onW4DY9J3gBe/YVjSN89EGLhjKhID3KM+kFBQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCk8YTZy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FA3606A696;
	Wed, 25 Nov 2026 16:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCk8YTZy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ED91F000C4;
	Wed, 25 Nov 2026 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622465;
	bh=ebsvlVhD0WiOJzzWV8my9To6ZENy9EY5tB5nmqb0ano=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCk8YTZyffD55uGjxaDw7O5ouk7f0mr6CnlWvKhFDbL9cp2JyhAsDItJwzBFHZIBb
	 pPNwDsgKuCsEu0N8ncACC6nEU/TXE578ctXcww9pUyA2OBjTXYKTw6XO+wl6wpK+HB
	 x13W7UKTs3bLwbFfU/e9kl+c129Kj5KernXb8dZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 502/990] drm/panthor: Revisit reqs_lock handling in flush/reset paths
Date: Wed, 25 Nov 2026 15:31:09 +0100
Message-ID: <20261125143833.858541640@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 4fd08b3d1da78e33cb5939f0086e61f9d660cd6c ]

panthor_gpu_flush_caches() and panthor_gpu_soft_reset() acquire their
reqs_lock spinlock with the IRQ-disabling variants of the spinlocking
functions. This isn't necessary, as the lock is never taken from an
atomic context, as Panthor uses threaded interrupt handlers. The result
of this overly strict locking is that IRQs may be disabled more
frequently and for longer than they should be, resulting in increased
system latency.

Switch the locking to use non-IRQ-disabling scoped_guard statements for
locking. The wait_event_timeout read of pending_reqs outside of the
spinlock is fine as wait_event_timeout is a memory barrier according to
the Linux Memory Model.

Fixes: 5cd894e258c4 ("drm/panthor: Add the GPU logical block")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260812-panthor-cache-flush-fix-v4-2-751e32901898@collabora.com

[ sashal: Dropped the cache flush tracepoint calls, which this tree lacks. ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 61 ++++++++++++---------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 7f2dc65386fd4..6be62672a3be8 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -259,34 +259,30 @@ int panthor_gpu_l2_power_on(struct panthor_device *ptdev)
 int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 			     u32 l2, u32 lsc, u32 other)
 {
-	unsigned long flags;
 	int ret = 0;
 
 	/* Serialize cache flush operations. */
 	guard(mutex)(&ptdev->gpu->cache_flush_lock);
 
-	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-	if (!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
-		ptdev->gpu->pending_reqs |= GPU_IRQ_CLEAN_CACHES_COMPLETED;
-		gpu_write(ptdev, GPU_CMD, GPU_FLUSH_CACHES(l2, lsc, other));
-	} else {
-		ret = -EIO;
+	scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+		if (!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
+			ptdev->gpu->pending_reqs |= GPU_IRQ_CLEAN_CACHES_COMPLETED;
+			gpu_write(ptdev, GPU_CMD, GPU_FLUSH_CACHES(l2, lsc, other));
+		} else {
+			return -EIO;
+		}
 	}
-	spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
-
-	if (ret)
-		return ret;
 
 	if (!wait_event_timeout(ptdev->gpu->reqs_acked,
 				!(ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED),
 				msecs_to_jiffies(100))) {
-		spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-		if ((ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED) != 0 &&
-		    !(gpu_read(ptdev, GPU_INT_RAWSTAT) & GPU_IRQ_CLEAN_CACHES_COMPLETED))
-			ret = -ETIMEDOUT;
-		else
-			ptdev->gpu->pending_reqs &= ~GPU_IRQ_CLEAN_CACHES_COMPLETED;
-		spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
+		scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+			if ((ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED) != 0 &&
+			    !(gpu_read(ptdev, GPU_INT_RAWSTAT) & GPU_IRQ_CLEAN_CACHES_COMPLETED))
+				ret = -ETIMEDOUT;
+			else
+				ptdev->gpu->pending_reqs &= ~GPU_IRQ_CLEAN_CACHES_COMPLETED;
+		}
 	}
 
 	if (ret) {
@@ -306,27 +302,26 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 int panthor_gpu_soft_reset(struct panthor_device *ptdev)
 {
 	bool timedout = false;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-	if (!drm_WARN_ON(&ptdev->base,
-			 ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED)) {
-		ptdev->gpu->pending_reqs |= GPU_IRQ_RESET_COMPLETED;
-		gpu_write(ptdev, GPU_INT_CLEAR, GPU_IRQ_RESET_COMPLETED);
-		gpu_write(ptdev, GPU_CMD, GPU_SOFT_RESET);
+	scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+		if (!drm_WARN_ON(&ptdev->base,
+				ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED)) {
+			ptdev->gpu->pending_reqs |= GPU_IRQ_RESET_COMPLETED;
+			gpu_write(ptdev, GPU_INT_CLEAR, GPU_IRQ_RESET_COMPLETED);
+			gpu_write(ptdev, GPU_CMD, GPU_SOFT_RESET);
+		}
 	}
-	spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
 
 	if (!wait_event_timeout(ptdev->gpu->reqs_acked,
 				!(ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED),
 				msecs_to_jiffies(100))) {
-		spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
-		if ((ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED) != 0 &&
-		    !(gpu_read(ptdev, GPU_INT_RAWSTAT) & GPU_IRQ_RESET_COMPLETED))
-			timedout = true;
-		else
-			ptdev->gpu->pending_reqs &= ~GPU_IRQ_RESET_COMPLETED;
-		spin_unlock_irqrestore(&ptdev->gpu->reqs_lock, flags);
+		scoped_guard(spinlock, &ptdev->gpu->reqs_lock) {
+			if ((ptdev->gpu->pending_reqs & GPU_IRQ_RESET_COMPLETED) != 0 &&
+			    !(gpu_read(ptdev, GPU_INT_RAWSTAT) & GPU_IRQ_RESET_COMPLETED))
+				timedout = true;
+			else
+				ptdev->gpu->pending_reqs &= ~GPU_IRQ_RESET_COMPLETED;
+		}
 	}
 
 	if (timedout) {
-- 
2.53.0



