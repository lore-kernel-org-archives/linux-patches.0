Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E9A1C0DE7;
	Mon,  1 Apr 2024 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989129; cv=none; b=qUxOE/2VsTL9+rdswTy4ITtXtFrdV+8frK8n7cGFWVY7AxNi274L4NBc3DWSyVFbsJVdRpD2xc+AG/29C+PoKRfAeBdPNlqH0Ptb2y55UaBLkPQpjGCqIMGiqCPHSXlOH0bLesj00BTqic2gRX9wDzO6joPUOq56xnOYeIH3ktA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989129; c=relaxed/simple;
	bh=CNf11PZqUPPs1UucV3VBGJyNRQVnu9kinuyr2VjWEUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPJnwwT+bl0EHlOUC9DfgkcKqpOUwQL62d6MgtMNGZGGjHp7X1bz/XYLB8JchjHoF5iCEYc6GblAMnLIgTEDJkh8m2V3iiRrfqiBJutFUFCyxGxDQ/LIbJjFQixg/Vqk8e7blo9KM8p6KWl/fSE0HyD2/n+14qImGxZa67gitzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4Z3dY10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4Z3dY10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D775C433C7;
	Mon,  1 Apr 2024 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989128;
	bh=CNf11PZqUPPs1UucV3VBGJyNRQVnu9kinuyr2VjWEUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4Z3dY10sXVvKQeWXvwJYhmf22xyUXe1BbavZFnzt01QK3VR+yDXwzlDYGGEwiK5B
	 0NJ8rBLGm8Ao3nN1bDMQLCUhcAejhEVP+b28QVXvWGh05Agwg0VwLu6KApyQkluzZP
	 CwnpsCnCzBep9zoqgiqtKVwUMJTvFbOf45h8VIIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 390/432] scsi: sd: Fix TCG OPAL unlock on system resume
Date: Mon,  1 Apr 2024 17:46:17 +0200
Message-ID: <20240401152604.952568935@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 0c76106cb97548810214def8ee22700bbbb90543 upstream.

Commit 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime start/stop
management") introduced the manage_system_start_stop scsi_device flag to
allow libata to indicate to the SCSI disk driver that nothing should be
done when resuming a disk on system resume. This change turned the
execution of sd_resume() into a no-op for ATA devices on system
resume. While this solved deadlock issues during device resume, this change
also wrongly removed the execution of opal_unlock_from_suspend().  As a
result, devices with TCG OPAL locking enabled remain locked and
inaccessible after a system resume from sleep.

To fix this issue, introduce the SCSI driver resume method and implement it
with the sd_resume() function calling opal_unlock_from_suspend(). The
former sd_resume() function is renamed to sd_resume_common() and modified
to call the new sd_resume() function. For non-ATA devices, this result in
no functional changes.

In order for libata to explicitly execute sd_resume() when a device is
resumed during system restart, the function scsi_resume_device() is
introduced. libata calls this function from the revalidation work executed
on devie resume, a state that is indicated with the new device flag
ATA_DFLAG_RESUMING. Doing so, locked TCG OPAL enabled devices are unlocked
on resume, allowing normal operation.

Fixes: 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime start/stop management")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218538
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240319071209.1179257-1-dlemoal@kernel.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c    |    5 ++++-
 drivers/ata/libata-scsi.c  |    9 +++++++++
 drivers/scsi/scsi_scan.c   |   34 ++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c          |   23 +++++++++++++++++++----
 include/linux/libata.h     |    1 +
 include/scsi/scsi_driver.h |    1 +
 include/scsi/scsi_host.h   |    1 +
 7 files changed, 69 insertions(+), 5 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -712,8 +712,10 @@ void ata_scsi_port_error_handler(struct
 				ehc->saved_ncq_enabled |= 1 << devno;
 
 			/* If we are resuming, wake up the device */
-			if (ap->pflags & ATA_PFLAG_RESUMING)
+			if (ap->pflags & ATA_PFLAG_RESUMING) {
+				dev->flags |= ATA_DFLAG_RESUMING;
 				ehc->i.dev_action[devno] |= ATA_EH_SET_ACTIVE;
+			}
 		}
 	}
 
