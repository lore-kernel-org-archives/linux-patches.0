Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595482931C0;
	Thu, 20 Aug 2026 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247464; cv=none; b=liOuqnuYFo1VBCW1lUu9CoVcmtslow6NI/4IJiFyBYi2+/1ndSnfrxOZQvTDFXG0ZL81BHvhW0E4ahlXA93K7xG0MNZIlJwxN9ZhkISnccvfhIYFFih99idjL4xPY6V6QfnfE/HGQvjXx3bleku3WrY9pdmiRV0454rDVKEbr1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247464; c=relaxed/simple;
	bh=eMm3gsQNrPbTz6gAcEkNLJRU9w0d4xS5mPEHrDAWjaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWksl/gde1vT9v4iFRDQ1rP4dxE39ARD4xddYrqLStyR1YCp6ouRiFqZoR92ZqbrYsQvtmah3P4TM7yHAfaMSFkYh9Uo5PTGj9iYk9186KjBit81ror3SrQ3lsNU6gY7ueVi0Varb+HcWdrMMzBQqzpMiugFHcDeedJEO/93KUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmF9VCkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmF9VCkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C881F000E9;
	Thu, 20 Aug 2026 17:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247463;
	bh=4286CBA1WBLMcHPgwYU7dKEKNK/pAv1Noquuv9xq89I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmF9VCkCJ0CWImKG0W/6LqZyQq595JXEaftrbLJF4Rlq7JZPJd6DPK5N2yikih5P3
	 vuoyd3GMAjnD8pQ288PTdXy24z8QHQgnbC2fH1dGFifADZnClZZchd5IHcK2KirHZ6
	 uWLiegIUuoZt0smxVk2Vyyqq1/oi5a9Mcjd8aeK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCH 6.6 055/166] s390/vfio_ccw: Selectively expand io_mutex
Date: Thu, 20 Aug 2026 16:55:14 +0200
Message-ID: <20260820145212.810138831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Eric Farman <farman@linux.ibm.com>

commit 34f4feff3e90bd09308fad0974e97113b23b812a upstream.

The io_mutex was defined to serialize the io_regions, but then has
also sort of been associated with the I/O themselves because of
the close relationship they share.

With the handful of races that are possible, the choices are either to:
 A) expand the scope of io_mutex to close these remaining windows, or
 B) reduce the scope of io_mutex to just io_region, and introduce a new
    lock mechanism for the remaining I/O resources

This patch implements A, since B brings with it a lot more interactions
that would need to be tracked and kept in a correct hierarchy. It also
takes advantage of the workqueue element for cp_free() that now gets
called out of fsm_notoper(), which could be invoked out of an interrupt
context and thus cannot acquire a mutex itself.

Fixes: 4f76617378ee ("vfio-ccw: protect the I/O region")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/vfio_ccw_chp.c     |    2 +-
 drivers/s390/cio/vfio_ccw_cp.c      |    8 +++++++-
 drivers/s390/cio/vfio_ccw_drv.c     |    6 ++++--
 drivers/s390/cio/vfio_ccw_fsm.c     |    5 +++++
 drivers/s390/cio/vfio_ccw_private.h |    3 ++-
 5 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/s390/cio/vfio_ccw_chp.c
+++ b/drivers/s390/cio/vfio_ccw_chp.c
@@ -98,13 +98,13 @@ static ssize_t vfio_ccw_crw_region_read(
 	if (pos + count > sizeof(*region))
 		return -EINVAL;
 
+	mutex_lock(&private->io_mutex);
 	crw = list_first_entry_or_null(&private->crw,
 				       struct vfio_ccw_crw, next);
 
 	if (crw)
 		list_del(&crw->next);
 
-	mutex_lock(&private->io_mutex);
 	if (i >= private->num_regions) {
 		ret = -EINVAL;
 		goto out;
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -953,17 +953,23 @@ void cp_update_scsw(struct channel_progr
  */
 bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length)
 {
+	struct vfio_ccw_private *private =
+		container_of(cp, struct vfio_ccw_private, cp);
 	struct ccwchain *chain;
 	int i;
 
 	if (!cp->initialized)
 		return false;
 
+	mutex_lock(&private->io_mutex);
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++)
-			if (page_array_iova_pinned(&chain->ch_pa[i], iova, length))
+			if (page_array_iova_pinned(&chain->ch_pa[i], iova, length)) {
+				mutex_unlock(&private->io_mutex);
 				return true;
+			}
 	}
+	mutex_unlock(&private->io_mutex);
 
 	return false;
 }
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -91,6 +91,7 @@ void vfio_ccw_sch_io_todo(struct work_st
 
 	is_final = !(scsw_actl(&irb->scsw) &
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
+	mutex_lock(&private->io_mutex);
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
 		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
@@ -98,9 +99,7 @@ void vfio_ccw_sch_io_todo(struct work_st
 			cp_is_finished = true;
 		}
 	}
-	mutex_lock(&private->io_mutex);
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
-	mutex_unlock(&private->io_mutex);
 
 	/*
 	 * Reset to IDLE only if processing of a channel program
@@ -110,6 +109,7 @@ void vfio_ccw_sch_io_todo(struct work_st
 	 */
 	if (cp_is_finished)
 		private->state = VFIO_CCW_STATE_IDLE;
+	mutex_unlock(&private->io_mutex);
 
 	if (private->io_trigger)
 		eventfd_signal(private->io_trigger, 1);
@@ -131,7 +131,9 @@ void vfio_ccw_notoper_todo(struct work_s
 
 	private = container_of(work, struct vfio_ccw_private, notoper_work);
 
+	mutex_lock(&private->io_mutex);
 	cp_free(&private->cp);
+	mutex_unlock(&private->io_mutex);
 }
 
 /*
--- a/drivers/s390/cio/vfio_ccw_fsm.c
+++ b/drivers/s390/cio/vfio_ccw_fsm.c
@@ -170,6 +170,7 @@ static void fsm_notoper(struct vfio_ccw_
 	css_sched_sch_todo(sch, SCH_TODO_UNREG);
 	private->state = VFIO_CCW_STATE_NOT_OPER;
 
+	/* This routine could be called from IRQ context, so defer */
 	queue_work(vfio_ccw_work_q, &private->notoper_work);
 }
 
@@ -409,7 +410,11 @@ static void fsm_close(struct vfio_ccw_pr
 
 	private->state = VFIO_CCW_STATE_STANDBY;
 	spin_unlock_irq(&sch->lock);
+
+	mutex_lock(&private->io_mutex);
 	cp_free(&private->cp);
+	mutex_unlock(&private->io_mutex);
+
 	return;
 
 err_unlock:
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -88,7 +88,8 @@ struct vfio_ccw_parent {
  * @state: internal state of the device
  * @completion: synchronization helper of the I/O completion
  * @io_region: MMIO region to input/output I/O arguments/results
- * @io_mutex: protect against concurrent update of I/O regions
+ * @io_mutex: protect against concurrent update of I/O resources
+ *            and @cp lifecycle
  * @region: additional regions for other subchannel operations
  * @cmd_region: MMIO region for asynchronous I/O commands other than START
  * @schib_region: MMIO region for SCHIB information


