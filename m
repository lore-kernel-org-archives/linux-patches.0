Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75657BB15;
	Mon,  8 Apr 2024 14:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584937; cv=none; b=MSc0IWjNUwL7i9koJPCgC1h5XZUqCSjhQFnaXnYDyyIoO2kPYJdtXwDbmJZc33QhHiqVUzprW9Aa3JjH9Dsi8rA2W6wj6E8iCMvjemPOfZ5S+9YNdtM0suiKIY5X7IIXod0EVsXFKausHNz/jMwtK2bJQUtGdYAmPLRr4DBS+J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584937; c=relaxed/simple;
	bh=/iO3pfCa9DaPOYswZfHEDY68Art7tG8bb7yGnumGSWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqH7vBR+4zPdzylBJCktBokuHLxx70UK5BPU++n88e6L8vAYWyjYmYHYRylGOqIXnq1iOS0Rdss6S94b6zlvo/9gkHz1TcIYUWSsWRqp6j1ufNrnc9muiR4u3GZ3Kq/7Q0hmWauwD6VbrZNAhsruygjwf9ppQaJoB/dzt13ed1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VwoytcoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VwoytcoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F631C433F1;
	Mon,  8 Apr 2024 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584937;
	bh=/iO3pfCa9DaPOYswZfHEDY68Art7tG8bb7yGnumGSWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwoytcoUiAPJECIga3gEEtZWbZ1ieUnmZeVdwFSRkdbmqr9hfMuORF6UgB4I0V5l6
	 +uLKTpuDPH8lVfEt085uQfIhfhhiZZrxpjjHsiI/8zZPeRBdTjQGkZ2BDARkdmmLt9
	 yUsCJPYjOjB4bxtQESWNSo8DMazQYe+Ii4s4BgMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-usb@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Oliver Neukum <oneukum@suse.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 607/690] scsi: usb: Stop using the SCSI pointer
Date: Mon,  8 Apr 2024 14:57:53 +0200
Message-ID: <20240408125421.592860359@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 5dfcf1ad933fe877cb44e9fb7a661dfc22190101 ]

Set scsi_host_template.cmd_size instead of using the SCSI pointer for
storing driver-private data. Change the type of the argument of
uas_add_work() from struct uas_cmd_info * into struct scsi_cmnd * because
it is easier to convert a SCSI command pointer into a uas_cmd_info pointer
than the other way around.

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Link: https://lore.kernel.org/r/20220218195117.25689-46-bvanassche@acm.org
Cc: linux-usb@vger.kernel.org
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: cd5432c71235 ("USB: UAS: return ENODEV when submit urbs fail with device not attached")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/uas.c | 43 ++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 774d18907f472..d11a9481f6d00 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -113,7 +113,7 @@ static void uas_do_work(struct work_struct *work)
 			continue;
 
 		cmnd = devinfo->cmnd[i];
-		cmdinfo = (void *)&cmnd->SCp;
+		cmdinfo = scsi_cmd_priv(cmnd);
 
 		if (!(cmdinfo->state & IS_IN_WORK_LIST))
 			continue;
@@ -139,10 +139,9 @@ static void uas_scan_work(struct work_struct *work)
 	dev_dbg(&devinfo->intf->dev, "scan complete\n");
 }
 
