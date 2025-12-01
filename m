Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4742727E6;
	Mon,  1 Dec 2025 11:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588644; cv=none; b=f/90Z6Pdcgk+D2Hue9/N3WbPP/ElgdhD/VFiePL0ly/sLtdEEW1WJupwycyy6uy8i8K85su8WbM9rUieeXWnNwIblnJCRt4MgUV7vn97gSOeunBcgV8Xr9Limo7MKI4f5bpIe2Xr5oysHGrrGrHPe4R/TRoBRg2vy77EirRc3aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588644; c=relaxed/simple;
	bh=1QZm/jFUSv9ngYuM7tYIIL7FilunM1+1TlsegFW9DIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlxTy2GZJvrrDBlgS8+25nmg4kjT+HHzhol3qERmnLZdsZO9MiLAHHE5zR0RY/33+IBe0utP/eDbxwO12pIrSv+5VK8SwVwmSXQ7TD2R8Xxwr0cmIeM2j634AypyF86hD/MSxHUcaltWxv4Aauj4o55SsXd8t+5pvCT0TNWthGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMGfCThI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMGfCThI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55BAC4CEF1;
	Mon,  1 Dec 2025 11:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588644;
	bh=1QZm/jFUSv9ngYuM7tYIIL7FilunM1+1TlsegFW9DIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMGfCThIp6NIAHaHQm9n7a00woz30hAxSdk+k4TCkFmrWpRSoyGHqmcICjrWTJFLf
	 0aKbOWn6TcNY6g3bC3pZyfWWOcTcjBROXoTiycnNmkEDQh2LaQ6CUFXsC8DL6qsFz3
	 EPMaie1j9I4eZWQaXIN3fjPD39cTkIXBNbb0hP4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/187] scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
Date: Mon,  1 Dec 2025 12:23:15 +0100
Message-ID: <20251201112244.374531437@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1d58895b3943b..9201c548aab4b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5153,7 +5153,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 /**
  * lpfc_reset_flush_io_context -
  * @vport: The virtual port (scsi_host) for the flush context
- * @tgt_id: If aborting by Target contect - specifies the target id
+ * @tgt_id: If aborting by Target context - specifies the target id
  * @lun_id: If aborting by Lun context - specifies the lun id
  * @context: specifies the context level to flush at.
  *
@@ -5312,8 +5312,14 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 			spin_unlock_irq(shost->host_lock);
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
 
@@ -5457,7 +5463,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	int rc, ret = SUCCESS;
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "3172 SCSI layer issued Host Reset Data:\n");
+			 "3172 SCSI layer issued Host Reset\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
-- 
2.51.0



