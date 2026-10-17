Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4AA3A1E96;
	Sat, 17 Oct 2026 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256257; cv=none; b=AHRxSIeOY9q4wmg9pEvBuRaGKOIqkjcSFoAy/EdbVsvvjkwfqnTH/+ksEr/zIsT3nlbSBZTQfvUG0Ce97gxx90PLf6dpBVregFBVMGjfQd6dPBDydJ9x840C8dFbysgKQr0QILAp1ZDhBQebLEvx+FG8I+M2TM2pkjFkJDkhJTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256257; c=relaxed/simple;
	bh=ar160hs7dlTl7NsybgDL3LUwYYLObkFiZH/ajKvtjBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZekeoNy/Urzg0ukn0ly+JBoj/KRT/0VD0d7PFx4h+0PGyCvhCYL2hl/s9rlBNLHewYxlreWPVi2cbsMKhkyOaFSmjNJTJpYvdh4kUJiFRS8DF5jU2V0DbAngSL6dHUWdCPk3aN2pHTFgVhRCW+BBu83x8bSbmVw1xBN7HK4vqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05tuYoF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05tuYoF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A833A1F000C4;
	Sat, 17 Oct 2026 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256256;
	bh=g29fxlLCAXs83k/wQOByn/JMlcZHMnBiFWuM8AcfMwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05tuYoF0xiCjRTy+LNfqOM6d4PT75EtDFzJCg+N7lwziIFUAm4fV4sIWSLRvYOiep
	 ItJzE1WxSrPG09KmQkTJifMFPHsgKyZmINvVDDTHYEFFw2kmpLeI4oR008TafxkJ7C
	 dZBwO424spKe0zJKlsdCXMknWLGi64PrKmTItqNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0177/1674] scsi: lpfc: Define lpfc_dmabuf type for ctx_buf ptr
Date: Sat, 17 Oct 2026 17:40:49 +0200
Message-ID: <20261017160435.698988885@linuxfoundation.org>
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

[ Upstream commit 115d137aa918d879e3cca9605bbf59e0482aa734 ]

In LPFC_MBOXQ_t, the ctx_buf ptr shouldn't be defined as a generic void
*ptr.  It is named ctx_buf and it should only be used as an lpfc_dmabuf
*ptr.  Due to the void* declaration, there have been abuses of ctx_buf for
things not related to lpfc_dmabuf.

So, set the ptr type for *ctx_buf as lpfc_dmabuf.  Remove all type casts on
ctx_buf because it is no longer a void *ptr.  Convert the abuse of ctx_buf
for something not related to lpfc_dmabuf to use the void *context3 ptr.

A particular abuse of the ctx_buf warranted a new void *ext_buf ptr.
However, the usage of this new void *ext_buf is not generic.  It is
intended to only hold virtual addresses for extended mailbox commands.

[ Backport to 6.6.y: retain only the ext_buf member and the corresponding
  extended-mailbox producers and SLI3 copy sites. The remainder of the
  upstream context-pointer cleanup depends on earlier patches in the lpfc
  14.4.0.1 series and is unrelated to this timeout fix. Keeping the SLI3
  payload in ext_buf leaves ctx_buf pointing to its DMA descriptor through
  late completion and cleanup. ]

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-10-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c |  2 +-
 drivers/scsi/lpfc/lpfc_els.c |  4 ++--
 drivers/scsi/lpfc/lpfc_sli.c | 20 ++++++++++----------
 drivers/scsi/lpfc/lpfc_sli.h |  1 +
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 0166f86c7b71a..d5febd2119ad6 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -4747,7 +4747,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	if (mbox_req->inExtWLen || mbox_req->outExtWLen) {
 		from = pmbx;
 		ext = from + sizeof(MAILBOX_t);
-		pmboxq->ctx_buf = ext;
+		pmboxq->ext_buf = ext;
 		pmboxq->in_ext_byte_len =
 			mbox_req->inExtWLen * sizeof(uint32_t);
 		pmboxq->out_ext_byte_len =
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2e9972a587810..8ef571498d846 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7300,7 +7300,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->in_ext_byte_len = DMP_SFF_PAGE_A0_SIZE;
 		mbox->out_ext_byte_len = DMP_SFF_PAGE_A0_SIZE;
 		mbox->mbox_offset_word = 5;
-		mbox->ctx_buf = virt;
+		mbox->ext_buf = virt;
 	} else {
 		bf_set(lpfc_mbx_memory_dump_type3_length,
 		       &mbox->u.mqe.un.mem_dump_type3, DMP_SFF_PAGE_A0_SIZE);
@@ -7360,7 +7360,7 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->in_ext_byte_len = DMP_SFF_PAGE_A2_SIZE;
 		mbox->out_ext_byte_len = DMP_SFF_PAGE_A2_SIZE;
 		mbox->mbox_offset_word = 5;
-		mbox->ctx_buf = virt;
+		mbox->ext_buf = virt;
 	} else {
 		bf_set(lpfc_mbx_memory_dump_type3_length,
 		       &mbox->u.mqe.un.mem_dump_type3, DMP_SFF_PAGE_A2_SIZE);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c88e224feed8a..fd726348cb693 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9558,8 +9558,8 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 		}
 
 		/* Copy the mailbox extension data */
