Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787F13BFE34;
	Sat, 17 Oct 2026 17:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258879; cv=none; b=CEOcc0fAnXE2ywG0lB+gJ8O+xjIsJEduWmZQS9SOeFMnDZvNzGc1VOeHzRwd2BuT+Kt5lc8ZkzxrQkLEwW7v0QOy6XQD0lro9RR84YagGlgVlDDz1GE7NxJBZiL332dAsmYFpjxj1W4b+YNFemoqKfpmu6ki4eL6SzSTjr8LLGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258879; c=relaxed/simple;
	bh=IxjKolcIGz/Nf227cgMaf0XvXShVZxwxP+pQy9VgsOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fl5rdfa3gRPeqsZuph5U5YEWeAQ0xcaxQoehDPm2ShcJ+j30dmWe/hG/eHyg8D3Y3Q0ylvH1uxemDtrQ/9xmG0KHS+/DzCniZu1ShJI1CIIJ3/fW0u9+nmUKqP5WwTbSBiUzSTTv7UVMT3G6Kat6AFEdogWfSpvh1Nsal5IeUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhkTRd2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhkTRd2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926291F000C4;
	Sat, 17 Oct 2026 17:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258878;
	bh=yF7g2Sz2+RdljPxkg6Kg8K+3OCu82+dWgGUVOI+ixr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhkTRd2Nh6VDtsYztu+RK64nkQc2nzKy939+VE6yUuQE8sss2nbAPdxF+IDZKCwVr
	 WBrhl0DGOEdBAwHV0nFo9B+r68n0AVUo0R3aVILlWHdUdyXVzkAOzhE+2RHeihZyly
	 2VrwRGc5HlLw+CAE0Nod+WZ3R3uvLVycnXFfPRKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1030/1674] drm/msm: always recover the gpu
Date: Sat, 17 Oct 2026 17:55:02 +0200
Message-ID: <20261017160457.572786327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a7541597d0ce..c2c8138909779 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -418,25 +418,23 @@ static void recover_worker(struct kthread_work *work)
 		msm_update_fence(ring->fctx, fence);
 	}
 
-	if (msm_gpu_active(gpu)) {
-		/* retire completed submits, plus the one that hung: */
-		retire_submits(gpu);
+	/* retire completed submits, plus the one that hung: */
+	retire_submits(gpu);
 
-		gpu->funcs->recover(gpu);
+	gpu->funcs->recover(gpu);
 
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



