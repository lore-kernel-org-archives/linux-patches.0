Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DAD320CAC;
	Wed,  3 Dec 2025 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777821; cv=none; b=oFSG7Ew06YmxiKWvUQq7IZZi4Cr0aWPGmPeqhLrhgZriNRhkrJTdkIhW2HHlkpKVXsPawo2fJzfLC6CGvW2pHWTAdzM274xNcwaFzAtz5PQj/LdwKL5rWzJwXO6Ap0+T5I3gyzgTenWxiNL8OtgFBl9wapKtKO1n8evro9oMdKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777821; c=relaxed/simple;
	bh=mOBp4Uw1+DqVD0kaDXEJedM0XrlR7xhyrYsPi813VvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PubnZ84we18b1Km3FYWBpsb449kwsW5UxgjMg3SWtO1g0/zPm8vmaE6TsmTxzA6TB3Vr1apauZDAEAkOZqVPYs8QsMS5sJZJ54Dz4EjrMfTQT9gCD6L8MfhtYA2G7N4dvTc57o/UmN+9xQIdiELitIeWQ6ei4ORxh2xKGUPTwA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDsnFM/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDsnFM/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B957AC4CEF5;
	Wed,  3 Dec 2025 16:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777821;
	bh=mOBp4Uw1+DqVD0kaDXEJedM0XrlR7xhyrYsPi813VvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDsnFM/12R5kMAu7h9ZZTq1PoTSdoyKkAyuge8eVGnucCk9N2LScir/Z4/lWtX128
	 GY1ovUrnvsYU0PeMZOh1vUud5ymZWw0OxsJR3YTJ2Pkyn6L/TIHb9+oMknFFppMf2L
	 kWOPH9aWPXosKGxNZFJWQ1rFnWeg0AkikCfjqSfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/392] scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
Date: Wed,  3 Dec 2025 16:25:07 +0100
Message-ID: <20251203152419.858073316@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 520491a8b56e6..d97bc6445e9e3 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6268,7 +6268,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct scsi_cmnd *cmnd)
 /**
  * lpfc_reset_flush_io_context -
  * @vport: The virtual port (scsi_host) for the flush context
- * @tgt_id: If aborting by Target contect - specifies the target id
+ * @tgt_id: If aborting by Target context - specifies the target id
  * @lun_id: If aborting by Lun context - specifies the lun id
  * @context: specifies the context level to flush at.
  *
@@ -6434,8 +6434,14 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
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
 
@@ -6620,7 +6626,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	int rc, ret = SUCCESS;
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "3172 SCSI layer issued Host Reset Data:\n");
+			 "3172 SCSI layer issued Host Reset\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
-- 
2.51.0



