Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525E31AB6F1;
	Mon, 14 Oct 2024 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916057; cv=none; b=B3RbE3OZwDTDOlTBpTpTnxqmOG7jkdmPvXccIJXOq7N1LGmki8fqREklTlTDjJV3KGuL7RsQpO07XHe7FSf3oaEUuDCgcMuOcK3ia80raw+tATEVwK/2zODSJ5KwW7NQ7BJd5f045EvyP/NR7fg5QuFD98tCUI7AQGZlvjUUkoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916057; c=relaxed/simple;
	bh=K6sdX/b2dCGY5OV2MwYHu1z7BfwHidFS3E+/4xvU9vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP6bldkUyIWfpD7bB4vhF6d4vIb4mon+2q7vCwAfHwUJlMd3+m7S0H8KTPaDSk554R60dm2+bvFxpbQ4rdlpaVhyrDQLvQsr789OFA9ZikfGW3Galo/XTo5MmmZgRrOI6j2AJvt1Pfo83ShbpjUcgU+7y9kJ3PGNA9H/XRM4OMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0GldsnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0GldsnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB420C4CED1;
	Mon, 14 Oct 2024 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916057;
	bh=K6sdX/b2dCGY5OV2MwYHu1z7BfwHidFS3E+/4xvU9vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0GldsnEEVCbJo6y8JFF07d5GHFQ8qqwSA8hBAwDOBhOkVKxU7IVB8CdzaTu0NzY8
	 454q8ZFNstrMMclcmtzxF9MdLpbriN3Jn8GxYC11CVF9IOR7G7TXLU1D5YHzwSqUkk
	 /uqZ4lAy1Me7wgmArYnQChq3ASRmiOEbAG1obWho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 074/214] scsi: lpfc: Revise TRACE_EVENT log flag severities from KERN_ERR to KERN_WARNING
Date: Mon, 14 Oct 2024 16:18:57 +0200
Message-ID: <20241014141047.875874191@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 1af9af1f8ab38f1285b27581a5e6920ec58296ba ]

Revise certain log messages marked as KERN_ERR LOG_TRACE_EVENT to
KERN_WARNING and use the lpfc_vlog_msg() macro to still log the event.  The
benefit is that events of interest are still logged and the entire trace
buffer is not dumped with extraneous logging information when using default
lpfc_log_verbose driver parameter settings.

Also, delete the keyword "fail" from such log messages as they aren't
really causes for concern.  The log messages are more for warnings to a SAN
admin about SAN activity.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240912232447.45607-7-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c  |  10 +--
 drivers/scsi/lpfc/lpfc_els.c | 125 +++++++++++++++++------------------
 2 files changed, 64 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1e5db489a00c5..134bc96dd1340 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1572,8 +1572,8 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 		}
 	} else
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "3065 GFT_ID failed x%08x\n", ulp_status);
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_DISCOVERY,
+			      "3065 GFT_ID status x%08x\n", ulp_status);
 
 out:
 	lpfc_ct_free_iocb(phba, cmdiocb);
@@ -2258,7 +2258,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "0229 FDMI cmd %04x failed, latt = %d "
+				 "0229 FDMI cmd %04x latt = %d "
 				 "ulp_status: x%x, rid x%x\n",
 				 be16_to_cpu(fdmi_cmd), latt, ulp_status,
 				 ulp_word4);
@@ -2275,9 +2275,9 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check for a CT LS_RJT response */
 	cmd =  be16_to_cpu(fdmi_cmd);
 	if (be16_to_cpu(fdmi_rsp) == SLI_CT_RESPONSE_FS_RJT) {
-		/* FDMI rsp failed */
+		/* Log FDMI reject */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_ELS,
-				 "0220 FDMI cmd failed FS_RJT Data: x%x", cmd);
+				 "0220 FDMI cmd FS_RJT Data: x%x", cmd);
 
 		/* Should we fallback to FDMI-2 / FDMI-1 ? */
 		switch (cmd) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4f324ca5368ef..14938c7c4aac5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -979,7 +979,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				phba->fcoe_cvl_eventtag_attn =
 					phba->fcoe_cvl_eventtag;
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
-					"2611 FLOGI failed on FCF (x%x), "
+					"2611 FLOGI FCF (x%x), "
 					"status:x%x/x%x, tmo:x%x, perform "
 					"roundrobin FCF failover\n",
 					phba->fcf.current_rec.fcf_indx,
@@ -997,11 +997,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
 		      ((ulp_word4 & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE)))
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2858 FLOGI failure Status:x%x/x%x TMO"
-					 ":x%x Data x%lx x%x\n",
-					 ulp_status, ulp_word4, tmo,
-					 phba->hba_flag, phba->fcf.fcf_flag);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2858 FLOGI Status:x%x/x%x TMO"
+				      ":x%x Data x%lx x%x\n",
+				      ulp_status, ulp_word4, tmo,
+				      phba->hba_flag, phba->fcf.fcf_flag);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
@@ -1023,7 +1023,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_nlp_put(ndlp);
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
-				 "0150 FLOGI failure Status:x%x/x%x "
+				 "0150 FLOGI Status:x%x/x%x "
 				 "xri x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
 				 tmo, kref_read(&ndlp->kref));
@@ -1032,11 +1032,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
 		      ((ulp_word4 & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE))) {
-			/* FLOGI failure */
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "0100 FLOGI failure Status:x%x/x%x "
-					 "TMO:x%x\n",
-					 ulp_status, ulp_word4, tmo);
+			/* Warn FLOGI status */
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "0100 FLOGI Status:x%x/x%x "
+				      "TMO:x%x\n",
+				      ulp_status, ulp_word4, tmo);
 			goto flogifail;
 		}
 
