Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232FE4749C1;
	Tue, 25 Aug 2026 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665951; cv=none; b=SOqlpAio5DyY2fylh8ue4fIo6y7j35JFF53BtwQ5w6WjZvcxD7qL2yKygPRlwkoeQQAii6C/FDWfT1DTP0tYIbRmLWuJqFNTylOIl+SneZCMhTtg0K+mIH9tX0++peMYGEEXcMHxdKrfR78CfQXl8LnyZZ9QAcN6+IXgXifSRNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665951; c=relaxed/simple;
	bh=IJDKrfEWGq8aXu+DVUbxfKEZzuofAuhmVos/a0LyZKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUxyQn0EA1XlkxETTdGwfl09/lA2uuEq4ZIykv9uKL+QKIKVa8kN0MFlGqv64xy3DputVOBJuu9VJdkUFtTo1HP9+eatHCt5mvpOCvzBJX6Fh/EdIkLP/wxrxSdrplhtxHyXfBkFtsmpjktlcHU3shhRXn9D+YvYggVp7U/x15A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmKRVk2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmKRVk2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A241F000E9;
	Tue, 25 Aug 2026 13:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665950;
	bh=5np7X6ZsgtHVm3sGiIXGeSgOvaHafB7421mL2y4VdSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmKRVk2ekMGsomnOul5YN9dgAfdxWt5MvPmHiri4L77rTOXcwGHOpkstgD3y6RCGT
	 BDMoCV/YtwZHxJk7wAZEwj9TPNaO/k3GiSJJSCjJhUXy0PgFYiuACV2Z+HJ2P9BcrC
	 FsaBZXCCMut18iAiK//OAslXfWJX4eirqh8BurNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/79] s390/vfio_ccw: Move cp cleanup out of not operational
Date: Tue, 25 Aug 2026 15:26:12 +0200
Message-ID: <20260825132542.956650512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 0c11f61a876ed6fcca53d442ed3f33ea8362a0f9 ]

The fsm_notoper() routine is called when the device has been
lost, and is (by definition) no longer operational. Since this
can happen asynchronously from the normal behavior of the
driver, the cleanup may happen when holding other locks
in the calling sequence (notably, the cio subchannel lock).

Push the cleanup of the private->cp resources to a workqueue,
where it can be done out from under that lock sequence and
a future patch can safely manage the locking requirements.

Fixes: 204b394a23ad ("vfio/ccw: Move FSM open/close to MDEV open/close")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Stable-dep-of: 16b0798024c0 ("s390/vfio_ccw: Implement a crw lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_drv.c     |   10 ++++++++++
 drivers/s390/cio/vfio_ccw_fsm.c     |    3 +--
 drivers/s390/cio/vfio_ccw_ops.c     |   12 ++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |    2 ++
 4 files changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -116,6 +116,15 @@ static void vfio_ccw_crw_todo(struct wor
 		eventfd_signal(private->crw_trigger, 1);
 }
 
+static void vfio_ccw_notoper_todo(struct work_struct *work)
+{
+	struct vfio_ccw_private *private;
+
+	private = container_of(work, struct vfio_ccw_private, notoper_work);
+
+	cp_free(&private->cp);
+}
+
 /*
  * Css driver callbacks
  */
@@ -141,6 +150,7 @@ static struct vfio_ccw_private *vfio_ccw
 	INIT_LIST_HEAD(&private->crw);
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
+	INIT_WORK(&private->notoper_work, vfio_ccw_notoper_todo);
 
 	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
 				       GFP_KERNEL);
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -176,8 +176,7 @@ static void fsm_notoper(struct vfio_ccw_
 	css_sched_sch_todo(sch, SCH_TODO_UNREG);
 	private->state = VFIO_CCW_STATE_NOT_OPER;
 
-	/* This is usually handled during CLOSE event */
-	cp_free(&private->cp);
+	queue_work(vfio_ccw_work_q, &private->notoper_work);
 }
 
 /*
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -89,9 +89,16 @@ static void vfio_ccw_mdev_release_dev(st
 	/*
 	 * Ensure these work items are fully drained, so none can
 	 * fire after being released.
+	 *
+	 * notoper_work should have nothing to do here, because only
+	 * open devices could have channel_program resources in use
+	 * and those would be released during close. Nevertheless,
+	 * call flush here as well to be certain anything that was
+	 * allocated is freed.
 	 */
 	cancel_work_sync(&private->io_work);
 	cancel_work_sync(&private->crw_work);
+	flush_work(&private->notoper_work);
 
 	/*
 	 * We cannot free vfio_ccw_private here because it includes
@@ -173,9 +180,14 @@ static void vfio_ccw_mdev_close_device(s
 	/*
 	 * Ensure these work items are drained, in the event the
 	 * device is re-opened instead of released.
+	 *
+	 * notoper_work needs to be given a chance to run if it
+	 * is queued, so any memory associated with the channel
+	 * program can be returned.
 	 */
 	cancel_work_sync(&private->io_work);
 	cancel_work_sync(&private->crw_work);
+	flush_work(&private->notoper_work);
 
 	vfio_ccw_unregister_dev_regions(private);
 }
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -88,6 +88,7 @@ struct vfio_ccw_crw {
  * @req_trigger: eventfd ctx for signaling userspace to return device
  * @io_work: work for deferral process of I/O handling
  * @crw_work: work for deferral process of CRW handling
+ * @notoper_work: work for deferred processing in not-operational state
  * @release_comp: synchronization helper for vfio device release
  * @parent: parent data structures for mdevs created
  */
@@ -114,6 +115,7 @@ struct vfio_ccw_private {
 	struct eventfd_ctx	*req_trigger;
 	struct work_struct	io_work;
 	struct work_struct	crw_work;
+	struct work_struct	notoper_work;
 
 	struct completion	release_comp;
 


