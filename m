Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AD23F9290;
	Fri, 15 May 2026 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862080; cv=none; b=ngbOsx/Cp7bPb63pO8BbIQ0M+R7rZn//kUuCnUlHCNlL/oNRT9NA9O6Bt6HfeD+VVNWZNCuiarMDeidYTwKM4iKp1Q8F+6H4xawkXlsNC0sCycSqdPDvGWTbWaVe8ABESawnyskLbwfORr2Gy5dIUUnplZ7LkBs+EOni8aGS3K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862080; c=relaxed/simple;
	bh=uueHRP6n8cly8IGqMiQlxedy4VJ1QhI3/1VTwFue3xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvqxU/PyElvFDdMbFOFk7+xxbRPD77vmUZf2D5T+ziXWI7ZNUlJ/rSWyaCKJFLYT9t+IYSnJAVM3FnqUowSUkjWSgahnFwTg6kzqMui1XW3XRUjOXKlYqx5xpGS2gGnbe41TycqItXLWc+3kofMMa02jOeCod/1tatMLQXeTgBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wa9yMkIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wa9yMkIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DA8C2BCB0;
	Fri, 15 May 2026 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862079;
	bh=uueHRP6n8cly8IGqMiQlxedy4VJ1QhI3/1VTwFue3xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa9yMkIf15TygqGqagpnXHQMkc6J/Tdjfl9wbdKjYQojxyJExhkWNy1VVLCyqoV6X
	 NcTr7sIrAwregRee+tfRDKlQUXFbogbTe/aWfnofAIAQmb4+RX7u87QcvJDowCvs/g
	 q0kA7uY4PhwHkz0xf1hkoQS0QKV7iSPevPpzeng8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Maniscalco <anna.maniscalco2000@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 099/188] drm/msm: always recover the gpu
Date: Fri, 15 May 2026 17:48:36 +0200
Message-ID: <20260515154659.478029476@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna Maniscalco <anna.maniscalco2000@gmail.com>

commit 01a0d6cd7032e9993feea19fadb03ef9d5b488f2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gpu.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -548,32 +548,30 @@ static void recover_worker(struct kthrea
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
-			list_for_each_entry(submit, &ring->submits, node) {
-				/*
-				 * If the submit uses an unusable vm make sure
-				 * we don't actually run it
-				 */
-				if (to_msm_vm(submit->vm)->unusable)
-					submit->nr_cmds = 0;
-				gpu->funcs->submit(gpu, submit);
-			}
-			spin_unlock_irqrestore(&ring->submit_lock, flags);
+		spin_lock_irqsave(&ring->submit_lock, flags);
+		list_for_each_entry(submit, &ring->submits, node) {
+			/*
+			 * If the submit uses an unusable vm make sure
+			 * we don't actually run it
+			 */
+			if (to_msm_vm(submit->vm)->unusable)
+				submit->nr_cmds = 0;
+			gpu->funcs->submit(gpu, submit);
 		}
+		spin_unlock_irqrestore(&ring->submit_lock, flags);
 	}
 
 	pm_runtime_put(&gpu->pdev->dev);