@@ -1962,16 +1962,16 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (ulp_status) {
 		/* Check for retry */
-		/* RRQ failed Don't print the vport to vport rjts */
+		/* Warn RRQ status Don't print the vport to vport rjts */
 		if (ulp_status != IOSTAT_LS_RJT ||
 		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
 		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
 		    (phba)->pport->cfg_log_verbose & LOG_ELS)
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2881 RRQ failure DID:%06X Status:"
-					 "x%x/x%x\n",
-					 ndlp->nlp_DID, ulp_status,
-					 ulp_word4);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2881 RRQ DID:%06X Status:"
+				      "x%x/x%x\n",
+				      ndlp->nlp_DID, ulp_status,
+				      ulp_word4);
 	}
 
 	lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
@@ -2075,16 +2075,16 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			goto out;
 		}
-		/* PLOGI failed Don't print the vport to vport rjts */
+		/* Warn PLOGI status Don't print the vport to vport rjts */
 		if (ulp_status != IOSTAT_LS_RJT ||
 		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
 		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
 		    (phba)->pport->cfg_log_verbose & LOG_ELS)
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2753 PLOGI failure DID:%06X "
-					 "Status:x%x/x%x\n",
-					 ndlp->nlp_DID, ulp_status,
-					 ulp_word4);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2753 PLOGI DID:%06X "
+				      "Status:x%x/x%x\n",
+				      ndlp->nlp_DID, ulp_status,
+				      ulp_word4);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
@@ -2321,7 +2321,6 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_nodelist *ndlp;
 	char *mode;
-	u32 loglevel;
 	u32 ulp_status;
 	u32 ulp_word4;
 	bool release_node = false;
@@ -2370,17 +2369,14 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * could be expected.
 		 */
 		if (test_bit(FC_FABRIC, &vport->fc_flag) ||
-		    vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH) {
-			mode = KERN_ERR;
-			loglevel =  LOG_TRACE_EVENT;
-		} else {
+		    vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH)
+			mode = KERN_WARNING;
+		else
 			mode = KERN_INFO;
-			loglevel =  LOG_ELS;
-		}
 
-		/* PRLI failed */
-		lpfc_printf_vlog(vport, mode, loglevel,
-				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
+		/* Warn PRLI status */
+		lpfc_printf_vlog(vport, mode, LOG_ELS,
+				 "2754 PRLI DID:%06X Status:x%x/x%x, "
 				 "data: x%x x%x x%x\n",
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4, ndlp->nlp_state,
@@ -2852,11 +2848,11 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			goto out;
 		}
-		/* ADISC failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2755 ADISC failure DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, ulp_status,
-				 ulp_word4);
+		/* Warn ADISC status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "2755 ADISC DID:%06X Status:x%x/x%x\n",
+			      ndlp->nlp_DID, ulp_status,
+			      ulp_word4);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
 
@@ -3043,12 +3039,12 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * discovery.  The PLOGI will retry.
 	 */
 	if (ulp_status) {
-		/* LOGO failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2756 LOGO failure, No Retry DID:%06X "
-				 "Status:x%x/x%x\n",
-				 ndlp->nlp_DID, ulp_status,
-				 ulp_word4);
+		/* Warn LOGO status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "2756 LOGO, No Retry DID:%06X "
+			      "Status:x%x/x%x\n",
+			      ndlp->nlp_DID, ulp_status,
+			      ulp_word4);
 
 		if (lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			skip_recovery = 1;
@@ -4835,11 +4831,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 			  (cmd == ELS_CMD_FDISC) &&
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_OUT_OF_RESOURCE)){
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0125 FDISC Failed (x%x). "
-						 "Fabric out of resources\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0125 FDISC (x%x). "
+					      "Fabric out of resources\n",
+					      stat.un.lsRjtError);
 				lpfc_vport_set_state(vport,
 						     FC_VPORT_NO_FABRIC_RSCS);
 			}
@@ -4875,11 +4870,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 						LSEXP_NOTHING_MORE) {
 				vport->fc_sparam.cmn.bbRcvSizeMsb &= 0xf;
 				retry = 1;
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0820 FLOGI Failed (x%x). "
-						 "BBCredit Not Supported\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0820 FLOGI (x%x). "
+					      "BBCredit Not Supported\n",
+					      stat.un.lsRjtError);
 			}
 			break;
 
@@ -4889,11 +4883,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			  ((stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_PNAME) ||
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_NPORT_ID))
 			  ) {
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0122 FDISC Failed (x%x). "
-						 "Fabric Detected Bad WWN\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0122 FDISC (x%x). "
+					      "Fabric Detected Bad WWN\n",
+					      stat.un.lsRjtError);
 				lpfc_vport_set_state(vport,
 						     FC_VPORT_FABRIC_REJ_WWN);
 			}
@@ -5353,8 +5346,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
 	if (!vport) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3177 ELS response failed\n");
+		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
+				"3177 null vport in ELS rsp\n");
 		goto out;
 	}
 	if (cmdiocb->context_un.mbox)
@@ -11326,10 +11319,10 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
-		/* FDISC failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "0126 FDISC failed. (x%x/x%x)\n",
-				 ulp_status, ulp_word4);
+		/* Warn FDISC status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "0126 FDISC cmpl status: x%x/x%x)\n",
+			      ulp_status, ulp_word4);
 		goto fdisc_failed;
 	}
 
-- 
2.43.0



