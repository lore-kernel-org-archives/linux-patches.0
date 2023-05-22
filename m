Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE01171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D50C433EF;
	Mon, 22 May 2023 19:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784483;
	bh=wQk/YkCUnRngItRy12a9dWbfE5UMHHrO+ZgvmewzHis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ue2RggGSRmSJQ8B8IWYOREc2DEtfW3V7CNvGME8FY0gvENcNs5BUklG884uF3CXsT
	 aqRWdTZcusBaNgrAtwPLm7DJAOhrtin+S1xGcXkOn2xC/m76rRiOi3NuKMoQKMEawi
	 5FzO4g+XVscPPTLR72ptObu/1UYZQrjIgxDawx3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 097/364] scsi: lpfc: Correct used_rpi count when devloss tmo fires with no recovery
Date: Mon, 22 May 2023 20:06:42 +0100
Message-Id: <20230522190415.172287322@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit db651ec22524eb8f9c854fbb4d9acd5d7e5be9e4 ]

A fabric controller can sometimes send an RDP request right before a link
down event.  Because of this outstanding RDP request, the driver does not
remove the last reference count on its ndlp causing a potential leak of RPI
resources when devloss tmo fires.

In lpfc_cmpl_els_rsp(), modify the NPIV clause to always allow the
lpfc_drop_node() routine to execute when not registered with SCSI
transport.

This relaxes the contraint that an NPIV ndlp must be in a specific state in
order to call lpfc_drop node.  Logic is revised such that the
lpfc_drop_node() routine is always called to ensure the last ndlp decrement
occurs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20230301231626.9621-7-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 35b252f1ef731..62d2ca688cd14 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5455,18 +5455,20 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * these conditions and release the RPI.
 	 */
 	if (phba->sli_rev == LPFC_SLI_REV4 &&
-	    (vport && vport->port_type == LPFC_NPIV_PORT) &&
-	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD) &&
-	    ndlp->nlp_flag & NLP_RELEASE_RPI) {
-		if (ndlp->nlp_state !=  NLP_STE_PLOGI_ISSUE &&
-		    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
-			lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
-			spin_lock_irq(&ndlp->lock);
-			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
-			spin_unlock_irq(&ndlp->lock);
-			lpfc_drop_node(vport, ndlp);
+	    vport && vport->port_type == LPFC_NPIV_PORT &&
+	    !(ndlp->fc4_xpt_flags & SCSI_XPT_REGD)) {
+		if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
+			if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
+			    ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) {
+				lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+				spin_lock_irq(&ndlp->lock);
+				ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+				ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+				spin_unlock_irq(&ndlp->lock);
+			}
 		}
+
+		lpfc_drop_node(vport, ndlp);
 	}
 
 	/* Release the originating I/O reference. */
-- 
2.39.2



