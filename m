Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CCD37E2E6;
	Thu, 20 Aug 2026 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238354; cv=none; b=BJ8RqNz7PaZp9QgkPTUhBJTAzaQKvNzmSnkKeQNxuuBPQKrBYjaOtUV2CzW13iEO49dBhz3bUpV+xWU0wz4lfqC0mSoVG2Cu5r/wG5x/tSmGwMxpI0+cPqZKix8JD40h7VglocjsqooFQax+2PYjMLsH7S7VmhUwIVbfs6AfIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238354; c=relaxed/simple;
	bh=IsmtgptktCz8oZ5LTIk+EBB945uJfa7FVhy5yIl2qjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZCJjHHvTt/1uoPuc+12OPMOTmeVq5TbUBr75kuej2683oGGbanty0IzRXIBDSYjWxL1pDaJ7B49HzxcPiNTZK745reXC7fPWqOexamVAfOYLsD6nxl63XGHgftBVOAYkBaoEgAbalOWr4xlUVt2WS+g2xU+Tv+LY7+06qOwalk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sC1yLR5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sC1yLR5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EF11F000E9;
	Thu, 20 Aug 2026 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238353;
	bh=C6AiC8vjK34IcbZa5EiqjkmMRmegmZ6142fO+8kN8uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sC1yLR5Kt9SgvWdSaGNn8q7SbaIkK15Af/pWhwMAKwyiiXmXdsQ6k1qyJSDjx7DcM
	 5f62eOcCzmmmYzJmxHs2TAu4MMB3pRccShTvoAftHxkzocr/C2KQ6vOuPoC133kERK
	 TLySApiKG1GKTUk3uLSm5lJ92RgdcQm3NtV+t+rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 7.1 101/228] s390/vfio_ccw: Move cp cleanup out of not operational
Date: Thu, 20 Aug 2026 16:54:03 +0200
Message-ID: <20260820145247.718312393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

commit 0c11f61a876ed6fcca53d442ed3f33ea8362a0f9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_drv.c     |    9 +++++++++
 drivers/s390/cio/vfio_ccw_fsm.c     |    3 +--
 drivers/s390/cio/vfio_ccw_ops.c     |   13 +++++++++++++
 drivers/s390/cio/vfio_ccw_private.h |    3 +++
 4 files changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -125,6 +125,15 @@ void vfio_ccw_crw_todo(struct work_struc
 		eventfd_signal(private->crw_trigger);
 }
 
+void vfio_ccw_notoper_todo(struct work_struct *work)
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
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -170,8 +170,7 @@ static void fsm_notoper(struct vfio_ccw_
 	css_sched_sch_todo(sch, SCH_TODO_UNREG);
 	private->state = VFIO_CCW_STATE_NOT_OPER;
 
-	/* This is usually handled during CLOSE event */
-	cp_free(&private->cp);
+	queue_work(vfio_ccw_work_q, &private->notoper_work);
 }
 
 /*
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -54,6 +54,7 @@ static int vfio_ccw_mdev_init_dev(struct
 	INIT_LIST_HEAD(&private->crw);
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
+	INIT_WORK(&private->notoper_work, vfio_ccw_notoper_todo);
 
 	private->cp.guest_cp = kzalloc_objs(struct ccw1, CCWCHAIN_LEN_MAX);
 	if (!private->cp.guest_cp)
@@ -134,9 +135,16 @@ static void vfio_ccw_mdev_release_dev(st
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
 
 	list_for_each_entry_safe(crw, temp, &private->crw, next) {
 		list_del(&crw->next);
@@ -213,9 +221,14 @@ static void vfio_ccw_mdev_close_device(s
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
@@ -102,6 +102,7 @@ struct vfio_ccw_parent {
  * @req_trigger: eventfd ctx for signaling userspace to return device
  * @io_work: work for deferral process of I/O handling
  * @crw_work: work for deferral process of CRW handling
+ * @notoper_work: work for deferred processing in not-operational state
  */
 struct vfio_ccw_private {
 	struct vfio_device vdev;
@@ -125,11 +126,13 @@ struct vfio_ccw_private {
 	struct eventfd_ctx	*req_trigger;
 	struct work_struct	io_work;
 	struct work_struct	crw_work;
+	struct work_struct	notoper_work;
 } __aligned(8);
 
 int vfio_ccw_sch_quiesce(struct subchannel *sch);
 void vfio_ccw_sch_io_todo(struct work_struct *work);
 void vfio_ccw_crw_todo(struct work_struct *work);
+void vfio_ccw_notoper_todo(struct work_struct *work);
 
 extern struct mdev_driver vfio_ccw_mdev_driver;
 


