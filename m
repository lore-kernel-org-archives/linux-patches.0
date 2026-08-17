Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFD33C3C08;
	Mon, 17 Aug 2026 13:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975178; cv=none; b=J0NA10tu9l8E+c4NEJRZneH741y/G1XR9cF7Xcpkn9nwF07xGW829D0vkBGfLGDoDlDGpfL5BQCtJ1CzoXYdt6s1X4Me5GAMoHNvRMY1j+pdj13G0i9RlQ/gomjsyUHkFMOJZLZvPNsh4y5E+Xps+rJrXTImWtmmoAlrVerU6KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975178; c=relaxed/simple;
	bh=dxpxkTwOw3bZr9s7c+QMkx5mkCSCXGwT55FzyPXQM5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzUxOsUuXchPn/Nx/ZQAdDf5yh2HLJjHAmbIf3zDdY2Y4bYRmQEQS9vt1fVOe7KN94MD25WOgKChQfYLOChAsC+plvpohmz+Vb4wN0DrADQTMDtFa1Ekxd2iG/D60UlqHZOzT9h3vD5PjXZOK1gDkVZX+P0gNE8pTAngx1MQaN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKyEgULl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKyEgULl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8341A1F00A3A;
	Mon, 17 Aug 2026 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975177;
	bh=TX1MsJCNtnS8CpaDrD5ijgFqiGMzU8gRp6hBBr9SBLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKyEgULlUOsGp69Ugd9zPkMY6+K69cUgT6VI5uF0tPSJWtbGa5VrxinidaL95FxdS
	 SahdtM+QQIfvNHL4Xnlv11RebsGFFVS81GP8n1xge3YprJRxuHq75wLLrzE0P8ncph
	 3DEFdfOzW/+0DixOtA20NnEePeQe3v+knQ2JswNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.18 188/250] drm/v3d: Serialize the scheduler timeout handlers
Date: Mon, 17 Aug 2026 15:32:29 +0200
Message-ID: <20260817132544.254877768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 4da94744707b27a3ae1197bdd7127da4505dc5b1 upstream.

V3D exposes several independent hardware queues (BIN, RENDER, TFU and
CSD) but has only a single, global reset. A timeout on any one queue
therefore has to stop, reset and restart the schedulers of every other
queue as well. That makes concurrent timeout handlers unsafe.

`reset_lock` was never able to make them safe, as a driver-side lock can
only cover the driver's &drm_sched_backend_ops.timedout_job callback.
The scheduler handles the timed out job and its pending list around that
callback, outside of the driver's control, so a global reset triggered
by one queue can still interfere with another queue that is in the
middle of handling a timeout of its own.

Consequently, if a reset happens in the CSD queue while a CL-intensive
application is running, the global reset stops and restarts the CL
queue's scheduler while that queue is handling a timeout of its own. As
drm_sched_stop() and drm_sched_start() subtract and add the credits of
every job sitting on the pending list of the scheduler they are called
on, and as the CL queue's handler concurrently takes its job off that
same list and puts it back, the stop and the start no longer see the
same set of jobs. The CL queue is left with more credits in flight than
its limit:

[  327.302739] ------------[ cut here ]------------
[  327.302744] WARNING: CPU: 2 PID: 43 at drivers/gpu/drm/scheduler/sched_main.c:102 drm_sched_run_job_work+0x238/0x4d0 [gpu_sched]
[  327.302884] CPU: 2 UID: 0 PID: 43 Comm: kworker/u16:1 Not tainted 6.18.39-v8-16k+ #3 PREEMPT
[  327.302889] Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
[  327.302893] Workqueue: v3d_bin drm_sched_run_job_work [gpu_sched]
[  327.302984] Call trace:
[  327.302987]  drm_sched_run_job_work+0x238/0x4d0 [gpu_sched] (P)
[  327.302997]  process_scheduled_works+0x180/0x3d0
[  327.303010]  worker_thread+0x268/0x3e8
[  327.303016]  kthread+0x140/0x250
[  327.303022]  ret_from_fork+0x10/0x20
[  327.303031] ---[ end trace 0000000000000000 ]---

>From that point on, the credit count of the CL queue is broken, causing
a complete GPU hang and UI freeze.

The DRM scheduler already provides a mechanism to serialize the timeout
handlers of different schedulers: an ordered workqueue passed as
drm_sched_init()'s @timeout_wq parameter. By default, each scheduler
queues its timeout work on the system workqueue, which runs the handlers
concurrently. Give all of the queues a shared ordered workqueue instead,
as recommended by the DRM scheduler documentation for hardware that has
distinct queues but resets globally.

Cc: stable@vger.kernel.org # 6.15
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260728-v3d-order-global-reset-v1-1-e47be838158d@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h   |    6 ++++++
 drivers/gpu/drm/v3d/v3d_sched.c |    9 ++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -179,6 +179,12 @@ struct v3d_dev {
 	 */
 	struct mutex reset_lock;
 
+	/* Ordered workqueue shared by every queue's scheduler timeout work.
+	 * V3D reset is global to all queues, so the timeout handlers must not
+	 * run concurrently.
+	 */
+	struct workqueue_struct *reset_wq;
+
 	/* Lock taken when creating and pushing the GPU scheduler
 	 * jobs, to keep the sched-fence seqnos in order.
 	 */
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -868,6 +868,7 @@ v3d_queue_sched_init(struct v3d_dev *v3d
 		.num_rqs = DRM_SCHED_PRIORITY_COUNT,
 		.credit_limit = 1,
 		.timeout = msecs_to_jiffies(500),
+		.timeout_wq = v3d->reset_wq,
 		.dev = v3d->drm.dev,
 	};
 
@@ -882,9 +883,13 @@ v3d_sched_init(struct v3d_dev *v3d)
 {
 	int ret;
 
+	v3d->reset_wq = alloc_ordered_workqueue("v3d_reset", 0);
+	if (!v3d->reset_wq)
+		return -ENOMEM;
+
 	ret = v3d_queue_sched_init(v3d, &v3d_bin_sched_ops, V3D_BIN, "v3d_bin");
 	if (ret)
-		return ret;
+		goto fail;
 
 	ret = v3d_queue_sched_init(v3d, &v3d_render_sched_ops, V3D_RENDER,
 				   "v3d_render");
@@ -927,4 +932,6 @@ v3d_sched_fini(struct v3d_dev *v3d)
 		if (v3d->queue[q].sched.ready)
 			drm_sched_fini(&v3d->queue[q].sched);
 	}
+
+	destroy_workqueue(v3d->reset_wq);
 }


