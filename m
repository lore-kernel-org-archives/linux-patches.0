Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270B31A2389;
	Sun,  7 Sep 2025 20:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276266; cv=none; b=lRRaH1N16gODjwcqA4SpJ8a6CK2zfvh+mUf+BaPBKLtIIsK+COF8cvfMW1flqanE7nNDyCwuVyGl4CI2WjjSkuCQIXAn2ut9yd9Jvbky9YfZK9+k0NmP82BSRT0fh9e9eqsYvzLZ1xaY3V4P6SJlJP8s88OGAZLRMjAXWsnzi6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276266; c=relaxed/simple;
	bh=kVMNap5HIHCrBg9AISUj4sFqjr7A0FcYyhPsntMlD/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/zCZXgCq/dF/JBy+K2m/jI0S5J9/WUSmEnczmgML3VPRhPSHc75IcKso9352zLsitNRZ8vxxPTidG0JnGdoD4Jq6Jg6P6j3tSg7UWisuAlCndyyA4a23IoGpc80OuhkFU9UGRBhj0765bTw2EzE6jw08Y69JHhx82yIeUHUrTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPXK7Z8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPXK7Z8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A965C4CEF0;
	Sun,  7 Sep 2025 20:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276266;
	bh=kVMNap5HIHCrBg9AISUj4sFqjr7A0FcYyhPsntMlD/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPXK7Z8vgcmOLYcuQzGnMxlSYGtH29q7zk905bSkh9ED3QFUQ+fq4NIEYRGmyesqG
	 cDBtWYVUTQKFZL8joSxJyMPksCSe5FJcjbrNnhH69SoJjk2yUUGto8UPDzXJ+PG78T
	 EbwtLrnFZJTHvKeYJRv2uHMDAcr194gT0/MGT/hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Evans <evans1210144@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 049/104] scsi: lpfc: Fix buffer free/clear order in deferred receive path
Date: Sun,  7 Sep 2025 21:58:06 +0200
Message-ID: <20250907195608.964607529@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1243,7 +1243,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct lpfc_async_xchg_ctx *ctxp =
 		container_of(rsp, struct lpfc_async_xchg_ctx, hdlrctx.fcp_req);
-	struct rqb_dmabuf *nvmebuf = ctxp->rqb_buffer;
+	struct rqb_dmabuf *nvmebuf;
 	struct lpfc_hba *phba = ctxp->phba;
 	unsigned long iflag;
 
@@ -1251,13 +1251,18 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
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
@@ -1265,9 +1270,6 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
 
 	/* Free the nvmebuf since a new buffer already replaced it */
 	nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
-	spin_lock_irqsave(&ctxp->ctxlock, iflag);
-	ctxp->rqb_buffer = NULL;
-	spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 }
 
 /**


