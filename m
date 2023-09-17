Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26556FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4C0C433C9;
	Sun, 17 Sep 2023 19:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979884;
	bh=baBWhUDNBqDGgKIqsk8TlJ4yQD5OzG9s3eFLX7YRrx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eN47Xo+di/zrOp87imPkCa9uGX8riSS9gxdcMtTTc3SpqjSalaRqBSKlCnjekayHV
	 jTEG+23FsziFj/BYgFhLle6RYe16i8/M9DdmtIcdopA0xg731v/dyfa5OKtpXaDw8h
	 MRN0Vh+UNYO5MrueAayEOoUJ6jfOe1E95k03yMW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 009/285] scsi: qla2xxx: Fix erroneous link up failure
Date: Sun, 17 Sep 2023 21:10:09 +0200
Message-ID: <20230917191051.946535880@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

From: Quinn Tran <qutran@marvell.com>

commit 5b51f35d127e7bef55fa869d2465e2bca4636454 upstream.

Link up failure occurred where driver failed to see certain events from FW
indicating link up (AEN 8011) and fabric login completion (AEN 8014).
Without these 2 events, driver would not proceed forward to scan the
fabric. The cause of this is due to delay in the receive of interrupt for
Mailbox 60 that causes qla to set the fw_started flag late.  The late
setting of this flag causes other interrupts to be dropped.  These dropped
interrupts happen to be the link up (AEN 8011) and fabric login completion
(AEN 8014).

Set fw_started flag early to prevent interrupts being dropped.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230714070104.40052-6-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 drivers/scsi/qla2xxx/qla_isr.c  |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4815,15 +4815,16 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	if (ha->flags.edif_enabled)
 		mid_init_cb->init_cb.frame_payload_size = cpu_to_le16(ELS_MAX_PAYLOAD);
 
+	QLA_FW_STARTED(ha);
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 next_check:
 	if (rval) {
+		QLA_FW_STOPPED(ha);
 		ql_log(ql_log_fatal, vha, 0x00d2,
 		    "Init Firmware **** FAILED ****.\n");
 	} else {
 		ql_dbg(ql_dbg_init, vha, 0x00d3,
 		    "Init Firmware -- success.\n");
-		QLA_FW_STARTED(ha);
 		vha->u_ql2xexchoffld = vha->u_ql2xiniexchg = 0;
 	}
 
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1121,8 +1121,12 @@ qla2x00_async_event(scsi_qla_host_t *vha
 	unsigned long	flags;
 	fc_port_t	*fcport = NULL;
 
-	if (!vha->hw->flags.fw_started)
+	if (!vha->hw->flags.fw_started) {
+		ql_log(ql_log_warn, vha, 0x50ff,
+		    "Dropping AEN - %04x %04x %04x %04x.\n",
+		    mb[0], mb[1], mb[2], mb[3]);
 		return;
+	}
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;


