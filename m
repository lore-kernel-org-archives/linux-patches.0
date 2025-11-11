Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D35C273D73;
	Tue, 11 Nov 2025 01:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824814; cv=none; b=QgQ0djOJ9iFVrLB/ybIVtr0UojvPECgajZI8Y1dmzczFAO71yGWCS6Dd2yflhJV5BHeGMe2hPMcae9cEf8Dp6E0UVLgVMOo7SX0JiVYijXT1IoksN0FJhzH4GB57jGnWrGfOb/teLwSQY+Eub1dKr6ejAztdp9BQ4Ljsy7AjbxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824814; c=relaxed/simple;
	bh=mE6H2+qwHvYJkJMgZ31AbHYxT1XePKdA6xNYMRudcBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEuKdstki8ntnknuKTinbW44HCTgUmfK95iOVBzctVF/a89Rxa1fW5XBTWl5EgPgQRgy+wWrXpWvEc0mFkOe+c47qmpHa5TcSWUwly6DOxRSNqFwDk2sEBLYVrXr37zI3L3WRZu7FL92bw+HZ/ManOn/cPZJmFx0evMecFLV51g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXsCyw/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXsCyw/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09A9C4CEFB;
	Tue, 11 Nov 2025 01:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824814;
	bh=mE6H2+qwHvYJkJMgZ31AbHYxT1XePKdA6xNYMRudcBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXsCyw/BVx2edKr4ztJ3eq9JwA6Bw0z4zwKced50O1BDovQN0eI3mD1GKlMtsssnj
	 uPAQw7tXbIMblEh9oI1H0ej7AGeDHrk871y+v1zS7W5BImOrGHs8P87rvxa0rlJSRN
	 k6wDrvM7BvGfhhUP6RMqgWGRwroBEV+aUYhyYdV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 575/849] scsi: lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup
Date: Tue, 11 Nov 2025 09:42:25 +0900
Message-ID: <20251111004550.320605861@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4c405bade4f34..3f703932b2f07 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -12013,7 +12013,11 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
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
index 4081d2a358eee..f7824266db5e8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3057,13 +3057,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
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



