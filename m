Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ADB2D73B1;
	Mon, 27 Oct 2025 19:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592026; cv=none; b=aoF0wqmF7EAE3a0CErdlnN8xjFIPkgYHwa6guLOdmXLLRgz2/drzGn68vykDUAHADtUg8t/59z0ZcjbCWswxOCoKrdrGJtvdk7HAg2Y6DMt5p9wkj/dUYZ7uco2jEG/qR5mhrBOu8rJ45AHxI3GEKfUtWTt2DB7VhFR1z/7CXwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592026; c=relaxed/simple;
	bh=OO3Zt8PfUufYZAcuSdg3kmalgFvS02czTyOkhdIYPBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRjNRWznnHMCtZVlcqgXf375rfCRAUB/W8dPiigZDk1H3+OGAIqurgsmzWaytGrlCWC3gapTDg3I/f2pZsSdusXpS5qEXNQkwZq0/XdvVYesXIQYWJTWvU707QAgRMSQv2revfG4L+IiUumK6tP6OSlILzSh1TP9wGzhgXVpfcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3/UwhcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3/UwhcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FA0C4CEF1;
	Mon, 27 Oct 2025 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592026;
	bh=OO3Zt8PfUufYZAcuSdg3kmalgFvS02czTyOkhdIYPBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3/UwhcSGz+8DYVKhhQVgqwtl7Cxs4+s6gTlDR5P/Ud7PDS1/MyJuYrlVATF5tDhk
	 473E8vX5084UpXlYDndQq/sHAfGGRLxFKmCSqRfalvTQgc9Oc9RMfbIIZht0+XHFGf
	 hrcTaNfSUO+KK4J1fD51wEJyWdkNDxaiuADPgJZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 089/123] s390/cio: Update purge function to unregister the unused subchannels
Date: Mon, 27 Oct 2025 19:36:09 +0100
Message-ID: <20251027183448.772784321@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

commit 9daa5a8795865f9a3c93d8d1066785b07ded6073 upstream.

Starting with 'commit 2297791c92d0 ("s390/cio: dont unregister
subchannel from child-drivers")', cio no longer unregisters
subchannels when the attached device is invalid or unavailable.

As an unintended side-effect, the cio_ignore purge function no longer
removes subchannels for devices on the cio_ignore list if no CCW device
is attached. This situation occurs when a CCW device is non-operational
or unavailable

To ensure the same outcome of the purge function as when the
current cio_ignore list had been active during boot, update the purge
function to remove I/O subchannels without working CCW devices if the
associated device number is found on the cio_ignore list.

Fixes: 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
Suggested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/device.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1323,23 +1323,34 @@ void ccw_device_schedule_recovery(void)
 	spin_unlock_irqrestore(&recovery_lock, flags);
 }
 
-static int purge_fn(struct device *dev, void *data)
+static int purge_fn(struct subchannel *sch, void *data)
 {
-	struct ccw_device *cdev = to_ccwdev(dev);
-	struct ccw_dev_id *id = &cdev->private->dev_id;
-	struct subchannel *sch = to_subchannel(cdev->dev.parent);
-
-	spin_lock_irq(cdev->ccwlock);
-	if (is_blacklisted(id->ssid, id->devno) &&
-	    (cdev->private->state == DEV_STATE_OFFLINE) &&
-	    (atomic_cmpxchg(&cdev->private->onoff, 0, 1) == 0)) {
-		CIO_MSG_EVENT(3, "ccw: purging 0.%x.%04x\n", id->ssid,
-			      id->devno);
+	struct ccw_device *cdev;
+
+	spin_lock_irq(sch->lock);
+	if (sch->st != SUBCHANNEL_TYPE_IO || !sch->schib.pmcw.dnv)
+		goto unlock;
+
+	if (!is_blacklisted(sch->schid.ssid, sch->schib.pmcw.dev))
+		goto unlock;
+
+	cdev = sch_get_cdev(sch);
+	if (cdev) {
+		if (cdev->private->state != DEV_STATE_OFFLINE)
+			goto unlock;
+
+		if (atomic_cmpxchg(&cdev->private->onoff, 0, 1) != 0)
+			goto unlock;
 		ccw_device_sched_todo(cdev, CDEV_TODO_UNREG);
-		css_sched_sch_todo(sch, SCH_TODO_UNREG);
 		atomic_set(&cdev->private->onoff, 0);
 	}
-	spin_unlock_irq(cdev->ccwlock);
+
+	css_sched_sch_todo(sch, SCH_TODO_UNREG);
+	CIO_MSG_EVENT(3, "ccw: purging 0.%x.%04x%s\n", sch->schid.ssid,
+		      sch->schib.pmcw.dev, cdev ? "" : " (no cdev)");
+
+unlock:
+	spin_unlock_irq(sch->lock);
 	/* Abort loop in case of pending signal. */
 	if (signal_pending(current))
 		return -EINTR;
@@ -1355,7 +1366,7 @@ static int purge_fn(struct device *dev,
 int ccw_purge_blacklisted(void)
 {
 	CIO_MSG_EVENT(2, "ccw: purging blacklisted devices\n");
-	bus_for_each_dev(&ccw_bus_type, NULL, NULL, purge_fn);
+	for_each_subchannel_staged(purge_fn, NULL, NULL);
 	return 0;
 }
 


