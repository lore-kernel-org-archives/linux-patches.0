Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6855927BF8D;
	Tue, 27 May 2025 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368138; cv=none; b=a9qKCY3xK3myk+S8pdh9jESIgQCw7NrySrNIrVF5HrraV+S8BHpvi66j+mTiwAVby9KA97TDoDbyywa56jDQt1WUItTu+mYWeE0d9Y94bNRhECs37Xa3FNu9m1TkN1t7A52TgNywnGUO5O2LZIsdAx7DeWvGShc3dRwkb87zdvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368138; c=relaxed/simple;
	bh=2l+2vZDbDSb2iXpzeWkMN1+8o2h+dpTOzvwfRlj4qrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8RAEXuKgBcdZqbyhZguzfISaxzAv0JzxHzCEn7sj1gLkxmWgRh3LkEt/pXPQnSt/kB5WuUslhJAFy1SnPK5BNPXlqGZlbh9JqgiAkilTQ+WL2+0gp46wDlBdWyjQq+JUtdBtfrTGpOR6Idd69qpkogNPm8cgpqbmqbQ+O0CIw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qH47neHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qH47neHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D4AC4CEE9;
	Tue, 27 May 2025 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368138;
	bh=2l+2vZDbDSb2iXpzeWkMN1+8o2h+dpTOzvwfRlj4qrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qH47neHyv0iECVm5mUAbJyvfhaw79mINkaaqMBnYUCRs8T2dWOXHgxMoRYZD8/3wI
	 Psj8Z/fuDYJpPDEvzyTjDm6pqufTTnQ98ec7YNJMGL+dZSjUGhQrqPwVmh4rBCo3bm
	 RTxrVgNT7BXOIhN6JrZkUf60eOCc0Q1x4qDSd8pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 580/783] scsi: lpfc: Reduce log message generation during ELS ring clean up
Date: Tue, 27 May 2025 18:26:17 +0200
Message-ID: <20250527162536.761197600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 8eccc58d71eafbd2635077916b68fda15791d270 ]

A clean up log message is output from lpfc_els_flush_cmd() for each
outstanding ELS I/O and repeated for every NPIV instance.  The log message
should only be generated for active I/Os matching the NPIV vport.  Thus,
move the vport check to before logging the message.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1d7db49a8fe45..318dc83e9a2ac 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9569,18 +9569,16 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	mbx_tmo_err = test_bit(MBX_TMO_ERR, &phba->bit_flags);
 	/* First we need to issue aborts to outstanding cmds on txcmpl */
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
+		if (piocb->vport != vport)
+			continue;
+
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 				 "2243 iotag = 0x%x cmd_flag = 0x%x "
-				 "ulp_command = 0x%x this_vport %x "
-				 "sli_flag = 0x%x\n",
+				 "ulp_command = 0x%x sli_flag = 0x%x\n",
 				 piocb->iotag, piocb->cmd_flag,
 				 get_job_cmnd(phba, piocb),
-				 (piocb->vport == vport),
 				 phba->sli.sli_flag);
 
-		if (piocb->vport != vport)
-			continue;
-
 		if ((phba->sli.sli_flag & LPFC_SLI_ACTIVE) && !mbx_tmo_err) {
 			if (piocb->cmd_flag & LPFC_IO_LIBDFC)
 				continue;
-- 
2.39.5



