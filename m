Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E44230D0F;
	Mon, 10 Mar 2025 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626619; cv=none; b=IgMQOg5ORU0jkXpQNJ5zlEbL9aK8oAeeQPUdfjE0T6rW5XU9XIcAv2rjbGyO6NqBfasopvaVs7tpS5gPLi7rNARq3E71FoA5mvfqnSYeetGy6qdMfgQlL+5iLc7Beo2RsKtNpUqhUkYNkgg6sR2U6T9n5JWBv24Q8Vx72sF5Ebw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626619; c=relaxed/simple;
	bh=f2ebQUAlynQptLK3/1knvtDxytwkzEC5HKJpG0wFKRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7R0yDdUxAkNElGjVT8RZ7HrVQFtR0dMIkEhFqNjDgEvpKOS9iX29P7k88s7mAjo+TDmeXgMvsvGTUXKgnVOHrL8+O/6ALoaIOxsVAqLHAROZmDX5jEbYMVj0PR/WlzyOiwoA/41hHlItLpfny0m/mJZpaWiL4UpDyWHVkICzuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFItDxZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFItDxZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1B2C4CEE5;
	Mon, 10 Mar 2025 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626619;
	bh=f2ebQUAlynQptLK3/1knvtDxytwkzEC5HKJpG0wFKRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFItDxZaO9Y7iGnBzmmF6anBrbk/++1desvOesYEd5RYdUA3shul0dpzjzb7uKLJ/
	 iryf35UpaDreLCOgZV5BBRMNYg1po9Ax2cqlv9zz+QweJ3i2Bu4kCtXT3U0PvC4eEK
	 z/6fwCRGpXOF3PW9uBiOerzK2bDkJfhSg005Th3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan King <brendan.king@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.13 037/207] drm/imagination: avoid deadlock on fence release
Date: Mon, 10 Mar 2025 18:03:50 +0100
Message-ID: <20250310170449.249051613@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brendan King <Brendan.King@imgtec.com>

commit df1a1ed5e1bdd9cc13148e0e5549f5ebcf76cf13 upstream.

Do scheduler queue fence release processing on a workqueue, rather
than in the release function itself.

Fixes deadlock issues such as the following:

[  607.400437] ============================================
[  607.405755] WARNING: possible recursive locking detected
[  607.415500] --------------------------------------------
[  607.420817] weston:zfq0/24149 is trying to acquire lock:
[  607.426131] ffff000017d041a0 (reservation_ww_class_mutex){+.+.}-{3:3}, at: pvr_gem_object_vunmap+0x40/0xc0 [powervr]
[  607.436728]
               but task is already holding lock:
[  607.442554] ffff000017d105a0 (reservation_ww_class_mutex){+.+.}-{3:3}, at: dma_buf_ioctl+0x250/0x554
[  607.451727]
               other info that might help us debug this:
[  607.458245]  Possible unsafe locking scenario:

[  607.464155]        CPU0
[  607.466601]        ----
[  607.469044]   lock(reservation_ww_class_mutex);
[  607.473584]   lock(reservation_ww_class_mutex);
[  607.478114]
                *** DEADLOCK ***

Cc: stable@vger.kernel.org
Fixes: eaf01ee5ba28 ("drm/imagination: Implement job submission and scheduling")
Signed-off-by: Brendan King <brendan.king@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226-fence-release-deadlock-v2-1-6fed2fc1fe88@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_queue.c |   13 +++++++++++--
 drivers/gpu/drm/imagination/pvr_queue.h |    4 ++++
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -109,12 +109,20 @@ pvr_queue_fence_get_driver_name(struct d
 	return PVR_DRIVER_NAME;
 }
 
+static void pvr_queue_fence_release_work(struct work_struct *w)
+{
+	struct pvr_queue_fence *fence = container_of(w, struct pvr_queue_fence, release_work);
+
+	pvr_context_put(fence->queue->ctx);
+	dma_fence_free(&fence->base);
+}
+
 static void pvr_queue_fence_release(struct dma_fence *f)
 {
 	struct pvr_queue_fence *fence = container_of(f, struct pvr_queue_fence, base);
+	struct pvr_device *pvr_dev = fence->queue->ctx->pvr_dev;
 
-	pvr_context_put(fence->queue->ctx);
-	dma_fence_free(f);
+	queue_work(pvr_dev->sched_wq, &fence->release_work);
 }
 
 static const char *
@@ -268,6 +276,7 @@ pvr_queue_fence_init(struct dma_fence *f
 
 	pvr_context_get(queue->ctx);
 	fence->queue = queue;
+	INIT_WORK(&fence->release_work, pvr_queue_fence_release_work);
 	dma_fence_init(&fence->base, fence_ops,
 		       &fence_ctx->lock, fence_ctx->id,
 		       atomic_inc_return(&fence_ctx->seqno));
--- a/drivers/gpu/drm/imagination/pvr_queue.h
+++ b/drivers/gpu/drm/imagination/pvr_queue.h
@@ -5,6 +5,7 @@
 #define PVR_QUEUE_H
 
 #include <drm/gpu_scheduler.h>
+#include <linux/workqueue.h>
 
 #include "pvr_cccb.h"
 #include "pvr_device.h"
@@ -63,6 +64,9 @@ struct pvr_queue_fence {
 
 	/** @queue: Queue that created this fence. */
 	struct pvr_queue *queue;
+
+	/** @release_work: Fence release work structure. */
+	struct work_struct release_work;
 };
 
 /**


