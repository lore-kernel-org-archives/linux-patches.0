Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE5C4778B;
	Mon,  1 Apr 2024 16:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987753; cv=none; b=ECu7WLMDbeOE60UITENbyVB5g/7TJUvCSEYtmp79kjSAs/KaRYjvSxjHKM5vvdZdHLoXhnm22YYvADS4JdY6iHXg+XUens1UVazQ2UhJxlLoHokBS5xpWBln5JXgWY7EtSe0KxpIu3bY5iscqxyVjSrHOfLxucSma7dFFk//gNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987753; c=relaxed/simple;
	bh=Zr6o2XOS6FrbB5YUv5YWQruQkqk/xSFlLMcS3sj18+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d86zfEN5DeL66iRIWKI3WUBP0WEBvXx8lOK1zNz3fu8YjvHvYbzs4g0ejvErpZ5Pqwj9q2PGWRNBi1CPSp7+vb7BWBp5lSquUf2AS9Vzxzf8C9an5jzejbZ7uqxx0C+6LUwz0grcyvz6tj6sMCgVK4IcuvHfmn9sRV3zA3GP8RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxotbrsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxotbrsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB333C433F1;
	Mon,  1 Apr 2024 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987753;
	bh=Zr6o2XOS6FrbB5YUv5YWQruQkqk/xSFlLMcS3sj18+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxotbrsqT1ydfdj0nZtz7Gd/aXlTLLfWjAbDTOZYcr9nkRK77pB/ru3KJzCRu8jrN
	 5RKbXl0SsEVeeZ8Y4RXPaHwwflR4X05zuhZ7qhm4wt7BVMoOribU+T06ycneTioR6P
	 J2ZMPEdER4LyCsEFxNdJy5CE6UiQaZkXQ9tDJr/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 381/399] scsi: qla2xxx: NVME|FCP prefer flag not being honored
Date: Mon,  1 Apr 2024 17:45:47 +0200
Message-ID: <20240401152600.550078106@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quinn Tran <qutran@marvell.com>

commit 69aecdd410106dc3a8f543a4f7ec6379b995b8d0 upstream.

Changing of [FCP|NVME] prefer flag in flash has no effect on driver. For
device that supports both FCP + NVMe over the same connection, driver
continues to connect to this device using the previous successful login
mode.

On completion of flash update, adapter will be reset. Driver will
reset the prefer flag based on setting from flash.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-6-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7501,6 +7501,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	struct scsi_qla_host *vp, *tvp;
 	struct req_que *req = ha->req_q_map[0];
 	unsigned long flags;
+	fc_port_t *fcport;
 
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
@@ -7569,6 +7570,15 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 			       "ISP Abort - ISP reg disconnect post nvmram config, exiting.\n");
 			return status;
 		}
+
+		/* User may have updated [fcp|nvme] prefer in flash */
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (NVME_PRIORITY(ha, fcport))
+				fcport->do_prli_nvme = 1;
+			else
+				fcport->do_prli_nvme = 0;
+		}
+
 		if (!qla2x00_restart_isp(vha)) {
 			clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 
@@ -7639,6 +7649,14 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				atomic_inc(&vp->vref_count);
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
 
+				/* User may have updated [fcp|nvme] prefer in flash */
+				list_for_each_entry(fcport, &vp->vp_fcports, list) {
+					if (NVME_PRIORITY(ha, fcport))
+						fcport->do_prli_nvme = 1;
+					else
+						fcport->do_prli_nvme = 0;
+				}
+
 				qla2x00_vp_abort_isp(vp);
 
 				spin_lock_irqsave(&ha->vport_slock, flags);