-		if (pmbox->in_ext_byte_len && pmbox->ctx_buf) {
-			lpfc_sli_pcimem_bcopy(pmbox->ctx_buf,
+		if (pmbox->in_ext_byte_len && pmbox->ext_buf) {
+			lpfc_sli_pcimem_bcopy(pmbox->ext_buf,
 					      (uint8_t *)phba->mbox_ext,
 					      pmbox->in_ext_byte_len);
 		}
@@ -9572,10 +9572,10 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 				= MAILBOX_HBA_EXT_OFFSET;
 
 		/* Copy the mailbox extension data */
-		if (pmbox->in_ext_byte_len && pmbox->ctx_buf)
+		if (pmbox->in_ext_byte_len && pmbox->ext_buf)
 			lpfc_memcpy_to_slim(phba->MBslimaddr +
 				MAILBOX_HBA_EXT_OFFSET,
-				pmbox->ctx_buf, pmbox->in_ext_byte_len);
+				pmbox->ext_buf, pmbox->in_ext_byte_len);
 
 		if (mbx->mbxCommand == MBX_CONFIG_PORT)
 			/* copy command data into host mbox for cmpl */
@@ -9698,9 +9698,9 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 			lpfc_sli_pcimem_bcopy(phba->mbox, mbx,
 						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
-			if (pmbox->out_ext_byte_len && pmbox->ctx_buf) {
+			if (pmbox->out_ext_byte_len && pmbox->ext_buf) {
 				lpfc_sli_pcimem_bcopy(phba->mbox_ext,
-						      pmbox->ctx_buf,
+						      pmbox->ext_buf,
 						      pmbox->out_ext_byte_len);
 			}
 		} else {
@@ -9708,9 +9708,9 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 			lpfc_memcpy_from_slim(mbx, phba->MBslimaddr,
 						MAILBOX_CMD_SIZE);
 			/* Copy the mailbox extension data */
-			if (pmbox->out_ext_byte_len && pmbox->ctx_buf) {
+			if (pmbox->out_ext_byte_len && pmbox->ext_buf) {
 				lpfc_memcpy_from_slim(
-					pmbox->ctx_buf,
+					pmbox->ext_buf,
 					phba->MBslimaddr +
 					MAILBOX_HBA_EXT_OFFSET,
 					pmbox->out_ext_byte_len);
@@ -13822,10 +13822,10 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 					lpfc_sli_pcimem_bcopy(mbox, pmbox,
 							MAILBOX_CMD_SIZE);
 					if (pmb->out_ext_byte_len &&
-						pmb->ctx_buf)
+						pmb->ext_buf)
 						lpfc_sli_pcimem_bcopy(
 						phba->mbox_ext,
-						pmb->ctx_buf,
+						pmb->ext_buf,
 						pmb->out_ext_byte_len);
 				}
 				if (pmb->mbox_flag & LPFC_MBX_IMED_UNREG) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index cd33dfec758c0..350bd4f147e83 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -184,6 +184,7 @@ typedef struct lpfcMboxq {
 	struct lpfc_vport *vport; /* virtual port pointer */
 	void *ctx_ndlp;		  /* caller ndlp information */
 	void *ctx_buf;		  /* caller buffer information */
+	void *ext_buf;		  /* extended mailbox payload */
 	void *context3;
 
 	void (*mbox_cmpl) (struct lpfc_hba *, struct lpfcMboxq *);
-- 
2.53.0



