Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B6623C4F2;
	Tue, 11 Nov 2025 01:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824809; cv=none; b=T27O62/M37AMjYxZARec3ZdCWCWGZN6uJj70wDSSRgBSDnRMs2fioROxJUhXy+IYdEK8EAXZFBOTGNNosKVuSxWroND/HHBH7xwLW9xGfJr+ARQaZSZvlzMTK9CZPGK8oNXtzeh90hJHAYbrQddoRyk2Eq0NUF7/QAoJ+KfavH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824809; c=relaxed/simple;
	bh=EON6xl/5Z8fA99OAN1KXtuMGH7cCo+Qbu5qPGcKaUzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u23DrAigeRmcCmT9zOEtqdxsG1f+KVieF4riH0cuO16XlHcV5TO3XDi76iRqL5E/1cz/cDu4M0SyedYEWN7kGsL/6i1FmdAVGq5KckPf+Jl3Wj2GMXZlJaL88wvs2dKdUHxi3Cd6WqGYn2/AwroGVUWeQfL1YLHb5BYlsVCPL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTqxntX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTqxntX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F78C116B1;
	Tue, 11 Nov 2025 01:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824809;
	bh=EON6xl/5Z8fA99OAN1KXtuMGH7cCo+Qbu5qPGcKaUzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTqxntX3zTmNhpuKkZ7LeN+TLZqeWjbTpLtm5lk/DPZb7KPAAUVlYxzBkSVU6xgGB
	 pHUkqEvreNafppUZD5ruf2ZHiiXKyAY5rX72kw8KnyaivTtaSMM/h4dz2jar8yJ/wT
	 MDtIKEEwWmuKOx4iY2hbSwKHbBsIbrZSqFN2xB8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 574/849] scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
Date: Tue, 11 Nov 2025 09:42:24 +0900
Message-ID: <20251111004550.298202648@linuxfoundation.org>
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
index 508ceeecf2d95..6d9d8c196936a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5935,7 +5935,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
 /**
  * lpfc_reset_flush_io_context -
  * @vport: The virtual port (scsi_host) for the flush context
- * @tgt_id: If aborting by Target contect - specifies the target id
+ * @tgt_id: If aborting by Target context - specifies the target id
  * @lun_id: If aborting by Lun context - specifies the lun id
  * @context: specifies the context level to flush at.
  *
@@ -6109,8 +6109,14 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
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
 
@@ -6202,7 +6208,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	int rc, ret = SUCCESS;
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "3172 SCSI layer issued Host Reset Data:\n");
+			 "3172 SCSI layer issued Host Reset\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
-- 
2.51.0



