Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD091A6192;
	Tue, 30 Jul 2024 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359172; cv=none; b=if8SaCkEfYt1LsnkMKLQPl0f9P5Byc8ckXaumHS0qJpd0nq6kfampIqgvYHJHAZAb3hFCtSdQ3tI8EYqquyp2RtmPS3xHx9a5GoqzXXcCT3f/r7uWxTw8riJ8pXiXkznoHWoQwLwQqIgBvloMI5RpTr+mURTTcNFogQIrXA17zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359172; c=relaxed/simple;
	bh=5bhP6myE7wAJbfLDtQfuSRUWkICRFRhXztCD0Q3OOSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPyMEr2niqLcKI508pGx8z4u1uAQHcY8yBqc5e+F9j8IBJ9ItfDgbeu7tkUU6vS8SXe8/0KTTXmYsod3neRnxVoSVrDZQp15/KH83SzmK6DsLYG/jHfT1V8CIV26ObkdjnGPy+vm1hu37Mr3zzjM2H0Ld+lnHHxUM+knsCNDUzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k72SQhMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k72SQhMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99087C4AF12;
	Tue, 30 Jul 2024 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359172;
	bh=5bhP6myE7wAJbfLDtQfuSRUWkICRFRhXztCD0Q3OOSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k72SQhMuE34t5MGM3hcuJFaHd66nwgP6VTHncGPNCCY8pYzHol3oN7VXuEbLwMEiM
	 /8bXcsnesFEo51AYl47L8L8G+Wysscjvey9d1Aqa1hk+Lx3Y3GVR8Cc8u4fXQm4xO3
	 bTs2laR2g7YEGCHcj2YtUgaJwu0Vbh8KC7L0UU9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 446/809] scsi: lpfc: Revise lpfc_prep_embed_io routine with proper endian macro usages
Date: Tue, 30 Jul 2024 17:45:22 +0200
Message-ID: <20240730151742.321418670@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

[ Upstream commit 8bc7c617642db6d8d20ee671fb6c4513017e7a7e ]

On big endian architectures, it is possible to run into a memory out of
bounds pointer dereference when FCP targets are zoned.

In lpfc_prep_embed_io, the memcpy(ptr, fcp_cmnd, sgl->sge_len) is
referencing a little endian formatted sgl->sge_len value.  So, the memcpy
can cause big endian systems to crash.

Redefine the *sgl ptr as a struct sli4_sge_le to make it clear that we are
referring to a little endian formatted data structure.  And, update the
routine with proper le32_to_cpu macro usages.

Fixes: af20bb73ac25 ("scsi: lpfc: Add support for 32 byte CDBs")
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240628172011.25921-8-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f475e7ece41a4..3e55d5edd60ab 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10579,10 +10579,11 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 {
 	struct lpfc_iocbq *piocb = &lpfc_cmd->cur_iocbq;
 	union lpfc_wqe128 *wqe = &lpfc_cmd->cur_iocbq.wqe;
-	struct sli4_sge *sgl;
+	struct sli4_sge_le *sgl;
+	u32 type_size;
 
 	/* 128 byte wqe support here */
-	sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
+	sgl = (struct sli4_sge_le *)lpfc_cmd->dma_sgl;
 
 	if (phba->fcp_embed_io) {
 		struct fcp_cmnd *fcp_cmnd;
@@ -10591,9 +10592,9 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 		fcp_cmnd = lpfc_cmd->fcp_cmnd;
 
 		/* Word 0-2 - FCP_CMND */
-		wqe->generic.bde.tus.f.bdeFlags =
-			BUFF_TYPE_BDE_IMMED;
-		wqe->generic.bde.tus.f.bdeSize = sgl->sge_len;
+		type_size = le32_to_cpu(sgl->sge_len);
+		type_size |= ULP_BDE64_TYPE_BDE_IMMED;
+		wqe->generic.bde.tus.w = type_size;
 		wqe->generic.bde.addrHigh = 0;
 		wqe->generic.bde.addrLow =  72;  /* Word 18 */
 
@@ -10602,13 +10603,13 @@ lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 		/* Word 18-29  FCP CMND Payload */
 		ptr = &wqe->words[18];
-		memcpy(ptr, fcp_cmnd, sgl->sge_len);
+		lpfc_sli_pcimem_bcopy(fcp_cmnd, ptr, le32_to_cpu(sgl->sge_len));
 	} else {
 		/* Word 0-2 - Inline BDE */
 		wqe->generic.bde.tus.f.bdeFlags =  BUFF_TYPE_BDE_64;
-		wqe->generic.bde.tus.f.bdeSize = sgl->sge_len;
-		wqe->generic.bde.addrHigh = sgl->addr_hi;
-		wqe->generic.bde.addrLow =  sgl->addr_lo;
+		wqe->generic.bde.tus.f.bdeSize = le32_to_cpu(sgl->sge_len);
+		wqe->generic.bde.addrHigh = le32_to_cpu(sgl->addr_hi);
+		wqe->generic.bde.addrLow = le32_to_cpu(sgl->addr_lo);
 
 		/* Word 10 */
 		bf_set(wqe_dbde, &wqe->generic.wqe_com, 1);
-- 
2.43.0



