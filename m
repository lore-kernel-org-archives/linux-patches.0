Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA62C1A5;
	Mon, 12 Aug 2024 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480291; cv=none; b=tPXDzy1mZZSO1Tb8XXIEGexmgzSQezlBj6A7P/GReJmx6wTyL1UXvCLtChTQkShAjRUMrvu0VWMma9jpeMIJlVZ3gq2Y3XjqFF6c58U03yhKBk0XcW8KzQU3npwkE6jN9/ZJwlpL/LMGGp/4KHGdbK4v1dYVBHNab+IZgxIx1To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480291; c=relaxed/simple;
	bh=ojyDG1uCalYpHBwz1qK4XsDQXAUhG5V423fE2ITJ2vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MemcrvM47Lw1ofdOLqe5NyI2VOZxMqPdzLDK1iKRS7MgHGoPuclgr0l6mAeDf1Icx05fAQiSjJEiYjTXKg/QtYIItqQFL8zRh8g30/7QGHv7Myrm/KorxZJWlW3ajw8l4mYEPEDxs+L9ZTPTMfZcycrlDc9XF3FTYYgbvjjAjsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tcm5386Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tcm5386Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DECEC32782;
	Mon, 12 Aug 2024 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480290;
	bh=ojyDG1uCalYpHBwz1qK4XsDQXAUhG5V423fE2ITJ2vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcm5386Z3x4X7v0+N80PDDEJrveEVL/ttVkpXtPw0ugmv2xNxPFvL1ZBKcxcY9Bb+
	 mQI5YMO9XZ5Px0vxC5PH7wDzKSfwUWE925tuvTjcJqIijUHvO0KM4FiE2k2AWScgZd
	 6MZ2r8sYWgjhFf2ooMcU3O0JuB4oUBIxS4ULCxDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 121/263] scsi: Revert "scsi: sd: Do not repeat the starting disk message"
Date: Mon, 12 Aug 2024 18:02:02 +0200
Message-ID: <20240812160151.180502887@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit da3e19ef0b3de0aa4b25595bdc214c02a04f19b8 upstream.

This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.

The offending commit tried to suppress a double "Starting disk" message for
some drivers, but instead started spamming the log with bogus messages
every five seconds:

	[  311.798956] sd 0:0:0:0: [sda] Starting disk
	[  316.919103] sd 0:0:0:0: [sda] Starting disk
	[  322.040775] sd 0:0:0:0: [sda] Starting disk
	[  327.161140] sd 0:0:0:0: [sda] Starting disk
	[  332.281352] sd 0:0:0:0: [sda] Starting disk
	[  337.401878] sd 0:0:0:0: [sda] Starting disk
	[  342.521527] sd 0:0:0:0: [sda] Starting disk
	[  345.850401] sd 0:0:0:0: [sda] Starting disk
	[  350.967132] sd 0:0:0:0: [sda] Starting disk
	[  356.090454] sd 0:0:0:0: [sda] Starting disk
	...

on machines that do not actually stop the disk on runtime suspend (e.g.
the Qualcomm sc8280xp CRD with UFS).

Let's just revert for now to address the regression.

Fixes: 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk message")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240716161101.30692-1-johan+linaro@kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4119,6 +4119,8 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -4135,13 +4137,12 @@ static int sd_resume_common(struct devic
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (!sd_do_start_stop(sdkp->device, runtime)) {
 		sdkp->suspended = false;
 		return 0;
 	}
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);


