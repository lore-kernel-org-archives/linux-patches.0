Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54A345CB5;
	Wed,  3 Dec 2025 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779352; cv=none; b=uEG/gFcHkOwZWGYwBpRWTVUTaa12Xf3BLsj6mMO6KE3Zs5zfJixi+fvybSBYEaU4c5nErZZT4sve9Nmqds8H2g3OGfPKADF/R1OY41s+ZkQxqRVPyxQwVQZZDNqa/fKhinpFTod1k75YRf30iDC5yOCqBOXUpdIg3rOhJDHhifM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779352; c=relaxed/simple;
	bh=W1UnaT3rHPX2XBd0lqeRtRpHO4o2nKZb2yOl6ply6Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNDXqn+Sf0rJr+ph7QhILSbCwRMB5oRkOWqEbQTuqS/yGzop2bmQwAlRyRYb/tKZmhr4f40k4gYWnuT6ghbsSGAf36SgM1XhL1MFcCzCQnWWSUyRkqZkUt4Gs+YksdgjfrFSKVkfKhSC5j0CCSiOLiii7wKNEqncgCaLfAMwGq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HZrKyK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HZrKyK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC94C116C6;
	Wed,  3 Dec 2025 16:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779352;
	bh=W1UnaT3rHPX2XBd0lqeRtRpHO4o2nKZb2yOl6ply6Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HZrKyK9Li8ividpFyUU/PVdHaZyGNyMdCJdjWuRZMO3rKsQWPKvOPUmcLfhwESNP
	 8Xq9vN/DX3wirA1rW2CqeywvPtE4NylWfIgeSuaBVrvX4LaNmoi2BNhD9mkm4NEVxh
	 jLApCd6zlaFj6Q68/cAi0HW1MR3nZDF4iqOIr0NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 232/568] scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
Date: Wed,  3 Dec 2025 16:23:54 +0100
Message-ID: <20251203152449.219971824@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6d4777a5f3d42..d09a8d583ba3c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5928,7 +5928,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
 /**
  * lpfc_reset_flush_io_context -
  * @vport: The virtual port (scsi_host) for the flush context
- * @tgt_id: If aborting by Target contect - specifies the target id
+ * @tgt_id: If aborting by Target context - specifies the target id
  * @lun_id: If aborting by Lun context - specifies the lun id
  * @context: specifies the context level to flush at.
  *
@@ -6102,8 +6102,14 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
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
 
@@ -6199,7 +6205,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	int rc, ret = SUCCESS;
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "3172 SCSI layer issued Host Reset Data:\n");
+			 "3172 SCSI layer issued Host Reset\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
-- 
2.51.0



