Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B692D7BF;
	Tue,  3 Dec 2024 15:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238999; cv=none; b=HdtvohbUlhkEk8XPmrZeGaCqalKRTCArAS/KUIGFNPZA+nLL0tJHcYCuwfMTRUguSlpredQ7xGFmYT5roU8U+Qwh9Vz+RpP0+XdNX7gqPwEfuSZE+vmM8FbkM8AaeKoCSQI+C2ybNdaxJc9joZcxRhJ0owObY3/hRLKgGdLAfEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238999; c=relaxed/simple;
	bh=KP2FjRCaZR0Ke94YqrpTHKC2eTpVvVTELUmmKFMUp7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilEr5roaWiRRL2lSXe10chION6HmaS/EJlnhph5XFSZxD808Gsih2oqwq0hsnLCLXHj+J/RrgP4EquNrdYREdLW6jFZ1qb0PdkGUp6vhFoaNkn15UNA2fye/3hSCug93Ppa17qDN8ol5mB/VnKHA9By9sNM3v5eiIyay5BbYgVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNxRQZjg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNxRQZjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A29C4CECF;
	Tue,  3 Dec 2024 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238998;
	bh=KP2FjRCaZR0Ke94YqrpTHKC2eTpVvVTELUmmKFMUp7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNxRQZjg3Xg6ecJ7td1gGRrHyWX+0mw9t5HC8bgqj/ItbDmFa7WpfBkUZHsAZblGm
	 9nP/ylOFJbCImhMQyW4cfndVmYLx0sIJHNopvPIsS4ZOYGkeAbp56WYOfAKdqgw0HY
	 ScvC0oXhrScwyzF1D8tCzSqXHyP20AGssEunqd3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 442/817] scsi: sg: Enable runtime power management
Date: Tue,  3 Dec 2024 15:40:14 +0100
Message-ID: <20241203144013.133397214@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4045de893f691f75193c606aec440c365cf7a7be ]

In 2010, runtime power management support was implemented in the SCSI
core.  The description of patch "[SCSI] implement runtime Power
Management" mentions that the sg driver is skipped but not why. This
patch enables runtime power management even if an instance of the sg
driver is held open.  Enabling runtime PM for the sg driver is safe
because all interactions of the sg driver with the SCSI device pass
through the block layer (blk_execute_rq_nowait()) and the block layer
already supports runtime PM.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Fixes: bc4f24014de5 ("[SCSI] implement runtime Power Management")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20241030220310.1373569-1-bvanassche@acm.org
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index baf870a03ecf6..9e6eebf307d3a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -307,10 +307,6 @@ sg_open(struct inode *inode, struct file *filp)
 	if (retval)
 		goto sg_put;
 
-	retval = scsi_autopm_get_device(device);
-	if (retval)
-		goto sdp_put;
-
 	/* scsi_block_when_processing_errors() may block so bypass
 	 * check if O_NONBLOCK. Permits SCSI commands to be issued
 	 * during error recovery. Tread carefully. */
@@ -318,7 +314,7 @@ sg_open(struct inode *inode, struct file *filp)
 	      scsi_block_when_processing_errors(device))) {
 		retval = -ENXIO;
 		/* we are in error recovery for this device */
-		goto error_out;
+		goto sdp_put;
 	}
 
 	mutex_lock(&sdp->open_rel_lock);
@@ -371,8 +367,6 @@ sg_open(struct inode *inode, struct file *filp)
 	}
 error_mutex_locked:
 	mutex_unlock(&sdp->open_rel_lock);
-error_out:
-	scsi_autopm_put_device(device);
 sdp_put:
 	kref_put(&sdp->d_ref, sg_device_destroy);
 	scsi_device_put(device);
@@ -392,7 +386,6 @@ sg_release(struct inode *inode, struct file *filp)
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp, "sg_release\n"));
 
 	mutex_lock(&sdp->open_rel_lock);
-	scsi_autopm_put_device(sdp->device);
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 	sdp->open_cnt--;
 
-- 
2.43.0



