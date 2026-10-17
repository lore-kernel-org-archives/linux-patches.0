Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29C32248B3;
	Sat, 17 Oct 2026 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254189; cv=none; b=m6MFxN3IOUs8Znq4S44ZKUixUL2kV6EyKbdHjAt0X2Ge5RceWcl2XkFEno4xHuAs5uaUlKok7Z1UnDdX7Y2VECzYxqMIhHUyNfUuCx78hmFS6UrRz+kmHuvw5FvXRr6VwH0/gEr45seybcBZwwS/Qe/yiQwbRTB4vp72TOAAMFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254189; c=relaxed/simple;
	bh=rjwXLJzi4uGzOTkntTzu1SAPqzU7QR+UuX6ZIS00Lno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UycoQ7M8pOEjVu49YuvRX5mB4UYCsfLB1DS4rPfbVOKS/iDwMEPewf3pUmLT5jH4aKscFnp4m3vLsQwOQNExz/G79+aN5CHXK2PBc3F4GBw5BH3CUf+msHJjX9OsrWMlwssrp8y9KVgsunteReKAyQ6paq0RPNOXBxc66muGumU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKihvq8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKihvq8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47DD61F000C4;
	Sat, 17 Oct 2026 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254186;
	bh=ViN9ihhHMBhCdfRkguQ69Qe5Kn2u0lc8slCvH9BQ8Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKihvq8WXw/JVk3YPSDk+beaWTe1Y3lsShOgHcv7HtI3dxy1vKpIEMDe1IJWN6UZJ
	 bzf8DXgB5cKFvIyYz2hdgI+CkBEOKYmjXHt/8iWs7vihE0ljRvxmrn/ZKRSCbOMUuO
	 zWAjUCjCC1TvFUTSp1X79NSoyzxbeuGiUTGLFtMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/869] drm/msm: always recover the gpu
Date: Sat, 17 Oct 2026 17:52:58 +0200
Message-ID: <20261017160045.722154934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

[ Upstream commit 01a0d6cd7032e9993feea19fadb03ef9d5b488f2 ]

Previously, in case there was no more work to do, recover worker
wouldn't trigger recovery and would instead rely on the gpu going to
sleep and then resuming when more work is submitted.

Recover_worker will first increment the fence of the hung ring so, if
there's only one job submitted to a ring and that causes an hang, it
will early out.

There's no guarantee that the gpu will suspend and resume before more
work is submitted and if the gpu is in a hung state it will stay in that
state and probably trigger a timeout again.

Just stop checking and always recover the gpu.

Signed-off-by: Anna Maniscalco <anna.maniscalco2000@gmail.com>
Cc: stable@vger.kernel.org
Patchwork: https://patchwork.freedesktop.org/patch/704066/
Message-ID: <20260210-recovery_suspend_fix-v1-1-00ed9013da04@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index ffb91e45aefde..76b44bb8de0d3 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -421,25 +421,23 @@ static void recover_worker(struct kthread_work *work)
 		msm_update_fence(ring->fctx, fence);
 	}
 
-	if (msm_gpu_active(gpu)) {
-		gpu->funcs->recover(gpu);
+	gpu->funcs->recover(gpu);
 
-		/* retire completed submits, plus the one that hung: */
-		retire_submits(gpu);
+	/* retire completed submits, plus the one that hung: */
+	retire_submits(gpu);
 
-		/*
-		 * Replay all remaining submits starting with highest priority
-		 * ring
-		 */
-		for (i = 0; i < gpu->nr_rings; i++) {
-			struct msm_ringbuffer *ring = gpu->rb[i];
-			unsigned long flags;
+	/*
+	 * Replay all remaining submits starting with highest priority
+	 * ring
+	 */
+	for (i = 0; i < gpu->nr_rings; i++) {
+		struct msm_ringbuffer *ring = gpu->rb[i];
+		unsigned long flags;
 
-			spin_lock_irqsave(&ring->submit_lock, flags);
-			list_for_each_entry(submit, &ring->submits, node)
-				gpu->funcs->submit(gpu, submit);
-			spin_unlock_irqrestore(&ring->submit_lock, flags);
-		}
+		spin_lock_irqsave(&ring->submit_lock, flags);
+		list_for_each_entry(submit, &ring->submits, node)
+			gpu->funcs->submit(gpu, submit);
+		spin_unlock_irqrestore(&ring->submit_lock, flags);
 	}
 
 	pm_runtime_put(&gpu->pdev->dev);
-- 
2.53.0



