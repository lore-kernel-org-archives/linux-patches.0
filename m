Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5956824B34;
	Mon, 14 Oct 2024 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916666; cv=none; b=Qbo44NjD55NmyCAD4V1ooItwxpqDxUAeGUzp9x9STnbo+0N7oJxzFUaDult4E8L1aDaeQ4CO72x1faUZBtzmYbWz20TwAtiDaVe3MqD91zxYE/YAJllkMDR4771q7am4i0+wRZCH3KpROIIbPLnEhJN0BRzdN/1x6zZyQRZ8LV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916666; c=relaxed/simple;
	bh=2RS9gjam0cPhVl4mFpjPRXUmfb0Jx+g2hNSSHvTYiME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvDdUjBeIaiuwA5NRA2KO/54NbWcc7zeZ7xisvv2QLc8itu2bLJJ4tFmwB4QJ2bfNhZ8jr+4pPSKKLPllcS/YzBiSvd5yrP0zfE936pbj+gbu8XC0udlCFNnSabf/Ah5QBSn4kjoLtsdEGs+dG3rYo8MeoHJXZhOAzURMiIUKoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2Bbck1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2Bbck1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BF3C4CEC3;
	Mon, 14 Oct 2024 14:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916666;
	bh=2RS9gjam0cPhVl4mFpjPRXUmfb0Jx+g2hNSSHvTYiME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2Bbck1YbYkYIBBwXue70yrGycmA1la4+fs4qewRoXo5/wBPBjp5I12bF5EEq1R4T
	 HIy0yVK2W8drfltFjc0Or8m5KwFQIpmf/aSLOk4303w5jX8rQrJtauMd6qehFITUr+
	 z1y6DCx3LGByZCCj3yWhzYMPFB7MiFUI4tgxMr3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/213] scsi: sd: Do not repeat the starting disk message
Date: Mon, 14 Oct 2024 16:18:57 +0200
Message-ID: <20241014141044.201197805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4 ]

The SCSI disk message "Starting disk" to signal resuming of a suspended
disk is printed in both sd_resume() and sd_resume_common() which results
in this message being printed twice when resuming from e.g. autosuspend:

$ echo 5000 > /sys/block/sda/device/power/autosuspend_delay_ms
$ echo auto > /sys/block/sda/device/power/control

[ 4962.438293] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 4962.501121] sd 0:0:0:0: [sda] Stopping disk

$ echo on > /sys/block/sda/device/power/control

[ 4972.805851] sd 0:0:0:0: [sda] Starting disk
[ 4980.558806] sd 0:0:0:0: [sda] Starting disk

Fix this double print by removing the call to sd_printk() from sd_resume()
and moving the call to sd_printk() in sd_resume_common() earlier in the
function, before the check using sd_do_start_stop().  Doing so, the message
is printed once regardless if sd_resume_common() actually executes
sd_start_stop_device() (i.e. SCSI device case) or not (libsas and libata
managed ATA devices case).

Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240701215326.128067-1-dlemoal@kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c627deedc1fa..7c25adb00e95d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3955,8 +3955,6 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -3973,12 +3971,13 @@ static int sd_resume_common(struct device *dev, bool runtime)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
 	if (!sd_do_start_stop(sdkp->device, runtime)) {
 		sdkp->suspended = false;
 		return 0;
 	}
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);
-- 
2.43.0



