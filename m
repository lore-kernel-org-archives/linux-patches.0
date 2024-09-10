Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8CB184101;
	Tue, 10 Sep 2024 09:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961870; cv=none; b=g8jEW1FohXBlk+UycjlKmogwseeyRh4RadrBjaa0279QZklCS6nBQX1VrUTGSyp5saUOo6rbnzBY1RSApZBh0GskAmMMqKHuk+By2Azkr2870Tor3u5BgCB3dOOMveVWqySab2c4LpeDa1gLnjZGRicIc9QYaJsESUTd934BiY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961870; c=relaxed/simple;
	bh=It0Qs3jatv5j/ab/GWOKjA3NRR0xEIRhjLhQ+0d5GDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baP3k3EQEn/xkxBRkWP2V8vn2JvYd4Rgsdh8hwsvHFGXxFzczeZVPt48RmGKkA9/DY3aL5xTB3OtX++4Fg0ANqOtMcHMcE0P/PArrOWJNnAIPHQlGzN0/MJh/TPSWYjTCW1KtXptR9Z5LjquZbEBQJ9T5CGwAkOYsV1PphbFFs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXO1eo4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXO1eo4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AD2C4CEC3;
	Tue, 10 Sep 2024 09:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961870;
	bh=It0Qs3jatv5j/ab/GWOKjA3NRR0xEIRhjLhQ+0d5GDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXO1eo4mMAKKr2FVjTgZVscm4ZCwQtqMHEWeb0l9Vis4M93kFml7rOgghFf+uD5Hs
	 wjd0mihaO+jrjPLzdO//QB4eWi6kurizkvUmzALkZd8z2Cj8eFk5uvIZVZ+ROmGC47
	 dtB4FvQJlzSlruI0M2ERmZGryuo9vf+Gh6c+d8ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 216/375] scsi: lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
Date: Tue, 10 Sep 2024 11:30:13 +0200
Message-ID: <20240910092629.790694330@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240628172011.25921-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c32bc773ab29..445cb6c2e80f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7302,13 +7302,13 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 	}
 	mbox->vport = phba->pport;
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
 		mp = mbox->ctx_buf;
 	else
@@ -7361,7 +7361,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 	}
 
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
+
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
 		rc = 1;
 		goto error;
@@ -7372,8 +7375,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
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
2.43.0



