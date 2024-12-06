Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4341474AF;
	Fri,  6 Dec 2024 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497484; cv=none; b=u6pPvHfaXszSfdhT2/NbOn5vm1cfnJCWXEV//dKZboxlg6r3S/MTNTYHTuY6iDZa4X9T/jAj8S1OogRt3fn+TB82/7WNLL2d2DOsEZ+M01k7E/3tM85RhokT6dfsaJUPze89CQ+tMz3ayFX0bJGFGKHUTpKWApK3aTVyCwW97Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497484; c=relaxed/simple;
	bh=ggdb6dsZmfBOekTtTZpc0c6+2D7N9ooBfiWSoOQ5iYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zy6TS0vZ81kCpHl6BGxrsEguv8Lv6Yai6xNljesZv4rF4VO080PC3dT0zNMXDMxYLA4gbXtxjlBIJEeWkl9iZY9YcZh+br2SWnZvzVF2YWdbUvfZW5vGkRk0O12Wr5cQ0H3N/guPBPD2+aF0v1BeWehqIeh1zKrOmn6f83EI4QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knIW3uNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knIW3uNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB6DC4CED1;
	Fri,  6 Dec 2024 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497483;
	bh=ggdb6dsZmfBOekTtTZpc0c6+2D7N9ooBfiWSoOQ5iYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knIW3uNjJHSFLFLN8FWr7x4bKNJ6s6Qdz4xn/ev+WTHc9W4hsVuLSVMWkFFvcuJBd
	 LctfOjONeWJz38wsugxxzAjVJqxBB1nqElszjNhlkl8jJfNW84Vec76I1RFGhHw5gz
	 zbPZfaaxUOjEI79nqsDPzTDd1VyuH++PoqJmpj7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/676] scsi: sg: Enable runtime power management
Date: Fri,  6 Dec 2024 15:32:04 +0100
Message-ID: <20241206143705.255224786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index e6d8beb877766..dc9722b290f20 100644
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



