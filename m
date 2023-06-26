Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EB4134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB13C433C8;
	Mon, 26 Jun 2023 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803345;
	bh=9azkbe3XjzKyrIsQBjASTRZeRfUcsO9R5leiMXv9vZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxwweNycE876uFNH+1MyGoaqrKzXgOE/ziddk41znHNBQ34zLwzDVJmzsE9S8aOnl
	 lhYuv1gdiYnnoq8JrRqwpEMCcRAH+dzp8YgBtXucz7w5RzbaZFHvTuUINgFjARaeIV
	 OPCaYnybcJZqrsMVmLrlmFvWQHneX7rDkBiz3Mto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Joe Breuer <linux-kernel@jmbreuer.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 005/199] ata: libata-scsi: Avoid deadlock on rescan after device resume
Date: Mon, 26 Jun 2023 20:08:31 +0200
Message-ID: <20230626180805.887749702@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 6aa0365a3c8512587fffd42fe438768709ddef8e ]

When an ATA port is resumed from sleep, the port is reset and a power
management request issued to libata EH to reset the port and rescanning
the device(s) attached to the port. Device rescanning is done by
scheduling an ata_scsi_dev_rescan() work, which will execute
scsi_rescan_device().

However, scsi_rescan_device() takes the generic device lock, which is
also taken by dpm_resume() when the SCSI device is resumed as well. If
a device rescan execution starts before the completion of the SCSI
device resume, the rcu locking used to refresh the cached VPD pages of
the device, combined with the generic device locking from
scsi_rescan_device() and from dpm_resume() can cause a deadlock.

Avoid this situation by changing struct ata_port scsi_rescan_task to be
a delayed work instead of a simple work_struct. ata_scsi_dev_rescan() is
modified to check if the SCSI device associated with the ATA device that
must be rescanned is not suspended. If the SCSI device is still
suspended, ata_scsi_dev_rescan() returns early and reschedule itself for
execution after an arbitrary delay of 5ms.

Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: Joe Breuer <linux-kernel@jmbreuer.net>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217530
Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Joe Breuer <linux-kernel@jmbreuer.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c |  3 ++-
 drivers/ata/libata-eh.c   |  2 +-
 drivers/ata/libata-scsi.c | 22 +++++++++++++++++++++-
 include/linux/libata.h    |  2 +-
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 14c17c3bda4e6..d37df499c9fa6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5348,7 +5348,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	mutex_init(&ap->scsi_scan_mutex);
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
-	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
+	INIT_DELAYED_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
 	init_waitqueue_head(&ap->eh_wait_q);
 	init_completion(&ap->park_req_pending);
@@ -5954,6 +5954,7 @@ static void ata_port_detach(struct ata_port *ap)
 	WARN_ON(!(ap->pflags & ATA_PFLAG_UNLOADED));
 
 	cancel_delayed_work_sync(&ap->hotplug_task);
+	cancel_delayed_work_sync(&ap->scsi_rescan_task);
 
  skip_eh:
 	/* clean up zpodd on port removal */
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index a6c9018118027..6f8d141915939 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2984,7 +2984,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			ehc->i.flags |= ATA_EHI_SETMODE;
 
 			/* schedule the scsi_rescan_device() here */
-			schedule_work(&(ap->scsi_rescan_task));
+			schedule_delayed_work(&ap->scsi_rescan_task, 0);
 		} else if (dev->class == ATA_DEV_UNKNOWN &&
 			   ehc->tries[dev->devno] &&
 			   ata_class_enabled(ehc->classes[dev->devno])) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a9e768fdae4e3..51673d95e5b22 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4597,10 +4597,11 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 void ata_scsi_dev_rescan(struct work_struct *work)
 {
 	struct ata_port *ap =
-		container_of(work, struct ata_port, scsi_rescan_task);
+		container_of(work, struct ata_port, scsi_rescan_task.work);
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long flags;
+	bool delay_rescan = false;
 
 	mutex_lock(&ap->scsi_scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
@@ -4614,6 +4615,21 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 			if (scsi_device_get(sdev))
 				continue;
 
+			/*
+			 * If the rescan work was scheduled because of a resume
+			 * event, the port is already fully resumed, but the
+			 * SCSI device may not yet be fully resumed. In such
+			 * case, executing scsi_rescan_device() may cause a
+			 * deadlock with the PM code on device_lock(). Prevent
+			 * this by giving up and retrying rescan after a short
+			 * delay.
+			 */
+			delay_rescan = sdev->sdev_gendev.power.is_suspended;
+			if (delay_rescan) {
+				scsi_device_put(sdev);
+				break;
+			}
+
 			spin_unlock_irqrestore(ap->lock, flags);
 			scsi_rescan_device(&(sdev->sdev_gendev));
 			scsi_device_put(sdev);
@@ -4623,4 +4639,8 @@ void ata_scsi_dev_rescan(struct work_struct *work)
 
 	spin_unlock_irqrestore(ap->lock, flags);
 	mutex_unlock(&ap->scsi_scan_mutex);
+
+	if (delay_rescan)
+		schedule_delayed_work(&ap->scsi_rescan_task,
+				      msecs_to_jiffies(5));
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a759dfbdcc91a..bb5dda3ec2db5 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -836,7 +836,7 @@ struct ata_port {
 
 	struct mutex		scsi_scan_mutex;
 	struct delayed_work	hotplug_task;
-	struct work_struct	scsi_rescan_task;
+	struct delayed_work	scsi_rescan_task;
 
 	unsigned int		hsm_task_state;
 
-- 
2.39.2



