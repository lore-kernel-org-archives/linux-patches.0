Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5660A30C639;
	Tue, 11 Nov 2025 01:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823332; cv=none; b=paDeUGR//K5feMZ0HkJwxeTRpQ/TszMHyF0oBXAHufzFIjD6xtp7epNcJL+pP5tB10wMyPEvcUllH0eS+YexPEG7K3XreTrmJxVMposCTgjishednZShH+qsrf9LmnRERAiokYCNbRIBVvVtnC1Mk+8AWPUj5ZcI5Repez94u2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823332; c=relaxed/simple;
	bh=6MTOrpLhNN2FewpT1IzX2LFNivcTjVheNR56ZyxZV0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg8hm8MU3ef1Os9OjLvOb/mK/Dh15yM9Sr8MMgWS/ojYF8P6B07rhbI7ZU2y/gwRvjcGA+0V2oc7qX3ZZC9H6F0tfejT681a2kkWW3y8oRJdLEjUB9o5KswpoboVAN+FixpizDaR038DNdqRR4YyxYvTXGFknO+xty1UzwobRY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STi6UwwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STi6UwwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0DEC4CEFB;
	Tue, 11 Nov 2025 01:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823331;
	bh=6MTOrpLhNN2FewpT1IzX2LFNivcTjVheNR56ZyxZV0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STi6UwwBJoCqndsioBWe9w6mXwJsnoIpQr6I1ins1X9tvdkO7YwekwNjYXgRLxANw
	 CQ5yQWE7q9Z2zBDQp9e9WxSSZ3ztI9IEUDGknvz+zrCLax2xOjATU4UQcuDDVps8t9
	 /Pxnjgtm9LdGue/T0enEDIS1iWXmi2TlS353wfBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Dennis Tsiang <dennis.tsiang@arm.com>,
	Karunika Choo <karunika.choo@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/565] drm/panthor: Serialize GPU cache flush operations
Date: Tue, 11 Nov 2025 09:41:17 +0900
Message-ID: <20251111004531.895566624@linuxfoundation.org>
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

From: Karunika Choo <karunika.choo@arm.com>

[ Upstream commit e322a4844811b54477b7072eb40dc9e402a1725d ]

In certain scenarios, it is possible for multiple cache flushes to be
requested before the previous one completes. This patch introduces the
cache_flush_lock mutex to serialize these operations and ensure that
any requested cache flushes are completed instead of dropped.

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Co-developed-by: Dennis Tsiang <dennis.tsiang@arm.com>
Signed-off-by: Dennis Tsiang <dennis.tsiang@arm.com>
Signed-off-by: Karunika Choo <karunika.choo@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250807162633.3666310-6-karunika.choo@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_gpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index 5251d8764e7d7..1ca2924e6d552 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -35,6 +35,9 @@ struct panthor_gpu {
 
 	/** @reqs_acked: GPU request wait queue. */
 	wait_queue_head_t reqs_acked;
+
+	/** @cache_flush_lock: Lock to serialize cache flushes */
+	struct mutex cache_flush_lock;
 };
 
 /**
@@ -201,6 +204,7 @@ int panthor_gpu_init(struct panthor_device *ptdev)
 
 	spin_lock_init(&gpu->reqs_lock);
 	init_waitqueue_head(&gpu->reqs_acked);
+	mutex_init(&gpu->cache_flush_lock);
 	ptdev->gpu = gpu;
 	panthor_gpu_init_info(ptdev);
 
@@ -383,6 +387,9 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 	bool timedout = false;
 	unsigned long flags;
 
+	/* Serialize cache flush operations. */
+	guard(mutex)(&ptdev->gpu->cache_flush_lock);
+
 	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
 	if (!drm_WARN_ON(&ptdev->base,
 			 ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
-- 
2.51.0



