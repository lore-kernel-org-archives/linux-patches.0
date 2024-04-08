Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6167C6EB;
	Mon,  8 Apr 2024 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584935; cv=none; b=gi+HfAqcOYSY+HyOwrJsw46ykibpl4JrULB8vnaKsAiYUxu+FZSRO2FfzFvohgeCwXFXMtxvqUvWnY5WUK/Q6Ym9WxdpK37wNgM922Na6vSQpb3J1Dr6pYMuPcOWU+8oxyudtW7GVxZYBYChuag9XWIFkubwyD7wCJGiXF/oObA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584935; c=relaxed/simple;
	bh=HgqDVC2ZDMjUyreQ7nLnQwIOmtMEjXwPfwmLfJKS6DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq15iOdg6+Txmu8vqOqaSwmn7NxprK7Yrj2oSehRUFtBZjzX+FHfbkL+68kfd0jKR+jiw2NAbnELogrMXf0CJN03yBPv03ktxzr1hMH9ToKOIgdVKeaN2TrexG9LJLbnFZGGn8glRot+6DmNY5ZWCDlSmf4nHXs9WXYcBcVnDmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f33RmDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f33RmDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A76C433C7;
	Mon,  8 Apr 2024 14:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584934;
	bh=HgqDVC2ZDMjUyreQ7nLnQwIOmtMEjXwPfwmLfJKS6DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f33RmDQyWzSYU/DS644V8ip3sEN6v7NBFIORw8L6AJFrL3y2lt5LGDoyyIS4BFRC
	 jlGz1p5xcUnDQF9WXNScHPuwH96RAHg7eCA0G5MqozuynURsk0m9pRmLjQqzihWyHn
	 QvHS3GDWjUVWVCyFNg6l0/yGILRFlNWOO/A24sn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 606/690] scsi: usb: Call scsi_done() directly
Date: Mon,  8 Apr 2024 14:57:52 +0200
Message-ID: <20240408125421.556003586@linuxfoundation.org>
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

[ Upstream commit 46c97948e9b5bc8b67fd72741a2fe723ac1d14d7 ]

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Link: https://lore.kernel.org/r/20211007204618.2196847-10-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: cd5432c71235 ("USB: UAS: return ENODEV when submit urbs fail with device not attached")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/scsiglue.c |  1 -
 drivers/usb/storage/uas.c      | 10 ++++------
 drivers/usb/storage/usb.c      |  4 ++--
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index b8e1109f0e0d4..e104aa651ccc7 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -393,7 +393,6 @@ static int queuecommand_lck(struct scsi_cmnd *srb,
 	}
 
 	/* enqueue the command and wake up the control thread */
-	srb->scsi_done = done;
 	us->srb = srb;
 	complete(&us->cmnd_ready);
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index bef89c6bd1d7f..774d18907f472 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -256,7 +256,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 		return -EBUSY;
 	devinfo->cmnd[cmdinfo->uas_tag - 1] = NULL;
 	uas_free_unsubmitted_urbs(cmnd);
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
@@ -653,7 +653,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		memcpy(cmnd->sense_buffer, usb_stor_sense_invalidCDB,
 		       sizeof(usb_stor_sense_invalidCDB));
 		cmnd->result = SAM_STAT_CHECK_CONDITION;
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		return 0;
 	}
 
@@ -661,7 +661,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	if (devinfo->resetting) {
 		set_host_byte(cmnd, DID_ERROR);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		goto zombie;
 	}
 
@@ -675,8 +675,6 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
-	cmnd->scsi_done = done;
-
 	memset(cmdinfo, 0, sizeof(*cmdinfo));
 	cmdinfo->uas_tag = idx + 1; /* uas-tag == usb-stream-id, so 1 based */
 	cmdinfo->state = SUBMIT_STATUS_URB | ALLOC_CMD_URB | SUBMIT_CMD_URB;
@@ -706,7 +704,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	 */
 	if (err == -ENODEV) {
 		set_host_byte(cmnd, DID_ERROR);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		goto zombie;
 	}
 	if (err) {
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 90aa9c12ffac5..8b543f2c98575 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -388,7 +388,7 @@ static int usb_stor_control_thread(void * __us)
 		if (srb->result == DID_ABORT << 16) {
 SkipForAbort:
 			usb_stor_dbg(us, "scsi command aborted\n");
-			srb = NULL;	/* Don't call srb->scsi_done() */
+			srb = NULL;	/* Don't call scsi_done() */
 		}
 
 		/*
@@ -417,7 +417,7 @@ static int usb_stor_control_thread(void * __us)
 		if (srb) {
 			usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
 					srb->result);
-			srb->scsi_done(srb);
+			scsi_done(srb);
 		}
 	} /* for (;;) */
 
-- 
2.43.0



