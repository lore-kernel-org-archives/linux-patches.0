Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAF8523781;
	Wed,  9 Sep 2026 13:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962051; cv=none; b=fLdAYQCdosjvrfqCBsPzrCqQsEX1D8eA3Y6SIWqKf+5nuOxq8jHfYK/zGLtA1IMrudQV4L/yTlD6I/k6lzPdjO2wjlrSPWvNqXv2lBroVrnfXs5Xh8JJ2TYli7qNbORpNvkBj4ditetFTZbupYk0bcDC6/aq/o0RuRdD7haCTqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962051; c=relaxed/simple;
	bh=k6BoVdT2NDeGmF0l2kruarvKpfi2X2HJxZ+fejfy/z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUml703bKcy08AiFAcdGV/FF2uBxXCZAtb/jIOkwbqJvJy8RMsKsLvweFYjq4UTyA3RHQNb5zepjnrfV7S+3CjIUgeCdkTX/7spPhNbkUHug+1lNTesK3+Nt3oXr4auYM3yzMA3eAh3V4CV0LJ/78NzS8QuSE0vwqoxJPyAzGVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJz8TO3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJz8TO3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0661F00A3A;
	Wed,  9 Sep 2026 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962050;
	bh=tRqod7fQS/LPA+sF3flkvPkywEkQfju6spaKxJteAEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJz8TO3DFz0f/qHKz+a/jZcUCmMyhVs1Tq3PYgPF3p55znMfEwT3RPt8zi0cV/geQ
	 GPhPKAII85SRl+Ede2x9AFyl8L+K3+Qep6UshA+MQNIPE0JiCfA/WTYu1MIUCJXnQY
	 oUA0omgTlYBFkgj0sTFh56DvdOwHNEBb6dnGaf/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 155/556] accel/ethosu: fix job completion fence cleanup
Date: Wed,  9 Sep 2026 15:37:15 +0200
Message-ID: <20260909134235.887854280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

commit 2d2a3adc91950f9a18829dadc7317fb5180a15c5 upstream.

ethosu_ioctl_submit_job() allocates done_fence before validating buffer
handles. Errors after allocation call ethosu_job_err_cleanup(), which frees
the job but leaks the uninitialized fence.

A scheduler dependency error also lets ethosu_job_run() return before
dma_fence_init(). Normal cleanup then passes a zeroed refcount to
dma_fence_put().

Release done_fence in the common cleanup path and use
dma_fence_was_initialized() to distinguish initialized fences from raw
allocations.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260716065219.931088-1-zhaoguohan@kylinos.cn?part=1
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Link: https://patch.msgid.link/20260717061145.1478139-6-zhaoguohan@kylinos.cn
[robh: also fix goto]
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ethosu/ethosu_job.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/ethosu/ethosu_job.c b/drivers/accel/ethosu/ethosu_job.c
index 1e2465279aae..1e4b65f62933 100644
--- a/drivers/accel/ethosu/ethosu_job.c
+++ b/drivers/accel/ethosu/ethosu_job.c
@@ -152,6 +152,13 @@ static void ethosu_job_err_cleanup(struct ethosu_job *job)
 
 	drm_gem_object_put(job->cmd_bo);
 
+	if (job->done_fence) {
+		if (dma_fence_was_initialized(job->done_fence))
+			dma_fence_put(job->done_fence);
+		else
+			dma_fence_free(job->done_fence);
+	}
+
 	kfree(job);
 }
 
@@ -162,7 +169,6 @@ static void ethosu_job_cleanup(struct kref *ref)
 
 	pm_runtime_put_autosuspend(job->dev->base.dev);
 
-	dma_fence_put(job->done_fence);
 	dma_fence_put(job->inference_done_fence);
 
 	ethosu_job_err_cleanup(job);
@@ -393,7 +399,7 @@ static int ethosu_ioctl_submit_job(struct drm_device *dev, struct drm_file *file
 	ejob->done_fence = kzalloc_obj(*ejob->done_fence);
 	if (!ejob->done_fence) {
 		ret = -ENOMEM;
-		goto out_cleanup_job;
+		goto out_put_job;
 	}
 
 	ret = drm_sched_job_init(&ejob->base,
-- 
2.55.0



