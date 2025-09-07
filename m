Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CE21CDFAC;
	Sun,  7 Sep 2025 20:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275661; cv=none; b=hjwtoiZlIX3YXsa78LqvARxaa/xjZxLVDbM9On131gWnulgJSN81xLCYIZV5KCf+B20fAIQ2NRgo1QA4TkyakRMcRupMTYQtWjzQ5cRhkG7zmL97M53tKSQqq7SMNrMV5NMbM5I5mRCJbITLL/3RdfE1+1aoK/a50EutG2VdR44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275661; c=relaxed/simple;
	bh=oGbdt+cmnhkwT8GUVkGy684cK4CoWWrOPdgsv/LcAog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBx1b/0K0Ffp7oLMLCa/vAMyu4i+/XgwqUYXr+gWtm3vshaGD8esuifc7y5jVLmKTERPnqyPdMI4zlOFpOckXH3dzKglzG4liLDFRP9mgBcjQ9VJ5fo0d0O3Tbleyx8qu4uP9LGWpDdFXB1oLw5Xn/608MR2k9ftvNL1vWbL5fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPNK/Xwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPNK/Xwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E46C4CEF0;
	Sun,  7 Sep 2025 20:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275661;
	bh=oGbdt+cmnhkwT8GUVkGy684cK4CoWWrOPdgsv/LcAog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPNK/XwuyOrecS4FULmV2hoZSY6C3bFPdDJCyn3/TWmw8XODsXXpQ3CdJ4NSu+0xf
	 lMkxjdo+gLQyG7IyYaviZZgA87/9R4iY6plr1SPzqdtnnPj4tpsxriuK2+J3kesGG6
	 nW5rRnSmsolkqYCkr1v9vS7qirdzPpjZajivgS14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Evans <evans1210144@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 24/52] scsi: lpfc: Fix buffer free/clear order in deferred receive path
Date: Sun,  7 Sep 2025 21:57:44 +0200
Message-ID: <20250907195602.699053186@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Evans <evans1210144@gmail.com>

commit 9dba9a45c348e8460da97c450cddf70b2056deb3 upstream.

Fix a use-after-free window by correcting the buffer release sequence in
the deferred receive path. The code freed the RQ buffer first and only
then cleared the context pointer under the lock. Concurrent paths (e.g.,
ABTS and the repost path) also inspect and release the same pointer under
the lock, so the old order could lead to double-free/UAF.

Note that the repost path already uses the correct pattern: detach the
pointer under the lock, then free it after dropping the lock. The
deferred path should do the same.

Fixes: 472e146d1cf3 ("scsi: lpfc: Correct upcalling nvmet_fc transport during io done downcall")
Cc: stable@vger.kernel.org
Signed-off-by: John Evans <evans1210144@gmail.com>
Link: https://lore.kernel.org/r/20250828044008.743-1-evans1210144@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1245,7 +1245,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct lpfc_async_xchg_ctx *ctxp =
 		container_of(rsp, struct lpfc_async_xchg_ctx, hdlrctx.fcp_req);
-	struct rqb_dmabuf *nvmebuf = ctxp->rqb_buffer;
+	struct rqb_dmabuf *nvmebuf;
 	struct lpfc_hba *phba = ctxp->phba;
 	unsigned long iflag;
 
@@ -1253,13 +1253,18 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
 	lpfc_nvmeio_data(phba, "NVMET DEFERRCV: xri x%x sz %d CPU %02x\n",
 			 ctxp->oxid, ctxp->size, raw_smp_processor_id());
 
+	spin_lock_irqsave(&ctxp->ctxlock, iflag);
+	nvmebuf = ctxp->rqb_buffer;
 	if (!nvmebuf) {
+		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_IOERR,
 				"6425 Defer rcv: no buffer oxid x%x: "
 				"flg %x ste %x\n",
 				ctxp->oxid, ctxp->flag, ctxp->state);
 		return;
 	}
+	ctxp->rqb_buffer = NULL;
+	spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 
 	tgtp = phba->targetport->private;
 	if (tgtp)
@@ -1267,9 +1272,6 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
 
 	/* Free the nvmebuf since a new buffer already replaced it */
 	nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
-	spin_lock_irqsave(&ctxp->ctxlock, iflag);
-	ctxp->rqb_buffer = NULL;
-	spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 }
 
 /**


