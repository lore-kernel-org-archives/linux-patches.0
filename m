Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5F445C70B;
	Tue, 25 Aug 2026 13:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666326; cv=none; b=p3uYgH+P6MinABRpUEj1HpKNrtYgDaLo2kh+B1DNMNRZGx7gNVwNQCYARl+6OlPpWj8ilAJ9fKQUdiYU+OblRjY8s6gXrgc6EyxqzZIg7ZDU+rfNBOQ+Yz9hMGQ51RqKl8/OHtUP5bmFUKNYoonHeFchmblemaJxrzSqDmtNMns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666326; c=relaxed/simple;
	bh=JafeEMCoKrxe9rm3nrl6Zu+0315ZJiVHCFe6yfvBeew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUSYKimVr+yOhPE0eBFKdlu1q2zZhQWBpApoEtgw1e417tDZwQVR4ZKMIOxK8qPislFGuhHdUZoZ660E18g+0DYrFnuw73rtOqdp66xTi8eJDBtbWMQzd0YEv/BgE2GtCwZ+AlnU1w3XkvmDWBVyoMd5o1RW+d38j9rd2TBSPkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1lIiyI/4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1lIiyI/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CE11F000E9;
	Tue, 25 Aug 2026 13:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666325;
	bh=0DpW2VKT44XeLOCuDUErSW1wPZ/PPeR1S1KsqOz22Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lIiyI/4w+dH+E/WPSjD2x5WWltchVwvyUL60S0QjUXvSSLjpx17avAA0X1H0/thK
	 8CHXlHD/bMvQ4VTqNLs3j44WDjAY7oe5ep1YPSXHMDjPfO/3BhYGE310G7AIGjvhIg
	 DhMdaRKltYVNUG24JfmA+m5ZRWn6GHnoBzmIWfcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/76] s390/vfio_ccw: Implement a crw lock
Date: Tue, 25 Aug 2026 15:26:41 +0200
Message-ID: <20260825132543.456403514@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Farman <farman@linux.ibm.com>

[ Upstream commit 16b0798024c0e9117e395829ddbbe70981c79d9c ]

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
[ relocated crw_lock init and CRW drain from vfio_ccw_ops.c's mdev_init_dev()/mdev_release_dev() into vfio_ccw_drv.c's sch_probe()/sch_remove(), and kept the two-argument eventfd_signal() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_chp.c     |   26 ++++++++++++++++----------
 drivers/s390/cio/vfio_ccw_drv.c     |   10 ++++++++++
 drivers/s390/cio/vfio_ccw_private.h |    4 ++++
 3 files changed, 30 insertions(+), 10 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -92,18 +92,13 @@ static ssize_t vfio_ccw_crw_region_read(
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
@@ -112,6 +107,16 @@ static ssize_t vfio_ccw_crw_region_read(
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
 
@@ -121,15 +126,16 @@ static ssize_t vfio_ccw_crw_region_read(
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
 		eventfd_signal(private->crw_trigger, 1);
+	spin_unlock_irqrestore(&private->crw_lock, flags);
+
+out:
+	mutex_unlock(&private->io_mutex);
 
 	return ret;
 }
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -119,11 +119,14 @@ static void vfio_ccw_sch_io_todo(struct
 static void vfio_ccw_crw_todo(struct work_struct *work)
 {
 	struct vfio_ccw_private *private;
+	unsigned long flags;
 
 	private = container_of(work, struct vfio_ccw_private, crw_work);
 
+	spin_lock_irqsave(&private->crw_lock, flags);
 	if (!list_empty(&private->crw) && private->crw_trigger)
 		eventfd_signal(private->crw_trigger, 1);
+	spin_unlock_irqrestore(&private->crw_lock, flags);
 }
 
 /*
@@ -207,6 +210,7 @@ static int vfio_ccw_sch_probe(struct sub
 	INIT_LIST_HEAD(&private->crw);
 	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
 	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
+	spin_lock_init(&private->crw_lock);
 	atomic_set(&private->avail, 1);
 	private->state = VFIO_CCW_STATE_STANDBY;
 
@@ -238,13 +242,16 @@ static void vfio_ccw_sch_remove(struct s
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
 	struct vfio_ccw_crw *crw, *temp;
+	unsigned long flags;
 
 	vfio_ccw_sch_quiesce(sch);
 
+	spin_lock_irqsave(&private->crw_lock, flags);
 	list_for_each_entry_safe(crw, temp, &private->crw, next) {
 		list_del(&crw->next);
 		kfree(crw);
 	}
+	spin_unlock_irqrestore(&private->crw_lock, flags);
 
 	vfio_ccw_mdev_unreg(sch);
 
@@ -304,6 +311,7 @@ static void vfio_ccw_queue_crw(struct vf
 			       unsigned int rsid)
 {
 	struct vfio_ccw_crw *crw;
+	unsigned long flags;
 
 	/*
 	 * If unable to allocate a CRW, just drop the event and
@@ -321,7 +329,9 @@ static void vfio_ccw_queue_crw(struct vf
 	crw->crw.erc = erc;
 	crw->crw.rsid = rsid;
 
+	spin_lock_irqsave(&private->crw_lock, flags);
 	list_add_tail(&crw->next, &private->crw);
+	spin_unlock_irqrestore(&private->crw_lock, flags);
 	queue_work(vfio_ccw_work_q, &private->crw_work);
 }
 
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -84,6 +84,8 @@ struct vfio_ccw_crw {
  * @cp: channel program for the current I/O operation
  * @irb: irb info received from interrupt
  * @scsw: scsw info
+ * @crw_lock: serialization of CRW list information
+ * @crw: list of Channel Report Word elements
  * @io_trigger: eventfd ctx for signaling userspace I/O results
  * @crw_trigger: eventfd ctx for signaling userspace CRW information
  * @req_trigger: eventfd ctx for signaling userspace to return device
@@ -108,6 +110,8 @@ struct vfio_ccw_private {
 	struct channel_program	cp;
 	struct irb		irb;
 	union scsw		scsw;
+
+	spinlock_t		crw_lock;
 	struct list_head	crw;
 
 	struct eventfd_ctx	*io_trigger;


