Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B383C07A;
	Thu, 20 Aug 2026 15:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239526; cv=none; b=Fg0LCw8V6NdpQdwFgQ+gGyOlhpcnRWE8oFiGbfTBorH6iU9HRgkGtZ7AosPpqZ9771epD85ogZAAU0hcaD+zWJh4Hp+ysWlj4xjnyvXji+Yp2t92cwGFELL3qIj7N7fvrp6oCejrNZq1360aA/0D/27Guq/d5InF6vv+YqbWYIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239526; c=relaxed/simple;
	bh=vA5S3PsHRHiFqeYCdiLVy5p41q23LyUs+8AlxM1GRAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNqVrzcksd8MfmEujXZ0YB0CrZhz1ufMJV9HJpXzf2LEq4/rfc2thXDaMhiwGlzPwxeEvh8CHSKqg2ymrTGFMSULAgAXvRo6I8QHx8P6acsleDDaWWWF9fwGH/8WHAPEHpwdF+LpEFzARrDwxqQcqVbVz3ojlHpQY9ZbSil9cAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rd1yILeW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rd1yILeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF591F000E9;
	Thu, 20 Aug 2026 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239524;
	bh=6tX1u8eSVnKdWfkaAJ4jrOihvaSf1jnR1hAZxHDjiyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rd1yILeWXjzduu3ruT7FPljBL98p1e5i2X3kih8ELOzdJGw2pXXv/FUxRwwOy9+dB
	 pdKasBPaYZ44cfTChW4aoehm4K5fi4EIioE9sNLjHTIdgzR9qc4UBrxwH5Rz6fVutX
	 0lkGdq1WBF3BBBLMDas8ToedDXs0JIFXF9Va6ryc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.12 079/220] s390/vfio_ccw: Implement a crw lock
Date: Thu, 20 Aug 2026 16:54:29 +0200
Message-ID: <20260820145225.863109498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit 16b0798024c0e9117e395829ddbbe70981c79d9c upstream.

Unlike the channel_program struct, which covers synchronous I/O
submissions and asynchronous interrupts, the CRW region relies
exclusively on asynchronous events coming from hardware.

Implement a lock to manage the list of those payloads, to ensure
they are read cohesively.

