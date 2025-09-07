Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EA51CDFAC;
	Sun,  7 Sep 2025 20:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275835; cv=none; b=B7lHFdmM1F1NwX7Kbw496rUc/n+TLBV4LyAsMP61UzxhdoSCl5BAztj/xsFsdlLKzrA3u4oodNE4ftxvEOUyQXKSLv6NfBF0TYJtFZ8MW/9BxwuUlCU/sFy98jO+wjTo97HPEzht8dJ4ypqYjlCarGTJG8oZjevpFxnUJ2qPr8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275835; c=relaxed/simple;
	bh=l++jVezVhN6JKFW7fiaF043se6LkkvUrTQ/y3EgQYuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V12vz7aur+7mRouwxmwkhSX6ZGOwE7Ayy0dZlJEEr6cjXvDbPtmWiv2Hr4ba8qc0zfxKMXbngbsX2tDBd6w5lkixW6VknL9WBetKtRkfCFQvf0YmMClDZG8EehKlWh+eadyYbHm7y2E/F2Lkxyi7adED3tdUjLtRHgUFloxBTWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/L793zK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/L793zK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D859C4CEF0;
	Sun,  7 Sep 2025 20:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275835;
	bh=l++jVezVhN6JKFW7fiaF043se6LkkvUrTQ/y3EgQYuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/L793zKFvCRKi6JqSyr7mh6lgdmTdjf2Oo1OgC6s/2b76TIJUpb1x6dKt/N3SpvZ
	 cqRVpzkdP663hJxa8zt3ji4QkQDpxUUylDeTIbcEBrHl7GU4sxVFC7cvvm2mpdHaWV
	 Vqi9ryJmSqBMb8HoBalX0m7rr1xAFrDtVxj+2wHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Evans <evans1210144@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/45] scsi: lpfc: Fix buffer free/clear order in deferred receive path
Date: Sun,  7 Sep 2025 21:58:11 +0200
Message-ID: <20250907195601.693319640@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Evans <evans1210144@gmail.com>

[ Upstream commit 9dba9a45c348e8460da97c450cddf70b2056deb3 ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1172,7 +1172,7 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
 	struct lpfc_nvmet_tgtport *tgtp;
 	struct lpfc_nvmet_rcv_ctx *ctxp =
 		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
-	struct rqb_dmabuf *nvmebuf = ctxp->rqb_buffer;
+	struct rqb_dmabuf *nvmebuf;
 	struct lpfc_hba *phba = ctxp->phba;
 	unsigned long iflag;
 
@@ -1180,13 +1180,18 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
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
@@ -1194,9 +1199,6 @@ lpfc_nvmet_defer_rcv(struct nvmet_fc_tar
 
 	/* Free the nvmebuf since a new buffer already replaced it */
 	nvmebuf->hrq->rqbp->rqb_free_buffer(phba, nvmebuf);
-	spin_lock_irqsave(&ctxp->ctxlock, iflag);
-	ctxp->rqb_buffer = NULL;
-	spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 }
 
 static void


