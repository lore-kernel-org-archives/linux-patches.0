Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFB334CFD4;
	Fri, 21 Nov 2025 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732886; cv=none; b=l5rpcYFQ6ho1V+gNQyXeaRP09ZCNzGeYx5xBugiZhOB7MEfarUSUGA0CEJPx1y/KHYXWkjL5XG3Is0acXkNpsJaBIchxlSu6JumcgG4EP4WQgWQ4eGeY3qWJcwyiFLTSghYrYK2zf/pGVsMaeAWQPe5EwSKPGyr7dxdLDEWPZwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732886; c=relaxed/simple;
	bh=+amB3zVHkguGCf9wG50ijvox2JBoWe3M/dJjf2ClDh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRzkZg8FRobktdc1trJS1kdOA5LCI4HaIwPay7WYN4iH6pCyF4J0xtt1sOPIA7vZcWkOv1HLS9N+xQiiQOrYJtRtqfuH6zHtvfGRiL74eFMvVXUNdgrZiDGdd9DDrD/wjwC2n+KkzJSTQxV5bBLOfHqWMOkGy4ttQF7mvF4RWZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxPRW7UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxPRW7UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6FAC2BCAF;
	Fri, 21 Nov 2025 13:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732886;
	bh=+amB3zVHkguGCf9wG50ijvox2JBoWe3M/dJjf2ClDh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxPRW7UCfldNfmporGGKCzk7nHAFRCrfZtlOioGUx78mHNKJ6/A43R82uNdbednA+
	 oZeQ3UYpDG6VRW5xdTw1c0zPI13sZYGAt+3N61/kry2BdsPMW7/PfasOu3jC8/FRc8
	 Kdj/yIUUEN1ZPFeFRXeEMaa52JUxjnMyzBw8AZi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/529] scsi: lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup
Date: Fri, 21 Nov 2025 14:09:03 +0100
Message-ID: <20251121130239.701879654@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ebe84bb7bb3dd..2e9972a587810 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -12094,7 +12094,11 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
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
index 7c8e0e1d36da9..b0eac09de5ad5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3047,13 +3047,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
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



