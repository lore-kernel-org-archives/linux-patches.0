Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5211C881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E7DC4339E;
	Fri, 10 Mar 2023 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459160;
	bh=ZticIFORbSCPcpGpqQbGeZo/8Hao8JCv1jJd2GTPcTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jg6dIt9DV8kCNunA6/BRbnu0LDft+NFNbPRuWraEKlGFh3siNdX2qvF8eSDoj33co
	 QaoFBp5HRvCKnz/+iwlrFwA0tq2wYPiABjtPlaklUERLcgywiaqiIJ6PXoKIdlHo4s
	 mvIKOI0CHOmZAy7BvtxkLE9RCpu3h5cbR+0Ou8uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arun Easi <aeasi@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 269/357] scsi: qla2xxx: Fix DMA-API call trace on NVMe LS requests
Date: Fri, 10 Mar 2023 14:39:18 +0100
Message-Id: <20230310133746.608550140@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arun Easi <aeasi@marvell.com>

commit c75e6aef5039830cce5d4cf764dd204522f89e6b upstream.

The following message and call trace was seen with debug kernels:

DMA-API: qla2xxx 0000:41:00.0: device driver failed to check map
error [device address=0x00000002a3ff38d8] [size=1024 bytes] [mapped as
single]
WARNING: CPU: 0 PID: 2930 at kernel/dma/debug.c:1017
	 check_unmap+0xf42/0x1990

Call Trace:
	debug_dma_unmap_page+0xc9/0x100
	qla_nvme_ls_unmap+0x141/0x210 [qla2xxx]

Remove DMA mapping from the driver altogether, as it is already done by FC
layer. This prevents the warning.

Fixes: c85ab7d9e27a ("scsi: qla2xxx: Fix missed DMA unmap for NVMe ls requests")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -152,18 +152,6 @@ out:
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
 
-static void qla_nvme_ls_unmap(struct srb *sp, struct nvmefc_ls_req *fd)
-{
-	if (sp->flags & SRB_DMA_VALID) {
-		struct srb_iocb *nvme = &sp->u.iocb_cmd;
-		struct qla_hw_data *ha = sp->fcport->vha->hw;
-
-		dma_unmap_single(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
-				 fd->rqstlen, DMA_TO_DEVICE);
-		sp->flags &= ~SRB_DMA_VALID;
-	}
-}
-
 static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
@@ -181,7 +169,6 @@ static void qla_nvme_release_ls_cmd_kref
 
 	fd = priv->fd;
 
-	qla_nvme_ls_unmap(sp, fd);
 	fd->done(fd, priv->comp_status);
 out:
 	qla2x00_rel_sp(sp);
@@ -323,13 +310,10 @@ static int qla_nvme_ls_req(struct nvme_f
 	nvme->u.nvme.rsp_len = fd->rsplen;
 	nvme->u.nvme.rsp_dma = fd->rspdma;
 	nvme->u.nvme.timeout_sec = fd->timeout;
-	nvme->u.nvme.cmd_dma = dma_map_single(&ha->pdev->dev, fd->rqstaddr,
-	    fd->rqstlen, DMA_TO_DEVICE);
+	nvme->u.nvme.cmd_dma = fd->rqstdma;
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
 	    fd->rqstlen, DMA_TO_DEVICE);
 
-	sp->flags |= SRB_DMA_VALID;
-
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
@@ -337,7 +321,6 @@ static int qla_nvme_ls_req(struct nvme_f
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
-		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}


