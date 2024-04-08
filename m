Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56937E105;
	Mon,  8 Apr 2024 14:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584905; cv=none; b=cbLZCXrf+22O9vVjK6yaZ3BoLe0HNuX48R+utyz2s1t+vVicbcHaI23L3Qqa8DvjyUOuW7P5x0W3Gzuij0iXybnCy5sVsVFIqbt+eYRY/TsFZhPpzGQ59bAMmQWfWp7d3PzThMgdPwqQ8P1qGiV1n7+pFUa0NS56nljYjP5vZBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584905; c=relaxed/simple;
	bh=MA1coPkUkRMVR9n3kNLEnqoZ+CzpLxSxiXZgQHWRR64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GElMZTyuptaqUUegXc+aZTFnFTf5iUsiwAzhuf7t3xwnD57EPu4hMC8H1bjs5nbPjZctNAW2k0XebwksZ92ptFF+LCwtn1QZEGEPVtqKwZUuUgKU4S4LPOdrVYuXEqqKaFIG6q9cqni14lnKKy8xI1oa+BNx9nWxzkJ7qK5wNT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytehxcBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytehxcBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9F5C433F1;
	Mon,  8 Apr 2024 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584904;
	bh=MA1coPkUkRMVR9n3kNLEnqoZ+CzpLxSxiXZgQHWRR64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytehxcBDyVqy9QhwNFS7ZfvctLv4N1GBFTJ6tgcXnyukePD3zYzDP4wWtiiZKLL9X
	 otPN/5B5YdMwtLT4H/iDrd2EnbiGDe/6OQrtLhA81wQmUCO6LiFFNjh20h6+ZlljkG
	 wXRkDkal8KHXqJU531rPhG48wFF1cgqHLsCaMK6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quinn Tran <qutran@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 597/690] scsi: qla2xxx: NVME|FCP prefer flag not being honored
Date: Mon,  8 Apr 2024 14:57:43 +0200
Message-ID: <20240408125421.220171052@linuxfoundation.org>
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
@@ -7582,6 +7582,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 	struct scsi_qla_host *vp, *tvp;
 	struct req_que *req = ha->req_q_map[0];
 	unsigned long flags;
+	fc_port_t *fcport;
 
 	if (vha->flags.online) {
 		qla2x00_abort_isp_cleanup(vha);
@@ -7647,6 +7648,15 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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
 
@@ -7717,6 +7727,14 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
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


