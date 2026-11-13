Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585397;
	b=fFWhqjNdTMvWKaWFEb3Tdqu0t83x4OPbdYRFuEYDockAlOEdBDbK/KuRGMGz18+l3yym
	 4NhpbV1PluKGDvKV2axhhizK+a9daVeY7xoe+7Mz/9omFfMo7oId/rmc1bLQ5mLTbLKgA
	 lcjfwVQpUsthKHTZa9l6OnNVZmJLd9OLSRZsOy9gwMl7XEP3jRHKVyU5Dd8hEffwDnM2T
	 gNHMt/86/Klct2jwE9YXRY74E31H3L2l93aglAy1TSfwG/1bSuiYd3HgjAR/ctVoBy/HS
	 T5jG6SEijzQ1kTspOYTkkxABC5JhSYmy0cGeV3HkzTEPmdv6+Do/mPrdedscPN9FEVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Aqo1V+FmBHuxmCZso9ZtqxTjjAgGBSGIncS9ODHetoE=;
	b=lMKneCkfHW4V7nVMyairt2GXEZgAe07z4OfuW+izksbgQEAX9t5SW332C0YoOr4OXgJ+
	 SosTA3zUBGKOcdoU7/dDm7xalBUHBaIwPj2EjsILUc+8ONdVBpCKiubqMEKrgC6EtZ40f
	 GY5whSdCEYVEnpTco8kkNFYl0mBtOkqV7gLUpOTkmkmyqyRcehA9sbydGmgu7pOdC+BRz
	 OCjE5BoEcM0hke5w+ChFLoMjLuZH4t/efD3ZyLKypGVpNiLToHbmsFjKgoSuAKsw6+kbq
	 c/FBUoLg/uoBLdiJx/SG+A2BXKAzpKEc8UnkD+9R7FasCP7ETjL1SIBNA2yZvCkuaZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTLA+auW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABA1606A882;
	Fri, 13 Nov 2026 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oTLA+auW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D241F000C7;
	Fri, 13 Nov 2026 15:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585397;
	bh=Aqo1V+FmBHuxmCZso9ZtqxTjjAgGBSGIncS9ODHetoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oTLA+auWVlpniRcsC67IWVv5eTgq/DEZUl1M58VV/f9XxuaaUgYv8JULXgY/MIcJD
	 c48aQ+i4fosB5JeHCBxBx9Kwq+kApncTU3x2LVzSx4eRXrE3bhs9MWpfEdt/WtCak5
	 Fi0bXoZtvCKEwgVwiZiiP9W24QExBCKPmyT9CCqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 068/507] drm/vc4: Publish the output fence outside of job_lock
Date: Fri, 13 Nov 2026 10:46:12 -0500
Message-ID: <20261113153755.866892630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 9ee552a42c3905b4547e83173d46413137ec329a ]

job_lock is taken by the V3D interrupt handler, so nesting an IRQ-unsafe
lock under it creates an inversion. drm_syncobj_replace_fence() takes
drm_syncobj::lock, which other paths acquire with interrupts enabled. For
example, a thread interrupted while holding it blocks the handler on
job_lock, and the handler can only make progress once the submit path
releases job_lock, which it cannot do while waiting for drm_syncobj::lock.

This is reported by lockdep:

[  188.139076] ========================================================
[  188.139086] WARNING: possible irq lock inversion dependency detected
[  188.139096] 7.3.0-rc3-00067-gc4f3feeaf60f #67 Tainted: G         C
[  188.139108] --------------------------------------------------------
[  188.139116] swapper/0/0 just changed the state of lock:
[  188.139125] ffff0000054f8ff8 (&vc4->job_lock){-...}-{3:3}, at: vc4_irq+0xa8/0x28c [vc4]
[  188.139234] but this lock took another, HARDIRQ-unsafe lock in the past:
[  188.139242]  (&syncobj->lock){+.+.}-{3:3}
[  188.139256] and interrupts could create inverse lock ordering between them.
[  188.139267] other info that might help us debug this:
[  188.139275]  Possible interrupt unsafe locking scenario:
[  188.139284]        CPU0                    CPU1
[  188.139291]        ----                    ----
[  188.139299]   lock(&syncobj->lock);
[  188.139312]                                local_irq_disable();
[  188.139320]                                lock(&vc4->job_lock);
[  188.139335]                                lock(&syncobj->lock);
[  188.139350]   <Interrupt>
[  188.139358]     lock(&vc4->job_lock);
[  188.139372] *** DEADLOCK ***

Hand the fence over after job_lock is dropped. The job can complete and
drop exec->fence in that window, so take a reference first and publish
through the local pointer, as exec may already be gone.

Cc: stable@vger.kernel.org
Fixes: e84fcb95e074 ("drm/vc4: Export fence through syncobj")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20261004-vc4-misc-fixes-v1-1-b763df9e33e1@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 6ee4bd77d4331..f4be154d4eb0c 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -639,8 +639,11 @@ vc4_queue_submit(struct drm_device *dev, struct vc4_exec_info *exec,
 	fence->seqno = exec->seqno;
 	exec->fence = &fence->base;
 
+	/* The job can complete and drop exec->fence as soon as job_lock is
+	 * released, so hold our own reference.
+	 */
 	if (out_sync)
-		drm_syncobj_replace_fence(out_sync, exec->fence);
+		dma_fence_get(&fence->base);
 
 	vc4_attach_fences(exec);
 
@@ -662,6 +665,11 @@ vc4_queue_submit(struct drm_device *dev, struct vc4_exec_info *exec,
 
 	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 
+	if (out_sync) {
+		drm_syncobj_replace_fence(out_sync, &fence->base);
+		dma_fence_put(&fence->base);
+	}
+
 	return 0;
 }
 
-- 
2.53.0



