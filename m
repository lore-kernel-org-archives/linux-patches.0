Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8421AA790;
	Mon, 14 Oct 2024 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916051; cv=none; b=YUsBn59kVFklk+uluBm0ZwVjKozUMYzb8znXI5B6X81m/J+TOwsMF8F/etc9UZF5CcGUUvcZn6NwlUE+eqfmafLTo9yWRhCvcmKk5D/VcYSIEEodG5vS1uHQV9yxcq0XtqBNSQWbc4lx2TKxVTXM5n2z6nk5FXQkc+vRq+IHIy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916051; c=relaxed/simple;
	bh=QbMVemG6rRXea8B/6EQAXJpMhaF3gN0DtvAYl1KQrm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hp273p1DMWirO1IwoZG10Eyc2xTfB/ZhRPmpvMLVOkyFCXIl3EwHMFPTzJyMuF+kKQHKN8s5sTKCmzVUTjL2v6x2pcbb55gnKVYfQo3TBwC5ESb8NEz0q0rIFB0DpKUT9OyoFdPDqt6TYaPqgC6GjOtp3pDB0iFkTiqrqJ+WIYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhMcykb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhMcykb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7D9C4CEC3;
	Mon, 14 Oct 2024 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916050;
	bh=QbMVemG6rRXea8B/6EQAXJpMhaF3gN0DtvAYl1KQrm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhMcykb6JUo8IFEtOsHPD6F/Kr5Syvg4P2KeUAbfmwQ062rO6kcWe739wrpF4QIcf
	 z2O9dBfsJenX5tsTO6FTGRsN9Qi9Do0Kgwy0f+qj0cOK004INW07NxJtV9lvIMqcZn
	 5Qq1unsq2mBMK6VHGCx4rh48NVqKdOTXSUSxqsss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 072/214] scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()
Date: Mon, 14 Oct 2024 16:18:55 +0200
Message-ID: <20241014141047.799088230@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 93bcc5f3984bf4f51da1529700aec351872dbfff ]

During HBA stress testing, a spam of received PLOGIs exposes a resource
recovery bug causing leakage of lpfc_sqlq entries from the global
phba->sli4_hba.lpfc_els_sgl_list.

The issue is in lpfc_els_flush_cmd(), where the driver attempts to recover
outstanding ELS sgls when walking the txcmplq.  Only CMD_ELS_REQUEST64_CRs
and CMD_GEN_REQUEST64_CRs are added to the abort and cancel lists.  A check
for CMD_XMIT_ELS_RSP64_WQE is missing in order to recover LS_ACC usages of
the phba->sli4_hba.lpfc_els_sgl_list too.

Fix by adding CMD_XMIT_ELS_RSP64_WQE as part of the txcmplq walk when
adding WQEs to the abort and cancel list in lpfc_els_flush_cmd().  Also,
update naming convention from CRs to WQEs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240912232447.45607-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e27f5d955edb4..4f324ca5368ef 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9656,11 +9656,12 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED && !mbx_tmo_err)
 			continue;
 
-		/* On the ELS ring we can have ELS_REQUESTs or
-		 * GEN_REQUESTs waiting for a response.
+		/* On the ELS ring we can have ELS_REQUESTs, ELS_RSPs,
+		 * or GEN_REQUESTs waiting for a CQE response.
 		 */
 		ulp_command = get_job_cmnd(phba, piocb);
-		if (ulp_command == CMD_ELS_REQUEST64_CR) {
+		if (ulp_command == CMD_ELS_REQUEST64_WQE ||
+		    ulp_command == CMD_XMIT_ELS_RSP64_WQE) {
 			list_add_tail(&piocb->dlist, &abort_list);
 
 			/* If the link is down when flushing ELS commands
-- 
2.43.0



