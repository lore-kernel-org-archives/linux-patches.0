Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95EB17731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC7C433C8;
	Wed,  9 Aug 2023 11:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579221;
	bh=E6zZJbs2IHZ6ARA5rBEZYDsdoWqvFzGdXLdHhRC1IlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm3DrvcLvtAexfjiq20WKc7NStnLPluZDkCWpD10iIsXATZaVKdsLif8FNDbma7Z3
	 YCsO9Juxv/QzlM2wzsZq2O9AuIeCEHnMW7+PmXZcTUZZEwOtWYfw8IL2Q4v7EXGkqs
	 K0gcFZQpWhOKNV22Lu99gU8NP8A70Ct8bvhfNuyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 119/204] scsi: qla2xxx: Wait for io return on terminate rport
Date: Wed,  9 Aug 2023 12:40:57 +0200
Message-ID: <20230809103646.585339752@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Quinn Tran <qutran@marvell.com>

commit fc0cba0c7be8261a1625098bd1d695077ec621c9 upstream.

System crash due to use after free.
Current code allows terminate_rport_io to exit before making
sure all IOs has returned. For FCP-2 device, IO's can hang
on in HW because driver has not tear down the session in FW at
first sign of cable pull. When dev_loss_tmo timer pops,
terminate_rport_io is called and upper layer is about to
free various resources. Terminate_rport_io trigger qla to do
the final cleanup, but the cleanup might not be fast enough where it
leave qla still holding on to the same resource.

Wait for IO's to return to upper layer before resources are freed.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20230428075339.32551-7-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1779,6 +1779,7 @@ static void
 qla2x00_terminate_rport_io(struct fc_rport *rport)
 {
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
+	scsi_qla_host_t *vha;
 
 	if (!fcport)
 		return;
@@ -1788,9 +1789,12 @@ qla2x00_terminate_rport_io(struct fc_rpo
 
 	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
 		return;
+	vha = fcport->vha;
 
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
 		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,
+			0, WAIT_TARGET);
 		return;
 	}
 	/*
@@ -1805,6 +1809,15 @@ qla2x00_terminate_rport_io(struct fc_rpo
 		else
 			qla2x00_port_logout(fcport->vha, fcport);
 	}
+
+	/* check for any straggling io left behind */
+	if (qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24, 0, WAIT_TARGET)) {
+		ql_log(ql_log_warn, vha, 0x300b,
+		       "IO not return.  Resetting. \n");
+		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		qla2xxx_wake_dpc(vha);
+		qla2x00_wait_for_chip_reset(vha);
+	}
 }
 
 static int


