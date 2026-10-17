Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8537F3AFCF0;
	Sat, 17 Oct 2026 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256260; cv=none; b=umoCbEw6n6sskL3HjkuZhIBU9fQXUlSowzdRjfjer9OmApKl4s0IkL1F2ON9D7NC6soQpgAT+G0kcVs+gffmT52Eeojh1o6VaCbh9MFb2vhyOwpCxjN/IbmekVthcsVBv5hGFV2TEps4sWqkygOklLx3HxE3BQRmoYM+TLSq768=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256260; c=relaxed/simple;
	bh=dflJkMV7AdulhQHVV25e7xvbI2wDD1nRiAxnUAlLkhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tpw2M2/yLjj0Ok0r6jDS+HlFRiwCJSjMEDJ0UB7Hq4UzWkE8aiMbPC6PPGz5JJHNEd5x/E7l7YCDzm1BoQYYM8dc6p5iSo9wrC+/R99ex3auIS5BGY37dpX6M8axr7l6oOPwuqGsFfZyFUJg/cxTrW8awKYIB67LTauwJSmmKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpfsPPqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpfsPPqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A280D1F000C4;
	Sat, 17 Oct 2026 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256259;
	bh=wkIEIQHzQ8Xu2XTwnC2zeTAYW0vja/fA63D3w+J1ybQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpfsPPqks8Se4gDu/JBTuDfaqrZr0w8Gzh+6eGZ42RShkPvd+sh7elObGTqn3zh55
	 xIIB25l39OTxLn7rpXJa0pFZQQU+7+OInNjLS+XTbcN5Lmp84GCLEkBEu7FDlBkrzx
	 ZuHMINcYcBE/yMmuc4DBC9kSYt+5dao0UVrxAcN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0178/1674] scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
Date: Sat, 17 Oct 2026 17:40:50 +0200
Message-ID: <20261017160435.725374588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit ede596b1434b57c0b3fd5c02b326efe5c54f6e48 ]

The MBX_TIMEOUT return code is not handled in lpfc_get_sfp_info and the
routine unconditionally frees submitted mailbox commands regardless of
return status.  The issue is that for MBX_TIMEOUT cases, when firmware
returns SFP information at a later time, that same mailbox memory region
references previously freed memory in its cmpl routine.

Fix by adding checks for the MBX_TIMEOUT return code.  During mailbox
resource cleanup, check the mbox flag to make sure that the wait did not
timeout.  If the MBOX_WAKE flag is not set, then do not free the resources
because it will be freed when firmware completes the mailbox at a later
time in its cmpl routine.

Also, increase the timeout from 30 to 60 seconds to accommodate boot
scripts requiring longer timeouts.

[ Backport to 6.6.y: depend on the preceding ext_buf split from upstream
  commit 115d137aa918 ("scsi: lpfc: Define lpfc_dmabuf type for ctx_buf
  ptr") so an SLI3 late completion copies its payload separately from the
  DMA descriptor. Retain the 6.6.y ctx_ndlp assignments. ]

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240628172011.25921-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8ef571498d846..aae08ad0f332b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7309,13 +7309,13 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	}
 	mbox->vport = phba->pport;
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
-
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
 	if (rc == MBX_NOT_FINISHED) {
 		rc = 1;
 		goto error;
 	}
-
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		mp = (struct lpfc_dmabuf *)(mbox->ctx_buf);
 	else
@@ -7369,7 +7369,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 	}
 
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
+
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
 		rc = 1;
 		goto error;
@@ -7380,8 +7383,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 			     DMP_SFF_PAGE_A2_SIZE);
 
 error:
-	mbox->ctx_buf = mpsave;
-	lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	if (mbox->mbox_flag & LPFC_MBX_WAKE) {
+		mbox->ctx_buf = mpsave;
+		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	}
 
 	return rc;
 
-- 
2.53.0



