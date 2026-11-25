Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625044;
	b=jop/gbI9EWuYRXRvAxp0UJjSOGMuz+sEI31mWIy7xfaBV2qe7i08nqXuUGI654/FUt2Y
	 4zs9tkI64QLzowF3bcmMmb3rZceriPXDBAp6Bq/aMw17fz5Qk+i8Vj/y0++AsghZXmkXf
	 ssXXUGGPDjqneRXSMtSsgjY58tUjzmHfB+W43dfqpjpOsM9pDxOsjYueE0/5ykEKnHhsj
	 bXF1j7z0jrTJTQY7RAwY63BBFt4ux9rzLsFJmQynMudYi1QlhzmCJkO3n6o60UNxoyGm5
	 GYapOA1liSBvedHRsEYk33y2VB61fZbydZ/aCdateI3hsVrun9JUDROvEDFFdP4xSSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yBbO8sr2b/80mKcqQkM4NtBfnexI7ixA0ybtHjGv/6w=;
	b=M7wtAQcfjL1AylcyS45LyW4m3KoCEhzE0sjjjjnck/JlB8+9rZao/bI0dhxx8td2PEW0
	 860mBvETMeSnbVd2mHah2t9+C2xJuFUPBZ9ZJWrk1SdDdjkk++IQywcFFDVlcJe/g75xI
	 +9U3yQZGOCWqhmneYTWVIXKGPnj+LTkgIv7tbmWdRGvMPBECeuIrpPZRnLC0Cb/BRJDfz
	 JYXfNuUGjC3dFgHqZxCRS95R4C3A/sV2sZO/StC/dgE34sYZgXM5dddbCfOp13tkIYKXN
	 GNJj5S6xGEzh/1i5GxHJRixDbJipoeHUKfL4Uu4VFDcSkdsPpaYMNFNYQtjeiQEuG1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZq5PAzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A29606A31E;
	Wed, 25 Nov 2026 16:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZq5PAzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4341F000C4;
	Wed, 25 Nov 2026 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625043;
	bh=yBbO8sr2b/80mKcqQkM4NtBfnexI7ixA0ybtHjGv/6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZq5PAzPESmnIAYEoYlvDJJB8jMdWgMCjIuxR3TaMuYChNXAn/J6/ylb5O2VNwF7S
	 lcaAQ1ViMRWScTcHXgFtuirJcTKICN3Qm0SYK5/Se5BWe/elAAQmWMX1kvmqtSXx8a
	 NkhJKYA60hbfkquBlt9lImbYYaqx6JIs2bR8sAVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/816] drm/panthor: Revisit reqs_lock handling in flush/reset paths
Date: Wed, 25 Nov 2026 15:32:16 +0100
Message-ID: <20261125143858.183726497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Dropped the cache-flush tracepoint code and kept the older gpu_read()/gpu_write() register accessors while converting reqs_lock to scoped_guard. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 61 ++++++++++++---------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 038f59df38d95..7bb319664e8b6 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -384,34 +384,30 @@ int panthor_gpu_l2_power_on(struct panthor_device *ptdev)
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
@@ -431,27 +427,26 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
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



