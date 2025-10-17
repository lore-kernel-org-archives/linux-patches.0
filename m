Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CBF289811;
	Fri, 17 Oct 2025 15:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714164; cv=none; b=he+BLr4QzGWDkHu72q1+GoRJjsyQYIwEoXmA/gU1RkPnZStlRV5wIg5+E2mZCtBo2wJrD9Brj8IGLqByvojW7XeRTAjdNhM7ZrLkoytlrjvBrEZDDzJeVZBTUXnr61DZ5+zFqV29RQ5BsTr7jx3MGFh6CBfWRkb5Kaf34+jQpvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714164; c=relaxed/simple;
	bh=s/mmSxuPL3QpQVdkv7PzHZGv525uBgv/tfGzBO0M7Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqdFOfTmHNuohhfWaPx3SNGAmkfFil9JFldDCy6XmkrZ+t6fEqNfHFNKQysCiAQyMAGlNHz6lD3Pc4cFWMwjy8fBwfa9BkbBEmGyCyo+tBZNtHU/8OlsbS6JnnvztMK6KzBYrlZL+oGYvDwnvtKgHNKvEMQrZ8Zx+Jt5XVXCb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7eAm/AM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7eAm/AM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C3DC4CEE7;
	Fri, 17 Oct 2025 15:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714164;
	bh=s/mmSxuPL3QpQVdkv7PzHZGv525uBgv/tfGzBO0M7Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7eAm/AMvxGCiXM7E3mxfJyzFdDpOkd1c9Qp5+avWLTBgWAq0xOR5wd7O4DKPNU/Y
	 qYP9c3gGBGZ9DcH777vgQnjiLsFFFmI4G/bFv6TqhpOYmgEONuuYF0uUkI273Qhnm7
	 euPpwMjiz6/mIqxsGqKlEhC4/VM7BzAECjfqkcEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/277] s390/cio: Update purge function to unregister the unused subchannels
Date: Fri, 17 Oct 2025 16:50:56 +0200
Message-ID: <20251017145148.939164192@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Vineeth Vijayan <vneethv@linux.ibm.com>

[ Upstream commit 9daa5a8795865f9a3c93d8d1066785b07ded6073 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 9498825d9c7a5..858a9e171351b 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1318,23 +1318,34 @@ void ccw_device_schedule_recovery(void)
 	spin_unlock_irqrestore(&recovery_lock, flags);
 }
 
-static int purge_fn(struct device *dev, void *data)
+static int purge_fn(struct subchannel *sch, void *data)
 {
-	struct ccw_device *cdev = to_ccwdev(dev);
-	struct ccw_dev_id *id = &cdev->private->dev_id;
-	struct subchannel *sch = to_subchannel(cdev->dev.parent);
+	struct ccw_device *cdev;
 
-	spin_lock_irq(cdev->ccwlock);
-	if (is_blacklisted(id->ssid, id->devno) &&
-	    (cdev->private->state == DEV_STATE_OFFLINE) &&
-	    (atomic_cmpxchg(&cdev->private->onoff, 0, 1) == 0)) {
-		CIO_MSG_EVENT(3, "ccw: purging 0.%x.%04x\n", id->ssid,
-			      id->devno);
+	spin_lock_irq(&sch->lock);
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
+	spin_unlock_irq(&sch->lock);
 	/* Abort loop in case of pending signal. */
 	if (signal_pending(current))
 		return -EINTR;
@@ -1350,7 +1361,7 @@ static int purge_fn(struct device *dev, void *data)
 int ccw_purge_blacklisted(void)
 {
 	CIO_MSG_EVENT(2, "ccw: purging blacklisted devices\n");
-	bus_for_each_dev(&ccw_bus_type, NULL, NULL, purge_fn);
+	for_each_subchannel_staged(purge_fn, NULL, NULL);
 	return 0;
 }
 
-- 
2.51.0



