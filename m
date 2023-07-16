Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82BF8F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E877C433C7;
	Sun, 16 Jul 2023 20:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540254;
	bh=rWtpXK0gATeqjSKcX3i2aH30oiDwKQysvw6IvO9oV00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1luM7vgED8m/71asW5lq6VwYeaqoGVvdFlTP90KOB7wqb37/OD87bg19xMofUhjSI
	 xriu/4/YgY2TfLXk7d9W93RQF/tPPREJVkplvBRzvTlyyVo79e2bCqBIou0VOpcHiK
	 ADMocyurbsRz6khPnMvJj5ICRotHgwCM4qejYiFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 298/591] scsi: lpfc: Revise NPIV ELS unsol rcv cmpl logic to drop ndlp based on nlp_state
Date: Sun, 16 Jul 2023 21:47:17 +0200
Message-ID: <20230716194931.606978970@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 9914a3d033d3e1d836a43e93e9738e7dd44a096a ]

When NPIV ports are zoned to devices that support both initiator and target
mode, a remote device's initiated PRLI results in unintended final kref
clean up of the device's ndlp structure.  This disrupts NPIV ports'
discovery for target devices that support both initiator and target mode.

Modify the NPIV lpfc_drop_node clause such that we allow the ndlp to live
so long as it was in NLP_STE_PLOGI_ISSUE, NLP_STE_REG_LOGIN_ISSUE, or
NLP_STE_PRLI_ISSUE nlp_state.  This allows lpfc's issued PRLI completion
routine to determine if the final kref clean up should execute rather than
a remote device's issued PRLI.

Fixes: db651ec22524 ("scsi: lpfc: Correct used_rpi count when devloss tmo fires with no recovery")
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20230523183206.7728-5-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ddd5949d8fc01..e21c73a3803ec 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5413,9 +5413,19 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
 				spin_unlock_irq(&ndlp->lock);
 			}
+			lpfc_drop_node(vport, ndlp);
+		} else if (ndlp->nlp_state != NLP_STE_PLOGI_ISSUE &&
+			   ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE &&
+			   ndlp->nlp_state != NLP_STE_PRLI_ISSUE) {
+			/* Drop ndlp if there is no planned or outstanding
+			 * issued PRLI.
+			 *
+			 * In cases when the ndlp is acting as both an initiator
+			 * and target function, let our issued PRLI determine
+			 * the final ndlp kref drop.
+			 */
+			lpfc_drop_node(vport, ndlp);
 		}
-
-		lpfc_drop_node(vport, ndlp);
 	}
 
 	/* Release the originating I/O reference. */
-- 
2.39.2



