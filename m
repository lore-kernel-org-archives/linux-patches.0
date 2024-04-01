Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D92D482CA;
	Mon,  1 Apr 2024 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991419; cv=none; b=NRl59YMOPKEjK/rraXo6V4qY/56pEH5GJ9mJQO1swy5c3A7dIUCb0lvCIbJdfnIoejhNgzRDvl4SAD3Y7dbcknKvO4zM8NRAYGag4hqK7ugPax5+Y6BWCbD58JrCsEWz74JLkhbMLCEt2fgQYCgMHG4HLLH5c5WGXs7g2k9q4c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991419; c=relaxed/simple;
	bh=sgFpge/+7GkvhekVBxdi5eHfdf++RqrpDwdkod+mArw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X86JPI9pM/TWohKpG9MFpcw9ewJ8CyEreDfFpJly2JIU92wvObyzt1wsVWlPHnkR+Ep3E9ILXXBsnoJaofFxQrEuSLH5AAl2P0ntOdhfUVT/7W0iJfG2JhVRY7WINiCQPBUndRQFLSbHMLzqZmp3Of1rustPRcxv7vNFCa4xBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBoOUVl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBoOUVl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF92C433C7;
	Mon,  1 Apr 2024 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991418;
	bh=sgFpge/+7GkvhekVBxdi5eHfdf++RqrpDwdkod+mArw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBoOUVl7shS903zTqEexymFa4M8yMtVbHgYMJMu1yrBav5hVjTeLMdGCqe8hGTO7I
	 wlMPLGzY8lizYP0NyPGL+xw3yoQmv0n9dgCGcrOT0vBeGE8LnwOOXVbSWon+/UYuiQ
	 pxZki/FhNf0c0dj0R5gRsil69T/0IcRisy7RfOvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 259/272] scsi: qla2xxx: NVME|FCP prefer flag not being honored
Date: Mon,  1 Apr 2024 17:47:29 +0200
Message-ID: <20240401152539.138561522@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7554,6 +7554,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	struct scsi_qla_host *vp, *tvp;
 	struct req_que *req = ha->req_q_map[0];
 	unsigned long flags;
+	fc_port_t *fcport;
 
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
@@ -7622,6 +7623,15 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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
 
@@ -7692,6 +7702,14 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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


