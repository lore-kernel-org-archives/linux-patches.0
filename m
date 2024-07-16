Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F5B1DDCE;
	Tue, 16 Jul 2024 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145165; cv=none; b=c2P+jdwR9s1EVJpxUJeNzmZN9LtsPaIAnIDsWdan7rJuzdG3RRQNAzA8QJTUzDfSg5WC6Zd9dVFvonkZbXhsm39IZZ4VIPTeYlg44wEU/4sj12wlY3SboDEwnC78F67OENN+IrnTu9/PUkv8YQ2WzkpxVu1gTlxcQ2R19bAyol0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145165; c=relaxed/simple;
	bh=+eYoPk/MwCSCBT2nMaLlJYrbDbPAIskh5Vw2TrNrmYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qP1ryebo8jkoyqc/UIziL8+Ei11vgSxOJhCot/ZAT1iTPo9w3ZTiJRPmIllyP0VCmK8zAobDJMGEifTukxdsZELSv0VBeN9zBp/+AdZC/NbTGIFEJULN17Am24Z7kKR0d5j8CXVvcq1t0Wc6Xf5gcHKOnTRPeHx4PG3r8Gs4dS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTKymMzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTKymMzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9103AC116B1;
	Tue, 16 Jul 2024 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145165;
	bh=+eYoPk/MwCSCBT2nMaLlJYrbDbPAIskh5Vw2TrNrmYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTKymMzEKatVHBMSYVTX9Ew6tTO2obXaPH/Y3o6lTCyUSO/hjGyK/tTHXFmxC+LhD
	 choE16hYCxPSlyLM/6+W7mRa8jmEXmApVNwgfVGRUEjimcOworiTq8SPR4+H2vfe9g
	 ca2CIp25PUXU+CJVzinsuMBDh+LaY6Kr9ZCy3C/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.9 093/143] scsi: sd: Do not repeat the starting disk message
Date: Tue, 16 Jul 2024 17:31:29 +0200
Message-ID: <20240716152759.554308808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4127,8 +4127,6 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -4145,12 +4143,13 @@ static int sd_resume_common(struct devic
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


