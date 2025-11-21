Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCC034CFAF;
	Fri, 21 Nov 2025 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732885; cv=none; b=fgBVdMkEp+5nsNbepS4+6OtKBXr8Rr856T6Krm4xoQkIdc9B44d+hqKjQ8E548noIs2lpRlfjU+As/Wax7xuP36gadBueJ31NBHxNWC0Rxb54RSK26yE142coxDLhRznOwX+7aRaBQlQfU/pOenuO9gG5Y6ydAw6mBvxQUL0Qgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732885; c=relaxed/simple;
	bh=/VzE6BYgOC7TSSXwLgJDT9x4QRymc3EktbNyivIquRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPCPAeIixhCCVIUm4nUIc8lAyegHoLZxK+5u5j+VEdwtTsvdhm7o0AMS/RmURkyfP815lvM2PeMoksWqyDQHNH44FEBNKko4VbbWF9Vk7EYg/NtwEEB5jo035qV4egOHi7s3B+9A/TIhZbnppl718NMQFvJmRsrTvsl0C0hHhC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6hOsPWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6hOsPWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B575C4CEF1;
	Fri, 21 Nov 2025 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732883;
	bh=/VzE6BYgOC7TSSXwLgJDT9x4QRymc3EktbNyivIquRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6hOsPWw7+Oi1nit5x4CevjPDrCZr8Uwj1zXTmXiKkVMbh4PHFodSJBQLSDoOqg3N
	 3sOsrQisAWQqMrYSUp+z71Kd2A1kV5fPrS7mH+jqhIE3+d9nIDeMZUDw1hn4t6cQEP
	 Infy30PU8K+qQJYvha8TCxkx321RVFYeK4qoDfkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/529] scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
Date: Fri, 21 Nov 2025 14:09:02 +0100
Message-ID: <20251121130239.666622750@linuxfoundation.org>
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

[ Upstream commit f408dde2468b3957e92b25e7438f74c8e9fb9e73 ]

If lpfc_reset_flush_io_context fails to execute, then the wrong return
status code may be passed back to upper layers when issuing a target
reset TMF command.  Fix by checking the return status from
lpfc_reset_flush_io_context() first in order to properly return FAILED
or FAST_IO_FAIL.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-7-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index dcbb2432c978b..4734694f59a4c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5920,7 +5920,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
 /**
  * lpfc_reset_flush_io_context -
  * @vport: The virtual port (scsi_host) for the flush context
- * @tgt_id: If aborting by Target contect - specifies the target id
+ * @tgt_id: If aborting by Target context - specifies the target id
  * @lun_id: If aborting by Lun context - specifies the lun id
  * @context: specifies the context level to flush at.
  *
@@ -6094,8 +6094,14 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 			spin_unlock_irqrestore(&pnode->lock, flags);
 		}
-		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-					  LPFC_CTX_TGT);
+		status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						     LPFC_CTX_TGT);
+		if (status != SUCCESS) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+					 "0726 Target Reset flush status x%x\n",
+					 status);
+			return status;
+		}
 		return FAST_IO_FAIL;
 	}
 
@@ -6191,7 +6197,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	int rc, ret = SUCCESS;
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "3172 SCSI layer issued Host Reset Data:\n");
+			 "3172 SCSI layer issued Host Reset\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
-- 
2.51.0



