Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B552613AC6;
	Sat,  3 Feb 2024 04:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933810; cv=none; b=tMzMF+Rccm76gD/qzlYNIUECXLCtO/vUFyWJpx4aCYNwfTubq3r3cS+/ZknC7N8/B7P78nphJvksRIB1T7I0rpYf3n6OdBwWIQtbRtm+Yj9fagkFJ9mxsIEwaUFDULfm5UmdE6stH0XmPdlSEoGSVDtw9UvyClfRBqDBounVW/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933810; c=relaxed/simple;
	bh=0rorU600mYjpy+y27I4D2R7jpwVs7Dla1yJiZjmk5iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoATgnFa2rO2Oj+OHlv4jAGSwzHoI0LBvWtyZvGMxNtj3zLKhJxu8YGWPpzOoCiPP+pXF21vsr33U9bcv1KZ5ZJgkZbsU6itd35MubvIr9lnFr6e6fM1Wcp2RlGH5tsIndTEbg4CAa0flOLf2i/FrxYpJjTYehh62TDktTiKFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbG+Xhz9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbG+Xhz9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF21C43390;
	Sat,  3 Feb 2024 04:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933810;
	bh=0rorU600mYjpy+y27I4D2R7jpwVs7Dla1yJiZjmk5iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbG+Xhz90JsWzltN03m0LaxPgGewwNOwaFZYYHOlo02A/L5OekzDqpI8qcf+vs9z4
	 Ftdz66CoN1z6ostw/M0+7HhT3RO9kSKhEStCEDCRR2znLNXiV9ECoUQN2ucCdP2Cer
	 84wQnpxlpZQNMYyRpgumujuCUlps7B3yR/CCWBHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 127/353] scsi: lpfc: Move determination of vmid_flag after VMID reinitialization completes
Date: Fri,  2 Feb 2024 20:04:05 -0800
Message-ID: <20240203035407.746252441@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit aba0fb0ef607a71511d23a07406f11130c1a54c5 ]

If priority tagging is set in the service parameters of a FLOGI cmpl, then
we update the vmid_flag.  In the current logic, if a follow up FLOGI cmpl
updates its service parameters such that priority tagging is no longer set,
then the vmid_flag ends up keeping stale data.

Fix by ensuring we clear the vmid_flag member during lpfc_reinit_vmid, and
check the priority tagging service parameter after reinitialization of the
vmid data structures.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20231207224039.35466-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c  | 6 +++---
 drivers/scsi/lpfc/lpfc_vmid.c | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7e9b93460e64..385e1636f139 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1130,12 +1130,12 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			 vport->port_state, vport->fc_flag,
 			 sp->cmn.priority_tagging, kref_read(&ndlp->kref));
 
-	if (sp->cmn.priority_tagging)
-		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
-						  LPFC_VMID_TYPE_PRIO);
 	/* reinitialize the VMID datastructure before returning */
 	if (lpfc_is_vmid_enabled(phba))
 		lpfc_reinit_vmid(vport);
+	if (sp->cmn.priority_tagging)
+		vport->phba->pport->vmid_flag |= (LPFC_VMID_ISSUE_QFPA |
+						  LPFC_VMID_TYPE_PRIO);
 
 	/*
 	 * Address a timing race with dev_loss.  If dev_loss is active on
diff --git a/drivers/scsi/lpfc/lpfc_vmid.c b/drivers/scsi/lpfc/lpfc_vmid.c
index cf8ba840d0ea..773e02ae20c3 100644
--- a/drivers/scsi/lpfc/lpfc_vmid.c
+++ b/drivers/scsi/lpfc/lpfc_vmid.c
@@ -321,5 +321,6 @@ lpfc_reinit_vmid(struct lpfc_vport *vport)
 	if (!hash_empty(vport->hash_table))
 		hash_for_each_safe(vport->hash_table, bucket, tmp, cur, hnode)
 			hash_del(&cur->hnode);
+	vport->vmid_flag = 0;
 	write_unlock(&vport->vmid_lock);
 }
-- 
2.43.0