Fixes: 3f02cb2fd9d2 ("vfio-ccw: Wire up the CRW irq and CRW region")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_chp.c     |   26 ++++++++++++++++----------
 drivers/s390/cio/vfio_ccw_drv.c     |    6 ++++++
 drivers/s390/cio/vfio_ccw_ops.c     |    4 ++++
 drivers/s390/cio/vfio_ccw_private.h |    4 ++++
 4 files changed, 30 insertions(+), 10 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -93,18 +93,13 @@ static ssize_t vfio_ccw_crw_region_read(
 	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
 	struct ccw_crw_region *region;
 	struct vfio_ccw_crw *crw;
+	unsigned long flags;
 	int ret;
 
 	if (pos + count > sizeof(*region))
 		return -EINVAL;
 
 	mutex_lock(&private->io_mutex);
-	crw = list_first_entry_or_null(&private->crw,
-				       struct vfio_ccw_crw, next);
-
-	if (crw)
-		list_del(&crw->next);
-
 	if (i >= private->num_regions) {
 		ret = -EINVAL;
 		goto out;
@@ -113,6 +108,16 @@ static ssize_t vfio_ccw_crw_region_read(
 	i = array_index_nospec(i, private->num_regions);
 	region = private->region[i].data;
 
+	spin_lock_irqsave(&private->crw_lock, flags);
+	crw = list_first_entry_or_null(&private->crw,
+				       struct vfio_ccw_crw, next);
+
+	if (crw)
+		list_del(&crw->next);
+
+	/* Drop CRW lock while copying to userspace */
+	spin_unlock_irqrestore(&private->crw_lock, flags);
+
 	if (crw)
 		memcpy(&region->crw, &crw->crw, sizeof(region->crw));
 
@@ -122,15 +127,16 @@ static ssize_t vfio_ccw_crw_region_read(
 		ret = count;
 
 	region->crw = 0;
-
-out:
-	mutex_unlock(&private->io_mutex);
-
 	kfree(crw);
 
 	/* Notify the guest if more CRWs are on our queue */
+	spin_lock_irqsave(&private->crw_lock, flags);
 	if (!list_empty(&private->crw) && private->crw_trigger)
 		eventfd_signal(private->crw_trigger);
+	spin_unlock_irqrestore(&private->crw_lock, flags);
+
+out:
+	mutex_unlock(&private->io_mutex);
 
 	return ret;
 }
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -118,11 +118,14 @@ void vfio_ccw_sch_io_todo(struct work_st
 void vfio_ccw_crw_todo(struct work_struct *work)
 {
 	struct vfio_ccw_private *private;
+	unsigned long flags;
 
 	private = container_of(work, struct vfio_ccw_private, crw_work);
 
+	spin_lock_irqsave(&private->crw_lock, flags);
 	if (!list_empty(&private->crw) && private->crw_trigger)
 		eventfd_signal(private->crw_trigger);
+	spin_unlock_irqrestore(&private->crw_lock, flags);
 }
 
 void vfio_ccw_notoper_todo(struct work_struct *work)
@@ -286,6 +289,7 @@ static void vfio_ccw_queue_crw(struct vf
 			       unsigned int rsid)
 {
 	struct vfio_ccw_crw *crw;
+	unsigned long flags;
 
 	/*
 	 * If unable to allocate a CRW, just drop the event and
@@ -303,7 +307,9 @@ static void vfio_ccw_queue_crw(struct vf
 	crw->crw.erc = erc;
 	crw->crw.rsid = rsid;
 
+	spin_lock_irqsave(&private->crw_lock, flags);
 	list_add_tail(&crw->next, &private->crw);
+	spin_unlock_irqrestore(&private->crw_lock, flags);
 	queue_work(vfio_ccw_work_q, &private->crw_work);
 }
 
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -55,6 +55,7 @@ static int vfio_ccw_mdev_init_dev(struct
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
 	INIT_WORK(&private->notoper_work, vfio_ccw_notoper_todo);
+	spin_lock_init(&private->crw_lock);
 
 	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
 				       GFP_KERNEL);
@@ -132,6 +133,7 @@ static void vfio_ccw_mdev_release_dev(st
 	struct vfio_ccw_private *private =
 		container_of(vdev, struct vfio_ccw_private, vdev);
 	struct vfio_ccw_crw *crw, *temp;
+	unsigned long flags;
 
 	/*
 	 * Ensure these work items are fully drained, so none can
@@ -147,10 +149,12 @@ static void vfio_ccw_mdev_release_dev(st
 	cancel_work_sync(&private->crw_work);
 	flush_work(&private->notoper_work);
 
+	spin_lock_irqsave(&private->crw_lock, flags);
 	list_for_each_entry_safe(crw, temp, &private->crw, next) {
 		list_del(&crw->next);
 		kfree(crw);
 	}
+	spin_unlock_irqrestore(&private->crw_lock, flags);
 
 	kmem_cache_free(vfio_ccw_crw_region, private->crw_region);
 	kmem_cache_free(vfio_ccw_schib_region, private->schib_region);
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -98,6 +98,8 @@ struct vfio_ccw_parent {
  * @cp: channel program for the current I/O operation
  * @irb: irb info received from interrupt
  * @scsw: scsw info
+ * @crw_lock: serialization of CRW list information
+ * @crw: list of Channel Report Word elements
  * @io_trigger: eventfd ctx for signaling userspace I/O results
  * @crw_trigger: eventfd ctx for signaling userspace CRW information
  * @req_trigger: eventfd ctx for signaling userspace to return device
@@ -120,6 +122,8 @@ struct vfio_ccw_private {
 	struct channel_program	cp;
 	struct irb		irb;
 	union scsw		scsw;
+
+	spinlock_t		crw_lock;
 	struct list_head	crw;
 
 	struct eventfd_ctx	*io_trigger;


