Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40D73AE711;
	Wed, 21 Jan 2026 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020210; cv=none; b=YwWCFjExOySMPvdyVJ1Y6XuT2791rsrWhLpngJbcomi+g/djcM7AYQRMTM3MsrvZkDHHMvaq/MA7qaLLmHBgUxV3E6hQ7F/DlqPRMppNiu7bfsD7g36sAq+f4UoTOJdkB5ZyMZzScjKN1pxLPnHeluUQzAX5/aK9wl4dDzpy6r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020210; c=relaxed/simple;
	bh=MvW+/oZvMca+mxZ4T2+HIFD3pCtYbLtz7ah0uvoE0zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8kuLs9av5rDE2DwglpFWt4dwsIKnqnYy9+OUISCbCfXOpsQqKAzqkdvUkvsp68dPlnb4YgI2B1mk/WFKEoIA67OthY2MfopzqI5bRd/B6bBBHRNacz6VH1gfO4U4WaQQa9Tej8D+IxuBPrI6elo0ud0B6/vW4a07rP4wn6Du2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pViYTDR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pViYTDR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF4C16AAE;
	Wed, 21 Jan 2026 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020210;
	bh=MvW+/oZvMca+mxZ4T2+HIFD3pCtYbLtz7ah0uvoE0zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pViYTDR1lnZyMNTDW7C68oQPDJldI4wVOC9+XhB3ePjn/KaB03kEzTGSdRyS+WJkK
	 sbjjvk5Xa/Y1pq+PIkAXd4FUu5Y/wVzZmWdrIFsw/iKHntq6fw7fRwSILubtZUqtuK
	 T//vDKyrK3CaC+dsi8ptvaemRAAGBCIngD/ec9FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Kao <powenkao@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 091/198] scsi: core: Fix error handler encryption support
Date: Wed, 21 Jan 2026 19:15:19 +0100
Message-ID: <20260121181421.831443673@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Kao <powenkao@google.com>

commit 9a49157deeb23581fc5c8189b486340d7343264a upstream.

Some low-level drivers (LLD) access block layer crypto fields, such as
rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
configure hardware for inline encryption.  However, SCSI Error Handling
(EH) commands (e.g., TEST UNIT READY, START STOP UNIT) should not
involve any encryption setup.

To prevent drivers from erroneously applying crypto settings during EH,
this patch saves the original values of rq->crypt_keyslot and
rq->crypt_ctx before an EH command is prepared via scsi_eh_prep_cmnd().
These fields in the 'struct request' are then set to NULL.  The original
values are restored in scsi_eh_restore_cmnd() after the EH command
completes.

This ensures that the block layer crypto context does not leak into EH
command execution.

Signed-off-by: Brian Kao <powenkao@google.com>
Link: https://patch.msgid.link/20251218031726.2642834-1-powenkao@google.com
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_error.c |   24 ++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |    6 ++++++
 2 files changed, 30 insertions(+)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1060,6 +1060,9 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd
 			unsigned char *cmnd, int cmnd_size, unsigned sense_bytes)
 {
 	struct scsi_device *sdev = scmd->device;
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct request *rq = scsi_cmd_to_rq(scmd);
+#endif
 
 	/*
 	 * We need saved copies of a number of fields - this is because
@@ -1112,6 +1115,18 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd
 			(sdev->lun << 5 & 0xe0);
 
 	/*
+	 * Encryption must be disabled for the commands submitted by the error handler.
+	 * Hence, clear the encryption context information.
+	 */
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	ses->rq_crypt_keyslot = rq->crypt_keyslot;
+	ses->rq_crypt_ctx = rq->crypt_ctx;
+
+	rq->crypt_keyslot = NULL;
+	rq->crypt_ctx = NULL;
+#endif
+
+	/*
 	 * Zero the sense buffer.  The scsi spec mandates that any
 	 * untransferred sense data should be interpreted as being zero.
 	 */
@@ -1128,6 +1143,10 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
  */
 void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 {
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct request *rq = scsi_cmd_to_rq(scmd);
+#endif
+
 	/*
 	 * Restore original data
 	 */
@@ -1140,6 +1159,11 @@ void scsi_eh_restore_cmnd(struct scsi_cm
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
 	scmd->eh_eflags = ses->eh_eflags;
+
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	rq->crypt_keyslot = ses->rq_crypt_keyslot;
+	rq->crypt_ctx = ses->rq_crypt_ctx;
+#endif
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -41,6 +41,12 @@ struct scsi_eh_save {
 	unsigned char cmnd[32];
 	struct scsi_data_buffer sdb;
 	struct scatterlist sense_sgl;
+
+	/* struct request fields */
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct bio_crypt_ctx *rq_crypt_ctx;
+	struct blk_crypto_keyslot *rq_crypt_keyslot;
+#endif
 };
 
 extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,


