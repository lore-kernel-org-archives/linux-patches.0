Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606142D787;
	Fri, 24 Nov 2023 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roFk4UA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E1FC433C7;
	Fri, 24 Nov 2023 18:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850911;
	bh=Rxh4wg1RqGcSwL3HZcbEWv7Q07YyaIACA/s5cBYbvUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roFk4UA0Ed/I6N1Vc66WALN2SDvIno9KtNyMoBMPfS8HMSMxXeGGt0ftbTbR9a6Fr
	 u+ujCSXDMVKihrgMHPcYXbnY7RkIktytppHDLdTY//8n+PXtZz/wak/z5tjSNagKDT
	 3pfqMuxzwMbi32XcHjWFdMdauBdUy/0QFc2DLkgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 237/491] scsi: ufs: core: Fix racing issue between ufshcd_mcq_abort() and ISR
Date: Fri, 24 Nov 2023 17:47:53 +0000
Message-ID: <20231124172031.674775241@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

commit 27900d7119c464b43cd9eac69c85884d17bae240 upstream.

If command timeout happens and cq complete IRQ is raised at the same time,
ufshcd_mcq_abort clears lprb->cmd and a NULL pointer deref happens in the
ISR. Error log:

ufshcd_abort: Device abort task at tag 18
Unable to handle kernel NULL pointer dereference at virtual address
0000000000000108
pc : [0xffffffe27ef867ac] scsi_dma_unmap+0xc/0x44
lr : [0xffffffe27f1b898c] ufshcd_release_scsi_cmd+0x24/0x114

Fixes: f1304d442077 ("scsi: ufs: mcq: Added ufshcd_mcq_abort()")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20231106075117.8995-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufs-mcq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -632,6 +632,7 @@ int ufshcd_mcq_abort(struct scsi_cmnd *c
 	int tag = scsi_cmd_to_rq(cmd)->tag;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct ufs_hw_queue *hwq;
+	unsigned long flags;
 	int err = FAILED;
 
 	if (!ufshcd_cmd_inflight(lrbp->cmd)) {
@@ -672,8 +673,10 @@ int ufshcd_mcq_abort(struct scsi_cmnd *c
 	}
 
 	err = SUCCESS;
+	spin_lock_irqsave(&hwq->cq_lock, flags);
 	if (ufshcd_cmd_inflight(lrbp->cmd))
 		ufshcd_release_scsi_cmd(hba, lrbp);
+	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 
 out:
 	return err;


