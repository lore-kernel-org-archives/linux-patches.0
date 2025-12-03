Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36B933893A;
	Wed,  3 Dec 2025 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777824; cv=none; b=WgDfAWERfjC5lRa3CV/OoDxcabJ69OeUTZTGahFnsJ1ot2kqQ1pxAgz9yztBNJhzoe0i8N2SeZvqzsv7/yn41Yk+mTu9lG1SxPZ76VzgixuwtdGOhZ5mNjwvzSY6Wxbte5qbRkyzwb1lweSOTq0wlFM2EhoEfxq/M47rO2cnmc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777824; c=relaxed/simple;
	bh=QrKSvtIuUYerQl5U35UAgh4Mw9252cy387NTwogAOKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiHEfIgvoQqkuCEv77XP63RW/hKMOdwZMCOl7JnFo/czbxqJ+QJK8bEjGxOJB4p290HCagORUBY8Iusb1zmMzmkWYWC864QUdoXbhN+MNL8eAPjzFLBdgXuorm5CmJgvdl0VCgrvNep2R1tbauFq3aWSU7QKxdvkwSmlgAKWDAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MI0IGwzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MI0IGwzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8AEC4CEF5;
	Wed,  3 Dec 2025 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777824;
	bh=QrKSvtIuUYerQl5U35UAgh4Mw9252cy387NTwogAOKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MI0IGwzjbVS+APtoIK3rklJBOGpDOzC5qRdvOFQgKHdIVAlZlcCAoUDLDMbxicxzW
	 2zaX0qVttKryz6UaOsI1OviqI3/ytNcTCtD0t0r+SAZTckwuIBMjOY1yk+JlxZAZAk
	 Lk9BTgDj+j1qZQOFXKrcM9/OpM/4xOg6aga4Xuos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/392] scsi: lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup
Date: Wed,  3 Dec 2025 16:25:08 +0100
Message-ID: <20251203152419.895035079@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit a4809b98eb004fcbf7c4d45eb5a624d1c682bb73 ]

In lpfc_cleanup, there is an extraneous nlp_put for NPIV ports on the
F_Port_Ctrl ndlp object.  In cases when an ABTS is issued, the
outstanding kref is needed for when a second XRI_ABORTED CQE is
received.  The final kref for the ndlp is designed to be decremented in
lpfc_sli4_els_xri_aborted instead.  Also, add a new log message to allow
for future diagnostics when debugging related issues.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-5-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c  | 6 +++++-
 drivers/scsi/lpfc/lpfc_init.c | 7 -------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 134d56bd00daf..cb2ee84ccc976 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11449,7 +11449,11 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			sglq_entry->state = SGL_FREED;
 			spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock,
 					       iflag);
-
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_SLI |
+					LOG_DISCOVERY | LOG_NODE,
+					"0732 ELS XRI ABORT on Node: ndlp=x%px "
+					"xri=x%x\n",
+					ndlp, xri);
 			if (ndlp) {
 				lpfc_set_rrq_active(phba, ndlp,
 					sglq_entry->sli4_lxritag,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index bba51ce4276ae..e2f9b23a3fbb2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2912,13 +2912,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		lpfc_vmid_vport_cleanup(vport);
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (vport->port_type != LPFC_PHYSICAL_PORT &&
-		    ndlp->nlp_DID == Fabric_DID) {
-			/* Just free up ndlp with Fabric_DID for vports */
-			lpfc_nlp_put(ndlp);
-			continue;
-		}
-
 		if (ndlp->nlp_DID == Fabric_Cntl_DID &&
 		    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
 			lpfc_nlp_put(ndlp);
-- 
2.51.0



