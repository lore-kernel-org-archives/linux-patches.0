Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB439569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB26C433D2;
	Sun, 28 May 2023 19:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301902;
	bh=xZ455jMDhB0RdiKwxwnNu9wuMeZgXRP5pt6WSDU0Xao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9hNBV5NJ1L+4EqqycyLAZZ1/bpFPGkUVLE3I94rZArG7ZxOnusIXpgI4f5xXlrKu
	 fH3QMYWmTMOqrKeKIDdNu6szo7+6bPALyBSK2iFisB1tTPRg3PlAu0UseKgiQzRcoM
	 v7TTRvSIo10JLVICk52JLun6e3b6NfglApx2Or9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Bizon <mbizon@freebox.fr>,
	linux-usb@vger.kernel.org,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 082/161] usb-storage: fix deadlock when a scsi command timeouts more than once
Date: Sun, 28 May 2023 20:10:06 +0100
Message-Id: <20230528190839.745816256@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Bizon <mbizon@freebox.fr>

commit a398d5eac6984316e71474e25b975688f282379b upstream.

With faulty usb-storage devices, read/write can timeout, in that case
the SCSI layer will abort and re-issue the command. USB storage has no
internal timeout, it relies on SCSI layer aborting commands via
.eh_abort_handler() for non those responsive devices.

After two consecutive timeouts of the same command, SCSI layer calls
.eh_device_reset_handler(), without calling .eh_abort_handler() first.

With usb-storage, this causes a deadlock:

  -> .eh_device_reset_handler
    -> device_reset
      -> mutex_lock(&(us->dev_mutex));

mutex already by usb_stor_control_thread(), which is waiting for
command completion:

  -> usb_stor_control_thread (mutex taken here)
    -> usb_stor_invoke_transport
      -> usb_stor_Bulk_transport
        -> usb_stor_bulk_srb
	  -> usb_stor_bulk_transfer_sglist
	    -> usb_sg_wait

Make sure we cancel any pending command in .eh_device_reset_handler()
to avoid this.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
Cc: linux-usb@vger.kernel.org
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/all/ZEllnjMKT8ulZbJh@sakura/
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230505114759.1189741-1-mbizon@freebox.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/scsiglue.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -407,22 +407,25 @@ static DEF_SCSI_QCMD(queuecommand)
  ***********************************************************************/
 
 /* Command timeout and abort */
-static int command_abort(struct scsi_cmnd *srb)
+static int command_abort_matching(struct us_data *us, struct scsi_cmnd *srb_match)
 {
-	struct us_data *us = host_to_us(srb->device->host);
-
-	usb_stor_dbg(us, "%s called\n", __func__);
-
 	/*
 	 * us->srb together with the TIMED_OUT, RESETTING, and ABORTING
 	 * bits are protected by the host lock.
 	 */
 	scsi_lock(us_to_host(us));
 
-	/* Is this command still active? */
-	if (us->srb != srb) {
+	/* is there any active pending command to abort ? */
+	if (!us->srb) {
 		scsi_unlock(us_to_host(us));
 		usb_stor_dbg(us, "-- nothing to abort\n");
+		return SUCCESS;
+	}
+
+	/* Does the command match the passed srb if any ? */
+	if (srb_match && us->srb != srb_match) {
+		scsi_unlock(us_to_host(us));
+		usb_stor_dbg(us, "-- pending command mismatch\n");
 		return FAILED;
 	}
 
@@ -445,6 +448,14 @@ static int command_abort(struct scsi_cmn
 	return SUCCESS;
 }
 
+static int command_abort(struct scsi_cmnd *srb)
+{
+	struct us_data *us = host_to_us(srb->device->host);
+
+	usb_stor_dbg(us, "%s called\n", __func__);
+	return command_abort_matching(us, srb);
+}
+
 /*
  * This invokes the transport reset mechanism to reset the state of the
  * device
@@ -456,6 +467,9 @@ static int device_reset(struct scsi_cmnd
 
 	usb_stor_dbg(us, "%s called\n", __func__);
 
+	/* abort any pending command before reset */
+	command_abort_matching(us, NULL);
+
 	/* lock the device pointers and do the reset */
 	mutex_lock(&(us->dev_mutex));
 	result = us->transport_reset(us);


