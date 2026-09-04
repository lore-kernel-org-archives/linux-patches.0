Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B7835AC03;
	Fri,  4 Sep 2026 05:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500984; cv=none; b=MJACJODSDhnJDzDDPO9Q6cGCO/5JfjD0hhdgx+OkSTSL136q3iwedgDc1HoaaQSMTb+cyYdNt9mz+c7xXFopc6q6PqDKCZHp4+2uOXMeVF+Z+52EJvPXDl0BH0LHdCaBhDd1lp+PoXltp0SfgijvgF7ozk5G9GxELrpUz+javLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500984; c=relaxed/simple;
	bh=Nt9QhZeZH+HrZh1b4gwJWWlPXPNuY5ts8a8URDU4V0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jK8TozGCjArMXDAlN5iiZ8+vUdp2k11LWr4SKGjvWctfAG0ARQisnIm5PNTemhDBgbMozg9cuNnQMHvKALwIHbTXxKQmUdVjVXe4fU6BtYu8QKc7bohbrk1swYystorSJ3WR3+P5OXv5QU8UPf9zGW+hktOPpl9HTTji6+3PzX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tD/thxX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tD/thxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D44D1F00A3D;
	Fri,  4 Sep 2026 05:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500983;
	bh=C6eUTHUI9f1I1JTe6/AqUlnwQgWY/kDDmATJ64VHNN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tD/thxXhJCRJ+nDDA7gbxixpISOh3NMejjRBPMqVTBOhHb+pJP+5JS+6jPEic9AI
	 sOqhaELEgG90aPW+VPvdFIiQd37EFnrmlflwX6Ivw7RORP69m9eq0z8pxn5WC+ervH
	 YpodFuGfYkNsRt9ms60y9BzB/i6wY0WjpqAc7hJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>
Subject: [PATCH 6.18 212/552] accel/rocket: Fix error path handling in rocket_job_run()
Date: Fri,  4 Sep 2026 06:56:09 +0200
Message-ID: <20260904045754.189190471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: ZhaoJinming <zhaojinming@uniontech.com>

commit 9b2dedadf6a91ac3fc9fae268bb556a041222711 upstream.

In rocket_job_run(), after taking an extra fence reference for
job->done_fence via dma_fence_get(), the error paths have three bugs:

- The dma_fence reference held by job->done_fence is never released,
  causing a reference leak.
- pm_runtime_get_sync() increments the usage counter even on failure,
  but the error path does not decrement it, leaking the runtime PM
  reference and preventing the NPU from suspending.
- A valid but unsignaled fence is returned to the DRM scheduler,
  which triggers WARN("Fence ... released with pending signals!")
  when the scheduler drops its reference.

Fix by replacing pm_runtime_get_sync() with pm_runtime_resume_and_get()
which auto-balances the usage counter on failure, releasing both fence
references on error, and returning ERR_PTR(ret) instead of the
unsignaled fence.

Cc: stable@vger.kernel.org
Fixes: 0810d5ad88a1 ("accel/rocket: Add job submission IOCTL")
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Link: https://lore.kernel.org/r/20260610071045.3414828-1-zhaojinming@uniontech.com
[tomeu: Refactored error paths to use consolidated goto labels]
Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/rocket/rocket_job.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/accel/rocket/rocket_job.c
+++ b/drivers/accel/rocket/rocket_job.c
@@ -317,13 +317,13 @@ static struct dma_fence *rocket_job_run(
 		dma_fence_put(job->done_fence);
 	job->done_fence = dma_fence_get(fence);
 
-	ret = pm_runtime_get_sync(core->dev);
+	ret = pm_runtime_resume_and_get(core->dev);
 	if (ret < 0)
-		return fence;
+		goto err_put_fences;
 
 	ret = iommu_attach_group(job->domain->domain, core->iommu_group);
 	if (ret < 0)
-		return fence;
+		goto err_put_pm;
 
 	scoped_guard(mutex, &core->job_lock) {
 		core->in_flight_job = job;
@@ -331,6 +331,14 @@ static struct dma_fence *rocket_job_run(
 	}
 
 	return fence;
+
+err_put_pm:
+	pm_runtime_put(core->dev);
+err_put_fences:
+	dma_fence_put(job->done_fence);
+	job->done_fence = NULL;
+	dma_fence_put(fence);
+	return ERR_PTR(ret);
 }
 
 static void rocket_job_handle_irq(struct rocket_core *core)