@@ -3169,6 +3171,7 @@ static int ata_eh_revalidate_and_attach(
 	return 0;
 
  err:
+	dev->flags &= ~ATA_DFLAG_RESUMING;
 	*r_failed_dev = dev;
 	return rc;
 }
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4730,6 +4730,7 @@ void ata_scsi_dev_rescan(struct work_str
 	struct ata_link *link;
 	struct ata_device *dev;
 	unsigned long flags;
+	bool do_resume;
 	int ret = 0;
 
 	mutex_lock(&ap->scsi_scan_mutex);
@@ -4751,7 +4752,15 @@ void ata_scsi_dev_rescan(struct work_str
 			if (scsi_device_get(sdev))
 				continue;
 
+			do_resume = dev->flags & ATA_DFLAG_RESUMING;
+
 			spin_unlock_irqrestore(ap->lock, flags);
+			if (do_resume) {
+				ret = scsi_resume_device(sdev);
+				if (ret == -EWOULDBLOCK)
+					goto unlock;
+				dev->flags &= ~ATA_DFLAG_RESUMING;
+			}
 			ret = scsi_rescan_device(sdev);
 			scsi_device_put(sdev);
 			spin_lock_irqsave(ap->lock, flags);
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1619,6 +1619,40 @@ int scsi_add_device(struct Scsi_Host *ho
 }
 EXPORT_SYMBOL(scsi_add_device);
 
+int scsi_resume_device(struct scsi_device *sdev)
+{
+	struct device *dev = &sdev->sdev_gendev;
+	int ret = 0;
+
+	device_lock(dev);
+
+	/*
+	 * Bail out if the device or its queue are not running. Otherwise,
+	 * the rescan may block waiting for commands to be executed, with us
+	 * holding the device lock. This can result in a potential deadlock
+	 * in the power management core code when system resume is on-going.
+	 */
+	if (sdev->sdev_state != SDEV_RUNNING ||
+	    blk_queue_pm_only(sdev->request_queue)) {
+		ret = -EWOULDBLOCK;
+		goto unlock;
+	}
+
+	if (dev->driver && try_module_get(dev->driver->owner)) {
+		struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+		if (drv->resume)
+			ret = drv->resume(dev);
+		module_put(dev->driver->owner);
+	}
+
+unlock:
+	device_unlock(dev);
+
+	return ret;
+}
+EXPORT_SYMBOL(scsi_resume_device);
+
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3948,7 +3948,21 @@ static int sd_suspend_runtime(struct dev
 	return sd_suspend_common(dev, true);
 }
 
-static int sd_resume(struct device *dev, bool runtime)
+static int sd_resume(struct device *dev)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
+	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
+		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int sd_resume_common(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	int ret;
@@ -3964,7 +3978,7 @@ static int sd_resume(struct device *dev,
 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
-		opal_unlock_from_suspend(sdkp->opal_dev);
+		sd_resume(dev);
 		sdkp->suspended = false;
 	}
 
@@ -3983,7 +3997,7 @@ static int sd_resume_system(struct devic
 		return 0;
 	}
 
-	return sd_resume(dev, false);
+	return sd_resume_common(dev, false);
 }
 
 static int sd_resume_runtime(struct device *dev)
@@ -4010,7 +4024,7 @@ static int sd_resume_runtime(struct devi
 				  "Failed to clear sense data\n");
 	}
 
-	return sd_resume(dev, true);
+	return sd_resume_common(dev, true);
 }
 
 static const struct dev_pm_ops sd_pm_ops = {
@@ -4033,6 +4047,7 @@ static struct scsi_driver sd_template =
 		.pm		= &sd_pm_ops,
 	},
 	.rescan			= sd_rescan,
+	.resume			= sd_resume,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
 	.done			= sd_done,
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -107,6 +107,7 @@ enum {
 
 	ATA_DFLAG_NCQ_PRIO_ENABLED = (1 << 20), /* Priority cmds sent to dev */
 	ATA_DFLAG_CDL_ENABLED	= (1 << 21), /* cmd duration limits is enabled */
+	ATA_DFLAG_RESUMING	= (1 << 22),  /* Device is resuming */
 	ATA_DFLAG_DETACH	= (1 << 24),
 	ATA_DFLAG_DETACHED	= (1 << 25),
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -12,6 +12,7 @@ struct request;
 struct scsi_driver {
 	struct device_driver	gendrv;
 
+	int (*resume)(struct device *);
 	void (*rescan)(struct device *);
 	blk_status_t (*init_command)(struct scsi_cmnd *);
 	void (*uninit_command)(struct scsi_cmnd *);
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -767,6 +767,7 @@ scsi_template_proc_dir(const struct scsi
 #define scsi_template_proc_dir(sht) NULL
 #endif
 extern void scsi_scan_host(struct Scsi_Host *);
+extern int scsi_resume_device(struct scsi_device *sdev);
 extern int scsi_rescan_device(struct scsi_device *sdev);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);