-static void uas_add_work(struct uas_cmd_info *cmdinfo)
+static void uas_add_work(struct scsi_cmnd *cmnd)
 {
-	struct scsi_pointer *scp = (void *)cmdinfo;
-	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = cmnd->device->hostdata;
 
 	lockdep_assert_held(&devinfo->lock);
@@ -163,7 +162,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 			continue;
 
 		cmnd = devinfo->cmnd[i];
-		cmdinfo = (void *)&cmnd->SCp;
+		cmdinfo = scsi_cmd_priv(cmnd);
 		uas_log_cmd_state(cmnd, __func__, 0);
 		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
 		cmdinfo->state &= ~COMMAND_INFLIGHT;
@@ -200,15 +199,14 @@ static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
 static void uas_log_cmd_state(struct scsi_cmnd *cmnd, const char *prefix,
 			      int status)
 {
-	struct uas_cmd_info *ci = (void *)&cmnd->SCp;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *ci = scsi_cmd_priv(cmnd);
 
 	if (status == -ENODEV) /* too late */
 		return;
 
 	scmd_printk(KERN_INFO, cmnd,
 		    "%s %d uas-tag %d inflight:%s%s%s%s%s%s%s%s%s%s%s%s ",
-		    prefix, status, cmdinfo->uas_tag,
+		    prefix, status, ci->uas_tag,
 		    (ci->state & SUBMIT_STATUS_URB)     ? " s-st"  : "",
 		    (ci->state & ALLOC_DATA_IN_URB)     ? " a-in"  : "",
 		    (ci->state & SUBMIT_DATA_IN_URB)    ? " s-in"  : "",
@@ -231,7 +229,7 @@ static void uas_free_unsubmitted_urbs(struct scsi_cmnd *cmnd)
 	if (!cmnd)
 		return;
 
-	cmdinfo = (void *)&cmnd->SCp;
+	cmdinfo = scsi_cmd_priv(cmnd);
 
 	if (cmdinfo->state & SUBMIT_CMD_URB)
 		usb_free_urb(cmdinfo->cmd_urb);
@@ -245,7 +243,7 @@ static void uas_free_unsubmitted_urbs(struct scsi_cmnd *cmnd)
 
 static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 
 	lockdep_assert_held(&devinfo->lock);
@@ -263,13 +261,13 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
 			  unsigned direction)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	int err;
 
 	cmdinfo->state |= direction | SUBMIT_STATUS_URB;
 	err = uas_submit_urbs(cmnd, cmnd->device->hostdata);
 	if (err) {
-		uas_add_work(cmdinfo);
+		uas_add_work(cmnd);
 	}
 }
 
@@ -329,7 +327,7 @@ static void uas_stat_cmplt(struct urb *urb)
 	}
 
 	cmnd = devinfo->cmnd[idx];
-	cmdinfo = (void *)&cmnd->SCp;
+	cmdinfo = scsi_cmd_priv(cmnd);
 
 	if (!(cmdinfo->state & COMMAND_INFLIGHT)) {
 		uas_log_cmd_state(cmnd, "unexpected status cmplt", 0);
@@ -394,7 +392,7 @@ static void uas_stat_cmplt(struct urb *urb)
 static void uas_data_cmplt(struct urb *urb)
 {
 	struct scsi_cmnd *cmnd = urb->context;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 	struct scsi_data_buffer *sdb = &cmnd->sdb;
 	unsigned long flags;
@@ -446,7 +444,7 @@ static struct urb *uas_alloc_data_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 				      enum dma_data_direction dir)
 {
 	struct usb_device *udev = devinfo->udev;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct scsi_data_buffer *sdb = &cmnd->sdb;
 	unsigned int pipe = (dir == DMA_FROM_DEVICE)
@@ -468,7 +466,7 @@ static struct urb *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 				       struct scsi_cmnd *cmnd)
 {
 	struct usb_device *udev = devinfo->udev;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct sense_iu *iu;
 
@@ -496,7 +494,7 @@ static struct urb *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
 {
 	struct usb_device *udev = devinfo->udev;
 	struct scsi_device *sdev = cmnd->device;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb = usb_alloc_urb(0, gfp);
 	struct command_iu *iu;
 	int len;
@@ -558,7 +556,7 @@ static struct urb *uas_submit_sense_urb(struct scsi_cmnd *cmnd, gfp_t gfp)
 static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 			   struct uas_dev_info *devinfo)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct urb *urb;
 	int err;
 
@@ -638,12 +636,10 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 {
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	unsigned long flags;
 	int idx, err;
 
-	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
-
 	/* Re-check scsi_block_requests now that we've the host-lock */
 	if (cmnd->device->host->host_self_blocked)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
@@ -713,7 +709,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 			spin_unlock_irqrestore(&devinfo->lock, flags);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
-		uas_add_work(cmdinfo);
+		uas_add_work(cmnd);
 	}
 
 	devinfo->cmnd[idx] = cmnd;
@@ -731,7 +727,7 @@ static DEF_SCSI_QCMD(uas_queuecommand)
  */
 static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 {
-	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	struct uas_cmd_info *cmdinfo = scsi_cmd_priv(cmnd);
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 	struct urb *data_in_urb = NULL;
 	struct urb *data_out_urb = NULL;
@@ -911,6 +907,7 @@ static struct scsi_host_template uas_host_template = {
 	.this_id = -1,
 	.skip_settle_delay = 1,
 	.dma_boundary = PAGE_SIZE - 1,
+	.cmd_size = sizeof(struct uas_cmd_info),
 };
 
 #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
-- 
2.43.0



