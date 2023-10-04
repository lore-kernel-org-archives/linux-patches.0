Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767D71C291
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAJGVNpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADADC433C8;
	Wed,  4 Oct 2023 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444484;
	bh=CB6ZtaM0kpWJJ2ZDyY4CjB24ikxU0rtOHK4bhVvRiwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAJGVNpbPwhLwog+H+Y5hNVGWPai7wt12X5oP0eU2nv4UYGqO+om6nbJM1xnhSvfA
	 JLel47V1XZPtxfm79sT3JzuXMS4R0GBoxfIDDfUtKWJeBQDLFNN7MkEKt60YOxafJE
	 5TeTDxI5x2wS4hTBRPPwR9B1oL+oTW+YmkY8qwdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 266/321] scsi: sd: Do not issue commands to suspended disks on shutdown
Date: Wed,  4 Oct 2023 19:56:51 +0200
Message-ID: <20231004175241.594324628@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 99398d2070ab03d13f90b758ad397e19a65fffb0 upstream.

If an error occurs when resuming a host adapter before the devices
attached to the adapter are resumed, the adapter low level driver may
remove the scsi host, resulting in a call to sd_remove() for the
disks of the host. This in turn results in a call to sd_shutdown() which
will issue a synchronize cache command and a start stop unit command to
spindown the disk. sd_shutdown() issues the commands only if the device
is not already runtime suspended but does not check the power state for
system-wide suspend/resume. That is, the commands may be issued with the
device in a suspended state, which causes PM resume to hang, forcing a
reset of the machine to recover.

Fix this by tracking the suspended state of a disk by introducing the
suspended boolean field in the scsi_disk structure. This flag is set to
true when the disk is suspended is sd_suspend_common() and resumed with
sd_resume(). When suspended is true, sd_shutdown() is not executed from
sd_remove().

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |   17 +++++++++++++----
 drivers/scsi/sd.h |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3780,7 +3780,8 @@ static int sd_remove(struct device *dev)
 
 	device_del(&sdkp->disk_dev);
 	del_gendisk(sdkp->disk);
-	sd_shutdown(dev);
+	if (!sdkp->suspended)
+		sd_shutdown(dev);
 
 	put_disk(sdkp->disk);
 	return 0;
@@ -3911,6 +3912,9 @@ static int sd_suspend_common(struct devi
 			ret = 0;
 	}
 
+	if (!ret)
+		sdkp->suspended = true;
+
 	return ret;
 }
 
@@ -3930,21 +3934,26 @@ static int sd_suspend_runtime(struct dev
 static int sd_resume(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	int ret;
+	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	if (!sd_do_start_stop(sdkp->device, runtime))
+	if (!sd_do_start_stop(sdkp->device, runtime)) {
+		sdkp->suspended = false;
 		return 0;
+	}
 
 	if (!sdkp->device->no_start_on_resume) {
 		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 		ret = sd_start_stop_device(sdkp, 1);
 	}
 
-	if (!ret)
+	if (!ret) {
 		opal_unlock_from_suspend(sdkp->opal_dev);
+		sdkp->suspended = false;
+	}
+
 	return ret;
 }
 
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -131,6 +131,7 @@ struct scsi_disk {
 	u8		provisioning_mode;
 	u8		zeroing_mode;
 	u8		nr_actuators;		/* Number of actuators */
+	bool		suspended;	/* Disk is suspended (stopped) */
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */


